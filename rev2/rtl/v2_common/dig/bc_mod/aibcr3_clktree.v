// SPDX-License-Identifier: Apache-2.0
// Copyright (c) 2019 Blue Cheetah Analog Design, Inc.
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
// Copyright (c) 2012 Altera Corporation. .
//
//------------------------------------------------------------------------
// Description: skew-matched clock distribution network
//------------------------------------------------------------------------

// Ayar changes: Modified to use custom buffer instantiations
// BC changes:   1. PE: Added back in timescale directive.

`timescale 1ps/1ps
module aibcr3_clktree
#(
parameter SKEW_DELAY     = 60   //min:20ps; typ :60ps; max:100ps
)
(
   input  wire         clkin,                   //clock source
   output wire 	       lstrbclk_l_0, 	        //buffered clock
   output wire         lstrbclk_l_1,            //buffered clock
   output wire         lstrbclk_l_2,            //buffered clock
   output wire         lstrbclk_l_3,            //buffered clock
   output wire         lstrbclk_l_4,            //buffered clock
   output wire         lstrbclk_l_5,            //buffered clock
   output wire         lstrbclk_l_6,            //buffered clock
   output wire         lstrbclk_l_7,            //buffered clock
   output wire         lstrbclk_l_8,            //buffered clock
   output wire         lstrbclk_l_9,            //buffered clock
   output wire         lstrbclk_l_10,           //buffered clock
   output wire         lstrbclk_l_11,           //buffered clock
   output wire         lstrbclk_r_0,            //buffered clock
   output wire         lstrbclk_r_1,            //buffered clock
   output wire         lstrbclk_r_2,            //buffered clock
   output wire         lstrbclk_r_3,            //buffered clock
   output wire         lstrbclk_r_4,            //buffered clock
   output wire         lstrbclk_r_5,            //buffered clock
   output wire         lstrbclk_r_6,            //buffered clock
   output wire         lstrbclk_r_7,            //buffered clock
   output wire         lstrbclk_r_8,            //buffered clock
   output wire         lstrbclk_r_9,            //buffered clock
   output wire         lstrbclk_r_10,           //buffered clock
   output wire         lstrbclk_r_11,           //buffered clock
   output wire         lstrbclk_rep, 	        //replica for DLL
   output wire         lstrbclk_mimic0,         //mimic path for load matching
   output wire         lstrbclk_mimic1,         //mimic path for load matching
   output wire         lstrbclk_mimic2          //mimic path for load matching
);

`ifdef TIMESCALE_EN
  timeunit 1ps;
  timeprecision 1ps;
`endif

`ifdef BEHAVIORAL

    assign #SKEW_DELAY lstrbclk_l_0 = clkin;
    assign #SKEW_DELAY lstrbclk_l_1 = clkin;
    assign #SKEW_DELAY lstrbclk_l_2 = clkin;
    assign #SKEW_DELAY lstrbclk_l_3 = clkin;
    assign #SKEW_DELAY lstrbclk_l_4 = clkin;
    assign #SKEW_DELAY lstrbclk_l_5 = clkin;
    assign #SKEW_DELAY lstrbclk_l_6 = clkin;
    assign #SKEW_DELAY lstrbclk_l_7 = clkin;
    assign #SKEW_DELAY lstrbclk_l_8 = clkin;
    assign #SKEW_DELAY lstrbclk_l_9 = clkin;
    assign #SKEW_DELAY lstrbclk_l_10 = clkin;
    assign #SKEW_DELAY lstrbclk_l_11 = clkin;
    assign #SKEW_DELAY lstrbclk_r_0 = clkin;
    assign #SKEW_DELAY lstrbclk_r_1 = clkin;
    assign #SKEW_DELAY lstrbclk_r_2 = clkin;
    assign #SKEW_DELAY lstrbclk_r_3 = clkin;
    assign #SKEW_DELAY lstrbclk_r_4 = clkin;
    assign #SKEW_DELAY lstrbclk_r_5 = clkin;
    assign #SKEW_DELAY lstrbclk_r_6 = clkin;
    assign #SKEW_DELAY lstrbclk_r_7 = clkin;
    assign #SKEW_DELAY lstrbclk_r_8 = clkin;
    assign #SKEW_DELAY lstrbclk_r_9 = clkin;
    assign #SKEW_DELAY lstrbclk_r_10 = clkin;
    assign #SKEW_DELAY lstrbclk_r_11 = clkin;
    assign #SKEW_DELAY lstrbclk_rep = clkin;
    assign #SKEW_DELAY lstrbclk_mimic0 = clkin;
    assign #SKEW_DELAY lstrbclk_mimic1 = clkin;
    assign #SKEW_DELAY lstrbclk_mimic2 = clkin;

`else

    wire clk_main, clk_l, clk_r;

    // Process-specific to meet insertion delay
	// Insert your process specific buffer cell here
    bufclkprocspec1x1 buf_main_0 (.clkout(clk_main), .clk(clkin));

    assign lstrbclk_l_0 = clk_main;
    assign lstrbclk_l_1 = clk_main;
    assign lstrbclk_l_2 = clk_main;
    assign lstrbclk_l_3 = clk_main;
    assign lstrbclk_l_4 = clk_main;
    assign lstrbclk_l_5 = clk_main;
    assign lstrbclk_l_6 = clk_main;
    assign lstrbclk_l_7 = clk_main;
    assign lstrbclk_l_8 = clk_main;
    assign lstrbclk_l_9 = clk_main;
    assign lstrbclk_l_10 = clk_main;
    assign lstrbclk_l_11 = clk_main;
    assign lstrbclk_r_0 = clk_main;
    assign lstrbclk_r_1 = clk_main;
    assign lstrbclk_r_2 = clk_main;
    assign lstrbclk_r_3 = clk_main;
    assign lstrbclk_r_4 = clk_main;
    assign lstrbclk_r_5 = clk_main;
    assign lstrbclk_r_6 = clk_main;
    assign lstrbclk_r_7 = clk_main;
    assign lstrbclk_r_8 = clk_main;
    assign lstrbclk_r_9 = clk_main;
    assign lstrbclk_r_10 = clk_main;
    assign lstrbclk_r_11 = clk_main;
    assign lstrbclk_rep = clk_main;
    assign lstrbclk_mimic0 = clk_main;
    assign lstrbclk_mimic1 = clk_main;
    assign lstrbclk_mimic2 = clk_main;

`endif

endmodule // aibcr_clktree


