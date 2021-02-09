// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcraux_lib, Cell - aibcraux_osc_3bcntr, View - schematic
// LAST TIME SAVED: Mar 13 08:02:23 2015
// NETLIST TIME: Jun  3 17:00:06 2015
// `timescale 1ns / 1ns 

module aibcr3aux_osc_3bcntr ( bin_cnt, scan_out, vcc_aibcraux,
     vss_aibcraux, clk, rstb, scan_clk, scan_in, scan_mode_n,
     scan_rst_n, scan_shift_n );

output  scan_out;

inout  vcc_aibcraux, vss_aibcraux;

input  clk, rstb, scan_clk, scan_in, scan_mode_n, scan_rst_n,
     scan_shift_n;

output [2:0]  bin_cnt;

wire net150, net152, net147, net144, vcc_aibcraux, net065, scanmoden, scanclk, clk, net064, net063, net151, scanshftn, scan_shift_n, scanin, scan_in, scan_mode_n, scanrstn, scan_rst_n, scan_clk, net017, rstb;

// Buses in the design

wire  [2:0]  binary;

wire so0;
wire so1;

// specify 
//     specparam CDS_LIBNAME  = "aibcraux_lib";
//     specparam CDS_CELLNAME = "aibcraux_osc_3bcntr";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

assign net150 = net152 ^ binary[2];
assign net147 = binary[0] ^ binary[1];
assign net144 = vcc_aibcraux ^ binary[0];
assign net065 = scanmoden ? clk : scanclk;
assign net064 = scanmoden ? clk : scanclk;
assign net063 = scanmoden ? clk : scanclk;
assign net152 = ~net151;
assign net151 = ~(binary[1] & binary[0]);
assign scanshftn = scan_shift_n;
assign scanin = scan_in;
assign scanmoden = scan_mode_n;
assign scanrstn = scan_rst_n;
assign scanclk = scan_clk;
assign bin_cnt[2:0] = binary[2:0];
aibcr3aux_osc_ff x8 ( .cdn(net017), .vbb(vss_aibcraux),
     .vss(vss_aibcraux), .vdd(vcc_aibcraux), .vpp(vcc_aibcraux),
     .q(binary[0]), .so(so0), .cp(net064), .d(net144),
     .se_n(scanshftn), .si(scanin));
aibcr3aux_osc_ff x18 ( .cdn(net017), .vbb(vss_aibcraux),
     .vss(vss_aibcraux), .vdd(vcc_aibcraux), .vpp(vcc_aibcraux),
     .q(binary[2]), .so(scan_out), .cp(net065), .d(net150),
     .se_n(scanshftn), .si(so1));
aibcr3aux_osc_ff x16 ( .cdn(net017), .vbb(vss_aibcraux),
     .vss(vss_aibcraux), .vdd(vcc_aibcraux), .vpp(vcc_aibcraux),
     .q(binary[1]), .so(so1), .cp(net063), .d(net147),
     .se_n(scanshftn), .si(so0));
assign net017 = scanmoden ? rstb : scanrstn;

endmodule

