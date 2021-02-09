// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 

//---------------------------------------------------------------------------------------------------------------------------------------------
//  aibcr_cmos_nand_x1
//---------------------------------------------------------------------------------------------------------------------------------------------



module aibcr3_cmos_nand_x1 (
input  bk, ci_p, ck, in_p, nrst, se_n, si, code_valid,
output  co_p, out_p, so
);

`ifdef TIMESCALE_EN
                timeunit 1ps;
                timeprecision 1ps;
`endif

wire bk_sync;


parameter   NAND_DELAY = 15; //min: 5ps; typ: 7ps; max: 15ps

reg    tp;

aibcr3_str_ff xreg0 ( .se_n(se_n), .so(so), .si(si), .CDN(nrst), .CP(ck), .D(bk), .code_valid(code_valid), .Q(bk_sync));

assign #NAND_DELAY co_p  = ~(in_p & bk_sync);

always @(*)
  if (~in_p)    tp <= #NAND_DELAY 1'b1;
  else if (~bk_sync) tp <= #NAND_DELAY 1'b0;

assign #NAND_DELAY out_p = ~(tp & ci_p);

endmodule



