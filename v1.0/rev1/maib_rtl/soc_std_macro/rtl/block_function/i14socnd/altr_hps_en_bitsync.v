// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module altr_hps_en_bitsync
#(
     parameter DWIDTH = 1,    // Sync Data input
     parameter RESET_VAL = 0  // Reset value
   )
   (
     input               clk,         // clock
     input               rst_n,       // async reset
     input               clk_en,      // clock enable
     input  [DWIDTH-1:0] data_in,     // data in
     output [DWIDTH-1:0] data_out     // data out
   );

wire clk_o;

altr_hps_clkgate clkgate (
  .clk            (clk),
  .clk_enable_i   (clk_en),
  .clk_o          (clk_o)
);

altr_hps_bitsync #(
  .DWIDTH      (DWIDTH),
  .RESET_VAL   (RESET_VAL)
) bitsync (
  .clk         (clk_o),
  .rst_n       (rst_n),
  .data_in     (data_in),
  .data_out    (data_out)
);

endmodule
