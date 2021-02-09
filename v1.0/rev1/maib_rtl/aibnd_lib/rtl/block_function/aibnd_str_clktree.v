// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
//
// Revision:    $Revision: #5 $
// Date:        $DateTime: 2015/07/27 23:57:02 $
//------------------------------------------------------------------------
// Description: skew-matched clock distribution network
//------------------------------------------------------------------------

module aibnd_str_clktree 
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

endmodule // aibnd_str_clktree

