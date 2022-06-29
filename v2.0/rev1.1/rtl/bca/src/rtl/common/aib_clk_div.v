// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.

module aib_clk_div (
   // Inputs
   input       rst_n,            // Asynchronous reset
   input       clk,              // Clock
   input       scan_mode,        // Scan mode
   input       clk_div_ld,       // Clock divider enable from avalon interface
   input       clk_div_1_onehot, // Onehot enable for clock divided by 1
   input       clk_div_2_onehot, // Onehot enable for clock divided by 2
   input       clk_div_4_onehot, // Onehot enable for clock divided by 4
   // Outputs
   output      clk_out,          // Clock divided
   output reg  clk_div_ld_ack_ff // Clock divider load acknowledge
   );

wire clk_div_ld_sync; // Clock divider enable in clk domain
wire clk_div_load;    // Loads clock selection control
wire clk_div2;        // Clock source divided by 2
wire clk_div4;        // Clock source divided by 4
wire clk_div2_b;      // Clock divided by 2 inverted
wire clk_div4_b;      // Clock divided by 4 inverted
wire clk_div1_cg;     // Clock divided by 1 after clock gating
wire clk_div2_cg;     // Clock divided by 2 after clock gating
wire clk_div4_cg;     // Clock divided by 4 after clock gating
wire div1_clk_en;     // DIV1 clock  enable
wire div2_clk_en ;    // DIV2 clock  enable
wire div4_clk_en;     // DIV4 clock  enable

reg  clk_div_1_sel_ff; // Clock divided by 1 selection
reg  clk_div_2_sel_ff; // Clock divided by 2 selection
reg  clk_div_4_sel_ff; // Clock divided by 4 selection

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

// Clock gating for DIV1 clock
clk_gate_cel cg_div_1( .clkout (clk_div1_cg),
                       .clk    (clk),
                       .en     (div1_clk_en),
                       .te     (1'b0)         );

assign div1_clk_en = clk_div_1_sel_ff | scan_mode;
assign div2_clk_en = clk_div_2_sel_ff & ~scan_mode;
assign div4_clk_en = clk_div_4_sel_ff & ~scan_mode;

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

// ORED clock output
clk_or3_cel clk_or3_cel(
.clkout (clk_out),
.clk1 (clk_div1_cg),
.clk2 (clk_div2_cg),
.clk3 (clk_div4_cg)
);

endmodule // aib_clk_div
