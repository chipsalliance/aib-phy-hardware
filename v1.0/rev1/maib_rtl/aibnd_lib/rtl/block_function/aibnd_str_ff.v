// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_str_ff, View - schematic
// LAST TIME SAVED: Mar 26 07:33:48 2015
// NETLIST TIME: May 12 17:53:10 2015
// `timescale 1ns / 1ns 

module aibnd_str_ff ( q, so, clk, code_valid, d, rb, se_n, si );

output  q, so;

input  clk, code_valid, d, rb, se_n, si;

wire so, q, net010, code_valid, d, net011, se_n, si; // Conversion Sript Generated

assign vcc_aibnd = 1'b1;
assign vss_aibnd = 1'b0;

// specify 
//     specparam CDS_LIBNAME  = "aibnd_lib";
//     specparam CDS_CELLNAME = "aibnd_str_ff";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

assign q = so;
aibnd_ff_r  xreg0 ( .o(so), .d(net011), .clk(clk) /*`ifndef INTCNOPWR , .vss(vss_aibnd) , .vcc(vcc_aibnd) `endif*/ , .rb(rb));
assign net010 = code_valid ? d : so;
assign net011 = se_n ? net010 : si;

endmodule

