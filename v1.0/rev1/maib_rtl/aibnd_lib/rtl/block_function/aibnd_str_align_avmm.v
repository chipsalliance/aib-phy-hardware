// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_str_align_avmm, View - schematic
// LAST TIME SAVED: Oct 28 17:42:05 2014
// NETLIST TIME: Oct 29 15:43:13 2014

module aibnd_str_align_avmm ( lstrbclk_l_0, lstrbclk_l_1, lstrbclk_l_2,
     lstrbclk_l_3, lstrbclk_l_4, lstrbclk_l_5, lstrbclk_l_6,
     lstrbclk_l_7, lstrbclk_r_0, lstrbclk_r_1, lstrbclk_r_2,
     lstrbclk_r_3, lstrbclk_r_4, lstrbclk_r_5, lstrbclk_r_6,
     lstrbclk_r_7, odll_dll2core_str, odll_lock, scan_out, atpg_en_n,
     csr_reg_str, idll_core2dll_str, idll_entest_str, idll_lock_req,
     pipeline_global_en, rb_clkdiv_str, rb_half_code_str,
     rb_selflock_str, ref_clk_n, ref_clk_p, scan_clk_in, scan_in,
     scan_mode_n, scan_shift, test_clk, test_clk_pll_en_n, test_clr_n,
     vcc_io, vcc_regphy, vss_io );

output  lstrbclk_l_0, lstrbclk_l_1, lstrbclk_l_2, lstrbclk_l_3,
     lstrbclk_l_4, lstrbclk_l_5, lstrbclk_l_6, lstrbclk_l_7,
     lstrbclk_r_0, lstrbclk_r_1, lstrbclk_r_2, lstrbclk_r_3,
     lstrbclk_r_4, lstrbclk_r_5, lstrbclk_r_6, lstrbclk_r_7, odll_lock,
     scan_out;

input  atpg_en_n, idll_entest_str, idll_lock_req, pipeline_global_en,
     rb_half_code_str, rb_selflock_str, ref_clk_n, ref_clk_p,
     scan_clk_in, scan_in, scan_mode_n, scan_shift, test_clk,
     test_clk_pll_en_n, test_clr_n, vcc_io, vcc_regphy, vss_io;

output [12:0]  odll_dll2core_str;

input [51:0]  csr_reg_str;
input [1:0]  rb_clkdiv_str;
input [2:0]  idll_core2dll_str;

wire ref_clk_p, buf_refclk_p, ref_clk_n, buf_refclk_n, idll_lock_req, reinit, net0135, lstrbclk_mimic0, vss_io, net098, net095, net0129, net0115, lstrbclk_mimic0_quadph, net0114, net0117, lstrbclk_rep, net0116, net0110, lstrbclk_mimic2, net0144, net0112, lstrbclk_mimic1, net0113; // Conversion Sript Generated

// Buses in the design

wire  [2:0]  i_gray_str;

wire  [9:0]  pvt_ref_half_gry_str;

wire  [9:0]  pvt_ref_gry_str;

wire  [6:0]  f_gray_str;

aibnd_dll_pnr  xaibnd_str_pnr ( .rb_half_code(rb_half_code_str),
     .pvt_ref_half_gry(pvt_ref_half_gry_str[9:0]),
     .dll_lock(odll_lock), .rb_clkdiv(rb_clkdiv_str[1:0]),
//     .vcc_io(vcc_io), .vss_io(vss_io),
     .pvt_ref_gry(pvt_ref_gry_str[9:0]),
     .dll_core(odll_dll2core_str[12:0]), .i_gray(i_gray_str[2:0]),
     .f_gray(f_gray_str[6:0]), .core_dll(idll_core2dll_str[2:0]),
     .test_clk_pll_en_n(test_clk_pll_en_n), .test_clr_n(test_clr_n),
     .test_clk(test_clk), .dll_phdet_reset_n(str_rst_n),
     .measure(measure_str), .launch(launch_str), .t_down(t_down_str),
     .t_up(t_up_str), .entest(idll_entest_str), .reinit(reinit),
     .atpg_en_n(atpg_en_n), .csr_reg(csr_reg_str[51:0]),
     .rb_selflock(rb_selflock_str), .clk_pll(buf_refclk_p));
aibnd_clktree_avmm_mimic xclktree_quadph (
     .lstrbclk_mimic0(lstrbclk_mimic0_quadph),
     .lstrbclk_l_0(lstrbclk_l_0_quadph),
     .lstrbclk_l_1(lstrbclk_l_1_quadph),
     .lstrbclk_l_2(lstrbclk_l_2_quadph),
     .lstrbclk_l_3(lstrbclk_l_3_quadph),
     .lstrbclk_l_4(lstrbclk_l_4_quadph),
     .lstrbclk_l_5(lstrbclk_l_5_quadph),
     .lstrbclk_l_6(lstrbclk_l_6_quadph),
     .lstrbclk_l_7(lstrbclk_l_7_quadph), .lstrbclk_rep(lstrbclk),
     .clkin(lstrbclk_rep) 
	//, .vssl(vss_io), .vccl(vcc_regphy)
);
aibnd_ff_r  fyn0 ( .o(net185), .d(i_del_str), .clk(ref_clk_p) /*`ifndef INTCNOPWR , .vss(vss_io) , .vcc(vcc_io) `endif*/ , .rb(vss_io));
aibnd_ff_r  xsampling_dn ( .o(net0111), .d(ref_clk_p),     .clk(i_del_str) /*`ifndef INTCNOPWR , .vss(vss_io) , .vcc(vcc_io) `endif*/ , .rb(vss_io));
assign buf_refclk_p = ref_clk_p;
assign buf_refclk_n = ref_clk_n;
aibnd_aliasv aliasv11 ( scan_out, vss_io);
assign reinit = !idll_lock_req;
aibnd_nand_x128_delay_line xdly_line_quadph ( .vcc_io(vcc_io),
     .vcc_regphy(vcc_regphy), .vss_io(vss_io),
     .i_gray(i_gray_str[2:0]), .f_gray(f_gray_str[6:0]),
     .out_p(clkout_quadph), .in_p(lstrbclk));
aibnd_nand_x128_delay_line xdly_line_str ( .vcc_io(vcc_io),
     .vcc_regphy(vcc_regphy), .vss_io(vss_io),
     .i_gray(i_gray_str[2:0]), .f_gray(f_gray_str[6:0]),
     .out_p(i_del_str), .in_p(ref_clk_p));
aibnd_dll_phdet xdll_phdet ( 
	.vss_io(vss_io), .vcc_io(vcc_regphy),
     .t_down(t_down_str), .t_up(t_up_str), .dll_reset_n(str_rst_n),
     .phase_clk(ref_clk_n), .i_del_p(clkout_quadph));
aibnd_clktree_avmm xclktree ( .lstrbclk_mimic2(lstrbclk_mimic2),
     .lstrbclk_r_7(lstrbclk_r_7), .lstrbclk_r_6(lstrbclk_r_6),
     .lstrbclk_r_5(lstrbclk_r_5), .lstrbclk_r_4(lstrbclk_r_4),
     .lstrbclk_r_3(lstrbclk_r_3), .lstrbclk_r_2(lstrbclk_r_2),
     .lstrbclk_r_1(lstrbclk_r_1), .lstrbclk_r_0(lstrbclk_r_0),
     .lstrbclk_mimic1(lstrbclk_mimic1),
     .lstrbclk_mimic0(lstrbclk_mimic0), .lstrbclk_l_0(lstrbclk_l_0),
     .lstrbclk_l_1(lstrbclk_l_1), .lstrbclk_l_2(lstrbclk_l_2),
     .lstrbclk_l_3(lstrbclk_l_3), .lstrbclk_l_4(lstrbclk_l_4),
     .lstrbclk_l_5(lstrbclk_l_5), .lstrbclk_l_6(lstrbclk_l_6),
     .lstrbclk_l_7(lstrbclk_l_7), .lstrbclk_rep(lstrbclk_rep),
     .clkin(i_del_str)
	//, .vssl(vss_io), .vccl(vcc_regphy)
);
assign net0135 = !(lstrbclk_mimic0 & vss_io);
assign net098 = !(vss_io & lstrbclk_mimic0);
assign net095 = !(ref_clk_n & vss_io);
assign net0129 = !(vss_io & ref_clk_n);
assign net0115 = !(lstrbclk_mimic0_quadph & vss_io);
assign net0114 = !(vss_io & lstrbclk_mimic0_quadph);
assign net0117 = !(lstrbclk_rep & vss_io);
assign net0116 = !(vss_io & lstrbclk_rep);
assign net0110 = !(vss_io & lstrbclk_mimic2);
assign net0144 = !(lstrbclk_mimic2 & vss_io);
assign net0112 = !(lstrbclk_mimic1 & vss_io);
assign net0113 = !(vss_io & lstrbclk_mimic1);
aibnd_preclkbuf x211 ( .clkin(lstrbclk_mimic0), .vssl(vss_io),
     .vccl(vcc_regphy), .clkout(net0103));
aibnd_preclkbuf x212 ( .clkin(lstrbclk_mimic1), .vssl(vss_io),
     .vccl(vcc_regphy), .clkout(net090));
aibnd_preclkbuf x215 ( .clkin(lstrbclk_mimic2), .vssl(vss_io),
     .vccl(vcc_regphy), .clkout(net0101));
aibnd_preclkbuf x216 ( .clkin(lstrbclk), .vssl(vss_io),
     .vccl(vcc_regphy), .clkout(net0100));
aibnd_preclkbuf x219 ( .clkin(lstrbclk_mimic0_quadph), .vssl(vss_io),
     .vccl(vcc_regphy), .clkout(net099));
aibnd_preclkbuf x220 ( .clkin(clkout_quadph), .vssl(vss_io),
     .vccl(vcc_regphy), .clkout(net0136));

endmodule

