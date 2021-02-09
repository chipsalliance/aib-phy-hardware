// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr_lib, Cell - aibcr_clkbuf, View - schematic
// LAST TIME SAVED: Oct  7 17:10:27 2014
// NETLIST TIME: Jan 12 20:09:48 2015

module aibcr3_clkbuf ( out, vcc_pl, vss_pl, in );

output  out;

inout  vcc_pl, vss_pl;

input  in;

// List of primary aliased buses


//FIXIT in CASE 405142:
assign out = ~in;

/*
sa_invg8_ulvt xinv1_1_ ( .vssesa(vss_pl), .vccesa(vcc_pl), .out(out),
     .in(in));
sa_invg8_ulvt xinv1_0_ ( .vssesa(vss_pl), .vccesa(vcc_pl), .out(out),
     .in(in));
*/
endmodule


