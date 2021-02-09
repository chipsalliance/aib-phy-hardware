// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//****************************************************************************************
// © 2011 Altera Corporation. 
//
//****************************************************************************************

//------------------------------------------------------------------------
// Description: standard 4 to 1 mux
//
//------------------------------------------------------------------------

module altr_hps_mux41
    (
    input  wire              mux_in0,     // mux in 0
    input  wire              mux_in1,     // mux in 1
    input  wire              mux_in2,     // mux in 1
    input  wire              mux_in3,     // mux in 1
    input  wire [1:0]        mux_sel,     // mux selector
    output wire             mux_out      // mux out
     );

`ifdef ALTR_HPS_INTEL_MACROS_OFF
    assign mux_out = mux_sel[1] ? 
            mux_sel[0] ? mux_in3 : mux_in2 :
            mux_sel[0] ? mux_in1 : mux_in0;
`else
`endif

endmodule // altr_hps_mux41
