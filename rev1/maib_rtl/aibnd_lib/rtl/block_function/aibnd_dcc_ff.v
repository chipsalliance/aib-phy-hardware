// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_dcc_ff, View - schematic
// LAST TIME SAVED: Mar 27 14:37:41 2015
// NETLIST TIME: May 12 17:53:11 2015
// `timescale 1ns / 1ns 

module aibnd_dcc_ff ( q, so, clk, d, rb, se_n, si, vcc_aibnd, vss_aibnd
     );

output  q, so;

input  clk, d, rb, se_n, si, vcc_aibnd, vss_aibnd;

wire so, q, net011, se_n, d, si; // Conversion Sript Generated


// specify 
//     specparam CDS_LIBNAME  = "aibnd_lib";
//     specparam CDS_CELLNAME = "aibnd_dcc_ff";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

assign so = q;
aibnd_ff_r  xreg0 ( .o(q), .d(net011), .clk(clk) /*`ifndef INTCNOPWR , .vss(vss_aibnd) , .vcc(vcc_aibnd) `endif*/ , .rb(rb));
assign net011 = se_n ? d : si;

endmodule

