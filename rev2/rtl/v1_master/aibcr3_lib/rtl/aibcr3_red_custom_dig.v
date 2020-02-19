// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3_lib, Cell - aibcr3_red_custom_dig, View - schematic
// LAST TIME SAVED: Sep  5 22:36:48 2016
// NETLIST TIME: Sep  8 13:11:45 2016
`timescale 1ns / 1ns 

module aibcr3_red_custom_dig ( anlg_rstb_out, anlg_rstb,
     prev_io_shift_en, shift_en );

output  anlg_rstb_out;

input  anlg_rstb, prev_io_shift_en, shift_en;

wire anlg_rst_nd_out;
wire io_disable_b;

assign anlg_rstb_out = !anlg_rst_nd_out;
assign prev_io_shenb = !prev_io_shift_en;
assign anlg_rst_nd_out = !(io_disable_b & anlg_rstb);
assign io_disable_b = !(prev_io_shenb & shift_en);


endmodule
