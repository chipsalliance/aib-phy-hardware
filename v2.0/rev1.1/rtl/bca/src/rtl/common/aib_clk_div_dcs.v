// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.

module aib_clk_div_dcs (
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
   input       clk_div_32_onehot, // Onehot enable for clock divided by 32
   input       clk_div_64_onehot, // Onehot enable for clock divided by 64
   input       clk_div_128_onehot, // Onehot enable for clock divided by 128
   input       clk_div_256_onehot, // Onehot enable for clock divided by 256
   // Outputs
   output      clk_out,          // Clock divided
   output reg  clk_div_ld_ack_ff // Clock divider load acknowledge
   );

wire clk_div_ld_sync;    // Clock divider enable in clk domain
wire clk_div_load;       // Loads clock selection control
wire clk_div2;           // Clock source divided by 2
wire clk_div4;           // Clock source divided by 4
wire clk_div8;           // Clock source divided by 8
wire clk_div16;          // Clock source divided by 16
wire clk_div32;          // Clock source divided by 32
wire clk_div64;          // Clock source divided by 64
wire clk_div128;         // Clock source divided by 128
wire clk_div256;         // Clock source divided by 256
wire clk_div2_b;         // Clock divided by 2 inverted
wire clk_div4_b;         // Clock divided by 4 inverted
wire clk_div8_b;         // Clock divided by 8 inverted
wire clk_div16_b;        // Clock divided by 16 inverted
wire clk_div32_b;        // Clock divided by 32 inverted
wire clk_div64_b;        // Clock divided by 64 inverted
wire clk_div128_b;        // Clock divided by 128 inverted
wire clk_div256_b;        // Clock divided by 256 inverted
wire clk_div1_cg;        // Clock divided by 1 after clock gating
wire clk_div2_cg;        // Clock divided by 2 after clock gating
wire clk_div4_cg;        // Clock divided by 4 after clock gating
wire clk_div8_cg;        // Clock divided by 8 after clock gating
wire clk_div16_cg;       // Clock divided by 16 after clock gating
wire clk_div32_cg;       // Clock divided by 32 after clock gating
wire clk_div64_cg;       // Clock divided by 64 after clock gating
wire clk_div128_cg;       // Clock divided by 128 after clock gating
wire clk_div256_cg;       // Clock divided by 256 after clock gating
wire div1_clk_en;        // Clock enable for clock divided by 1
wire div2_clk_en;        // Clock enable for clock divided by 2
wire div4_clk_en;        // Clock enable for clock divided by 4
wire div8_clk_en;        // Clock enable for clock divided by 8
wire div16_clk_en;       // Clock enable for clock divided by 16
wire div32_clk_en;       // Clock enable for clock divided by 32
wire div64_clk_en;       // Clock enable for clock divided by 64 
wire div128_clk_en;       // Clock enable for clock divided by 128
wire div256_clk_en;       // Clock enable for clock divided by 256
wire clkout_div1_div2;   // First OR level for clock div 1 and clock div 2
wire clkout_div4_div8;   // First OR level for clock div 4 and clock div 8
wire clkout_div16_div32; // First OR level for clock div 16 and clock div 32
wire clkout_div64_div128; // First OR level for clock div 64 and clock div 128
wire clkout_div16_div128; // Second OR level for clock div 16 and clock div 128
wire clkout_div_1_8;     // Second OR level for clock div1, div 2 and div 8
wire clkout_div_16_32;   // Second OR level for clock div16
wire clkout_div_16_256; //  Third OR level for clock div 16 and clock div 256
wire clk_div8_and_en;  //den for DIV8 ciruit, AND of DIV2 qb signal and DIV4 qb signals
wire clk_div16_and_en; //den for DIV16 ciruit, AND of DIV2 qb signal, DIV4 qb signal and DIV8 qb signals
wire clk_div32_and_en; //den for DIV32 ciruit, AND of DIV2,4,8,16 qb signals
wire clk_div64_and_en; //den for DIV64 ciruit, AND of clk_div64_and_en_1, clk_div64_and_en_2
wire clk_div64_and_en_1; //den for DIV64 ciruit, AND of DIV2,4 qb signals
wire clk_div64_and_en_2; //den for DIV64 ciruit, AND of DIV8,16,32 qb signals
wire clk_div128_and_en; //den for DIV128 ciruit, AND of clk_div64_and_en_1,clk_div64_and_en_2 
wire clk_div128_and_en_1; //den for DIV128 ciruit, AND of DIV2,4,8 qb signals
wire clk_div128_and_en_2; //den for DIV128 ciruit, AND of DIV16,32,64 qb signals
wire clk_div256_and_en; //den for DIV256 ciruit, AND of clk_div256_and_en_1, clk_div256_and_en_2, 128qb signals
wire clk_div256_and_en_1; //den for DIV256 ciruit, AND of DIV2,4,8  qb signals
wire clk_div256_and_en_2; //den for DIV256 ciruit, AND of DIV16,32,64  qb signals

reg  clk_div_1_sel_ff;  // Clock divided by 1 selection
reg  clk_div_2_sel_ff;  // Clock divided by 2 selection
reg  clk_div_4_sel_ff;  // Clock divided by 4 selection
reg  clk_div_8_sel_ff;  // Clock divided by 8 selection
reg  clk_div_16_sel_ff; // Clock divided by 16 selection
reg  clk_div_32_sel_ff; // Clock divided by 32 selection
reg  clk_div_64_sel_ff; // Clock divided by 64 selection
reg  clk_div_128_sel_ff; // Clock divided by 128 selection
reg  clk_div_256_sel_ff; // Clock divided by 256 selection

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

// Clock divided by 32 selection register
always @(posedge clk or negedge rst_n)
  begin: clk_div_32_sel_register
    if(!rst_n)
      clk_div_32_sel_ff <= 1'b0;
    else if(clk_div_load)
      clk_div_32_sel_ff <= clk_div_32_onehot;
  end // block: clk_div_32_sel_register

// Clock divided by 64 selection register
always @(posedge clk or negedge rst_n)
  begin: clk_div_64_sel_register
    if(!rst_n)
      clk_div_64_sel_ff <= 1'b0;
    else if(clk_div_load)
      clk_div_64_sel_ff <= clk_div_64_onehot;
  end // block: clk_div_64_sel_register

// Clock divided by 128 selection register
always @(posedge clk or negedge rst_n)
  begin: clk_div_128_sel_register
    if(!rst_n)
      clk_div_128_sel_ff <= 1'b0;
    else if(clk_div_load)
      clk_div_128_sel_ff <= clk_div_128_onehot;
  end // block: clk_div_128_sel_register

// Clock divided by 256 selection register
always @(posedge clk or negedge rst_n)
  begin: clk_div_256_sel_register
    if(!rst_n)
      clk_div_256_sel_ff <= 1'b0;
    else if(clk_div_load)
      clk_div_256_sel_ff <= clk_div_256_onehot;
  end // block: clk_div_256_sel_register

// Clock gating for DIV1 clock
clk_gate_cel cg_div_1( .clkout (clk_div1_cg),
                       .clk    (clk),
                       .en     (div1_clk_en),
                       .te     (1'b0)         );

assign div1_clk_en  = clk_div_1_sel_ff   |  scan_mode;
assign div2_clk_en  = clk_div_2_sel_ff   & ~scan_mode;
assign div4_clk_en  = clk_div_4_sel_ff   & ~scan_mode;
assign div8_clk_en  = clk_div_8_sel_ff   & ~scan_mode;
assign div16_clk_en = clk_div_16_sel_ff  & ~scan_mode;
assign div32_clk_en = clk_div_32_sel_ff  & ~scan_mode;
assign div64_clk_en = clk_div_64_sel_ff  & ~scan_mode;
assign div128_clk_en = clk_div_128_sel_ff & ~scan_mode;
assign div256_clk_en = clk_div_256_sel_ff & ~scan_mode;

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

// Clock gating for DIV32 clock
clk_gate_cel cg_div_32( .clkout (clk_div32_cg),
                        .clk    (clk_div32),
                        .en     (div32_clk_en),
                        .te     (1'b0)         );

// Clock gating for DIV64 clock
clk_gate_cel cg_div_64( .clkout (clk_div64_cg),
                        .clk    (clk_div64),
                        .en     (div64_clk_en),
                        .te     (1'b0)         );

// Clock gating for DIV128 clock
clk_gate_cel cg_div_128( .clkout (clk_div128_cg),
                        .clk    (clk_div128),
                        .en     (div128_clk_en),
                        .te     (1'b0)         );

// Clock gating for DIV256 clock
clk_gate_cel cg_div_256( .clkout (clk_div256_cg),
                        .clk    (clk_div256),
                        .en     (div256_clk_en),
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
// Flop to divide clock source by 32
clk_den_flop clk_div32_flop(
.clk (clk),
.d   (clk_div32_b),  
.den (clk_div32_and_en),
.rb  (rst_n),
.o   (clk_div32)  
);

// Clock divided by 32 inverted
clk_inv_cel clk_div32_inv(
.clkout (clk_div32_b),
.clk    (clk_div32)
);

// AND for den signal of div32 circuit
clk_and4_cel clk_and4_div32(
.clkout (clk_div32_and_en), // AND output
.clk1   (clk_div2_b),  // clock 1
.clk2   (clk_div4_b),   // clock 2
.clk3   (clk_div8_b),   // clock 3
.clk4   (clk_div16_b)   // clock 4
);

// Flop to divide clock source by 64
clk_den_flop clk_div64_flop(
.clk (clk),
.d   (clk_div64_b),  
.den (clk_div64_and_en),
.rb  (rst_n),
.o   (clk_div64)  
);

// Clock divided by 64 inverted
clk_inv_cel clk_div64_inv(
.clkout (clk_div64_b),
.clk    (clk_div64)
);

// AND for den signal of div64 circuit
clk_and2_cel clk_and2_div64_1(
.clkout (clk_div64_and_en_1), // AND output
.clk1   (clk_div2_b),  // clock 1
.clk2   (clk_div4_b)   // clock 2
);

// AND for den signal of div64 circuit
clk_and3_cel clk_and3_div64_2(
.clkout (clk_div64_and_en_2), // AND output
.clk1   (clk_div8_b),  // clock 1
.clk2   (clk_div16_b),  // clock 2
.clk3   (clk_div32_b)   // clock 3
);

// AND for den signal of div64 circuit
clk_and2_cel clk_and2_div64(
.clkout (clk_div64_and_en),    // AND output
.clk1   (clk_div64_and_en_1),  // clock 1
.clk2   (clk_div64_and_en_2)   // clock 2
);

// Flop to divide clock source by 128
clk_den_flop clk_div128_flop(
.clk (clk),
.d   (clk_div128_b),  
.den (clk_div128_and_en),
.rb  (rst_n),
.o   (clk_div128)  
);

// Clock divided by 128 inverted
clk_inv_cel clk_div128_inv(
.clkout (clk_div128_b),
.clk    (clk_div128)
);

// AND for den signal of div128 circuit
clk_and3_cel clk_and3_div128_1(
.clkout (clk_div128_and_en_1), // AND output
.clk1   (clk_div2_b),  // clock 1
.clk2   (clk_div4_b),   // clock 2
.clk3   (clk_div8_b)   // clock 2
);

// AND for den signal of div128 circuit
clk_and3_cel clk_and3_div128_2(
.clkout (clk_div128_and_en_2), // AND output
.clk1   (clk_div16_b),  // clock 1
.clk2   (clk_div32_b),  // clock 2
.clk3   (clk_div64_b)   // clock 3
);

// AND for den signal of div128 circuit
clk_and2_cel clk_and2_div128(
.clkout (clk_div128_and_en),    // AND output
.clk1   (clk_div128_and_en_1),  // clock 1
.clk2   (clk_div128_and_en_2)   // clock 2
);

// Flop to divide clock source by 256
clk_den_flop clk_div256_flop(
.clk (clk),
.d   (clk_div256_b),  
.den (clk_div256_and_en),
.rb  (rst_n),
.o   (clk_div256)  
);

// Clock divided by 256 inverted
clk_inv_cel clk_div256_inv(
.clkout (clk_div256_b),
.clk    (clk_div256)
);

// AND for den signal of div256 circuit
clk_and3_cel clk_and3_div256_1(
.clkout (clk_div256_and_en_1), // AND output
.clk1   (clk_div2_b),  // clock 1
.clk2   (clk_div4_b),   // clock 2
.clk3   (clk_div8_b)   // clock 3
);

// AND for den signal of div256 circuit
clk_and3_cel clk_and3_div256_2(
.clkout (clk_div256_and_en_2), // AND output
.clk1   (clk_div16_b),  // clock 1
.clk2   (clk_div32_b),  // clock 2
.clk3   (clk_div64_b)   // clock 3
);

// AND for den signal of div256 circuit
clk_and3_cel clk_and3_div256(
.clkout (clk_div256_and_en),    // AND output
.clk1   (clk_div256_and_en_1),  // clock 1
.clk2   (clk_div256_and_en_2),  // clock 2
.clk3   (clk_div128_b)          // clock 3
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

// First OR level for dclk div  16 and clk div 32
clk_or2_cel clk_or2_div16_div32_1(
.clkout (clkout_div16_div32), // OR output
.clk1   (clk_div16_cg),  // clock 1
.clk2   (clk_div32_cg)   // clock 2
);

// Second OR level for clock div 1, 2 ,4 and 8
clk_or2_cel clk_or2_level2_1(
.clkout (clkout_div_1_8),       // OR output
.clk1   (clkout_div1_div2),     // clock 1
.clk2   (clkout_div4_div8)      // clock 2
);

//  Second OR level 2 for clock div 16 and clock div 32
clk_or2_cel clk_or2_level2_2(
.clkout (clkout_div_16_32), // OR output
.clk1   (clkout_div16_div32),   // clock 1
.clk2   (1'b0)            // clock 2
);

// Level 4 OR
clk_or2_cel clk_or2_level4(
.clkout (clk_out),          // OR output
.clk1   (clkout_div_1_8),  // clock 1
.clk2   (clkout_div_16_256) // clock 2
);

// First OR level for dclk div64 and clk div128
clk_or2_cel clk_or2_div64_div128_1(
.clkout (clkout_div64_div128), // OR output
.clk1   (clk_div64_cg),  // clock 1
.clk2   (clk_div128_cg)   // clock 2
);

// Second OR level for dclk div16 and clk div128
clk_or2_cel clk_or2_div16_div128_2(
.clkout (clkout_div16_div128), // OR output
.clk1   (clkout_div_16_32),  // clock 1
.clk2   (clkout_div64_div128)   // clock 2
);

//Third OR level 2 for clock div 16 and 256
clk_or2_cel clk_or2_level3(
.clkout (clkout_div_16_256), // OR output
.clk1   (clkout_div16_div128),  // clock 1
.clk2   (clk_div256_cg)   // clock 2
);

endmodule // aib_clk_div_dcs
