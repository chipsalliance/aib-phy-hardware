// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcraux_lib, Cell - aibcraux_osc_clkmux, View - schematic
// LAST TIME SAVED: Jan 27 14:21:48 2015
// NETLIST TIME: Jun  3 17:00:05 2015
// `timescale 1ns / 1ns 

module aibcr3aux_osc_clkmux ( out, vcc_aibcraux, vss_aibcraux, ina, inb,
     sel );

output  out;

inout  vcc_aibcraux, vss_aibcraux;

input  ina, inb, sel;

wire net66, ina, net64, net010, net65, sel, inb, out;


// specify 
//     specparam CDS_LIBNAME  = "aibcraux_lib";
//     specparam CDS_CELLNAME = "aibcraux_osc_clkmux";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

assign net66 = ~(ina & net64);
assign net010 = ~(net66 & net65);
assign net65 = ~(sel & inb);
assign net64 = ~sel;
assign out = net010;

endmodule

