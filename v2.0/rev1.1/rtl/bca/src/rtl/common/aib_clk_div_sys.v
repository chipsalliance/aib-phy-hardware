// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.

module aib_clk_div_sys (
   // Inputs
   input       rst_n,             // Asynchronous reset
   input       clk,               // Clock
   input       scan_mode,         // Scan mode
   input       clk_div_ld,        // Clock divider enable from avalon interface
   input       clk_div_1_onehot,  // Onehot enable for clock divided by 1
   input       clk_div_2_onehot,  // Onehot enable for clock divided by 2
   input       clk_div_4_onehot,  // Onehot enable for clock divided by 4
   input       clk_div_8_onehot,  // Onehot enable for clock divided by 8
   input       clk_div_16_onehot, // Onehot enable for clock divided by 16
   // Outputs
   output      clk_out,          // Clock divided
   output reg  clk_div_ld_ack_ff // Clock divider load acknowledge
   );

wire clk_div_ld_sync;  // Clock divider enable in clk domain
wire clk_div_load;     // Loads clock selection control
wire clk_div2;         // Clock source divided by 2
wire clk_div4;         // Clock source divided by 4
wire clk_div8;         // Clock source divided by 8
wire clk_div16;        // Clock source divided by 16
wire clk_div2_b;       // Clock divided by 2 inverted
wire clk_div4_b;       // Clock divided by 4 inverted
wire clk_div8_b;       // Clock divided by 8 inverted
wire clk_div16_b;      // Clock divided by 16 inverted
wire clk_div1_cg;      // Clock divided by 1 after clock gating
wire clk_div2_cg;      // Clock divided by 2 after clock gating
wire clk_div4_cg;      // Clock divided by 4 after clock gating
wire clk_div8_cg;      // Clock divided by 8 after clock gating
wire clk_div16_cg;     // Clock divided by 16 after clock gating
wire div1_clk_en;      // Clock enable for clock divided by 1
wire div2_clk_en;      // Clock enable for clock divided by 2
wire div4_clk_en;      // Clock enable for clock divided by 4
wire div8_clk_en;      // Clock enable for clock divided by 8
wire div16_clk_en;     // Clock enable for clock divided by 16
wire clkout_div1_div2; // First OR level for clock div 1 and clock div 2
wire clkout_div4_div8; // First OR level for clock div 4 and clock div 8
wire clkout_div_16;    // First OR level for clock div 16
wire clkout_div_1_8;   // Second OR level for clock div1, div 2 and div 8
wire clkout_div_16_2;  // Second OR level for clock div16
wire clk_div8_and_en;  //den for DIV8 ciruit, AND of DIV2 qb signal and DIV4 qb signal
wire clk_div16_and_en; //den for DIV16 ciruit, AND of DIV2 qb signal, DIV4 qb signal and DIV8 qb signal

reg  clk_div_1_sel_ff;  // Clock divided by 1 selection
reg  clk_div_2_sel_ff;  // Clock divided by 2 selection
reg  clk_div_4_sel_ff;  // Clock divided by 4 selection
reg  clk_div_8_sel_ff;  // Clock divided by 8 selection
reg  clk_div_16_sel_ff; // Clock divided by 16 selection

// phcomp_wren Synchronizer
aib_bit_sync clk_div_load_sync
  (
   .clk      (clk),             // Clock of destination domain
   .rst_n    (rst_n),           // Reset of destination domain
   .data_in  (clk_div_ld),      // Input to be synchronized
   .data_out (clk_div_ld_sync)  // Synchronized output
   );

assign clk_div_load = clk_div_ld_ack_ff ^ clk_div_ld_sync;

// Clock division update enable
always @(posedge clk or negedge rst_n)
  begin: clk_div_ld_sync_register
    if(!rst_n)
      clk_div_ld_ack_ff <= 1'b0;
    else
      clk_div_ld_ack_ff <= clk_div_ld_sync;
  end // block: clk_div_ld_sync_register

// Clock divided by 1 selection register
always @(posedge clk or negedge rst_n)
  begin: clk_div_1_sel_register
    if(!rst_n)
      clk_div_1_sel_ff <= 1'b0;
    else if(clk_div_load)
      clk_div_1_sel_ff <= clk_div_1_onehot;
  end // block: clk_div_1_sel_register

// Clock divided by 2 selection register
always @(posedge clk or negedge rst_n)
  begin: clk_div_2_sel_register
    if(!rst_n)
      clk_div_2_sel_ff <= 1'b0;
    else if(clk_div_load)
      clk_div_2_sel_ff <= clk_div_2_onehot;
  end // block: clk_div_2_sel_register

// Clock divided by 4 selection register
always @(posedge clk or negedge rst_n)
  begin: clk_div_4_sel_register
    if(!rst_n)
      clk_div_4_sel_ff <= 1'b0;
    else if(clk_div_load)
      clk_div_4_sel_ff <= clk_div_4_onehot;
  end // block: clk_div_4_sel_register

// Clock divided by 8 selection register
always @(posedge clk or negedge rst_n)
  begin: clk_div_8_sel_register
    if(!rst_n)
      clk_div_8_sel_ff <= 1'b0;
    else if(clk_div_load)
      clk_div_8_sel_ff <= clk_div_8_onehot;
  end // block: clk_div_8_sel_register
  

// Clock divided by 16 selection register
always @(posedge clk or negedge rst_n)
  begin: clk_div_16_sel_register
    if(!rst_n)
      clk_div_16_sel_ff <= 1'b0;
    else if(clk_div_load)
      clk_div_16_sel_ff <= clk_div_16_onehot;
  end // block: clk_div_16_sel_register

// Clock gating for DIV1 clock
clk_gate_cel cg_div_1( .clkout (clk_div1_cg),
                       .clk    (clk),
                       .en     (div1_clk_en),
                       .te     (1'b0)         );

assign div1_clk_en  = clk_div_1_sel_ff  |  scan_mode;
assign div2_clk_en  = clk_div_2_sel_ff  & ~scan_mode;
assign div4_clk_en  = clk_div_4_sel_ff  & ~scan_mode;
assign div8_clk_en  = clk_div_8_sel_ff  & ~scan_mode;
assign div16_clk_en = clk_div_16_sel_ff & ~scan_mode;

// Clock gating for DIV2 clock
clk_gate_cel cg_div_2( .clkout (clk_div2_cg),
                       .clk    (clk_div2),
                       .en     (div2_clk_en),
                       .te     (1'b0)         );

// Clock gating for DIV4 clock
clk_gate_cel cg_div_4( .clkout (clk_div4_cg),
                       .clk    (clk_div4),
                       .en     (div4_clk_en),
                       .te     (1'b0)         );

// Clock gating for DIV8 clock
clk_gate_cel cg_div_8( .clkout (clk_div8_cg),
                       .clk    (clk_div8),
                       .en     (div8_clk_en),
                       .te     (1'b0)         );

// Clock gating for DIV16 clock
clk_gate_cel cg_div_16( .clkout (clk_div16_cg),
                        .clk    (clk_div16),
                        .en     (div16_clk_en),
                        .te     (1'b0)         );

// Flop to divide clock source by 2
clk_den_flop clk_div2_flop(
.clk (clk),
.d   (clk_div2_b),  
.den (1'b1),
.rb  (rst_n),
.o   (clk_div2)  
);

// Clock divided by 2 inverted
clk_inv_cel clk_div2_inv(
.clkout (clk_div2_b),
.clk    (clk_div2)
);

// Flop to divide clock source by 4
clk_den_flop clk_div4_flop(
.clk (clk),
.d   (clk_div4_b),  
.den (clk_div2_b),
.rb  (rst_n),
.o   (clk_div4)  
);

// Clock divided by 4 inverted
clk_inv_cel clk_div4_inv(
.clkout (clk_div4_b),
.clk    (clk_div4)
);

// Flop to divide clock source by 8
clk_den_flop clk_div8_flop(
.clk (clk),
.d   (clk_div8_b),  
.den (clk_div8_and_en),
.rb  (rst_n),
.o   (clk_div8)  
);

// Clock divided by 8 inverted
clk_inv_cel clk_div8_inv(
.clkout (clk_div8_b),
.clk    (clk_div8)
);

// AND for den signal of div8 circuit
clk_and2_cel clk_and2_div8(
.clkout (clk_div8_and_en), // AND output
.clk1   (clk_div4_b),  // clock 1
.clk2   (clk_div2_b)   // clock 2
);
// Flop to divide clock source by 16
clk_den_flop clk_div16_flop(
.clk (clk),
.d   (clk_div16_b),  
.den (clk_div16_and_en),
.rb  (rst_n),
.o   (clk_div16)  
);

// Clock divided by 16 inverted
clk_inv_cel clk_div16_inv(
.clkout (clk_div16_b),
.clk    (clk_div16)
);

// AND for den signal of div16 circuit
clk_and3_cel clk_and3_div16(
.clkout (clk_div16_and_en), // AND output
.clk1   (clk_div2_b),  // clock 1
.clk2   (clk_div4_b),   // clock 2
.clk3   (clk_div8_b)   // clock 3
);

// First OR level for clk div 1 and clk div 2
clk_or2_cel clk_or2_div1_div2_1(
.clkout (clkout_div1_div2), // OR output
.clk1   (clk_div1_cg),      // clock 1
.clk2   (clk_div2_cg)       // clock 2
);

// First OR level for clk div 4 and clk div 8
clk_or2_cel clk_or2_div4_div8_1(
.clkout (clkout_div4_div8), // OR output
.clk1   (clk_div4_cg),     // clock 1
.clk2   (clk_div8_cg)      // clock 2
);

// First OR level for dclk div  16
clk_or2_cel clk_or2_div16_1(
.clkout (clkout_div_16), // OR output
.clk1   (clk_div16_cg),  // clock 1
.clk2   (1'b0)           // clock 2
);

// Second OR level 1 for clock div 1, 2 ,4 and 8
clk_or2_cel clk_or2_level2_1(
.clkout (clkout_div_1_8),       // OR output
.clk1   (clkout_div1_div2),     // clock 1
.clk2   (clkout_div4_div8)      // clock 2
);

//  Second OR level 2 for clock div 16
clk_or2_cel clk_or2_level2_2(
.clkout (clkout_div_16_2), // OR output
.clk1   (clkout_div_16),   // clock 1
.clk2   (1'b0)            // clock 2
);

// Level 3 OR
clk_or2_cel clk_or2_level3(
.clkout (clk_out),          // OR output
.clk1   (clkout_div_1_8),  // clock 1
.clk2   (clkout_div_16_2)  // clock 2
);

endmodule // aib_clk_div_sys
