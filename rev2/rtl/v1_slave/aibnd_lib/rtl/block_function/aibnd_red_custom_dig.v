// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_red_custom_dig, View - schematic
// LAST TIME SAVED: Apr 22 15:41:59 2015
// NETLIST TIME: May 12 17:53:10 2015
// `timescale 1ns / 1ns 

module aibnd_red_custom_dig ( anlg_rstb_out, anlg_rstb,
     prev_io_shift_en, shift_en, vccl_aibnd, vssl_aibnd );

output  anlg_rstb_out;

input  anlg_rstb, prev_io_shift_en, shift_en, vccl_aibnd, vssl_aibnd;

wire anlg_rstb_out, io_disable_b, anlg_rstb, prev_io_shenb, shift_en, prev_io_shift_en; // Conversion Sript Generated


// specify 
//     specparam CDS_LIBNAME  = "aibnd_lib";
//     specparam CDS_CELLNAME = "aibnd_red_custom_dig";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

assign anlg_rstb_out = io_disable_b & anlg_rstb;
assign io_disable_b = !(prev_io_shenb & shift_en);
assign prev_io_shenb = !prev_io_shift_en;

endmodule

