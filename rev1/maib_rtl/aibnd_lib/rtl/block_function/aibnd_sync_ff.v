// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_sync_ff, View - schematic
// LAST TIME SAVED: Mar 26 07:33:50 2015
// NETLIST TIME: May 12 17:53:10 2015
// `timescale 1ns / 1ns 

module aibnd_sync_ff ( q, so, clk, d, rb, se_n, si, vcc_aibnd,
     vss_aibnd );

output  q, so;

input  clk, d, rb, se_n, si, vcc_aibnd, vss_aibnd;


// specify 
//     specparam CDS_LIBNAME  = "aibnd_lib";
//     specparam CDS_CELLNAME = "aibnd_sync_ff";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

aibnd_2ff_scan  xsync0 ( .d(d), .clk(clk), .o(net016) /*`ifndef INTCNOPWR , .vcc(vcc_aibnd) `endif*/ ,     .rb(rb), .si(si) /*`ifndef INTCNOPWR , .vss(vss_aibnd) `endif*/ , .so(so0), .ssb(se_n));
aibnd_2ff_scan  xsync1 ( .d(net016), .clk(clk), .o(q) /*`ifndef INTCNOPWR , .vcc(vcc_aibnd) `endif*/ ,     .rb(rb), .si(so0) /*`ifndef INTCNOPWR , .vss(vss_aibnd) `endif*/ , .so(so), .ssb(se_n));

endmodule

