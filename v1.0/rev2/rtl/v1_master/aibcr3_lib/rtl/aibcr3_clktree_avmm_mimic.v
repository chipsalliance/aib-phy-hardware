// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
// Copyright (c) 2012 Altera Corporation. .
//
//------------------------------------------------------------------------
// File:        $RCSfile: aibcr3_clktree_avmm_mimic.v $
// Date:        $DateTime: 2018/03/12 15:24:07 $
//------------------------------------------------------------------------
// Description: skew-matched clock distribution network
//------------------------------------------------------------------------

module aibcr3_clktree_avmm_mimic 
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
   output wire         lstrbclk_rep, 	        //replica for DLL
   output wire         lstrbclk_mimic0         //mimic path for load matching
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
                assign #SKEW_DELAY lstrbclk_rep = clkin;
                assign #SKEW_DELAY lstrbclk_mimic0 = clkin;

endmodule // aibcr_clktree_avmm_mimic

