// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcraux_lib, Cell - aibcraux_osc_6bcntr, View - schematic
// LAST TIME SAVED: May 19 07:37:11 2015
// NETLIST TIME: Jun  3 17:00:06 2015
// `timescale 1ns / 1ns 

module aibcr3aux_osc_6bcntr ( out_bin, scan_out, vcc_aibcraux,
     vss_aibcraux, clk, cntr, en, reset_n, scan_clk, scan_in,
     scan_mode_n, scan_rst_n, scan_shift_n );

output  scan_out;

inout  vcc_aibcraux, vss_aibcraux;

input  clk, en, reset_n, scan_clk, scan_in, scan_mode_n, scan_rst_n,
     scan_shift_n;

output [5:0]  out_bin;

input [2:0]  cntr;

wire clkin, net77, overflow, net78, en, clk, clkdiv2, net038, net037, scan_out;

// Buses in the design

wire  [5:0]  cnt;
wire so0;
wire so1;


// specify 
//     specparam CDS_LIBNAME  = "aibcraux_lib";
//     specparam CDS_CELLNAME = "aibcraux_osc_6bcntr";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

assign clkin = ~net77;
assign overflow = ~cnt[2];
assign out_bin[5:0] = cnt[5:0];
assign net77 = ~(net78 & en);
assign net78 = cntr[0] ? clkdiv2 : clk;
aibcr3aux_osc_div2_asyn_clr x13 ( .scan_shift_n(scan_shift_n),
     .scan_out(so0), .scan_clk(scan_clk), .scan_in(scan_in),
     .scan_mode_n(scan_mode_n), .scan_rst_n(scan_rst_n),
     .vss_aibcraux(vss_aibcraux), .vcc_aibcraux(vcc_aibcraux),
     .clkout(clkdiv2), .irstb(reset_n), .clkin(clk));
aibcr3aux_osc_3bcntr xbincntr_lsb ( .scan_shift_n(scan_shift_n),
     .scan_out(so1), .scan_clk(scan_clk), .scan_in(so0),
     .scan_mode_n(scan_mode_n), .scan_rst_n(scan_rst_n),
     .vss_aibcraux(vss_aibcraux), .vcc_aibcraux(vcc_aibcraux),
     .bin_cnt(cnt[2:0]), .clk(clkin), .rstb(reset_n));
aibcr3aux_osc_3bcntr xbincntr_msb ( .scan_shift_n(scan_shift_n),
     .scan_out(net037), .scan_clk(scan_clk), .scan_in(so1),
     .scan_mode_n(scan_mode_n), .scan_rst_n(scan_rst_n),
     .vss_aibcraux(vss_aibcraux), .vcc_aibcraux(vcc_aibcraux),
     .bin_cnt(cnt[5:3]), .clk(overflow), .rstb(reset_n));
assign net038 = ~net037;
assign scan_out = ~net038;

endmodule

