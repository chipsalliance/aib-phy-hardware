// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_dll_custom, View - schematic
// LAST TIME SAVED: Mar 27 14:37:40 2015
// NETLIST TIME: May 12 17:53:11 2015
// `timescale 1ns / 1ns 

module aibnd_dll_custom ( clk_dcc, dcc_done, scan_out, t_down, t_up,
     clk_dcd, dll_lock, dll_reset_n, f_gray, i_gray, launch, measure,
     nfrzdrv, nrst, pvt_ref_half_gry, rb_cont_cal, rb_dcc_byp,
     scan_clk_in, scan_in, scan_mode_n, scan_rst_n, scan_shift_n,
     vcc_aibnd, vss_aibnd );

output  clk_dcc, dcc_done, scan_out, t_down, t_up;

input  clk_dcd, dll_lock, dll_reset_n, launch, measure, nfrzdrv, nrst,
     rb_cont_cal, rb_dcc_byp, scan_clk_in, scan_in, scan_mode_n,
     scan_rst_n, scan_shift_n, vcc_aibnd, vss_aibnd;

input [2:0]  i_gray;
input [6:0]  f_gray;
input [9:0]  pvt_ref_half_gry;

wire dll_lock_reg, rb_cont_cal, vss_aibnd, dll_lock_reg_premux, net080, scan_mode_n, net0109, scan_rst_n, net081, net075, scan_clk_in, dll_lock_reg_prebuf, dll_lock_mux, dll_reset_n_mux, clk_dcd, clk_dcd_buf; // Conversion Sript Generated

// Buses in the design

wire  [9:0]  gray;

wire  [9:0]  pvt_ref_half_gry_ff;


// specify 
//     specparam CDS_LIBNAME  = "aibnd_lib";
//     specparam CDS_CELLNAME = "aibnd_dll_custom";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

assign gray[0] = dll_lock_reg ? pvt_ref_half_gry_ff[0] : i_gray[0];
assign gray[1] = dll_lock_reg ? pvt_ref_half_gry_ff[1] : i_gray[1];
assign dll_lock_reg = rb_cont_cal ? vss_aibnd : dll_lock_reg_premux;
assign gray[9] = dll_lock_reg ? pvt_ref_half_gry_ff[9] : f_gray[6];
assign gray[8] = dll_lock_reg ? pvt_ref_half_gry_ff[8] : f_gray[5];
assign gray[7] = dll_lock_reg ? pvt_ref_half_gry_ff[7] : f_gray[4];
assign gray[6] = dll_lock_reg ? pvt_ref_half_gry_ff[6] : f_gray[3];
assign gray[3] = dll_lock_reg ? pvt_ref_half_gry_ff[3] : f_gray[0];
assign gray[2] = dll_lock_reg ? pvt_ref_half_gry_ff[2] : i_gray[2];
assign gray[4] = dll_lock_reg ? pvt_ref_half_gry_ff[4] : f_gray[1];
assign gray[5] = dll_lock_reg ? pvt_ref_half_gry_ff[5] : f_gray[2];
aibnd_dcc_dly xdly1 ( .vss_aibnd(vss_aibnd), .vcc_aibnd(vcc_aibnd),
     .clkp_mindly(clkp_mindly_cont), .clkn_mindly(clkn_mindly_cont),
     .clkp_dly(clkp_dly_cont), .clkn_dly(clkn_dly_cont),
     .launch(vss_aibnd), .measure(vss_aibnd), .clk_dcd(clk_dcd_buf),
     .nfrzdrv(nfrzdrv), .dll_lock_reg(rb_cont_cal),
     .gray(pvt_ref_half_gry_ff[9:0]));
aibnd_dcc_dly xdly0 ( .vss_aibnd(vss_aibnd), .vcc_aibnd(vcc_aibnd),
     .clkp_mindly(clkp_mindly_1time), .clkn_mindly(clkn_mindly_1time),
     .clkp_dly(clkp_dly_1time), .clkn_dly(clkn_dly_1time),
     .launch(launch), .measure(measure), .clk_dcd(clk_dcd_buf),
     .nfrzdrv(nfrzdrv), .dll_lock_reg(dll_lock_reg), .gray(gray[9:0]));
io_dll_phdet  xdll_phdet ( //.vcc_io(vcc_aibnd), .vss_io(vss_aibnd),
     .t_down(t_down), .t_up(t_up), .dll_reset_n(dll_reset_n),
     .i_del_n(clkn_dly_1time), .i_del_p(clkp_dly_1time),
     .phase_clk(clkp_mindly_1time), .phase_clkb(clkn_mindly_1time));
io_dll_phdet  xdll_phdet_load ( //.vcc_io(vcc_aibnd), .vss_io(vss_aibnd),
     .t_down(net092), .t_up(net091), .dll_reset_n(vss_aibnd),
     .i_del_n(clkn_dly_cont), .i_del_p(clkp_dly_cont),
     .phase_clk(clkp_mindly_cont), .phase_clkb(clkn_mindly_cont));
aibnd_dcc_mux gmx10 ( .clk0(clkn_dly_1time), .s(rb_cont_cal),
     .vcc_aibnd(vcc_aibnd), .vss_aibnd(vss_aibnd), .clkout(clkn_dly),
     .clk1(clkn_dly_cont));
aibnd_dcc_mux gmx9 ( .clk0(clkp_dly_1time), .s(rb_cont_cal),
     .vcc_aibnd(vcc_aibnd), .vss_aibnd(vss_aibnd), .clkout(clkp_dly),
     .clk1(clkp_dly_cont));
aibnd_dcc_mux gmx8 ( .clk0(clkn_mindly_1time), .s(rb_cont_cal),
     .vcc_aibnd(vcc_aibnd), .vss_aibnd(vss_aibnd),
     .clkout(clkn_mindly), .clk1(clkn_mindly_cont));
aibnd_dcc_mux gmx7 ( .clk0(clkp_mindly_1time), .s(rb_cont_cal),
     .vcc_aibnd(vcc_aibnd), .vss_aibnd(vss_aibnd),
     .clkout(clkp_mindly), .clk1(clkp_mindly_cont));
aibnd_dcc_mux gmx11 ( .clk0(dll_lock), .s(rb_cont_cal),
     .vcc_aibnd(vcc_aibnd), .vss_aibnd(vss_aibnd), .clkout(net075),
     .clk1(clk_dcd));
aibnd_dcc_mux gmx12 ( .clk0(dll_reset_n), .s(rb_cont_cal),
     .vcc_aibnd(vcc_aibnd), .vss_aibnd(vss_aibnd), .clkout(net0109),
     .clk1(dll_lock));
assign net080 = scan_mode_n ? net0109 : scan_rst_n;
assign net081 = scan_mode_n ? net075 : scan_clk_in;
aibnd_dcc_ff xff12 ( .vcc_aibnd(vcc_aibnd), .vss_aibnd(vss_aibnd),
     .so(net119), .se_n(scan_shift_n), .q(net118),
     .rb(dll_reset_n_mux), .clk(clk_dcd), .si(net111), .d(net112));
aibnd_dcc_ff xff11 ( .vcc_aibnd(vcc_aibnd), .vss_aibnd(vss_aibnd),
     .so(net111), .se_n(scan_shift_n), .q(net112),
     .rb(dll_reset_n_mux), .clk(clk_dcd), .si(so0aa),
     .d(dll_lock_reg_prebuf));
aibnd_dcc_ff xff10 ( .vcc_aibnd(vcc_aibnd), .vss_aibnd(vss_aibnd),
     .so(so0aa), .se_n(scan_shift_n), .q(dll_lock_reg_prebuf),
     .rb(dll_reset_n_mux), .clk(dll_lock_mux), .si(scan_in),
     .d(vcc_aibnd));
aibnd_dcc_ff xff13 ( .vcc_aibnd(vcc_aibnd), .vss_aibnd(vss_aibnd),
     .so(net115), .se_n(scan_shift_n), .q(net114),
     .rb(dll_reset_n_mux), .clk(clk_dcd), .si(net119), .d(net118));
aibnd_dcc_ff xff0 ( .vcc_aibnd(vcc_aibnd), .vss_aibnd(vss_aibnd),
     .so(so0), .se_n(scan_shift_n), .si(so0a),
     .q(pvt_ref_half_gry_ff[0]), .rb(dll_reset_n_mux),
     .clk(dll_lock_mux), .d(pvt_ref_half_gry[0]));
aibnd_dcc_ff xff1 ( .vcc_aibnd(vcc_aibnd), .vss_aibnd(vss_aibnd),
     .so(so1), .se_n(scan_shift_n), .si(so0),
     .q(pvt_ref_half_gry_ff[1]), .rb(dll_reset_n_mux),
     .clk(dll_lock_mux), .d(pvt_ref_half_gry[1]));
aibnd_dcc_ff xff2 ( .vcc_aibnd(vcc_aibnd), .vss_aibnd(vss_aibnd),
     .so(so2), .se_n(scan_shift_n), .si(so1),
     .q(pvt_ref_half_gry_ff[2]), .rb(dll_reset_n_mux),
     .clk(dll_lock_mux), .d(pvt_ref_half_gry[2]));
aibnd_dcc_ff xff15 ( .vcc_aibnd(vcc_aibnd), .so(net0113),
     .se_n(scan_shift_n), .q(net0112), .vss_aibnd(vss_aibnd),
     .rb(dll_reset_n_mux), .clk(clk_dcd), .si(net098), .d(net097));
aibnd_dcc_ff xff8 ( .vcc_aibnd(vcc_aibnd), .vss_aibnd(vss_aibnd),
     .so(so8), .se_n(scan_shift_n), .si(so7),
     .q(pvt_ref_half_gry_ff[8]), .rb(dll_reset_n_mux),
     .clk(dll_lock_mux), .d(pvt_ref_half_gry[8]));
aibnd_dcc_ff xff4 ( .vcc_aibnd(vcc_aibnd), .vss_aibnd(vss_aibnd),
     .so(so4), .se_n(scan_shift_n), .si(so3),
     .q(pvt_ref_half_gry_ff[4]), .rb(dll_reset_n_mux),
     .clk(dll_lock_mux), .d(pvt_ref_half_gry[4]));
aibnd_dcc_ff xff16 ( .vcc_aibnd(vcc_aibnd), .so(net127),
     .se_n(scan_shift_n), .q(net126), .vss_aibnd(vss_aibnd),
     .rb(dll_reset_n_mux), .clk(clk_dcd), .si(net0113), .d(net0112));
aibnd_dcc_ff xff18 ( .vcc_aibnd(vcc_aibnd), .vss_aibnd(vss_aibnd),
     .so(so0a), .se_n(scan_shift_n), .q(dcc_done),
     .rb(dll_reset_n_mux), .clk(clk_dcd), .si(net0126), .d(net0108));
aibnd_dcc_ff xff3 ( .vcc_aibnd(vcc_aibnd), .vss_aibnd(vss_aibnd),
     .so(so3), .se_n(scan_shift_n), .si(so2),
     .q(pvt_ref_half_gry_ff[3]), .rb(dll_reset_n_mux),
     .clk(dll_lock_mux), .d(pvt_ref_half_gry[3]));
aibnd_dcc_ff xff17 ( .vcc_aibnd(vcc_aibnd), .so(net0126),
     .se_n(scan_shift_n), .q(net0108), .vss_aibnd(vss_aibnd),
     .rb(dll_reset_n_mux), .clk(clk_dcd), .si(net127), .d(net126));
aibnd_dcc_ff xff9 ( .vcc_aibnd(vcc_aibnd), .vss_aibnd(vss_aibnd),
     .so(scan_out), .se_n(scan_shift_n), .si(so8),
     .q(pvt_ref_half_gry_ff[9]), .rb(dll_reset_n_mux),
     .clk(dll_lock_mux), .d(pvt_ref_half_gry[9]));
aibnd_dcc_ff xff14 ( .vcc_aibnd(vcc_aibnd), .vss_aibnd(vss_aibnd),
     .so(net098), .se_n(scan_shift_n), .q(net097),
     .rb(dll_reset_n_mux), .clk(clk_dcd), .si(net115), .d(net114));
aibnd_dcc_ff xff5 ( .vcc_aibnd(vcc_aibnd), .vss_aibnd(vss_aibnd),
     .so(so5), .se_n(scan_shift_n), .si(so4),
     .q(pvt_ref_half_gry_ff[5]), .rb(dll_reset_n_mux),
     .clk(dll_lock_mux), .d(pvt_ref_half_gry[5]));
aibnd_dcc_ff xff6 ( .vcc_aibnd(vcc_aibnd), .vss_aibnd(vss_aibnd),
     .so(so6), .se_n(scan_shift_n), .si(so5),
     .q(pvt_ref_half_gry_ff[6]), .rb(dll_reset_n_mux),
     .clk(dll_lock_mux), .d(pvt_ref_half_gry[6]));
aibnd_dcc_ff xff7 ( .vcc_aibnd(vcc_aibnd), .vss_aibnd(vss_aibnd),
     .so(so7), .se_n(scan_shift_n), .si(so6),
     .q(pvt_ref_half_gry_ff[7]), .rb(dll_reset_n_mux),
     .clk(dll_lock_mux), .d(pvt_ref_half_gry[7]));
assign dll_lock_reg_premux = dll_lock_reg_prebuf;
assign dll_lock_mux = net081;
assign dll_reset_n_mux = net080;
assign clk_dcd_buf = clk_dcd;
aibnd_dcc_helper xdcc_helper ( .launchb(clkn_mindly),
     .measureb(clkn_dly), .vcc_io(vcc_aibnd), .dcc_byp(rb_dcc_byp),
     .clk_dcd(clk_dcd), .vss_io(vss_aibnd), .clkout(clk_dcc),
     .launch(clkp_mindly), .measure(clkp_dly), .rstb(nrst));

endmodule

