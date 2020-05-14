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

module aibcr3_clktree_mimic
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
   output wire         lstrbclk_rep, 	        //replica for DLL
   output wire         lstrbclk_mimic0         //mimic path for load matching
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
    assign #SKEW_DELAY lstrbclk_rep = clkin;
    assign #SKEW_DELAY lstrbclk_mimic0 = clkin;

`else

    wire clk_main, clk_l, clk_r;
    wire [23:0] dummy_out;

    // Process-specific to meet insertion delay
	// Insert your process specific buffer cell here
    bufclkprocspec1x1 buf_main_0 (.clkout(clk_main), .clk(clkin));

    // These mimic buffx1 clock tree loads
    // Input cap of each of these should match that of BUFFX1 istrbclk_in0 input (2.6729fF)
    // Process-specific for now
    bufclkprocspec1x5  dummy_0     (.a(lstrbclk_l_0), .o1(dummy_out[0]));
    bufclkprocspec1x5  dummy_1     (.a(lstrbclk_l_1), .o1(dummy_out[1]));
    bufclkprocspec1x5  dummy_2     (.a(lstrbclk_l_2), .o1(dummy_out[2]));
    bufclkprocspec1x5  dummy_3     (.a(lstrbclk_l_3), .o1(dummy_out[3]));
    bufclkprocspec1x5  dummy_4     (.a(lstrbclk_l_4), .o1(dummy_out[4]));
    bufclkprocspec1x5  dummy_5     (.a(lstrbclk_l_5), .o1(dummy_out[5]));
    bufclkprocspec1x5  dummy_6     (.a(lstrbclk_l_6), .o1(dummy_out[6]));
    bufclkprocspec1x5  dummy_7     (.a(lstrbclk_l_7), .o1(dummy_out[7]));
    bufclkprocspec1x5  dummy_8     (.a(lstrbclk_l_8), .o1(dummy_out[8]));
    bufclkprocspec1x5  dummy_9     (.a(lstrbclk_l_9), .o1(dummy_out[9]));
    bufclkprocspec1x5  dummy_10    (.a(lstrbclk_l_10), .o1(dummy_out[10]));
    bufclkprocspec1x5  dummy_11    (.a(lstrbclk_l_11), .o1(dummy_out[11]));

    bufclkprocspec1x5  dummy_12    (.a(clk_main), .o1(dummy_out[12]));
    bufclkprocspec1x5  dummy_13    (.a(clk_main), .o1(dummy_out[13]));
    bufclkprocspec1x5  dummy_14    (.a(clk_main), .o1(dummy_out[14]));
    bufclkprocspec1x5  dummy_15    (.a(clk_main), .o1(dummy_out[15]));
    bufclkprocspec1x5  dummy_16    (.a(clk_main), .o1(dummy_out[16]));
    bufclkprocspec1x5  dummy_17    (.a(clk_main), .o1(dummy_out[17]));
    bufclkprocspec1x5  dummy_18    (.a(clk_main), .o1(dummy_out[18]));
    bufclkprocspec1x5  dummy_19    (.a(clk_main), .o1(dummy_out[19]));
    bufclkprocspec1x5  dummy_20    (.a(clk_main), .o1(dummy_out[20]));
    bufclkprocspec1x5  dummy_21    (.a(clk_main), .o1(dummy_out[21]));
    bufclkprocspec1x5  dummy_22    (.a(clk_main), .o1(dummy_out[22]));
    bufclkprocspec1x5  dummy_23    (.a(clk_main), .o1(dummy_out[23]));

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
    assign lstrbclk_rep = clk_main;
    assign lstrbclk_mimic0 = clk_main;
`endif

endmodule // aibcr_clktree_mimic


