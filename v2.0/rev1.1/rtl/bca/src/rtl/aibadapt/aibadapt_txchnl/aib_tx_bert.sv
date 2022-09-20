// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.

module aib_tx_bert #(
parameter [0:0] BERT_BUF_MODE_EN = 1  // Enables Buffer mode for BERT
)
(
input          clk,               // TX BERT clock
input          rstn,              // Active low asynchronous reset
input [ 3:0]   tx_start_pulse,    // Start pulse to enable LFSR and Pattern 
input [ 3:0]   tx_rst_pulse,      // Synchronous reset pulse
input [ 2:0]   gen0_ptrn_sel_ff,  // Select Pattern in generator0
input [ 2:0]   gen1_ptrn_sel_ff,  // Select Pattern in generator1
input [ 2:0]   gen2_ptrn_sel_ff,  // Select Pattern in generator2
input [ 2:0]   gen3_ptrn_sel_ff,  // Select Pattern in generator3
input [ 1:0]   lane39_gen_sel_ff, // Lane39 selection
input [ 1:0]   lane38_gen_sel_ff, // Lane38 selection
input [ 1:0]   lane37_gen_sel_ff, // Lane37 selection
input [ 1:0]   lane36_gen_sel_ff, // Lane36 selection
input [ 1:0]   lane35_gen_sel_ff, // Lane35 selection
input [ 1:0]   lane34_gen_sel_ff, // Lane34 selection
input [ 1:0]   lane33_gen_sel_ff, // Lane33 selection
input [ 1:0]   lane32_gen_sel_ff, // Lane32 selection
input [ 1:0]   lane31_gen_sel_ff, // Lane31 selection
input [ 1:0]   lane30_gen_sel_ff, // Lane30 selection
input [ 1:0]   lane29_gen_sel_ff, // Lane29 selection
input [ 1:0]   lane28_gen_sel_ff, // Lane28 selection
input [ 1:0]   lane27_gen_sel_ff, // Lane27 selection
input [ 1:0]   lane26_gen_sel_ff, // Lane26 selection
input [ 1:0]   lane25_gen_sel_ff, // Lane25 selection
input [ 1:0]   lane24_gen_sel_ff, // Lane24 selection
input [ 1:0]   lane23_gen_sel_ff, // Lane23 selection
input [ 1:0]   lane22_gen_sel_ff, // Lane22 selection
input [ 1:0]   lane21_gen_sel_ff, // Lane21 selection
input [ 1:0]   lane20_gen_sel_ff, // Lane20 selection
input [ 1:0]   lane19_gen_sel_ff, // Lane19 selection
input [ 1:0]   lane18_gen_sel_ff, // Lane18 selection
input [ 1:0]   lane17_gen_sel_ff, // Lane17 selection
input [ 1:0]   lane16_gen_sel_ff, // Lane16 selection
input [ 1:0]   lane15_gen_sel_ff, // Lane15 selection
input [ 1:0]   lane14_gen_sel_ff, // Lane14 selection
input [ 1:0]   lane13_gen_sel_ff, // Lane13 selection
input [ 1:0]   lane12_gen_sel_ff, // Lane12 selection
input [ 1:0]   lane11_gen_sel_ff, // Lane11 selection
input [ 1:0]   lane10_gen_sel_ff, // Lane10 selection
input [ 1:0]   lane9_gen_sel_ff,  // Lane9 selection
input [ 1:0]   lane8_gen_sel_ff,  // Lane8 selection
input [ 1:0]   lane7_gen_sel_ff,  // Lane7 selection
input [ 1:0]   lane6_gen_sel_ff,  // Lane6 selection
input [ 1:0]   lane5_gen_sel_ff,  // Lane5 selection
input [ 1:0]   lane4_gen_sel_ff,  // Lane4 selection
input [ 1:0]   lane3_gen_sel_ff,  // Lane3 selection
input [ 1:0]   lane2_gen_sel_ff,  // Lane2 selection
input [ 1:0]   lane1_gen_sel_ff,  // Lane1 selection
input [ 1:0]   lane0_gen_sel_ff,  // Lane0 selection
input [15:0]   seed_ld_0,         // Generator0 seed load
input [15:0]   seed_ld_1,         // Generator1 seed load
input [15:0]   seed_ld_2,         // Generator2 seed load
input [15:0]   seed_ld_3,         // Generator3 seed load
input [31:0]   txwdata_sync_ff,   // Data bus to load seed
input          sdr_mode,          // Sigle data rate mode
input  [1:0]   tx_fifo_mode,      // TX FIFO mode
input          m_gen2_mode,       // GEN2 mode selector
output [3:0]   tx_seed_good,      // Seed is different from zero
output [3:0]   tx_bertgen_en,     // LFSR is running
output [319:0] tx_bert_data_out   // TX Bert output for 40x8 bits wide signal
);

// Internal signals
wire [ 79:0] tx_gen_sel; // Selects data source for each LANE
wire [319:0] tx_bert_data_out_g1;
wire [319:0] tx_bert_data_out_g1_ddr;
wire [319:0] tx_bert_data_out_g1_sdr;
wire [319:0] tx_bert_data_out_g2;

reg [7:0] tx_gen0_data;  // Reg for selecting the Pattern output
reg [7:0] tx_gen1_data;  // Reg for selecting the PRBS 7 output
reg [7:0] tx_gen2_data;  // Reg for selecting the PRBS 15 output
reg [7:0] tx_gen3_data;  // Reg for selecting the PRBS 23 output
reg [39:0][7:0] mux_out; // Reg for the 8 bits wide output of the 40 muxes
reg [1:0] tx_sft_nb;            // Select the number of shifts per clock

// Local parameters for selecting the output
localparam [1:0] GEN0 = 2'b00;
localparam [1:0] GEN1 = 2'b01;
localparam [1:0] GEN2 = 2'b10;
localparam [1:0] GEN3 = 2'b11;

// FIFO mode local params
localparam   FIFO_1X   = 2'b00;       //Full rate
localparam   FIFO_2X   = 2'b01;       //Half rate
localparam   FIFO_4X   = 2'b10;       //Quarter Rate


//------------------------------------------------------------------------------
// Instantiation of modules
//------------------------------------------------------------------------------

// BERT generator 0
aib_bert_gen #(.BERT_BUF_MODE_EN (BERT_BUF_MODE_EN))
aib_bert_gen0(
// Inputs
.clk            (clk),             
.rstn           (rstn),            
.tx_start_pulse (tx_start_pulse[0]),  
.tx_rst_pulse   (tx_rst_pulse[0]),    
.tx_sft_nb      (tx_sft_nb[1:0]),  
.tx_ptrn_sel    (gen0_ptrn_sel_ff[2:0]),
.tx_seed        (txwdata_sync_ff[31:0]),  
.tx_seed_ld     (seed_ld_0[15:0]),      
// Outputs
.tx_seed_good   (tx_seed_good[0]),     
.tx_bert_run_ff (tx_bertgen_en[0]),  
.tx_bert_data   (tx_gen0_data[7:0]) 
);

// BERT generator 1
aib_bert_gen #(.BERT_BUF_MODE_EN (BERT_BUF_MODE_EN))
aib_bert_gen1(
// Inputs
.clk            (clk),             
.rstn           (rstn),            
.tx_start_pulse (tx_start_pulse[1]),  
.tx_rst_pulse   (tx_rst_pulse[1]),    
.tx_sft_nb      (tx_sft_nb[1:0]),  
.tx_ptrn_sel    (gen1_ptrn_sel_ff[2:0]),
.tx_seed        (txwdata_sync_ff[31:0]),  
.tx_seed_ld     (seed_ld_1[15:0]),      
// Outputs
.tx_seed_good   (tx_seed_good[1]),     
.tx_bert_run_ff (tx_bertgen_en[1]),  
.tx_bert_data   (tx_gen1_data[7:0]) 
);

// BERT generator 2
aib_bert_gen #(.BERT_BUF_MODE_EN (BERT_BUF_MODE_EN))
aib_bert_gen2(
// Inputs
.clk            (clk),             
.rstn           (rstn),            
.tx_start_pulse (tx_start_pulse[2]),  
.tx_rst_pulse   (tx_rst_pulse[2]),    
.tx_sft_nb      (tx_sft_nb[1:0]),  
.tx_ptrn_sel    (gen2_ptrn_sel_ff[2:0]),
.tx_seed        (txwdata_sync_ff[31:0]),  
.tx_seed_ld     (seed_ld_2[15:0]),      
// Outputs
.tx_seed_good   (tx_seed_good[2]),     
.tx_bert_run_ff (tx_bertgen_en[2]),  
.tx_bert_data   (tx_gen2_data[7:0]) 
);

// BERT generator 3
aib_bert_gen #(.BERT_BUF_MODE_EN (BERT_BUF_MODE_EN))
aib_bert_gen3(
// Inputs
.clk            (clk),             
.rstn           (rstn),            
.tx_start_pulse (tx_start_pulse[3]),  
.tx_rst_pulse   (tx_rst_pulse[3]),    
.tx_sft_nb      (tx_sft_nb[1:0]),  
.tx_ptrn_sel    (gen3_ptrn_sel_ff[2:0]),
.tx_seed        (txwdata_sync_ff[31:0]),  
.tx_seed_ld     (seed_ld_3[15:0]),      
// Outputs
.tx_seed_good   (tx_seed_good[3]),     
.tx_bert_run_ff (tx_bertgen_en[3]),  
.tx_bert_data   (tx_gen3_data[7:0]) 
);

//------------------------------------------------------------------------------
// 
//------------------------------------------------------------------------------
//Logic to select the number of bits per clock
always @(*)
  begin: tx_sft_nb_logic
    case(tx_fifo_mode[1:0])
      FIFO_1X: // FIFO 1:1 rate
        begin
          if(sdr_mode)
            tx_sft_nb[1:0] = 2'b00; // 1 bits per clock
          else
            tx_sft_nb[1:0] = 2'b01; // 2 bits per clock
        end
      FIFO_2X: // FIFO 1:2 rate
        begin
          if(sdr_mode)
            tx_sft_nb[1:0] = 2'b01; // 2 bits per clock
          else
            tx_sft_nb[1:0] = 2'b10; // 4 bits per clock
        end
      FIFO_4X: // FIFO 1:4 rate
        begin
          if(sdr_mode)
            tx_sft_nb[1:0] = 2'b10; // 4 bits per clock
          else
            tx_sft_nb[1:0] = 2'b11; // 8 bits per clock
        end
      default: // register mode - BERT does not support
        begin
          if(sdr_mode)
            tx_sft_nb[1:0] = 2'b00; // 1 bits per clock
          else
            tx_sft_nb[1:0] = 2'b01; // 2 bits per clock
        end
    endcase
  end // block: tx_sft_nb_logic


//------------------------------------------------------------------------------
// Output logic for each of the 40 8 bits wide muxes
//------------------------------------------------------------------------------

assign tx_gen_sel[79:0] = { lane39_gen_sel_ff[1:0],
                            lane38_gen_sel_ff[1:0],
                            lane37_gen_sel_ff[1:0],
                            lane36_gen_sel_ff[1:0],
                            lane35_gen_sel_ff[1:0],
                            lane34_gen_sel_ff[1:0],
                            lane33_gen_sel_ff[1:0],
                            lane32_gen_sel_ff[1:0],
                            lane31_gen_sel_ff[1:0],
                            lane30_gen_sel_ff[1:0],
                            lane29_gen_sel_ff[1:0],
                            lane28_gen_sel_ff[1:0],
                            lane27_gen_sel_ff[1:0],
                            lane26_gen_sel_ff[1:0],
                            lane25_gen_sel_ff[1:0],
                            lane24_gen_sel_ff[1:0],
                            lane23_gen_sel_ff[1:0],
                            lane22_gen_sel_ff[1:0],
                            lane21_gen_sel_ff[1:0],
                            lane20_gen_sel_ff[1:0],
                            lane19_gen_sel_ff[1:0],
                            lane18_gen_sel_ff[1:0],
                            lane17_gen_sel_ff[1:0],
                            lane16_gen_sel_ff[1:0],
                            lane15_gen_sel_ff[1:0],
                            lane14_gen_sel_ff[1:0],
                            lane13_gen_sel_ff[1:0],
                            lane12_gen_sel_ff[1:0],
                            lane11_gen_sel_ff[1:0],
                            lane10_gen_sel_ff[1:0],
                            lane9_gen_sel_ff[1:0], 
                            lane8_gen_sel_ff[1:0], 
                            lane7_gen_sel_ff[1:0], 
                            lane6_gen_sel_ff[1:0], 
                            lane5_gen_sel_ff[1:0], 
                            lane4_gen_sel_ff[1:0], 
                            lane3_gen_sel_ff[1:0], 
                            lane2_gen_sel_ff[1:0], 
                            lane1_gen_sel_ff[1:0], 
                            lane0_gen_sel_ff[1:0] };

// Transmit data MUX output per lane
genvar j;
generate 
  for(j=0; j<40; j=j+1)
    begin: mux_out_gen
      always @(*)
        begin
          case ({tx_gen_sel[(2*j)+1],tx_gen_sel[2*j]}) // Source Selection 
            GEN0: mux_out[j][7:0] = tx_gen0_data[7:0];    // GEN0 output  
            GEN1: mux_out[j][7:0] = tx_gen1_data[7:0];    // GEN1 output   
            GEN2: mux_out[j][7:0] = tx_gen2_data[7:0];    // GEN2 output  
            GEN3: mux_out[j][7:0] = tx_gen3_data[7:0];    // GEN3 output  
          endcase
        end
    end
endgenerate


  
//------------------------------------------------------------------------------
// Assigning the bits for 320 bits wide output
//------------------------------------------------------------------------------

// Unused bits in GEN1 mode received GEN2 bits
assign tx_bert_data_out_g1_sdr[319:80] = tx_bert_data_out_g2[319:80] ;

assign tx_bert_data_out_g1_ddr[319:80] = tx_bert_data_out_g2[319:80];

// TX BERT data for GEN1 mode with DDR
genvar m;
genvar n;
generate
  for(m=0; m<4; m=m+2)
    begin:m_tx_bert_g1_ddr
      for(n=0; n<20; n=n+1)
        begin: n_tx_bert_g1_ddr
          assign tx_bert_data_out_g1_ddr[(m*20)+(2*n)+1:(m*20)+(2*n)] = 
                  {mux_out[n][6-m],mux_out[n][7-m]};
        end // block:n_tx_bert_g1_ddr
    end // block: m_tx_bert_g1_ddr
endgenerate

// TX BERT data for GEN1 mode with SDR
generate
  for(m=0; m<2; m=m+1)
    begin:m_tx_bert_g1_sdr
      for(n=0; n<20; n=n+1)
        begin: n_tx_bert_g1_sdr
          assign tx_bert_data_out_g1_sdr[(m*40)+(2*n)]   = mux_out[n][7-m];
          assign tx_bert_data_out_g1_sdr[(m*40)+(2*n)+1] = 
                                   tx_bert_data_out_g1_ddr[(m*40)+(2*n)+1];
        end // block: n_tx_bert_g1_sdr
    end // block: m_tx_bert_g1_sdr
endgenerate

// TX BERT data for GEN2 mode
genvar p;
genvar q;
generate
  for(p=0; p<8; p=p+2)
    begin:p_tx_bert_data_out_g2
      for(q=0; q<40; q=q+1)
         assign tx_bert_data_out_g2[(p*40)+(2*q)+1:(p*40)+(2*q)] = 
                  {mux_out[q][6-p],mux_out[q][7-p]};
    end // block: p_tx_bert_data_out_g2
endgenerate

// TX BERT data for GEN1 mode
assign tx_bert_data_out_g1[319:0] = sdr_mode ?
                                    tx_bert_data_out_g1_sdr[319:0] :
                                    tx_bert_data_out_g1_ddr[319:0];

// TX BERT data
assign tx_bert_data_out[319:0] = m_gen2_mode                ?
                                 tx_bert_data_out_g2[319:0] :
                                 tx_bert_data_out_g1[319:0];


endmodule
