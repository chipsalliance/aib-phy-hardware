// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 

//---------------------------------------------------------------------------------------------------------------------------------------------
// aibcr3_dlycell_dll.v 
//---------------------------------------------------------------------------------------------------------------------------------------------
`timescale 1ps/1ps
module aibcr3_dlycell_dll (
input         in_p,
input         bk,
input         ci_p,
output        out_p,
output        co_p,
input         ck,
input         si,
input         SE,
input         RSTb,
output        so
);

`ifdef TIMESCALE_EN
                timeunit 1ps;
                timeprecision 1ps;
`endif

parameter   NAND_DELAY = 20;
/*
wire   tp;
wire   fp;
wire   tn;
wire   fn;

assign #NAND_DELAY co_p  = ~(in_p & bk);
assign #NAND_DELAY tp    = ~(in_p & fp);
assign #NAND_DELAY fp    = ~(tp & bk);
assign #NAND_DELAY out_p = ~(tp & ci_p);
assign #NAND_DELAY co_n  = ~(in_n & bk);
assign #NAND_DELAY tn    = ~(in_n & fn);
assign #NAND_DELAY fn    = ~(tn & bk);
assign #NAND_DELAY out_n = ~(tn & ci_n);
*/

reg    tp;
wire   bk1;

aibcr3_svt16_scdffcdn_cust I316 ( bk1, so, RSTb, ck,
     bk, SE, si);

assign #NAND_DELAY co_p  = ~(in_p & bk1);

always @(*)
  if (~in_p)    tp <= #NAND_DELAY 1'b1;
  else if (~bk1) tp <= #NAND_DELAY 1'b0;

assign #NAND_DELAY out_p = ~(tp & ci_p);


endmodule



