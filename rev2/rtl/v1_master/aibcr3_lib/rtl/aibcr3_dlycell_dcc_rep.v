// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3_lib, Cell - aibcr3_dlycell_dcc, View - schematic
// LAST TIME SAVED: Aug  6 23:29:22 2016
// NETLIST TIME: Aug 17 15:46:58 2016
`timescale 1ps / 1ps 

module aibcr3_dlycell_dcc_rep ( co_p, out_p, bk, ci_p, in_p );

`ifdef TIMESCALE_EN
                timeunit 1ps;
                timeprecision 1ps;
`endif

output  co_p, out_p;

input  bk, ci_p, in_p;

wire bkbl;

parameter   BUF_DELAY = 20;

assign net0150 = ~in_p;
assign bkb     = ! bk;
assign net0173 = ! (net0150 & bk);
assign net0174 = ! (net0150 & bkb);
assign bkl     = ! (net0173 & bkbl);
assign bkbl    = ! (net0174 & bkl);

assign #BUF_DELAY co_p = bkl? in_p : 1'b0;
assign #BUF_DELAY out_p = bkl? ci_p : in_p;

endmodule
