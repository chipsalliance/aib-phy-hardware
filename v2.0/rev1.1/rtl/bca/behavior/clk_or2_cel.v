// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.

module clk_or2_cel(
output clkout, // OR output
input  clk1, // clock 1
input  clk2  // clock 2
);

assign clkout = clk1 | clk2;

endmodule // clk_or2_cel
