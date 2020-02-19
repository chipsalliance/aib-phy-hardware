// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Blue Cheetah Analog Design, Inc.
// Copyright (C) 2019 Intel Corporation. 
//
// Library - aibcr3_lib, Cell - aibcr3_rxdatapath_rx, View - schematic
// LAST TIME SAVED: Jul  8 20:59:44 2015
// NETLIST TIME: Jul  9 10:52:18 2015
// `timescale 1ns / 1ns

// Ayar changes:
//  1.  Removed vcc, vccl, and vss pins
//  2.  Added explicit buffer here to isolate main clock tree from dft clk path
//
// BCA changes:
//  1. Disabled aib57 -> ohssi_pld_pma_coreclkin clock path. ohssi_pld_pma_coreclkin
//     is unused in our system and the clock path was causing
//     routing issues, so we removed constraints on the path.
module aibcr3_rxdatapath_rx ( async_dat_outpclk6, async_dat_outpdir2,
     dcc_done, dft_tx_clk, idat0_outpclk1n, idat1_outpclk1n,
     idata0_poutp0, idata1_poutp0, idataselb_out_chain2,
     idataselb_outpclk1n, idataselb_outpclk6, idataselb_outpdir2,
     idataselb_poutp0, iddren_poutp0, idirectout_data_out_chain2,
     ilaunch_clk_poutp0, irxen_inpclk0, irxen_inpclk1, irxen_inpdir0_1,
     irxen_inpdir2_1, itxen_out_chain2, itxen_outpclk1n,
     itxen_outpclk6, itxen_outpdir2, itxen_poutp0, jtag_clkdr_inpclk0,
     jtag_clkdr_inpclk1, jtag_clkdr_inpdir0_1, jtag_clkdr_inpdir2_1,
     jtag_clkdr_out_chain2, jtag_clkdr_out_poutp0,
     jtag_clkdr_outpclk1n, jtag_clkdr_outpclk6, jtag_clkdr_outpdir2,
     jtag_rx_scan_inpclk0, jtag_rx_scan_inpclk1,
     jtag_rx_scan_inpdir0_1, jtag_rx_scan_inpdir2_1,
     jtag_rx_scan_out_chain2, jtag_rx_scan_out_poutp0,
     jtag_rx_scan_outpdir2, jtag_scan_outpclk1n, jtag_scan_outpclk6,
     oclkn_aib_inpdir2_1, odat0_aib_inpdir5_1, odat1_aib_inpdir5_1,
     odat_async_aib_poutp19, odirectin_data, odll_dll2core,
     out_rx_fast_clk, out_rx_fast_clkb, scan_out, shift_en_inpclk0,
     shift_en_inpclk1, shift_en_inpdir0_1, shift_en_inpdir2_1,
     shift_en_out_chain2, shift_en_outpclk1n, shift_en_outpclk6,
     shift_en_outpdir2, shift_en_poutp0, iopad_clkn, iopad_clkp,
     iopad_dat, iopad_direct_input, iopad_directinclkn,
     iopad_directinclkp, iopad_directout, iopad_directoutclkn,
     iopad_directoutclkp, async_dat_outpclk3, async_dat_outpdir3,
     clkdr_xr1l, clkdr_xr1r, clkdr_xr2l, clkdr_xr2r, clkdr_xr3l,
     clkdr_xr3r, clkdr_xr4l, clkdr_xr4r, clkdr_xr5l, clkdr_xr5r,
     clkdr_xr6l, clkdr_xr6r, clkdr_xr7l, clkdr_xr7r, clkdr_xr8l,
     clkdr_xr8r, csr_reg, dcc_dft_nrst, dcc_dft_nrst_coding,
     dcc_dft_up, dcc_req, dll_csr_reg6, iclkin_dist_pinp18, idat0,
     idat0_clkn, idat0_clkp, idat0_directoutclkn, idat0_directoutclkp,
     idat0_oshared0, idat0_outclk0n, idat1, idat1_clkn, idat1_clkp,
     idat1_directoutclkn, idat1_directoutclkp, idat1_oshared0,
     idat1_outclk0n, idata0_voutp0, idata0_voutp1, idata1_voutp0,
     idata1_voutp1, idataselb, idataselb_in_chain2, idataselb_oshared0,
     idataselb_outclk0n, idataselb_outpclk3, idataselb_outpdir3,
     idataselb_voutp0, idataselb_voutp1, iddren, idirectout_data,
     idirectout_data_in_chain2, idll_core2dll, idll_entest,
     ilaunch_clk_oshared0, ilaunch_clk_outclk0n, ilaunch_clk_voutp0,
     ilaunch_clk_voutp1, indrv_r12, indrv_r56, indrv_r78, ipdrv_r12,
     ipdrv_r56, ipdrv_r78, irxen_inpdir6_1, irxen_pinp18, irxen_r0,
     irxen_r1, istrbclk_pinp18, itxen, itxen_in_chain2, itxen_oshared0,
     itxen_outclk0n, itxen_outpclk3, itxen_outpdir3, itxen_voutp0,
     itxen_voutp1, jtag_clkdr_in_chain2, jtag_clkdr_inpdir6_1,
     jtag_clkdr_oshared0, jtag_clkdr_outclk0n, jtag_clkdr_outpclk3,
     jtag_clkdr_outpdir3, jtag_clkdr_pinp18, jtag_clkdr_voutp0,
     jtag_clkdr_voutp1, jtag_clksel, jtag_intest, jtag_mode_in,
     jtag_rstb, jtag_rstb_en, jtag_rx_scan_in_chain2,
     jtag_rx_scan_inpdir6_1, jtag_rx_scan_oshared0,
     jtag_rx_scan_outpclk3, jtag_rx_scan_outpdir3, jtag_rx_scan_pinp18,
     jtag_rx_scan_voutp0, jtag_rx_scan_voutp1, jtag_scan_outclk0n,
     jtag_tx_scanen_in, jtag_weakpdn, jtag_weakpu, oclk_aib_inpdir1_1,
     oclkb_aib_inpdir1_1, odat_async_aib_vinp11, odat_async_outclk0,
     odat_async_outclk0n, output_buffer_clk, output_rstb,
     pipeline_global_en, por_aib_vcchssi, por_aib_vccl, poutp_dig_rstb,
     rb_clkdiv, rb_dcc_byp, rb_dcc_byp_dprio, // Mod : Add dprio rambit
     rb_dcc_dft, rb_dcc_dft_sel, rb_dcc_en, rb_dcc_en_dprio, // Mod : Add dprio rambit
     rb_dcc_manual_dn, rb_dcc_manual_mode, rb_dcc_manual_mode_dprio, // Mod : Add dprio rambit
     rb_dcc_manual_up,
     rb_dcc_test_clk_pll_en_n, rb_half_code, rb_selflock, rx_shift_en,
     scan_clk_in, scan_in, scan_mode_n, scan_rst_n, scan_shift,
     shift_en_in_chain2, shift_en_inpdir6_1, shift_en_oshared0,
     shift_en_outclk0n, shift_en_outpclk3, shift_en_outpdir3,
     shift_en_pinp18, shift_en_voutp0, shift_en_voutp1,
     txdirclk_fast_clkn, txdirclk_fast_clkp, txpma_dig_rstb, vcc, vccl,
     vssl );

output  async_dat_outpclk6, async_dat_outpdir2, dcc_done, dft_tx_clk,
     idat0_outpclk1n, idat1_outpclk1n, idata0_poutp0, idata1_poutp0,
     idataselb_out_chain2, idataselb_outpclk1n, idataselb_outpclk6,
     idataselb_outpdir2, idataselb_poutp0, iddren_poutp0,
     idirectout_data_out_chain2, ilaunch_clk_poutp0, itxen_out_chain2,
     itxen_outpclk1n, itxen_outpclk6, itxen_outpdir2, itxen_poutp0,
     jtag_clkdr_inpclk0, jtag_clkdr_inpclk1, jtag_clkdr_inpdir0_1,
     jtag_clkdr_inpdir2_1, jtag_clkdr_out_chain2,
     jtag_clkdr_out_poutp0, jtag_clkdr_outpclk1n, jtag_clkdr_outpclk6,
     jtag_clkdr_outpdir2, jtag_rx_scan_inpclk0, jtag_rx_scan_inpclk1,
     jtag_rx_scan_inpdir0_1, jtag_rx_scan_inpdir2_1,
     jtag_rx_scan_out_chain2, jtag_rx_scan_out_poutp0,
     jtag_rx_scan_outpdir2, jtag_scan_outpclk1n, jtag_scan_outpclk6,
     oclkn_aib_inpdir2_1, odat0_aib_inpdir5_1, odat1_aib_inpdir5_1,
     odat_async_aib_poutp19, out_rx_fast_clk, out_rx_fast_clkb,
     scan_out, shift_en_inpclk0, shift_en_inpclk1, shift_en_inpdir0_1,
     shift_en_inpdir2_1, shift_en_out_chain2, shift_en_outpclk1n,
     shift_en_outpclk6, shift_en_outpdir2, shift_en_poutp0;

inout  iopad_clkn, iopad_clkp, iopad_directinclkn, iopad_directinclkp,
     iopad_directoutclkn, iopad_directoutclkp;

input  async_dat_outpclk3, async_dat_outpdir3, clkdr_xr1l, clkdr_xr1r,
     clkdr_xr2l, clkdr_xr2r, clkdr_xr3l, clkdr_xr3r, clkdr_xr4l,
     clkdr_xr4r, clkdr_xr5l, clkdr_xr5r, clkdr_xr6l, clkdr_xr6r,
     clkdr_xr7l, clkdr_xr7r, clkdr_xr8l, clkdr_xr8r, dcc_dft_nrst,
     dcc_dft_nrst_coding, dcc_dft_up, dcc_req, dll_csr_reg6,
     iclkin_dist_pinp18, idat0_clkn, idat0_clkp, idat0_directoutclkn,
     idat0_directoutclkp, idat0_oshared0, idat0_outclk0n, idat1_clkn,
     idat1_clkp, idat1_directoutclkn, idat1_directoutclkp,
     idat1_oshared0, idat1_outclk0n, idata0_voutp0, idata0_voutp1,
     idata1_voutp0, idata1_voutp1, idataselb_in_chain2,
     idataselb_oshared0, idataselb_outclk0n, idataselb_outpclk3,
     idataselb_outpdir3, idataselb_voutp0, idataselb_voutp1,
     idirectout_data_in_chain2, idll_entest, ilaunch_clk_oshared0,
     ilaunch_clk_outclk0n, ilaunch_clk_voutp0, ilaunch_clk_voutp1,
     istrbclk_pinp18, itxen_in_chain2, itxen_oshared0, itxen_outclk0n,
     itxen_outpclk3, itxen_outpdir3, itxen_voutp0, itxen_voutp1,
     jtag_clkdr_in_chain2, jtag_clkdr_inpdir6_1, jtag_clkdr_oshared0,
     jtag_clkdr_outclk0n, jtag_clkdr_outpclk3, jtag_clkdr_outpdir3,
     jtag_clkdr_pinp18, jtag_clkdr_voutp0, jtag_clkdr_voutp1,
     jtag_clksel, jtag_intest, jtag_mode_in, jtag_rstb, jtag_rstb_en,
     jtag_rx_scan_in_chain2, jtag_rx_scan_inpdir6_1,
     jtag_rx_scan_oshared0, jtag_rx_scan_outpclk3,
     jtag_rx_scan_outpdir3, jtag_rx_scan_pinp18, jtag_rx_scan_voutp0,
     jtag_rx_scan_voutp1, jtag_scan_outclk0n, jtag_tx_scanen_in,
     jtag_weakpdn, jtag_weakpu, oclk_aib_inpdir1_1,
     oclkb_aib_inpdir1_1, odat_async_aib_vinp11, odat_async_outclk0,
     odat_async_outclk0n, output_buffer_clk, output_rstb,
     pipeline_global_en, por_aib_vcchssi, por_aib_vccl, poutp_dig_rstb,
     rb_dcc_byp, rb_dcc_byp_dprio, // Mod : Add dprio rambit
     rb_dcc_dft, rb_dcc_dft_sel, rb_dcc_en, rb_dcc_en_dprio, // Mod : Add dprio rambit
     rb_dcc_manual_mode, rb_dcc_manual_mode_dprio, // Mod : Add dprio rambit
     rb_dcc_test_clk_pll_en_n, rb_half_code,
     rb_selflock, scan_clk_in, scan_in, scan_mode_n, scan_rst_n,
     scan_shift, shift_en_in_chain2, shift_en_inpdir6_1,
     shift_en_oshared0, shift_en_outclk0n, shift_en_outpclk3,
     shift_en_outpdir3, shift_en_pinp18, shift_en_voutp0,
     shift_en_voutp1, txdirclk_fast_clkn, txdirclk_fast_clkp,
     txpma_dig_rstb, vcc, vccl, vssl;

output [2:0]  irxen_inpclk1;
output [2:0]  irxen_inpdir0_1;
output [2:0]  irxen_inpclk0;
output [12:0]  odll_dll2core;
output [2:0]  irxen_inpdir2_1;
output [3:0]  odirectin_data;

inout [6:0]  iopad_directout;
inout [3:0]  iopad_direct_input;
inout [19:0]  iopad_dat;

input [2:0]  idll_core2dll;
input [1:0]  indrv_r78;
input [1:0]  ipdrv_r78;
input [2:0]  irxen_pinp18;
input [2:0]  rb_clkdiv;
input [2:0]  irxen_r0;
input [1:0]  ipdrv_r56;
input [1:0]  indrv_r56;
input [4:0]  rb_dcc_manual_up;
input [51:0]  csr_reg;
input [2:0]  irxen_r1;
input [19:0]  idat0;
input [1:0]  ipdrv_r12;
input [2:0]  irxen_inpdir6_1;
input [19:0]  idat1;
input [4:0]  rb_dcc_manual_dn;
input [1:0]  indrv_r12;
input [1:0]  iddren;
input [6:0]  idirectout_data;
input [3:0]  itxen;
input [2:0]  idataselb;
input [36:0]  rx_shift_en;

wire dft_tx_clk, gated_clk_mimic1, clk_mimic1_buf, clk_mimic1, clk_mimic0_buf, clk_mimic0, gated_clk_mimic1_b, nc_clk_mimicb, clk_mimic, nc_clk_repb, clk_rep, dll_csr_reg6;

// Buses in the design

wire  [0:0]  nc_odat_async_directout;

wire  [1:1]  nc_oclkn_out0_directin;

wire  [2:2]  odat_async_aib_directout;

wire  [1:1]  nc_odat_async_aib;

wire  [1:3]  nc_oclkb_out0_directin;

wire  [4:4]  odat_async_out;

wire  [6:6]  nc_last_bs_out_directout;

wire  [0:6]  nc_oclk_directout;

wire  [3:5]  nc_odat_async_out_directout;

wire  [0:6]  nc_pd_data_directout;

wire  [0:6]  nc_oclk_out0_directout;

wire  [0:6]  nc_odat_async_aib_directout;

wire  [0:6]  nc_odata1_out0_directout;

wire  [0:3]  nc_odat1_out0_directin;

wire  [1:3]  nc_oclk_out0_directin;

wire  [0:3]  nc_pd_data_directin;

wire  [19:0]  idat0_buf;

wire  [0:6]  nc_oclkn_out0_directout;

wire  [0:6]  nc_pd_data_out0_directout;

wire  [0:6]  nc_odata0_out0_directout;

wire  [0:17]  ncrx_pd_data_aib_poutp;

wire  [19:0]  idat1_buf;

wire  [0:17]  ncdrx_odat1_aib_poutp;

wire  [0:11]  tx_launch_clk_l;

wire  [0:11]  tx_launch_clk_r;

wire  [0:17]  ncdrx_odat0_aib_poutp;

wire  [0:17]  ncdrx_oclkb_aib_poutp;

wire  [0:17]  ncrx_odat_async_aib_poutp;

wire  [0:17]  ncdrx_oclkn_poutp;

wire  [0:6]  nc_odata0_directout;

wire  [1:6]  nc_odat_async_out;

wire  [0:17]  ncdrx_oclk_aib_poutp;

wire  [0:19]  nc_odat_async_out_poutp;

wire  [0:6]  nc_odata1_directout;

wire  [0:19]  nc_odat0_out_poutp;

wire  [0:19]  nc_oclkb_out_poutp;

wire  [0:19]  nc_odat1_out_poutp;

wire  [0:19]  nc_pd_data_out_poutp;

wire  [0:6]  nc_oclkb_directout;

wire  [0:19]  nc_oclk_out_poutp;

wire  [0:6]  nc_oclkb_out0_directout;

wire  [0:3]  nc_odat_async_out0_directin;

wire  [0:3]  nc_odat1_directin;

wire  [0:3]  nc_oclk_directin;

wire  [0:3]  nc_odat0_out0_directin;

wire  [0:3]  nc_oclkb_directin;

wire  [0:3]  nc_odat0_directin;

wire  [0:3]  nc_pd_data_out0_directin;

wire clktree_in;
wire jtag_clkdr_outn_outpdir3;
wire nc_last_bs_out_directout2;
wire jtag_clkdr_outn_outpclk2;
wire jtag_clkdr_outpclk2;
wire jtag_rx_scan_outpclk2;
wire jtag_rx_scan_outpclk1;
wire jtag_clkdr_outn_outpclk5;
wire jtag_clkdr_outpclk5;
wire jtag_rx_scan_outpclk5;
wire nc_last_bs_out_outpclk5;
wire jtag_clkdr_outn_outpclk6;
wire last_bs_out_outpclk6;
wire jtag_clkdr_outn_outpclk1;
wire nc_pd_data_out0_dout_clkp;
wire nc_oclk_dout_clkp;
wire nc_oclkb_clkp;
wire nc_odat0_dout_clkp;
wire nc_odat1_dout_clkp;
wire nc_odat_async_dout_clkp;
wire nc_pd_data_dout_clkp;
wire nc_odat_async_out0_dout_clkp;
wire jtag_clkdr_outpclk1;
wire nc_odat1_out0_dout_clkp;
wire nc_odat0_out0_dout_clkp;
wire nc_oclk_out0_dout_clkp;
wire nc_last_bs_out_outpclk1;
wire nc_oclkb_out0_dout_clkp;
wire nc_oclkn_out0_dout_clkp;
wire jtag_clkdr_outn_outpclk1n;
wire nc_pd_data_out0_dout_clkn;
wire nc_oclk_dout_clkn;
wire nc_oclkb_clkn;
wire nc_odat0_dout_clkn;
wire nc_odat1_dout_clkn;
wire nc_odat_async_dout_clkn;
wire nc_pd_data_dout_clkn;
wire nc_odat_async_out0_dout_clkn;
wire nc_odat1_out0_dout_clkn;
wire nc_odat0_out0_dout_clkn;
wire nc_oclk_out0_dout_clkn;
wire nc_last_bs_out_dout_clkn;
wire nc_oclkb_out0_dout_clkn;
wire jtag_rx_scan_outpdir4;
wire nc_oclkn_out0_dout_clkn;
wire jtag_clkdr_outn_inpdir0_1;
wire nc_last_bs_out_directin3;
wire nc_oclkn_inpdir0_1;
wire jtag_clkdr_outn_directin1;
wire odirectout_data_poutp18;
wire jtag_clkdr_out_directin1;
wire jtag_rx_scan_out_directin1;
wire last_bs_out_directin1;
wire jtag_clkdr_outn_poutp0;
wire last_bs_out_poutp0;
wire jtag_rx_scan_out_poutp2;
wire last_bs_out_poutp2;
wire jtag_clkdr_outn_poutp2;
wire jtag_clkdr_out_poutp2;
wire jtag_rx_scan_out_poutp4;
wire last_bs_out_poutp4;
wire jtag_clkdr_outn_poutp4;
wire jtag_clkdr_out_poutp4;
wire jtag_rx_scan_out_poutp6;
wire last_bs_out_poutp6;
wire jtag_clkdr_outn_poutp6;
wire jtag_clkdr_out_poutp6;
wire jtag_rx_scan_out_poutp8;
wire last_bs_out_poutp8;
wire jtag_clkdr_outn_poutp8;
wire jtag_clkdr_out_poutp8;
wire oclk_aib_poutp8;
wire oclkb_aib_poutp8;
wire nc_jtag_rx_scan_out_tx_clkp;
wire nc_last_bs_out_tx_clkp;
wire jtag_clkdr_outn_tx_clkp;
wire ncrx_pd_data_aib_clkp;
wire nc_oclk_out_clkp;
wire nc_oclkb_out_clkp;
wire nc_odat0_out_clkp;
wire nc_odat1_out_clkp;
wire nc_odat_async_out_clkp;
wire nc_pd_data_out_clkp;
wire ncrx_odat_async_aib_clkp;
wire nc_jtag_clkdr_out_tx_clkp;
wire ncdrx_odat1_aib_clkp;
wire ncdrx_odat0_aib_clkp;
wire ncdrx_oclk_aib_clkp;
wire ncdrx_oclkb_aib_clkp;
wire jtag_rx_scan_out_poutp10;
wire last_bs_out_poutp10;
wire ncdrx_oclkn_tx_clkp;
wire jtag_clkdr_outn_poutp10;
wire jtag_clkdr_out_poutp10;
wire jtag_rx_scan_out_poutp12;
wire last_bs_out_poutp12;
wire jtag_clkdr_outn_poutp12;
wire jtag_clkdr_out_poutp12;
wire jtag_rx_scan_out_poutp14;
wire last_bs_out_poutp14;
wire jtag_clkdr_outn_poutp14;
wire jtag_clkdr_out_poutp14;
wire jtag_rx_scan_out_poutp16;
wire last_bs_out_poutp16;
wire jtag_clkdr_outn_poutp16;
wire jtag_clkdr_out_poutp16;
wire jtag_rx_scan_in_poutp18;
wire last_bs_out_poutp18;
wire jtag_clkdr_outn_poutp18;
wire pd_data_poutp18;
wire jtag_clkdr_in_poutp18;
wire odat1_poutp18;
wire odat0_poutp18;
wire ncdrx_oclk_poutp18;
wire ncdrx_oclkb_poutp18;
wire ncdrx_oclkn_poutp18;
wire jtag_clkdr_outn_tx_clkn;
wire ncrx_pd_data_aib_clkn;
wire nc_oclk_out_clkn;
wire nc_oclkb_out_clkn;
wire nc_odat0_out_clkn;
wire nc_odat1_out_clkn;
wire nc_odat_async_out_clkn;
wire nc_pd_data_out_clkn;
wire oclk_aib_poutp9;
wire ncrx_odat_async_aib_clkn;
wire oclkb_aib_poutp9;
wire nc_jtag_clkdr_out_tx_clkn;
wire ncdrx_odat1_aib_clkn;
wire nc_jtag_rx_scan_out_tx_clkn;
wire ncdrx_odat0_aib_clkn;
wire ncdrx_oclk_aib_clkn;
wire nc_last_bs_out_tx_clkn;
wire ncdrx_oclkb_aib_clkn;
wire jtag_rx_scan_out_poutp11;
wire last_bs_out_poutp11;
wire ncdrx_oclkn_tx_clkn;
wire jtag_clkdr_outn_poutp11;
wire jtag_clkdr_out_poutp11;
wire jtag_rx_scan_out_poutp13;
wire last_bs_out_poutp13;
wire jtag_clkdr_outn_poutp13;
wire jtag_clkdr_out_poutp13;
wire jtag_rx_scan_out_poutp15;
wire last_bs_out_poutp15;
wire jtag_clkdr_outn_poutp15;
wire jtag_clkdr_out_poutp15;
wire jtag_rx_scan_out_poutp17;
wire last_bs_out_poutp17;
wire jtag_clkdr_outn_poutp17;
wire jtag_clkdr_out_poutp17;
wire jtag_rx_scan_out_poutp19;
wire last_bs_out_poutp19;
wire jtag_clkdr_outn_poutp19;
wire pd_data_poutp19;
wire jtag_clkdr_out_poutp19;
wire odat1_poutp19;
wire odat0_poutp19;
wire ncdrx_oclk_poutp19;
wire ncdrx_oclkb_poutp19;
wire ncdrx_oclkn_poutp19;
wire jtag_clkdr_outn_poutp7;
wire jtag_clkdr_out_poutp7;
wire jtag_rx_scan_out_poutp7;
wire last_bs_out_poutp7;
wire jtag_rx_scan_out_poutp9;
wire last_bs_out_poutp9;
wire jtag_clkdr_outn_poutp9;
wire jtag_clkdr_out_poutp9;
wire jtag_clkdr_outn_inpclk0;
wire nc_pd_data_out0_diin_clkp;
wire nc_odat0_diin_clkp;
wire nc_odat1_diin_clkp;
wire nc_odat_async_diin_clkp;
wire nc_pd_data_diin_clkp;
wire nc_odat_async_out0_diin_clkp;
wire nc_odat1_out0_diin_clkp;
wire nc_odat0_out0_diin_clkp;
wire nc_oclk_diin_clkp;
wire nc2;
wire nc_oclkb_diin_clkp;
wire nc_oclkn_out0_diin_clkp;
wire rxoclkn_clkn;
wire jtag_clkdr_outn_directout5;
wire jtag_clkdr_out_directout5;
wire jtag_rx_scan_out_directout5;
wire nc_last_bs_out_directout5;
wire jtag_clkdr_outn_inpclk1;
wire nc_oclk_out0_directin0;
wire nc_last_bs_out_directin0;
wire nc_oclkb_out0_directin0;
wire nc_oclkn_inpclk1;
wire jtag_clkdr_outn_poutp5;
wire jtag_clkdr_out_poutp5;
wire jtag_rx_scan_out_poutp5;
wire last_bs_out_poutp5;
wire jtag_clkdr_outn_inpdir2_1;
wire nc_last_bs_out_directin2;
wire jtag_rx_scan_out_diin_clkn;
wire jtag_clkdr_outn_diin_clkn;
wire nc_pd_data_out0_diin_clkn;
wire nc_oclk_diin_clkn;
wire nc_oclkb_diin_clkn;
wire nc_odat0_diin_clkn;
wire nc_odat1_diin_clkn;
wire nc_odat_async_diin_clkn;
wire nc_pd_data_diin_clkn;
wire nc_odat_async_out0_diin_clkn;
wire jtag_clkdr_out_diin_clkn;
wire nc_odat1_out0_diin_clkn;
wire nc_odat0_out0_diin_clkn;
wire nc_oclk_out0_diin_clkn;
wire nc_last_bs_out_diin_clkn;
wire nc_oclkb_out0_diin_clkn;
wire jtag_clkdr_outn_poutp3;
wire NET0857;
wire NET0856;
wire NET0858;
wire jtag_clkdr_out_poutp3;
wire jtag_rx_scan_out_poutp3;
wire last_bs_out_poutp3;
wire jtag_clkdr_outn_poutp1;
wire jtag_clkdr_out_poutp1;
wire jtag_rx_scan_out_poutp1;
wire last_bs_out_poutp1;
wire jtag_clkdr_outn_outpdir4;
wire jtag_clkdr_outpdir4;
wire last_bs_outpdir4;
wire jtag_clkdr_outn_outpdir1;
wire last_bs_out_outpdir1;
wire dcc_scan_out;
wire outbuf_clk_buf;
wire nc_idat1_outpdir3;
wire nc_idat0_outpdir3;
wire nc_idat1_outpclk2;
wire nc_idat0_outpclk2;
wire async_dat_outpclk2;
wire idat0_outpclk1;
wire idat1_outpclk1;
wire nc_idat1_outpclk5;
wire nc_idat0_outpclk5;
wire async_dat_outpclk5;
wire nc_idat1_outpclk6;
wire nc_idat0_outpclk6;
wire nc_async_dat_outpclk1;
wire nc_async_dat_outpclk1n;
wire async_dat_outpdir4;
wire nc_idat1_inpdir0_1;
wire nc_idat0_inpdir0_1;
wire nc_async_dat_inpdir0_1;
wire nc_idat1_directin1;
wire nc_idat0_directin1;
wire nc_async_dat_directin1;
wire nc_async_dat_poutp0;
wire idat0_poutp2;
wire idat1_poutp2;
wire nc_async_dat_poutp2;
wire idat0_poutp4;
wire idat1_poutp4;
wire nc_async_dat_poutp4;
wire idat0_poutp6;
wire idat1_poutp6;
wire nc_async_dat_poutp6;
wire idat0_poutp8;
wire idat1_poutp8;
wire nc_async_dat_poutp8;
wire idat0_tx_clkp;
wire idat1_tx_clkp;
wire nc_async_dat_tx_clkp;
wire idat0_poutp10;
wire idat1_poutp10;
wire nc_async_dat_poutp10;
wire idat0_poutp12;
wire idat1_poutp12;
wire nc_async_dat_poutp12;
wire idat0_poutp14;
wire idat1_poutp14;
wire nc_async_dat_poutp14;
wire idat0_poutp16;
wire idat1_poutp16;
wire nc_async_dat_poutp16;
wire idat0_poutp18;
wire idat1_poutp18;
wire nc_async_dat_poutp18;
wire idat1_tx_clkn;
wire idat0_tx_clkn;
wire nc_async_dat_tx_clkn;
wire idat0_poutp11;
wire idat1_poutp11;
wire nc_async_dat_poutp11;
wire idat0_poutp13;
wire idat1_poutp13;
wire nc_async_dat_poutp13;
wire idat0_poutp15;
wire idat1_poutp15;
wire nc_async_dat_poutp15;
wire idat0_poutp17;
wire idat1_poutp17;
wire nc_async_dat_poutp17;
wire idat0_poutp19;
wire idat1_poutp19;
wire nc_async_dat_poutp19;
wire idat1_poutp7;
wire idat0_poutp7;
wire nc_async_dat_poutp7;
wire idat0_poutp9;
wire idat1_poutp9;
wire nc_async_dat_poutp9;
wire nc_idat1_inpclk0;
wire nc_idat0_inpclk0;
wire nc_async_dat_inpclk0;
wire nc_idat1_directout5;
wire nc_idat0_directout5;
wire async_dat_directout5;
wire nc_idat1_inpclk1;
wire nc_idat0_inpclk1;
wire nc_async_dat_inpclk1;
wire idat1_poutp5;
wire idat0_poutp5;
wire nc_async_dat_poutp5;
wire nc_idat1_inpdir2_1;
wire nc_idat0_inpdir2_1;
wire nc_async_dat_inpdir2_1;
wire nc_idat1_diin_clkn;
wire nc_idat0_diin_clkn;
wire nc_async_dat_diin_clkn;
wire idat1_poutp3;
wire idat0_poutp3;
wire nc_async_dat_poutp3;
wire idat1_poutp1;
wire idat0_poutp1;
wire nc_async_dat_poutp1;
wire nc_idat1_outpdir4;
wire nc_idat0_outpdir4;
wire nc_idat1_outpdir1;
wire nc_idat0_outpdir1;

// specify
//     specparam CDS_LIBNAME  = "aibcr3_lib";
//     specparam CDS_CELLNAME = "aibcr3_rxdatapath_rx";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

	assign idat0_buf = idat0;
	assign idat1_buf = idat1;
	assign scan_out = dcc_scan_out;

wire rb_dcc_byp_inv;
assign rb_dcc_byp_inv = ~rb_dcc_byp_dprio ;

aibcr3_dcc_top x1591 ( .rb_cont_cal(rb_dcc_manual_mode_dprio),
     .scan_shift_n(scan_shift),
     .rb_clkdiv(rb_clkdiv[2:0]),
     .rb_dcc_manual_up(rb_dcc_manual_up[4:0]), .scan_rst_n(scan_rst_n),
     .clktree_out(clk_mimic0_buf),
     .rb_dcc_manual_dn(rb_dcc_manual_dn[4:0]),
     .dcc_dft_nrst_coding(dcc_dft_nrst_coding),
     .dcc_dft_nrst(dcc_dft_nrst), .dcc_dft_up(dcc_dft_up),
     .rb_dcc_dft(rb_dcc_dft), .rb_dcc_dft_sel(rb_dcc_dft_sel),
     .scan_out(dcc_scan_out), .scan_mode_n(scan_mode_n),
     .scan_in(scan_in), .pipeline_global_en(pipeline_global_en),
     .scan_clk_in(scan_clk_in), .rb_dcc_byp(rb_dcc_byp_inv),
     .clk_dcc(clktree_in), .dcc_done(dcc_done),
     .odll_dll2core(odll_dll2core[12:0]), .clk_dcd(outbuf_clk_buf),
     .csr_reg(csr_reg[51:0]), .dcc_req(dcc_req),
     .idll_core2dll(idll_core2dll[2:0]), .idll_entest(idll_entest),
     .nfrzdrv(output_rstb), .rb_dcc_en(rb_dcc_en_dprio),
     .rb_half_code(rb_half_code), .rb_selflock(rb_selflock),
     .test_clk_pll_en_n(rb_dcc_test_clk_pll_en_n));
aibcr3_aliasd  r73 ( .rb(ilaunch_clk_poutp0), .ra(tx_launch_clk_r[11]));
aibcr3_aliasd  r16 ( .rb(itxen_out_chain2), .ra(itxen[3]));
aibcr3_aliasd  r30 ( .rb(idataselb_outpdir2), .ra(idataselb[2]));
aibcr3_aliasd  r33 ( .rb(itxen_outpdir2), .ra(itxen[3]));
aibcr3_aliasd  r64 ( .rb(itxen_poutp0), .ra(itxen[0]));
aibcr3_aliasd  r69 ( .rb(shift_en_inpclk0), .ra(rx_shift_en[28]));
aibcr3_aliasd  r66 ( .rb(shift_en_inpclk1), .ra(rx_shift_en[26]));
aibcr3_aliasd  r59 ( .rb(itxen_outpclk6), .ra(itxen[3]));
aibcr3_aliasd  r58 ( .rb(idataselb_outpclk6), .ra(idataselb[2]));
aibcr3_aliasd  r56 ( .rb(shift_en_outpclk6), .ra(rx_shift_en[34]));
aibcr3_aliasd  r15 ( .rb(idataselb_out_chain2), .ra(idataselb[2]));
aibcr3_aliasd  r72 ( .rb(shift_en_out_chain2), .ra(rx_shift_en[1]));
aibcr3_aliasd  r63 ( .rb(iddren_poutp0), .ra(iddren[0]));
aibcr3_aliasd  r45[2:0] ( .ra(irxen_r1[2:0]), .rb(irxen_inpdir0_1[2:0]));
aibcr3_aliasd  r67 ( .rb(shift_en_outpclk1n), .ra(rx_shift_en[32]));
aibcr3_aliasd  r55 ( .rb(itxen_outpclk1n), .ra(itxen[2]));
aibcr3_aliasd  r65 ( .rb(shift_en_inpdir0_1), .ra(rx_shift_en[25]));
aibcr3_aliasd  r46[2:0] ( .ra(irxen_r1[2:0]), .rb(irxen_inpclk1[2:0]));
aibcr3_aliasd  r71 ( .rb(shift_en_poutp0), .ra(rx_shift_en[2]));
aibcr3_aliasd  r44[2:0] ( .ra(irxen_r1[2:0]), .rb(irxen_inpdir2_1[2:0]));
aibcr3_aliasd  r54 ( .rb(idataselb_outpclk1n), .ra(idataselb[1]));
aibcr3_aliasd  r70 ( .rb(shift_en_outpdir2), .ra(rx_shift_en[35]));
aibcr3_aliasd  r68 ( .rb(shift_en_inpdir2_1), .ra(rx_shift_en[27]));
aibcr3_aliasd  r62 ( .rb(idataselb_poutp0), .ra(idataselb[0]));
aibcr3_aliasd  aliasv52[2:0] ( .ra(irxen_r0[2:0]), .rb(irxen_inpclk0[2:0]));
assign dft_tx_clk = gated_clk_mimic1;
// Ayar change: Added explicit buffer here to isolate main clock tree from dft clk path
`ifdef BEHAVIORAL
    assign clk_mimic1_buf = clk_mimic1;
    //assign clk_mimic0_buf = clk_mimic0;
    assign clk_mimic0_buf = 1'b0;
`else
    clock_buffer dft_tx_clk_buf (.in(clk_mimic1), .out(clk_mimic1_buf));
    clock_buffer dft_tx_clk_mimic (.in(clk_mimic0), .out(clk_mimic0_buf));
`endif

aibcr3_clktree  xclktree ( //.vcc_aibcr(vcc), .vss_aibcr(vssl),
     .lstrbclk_mimic2(clk_mimic), .lstrbclk_r_11(tx_launch_clk_r[11]),
     .lstrbclk_r_10(tx_launch_clk_r[10]),
     .lstrbclk_r_9(tx_launch_clk_r[9]),
     .lstrbclk_r_8(tx_launch_clk_r[8]),
     .lstrbclk_r_7(tx_launch_clk_r[7]),
     .lstrbclk_r_6(tx_launch_clk_r[6]),
     .lstrbclk_r_5(tx_launch_clk_r[5]),
     .lstrbclk_r_4(tx_launch_clk_r[4]),
     .lstrbclk_r_3(tx_launch_clk_r[3]),
     .lstrbclk_r_2(tx_launch_clk_r[2]),
     .lstrbclk_r_1(tx_launch_clk_r[1]),
     .lstrbclk_r_0(tx_launch_clk_r[0]), .lstrbclk_mimic1(clk_mimic1),
     .lstrbclk_mimic0(clk_mimic0), .lstrbclk_l_0(tx_launch_clk_l[0]),
     .lstrbclk_l_1(tx_launch_clk_l[1]),
     .lstrbclk_l_2(tx_launch_clk_l[2]),
     .lstrbclk_l_3(tx_launch_clk_l[3]),
     .lstrbclk_l_4(tx_launch_clk_l[4]),
     .lstrbclk_l_5(tx_launch_clk_l[5]),
     .lstrbclk_l_6(tx_launch_clk_l[6]),
     .lstrbclk_l_7(tx_launch_clk_l[7]),
     .lstrbclk_l_8(tx_launch_clk_l[8]),
     .lstrbclk_l_9(tx_launch_clk_l[9]),
     .lstrbclk_l_10(tx_launch_clk_l[10]),
     .lstrbclk_l_11(tx_launch_clk_l[11]), .lstrbclk_rep(clk_rep),
     .clkin(clktree_in));
aibcr3_buffx1_top xdirect_out2 (
     .idata1_in1_jtag_out(nc_idat1_outpdir3),
     .idata0_in1_jtag_out(nc_idat0_outpdir3),
     .async_dat_in1_jtag_out(async_dat_outpdir2),
     .prev_io_shift_en(shift_en_oshared0),
     .jtag_clkdr_outn(jtag_clkdr_outn_outpdir3),
     .jtag_clksel(jtag_clksel), .jtag_rstb_en(jtag_rstb_en),
     .jtag_intest(jtag_intest), .anlg_rstb(output_rstb),
     .pd_data_aib(nc_pd_data_out0_directout[2]),
     .oclk_out(nc_oclk_directout[2]),
     .oclkb_out(nc_oclkb_directout[2]),
     .odat0_out(nc_odata0_directout[2]),
     .odat1_out(nc_odata1_directout[2]),
     .odat_async_out(nc_odat_async_out[2]),
     .pd_data_out(nc_pd_data_directout[2]),
     .async_dat_in0(idirectout_data[2]), .async_dat_in1(vssl),
     .iclkin_dist_in0(vssl), .iclkin_dist_in1(vssl), .idata0_in0(vssl),
     .idata0_in1(idat0_oshared0), .idata1_in0(vssl),
     .idata1_in1(idat1_oshared0), .idataselb_in0(idataselb[2]),
     .idataselb_in1(idataselb_oshared0), .iddren_in0(vssl),
     .iddren_in1(vcc), .ilaunch_clk_in0(vssl),
     .ilaunch_clk_in1(ilaunch_clk_oshared0), .ilpbk_dat_in0(vssl),
     .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl), .ilpbk_en_in1(vssl),
     .indrv_in0(indrv_r56[1:0]), .indrv_in1(indrv_r56[1:0]),
     .ipdrv_in0(ipdrv_r56[1:0]), .ipdrv_in1(ipdrv_r56[1:0]),
     .irxen_in0({vssl, vcc, vssl}), .irxen_in1({vssl, vcc, vssl}),
     .istrbclk_in0(vssl), .istrbclk_in1(vssl), .itxen_in0(itxen[3]),
     .itxen_in1(itxen_oshared0), .oclk_in1(vssl),
     .odat_async_aib(odat_async_aib_directout[2]), .oclkb_in1(vssl),
     /*.vssl(vssl),*/ .odat0_in1(vssl), /*.vccl(vccl),*/ .odat1_in1(vssl),
     .odat_async_in1(vssl), .shift_en(rx_shift_en[35]),
     .pd_data_in1(vssl), .dig_rstb(output_rstb),
     .jtag_clkdr_out(jtag_clkdr_outpdir2), /*.vcc(vcc),*/
     .odat1_aib(nc_odata1_out0_directout[2]),
     .jtag_rx_scan_out(jtag_rx_scan_outpdir2),
     .odat0_aib(nc_odata0_out0_directout[2]),
     .oclk_aib(nc_oclk_out0_directout[2]),
     .last_bs_out(nc_last_bs_out_directout2),
     .por_aib_vccl(por_aib_vccl), .por_aib_vcchssi(por_aib_vcchssi),
     .oclkb_aib(nc_oclkb_out0_directout[2]),
     .jtag_clkdr_in(clkdr_xr5r), .jtag_mode_in(jtag_mode_in),
     .jtag_rstb(jtag_rstb), .jtag_tx_scan_in(jtag_rx_scan_oshared0),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_directout[2]), .oclkn(nc_oclkn_out0_directout[2]),
     .iclkn(vssl), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xdirect_out6 (
     .idata1_in1_jtag_out(nc_idat1_outpclk2),
     .idata0_in1_jtag_out(nc_idat0_outpclk2),
     .async_dat_in1_jtag_out(async_dat_outpclk2),
     .prev_io_shift_en(rx_shift_en[31]),
     .jtag_clkdr_outn(jtag_clkdr_outn_outpclk2),
     .jtag_clksel(jtag_clksel), .jtag_rstb_en(jtag_rstb_en),
     .jtag_intest(jtag_intest), .anlg_rstb(output_rstb),
     .pd_data_aib(nc_pd_data_out0_directout[6]),
     .oclk_out(nc_oclk_directout[6]),
     .oclkb_out(nc_oclkb_directout[6]),
     .odat0_out(nc_odata0_directout[6]),
     .odat1_out(nc_odata1_directout[6]),
     .odat_async_out(nc_odat_async_out[6]),
     .pd_data_out(nc_pd_data_directout[6]),
     .async_dat_in0(idirectout_data[6]), .async_dat_in1(vssl),
     .iclkin_dist_in0(vssl), .iclkin_dist_in1(vssl), .idata0_in0(vssl),
     .idata0_in1(idat0_outpclk1), .idata1_in0(vssl),
     .idata1_in1(idat1_outpclk1), .idataselb_in0(idataselb[2]),
     .idataselb_in1(idataselb[1]), .iddren_in0(vssl), .iddren_in1(vcc),
     .ilaunch_clk_in0(vssl), .ilaunch_clk_in1(txdirclk_fast_clkp),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0(indrv_r78[1:0]),
     .indrv_in1(indrv_r78[1:0]), .ipdrv_in0(ipdrv_r78[1:0]),
     .ipdrv_in1(ipdrv_r78[1:0]), .irxen_in0({vssl, vcc, vssl}),
     .irxen_in1({vssl, vcc, vssl}), .istrbclk_in0(vssl),
     .istrbclk_in1(vssl), .itxen_in0(itxen[3]), .itxen_in1(itxen[2]),
     .oclk_in1(vssl), .odat_async_aib(nc_odat_async_aib_directout[6]),
     .oclkb_in1(vssl), /*.vssl(vssl),*/ .odat0_in1(vssl), /*.vccl(vccl),*/
     .odat1_in1(vssl), .odat_async_in1(vssl),
     .shift_en(rx_shift_en[36]), .pd_data_in1(vssl),
     .dig_rstb(output_rstb), .jtag_clkdr_out(jtag_clkdr_outpclk2),
     /*.vcc(vcc),*/ .odat1_aib(nc_odata1_out0_directout[6]),
     .jtag_rx_scan_out(jtag_rx_scan_outpclk2),
     .odat0_aib(nc_odata0_out0_directout[6]),
     .oclk_aib(nc_oclk_out0_directout[6]),
     .last_bs_out(nc_last_bs_out_directout[6]),
     .por_aib_vccl(por_aib_vccl), .por_aib_vcchssi(por_aib_vcchssi),
     .oclkb_aib(nc_oclkb_out0_directout[6]),
     .jtag_clkdr_in(clkdr_xr7l), .jtag_mode_in(jtag_mode_in),
     .jtag_rstb(jtag_rstb), .jtag_tx_scan_in(jtag_rx_scan_outpclk1),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_directout[6]), .oclkn(nc_oclkn_out0_directout[6]),
     .iclkn(vssl), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xdirect_out4 (
     .idata1_in1_jtag_out(nc_idat1_outpclk5),
     .idata0_in1_jtag_out(nc_idat0_outpclk5),
     .async_dat_in1_jtag_out(async_dat_outpclk5),
     .prev_io_shift_en(rx_shift_en[36]),
     .jtag_clkdr_outn(jtag_clkdr_outn_outpclk5),
     .jtag_clksel(jtag_clksel), .jtag_rstb_en(jtag_rstb_en),
     .jtag_intest(jtag_intest), .anlg_rstb(output_rstb),
     .pd_data_aib(nc_pd_data_out0_directout[4]),
     .oclk_out(nc_oclk_directout[4]),
     .oclkb_out(nc_oclkb_directout[4]),
     .odat0_out(nc_odata0_directout[4]),
     .odat1_out(nc_odata1_directout[4]),
     .odat_async_out(odat_async_out[4]),
     .pd_data_out(nc_pd_data_directout[4]),
     .async_dat_in0(idirectout_data[4]),
     .async_dat_in1(async_dat_outpclk2), .iclkin_dist_in0(vssl),
     .iclkin_dist_in1(vssl), .idata0_in0(vssl), .idata0_in1(vssl),
     .idata1_in0(vssl), .idata1_in1(vssl),
     .idataselb_in0(idataselb[2]), .idataselb_in1(idataselb[2]),
     .iddren_in0(vssl), .iddren_in1(vssl), .ilaunch_clk_in0(vssl),
     .ilaunch_clk_in1(vssl), .ilpbk_dat_in0(vssl),
     .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl), .ilpbk_en_in1(vssl),
     .indrv_in0(indrv_r56[1:0]), .indrv_in1(indrv_r56[1:0]),
     .ipdrv_in0(ipdrv_r56[1:0]), .ipdrv_in1(ipdrv_r56[1:0]),
     .irxen_in0({vssl, vcc, vssl}), .irxen_in1({vssl, vcc, vssl}),
     .istrbclk_in0(vssl), .istrbclk_in1(vssl), .itxen_in0(itxen[3]),
     .itxen_in1(itxen[3]), .oclk_in1(vssl),
     .odat_async_aib(nc_odat_async_aib_directout[4]), .oclkb_in1(vssl),
     /*.vssl(vssl),*/ .odat0_in1(vssl), /*.vccl(vccl),*/ .odat1_in1(vssl),
     .odat_async_in1(vssl), .shift_en(rx_shift_en[33]),
     .pd_data_in1(vssl), .dig_rstb(output_rstb),
     .jtag_clkdr_out(jtag_clkdr_outpclk5), /*.vcc(vcc),*/
     .odat1_aib(nc_odata1_out0_directout[4]),
     .jtag_rx_scan_out(jtag_rx_scan_outpclk5),
     .odat0_aib(nc_odata0_out0_directout[4]),
     .oclk_aib(nc_oclk_out0_directout[4]),
     .last_bs_out(nc_last_bs_out_outpclk5),
     .por_aib_vccl(por_aib_vccl), .por_aib_vcchssi(por_aib_vcchssi),
     .oclkb_aib(nc_oclkb_out0_directout[4]),
     .jtag_clkdr_in(clkdr_xr5l), .jtag_mode_in(jtag_mode_in),
     .jtag_rstb(jtag_rstb), .jtag_tx_scan_in(jtag_rx_scan_outpclk2),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_directout[4]), .oclkn(nc_oclkn_out0_directout[4]),
     .iclkn(vssl), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xdirect_out3 (
     .idata1_in1_jtag_out(nc_idat1_outpclk6),
     .idata0_in1_jtag_out(nc_idat0_outpclk6),
     .async_dat_in1_jtag_out(async_dat_outpclk6),
     .prev_io_shift_en(shift_en_in_chain2),
     .jtag_clkdr_outn(jtag_clkdr_outn_outpclk6),
     .jtag_clksel(jtag_clksel), .jtag_rstb_en(jtag_rstb_en),
     .jtag_intest(jtag_intest), .anlg_rstb(output_rstb),
     .pd_data_aib(nc_pd_data_out0_directout[3]),
     .oclk_out(nc_oclk_directout[3]),
     .oclkb_out(nc_oclkb_directout[3]),
     .odat0_out(nc_odata0_directout[3]),
     .odat1_out(nc_odata1_directout[3]),
     .odat_async_out(nc_odat_async_out_directout[3]),
     .pd_data_out(nc_pd_data_directout[3]),
     .async_dat_in0(idirectout_data[3]),
     .async_dat_in1(idirectout_data_in_chain2), .iclkin_dist_in0(vssl),
     .iclkin_dist_in1(vssl), .idata0_in0(vssl), .idata0_in1(vssl),
     .idata1_in0(vssl), .idata1_in1(vssl),
     .idataselb_in0(idataselb[2]), .idataselb_in1(idataselb_in_chain2),
     .iddren_in0(vssl), .iddren_in1(vssl), .ilaunch_clk_in0(vssl),
     .ilaunch_clk_in1(vssl), .ilpbk_dat_in0(vssl),
     .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl), .ilpbk_en_in1(vssl),
     .indrv_in0(indrv_r78[1:0]), .indrv_in1(indrv_r78[1:0]),
     .ipdrv_in0(ipdrv_r78[1:0]), .ipdrv_in1(ipdrv_r78[1:0]),
     .irxen_in0({vssl, vcc, vssl}), .irxen_in1({vssl, vcc, vssl}),
     .istrbclk_in0(vssl), .istrbclk_in1(vssl), .itxen_in0(itxen[3]),
     .itxen_in1(itxen_in_chain2), .oclk_in1(vssl),
     .odat_async_aib(nc_odat_async_aib_directout[3]), .oclkb_in1(vssl),
     /*.vssl(vssl),*/ .odat0_in1(vssl), /*.vccl(vccl),*/ .odat1_in1(vssl),
     .odat_async_in1(vssl), .shift_en(rx_shift_en[34]),
     .pd_data_in1(vssl), .dig_rstb(output_rstb),
     .jtag_clkdr_out(jtag_clkdr_outpclk6), /*.vcc(vcc),*/
     .odat1_aib(nc_odata1_out0_directout[3]),
     .jtag_rx_scan_out(jtag_scan_outpclk6),
     .odat0_aib(nc_odata0_out0_directout[3]),
     .oclk_aib(nc_oclk_out0_directout[3]),
     .last_bs_out(last_bs_out_outpclk6), .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi),
     .oclkb_aib(nc_oclkb_out0_directout[3]),
     .jtag_clkdr_in(clkdr_xr8r), .jtag_mode_in(jtag_mode_in),
     .jtag_rstb(jtag_rstb), .jtag_tx_scan_in(jtag_rx_scan_in_chain2),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_directout[3]), .oclkn(nc_oclkn_out0_directout[3]),
     .iclkn(vssl), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xxdout_clkp ( .idata1_in1_jtag_out(idat1_outpclk1),
     .idata0_in1_jtag_out(idat0_outpclk1),
     .async_dat_in1_jtag_out(nc_async_dat_outpclk1),
     .prev_io_shift_en(shift_en_outpdir3),
     .jtag_clkdr_outn(jtag_clkdr_outn_outpclk1),
     .jtag_clksel(jtag_clksel), .jtag_rstb_en(jtag_rstb_en),
     .jtag_intest(jtag_intest), .anlg_rstb(output_rstb),
     .pd_data_aib(nc_pd_data_out0_dout_clkp),
     .oclk_out(nc_oclk_dout_clkp), .oclkb_out(nc_oclkb_clkp),
     .odat0_out(nc_odat0_dout_clkp), .odat1_out(nc_odat1_dout_clkp),
     .odat_async_out(nc_odat_async_dout_clkp),
     .pd_data_out(nc_pd_data_dout_clkp), .async_dat_in0(vssl),
     .async_dat_in1(async_dat_outpdir3),
     .iclkin_dist_in0(jtag_clkdr_outn_outpclk1),
     .iclkin_dist_in1(vssl), .idata0_in0(idat0_directoutclkp),
     .idata0_in1(vssl), .idata1_in0(idat1_directoutclkp),
     .idata1_in1(vssl), .idataselb_in0(idataselb[1]),
     .idataselb_in1(idataselb_outpdir3), .iddren_in0(vcc),
     .iddren_in1(vssl), .ilaunch_clk_in0(txdirclk_fast_clkp),
     .ilaunch_clk_in1(vssl), .ilpbk_dat_in0(vssl),
     .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl), .ilpbk_en_in1(vssl),
     .indrv_in0(indrv_r78[1:0]), .indrv_in1(indrv_r78[1:0]),
     .ipdrv_in0(ipdrv_r78[1:0]), .ipdrv_in1(ipdrv_r78[1:0]),
     .irxen_in0({vssl, vcc, vssl}), .irxen_in1({vssl, vcc, vssl}),
     .istrbclk_in0(jtag_clkdr_outn_outpclk1), .istrbclk_in1(vssl),
     .itxen_in0(itxen[2]), .itxen_in1(itxen_outpdir3), .oclk_in1(vssl),
     .odat_async_aib(nc_odat_async_out0_dout_clkp), .oclkb_in1(vssl),
     /*.vssl(vssl),*/ .odat0_in1(vssl), /*.vccl(vccl),*/ .odat1_in1(vssl),
     .odat_async_in1(vssl), .shift_en(rx_shift_en[31]),
     .pd_data_in1(vssl), .dig_rstb(output_rstb),
     .jtag_clkdr_out(jtag_clkdr_outpclk1), /*.vcc(vcc),*/
     .odat1_aib(nc_odat1_out0_dout_clkp),
     .jtag_rx_scan_out(jtag_rx_scan_outpclk1),
     .odat0_aib(nc_odat0_out0_dout_clkp),
     .oclk_aib(nc_oclk_out0_dout_clkp),
     .last_bs_out(nc_last_bs_out_outpclk1),
     .por_aib_vccl(por_aib_vccl), .por_aib_vcchssi(por_aib_vcchssi),
     .oclkb_aib(nc_oclkb_out0_dout_clkp), .jtag_clkdr_in(clkdr_xr7l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_outpdir3),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_directoutclkp), .oclkn(nc_oclkn_out0_dout_clkp),
     .iclkn(vssl), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xxdout_clkn ( .idata1_in1_jtag_out(idat1_outpclk1n),
     .idata0_in1_jtag_out(idat0_outpclk1n),
     .async_dat_in1_jtag_out(nc_async_dat_outpclk1n),
     .prev_io_shift_en(rx_shift_en[0]),
     .jtag_clkdr_outn(jtag_clkdr_outn_outpclk1n),
     .jtag_clksel(jtag_clksel), .jtag_rstb_en(jtag_rstb_en),
     .jtag_intest(jtag_intest), .anlg_rstb(output_rstb),
     .pd_data_aib(nc_pd_data_out0_dout_clkn),
     .oclk_out(nc_oclk_dout_clkn), .oclkb_out(nc_oclkb_clkn),
     .odat0_out(nc_odat0_dout_clkn), .odat1_out(nc_odat1_dout_clkn),
     .odat_async_out(nc_odat_async_dout_clkn),
     .pd_data_out(nc_pd_data_dout_clkn), .async_dat_in0(vssl),
     .async_dat_in1(async_dat_outpdir4),
     .iclkin_dist_in0(jtag_clkdr_outn_outpclk1n),
     .iclkin_dist_in1(vssl), .idata0_in0(idat0_directoutclkn),
     .idata0_in1(vssl), .idata1_in0(idat1_directoutclkn),
     .idata1_in1(vssl), .idataselb_in0(idataselb[1]),
     .idataselb_in1(idataselb[2]), .iddren_in0(vcc), .iddren_in1(vssl),
     .ilaunch_clk_in0(txdirclk_fast_clkp), .ilaunch_clk_in1(vssl),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0(indrv_r78[1:0]),
     .indrv_in1(indrv_r78[1:0]), .ipdrv_in0(ipdrv_r78[1:0]),
     .ipdrv_in1(ipdrv_r78[1:0]), .irxen_in0({vssl, vcc, vssl}),
     .irxen_in1({vssl, vcc, vssl}),
     .istrbclk_in0(jtag_clkdr_outn_outpclk1n), .istrbclk_in1(vssl),
     .itxen_in0(itxen[2]), .itxen_in1(itxen[3]), .oclk_in1(vssl),
     .odat_async_aib(nc_odat_async_out0_dout_clkn), .oclkb_in1(vssl),
     /*.vssl(vssl),*/ .odat0_in1(vssl), /*.vccl(vccl),*/ .odat1_in1(vssl),
     .odat_async_in1(vssl), .shift_en(rx_shift_en[32]),
     .pd_data_in1(vssl), .dig_rstb(output_rstb),
     .jtag_clkdr_out(jtag_clkdr_outpclk1n), /*.vcc(vcc),*/
     .odat1_aib(nc_odat1_out0_dout_clkn),
     .jtag_rx_scan_out(jtag_scan_outpclk1n),
     .odat0_aib(nc_odat0_out0_dout_clkn),
     .oclk_aib(nc_oclk_out0_dout_clkn),
     .last_bs_out(nc_last_bs_out_dout_clkn),
     .por_aib_vccl(por_aib_vccl), .por_aib_vcchssi(por_aib_vcchssi),
     .oclkb_aib(nc_oclkb_out0_dout_clkn), .jtag_clkdr_in(clkdr_xr8l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_outpdir4),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_directoutclkn), .oclkn(nc_oclkn_out0_dout_clkn),
     .iclkn(vssl), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xdirect_in3 (
     .idata1_in1_jtag_out(nc_idat1_inpdir0_1),
     .idata0_in1_jtag_out(nc_idat0_inpdir0_1),
     .async_dat_in1_jtag_out(nc_async_dat_inpdir0_1),
     .prev_io_shift_en(shift_en_voutp1),
     .jtag_clkdr_outn(jtag_clkdr_outn_inpdir0_1),
     .jtag_clksel(jtag_clksel), .jtag_rstb_en(jtag_rstb_en),
     .jtag_intest(jtag_intest), /*.vcc(vcc),*/ .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(output_rstb),
     .pd_data_aib(nc_pd_data_out0_directin[3]),
     .oclk_out(nc_oclk_directin[3]), .oclkb_out(nc_oclkb_directin[3]),
     .odat0_out(nc_odat0_directin[3]),
     .odat1_out(nc_odat1_directin[3]),
     .odat_async_out(odirectin_data[3]),
     .pd_data_out(nc_pd_data_directin[3]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(vssl),
     .iclkin_dist_in1(vssl), .idata0_in0(vssl),
     .idata0_in1(idata0_voutp1), .idata1_in0(vssl),
     .idata1_in1(idata1_voutp1), .idataselb_in0(vssl),
     .idataselb_in1(idataselb_voutp1), .iddren_in0(vssl),
     .iddren_in1(vssl), .ilaunch_clk_in0(vssl),
     .ilaunch_clk_in1(ilaunch_clk_voutp1), .ilpbk_dat_in0(vssl),
     .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl), .ilpbk_en_in1(vssl),
     .indrv_in0({vssl, vssl}), .indrv_in1(indrv_r78[1:0]),
     .ipdrv_in0({vssl, vssl}), .ipdrv_in1(ipdrv_r78[1:0]),
     .irxen_in0(irxen_r1[2:0]), .irxen_in1({vssl, vcc, vssl}),
     .istrbclk_in0(vssl), .istrbclk_in1(vssl), .itxen_in0(vssl),
     .itxen_in1(itxen_voutp1), .oclk_in1(vssl),
     .odat_async_aib(nc_odat_async_out0_directin[3]), .oclkb_in1(vssl),
     /*.vssl(vssl),*/ .odat0_in1(vssl), /*.vccl(vccl),*/ .odat1_in1(vssl),
     .odat_async_in1(odat_async_outclk0n), .shift_en(rx_shift_en[25]),
     .pd_data_in1(vssl), .dig_rstb(output_rstb),
     .jtag_clkdr_out(jtag_clkdr_inpdir0_1),
     .odat1_aib(nc_odat1_out0_directin[3]),
     .jtag_rx_scan_out(jtag_rx_scan_inpdir0_1),
     .odat0_aib(nc_odat0_out0_directin[3]),
     .oclk_aib(nc_oclk_out0_directin[3]),
     .last_bs_out(nc_last_bs_out_directin3),
     .oclkb_aib(nc_oclkb_out0_directin[3]), .jtag_clkdr_in(clkdr_xr8l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_voutp1),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_direct_input[3]), .oclkn(nc_oclkn_inpdir0_1),
     .iclkn(vssl), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xdirect_in1 (
     .idata1_in1_jtag_out(nc_idat1_directin1),
     .idata0_in1_jtag_out(nc_idat0_directin1),
     .async_dat_in1_jtag_out(nc_async_dat_directin1),
     .prev_io_shift_en(shift_en_pinp18),
     .jtag_clkdr_outn(jtag_clkdr_outn_directin1),
     .jtag_clksel(jtag_clksel), .jtag_rstb_en(jtag_rstb_en),
     .jtag_intest(jtag_intest), /*.vcc(vcc),*/ .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(output_rstb),
     .pd_data_aib(nc_pd_data_out0_directin[1]),
     .oclk_out(nc_oclk_directin[1]), .oclkb_out(nc_oclkb_directin[1]),
     .odat0_out(nc_odat0_directin[1]),
     .odat1_out(nc_odat1_directin[1]),
     .odat_async_out(odirectin_data[1]),
     .pd_data_out(nc_pd_data_directin[1]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(iclkin_dist_pinp18),
     .iclkin_dist_in1(iclkin_dist_pinp18), .idata0_in0(vssl),
     .idata0_in1(vssl), .idata1_in0(vssl), .idata1_in1(vssl),
     .idataselb_in0(vssl), .idataselb_in1(vssl), .iddren_in0(vssl),
     .iddren_in1(vssl), .ilaunch_clk_in0(vssl), .ilaunch_clk_in1(vssl),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0({vssl, vssl}), .indrv_in1({vssl,
     vssl}), .ipdrv_in0({vssl, vssl}), .ipdrv_in1({vssl, vssl}),
     .irxen_in0(irxen_r1[2:0]), .irxen_in1(irxen_pinp18[2:0]),
     .istrbclk_in0(istrbclk_pinp18), .istrbclk_in1(istrbclk_pinp18),
     .itxen_in0(vssl), .itxen_in1(vssl), .oclk_in1(vssl),
     .odat_async_aib(nc_odat_async_out0_directin[1]), .oclkb_in1(vssl),
     /*.vssl(vssl),*/ .odat0_in1(vssl), /*.vccl(vccl),*/ .odat1_in1(vssl),
     .odat_async_in1(odirectout_data_poutp18),
     .shift_en(rx_shift_en[24]), .pd_data_in1(vssl),
     .dig_rstb(txpma_dig_rstb),
     .jtag_clkdr_out(jtag_clkdr_out_directin1),
     .odat1_aib(odat1_aib_inpdir5_1),
     .jtag_rx_scan_out(jtag_rx_scan_out_directin1),
     .odat0_aib(odat0_aib_inpdir5_1),
     .oclk_aib(nc_oclk_out0_directin[1]),
     .last_bs_out(last_bs_out_directin1),
     .oclkb_aib(nc_oclkb_out0_directin[1]), .jtag_clkdr_in(clkdr_xr3l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_pinp18),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_direct_input[1]), .oclkn(nc_oclkn_out0_directin[1]),
     .iclkn(vssl), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xpoutp0 ( .idata1_in1_jtag_out(idata1_poutp0),
     .idata0_in1_jtag_out(idata0_poutp0),
     .async_dat_in1_jtag_out(nc_async_dat_poutp0),
     .prev_io_shift_en(rx_shift_en[4]),
     .jtag_clkdr_outn(jtag_clkdr_outn_poutp0),
     .jtag_clksel(jtag_clksel), .jtag_rstb_en(jtag_rstb_en),
     .jtag_intest(jtag_intest), /*.vcc(vcc),*/ .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(output_rstb),
     .pd_data_aib(ncrx_pd_data_aib_poutp[0]),
     .oclk_out(nc_oclk_out_poutp[0]),
     .oclkb_out(nc_oclkb_out_poutp[0]),
     .odat0_out(nc_odat0_out_poutp[0]),
     .odat1_out(nc_odat1_out_poutp[0]),
     .odat_async_out(nc_odat_async_out_poutp[0]),
     .pd_data_out(nc_pd_data_out_poutp[0]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(jtag_clkdr_outn_poutp0),
     .iclkin_dist_in1(vssl), .idata0_in0(idat0_buf[0]),
     .idata0_in1(idat0_poutp2), .idata1_in0(idat1_buf[0]),
     .idata1_in1(idat1_poutp2), .idataselb_in0(idataselb[0]),
     .idataselb_in1(idataselb[0]), .iddren_in0(iddren[0]),
     .iddren_in1(iddren[0]), .ilaunch_clk_in0(tx_launch_clk_r[7]),
     .ilaunch_clk_in1(tx_launch_clk_r[7]), .ilpbk_dat_in0(vssl),
     .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl), .ilpbk_en_in1(vssl),
     .indrv_in0(indrv_r12[1:0]), .indrv_in1(indrv_r12[1:0]),
     .ipdrv_in0(ipdrv_r12[1:0]), .ipdrv_in1(ipdrv_r12[1:0]),
     .irxen_in0({vssl, vcc, vssl}), .irxen_in1({vssl, vcc, vssl}),
     .istrbclk_in0(jtag_clkdr_outn_poutp0), .istrbclk_in1(vssl),
     .itxen_in0(itxen[0]), .itxen_in1(itxen[0]), .oclk_in1(vssl),
     .odat_async_aib(ncrx_odat_async_aib_poutp[0]), .oclkb_in1(vssl),
     /*.vssl(vssl),*/ .odat0_in1(vssl), /*.vccl(vccl),*/ .odat1_in1(vssl),
     .odat_async_in1(vssl), .shift_en(rx_shift_en[2]),
     .pd_data_in1(vssl), .dig_rstb(poutp_dig_rstb),
     .jtag_clkdr_out(jtag_clkdr_out_poutp0),
     .odat1_aib(ncdrx_odat1_aib_poutp[0]),
     .jtag_rx_scan_out(jtag_rx_scan_out_poutp0),
     .odat0_aib(ncdrx_odat0_aib_poutp[0]),
     .oclk_aib(ncdrx_oclk_aib_poutp[0]),
     .last_bs_out(last_bs_out_poutp0),
     .oclkb_aib(ncdrx_oclkb_aib_poutp[0]), .jtag_clkdr_in(clkdr_xr1r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_out_poutp2),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_out_poutp2), .iopad(iopad_dat[0]),
     .oclkn(ncdrx_oclkn_poutp[0]), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xpoutp2 ( .idata1_in1_jtag_out(idat1_poutp2),
     .idata0_in1_jtag_out(idat0_poutp2),
     .async_dat_in1_jtag_out(nc_async_dat_poutp2),
     .prev_io_shift_en(rx_shift_en[6]),
     .jtag_clkdr_outn(jtag_clkdr_outn_poutp2),
     .jtag_clksel(jtag_clksel), .jtag_rstb_en(jtag_rstb_en),
     .jtag_intest(jtag_intest), /*.vcc(vcc),*/ .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(output_rstb),
     .pd_data_aib(ncrx_pd_data_aib_poutp[2]),
     .oclk_out(nc_oclk_out_poutp[2]),
     .oclkb_out(nc_oclkb_out_poutp[2]),
     .odat0_out(nc_odat0_out_poutp[2]),
     .odat1_out(nc_odat1_out_poutp[2]),
     .odat_async_out(nc_odat_async_out_poutp[2]),
     .pd_data_out(nc_pd_data_out_poutp[2]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(jtag_clkdr_outn_poutp2),
     .iclkin_dist_in1(vssl), .idata0_in0(idat0_buf[2]),
     .idata0_in1(idat0_poutp4), .idata1_in0(idat1_buf[2]),
     .idata1_in1(idat1_poutp4), .idataselb_in0(idataselb[0]),
     .idataselb_in1(idataselb[0]), .iddren_in0(iddren[0]),
     .iddren_in1(iddren[0]), .ilaunch_clk_in0(tx_launch_clk_r[3]),
     .ilaunch_clk_in1(tx_launch_clk_r[3]), .ilpbk_dat_in0(vssl),
     .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl), .ilpbk_en_in1(vssl),
     .indrv_in0(indrv_r12[1:0]), .indrv_in1(indrv_r12[1:0]),
     .ipdrv_in0(ipdrv_r12[1:0]), .ipdrv_in1(ipdrv_r12[1:0]),
     .irxen_in0({vssl, vcc, vssl}), .irxen_in1({vssl, vcc, vssl}),
     .istrbclk_in0(jtag_clkdr_outn_poutp2), .istrbclk_in1(vssl),
     .itxen_in0(itxen[0]), .itxen_in1(itxen[0]), .oclk_in1(vssl),
     .odat_async_aib(ncrx_odat_async_aib_poutp[2]), .oclkb_in1(vssl),
     /*.vssl(vssl),*/ .odat0_in1(vssl), /*.vccl(vccl),*/ .odat1_in1(vssl),
     .odat_async_in1(vssl), .shift_en(rx_shift_en[4]),
     .pd_data_in1(vssl), .dig_rstb(poutp_dig_rstb),
     .jtag_clkdr_out(jtag_clkdr_out_poutp2),
     .odat1_aib(ncdrx_odat1_aib_poutp[2]),
     .jtag_rx_scan_out(jtag_rx_scan_out_poutp2),
     .odat0_aib(ncdrx_odat0_aib_poutp[2]),
     .oclk_aib(ncdrx_oclk_aib_poutp[2]),
     .last_bs_out(last_bs_out_poutp2),
     .oclkb_aib(ncdrx_oclkb_aib_poutp[2]), .jtag_clkdr_in(clkdr_xr1r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_out_poutp4),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_out_poutp4), .iopad(iopad_dat[2]),
     .oclkn(ncdrx_oclkn_poutp[2]), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xpoutp4 ( .idata1_in1_jtag_out(idat1_poutp4),
     .idata0_in1_jtag_out(idat0_poutp4),
     .async_dat_in1_jtag_out(nc_async_dat_poutp4),
     .prev_io_shift_en(rx_shift_en[8]),
     .jtag_clkdr_outn(jtag_clkdr_outn_poutp4),
     .jtag_clksel(jtag_clksel), .jtag_rstb_en(jtag_rstb_en),
     .jtag_intest(jtag_intest), /*.vcc(vcc),*/ .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(output_rstb),
     .pd_data_aib(ncrx_pd_data_aib_poutp[4]),
     .oclk_out(nc_oclk_out_poutp[4]),
     .oclkb_out(nc_oclkb_out_poutp[4]),
     .odat0_out(nc_odat0_out_poutp[4]),
     .odat1_out(nc_odat1_out_poutp[4]),
     .odat_async_out(nc_odat_async_out_poutp[4]),
     .pd_data_out(nc_pd_data_out_poutp[4]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(jtag_clkdr_outn_poutp4),
     .iclkin_dist_in1(vssl), .idata0_in0(idat0_buf[4]),
     .idata0_in1(idat0_poutp6), .idata1_in0(idat1_buf[4]),
     .idata1_in1(idat1_poutp6), .idataselb_in0(idataselb[0]),
     .idataselb_in1(idataselb[0]), .iddren_in0(iddren[0]),
     .iddren_in1(iddren[0]), .ilaunch_clk_in0(tx_launch_clk_r[1]),
     .ilaunch_clk_in1(tx_launch_clk_r[1]), .ilpbk_dat_in0(vssl),
     .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl), .ilpbk_en_in1(vssl),
     .indrv_in0(indrv_r12[1:0]), .indrv_in1(indrv_r12[1:0]),
     .ipdrv_in0(ipdrv_r12[1:0]), .ipdrv_in1(ipdrv_r12[1:0]),
     .irxen_in0({vssl, vcc, vssl}), .irxen_in1({vssl, vcc, vssl}),
     .istrbclk_in0(jtag_clkdr_outn_poutp4), .istrbclk_in1(vssl),
     .itxen_in0(itxen[0]), .itxen_in1(itxen[0]), .oclk_in1(vssl),
     .odat_async_aib(ncrx_odat_async_aib_poutp[4]), .oclkb_in1(vssl),
     /*.vssl(vssl),*/ .odat0_in1(vssl), /*.vccl(vccl),*/ .odat1_in1(vssl),
     .odat_async_in1(vssl), .shift_en(rx_shift_en[6]),
     .pd_data_in1(vssl), .dig_rstb(poutp_dig_rstb),
     .jtag_clkdr_out(jtag_clkdr_out_poutp4),
     .odat1_aib(ncdrx_odat1_aib_poutp[4]),
     .jtag_rx_scan_out(jtag_rx_scan_out_poutp4),
     .odat0_aib(ncdrx_odat0_aib_poutp[4]),
     .oclk_aib(ncdrx_oclk_aib_poutp[4]),
     .last_bs_out(last_bs_out_poutp4),
     .oclkb_aib(ncdrx_oclkb_aib_poutp[4]), .jtag_clkdr_in(clkdr_xr1r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_out_poutp6),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_out_poutp6), .iopad(iopad_dat[4]),
     .oclkn(ncdrx_oclkn_poutp[4]), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xpoutp6 ( .idata1_in1_jtag_out(idat1_poutp6),
     .idata0_in1_jtag_out(idat0_poutp6),
     .async_dat_in1_jtag_out(nc_async_dat_poutp6),
     .prev_io_shift_en(rx_shift_en[10]),
     .jtag_clkdr_outn(jtag_clkdr_outn_poutp6),
     .jtag_clksel(jtag_clksel), .jtag_rstb_en(jtag_rstb_en),
     .jtag_intest(jtag_intest), /*.vcc(vcc),*/ .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(output_rstb),
     .pd_data_aib(ncrx_pd_data_aib_poutp[6]),
     .oclk_out(nc_oclk_out_poutp[6]),
     .oclkb_out(nc_oclkb_out_poutp[6]),
     .odat0_out(nc_odat0_out_poutp[6]),
     .odat1_out(nc_odat1_out_poutp[6]),
     .odat_async_out(nc_odat_async_out_poutp[6]),
     .pd_data_out(nc_pd_data_out_poutp[6]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(jtag_clkdr_outn_poutp6),
     .iclkin_dist_in1(vssl), .idata0_in0(idat0_buf[6]),
     .idata0_in1(idat0_poutp8), .idata1_in0(idat1_buf[6]),
     .idata1_in1(idat1_poutp8), .idataselb_in0(idataselb[0]),
     .idataselb_in1(idataselb[0]), .iddren_in0(iddren[0]),
     .iddren_in1(iddren[0]), .ilaunch_clk_in0(tx_launch_clk_r[5]),
     .ilaunch_clk_in1(tx_launch_clk_r[5]), .ilpbk_dat_in0(vssl),
     .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl), .ilpbk_en_in1(vssl),
     .indrv_in0(indrv_r12[1:0]), .indrv_in1(indrv_r12[1:0]),
     .ipdrv_in0(ipdrv_r12[1:0]), .ipdrv_in1(ipdrv_r12[1:0]),
     .irxen_in0({vssl, vcc, vssl}), .irxen_in1({vssl, vcc, vssl}),
     .istrbclk_in0(jtag_clkdr_outn_poutp6), .istrbclk_in1(vssl),
     .itxen_in0(itxen[0]), .itxen_in1(itxen[0]), .oclk_in1(vssl),
     .odat_async_aib(ncrx_odat_async_aib_poutp[6]), .oclkb_in1(vssl),
     /*.vssl(vssl),*/ .odat0_in1(vssl), /*.vccl(vccl),*/ .odat1_in1(vssl),
     .odat_async_in1(vssl), .shift_en(rx_shift_en[8]),
     .pd_data_in1(vssl), .dig_rstb(poutp_dig_rstb),
     .jtag_clkdr_out(jtag_clkdr_out_poutp6),
     .odat1_aib(ncdrx_odat1_aib_poutp[6]),
     .jtag_rx_scan_out(jtag_rx_scan_out_poutp6),
     .odat0_aib(ncdrx_odat0_aib_poutp[6]),
     .oclk_aib(ncdrx_oclk_aib_poutp[6]),
     .last_bs_out(last_bs_out_poutp6),
     .oclkb_aib(ncdrx_oclkb_aib_poutp[6]), .jtag_clkdr_in(clkdr_xr1r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_out_poutp8),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_out_poutp8), .iopad(iopad_dat[6]),
     .oclkn(ncdrx_oclkn_poutp[6]), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xpoutp8 ( .idata1_in1_jtag_out(idat1_poutp8),
     .idata0_in1_jtag_out(idat0_poutp8),
     .async_dat_in1_jtag_out(nc_async_dat_poutp8),
     .prev_io_shift_en(rx_shift_en[12]),
     .jtag_clkdr_outn(jtag_clkdr_outn_poutp8),
     .jtag_clksel(jtag_clksel), .jtag_rstb_en(jtag_rstb_en),
     .jtag_intest(jtag_intest), /*.vcc(vcc),*/ .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(output_rstb),
     .pd_data_aib(ncrx_pd_data_aib_poutp[8]),
     .oclk_out(nc_oclk_out_poutp[8]),
     .oclkb_out(nc_oclkb_out_poutp[8]),
     .odat0_out(nc_odat0_out_poutp[8]),
     .odat1_out(nc_odat1_out_poutp[8]),
     .odat_async_out(nc_odat_async_out_poutp[8]),
     .pd_data_out(nc_pd_data_out_poutp[8]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(jtag_clkdr_outn_poutp8),
     .iclkin_dist_in1(vssl), .idata0_in0(idat0_buf[8]),
     .idata0_in1(idat0_tx_clkp), .idata1_in0(idat1_buf[8]),
     .idata1_in1(idat1_tx_clkp), .idataselb_in0(idataselb[0]),
     .idataselb_in1(idataselb[0]), .iddren_in0(iddren[0]),
     .iddren_in1(iddren[1]), .ilaunch_clk_in0(tx_launch_clk_r[9]),
     .ilaunch_clk_in1(tx_launch_clk_r[9]), .ilpbk_dat_in0(vssl),
     .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl), .ilpbk_en_in1(vssl),
     .indrv_in0(indrv_r12[1:0]), .indrv_in1(indrv_r12[1:0]),
     .ipdrv_in0(ipdrv_r12[1:0]), .ipdrv_in1(ipdrv_r12[1:0]),
     .irxen_in0({vssl, vcc, vssl}), .irxen_in1({vssl, vcc, vssl}),
     .istrbclk_in0(jtag_clkdr_outn_poutp8), .istrbclk_in1(vssl),
     .itxen_in0(itxen[0]), .itxen_in1(itxen[1]), .oclk_in1(vssl),
     .odat_async_aib(ncrx_odat_async_aib_poutp[8]), .oclkb_in1(vssl),
     /*.vssl(vssl),*/ .odat0_in1(vssl), /*.vccl(vccl),*/ .odat1_in1(vssl),
     .odat_async_in1(vssl), .shift_en(rx_shift_en[10]),
     .pd_data_in1(vssl), .dig_rstb(poutp_dig_rstb),
     .jtag_clkdr_out(jtag_clkdr_out_poutp8),
     .odat1_aib(ncdrx_odat1_aib_poutp[8]),
     .jtag_rx_scan_out(jtag_rx_scan_out_poutp8),
     .odat0_aib(ncdrx_odat0_aib_poutp[8]), .oclk_aib(oclk_aib_poutp8),
     .last_bs_out(last_bs_out_poutp8), .oclkb_aib(oclkb_aib_poutp8),
     .jtag_clkdr_in(clkdr_xr1r), .jtag_mode_in(jtag_mode_in),
     .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(nc_jtag_rx_scan_out_tx_clkp),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(nc_last_bs_out_tx_clkp), .iopad(iopad_dat[8]),
     .oclkn(ncdrx_oclkn_poutp[8]), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xrx_clkp ( .idata1_in1_jtag_out(idat1_tx_clkp),
     .idata0_in1_jtag_out(idat0_tx_clkp),
     .async_dat_in1_jtag_out(nc_async_dat_tx_clkp),
     .prev_io_shift_en(rx_shift_en[14]),
     .jtag_clkdr_outn(jtag_clkdr_outn_tx_clkp),
     .jtag_clksel(jtag_clksel), .jtag_rstb_en(jtag_rstb_en),
     .jtag_intest(jtag_intest), /*.vcc(vcc),*/ .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(output_rstb),
     .pd_data_aib(ncrx_pd_data_aib_clkp), .oclk_out(nc_oclk_out_clkp),
     .oclkb_out(nc_oclkb_out_clkp), .odat0_out(nc_odat0_out_clkp),
     .odat1_out(nc_odat1_out_clkp),
     .odat_async_out(nc_odat_async_out_clkp),
     .pd_data_out(nc_pd_data_out_clkp), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(jtag_clkdr_outn_tx_clkp),
     .iclkin_dist_in1(vssl), .idata0_in0(idat0_clkp),
     .idata0_in1(idat0_poutp10), .idata1_in0(idat1_clkp),
     .idata1_in1(idat1_poutp10), .idataselb_in0(idataselb[0]),
     .idataselb_in1(idataselb[0]), .iddren_in0(iddren[1]),
     .iddren_in1(iddren[0]), .ilaunch_clk_in0(tx_launch_clk_l[11]),
     .ilaunch_clk_in1(tx_launch_clk_l[11]), .ilpbk_dat_in0(vssl),
     .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl), .ilpbk_en_in1(vssl),
     .indrv_in0(indrv_r12[1:0]), .indrv_in1(indrv_r12[1:0]),
     .ipdrv_in0(ipdrv_r12[1:0]), .ipdrv_in1(ipdrv_r12[1:0]),
     .irxen_in0({vssl, vcc, vssl}), .irxen_in1({vssl, vcc, vssl}),
     .istrbclk_in0(jtag_clkdr_outn_tx_clkp), .istrbclk_in1(vssl),
     .itxen_in0(itxen[1]), .itxen_in1(itxen[0]),
     .oclk_in1(oclk_aib_poutp8),
     .odat_async_aib(ncrx_odat_async_aib_clkp),
     .oclkb_in1(oclkb_aib_poutp8), /*.vssl(vssl),*/ .odat0_in1(vssl),
     /*.vccl(vccl),*/ .odat1_in1(vssl), .odat_async_in1(vssl),
     .shift_en(rx_shift_en[12]), .pd_data_in1(vssl),
     .dig_rstb(poutp_dig_rstb),
     .jtag_clkdr_out(nc_jtag_clkdr_out_tx_clkp),
     .odat1_aib(ncdrx_odat1_aib_clkp),
     .jtag_rx_scan_out(nc_jtag_rx_scan_out_tx_clkp),
     .odat0_aib(ncdrx_odat0_aib_clkp), .oclk_aib(ncdrx_oclk_aib_clkp),
     .last_bs_out(nc_last_bs_out_tx_clkp),
     .oclkb_aib(ncdrx_oclkb_aib_clkp), .jtag_clkdr_in(clkdr_xr1l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_out_poutp10),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_out_poutp10), .iopad(iopad_clkp),
     .oclkn(ncdrx_oclkn_tx_clkp), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xpoutp10 ( .idata1_in1_jtag_out(idat1_poutp10),
     .idata0_in1_jtag_out(idat0_poutp10),
     .async_dat_in1_jtag_out(nc_async_dat_poutp10),
     .prev_io_shift_en(rx_shift_en[16]),
     .jtag_clkdr_outn(jtag_clkdr_outn_poutp10),
     .jtag_clksel(jtag_clksel), .jtag_rstb_en(jtag_rstb_en),
     .jtag_intest(jtag_intest), /*.vcc(vcc),*/ .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(output_rstb),
     .pd_data_aib(ncrx_pd_data_aib_poutp[10]),
     .oclk_out(nc_oclk_out_poutp[10]),
     .oclkb_out(nc_oclkb_out_poutp[10]),
     .odat0_out(nc_odat0_out_poutp[10]),
     .odat1_out(nc_odat1_out_poutp[10]),
     .odat_async_out(nc_odat_async_out_poutp[10]),
     .pd_data_out(nc_pd_data_out_poutp[10]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(jtag_clkdr_outn_poutp10),
     .iclkin_dist_in1(vssl), .idata0_in0(idat0_buf[10]),
     .idata0_in1(idat0_poutp12), .idata1_in0(idat1_buf[10]),
     .idata1_in1(idat1_poutp12), .idataselb_in0(idataselb[0]),
     .idataselb_in1(idataselb[0]), .iddren_in0(iddren[0]),
     .iddren_in1(iddren[0]), .ilaunch_clk_in0(tx_launch_clk_l[7]),
     .ilaunch_clk_in1(tx_launch_clk_l[7]), .ilpbk_dat_in0(vssl),
     .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl), .ilpbk_en_in1(vssl),
     .indrv_in0(indrv_r12[1:0]), .indrv_in1(indrv_r12[1:0]),
     .ipdrv_in0(ipdrv_r12[1:0]), .ipdrv_in1(ipdrv_r12[1:0]),
     .irxen_in0({vssl, vcc, vssl}), .irxen_in1({vssl, vcc, vssl}),
     .istrbclk_in0(jtag_clkdr_outn_poutp10), .istrbclk_in1(vssl),
     .itxen_in0(itxen[0]), .itxen_in1(itxen[0]), .oclk_in1(vssl),
     .odat_async_aib(ncrx_odat_async_aib_poutp[10]), .oclkb_in1(vssl),
     /*.vssl(vssl),*/ .odat0_in1(vssl), /*.vccl(vccl),*/ .odat1_in1(vssl),
     .odat_async_in1(vssl), .shift_en(rx_shift_en[14]),
     .pd_data_in1(vssl), .dig_rstb(poutp_dig_rstb),
     .jtag_clkdr_out(jtag_clkdr_out_poutp10),
     .odat1_aib(ncdrx_odat1_aib_poutp[10]),
     .jtag_rx_scan_out(jtag_rx_scan_out_poutp10),
     .odat0_aib(ncdrx_odat0_aib_poutp[10]),
     .oclk_aib(ncdrx_oclk_aib_poutp[10]),
     .last_bs_out(last_bs_out_poutp10),
     .oclkb_aib(ncdrx_oclkb_aib_poutp[10]), .jtag_clkdr_in(clkdr_xr1l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_out_poutp12),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_out_poutp12), .iopad(iopad_dat[10]),
     .oclkn(ncdrx_oclkn_poutp[10]), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xpoutp12 ( .idata1_in1_jtag_out(idat1_poutp12),
     .idata0_in1_jtag_out(idat0_poutp12),
     .async_dat_in1_jtag_out(nc_async_dat_poutp12),
     .prev_io_shift_en(rx_shift_en[18]),
     .jtag_clkdr_outn(jtag_clkdr_outn_poutp12),
     .jtag_clksel(jtag_clksel), .jtag_rstb_en(jtag_rstb_en),
     .jtag_intest(jtag_intest), /*.vcc(vcc),*/ .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(output_rstb),
     .pd_data_aib(ncrx_pd_data_aib_poutp[12]),
     .oclk_out(nc_oclk_out_poutp[12]),
     .oclkb_out(nc_oclkb_out_poutp[12]),
     .odat0_out(nc_odat0_out_poutp[12]),
     .odat1_out(nc_odat1_out_poutp[12]),
     .odat_async_out(nc_odat_async_out_poutp[12]),
     .pd_data_out(nc_pd_data_out_poutp[12]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(jtag_clkdr_outn_poutp12),
     .iclkin_dist_in1(vssl), .idata0_in0(idat0_buf[12]),
     .idata0_in1(idat0_poutp14), .idata1_in0(idat1_buf[12]),
     .idata1_in1(idat1_poutp14), .idataselb_in0(idataselb[0]),
     .idataselb_in1(idataselb[0]), .iddren_in0(iddren[0]),
     .iddren_in1(iddren[0]), .ilaunch_clk_in0(tx_launch_clk_l[3]),
     .ilaunch_clk_in1(tx_launch_clk_l[3]), .ilpbk_dat_in0(vssl),
     .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl), .ilpbk_en_in1(vssl),
     .indrv_in0(indrv_r12[1:0]), .indrv_in1(indrv_r12[1:0]),
     .ipdrv_in0(ipdrv_r12[1:0]), .ipdrv_in1(ipdrv_r12[1:0]),
     .irxen_in0({vssl, vcc, vssl}), .irxen_in1({vssl, vcc, vssl}),
     .istrbclk_in0(jtag_clkdr_outn_poutp12), .istrbclk_in1(vssl),
     .itxen_in0(itxen[0]), .itxen_in1(itxen[0]), .oclk_in1(vssl),
     .odat_async_aib(ncrx_odat_async_aib_poutp[12]), .oclkb_in1(vssl),
     /*.vssl(vssl),*/ .odat0_in1(vssl), /*.vccl(vccl),*/ .odat1_in1(vssl),
     .odat_async_in1(vssl), .shift_en(rx_shift_en[16]),
     .pd_data_in1(vssl), .dig_rstb(poutp_dig_rstb),
     .jtag_clkdr_out(jtag_clkdr_out_poutp12),
     .odat1_aib(ncdrx_odat1_aib_poutp[12]),
     .jtag_rx_scan_out(jtag_rx_scan_out_poutp12),
     .odat0_aib(ncdrx_odat0_aib_poutp[12]),
     .oclk_aib(ncdrx_oclk_aib_poutp[12]),
     .last_bs_out(last_bs_out_poutp12),
     .oclkb_aib(ncdrx_oclkb_aib_poutp[12]), .jtag_clkdr_in(clkdr_xr1l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_out_poutp14),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_out_poutp14), .iopad(iopad_dat[12]),
     .oclkn(ncdrx_oclkn_poutp[12]), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xpoutp14 ( .idata1_in1_jtag_out(idat1_poutp14),
     .idata0_in1_jtag_out(idat0_poutp14),
     .async_dat_in1_jtag_out(nc_async_dat_poutp14),
     .prev_io_shift_en(rx_shift_en[20]),
     .jtag_clkdr_outn(jtag_clkdr_outn_poutp14),
     .jtag_clksel(jtag_clksel), .jtag_rstb_en(jtag_rstb_en),
     .jtag_intest(jtag_intest), /*.vcc(vcc),*/ .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(output_rstb),
     .pd_data_aib(ncrx_pd_data_aib_poutp[14]),
     .oclk_out(nc_oclk_out_poutp[14]),
     .oclkb_out(nc_oclkb_out_poutp[14]),
     .odat0_out(nc_odat0_out_poutp[14]),
     .odat1_out(nc_odat1_out_poutp[14]),
     .odat_async_out(nc_odat_async_out_poutp[14]),
     .pd_data_out(nc_pd_data_out_poutp[14]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(jtag_clkdr_outn_poutp14),
     .iclkin_dist_in1(vssl), .idata0_in0(idat0_buf[14]),
     .idata0_in1(idat0_poutp16), .idata1_in0(idat1_buf[14]),
     .idata1_in1(idat1_poutp16), .idataselb_in0(idataselb[0]),
     .idataselb_in1(idataselb[0]), .iddren_in0(iddren[0]),
     .iddren_in1(iddren[0]), .ilaunch_clk_in0(tx_launch_clk_l[1]),
     .ilaunch_clk_in1(tx_launch_clk_l[1]), .ilpbk_dat_in0(vssl),
     .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl), .ilpbk_en_in1(vssl),
     .indrv_in0(indrv_r12[1:0]), .indrv_in1(indrv_r12[1:0]),
     .ipdrv_in0(ipdrv_r12[1:0]), .ipdrv_in1(ipdrv_r12[1:0]),
     .irxen_in0({vssl, vcc, vssl}), .irxen_in1({vssl, vcc, vssl}),
     .istrbclk_in0(jtag_clkdr_outn_poutp14), .istrbclk_in1(vssl),
     .itxen_in0(itxen[0]), .itxen_in1(itxen[0]), .oclk_in1(vssl),
     .odat_async_aib(ncrx_odat_async_aib_poutp[14]), .oclkb_in1(vssl),
     /*.vssl(vssl),*/ .odat0_in1(vssl), /*.vccl(vccl),*/ .odat1_in1(vssl),
     .odat_async_in1(vssl), .shift_en(rx_shift_en[18]),
     .pd_data_in1(vssl), .dig_rstb(poutp_dig_rstb),
     .jtag_clkdr_out(jtag_clkdr_out_poutp14),
     .odat1_aib(ncdrx_odat1_aib_poutp[14]),
     .jtag_rx_scan_out(jtag_rx_scan_out_poutp14),
     .odat0_aib(ncdrx_odat0_aib_poutp[14]),
     .oclk_aib(ncdrx_oclk_aib_poutp[14]),
     .last_bs_out(last_bs_out_poutp14),
     .oclkb_aib(ncdrx_oclkb_aib_poutp[14]), .jtag_clkdr_in(clkdr_xr1l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_out_poutp16),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_out_poutp16), .iopad(iopad_dat[14]),
     .oclkn(ncdrx_oclkn_poutp[14]), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xpoutp16 ( .idata1_in1_jtag_out(idat1_poutp16),
     .idata0_in1_jtag_out(idat0_poutp16),
     .async_dat_in1_jtag_out(nc_async_dat_poutp16),
     .prev_io_shift_en(rx_shift_en[22]),
     .jtag_clkdr_outn(jtag_clkdr_outn_poutp16),
     .jtag_clksel(jtag_clksel), .jtag_rstb_en(jtag_rstb_en),
     .jtag_intest(jtag_intest), /*.vcc(vcc),*/ .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(output_rstb),
     .pd_data_aib(ncrx_pd_data_aib_poutp[16]),
     .oclk_out(nc_oclk_out_poutp[16]),
     .oclkb_out(nc_oclkb_out_poutp[16]),
     .odat0_out(nc_odat0_out_poutp[16]),
     .odat1_out(nc_odat1_out_poutp[16]),
     .odat_async_out(nc_odat_async_out_poutp[16]),
     .pd_data_out(nc_pd_data_out_poutp[16]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(jtag_clkdr_outn_poutp16),
     .iclkin_dist_in1(vssl), .idata0_in0(idat0_buf[16]),
     .idata0_in1(idat0_poutp18), .idata1_in0(idat1_buf[16]),
     .idata1_in1(idat1_poutp18), .idataselb_in0(idataselb[0]),
     .idataselb_in1(idataselb[0]), .iddren_in0(iddren[0]),
     .iddren_in1(iddren[0]), .ilaunch_clk_in0(tx_launch_clk_l[5]),
     .ilaunch_clk_in1(tx_launch_clk_l[5]), .ilpbk_dat_in0(vssl),
     .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl), .ilpbk_en_in1(vssl),
     .indrv_in0(indrv_r12[1:0]), .indrv_in1(indrv_r12[1:0]),
     .ipdrv_in0(ipdrv_r12[1:0]), .ipdrv_in1(ipdrv_r12[1:0]),
     .irxen_in0({vssl, vcc, vssl}), .irxen_in1({vssl, vcc, vssl}),
     .istrbclk_in0(jtag_clkdr_outn_poutp16), .istrbclk_in1(vssl),
     .itxen_in0(itxen[0]), .itxen_in1(itxen[0]), .oclk_in1(vssl),
     .odat_async_aib(ncrx_odat_async_aib_poutp[16]), .oclkb_in1(vssl),
     /*.vssl(vssl),*/ .odat0_in1(vssl), /*.vccl(vccl),*/ .odat1_in1(vssl),
     .odat_async_in1(vssl), .shift_en(rx_shift_en[20]),
     .pd_data_in1(vssl), .dig_rstb(poutp_dig_rstb),
     .jtag_clkdr_out(jtag_clkdr_out_poutp16),
     .odat1_aib(ncdrx_odat1_aib_poutp[16]),
     .jtag_rx_scan_out(jtag_rx_scan_out_poutp16),
     .odat0_aib(ncdrx_odat0_aib_poutp[16]),
     .oclk_aib(ncdrx_oclk_aib_poutp[16]),
     .last_bs_out(last_bs_out_poutp16),
     .oclkb_aib(ncdrx_oclkb_aib_poutp[16]), .jtag_clkdr_in(clkdr_xr1l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_poutp18),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_out_poutp18), .iopad(iopad_dat[16]),
     .oclkn(ncdrx_oclkn_poutp[16]), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xpoutp18 ( .idata1_in1_jtag_out(idat1_poutp18),
     .idata0_in1_jtag_out(idat0_poutp18),
     .async_dat_in1_jtag_out(nc_async_dat_poutp18),
     .prev_io_shift_en(rx_shift_en[24]),
     .jtag_clkdr_outn(jtag_clkdr_outn_poutp18),
     .jtag_clksel(jtag_clksel), .jtag_rstb_en(jtag_rstb_en),
     .jtag_intest(jtag_intest), /*.vcc(vcc),*/ .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(output_rstb),
     .pd_data_aib(pd_data_poutp18), .oclk_out(nc_oclk_out_poutp[18]),
     .oclkb_out(nc_oclkb_out_poutp[18]),
     .odat0_out(nc_odat0_out_poutp[18]),
     .odat1_out(nc_odat1_out_poutp[18]),
     .odat_async_out(nc_odat_async_out_poutp[18]),
     .pd_data_out(nc_pd_data_out_poutp[18]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(jtag_clkdr_outn_poutp18),
     .iclkin_dist_in1(vssl), .idata0_in0(idat0_buf[18]),
     .idata0_in1(vssl), .idata1_in0(idat1_buf[18]), .idata1_in1(vssl),
     .idataselb_in0(idataselb[0]), .idataselb_in1(vssl),
     .iddren_in0(iddren[0]), .iddren_in1(vssl),
     .ilaunch_clk_in0(tx_launch_clk_l[9]),
     .ilaunch_clk_in1(tx_launch_clk_l[9]), .ilpbk_dat_in0(vssl),
     .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl), .ilpbk_en_in1(vssl),
     .indrv_in0(indrv_r12[1:0]), .indrv_in1({vssl, vssl}),
     .ipdrv_in0(ipdrv_r12[1:0]), .ipdrv_in1({vssl, vssl}),
     .irxen_in0({vssl, vcc, vssl}), .irxen_in1(irxen_r1[2:0]),
     .istrbclk_in0(jtag_clkdr_outn_poutp18), .istrbclk_in1(vssl),
     .itxen_in0(itxen[0]), .itxen_in1(vssl), .oclk_in1(vssl),
     .odat_async_aib(odirectout_data_poutp18), .oclkb_in1(vssl),
     /*.vssl(vssl),*/ .odat0_in1(vssl), /*.vccl(vccl),*/ .odat1_in1(vssl),
     .odat_async_in1(vssl), .shift_en(rx_shift_en[22]),
     .pd_data_in1(vssl), .dig_rstb(poutp_dig_rstb),
     .jtag_clkdr_out(jtag_clkdr_in_poutp18), .odat1_aib(odat1_poutp18),
     .jtag_rx_scan_out(jtag_rx_scan_in_poutp18),
     .odat0_aib(odat0_poutp18), .oclk_aib(ncdrx_oclk_poutp18),
     .last_bs_out(last_bs_out_poutp18),
     .oclkb_aib(ncdrx_oclkb_poutp18), .jtag_clkdr_in(clkdr_xr1l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_out_directin1),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_dat[18]), .oclkn(ncdrx_oclkn_poutp18), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xrx_clkn ( .idata1_in1_jtag_out(idat1_tx_clkn),
     .idata0_in1_jtag_out(idat0_tx_clkn),
     .async_dat_in1_jtag_out(nc_async_dat_tx_clkn),
     .prev_io_shift_en(rx_shift_en[15]),
     .jtag_clkdr_outn(jtag_clkdr_outn_tx_clkn),
     .jtag_clksel(jtag_clksel), .jtag_rstb_en(jtag_rstb_en),
     .jtag_intest(jtag_intest), /*.vcc(vcc),*/ .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(output_rstb),
     .pd_data_aib(ncrx_pd_data_aib_clkn), .oclk_out(nc_oclk_out_clkn),
     .oclkb_out(nc_oclkb_out_clkn), .odat0_out(nc_odat0_out_clkn),
     .odat1_out(nc_odat1_out_clkn),
     .odat_async_out(nc_odat_async_out_clkn),
     .pd_data_out(nc_pd_data_out_clkn), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(jtag_clkdr_outn_tx_clkn),
     .iclkin_dist_in1(vssl), .idata0_in0(idat0_clkn),
     .idata0_in1(idat0_poutp11), .idata1_in0(idat1_clkn),
     .idata1_in1(idat1_poutp11), .idataselb_in0(idataselb[0]),
     .idataselb_in1(idataselb[0]), .iddren_in0(iddren[1]),
     .iddren_in1(iddren[0]), .ilaunch_clk_in0(tx_launch_clk_l[10]),
     .ilaunch_clk_in1(tx_launch_clk_l[10]), .ilpbk_dat_in0(vssl),
     .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl), .ilpbk_en_in1(vssl),
     .indrv_in0(indrv_r12[1:0]), .indrv_in1(indrv_r12[1:0]),
     .ipdrv_in0(ipdrv_r12[1:0]), .ipdrv_in1(ipdrv_r12[1:0]),
     .irxen_in0({vssl, vcc, vssl}), .irxen_in1({vssl, vcc, vssl}),
     .istrbclk_in0(jtag_clkdr_outn_tx_clkn), .istrbclk_in1(vssl),
     .itxen_in0(itxen[1]), .itxen_in1(itxen[0]),
     .oclk_in1(oclk_aib_poutp9),
     .odat_async_aib(ncrx_odat_async_aib_clkn),
     .oclkb_in1(oclkb_aib_poutp9), /*.vssl(vssl),*/ .odat0_in1(vssl),
     /*.vccl(vccl),*/ .odat1_in1(vssl), .odat_async_in1(vssl),
     .shift_en(rx_shift_en[13]), .pd_data_in1(vssl),
     .dig_rstb(poutp_dig_rstb),
     .jtag_clkdr_out(nc_jtag_clkdr_out_tx_clkn),
     .odat1_aib(ncdrx_odat1_aib_clkn),
     .jtag_rx_scan_out(nc_jtag_rx_scan_out_tx_clkn),
     .odat0_aib(ncdrx_odat0_aib_clkn), .oclk_aib(ncdrx_oclk_aib_clkn),
     .last_bs_out(nc_last_bs_out_tx_clkn),
     .oclkb_aib(ncdrx_oclkb_aib_clkn), .jtag_clkdr_in(clkdr_xr2l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_out_poutp11),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_out_poutp11), .iopad(iopad_clkn),
     .oclkn(ncdrx_oclkn_tx_clkn), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xpoutp11 ( .idata1_in1_jtag_out(idat1_poutp11),
     .idata0_in1_jtag_out(idat0_poutp11),
     .async_dat_in1_jtag_out(nc_async_dat_poutp11),
     .prev_io_shift_en(rx_shift_en[17]),
     .jtag_clkdr_outn(jtag_clkdr_outn_poutp11),
     .jtag_clksel(jtag_clksel), .jtag_rstb_en(jtag_rstb_en),
     .jtag_intest(jtag_intest), /*.vcc(vcc),*/ .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(output_rstb),
     .pd_data_aib(ncrx_pd_data_aib_poutp[11]),
     .oclk_out(nc_oclk_out_poutp[11]),
     .oclkb_out(nc_oclkb_out_poutp[11]),
     .odat0_out(nc_odat0_out_poutp[11]),
     .odat1_out(nc_odat1_out_poutp[11]),
     .odat_async_out(nc_odat_async_out_poutp[11]),
     .pd_data_out(nc_pd_data_out_poutp[11]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(jtag_clkdr_outn_poutp11),
     .iclkin_dist_in1(vssl), .idata0_in0(idat0_buf[11]),
     .idata0_in1(idat0_poutp13), .idata1_in0(idat1_buf[11]),
     .idata1_in1(idat1_poutp13), .idataselb_in0(idataselb[0]),
     .idataselb_in1(idataselb[0]), .iddren_in0(iddren[0]),
     .iddren_in1(iddren[0]), .ilaunch_clk_in0(tx_launch_clk_l[6]),
     .ilaunch_clk_in1(tx_launch_clk_l[6]), .ilpbk_dat_in0(vssl),
     .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl), .ilpbk_en_in1(vssl),
     .indrv_in0(indrv_r12[1:0]), .indrv_in1(indrv_r12[1:0]),
     .ipdrv_in0(ipdrv_r12[1:0]), .ipdrv_in1(ipdrv_r12[1:0]),
     .irxen_in0({vssl, vcc, vssl}), .irxen_in1({vssl, vcc, vssl}),
     .istrbclk_in0(jtag_clkdr_outn_poutp11), .istrbclk_in1(vssl),
     .itxen_in0(itxen[0]), .itxen_in1(itxen[0]), .oclk_in1(vssl),
     .odat_async_aib(ncrx_odat_async_aib_poutp[11]), .oclkb_in1(vssl),
     /*.vssl(vssl),*/ .odat0_in1(vssl), /*.vccl(vccl),*/ .odat1_in1(vssl),
     .odat_async_in1(vssl), .shift_en(rx_shift_en[15]),
     .pd_data_in1(vssl), .dig_rstb(poutp_dig_rstb),
     .jtag_clkdr_out(jtag_clkdr_out_poutp11),
     .odat1_aib(ncdrx_odat1_aib_poutp[11]),
     .jtag_rx_scan_out(jtag_rx_scan_out_poutp11),
     .odat0_aib(ncdrx_odat0_aib_poutp[11]),
     .oclk_aib(ncdrx_oclk_aib_poutp[11]),
     .last_bs_out(last_bs_out_poutp11),
     .oclkb_aib(ncdrx_oclkb_aib_poutp[11]), .jtag_clkdr_in(clkdr_xr2l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_out_poutp13),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_out_poutp13), .iopad(iopad_dat[11]),
     .oclkn(ncdrx_oclkn_poutp[11]), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xpoutp13 ( .idata1_in1_jtag_out(idat1_poutp13),
     .idata0_in1_jtag_out(idat0_poutp13),
     .async_dat_in1_jtag_out(nc_async_dat_poutp13),
     .prev_io_shift_en(rx_shift_en[19]),
     .jtag_clkdr_outn(jtag_clkdr_outn_poutp13),
     .jtag_clksel(jtag_clksel), .jtag_rstb_en(jtag_rstb_en),
     .jtag_intest(jtag_intest), /*.vcc(vcc),*/ .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(output_rstb),
     .pd_data_aib(ncrx_pd_data_aib_poutp[13]),
     .oclk_out(nc_oclk_out_poutp[13]),
     .oclkb_out(nc_oclkb_out_poutp[13]),
     .odat0_out(nc_odat0_out_poutp[13]),
     .odat1_out(nc_odat1_out_poutp[13]),
     .odat_async_out(nc_odat_async_out_poutp[13]),
     .pd_data_out(nc_pd_data_out_poutp[13]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(jtag_clkdr_outn_poutp13),
     .iclkin_dist_in1(vssl), .idata0_in0(idat0_buf[13]),
     .idata0_in1(idat0_poutp15), .idata1_in0(idat1_buf[13]),
     .idata1_in1(idat1_poutp15), .idataselb_in0(idataselb[0]),
     .idataselb_in1(idataselb[0]), .iddren_in0(iddren[0]),
     .iddren_in1(iddren[0]), .ilaunch_clk_in0(tx_launch_clk_l[2]),
     .ilaunch_clk_in1(tx_launch_clk_l[2]), .ilpbk_dat_in0(vssl),
     .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl), .ilpbk_en_in1(vssl),
     .indrv_in0(indrv_r12[1:0]), .indrv_in1(indrv_r12[1:0]),
     .ipdrv_in0(ipdrv_r12[1:0]), .ipdrv_in1(ipdrv_r12[1:0]),
     .irxen_in0({vssl, vcc, vssl}), .irxen_in1({vssl, vcc, vssl}),
     .istrbclk_in0(jtag_clkdr_outn_poutp13), .istrbclk_in1(vssl),
     .itxen_in0(itxen[0]), .itxen_in1(itxen[0]), .oclk_in1(vssl),
     .odat_async_aib(ncrx_odat_async_aib_poutp[13]), .oclkb_in1(vssl),
     /*.vssl(vssl),*/ .odat0_in1(vssl), /*.vccl(vccl),*/ .odat1_in1(vssl),
     .odat_async_in1(vssl), .shift_en(rx_shift_en[17]),
     .pd_data_in1(vssl), .dig_rstb(poutp_dig_rstb),
     .jtag_clkdr_out(jtag_clkdr_out_poutp13),
     .odat1_aib(ncdrx_odat1_aib_poutp[13]),
     .jtag_rx_scan_out(jtag_rx_scan_out_poutp13),
     .odat0_aib(ncdrx_odat0_aib_poutp[13]),
     .oclk_aib(ncdrx_oclk_aib_poutp[13]),
     .last_bs_out(last_bs_out_poutp13),
     .oclkb_aib(ncdrx_oclkb_aib_poutp[13]), .jtag_clkdr_in(clkdr_xr2l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_out_poutp15),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_out_poutp15), .iopad(iopad_dat[13]),
     .oclkn(ncdrx_oclkn_poutp[13]), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xpoutp15 ( .idata1_in1_jtag_out(idat1_poutp15),
     .idata0_in1_jtag_out(idat0_poutp15),
     .async_dat_in1_jtag_out(nc_async_dat_poutp15),
     .prev_io_shift_en(rx_shift_en[21]),
     .jtag_clkdr_outn(jtag_clkdr_outn_poutp15),
     .jtag_clksel(jtag_clksel), .jtag_rstb_en(jtag_rstb_en),
     .jtag_intest(jtag_intest), /*.vcc(vcc),*/ .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(output_rstb),
     .pd_data_aib(ncrx_pd_data_aib_poutp[15]),
     .oclk_out(nc_oclk_out_poutp[15]),
     .oclkb_out(nc_oclkb_out_poutp[15]),
     .odat0_out(nc_odat0_out_poutp[15]),
     .odat1_out(nc_odat1_out_poutp[15]),
     .odat_async_out(nc_odat_async_out_poutp[15]),
     .pd_data_out(nc_pd_data_out_poutp[15]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(jtag_clkdr_outn_poutp15),
     .iclkin_dist_in1(vssl), .idata0_in0(idat0_buf[15]),
     .idata0_in1(idat0_poutp17), .idata1_in0(idat1_buf[15]),
     .idata1_in1(idat1_poutp17), .idataselb_in0(idataselb[0]),
     .idataselb_in1(idataselb[0]), .iddren_in0(iddren[0]),
     .iddren_in1(iddren[0]), .ilaunch_clk_in0(tx_launch_clk_l[0]),
     .ilaunch_clk_in1(tx_launch_clk_l[0]), .ilpbk_dat_in0(vssl),
     .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl), .ilpbk_en_in1(vssl),
     .indrv_in0(indrv_r12[1:0]), .indrv_in1(indrv_r12[1:0]),
     .ipdrv_in0(ipdrv_r12[1:0]), .ipdrv_in1(ipdrv_r12[1:0]),
     .irxen_in0({vssl, vcc, vssl}), .irxen_in1({vssl, vcc, vssl}),
     .istrbclk_in0(jtag_clkdr_outn_poutp15), .istrbclk_in1(vssl),
     .itxen_in0(itxen[0]), .itxen_in1(itxen[0]), .oclk_in1(vssl),
     .odat_async_aib(ncrx_odat_async_aib_poutp[15]), .oclkb_in1(vssl),
     /*.vssl(vssl),*/ .odat0_in1(vssl), /*.vccl(vccl),*/ .odat1_in1(vssl),
     .odat_async_in1(vssl), .shift_en(rx_shift_en[19]),
     .pd_data_in1(vssl), .dig_rstb(poutp_dig_rstb),
     .jtag_clkdr_out(jtag_clkdr_out_poutp15),
     .odat1_aib(ncdrx_odat1_aib_poutp[15]),
     .jtag_rx_scan_out(jtag_rx_scan_out_poutp15),
     .odat0_aib(ncdrx_odat0_aib_poutp[15]),
     .oclk_aib(ncdrx_oclk_aib_poutp[15]),
     .last_bs_out(last_bs_out_poutp15),
     .oclkb_aib(ncdrx_oclkb_aib_poutp[15]), .jtag_clkdr_in(clkdr_xr2l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_out_poutp17),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_out_poutp17), .iopad(iopad_dat[15]),
     .oclkn(ncdrx_oclkn_poutp[15]), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xpoutp17 ( .idata1_in1_jtag_out(idat1_poutp17),
     .idata0_in1_jtag_out(idat0_poutp17),
     .async_dat_in1_jtag_out(nc_async_dat_poutp17),
     .prev_io_shift_en(rx_shift_en[23]),
     .jtag_clkdr_outn(jtag_clkdr_outn_poutp17),
     .jtag_clksel(jtag_clksel), .jtag_rstb_en(jtag_rstb_en),
     .jtag_intest(jtag_intest), /*.vcc(vcc),*/ .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(output_rstb),
     .pd_data_aib(ncrx_pd_data_aib_poutp[17]),
     .oclk_out(nc_oclk_out_poutp[17]),
     .oclkb_out(nc_oclkb_out_poutp[17]),
     .odat0_out(nc_odat0_out_poutp[17]),
     .odat1_out(nc_odat1_out_poutp[17]),
     .odat_async_out(nc_odat_async_out_poutp[17]),
     .pd_data_out(nc_pd_data_out_poutp[17]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(jtag_clkdr_outn_poutp17),
     .iclkin_dist_in1(vssl), .idata0_in0(idat0_buf[17]),
     .idata0_in1(idat0_poutp19), .idata1_in0(idat1_buf[17]),
     .idata1_in1(idat1_poutp19), .idataselb_in0(idataselb[0]),
     .idataselb_in1(idataselb[0]), .iddren_in0(iddren[0]),
     .iddren_in1(iddren[0]), .ilaunch_clk_in0(tx_launch_clk_l[4]),
     .ilaunch_clk_in1(tx_launch_clk_l[4]), .ilpbk_dat_in0(vssl),
     .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl), .ilpbk_en_in1(vssl),
     .indrv_in0(indrv_r12[1:0]), .indrv_in1(indrv_r12[1:0]),
     .ipdrv_in0(ipdrv_r12[1:0]), .ipdrv_in1(ipdrv_r12[1:0]),
     .irxen_in0({vssl, vcc, vssl}), .irxen_in1({vssl, vcc, vssl}),
     .istrbclk_in0(jtag_clkdr_outn_poutp17), .istrbclk_in1(vssl),
     .itxen_in0(itxen[0]), .itxen_in1(itxen[0]), .oclk_in1(vssl),
     .odat_async_aib(ncrx_odat_async_aib_poutp[17]), .oclkb_in1(vssl),
     /*.vssl(vssl),*/ .odat0_in1(vssl), /*.vccl(vccl),*/ .odat1_in1(vssl),
     .odat_async_in1(vssl), .shift_en(rx_shift_en[21]),
     .pd_data_in1(vssl), .dig_rstb(poutp_dig_rstb),
     .jtag_clkdr_out(jtag_clkdr_out_poutp17),
     .odat1_aib(ncdrx_odat1_aib_poutp[17]),
     .jtag_rx_scan_out(jtag_rx_scan_out_poutp17),
     .odat0_aib(ncdrx_odat0_aib_poutp[17]),
     .oclk_aib(ncdrx_oclk_aib_poutp[17]),
     .last_bs_out(last_bs_out_poutp17),
     .oclkb_aib(ncdrx_oclkb_aib_poutp[17]), .jtag_clkdr_in(clkdr_xr2l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_out_poutp19),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_out_poutp19), .iopad(iopad_dat[17]),
     .oclkn(ncdrx_oclkn_poutp[17]), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xpoutp19 ( .idata1_in1_jtag_out(idat1_poutp19),
     .idata0_in1_jtag_out(idat0_poutp19),
     .async_dat_in1_jtag_out(nc_async_dat_poutp19),
     .prev_io_shift_en(shift_en_inpdir6_1),
     .jtag_clkdr_outn(jtag_clkdr_outn_poutp19),
     .jtag_clksel(jtag_clksel), .jtag_rstb_en(jtag_rstb_en),
     .jtag_intest(jtag_intest), /*.vcc(vcc),*/ .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(output_rstb),
     .pd_data_aib(pd_data_poutp19), .oclk_out(nc_oclk_out_poutp[19]),
     .oclkb_out(nc_oclkb_out_poutp[19]),
     .odat0_out(nc_odat0_out_poutp[19]),
     .odat1_out(nc_odat1_out_poutp[19]),
     .odat_async_out(nc_odat_async_out_poutp[19]),
     .pd_data_out(nc_pd_data_out_poutp[19]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(jtag_clkdr_outn_poutp19),
     .iclkin_dist_in1(vssl), .idata0_in0(idat0_buf[19]),
     .idata0_in1(vssl), .idata1_in0(idat1_buf[19]), .idata1_in1(vssl),
     .idataselb_in0(idataselb[0]), .idataselb_in1(vssl),
     .iddren_in0(iddren[0]), .iddren_in1(vssl),
     .ilaunch_clk_in0(tx_launch_clk_l[8]),
     .ilaunch_clk_in1(tx_launch_clk_l[8]), .ilpbk_dat_in0(vssl),
     .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl), .ilpbk_en_in1(vssl),
     .indrv_in0(indrv_r12[1:0]), .indrv_in1({vssl, vssl}),
     .ipdrv_in0(ipdrv_r12[1:0]), .ipdrv_in1({vssl, vssl}),
     .irxen_in0({vssl, vcc, vssl}), .irxen_in1(irxen_inpdir6_1[2:0]),
     .istrbclk_in0(jtag_clkdr_outn_poutp19), .istrbclk_in1(vssl),
     .itxen_in0(itxen[0]), .itxen_in1(vssl), .oclk_in1(vssl),
     .odat_async_aib(odat_async_aib_poutp19), .oclkb_in1(vssl),
     /*.vssl(vssl),*/ .odat0_in1(vssl), /*.vccl(vccl),*/ .odat1_in1(vssl),
     .odat_async_in1(vssl), .shift_en(rx_shift_en[23]),
     .pd_data_in1(vssl), .dig_rstb(poutp_dig_rstb),
     .jtag_clkdr_out(jtag_clkdr_out_poutp19),
     .odat1_aib(odat1_poutp19),
     .jtag_rx_scan_out(jtag_rx_scan_out_poutp19),
     .odat0_aib(odat0_poutp19), .oclk_aib(ncdrx_oclk_poutp19),
     .last_bs_out(last_bs_out_poutp19),
     .oclkb_aib(ncdrx_oclkb_poutp19), .jtag_clkdr_in(clkdr_xr2l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_inpdir6_1),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_dat[19]), .oclkn(ncdrx_oclkn_poutp19), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xpoutp7 ( .idata1_in1_jtag_out(idat1_poutp7),
     .idata0_in1_jtag_out(idat0_poutp7),
     .async_dat_in1_jtag_out(nc_async_dat_poutp7),
     .prev_io_shift_en(rx_shift_en[11]),
     .jtag_clkdr_outn(jtag_clkdr_outn_poutp7),
     .jtag_clksel(jtag_clksel), .jtag_rstb_en(jtag_rstb_en),
     .jtag_intest(jtag_intest), /*.vcc(vcc),*/ .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(output_rstb),
     .pd_data_aib(ncrx_pd_data_aib_poutp[7]),
     .oclk_out(nc_oclk_out_poutp[7]),
     .oclkb_out(nc_oclkb_out_poutp[7]),
     .odat0_out(nc_odat0_out_poutp[7]),
     .odat1_out(nc_odat1_out_poutp[7]),
     .odat_async_out(nc_odat_async_out_poutp[7]),
     .pd_data_out(nc_pd_data_out_poutp[7]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(jtag_clkdr_outn_poutp7),
     .iclkin_dist_in1(vssl), .idata0_in0(idat0_buf[7]),
     .idata0_in1(idat0_poutp9), .idata1_in0(idat1_buf[7]),
     .idata1_in1(idat1_poutp9), .idataselb_in0(idataselb[0]),
     .idataselb_in1(idataselb[0]), .iddren_in0(iddren[0]),
     .iddren_in1(iddren[0]), .ilaunch_clk_in0(tx_launch_clk_r[4]),
     .ilaunch_clk_in1(tx_launch_clk_r[4]), .ilpbk_dat_in0(vssl),
     .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl), .ilpbk_en_in1(vssl),
     .indrv_in0(indrv_r12[1:0]), .indrv_in1(indrv_r12[1:0]),
     .ipdrv_in0(ipdrv_r12[1:0]), .ipdrv_in1(ipdrv_r12[1:0]),
     .irxen_in0({vssl, vcc, vssl}), .irxen_in1({vssl, vcc, vssl}),
     .istrbclk_in0(jtag_clkdr_outn_poutp7), .istrbclk_in1(vssl),
     .itxen_in0(itxen[0]), .itxen_in1(itxen[0]), .oclk_in1(vssl),
     .odat_async_aib(ncrx_odat_async_aib_poutp[7]), .oclkb_in1(vssl),
     /*.vssl(vssl),*/ .odat0_in1(vssl), /*.vccl(vccl),*/ .odat1_in1(vssl),
     .odat_async_in1(vssl), .shift_en(rx_shift_en[9]),
     .pd_data_in1(vssl), .dig_rstb(poutp_dig_rstb),
     .jtag_clkdr_out(jtag_clkdr_out_poutp7),
     .odat1_aib(ncdrx_odat1_aib_poutp[7]),
     .jtag_rx_scan_out(jtag_rx_scan_out_poutp7),
     .odat0_aib(ncdrx_odat0_aib_poutp[7]),
     .oclk_aib(ncdrx_oclk_aib_poutp[7]),
     .last_bs_out(last_bs_out_poutp7),
     .oclkb_aib(ncdrx_oclkb_aib_poutp[7]), .jtag_clkdr_in(clkdr_xr2r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_out_poutp9),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_out_poutp9), .iopad(iopad_dat[7]),
     .oclkn(ncdrx_oclkn_poutp[7]), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xpoutp9 ( .idata1_in1_jtag_out(idat1_poutp9),
     .idata0_in1_jtag_out(idat0_poutp9),
     .async_dat_in1_jtag_out(nc_async_dat_poutp9),
     .prev_io_shift_en(rx_shift_en[13]),
     .jtag_clkdr_outn(jtag_clkdr_outn_poutp9),
     .jtag_clksel(jtag_clksel), .jtag_rstb_en(jtag_rstb_en),
     .jtag_intest(jtag_intest), /*.vcc(vcc),*/ .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(output_rstb),
     .pd_data_aib(ncrx_pd_data_aib_poutp[9]),
     .oclk_out(nc_oclk_out_poutp[9]),
     .oclkb_out(nc_oclkb_out_poutp[9]),
     .odat0_out(nc_odat0_out_poutp[9]),
     .odat1_out(nc_odat1_out_poutp[9]),
     .odat_async_out(nc_odat_async_out_poutp[9]),
     .pd_data_out(nc_pd_data_out_poutp[9]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(jtag_clkdr_outn_poutp9),
     .iclkin_dist_in1(vssl), .idata0_in0(idat0_buf[9]),
     .idata0_in1(idat0_tx_clkn), .idata1_in0(idat1_buf[9]),
     .idata1_in1(idat1_tx_clkn), .idataselb_in0(idataselb[0]),
     .idataselb_in1(idataselb[0]), .iddren_in0(iddren[0]),
     .iddren_in1(iddren[1]), .ilaunch_clk_in0(tx_launch_clk_r[8]),
     .ilaunch_clk_in1(tx_launch_clk_r[8]), .ilpbk_dat_in0(vssl),
     .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl), .ilpbk_en_in1(vssl),
     .indrv_in0(indrv_r12[1:0]), .indrv_in1(indrv_r12[1:0]),
     .ipdrv_in0(ipdrv_r12[1:0]), .ipdrv_in1(ipdrv_r12[1:0]),
     .irxen_in0({vssl, vcc, vssl}), .irxen_in1({vssl, vcc, vssl}),
     .istrbclk_in0(jtag_clkdr_outn_poutp9), .istrbclk_in1(vssl),
     .itxen_in0(itxen[0]), .itxen_in1(itxen[1]), .oclk_in1(vssl),
     .odat_async_aib(ncrx_odat_async_aib_poutp[9]), .oclkb_in1(vssl),
     /*.vssl(vssl),*/ .odat0_in1(vssl), /*.vccl(vccl),*/ .odat1_in1(vssl),
     .odat_async_in1(vssl), .shift_en(rx_shift_en[11]),
     .pd_data_in1(vssl), .dig_rstb(poutp_dig_rstb),
     .jtag_clkdr_out(jtag_clkdr_out_poutp9),
     .odat1_aib(ncdrx_odat1_aib_poutp[9]),
     .jtag_rx_scan_out(jtag_rx_scan_out_poutp9),
     .odat0_aib(ncdrx_odat0_aib_poutp[9]), .oclk_aib(oclk_aib_poutp9),
     .last_bs_out(last_bs_out_poutp9), .oclkb_aib(oclkb_aib_poutp9),
     .jtag_clkdr_in(clkdr_xr2r), .jtag_mode_in(jtag_mode_in),
     .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(nc_jtag_rx_scan_out_tx_clkn),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(nc_last_bs_out_tx_clkn), .iopad(iopad_dat[9]),
     .oclkn(ncdrx_oclkn_poutp[9]), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));

aibcr3_buffx1_top xdiin_clkp ( .idata1_in1_jtag_out(nc_idat1_inpclk0),
     .idata0_in1_jtag_out(nc_idat0_inpclk0),
     .async_dat_in1_jtag_out(nc_async_dat_inpclk0),
     .prev_io_shift_en(rx_shift_en[33]),
     .jtag_clkdr_outn(jtag_clkdr_outn_inpclk0),
     .jtag_clksel(jtag_clksel), .jtag_rstb_en(jtag_rstb_en),
     .jtag_intest(jtag_intest), /*.vcc(vcc),*/ .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(output_rstb),
     .pd_data_aib(nc_pd_data_out0_diin_clkp),
     .oclk_out(out_rx_fast_clk),       // BCA: disable unused clock
     .oclkb_out(out_rx_fast_clkb),
     .odat0_out(nc_odat0_diin_clkp), .odat1_out(nc_odat1_diin_clkp),
     .odat_async_out(nc_odat_async_diin_clkp),
     .pd_data_out(nc_pd_data_diin_clkp), .async_dat_in0(vssl),
     .async_dat_in1(async_dat_outpclk5), .iclkin_dist_in0(vssl),
     .iclkin_dist_in1(vssl), .idata0_in0(vssl), .idata0_in1(vssl),
     .idata1_in0(vssl), .idata1_in1(vssl), .idataselb_in0(vssl),
     .idataselb_in1(idataselb[2]), .iddren_in0(vssl),
     .iddren_in1(vssl), .ilaunch_clk_in0(vssl), .ilaunch_clk_in1(vssl),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0({vssl, vssl}),
     .indrv_in1(indrv_r56[1:0]), .ipdrv_in0({vssl, vssl}),
     .ipdrv_in1(ipdrv_r56[1:0]), .irxen_in0(irxen_r0[2:0]),
     .irxen_in1({vssl, vcc, vssl}), .istrbclk_in0(vssl),
     .istrbclk_in1(vssl), .itxen_in0(vssl), .itxen_in1(itxen[3]),
     .oclk_in1(oclk_aib_inpdir1_1),
     .odat_async_aib(nc_odat_async_out0_diin_clkp),
     .oclkb_in1(oclkb_aib_inpdir1_1), /*.vssl(vssl),*/ .odat0_in1(vssl),
     /*.vccl(vccl),*/ .odat1_in1(vssl), .odat_async_in1(vssl),
     .shift_en(rx_shift_en[28]), .pd_data_in1(vssl),
     .dig_rstb(output_rstb), .jtag_clkdr_out(jtag_clkdr_inpclk0),
     .odat1_aib(nc_odat1_out0_diin_clkp),
     .jtag_rx_scan_out(jtag_rx_scan_inpclk0),
     .odat0_aib(nc_odat0_out0_diin_clkp), .oclk_aib(nc_oclk_diin_clkp),
     .last_bs_out(nc2), .oclkb_aib(nc_oclkb_diin_clkp),
     .jtag_clkdr_in(clkdr_xr5l), .jtag_mode_in(jtag_mode_in),
     .jtag_rstb(jtag_rstb), .jtag_tx_scan_in(jtag_rx_scan_outpclk5),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_directinclkp), .oclkn(nc_oclkn_out0_diin_clkp),
     .iclkn(rxoclkn_clkn),      // BCA: disable unused clock
     .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xdirect_out5 (
     .idata1_in1_jtag_out(nc_idat1_directout5),
     .idata0_in1_jtag_out(nc_idat0_directout5),
     .async_dat_in1_jtag_out(async_dat_directout5),
     .prev_io_shift_en(shift_en_outpclk3),
     .jtag_clkdr_outn(jtag_clkdr_outn_directout5),
     .jtag_clksel(jtag_clksel), .jtag_rstb_en(jtag_rstb_en),
     .jtag_intest(jtag_intest), /*.vcc(vcc),*/ .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(output_rstb),
     .pd_data_aib(nc_pd_data_out0_directout[5]),
     .oclk_out(nc_oclk_directout[5]),
     .oclkb_out(nc_oclkb_directout[5]),
     .odat0_out(nc_odata0_directout[5]),
     .odat1_out(nc_odata1_directout[5]),
     .odat_async_out(nc_odat_async_out_directout[5]),
     .pd_data_out(nc_pd_data_directout[5]),
     .async_dat_in0(idirectout_data[5]),
     .async_dat_in1(async_dat_outpclk3), .iclkin_dist_in0(vssl),
     .iclkin_dist_in1(vssl), .idata0_in0(vssl), .idata0_in1(vssl),
     .idata1_in0(vssl), .idata1_in1(vssl),
     .idataselb_in0(idataselb[2]), .idataselb_in1(idataselb_outpclk3),
     .iddren_in0(vssl), .iddren_in1(vssl), .ilaunch_clk_in0(vssl),
     .ilaunch_clk_in1(vssl), .ilpbk_dat_in0(vssl),
     .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl), .ilpbk_en_in1(vssl),
     .indrv_in0(indrv_r56[1:0]), .indrv_in1(indrv_r56[1:0]),
     .ipdrv_in0(ipdrv_r56[1:0]), .ipdrv_in1(ipdrv_r56[1:0]),
     .irxen_in0({vssl, vcc, vssl}), .irxen_in1({vssl, vcc, vssl}),
     .istrbclk_in0(vssl), .istrbclk_in1(vssl), .itxen_in0(itxen[3]),
     .itxen_in1(itxen_outpclk3), .oclk_in1(vssl),
     .odat_async_aib(nc_odat_async_aib_directout[5]), .oclkb_in1(vssl),
     /*.vssl(vssl),*/ .odat0_in1(vssl), /*.vccl(vccl),*/ .odat1_in1(vssl),
     .odat_async_in1(vssl), .shift_en(rx_shift_en[30]),
     .pd_data_in1(vssl), .dig_rstb(output_rstb),
     .jtag_clkdr_out(jtag_clkdr_out_directout5),
     .odat1_aib(nc_odata1_out0_directout[5]),
     .jtag_rx_scan_out(jtag_rx_scan_out_directout5),
     .odat0_aib(nc_odata0_out0_directout[5]),
     .oclk_aib(nc_oclk_out0_directout[5]),
     .last_bs_out(nc_last_bs_out_directout5),
     .oclkb_aib(nc_oclkb_out0_directout[5]),
     .jtag_clkdr_in(clkdr_xr6l), .jtag_mode_in(jtag_mode_in),
     .jtag_rstb(jtag_rstb), .jtag_tx_scan_in(jtag_rx_scan_outpclk3),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_directout[5]), .oclkn(nc_oclkn_out0_directout[5]),
     .iclkn(vssl), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xdirect_in0 ( .idata1_in1_jtag_out(nc_idat1_inpclk1),
     .idata0_in1_jtag_out(nc_idat0_inpclk1),
     .async_dat_in1_jtag_out(nc_async_dat_inpclk1),
     .prev_io_shift_en(shift_en_voutp0),
     .jtag_clkdr_outn(jtag_clkdr_outn_inpclk1),
     .jtag_clksel(jtag_clksel), .jtag_rstb_en(jtag_rstb_en),
     .jtag_intest(jtag_intest), /*.vcc(vcc),*/ .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(output_rstb),
     .pd_data_aib(nc_pd_data_out0_directin[0]),
     .oclk_out(nc_oclk_directin[0]), .oclkb_out(nc_oclkb_directin[0]),
     .odat0_out(nc_odat0_directin[0]),
     .odat1_out(nc_odat1_directin[0]),
     .odat_async_out(odirectin_data[0]),
     .pd_data_out(nc_pd_data_directin[0]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(vssl),
     .iclkin_dist_in1(vssl), .idata0_in0(vssl),
     .idata0_in1(idata0_voutp0), .idata1_in0(vssl),
     .idata1_in1(idata1_voutp0), .idataselb_in0(vssl),
     .idataselb_in1(idataselb_voutp0), .iddren_in0(vssl),
     .iddren_in1(vssl), .ilaunch_clk_in0(vssl),
     .ilaunch_clk_in1(ilaunch_clk_voutp0), .ilpbk_dat_in0(vssl),
     .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl), .ilpbk_en_in1(vssl),
     .indrv_in0({vssl, vssl}), .indrv_in1(indrv_r78[1:0]),
     .ipdrv_in0({vssl, vssl}), .ipdrv_in1(ipdrv_r78[1:0]),
     .irxen_in0(irxen_r1[2:0]), .irxen_in1({vssl, vcc, vssl}),
     .istrbclk_in0(vssl), .istrbclk_in1(vssl), .itxen_in0(vssl),
     .itxen_in1(itxen_voutp0), .oclk_in1(vssl),
     .odat_async_aib(nc_odat_async_out0_directin[0]), .oclkb_in1(vssl),
     /*.vssl(vssl),*/ .odat0_in1(vssl), /*.vccl(vccl),*/ .odat1_in1(vssl),
     .odat_async_in1(odat_async_outclk0), .shift_en(rx_shift_en[26]),
     .pd_data_in1(vssl), .dig_rstb(output_rstb),
     .jtag_clkdr_out(jtag_clkdr_inpclk1),
     .odat1_aib(nc_odat1_out0_directin[0]),
     .jtag_rx_scan_out(jtag_rx_scan_inpclk1),
     .odat0_aib(nc_odat0_out0_directin[0]),
     .oclk_aib(nc_oclk_out0_directin0),
     .last_bs_out(nc_last_bs_out_directin0),
     .oclkb_aib(nc_oclkb_out0_directin0), .jtag_clkdr_in(clkdr_xr7l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_voutp0),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_direct_input[0]), .oclkn(nc_oclkn_inpclk1),
     .iclkn(vssl), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xpoutp5 ( .idata1_in1_jtag_out(idat1_poutp5),
     .idata0_in1_jtag_out(idat0_poutp5),
     .async_dat_in1_jtag_out(nc_async_dat_poutp5),
     .prev_io_shift_en(rx_shift_en[9]),
     .jtag_clkdr_outn(jtag_clkdr_outn_poutp5),
     .jtag_clksel(jtag_clksel), .jtag_rstb_en(jtag_rstb_en),
     .jtag_intest(jtag_intest), /*.vcc(vcc),*/ .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(output_rstb),
     .pd_data_aib(ncrx_pd_data_aib_poutp[5]),
     .oclk_out(nc_oclk_out_poutp[5]),
     .oclkb_out(nc_oclkb_out_poutp[5]),
     .odat0_out(nc_odat0_out_poutp[5]),
     .odat1_out(nc_odat1_out_poutp[5]),
     .odat_async_out(nc_odat_async_out_poutp[5]),
     .pd_data_out(nc_pd_data_out_poutp[5]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(jtag_clkdr_outn_poutp5),
     .iclkin_dist_in1(vssl), .idata0_in0(idat0_buf[5]),
     .idata0_in1(idat0_poutp7), .idata1_in0(idat1_buf[5]),
     .idata1_in1(idat1_poutp7), .idataselb_in0(idataselb[0]),
     .idataselb_in1(idataselb[0]), .iddren_in0(iddren[0]),
     .iddren_in1(iddren[0]), .ilaunch_clk_in0(tx_launch_clk_r[0]),
     .ilaunch_clk_in1(tx_launch_clk_r[0]), .ilpbk_dat_in0(vssl),
     .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl), .ilpbk_en_in1(vssl),
     .indrv_in0(indrv_r12[1:0]), .indrv_in1(indrv_r12[1:0]),
     .ipdrv_in0(ipdrv_r12[1:0]), .ipdrv_in1(ipdrv_r12[1:0]),
     .irxen_in0({vssl, vcc, vssl}), .irxen_in1({vssl, vcc, vssl}),
     .istrbclk_in0(jtag_clkdr_outn_poutp5), .istrbclk_in1(vssl),
     .itxen_in0(itxen[0]), .itxen_in1(itxen[0]), .oclk_in1(vssl),
     .odat_async_aib(ncrx_odat_async_aib_poutp[5]), .oclkb_in1(vssl),
     .odat0_in1(vssl), .odat1_in1(vssl), .odat_async_in1(vssl),
     .shift_en(rx_shift_en[7]), .pd_data_in1(vssl),
     .dig_rstb(poutp_dig_rstb), .jtag_clkdr_out(jtag_clkdr_out_poutp5),
     .odat1_aib(ncdrx_odat1_aib_poutp[5]),
     .jtag_rx_scan_out(jtag_rx_scan_out_poutp5),
     .odat0_aib(ncdrx_odat0_aib_poutp[5]),
     .oclk_aib(ncdrx_oclk_aib_poutp[5]),
     .last_bs_out(last_bs_out_poutp5),
     .oclkb_aib(ncdrx_oclkb_aib_poutp[5]), .jtag_clkdr_in(clkdr_xr2r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_out_poutp7),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_out_poutp7), .test_weakpd(jtag_weakpdn),
     .test_weakpu(jtag_weakpu), /*.vssl(vssl),*/ .iopad(iopad_dat[5]),
     /*.vccl(vccl),*/ .oclkn(ncdrx_oclkn_poutp[5]), .iclkn(vssl));
aibcr3_buffx1_top xdirect_in2 (
     .idata1_in1_jtag_out(nc_idat1_inpdir2_1),
     .idata0_in1_jtag_out(nc_idat0_inpdir2_1),
     .async_dat_in1_jtag_out(nc_async_dat_inpdir2_1),
     .prev_io_shift_en(rx_shift_en[29]),
     .jtag_clkdr_outn(jtag_clkdr_outn_inpdir2_1),
     .jtag_clksel(jtag_clksel), .jtag_rstb_en(jtag_rstb_en),
     .jtag_intest(jtag_intest), /*.vcc(vcc),*/ .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(output_rstb),
     .pd_data_aib(nc_pd_data_out0_directin[2]),
     .oclk_out(nc_oclk_directin[2]), .oclkb_out(nc_oclkb_directin[2]),
     .odat0_out(nc_odat0_directin[2]),
     .odat1_out(nc_odat1_directin[2]),
     .odat_async_out(odirectin_data[2]),
     .pd_data_out(nc_pd_data_directin[2]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(vssl),
     .iclkin_dist_in1(vssl), .idata0_in0(vssl), .idata0_in1(vssl),
     .idata1_in0(vssl), .idata1_in1(vssl), .idataselb_in0(vssl),
     .idataselb_in1(vssl), .iddren_in0(vssl), .iddren_in1(vssl),
     .ilaunch_clk_in0(vssl), .ilaunch_clk_in1(vssl),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0({vssl, vssl}), .indrv_in1({vssl,
     vssl}), .ipdrv_in0({vssl, vssl}), .ipdrv_in1({vssl, vssl}),
     .irxen_in0(irxen_r1[2:0]), .irxen_in1({vssl, vcc, vssl}),
     .istrbclk_in0(vssl), .istrbclk_in1(vssl), .itxen_in0(vssl),
     .itxen_in1(vssl), .oclk_in1(vssl),
     .odat_async_aib(nc_odat_async_out0_directin[2]), .oclkb_in1(vssl),
     /*.vssl(vssl),*/ .odat0_in1(vssl), /*.vccl(vccl),*/ .odat1_in1(vssl),
     .odat_async_in1(odat_async_aib_vinp11),
     .shift_en(rx_shift_en[27]), .pd_data_in1(vssl),
     .dig_rstb(output_rstb), .jtag_clkdr_out(jtag_clkdr_inpdir2_1),
     .odat1_aib(nc_odat1_out0_directin[2]),
     .jtag_rx_scan_out(jtag_rx_scan_inpdir2_1),
     .odat0_aib(nc_odat0_out0_directin[2]),
     .oclk_aib(nc_oclk_out0_directin[2]),
     .last_bs_out(nc_last_bs_out_directin2),
     .oclkb_aib(nc_oclkb_out0_directin[2]), .jtag_clkdr_in(clkdr_xr6l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_out_diin_clkn),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_direct_input[2]), .oclkn(oclkn_aib_inpdir2_1),
     .iclkn(vssl), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xdiin_clkn ( .idata1_in1_jtag_out(nc_idat1_diin_clkn),
     .idata0_in1_jtag_out(nc_idat0_diin_clkn),
     .async_dat_in1_jtag_out(nc_async_dat_diin_clkn),
     .prev_io_shift_en(rx_shift_en[30]),
     .jtag_clkdr_outn(jtag_clkdr_outn_diin_clkn),
     .jtag_clksel(jtag_clksel), .jtag_rstb_en(jtag_rstb_en),
     .jtag_intest(jtag_intest), /*.vcc(vcc),*/ .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(output_rstb),
     .pd_data_aib(nc_pd_data_out0_diin_clkn),
     .oclk_out(nc_oclk_diin_clkn), .oclkb_out(nc_oclkb_diin_clkn),
     .odat0_out(nc_odat0_diin_clkn), .odat1_out(nc_odat1_diin_clkn),
     .odat_async_out(nc_odat_async_diin_clkn),
     .pd_data_out(nc_pd_data_diin_clkn), .async_dat_in0(vssl),
     .async_dat_in1(async_dat_directout5), .iclkin_dist_in0(vssl),
     .iclkin_dist_in1(vssl), .idata0_in0(vssl), .idata0_in1(vssl),
     .idata1_in0(vssl), .idata1_in1(vssl), .idataselb_in0(vssl),
     .idataselb_in1(idataselb[2]), .iddren_in0(vssl),
     .iddren_in1(vssl), .ilaunch_clk_in0(vssl), .ilaunch_clk_in1(vssl),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0({vssl, vssl}),
     .indrv_in1(indrv_r56[1:0]), .ipdrv_in0({vssl, vssl}),
     .ipdrv_in1(ipdrv_r56[1:0]), .irxen_in0({vssl, vcc, vssl}),
     .irxen_in1({vssl, vcc, vssl}), .istrbclk_in0(vssl),
     .istrbclk_in1(vssl), .itxen_in0(vssl), .itxen_in1(itxen[3]),
     .oclk_in1(vssl), .odat_async_aib(nc_odat_async_out0_diin_clkn),
     .oclkb_in1(vssl), /*.vssl(vssl),*/ .odat0_in1(vssl), /*.vccl(vccl),*/
     .odat1_in1(vssl), .odat_async_in1(vssl),
     .shift_en(rx_shift_en[29]), .pd_data_in1(vssl),
     .dig_rstb(output_rstb), .jtag_clkdr_out(jtag_clkdr_out_diin_clkn),
     .odat1_aib(nc_odat1_out0_diin_clkn),
     .jtag_rx_scan_out(jtag_rx_scan_out_diin_clkn),
     .odat0_aib(nc_odat0_out0_diin_clkn),
     .oclk_aib(nc_oclk_out0_diin_clkn),
     .last_bs_out(nc_last_bs_out_diin_clkn),
     .oclkb_aib(nc_oclkb_out0_diin_clkn), .jtag_clkdr_in(clkdr_xr6l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_out_directout5),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_directinclkn), .oclkn(rxoclkn_clkn), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xpoutp3 ( .idata1_in1_jtag_out(idat1_poutp3),
     .idata0_in1_jtag_out(idat0_poutp3),
     .async_dat_in1_jtag_out(nc_async_dat_poutp3),
     .prev_io_shift_en(rx_shift_en[7]),
     .jtag_clkdr_outn(jtag_clkdr_outn_poutp3),
     .jtag_clksel(jtag_clksel), .jtag_rstb_en(jtag_rstb_en),
     .jtag_intest(jtag_intest), /*.vcc(vcc),*/ .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(output_rstb),
     .pd_data_aib(ncrx_pd_data_aib_poutp[3]), .oclk_out(NET0857),
     .oclkb_out(NET0856), .odat0_out(nc_odat0_out_poutp[3]),
     .odat1_out(nc_odat1_out_poutp[3]), .odat_async_out(NET0858),
     .pd_data_out(nc_pd_data_out_poutp[3]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(jtag_clkdr_outn_poutp3),
     .iclkin_dist_in1(vssl), .idata0_in0(idat0_buf[3]),
     .idata0_in1(idat0_poutp5), .idata1_in0(idat1_buf[3]),
     .idata1_in1(idat1_poutp5), .idataselb_in0(idataselb[0]),
     .idataselb_in1(idataselb[0]), .iddren_in0(iddren[0]),
     .iddren_in1(iddren[0]), .ilaunch_clk_in0(tx_launch_clk_r[2]),
     .ilaunch_clk_in1(tx_launch_clk_r[2]), .ilpbk_dat_in0(vssl),
     .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl), .ilpbk_en_in1(vssl),
     .indrv_in0(indrv_r12[1:0]), .indrv_in1(indrv_r12[1:0]),
     .ipdrv_in0(ipdrv_r12[1:0]), .ipdrv_in1(ipdrv_r12[1:0]),
     .irxen_in0({vssl, vcc, vssl}), .irxen_in1({vssl, vcc, vssl}),
     .istrbclk_in0(jtag_clkdr_outn_poutp3), .istrbclk_in1(vssl),
     .itxen_in0(itxen[0]), .itxen_in1(itxen[0]), .oclk_in1(vssl),
     .odat_async_aib(ncrx_odat_async_aib_poutp[3]), .oclkb_in1(vssl),
     /*.vssl(vssl),*/ .odat0_in1(vssl), /*.vccl(vccl),*/ .odat1_in1(vssl),
     .odat_async_in1(vssl), .shift_en(rx_shift_en[5]),
     .pd_data_in1(vssl), .dig_rstb(poutp_dig_rstb),
     .jtag_clkdr_out(jtag_clkdr_out_poutp3),
     .odat1_aib(ncdrx_odat1_aib_poutp[3]),
     .jtag_rx_scan_out(jtag_rx_scan_out_poutp3),
     .odat0_aib(ncdrx_odat0_aib_poutp[3]),
     .oclk_aib(ncdrx_oclk_aib_poutp[3]),
     .last_bs_out(last_bs_out_poutp3),
     .oclkb_aib(ncdrx_oclkb_aib_poutp[3]), .jtag_clkdr_in(clkdr_xr2r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_out_poutp5),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_out_poutp5), .iopad(iopad_dat[3]),
     .oclkn(ncdrx_oclkn_poutp[3]), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xpoutp1 ( .idata1_in1_jtag_out(idat1_poutp1),
     .idata0_in1_jtag_out(idat0_poutp1),
     .async_dat_in1_jtag_out(nc_async_dat_poutp1),
     .prev_io_shift_en(rx_shift_en[5]),
     .jtag_clkdr_outn(jtag_clkdr_outn_poutp1),
     .jtag_clksel(jtag_clksel), .jtag_rstb_en(jtag_rstb_en),
     .jtag_intest(jtag_intest), /*.vcc(vcc),*/ .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(output_rstb),
     .pd_data_aib(ncrx_pd_data_aib_poutp[1]),
     .oclk_out(nc_oclk_out_poutp[1]),
     .oclkb_out(nc_oclkb_out_poutp[1]),
     .odat0_out(nc_odat0_out_poutp[1]),
     .odat1_out(nc_odat1_out_poutp[1]),
     .odat_async_out(nc_odat_async_out_poutp[1]),
     .pd_data_out(nc_pd_data_out_poutp[1]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(jtag_clkdr_outn_poutp1),
     .iclkin_dist_in1(vssl), .idata0_in0(idat0_buf[1]),
     .idata0_in1(idat0_poutp3), .idata1_in0(idat1_buf[1]),
     .idata1_in1(idat1_poutp3), .idataselb_in0(idataselb[0]),
     .idataselb_in1(idataselb[0]), .iddren_in0(iddren[0]),
     .iddren_in1(iddren[0]), .ilaunch_clk_in0(tx_launch_clk_r[6]),
     .ilaunch_clk_in1(tx_launch_clk_r[6]), .ilpbk_dat_in0(vssl),
     .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl), .ilpbk_en_in1(vssl),
     .indrv_in0(indrv_r12[1:0]), .indrv_in1(indrv_r12[1:0]),
     .ipdrv_in0(ipdrv_r12[1:0]), .ipdrv_in1(ipdrv_r12[1:0]),
     .irxen_in0({vssl, vcc, vssl}), .irxen_in1({vssl, vcc, vssl}),
     .istrbclk_in0(jtag_clkdr_outn_poutp1), .istrbclk_in1(vssl),
     .itxen_in0(itxen[0]), .itxen_in1(itxen[0]), .oclk_in1(vssl),
     .odat_async_aib(ncrx_odat_async_aib_poutp[1]), .oclkb_in1(vssl),
     .odat0_in1(vssl), .odat1_in1(vssl), .odat_async_in1(vssl),
     .shift_en(rx_shift_en[3]), .pd_data_in1(vssl),
     .dig_rstb(poutp_dig_rstb), .jtag_clkdr_out(jtag_clkdr_out_poutp1),
     .odat1_aib(ncdrx_odat1_aib_poutp[1]),
     .jtag_rx_scan_out(jtag_rx_scan_out_poutp1),
     .odat0_aib(ncdrx_odat0_aib_poutp[1]),
     .oclk_aib(ncdrx_oclk_aib_poutp[1]),
     .last_bs_out(last_bs_out_poutp1),
     .oclkb_aib(ncdrx_oclkb_aib_poutp[1]), .jtag_clkdr_in(clkdr_xr2r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_out_poutp3),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_out_poutp3), .test_weakpd(jtag_weakpdn),
     .test_weakpu(jtag_weakpu), /*.vssl(vssl),*/ .iopad(iopad_dat[1]),
     /*.vccl(vccl),*/ .oclkn(ncdrx_oclkn_poutp[1]), .iclkn(vssl));
aibcr3_buffx1_top xxdirect_out0 (
     .idata1_in1_jtag_out(nc_idat1_outpdir4),
     .idata0_in1_jtag_out(nc_idat0_outpdir4),
     .async_dat_in1_jtag_out(async_dat_outpdir4),
     .prev_io_shift_en(shift_en_outclk0n),
     .jtag_clkdr_outn(jtag_clkdr_outn_outpdir4),
     .jtag_clksel(jtag_clksel), .jtag_rstb_en(jtag_rstb_en),
     .jtag_intest(jtag_intest), /*.vcc(vcc),*/ .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(output_rstb),
     .pd_data_aib(nc_pd_data_out0_directout[0]),
     .oclk_out(nc_oclk_directout[0]),
     .oclkb_out(nc_oclkb_directout[0]),
     .odat0_out(nc_odata0_directout[0]),
     .odat1_out(nc_odata1_directout[0]),
     .odat_async_out(nc_odat_async_directout[0]),
     .pd_data_out(nc_pd_data_directout[0]),
     .async_dat_in0(idirectout_data[0]), .async_dat_in1(vssl),
     .iclkin_dist_in0(vssl), .iclkin_dist_in1(vssl), .idata0_in0(vssl),
     .idata0_in1(idat0_outclk0n), .idata1_in0(vssl),
     .idata1_in1(idat1_outclk0n), .idataselb_in0(idataselb[2]),
     .idataselb_in1(idataselb_outclk0n), .iddren_in0(vssl),
     .iddren_in1(vcc), .ilaunch_clk_in0(vssl),
     .ilaunch_clk_in1(ilaunch_clk_outclk0n), .ilpbk_dat_in0(vssl),
     .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl), .ilpbk_en_in1(vssl),
     .indrv_in0(indrv_r78[1:0]), .indrv_in1(indrv_r78[1:0]),
     .ipdrv_in0(ipdrv_r78[1:0]), .ipdrv_in1(ipdrv_r78[1:0]),
     .irxen_in0({vssl, vcc, vssl}), .irxen_in1({vssl, vcc, vssl}),
     .istrbclk_in0(vssl), .istrbclk_in1(vssl), .itxen_in0(itxen[3]),
     .itxen_in1(itxen_outclk0n), .oclk_in1(vssl),
     .odat_async_aib(nc_odat_async_aib_directout[0]), .oclkb_in1(vssl),
     /*.vssl(vssl),*/ .odat0_in1(vssl), /*.vccl(vccl),*/ .odat1_in1(vssl),
     .odat_async_in1(vssl), .shift_en(rx_shift_en[0]),
     .pd_data_in1(vssl), .dig_rstb(poutp_dig_rstb),
     .jtag_clkdr_out(jtag_clkdr_outpdir4),
     .odat1_aib(nc_odata1_out0_directout[0]),
     .jtag_rx_scan_out(jtag_rx_scan_outpdir4),
     .odat0_aib(nc_odata0_out0_directout[0]),
     .oclk_aib(nc_oclk_out0_directout[0]),
     .last_bs_out(last_bs_outpdir4),
     .oclkb_aib(nc_oclkb_out0_directout[0]),
     .jtag_clkdr_in(clkdr_xr8l), .jtag_mode_in(jtag_mode_in),
     .jtag_rstb(jtag_rstb), .jtag_tx_scan_in(jtag_scan_outclk0n),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_directout[0]), .oclkn(nc_oclkn_out0_directout[0]),
     .iclkn(vssl), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xdirect_out1 (
     .idata1_in1_jtag_out(nc_idat1_outpdir1),
     .idata0_in1_jtag_out(nc_idat0_outpdir1),
     .async_dat_in1_jtag_out(idirectout_data_out_chain2),
     .prev_io_shift_en(rx_shift_en[3]),
     .jtag_clkdr_outn(jtag_clkdr_outn_outpdir1),
     .jtag_clksel(jtag_clksel), .jtag_rstb_en(jtag_rstb_en),
     .jtag_intest(jtag_intest), /*.vcc(vcc),*/ .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(output_rstb),
     .pd_data_aib(nc_pd_data_out0_directout[1]),
     .oclk_out(nc_oclk_directout[1]),
     .oclkb_out(nc_oclkb_directout[1]),
     .odat0_out(nc_odata0_directout[1]),
     .odat1_out(nc_odata1_directout[1]),
     .odat_async_out(nc_odat_async_out[1]),
     .pd_data_out(nc_pd_data_directout[1]),
     .async_dat_in0(idirectout_data[1]), .async_dat_in1(vssl),
     .iclkin_dist_in0(vssl), .iclkin_dist_in1(vssl), .idata0_in0(vssl),
     .idata0_in1(idat0_poutp1), .idata1_in0(vssl),
     .idata1_in1(idat1_poutp1), .idataselb_in0(idataselb[2]),
     .idataselb_in1(idataselb[0]), .iddren_in0(vssl),
     .iddren_in1(iddren[0]), .ilaunch_clk_in0(tx_launch_clk_r[10]),
     .ilaunch_clk_in1(tx_launch_clk_r[10]), .ilpbk_dat_in0(vssl),
     .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl), .ilpbk_en_in1(vssl),
     .indrv_in0(indrv_r12[1:0]), .indrv_in1(indrv_r12[1:0]),
     .ipdrv_in0(indrv_r12[1:0]), .ipdrv_in1(ipdrv_r12[1:0]),
     .irxen_in0({vssl, vcc, vssl}), .irxen_in1({vssl, vcc, vssl}),
     .istrbclk_in0(vssl), .istrbclk_in1(vssl), .itxen_in0(itxen[3]),
     .itxen_in1(itxen[0]), .oclk_in1(vssl),
     .odat_async_aib(nc_odat_async_aib[1]), .oclkb_in1(vssl),
     /*.vssl(vssl),*/ .odat0_in1(vssl), /*.vccl(vccl),*/ .odat1_in1(vssl),
     .odat_async_in1(vssl), .shift_en(rx_shift_en[1]),
     .pd_data_in1(vssl), .dig_rstb(poutp_dig_rstb),
     .jtag_clkdr_out(jtag_clkdr_out_chain2),
     .odat1_aib(nc_odata1_out0_directout[1]),
     .jtag_rx_scan_out(jtag_rx_scan_out_chain2),
     .odat0_aib(nc_odata0_out0_directout[1]),
     .oclk_aib(nc_oclk_out0_directout[1]),
     .last_bs_out(last_bs_out_outpdir1),
     .oclkb_aib(nc_oclkb_out0_directout[1]),
     .jtag_clkdr_in(clkdr_xr2r), .jtag_mode_in(jtag_mode_in),
     .jtag_rstb(jtag_rstb), .jtag_tx_scan_in(jtag_rx_scan_out_poutp1),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_out_poutp1), .iopad(iopad_directout[1]),
     .oclkn(nc_oclkn_out0_directout[1]), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
assign gated_clk_mimic1 = !gated_clk_mimic1_b;
//assign nc_clk_mimicb = !clk_mimic;
assign nc_clk_mimicb = 1'b1;
assign nc_clk_repb = !clk_rep;
assign gated_clk_mimic1_b = !(clk_mimic1_buf & dll_csr_reg6);
assign outbuf_clk_buf = output_buffer_clk;


endmodule


