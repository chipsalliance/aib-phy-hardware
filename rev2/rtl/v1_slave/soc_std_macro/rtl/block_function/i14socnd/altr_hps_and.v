// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//****************************************************************************************
// Copyright (C) 2011 Altera Corporation. .
//
//****************************************************************************************

//------------------------------------------------------------------------
// Description: standard and gate
//
//------------------------------------------------------------------------

module altr_hps_and
    (
    input  wire              and_in1,     // and input 1
    input  wire              and_in2,     // and input 2
    output  wire             and_out      // and output
     );

`ifdef ALTR_HPS_INTEL_MACROS_OFF
    assign and_out = and_in1 & and_in2;
`else

`endif

endmodule // altr_hps_and
