// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_dll_phdet, View - schematic
// LAST TIME SAVED: Mar 25 07:54:22 2015
// NETLIST TIME: May 12 17:53:10 2015
// `timescale 1ns / 1ns 

module aibnd_dll_phdet ( t_down, t_up, dll_reset_n, i_del_p, phase_clk,
     vcc_io, vss_io );

output  t_down, t_up;

input  dll_reset_n, i_del_p, phase_clk, vcc_io, vss_io;

wire net034, t_down, net021, t_up; // Conversion Sript Generated


// specify 
//     specparam CDS_LIBNAME  = "aibnd_lib";
//     specparam CDS_CELLNAME = "aibnd_dll_phdet";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

assign t_down = net034;
assign t_up = net021;
aibnd_ff_r  xsampling_dn ( .o(net034), .d(phase_clk), .clk(i_del_p) /*`ifndef INTCNOPWR , .vss(vss_io) , .vcc(vcc_io) `endif*/ , .rb(dll_reset_n));
aibnd_ff_r  xsampling_up ( .o(net021), .d(i_del_p), .clk(phase_clk) /*`ifndef INTCNOPWR , .vss(vss_io) , .vcc(vcc_io) `endif*/ , .rb(dll_reset_n));

endmodule

