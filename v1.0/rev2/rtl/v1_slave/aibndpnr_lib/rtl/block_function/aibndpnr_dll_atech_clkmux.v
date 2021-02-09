// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module aibndpnr_dll_atech_clkmux

// IMPORTANT NOTICE: This clock mux behavioral model
// must be mapped to either a transmission gate mux
// or a pass gate mux in the standard cell library.
// Failure to comply will result in glitch hazards.

(
             input    wire   clk1,
             input    wire   clk2,
             input    wire   s,		// Select
             output   wire   clkout
);

assign clkout = s ? clk1 : clk2;	// 2:1 clock mux

endmodule
