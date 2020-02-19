// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_dcc_dly, View - schematic
// LAST TIME SAVED: Mar 26 07:56:48 2015
// NETLIST TIME: May 12 17:53:11 2015
// `timescale 1ns / 1ns 

module aibnd_dcc_dly ( clkn_dly, clkn_mindly, clkp_dly, clkp_mindly,
     clk_dcd, dll_lock_reg, gray, launch, measure, nfrzdrv, vcc_aibnd,
     vss_aibnd );

output  clkn_dly, clkn_mindly, clkp_dly, clkp_mindly;

input  clk_dcd, dll_lock_reg, launch, measure, nfrzdrv, vcc_aibnd,
     vss_aibnd;

input [9:0]  gray;

wire clkn_dly, net048, clkn_mindly, net050, clkp_mindly, net049, clkp_dly, net047, net033, measure, vss_aibnd, net028, launch, net025, net024, net022, net023; // Conversion Sript Generated


// specify 
//     specparam CDS_LIBNAME  = "aibnd_lib";
//     specparam CDS_CELLNAME = "aibnd_dcc_dly";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

io_nand_delay_line_min  xdelay_min ( //.vcc_io(vcc_aibnd),
     //.vcc_regphy(vcc_aibnd), .vss_io(vss_aibnd), 
     .out_n(net023),
     .out_p(net022), .in_n(clk_split_mindly_n),
     .in_p(clk_split_mindly_p), .nfrzdrv(nfrzdrv));
assign clkn_dly = !net048;
assign clkn_mindly = !net050;
assign clkp_mindly = !net049;
assign clkp_dly = !net047;
io_nand_x128_delay_line  xdelay_line ( .f_gray(gray[9:3]),
     //.vcc_io(vcc_aibnd), .vcc_regphy(vcc_aibnd), .vss_io(vss_aibnd),
     .osc_out_n(net060), .osc_out_p(net061), .out_n(net025),
     .out_p(net024), .i_gray(gray[2:0]), .in_n(clk_split_dlyline_n),
     .in_p(clk_split_dlyline_p), .nfrzdrv(nfrzdrv),
     .osc_in_n(vcc_aibnd), .osc_in_p(vss_aibnd), .osc_mode(vss_aibnd));
io_split_align  xsplit0 ( //.vcc_io(vcc_aibnd), .vss_io(vss_aibnd),
     .dout_n(clk_split_mindly_n), .dout_p(clk_split_mindly_p),
     .din(clkin_mindly));
io_split_align  xsplit1 ( //.vcc_io(vcc_aibnd), .vss_io(vss_aibnd),
     .dout_n(clk_split_dlyline_n), .dout_p(clk_split_dlyline_p),
     .din(clkin_dlyline));
aibnd_dcc_mux xmux11 ( .vcc_aibnd(vcc_aibnd), .vss_aibnd(vss_aibnd),
     .clk0(launch), .s(dll_lock_reg), .clkout(clkin_dlyline),
     .clk1(clk_dcd));
aibnd_dcc_mux xmux10 ( .vcc_aibnd(vcc_aibnd), .vss_aibnd(vss_aibnd),
     .clk0(measure), .s(dll_lock_reg), .clkout(clkin_mindly),
     .clk1(clk_dcd));
assign net033 = !(measure & vss_aibnd);
assign net028 = !(launch & vss_aibnd);
assign net048 = !net025;
assign net047 = !net024;
assign net049 = !net022;
assign net050 = !net023;

endmodule

