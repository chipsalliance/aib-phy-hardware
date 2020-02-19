// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_dcc_ctrl, View - schematic
// LAST TIME SAVED: Dec 16 14:23:02 2014
// NETLIST TIME: Dec 17 10:24:04 2014

module aibnd_dcc_ctrl ( dcc_done, dir_dncnt, dir_upcnt, full_dn,
     full_up, init_up, nrst, q0_dn, q0_up, q1_dn, q1_up, q2_dn, q2_up,
     q3_dn, q3_up, q4_dn, q4_up, scan_out, therm_dn, therm_up,
     thermb_dn, thermb_up, vcc_pl, vss_pl, clk, dcc_dft_nrst,
     dcc_dft_nrst_coding, dcc_req, dll_lock, rb_dcc_dft, rb_dcc_en,
     rb_dcc_manual_dn, rb_dcc_manual_mode, rb_dcc_manual_up,
     scan_clk_in, scan_in, scan_mode_n, scan_rst_n, up );

output  dcc_done, dir_dncnt, dir_upcnt, full_dn, full_up, init_up,
     nrst, q0_dn, q0_up, q1_dn, q1_up, q2_dn, q2_up, q3_dn, q3_up,
     q4_dn, q4_up, scan_out;

inout  vcc_pl, vss_pl;

input  clk, dcc_dft_nrst, dcc_dft_nrst_coding, dcc_req, dll_lock,
     rb_dcc_dft, rb_dcc_en, rb_dcc_manual_mode, scan_clk_in, scan_in,
     scan_mode_n, scan_rst_n, up;

output [30:0]  thermb_dn;
output [30:0]  thermb_up;
output [30:0]  therm_up;
output [30:0]  therm_dn;

input [4:0]  rb_dcc_manual_up;
input [4:0]  rb_dcc_manual_dn;



aibnd_dcc_clkrst xclkrst ( .scan_out(so_clkrst),
     .scan_rst_n(scan_rst_n), .scan_mode_n(scan_mode_n),
     .scan_clk_in(scan_clk_in), .scan_in(scan_in),
     .dcc_dft_nrst(dcc_dft_nrst),
     .dcc_dft_nrst_coding(dcc_dft_nrst_coding),
     .rb_dcc_dft(rb_dcc_dft), .nrst(nrst), .nrst_coding(nrst_coding),
     .dll_lock(dll_lock), .dcc_req(dcc_req), .vss_pl(vss_pl),
     .vcc_pl(vcc_pl), .clk_coding(clk_coding), .rb_dcc_en(rb_dcc_en),
     .clk(clk), .dcc_done(dcc_done));
aibnd_dcc_5b_b2tc xb2t_up ( .scan_out(so_b2t_up),
     .scan_mode_n(scan_mode_n), .scan_in(so_5bcnt_dn),
     .nrst_coding(nrst_coding), .rb_dcc_manual(rb_dcc_manual_up[4:0]),
     .q4(q4_up), .clk(clk_coding), .thermb_ff(thermb_up[30:0]),
     .therm_ff(therm_up[30:0]), .q3(q3_up), .vss_pl(vss_pl),
     .vcc_pl(vcc_pl), .q2(q2_up), .q1(q1_up), .q0(q0_up),
     .rb_dcc_manual_mode(rb_dcc_manual_mode));
aibnd_dcc_5b_b2tc xb2t_dn ( .scan_out(scan_out),
     .scan_mode_n(scan_mode_n), .scan_in(so_b2t_up),
     .nrst_coding(nrst_coding), .rb_dcc_manual(rb_dcc_manual_dn[4:0]),
     .q4(q4_dn), .clk(clk_coding), .thermb_ff(thermb_dn[30:0]),
     .therm_ff(therm_dn[30:0]), .q3(q3_dn), .vss_pl(vss_pl),
     .vcc_pl(vcc_pl), .q2(q2_dn), .q1(q1_dn), .q0(q0_dn),
     .rb_dcc_manual_mode(rb_dcc_manual_mode));
aibnd_dcc_5bupcnt x5bcnt_up ( .scan_out(so_5bcnt_up),
     .scan_mode_n(scan_mode_n), .scan_clk_in(scan_clk_in),
     .scan_in(so_fltr), .hold_state(dcc_done), .q4(q4_up), .q3(q3_up),
     .vss_pl(vss_pl), .vcc_pl(vcc_pl), .full(full_up), .q0(q0_up),
     .q1(q1_up), .q2(q2_up), .clk(clk_coding), .dir(dir_upcnt),
     .nrst(nrst_coding));
aibnd_dcc_fltr xfltr ( .scan_out(so_fltr), .scan_rst_n(scan_rst_n),
     .scan_mode_n(scan_mode_n), .scan_clk_in(scan_clk_in),
     .scan_in(so_clkrst), .dcc_req(dcc_req), .init_up(init_up),
     .vss_pl(vss_pl), .vcc_pl(vcc_pl), .dcc_done(dcc_done),
     .dir_dncnt(dir_dncnt), .dir_upcnt(dir_upcnt), .clk(clk),
     .clk_coding(clk_coding), .full_dn(full_dn), .full_up(full_up),
     .nrst_coding(nrst_coding), .rb_dcc_en(rb_dcc_en), .up(up));
aibnd_dcc_5bdncnt x5bcnt_dn ( .scan_out(so_5bcnt_dn),
     .scan_mode_n(scan_mode_n), .scan_clk_in(scan_clk_in),
     .scan_in(so_5bcnt_up), .hold_state(dcc_done), .q4(q4_dn),
     .q3(q3_dn), .vss_pl(vss_pl), .vcc_pl(vcc_pl), .full(full_dn),
     .q0(q0_dn), .q1(q1_dn), .q2(q2_dn), .clk(clk_coding),
     .dir(dir_dncnt), .nrst(nrst_coding));

endmodule

