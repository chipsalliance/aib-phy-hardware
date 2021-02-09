// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr_lib, Cell - aibcr_data_buf, View - schematic
// LAST TIME SAVED: May 13 16:50:54 2015
// NETLIST TIME: Jun  3 09:30:55 2015
// `timescale 1ns / 1ns 

module aibcr3_data_buf ( sig_out, sig_in, vcc, vssl );

output  sig_out;

input  sig_in, vcc, vssl;

wire sig_out, sig_in;


// specify 
//     specparam CDS_LIBNAME  = "aibcr_lib";
//     specparam CDS_CELLNAME = "aibcr_data_buf";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

assign sig_out = sig_in;

endmodule

