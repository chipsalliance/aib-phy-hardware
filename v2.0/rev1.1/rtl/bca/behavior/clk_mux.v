// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.

module clk_mux(
// Inputs
input clk1, // Clock 1 input
input clk2, // Clock 2 input
input s,    // Clock selection: 1 - clkout = clk1
            //                  0 - clkout = clk2
// Outputs
output clkout // Clock output 
);

// Clock mux
assign clkout = s ? clk1 : clk2;

endmodule // clk_mux
