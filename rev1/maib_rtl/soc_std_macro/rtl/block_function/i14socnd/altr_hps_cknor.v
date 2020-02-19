// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//-----------------------------------------------------------------------------
//  Clock OR macro
//-----------------------------------------------------------------------------

module altr_hps_cknor (
    input  wire              nor_in1,     // or input 1
    input  wire              nor_in2,     // or input 2
    output  wire             nor_out      // or output
);

// -------------------
// Port declarations
// -------------------

// -----
// RTL
// -----

`ifdef ALTR_HPS_INTEL_MACROS_OFF
assign nor_out = ~(nor_in1 | nor_in2);

`else


`endif

endmodule
