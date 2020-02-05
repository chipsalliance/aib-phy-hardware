// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3_lib, Cell - aibcr3_str_align, View - schematic
// LAST TIME SAVED: Aug 19 00:24:25 2016
// NETLIST TIME: Aug 31 08:45:53 2016
`timescale 1ns / 1ns 

module aibcr3_str_align ( lstrbclk_l_0, lstrbclk_l_1, lstrbclk_l_2,
     lstrbclk_l_3, lstrbclk_l_4, lstrbclk_l_5, lstrbclk_l_6,
     lstrbclk_l_7, lstrbclk_l_8, lstrbclk_l_9, lstrbclk_l_10,
     lstrbclk_l_11, lstrbclk_r_0, lstrbclk_r_1, lstrbclk_r_2,
     lstrbclk_r_3, lstrbclk_r_4, lstrbclk_r_5, lstrbclk_r_6,
     lstrbclk_r_7, lstrbclk_r_8, lstrbclk_r_9, lstrbclk_r_10,
     lstrbclk_r_11, odll_dll2core_str, odll_lock, scan_out, 
     csr_reg_str, idll_core2dll_str, idll_entest_str, idll_lock_req,
     pipeline_global_en, rb_clkdiv_str, rb_half_code_str,
     rb_selflock_str, ref_clk_n, ref_clk_p, scan_clk_in, scan_in,
     scan_mode_n, scan_rst_n, scan_shift_n, test_clk_pll_en_n, i_del_str_o );

output  lstrbclk_l_0, lstrbclk_l_1, lstrbclk_l_2, lstrbclk_l_3,
     lstrbclk_l_4, lstrbclk_l_5, lstrbclk_l_6, lstrbclk_l_7,
     lstrbclk_l_8, lstrbclk_l_9, lstrbclk_l_10, lstrbclk_l_11,
     lstrbclk_r_0, lstrbclk_r_1, lstrbclk_r_2, lstrbclk_r_3,
     lstrbclk_r_4, lstrbclk_r_5, lstrbclk_r_6, lstrbclk_r_7,
     lstrbclk_r_8, lstrbclk_r_9, lstrbclk_r_10, lstrbclk_r_11,
     odll_lock, scan_out, i_del_str_o;


input  idll_entest_str, idll_lock_req, pipeline_global_en,
     rb_half_code_str, rb_selflock_str, ref_clk_n, ref_clk_p,
     scan_clk_in, scan_in, scan_mode_n, scan_rst_n, scan_shift_n,
     test_clk_pll_en_n;

output [12:0]  odll_dll2core_str;

input [2:0]  rb_clkdiv_str;
input [2:0]  idll_core2dll_str;
input [51:0]  csr_reg_str;

// Buses in the design

wire  [6:0]  gate_shf;

wire  [7:0]  f_gray_str;
wire  [6:0]  sm_grey;
wire  [2:0]  i_gray_str;
wire  [2:0]  sm_igray;
wire         satdetb;
wire  [10:0]  pvt_ref_half_gry_str;

wire  [10:0]  pvt_ref_gry_str;

wire net0228;
wire clk_prebuf;
wire so_str_pnr;
wire net0329;
wire so_dly_line_str;
wire net0324;
wire net0325;
wire dll_lock;
wire net830;
wire lock_req_mux;

assign tie_HI = 1'b1;
assign net883 = 1'b0;
assign tie_LO = 1'b1;
assign scan_shift_n_buf = scan_shift_n;
assign buf_refclk_n = ref_clk_n;
assign buf_refclk_p = ref_clk_p;
assign scan_out = net0228;
assign scan_clk_in_buf = scan_clk_in;
assign clk_buf0 = clk_prebuf;
assign scan_rst_n_buf = scan_rst_n;
assign scan_mode_n_buf = scan_mode_n;
assign scan_in_buf = scan_in;
assign net0326 = so_str_pnr;
assign net0328 = net0329;
assign net0327 = net0328;
assign so_dly_line_str_dly = net0327;
assign net0329 = so_dly_line_str;
assign so_str_pnr_dly = net0324;
assign net0324 = net0325;
assign net0325 = net0326;
assign odll_lock = dll_lock;
assign code_valid = gate_shf[6];
assign net815 = net830;
assign csr_reg_str6 = csr_reg_str[6];
assign sm_grey[6] = (f_gray_str[7] | f_gray_str[6]);
assign satdetb = ~(f_gray_str[7] | f_gray_str[6]);
assign sm_grey[5:0] = f_gray_str[5:0];
assign sm_igray[2] = ( f_gray_str[7] | f_gray_str[6] | i_gray_str[2] );
assign sm_igray[1:0] = ( {satdetb,satdetb} & i_gray_str[1:0] );

aibcr3_dcc_phasedet x49 ( t_down_str, t_up_str,
     clkout_quadph, ref_clk_n, str_rst_n);

aibcr3_clktree_mimic x46 ( 
     .lstrbclk_l_11(lstrbclk_l_11_quadph),
     .lstrbclk_mimic0(lstrbclk_mimic0_quadph),
     .lstrbclk_l_10(lstrbclk_l_10_quadph),
     .lstrbclk_l_0(lstrbclk_l_0_quadph),
     .lstrbclk_l_1(lstrbclk_l_1_quadph),
     .lstrbclk_l_2(lstrbclk_l_2_quadph),
     .lstrbclk_l_3(lstrbclk_l_3_quadph),
     .lstrbclk_l_4(lstrbclk_l_4_quadph),
     .lstrbclk_l_5(lstrbclk_l_5_quadph),
     .lstrbclk_l_6(lstrbclk_l_6_quadph),
     .lstrbclk_l_7(lstrbclk_l_7_quadph),
     .lstrbclk_l_8(lstrbclk_l_8_quadph),
     .lstrbclk_l_9(lstrbclk_l_9_quadph), .lstrbclk_rep(lstrbclk),
     .clkin(lstrbclk_rep)
     );

aibcr3_clktree x41 (
     .lstrbclk_r_11(lstrbclk_r_11), .lstrbclk_r_10(lstrbclk_r_10),
     .lstrbclk_l_11(lstrbclk_l_11), .lstrbclk_mimic2(lstrbclk_mimic2),
     .lstrbclk_mimic1(lstrbclk_mimic1),
     .lstrbclk_mimic0(lstrbclk_mimic0), .lstrbclk_l_10(lstrbclk_l_10),
     .lstrbclk_r_9(lstrbclk_r_9), .lstrbclk_r_8(lstrbclk_r_8),
     .lstrbclk_r_7(lstrbclk_r_7), .lstrbclk_r_6(lstrbclk_r_6),
     .lstrbclk_r_5(lstrbclk_r_5), .lstrbclk_r_4(lstrbclk_r_4),
     .lstrbclk_r_3(lstrbclk_r_3), .lstrbclk_r_2(lstrbclk_r_2),
     .lstrbclk_r_1(lstrbclk_r_1), .lstrbclk_r_0(lstrbclk_r_0),
     .lstrbclk_l_0(lstrbclk_l_0), .lstrbclk_l_1(lstrbclk_l_1),
     .lstrbclk_l_2(lstrbclk_l_2), .lstrbclk_l_3(lstrbclk_l_3),
     .lstrbclk_l_4(lstrbclk_l_4), .lstrbclk_l_5(lstrbclk_l_5),
     .lstrbclk_l_6(lstrbclk_l_6), .lstrbclk_l_7(lstrbclk_l_7),
     .lstrbclk_l_8(lstrbclk_l_8), .lstrbclk_l_9(lstrbclk_l_9),
     .lstrbclk_rep(lstrbclk_rep), .clkin(i_del_str) 
     );

aibcr3pnr_dll_pnr I1 ( 
     .dll_core(odll_dll2core_str[12:0]), .dll_lock(dll_lock), .dll_phdet_reset_n(str_rst_n),
     .f_gray(f_gray_str[7:0]), .gate_shf(gate_shf[6:0]), .i_gray(i_gray_str[2:0]), .launch(launch_str),
     .measure(measure_str), .pvt_ref_half_gry(pvt_ref_half_gry_str[10:0]), .pvt_ref_gry(pvt_ref_gry_str[10:0]),
     .scan_out(so_str_pnr), .clk_pll(buf_refclk_p), .core_dll(idll_core2dll_str[2:0]),
     .csr_reg(csr_reg_str[51:0]), .entest(idll_entest_str), .pipeline_global_en(pipeline_global_en),
     .rb_clkdiv(rb_clkdiv_str[2:0]), .rb_half_code(rb_half_code_str), .rb_selflock(rb_selflock_str), .reinit(reinit),
     .scan_clk_in(scan_clk_in_buf), .scan_in(so_sync), .scan_mode_n(scan_mode_n_buf), .scan_rst_n(scan_rst_n_buf),
     .scan_shift_n(scan_shift_n_buf), .t_up(t_up_str), .t_down(t_down_str), .test_clk_pll_en_n(test_clk_pll_en_n) 
     );

// electrical loading, no logical sense
// aibcr3_phd_ldmatch x180 ( i_del_str, ref_clk_n, str_rst_n);

assign net880 = !( net883 & net883 );
assign net0223 = !( net883 & net883 );
assign net0299 = !( tie_LO & lstrbclk_mimic0_quadph );
assign net0300 = !( lstrbclk_mimic0_quadph & tie_LO );
assign net0336 = !( tie_LO & lstrbclk_mimic0 );
assign net0307 = !( lstrbclk_mimic0 & tie_LO );
assign net0301 = !( lstrbclk_rep & tie_LO );
assign net0306 = !( lstrbclk_mimic1 & tie_LO );
assign net0305 =!( tie_LO & lstrbclk_mimic1 );
assign net0302 =!( tie_LO & lstrbclk_rep );
assign net0303 =!( tie_LO & lstrbclk_mimic2 );
assign net0304 =!( lstrbclk_mimic2 & tie_LO );
assign net0414 = ! lstrbclk_mimic0;
assign net0415 = ! lstrbclk_mimic1;
assign net0416 = ! lstrbclk_mimic2;
assign net0221 = ! net883;
assign net0293 = ! lstrbclk_l_11_quadph;
assign net0287 = ! lstrbclk_l_5_quadph;
assign net0288 = ! lstrbclk_l_6_quadph;
assign net0289 = ! lstrbclk_l_7_quadph;
assign net0290 = ! lstrbclk_l_8_quadph;
assign net0291 = ! lstrbclk_l_9_quadph;
assign net0292 = ! lstrbclk_l_10_quadph;
assign net099 = ! net883;
assign net884 = ! net883;
assign net831 = ! scan_shift_n_buf;
assign reinit = ! so_sync;
assign net0220 = ! net883;
assign net0282 = ! lstrbclk_l_4_quadph;
assign net0283 = ! lstrbclk_l_3_quadph;
assign net0284 = ! lstrbclk_l_2_quadph;
assign net0333 = ! lstrbclk;
assign net0334 = ! lstrbclk_mimic0_quadph;
assign net0285 = ! lstrbclk_l_1_quadph;
assign net0286 = ! lstrbclk_l_0_quadph; 
assign net830 = scan_mode_n_buf? lock_req_mux : scan_rst_n_buf;
assign lock_req_mux = csr_reg_str6 ? idll_core2dll_str[2] : idll_lock_req;
assign clk_prebuf = scan_mode_n_buf? buf_refclk_p : scan_clk_in_buf;

aibcr3_ulvt16_2xarstsyncdff1_b2  I99 ( 
     .Q(so_sync), .CLR_N(net815), .CK(clk_buf0), 
     .SE(net831), .D(tie_HI), .SI(scan_in_buf));

aibcr3_cmos_nand_x64 x43 ( i_del_str, so_dly_line_str, 
     code_valid, str_rst_n, ref_clk_p, scan_rst_n_buf, scan_clk_in_buf,
     scan_shift_n_buf, so_str_pnr_dly, sm_grey[6:0],
     sm_igray[2:0], scan_mode_n_buf);

aibcr3_cmos_nand_x64 x44 ( clkout_quadph, net0228, 
     code_valid, str_rst_n, lstrbclk, scan_rst_n_buf, scan_clk_in_buf,
     scan_shift_n_buf, so_dly_line_str_dly, sm_grey[6:0],
     sm_igray[2:0], scan_mode_n_buf);

assign i_del_str_o = i_del_str;

endmodule
