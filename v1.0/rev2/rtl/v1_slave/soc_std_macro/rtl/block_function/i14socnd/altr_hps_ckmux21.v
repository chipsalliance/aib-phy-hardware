// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//****************************************************************************************
// Copyright (C) 2011 Altera Corporation. .
//
//****************************************************************************************

//------------------------------------------------------------------------
// Description: standard clock mux
//
//------------------------------------------------------------------------

module altr_hps_ckmux21
    (
    input  wire              clk_0,     // clock 0
    input  wire              clk_1,     // clock 1
    input  wire              clk_sel,   // clock selector
    output  wire             clk_o      // clock out
     );

`ifdef ALTR_HPS_INTEL_MACROS_OFF
    assign clk_o = clk_sel ? clk_1 : clk_0;
`else

`endif

endmodule // altr_hps_ckmux21
