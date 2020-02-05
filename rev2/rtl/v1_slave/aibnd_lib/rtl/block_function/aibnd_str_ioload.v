// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_str_ioload, View - schematic
// LAST TIME SAVED: May 19 10:56:07 2015
// NETLIST TIME: May 19 12:48:22 2015
//`timescale 1ns / 1ns 

module aibnd_str_ioload ( inp);

input  inp;

// Buses in the design

wire    net07;

assign vcc_aibnd = 1'b1;
assign vss_aibnd = 1'b0;


//specify 
//    specparam CDS_LIBNAME  = "aibnd_lib";
//    specparam CDS_CELLNAME = "aibnd_str_ioload";
//    specparam CDS_VIEWNAME = "schematic";
//endspecify

assign net07 = ~inp ;

endmodule
