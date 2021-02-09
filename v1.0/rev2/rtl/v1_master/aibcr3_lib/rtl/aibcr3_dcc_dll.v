// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3_lib, Cell - aibcr3_dcc_dll, View - schematic
// LAST TIME SAVED: Aug  9 03:13:12 2016
// NETLIST TIME: Aug 17 15:46:59 2016
`timescale 1ns / 1ns 

module aibcr3_dcc_dll ( clk_dcc, dcc_done, odll_dll2core, odll_lock,
     pvt_ref_half_gry, scan_out, clk_dcd, clk_pll,
     csr_reg, idll_core2dll, idll_entest, nfrzdrv, nrst,
     pipeline_global_en, rb_clkdiv, rb_cont_cal, rb_dcc_byp,
     rb_half_code, rb_selflock, reinit, scan_clk_in, scan_in,
     scan_mode_n, scan_rst_n, scan_shift_n, test_clk_pll_en_n );

output  clk_dcc, dcc_done, odll_lock, scan_out;


input  clk_dcd, clk_pll, idll_entest, nfrzdrv, nrst,
     pipeline_global_en, rb_cont_cal, rb_dcc_byp, rb_half_code,
     rb_selflock, reinit, scan_clk_in, scan_in, scan_mode_n,
     scan_rst_n, scan_shift_n, test_clk_pll_en_n;

output [12:0]  odll_dll2core;
output [10:0]  pvt_ref_half_gry;

input [2:0]  idll_core2dll;
input [2:0]  rb_clkdiv;
input [51:0]  csr_reg;

// Buses in the design

wire  [2:0]  i_gray;

wire  [10:0]  pvt_ref_gry;

wire  [7:0]  f_gray;

wire  [6:0]  gate_shf;

wire dll_phdet_reset_n;
wire launch;

aibcr3_dll_custom I0 ( clk_dcc, dcc_done, so_dll_custom, t_down, t_up,
       clk_dcd, odll_lock, dll_phdet_reset_n, f_gray[7:0],
     i_gray[2:0], launch, measure, nfrzdrv, nrst,
     pvt_ref_half_gry[10:0], rb_cont_cal, rb_dcc_byp, scan_clk_in,
     scan_in, scan_mode_n, scan_rst_n, scan_shift_n);

aibcr3pnr_dll_pnr I1 ( .dll_core(odll_dll2core[12:0]), .dll_lock(odll_lock),
     .dll_phdet_reset_n(dll_phdet_reset_n), .f_gray(f_gray[7:0]), .gate_shf(gate_shf[6:0]), .i_gray(i_gray[2:0]),
     .launch (launch), .measure(measure), .pvt_ref_gry(pvt_ref_gry[10:0]), .pvt_ref_half_gry(pvt_ref_half_gry[10:0]),
     .scan_out(scan_out), .clk_pll(clk_pll), .core_dll(idll_core2dll[2:0]), .csr_reg(csr_reg[51:0]), .entest(idll_entest),
     .pipeline_global_en(pipeline_global_en), .rb_clkdiv(rb_clkdiv[2:0]), .rb_half_code(rb_half_code), .rb_selflock(rb_selflock),
     .reinit(reinit), .scan_clk_in(scan_clk_in), .scan_in(so_dll_custom), .scan_mode_n(scan_mode_n), .scan_rst_n(scan_rst_n),
     .scan_shift_n(scan_shift_n), .t_down(t_down), .t_up(t_up), .test_clk_pll_en_n(test_clk_pll_en_n));

endmodule
