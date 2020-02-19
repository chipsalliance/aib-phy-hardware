// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_str_align, View - schematic
// LAST TIME SAVED: May  7 14:46:58 2015
// NETLIST TIME: May 12 17:53:11 2015
// `timescale 1ns / 1ns 

module aibnd_str_align ( lstrbclk_l_0, lstrbclk_l_1, lstrbclk_l_2,
     lstrbclk_l_3, lstrbclk_l_4, lstrbclk_l_5, lstrbclk_l_6,
     lstrbclk_l_7, lstrbclk_l_8, lstrbclk_l_9, lstrbclk_l_10,
     lstrbclk_l_11, lstrbclk_r_0, lstrbclk_r_1, lstrbclk_r_2,
     lstrbclk_r_3, lstrbclk_r_4, lstrbclk_r_5, lstrbclk_r_6,
     lstrbclk_r_7, lstrbclk_r_8, lstrbclk_r_9, lstrbclk_r_10,
     lstrbclk_r_11, odll_dll2core_str, odll_lock, scan_out,
     csr_reg_str, idll_core2dll_str, idll_entest_str, idll_lock_req,
     pipeline_global_en, rb_clkdiv_str, rb_half_code_str,
     rb_selflock_str, ref_clk_n, ref_clk_p, scan_clk_in, scan_in,
     scan_mode_n, scan_rst_n, scan_shift_n, test_clk_pll_en_n,
     vcc_aibnd, vcc_io, vss_aibnd );

output  lstrbclk_l_0, lstrbclk_l_1, lstrbclk_l_2, lstrbclk_l_3,
     lstrbclk_l_4, lstrbclk_l_5, lstrbclk_l_6, lstrbclk_l_7,
     lstrbclk_l_8, lstrbclk_l_9, lstrbclk_l_10, lstrbclk_l_11,
     lstrbclk_r_0, lstrbclk_r_1, lstrbclk_r_2, lstrbclk_r_3,
     lstrbclk_r_4, lstrbclk_r_5, lstrbclk_r_6, lstrbclk_r_7,
     lstrbclk_r_8, lstrbclk_r_9, lstrbclk_r_10, lstrbclk_r_11,
     odll_lock, scan_out;

input  idll_entest_str, idll_lock_req, pipeline_global_en,
     rb_half_code_str, rb_selflock_str, ref_clk_n, ref_clk_p,
     scan_clk_in, scan_in, scan_mode_n, scan_rst_n, scan_shift_n,
     test_clk_pll_en_n, vcc_aibnd, vcc_io, vss_aibnd;

output [12:0]  odll_dll2core_str;

input [2:0]  rb_clkdiv_str;
input [2:0]  idll_core2dll_str;
input [51:0]  csr_reg_str;

wire scan_shift_n, scan_shift_n_buf, scan_clk_in, scan_clk_in_buf, net_0112, net_0111, scan_rst_n, scan_rst_n_buf, scan_mode_n, scan_mode_n_buf, scan_in, scan_in_buf, dll_lock, odll_lock, ref_clk_p, buf_refclk_p, ref_clk_n, buf_refclk_n, lock_req_mux, csr_reg_str6, idll_lock_req, reinit_b, reinit, net106, lstrbclk_mimic0, vss_aibnd, net107, net105, net103, net114, lstrbclk_mimic0_quadph, net115, net112, lstrbclk_rep, net108, net110, lstrbclk_mimic2, net119, net104, lstrbclk_mimic1, net120, net_0113, clk_buf0, code_valid; // Conversion Sript Generated

// Buses in the design

wire  [9:0]  pvt_ref_gry_str;

wire  [9:0]  pvt_ref_half_gry_str;

wire  [6:0]  f_gray_str;

wire  [6:0]  gate_shf;

wire  [2:0]  i_gray_str;


// specify 
//     specparam CDS_LIBNAME  = "aibnd_lib";
//     specparam CDS_CELLNAME = "aibnd_str_align";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

aibnd_2ff_scan  xsync ( .si(scan_in_buf), .so(so_sync),     .ssb(scan_shift_n_buf), .o(reinit_b), .d(vcc_aibnd),     .clk(clk_buf0) /*`ifndef INTCNOPWR , .vss(vss_aibnd) , .vcc(vcc_aibnd) `endif*/ , .rb(net_0111));
aibndpnr_dll_pnr  xaibnd_str_pnr ( .scan_shift_n(scan_shift_n_buf),
     .rb_clkdiv(rb_clkdiv_str[2:0]), .gate_shf(gate_shf[6:0]),
     .scan_in(so_sync), .scan_rst_n(scan_rst_n_buf),
     .scan_clk_in(scan_clk_in_buf), .scan_mode_n(scan_mode_n_buf),
     .scan_out(so_str_pnr), .pipeline_global_en(pipeline_global_en),
     .rb_half_code(rb_half_code_str),
     .pvt_ref_half_gry(pvt_ref_half_gry_str[9:0]), .dll_lock(dll_lock),
     //.vcc_io(vcc_aibnd), .vss_io(vss_aibnd),
     .pvt_ref_gry(pvt_ref_gry_str[9:0]),
     .dll_core(odll_dll2core_str[12:0]), .i_gray(i_gray_str[2:0]),
     .f_gray(f_gray_str[6:0]), .core_dll(idll_core2dll_str[2:0]),
     .test_clk_pll_en_n(test_clk_pll_en_n),
     .dll_phdet_reset_n(str_rst_n), .measure(measure_str),
     .launch(launch_str), .t_down(t_down_str), .t_up(t_up_str),
     .entest(idll_entest_str), .reinit(reinit),
     .csr_reg(csr_reg_str[51:0]), .rb_selflock(rb_selflock_str),
     .clk_pll(buf_refclk_p));
aibnd_str_clktree_mimic  xclktree_quadph ( //.vcc_aibnd(vcc_aibnd),
     //.vss_aibnd(vss_aibnd), 
     .lstrbclk_mimic0(lstrbclk_mimic0_quadph),
     .lstrbclk_l_0(lstrbclk_l_0_quadph),
     .lstrbclk_l_1(lstrbclk_l_1_quadph),
     .lstrbclk_l_2(lstrbclk_l_2_quadph),
     .lstrbclk_l_3(lstrbclk_l_3_quadph),
     .lstrbclk_l_4(lstrbclk_l_4_quadph),
     .lstrbclk_l_5(lstrbclk_l_5_quadph),
     .lstrbclk_l_6(lstrbclk_l_6_quadph),
     .lstrbclk_l_7(lstrbclk_l_7_quadph),
     .lstrbclk_l_8(lstrbclk_l_8_quadph),
     .lstrbclk_l_9(lstrbclk_l_9_quadph),
     .lstrbclk_l_10(lstrbclk_l_10_quadph),
     .lstrbclk_l_11(lstrbclk_l_11_quadph), .lstrbclk_rep(lstrbclk),
     .clkin(lstrbclk_rep));
assign scan_shift_n_buf = scan_shift_n;
assign scan_clk_in_buf = scan_clk_in;
assign net_0111 = net_0112;
assign scan_rst_n_buf = scan_rst_n;
assign scan_mode_n_buf = scan_mode_n;
assign scan_in_buf = scan_in;
aibnd_ff_r  fyn0 ( .o(net121), .d(i_del_str), .clk(ref_clk_p) /*`ifndef INTCNOPWR , .vss(vss_aibnd) , .vcc(vcc_aibnd) `endif*/ , .rb(vss_aibnd));
aibnd_ff_r  xsampling_dn ( .o(net102), .d(ref_clk_p),     .clk(i_del_str) /*`ifndef INTCNOPWR , .vss(vss_aibnd) , .vcc(vcc_aibnd) `endif*/ ,     .rb(vss_aibnd));
assign odll_lock = dll_lock;
assign buf_refclk_p = ref_clk_p;
assign buf_refclk_n = ref_clk_n;
aibnd_str_preclkbuf x211 ( .vcc_aibnd(vcc_aibnd),
     .vss_aibnd(vss_aibnd), .clkin(lstrbclk_mimic0), .clkout(net111));
aibnd_str_preclkbuf x212 ( .vcc_aibnd(vcc_aibnd),
     .vss_aibnd(vss_aibnd), .clkin(lstrbclk_mimic1), .clkout(net117));
aibnd_str_preclkbuf x215 ( .vcc_aibnd(vcc_aibnd),
     .vss_aibnd(vss_aibnd), .clkin(lstrbclk_mimic2), .clkout(net101));
aibnd_str_preclkbuf x216 ( .vcc_aibnd(vcc_aibnd),
     .vss_aibnd(vss_aibnd), .clkin(lstrbclk), .clkout(net118));
aibnd_str_preclkbuf x219 ( .vcc_aibnd(vcc_aibnd),
     .vss_aibnd(vss_aibnd), .clkin(lstrbclk_mimic0_quadph),
     .clkout(net109));
aibnd_str_preclkbuf x220 ( .vcc_aibnd(vcc_aibnd),
     .vss_aibnd(vss_aibnd), .clkin(clkout_quadph), .clkout(net116));
assign lock_req_mux = csr_reg_str6 ? idll_core2dll_str[2] : idll_lock_req;
assign reinit = !reinit_b;
aibnd_nand_x64_delay_line xdly_line_quadph ( .sm_n(scan_mode_n_buf),
     .vss_aibnd(vss_aibnd), .vcc_aibnd(vcc_aibnd),
     .code_valid(code_valid), .sck_in(scan_clk_in_buf),
     .scan_rst_n(scan_rst_n_buf), .dll_reset_n(str_rst_n),
     .se_n(scan_shift_n_buf), .so(scan_out), .si(so_dly_line_str),
     .vcc_io(vcc_aibnd), .i_gray(i_gray_str[2:0]),
     .f_gray(f_gray_str[6:0]), .out_p(clkout_quadph), .in_p(lstrbclk));
aibnd_nand_x64_delay_line xdly_line_str ( .sm_n(scan_mode_n_buf),
     .vss_aibnd(vss_aibnd), .vcc_aibnd(vcc_aibnd),
     .code_valid(code_valid), .sck_in(scan_clk_in_buf),
     .scan_rst_n(scan_rst_n_buf), .dll_reset_n(str_rst_n),
     .se_n(scan_shift_n_buf), .so(so_dly_line_str), .si(vss_aibnd),
     .vcc_io(vcc_aibnd), .i_gray(i_gray_str[2:0]),
     .f_gray(f_gray_str[6:0]), .out_p(i_del_str), .in_p(ref_clk_p));
aibnd_dll_phdet xdll_phdet ( .vss_io(vss_aibnd), .vcc_io(vcc_aibnd),
     .t_down(t_down_str), .t_up(t_up_str), .dll_reset_n(str_rst_n),
     .phase_clk(ref_clk_n), .i_del_p(clkout_quadph));
assign csr_reg_str6 = csr_reg_str[6];
assign net106 = !(lstrbclk_mimic0 & vss_aibnd);
assign net107 = !(vss_aibnd & lstrbclk_mimic0);
assign net105 = !(ref_clk_n & vss_aibnd);
assign net103 = !(vss_aibnd & ref_clk_n);
assign net114 = !(lstrbclk_mimic0_quadph & vss_aibnd);
assign net115 = !(vss_aibnd & lstrbclk_mimic0_quadph);
assign net112 = !(lstrbclk_rep & vss_aibnd);
assign net108 = !(vss_aibnd & lstrbclk_rep);
assign net110 = !(vss_aibnd & lstrbclk_mimic2);
assign net119 = !(lstrbclk_mimic2 & vss_aibnd);
assign net104 = !(lstrbclk_mimic1 & vss_aibnd);
assign net120 = !(vss_aibnd & lstrbclk_mimic1);
//pdecap  xdecap0 ( .g(vss_aibnd), .b(vcc_aibnd));
assign net_0113 = scan_mode_n_buf ? buf_refclk_p : scan_clk_in_buf;
assign net_0112 = scan_mode_n_buf ? lock_req_mux : scan_rst_n_buf;
assign clk_buf0 = net_0113;
//assign code_valid = !gate_shf[6];
assign code_valid = gate_shf[6];    
aibnd_str_clktree  xclktree ( //.vcc_aibnd(vcc_aibnd),
     //.vss_aibnd(vss_aibnd), 
     .lstrbclk_mimic2(lstrbclk_mimic2),
     .lstrbclk_r_11(lstrbclk_r_11), .lstrbclk_r_10(lstrbclk_r_10),
     .lstrbclk_r_9(lstrbclk_r_9), .lstrbclk_r_8(lstrbclk_r_8),
     .lstrbclk_r_7(lstrbclk_r_7), .lstrbclk_r_6(lstrbclk_r_6),
     .lstrbclk_r_5(lstrbclk_r_5), .lstrbclk_r_4(lstrbclk_r_4),
     .lstrbclk_r_3(lstrbclk_r_3), .lstrbclk_r_2(lstrbclk_r_2),
     .lstrbclk_r_1(lstrbclk_r_1), .lstrbclk_r_0(lstrbclk_r_0),
     .lstrbclk_mimic1(lstrbclk_mimic1),
     .lstrbclk_mimic0(lstrbclk_mimic0), .lstrbclk_l_0(lstrbclk_l_0),
     .lstrbclk_l_1(lstrbclk_l_1), .lstrbclk_l_2(lstrbclk_l_2),
     .lstrbclk_l_3(lstrbclk_l_3), .lstrbclk_l_4(lstrbclk_l_4),
     .lstrbclk_l_5(lstrbclk_l_5), .lstrbclk_l_6(lstrbclk_l_6),
     .lstrbclk_l_7(lstrbclk_l_7), .lstrbclk_l_8(lstrbclk_l_8),
     .lstrbclk_l_9(lstrbclk_l_9), .lstrbclk_l_10(lstrbclk_l_10),
     .lstrbclk_l_11(lstrbclk_l_11), .lstrbclk_rep(lstrbclk_rep),
     .clkin(i_del_str));

endmodule

