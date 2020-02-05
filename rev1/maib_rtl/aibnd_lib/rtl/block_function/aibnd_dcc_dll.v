// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_dcc_dll, View - schematic
// LAST TIME SAVED: Mar 27 14:37:41 2015
// NETLIST TIME: May 12 17:53:11 2015
// `timescale 1ns / 1ns 

module aibnd_dcc_dll ( clk_dcc, dcc_done, odll_dll2core, odll_lock,
     pvt_ref_half_gry, scan_out, clk_dcd, clk_pll, csr_reg,
     idll_core2dll, idll_entest, nfrzdrv, nrst, pipeline_global_en,
     rb_clkdiv, rb_cont_cal, rb_dcc_byp, rb_half_code, rb_selflock,
     reinit, scan_clk_in, scan_in, scan_mode_n, scan_rst_n,
     scan_shift_n, test_clk_pll_en_n, vcc_aibnd, vss_aibnd );

output  clk_dcc, dcc_done, odll_lock, scan_out;

input  clk_dcd, clk_pll, idll_entest, nfrzdrv, nrst,
     pipeline_global_en, rb_cont_cal, rb_dcc_byp, rb_half_code,
     rb_selflock, reinit, scan_clk_in, scan_in, scan_mode_n,
     scan_rst_n, scan_shift_n, test_clk_pll_en_n, vcc_aibnd, vss_aibnd;

output [9:0]  pvt_ref_half_gry;
output [12:0]  odll_dll2core;

input [51:0]  csr_reg;
input [2:0]  rb_clkdiv;
input [2:0]  idll_core2dll;

// Buses in the design

wire  [6:0]  f_gray;

wire  [0:6]  net43;

wire  [9:0]  pvt_ref_gry;

wire  [2:0]  i_gray;


// specify 
//     specparam CDS_LIBNAME  = "aibnd_lib";
//     specparam CDS_CELLNAME = "aibnd_dcc_dll";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

aibnd_dll_custom xdll_custom ( .scan_shift_n(scan_shift_n),
     .rb_cont_cal(rb_cont_cal), .vss_aibnd(vss_aibnd),
     .vcc_aibnd(vcc_aibnd), .dcc_done(dcc_done), .clk_dcd(clk_dcd),
     .rb_dcc_byp(rb_dcc_byp), .scan_out(so_dll_custom),
     .scan_rst_n(scan_rst_n), .scan_mode_n(scan_mode_n),
     .scan_clk_in(scan_clk_in), .dll_lock(odll_lock),
     .scan_in(scan_in), .pvt_ref_half_gry(pvt_ref_half_gry[9:0]),
     .clk_dcc(clk_dcc), .nrst(nrst), .launch(launch),
     .measure(measure), .nfrzdrv(nfrzdrv), .t_down(t_down),
     .t_up(t_up), .dll_reset_n(dll_phdet_reset_n),
     .f_gray(f_gray[6:0]), .i_gray(i_gray[2:0]));
aibndpnr_dll_pnr  xdll_pnr ( .scan_shift_n(scan_shift_n),
     .rb_clkdiv(rb_clkdiv[2:0]), .gate_shf(net43[0:6]),
     .scan_in(so_dll_custom), .scan_rst_n(scan_rst_n),
     .scan_clk_in(scan_clk_in), .scan_mode_n(scan_mode_n),
     .scan_out(scan_out), .pipeline_global_en(pipeline_global_en),
     .dll_lock(odll_lock), .rb_half_code(rb_half_code),
     .pvt_ref_half_gry(pvt_ref_half_gry[9:0]), //.vcc_io(vcc_aibnd),
     //.vss_io(vss_aibnd), 
     .pvt_ref_gry(pvt_ref_gry[9:0]),
     .dll_core(odll_dll2core[12:0]), .i_gray(i_gray[2:0]),
     .f_gray(f_gray[6:0]), .core_dll(idll_core2dll[2:0]),
     .test_clk_pll_en_n(test_clk_pll_en_n),
     .dll_phdet_reset_n(dll_phdet_reset_n), .measure(measure),
     .launch(launch), .t_down(t_down), .t_up(t_up),
     .entest(idll_entest), .reinit(reinit), .csr_reg(csr_reg[51:0]),
     .rb_selflock(rb_selflock), .clk_pll(clk_pll));

endmodule

