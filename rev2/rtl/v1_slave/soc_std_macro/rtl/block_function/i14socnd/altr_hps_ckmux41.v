// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//****************************************************************************************
// Copyright (C) 2011 Altera Corporation. 
//
//****************************************************************************************

//------------------------------------------------------------------------
// Description: standard 4:1 clock mux, built of three 2:1 muxes
//              clk_sel = 00, clk_o = clk_0 
//              clk_sel = 01, clk_o = clk_1 
//              clk_sel = 10, clk_o = clk_2 
//              clk_sel = 11, clk_o = clk_3 
//------------------------------------------------------------------------

module altr_hps_ckmux41
    (
    input  wire              clk_0,     // clock 0
    input  wire              clk_1,     // clock 1
    input  wire              clk_2,     // clock 2
    input  wire              clk_3,     // clock 3
    input  wire  [1:0]       clk_sel,   // clock selector
    output wire              clk_o      // clock out
     );

     wire clk_mux_a;
     wire clk_mux_b;
     
`ifdef ALTR_HPS_INTEL_MACROS_OFF
    assign clk_mux_a = clk_sel[0] ? clk_1 : clk_0;
    assign clk_mux_b = clk_sel[0] ? clk_3 : clk_2;
    
    assign clk_o     = clk_sel[1] ? clk_mux_b : clk_mux_a;
`else

`endif

endmodule // altr_hps_ckmux41
