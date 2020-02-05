// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//-----------------------------------------------------------------------------
//  Clock OR macro
//-----------------------------------------------------------------------------

module altr_hps_ckor_gate (
    input  wire              or_clk,     // or input 1
    input  wire              or_en,     // or input 2
    output  wire             or_out      // or output
);

// -------------------
// Port declarations
// -------------------

// -----
// RTL
// -----

`ifdef ALTR_HPS_INTEL_MACROS_OFF
assign or_out = or_clk | or_en;

`else



`endif

endmodule
