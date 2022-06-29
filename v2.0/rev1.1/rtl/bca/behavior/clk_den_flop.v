// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.

module clk_den_flop(
input      clk, // clock
input      d,   // data input
input      den, // data enable
input      rb,  // Active low reset
output reg o    // data output
);

// Flop with data enable
always @(posedge clk or negedge rb)
  begin: o_register
    if(!rb)
      o <= 1'b0;
    else if(den)
      o <= d;
  end // block: o_register

endmodule // clk_den_flop

