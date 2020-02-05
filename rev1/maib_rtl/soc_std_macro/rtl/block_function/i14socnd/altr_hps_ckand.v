// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//-----------------------------------------------------------------------------
//  Clock XOR macro
//-----------------------------------------------------------------------------

module altr_hps_ckand (
    input  wire              and_in1,     // and input 1
    input  wire              and_in2,     // and input 2
    output  wire             and_out      // and output
);

// -------------------
// Port declarations
// -------------------

wire   and_out_n;

// -----
// RTL
// -----

`ifdef ALTR_HPS_INTEL_MACROS_OFF
assign and_out = and_in1 & and_in2;

`else




`endif

endmodule
