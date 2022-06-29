// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.

module clk_and3_cel(
output clkout, // AND output
input  clk1, // clock 1
input  clk2,  // clock 2
input  clk3  // clock 3
);

assign clkout = clk1 & clk2 & clk3;

endmodule // clk_and3_cel
