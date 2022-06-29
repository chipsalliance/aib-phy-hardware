// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.


module clk_or3_cel(
output clkout, // OR output
input  clk1, // clock 1
input  clk2, // clock 2
input  clk3  // clock 3
);

wire clkout_1_2;
wire clkout_3;

// First OR level for clk1 and clk2
clk_or2_cel clk_or2_1(
.clkout (clkout_1_2), // OR output
.clk1   (clk1),       // clock 1
.clk2   (clk2)        // clock 2
);

// First OR level for clk3
clk_or2_cel clk_or2_2(
.clkout (clkout_3), // OR output
.clk1   (clk3),     // clock 1
.clk2   (1'b0)      // clock 2
);

// Second OR level for clk1, clk2 and clk3
clk_or2_cel clk_or2_3(
.clkout (clkout),      // OR output
.clk1   (clkout_1_2),  // clock 1
.clk2   (clkout_3)     // clock 2
);

endmodule // clk_or3_cel
