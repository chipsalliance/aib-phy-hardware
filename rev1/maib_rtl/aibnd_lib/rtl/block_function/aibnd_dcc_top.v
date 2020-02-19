// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_dcc_top, View - schematic
// LAST TIME SAVED: Apr 14 10:39:46 2015
// NETLIST TIME: May 12 17:53:11 2015
// `timescale 1ns / 1ns 

module aibnd_dcc_top ( clk_dcc, dcc_done, odll_dll2core, scan_out,
     clk_dcd, clktree_out, csr_reg, dcc_dft_nrst, dcc_dft_nrst_coding,
     dcc_dft_up, dcc_req, idll_core2dll, idll_entest, nfrzdrv,
     pipeline_global_en, rb_clkdiv, rb_cont_cal, rb_dcc_byp,
     rb_dcc_dft, rb_dcc_dft_sel, rb_dcc_en, rb_dcc_manual_dn,
     rb_dcc_manual_up, rb_half_code, rb_selflock, scan_clk_in, scan_in,
     scan_mode_n, scan_rst_n, scan_shift_n, test_clk_pll_en_n,
     vcc_aibnd, vcc_io, vss_aibnd );

output  clk_dcc, dcc_done, scan_out;

input  clk_dcd, clktree_out, dcc_dft_nrst, dcc_dft_nrst_coding,
     dcc_dft_up, dcc_req, idll_entest, nfrzdrv, pipeline_global_en,
     rb_cont_cal, rb_dcc_byp, rb_dcc_dft, rb_dcc_dft_sel, rb_dcc_en,
     rb_half_code, rb_selflock, scan_clk_in, scan_in, scan_mode_n,
     scan_rst_n, scan_shift_n, test_clk_pll_en_n, vcc_aibnd, vcc_io,
     vss_aibnd;

output [12:0]  odll_dll2core;

input [4:0]  rb_dcc_manual_up;
input [4:0]  rb_dcc_manual_dn;
input [51:0]  csr_reg;
input [2:0]  rb_clkdiv;
input [2:0]  idll_core2dll;

wire net088, nrst_coding, dcc_done, rb_dcc_byp_b, dcc_done_nonbyp, dcc_done_byp, dcc_byp_mux, csr_reg6, buf_rb_dcc_byp, buf_rb_dcc_dft_sel, odll_lock, vss_aibnd, dcc_req_mux, dcc_req, rb_dcc_dft_sel, scan_shift_n, scan_shift_n_buf, clk_dcd, clk_dcd_buf, scan_clk_in, scan_clk_in_buf, net081, net080, scan_in, scan_in_buf, scan_mode_n, scan_mode_n_buf, clk_dcd_mux, clk_buf0, scan_rst_n, scan_rst_n_buf, net96, dll_lock_mux, dccen_dccreq_mux, dccen_dccreq, dcc_req_synced_mux, dcc_req_synced, net61, buf_rb_dcc_en, reinit, nfrzdrv_nrst_b, nfrzdrv, nfrzdrv_nrst, rb_dcc_byp, rb_dcc_en_b, rb_dcc_en; // Conversion Sript Generated

// Buses in the design

wire  [9:0]  pvt_ref_half_gry;

wire  [12:0]  dll2core;


// specify 
//     specparam CDS_LIBNAME  = "aibnd_lib";
//     specparam CDS_CELLNAME = "aibnd_dcc_top";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

assign nrst_coding = net088;
assign dcc_done = rb_dcc_byp_b ? dcc_done_nonbyp : dcc_done_byp;
assign dcc_byp_mux = csr_reg6 ? idll_core2dll[1] : buf_rb_dcc_byp;
assign odll_dll2core[0] = buf_rb_dcc_dft_sel ? odll_lock : dll2core[0];
assign odll_dll2core[1] = buf_rb_dcc_dft_sel ? dcc_done : dll2core[1];
assign odll_dll2core[2] = buf_rb_dcc_dft_sel ? vss_aibnd : dll2core[2];
assign odll_dll2core[4] = buf_rb_dcc_dft_sel ? vss_aibnd : dll2core[4];
assign odll_dll2core[3] = buf_rb_dcc_dft_sel ? vss_aibnd : dll2core[3];
assign odll_dll2core[6] = buf_rb_dcc_dft_sel ? vss_aibnd : dll2core[6];
assign odll_dll2core[5] = buf_rb_dcc_dft_sel ? vss_aibnd : dll2core[5];
assign odll_dll2core[7] = buf_rb_dcc_dft_sel ? vss_aibnd : dll2core[7];
assign odll_dll2core[8] = buf_rb_dcc_dft_sel ? vss_aibnd : dll2core[8];
assign odll_dll2core[10] = buf_rb_dcc_dft_sel ? vss_aibnd : dll2core[10];
assign odll_dll2core[9] = buf_rb_dcc_dft_sel ? vss_aibnd : dll2core[9];
assign dcc_req_mux = csr_reg6 ? idll_core2dll[2] : dcc_req;
assign odll_dll2core[12] = buf_rb_dcc_dft_sel ? vss_aibnd : dll2core[12];
assign odll_dll2core[11] = buf_rb_dcc_dft_sel ? vss_aibnd : dll2core[11];
assign buf_rb_dcc_dft_sel = rb_dcc_dft_sel;
assign scan_shift_n_buf = scan_shift_n;
assign clk_dcd_buf = clk_dcd;
assign scan_clk_in_buf = scan_clk_in;
assign net080 = net081;
assign scan_in_buf = scan_in;
assign scan_mode_n_buf = scan_mode_n;
assign clk_buf0 = clk_dcd_mux;
assign scan_rst_n_buf = scan_rst_n;
assign net088 = scan_mode_n_buf ? net96 : scan_rst_n_buf;
assign dll_lock_mux = scan_mode_n_buf ? odll_lock : scan_clk_in_buf;
assign dccen_dccreq_mux = scan_mode_n_buf ? dccen_dccreq : scan_rst_n_buf;
assign dcc_req_synced_mux = scan_mode_n_buf ? dcc_req_synced : scan_rst_n_buf;
assign clk_dcd_mux = scan_mode_n_buf ? clk_dcd_buf : scan_clk_in_buf;
assign net081 = scan_mode_n_buf ? dcc_req_mux : scan_rst_n_buf;
assign net61 = !(dcc_req_mux & buf_rb_dcc_en);
assign reinit = !(dcc_req_synced & buf_rb_dcc_en);
assign nfrzdrv_nrst_b = !(nfrzdrv & buf_rb_dcc_en);
assign nfrzdrv_nrst = !nfrzdrv_nrst_b;
assign csr_reg6 = csr_reg[6];
assign rb_dcc_byp_b = !rb_dcc_byp;
assign dccen_dccreq = !net61;
assign rb_dcc_en_b = !rb_dcc_en;
assign buf_rb_dcc_en = !rb_dcc_en_b;
assign buf_rb_dcc_byp = !rb_dcc_byp_b;
aibnd_dcc_dll xdll ( .rb_cont_cal(rb_cont_cal), .vcc_aibnd(vcc_aibnd),
     .vss_aibnd(vss_aibnd), .scan_shift_n(scan_shift_n_buf),
     .dcc_done(dcc_done_nonbyp), .rb_dcc_byp(dcc_byp_mux),
     .clk_dcd(clk_buf0), .rb_clkdiv(rb_clkdiv[2:0]),
     .pipeline_global_en(pipeline_global_en), .scan_out(scan_out),
     .scan_mode_n(scan_mode_n_buf), .scan_clk_in(scan_clk_in_buf),
     .scan_rst_n(scan_rst_n_buf), .scan_in(so_dcc_done),
     .nfrzdrv(nfrzdrv_nrst), .clk_dcc(clk_dcc), .nrst(nrst_coding),
     .odll_dll2core(dll2core[12:0]), .odll_lock(odll_lock),
     .pvt_ref_half_gry(pvt_ref_half_gry[9:0]), .clk_pll(clk_buf0),
     .csr_reg(csr_reg[51:0]), .idll_core2dll(idll_core2dll[2:0]),
     .idll_entest(idll_entest), .rb_half_code(rb_half_code),
     .rb_selflock(rb_selflock), .reinit(reinit),
     .test_clk_pll_en_n(test_clk_pll_en_n));
aibnd_2ff_scan  xsync ( .d(vcc_aibnd), .clk(clk_buf0),     .o(dcc_req_synced) /*`ifndef INTCNOPWR , .vcc(vcc_aibnd) `endif*/ , .rb(net080),     .si(scan_in_buf) /*`ifndef INTCNOPWR , .vss(vss_aibnd) `endif*/ , .so(so_sync),     .ssb(scan_shift_n_buf));
aibnd_dcc_ff xff0 ( .vcc_aibnd(vcc_aibnd), .vss_aibnd(vss_aibnd),
     .so(so_nrst), .se_n(scan_shift_n_buf), .q(net96),
     .rb(dccen_dccreq_mux), .clk(dll_lock_mux), .si(so_sync),
     .d(vcc_aibnd));
aibnd_dcc_ff xff1 ( .vcc_aibnd(vcc_aibnd), .vss_aibnd(vss_aibnd),
     .so(so_dcc_done), .se_n(scan_shift_n_buf), .q(dcc_done_byp),
     .rb(dcc_req_synced_mux), .clk(clk_buf0), .si(so_nrst),
     .d(dcc_req_synced));

endmodule

