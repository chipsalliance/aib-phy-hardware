// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr_lib, Cell - aibcr_str_ioload, View - schematic
// LAST TIME SAVED: May 13 16:11:12 2015
// NETLIST TIME: May 14 11:14:35 2015
// `timescale 1ns / 1ns 

module aibcr3_str_ioload ( in, vcc, vssl );

input  in, vcc, vssl;

// Buses in the design

wire  net5;


// specify 
//     specparam CDS_LIBNAME  = "aibcr_lib";
//     specparam CDS_CELLNAME = "aibcr_str_ioload";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

assign net5 = ~in ;

endmodule

