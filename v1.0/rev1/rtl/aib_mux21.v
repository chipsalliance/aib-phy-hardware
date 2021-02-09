// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
// Description: standard 2 to 1 mux
//
//------------------------------------------------------------------------

module aib_mux21
    (
    input  wire              mux_in0,     // mux in 0
    input  wire              mux_in1,     // mux in 1
    input  wire              mux_sel,     // mux selector
    output  wire             mux_out      // mux out
     );

    assign mux_out = mux_sel ? mux_in1 : mux_in0;

endmodule 
