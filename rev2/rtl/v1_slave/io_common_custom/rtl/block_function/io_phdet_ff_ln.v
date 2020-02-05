// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module io_phdet_ff_ln (dp, dn, clk_p, rst_n, q);
input  dp, dn, clk_p, rst_n;
output q;
reg    q;

always @(posedge clk_p or negedge rst_n)
  if (~rst_n)           q <= 1'b0;
  else                  q <= dp;

endmodule // io_phdet_ff_ln

