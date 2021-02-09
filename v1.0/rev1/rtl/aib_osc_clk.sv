// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// ==========================================================================
//
// Module name    : aib_osc_clk
// Description    : Behavioral model of free running clock in aux
// Revision       : 1.0
// ============================================================================
`timescale 1ps/1fs
module aib_osc_clk (
		    output logic osc_clk
                   ); 
initial  osc_clk = 1'b0;
always #(500)       osc_clk = ~osc_clk;

endmodule // aib_osc_clk
