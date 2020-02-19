// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr_lib, Cell - aibcr_preclkbuf, View - schematic
// LAST TIME SAVED: Oct 10 10:00:30 2014
// NETLIST TIME: May 14 11:14:35 2015
// `timescale 1ns / 1ns 

module aibcr3_preclkbuf ( out, vcc_pl, vss_pl, in );

output  out;

inout  vcc_pl, vss_pl;

input  in;


// specify 
//     specparam CDS_LIBNAME  = "aibcr_lib";
//     specparam CDS_CELLNAME = "aibcr_preclkbuf";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify


//sa_invg8_ulvt xinv1 ( .vssesa(vss_pl), .vccesa(vcc_pl), .out(out),     .in(in));
assign out = !in;

endmodule

