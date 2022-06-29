// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.
// Copyright (C) 2021 Intel Corporation.

module aib_adapt_rx_fifo
  #(
    parameter ODWIDTH = 'd320,       // FIFO output data width
    parameter IDWIDTH = 'd80,        // FIFO Input data width
    parameter DEPTH   = 'd6,         // FIFO Depth 
    parameter DEPTH4  = DEPTH * 4,   // DEPTH MUTIPLIED BY 4
    parameter AWIDTH = $clog2(DEPTH4) // FIFO address width 
    )
    (
    // Inputs
    input               wr_rst_n,        // Write Domain Active low Reset  
    input               wr_clk,          // Write Domain Clock             
    input  [IDWIDTH-1:0] fifo_din,       // Write Data In                  
    input               rd_rst_n,        // Read Domain Active low Reset   
    input               rd_clk,          // Read Domain Clock              
    input               scan_en,         // Scan enable                    
    input               m_gen2_mode,     // Generation 2 mode              
    input  [1:0]        r_fifo_mode,     // FIFO Mode: 4:1 2:1 1:1 Reg mode
    input  [3:0] r_phcomp_rd_delay,      // Programmable phase conpensation
    input  [4:0] rx_align_threshold,     // Rx FIFO alignment threshold    
    input               r_wa_en,         // Word-align enable              
    input  [4:0]        r_mkbit,         // Configurable marker bit        
    input               rx_wa_mode_sync, // Word alignment mode bit
    // Outputs
    output [ODWIDTH-1:0] fifo_dout,  // Read Data Out
    output               align_done  // Word mark alignment done
     );

//------------------------------------------------------------------------------
// Local Parameters 
//------------------------------------------------------------------------------
localparam   FIFO_1X   = 2'b00;       //Full rate
localparam   FIFO_2X   = 2'b01;       //Half rate
localparam   FIFO_4X   = 2'b10;       //Quarter Rate
localparam   REG_MOD   = 2'b11;       //REG mode

//------------------------------------------------------------------------------
// Define wires and regs 
//------------------------------------------------------------------------------
wire   phcomp_mode;          // Indicates FIFO mode 
wire   phcomp_wren_sync2;    // Wite enable synchronized at read clock domain  
wire   rd_en_int;            // FIFO read enable
wire   wam_fifo_wren;        // Indicates FIFO can be written
wire   phcomp_wren_sync;     // Write enable in read clock domain with 
                             // configurable phase
wire   phcomp_rden;          // Read enable for FIFO mode
wire   wam_alig_sync;        // Word alignment indication at read clock domain
wire [AWIDTH-1 :0] rxf_wr_pnt_in; // RX FIFO write pointer input
wire [ODWIDTH-1:0] rxf_wr_data;   // RX FIFO write data bus
wire [DEPTH4-1 :0] fifo_rd_en;    // RX FIFO read enable
wire [DEPTH-1:0] rff_clk_39_0;    // Clocks for word 39-0
wire [DEPTH-1:0] rff_clk_79_40;   // Clocks for word 79-40
wire [DEPTH-1:0] rff_clk_119_80;
wire [DEPTH-1:0] rff_clk_159_120;
wire [DEPTH-1:0] rff_clk_199_160;
wire [DEPTH-1:0] rff_clk_239_200;
wire [DEPTH-1:0] rff_clk_279_240;
wire [DEPTH-1:0] rff_clk_319_280;
wire [DEPTH-1:0][ODWIDTH-1:0] fifo_data_ff; // Data of FIFO array
wire             wr_en_int;
wire             co_nc;

reg    phcomp_wren_sync3;    // Additional delay in the read enable path
reg    phcomp_wren_sync4;    // Additional delay in the read enable path
reg    phcomp_wren_sync5;    // Additional delay in the read enable path
reg    phcomp_wren_sync6;    // Additional delay in the read enable path
reg    phcomp_wren_sync7;    // Additional delay in the read enable path
reg    phcomp_wren_sync8;    // Additional delay in the read enable path
reg    phcomp_wren_sync9;    // Additional delay in the read enable path
reg    phcomp_wren_sync10;   // Additional delay in the read enable path
reg    phcomp_wren_sync11;   // Additional delay in the read enable path
reg    rd_en_reg;            // Read enable registered to be used as align done
                             // output
reg [AWIDTH-1 :0] rxf_wr_pnt_ff; // RX FIFO write pointer
reg [IDWIDTH-1:0] fifo_din_ff;   // Data input register
reg [DEPTH4-1 :0] rxf_rd_pnt_ff;  // RX FIFO read pointer
reg [DEPTH4-1 :0] rxf_rd_pnt_in;  // RX FIFO read pointer input


// FIFO mode decode
assign phcomp_mode   = (r_fifo_mode != REG_MOD);  //2'b11 is reg_mod

// Indicates the alignment is done
assign align_done = rd_en_reg;

//********************************************************************
// Read Write logic 
//********************************************************************

// FIFO write enable
assign wr_en_int = phcomp_mode & wam_fifo_wren;

// FIFO read enable
assign rd_en_int = phcomp_mode & phcomp_rden;

// Read enable registered to be used as align done output
always @(negedge rd_rst_n or posedge rd_clk)
  begin: read_en_register
    if (rd_rst_n == 1'b0) 
      begin
        rd_en_reg <= 1'b0;
      end // reset
    else 
      begin
        rd_en_reg <= rd_en_int & wam_alig_sync;
      end // sampled input
  end // block: read_en_register

aib_rx_fifo_wam #( .IDWIDTH (IDWIDTH) )
aib_rx_fifo_wam
(
// Inputs
.wr_rst_n           (wr_rst_n),             // Write Domain Active low Reset
.wr_clk             (wr_clk),               // Write Domain Clock
.wr_data            (fifo_din_ff[IDWIDTH-1:0]), // Write Data In
.rd_rst_n           (rd_rst_n),             // Read Domain Active low Reset
.rd_clk             (rd_clk),               // Read Domain Clock
.r_fifo_mode        (r_fifo_mode[1:0]),     // FIFO double write mode
.rx_wa_mode_sync    (rx_wa_mode_sync),      // Rx word alignment mode bit
.r_mkbit            (r_mkbit[4:0]),         // Configurable marker bit 
.rx_align_threshold (rx_align_threshold[4:0]), // FIFO word alignment threshold
.r_wa_en            (r_wa_en),              // Rx word alignment enable
// Outputs
.wam_alig_sync      (wam_alig_sync), // Word aligned indication synchronized
.wam_fifo_wren      (wam_fifo_wren)  // Write in FIFO is enabled
);

// PHCOM_wren synchronization to read clock domain
aib_bit_sync bitsync2_phcomp_wren
(
.clk      (rd_clk),           // Clock of destination domain
.rst_n    (rd_rst_n),         // Reset of destination domain
.data_in  (wam_fifo_wren),    // Input to be synchronized
.data_out (phcomp_wren_sync2) // Synchronized output
);

// Phase compensation for read enable
always @(negedge rd_rst_n or posedge rd_clk)
  begin: phcomp_rden_register
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
      end
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
  end // block: phcomp_rden_register  

// Read Enable phase control logic
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

// Read enable is generated using phase compensation configuration
assign phcomp_rden = phcomp_wren_sync;

assign {co_nc,rxf_wr_pnt_in[AWIDTH-1:0]} = 
           (rxf_wr_pnt_ff[AWIDTH-1:0] == (DEPTH4-1))              ?
           {AWIDTH{1'b0}}                                         :
           rxf_wr_pnt_ff[AWIDTH-1:0] + {{(AWIDTH-1){1'b0}}, 1'b1};

always @(posedge wr_clk or negedge wr_rst_n)
  begin
    if(!wr_rst_n)
      rxf_wr_pnt_ff[AWIDTH-1:0] <= {AWIDTH{1'b0}};
    else if(wr_en_int)
      rxf_wr_pnt_ff[AWIDTH-1:0] <= rxf_wr_pnt_in[AWIDTH-1:0];
  end

aib_rxfifo_clk_gating #( .FF_DEPTH (DEPTH) )
aib_rxfifo_clk_gating
(
// Outputs
.rff_clk_39_0    (rff_clk_39_0[DEPTH-1:0]),     // Clocks for word 39-0
.rff_clk_79_40   (rff_clk_79_40[DEPTH-1:0]),    // Clocks for word 79-40
.rff_clk_119_80  (rff_clk_119_80),
.rff_clk_159_120 (rff_clk_159_120),
.rff_clk_199_160 (rff_clk_199_160),
.rff_clk_239_200 (rff_clk_239_200),
.rff_clk_279_240 (rff_clk_279_240),
.rff_clk_319_280 (rff_clk_319_280),
// Inputs
.rxf_wr_clk   (wr_clk),             // RX FIFO write clock
.rxf_wr_en    (wr_en_int),          // RX FIFO write enable
.rxf_pnt_ff   (rxf_wr_pnt_ff[AWIDTH-1:0]), // Indicates RX FIFO element 
.m_gen2_mode  (m_gen2_mode),        // Indicates RX FIFO operates in GEN2 mode
.scan_en      (scan_en)             // Scan enable
);

always @(posedge wr_clk or negedge wr_rst_n)
  begin
    if(!wr_rst_n)
      fifo_din_ff[IDWIDTH-1:0] <= {IDWIDTH{1'b0}};
    else
      fifo_din_ff[IDWIDTH-1:0] <= fifo_din[IDWIDTH-1:0];
  end

assign rxf_wr_data[ODWIDTH-1:0] = { fifo_din_ff[IDWIDTH-1:0],
                                    fifo_din_ff[IDWIDTH-1:0],
                                    fifo_din_ff[IDWIDTH-1:0],
                                    fifo_din_ff[IDWIDTH-1:0] };

aib_adapt_fifo_mem #(
.DWIDTH (ODWIDTH), // FIFO Input data width 
.DEPTH  (DEPTH)    // FIFO Depth 
)
aib_adapt_rxfifo_mem
(
// Inputs
.ff_clk_39_0    (rff_clk_39_0[DEPTH-1:0]),    // clocks for bits 39-0 of FIFO
.ff_clk_79_40   (rff_clk_79_40[DEPTH-1:0]),   // clocks for bits 79-40 of FIFO
.ff_clk_119_80  (rff_clk_119_80[DEPTH-1:0]),  // clocks for bits 119-80 of FIFO
.ff_clk_159_120 (rff_clk_159_120[DEPTH-1:0]), // clocks for bits 159-120 of FIFO
.ff_clk_199_160 (rff_clk_199_160[DEPTH-1:0]),
.ff_clk_239_200 (rff_clk_239_200[DEPTH-1:0]),
.ff_clk_279_240 (rff_clk_279_240[DEPTH-1:0]),
.ff_clk_319_280 (rff_clk_319_280[DEPTH-1:0]),
.ff_rst_n       (wr_rst_n),                   // FIFO array reset
.wr_data        (rxf_wr_data[ODWIDTH-1:0]),   // FIFO write data bus
// Outputs
.fifo_data_ff (fifo_data_ff) // FIFO data
);

always @(*)
  begin
    if(rd_en_int)
      begin
        case(r_fifo_mode[1:0])
          FIFO_4X: rxf_rd_pnt_in = { rxf_rd_pnt_ff[DEPTH4-5:0],
                                     rxf_rd_pnt_ff[DEPTH4-1:DEPTH4-4]   };
          FIFO_2X: rxf_rd_pnt_in = { rxf_rd_pnt_ff[DEPTH4-3:0],
                                     rxf_rd_pnt_ff[DEPTH4-1:DEPTH4-2]   };
          default: rxf_rd_pnt_in = { rxf_rd_pnt_ff[DEPTH4-2:0],
                                     rxf_rd_pnt_ff[DEPTH4-1]   };
        endcase
      end
    else
      begin
        case(r_fifo_mode[1:0])
          FIFO_4X: rxf_rd_pnt_in = {{(DEPTH4-4){1'b0}},4'b1111};
          FIFO_2X: rxf_rd_pnt_in = {{(DEPTH4-2){1'b0}},2'b11};
          default: rxf_rd_pnt_in = {{(DEPTH4-1){1'b0}},1'b1};
        endcase
      end
  end

// RX FIFO Read pointer register
always @(posedge rd_clk or negedge rd_rst_n)
  begin: rxf_rd_pnt_register
    if (!rd_rst_n)
      rxf_rd_pnt_ff[DEPTH4-1:0] <= {{(DEPTH4-1){1'b0}},1'b1};
    else
      rxf_rd_pnt_ff[DEPTH4-1:0] <= rxf_rd_pnt_in[DEPTH4-1:0];
  end // block: rxf_rd_pnt_register

// Enables read in RX FIFO
assign  fifo_rd_en[DEPTH4-1:0] = rxf_rd_pnt_ff[DEPTH4-1:0] &
                                 {DEPTH4{rd_en_int}};

aib_rxfifo_rd_dpath #(
.DWIDTH (ODWIDTH),
.DEPTH  (DEPTH)
)
aib_rxfifo_rd_dpath
(
// Output
.rdata_sync_ff (fifo_dout[ODWIDTH-1:0]), // Read data synchronized
// Inputs
.fifo_rd_en      (fifo_rd_en[DEPTH4-1:0]), // FIFO element selector
.r_fifo_mode     (r_fifo_mode[1:0]),       // FIFO mode
.m_gen2_mode     (m_gen2_mode),            // GEN2 mode enable
.fifo_data_async (fifo_data_ff),           // FIFO data
.rd_clk          (rd_clk),                 // FIFO read clock
.rd_rst_n        (rd_rst_n)                // FIFO read asynchronous reset
);

endmodule // aib_adapt_rx_fifo
