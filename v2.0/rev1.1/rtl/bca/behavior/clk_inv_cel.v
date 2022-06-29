// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.

module clk_inv_cel(
output clkout, // clock output
input  clk     // clock input
);

assign clkout = ~clk;

endmodule // clk_inv_cel
