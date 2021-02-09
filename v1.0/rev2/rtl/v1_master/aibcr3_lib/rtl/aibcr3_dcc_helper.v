// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3_lib, Cell - aibcr3_dcc_helper, View - schematic
// LAST TIME SAVED: Aug 17 16:03:51 2016
// NETLIST TIME: Aug 18 17:31:16 2016
`timescale 1ns / 1ns 

module aibcr3_dcc_helper ( ckout, clk_dcd, dcc_byp,
     launch, measure, rstb );

output  ckout;

input  clk_dcd, dcc_byp, launch, measure, rstb;

wire net72;
wire net73;
wire net49;
wire net029;
wire net71;
wire launchb;

assign tieHI = 1'b1;
assign tieLO = 1'b0;
assign net075 = ~rstb;
assign net50 = ~net72;
assign net72 = ~net73;
assign net029 = ~net72;
assign net52 = ~net075;
assign ckout = net49;
assign net71 = net029? measure : launch;
assign net49 = dcc_byp? clk_dcd : net50;
//assign launchb = ~launch;

aibcr3_ulvt16_dffcdn_cust x24 ( .Q(sync1), .CDN(net52), .CK(launch),
     .D(tieHI));
aibcr3_ulvt16_dffcdn_cust x25 ( .Q(sync1out), .CDN(net52), .CK(launch),
     .D(sync1));

aibcr3_ulvt16_dffcdn_cust x23 ( .Q(net73), .CDN(syncrstb), .CK(net71),
     .D(net72));

// 2nd synchronizer
aibcr3_ulvt16_dffcdn_cust x21 ( .Q(net55), .CDN(net52), .CK(launch),
     .D(sync1out));
aibcr3_ulvt16_dffcdn_cust x22 ( .Q(syncrstb), .CDN(net52), .CK(launch),
     .D(net55));



endmodule
