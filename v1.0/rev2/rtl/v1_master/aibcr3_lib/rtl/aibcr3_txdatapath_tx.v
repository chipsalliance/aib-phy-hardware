// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3_lib, Cell - aibcr3_txdatapath_tx, View - schematic
// LAST TIME SAVED: Jul  8 22:38:43 2015
// NETLIST TIME: Jul  9 10:52:17 2015
// `timescale 1ns / 1ns 

module aibcr3_txdatapath_tx ( SCAN_OUT_SEG2, async_dat_oshared4, async_dat_outpclk3,
     async_dat_outpdir3, dummy_dcc_done, iclkin_dist_pinp18,
     idat0_oshared0, idat0_outclk0n, idat1_oshared0, idat1_outclk0n,
     idata0_ptxclkout, idata0_ptxclkoutn, idata1_ptxclkout,
     idata1_ptxclkoutn, idataselb_oshared0, idataselb_oshared4,
     idataselb_out_chain1, idataselb_outclk0n, idataselb_outpclk3,
     idataselb_outpdir3, idataselb_ptxclkout, idataselb_ptxclkoutn,
     idirectout_data_out_chain1, ilaunch_clk_oshared0,
     ilaunch_clk_outclk0n, ilaunch_clk_ptxclkout,
     ilaunch_clk_ptxclkoutn, indrv_ptxclkout, indrv_ptxclkoutn,
     ipdrv_ptxclkout, ipdrv_ptxclkoutn, irxen_inpdir1_1,
     irxen_inpdir6_1, irxen_inpshared2, irxen_pinp18, istrbclk_pinp18,
     itxen_oshared0, itxen_oshared4, itxen_out_chain1, itxen_outclk0n,
     itxen_outpclk3, itxen_outpdir3, itxen_ptxclkout, itxen_ptxclkoutn,
     jtag_clkdr_inpdir1_1, jtag_clkdr_inpdir6_1, jtag_clkdr_inpshared2,
     jtag_clkdr_oshared0, jtag_clkdr_oshared4, jtag_clkdr_out_chain1,
     jtag_clkdr_outclk0n, jtag_clkdr_outpclk3, jtag_clkdr_outpdir3,
     jtag_clkdr_pinp18, jtag_clkdr_ptxclkout, jtag_clkdr_ptxclkoutn,
     jtag_rx_scan_inpdir1_1, jtag_rx_scan_inpdir6_1,
     jtag_rx_scan_inpshared2, jtag_rx_scan_oshared0,
     jtag_rx_scan_oshared4, jtag_rx_scan_outclk0n,
     jtag_rx_scan_outpclk3, jtag_rx_scan_outpdir3, jtag_rx_scan_pinp18,
     jtag_rx_scan_ptxclkout, jtag_rx_scan_ptxclkoutn,
     jtag_scan_out_chain1, oaibdftcore2dcc, oaibdftdll2adjch,
     oaibdftdll2core, oclk_aib_inpdir1_1, oclkb_aib_inpdir1_1,
     odat0_oshared2, odat0_oshared3, odat0_ptxclkout, odat0_ptxclkoutn,
     odat1_oshared2, odat1_oshared3, odat1_ptxclkout, odat1_ptxclkoutn,
     odat_async, odat_async_outclk0, odat_async_outclk0n,
     odirectin_data, odll_lock, pcs_clk, pcs_data_out0, pcs_data_out1,
     scan_out, shift_en_inpdir1_1, shift_en_inpdir6_1,
     shift_en_inpshared2, shift_en_oshared0, shift_en_oshared4,
     shift_en_out_chain1, shift_en_outclk0n, shift_en_outpclk3,
     shift_en_outpdir3, shift_en_pinp18, shift_en_ptxclkout,
     shift_en_ptxclkoutn, iopad_async_in, iopad_async_out, iopad_clkn,
     iopad_clkp, iopad_dat, iopad_direct_input, iopad_directout,
     iopad_directoutclkn, iopad_directoutclkp, vcc, vccl, vssl,
     SCAN_IN_SEG3, async_dat_outpclk6, async_dat_outpdir2, clkdr_xr1l, clkdr_xr1r,
     clkdr_xr2l, clkdr_xr2r, clkdr_xr3l, clkdr_xr3r, clkdr_xr4l,
     clkdr_xr4r, clkdr_xr5l, clkdr_xr5r, clkdr_xr6l, clkdr_xr6r,
     clkdr_xr7l, clkdr_xr7r, clkdr_xr8l, clkdr_xr8r, dft_tx_clk,
     dummy_dcc_lock_req, iaibdftcore2dll, iaibdftdll2adjch, iasyncdata,
     iclkin_dist_ssrdin, iclkin_dist_ssrldin, iclkin_dist_vinp00,
     iclkin_dist_vinp01, idat0_directoutclkn, idat0_directoutclkp,
     idat0_outpclk1n, idat1_directoutclkn, idat1_directoutclkp,
     idat1_outpclk1n, idata0_poutp0, idata1_poutp0, idataselb,
     idataselb_in_chain1, idataselb_outpclk1n, idataselb_outpclk6,
     idataselb_outpdir2, idataselb_poutp0, idatdll_entest_str,
     idatdll_pipeline_global_en, idatdll_rb_clkdiv_str,
     idatdll_rb_half_code_str, idatdll_rb_selflock_str,
     idatdll_scan_clk_in, idatdll_scan_in, idatdll_scan_mode_n,
     idatdll_scan_rst_n, idatdll_scan_shift_n,
     idatdll_str_align_dyconfig_ctl_static,
     idatdll_str_align_dyconfig_ctlsel,
     idatdll_str_align_stconfig_core_dn_prgmnvrt,
     idatdll_str_align_stconfig_core_up_prgmnvrt,
     idatdll_str_align_stconfig_core_updnen,
     idatdll_str_align_stconfig_dftmuxsel,
     idatdll_str_align_stconfig_dll_en,
     idatdll_str_align_stconfig_dll_rst_en,
     idatdll_str_align_stconfig_hps_ctrl_en,
     idatdll_str_align_stconfig_ndllrst_prgmnvrt,
     idatdll_str_align_stconfig_new_dll,
     idatdll_str_align_stconfig_spare, idatdll_test_clk_pll_en_n,
     idcc_dll2core, iddren_poutp0, idirectout_data,
     idirectout_data_in_chain1, idll_lock_req, ilaunch_clk_outpclk1n,
     ilaunch_clk_poutp0, indrv_r12, indrv_r34, indrv_r56, indrv_r78,
     input_rstb, ipdrv_r12, ipdrv_r34, ipdrv_r56, ipdrv_r78,
     irxen_inpclk0, irxen_inpclk1, irxen_inpdir0_1, irxen_r0, irxen_r1,
     irxen_r2, irxen_r3, irxen_ssrdin, irxen_ssrldin, irxen_vinp00,
     irxen_vinp01, istrbclk_ssrdin, istrbclk_ssrldin, istrbclk_vinp00,
     istrbclk_vinp01, itxen, itxen_in_chain1, itxen_outpclk1n,
     itxen_outpclk6, itxen_outpdir2, itxen_poutp0,
     jtag_clkdr_in_chain1, jtag_clkdr_inpclk0, jtag_clkdr_inpclk1,
     jtag_clkdr_inpdir0_1, jtag_clkdr_out_poutp0, jtag_clkdr_outpclk1n,
     jtag_clkdr_outpclk6, jtag_clkdr_outpdir2, jtag_clkdr_ssrdin,
     jtag_clkdr_ssrldin, jtag_clkdr_vinp00, jtag_clkdr_vinp01,
     jtag_clksel, jtag_intest, jtag_mode_in, jtag_rstb, jtag_rstb_en,
     jtag_rx_scan_inpclk0, jtag_rx_scan_inpclk1,
     jtag_rx_scan_inpdir0_1, jtag_rx_scan_out_poutp0,
     jtag_rx_scan_outpclk1n, jtag_rx_scan_outpclk6,
     jtag_rx_scan_outpdir2, jtag_rx_scan_ssrdin, jtag_rx_scan_ssrldin,
     jtag_rx_scan_vinp00, jtag_rx_scan_vinp01, jtag_scan_in_chain1,
     jtag_tx_scanen_in, jtag_weakpdn, jtag_weakpu, oclkn_inpdir2_1,
     odat0_aib_inpdir5_1, odat1_aib_inpdir5_1, odat_async_aib_poutp19,
     odat_async_aib_vinp10, odat_async_fsrldout, pinp_dig_rstb,
     por_aib_vcchssi, por_aib_vccl, rb_dcc_dll_dft_sel,
     rb_dft_ch_muxsel, rshift_en_dirclkn, rshift_en_dirclkp,
     rshift_en_drx, rshift_en_dtx, rshift_en_pinp, rshift_en_rx,
     rshift_en_tx, rshift_en_txferclkout, rshift_en_txferclkoutn,
     shift_en_in_chain1, shift_en_inpclk0, shift_en_inpclk1,
     shift_en_inpdir0_1, shift_en_outpclk1n, shift_en_outpclk6,
     shift_en_outpdir2, shift_en_poutp0, shift_en_ssrdin,
     shift_en_ssrldin, shift_en_vinp00, shift_en_vinp01,
     txdirclk_fast_clkn, txdirclk_fast_clkp );

output  async_dat_oshared4, async_dat_outpclk3, async_dat_outpdir3,
     dummy_dcc_done, iclkin_dist_pinp18, idat0_oshared0,
     idat0_outclk0n, idat1_oshared0, idat1_outclk0n, idata0_ptxclkout,
     idata0_ptxclkoutn, idata1_ptxclkout, idata1_ptxclkoutn,
     idataselb_oshared0, idataselb_oshared4, idataselb_out_chain1,
     idataselb_outclk0n, idataselb_outpclk3, idataselb_outpdir3,
     idataselb_ptxclkout, idataselb_ptxclkoutn,
     idirectout_data_out_chain1, ilaunch_clk_oshared0,
     ilaunch_clk_outclk0n, ilaunch_clk_ptxclkout,
     ilaunch_clk_ptxclkoutn, istrbclk_pinp18, itxen_oshared0,
     itxen_oshared4, itxen_out_chain1, itxen_outclk0n, itxen_outpclk3,
     itxen_outpdir3, itxen_ptxclkout, itxen_ptxclkoutn,
     jtag_clkdr_inpdir1_1, jtag_clkdr_inpdir6_1, jtag_clkdr_inpshared2,
     jtag_clkdr_oshared0, jtag_clkdr_oshared4, jtag_clkdr_out_chain1,
     jtag_clkdr_outclk0n, jtag_clkdr_outpclk3, jtag_clkdr_outpdir3,
     jtag_clkdr_pinp18, jtag_clkdr_ptxclkout, jtag_clkdr_ptxclkoutn,
     jtag_rx_scan_inpdir1_1, jtag_rx_scan_inpdir6_1,
     jtag_rx_scan_inpshared2, jtag_rx_scan_oshared0,
     jtag_rx_scan_oshared4, jtag_rx_scan_outclk0n,
     jtag_rx_scan_outpclk3, jtag_rx_scan_outpdir3, jtag_rx_scan_pinp18,
     jtag_rx_scan_ptxclkout, jtag_rx_scan_ptxclkoutn,
     jtag_scan_out_chain1, oclk_aib_inpdir1_1, oclkb_aib_inpdir1_1,
     odat0_oshared2, odat0_oshared3, odat0_ptxclkout, odat0_ptxclkoutn,
     odat1_oshared2, odat1_oshared3, odat1_ptxclkout, odat1_ptxclkoutn,
     odat_async_outclk0, odat_async_outclk0n, odll_lock, pcs_clk,
     scan_out, shift_en_inpdir1_1, shift_en_inpdir6_1,
     shift_en_inpshared2, shift_en_oshared0, shift_en_oshared4,
     shift_en_out_chain1, shift_en_outclk0n, shift_en_outpclk3,
     shift_en_outpdir3, shift_en_pinp18, shift_en_ptxclkout,
     shift_en_ptxclkoutn, SCAN_OUT_SEG2;

inout  iopad_clkn, iopad_clkp, vcc, vccl, vssl;

input  async_dat_outpclk6, async_dat_outpdir2, clkdr_xr1l, clkdr_xr1r,
     clkdr_xr2l, clkdr_xr2r, clkdr_xr3l, clkdr_xr3r, clkdr_xr4l,
     clkdr_xr4r, clkdr_xr5l, clkdr_xr5r, clkdr_xr6l, clkdr_xr6r,
     clkdr_xr7l, clkdr_xr7r, clkdr_xr8l, clkdr_xr8r, dft_tx_clk,
     dummy_dcc_lock_req, iclkin_dist_ssrdin, iclkin_dist_ssrldin,
     iclkin_dist_vinp00, iclkin_dist_vinp01, idat0_outpclk1n,
     idat1_outpclk1n, idata0_poutp0, idata1_poutp0,
     idataselb_in_chain1, idataselb_outpclk1n, idataselb_outpclk6,
     idataselb_outpdir2, idataselb_poutp0, idatdll_entest_str,
     idatdll_pipeline_global_en, idatdll_rb_half_code_str,
     idatdll_rb_selflock_str, idatdll_scan_clk_in, idatdll_scan_in,
     idatdll_scan_mode_n, idatdll_scan_rst_n, idatdll_scan_shift_n,
     idatdll_str_align_dyconfig_ctlsel,
     idatdll_str_align_stconfig_core_dn_prgmnvrt,
     idatdll_str_align_stconfig_core_up_prgmnvrt,
     idatdll_str_align_stconfig_core_updnen,
     idatdll_str_align_stconfig_dll_en,
     idatdll_str_align_stconfig_dll_rst_en,
     idatdll_str_align_stconfig_hps_ctrl_en,
     idatdll_str_align_stconfig_ndllrst_prgmnvrt,
     idatdll_test_clk_pll_en_n, iddren_poutp0,
     idirectout_data_in_chain1, idll_lock_req, ilaunch_clk_outpclk1n,
     ilaunch_clk_poutp0, input_rstb, istrbclk_ssrdin, istrbclk_ssrldin,
     istrbclk_vinp00, istrbclk_vinp01, itxen_in_chain1,
     itxen_outpclk1n, itxen_outpclk6, itxen_outpdir2, itxen_poutp0,
     jtag_clkdr_in_chain1, jtag_clkdr_inpclk0, jtag_clkdr_inpclk1,
     jtag_clkdr_inpdir0_1, jtag_clkdr_out_poutp0, jtag_clkdr_outpclk1n,
     jtag_clkdr_outpclk6, jtag_clkdr_outpdir2, jtag_clkdr_ssrdin,
     jtag_clkdr_ssrldin, jtag_clkdr_vinp00, jtag_clkdr_vinp01,
     jtag_clksel, jtag_intest, jtag_mode_in, jtag_rstb, jtag_rstb_en,
     jtag_rx_scan_inpclk0, jtag_rx_scan_inpclk1,
     jtag_rx_scan_inpdir0_1, jtag_rx_scan_out_poutp0,
     jtag_rx_scan_outpclk1n, jtag_rx_scan_outpclk6,
     jtag_rx_scan_outpdir2, jtag_rx_scan_ssrdin, jtag_rx_scan_ssrldin,
     jtag_rx_scan_vinp00, jtag_rx_scan_vinp01, jtag_scan_in_chain1,
     jtag_tx_scanen_in, jtag_weakpdn, jtag_weakpu, oclkn_inpdir2_1,
     odat0_aib_inpdir5_1, odat1_aib_inpdir5_1, odat_async_aib_poutp19,
     odat_async_aib_vinp10, odat_async_fsrldout, pinp_dig_rstb,
     por_aib_vcchssi, por_aib_vccl, rb_dcc_dll_dft_sel,
     rb_dft_ch_muxsel, rshift_en_txferclkout, rshift_en_txferclkoutn,
     shift_en_in_chain1, shift_en_inpclk0, shift_en_inpclk1,
     shift_en_inpdir0_1, shift_en_outpclk1n, shift_en_outpclk6,
     shift_en_outpdir2, shift_en_poutp0, shift_en_ssrdin,
     shift_en_ssrldin, shift_en_vinp00, shift_en_vinp01, SCAN_IN_SEG3;

output [2:0]  irxen_inpshared2;
output [12:0]  oaibdftdll2adjch;
output [2:0]  irxen_inpdir6_1;
output [1:0]  ipdrv_ptxclkoutn;
output [1:0]  indrv_ptxclkoutn;
output [1:0]  ipdrv_ptxclkout;
output [1:0]  indrv_ptxclkout;
output [2:0]  irxen_pinp18;
output [2:0]  odat_async;
output [2:0]  irxen_inpdir1_1;
output [3:0]  odirectin_data;
output [12:0]  oaibdftdll2core;
output [2:0]  oaibdftcore2dcc;
output [19:0]  pcs_data_out1;
output [19:0]  pcs_data_out0;

inout [1:0]  iopad_directoutclkp;
inout [2:0]  iopad_directout;
inout [1:0]  iopad_directoutclkn;
inout [4:0]  iopad_async_out;
inout [2:0]  iopad_async_in;
inout [3:0]  iopad_direct_input;
inout [19:0]  iopad_dat;

input [2:0]  irxen_r1;
input [1:0]  txdirclk_fast_clkn;
input [19:0]  idatdll_str_align_stconfig_dftmuxsel;
input [10:0]  idatdll_str_align_stconfig_spare;
input [2:0]  idatdll_str_align_stconfig_new_dll;
input [2:0]  iaibdftcore2dll;
input [2:0]  irxen_ssrldin;
input [9:0]  idatdll_str_align_dyconfig_ctl_static;
input [2:0]  irxen_r0;
input [12:0]  iaibdftdll2adjch;
input [2:0]  idirectout_data;
input [1:0]  indrv_r78;
input [1:0]  ipdrv_r56;
input [2:0]  irxen_r2;
input [2:0]  irxen_ssrdin;
input [1:0]  ipdrv_r78;
input [1:0]  indrv_r12;
input [3:0]  rshift_en_rx;
input [2:0]  irxen_inpdir0_1;
input [1:0]  ipdrv_r34;
input [1:0]  rshift_en_dirclkp;
input [1:0]  ipdrv_r12;
input [2:0]  irxen_vinp00;
input [12:0]  idcc_dll2core;
input [1:0]  indrv_r56;
input [1:0]  txdirclk_fast_clkp;
input [1:0]  rshift_en_dirclkn;
input [2:0]  irxen_inpclk1;
input [1:0]  idat1_directoutclkp;
input [2:0]  idatdll_rb_clkdiv_str;
input [2:0]  irxen_r3;
input [2:0]  itxen;
input [2:0]  irxen_inpclk0;
input [1:0]  idat0_directoutclkp;
input [3:0]  rshift_en_drx;
input [4:0]  iasyncdata;
input [1:0]  idat0_directoutclkn;
input [2:0]  irxen_vinp01;
input [1:0]  idat1_directoutclkn;
input [2:0]  idataselb;
input [2:0]  rshift_en_dtx;
input [1:0]  indrv_r34;
input [3:0]  rshift_en_tx;
input [19:0]  rshift_en_pinp;

wire rb_dft_ch_muxsel, rb_dcc_dll_dft_sel, pcs_clk, clktree_pcs_clk, scan_out, dll_scan_out, nc_clk_mimic0b, nc_clk_mimic0, nc_clk_mimic1b, nc_clk_mimic1, nc_clk_distclkb, clk_distclk;
wire oclk_clkp_buf;
wire oclk_clkpb_buf;
wire oclk_clkp_io;
wire oclk_clkpb_io;

// Buses in the design

wire  [0:12]  mx_dftdll2adjch;

wire  [12:0]  odll_dll2core;

wire  [2:0]  oaibdftcore2dll;

wire  [0:12]  buf_dll2core;

wire  [0:12]  buf_dcc2core;

wire  [0:12]  mux_dft_dll2core;

wire  [51:0]  csr_reg_str;

wire  [0:11]  rx_strbclk_l;

wire  [0:11]  rx_distclk_l;

wire  [0:11]  rx_distclk_r;

wire  [0:0]  nc_rx_fast_clk;

wire  [0:0]  nc_rx_fast_clkb;

wire  [0:0]  ncout_tx_fast_clkn;

wire  [1:1]  ncout_rx_fast_clkn;

wire  [0:1]  ncout_rx_fast_clknb;

wire  [0:1]  nc_rxodat0_clkn;

wire  [0:1]  nc_rxodat1_clkn;

wire  [0:1]  nc_rxodat_async_clkn;

wire  [0:1]  nc_rxpd_data_clkn;

wire  [0:11]  rx_strbclk_r;

wire  [1:1]  nc_out_rx_fast_clk;

wire  [1:1]  nc_out_rx_fast_clkb;

wire  [0:1]  nc_rxodat0_clkp;

wire  [0:1]  nc_rxodat1_clkp;

wire  [0:1]  nc_rxodat_async_clkp;

wire  [0:1]  nc_rxpd_data_clkp;

wire  [0:2]  ncdtx_oclkb_aib;

wire  [0:2]  ncdtx_oclk;

wire  [0:2]  ncdtx_oclkb;

wire  [0:2]  ncdtx_odat0;

wire  [0:2]  ncdtx_odat1;

wire  [0:2]  ncdtx_odat_async;

wire  [0:2]  ncdtx_pd_data;

wire  [0:2]  ncdtx_oclk_aib;

wire  [0:2]  ncdtx_odat0_aib;

wire  [0:2]  ncdtx_odat1_aib;

wire  [0:2]  ncdtx_odat_async_aib;

wire  [0:2]  ncdtx_pd_data_aib;

wire  [0:1]  nctx_odat_async_aib;

wire  [0:4]  nctx_odat1_aib;

wire  [0:4]  nctx_odat1;

wire  [0:4]  nctx_odat_async;

wire  [0:4]  nctx_pd_data;

wire  [0:4]  nctx_oclk_aib;

wire  [0:4]  nctx_oclkb_aib;

wire  [0:4]  nctx_pd_data_aib;

wire  [0:4]  nctx_odat0_aib;

wire  [0:4]  nctx_oclkn;

wire  [0:2]  ncrx_oclkn;

wire  [0:2]  ncrx_oclk_aib;

wire  [0:2]  ncrx_oclkb_aib;

wire  [0:2]  ncrx_odat0_aib;

wire  [0:2]  ncrx_odat1_aib;

wire  [1:1]  ncrx_odat_async_aib;

wire  [0:2]  ncrx_pd_data_aib;

wire  [0:4]  nctx_oclk;

wire  [0:4]  nctx_oclkb;

wire  [0:4]  nctx_odat0;

wire  [0:2]  ncrx_oclk;

wire  [0:2]  ncrx_oclkb;

wire  [0:2]  ncrx_odat0;

wire  [0:2]  ncrx_odat1;

wire  [0:2]  ncrx_pd_data;

wire  [1:3]  ncdrx_odat0_aib;

wire  [0:3]  ncdrx_odat0;

wire  [1:3]  ncdrx_odat1_aib;

wire  [0:3]  ncdrx_oclk;

wire  [0:3]  ncdrx_oclkb;

wire  [0:3]  ncdrx_pd_data;

wire  [0:3]  ncdrx_odat1;

wire  [0:3]  ncdrx_oclkn;

wire  [0:2]  ncdrx_oclk_aib;

wire  [0:2]  ncdrx_oclkb_aib;

wire  [0:19]  nc_pd_data_aib_pin;

wire  [2:19]  nc_odat_async_aib_pin;

wire  [0:3]  ncdrx_odat_async_aib;

wire  [0:3]  ncdrx_pd_data_aib;

wire  [0:19]  nc_oclk;

wire  [0:19]  nc_oclkb;

wire  [0:19]  odat1_aib_pin;

wire  [0:19]  nc_odat_async;

wire  [0:19]  odat0_aib_pin;

wire  [0:19]  nc_pd_data;

wire  [0:19]  nc_oclkn_pin;

wire  [0:19]  nc_oclk_aib_pin;

wire  [0:19]  nc_oclkb_aib_pin;

wire [19:0]  pcs_data_out0_int;
wire [19:0]  pcs_data_out1_int;
wire         clk_postdll;
wire         clkin_pcs;

wire txdirclk_fast_clkp0_buf;
wire jtag_clkdr_outn_outpdir3;
wire nc_last_bs_out_outpdir3;
wire jtag_rx_scan_dirclkp1;
wire ncdtx_oclkn0;
wire jtag_clkdr_outn_inpdir3_1;
wire ncdrx_odat_async_aib2;
wire odat_async_inpshared0;
wire jtag_clkdr_inpdir3_1;
wire jtag_rx_scan_inpdir3_1;
wire nc_last_bs_out_inpdir3_1;
wire jtag_clkdr_outn_oshared4;
wire tx_odat_async_aib4;
wire nc_last_bs_out_diro4;
wire jtag_rx_scan_inpshared0;
wire jtag_clkdr_outn_inpshared0;
wire jtag_clkdr_inpshared0;
wire nc_last_bs_out_diro0;
wire jtag_clkdr_outn_pinp9;
wire odat0_aib_txferclkoutn;
wire odat1_aib_txferclkoutn;
wire jtag_clkdr_pinp9;
wire jtag_rx_scan_pinp9;
wire nc_last_bs_out_pinp9;
wire jtag_rx_scan_pinp7;
wire jtag_clkdr_outn_clkn;
wire nc_pd_data_aib_txferclkoutn;
wire nc_oclk_clkn;
wire nc_oclkb_clkn;
wire nc_odat0_clkn;
wire nc_odat1_clkn;
wire nc_odat_async_clkn;
wire nc_pd_data_clkn;
wire nc_odat_async_aib_txferclkoutn;
wire jtag_clkdr_clkn;
wire jtag_rx_scan_clkn;
wire nc_oclk_aib_txferclkoutn;
wire nc_last_bs_out_txferclkoutn;
wire nc_oclkb_aib_txferclkoutn;
wire oclkn_txferclkoutn;
wire jtag_clkdr_outn_pinp5;
wire jtag_clkdr_pinp5;
wire jtag_rx_scan_pinp5;
wire nc_last_bs_out_pinp5;
wire jtag_rx_scan_pinp3;
wire jtag_clkdr_outn_pinp3;
wire jtag_clkdr_pinp3;
wire nc_last_bs_out_pinp3;
wire jtag_rx_scan_pinp1;
wire jtag_clkdr_outn_pinp1;
wire odat_async_aib_pin1;
wire jtag_clkdr_pinp1;
wire nc_last_bs_out_pinp1;
wire jtag_clkdr_outn_pinp7;
wire jtag_clkdr_pinp7;
wire nc_last_bs_out_pinp7;
wire jtag_clkdr_outn_pinp2;
wire jtag_clkdr_pinp2;
wire jtag_rx_scan_pinp2;
wire nc_last_bs_out_pinp2;
wire jtag_rx_scan_pinp0;
wire jtag_clkdr_outn_pinp0;
wire nc_odat_async_aib_pin0;
wire jtag_clkdr_pinp0;
wire nc_last_bs_out_pinp0;
wire jtag_clkdr_outn_pinp4;
wire jtag_clkdr_pinp4;
wire jtag_rx_scan_pinp4;
wire nc_last_bs_out_pinp4;
wire jtag_clkdr_outn_oshared2;
wire nctx_odat_async_aib2;
wire jtag_clkdr_oshared2;
wire jtag_rx_scan_oshared2;
wire nc_last_bs_out_oshared2;
wire nctx_oclkn2;
wire jtag_clkdr_outn_pinp11;
wire jtag_clkdr_pinp11;
wire jtag_rx_scan_pinp11;
wire nc_last_bs_out_pinp11;
wire oclkn_pin11;
wire jtag_clkdr_outn_inpdir4_1;
wire ncdrx_odatasync_aib1;
wire jtag_clkdr_inpdir4_1;
wire nc_last_bs_out_indir4_1;
wire jtag_rx_scan_oshared1;
wire jtag_clkdr_outn_pinp6;
wire jtag_clkdr_pinp6;
wire jtag_rx_scan_pinp6;
wire nc_last_bs_out_pinp6;
wire jtag_clkdr_outn_pinp8;
wire odat0_aib_txferclkout;
wire odat1_aib_txferclkout;
wire jtag_clkdr_pinp8;
wire jtag_rx_scan_pinp8;
wire nc_last_bs_out_pinp8;
wire jtag_clkdr_outn_clkp;
wire nc_pd_data_aib_txferclkout;
wire oclk_clkp;
wire oclk_clkpb;
wire nc_odat0_clkp;
wire nc_odat1_clkp;
wire nc_odat_async_clkp;
wire nc_pd_data_clkp;
wire oclk_aib_pin10;
wire nc_odat_async_aib_txferclkout;
wire oclkb_aib_pin10;
wire jtag_clkdr_clkp;
wire jtag_rx_scan_clkp;
wire oclk_aib_txferclkout;
wire nc_last_bs_out_txferclkout;
wire oclkb_aib_txferclkout;
wire nc_oclkn_txferclkout;
wire jtag_clkdr_outn_pinp10;
wire jtag_clkdr_pinp10;
wire jtag_rx_scan_pinp10;
wire nc_last_bs_out_pinp10;
wire jtag_clkdr_outn_pinp12;
wire jtag_clkdr_pinp12;
wire jtag_rx_scan_pinp12;
wire nc_last_bs_out_pinp12;
wire jtag_clkdr_outn_pinp13;
wire jtag_clkdr_pinp13;
wire jtag_rx_scan_pinp13;
wire nc_last_bs_out_pinp13;
wire jtag_clkdr_outn_pinp14;
wire jtag_clkdr_pinp14;
wire jtag_rx_scan_pinp14;
wire nc_last_bs_out_pinp14;
wire jtag_clkdr_outn_pinp15;
wire jtag_clkdr_pinp15;
wire jtag_rx_scan_pinp15;
wire nc_last_bs_out_pinp15;
wire jtag_clkdr_outn_ptxclkout;
wire ncrx_pd_data_aib_clkp0;
wire ncrx_odat_async_aib_clkp0;
wire ncrx_oclk_aib_clkp0;
wire nc_last_bs_out_ptxclkout;
wire ncrx_oclkb_aib_clkp0;
wire nc_rxoclk_clkp0;
wire jtag_clkdr_outn_oshared1;
wire jtag_clkdr_oshared1;
wire nc_last_bs_out_oshared1;
wire jtag_rx_scan_oshared3;
wire jtag_clkdr_outn_oshared0;
wire nc_last_bs_out_oshared0;
wire jtag_clkdr_outn_inpshared2;
wire odat_async_aib_inpshared2;
wire nc_last_bs_out_diro2;
wire jtag_rx_scan_inpshared1;
wire jtag_clkdr_outn_outpdir0;
wire nc_last_bs_out_outpdir0;
wire ncdtx_oclkn1;
wire jtag_clkdr_outn_pinp18;
wire nc_last_bs_out_pinp18;
wire jtag_rx_scan_pinp16;
wire jtag_clkdr_outn_outclk0n;
wire ncrx_pd_data_aib_clkn1;
wire nc_odat1_outpclk0n;
wire nc_odat0_outpclk0n;
wire nc_out_rx_fast_clkn_aib1;
wire nc_last_bs_out_outclk0n;
wire nc_out_rx_fast_clknb_aib1;
wire oclkn_clkn1;
wire jtag_clkdr_outn_pinp16;
wire jtag_clkdr_pinp16;
wire nc_last_bs_out_pinp16;
wire jtag_clkdr_outn_pinp19;
wire drx_odat0_aib_0;
wire drx_odat1_aib_0;
wire jtag_clkdr_pinp19;
wire jtag_rx_scan_pinp19;
wire nc_last_bs_out_pinp19;
wire jtag_rx_scan_pinp17;
wire jtag_clkdr_outn_inpshared1;
wire jtag_clkdr_inpshared1;
wire nc_last_bs_out_diro1;
wire jtag_clkdr_outn_oshared3;
wire nctx_odat_async_aib3;
wire jtag_clkdr_oshared3;
wire nc_last_bs_out_oshared3;
wire jtag_clkdr_outn_outpclk3;
wire nc_last_bs_out_outpclk3;
wire ncdtx_oclkn2;
wire jtag_clkdr_outn_pinp17;
wire jtag_clkdr_pinp17;
wire nc_last_bs_out_pinp17;
wire jtag_clkdr_outn_inpdir6_1;
wire nc_last_bs_out_inpdir6_1;
wire jtag_clkdr_outn_ptxclkoutn;
wire ncrx_pd_data_aib_clkn0;
wire ncrx_odat_async_aib_clkn0;
wire nc_out_rx_fast_clkn_aib0;
wire nc_last_bs_out_ptxclkoutn;
wire nc_out_rx_fast_clknb_aib0;
wire nc_oclkn_clkn0;
wire jtag_clkdr_outn_outclk0;
wire ncrx_pd_data_aib_clkp1;
wire jtag_clkdr_dirclkp1;
wire nc_odat1_outpclk0;
wire nc_odat0_outpclk0;
wire nc_out_rx_fast_clk_aib1;
wire nc_last_bs_out_outclk0;
wire nc_out_rx_fast_clkb_aib1;
wire nc_rxoclk_clkp1;
wire jtag_clkdr_outn_inpdir1_1;
wire nc_last_bs_out_inpdir1_1;
wire nc_idat1_outpdir3;
wire nc_idat0_outpdir3;
wire idat0_dirclkp1;
wire idat1_dirclkp1;
wire nc_idat1_inpdir3_1;
wire nc_idat0_inpdir3_1;
wire nc_async_dat_inpdir3_1;
wire nc_idat1_oshared4;
wire nc_idat0_oshared4;
wire nc_idat1_inpshared0;
wire nc_idat0_inpshared0;
wire nc_async_dat_inpshared0;
wire nc_idat1_pinp9;
wire nc_idat0_pinp9;
wire nc_async_dat_pinp9;
wire idat1_in1_clkn;
wire idat0_in1_clkn;
wire nc_async_dat_clkn;
wire nc_idat1_pinp5;
wire nc_idat0_pinp5;
wire nc_async_dat_pinp5;
wire nc_idat1_pinp3;
wire nc_idat0_pinp3;
wire nc_async_dat_pinp3;
wire nc_idat1_pinp1;
wire nc_idat0_pinp1;
wire nc_async_dat_pinp1;
wire nc_idat1_pinp7;
wire nc_idat0_pinp7;
wire nc_async_dat_pinp7;
wire nc_idat1_pinp2;
wire nc_idat0_pinp2;
wire nc_async_dat_pinp2;
wire nc_idat1_pinp0;
wire nc_idat0_pinp0;
wire nc_async_dat_pinp0;
wire nc_idat1_pinp4;
wire nc_idat0_pinp4;
wire nc_async_dat_pinp4;
wire idat1_oshared2;
wire idat0_oshared2;
wire nc_async_dat_oshared2;
wire nc_idat1_pinp11;
wire nc_idat0_pinp11;
wire nc_async_dat_pinp11;
wire nc_idat1_inpdir4_1;
wire nc_idat0_inpdir4_1;
wire nc_async_dat_inpdir4_1;
wire idat0_oshared1;
wire idat1_oshared1;
wire nc_idat1_pinp6;
wire nc_idat0_pinp6;
wire nc_async_dat_pinp6;
wire nc_idat1_pinp8;
wire nc_idat0_pinp8;
wire nc_async_dat_pinp8;
wire idat1_in1_clkp;
wire idat0_in1_clkp;
wire nc_async_dat_clkp;
wire nc_idat1_pinp10;
wire nc_idat0_pinp10;
wire nc_async_dat_pinp10;
wire nc_idat1_pinp12;
wire nc_idat0_pinp12;
wire nc_async_dat_pinp12;
wire nc_idat1_pinp13;
wire nc_idat0_pinp13;
wire nc_async_dat_pinp13;
wire nc_idat1_pinp14;
wire nc_idat0_pinp14;
wire nc_async_dat_pinp14;
wire nc_idat1_pinp15;
wire nc_idat0_pinp15;
wire nc_async_dat_pinp15;
wire nc_async_dat_ptxclkout;
wire nc_async_dat_oshared1;
wire idat0_oshared3;
wire idat1_oshared3;
wire nc_async_dat_oshared0;
wire nc_idat1_inpshared2;
wire nc_idat0_inpshared2;
wire nc_async_dat_inpshared2;
wire nc_idat1_outpdir0;
wire nc_idat0_outpdir0;
wire nc_idat1_pinp18;
wire nc_idat0_pinp18;
wire nc_async_dat_pinp18;
wire nc_async_dat_outclk0n;
wire nc_idat1_pinp16;
wire nc_idat0_pinp16;
wire nc_async_dat_pinp16;
wire nc_idat1_pinp19;
wire nc_idat0_pinp19;
wire nc_async_dat_pinp19;
wire nc_idat1_inpshared1;
wire nc_idat0_inpshared1;
wire nc_async_dat_inpshared1;
wire nc_async_dat_oshared3;
wire nc_idat1_outpclk3;
wire nc_idat0_outpclk3;
wire nc_idat1_pinp17;
wire nc_idat0_pinp17;
wire nc_async_dat_pinp17;
wire nc_idat1_inpdir6_1;
wire nc_idat0_inpdir6_1;
wire nc_async_dat_inpdir6_1;
wire nc_async_dat_ptxclkoutn;
wire nc_async_dat_dirclkp1;
wire nc_idat1_inpdir1_1;
wire nc_idat0_inpdir1_1;
wire nc_async_dat_inpdir1_1;
wire pcs_clk_int;

// specify 
//     specparam CDS_LIBNAME  = "aibcr3_lib";
//     specparam CDS_CELLNAME = "aibcr3_txdatapath_tx";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

aibcr3_dcc_top_dummy x874 ( .vcc_aibcr(vcc), .vss_aibcr(vssl),
     .vcc_io(vcc), .clk_dcc(txdirclk_fast_clkp0_buf),
     .dcc_done(dummy_dcc_done), .clk_dcd(txdirclk_fast_clkp[0]),
     .dcc_req(dummy_dcc_lock_req));
aibcr3_aliasd  r70 ( .rb(shift_en_inpdir1_1), .ra(rshift_en_drx[3]));
aibcr3_aliasd  r69 ( .rb(shift_en_ptxclkout), .ra(rshift_en_dirclkp[0]));
aibcr3_aliasd  r68 ( .rb(shift_en_oshared0), .ra(rshift_en_rx[0]));
aibcr3_aliasd  r67 ( .rb(itxen_oshared0), .ra(itxen[2]));
aibcr3_aliasd  r66 ( .rb(ilaunch_clk_oshared0), .ra(iasyncdata[0]));
aibcr3_aliasd  r65 ( .rb(idataselb_oshared0), .ra(idataselb[2]));
aibcr3_aliasd  r64 ( .rb(shift_en_out_chain1), .ra(rshift_en_dtx[1]));
aibcr3_aliasd  r63 ( .rb(shift_en_pinp18), .ra(rshift_en_pinp[18]));
aibcr3_aliasd  r62 ( .rb(shift_en_inpdir6_1), .ra(rshift_en_drx[0]));
aibcr3_aliasd  r61 ( .rb(shift_en_ptxclkoutn), .ra(rshift_en_dirclkn[0]));
aibcr3_aliasd  r60 ( .rb(shift_en_outpdir3), .ra(rshift_en_dtx[0]));
aibcr3_aliasd  r58 ( .rb(shift_en_inpshared2), .ra(rshift_en_tx[3]));
aibcr3_aliasd  r59 ( .rb(shift_en_oshared4), .ra(rshift_en_tx[2]));
aibcr3_aliasd  r57 ( .rb(itxen_outclk0n), .ra(itxen[0]));
aibcr3_aliasd  r54 ( .rb(ilaunch_clk_outclk0n), .ra(txdirclk_fast_clkp[1]));
aibcr3_aliasd  r53 ( .rb(idataselb_outclk0n), .ra(idataselb[0]));
aibcr3_aliasd  r52 ( .rb(shift_en_outclk0n), .ra(rshift_en_dirclkn[1]));
aibcr3_aliasd  r51 ( .rb(shift_en_outpclk3), .ra(rshift_en_dtx[2]));
aibcr3_aliasd  r50[1:0] ( .ra(indrv_r56[1:0]), .rb(indrv_ptxclkoutn[1:0]));
aibcr3_aliasd  r49[1:0] ( .ra(ipdrv_r56[1:0]), .rb(ipdrv_ptxclkoutn[1:0]));
aibcr3_aliasd  r47[1:0] ( .ra(indrv_r56[1:0]), .rb(indrv_ptxclkout[1:0]));
aibcr3_aliasd  r48[1:0] ( .ra(ipdrv_r56[1:0]), .rb(ipdrv_ptxclkout[1:0]));
aibcr3_aliasd  r19 ( .rb(idataselb_outpclk3), .ra(idataselb[1]));
aibcr3_aliasd  r18 ( .rb(itxen_outpclk3), .ra(itxen[1]));
aibcr3_aliasd  r13[2:0] ( .ra(irxen_r0[2:0]), .rb(irxen_pinp18[2:0]));
aibcr3_aliasd  r12[2:0] ( .ra(irxen_r2[2:0]), .rb(irxen_inpdir6_1[2:0]));
aibcr3_aliasd  r15 ( .rb(istrbclk_pinp18), .ra(rx_strbclk_l[9]));
aibcr3_aliasd  r20 ( .rb(idataselb_outpdir3), .ra(idataselb[1]));
aibcr3_aliasd  r9[19:0] ( .ra(idatdll_str_align_stconfig_dftmuxsel[19:0]),
     .rb(csr_reg_str[47:28]));
aibcr3_aliasd  r11 ( .rb(csr_reg_str[51]),
     .ra(idatdll_str_align_stconfig_hps_ctrl_en));
aibcr3_aliasd  r14 ( .rb(iclkin_dist_pinp18), .ra(rx_distclk_l[9]));
aibcr3_aliasd  r16[2:0] ( .ra(irxen_r2[2:0]), .rb(irxen_inpdir1_1[2:0]));
aibcr3_aliasd  r22 ( .rb(itxen_outpdir3), .ra(itxen[1]));
aibcr3_aliasd  r2 ( .rb(csr_reg_str[2]),
     .ra(idatdll_str_align_stconfig_ndllrst_prgmnvrt));
aibcr3_aliasd  r1 ( .rb(csr_reg_str[1]),
     .ra(idatdll_str_align_stconfig_dll_en));
aibcr3_aliasd  r39 ( .rb(itxen_oshared4), .ra(itxen[2]));
aibcr3_aliasd  r38 ( .rb(idataselb_oshared4), .ra(idataselb[1]));
aibcr3_aliasd  r36 ( .rb(itxen_ptxclkoutn), .ra(itxen[0]));
aibcr3_aliasd  r35 ( .rb(idataselb_ptxclkoutn), .ra(idataselb[0]));
aibcr3_aliasd  r34 ( .rb(ilaunch_clk_ptxclkoutn),
     .ra(txdirclk_fast_clkp0_buf));
aibcr3_aliasd  r23 ( .rb(itxen_out_chain1), .ra(itxen[1]));
aibcr3_aliasd  r26 ( .rb(itxen_ptxclkout), .ra(itxen[0]));
aibcr3_aliasd  r25 ( .rb(idataselb_out_chain1), .ra(idataselb[1]));
aibcr3_aliasd  r27 ( .rb(idataselb_ptxclkout), .ra(idataselb[0]));
aibcr3_aliasd  r4 ( .rb(csr_reg_str[4]),
     .ra(idatdll_str_align_stconfig_core_dn_prgmnvrt));
aibcr3_aliasd  r41[2:0] ( .ra(irxen_r3[2:0]), .rb(irxen_inpshared2[2:0]));
aibcr3_aliasd  r3 ( .rb(csr_reg_str[3]),
     .ra(idatdll_str_align_stconfig_core_up_prgmnvrt));
aibcr3_aliasd  r10[2:0] ( .ra(idatdll_str_align_stconfig_new_dll[2:0]),
     .rb(csr_reg_str[50:48]));
// margining change starts
aibcr3_aliasd  r6[8:0] ( .ra(idatdll_str_align_stconfig_spare[8:0]),
     .rb(csr_reg_str[14:6]));
aibcr3_aliasd  r6_split[1:0] ( .ra({1'b0, 1'b0}),
     .rb(csr_reg_str[16:15]));
// margining change ends
aibcr3_aliasd  r5 ( .rb(csr_reg_str[5]),
     .ra(idatdll_str_align_stconfig_core_updnen));
aibcr3_aliasd  r7 ( .rb(csr_reg_str[17]),
     .ra(idatdll_str_align_dyconfig_ctlsel));
aibcr3_aliasd  r8[9:0] ( .ra(idatdll_str_align_dyconfig_ctl_static[9:0]),
     .rb(csr_reg_str[27:18]));
aibcr3_aliasd  r29 ( .rb(ilaunch_clk_ptxclkout), .ra(txdirclk_fast_clkp0_buf));
aibcr3_aliasd  r0 ( .rb(csr_reg_str[0]),
     .ra(idatdll_str_align_stconfig_dll_rst_en));
assign mx_dftdll2adjch[11] = rb_dft_ch_muxsel ? oaibdftdll2core[11] : iaibdftdll2adjch[11];
assign mx_dftdll2adjch[7] = rb_dft_ch_muxsel ? oaibdftdll2core[7] : iaibdftdll2adjch[7];
assign mx_dftdll2adjch[3] = rb_dft_ch_muxsel ? oaibdftdll2core[3] : iaibdftdll2adjch[3];
assign mx_dftdll2adjch[10] = rb_dft_ch_muxsel ? oaibdftdll2core[10] : iaibdftdll2adjch[10];
assign mx_dftdll2adjch[6] = rb_dft_ch_muxsel ? oaibdftdll2core[6] : iaibdftdll2adjch[6];
assign mx_dftdll2adjch[12] = rb_dft_ch_muxsel ? oaibdftdll2core[12] : iaibdftdll2adjch[12];
assign mx_dftdll2adjch[2] = rb_dft_ch_muxsel ? oaibdftdll2core[2] : iaibdftdll2adjch[2];
assign mx_dftdll2adjch[9] = rb_dft_ch_muxsel ? oaibdftdll2core[9] : iaibdftdll2adjch[9];
assign mx_dftdll2adjch[5] = rb_dft_ch_muxsel ? oaibdftdll2core[5] : iaibdftdll2adjch[5];
assign mx_dftdll2adjch[1] = rb_dft_ch_muxsel ? oaibdftdll2core[1] : iaibdftdll2adjch[1];
assign mx_dftdll2adjch[8] = rb_dft_ch_muxsel ? oaibdftdll2core[8] : iaibdftdll2adjch[8];
assign mx_dftdll2adjch[4] = rb_dft_ch_muxsel ? oaibdftdll2core[4] : iaibdftdll2adjch[4];
assign mx_dftdll2adjch[0] = rb_dft_ch_muxsel ? oaibdftdll2core[0] : iaibdftdll2adjch[0];
assign mux_dft_dll2core[9] = rb_dcc_dll_dft_sel ? buf_dcc2core[9] : buf_dll2core[9];
assign mux_dft_dll2core[10] = rb_dcc_dll_dft_sel ? buf_dcc2core[10] : buf_dll2core[10];
assign mux_dft_dll2core[2] = rb_dcc_dll_dft_sel ? buf_dcc2core[2] : buf_dll2core[2];
assign mux_dft_dll2core[12] = rb_dcc_dll_dft_sel ? buf_dcc2core[12] : buf_dll2core[12];
assign mux_dft_dll2core[5] = rb_dcc_dll_dft_sel ? buf_dcc2core[5] : buf_dll2core[5];
assign mux_dft_dll2core[4] = rb_dcc_dll_dft_sel ? buf_dcc2core[4] : buf_dll2core[4];
assign mux_dft_dll2core[0] = rb_dcc_dll_dft_sel ? buf_dcc2core[0] : buf_dll2core[0];
assign mux_dft_dll2core[1] = rb_dcc_dll_dft_sel ? buf_dcc2core[1] : buf_dll2core[1];
assign mux_dft_dll2core[7] = rb_dcc_dll_dft_sel ? buf_dcc2core[7] : buf_dll2core[7];
assign mux_dft_dll2core[11] = rb_dcc_dll_dft_sel ? buf_dcc2core[11] : buf_dll2core[11];
assign mux_dft_dll2core[6] = rb_dcc_dll_dft_sel ? buf_dcc2core[6] : buf_dll2core[6];
assign mux_dft_dll2core[8] = rb_dcc_dll_dft_sel ? buf_dcc2core[8] : buf_dll2core[8];
assign mux_dft_dll2core[3] = rb_dcc_dll_dft_sel ? buf_dcc2core[3] : buf_dll2core[3];
assign pcs_clk = clktree_pcs_clk;
assign scan_out = dll_scan_out;
assign oaibdftdll2adjch[11] = mx_dftdll2adjch[11];
assign oaibdftdll2adjch[7] = mx_dftdll2adjch[7];
assign oaibdftdll2adjch[3] = mx_dftdll2adjch[3];
assign oaibdftdll2adjch[10] = mx_dftdll2adjch[10];
assign oaibdftdll2adjch[6] = mx_dftdll2adjch[6];
assign oaibdftdll2adjch[2] = mx_dftdll2adjch[2];
assign oaibdftdll2adjch[9] = mx_dftdll2adjch[9];
assign oaibdftdll2adjch[5] = mx_dftdll2adjch[5];
assign oaibdftdll2adjch[1] = mx_dftdll2adjch[1];
assign oaibdftdll2adjch[8] = mx_dftdll2adjch[8];
assign oaibdftdll2adjch[4] = mx_dftdll2adjch[4];
assign oaibdftdll2adjch[0] = mx_dftdll2adjch[0];
assign oaibdftdll2adjch[12] = mx_dftdll2adjch[12];
assign buf_dcc2core[0] = idcc_dll2core[0];
assign buf_dll2core[9] = odll_dll2core[9];
assign buf_dcc2core[10] = idcc_dll2core[10];
assign oaibdftdll2core[8] = mux_dft_dll2core[8];
assign buf_dcc2core[12] = idcc_dll2core[12];
assign buf_dll2core[12] = odll_dll2core[12];
assign oaibdftdll2core[9] = mux_dft_dll2core[9];
assign oaibdftdll2core[10] = mux_dft_dll2core[10];
assign buf_dcc2core[11] = idcc_dll2core[11];
assign buf_dll2core[10] = odll_dll2core[10];
assign buf_dcc2core[9] = idcc_dll2core[9];
assign oaibdftdll2core[11] = mux_dft_dll2core[11];
assign buf_dll2core[11] = odll_dll2core[11];
assign oaibdftcore2dll[0] = iaibdftcore2dll[0];
assign oaibdftcore2dcc[1] = oaibdftcore2dll[1];
assign buf_dcc2core[3] = idcc_dll2core[3];
assign buf_dll2core[0] = odll_dll2core[0];
assign buf_dll2core[2] = odll_dll2core[2];
assign oaibdftcore2dll[2] = iaibdftcore2dll[2];
assign buf_dll2core[4] = odll_dll2core[4];
assign buf_dll2core[1] = odll_dll2core[1];
assign oaibdftcore2dll[1] = iaibdftcore2dll[1];
assign buf_dll2core[6] = odll_dll2core[6];
assign buf_dcc2core[6] = idcc_dll2core[6];
assign buf_dcc2core[7] = idcc_dll2core[7];
assign buf_dll2core[5] = odll_dll2core[5];
assign oaibdftdll2core[6] = mux_dft_dll2core[6];
assign oaibdftdll2core[5] = mux_dft_dll2core[5];
assign buf_dcc2core[8] = idcc_dll2core[8];
assign oaibdftdll2core[0] = mux_dft_dll2core[0];
assign oaibdftcore2dcc[0] = oaibdftcore2dll[0];
assign buf_dcc2core[2] = idcc_dll2core[2];
assign oaibdftcore2dcc[2] = oaibdftcore2dll[2];
assign buf_dcc2core[5] = idcc_dll2core[5];
assign oaibdftdll2core[7] = mux_dft_dll2core[7];
assign oaibdftdll2core[1] = mux_dft_dll2core[1];
assign buf_dll2core[7] = odll_dll2core[7];
assign oaibdftdll2core[4] = mux_dft_dll2core[4];
assign buf_dll2core[3] = odll_dll2core[3];
assign oaibdftdll2core[12] = mux_dft_dll2core[12];
assign buf_dcc2core[1] = idcc_dll2core[1];
assign buf_dcc2core[4] = idcc_dll2core[4];
assign buf_dll2core[8] = odll_dll2core[8];
assign oaibdftdll2core[3] = mux_dft_dll2core[3];
assign oaibdftdll2core[2] = mux_dft_dll2core[2];

// Margining control
assign pcs_data_out0 = idatdll_str_align_stconfig_spare[9]? pcs_data_out1_int: pcs_data_out0_int;
assign pcs_data_out1 = idatdll_str_align_stconfig_spare[9]? pcs_data_out0_int: pcs_data_out1_int;
assign clkin_pcs = idatdll_str_align_stconfig_spare[10] ? clk_postdll : oclk_clkp_buf;

aibcr3_buffx1_top xdirect_out0 (
     .idata1_in1_jtag_out(nc_idat1_outpdir3),
     .idata0_in1_jtag_out(nc_idat0_outpdir3),
     .async_dat_in1_jtag_out(async_dat_outpdir3),
     .prev_io_shift_en(rshift_en_dirclkp[1]),
     .jtag_clkdr_outn(jtag_clkdr_outn_outpdir3),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .anlg_rstb(input_rstb),
     .pd_data_aib(ncdtx_pd_data_aib[0]), .oclk_out(ncdtx_oclk[0]),
     .oclkb_out(ncdtx_oclkb[0]), .odat0_out(ncdtx_odat0[0]),
     .odat1_out(ncdtx_odat1[0]), .odat_async_out(ncdtx_odat_async[0]),
     .pd_data_out(ncdtx_pd_data[0]),
     .async_dat_in0(idirectout_data[0]), .async_dat_in1(vssl),
     .iclkin_dist_in0(vssl), .iclkin_dist_in1(vssl), .idata0_in0(vssl),
     .idata0_in1(idat0_dirclkp1), .idata1_in0(vssl),
     .idata1_in1(idat1_dirclkp1), .idataselb_in0(idataselb[1]),
     .idataselb_in1(idataselb[0]), .iddren_in0(vssl), .iddren_in1(vcc),
     .ilaunch_clk_in0(vssl), .ilaunch_clk_in1(txdirclk_fast_clkp[1]),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0(indrv_r78[1:0]),
     .indrv_in1(indrv_r78[1:0]), .ipdrv_in0(ipdrv_r78[1:0]),
     .ipdrv_in1(ipdrv_r78[1:0]), .irxen_in0({vssl, vcc, vssl}),
     .irxen_in1({vssl, vcc, vssl}), .istrbclk_in0(vssl),
     .istrbclk_in1(vssl), .itxen_in0(itxen[1]), .itxen_in1(itxen[0]),
     .oclk_in1(vssl), .odat_async_aib(ncdtx_odat_async_aib[0]),
     .oclkb_in1(vssl), .vssl(vssl), .odat0_in1(vssl), .vccl(vccl),
     .odat1_in1(vssl), .odat_async_in1(vssl),
     .shift_en(rshift_en_dtx[0]), .pd_data_in1(vssl),
     .dig_rstb(input_rstb), .jtag_clkdr_out(jtag_clkdr_outpdir3),
     .vcc(vcc), .odat1_aib(ncdtx_odat1_aib[0]),
     .jtag_rx_scan_out(jtag_rx_scan_outpdir3),
     .odat0_aib(ncdtx_odat0_aib[0]), .oclk_aib(ncdtx_oclk_aib[0]),
     .last_bs_out(nc_last_bs_out_outpdir3),
     .por_aib_vccl(por_aib_vccl), .por_aib_vcchssi(por_aib_vcchssi),
     .oclkb_aib(ncdtx_oclkb_aib[0]), .jtag_clkdr_in(clkdr_xr7l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_dirclkp1),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_directout[0]), .oclkn(ncdtx_oclkn0), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xdirect_in3_1 (
     .idata1_in1_jtag_out(nc_idat1_inpdir3_1),
     .idata0_in1_jtag_out(nc_idat0_inpdir3_1),
     .async_dat_in1_jtag_out(nc_async_dat_inpdir3_1),
     .prev_io_shift_en(shift_en_in_chain1),
     .jtag_clkdr_outn(jtag_clkdr_outn_inpdir3_1),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .anlg_rstb(input_rstb),
     .pd_data_aib(ncdrx_pd_data_aib[2]), .oclk_out(ncdrx_oclk[2]),
     .oclkb_out(ncdrx_oclkb[2]), .odat0_out(ncdrx_odat0[2]),
     .odat1_out(ncdrx_odat1[2]), .odat_async_out(odirectin_data[2]),
     .pd_data_out(ncdrx_pd_data[2]), .async_dat_in0(vssl),
     .async_dat_in1(idirectout_data_in_chain1), .iclkin_dist_in0(vssl),
     .iclkin_dist_in1(vssl), .idata0_in0(vssl), .idata0_in1(vssl),
     .idata1_in0(vssl), .idata1_in1(vssl), .idataselb_in0(vssl),
     .idataselb_in1(idataselb_in_chain1), .iddren_in0(vssl),
     .iddren_in1(vssl), .ilaunch_clk_in0(vssl), .ilaunch_clk_in1(vssl),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0({vssl, vssl}),
     .indrv_in1(indrv_r78[1:0]), .ipdrv_in0({vssl, vssl}),
     .ipdrv_in1(ipdrv_r78[1:0]), .irxen_in0(irxen_r2[2:0]),
     .irxen_in1({vssl, vcc, vssl}), .istrbclk_in0(vssl),
     .istrbclk_in1(vssl), .itxen_in0(vssl),
     .itxen_in1(itxen_in_chain1), .oclk_in1(vssl),
     .odat_async_aib(ncdrx_odat_async_aib2), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(vssl), .vccl(vccl), .odat1_in1(vssl),
     .odat_async_in1(odat_async_inpshared0),
     .shift_en(rshift_en_drx[2]), .pd_data_in1(vssl),
     .dig_rstb(input_rstb), .jtag_clkdr_out(jtag_clkdr_inpdir3_1),
     .vcc(vcc), .odat1_aib(ncdrx_odat1_aib[2]),
     .jtag_rx_scan_out(jtag_rx_scan_inpdir3_1),
     .odat0_aib(ncdrx_odat0_aib[2]), .oclk_aib(ncdrx_oclk_aib[2]),
     .last_bs_out(nc_last_bs_out_inpdir3_1),
     .por_aib_vccl(por_aib_vccl), .por_aib_vcchssi(por_aib_vcchssi),
     .oclkb_aib(ncdrx_oclkb_aib[2]), .jtag_clkdr_in(clkdr_xr7r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_scan_in_chain1),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_direct_input[2]), .oclkn(ncdrx_oclkn[2]),
     .iclkn(vssl), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xasynctx4 ( .idata1_in1_jtag_out(nc_idat1_oshared4),
     .idata0_in1_jtag_out(nc_idat0_oshared4),
     .async_dat_in1_jtag_out(async_dat_oshared4),
     .prev_io_shift_en(rshift_en_tx[0]),
     .jtag_clkdr_outn(jtag_clkdr_outn_oshared4),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .anlg_rstb(input_rstb),
     .pd_data_aib(nctx_pd_data_aib[4]), .oclk_out(nctx_oclk[4]),
     .oclkb_out(nctx_oclkb[4]), .odat0_out(nctx_odat0[4]),
     .odat1_out(nctx_odat1[4]), .odat_async_out(nctx_odat_async[4]),
     .pd_data_out(nctx_pd_data[4]), .async_dat_in0(iasyncdata[4]),
     .async_dat_in1(vssl), .iclkin_dist_in0(vssl),
     .iclkin_dist_in1(vssl), .idata0_in0(vssl), .idata0_in1(vssl),
     .idata1_in0(vssl), .idata1_in1(vssl),
     .idataselb_in0(idataselb[1]), .idataselb_in1(vssl),
     .iddren_in0(vssl), .iddren_in1(vssl), .ilaunch_clk_in0(vssl),
     .ilaunch_clk_in1(vssl), .ilpbk_dat_in0(vssl),
     .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl), .ilpbk_en_in1(vssl),
     .indrv_in0(indrv_r78[1:0]), .indrv_in1({vssl, vssl}),
     .ipdrv_in0(ipdrv_r78[1:0]), .ipdrv_in1({vssl, vssl}),
     .irxen_in0({vssl, vcc, vssl}), .irxen_in1(irxen_r3[2:0]),
     .istrbclk_in0(vssl), .istrbclk_in1(vssl), .itxen_in0(itxen[2]),
     .itxen_in1(vssl), .oclk_in1(vssl),
     .odat_async_aib(tx_odat_async_aib4), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(vssl), .vccl(vccl), .odat1_in1(vssl),
     .odat_async_in1(vssl), .shift_en(rshift_en_tx[2]),
     .pd_data_in1(vssl), .dig_rstb(input_rstb),
     .jtag_clkdr_out(jtag_clkdr_oshared4), .vcc(vcc),
     .odat1_aib(nctx_odat1_aib[4]),
     .jtag_rx_scan_out(jtag_rx_scan_oshared4),
     .odat0_aib(nctx_odat0_aib[4]), .oclk_aib(nctx_oclk_aib[4]),
     .last_bs_out(nc_last_bs_out_diro4), .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .oclkb_aib(nctx_oclkb_aib[4]),
     .jtag_clkdr_in(clkdr_xr7r), .jtag_mode_in(jtag_mode_in),
     .jtag_rstb(jtag_rstb), .jtag_tx_scan_in(jtag_rx_scan_inpshared0),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_async_out[4]), .oclkn(nctx_oclkn[4]), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xasyncrx0 ( .idata1_in1_jtag_out(nc_idat1_inpshared0),
     .idata0_in1_jtag_out(nc_idat0_inpshared0),
     .async_dat_in1_jtag_out(nc_async_dat_inpshared0),
     .prev_io_shift_en(rshift_en_drx[2]),
     .jtag_clkdr_outn(jtag_clkdr_outn_inpshared0),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .anlg_rstb(input_rstb),
     .pd_data_aib(ncrx_pd_data_aib[0]), .oclk_out(ncrx_oclk[0]),
     .oclkb_out(ncrx_oclkb[0]), .odat0_out(ncrx_odat0[0]),
     .odat1_out(ncrx_odat1[0]), .odat_async_out(odat_async[0]),
     .pd_data_out(ncrx_pd_data[0]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(vssl),
     .iclkin_dist_in1(vssl), .idata0_in0(vssl), .idata0_in1(vssl),
     .idata1_in0(vssl), .idata1_in1(vssl), .idataselb_in0(vssl),
     .idataselb_in1(vssl), .iddren_in0(vssl), .iddren_in1(vssl),
     .ilaunch_clk_in0(vssl), .ilaunch_clk_in1(vssl),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0({vssl, vssl}), .indrv_in1({vssl,
     vssl}), .ipdrv_in0({vssl, vssl}), .ipdrv_in1({vssl, vssl}),
     .irxen_in0(irxen_r3[2:0]), .irxen_in1(irxen_r2[2:0]),
     .istrbclk_in0(vssl), .istrbclk_in1(vssl), .itxen_in0(vssl),
     .itxen_in1(vssl), .oclk_in1(vssl),
     .odat_async_aib(odat_async_inpshared0), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(vssl), .vccl(vccl), .odat1_in1(vssl),
     .odat_async_in1(tx_odat_async_aib4), .shift_en(rshift_en_tx[0]),
     .pd_data_in1(vssl), .dig_rstb(input_rstb),
     .jtag_clkdr_out(jtag_clkdr_inpshared0), .vcc(vcc),
     .odat1_aib(ncrx_odat1_aib[0]),
     .jtag_rx_scan_out(jtag_rx_scan_inpshared0),
     .odat0_aib(ncrx_odat0_aib[0]), .oclk_aib(ncrx_oclk_aib[0]),
     .last_bs_out(nc_last_bs_out_diro0), .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .oclkb_aib(ncrx_oclkb_aib[0]),
     .jtag_clkdr_in(clkdr_xr7r), .jtag_mode_in(jtag_mode_in),
     .jtag_rstb(jtag_rstb), .jtag_tx_scan_in(jtag_rx_scan_inpdir3_1),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_async_in[0]), .oclkn(ncrx_oclkn[0]), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top x455 ( .idata1_in1_jtag_out(nc_idat1_pinp9),
     .idata0_in1_jtag_out(nc_idat0_pinp9),
     .async_dat_in1_jtag_out(nc_async_dat_pinp9),
     .prev_io_shift_en(rshift_en_pinp[7]),
     .jtag_clkdr_outn(jtag_clkdr_outn_pinp9),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .vcc(vcc), .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(input_rstb),
     .pd_data_aib(nc_pd_data_aib_pin[9]), .oclk_out(nc_oclk[9]),
     .oclkb_out(nc_oclkb[9]), .odat0_out(pcs_data_out0_int[9]),
     .odat1_out(pcs_data_out1_int[9]), .odat_async_out(nc_odat_async[9]),
     .pd_data_out(nc_pd_data[9]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(rx_distclk_r[4]),
     .iclkin_dist_in1(rx_distclk_r[4]), .idata0_in0(vssl),
     .idata0_in1(vssl), .idata1_in0(vssl), .idata1_in1(vssl),
     .idataselb_in0(vcc), .idataselb_in1(vssl), .iddren_in0(vcc),
     .iddren_in1(vssl), .ilaunch_clk_in0(vssl), .ilaunch_clk_in1(vssl),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0({vssl, vssl}), .indrv_in1({vssl,
     vssl}), .ipdrv_in0({vssl, vssl}), .ipdrv_in1({vssl, vssl}),
     .irxen_in0(irxen_r0[2:0]), .irxen_in1(irxen_r0[2:0]),
     .istrbclk_in0(rx_strbclk_r[4]), .istrbclk_in1(rx_strbclk_r[4]),
     .itxen_in0(vssl), .itxen_in1(vssl), .oclk_in1(vssl),
     .odat_async_aib(nc_odat_async_aib_pin[9]), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(odat0_aib_txferclkoutn), .vccl(vccl),
     .odat1_in1(odat1_aib_txferclkoutn), .odat_async_in1(vssl),
     .shift_en(rshift_en_pinp[9]), .pd_data_in1(vssl),
     .dig_rstb(pinp_dig_rstb), .jtag_clkdr_out(jtag_clkdr_pinp9),
     .odat1_aib(odat1_aib_pin[9]),
     .jtag_rx_scan_out(jtag_rx_scan_pinp9),
     .odat0_aib(odat0_aib_pin[9]), .oclk_aib(nc_oclk_aib_pin[9]),
     .last_bs_out(nc_last_bs_out_pinp9),
     .oclkb_aib(nc_oclkb_aib_pin[9]), .jtag_clkdr_in(clkdr_xr4r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_pinp7),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_dat[9]), .oclkn(nc_oclkn_pin[9]), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top x454 ( .idata1_in1_jtag_out(idat1_in1_clkn),
     .idata0_in1_jtag_out(idat0_in1_clkn),
     .async_dat_in1_jtag_out(nc_async_dat_clkn),
     .prev_io_shift_en(rshift_en_pinp[9]),
     .jtag_clkdr_outn(jtag_clkdr_outn_clkn),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .vcc(vcc), .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(input_rstb),
     .pd_data_aib(nc_pd_data_aib_txferclkoutn),
     .oclk_out(nc_oclk_clkn), .oclkb_out(nc_oclkb_clkn),
     .odat0_out(nc_odat0_clkn), .odat1_out(nc_odat1_clkn),
     .odat_async_out(nc_odat_async_clkn),
     .pd_data_out(nc_pd_data_clkn), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(rx_distclk_r[8]),
     .iclkin_dist_in1(rx_distclk_r[8]), .idata0_in0(vcc),
     .idata0_in1(vssl), .idata1_in0(vssl), .idata1_in1(vssl),
     .idataselb_in0(vcc), .idataselb_in1(vssl), .iddren_in0(vcc),
     .iddren_in1(vssl), .ilaunch_clk_in0(dft_tx_clk),
     .ilaunch_clk_in1(vssl), .ilpbk_dat_in0(vssl),
     .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl), .ilpbk_en_in1(vssl),
     .indrv_in0({vssl, vssl}), .indrv_in1({vssl, vssl}),
     .ipdrv_in0({vssl, vssl}), .ipdrv_in1({vssl, vssl}),
     .irxen_in0({vssl, vcc, vssl}), .irxen_in1(irxen_r0[2:0]),
     .istrbclk_in0(rx_strbclk_r[8]), .istrbclk_in1(rx_strbclk_r[8]),
     .itxen_in0(csr_reg_str[6]), .itxen_in1(vssl), .oclk_in1(vssl),
     .odat_async_aib(nc_odat_async_aib_txferclkoutn), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(vssl), .vccl(vccl), .odat1_in1(vssl),
     .odat_async_in1(vssl), .shift_en(rshift_en_txferclkoutn),
     .pd_data_in1(vssl), .dig_rstb(pinp_dig_rstb),
     .jtag_clkdr_out(jtag_clkdr_clkn),
     .odat1_aib(odat1_aib_txferclkoutn),
     .jtag_rx_scan_out(jtag_rx_scan_clkn),
     .odat0_aib(odat0_aib_txferclkoutn),
     .oclk_aib(nc_oclk_aib_txferclkoutn),
     .last_bs_out(nc_last_bs_out_txferclkoutn),
     .oclkb_aib(nc_oclkb_aib_txferclkoutn), .jtag_clkdr_in(clkdr_xr4r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_pinp9),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_clkn), .oclkn(oclkn_txferclkoutn), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top x446 ( .idata1_in1_jtag_out(nc_idat1_pinp5),
     .idata0_in1_jtag_out(nc_idat0_pinp5),
     .async_dat_in1_jtag_out(nc_async_dat_pinp5),
     .prev_io_shift_en(rshift_en_pinp[3]),
     .jtag_clkdr_outn(jtag_clkdr_outn_pinp5),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .vcc(vcc), .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(input_rstb),
     .pd_data_aib(nc_pd_data_aib_pin[5]), .oclk_out(nc_oclk[5]),
     .oclkb_out(nc_oclkb[5]), .odat0_out(pcs_data_out0_int[5]),
     .odat1_out(pcs_data_out1_int[5]), .odat_async_out(nc_odat_async[5]),
     .pd_data_out(nc_pd_data[5]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(rx_distclk_r[2]),
     .iclkin_dist_in1(rx_distclk_r[2]), .idata0_in0(vssl),
     .idata0_in1(vssl), .idata1_in0(vssl), .idata1_in1(vssl),
     .idataselb_in0(vcc), .idataselb_in1(vssl), .iddren_in0(vcc),
     .iddren_in1(vssl), .ilaunch_clk_in0(vssl), .ilaunch_clk_in1(vssl),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0({vssl, vssl}), .indrv_in1({vssl,
     vssl}), .ipdrv_in0({vssl, vssl}), .ipdrv_in1({vssl, vssl}),
     .irxen_in0(irxen_r0[2:0]), .irxen_in1(irxen_r0[2:0]),
     .istrbclk_in0(rx_strbclk_r[2]), .istrbclk_in1(rx_strbclk_r[2]),
     .itxen_in0(vssl), .itxen_in1(vssl), .oclk_in1(vssl),
     .odat_async_aib(nc_odat_async_aib_pin[5]), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(odat0_aib_pin[7]), .vccl(vccl),
     .odat1_in1(odat1_aib_pin[7]), .odat_async_in1(vssl),
     .shift_en(rshift_en_pinp[5]), .pd_data_in1(vssl),
     .dig_rstb(pinp_dig_rstb), .jtag_clkdr_out(jtag_clkdr_pinp5),
     .odat1_aib(odat1_aib_pin[5]),
     .jtag_rx_scan_out(jtag_rx_scan_pinp5),
     .odat0_aib(odat0_aib_pin[5]), .oclk_aib(nc_oclk_aib_pin[5]),
     .last_bs_out(nc_last_bs_out_pinp5),
     .oclkb_aib(nc_oclkb_aib_pin[5]), .jtag_clkdr_in(clkdr_xr4r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_pinp3),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_dat[5]), .oclkn(nc_oclkn_pin[5]), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top x438 ( .idata1_in1_jtag_out(nc_idat1_pinp3),
     .idata0_in1_jtag_out(nc_idat0_pinp3),
     .async_dat_in1_jtag_out(nc_async_dat_pinp3),
     .prev_io_shift_en(rshift_en_pinp[1]),
     .jtag_clkdr_outn(jtag_clkdr_outn_pinp3),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .vcc(vcc), .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(input_rstb),
     .pd_data_aib(nc_pd_data_aib_pin[3]), .oclk_out(nc_oclk[3]),
     .oclkb_out(nc_oclkb[3]), .odat0_out(pcs_data_out0_int[3]),
     .odat1_out(pcs_data_out1_int[3]), .odat_async_out(nc_odat_async[3]),
     .pd_data_out(nc_pd_data[3]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(rx_distclk_r[6]),
     .iclkin_dist_in1(rx_distclk_r[6]), .idata0_in0(vssl),
     .idata0_in1(vssl), .idata1_in0(vssl), .idata1_in1(vssl),
     .idataselb_in0(vcc), .idataselb_in1(vssl), .iddren_in0(vcc),
     .iddren_in1(vssl), .ilaunch_clk_in0(vssl), .ilaunch_clk_in1(vssl),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0({vssl, vssl}), .indrv_in1({vssl,
     vssl}), .ipdrv_in0({vssl, vssl}), .ipdrv_in1({vssl, vssl}),
     .irxen_in0(irxen_r0[2:0]), .irxen_in1(irxen_r0[2:0]),
     .istrbclk_in0(rx_strbclk_r[6]), .istrbclk_in1(rx_strbclk_r[6]),
     .itxen_in0(vssl), .itxen_in1(vssl), .oclk_in1(vssl),
     .odat_async_aib(nc_odat_async_aib_pin[3]), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(odat0_aib_pin[5]), .vccl(vccl),
     .odat1_in1(odat1_aib_pin[5]), .odat_async_in1(vssl),
     .shift_en(rshift_en_pinp[3]), .pd_data_in1(vssl),
     .dig_rstb(pinp_dig_rstb), .jtag_clkdr_out(jtag_clkdr_pinp3),
     .odat1_aib(odat1_aib_pin[3]),
     .jtag_rx_scan_out(jtag_rx_scan_pinp3),
     .odat0_aib(odat0_aib_pin[3]), .oclk_aib(nc_oclk_aib_pin[3]),
     .last_bs_out(nc_last_bs_out_pinp3),
     .oclkb_aib(nc_oclkb_aib_pin[3]), .jtag_clkdr_in(clkdr_xr4r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_pinp1),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_dat[3]), .oclkn(nc_oclkn_pin[3]), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top x430 ( .idata1_in1_jtag_out(nc_idat1_pinp1),
     .idata0_in1_jtag_out(nc_idat0_pinp1),
     .async_dat_in1_jtag_out(nc_async_dat_pinp1),
     .prev_io_shift_en(rshift_en_drx[1]),
     .jtag_clkdr_outn(jtag_clkdr_outn_pinp1),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .vcc(vcc), .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(input_rstb),
     .pd_data_aib(nc_pd_data_aib_pin[1]), .oclk_out(nc_oclk[1]),
     .oclkb_out(nc_oclkb[1]), .odat0_out(pcs_data_out0_int[1]),
     .odat1_out(pcs_data_out1_int[1]), .odat_async_out(nc_odat_async[1]),
     .pd_data_out(nc_pd_data[1]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(rx_distclk_r[10]),
     .iclkin_dist_in1(vssl), .idata0_in0(vssl), .idata0_in1(vssl),
     .idata1_in0(vssl), .idata1_in1(vssl), .idataselb_in0(vcc),
     .idataselb_in1(vssl), .iddren_in0(vcc), .iddren_in1(vssl),
     .ilaunch_clk_in0(vssl), .ilaunch_clk_in1(vssl),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0({vssl, vssl}), .indrv_in1({vssl,
     vssl}), .ipdrv_in0({vssl, vssl}), .ipdrv_in1({vssl, vssl}),
     .irxen_in0(irxen_r0[2:0]), .irxen_in1(irxen_r2[2:0]),
     .istrbclk_in0(rx_strbclk_r[10]), .istrbclk_in1(vssl),
     .itxen_in0(vssl), .itxen_in1(vssl), .oclk_in1(vssl),
     .odat_async_aib(odat_async_aib_pin1), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(odat0_aib_pin[3]), .vccl(vccl),
     .odat1_in1(odat1_aib_pin[3]), .odat_async_in1(vssl),
     .shift_en(rshift_en_pinp[1]), .pd_data_in1(vssl),
     .dig_rstb(pinp_dig_rstb), .jtag_clkdr_out(jtag_clkdr_pinp1),
     .odat1_aib(odat1_aib_pin[1]),
     .jtag_rx_scan_out(jtag_rx_scan_pinp1),
     .odat0_aib(odat0_aib_pin[1]), .oclk_aib(nc_oclk_aib_pin[1]),
     .last_bs_out(nc_last_bs_out_pinp1),
     .oclkb_aib(nc_oclkb_aib_pin[1]), .jtag_clkdr_in(clkdr_xr4r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(SCAN_IN_SEG3),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_dat[1]), .oclkn(nc_oclkn_pin[1]), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top x429 ( .idata1_in1_jtag_out(nc_idat1_pinp7),
     .idata0_in1_jtag_out(nc_idat0_pinp7),
     .async_dat_in1_jtag_out(nc_async_dat_pinp7),
     .prev_io_shift_en(rshift_en_pinp[5]),
     .jtag_clkdr_outn(jtag_clkdr_outn_pinp7),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .vcc(vcc), .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(input_rstb),
     .pd_data_aib(nc_pd_data_aib_pin[7]), .oclk_out(nc_oclk[7]),
     .oclkb_out(nc_oclkb[7]), .odat0_out(pcs_data_out0_int[7]),
     .odat1_out(pcs_data_out1_int[7]), .odat_async_out(nc_odat_async[7]),
     .pd_data_out(nc_pd_data[7]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(rx_distclk_r[0]),
     .iclkin_dist_in1(rx_distclk_r[0]), .idata0_in0(vssl),
     .idata0_in1(vssl), .idata1_in0(vssl), .idata1_in1(vssl),
     .idataselb_in0(vcc), .idataselb_in1(vssl), .iddren_in0(vcc),
     .iddren_in1(vssl), .ilaunch_clk_in0(vssl), .ilaunch_clk_in1(vssl),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0({vssl, vssl}), .indrv_in1({vssl,
     vssl}), .ipdrv_in0({vssl, vssl}), .ipdrv_in1({vssl, vssl}),
     .irxen_in0(irxen_r0[2:0]), .irxen_in1(irxen_r0[2:0]),
     .istrbclk_in0(rx_strbclk_r[0]), .istrbclk_in1(rx_strbclk_r[0]),
     .itxen_in0(vssl), .itxen_in1(vssl), .oclk_in1(vssl),
     .odat_async_aib(nc_odat_async_aib_pin[7]), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(odat0_aib_pin[9]), .vccl(vccl),
     .odat1_in1(odat1_aib_pin[9]), .odat_async_in1(vssl),
     .shift_en(rshift_en_pinp[7]), .pd_data_in1(vssl),
     .dig_rstb(pinp_dig_rstb), .jtag_clkdr_out(jtag_clkdr_pinp7),
     .odat1_aib(odat1_aib_pin[7]),
     .jtag_rx_scan_out(jtag_rx_scan_pinp7),
     .odat0_aib(odat0_aib_pin[7]), .oclk_aib(nc_oclk_aib_pin[7]),
     .last_bs_out(nc_last_bs_out_pinp7),
     .oclkb_aib(nc_oclkb_aib_pin[7]), .jtag_clkdr_in(clkdr_xr4r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_pinp5),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_dat[7]), .oclkn(nc_oclkn_pin[7]), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xpinp2 ( .idata1_in1_jtag_out(nc_idat1_pinp2),
     .idata0_in1_jtag_out(nc_idat0_pinp2),
     .async_dat_in1_jtag_out(nc_async_dat_pinp2),
     .prev_io_shift_en(rshift_en_pinp[0]),
     .jtag_clkdr_outn(jtag_clkdr_outn_pinp2),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .vcc(vcc), .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(input_rstb),
     .pd_data_aib(nc_pd_data_aib_pin[2]), .oclk_out(nc_oclk[2]),
     .oclkb_out(nc_oclkb[2]), .odat0_out(pcs_data_out0_int[2]),
     .odat1_out(pcs_data_out1_int[2]), .odat_async_out(nc_odat_async[2]),
     .pd_data_out(nc_pd_data[2]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(rx_distclk_r[7]),
     .iclkin_dist_in1(rx_distclk_r[7]), .idata0_in0(vssl),
     .idata0_in1(vssl), .idata1_in0(vssl), .idata1_in1(vssl),
     .idataselb_in0(vcc), .idataselb_in1(vssl), .iddren_in0(vcc),
     .iddren_in1(vssl), .ilaunch_clk_in0(vssl), .ilaunch_clk_in1(vssl),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0({vssl, vssl}), .indrv_in1({vssl,
     vssl}), .ipdrv_in0({vssl, vssl}), .ipdrv_in1({vssl, vssl}),
     .irxen_in0(irxen_r0[2:0]), .irxen_in1(irxen_r0[2:0]),
     .istrbclk_in0(rx_strbclk_r[7]), .istrbclk_in1(rx_strbclk_r[7]),
     .itxen_in0(vssl), .itxen_in1(vssl), .oclk_in1(vssl),
     .odat_async_aib(nc_odat_async_aib_pin[2]), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(odat0_aib_pin[4]), .vccl(vccl),
     .odat1_in1(odat1_aib_pin[4]), .odat_async_in1(vssl),
     .shift_en(rshift_en_pinp[2]), .pd_data_in1(vssl),
     .dig_rstb(pinp_dig_rstb), .jtag_clkdr_out(jtag_clkdr_pinp2),
     .odat1_aib(odat1_aib_pin[2]),
     .jtag_rx_scan_out(jtag_rx_scan_pinp2),
     .odat0_aib(odat0_aib_pin[2]), .oclk_aib(nc_oclk_aib_pin[2]),
     .last_bs_out(nc_last_bs_out_pinp2),
     .oclkb_aib(nc_oclkb_aib_pin[2]), .jtag_clkdr_in(clkdr_xr3r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_pinp0),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_dat[2]), .oclkn(nc_oclkn_pin[2]), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xpinp0 ( .idata1_in1_jtag_out(nc_idat1_pinp0),
     .idata0_in1_jtag_out(nc_idat0_pinp0),
     .async_dat_in1_jtag_out(nc_async_dat_pinp0),
     .prev_io_shift_en(shift_en_outpdir2),
     .jtag_clkdr_outn(jtag_clkdr_outn_pinp0),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .vcc(vcc), .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(input_rstb),
     .pd_data_aib(nc_pd_data_aib_pin[0]), .oclk_out(nc_oclk[0]),
     .oclkb_out(nc_oclkb[0]), .odat0_out(pcs_data_out0_int[0]),
     .odat1_out(pcs_data_out1_int[0]), .odat_async_out(nc_odat_async[0]),
     .pd_data_out(nc_pd_data[0]), .async_dat_in0(vssl),
     .async_dat_in1(async_dat_outpdir2),
     .iclkin_dist_in0(rx_distclk_r[11]), .iclkin_dist_in1(vssl),
     .idata0_in0(vssl), .idata0_in1(vssl), .idata1_in0(vssl),
     .idata1_in1(vssl), .idataselb_in0(vcc),
     .idataselb_in1(idataselb_outpdir2), .iddren_in0(vcc),
     .iddren_in1(vssl), .ilaunch_clk_in0(vssl), .ilaunch_clk_in1(vssl),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0({vssl, vssl}),
     .indrv_in1(indrv_r34[1:0]), .ipdrv_in0({vssl, vssl}),
     .ipdrv_in1(ipdrv_r34[1:0]), .irxen_in0(irxen_r0[2:0]),
     .irxen_in1({vssl, vcc, vssl}), .istrbclk_in0(rx_strbclk_r[11]),
     .istrbclk_in1(vssl), .itxen_in0(vssl), .itxen_in1(itxen_outpdir2),
     .oclk_in1(vssl), .odat_async_aib(nc_odat_async_aib_pin0),
     .oclkb_in1(vssl), .vssl(vssl), .odat0_in1(odat0_aib_pin[2]),
     .vccl(vccl), .odat1_in1(odat1_aib_pin[2]), .odat_async_in1(vssl),
     .shift_en(rshift_en_pinp[0]), .pd_data_in1(vssl),
     .dig_rstb(pinp_dig_rstb), .jtag_clkdr_out(jtag_clkdr_pinp0),
     .odat1_aib(odat1_aib_pin[0]),
     .jtag_rx_scan_out(jtag_rx_scan_pinp0),
     .odat0_aib(odat0_aib_pin[0]), .oclk_aib(nc_oclk_aib_pin[0]),
     .last_bs_out(nc_last_bs_out_pinp0),
     .oclkb_aib(nc_oclkb_aib_pin[0]), .jtag_clkdr_in(clkdr_xr3r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_outpdir2),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_dat[0]), .oclkn(nc_oclkn_pin[0]), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xpinp4 ( .idata1_in1_jtag_out(nc_idat1_pinp4),
     .idata0_in1_jtag_out(nc_idat0_pinp4),
     .async_dat_in1_jtag_out(nc_async_dat_pinp4),
     .prev_io_shift_en(rshift_en_pinp[2]),
     .jtag_clkdr_outn(jtag_clkdr_outn_pinp4),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .vcc(vcc), .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(input_rstb),
     .pd_data_aib(nc_pd_data_aib_pin[4]), .oclk_out(nc_oclk[4]),
     .oclkb_out(nc_oclkb[4]), .odat0_out(pcs_data_out0_int[4]),
     .odat1_out(pcs_data_out1_int[4]), .odat_async_out(nc_odat_async[4]),
     .pd_data_out(nc_pd_data[4]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(rx_distclk_r[3]),
     .iclkin_dist_in1(rx_distclk_r[3]), .idata0_in0(vssl),
     .idata0_in1(vssl), .idata1_in0(vssl), .idata1_in1(vssl),
     .idataselb_in0(vcc), .idataselb_in1(vssl), .iddren_in0(vcc),
     .iddren_in1(vssl), .ilaunch_clk_in0(vssl), .ilaunch_clk_in1(vssl),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0({vssl, vssl}), .indrv_in1({vssl,
     vssl}), .ipdrv_in0({vssl, vssl}), .ipdrv_in1({vssl, vssl}),
     .irxen_in0(irxen_r0[2:0]), .irxen_in1(irxen_r0[2:0]),
     .istrbclk_in0(rx_strbclk_r[3]), .istrbclk_in1(rx_strbclk_r[3]),
     .itxen_in0(vssl), .itxen_in1(vssl), .oclk_in1(vssl),
     .odat_async_aib(nc_odat_async_aib_pin[4]), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(odat0_aib_pin[6]), .vccl(vccl),
     .odat1_in1(odat1_aib_pin[6]), .odat_async_in1(vssl),
     .shift_en(rshift_en_pinp[4]), .pd_data_in1(vssl),
     .dig_rstb(pinp_dig_rstb), .jtag_clkdr_out(jtag_clkdr_pinp4),
     .odat1_aib(odat1_aib_pin[4]),
     .jtag_rx_scan_out(jtag_rx_scan_pinp4),
     .odat0_aib(odat0_aib_pin[4]), .oclk_aib(nc_oclk_aib_pin[4]),
     .last_bs_out(nc_last_bs_out_pinp4),
     .oclkb_aib(nc_oclkb_aib_pin[4]), .jtag_clkdr_in(clkdr_xr3r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_pinp2),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_dat[4]), .oclkn(nc_oclkn_pin[4]), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xasynctx2 ( .idata1_in1_jtag_out(idat1_oshared2),
     .idata0_in1_jtag_out(idat0_oshared2),
     .async_dat_in1_jtag_out(nc_async_dat_oshared2),
     .prev_io_shift_en(shift_en_ssrdin),
     .jtag_clkdr_outn(jtag_clkdr_outn_oshared2),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .anlg_rstb(input_rstb),
     .pd_data_aib(nctx_pd_data_aib[2]), .oclk_out(nctx_oclk[2]),
     .oclkb_out(nctx_oclkb[2]), .odat0_out(nctx_odat0[2]),
     .odat1_out(nctx_odat1[2]), .odat_async_out(nctx_odat_async[2]),
     .pd_data_out(nctx_pd_data[2]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(iclkin_dist_ssrdin),
     .iclkin_dist_in1(iclkin_dist_ssrdin), .idata0_in0(vssl),
     .idata0_in1(vssl), .idata1_in0(vcc), .idata1_in1(vssl),
     .idataselb_in0(idataselb[2]), .idataselb_in1(vssl),
     .iddren_in0(vcc), .iddren_in1(vssl),
     .ilaunch_clk_in0(iasyncdata[2]), .ilaunch_clk_in1(vssl),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0(indrv_r56[1:0]), .indrv_in1({vssl,
     vssl}), .ipdrv_in0(ipdrv_r56[1:0]), .ipdrv_in1({vssl, vssl}),
     .irxen_in0({vssl, vcc, vssl}), .irxen_in1(irxen_ssrdin[2:0]),
     .istrbclk_in0(istrbclk_ssrdin), .istrbclk_in1(istrbclk_ssrdin),
     .itxen_in0(itxen[2]), .itxen_in1(vssl), .oclk_in1(vssl),
     .odat_async_aib(nctx_odat_async_aib2), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(vssl), .vccl(vccl), .odat1_in1(vssl),
     .odat_async_in1(vssl), .shift_en(rshift_en_rx[2]),
     .pd_data_in1(vssl), .dig_rstb(input_rstb),
     .jtag_clkdr_out(jtag_clkdr_oshared2), .vcc(vcc),
     .odat1_aib(odat1_oshared2),
     .jtag_rx_scan_out(jtag_rx_scan_oshared2),
     .odat0_aib(odat0_oshared2), .oclk_aib(nctx_oclk_aib[2]),
     .last_bs_out(nc_last_bs_out_oshared2),
     .por_aib_vccl(por_aib_vccl), .por_aib_vcchssi(por_aib_vcchssi),
     .oclkb_aib(nctx_oclkb_aib[2]), .jtag_clkdr_in(clkdr_xr5r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_ssrdin),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_async_out[2]), .oclkn(nctx_oclkn2), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xpinp11 ( .idata1_in1_jtag_out(nc_idat1_pinp11),
     .idata0_in1_jtag_out(nc_idat0_pinp11),
     .async_dat_in1_jtag_out(nc_async_dat_pinp11),
     .prev_io_shift_en(rshift_en_txferclkoutn),
     .jtag_clkdr_outn(jtag_clkdr_outn_pinp11),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .vcc(vcc), .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(input_rstb),
     .pd_data_aib(nc_pd_data_aib_pin[11]), .oclk_out(nc_oclk[11]),
     .oclkb_out(nc_oclkb[11]), .odat0_out(pcs_data_out0_int[11]),
     .odat1_out(pcs_data_out1_int[11]), .odat_async_out(nc_odat_async[11]),
     .pd_data_out(nc_pd_data[11]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(rx_distclk_l[10]),
     .iclkin_dist_in1(vssl), .idata0_in0(vssl),
     .idata0_in1(idat0_in1_clkn), .idata1_in0(vssl),
     .idata1_in1(idat1_in1_clkn), .idataselb_in0(vcc),
     .idataselb_in1(vcc), .iddren_in0(vcc), .iddren_in1(vcc),
     .ilaunch_clk_in0(vssl), .ilaunch_clk_in1(dft_tx_clk),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0({vssl, vssl}), .indrv_in1({vssl,
     vssl}), .ipdrv_in0({vssl, vssl}), .ipdrv_in1({vssl, vssl}),
     .irxen_in0(irxen_r0[2:0]), .irxen_in1({vssl, vcc, vssl}),
     .istrbclk_in0(rx_strbclk_l[10]), .istrbclk_in1(vssl),
     .itxen_in0(vssl), .itxen_in1(csr_reg_str[6]), .oclk_in1(vssl),
     .odat_async_aib(nc_odat_async_aib_pin[11]), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(odat0_aib_pin[13]), .vccl(vccl),
     .odat1_in1(odat1_aib_pin[13]), .odat_async_in1(vssl),
     .shift_en(rshift_en_pinp[11]), .pd_data_in1(vssl),
     .dig_rstb(pinp_dig_rstb), .jtag_clkdr_out(jtag_clkdr_pinp11),
     .odat1_aib(odat1_aib_pin[11]),
     .jtag_rx_scan_out(jtag_rx_scan_pinp11),
     .odat0_aib(odat0_aib_pin[11]), .oclk_aib(nc_oclk_aib_pin[11]),
     .last_bs_out(nc_last_bs_out_pinp11),
     .oclkb_aib(nc_oclkb_aib_pin[11]), .jtag_clkdr_in(clkdr_xr4l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_clkn),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_dat[11]), .oclkn(oclkn_pin11), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xdirect_in4_1 (
     .idata1_in1_jtag_out(nc_idat1_inpdir4_1),
     .idata0_in1_jtag_out(nc_idat0_inpdir4_1),
     .async_dat_in1_jtag_out(nc_async_dat_inpdir4_1),
     .prev_io_shift_en(rshift_en_rx[1]),
     .jtag_clkdr_outn(jtag_clkdr_outn_inpdir4_1),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .anlg_rstb(input_rstb),
     .pd_data_aib(ncdrx_pd_data_aib[1]), .oclk_out(ncdrx_oclk[1]),
     .oclkb_out(ncdrx_oclkb[1]), .odat0_out(ncdrx_odat0[1]),
     .odat1_out(ncdrx_odat1[1]), .odat_async_out(odirectin_data[1]),
     .pd_data_out(ncdrx_pd_data[1]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(vssl),
     .iclkin_dist_in1(vssl), .idata0_in0(vssl),
     .idata0_in1(idat0_oshared1), .idata1_in0(vssl),
     .idata1_in1(idat1_oshared1), .idataselb_in0(vssl),
     .idataselb_in1(idataselb[2]), .iddren_in0(vssl), .iddren_in1(vcc),
     .ilaunch_clk_in0(vssl), .ilaunch_clk_in1(iasyncdata[0]),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0({vssl, vssl}),
     .indrv_in1(indrv_r56[1:0]), .ipdrv_in0({vssl, vssl}),
     .ipdrv_in1(ipdrv_r56[1:0]), .irxen_in0(irxen_r2[2:0]),
     .irxen_in1({vssl, vcc, vssl}), .istrbclk_in0(vssl),
     .istrbclk_in1(vssl), .itxen_in0(vssl), .itxen_in1(itxen[2]),
     .oclk_in1(vssl), .odat_async_aib(ncdrx_odatasync_aib1),
     .oclkb_in1(vssl), .vssl(vssl), .odat0_in1(vssl), .vccl(vccl),
     .odat1_in1(vssl), .odat_async_in1(odat_async_aib_pin1),
     .shift_en(rshift_en_drx[1]), .pd_data_in1(vssl),
     .dig_rstb(input_rstb), .jtag_clkdr_out(jtag_clkdr_inpdir4_1),
     .vcc(vcc), .odat1_aib(ncdrx_odat1_aib[1]),
     .jtag_rx_scan_out(SCAN_OUT_SEG2),
     .odat0_aib(ncdrx_odat0_aib[1]), .oclk_aib(ncdrx_oclk_aib[1]),
     .last_bs_out(nc_last_bs_out_indir4_1),
     .por_aib_vccl(por_aib_vccl), .por_aib_vcchssi(por_aib_vcchssi),
     .oclkb_aib(ncdrx_oclkb_aib[1]), .jtag_clkdr_in(clkdr_xr6r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_oshared1),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_direct_input[1]), .oclkn(ncdrx_oclkn[1]),
     .iclkn(vssl), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xpinp6 ( .idata1_in1_jtag_out(nc_idat1_pinp6),
     .idata0_in1_jtag_out(nc_idat0_pinp6),
     .async_dat_in1_jtag_out(nc_async_dat_pinp6),
     .prev_io_shift_en(rshift_en_pinp[4]),
     .jtag_clkdr_outn(jtag_clkdr_outn_pinp6),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .vcc(vcc), .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(input_rstb),
     .pd_data_aib(nc_pd_data_aib_pin[6]), .oclk_out(nc_oclk[6]),
     .oclkb_out(nc_oclkb[6]), .odat0_out(pcs_data_out0_int[6]),
     .odat1_out(pcs_data_out1_int[6]), .odat_async_out(nc_odat_async[6]),
     .pd_data_out(nc_pd_data[6]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(rx_distclk_r[1]),
     .iclkin_dist_in1(rx_distclk_r[1]), .idata0_in0(vssl),
     .idata0_in1(vssl), .idata1_in0(vssl), .idata1_in1(vssl),
     .idataselb_in0(vcc), .idataselb_in1(vssl), .iddren_in0(vcc),
     .iddren_in1(vssl), .ilaunch_clk_in0(vssl), .ilaunch_clk_in1(vssl),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0({vssl, vssl}), .indrv_in1({vssl,
     vssl}), .ipdrv_in0({vssl, vssl}), .ipdrv_in1({vssl, vssl}),
     .irxen_in0(irxen_r0[2:0]), .irxen_in1(irxen_r0[2:0]),
     .istrbclk_in0(rx_strbclk_r[1]), .istrbclk_in1(rx_strbclk_r[1]),
     .itxen_in0(vssl), .itxen_in1(vssl), .oclk_in1(vssl),
     .odat_async_aib(nc_odat_async_aib_pin[6]), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(odat0_aib_pin[8]), .vccl(vccl),
     .odat1_in1(odat1_aib_pin[8]), .odat_async_in1(vssl),
     .shift_en(rshift_en_pinp[6]), .pd_data_in1(vssl),
     .dig_rstb(pinp_dig_rstb), .jtag_clkdr_out(jtag_clkdr_pinp6),
     .odat1_aib(odat1_aib_pin[6]),
     .jtag_rx_scan_out(jtag_rx_scan_pinp6),
     .odat0_aib(odat0_aib_pin[6]), .oclk_aib(nc_oclk_aib_pin[6]),
     .last_bs_out(nc_last_bs_out_pinp6),
     .oclkb_aib(nc_oclkb_aib_pin[6]), .jtag_clkdr_in(clkdr_xr3r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_pinp4),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_dat[6]), .oclkn(nc_oclkn_pin[6]), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xpinp8 ( .idata1_in1_jtag_out(nc_idat1_pinp8),
     .idata0_in1_jtag_out(nc_idat0_pinp8),
     .async_dat_in1_jtag_out(nc_async_dat_pinp8),
     .prev_io_shift_en(rshift_en_pinp[6]),
     .jtag_clkdr_outn(jtag_clkdr_outn_pinp8),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .vcc(vcc), .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(input_rstb),
     .pd_data_aib(nc_pd_data_aib_pin[8]), .oclk_out(nc_oclk[8]),
     .oclkb_out(nc_oclkb[8]), .odat0_out(pcs_data_out0_int[8]),
     .odat1_out(pcs_data_out1_int[8]), .odat_async_out(nc_odat_async[8]),
     .pd_data_out(nc_pd_data[8]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(rx_distclk_r[5]),
     .iclkin_dist_in1(rx_distclk_r[5]), .idata0_in0(vssl),
     .idata0_in1(vssl), .idata1_in0(vssl), .idata1_in1(vssl),
     .idataselb_in0(vcc), .idataselb_in1(vssl), .iddren_in0(vcc),
     .iddren_in1(vssl), .ilaunch_clk_in0(vssl), .ilaunch_clk_in1(vssl),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0({vssl, vssl}), .indrv_in1({vssl,
     vssl}), .ipdrv_in0({vssl, vssl}), .ipdrv_in1({vssl, vssl}),
     .irxen_in0(irxen_r0[2:0]), .irxen_in1(irxen_r0[2:0]),
     .istrbclk_in0(rx_strbclk_r[5]), .istrbclk_in1(rx_strbclk_r[5]),
     .itxen_in0(vssl), .itxen_in1(vssl), .oclk_in1(vssl),
     .odat_async_aib(nc_odat_async_aib_pin[8]), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(odat0_aib_txferclkout), .vccl(vccl),
     .odat1_in1(odat1_aib_txferclkout), .odat_async_in1(vssl),
     .shift_en(rshift_en_pinp[8]), .pd_data_in1(vssl),
     .dig_rstb(pinp_dig_rstb), .jtag_clkdr_out(jtag_clkdr_pinp8),
     .odat1_aib(odat1_aib_pin[8]),
     .jtag_rx_scan_out(jtag_rx_scan_pinp8),
     .odat0_aib(odat0_aib_pin[8]), .oclk_aib(nc_oclk_aib_pin[8]),
     .last_bs_out(nc_last_bs_out_pinp8),
     .oclkb_aib(nc_oclkb_aib_pin[8]), .jtag_clkdr_in(clkdr_xr3r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_pinp6),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_dat[8]), .oclkn(nc_oclkn_pin[8]), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top x187 ( .idata1_in1_jtag_out(idat1_in1_clkp),
     .idata0_in1_jtag_out(idat0_in1_clkp),
     .async_dat_in1_jtag_out(nc_async_dat_clkp),
     .prev_io_shift_en(rshift_en_pinp[8]),
     .jtag_clkdr_outn(jtag_clkdr_outn_clkp),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .vcc(vcc), .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(input_rstb),
     .pd_data_aib(nc_pd_data_aib_txferclkout), .oclk_out(oclk_clkp_io),
     .oclkb_out(oclk_clkpb_io), .odat0_out(nc_odat0_clkp),
     .odat1_out(nc_odat1_clkp), .odat_async_out(nc_odat_async_clkp),
     .pd_data_out(nc_pd_data_clkp), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(rx_distclk_r[9]),
     .iclkin_dist_in1(rx_distclk_r[9]), .idata0_in0(vssl),
     .idata0_in1(vssl), .idata1_in0(vcc), .idata1_in1(vssl),
     .idataselb_in0(vcc), .idataselb_in1(vssl), .iddren_in0(vcc),
     .iddren_in1(vssl), .ilaunch_clk_in0(dft_tx_clk),
     .ilaunch_clk_in1(vssl), .ilpbk_dat_in0(vssl),
     .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl), .ilpbk_en_in1(vssl),
     .indrv_in0({vssl, vssl}), .indrv_in1({vssl, vssl}),
     .ipdrv_in0({vssl, vssl}), .ipdrv_in1({vssl, vssl}),
     .irxen_in0(irxen_r1[2:0]), .irxen_in1(irxen_r0[2:0]),
     .istrbclk_in0(rx_strbclk_r[9]), .istrbclk_in1(rx_strbclk_r[9]),
     .itxen_in0(csr_reg_str[6]), .itxen_in1(vssl),
     .oclk_in1(oclk_clkp_buf),
     .odat_async_aib(nc_odat_async_aib_txferclkout),
     .oclkb_in1(oclk_clkpb_buf), .vssl(vssl), .odat0_in1(vssl),
     .vccl(vccl), .odat1_in1(vssl), .odat_async_in1(vssl),
     .shift_en(rshift_en_txferclkout), .pd_data_in1(vssl),
     .dig_rstb(pinp_dig_rstb), .jtag_clkdr_out(jtag_clkdr_clkp),
     .odat1_aib(odat1_aib_txferclkout),
     .jtag_rx_scan_out(jtag_rx_scan_clkp),
     .odat0_aib(odat0_aib_txferclkout),
     .oclk_aib(oclk_aib_txferclkout),
     .last_bs_out(nc_last_bs_out_txferclkout),
     .oclkb_aib(oclkb_aib_txferclkout), .jtag_clkdr_in(clkdr_xr3r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_pinp8),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_clkp), .oclkn(nc_oclkn_txferclkout),
     .iclkn(oclkn_txferclkoutn), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xpinp10 ( .idata1_in1_jtag_out(nc_idat1_pinp10),
     .idata0_in1_jtag_out(nc_idat0_pinp10),
     .async_dat_in1_jtag_out(nc_async_dat_pinp10),
     .prev_io_shift_en(rshift_en_txferclkout),
     .jtag_clkdr_outn(jtag_clkdr_outn_pinp10),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .vcc(vcc), .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(input_rstb),
     .pd_data_aib(nc_pd_data_aib_pin[10]), .oclk_out(nc_oclk[10]),
     .oclkb_out(nc_oclkb[10]), .odat0_out(pcs_data_out0_int[10]),
     .odat1_out(pcs_data_out1_int[10]), .odat_async_out(nc_odat_async[10]),
     .pd_data_out(nc_pd_data[10]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(rx_distclk_l[11]),
     .iclkin_dist_in1(vssl), .idata0_in0(vssl),
     .idata0_in1(idat0_in1_clkp), .idata1_in0(vssl),
     .idata1_in1(idat1_in1_clkp), .idataselb_in0(vcc),
     .idataselb_in1(vcc), .iddren_in0(vcc), .iddren_in1(vcc),
     .ilaunch_clk_in0(vssl), .ilaunch_clk_in1(dft_tx_clk),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0({vssl, vssl}), .indrv_in1({vssl,
     vssl}), .ipdrv_in0({vssl, vssl}), .ipdrv_in1({vssl, vssl}),
     .irxen_in0(irxen_r0[2:0]), .irxen_in1(irxen_r1[2:0]),
     .istrbclk_in0(rx_strbclk_l[11]), .istrbclk_in1(vssl),
     .itxen_in0(vssl), .itxen_in1(csr_reg_str[6]), .oclk_in1(vssl),
     .odat_async_aib(nc_odat_async_aib_pin[10]), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(odat0_aib_pin[12]), .vccl(vccl),
     .odat1_in1(odat1_aib_pin[12]), .odat_async_in1(vssl),
     .shift_en(rshift_en_pinp[10]), .pd_data_in1(vssl),
     .dig_rstb(pinp_dig_rstb), .jtag_clkdr_out(jtag_clkdr_pinp10),
     .odat1_aib(odat1_aib_pin[10]),
     .jtag_rx_scan_out(jtag_rx_scan_pinp10),
     .odat0_aib(odat0_aib_pin[10]), .oclk_aib(oclk_aib_pin10),
     .last_bs_out(nc_last_bs_out_pinp10), .oclkb_aib(oclkb_aib_pin10),
     .jtag_clkdr_in(clkdr_xr3l), .jtag_mode_in(jtag_mode_in),
     .jtag_rstb(jtag_rstb), .jtag_tx_scan_in(jtag_rx_scan_clkp),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_dat[10]), .oclkn(nc_oclkn_pin[10]),
     .iclkn(oclkn_pin11), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xpinp12 ( .idata1_in1_jtag_out(nc_idat1_pinp12),
     .idata0_in1_jtag_out(nc_idat0_pinp12),
     .async_dat_in1_jtag_out(nc_async_dat_pinp12),
     .prev_io_shift_en(rshift_en_pinp[10]),
     .jtag_clkdr_outn(jtag_clkdr_outn_pinp12),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .vcc(vcc), .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(input_rstb),
     .pd_data_aib(nc_pd_data_aib_pin[12]), .oclk_out(nc_oclk[12]),
     .oclkb_out(nc_oclkb[12]), .odat0_out(pcs_data_out0_int[12]),
     .odat1_out(pcs_data_out1_int[12]), .odat_async_out(nc_odat_async[12]),
     .pd_data_out(nc_pd_data[12]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(rx_distclk_l[7]),
     .iclkin_dist_in1(rx_distclk_l[7]), .idata0_in0(vssl),
     .idata0_in1(vssl), .idata1_in0(vssl), .idata1_in1(vssl),
     .idataselb_in0(vcc), .idataselb_in1(vssl), .iddren_in0(vcc),
     .iddren_in1(vssl), .ilaunch_clk_in0(vssl), .ilaunch_clk_in1(vssl),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0({vssl, vssl}), .indrv_in1({vssl,
     vssl}), .ipdrv_in0({vssl, vssl}), .ipdrv_in1({vssl, vssl}),
     .irxen_in0(irxen_r0[2:0]), .irxen_in1(irxen_r0[2:0]),
     .istrbclk_in0(rx_strbclk_l[7]), .istrbclk_in1(rx_strbclk_l[7]),
     .itxen_in0(vssl), .itxen_in1(vssl), .oclk_in1(vssl),
     .odat_async_aib(nc_odat_async_aib_pin[12]), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(odat0_aib_pin[14]), .vccl(vccl),
     .odat1_in1(odat1_aib_pin[14]), .odat_async_in1(vssl),
     .shift_en(rshift_en_pinp[12]), .pd_data_in1(vssl),
     .dig_rstb(pinp_dig_rstb), .jtag_clkdr_out(jtag_clkdr_pinp12),
     .odat1_aib(odat1_aib_pin[12]),
     .jtag_rx_scan_out(jtag_rx_scan_pinp12),
     .odat0_aib(odat0_aib_pin[12]), .oclk_aib(nc_oclk_aib_pin[12]),
     .last_bs_out(nc_last_bs_out_pinp12),
     .oclkb_aib(nc_oclkb_aib_pin[12]), .jtag_clkdr_in(clkdr_xr3l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_pinp10),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_dat[12]), .oclkn(nc_oclkn_pin[12]), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xpinp13 ( .idata1_in1_jtag_out(nc_idat1_pinp13),
     .idata0_in1_jtag_out(nc_idat0_pinp13),
     .async_dat_in1_jtag_out(nc_async_dat_pinp13),
     .prev_io_shift_en(rshift_en_pinp[11]),
     .jtag_clkdr_outn(jtag_clkdr_outn_pinp13),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .vcc(vcc), .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(input_rstb),
     .pd_data_aib(nc_pd_data_aib_pin[13]), .oclk_out(nc_oclk[13]),
     .oclkb_out(nc_oclkb[13]), .odat0_out(pcs_data_out0_int[13]),
     .odat1_out(pcs_data_out1_int[13]), .odat_async_out(nc_odat_async[13]),
     .pd_data_out(nc_pd_data[13]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(rx_distclk_l[6]),
     .iclkin_dist_in1(rx_distclk_l[6]), .idata0_in0(vssl),
     .idata0_in1(vssl), .idata1_in0(vssl), .idata1_in1(vssl),
     .idataselb_in0(vcc), .idataselb_in1(vssl), .iddren_in0(vcc),
     .iddren_in1(vssl), .ilaunch_clk_in0(vssl), .ilaunch_clk_in1(vssl),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0({vssl, vssl}), .indrv_in1({vssl,
     vssl}), .ipdrv_in0({vssl, vssl}), .ipdrv_in1({vssl, vssl}),
     .irxen_in0(irxen_r0[2:0]), .irxen_in1(irxen_r0[2:0]),
     .istrbclk_in0(rx_strbclk_l[6]), .istrbclk_in1(rx_strbclk_l[6]),
     .itxen_in0(vssl), .itxen_in1(vssl), .oclk_in1(vssl),
     .odat_async_aib(nc_odat_async_aib_pin[13]), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(odat0_aib_pin[15]), .vccl(vccl),
     .odat1_in1(odat1_aib_pin[15]), .odat_async_in1(vssl),
     .shift_en(rshift_en_pinp[13]), .pd_data_in1(vssl),
     .dig_rstb(pinp_dig_rstb), .jtag_clkdr_out(jtag_clkdr_pinp13),
     .odat1_aib(odat1_aib_pin[13]),
     .jtag_rx_scan_out(jtag_rx_scan_pinp13),
     .odat0_aib(odat0_aib_pin[13]), .oclk_aib(nc_oclk_aib_pin[13]),
     .last_bs_out(nc_last_bs_out_pinp13),
     .oclkb_aib(nc_oclkb_aib_pin[13]), .jtag_clkdr_in(clkdr_xr4l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_pinp11),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_dat[13]), .oclkn(nc_oclkn_pin[13]), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xpinp14 ( .idata1_in1_jtag_out(nc_idat1_pinp14),
     .idata0_in1_jtag_out(nc_idat0_pinp14),
     .async_dat_in1_jtag_out(nc_async_dat_pinp14),
     .prev_io_shift_en(rshift_en_pinp[12]),
     .jtag_clkdr_outn(jtag_clkdr_outn_pinp14),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .vcc(vcc), .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(input_rstb),
     .pd_data_aib(nc_pd_data_aib_pin[14]), .oclk_out(nc_oclk[14]),
     .oclkb_out(nc_oclkb[14]), .odat0_out(pcs_data_out0_int[14]),
     .odat1_out(pcs_data_out1_int[14]), .odat_async_out(nc_odat_async[14]),
     .pd_data_out(nc_pd_data[14]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(rx_distclk_l[3]),
     .iclkin_dist_in1(rx_distclk_l[3]), .idata0_in0(vssl),
     .idata0_in1(vssl), .idata1_in0(vssl), .idata1_in1(vssl),
     .idataselb_in0(vcc), .idataselb_in1(vssl), .iddren_in0(vcc),
     .iddren_in1(vssl), .ilaunch_clk_in0(vssl), .ilaunch_clk_in1(vssl),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0({vssl, vssl}), .indrv_in1({vssl,
     vssl}), .ipdrv_in0({vssl, vssl}), .ipdrv_in1({vssl, vssl}),
     .irxen_in0(irxen_r0[2:0]), .irxen_in1(irxen_r0[2:0]),
     .istrbclk_in0(rx_strbclk_l[3]), .istrbclk_in1(rx_strbclk_l[3]),
     .itxen_in0(vssl), .itxen_in1(vssl), .oclk_in1(vssl),
     .odat_async_aib(nc_odat_async_aib_pin[14]), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(odat0_aib_pin[16]), .vccl(vccl),
     .odat1_in1(odat1_aib_pin[16]), .odat_async_in1(vssl),
     .shift_en(rshift_en_pinp[14]), .pd_data_in1(vssl),
     .dig_rstb(pinp_dig_rstb), .jtag_clkdr_out(jtag_clkdr_pinp14),
     .odat1_aib(odat1_aib_pin[14]),
     .jtag_rx_scan_out(jtag_rx_scan_pinp14),
     .odat0_aib(odat0_aib_pin[14]), .oclk_aib(nc_oclk_aib_pin[14]),
     .last_bs_out(nc_last_bs_out_pinp14),
     .oclkb_aib(nc_oclkb_aib_pin[14]), .jtag_clkdr_in(clkdr_xr3l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_pinp12),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_dat[14]), .oclkn(nc_oclkn_pin[14]), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xpinp15 ( .idata1_in1_jtag_out(nc_idat1_pinp15),
     .idata0_in1_jtag_out(nc_idat0_pinp15),
     .async_dat_in1_jtag_out(nc_async_dat_pinp15),
     .prev_io_shift_en(rshift_en_pinp[13]),
     .jtag_clkdr_outn(jtag_clkdr_outn_pinp15),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .vcc(vcc), .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(input_rstb),
     .pd_data_aib(nc_pd_data_aib_pin[15]), .oclk_out(nc_oclk[15]),
     .oclkb_out(nc_oclkb[15]), .odat0_out(pcs_data_out0_int[15]),
     .odat1_out(pcs_data_out1_int[15]), .odat_async_out(nc_odat_async[15]),
     .pd_data_out(nc_pd_data[15]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(rx_distclk_l[2]),
     .iclkin_dist_in1(rx_distclk_l[2]), .idata0_in0(vssl),
     .idata0_in1(vssl), .idata1_in0(vssl), .idata1_in1(vssl),
     .idataselb_in0(vcc), .idataselb_in1(vssl), .iddren_in0(vcc),
     .iddren_in1(vssl), .ilaunch_clk_in0(vssl), .ilaunch_clk_in1(vssl),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0({vssl, vssl}), .indrv_in1({vssl,
     vssl}), .ipdrv_in0({vssl, vssl}), .ipdrv_in1({vssl, vssl}),
     .irxen_in0(irxen_r0[2:0]), .irxen_in1(irxen_r0[2:0]),
     .istrbclk_in0(rx_strbclk_l[2]), .istrbclk_in1(rx_strbclk_l[2]),
     .itxen_in0(vssl), .itxen_in1(vssl), .oclk_in1(vssl),
     .odat_async_aib(nc_odat_async_aib_pin[15]), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(odat0_aib_pin[17]), .vccl(vccl),
     .odat1_in1(odat1_aib_pin[17]), .odat_async_in1(vssl),
     .shift_en(rshift_en_pinp[15]), .pd_data_in1(vssl),
     .dig_rstb(pinp_dig_rstb), .jtag_clkdr_out(jtag_clkdr_pinp15),
     .odat1_aib(odat1_aib_pin[15]),
     .jtag_rx_scan_out(jtag_rx_scan_pinp15),
     .odat0_aib(odat0_aib_pin[15]), .oclk_aib(nc_oclk_aib_pin[15]),
     .last_bs_out(nc_last_bs_out_pinp15),
     .oclkb_aib(nc_oclkb_aib_pin[15]), .jtag_clkdr_in(clkdr_xr4l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_pinp13),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_dat[15]), .oclkn(nc_oclkn_pin[15]), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xdiout_clkp0 ( .idata1_in1_jtag_out(idata1_ptxclkout),
     .idata0_in1_jtag_out(idata0_ptxclkout),
     .async_dat_in1_jtag_out(nc_async_dat_ptxclkout),
     .prev_io_shift_en(shift_en_vinp00),
     .jtag_clkdr_outn(jtag_clkdr_outn_ptxclkout),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .anlg_rstb(input_rstb),
     .pd_data_aib(ncrx_pd_data_aib_clkp0),
     .oclk_out(nc_rx_fast_clk[0]), .oclkb_out(nc_rx_fast_clkb[0]),
     .odat0_out(nc_rxodat0_clkp[0]), .odat1_out(nc_rxodat1_clkp[0]),
     .odat_async_out(nc_rxodat_async_clkp[0]),
     .pd_data_out(nc_rxpd_data_clkp[0]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(iclkin_dist_vinp00),
     .iclkin_dist_in1(iclkin_dist_vinp00),
     .idata0_in0(idat0_directoutclkp[0]), .idata0_in1(vssl),
     .idata1_in0(idat1_directoutclkp[0]), .idata1_in1(vssl),
     .idataselb_in0(idataselb[0]), .idataselb_in1(vssl),
     .iddren_in0(vcc), .iddren_in1(vssl),
     .ilaunch_clk_in0(txdirclk_fast_clkp0_buf), .ilaunch_clk_in1(vssl),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0(indrv_r56[1:0]), .indrv_in1({vssl,
     vssl}), .ipdrv_in0(ipdrv_r56[1:0]), .ipdrv_in1({vssl, vssl}),
     .irxen_in0({vssl, vcc, vssl}), .irxen_in1(irxen_vinp00[2:0]),
     .istrbclk_in0(istrbclk_vinp00), .istrbclk_in1(istrbclk_vinp00),
     .itxen_in0(itxen[0]), .itxen_in1(vssl), .oclk_in1(vssl),
     .odat_async_aib(ncrx_odat_async_aib_clkp0), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(vssl), .vccl(vccl), .odat1_in1(vssl),
     .odat_async_in1(vssl), .shift_en(rshift_en_dirclkp[0]),
     .pd_data_in1(vssl), .dig_rstb(input_rstb),
     .jtag_clkdr_out(jtag_clkdr_ptxclkout), .vcc(vcc),
     .odat1_aib(odat1_ptxclkout),
     .jtag_rx_scan_out(jtag_rx_scan_ptxclkout),
     .odat0_aib(odat0_ptxclkout), .oclk_aib(ncrx_oclk_aib_clkp0),
     .last_bs_out(nc_last_bs_out_ptxclkout),
     .por_aib_vccl(por_aib_vccl), .por_aib_vcchssi(por_aib_vcchssi),
     .oclkb_aib(ncrx_oclkb_aib_clkp0), .jtag_clkdr_in(clkdr_xr5l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_vinp00),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_directoutclkp[0]), .oclkn(nc_rxoclk_clkp0),
     .iclkn(vssl), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xasynctx1 ( .idata1_in1_jtag_out(idat1_oshared1),
     .idata0_in1_jtag_out(idat0_oshared1),
     .async_dat_in1_jtag_out(nc_async_dat_oshared1),
     .prev_io_shift_en(rshift_en_rx[3]),
     .jtag_clkdr_outn(jtag_clkdr_outn_oshared1),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .anlg_rstb(input_rstb),
     .pd_data_aib(nctx_pd_data_aib[1]), .oclk_out(nctx_oclk[1]),
     .oclkb_out(nctx_oclkb[1]), .odat0_out(nctx_odat0[1]),
     .odat1_out(nctx_odat1[1]), .odat_async_out(nctx_odat_async[1]),
     .pd_data_out(nctx_pd_data[1]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(jtag_clkdr_outn_oshared1),
     .iclkin_dist_in1(vssl), .idata0_in0(vcc),
     .idata0_in1(idat0_oshared3), .idata1_in0(vssl),
     .idata1_in1(idat1_oshared3), .idataselb_in0(idataselb[2]),
     .idataselb_in1(idataselb[2]), .iddren_in0(vcc), .iddren_in1(vcc),
     .ilaunch_clk_in0(iasyncdata[0]), .ilaunch_clk_in1(iasyncdata[2]),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0(indrv_r56[1:0]),
     .indrv_in1(indrv_r56[1:0]), .ipdrv_in0(ipdrv_r56[1:0]),
     .ipdrv_in1(ipdrv_r56[1:0]), .irxen_in0({vssl, vcc, vssl}),
     .irxen_in1({vssl, vcc, vssl}),
     .istrbclk_in0(jtag_clkdr_outn_oshared1), .istrbclk_in1(vssl),
     .itxen_in0(itxen[2]), .itxen_in1(itxen[2]), .oclk_in1(vssl),
     .odat_async_aib(nctx_odat_async_aib[1]), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(vssl), .vccl(vccl), .odat1_in1(vssl),
     .odat_async_in1(vssl), .shift_en(rshift_en_rx[1]),
     .pd_data_in1(vssl), .dig_rstb(input_rstb),
     .jtag_clkdr_out(jtag_clkdr_oshared1), .vcc(vcc),
     .odat1_aib(nctx_odat1_aib[1]),
     .jtag_rx_scan_out(jtag_rx_scan_oshared1),
     .odat0_aib(nctx_odat0_aib[1]), .oclk_aib(nctx_oclk_aib[1]),
     .last_bs_out(nc_last_bs_out_oshared1),
     .por_aib_vccl(por_aib_vccl), .por_aib_vcchssi(por_aib_vcchssi),
     .oclkb_aib(nctx_oclkb_aib[1]), .jtag_clkdr_in(clkdr_xr6r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_oshared3),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_async_out[1]), .oclkn(nctx_oclkn[1]), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xasynctx0 ( .idata1_in1_jtag_out(idat1_oshared0),
     .idata0_in1_jtag_out(idat0_oshared0),
     .async_dat_in1_jtag_out(nc_async_dat_oshared0),
     .prev_io_shift_en(rshift_en_rx[2]),
     .jtag_clkdr_outn(jtag_clkdr_outn_oshared0),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .anlg_rstb(input_rstb),
     .pd_data_aib(nctx_pd_data_aib[0]), .oclk_out(nctx_oclk[0]),
     .oclkb_out(nctx_oclkb[0]), .odat0_out(nctx_odat0[0]),
     .odat1_out(nctx_odat1[0]), .odat_async_out(nctx_odat_async[0]),
     .pd_data_out(nctx_pd_data[0]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(jtag_clkdr_outn_oshared0),
     .iclkin_dist_in1(vssl), .idata0_in0(vssl),
     .idata0_in1(idat0_oshared2), .idata1_in0(vcc),
     .idata1_in1(idat1_oshared2), .idataselb_in0(idataselb[2]),
     .idataselb_in1(idataselb[2]), .iddren_in0(vcc), .iddren_in1(vcc),
     .ilaunch_clk_in0(iasyncdata[0]), .ilaunch_clk_in1(iasyncdata[2]),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0(indrv_r56[1:0]),
     .indrv_in1(indrv_r56[1:0]), .ipdrv_in0(ipdrv_r56[1:0]),
     .ipdrv_in1(ipdrv_r56[1:0]), .irxen_in0({vssl, vcc, vssl}),
     .irxen_in1({vssl, vcc, vssl}),
     .istrbclk_in0(jtag_clkdr_outn_oshared0), .istrbclk_in1(vssl),
     .itxen_in0(itxen[2]), .itxen_in1(itxen[2]), .oclk_in1(vssl),
     .odat_async_aib(nctx_odat_async_aib[0]), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(vssl), .vccl(vccl), .odat1_in1(vssl),
     .odat_async_in1(vssl), .shift_en(rshift_en_rx[0]),
     .pd_data_in1(vssl), .dig_rstb(input_rstb),
     .jtag_clkdr_out(jtag_clkdr_oshared0), .vcc(vcc),
     .odat1_aib(nctx_odat1_aib[0]),
     .jtag_rx_scan_out(jtag_rx_scan_oshared0),
     .odat0_aib(nctx_odat0_aib[0]), .oclk_aib(nctx_oclk_aib[0]),
     .last_bs_out(nc_last_bs_out_oshared0),
     .por_aib_vccl(por_aib_vccl), .por_aib_vcchssi(por_aib_vcchssi),
     .oclkb_aib(nctx_oclkb_aib[0]), .jtag_clkdr_in(clkdr_xr5r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_oshared2),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_async_out[0]), .oclkn(nctx_oclkn[0]), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xasyncrx2 ( .idata1_in1_jtag_out(nc_idat1_inpshared2),
     .idata0_in1_jtag_out(nc_idat0_inpshared2),
     .async_dat_in1_jtag_out(nc_async_dat_inpshared2),
     .prev_io_shift_en(rshift_en_tx[1]),
     .jtag_clkdr_outn(jtag_clkdr_outn_inpshared2),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .anlg_rstb(input_rstb),
     .pd_data_aib(ncrx_pd_data_aib[2]), .oclk_out(ncrx_oclk[2]),
     .oclkb_out(ncrx_oclkb[2]), .odat0_out(ncrx_odat0[2]),
     .odat1_out(ncrx_odat1[2]), .odat_async_out(odat_async[2]),
     .pd_data_out(ncrx_pd_data[2]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(vssl),
     .iclkin_dist_in1(vssl), .idata0_in0(vssl), .idata0_in1(vssl),
     .idata1_in0(vssl), .idata1_in1(vssl), .idataselb_in0(vssl),
     .idataselb_in1(vssl), .iddren_in0(vssl), .iddren_in1(vssl),
     .ilaunch_clk_in0(vssl), .ilaunch_clk_in1(vssl),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0({vssl, vssl}), .indrv_in1({vssl,
     vssl}), .ipdrv_in0({vssl, vssl}), .ipdrv_in1({vssl, vssl}),
     .irxen_in0(irxen_r3[2:0]), .irxen_in1(irxen_r3[2:0]),
     .istrbclk_in0(vssl), .istrbclk_in1(vssl), .itxen_in0(vssl),
     .itxen_in1(vssl), .oclk_in1(vssl),
     .odat_async_aib(odat_async_aib_inpshared2), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(vssl), .vccl(vccl), .odat1_in1(vssl),
     .odat_async_in1(odat_async_fsrldout), .shift_en(rshift_en_tx[3]),
     .pd_data_in1(vssl), .dig_rstb(input_rstb),
     .jtag_clkdr_out(jtag_clkdr_inpshared2), .vcc(vcc),
     .odat1_aib(ncrx_odat1_aib[2]),
     .jtag_rx_scan_out(jtag_rx_scan_inpshared2),
     .odat0_aib(ncrx_odat0_aib[2]), .oclk_aib(ncrx_oclk_aib[2]),
     .last_bs_out(nc_last_bs_out_diro2), .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .oclkb_aib(ncrx_oclkb_aib[2]),
     .jtag_clkdr_in(clkdr_xr8r), .jtag_mode_in(jtag_mode_in),
     .jtag_rstb(jtag_rstb), .jtag_tx_scan_in(jtag_rx_scan_inpshared1),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_async_in[2]), .oclkn(ncrx_oclkn[2]), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xdirect_out1 (
     .idata1_in1_jtag_out(nc_idat1_outpdir0),
     .idata0_in1_jtag_out(nc_idat0_outpdir0),
     .async_dat_in1_jtag_out(idirectout_data_out_chain1),
     .prev_io_shift_en(shift_en_poutp0),
     .jtag_clkdr_outn(jtag_clkdr_outn_outpdir0),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .anlg_rstb(input_rstb),
     .pd_data_aib(ncdtx_pd_data_aib[1]), .oclk_out(ncdtx_oclk[1]),
     .oclkb_out(ncdtx_oclkb[1]), .odat0_out(ncdtx_odat0[1]),
     .odat1_out(ncdtx_odat1[1]), .odat_async_out(ncdtx_odat_async[1]),
     .pd_data_out(ncdtx_pd_data[1]),
     .async_dat_in0(idirectout_data[1]), .async_dat_in1(vssl),
     .iclkin_dist_in0(vssl), .iclkin_dist_in1(vssl), .idata0_in0(vssl),
     .idata0_in1(idata0_poutp0), .idata1_in0(vssl),
     .idata1_in1(idata1_poutp0), .idataselb_in0(idataselb[1]),
     .idataselb_in1(idataselb_poutp0), .iddren_in0(vssl),
     .iddren_in1(iddren_poutp0), .ilaunch_clk_in0(vssl),
     .ilaunch_clk_in1(ilaunch_clk_poutp0), .ilpbk_dat_in0(vssl),
     .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl), .ilpbk_en_in1(vssl),
     .indrv_in0(indrv_r12[1:0]), .indrv_in1(indrv_r12[1:0]),
     .ipdrv_in0(ipdrv_r12[1:0]), .ipdrv_in1(ipdrv_r12[1:0]),
     .irxen_in0({vssl, vcc, vssl}), .irxen_in1({vssl, vcc, vssl}),
     .istrbclk_in0(vssl), .istrbclk_in1(vssl), .itxen_in0(itxen[1]),
     .itxen_in1(itxen_poutp0), .oclk_in1(vssl),
     .odat_async_aib(ncdtx_odat_async_aib[1]), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(vssl), .vccl(vccl), .odat1_in1(vssl),
     .odat_async_in1(vssl), .shift_en(rshift_en_dtx[1]),
     .pd_data_in1(vssl), .dig_rstb(input_rstb),
     .jtag_clkdr_out(jtag_clkdr_out_chain1), .vcc(vcc),
     .odat1_aib(ncdtx_odat1_aib[1]),
     .jtag_rx_scan_out(jtag_scan_out_chain1),
     .odat0_aib(ncdtx_odat0_aib[1]), .oclk_aib(ncdtx_oclk_aib[1]),
     .last_bs_out(nc_last_bs_out_outpdir0),
     .por_aib_vccl(por_aib_vccl), .por_aib_vcchssi(por_aib_vcchssi),
     .oclkb_aib(ncdtx_oclkb_aib[1]), .jtag_clkdr_in(clkdr_xr1r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_out_poutp0),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_directout[1]), .oclkn(ncdtx_oclkn1), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xpinp18 ( .idata1_in1_jtag_out(nc_idat1_pinp18),
     .idata0_in1_jtag_out(nc_idat0_pinp18),
     .async_dat_in1_jtag_out(nc_async_dat_pinp18),
     .prev_io_shift_en(rshift_en_pinp[16]),
     .jtag_clkdr_outn(jtag_clkdr_outn_pinp18),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .vcc(vcc), .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(input_rstb),
     .pd_data_aib(nc_pd_data_aib_pin[18]), .oclk_out(nc_oclk[18]),
     .oclkb_out(nc_oclkb[18]), .odat0_out(pcs_data_out0_int[18]),
     .odat1_out(pcs_data_out1_int[18]), .odat_async_out(nc_odat_async[18]),
     .pd_data_out(nc_pd_data[18]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(rx_distclk_l[5]),
     .iclkin_dist_in1(rx_distclk_l[5]), .idata0_in0(vssl),
     .idata0_in1(vssl), .idata1_in0(vssl), .idata1_in1(vssl),
     .idataselb_in0(vcc), .idataselb_in1(vssl), .iddren_in0(vcc),
     .iddren_in1(vssl), .ilaunch_clk_in0(vssl), .ilaunch_clk_in1(vssl),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0({vssl, vssl}), .indrv_in1({vssl,
     vssl}), .ipdrv_in0({vssl, vssl}), .ipdrv_in1({vssl, vssl}),
     .irxen_in0(irxen_r0[2:0]), .irxen_in1(irxen_r0[2:0]),
     .istrbclk_in0(rx_strbclk_l[5]), .istrbclk_in1(rx_strbclk_l[5]),
     .itxen_in0(vssl), .itxen_in1(vssl), .oclk_in1(vssl),
     .odat_async_aib(nc_odat_async_aib_pin[18]), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(odat0_aib_inpdir5_1), .vccl(vccl),
     .odat1_in1(odat1_aib_inpdir5_1), .odat_async_in1(vssl),
     .shift_en(rshift_en_pinp[18]), .pd_data_in1(vssl),
     .dig_rstb(pinp_dig_rstb), .jtag_clkdr_out(jtag_clkdr_pinp18),
     .odat1_aib(odat1_aib_pin[18]),
     .jtag_rx_scan_out(jtag_rx_scan_pinp18),
     .odat0_aib(odat0_aib_pin[18]), .oclk_aib(nc_oclk_aib_pin[18]),
     .last_bs_out(nc_last_bs_out_pinp18),
     .oclkb_aib(nc_oclkb_aib_pin[18]), .jtag_clkdr_in(clkdr_xr3l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_pinp16),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_dat[18]), .oclkn(nc_oclkn_pin[18]), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xdiout_clkn1 ( .idata1_in1_jtag_out(idat1_outclk0n),
     .idata0_in1_jtag_out(idat0_outclk0n),
     .async_dat_in1_jtag_out(nc_async_dat_outclk0n),
     .prev_io_shift_en(shift_en_inpdir0_1),
     .jtag_clkdr_outn(jtag_clkdr_outn_outclk0n),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .anlg_rstb(input_rstb),
     .pd_data_aib(ncrx_pd_data_aib_clkn1),
     .oclk_out(ncout_rx_fast_clkn[1]),
     .oclkb_out(ncout_rx_fast_clknb[1]),
     .odat0_out(nc_rxodat0_clkn[1]), .odat1_out(nc_rxodat1_clkn[1]),
     .odat_async_out(nc_rxodat_async_clkn[1]),
     .pd_data_out(nc_rxpd_data_clkn[1]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(jtag_clkdr_outn_outclk0n),
     .iclkin_dist_in1(vssl), .idata0_in0(idat0_directoutclkn[1]),
     .idata0_in1(vssl), .idata1_in0(idat1_directoutclkn[1]),
     .idata1_in1(vssl), .idataselb_in0(idataselb[0]),
     .idataselb_in1(vssl), .iddren_in0(vcc), .iddren_in1(vssl),
     .ilaunch_clk_in0(txdirclk_fast_clkp[1]), .ilaunch_clk_in1(vssl),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0(indrv_r78[1:0]), .indrv_in1({vssl,
     vssl}), .ipdrv_in0(ipdrv_r78[1:0]), .ipdrv_in1({vssl, vssl}),
     .irxen_in0({vssl, vcc, vssl}), .irxen_in1(irxen_inpdir0_1[2:0]),
     .istrbclk_in0(jtag_clkdr_outn_outclk0n), .istrbclk_in1(vssl),
     .itxen_in0(itxen[0]), .itxen_in1(vssl), .oclk_in1(vssl),
     .odat_async_aib(odat_async_outclk0n), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(vssl), .vccl(vccl), .odat1_in1(vssl),
     .odat_async_in1(vssl), .shift_en(rshift_en_dirclkn[1]),
     .pd_data_in1(vssl), .dig_rstb(input_rstb),
     .jtag_clkdr_out(jtag_clkdr_outclk0n), .vcc(vcc),
     .odat1_aib(nc_odat1_outpclk0n),
     .jtag_rx_scan_out(jtag_rx_scan_outclk0n),
     .odat0_aib(nc_odat0_outpclk0n),
     .oclk_aib(nc_out_rx_fast_clkn_aib1),
     .last_bs_out(nc_last_bs_out_outclk0n),
     .por_aib_vccl(por_aib_vccl), .por_aib_vcchssi(por_aib_vcchssi),
     .oclkb_aib(nc_out_rx_fast_clknb_aib1), .jtag_clkdr_in(clkdr_xr8l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_inpdir0_1),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_directoutclkn[1]), .oclkn(oclkn_clkn1), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xpinp16 ( .idata1_in1_jtag_out(nc_idat1_pinp16),
     .idata0_in1_jtag_out(nc_idat0_pinp16),
     .async_dat_in1_jtag_out(nc_async_dat_pinp16),
     .prev_io_shift_en(rshift_en_pinp[14]),
     .jtag_clkdr_outn(jtag_clkdr_outn_pinp16),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .vcc(vcc), .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(input_rstb),
     .pd_data_aib(nc_pd_data_aib_pin[16]), .oclk_out(nc_oclk[16]),
     .oclkb_out(nc_oclkb[16]), .odat0_out(pcs_data_out0_int[16]),
     .odat1_out(pcs_data_out1_int[16]), .odat_async_out(nc_odat_async[16]),
     .pd_data_out(nc_pd_data[16]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(rx_distclk_l[1]),
     .iclkin_dist_in1(rx_distclk_l[1]), .idata0_in0(vssl),
     .idata0_in1(vssl), .idata1_in0(vssl), .idata1_in1(vssl),
     .idataselb_in0(vcc), .idataselb_in1(vssl), .iddren_in0(vcc),
     .iddren_in1(vssl), .ilaunch_clk_in0(vssl), .ilaunch_clk_in1(vssl),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0({vssl, vssl}), .indrv_in1({vssl,
     vssl}), .ipdrv_in0({vssl, vssl}), .ipdrv_in1({vssl, vssl}),
     .irxen_in0(irxen_r0[2:0]), .irxen_in1(irxen_r0[2:0]),
     .istrbclk_in0(rx_strbclk_l[1]), .istrbclk_in1(rx_strbclk_l[1]),
     .itxen_in0(vssl), .itxen_in1(vssl), .oclk_in1(vssl),
     .odat_async_aib(nc_odat_async_aib_pin[16]), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(odat0_aib_pin[18]), .vccl(vccl),
     .odat1_in1(odat1_aib_pin[18]), .odat_async_in1(vssl),
     .shift_en(rshift_en_pinp[16]), .pd_data_in1(vssl),
     .dig_rstb(pinp_dig_rstb), .jtag_clkdr_out(jtag_clkdr_pinp16),
     .odat1_aib(odat1_aib_pin[16]),
     .jtag_rx_scan_out(jtag_rx_scan_pinp16),
     .odat0_aib(odat0_aib_pin[16]), .oclk_aib(nc_oclk_aib_pin[16]),
     .last_bs_out(nc_last_bs_out_pinp16),
     .oclkb_aib(nc_oclkb_aib_pin[16]), .jtag_clkdr_in(clkdr_xr3l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_pinp14),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_dat[16]), .oclkn(nc_oclkn_pin[16]), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xpinp19 ( .idata1_in1_jtag_out(nc_idat1_pinp19),
     .idata0_in1_jtag_out(nc_idat0_pinp19),
     .async_dat_in1_jtag_out(nc_async_dat_pinp19),
     .prev_io_shift_en(rshift_en_pinp[17]),
     .jtag_clkdr_outn(jtag_clkdr_outn_pinp19),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .vcc(vcc), .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(input_rstb),
     .dig_rstb(pinp_dig_rstb), .pd_data_aib(nc_pd_data_aib_pin[19]),
     .oclk_out(nc_oclk[19]), .oclkb_out(nc_oclkb[19]),
     .odat0_out(pcs_data_out0_int[19]), .odat1_out(pcs_data_out1_int[19]),
     .odat_async_out(nc_odat_async[19]), .pd_data_out(nc_pd_data[19]),
     .async_dat_in0(vssl), .async_dat_in1(vssl),
     .iclkin_dist_in0(rx_distclk_l[4]),
     .iclkin_dist_in1(rx_distclk_l[4]), .idata0_in0(vssl),
     .idata0_in1(vssl), .idata1_in0(vssl), .idata1_in1(vssl),
     .idataselb_in0(vcc), .idataselb_in1(vssl), .iddren_in0(vcc),
     .iddren_in1(vssl), .ilaunch_clk_in0(vssl), .ilaunch_clk_in1(vssl),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0({vssl, vssl}), .indrv_in1({vssl,
     vssl}), .ipdrv_in0({vssl, vssl}), .ipdrv_in1({vssl, vssl}),
     .irxen_in0(irxen_r0[2:0]), .irxen_in1(irxen_r0[2:0]),
     .istrbclk_in0(rx_strbclk_l[4]), .istrbclk_in1(rx_strbclk_l[4]),
     .itxen_in0(vssl), .itxen_in1(vssl), .oclk_in1(vssl),
     .odat_async_aib(nc_odat_async_aib_pin[19]), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(drx_odat0_aib_0), .vccl(vccl),
     .odat1_in1(drx_odat1_aib_0), .odat_async_in1(vssl),
     .shift_en(rshift_en_pinp[19]), .pd_data_in1(vssl),
     .jtag_clkdr_out(jtag_clkdr_pinp19), .odat1_aib(odat1_aib_pin[19]),
     .jtag_rx_scan_out(jtag_rx_scan_pinp19),
     .odat0_aib(odat0_aib_pin[19]), .oclk_aib(nc_oclk_aib_pin[19]),
     .last_bs_out(nc_last_bs_out_pinp19),
     .oclkb_aib(nc_oclkb_aib_pin[19]), .jtag_clkdr_in(clkdr_xr4l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_pinp17),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_dat[19]), .oclkn(nc_oclkn_pin[19]), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xasyncrx1 ( .idata1_in1_jtag_out(nc_idat1_inpshared1),
     .idata0_in1_jtag_out(nc_idat0_inpshared1),
     .async_dat_in1_jtag_out(nc_async_dat_inpshared1),
     .prev_io_shift_en(shift_en_outpclk6),
     .jtag_clkdr_outn(jtag_clkdr_outn_inpshared1),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .anlg_rstb(input_rstb),
     .pd_data_aib(ncrx_pd_data_aib[1]), .oclk_out(ncrx_oclk[1]),
     .oclkb_out(ncrx_oclkb[1]), .odat0_out(ncrx_odat0[1]),
     .odat1_out(ncrx_odat1[1]), .odat_async_out(odat_async[1]),
     .pd_data_out(ncrx_pd_data[1]), .async_dat_in0(vssl),
     .async_dat_in1(async_dat_outpclk6), .iclkin_dist_in0(vssl),
     .iclkin_dist_in1(vssl), .idata0_in0(vssl), .idata0_in1(vssl),
     .idata1_in0(vssl), .idata1_in1(vssl), .idataselb_in0(vssl),
     .idataselb_in1(idataselb_outpclk6), .iddren_in0(vssl),
     .iddren_in1(vssl), .ilaunch_clk_in0(vssl), .ilaunch_clk_in1(vssl),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0({vssl, vssl}),
     .indrv_in1(indrv_r78[1:0]), .ipdrv_in0({vssl, vssl}),
     .ipdrv_in1(ipdrv_r78[1:0]), .irxen_in0(irxen_r3[2:0]),
     .irxen_in1({vssl, vcc, vssl}), .istrbclk_in0(vssl),
     .istrbclk_in1(vssl), .itxen_in0(vssl), .itxen_in1(itxen_outpclk6),
     .oclk_in1(vssl), .odat_async_aib(ncrx_odat_async_aib[1]),
     .oclkb_in1(vssl), .vssl(vssl), .odat0_in1(vssl), .vccl(vccl),
     .odat1_in1(vssl), .odat_async_in1(odat_async_aib_inpshared2),
     .shift_en(rshift_en_tx[1]), .pd_data_in1(vssl),
     .dig_rstb(input_rstb), .jtag_clkdr_out(jtag_clkdr_inpshared1),
     .vcc(vcc), .odat1_aib(ncrx_odat1_aib[1]),
     .jtag_rx_scan_out(jtag_rx_scan_inpshared1),
     .odat0_aib(ncrx_odat0_aib[1]), .oclk_aib(ncrx_oclk_aib[1]),
     .last_bs_out(nc_last_bs_out_diro1), .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .oclkb_aib(ncrx_oclkb_aib[1]),
     .jtag_clkdr_in(clkdr_xr8r), .jtag_mode_in(jtag_mode_in),
     .jtag_rstb(jtag_rstb), .jtag_tx_scan_in(jtag_rx_scan_outpclk6),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_async_in[1]), .oclkn(ncrx_oclkn[1]), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xasynctx3 ( .idata1_in1_jtag_out(idat1_oshared3),
     .idata0_in1_jtag_out(idat0_oshared3),
     .async_dat_in1_jtag_out(nc_async_dat_oshared3),
     .prev_io_shift_en(shift_en_ssrldin),
     .jtag_clkdr_outn(jtag_clkdr_outn_oshared3),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .anlg_rstb(input_rstb),
     .pd_data_aib(nctx_pd_data_aib[3]), .oclk_out(nctx_oclk[3]),
     .oclkb_out(nctx_oclkb[3]), .odat0_out(nctx_odat0[3]),
     .odat1_out(nctx_odat1[3]), .odat_async_out(nctx_odat_async[3]),
     .pd_data_out(nctx_pd_data[3]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(iclkin_dist_ssrldin),
     .iclkin_dist_in1(iclkin_dist_ssrldin), .idata0_in0(vcc),
     .idata0_in1(vssl), .idata1_in0(vssl), .idata1_in1(vssl),
     .idataselb_in0(idataselb[2]), .idataselb_in1(vssl),
     .iddren_in0(vcc), .iddren_in1(vssl),
     .ilaunch_clk_in0(iasyncdata[2]), .ilaunch_clk_in1(vssl),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0(indrv_r56[1:0]), .indrv_in1({vssl,
     vssl}), .ipdrv_in0(ipdrv_r56[1:0]), .ipdrv_in1({vssl, vssl}),
     .irxen_in0({vssl, vcc, vssl}), .irxen_in1(irxen_ssrldin[2:0]),
     .istrbclk_in0(istrbclk_ssrldin), .istrbclk_in1(istrbclk_ssrldin),
     .itxen_in0(itxen[2]), .itxen_in1(vssl), .oclk_in1(vssl),
     .odat_async_aib(nctx_odat_async_aib3), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(vssl), .vccl(vccl), .odat1_in1(vssl),
     .odat_async_in1(vssl), .shift_en(rshift_en_rx[3]),
     .pd_data_in1(vssl), .dig_rstb(input_rstb),
     .jtag_clkdr_out(jtag_clkdr_oshared3), .vcc(vcc),
     .odat1_aib(odat1_oshared3),
     .jtag_rx_scan_out(jtag_rx_scan_oshared3),
     .odat0_aib(odat0_oshared3), .oclk_aib(nctx_oclk_aib[3]),
     .last_bs_out(nc_last_bs_out_oshared3),
     .por_aib_vccl(por_aib_vccl), .por_aib_vcchssi(por_aib_vcchssi),
     .oclkb_aib(nctx_oclkb_aib[3]), .jtag_clkdr_in(clkdr_xr6r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_ssrldin),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_async_out[3]), .oclkn(nctx_oclkn[3]), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xdirect_outpclk3 (
     .idata1_in1_jtag_out(nc_idat1_outpclk3),
     .idata0_in1_jtag_out(nc_idat0_outpclk3),
     .async_dat_in1_jtag_out(async_dat_outpclk3),
     .prev_io_shift_en(shift_en_outpclk1n),
     .jtag_clkdr_outn(jtag_clkdr_outn_outpclk3),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .anlg_rstb(input_rstb),
     .pd_data_aib(ncdtx_pd_data_aib[2]), .oclk_out(ncdtx_oclk[2]),
     .oclkb_out(ncdtx_oclkb[2]), .odat0_out(ncdtx_odat0[2]),
     .odat1_out(ncdtx_odat1[2]), .odat_async_out(ncdtx_odat_async[2]),
     .pd_data_out(ncdtx_pd_data[2]),
     .async_dat_in0(idirectout_data[2]), .async_dat_in1(vssl),
     .iclkin_dist_in0(vssl), .iclkin_dist_in1(vssl), .idata0_in0(vssl),
     .idata0_in1(idat0_outpclk1n), .idata1_in0(vssl),
     .idata1_in1(idat1_outpclk1n), .idataselb_in0(idataselb[1]),
     .idataselb_in1(idataselb_outpclk1n), .iddren_in0(vssl),
     .iddren_in1(vcc), .ilaunch_clk_in0(vssl),
     .ilaunch_clk_in1(ilaunch_clk_outpclk1n), .ilpbk_dat_in0(vssl),
     .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl), .ilpbk_en_in1(vssl),
     .indrv_in0(indrv_r78[1:0]), .indrv_in1(indrv_r78[1:0]),
     .ipdrv_in0(ipdrv_r78[1:0]), .ipdrv_in1(ipdrv_r78[1:0]),
     .irxen_in0({vssl, vcc, vssl}), .irxen_in1({vssl, vcc, vssl}),
     .istrbclk_in0(vssl), .istrbclk_in1(vssl), .itxen_in0(itxen[1]),
     .itxen_in1(itxen_outpclk1n), .oclk_in1(vssl),
     .odat_async_aib(ncdtx_odat_async_aib[2]), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(vssl), .vccl(vccl), .odat1_in1(vssl),
     .odat_async_in1(vssl), .shift_en(rshift_en_dtx[2]),
     .pd_data_in1(vssl), .dig_rstb(input_rstb),
     .jtag_clkdr_out(jtag_clkdr_outpclk3), .vcc(vcc),
     .odat1_aib(ncdtx_odat1_aib[2]),
     .jtag_rx_scan_out(jtag_rx_scan_outpclk3),
     .odat0_aib(ncdtx_odat0_aib[2]), .oclk_aib(ncdtx_oclk_aib[2]),
     .last_bs_out(nc_last_bs_out_outpclk3),
     .por_aib_vccl(por_aib_vccl), .por_aib_vcchssi(por_aib_vcchssi),
     .oclkb_aib(ncdtx_oclkb_aib[2]), .jtag_clkdr_in(clkdr_xr8l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_outpclk1n),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_directout[2]), .oclkn(ncdtx_oclkn2), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xpinp17 ( .idata1_in1_jtag_out(nc_idat1_pinp17),
     .idata0_in1_jtag_out(nc_idat0_pinp17),
     .async_dat_in1_jtag_out(nc_async_dat_pinp17),
     .prev_io_shift_en(rshift_en_pinp[15]),
     .jtag_clkdr_outn(jtag_clkdr_outn_pinp17),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .vcc(vcc), .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(input_rstb),
     .pd_data_aib(nc_pd_data_aib_pin[17]), .oclk_out(nc_oclk[17]),
     .oclkb_out(nc_oclkb[17]), .odat0_out(pcs_data_out0_int[17]),
     .odat1_out(pcs_data_out1_int[17]), .odat_async_out(nc_odat_async[17]),
     .pd_data_out(nc_pd_data[17]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(rx_distclk_l[0]),
     .iclkin_dist_in1(rx_distclk_l[0]), .idata0_in0(vssl),
     .idata0_in1(vssl), .idata1_in0(vssl), .idata1_in1(vssl),
     .idataselb_in0(vcc), .idataselb_in1(vssl), .iddren_in0(vcc),
     .iddren_in1(vssl), .ilaunch_clk_in0(vssl), .ilaunch_clk_in1(vssl),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0({vssl, vssl}), .indrv_in1({vssl,
     vssl}), .ipdrv_in0({vssl, vssl}), .ipdrv_in1({vssl, vssl}),
     .irxen_in0(irxen_r0[2:0]), .irxen_in1(irxen_r0[2:0]),
     .istrbclk_in0(rx_strbclk_l[0]), .istrbclk_in1(rx_strbclk_l[0]),
     .itxen_in0(vssl), .itxen_in1(vssl), .oclk_in1(vssl),
     .odat_async_aib(nc_odat_async_aib_pin[17]), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(odat0_aib_pin[19]), .vccl(vccl),
     .odat1_in1(odat1_aib_pin[19]), .odat_async_in1(vssl),
     .shift_en(rshift_en_pinp[17]), .pd_data_in1(vssl),
     .dig_rstb(pinp_dig_rstb), .jtag_clkdr_out(jtag_clkdr_pinp17),
     .odat1_aib(odat1_aib_pin[17]),
     .jtag_rx_scan_out(jtag_rx_scan_pinp17),
     .odat0_aib(odat0_aib_pin[17]), .oclk_aib(nc_oclk_aib_pin[17]),
     .last_bs_out(nc_last_bs_out_pinp17),
     .oclkb_aib(nc_oclkb_aib_pin[17]), .jtag_clkdr_in(clkdr_xr4l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_pinp15),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_dat[17]), .oclkn(nc_oclkn_pin[17]), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xdirect_out (
     .idata1_in1_jtag_out(nc_idat1_inpdir6_1),
     .idata0_in1_jtag_out(nc_idat0_inpdir6_1),
     .async_dat_in1_jtag_out(nc_async_dat_inpdir6_1),
     .prev_io_shift_en(rshift_en_pinp[19]),
     .jtag_clkdr_outn(jtag_clkdr_outn_inpdir6_1),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .vcc(vcc), .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(input_rstb),
     .pd_data_aib(ncdrx_pd_data_aib[0]), .oclk_out(ncdrx_oclk[0]),
     .oclkb_out(ncdrx_oclkb[0]), .odat0_out(ncdrx_odat0[0]),
     .odat1_out(ncdrx_odat1[0]), .odat_async_out(odirectin_data[0]),
     .pd_data_out(ncdrx_pd_data[0]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(rx_distclk_l[8]),
     .iclkin_dist_in1(rx_distclk_l[8]), .idata0_in0(vssl),
     .idata0_in1(vssl), .idata1_in0(vssl), .idata1_in1(vssl),
     .idataselb_in0(vssl), .idataselb_in1(vssl), .iddren_in0(vssl),
     .iddren_in1(vssl), .ilaunch_clk_in0(vssl), .ilaunch_clk_in1(vssl),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0({vssl, vssl}), .indrv_in1({vssl,
     vssl}), .ipdrv_in0({vssl, vssl}), .ipdrv_in1({vssl, vssl}),
     .irxen_in0(irxen_r2[2:0]), .irxen_in1(irxen_r0[2:0]),
     .istrbclk_in0(rx_strbclk_l[8]), .istrbclk_in1(rx_strbclk_l[8]),
     .itxen_in0(vssl), .itxen_in1(vssl), .oclk_in1(vssl),
     .odat_async_aib(ncdrx_odat_async_aib[0]), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(vssl), .vccl(vccl), .odat1_in1(vssl),
     .odat_async_in1(odat_async_aib_poutp19),
     .shift_en(rshift_en_drx[0]), .pd_data_in1(vssl),
     .dig_rstb(pinp_dig_rstb), .jtag_clkdr_out(jtag_clkdr_inpdir6_1),
     .odat1_aib(drx_odat1_aib_0),
     .jtag_rx_scan_out(jtag_rx_scan_inpdir6_1),
     .odat0_aib(drx_odat0_aib_0), .oclk_aib(ncdrx_oclk_aib[0]),
     .last_bs_out(nc_last_bs_out_inpdir6_1),
     .oclkb_aib(ncdrx_oclkb_aib[0]), .jtag_clkdr_in(clkdr_xr4l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_pinp19),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_direct_input[0]), .oclkn(ncdrx_oclkn[0]),
     .iclkn(vssl), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xdiout_clkn0 (
     .idata1_in1_jtag_out(idata1_ptxclkoutn),
     .idata0_in1_jtag_out(idata0_ptxclkoutn),
     .async_dat_in1_jtag_out(nc_async_dat_ptxclkoutn),
     .prev_io_shift_en(shift_en_vinp01),
     .jtag_clkdr_outn(jtag_clkdr_outn_ptxclkoutn),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .anlg_rstb(input_rstb),
     .pd_data_aib(ncrx_pd_data_aib_clkn0),
     .oclk_out(ncout_tx_fast_clkn[0]),
     .oclkb_out(ncout_rx_fast_clknb[0]),
     .odat0_out(nc_rxodat0_clkn[0]), .odat1_out(nc_rxodat1_clkn[0]),
     .odat_async_out(nc_rxodat_async_clkn[0]),
     .pd_data_out(nc_rxpd_data_clkn[0]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(iclkin_dist_vinp01),
     .iclkin_dist_in1(iclkin_dist_vinp01),
     .idata0_in0(idat0_directoutclkn[0]), .idata0_in1(vssl),
     .idata1_in0(idat1_directoutclkn[0]), .idata1_in1(vssl),
     .idataselb_in0(idataselb[0]), .idataselb_in1(vssl),
     .iddren_in0(vcc), .iddren_in1(vssl),
     .ilaunch_clk_in0(txdirclk_fast_clkp0_buf), .ilaunch_clk_in1(vssl),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0(indrv_r56[1:0]), .indrv_in1({vssl,
     vssl}), .ipdrv_in0(ipdrv_r56[1:0]), .ipdrv_in1({vssl, vssl}),
     .irxen_in0({vssl, vcc, vssl}), .irxen_in1(irxen_vinp01[2:0]),
     .istrbclk_in0(istrbclk_vinp01), .istrbclk_in1(istrbclk_vinp01),
     .itxen_in0(itxen[0]), .itxen_in1(vssl), .oclk_in1(vssl),
     .odat_async_aib(ncrx_odat_async_aib_clkn0), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(vssl), .vccl(vccl), .odat1_in1(vssl),
     .odat_async_in1(vssl), .shift_en(rshift_en_dirclkn[0]),
     .pd_data_in1(vssl), .dig_rstb(input_rstb),
     .jtag_clkdr_out(jtag_clkdr_ptxclkoutn), .vcc(vcc),
     .odat1_aib(odat1_ptxclkoutn),
     .jtag_rx_scan_out(jtag_rx_scan_ptxclkoutn),
     .odat0_aib(odat0_ptxclkoutn), .oclk_aib(nc_out_rx_fast_clkn_aib0),
     .last_bs_out(nc_last_bs_out_ptxclkoutn),
     .por_aib_vccl(por_aib_vccl), .por_aib_vcchssi(por_aib_vcchssi),
     .oclkb_aib(nc_out_rx_fast_clknb_aib0), .jtag_clkdr_in(clkdr_xr6l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_vinp01),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_directoutclkn[0]), .oclkn(nc_oclkn_clkn0),
     .iclkn(vssl), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xdiout_clkp1 ( .idata1_in1_jtag_out(idat1_dirclkp1),
     .idata0_in1_jtag_out(idat0_dirclkp1),
     .async_dat_in1_jtag_out(nc_async_dat_dirclkp1),
     .prev_io_shift_en(shift_en_inpclk1),
     .jtag_clkdr_outn(jtag_clkdr_outn_outclk0),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .anlg_rstb(input_rstb),
     .pd_data_aib(ncrx_pd_data_aib_clkp1),
     .oclk_out(nc_out_rx_fast_clk[1]),
     .oclkb_out(nc_out_rx_fast_clkb[1]),
     .odat0_out(nc_rxodat0_clkp[1]), .odat1_out(nc_rxodat1_clkp[1]),
     .odat_async_out(nc_rxodat_async_clkp[1]),
     .pd_data_out(nc_rxpd_data_clkp[1]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(jtag_clkdr_outn_outclk0),
     .iclkin_dist_in1(vssl), .idata0_in0(idat0_directoutclkp[1]),
     .idata0_in1(vssl), .idata1_in0(idat1_directoutclkp[1]),
     .idata1_in1(vssl), .idataselb_in0(idataselb[0]),
     .idataselb_in1(vssl), .iddren_in0(vcc), .iddren_in1(vssl),
     .ilaunch_clk_in0(txdirclk_fast_clkp[1]), .ilaunch_clk_in1(vssl),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0(indrv_r78[1:0]), .indrv_in1({vssl,
     vssl}), .ipdrv_in0(ipdrv_r78[1:0]), .ipdrv_in1({vssl, vssl}),
     .irxen_in0({vssl, vcc, vssl}), .irxen_in1(irxen_inpclk1[2:0]),
     .istrbclk_in0(jtag_clkdr_outn_outclk0), .istrbclk_in1(vssl),
     .itxen_in0(itxen[0]), .itxen_in1(vssl), .oclk_in1(vssl),
     .odat_async_aib(odat_async_outclk0), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(vssl), .vccl(vccl), .odat1_in1(vssl),
     .odat_async_in1(vssl), .shift_en(rshift_en_dirclkp[1]),
     .pd_data_in1(vssl), .dig_rstb(input_rstb),
     .jtag_clkdr_out(jtag_clkdr_dirclkp1), .vcc(vcc),
     .odat1_aib(nc_odat1_outpclk0),
     .jtag_rx_scan_out(jtag_rx_scan_dirclkp1),
     .odat0_aib(nc_odat0_outpclk0), .oclk_aib(nc_out_rx_fast_clk_aib1),
     .last_bs_out(nc_last_bs_out_outclk0), .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi),
     .oclkb_aib(nc_out_rx_fast_clkb_aib1), .jtag_clkdr_in(clkdr_xr7l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_inpclk1),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_directoutclkp[1]), .oclkn(nc_rxoclk_clkp1),
     .iclkn(oclkn_clkn1), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xdirect_in1_1 (
     .idata1_in1_jtag_out(nc_idat1_inpdir1_1),
     .idata0_in1_jtag_out(nc_idat0_inpdir1_1),
     .async_dat_in1_jtag_out(nc_async_dat_inpdir1_1),
     .prev_io_shift_en(shift_en_inpclk0),
     .jtag_clkdr_outn(jtag_clkdr_outn_inpdir1_1),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .anlg_rstb(input_rstb),
     .pd_data_aib(ncdrx_pd_data_aib[3]), .oclk_out(ncdrx_oclk[3]),
     .oclkb_out(ncdrx_oclkb[3]), .odat0_out(ncdrx_odat0[3]),
     .odat1_out(ncdrx_odat1[3]), .odat_async_out(odirectin_data[3]),
     .pd_data_out(ncdrx_pd_data[3]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(vssl),
     .iclkin_dist_in1(vssl), .idata0_in0(vssl), .idata0_in1(vssl),
     .idata1_in0(vssl), .idata1_in1(vssl), .idataselb_in0(vssl),
     .idataselb_in1(vssl), .iddren_in0(vssl), .iddren_in1(vssl),
     .ilaunch_clk_in0(vssl), .ilaunch_clk_in1(vssl),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0({vssl, vssl}), .indrv_in1({vssl,
     vssl}), .ipdrv_in0({vssl, vssl}), .ipdrv_in1({vssl, vssl}),
     .irxen_in0(irxen_r2[2:0]), .irxen_in1(irxen_inpclk0[2:0]),
     .istrbclk_in0(vssl), .istrbclk_in1(vssl), .itxen_in0(vssl),
     .itxen_in1(vssl), .oclk_in1(vssl),
     .odat_async_aib(ncdrx_odat_async_aib[3]), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(vssl), .vccl(vccl), .odat1_in1(vssl),
     .odat_async_in1(odat_async_aib_vinp10),
     .shift_en(rshift_en_drx[3]), .pd_data_in1(vssl),
     .dig_rstb(input_rstb), .jtag_clkdr_out(jtag_clkdr_inpdir1_1),
     .vcc(vcc), .odat1_aib(ncdrx_odat1_aib[3]),
     .jtag_rx_scan_out(jtag_rx_scan_inpdir1_1),
     .odat0_aib(ncdrx_odat0_aib[3]), .oclk_aib(oclk_aib_inpdir1_1),
     .last_bs_out(nc_last_bs_out_inpdir1_1),
     .por_aib_vccl(por_aib_vccl), .por_aib_vcchssi(por_aib_vcchssi),
     .oclkb_aib(oclkb_aib_inpdir1_1), .jtag_clkdr_in(clkdr_xr5l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_inpclk0),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_direct_input[3]), .oclkn(ncdrx_oclkn[3]),
     .iclkn(oclkn_inpdir2_1), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_rxdat_mimic x1059 ( .vss_aibcr(vssl), .vcc_aibcr(vcc),
     .odat_out(pcs_clk), .odat_in(pcs_clk_int));
aibcr3_clktree_pcs  clktree_pcs ( //.vcc_aibcr(vcc), .vss_aibcr(vssl),
     .lstrbclk_mimic2(clk_distclk), .lstrbclk_r_11(rx_distclk_r[11]),
     .lstrbclk_r_10(rx_distclk_r[10]), .lstrbclk_r_9(rx_distclk_r[9]),
     .lstrbclk_r_8(rx_distclk_r[8]), .lstrbclk_r_7(rx_distclk_r[7]),
     .lstrbclk_r_6(rx_distclk_r[6]), .lstrbclk_r_5(rx_distclk_r[5]),
     .lstrbclk_r_4(rx_distclk_r[4]), .lstrbclk_r_3(rx_distclk_r[3]),
     .lstrbclk_r_2(rx_distclk_r[2]), .lstrbclk_r_1(rx_distclk_r[1]),
     .lstrbclk_r_0(rx_distclk_r[0]), .lstrbclk_mimic1(nc_clk_mimic1),
     .lstrbclk_mimic0(nc_clk_mimic0), .lstrbclk_l_0(rx_distclk_l[0]),
     .lstrbclk_l_1(rx_distclk_l[1]), .lstrbclk_l_2(rx_distclk_l[2]),
     .lstrbclk_l_3(rx_distclk_l[3]), .lstrbclk_l_4(rx_distclk_l[4]),
     .lstrbclk_l_5(rx_distclk_l[5]), .lstrbclk_l_6(rx_distclk_l[6]),
     .lstrbclk_l_7(rx_distclk_l[7]), .lstrbclk_l_8(rx_distclk_l[8]),
     .lstrbclk_l_9(rx_distclk_l[9]), .lstrbclk_l_10(rx_distclk_l[10]),
     .lstrbclk_l_11(rx_distclk_l[11]), .lstrbclk_rep(clktree_pcs_clk),
     .clkin(clkin_pcs));
aibcr3_str_align x982 ( .scan_shift_n(idatdll_scan_shift_n),
     .rb_clkdiv_str(idatdll_rb_clkdiv_str[2:0]),
     .scan_rst_n(idatdll_scan_rst_n), .ref_clk_p(oclk_clkp),
     .lstrbclk_l_11(rx_strbclk_l[11]), 
     .lstrbclk_l_10(rx_strbclk_l[10]),
     .odll_dll2core_str(odll_dll2core[12:0]),
     .lstrbclk_l_9(rx_strbclk_l[9]), .lstrbclk_l_8(rx_strbclk_l[8]),
     .lstrbclk_l_7(rx_strbclk_l[7]), .lstrbclk_l_6(rx_strbclk_l[6]),
     .lstrbclk_l_5(rx_strbclk_l[5]), .lstrbclk_l_4(rx_strbclk_l[4]),
     .lstrbclk_l_3(rx_strbclk_l[3]), .lstrbclk_l_2(rx_strbclk_l[2]),
     .lstrbclk_l_1(rx_strbclk_l[1]), .lstrbclk_l_0(rx_strbclk_l[0]),
     .lstrbclk_r_0(rx_strbclk_r[0]), .lstrbclk_r_1(rx_strbclk_r[1]),
     .lstrbclk_r_2(rx_strbclk_r[2]),
     .idll_core2dll_str(oaibdftcore2dll[2:0]),
     .lstrbclk_r_3(rx_strbclk_r[3]), .idll_lock_req(idll_lock_req),
     .idll_entest_str(idatdll_entest_str),
     .lstrbclk_r_4(rx_strbclk_r[4]), .lstrbclk_r_5(rx_strbclk_r[5]),
     .lstrbclk_r_6(rx_strbclk_r[6]), .lstrbclk_r_7(rx_strbclk_r[7]),
     .lstrbclk_r_8(rx_strbclk_r[8]), .lstrbclk_r_9(rx_strbclk_r[9]),
     .lstrbclk_r_10(rx_strbclk_r[10]),
     .lstrbclk_r_11(rx_strbclk_r[11]),
     .scan_mode_n(idatdll_scan_mode_n),
     .pipeline_global_en(idatdll_pipeline_global_en),
     .scan_clk_in(idatdll_scan_clk_in), .scan_in(idatdll_scan_in),
     .scan_out(dll_scan_out), .csr_reg_str(csr_reg_str[51:0]),
     .odll_lock(odll_lock),
     .rb_half_code_str(idatdll_rb_half_code_str),
     .rb_selflock_str(idatdll_rb_selflock_str), .ref_clk_n(oclk_clkpb),
     .test_clk_pll_en_n(idatdll_test_clk_pll_en_n), .i_del_str_o(clk_postdll));

/* 
aibcr3_clkmux2 xclkmuxn ( .vssl(vssl), .vcc(vcc), .oclk_out(oclk_clkpb),
     .mux_sel(rshift_en_txferclkout), .oclk_in0(oclkb_aib_txferclkout),
     .oclk_in1(oclkb_aib_pin10));
aibcr3_clkmux2 xclkmuxp ( .vssl(vssl), .vcc(vcc), .oclk_out(oclk_clkp),
     .mux_sel(rshift_en_txferclkout), .oclk_in0(oclk_aib_txferclkout),
     .oclk_in1(oclk_aib_pin10));
*/

assign oclk_clkp = rshift_en_txferclkout? oclk_aib_pin10 : oclk_aib_txferclkout;
assign oclk_clkpb = rshift_en_txferclkout? oclkb_aib_pin10 : oclkb_aib_txferclkout;


assign oclk_clkp_buf = oclk_clkp;
assign oclk_clkpb_buf = oclk_clkpb;

assign nc_clk_mimic0b = !nc_clk_mimic0;
assign nc_clk_mimic1b = !nc_clk_mimic1;
assign nc_clk_distclkb = !clk_distclk;

endmodule

