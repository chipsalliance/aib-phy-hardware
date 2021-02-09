// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr_lib, Cell - aibcr_str_ff, View - schematic
// LAST TIME SAVED: Jan 27 19:20:53 2015
// NETLIST TIME: Jan 29 11:11:10 2015

module aibcr3_str_ff ( Q, so , CDN, CP,
     D, code_valid, se_n, si );

output  Q, so;

input  CDN, CP, D, code_valid, se_n, si;

wire Q, so, net030, code_valid, D, net023, se_n, si;

assign Q = so;
assign net030 = code_valid ? D : so;
assign net023 = se_n ? net030 : si;
 aibcr3_ff_r xff0 ( .Q(so), .CDN(CDN), .CP(CP),      .D(net023));

endmodule

