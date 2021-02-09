// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3_lib, Cell - aibcr3_dcc_top, View - schematic
// LAST TIME SAVED: Aug 16 22:19:29 2016
// NETLIST TIME: Aug 17 15:46:59 2016
`timescale 1ns / 1ns 

module aibcr3_dcc_top ( clk_dcc, dcc_done, odll_dll2core, scan_out,
       clk_dcd, clktree_out, csr_reg, dcc_dft_nrst,
     dcc_dft_nrst_coding, dcc_dft_up, dcc_req, idll_core2dll,
     idll_entest, nfrzdrv, pipeline_global_en, rb_clkdiv, rb_cont_cal,
     rb_dcc_byp, rb_dcc_dft, rb_dcc_dft_sel, rb_dcc_en,
     rb_dcc_manual_dn, rb_dcc_manual_up, rb_half_code, rb_selflock,
     scan_clk_in, scan_in, scan_mode_n, scan_rst_n, scan_shift_n,
     test_clk_pll_en_n );

output  clk_dcc, dcc_done, scan_out;


input  clk_dcd, clktree_out, dcc_dft_nrst, dcc_dft_nrst_coding,
     dcc_dft_up, dcc_req, idll_entest, nfrzdrv, pipeline_global_en,
     rb_cont_cal, rb_dcc_byp, rb_dcc_dft, rb_dcc_dft_sel, rb_dcc_en,
     rb_half_code, rb_selflock, scan_clk_in, scan_in, scan_mode_n,
     scan_rst_n, scan_shift_n, test_clk_pll_en_n;

output [12:0]  odll_dll2core;

input [2:0]  rb_clkdiv;
input [4:0]  rb_dcc_manual_up;
input [4:0]  rb_dcc_manual_dn;
input [51:0]  csr_reg;
input [2:0]  idll_core2dll;

// Buses in the design

wire  [10:0]  pvt_ref_half_gry;

wire  [12:0]  dll2core;

wire so_nrst;
wire net0277;
wire net0274;
wire net0214;
wire buf_rb_dcc_en;
wire dcc_req_mux;
wire dcc_req_synced;
wire odll_lock;
wire buf_rb_dcc_byp;
wire net0275;
wire rb_dcc_byp_b;
wire dcc_done_nonbyp;
wire dcc_done_byp;
wire rb_dcc_en_b;
wire clk_prebuf;
wire net057;
wire dccen_dccreq;
wire net052;
wire clk_mindly_cont;
wire clk_mindly_1time;
wire net054;
wire clk_dly_cont;
wire clk_dly_1time;

assign tieHi = 1'b1;
assign tieLo = 1'b0;
assign so_nrst_dly = so_nrst;
assign net0288 = net0277;
assign scan_clk_in_buf = scan_clk_in;
assign dcc_done = net0274;
assign buf_rb_cont_cal = rb_cont_cal;
assign scan_out = net0214;
assign scan_in_buf = scan_in;
assign scan_mode_n_buf = scan_mode_n;
assign buf_rb_dcc_dft_sel = rb_dcc_dft_sel;
assign scan_rst_n_buf = scan_rst_n;
assign scan_shift_n_buf = scan_shift_n;
assign csr_reg6 = csr_reg[6];
assign nfrzdrv_nrst_b = !(nfrzdrv & buf_rb_dcc_en);
assign net0224 = !(tieLo & tieLo);
assign net0225 = !(tieLo & tieLo);
assign net0276 = !(dcc_req_mux & buf_rb_dcc_en);
assign reinit = !(dcc_req_synced & buf_rb_dcc_en);

assign odll_dll2core[12] = buf_rb_dcc_dft_sel ? tieLo : dll2core[12];
assign odll_dll2core[11] = buf_rb_dcc_dft_sel ? tieLo : dll2core[11];
assign odll_dll2core[10] = buf_rb_dcc_dft_sel ? tieLo : dll2core[10];
assign odll_dll2core[9] = buf_rb_dcc_dft_sel ? tieLo : dll2core[9];
assign odll_dll2core[8] = buf_rb_dcc_dft_sel ? tieLo : dll2core[8];
assign odll_dll2core[7] = buf_rb_dcc_dft_sel ? tieLo : dll2core[7];
assign odll_dll2core[6] = buf_rb_dcc_dft_sel ? tieLo : dll2core[6];
assign odll_dll2core[5] = buf_rb_dcc_dft_sel ? tieLo : dll2core[5];
assign odll_dll2core[4] = buf_rb_dcc_dft_sel ? tieLo : dll2core[4];
assign odll_dll2core[3] = buf_rb_dcc_dft_sel ? tieLo : dll2core[3];
assign odll_dll2core[2] = buf_rb_dcc_dft_sel ? tieLo : dll2core[2];
assign odll_dll2core[1] = buf_rb_dcc_dft_sel ? dcc_done : dll2core[1];
assign odll_dll2core[0] = buf_rb_dcc_dft_sel ? odll_lock : dll2core[0];
assign dll_lock_mux = scan_mode_n_buf ? odll_lock : scan_clk_in_buf;
assign dccen_dccreq_mux = scan_mode_n_buf ? dccen_dccreq : scan_rst_n_buf;
assign net0247 = scan_mode_n_buf ? dcc_req_synced : scan_rst_n; // net0247 was dcc_req_synced_mux in t20
assign net0277 = scan_mode_n_buf ? dcc_req_mux : scan_rst_n_buf;
assign dcc_req_mux = csr_reg6 ? idll_core2dll[2] : dcc_req;
assign dcc_byp_mux = csr_reg6 ? idll_core2dll[1] : buf_rb_dcc_byp;
assign nrst_coding = scan_mode_n_buf ? net0275 : scan_rst_n_buf;
assign net0274 = rb_dcc_byp_b ? dcc_done_nonbyp : dcc_done_byp;
assign net0226 = !tieLo;
assign net0242 = !tieLo;
assign net0228 = !tieLo;
assign net0223 = !tieLo;
assign net0221 = !scan_shift_n_buf;
assign net0248 = !scan_shift_n_buf;    
assign buf_rb_dcc_en = !rb_dcc_en_b;
assign rb_dcc_en_b = !rb_dcc_en;
assign rb_dcc_byp_b = !rb_dcc_byp;
assign buf_rb_dcc_byp = !rb_dcc_byp_b;
assign nfrzdrv_nrst = !nfrzdrv_nrst_b;
assign so_sync = dcc_req_synced;
assign net0227 = !scan_shift_n_buf;
assign dccen_dccreq = !net0276;
assign clk_dcd_buf = clk_dcd;
assign clk_buf0 = clk_prebuf;
assign clk_prebuf = scan_mode_n_buf ? clk_dcd_buf : scan_clk_in_buf;

aibcr3_svt16_scdffcdn_cust I53 (.Q(dcc_done_byp), .scQ(so_dcc_done), .CDN(net0247), .CK(clk_buf0), .D(dcc_req_synced), .SE(net0248), .SI(so_nrst_dly));
aibcr3_svt16_scdffcdn_cust I48 (.Q(net0275), .scQ(so_nrst), .CDN(dccen_dccreq_mux), .CK(dll_lock_mux), .D(tieHi), .SE(net0227), .SI(so_sync));

aibcr3_dcc_dll I82 ( clk_dcc, dcc_done_nonbyp, dll2core[12:0],
     odll_lock, pvt_ref_half_gry[10:0], net0214,  clk_buf0,
     clk_buf0, csr_reg[51:0], idll_core2dll[2:0], idll_entest,
     nfrzdrv_nrst, nrst_coding, pipeline_global_en, rb_clkdiv[2:0],
     buf_rb_cont_cal, dcc_byp_mux, rb_half_code, rb_selflock, reinit,
     scan_clk_in_buf, so_dcc_done, scan_mode_n_buf, scan_rst_n_buf,
     scan_shift_n_buf, test_clk_pll_en_n);


// 2-stage reset synchronization
aibcr3_ulvt16_2xarstsyncdff1_b2 I99 (.CLR_N(net0288), .CK(clk_buf0), .D(tieHi), .SE(net0221), .SI(scan_in_buf), .Q(dcc_req_synced));


endmodule
