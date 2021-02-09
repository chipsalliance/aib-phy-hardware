// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 

//---------------------------------------------------------------------------------------------------------------------------------------------
//  aibnd_cmos_nand_x1
//---------------------------------------------------------------------------------------------------------------------------------------------

module aibnd_cmos_nand_x1 (
input         in_p,
input         bk,
input         ci_p,
input         code_valid,
input         ck, nrst, se_n, si,
output        out_p, so,
output        co_p
);

`ifdef TIMESCALE_EN
                timeunit 1ps;
                timeprecision 1ps;
`endif

parameter   NAND_DELAY = 15; //min: 5ps; typ: 10ps; max: 20ps

reg    tp;

aibnd_str_ff xsync ( .se_n(se_n), .so(so), .si(si), .rb(nrst), .code_valid(code_valid), .clk(ck), .d(bk), .q(bk_sync));

assign #NAND_DELAY co_p  = ~(in_p & bk_sync);

always @(*)
  if (~in_p)    tp <= #NAND_DELAY 1'b1;
  else if (~bk_sync) tp <= #NAND_DELAY 1'b0;

assign #NAND_DELAY out_p = ~(tp & ci_p);

endmodule

