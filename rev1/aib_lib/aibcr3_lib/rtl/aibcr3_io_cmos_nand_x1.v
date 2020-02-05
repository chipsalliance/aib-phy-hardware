// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 

//---------------------------------------------------------------------------------------------------------------------------------------------
//  aibcr_io_cmos_nand_x1
//---------------------------------------------------------------------------------------------------------------------------------------------

module aibcr3_io_cmos_nand_x1 (
input         in_p,
input         in_n,
input         bk,
input         ci_p,
input         ci_n,
output        out_p,
output        out_n,
output        co_p,
output        co_n
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
reg    tn;

assign #NAND_DELAY co_p  = ~(in_p & bk);

always @(*)
  if (~in_p)    tp <= #NAND_DELAY 1'b1;
  else if (~bk) tp <= #NAND_DELAY 1'b0;

assign #NAND_DELAY out_p = ~(tp & ci_p);

assign #NAND_DELAY co_n  = ~(in_n & bk);

always @(*)
  if (~in_n)    tn <= #NAND_DELAY 1'b1;
  else if (~bk) tn <= #NAND_DELAY 1'b0;

assign #NAND_DELAY out_n = ~(tn & ci_n);

endmodule



