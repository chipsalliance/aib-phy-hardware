// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_triinv_dig_str, View - schematic
// LAST TIME SAVED: May 19 10:54:10 2015
// NETLIST TIME: May 19 12:48:22 2015
//`timescale 1ns / 1ns 

module aibnd_triinv_dig_str ( dat_out, dat_in, en, enb);

output  dat_out;

input  dat_in, en, enb;

assign vccl_aibnd = 1'b1;
assign vssl_aibnd = 1'b0;

//specify 
//    specparam CDS_LIBNAME  = "aibnd_lib";
//    specparam CDS_CELLNAME = "aibnd_triinv_dig_str";
//    specparam CDS_VIEWNAME = "schematic";
//endspecify

assign dat_out = ((en == 1'b1) & (enb == 1'b0))? ~dat_in : 1'bz;

endmodule
