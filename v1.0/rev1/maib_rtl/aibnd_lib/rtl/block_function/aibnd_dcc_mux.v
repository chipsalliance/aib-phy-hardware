// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_dcc_mux, View - schematic
// LAST TIME SAVED: Mar 27 14:37:40 2015
// NETLIST TIME: May 12 17:53:11 2015
// `timescale 1ns / 1ns 

module aibnd_dcc_mux ( clkout, clk0, clk1, s, vcc_aibnd, vss_aibnd );

output  clkout;

input  clk0, clk1, s, vcc_aibnd, vss_aibnd;

wire net011, s, net013, clk1, net012, clk0, clkout; // Conversion Sript Generated


// specify 
//     specparam CDS_LIBNAME  = "aibnd_lib";
//     specparam CDS_CELLNAME = "aibnd_dcc_mux";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

assign net011 = !s;
assign net013 = !(clk1 & s);
assign net012 = !(clk0 & net011);
assign clkout = !(net012 & net013);

endmodule

