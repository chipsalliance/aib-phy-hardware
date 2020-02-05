// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_dcc_3bcnt, View - schematic
// LAST TIME SAVED: Jan 14 13:08:14 2015
// NETLIST TIME: Jan 20 13:37:51 2015

module aibnd_dcc_3bcnt ( dir_flip, overflow, ovrflow_check, scan_out,
     vcc_pl, vss_pl, clk, clk_coding, dir, nrst, overflow_opp,
     scan_clk_in, scan_in, scan_mode_n, scan_rst_n );

output  dir_flip, overflow, ovrflow_check, scan_out;

inout  vcc_pl, vss_pl;

input  clk, clk_coding, dir, nrst, overflow_opp, scan_clk_in, scan_in,
     scan_mode_n, scan_rst_n;

wire net095, dly_vcc, nrst, dir_flipb, ovrflow_check, limit_inc, net099, q0b, dir_buf, net063, net0103, net084, q2, net032, net083, dir_flip, overflow, net070, net037, q1, q1b, nrst_dlyed, net040, q2b, net098, net0104, dir, q0, overflow_mux, scan_mode_n, scan_clk_in, overflowb_mux, overflow_opp, nrst_dlyed_mux, scan_rst_n, net0102, net0101, net085, net086; // Conversion Sript Generated



assign net095 = !(dly_vcc & nrst);
assign dir_flipb = !(ovrflow_check & limit_inc);
assign net099 = !(q0b & dir_buf);
assign net063 = !(net0103 & net084);
assign net0103 = !(q2 & dir_buf);
assign net032 = !(net099 & net083);
assign dir_flip = !dir_flipb;
assign overflow = !net070;
assign q0b = !net037;
assign q1 = !q1b;
assign nrst_dlyed = !net095;
assign q1b = !net040;
assign q2b = !net098;
assign q2 = !q2b;
assign net0104 = !dir;
assign q0 = !q0b;
assign dir_buf = !net0104;
aibnd_dcc_ff x163 ( .so(so6), .se_n(scan_mode_n), .si(so5), .q(net064),
     .vcc_pl(vcc_pl), .rb(nrst_dlyed_mux), .clk(clk_coding),
     .d(net046), .vss_pl(vss_pl));
aibnd_dcc_ff x149 ( .so(so7), .se_n(scan_mode_n), .si(so3), .q(net037),
     .vcc_pl(vcc_pl), .rb(nrst_dlyed_mux), .clk(clk), .d(net032),
     .vss_pl(vss_pl));
aibnd_dcc_ff x148 ( .so(so8), .se_n(scan_mode_n), .si(so7), .q(net040),
     .vcc_pl(vcc_pl), .rb(nrst_dlyed_mux), .clk(clk), .d(net0101),
     .vss_pl(vss_pl));
aibnd_dcc_ff x152 ( .so(so2), .se_n(scan_mode_n), .si(so1),
     .q(ovrflow_check), .vcc_pl(vcc_pl), .rb(nrst_dlyed_mux),
     .clk(overflow_mux), .d(dly_vcc), .vss_pl(vss_pl));
aibnd_dcc_ff x153 ( .so(so3), .se_n(scan_mode_n), .si(so2),
     .q(limit_inc), .vcc_pl(vcc_pl), .rb(nrst_dlyed_mux),
     .clk(overflowb_mux), .d(dly_vcc), .vss_pl(vss_pl));
aibnd_dcc_ff x162 ( .so(so5), .se_n(scan_mode_n), .si(so4), .q(net046),
     .vcc_pl(vcc_pl), .rb(nrst_dlyed_mux), .clk(clk_coding),
     .d(net049), .vss_pl(vss_pl));
aibnd_dcc_ff x161 ( .so(so4), .se_n(scan_mode_n), .si(vss_pl),
     .q(net049), .vcc_pl(vcc_pl), .rb(nrst_dlyed_mux),
     .clk(clk_coding), .d(vss_pl), .vss_pl(vss_pl));
aibnd_dcc_ff x147 ( .so(scan_out), .se_n(scan_mode_n), .si(so8),
     .q(net098), .vcc_pl(vcc_pl), .rb(nrst_dlyed_mux), .clk(clk),
     .d(net063), .vss_pl(vss_pl));
aibnd_dcc_ff x151 ( .so(so1), .se_n(scan_mode_n), .si(so0),
     .q(dly_vcc), .vcc_pl(vcc_pl), .rb(nrst), .clk(clk_coding),
     .d(net035), .vss_pl(vss_pl));
aibnd_dcc_ff x150 ( .so(so0), .se_n(scan_mode_n), .si(scan_in),
     .q(net035), .vcc_pl(vcc_pl), .rb(nrst), .clk(clk_coding),
     .d(vcc_pl), .vss_pl(vss_pl));
assign overflow_mux = scan_mode_n ? overflow : scan_clk_in;
assign overflowb_mux = scan_mode_n ? overflow_opp : scan_clk_in;
assign nrst_dlyed_mux = scan_mode_n ? nrst_dlyed : scan_rst_n;
assign net0102 = !(q2 & q1 & dir_buf);
assign net083 = !(q2 & q1 & dir_buf);
assign net0101 = !(net085 & net0102 & net086);
assign net086 = !(q1b & q0 & dir_buf);
assign net085 = !(q1 & q0b & dir_buf);
assign net070 = !(q2 & q1 & q0);
assign net084 = !(q1 & q0 & dir_buf);

endmodule

