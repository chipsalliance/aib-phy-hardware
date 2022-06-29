// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.
// Copyright (C) 2021 Intel Corporation. 

module aib_adapt_tx_fifo
  #(
    parameter ODWIDTH = 'd80,          // FIFO output data width
    parameter IDWIDTH = 'd320,         // FIFO input data width
    parameter DEPTH   = 'd5,           // FIFO Depth
    parameter DEPTH4  = (DEPTH * 4),   // FIFO Depth x 4
    parameter AWIDTH  = $clog2(DEPTH4) // FIFO address width 
    )
    (
    // Inputs
    input                  wr_rst_n,    // Write Domain Active low Reset
    input                  wr_clk,      // Write Domain Clock
    input                  m_gen2_mode, // Generation 2 mode
    input   [IDWIDTH-1:0]  data_in,     // Write Data In
    input                  rd_rst_n,    // Read Domain Active low Reset
    input                  rd_clk,      // Read Domain Clock
    input                  scan_en,     // Scan enable
    input                  r_wm_en,     // mark enable
    input   [4:0]          r_mkbit,     // Configurable marker bit
    input   [1:0]          r_fifo_mode, // FIFO Mode: 4:1 2:1 1:1 Reg mode
    input   [3:0]    r_phcomp_rd_delay, // Programmable phase conpensation
    // Outputs
    output  [ODWIDTH-1:0]  fifo_dout    // Read Data Out 
     );
   
//------------------------------------------------------------------------------
// Local Parameters 
//------------------------------------------------------------------------------
localparam   FIFO_1X   = 2'b00;          //Full rate
localparam   FIFO_2X   = 2'b01;          //Half rate
localparam   FIFO_4X   = 2'b10;          //Quarter Rate
localparam   REG_MOD   = 2'b11;          //REG mode

// Valid word mark configuration in r_mkbit register
localparam [4:0] MARK_BIT_79 = 5'b10000;// Mark is in bit 79
localparam [4:0] MARK_BIT_78 = 5'b01000;// Mark is in bit 78
localparam [4:0] MARK_BIT_77 = 5'b00100;// Mark is in bit 77
localparam [4:0] MARK_BIT_76 = 5'b00010;// Mark is in bit 76
localparam [4:0] MARK_BIT_39 = 5'b00001;// Mark is in bit 39

//------------------------------------------------------------------------------
// Define wires and regs 
//------------------------------------------------------------------------------
wire   register_mode;      // Register mode indication
wire   phcomp_mode;        // FIFO mode where phase compensation is used
wire   phcomp_rden_int;    // Internal read enable to get data from FIFO
wire   phcomp_wren;        // Write enable synchronized at write clock domain
wire   phcomp_wren_sync2;  // Write enable synchronized at read clock domain
wire               wr_en_int; // FIFO write enable
wire               rd_en_int; // FIFO read enable
wire   phcomp_wren_sync;   // Write enable after compensation of phase         
wire [DEPTH-1:0] tff_clk_39_0;    // Clocks for word 39-0
wire [DEPTH-1:0] tff_clk_79_40;   // Clocks for word 79-40
wire [DEPTH-1:0] tff_clk_119_80;  // Clocks for word 119-80
wire [DEPTH-1:0] tff_clk_159_120; // Clocks for word 159-120
wire [DEPTH-1:0] tff_clk_199_160;
wire [DEPTH-1:0] tff_clk_239_200;
wire [DEPTH-1:0] tff_clk_279_240;
wire [DEPTH-1:0] tff_clk_319_280;
wire [DEPTH-1:0][IDWIDTH-1:0] fifo_data_ff; // Data of FIFO array
wire [DEPTH4-1:0]    fifo_rd_en; // TX FIFO read enable
wire             phcomp_rden;

reg    phcomp_wren_d0;     // First flop to to sample write enable after reset 
reg    phcomp_wren_d1;     // Second flop to to sample write enable after reset
reg    phcomp_wren_d2;     // Write enable synchronized  at write clock domain 
reg    phcomp_wren_sync3;  // Additional delay after read clock domain sync.   
reg    phcomp_wren_sync4;  // Additional delay after read clock domain sync.   
reg    phcomp_wren_sync5;  // Additional delay after read clock domain sync.   
reg    phcomp_wren_sync6;  // Additional delay after read clock domain sync.   
reg    phcomp_wren_sync7;  // Additional delay after read clock domain sync.   
reg    phcomp_wren_sync8;  // Additional delay after read clock domain sync.   
reg    phcomp_wren_sync9;  // Additional delay after read clock domain sync.   
reg    phcomp_wren_sync10;  // Additional delay after read clock domain sync.
reg    phcomp_wren_sync11;  // Additional delay after read clock domain sync.
reg  [IDWIDTH-1:0] wr_data;      // Write data to be written into FIFO
reg  [AWIDTH-1 :0]txf_wr_pnt_ff; // TX FIFO write pointer
reg  [DEPTH4-1:0]   txf_rd_pnt_ff; // TX FIFO read pointer
reg  [AWIDTH-1 :0] txf_wr_pnt_in;  // Next value of TX FIFO write pointer
reg  [319:0]       fifo_wr_data;
reg                co_nc;

// FIFO mode decode to detect register mode
assign register_mode = (r_fifo_mode == REG_MOD);

// FIFO mode where phase compensation is enabled
assign phcomp_mode =  ~ register_mode; 

// FIFO write data logic to insert word mark bits
always @(*) 
  begin: fifo_write_data_logic
    if (r_wm_en) // Word Mark insertion is enabled
      begin
        if (r_fifo_mode == FIFO_4X) // FIFO 4x mode
          begin
            case(r_mkbit[4:0])
              MARK_BIT_79: // Mark is in bit 79
                begin
                  wr_data = { {1'b1, data_in[318:240]}, 
                              {1'b0, data_in[238:160]}, 
                              {1'b0, data_in[158:80]}, 
                              {1'b0, data_in[78:0]}    }; //bit 79
                end
              MARK_BIT_78: // Mark is in bit 78
                begin
                  wr_data = { {data_in[319], 1'b1, data_in[317:240]}, 
                              {data_in[239], 1'b0, data_in[237:160]}, 
                              {data_in[159], 1'b0, data_in[157:80]}, 
                              {data_in[79],  1'b0, data_in[77:0]}     }; //bit 78
                end
              MARK_BIT_77: // Mark is in bit 77
                begin
                  wr_data = { {data_in[319:318], 1'b1, data_in[316:240]}, 
                              {data_in[239:238], 1'b0, data_in[236:160]}, 
                              {data_in[159:158], 1'b0, data_in[156:80]}, 
                              {data_in[79:78],   1'b0, data_in[76:0]}     };  //bit 77
                end
              MARK_BIT_76: // Mark is in bit 76
                begin
                  wr_data = { {data_in[319:317], 1'b1, data_in[315:240]}, 
                              {data_in[239:237], 1'b0, data_in[235:160]}, 
                              {data_in[159:157], 1'b0, data_in[155:80]}, 
                              {data_in[79:77],   1'b0, data_in[75:0]}     };  //bit 76
                end
              MARK_BIT_39: // Mark is in bit 39
                begin
                  wr_data = { {data_in[319:280], 1'b1, data_in[278:240]}, 
                              {data_in[239:200], 1'b0, data_in[198:160]}, 
                              {data_in[159:120], 1'b0, data_in[118:80]}, 
                              {data_in[79:40],   1'b0, data_in[38:0]}     };  //bit 39
                end
              default: // No mark bit enabled - bypass
                begin
                  wr_data = data_in; // No mark bit enabled
                end
            endcase
          end
        else if (r_fifo_mode == FIFO_2X) // FIFO 2x mode
          begin
            case(r_mkbit[4:0])
              MARK_BIT_79: // Mark is in bit 79
                begin
                  wr_data = {  160'h0,
                              {1'b1, data_in[158:80]},
                              {1'b0, data_in[78:0]}    };
                end
              MARK_BIT_78: // Mark is in bit 78
                begin
                  wr_data = {  160'h0,
                              {data_in[159], 1'b1, data_in[157:80]},
                              {data_in[79],  1'b0, data_in[77:0]}    };
                end
              MARK_BIT_77: // Mark is in bit 77
                begin
                  wr_data = {  160'h0,
                              {data_in[159:158], 1'b1, data_in[156:80]},
                              {data_in[79:78],   1'b0, data_in[76:0]}    };
                end
              MARK_BIT_76: // Mark is in bit 76
                begin
                  wr_data = {  160'h0,
                              {data_in[159:157], 1'b1, data_in[155:80]},
                              {data_in[79:77],   1'b0, data_in[75:0]}    };
                end
              MARK_BIT_39: // Mark is in bit 39
                begin
                  if(m_gen2_mode) // GEN2 mode
                    begin
                      wr_data = {  160'h0,
                                  {data_in[159:120], 1'b1, data_in[118:80]},
                                  {data_in[79:40], 1'b0, data_in[38:0]}     };
                    end // GEN2 mode
                  else // GEN1 mode
                    begin
                      wr_data = {  160'h0,
                                  {40'h0, 1'b1, data_in[78:40]},
                                  {40'h0, 1'b0, data_in[38:0]}  };
                    end // GEN1 mode
                end
              default: // No mark bit enabled - bypass
                begin
                  wr_data = data_in; // No mark bit enabled
                end
            endcase
          end
        else // Data bypass
          wr_data = data_in;
      end // Word Mark insertion is enabled
    else
      begin // Mark is disabled
        if ((r_fifo_mode == FIFO_2X) & ~m_gen2_mode) // FIFO 2x and Gen1
           wr_data ={ 160'h0,
                    {40'h0, data_in[79:40]},
                    {40'h0, data_in[39:0]}};
        else // Data bypass
           wr_data = data_in;
      end // Mark is disabled
end // block: fifo_write_data_logic


//********************************************************************
// Read Write logic 
//********************************************************************
  
// Write enable
assign wr_en_int = phcomp_mode &  phcomp_wren; // Phase Comp Indiviual mode

// Read enable
assign rd_en_int = phcomp_mode &  phcomp_rden_int; // Phase Comp Indiviual mode

// Phase Comp FIFO mode Write/Read enable logic generation
// Write Enable
always @(negedge wr_rst_n or posedge wr_clk) 
  begin: wren_phase_register
   if (wr_rst_n == 1'b0)
     begin
       phcomp_wren_d0 <= 1'b0;
       phcomp_wren_d1 <= 1'b0;
       phcomp_wren_d2 <= 1'b0;
     end
   else
     begin
       phcomp_wren_d0 <= 1'b1; // Indv: 1, Bonding: goes high and stays high
       phcomp_wren_d1 <= phcomp_wren_d0;
       phcomp_wren_d2 <= phcomp_wren_d1;
     end
end // block: wren_phase_register

assign phcomp_wren = phcomp_wren_d2;

// phcomp_wren Synchronizer
aib_bit_sync bitsync2_phcomp_wren
  (
   .clk      (rd_clk),           // Clock of destination domain
   .rst_n    (rd_rst_n),         // Reset of destination domain
   .data_in  (phcomp_wren),      // Input to be synchronized
   .data_out (phcomp_wren_sync2) // Synchronized output
   );

// Write enable delay registers
always @(negedge rd_rst_n or posedge rd_clk)
  begin: phcomp_wren_sync_register
    if (rd_rst_n == 1'b0)
      begin
        phcomp_wren_sync3  <= 1'b0;
        phcomp_wren_sync4  <= 1'b0;
        phcomp_wren_sync5  <= 1'b0;
        phcomp_wren_sync6  <= 1'b0;
        phcomp_wren_sync7  <= 1'b0;
        phcomp_wren_sync8  <= 1'b0;
        phcomp_wren_sync9  <= 1'b0;
        phcomp_wren_sync10 <= 1'b0;
        phcomp_wren_sync11 <= 1'b0;
      end // reset
    else
      begin
        phcomp_wren_sync3  <= phcomp_wren_sync2;
        phcomp_wren_sync4  <= phcomp_wren_sync3;
        phcomp_wren_sync5  <= phcomp_wren_sync4;
        phcomp_wren_sync6  <= phcomp_wren_sync5;
        phcomp_wren_sync7  <= phcomp_wren_sync6;
        phcomp_wren_sync8  <= phcomp_wren_sync7;
        phcomp_wren_sync9  <= phcomp_wren_sync8;
        phcomp_wren_sync10 <= phcomp_wren_sync9;
        phcomp_wren_sync11 <= phcomp_wren_sync10;
      end
  end // block: phcomp_wren_sync_register  

// Read Enable
assign phcomp_wren_sync = 
           (r_phcomp_rd_delay[3:0] == 4'b1011) ? phcomp_wren_sync11 :
           (r_phcomp_rd_delay[3:0] == 4'b1010) ? phcomp_wren_sync10 :
           (r_phcomp_rd_delay[3:0] == 4'b1001) ? phcomp_wren_sync9  :
           (r_phcomp_rd_delay[3:0] == 4'b1000) ? phcomp_wren_sync8  :
           (r_phcomp_rd_delay[3:0] == 4'b0111) ? phcomp_wren_sync7  :
           (r_phcomp_rd_delay[3:0] == 4'b0110) ? phcomp_wren_sync6  :
           (r_phcomp_rd_delay[3:0] == 4'b0101) ? phcomp_wren_sync5  :
           (r_phcomp_rd_delay[3:0] == 4'b0100) ? phcomp_wren_sync4  :
           (r_phcomp_rd_delay[3:0] == 4'b0011) ? phcomp_wren_sync3  :
            phcomp_wren_sync2;

// Configured delay selected
assign phcomp_rden = phcomp_wren_sync;

// Read enable
assign phcomp_rden_int = phcomp_rden;

always @(*)
  begin
    case(r_fifo_mode[1:0])
      FIFO_2X:
        begin
          if( txf_wr_pnt_ff[AWIDTH-1:0] == (DEPTH4-2) )
            begin
              {co_nc,txf_wr_pnt_in[AWIDTH-1:0]} = {(AWIDTH+1){1'b0}};
            end
          else
            begin
              {co_nc,txf_wr_pnt_in[AWIDTH-1:0]} = txf_wr_pnt_ff[AWIDTH-1:0] +
                                                  {{(AWIDTH-2){1'b0}}, 2'b10};
            end
        end
      FIFO_4X:
        begin
          if( txf_wr_pnt_ff[AWIDTH-1:0] == (DEPTH4-4) )
            begin
              {co_nc,txf_wr_pnt_in[AWIDTH-1:0]} = {(AWIDTH+1){1'b0}};
            end
          else
            begin
              {co_nc,txf_wr_pnt_in[AWIDTH-1:0]} = txf_wr_pnt_ff[AWIDTH-1:0] +
                                                  {{(AWIDTH-3){1'b0}}, 3'b100};
            end
        end
      default:
        begin
          if(txf_wr_pnt_ff[AWIDTH-1:0] == (DEPTH4-1))
            begin
              {co_nc,txf_wr_pnt_in[AWIDTH-1:0]} = {(AWIDTH+1){1'b0}};
            end
          else
            begin
              {co_nc,txf_wr_pnt_in[AWIDTH-1:0]} = txf_wr_pnt_ff[AWIDTH-1:0] +
                                                  {{(AWIDTH-1){1'b0}}, 1'b1};
            end
        end
    endcase
  end

always @(posedge wr_clk or negedge wr_rst_n)
  begin
    if(!wr_rst_n)
      txf_wr_pnt_ff[AWIDTH-1:0] <= {AWIDTH{1'b0}};
    else if(wr_en_int)
      txf_wr_pnt_ff[AWIDTH-1:0] <= txf_wr_pnt_in[AWIDTH-1:0];
  end

aib_txfifo_clk_gating #(.FF_DEPTH (DEPTH))
aib_txfifo_clk_gating
(
// Outputs
.tff_clk_39_0    (tff_clk_39_0[DEPTH-1:0]),    // Clocks for word 39-0
.tff_clk_79_40   (tff_clk_79_40[DEPTH-1:0]),   // Clocks for word 79-40
.tff_clk_119_80  (tff_clk_119_80[DEPTH-1:0]),  // Clocks for word 119-80
.tff_clk_159_120 (tff_clk_159_120[DEPTH-1:0]), // Clocks for word 159-120
.tff_clk_199_160 (tff_clk_199_160[DEPTH-1:0]),
.tff_clk_239_200 (tff_clk_239_200[DEPTH-1:0]),
.tff_clk_279_240 (tff_clk_279_240[DEPTH-1:0]),
.tff_clk_319_280 (tff_clk_319_280[DEPTH-1:0]),
// Inputs
.txf_wr_clk   (wr_clk),            // TX FIFO write clock
.txf_wr_en    (wr_en_int),         // TX FIFO write enable
.txf_pnt_ff   (txf_wr_pnt_ff[AWIDTH-1:0]), // Indicates TX FIFO element
.tx_fifo_mode (r_fifo_mode[1:0]),  // Indicates TX FIFO operation mode
.m_gen2_mode  (m_gen2_mode),       // Indicates TX FIFO operates in GEN2 mode
.scan_en      (scan_en)            // Scan enable
);

always @(*)
  begin
    case(r_fifo_mode[1:0])
      FIFO_1X:
        begin
          fifo_wr_data[319:0] = { wr_data[79:0],
                                  wr_data[79:0],
                                  wr_data[79:0],
                                  wr_data[79:0] };
        end
      FIFO_2X:
        begin
          fifo_wr_data[319:0] = {wr_data[159:0],wr_data[159:0]};
        end
      default:
        begin
          fifo_wr_data[319:0] = wr_data[319:0];
        end
    endcase
  end


aib_adapt_fifo_mem #(
.DWIDTH (IDWIDTH), // FIFO Input data width 
.DEPTH  (DEPTH)    // FIFO Depth 
)
aib_adapt_txfifo_mem
(
// Inputs
.ff_clk_39_0    (tff_clk_39_0[DEPTH-1:0]),    // clocks for bits 39-0 of FIFO
.ff_clk_79_40   (tff_clk_79_40[DEPTH-1:0]),   // clocks for bits 79-40 of FIFO
.ff_clk_119_80  (tff_clk_119_80[DEPTH-1:0]),  // clocks for bits 119-80 of FIFO
.ff_clk_159_120 (tff_clk_159_120[DEPTH-1:0]), // clocks for bits 159-120 of FIFO
.ff_clk_199_160 (tff_clk_199_160[DEPTH-1:0]),
.ff_clk_239_200 (tff_clk_239_200[DEPTH-1:0]),
.ff_clk_279_240 (tff_clk_279_240[DEPTH-1:0]),
.ff_clk_319_280 (tff_clk_319_280[DEPTH-1:0]),
.ff_rst_n       (wr_rst_n),                   // FIFO array reset
.wr_data        (fifo_wr_data[IDWIDTH-1:0]),       // FIFO write data bus
// Outputs
.fifo_data_ff (fifo_data_ff) // FIFO data
);

// TX FIFO Read pointer register
always @(posedge rd_clk or negedge rd_rst_n)
  begin: txf_rd_pnt_register
    if (!rd_rst_n)
      txf_rd_pnt_ff[DEPTH4-1:0] <= {{(DEPTH4-1){1'b0}},1'b1};
    else if (rd_en_int)
      txf_rd_pnt_ff[DEPTH4-1:0] <= { txf_rd_pnt_ff[DEPTH4-2:0],
                                    txf_rd_pnt_ff[DEPTH4-1]   }; 
  end // block: txf_rd_pnt_register

// Enables read in RX FIFO
assign  fifo_rd_en[DEPTH4-1:0] = txf_rd_pnt_ff[DEPTH4-1:0] &
                                 {DEPTH4{rd_en_int}};

aib_txfifo_rd_dpath #(
.DINW  (IDWIDTH),
.DOUTW (ODWIDTH),
.DEPTH (DEPTH)
)
aib_txfifo_rd_dpath
(
// Output
.rdata_sync_ff (fifo_dout[ODWIDTH-1:0]), // Read data synchronized
// Inputs
.fifo_rd_en      (fifo_rd_en[DEPTH4-1:0]), // FIFO element selector
.fifo_data_async (fifo_data_ff), // FIFO data
.rd_clk          (rd_clk),          // FIFO read clock
.rd_rst_n        (rd_rst_n)         // FIFO read asynchronous reset
);


endmodule // aib_adapt_tx_fifo
