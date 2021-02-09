// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3_lib, Cell - aibcr3_top, View - schematic
// LAST TIME SAVED: Sep  6 00:20:12 2016
// NETLIST TIME: Sep 13 21:47:08 2016
`timescale 1ns / 1ns 

module aibcr3_top ( jtag_clksel_out, jtag_intest_out, jtag_mode_out,
     jtag_rstb_en_out, jtag_rstb_out, jtag_tx_scanen_out,
     jtag_weakpdn_out, jtag_weakpu_out, oaibdftdll2adjch,
     oaibdftdll2core, oatpg_bsr0_scan_out, oatpg_bsr1_scan_out,
     oatpg_bsr2_scan_out, oatpg_bsr3_scan_out, oatpg_scan_out0,
     oatpg_scan_out1, odirectout_data_out_chain1,
     odirectout_data_out_chain2, ohssi_adapter_rx_pld_rst_n,
     ohssi_adapter_tx_pld_rst_n, ohssi_avmm1_data_in,
     ohssi_avmm2_data_in, ohssi_fsr_data_in, ohssi_fsr_load_in,
     ohssi_pcs_rx_pld_rst_n, ohssi_pcs_tx_pld_rst_n,
     ohssi_pld_pma_coreclkin, ohssi_pld_pma_coreclkin_n,
     ohssi_pld_pma_rxpma_rstb, ohssi_pld_pma_txdetectrx,
     ohssi_pld_pma_txpma_rstb, ohssi_pld_sclk, ohssi_sr_clk_in,
     ohssi_ssr_data_in, ohssi_ssr_load_in, ohssi_tx_data_in,
     ohssi_tx_dcd_cal_done, ohssi_tx_dll_lock, ohssi_tx_sr_clk_in,
     ohssi_tx_transfer_clk, ohssirx_dcc_done, ojtag_clkdr_out_chain,
     ojtag_last_bs_out_chain, ojtag_rx_scan_out_chain,
     ored_idataselb_out_chain1, ored_idataselb_out_chain2,
     ored_shift_en_out_chain1, ored_shift_en_out_chain2, osc_clkout,
     oshared_direct_async_out, otxen_out_chain1, otxen_out_chain2,
     por_aib_vcchssi_out, por_aib_vccl_out, u_adapter_rx_pld_rst_n,
     u_adapter_tx_pld_rst_n, u_avmm1_data_in, u_avmm1_data_out,
     u_avmm2_data_in, u_avmm2_data_out, u_fpll_shared_direct_async_in,
     u_fpll_shared_direct_async_out, u_fsr_data_in, u_fsr_data_out,
     u_fsr_load_in, u_fsr_load_out, u_pcs_rx_pld_rst_n,
     u_pcs_tx_pld_rst_n, u_pld_8g_rxelecidle, u_pld_pcs_rx_clk_out,
     u_pld_pcs_rx_clk_out_n, u_pld_pcs_tx_clk_out,
     u_pld_pcs_tx_clk_out_n, u_pld_pma_clkdiv_rx_user,
     u_pld_pma_clkdiv_tx_user, u_pld_pma_coreclkin,
     u_pld_pma_coreclkin_n, u_pld_pma_hclk, u_pld_pma_internal_clk1,
     u_pld_pma_internal_clk2, u_pld_pma_pfdmode_lock,
     u_pld_pma_rxpll_lock, u_pld_pma_rxpma_rstb, u_pld_pma_txdetectrx,
     u_pld_pma_txpma_rstb, u_pld_rx_hssi_fifo_latency_pulse,
     u_pld_sclk, u_pld_tx_hssi_fifo_latency_pulse, u_pma_aib_tx_clk,
     u_pma_aib_tx_clk_n, u_rx_data_out, u_rx_transfer_clk,
     u_rx_transfer_clk_n, u_sr_clk_in, u_sr_clk_n_in, u_sr_clk_n_out,
     u_sr_clk_out, u_ssr_data_in, u_ssr_data_out, u_ssr_load_in,
     u_ssr_load_out, u_tx_data_in, u_tx_transfer_clk,
     u_tx_transfer_clk_n, vcc, vccl, vssl, iaibdftcore2dll,
     iaibdftdll2adjch, iatpg_bsr0_scan_in, iatpg_bsr0_scan_shift_clk,
     iatpg_bsr1_scan_in, iatpg_bsr1_scan_shift_clk, iatpg_bsr2_scan_in,
     iatpg_bsr2_scan_shift_clk, iatpg_bsr3_scan_in,
     iatpg_bsr3_scan_shift_clk, iatpg_bsr_scan_shift_n,
     iatpg_pipeline_global_en, iatpg_scan_clk_in0, iatpg_scan_clk_in1,
     iatpg_scan_in0, iatpg_scan_in1, iatpg_scan_mode_n,
     iatpg_scan_rst_n, iatpg_scan_shift_n, iavm1in_en0, iavm1in_en1,
     iavm1in_en2, iavm1out_dataselb, iavm1out_en, iavm2in_en0,
     iavm2out_dataselb, iavm2out_en, idatdll_test_clk_pll_en_n,
     idirectout_data_in_chain1, idirectout_data_in_chain2,
     ihssi_avmm1_data_out, ihssi_avmm2_data_out, ihssi_dcc_dft_nrst,
     ihssi_dcc_dft_nrst_coding, ihssi_dcc_dft_up,
     ihssi_dcc_dll_csr_reg, ihssi_dcc_dll_entest, ihssi_dcc_req,
     ihssi_fsr_data_out, ihssi_fsr_load_out, ihssi_pld_8g_rxelecidle,
     ihssi_pld_pcs_rx_clk_out, ihssi_pld_pcs_rx_clk_out_n,
     ihssi_pld_pcs_tx_clk_out, ihssi_pld_pma_clkdiv_rx_user,
     ihssi_pld_pma_clkdiv_tx_user, ihssi_pld_pma_hclk,
     ihssi_pld_pma_internal_clk1, ihssi_pld_pma_internal_clk2,
     ihssi_pld_pma_pfdmode_lock, ihssi_pld_pma_rxpll_lock,
     ihssi_pld_rx_hssi_fifo_latency_pulse,
     ihssi_pld_tx_hssi_fifo_latency_pulse, ihssi_pma_aib_tx_clk,
     ihssi_rb_clkdiv, ihssi_rb_dcc_byp, ihssi_rb_dcc_byp_dprio,
     ihssi_rb_dcc_dft, ihssi_rb_dcc_dft_sel, ihssi_rb_dcc_en,
     ihssi_rb_dcc_en_dprio, ihssi_rb_dcc_manual_dn,
     ihssi_rb_dcc_manual_mode, ihssi_rb_dcc_manual_mode_dprio,
     ihssi_rb_dcc_manual_up, ihssi_rb_half_code, ihssi_rb_selflock,
     ihssi_rx_data_out, ihssi_rx_transfer_clk, ihssi_sr_clk_out,
     ihssi_ssr_data_out, ihssi_ssr_load_out, ihssi_tx_dcd_cal_req,
     ihssi_tx_dll_lock_req, ihssirx_async_en, ihssirx_clk_en,
     ihssirx_out_dataselb, ihssirx_out_ddren, ihssirx_out_en,
     ihssitx_in_en0, ihssitx_in_en1, ihssitx_in_en2, ihssitx_in_en3,
     ihssitx_out_dataselb, ihssitx_out_en, ihssitxdll_rb_clkdiv_str,
     ihssitxdll_rb_half_code_str, ihssitxdll_rb_selflock_str,
     ihssitxdll_str_align_dly_pst,
     ihssitxdll_str_align_dyconfig_ctl_static,
     ihssitxdll_str_align_dyconfig_ctlsel, ihssitxdll_str_align_entest,
     ihssitxdll_str_align_stconfig_core_dn_prgmnvrt,
     ihssitxdll_str_align_stconfig_core_up_prgmnvrt,
     ihssitxdll_str_align_stconfig_core_updnen,
     ihssitxdll_str_align_stconfig_dftmuxsel,
     ihssitxdll_str_align_stconfig_dll_en,
     ihssitxdll_str_align_stconfig_dll_rst_en,
     ihssitxdll_str_align_stconfig_hps_ctrl_en,
     ihssitxdll_str_align_stconfig_ndllrst_prgmnvrt,
     ihssitxdll_str_align_stconfig_new_dll,
     ihssitxdll_str_align_stconfig_spare, ijtag_clkdr_in_chain,
     ijtag_last_bs_in_chain, ijtag_tx_scan_in_chain, indrv_r12,
     indrv_r34, indrv_r56, indrv_r78, ipdrv_r12, ipdrv_r34, ipdrv_r56,
     ipdrv_r78, ired_avm1_shift_en, ired_idataselb_in_chain1,
     ired_idataselb_in_chain2, ired_rshift_en_dirclkn,
     ired_rshift_en_dirclkp, ired_rshift_en_drx, ired_rshift_en_dtx,
     ired_rshift_en_pinp, ired_rshift_en_rx, ired_rshift_en_rx_avmm2,
     ired_rshift_en_tx, ired_rshift_en_tx_avmm2,
     ired_rshift_en_txferclkout, ired_rshift_en_txferclkoutn,
     ired_rx_shift_en, ired_shift_en_in_chain1,
     ired_shift_en_in_chain2, irstb, ishared_direct_async_in,
     itxen_in_chain1, itxen_in_chain2, jtag_clksel, jtag_intest,
     jtag_mode_in, jtag_rstb, jtag_rstb_en, jtag_tx_scanen_in,
     jtag_weakpdn, jtag_weakpu, osc_clkin, por_aib_vcchssi,
     por_aib_vccl, rb_dcc_dll_dft_sel, rb_dcc_test_clk_pll_en_n,
     rb_dft_ch_muxsel );

output  jtag_clksel_out, jtag_intest_out, jtag_mode_out,
     jtag_rstb_en_out, jtag_rstb_out, jtag_tx_scanen_out,
     jtag_weakpdn_out, jtag_weakpu_out, oatpg_bsr0_scan_out,
     oatpg_bsr1_scan_out, oatpg_bsr2_scan_out, oatpg_bsr3_scan_out,
     oatpg_scan_out0, oatpg_scan_out1, odirectout_data_out_chain1,
     odirectout_data_out_chain2, ohssi_adapter_rx_pld_rst_n,
     ohssi_adapter_tx_pld_rst_n, ohssi_fsr_data_in, ohssi_fsr_load_in,
     ohssi_pcs_rx_pld_rst_n, ohssi_pcs_tx_pld_rst_n,
     ohssi_pld_pma_coreclkin, ohssi_pld_pma_coreclkin_n,
     ohssi_pld_pma_rxpma_rstb, ohssi_pld_pma_txdetectrx,
     ohssi_pld_pma_txpma_rstb, ohssi_pld_sclk, ohssi_sr_clk_in,
     ohssi_ssr_data_in, ohssi_ssr_load_in, ohssi_tx_dcd_cal_done,
     ohssi_tx_dll_lock, ohssi_tx_sr_clk_in, ohssi_tx_transfer_clk,
     ohssirx_dcc_done, ojtag_clkdr_out_chain, ojtag_last_bs_out_chain,
     ojtag_rx_scan_out_chain, ored_idataselb_out_chain1,
     ored_idataselb_out_chain2, ored_shift_en_out_chain1,
     ored_shift_en_out_chain2, osc_clkout, otxen_out_chain1,
     otxen_out_chain2, por_aib_vcchssi_out, por_aib_vccl_out;

inout  u_adapter_rx_pld_rst_n, u_adapter_tx_pld_rst_n,
     u_avmm1_data_out, u_avmm2_data_out, u_fsr_data_in, u_fsr_data_out,
     u_fsr_load_in, u_fsr_load_out, u_pcs_rx_pld_rst_n,
     u_pcs_tx_pld_rst_n, u_pld_8g_rxelecidle, u_pld_pcs_rx_clk_out,
     u_pld_pcs_rx_clk_out_n, u_pld_pcs_tx_clk_out,
     u_pld_pcs_tx_clk_out_n, u_pld_pma_clkdiv_rx_user,
     u_pld_pma_clkdiv_tx_user, u_pld_pma_coreclkin,
     u_pld_pma_coreclkin_n, u_pld_pma_hclk, u_pld_pma_internal_clk1,
     u_pld_pma_internal_clk2, u_pld_pma_pfdmode_lock,
     u_pld_pma_rxpll_lock, u_pld_pma_rxpma_rstb, u_pld_pma_txdetectrx,
     u_pld_pma_txpma_rstb, u_pld_rx_hssi_fifo_latency_pulse,
     u_pld_sclk, u_pld_tx_hssi_fifo_latency_pulse, u_pma_aib_tx_clk,
     u_pma_aib_tx_clk_n, u_rx_transfer_clk, u_rx_transfer_clk_n,
     u_sr_clk_in, u_sr_clk_n_in, u_sr_clk_n_out, u_sr_clk_out,
     u_ssr_data_in, u_ssr_data_out, u_ssr_load_in, u_ssr_load_out,
     u_tx_transfer_clk, u_tx_transfer_clk_n, vcc, vccl, vssl;

input  iatpg_bsr0_scan_in, iatpg_bsr0_scan_shift_clk,
     iatpg_bsr1_scan_in, iatpg_bsr1_scan_shift_clk, iatpg_bsr2_scan_in,
     iatpg_bsr2_scan_shift_clk, iatpg_bsr3_scan_in,
     iatpg_bsr3_scan_shift_clk, iatpg_bsr_scan_shift_n,
     iatpg_pipeline_global_en, iatpg_scan_clk_in0, iatpg_scan_clk_in1,
     iatpg_scan_in0, iatpg_scan_in1, iatpg_scan_mode_n,
     iatpg_scan_rst_n, iatpg_scan_shift_n, iavm2out_dataselb,
     iavm2out_en, idatdll_test_clk_pll_en_n, idirectout_data_in_chain1,
     idirectout_data_in_chain2, ihssi_avmm1_data_out,
     ihssi_avmm2_data_out, ihssi_dcc_dft_nrst,
     ihssi_dcc_dft_nrst_coding, ihssi_dcc_dft_up, ihssi_dcc_dll_entest,
     ihssi_dcc_req, ihssi_fsr_data_out, ihssi_fsr_load_out,
     ihssi_pld_8g_rxelecidle, ihssi_pld_pcs_rx_clk_out,
     ihssi_pld_pcs_rx_clk_out_n, ihssi_pld_pcs_tx_clk_out,
     ihssi_pld_pma_clkdiv_rx_user, ihssi_pld_pma_clkdiv_tx_user,
     ihssi_pld_pma_hclk, ihssi_pld_pma_internal_clk1,
     ihssi_pld_pma_internal_clk2, ihssi_pld_pma_pfdmode_lock,
     ihssi_pld_pma_rxpll_lock, ihssi_pld_rx_hssi_fifo_latency_pulse,
     ihssi_pld_tx_hssi_fifo_latency_pulse, ihssi_pma_aib_tx_clk,
     ihssi_rb_dcc_byp, ihssi_rb_dcc_byp_dprio, ihssi_rb_dcc_dft,
     ihssi_rb_dcc_dft_sel, ihssi_rb_dcc_en, ihssi_rb_dcc_en_dprio,
     ihssi_rb_dcc_manual_mode, ihssi_rb_dcc_manual_mode_dprio,
     ihssi_rb_half_code, ihssi_rb_selflock, ihssi_rx_transfer_clk,
     ihssi_sr_clk_out, ihssi_ssr_data_out, ihssi_ssr_load_out,
     ihssi_tx_dcd_cal_req, ihssi_tx_dll_lock_req,
     ihssitxdll_rb_half_code_str, ihssitxdll_rb_selflock_str,
     ihssitxdll_str_align_dyconfig_ctlsel, ihssitxdll_str_align_entest,
     ihssitxdll_str_align_stconfig_core_dn_prgmnvrt,
     ihssitxdll_str_align_stconfig_core_up_prgmnvrt,
     ihssitxdll_str_align_stconfig_core_updnen,
     ihssitxdll_str_align_stconfig_dll_en,
     ihssitxdll_str_align_stconfig_dll_rst_en,
     ihssitxdll_str_align_stconfig_hps_ctrl_en,
     ihssitxdll_str_align_stconfig_ndllrst_prgmnvrt,
     ihssitxdll_str_align_stconfig_spare, ijtag_clkdr_in_chain,
     ijtag_last_bs_in_chain, ijtag_tx_scan_in_chain,
     ired_idataselb_in_chain1, ired_idataselb_in_chain2,
     ired_rshift_en_tx_avmm2, ired_rshift_en_txferclkout,
     ired_rshift_en_txferclkoutn, ired_shift_en_in_chain1,
     ired_shift_en_in_chain2, irstb, itxen_in_chain1, itxen_in_chain2,
     jtag_clksel, jtag_intest, jtag_mode_in, jtag_rstb, jtag_rstb_en,
     jtag_tx_scanen_in, jtag_weakpdn, jtag_weakpu, osc_clkin,
     por_aib_vcchssi, por_aib_vccl, rb_dcc_dll_dft_sel,
     rb_dcc_test_clk_pll_en_n, rb_dft_ch_muxsel;

output [1:0]  ohssi_avmm2_data_in;
output [2:0]  oshared_direct_async_out;
output [39:0]  ohssi_tx_data_in;
output [1:0]  ohssi_avmm1_data_in;
output [12:0]  oaibdftdll2adjch;
output [12:0]  oaibdftdll2core;

inout [1:0]  u_avmm1_data_in;
inout [2:0]  u_fpll_shared_direct_async_in;
inout [1:0]  u_avmm2_data_in;
inout [19:0]  u_rx_data_out;
inout [4:0]  u_fpll_shared_direct_async_out;
inout [19:0]  u_tx_data_in;

input [2:0]  ihssitxdll_rb_clkdiv_str;
input [1:0]  indrv_r34;
input [2:0]  ihssitx_out_en;
input [1:0]  ired_rshift_en_dirclkp;
input [2:0]  ired_rshift_en_dtx;
input [1:0]  indrv_r12;
input [2:0]  ihssirx_async_en;
input [2:0]  ihssitx_in_en2;
input [2:0]  ihssitx_in_en3;
input [2:0]  ihssitx_out_dataselb;
input [2:0]  iavm1out_en;
input [1:0]  indrv_r56;
input [4:0]  ishared_direct_async_in;
input [2:0]  ihssitx_in_en0;
input [1:0]  ipdrv_r34;
input [19:0]  ired_rshift_en_pinp;
input [39:0]  ihssi_rx_data_out;
input [2:0]  iavm1in_en0;
input [2:0]  ihssitx_in_en1;
input [1:0]  ihssirx_out_ddren;
input [2:0]  ihssi_rb_clkdiv;
input [2:0]  iavm1in_en2;
input [2:0]  ihssirx_out_dataselb;
input [2:0]  ihssitxdll_str_align_stconfig_new_dll;
input [51:0]  ihssi_dcc_dll_csr_reg;
input [1:0]  ired_rshift_en_dirclkn;
input [3:0]  ired_rshift_en_drx;
input [1:0]  ipdrv_r12;
input [14:0]  ired_avm1_shift_en;
input [2:0]  iavm2in_en0;
input [3:0]  ired_rshift_en_tx;
input [4:0]  ihssi_rb_dcc_manual_up;
input [19:0]  ihssitxdll_str_align_stconfig_dftmuxsel;
input [1:0]  ired_rshift_en_rx_avmm2;
input [9:0]  ihssitxdll_str_align_dly_pst;
input [2:0]  iaibdftcore2dll;
input [2:0]  iavm1out_dataselb;
input [3:0]  ired_rshift_en_rx;
input [1:0]  indrv_r78;
input [1:0]  ipdrv_r56;
input [1:0]  ipdrv_r78;
input [9:0]  ihssitxdll_str_align_dyconfig_ctl_static;
input [2:0]  iavm1in_en1;
input [4:0]  ihssi_rb_dcc_manual_dn;
input [2:0]  ihssirx_clk_en;
input [36:0]  ired_rx_shift_en;
input [12:0]  iaibdftdll2adjch;
input [3:0]  ihssirx_out_en;

// Buses in the design

wire  [2:0]  irxen_inpdir1_1;

wire  [2:0]  irxen_inpdir2_1;

wire  [2:0]  irxen_vinp10;

wire  [2:0]  irxen_pinp18;

wire  [2:0]  oaibdftcore2dcc;

wire  [2:0]  oshared_direct_async_out_in;

wire  [1:0]  ipdrv_r34_out;

wire  [2:0]  irxen_inpclk0;

wire  [2:0]  irxen_inpdir0_1;

wire  [36:0]  ired_rx_shift_en_outbuf;

wire  [1:0]  ipdrv_r12_out;

wire  [1:0]  indrv_r56_out;

wire  [1:0]  indrv_r34_out;

wire  [1:0]  indrv_r12_out;

wire  [1:0]  ipdrv_r56_out;

wire  [2:0]  irxen_inpclk1;

wire  [1:0]  ohssi_avmm2_data_in_aib;

wire  [1:0]  nc_avmm2_odat1;

wire  [1:0]  indrv_r78_out;

wire  [1:0]  ipdrv_r78_out;

wire  [2:0]  iavm2in_en0_out;

wire  [12:0]  oaibdftdll2core_in;

wire  [12:0]  idcc_dll2core;

wire  [2:0]  irxen_vinp11;

wire  [1:0]  ired_rshift_en_rx_avmm2_out;

wire  [2:0]  iavm1in_en0_out;

wire  [2:0]  iavm1in_en1_out;

wire  [2:0]  iavm1in_en2_out;

wire  [1:0]  ohssi_avmm1_data_in_aib;

wire  [1:0]  nc_avmm1_odat1;

wire  [3:0]  nc_sdr_odat1;

wire  [2:0]  iavm1out_dataselb_out;

wire  [2:0]  iavm1out_en_out;

wire  [2:0]  irxen_ssrdin;

wire  [2:0]  irxen_ssrldin;

wire  [19:0]  ired_rshift_en_pinp_out;

wire  [1:0]  indrv_ptxclkout;

wire  [1:0]  indrv_ptxclkoutn;

wire  [1:0]  ipdrv_ptxclkout;

wire  [1:0]  ipdrv_ptxclkoutn;

wire  [2:0]  irxen_inpshared2;

wire  [14:0]  ired_avm1_shift_en_out;

wire  [2:0]  irxen_vinp00;

wire  [2:0]  irxen_vinp01;

wire  [51:0]  ihssi_dcc_dll_csr_reg_out;

wire  [39:0]  ihssi_rx_data_out_buf;

wire  [4:0]  ihssi_rb_dcc_manual_up_out;

wire  [2:0]  ihssi_rb_clkdiv_out;

wire  [39:0]  ihssi_rx_data_out_dly;

wire  [4:0]  ihssi_rb_dcc_manual_dn_out;

wire  [2:0]  ihssirx_async_en_out;

wire  [2:0]  ihssirx_clk_en_out;

wire  [1:0]  ihssirx_out_ddren_out;

wire  [2:0]  ihssirx_out_dataselb_out;

wire  [3:0]  ihssirx_out_en_out;

wire  [2:0]  ihssitx_in_en0_out;

wire  [2:0]  ihssitx_in_en1_out;

wire  [9:0]  ihssitxdll_str_align_dyconfig_ctl_static_out;

wire  [9:0]  ihssitxdll_str_align_dly_pst_out;

wire  [19:0]  ihssitxdll_str_align_stconfig_dftmuxsel_out;

wire  [2:0]  ihssitxdll_str_align_stconfig_new_dll_out;

wire  [1:0]  ired_rshift_en_dirclkn_out;

wire  [3:0]  ired_rshift_en_drx_out;

wire  [1:0]  ired_rshift_en_dirclkp_out;

wire  [2:0]  ihssitx_in_en2_out;

wire  [2:0]  ihssitx_in_en3_out;

wire  [2:0]  ired_rshift_en_dtx_out;

wire  [2:0]  ihssitx_out_dataselb_out;

wire  [2:0]  ihssitx_out_en_out;

wire  [2:0]  ihssitxdll_rb_clkdiv_str_out;

wire  [2:0]  iaibdftcore2dll_out;

wire  [4:0]  ishared_direct_async_in_out;

wire  [3:0]  ired_rshift_en_rx_out;

wire  [3:0]  ired_rshift_en_tx_out;

wire  [2:0]  irxen_inpdir6_1;

wire  [39:0]  ohssi_tx_data_in_aib;


aibcr3_txdatapath_tx xtxdatapath_tx ( scan_out_seg2,
     async_dat_oshared4, async_dat_outpclk3, async_dat_outpdir3,
     ohssi_tx_dcd_cal_done_in, iclkin_dist_pinp18, idat0_oshared0,
     idat0_outclk0n, idat1_oshared0, idat1_outclk0n, idata0_ptxclkout,
     idata0_ptxclkoutn, idata1_ptxclkout, idata1_ptxclkoutn,
     idataselb_oshared0, idataselb_oshared4,
     ored_idataselb_out_chain1_inbuf, idataselb_outclk0n,
     idataselb_outpclk3, idataselb_outpdir3, idataselb_ptxclkout,
     idataselb_ptxclkoutn, odirectout_data_out_chain1,
     ilaunch_clk_oshared0, ilaunch_clk_outclk0n, ilaunch_clk_ptxclkout,
     ilaunch_clk_ptxclkoutn, indrv_ptxclkout[1:0],
     indrv_ptxclkoutn[1:0], ipdrv_ptxclkout[1:0],
     ipdrv_ptxclkoutn[1:0], irxen_inpdir1_1[2:0], irxen_inpdir6_1[2:0],
     irxen_inpshared2[2:0], irxen_pinp18[2:0], istrbclk_pinp18,
     itxen_oshared0, itxen_oshared4, otxen_out_chain1_inbuf,
     itxen_outclk0n, itxen_outpclk3, itxen_outpdir3, itxen_ptxclkout,
     itxen_ptxclkoutn, jtag_clkdr_inpdir1_1, jtag_clkdr_inpdir6_1,
     jtag_clkdr_inpshared2, jtag_clkdr_oshared0, jtag_clkdr_oshared4,
     nc_jtag_clkdr_int, jtag_clkdr_outclk0n, jtag_clkdr_outpclk3,
     jtag_clkdr_outpdir3, jtag_clkdr_pinp18, jtag_clkdr_ptxclkout,
     jtag_clkdr_ptxclkoutn, jtag_rx_scan_inpdir1_1,
     jtag_rx_scan_inpdir6_1, jtag_rx_scan_inpshared2,
     jtag_rx_scan_oshared0, jtag_rx_scan_oshared4, jtag_scan_outclk0n,
     jtag_rx_scan_outpclk3, jtag_rx_scan_outpdir3, jtag_rx_scan_pinp18,
     jtag_rx_scan_ptxclkout, jtag_rx_scan_ptxclkoutn, scan_out_seg1,
     oaibdftcore2dcc[2:0], oaibdftdll2adjch[12:0],
     oaibdftdll2core_in[12:0], oclk_aib_inpdir1_1, oclkb_aib_inpdir1_1,
     odat0_oshared2, odat0_oshared3, odat0_ptxclkout, odat0_ptxclkoutn,
     odat1_oshared2, odat1_oshared3, odat1_ptxclkout, odat1_ptxclkoutn,
     oshared_direct_async_out_in[2:0], odat_async_outclk0,
     odat_async_outclk0n, {ohssi_pcs_tx_pld_rst_n_in,
     ohssi_adapter_tx_pld_rst_n_in, ohssi_pld_pma_txdetectrx_in,
     ohssi_pld_pma_txpma_rstb_in}, ohssi_tx_dll_lock_in,
     ohssi_tx_transfer_clk_in, {ohssi_tx_data_in_aib[38],
     ohssi_tx_data_in_aib[36], ohssi_tx_data_in_aib[34],
     ohssi_tx_data_in_aib[32], ohssi_tx_data_in_aib[30],
     ohssi_tx_data_in_aib[28], ohssi_tx_data_in_aib[26],
     ohssi_tx_data_in_aib[24], ohssi_tx_data_in_aib[22],
     ohssi_tx_data_in_aib[20], ohssi_tx_data_in_aib[18],
     ohssi_tx_data_in_aib[16], ohssi_tx_data_in_aib[14],
     ohssi_tx_data_in_aib[12], ohssi_tx_data_in_aib[10],
     ohssi_tx_data_in_aib[8], ohssi_tx_data_in_aib[6],
     ohssi_tx_data_in_aib[4], ohssi_tx_data_in_aib[2],
     ohssi_tx_data_in_aib[0]}, {ohssi_tx_data_in_aib[39],
     ohssi_tx_data_in_aib[37], ohssi_tx_data_in_aib[35],
     ohssi_tx_data_in_aib[33], ohssi_tx_data_in_aib[31],
     ohssi_tx_data_in_aib[29], ohssi_tx_data_in_aib[27],
     ohssi_tx_data_in_aib[25], ohssi_tx_data_in_aib[23],
     ohssi_tx_data_in_aib[21], ohssi_tx_data_in_aib[19],
     ohssi_tx_data_in_aib[17], ohssi_tx_data_in_aib[15],
     ohssi_tx_data_in_aib[13], ohssi_tx_data_in_aib[11],
     ohssi_tx_data_in_aib[9], ohssi_tx_data_in_aib[7],
     ohssi_tx_data_in_aib[5], ohssi_tx_data_in_aib[3],
     ohssi_tx_data_in_aib[1]}, oatpg_scan_out1_in, shift_en_inpdir1_1,
     shift_en_inpdir6_1, shift_en_inpshared2, shift_en_oshared0,
     shift_en_oshared4, ored_shift_en_out_chain1, shift_en_outclk0n,
     shift_en_outpclk3, shift_en_outpdir3, shift_en_pinp18,
     shift_en_ptxclkout, shift_en_ptxclkoutn,
     u_fpll_shared_direct_async_in[2:0],
     u_fpll_shared_direct_async_out[4:0], u_tx_transfer_clk_n,
     u_tx_transfer_clk, u_tx_data_in[19:0], {u_pcs_tx_pld_rst_n,
     u_adapter_tx_pld_rst_n, u_pld_pma_txdetectrx,
     u_pld_pma_txpma_rstb}, {u_pld_pma_clkdiv_tx_user,
     u_pld_pma_pfdmode_lock, u_pld_tx_hssi_fifo_latency_pulse},
     {u_pld_pcs_tx_clk_out_n, u_pma_aib_tx_clk_n},
     {u_pld_pcs_tx_clk_out, u_pma_aib_tx_clk}, vcc, vccl, vssl,
     scan_in_seg3, async_dat_outpclk6, async_dat_outpdir2, /*net0462*/,
     clkdr_scan_seg1c_TX, /*net0461*/, /*net0460*/, clkdr_scan_seg1b_TX,
     clkdr_scan_seg1a_TX, clkdr_scan_seg3b_TX, clkdr_scan_seg3a_TX,
     clkdr_scan_seg0c_TX, clkdr_scan_seg0d_TX, clkdr_scan_seg2b_TX,
     clkdr_scan_seg2c_TX, clkdr_scan_seg0b_TX, clkdr_scan_seg0a_TX,
     clkdr_scan_seg2b_TX, clkdr_scan_seg2a_TX, dft_tx_clk,
     ihssi_tx_dcd_cal_req_out, iaibdftcore2dll_out[2:0],
     iaibdftdll2adjch[12:0], ishared_direct_async_in_out[4:0],
     iclkin_dist_ssrdin, iclkin_dist_ssrldin, iclkin_dist_vinp00,
     iclkin_dist_vinp01, {vcc, vcc}, {vssl, vssl}, idat0_outpclk1n,
     {vssl, vssl}, {vcc, vcc}, idat1_outpclk1n, idata0_poutp0,
     idata1_poutp0, ihssitx_out_dataselb_out[2:0],
     ired_idataselb_in_chain1_outbuf, idataselb_outpclk1n,
     idataselb_outpclk6, idataselb_outpdir2, idataselb_poutp0,
     ihssitxdll_str_align_entest_out, iatpg_pipeline_global_en_out,
     ihssitxdll_rb_clkdiv_str_out[2:0],
     ihssitxdll_rb_half_code_str_out, ihssitxdll_rb_selflock_str_out,
     iatpg_scan_clk_in1_out, iatpg_scan_in1_out, iatpg_scan_mode_n_out,
     iatpg_scan_rst_n_out, iatpg_scan_shift_n_out,
     ihssitxdll_str_align_dyconfig_ctl_static_out[9:0],
     ihssitxdll_str_align_dyconfig_ctlsel_out,
     ihssitxdll_str_align_stconfig_core_dn_prgmnvrt_out,
     ihssitxdll_str_align_stconfig_core_up_prgmnvrt_out,
     ihssitxdll_str_align_stconfig_core_updnen_out,
     ihssitxdll_str_align_stconfig_dftmuxsel_out[19:0],
     ihssitxdll_str_align_stconfig_dll_en_out,
     ihssitxdll_str_align_stconfig_dll_rst_en_out,
     ihssitxdll_str_align_stconfig_hps_ctrl_en_out,
     ihssitxdll_str_align_stconfig_ndllrst_prgmnvrt_out,
     ihssitxdll_str_align_stconfig_new_dll_out[2:0],
     {ihssitxdll_str_align_stconfig_spare_out,
     ihssitxdll_str_align_dly_pst_out[9:0]},
     idatdll_test_clk_pll_en_n_out, idcc_dll2core[12:0], iddren_poutp0,
     {ihssi_pld_pma_clkdiv_tx_user_out, ihssi_pld_pma_pfdmode_lock_out,
     ihssi_pld_tx_hssi_fifo_latency_pulse_out},
     idirectout_data_in_chain1_outbuf, ihssi_tx_dll_lock_req_out,
     ihssi_pld_pcs_rx_clk_out_buf, ilaunch_clk_poutp0,
     indrv_r12_out[1:0], indrv_r34_out[1:0], indrv_r56_out[1:0],
     indrv_r78_out[1:0], irstb_out, ipdrv_r12_out[1:0],
     ipdrv_r34_out[1:0], ipdrv_r56_out[1:0], ipdrv_r78_out[1:0],
     irxen_inpclk0[2:0], irxen_inpclk1[2:0], irxen_inpdir0_1[2:0],
     ihssitx_in_en0_out[2:0], ihssitx_in_en1_out[2:0],
     ihssitx_in_en2_out[2:0], ihssitx_in_en3_out[2:0],
     irxen_ssrdin[2:0], irxen_ssrldin[2:0], irxen_vinp00[2:0],
     irxen_vinp01[2:0], istrbclk_ssrdin, istrbclk_ssrldin,
     istrbclk_vinp00, istrbclk_vinp01, ihssitx_out_en_out[2:0],
     itxen_in_chain1_outbuf, itxen_outpclk1n, itxen_outpclk6,
     itxen_outpdir2, itxen_poutp0, vssl, jtag_clkdr_inpclk0,
     jtag_clkdr_inpclk1, jtag_clkdr_inpdir0_1, jtag_clkdr_out_poutp0,
     jtag_clkdr_outpclk1n, jtag_clkdr_outpclk6, jtag_clkdr_outpdir2,
     jtag_clkdr_ssrdin, jtag_clkdr_ssrldin, jtag_clkdr_vinp00,
     jtag_clkdr_vinp01, jtag_clksel_int, jtag_intest_int,
     jtag_mode_int, jtag_rstb_int, jtag_rstb_en_int,
     jtag_rx_scan_inpclk0, jtag_rx_scan_inpclk1,
     jtag_rx_scan_inpdir0_1, jtag_rx_scan_out_poutp0,
     jtag_scan_outpclk1n, jtag_scan_outpclk6, scan_in_seg1,
     jtag_rx_scan_ssrdin, jtag_rx_scan_ssrldin, jtag_rx_scan_vinp00,
     jtag_rx_scan_vinp01, scan_in_seg0, jtag_tx_scanen_out,
     jtag_weakpdn_int, jtag_weakpu_int, oclkn_aib_inpdir2_1,
     odat0_aib_inpdir5_1, odat1_aib_inpdir5_1, odat_async_aib_poutp19,
     odat_async_aib_vinp10, odat_async_fsrldout, irstb_out,
     por_aib_vcchssi_int, por_aib_vccl_int, rb_dcc_dll_dft_sel_out,
     rb_dft_ch_muxsel_out, ired_rshift_en_dirclkn_out[1:0],
     ired_rshift_en_dirclkp_out[1:0], ired_rshift_en_drx_out[3:0],
     ired_rshift_en_dtx_out[2:0], ired_rshift_en_pinp_out[19:0],
     ired_rshift_en_rx_out[3:0], ired_rshift_en_tx_out[3:0],
     ired_rshift_en_txferclkout_out, ired_rshift_en_txferclkoutn_out,
     ired_shift_en_in_chain1_outbuf, shift_en_inpclk0,
     shift_en_inpclk1, shift_en_inpdir0_1, shift_en_outpclk1n,
     shift_en_outpclk6, shift_en_outpdir2, shift_en_poutp0,
     shift_en_ssrdin, shift_en_ssrldin, shift_en_vinp00,
     shift_en_vinp01, {vssl, vssl}, {ihssi_pld_pcs_tx_clk_out_buf,
     ihssi_pma_aib_tx_clk_out});

wire clkdr_scan_seg0a_AVMM2 ;
wire clkdr_scan_seg2a_AVMM2 ;
wire clkdr_scan_seg2b_AVMM2 ;
wire clkdr_scan_seg3a_RX ;
wire clkdr_scan_seg3b_RX ;
wire net0384 ;
wire net0382 ;
wire clkdr_scan_seg2c_RX ;
wire clkdr_scan_seg2b_RX ;
wire clkdr_scan_seg2a_RX ;
wire clkdr_scan_seg1c_RX ;
wire clkdr_scan_seg2c_AVMM1 ;
wire clkdr_scan_seg2b_AVMM1 ;
wire clkdr_scan_seg2a_AVMM1 ;
wire ojtag_last_bs_out_chain ;
wire jtag_mode_out ;
wire jtag_rstb_en_out ;
wire jtag_mode_in_buf ;
wire jtag_rstb_out ;
wire jtag_weakpdn_out ;
wire jtag_weakpu_out ;
wire jtag_clksel_out ;
wire jtag_intest_out ;
wire por_aib_vcchssi_out ;
wire por_aib_vcchssi_buf ;
wire por_aib_vccl_out ;
wire por_aib_vcc_buf ;
wire ired_idataselb_in_chain2_outbuf ;
wire ored_idataselb_out_chain2 ;
wire otxen_out_chain2 ;
wire otxen_out_chain1 ;
wire ired_shift_en_in_chain2_outbuf ;
wire ored_idataselb_out_chain1 ;
wire itxen_in_chain2_outbuf ;
wire clkdr_scan_seg1a_RX ;
wire clkdr_scan_seg1b_RX ;
wire net0375 ;
wire net0377 ;
wire clkdr_scan_seg0a_RX ;
wire clkdr_scan_seg0b_RX ;
wire clkdr_scan_seg0c_RX ;
wire clkdr_scan_seg0b_AVMM1 ;
wire clkdr_scan_seg0c_AVMM1 ;
wire clkdr_scan_seg0a_AVMM1 ;
wire idirectout_data_in_chain2_outbuf ;
wire osc_clkinb ;
wire ohssi_tx_sr_clk_in ;
wire osc_clkout ;
wire iatpg_scan_shift_clk_seg3;
wire iatpg_scan_shift_clk_seg2;
wire atpg_scan_shift_clk_seg1;
wire ored_idataselb_out_chain2_inbuf;
wire otxen_out_chain2_inbuf;
wire iatpg_scan_shift_clk_seg0;
wire irstb_pre_out;
wire iatpg_scan_shift_clk_seg1;
wire clkdr_scan_seg0a1_AVMM1;

assign clkdr_scan_seg0a_AVMM2 = net0375;
assign clkdr_scan_seg2a_AVMM2 = net0382;
assign clkdr_scan_seg2b_AVMM2 = net0382;
assign clkdr_scan_seg3a_TX = iatpg_scan_shift_clk_seg3;
assign clkdr_scan_seg3b_TX = iatpg_scan_shift_clk_seg3;
assign clkdr_scan_seg3a_RX = iatpg_scan_shift_clk_seg3;
assign clkdr_scan_seg3b_RX = iatpg_scan_shift_clk_seg3;
assign net0384 = iatpg_scan_shift_clk_seg2;
assign net0382 = iatpg_scan_shift_clk_seg2;
assign clkdr_scan_seg2c_RX = net0382;
assign clkdr_scan_seg2b_RX = net0382;
assign clkdr_scan_seg2a_RX = net0382;
assign clkdr_scan_seg2b_TX = net0384;
assign clkdr_scan_seg2c_TX = net0384;
assign clkdr_scan_seg1c_RX = iatpg_scan_shift_clk_seg1;
assign clkdr_scan_seg2c_AVMM1 = net0384;
assign clkdr_scan_seg2a_TX = net0384;
assign clkdr_scan_seg2b_AVMM1 = net0384;
assign clkdr_scan_seg1a_TX = iatpg_scan_shift_clk_seg1;
assign clkdr_scan_seg2a_AVMM1 = net0384;
assign ojtag_last_bs_out_chain = ijtag_last_bs_in_chain;
assign jtag_mode_out = jtag_mode_int;
assign jtag_rstb_en_out = jtag_rstb_en_int;
assign jtag_mode_in_buf = jtag_mode_in;
assign jtag_rstb_int = jtag_rstb;
assign jtag_rstb_en_int = jtag_rstb_en;
assign jtag_rstb_out = jtag_rstb_int;
assign jtag_weakpdn_out = jtag_weakpdn_int;
assign jtag_weakpdn_int = jtag_weakpdn;
assign jtag_weakpu_out = jtag_weakpu_int;
assign jtag_weakpu_int = jtag_weakpu;
assign jtag_clksel_int = jtag_clksel;
assign jtag_clksel_out = jtag_clksel_int;
assign jtag_intest_out = jtag_intest_int;
assign jtag_intest_int = jtag_intest;
assign por_aib_vcchssi_out = por_aib_vcchssi_int;
assign por_aib_vcchssi_buf = por_aib_vcchssi;
assign por_aib_vccl_out = por_aib_vccl_int;
assign por_aib_vcc_buf = por_aib_vccl;
assign ired_idataselb_in_chain2_outbuf = ired_idataselb_in_chain2;
assign ored_idataselb_out_chain2 = ored_idataselb_out_chain2_inbuf;
assign otxen_out_chain2 = otxen_out_chain2_inbuf;
assign otxen_out_chain1 = otxen_out_chain1_inbuf;
assign itxen_in_chain1_outbuf = itxen_in_chain1;
assign ired_idataselb_in_chain1_outbuf = ired_idataselb_in_chain1;
assign ired_shift_en_in_chain2_outbuf = ired_shift_en_in_chain2;
assign ired_shift_en_in_chain1_outbuf = ired_shift_en_in_chain1;
assign ired_rx_shift_en_outbuf[36:0] = ired_rx_shift_en[36:0];
assign ored_idataselb_out_chain1 = ored_idataselb_out_chain1_inbuf;
assign itxen_in_chain2_outbuf = itxen_in_chain2;
assign clkdr_scan_seg1b_TX = iatpg_scan_shift_clk_seg1;
assign clkdr_scan_seg1c_TX = iatpg_scan_shift_clk_seg1;
assign clkdr_scan_seg1a_RX = iatpg_scan_shift_clk_seg1;
assign clkdr_scan_seg1b_RX = iatpg_scan_shift_clk_seg1;
assign net0375 = iatpg_scan_shift_clk_seg0;
assign net0377 = iatpg_scan_shift_clk_seg0;
assign clkdr_scan_seg0a_RX = net0375;
assign clkdr_scan_seg0b_RX = net0375;
assign clkdr_scan_seg0c_RX = net0375;
assign clkdr_scan_seg0b_AVMM1 = net0375;
assign clkdr_scan_seg0c_AVMM1 = net0375;
assign clkdr_scan_seg0a_AVMM1 = net0377;
assign clkdr_scan_seg0c_TX = net0377;
assign clkdr_scan_seg0b_TX = net0377;
assign clkdr_scan_seg0a_TX = net0377;
assign clkdr_scan_seg0d_TX = net0377;
assign net0450 = clkdr_scan_seg0a1_AVMM1;  
assign clkdr_scan_seg0a1_AVMM1 = net0377;

aibcr3_rxdatapath_rx xrxdatapath_rx ( async_dat_outpclk6, async_dat_outpdir2,
     ohssirx_dcc_done_in, dft_tx_clk, idat0_outpclk1n, idat1_outpclk1n,
     idata0_poutp0, idata1_poutp0, ored_idataselb_out_chain2_inbuf,
     idataselb_outpclk1n, idataselb_outpclk6, idataselb_outpdir2,
     idataselb_poutp0, iddren_poutp0, odirectout_data_out_chain2,
     ilaunch_clk_poutp0, irxen_inpclk0[2:0], irxen_inpclk1[2:0],
     irxen_inpdir0_1[2:0], irxen_inpdir2_1[2:0],
     otxen_out_chain2_inbuf, itxen_outpclk1n, itxen_outpclk6,
     itxen_outpdir2, itxen_poutp0, jtag_clkdr_inpclk0,
     jtag_clkdr_inpclk1, jtag_clkdr_inpdir0_1, jtag_clkdr_inpdir2_1,
     nc_jtag_clkdr_out_chain2, jtag_clkdr_out_poutp0,
     jtag_clkdr_outpclk1n, jtag_clkdr_outpclk6, jtag_clkdr_outpdir2,
     jtag_rx_scan_inpclk0, jtag_rx_scan_inpclk1,
     jtag_rx_scan_inpdir0_1, jtag_rx_scan_inpdir2_1, scan_out_seg3,
     jtag_rx_scan_out_poutp0, scan_out_seg0, jtag_scan_outpclk1n,
     jtag_scan_outpclk6, oclkn_aib_inpdir2_1, odat0_aib_inpdir5_1,
     odat1_aib_inpdir5_1, odat_async_aib_poutp19,
     {ohssi_pcs_rx_pld_rst_n_in, ohssi_adapter_rx_pld_rst_n_in,
     ohssi_pld_pma_rxpma_rstb_in, ohssi_pld_sclk_in},
     idcc_dll2core[12:0], ohssi_pld_pma_coreclkin_in,
     ohssi_pld_pma_coreclkin_n_in, oatpg_scan_out0_in,
     shift_en_inpclk0, shift_en_inpclk1, shift_en_inpdir0_1,
     shift_en_inpdir2_1, ored_shift_en_out_chain2, shift_en_outpclk1n,
     shift_en_outpclk6, shift_en_outpdir2, shift_en_poutp0,
     u_rx_transfer_clk_n, u_rx_transfer_clk, u_rx_data_out[19:0],
     {u_pcs_rx_pld_rst_n, u_adapter_rx_pld_rst_n, u_pld_pma_rxpma_rstb,
     u_pld_sclk}, u_pld_pma_coreclkin_n, u_pld_pma_coreclkin,
     {u_pld_pma_clkdiv_rx_user, u_pld_pma_internal_clk1,
     u_pld_pma_internal_clk2, u_pld_pma_hclk, u_pld_8g_rxelecidle,
     u_pld_pma_rxpll_lock, u_pld_rx_hssi_fifo_latency_pulse},
     u_pld_pcs_rx_clk_out_n, u_pld_pcs_rx_clk_out, async_dat_outpclk3,
     async_dat_outpdir3, clkdr_scan_seg1b_RX, clkdr_scan_seg1c_RX,
     clkdr_scan_seg3a_RX, clkdr_scan_seg3b_RX, clkdr_scan_seg1a_RX,
     /*net0518*/, /*net0517*/, /*net0516*/, clkdr_scan_seg0b_RX,
     clkdr_scan_seg0c_RX, clkdr_scan_seg2c_RX, /*net0515*/,
     clkdr_scan_seg0a_RX, /*net0514*/, clkdr_scan_seg2b_RX,
     clkdr_scan_seg2a_RX, ihssi_dcc_dll_csr_reg_out[51:0],
     ihssi_dcc_dft_nrst_out, ihssi_dcc_dft_nrst_coding_out,
     ihssi_dcc_dft_up_out, ihssi_dcc_req_out,
     ihssitxdll_str_align_dly_pst_out[0], iclkin_dist_pinp18,
     {ihssi_rx_data_out_buf[38], ihssi_rx_data_out_buf[36],
     ihssi_rx_data_out_buf[34], ihssi_rx_data_out_buf[32],
     ihssi_rx_data_out_buf[30], ihssi_rx_data_out_buf[28],
     ihssi_rx_data_out_buf[26], ihssi_rx_data_out_buf[24],
     ihssi_rx_data_out_buf[22], ihssi_rx_data_out_buf[20],
     ihssi_rx_data_out_buf[18], ihssi_rx_data_out_buf[16],
     ihssi_rx_data_out_buf[14], ihssi_rx_data_out_buf[12],
     ihssi_rx_data_out_buf[10], ihssi_rx_data_out_buf[8],
     ihssi_rx_data_out_buf[6], ihssi_rx_data_out_buf[4],
     ihssi_rx_data_out_buf[2], ihssi_rx_data_out_buf[0]}, vcc, vssl,
     vcc, vssl, idat0_oshared0, idat0_outclk0n,
     {ihssi_rx_data_out_buf[39], ihssi_rx_data_out_buf[37],
     ihssi_rx_data_out_buf[35], ihssi_rx_data_out_buf[33],
     ihssi_rx_data_out_buf[31], ihssi_rx_data_out_buf[29],
     ihssi_rx_data_out_buf[27], ihssi_rx_data_out_buf[25],
     ihssi_rx_data_out_buf[23], ihssi_rx_data_out_buf[21],
     ihssi_rx_data_out_buf[19], ihssi_rx_data_out_buf[17],
     ihssi_rx_data_out_buf[15], ihssi_rx_data_out_buf[13],
     ihssi_rx_data_out_buf[11], ihssi_rx_data_out_buf[9],
     ihssi_rx_data_out_buf[7], ihssi_rx_data_out_buf[5],
     ihssi_rx_data_out_buf[3], ihssi_rx_data_out_buf[1]}, vssl, vcc,
     vssl, vcc, idat1_oshared0, idat1_outclk0n, idata0_voutp0,
     idata0_voutp1, idata1_voutp0, idata1_voutp1,
     ihssirx_out_dataselb_out[2:0], ired_idataselb_in_chain2_outbuf,
     idataselb_oshared0, idataselb_outclk0n, idataselb_outpclk3,
     idataselb_outpdir3, idataselb_voutp0, idataselb_voutp1,
     ihssirx_out_ddren_out[1:0], {ihssi_pld_pma_clkdiv_rx_user_out,
     ihssi_pld_pma_internal_clk1_out, ihssi_pld_pma_internal_clk2_out,
     ihssi_pld_pma_hclk_out, ihssi_pld_8g_rxelecidle_out,
     ihssi_pld_pma_rxpll_lock_out,
     ihssi_pld_rx_hssi_fifo_latency_pulse_out},
     idirectout_data_in_chain2_outbuf, oaibdftcore2dcc[2:0],
     ihssi_dcc_dll_entest_out, ilaunch_clk_oshared0,
     ilaunch_clk_outclk0n, ilaunch_clk_voutp0, ilaunch_clk_voutp1,
     indrv_r12_out[1:0], indrv_r56_out[1:0], indrv_r78_out[1:0],
     ipdrv_r12_out[1:0], ipdrv_r56_out[1:0], ipdrv_r78_out[1:0],
     irxen_inpdir6_1[2:0], irxen_pinp18[2:0], ihssirx_clk_en_out[2:0],
     ihssirx_async_en_out[2:0], istrbclk_pinp18,
     ihssirx_out_en_out[3:0], itxen_in_chain2_outbuf, itxen_oshared0,
     itxen_outclk0n, itxen_outpclk3, itxen_outpdir3, itxen_voutp0,
     itxen_voutp1, vssl, jtag_clkdr_inpdir6_1, jtag_clkdr_oshared0,
     jtag_clkdr_outclk0n, jtag_clkdr_outpclk3, jtag_clkdr_outpdir3,
     jtag_clkdr_pinp18, jtag_clkdr_voutp0, jtag_clkdr_voutp1,
     jtag_clksel_int, jtag_intest_int, jtag_mode_int, jtag_rstb_int,
     jtag_rstb_en_int, scan_in_seg2, jtag_rx_scan_inpdir6_1,
     jtag_rx_scan_oshared0, jtag_rx_scan_outpclk3,
     jtag_rx_scan_outpdir3, jtag_rx_scan_pinp18, jtag_rx_scan_voutp0,
     jtag_rx_scan_voutp1, jtag_scan_outclk0n, jtag_tx_scanen_out,
     jtag_weakpdn_int, jtag_weakpu_int, oclk_aib_inpdir1_1,
     oclkb_aib_inpdir1_1, odat_async_aib_vinp11, odat_async_outclk0,
     odat_async_outclk0n, ihssi_rx_transfer_clk_out, irstb_out,
     iatpg_pipeline_global_en_out, por_aib_vcchssi_int,
     por_aib_vccl_int, irstb_out, ihssi_rb_clkdiv_out[2:0],
     ihssi_rb_dcc_byp_out, ihssi_rb_dcc_byp_dprio_out,
     ihssi_rb_dcc_dft_out, ihssi_rb_dcc_dft_sel_out,
     ihssi_rb_dcc_en_out, ihssi_rb_dcc_en_dprio_out,
     ihssi_rb_dcc_manual_dn_out[4:0], ihssi_rb_dcc_manual_mode_out,
     ihssi_rb_dcc_manual_mode_dprio_out,
     ihssi_rb_dcc_manual_up_out[4:0], rb_dcc_test_clk_pll_en_n_out,
     ihssi_rb_half_code_out, ihssi_rb_selflock_out,
     ired_rx_shift_en_outbuf[36:0], iatpg_scan_clk_in0_out,
     iatpg_scan_in0_out, iatpg_scan_mode_n_out, iatpg_scan_rst_n_out,
     iatpg_scan_shift_n_out, ired_shift_en_in_chain2_outbuf,
     shift_en_inpdir6_1, shift_en_oshared0, shift_en_outclk0n,
     shift_en_outpclk3, shift_en_outpdir3, shift_en_pinp18,
     shift_en_voutp0, shift_en_voutp1, ihssi_pld_pcs_rx_clk_out_n_buf,
     ihssi_pld_pcs_rx_clk_out_buf, irstb_out, vcc, vccl, vssl);

assign jtag_mode_int = jtag_mode_in_buf;
assign por_aib_vcchssi_int = por_aib_vcchssi_buf;
assign por_aib_vccl_int = por_aib_vcc_buf;
assign idirectout_data_in_chain1_outbuf = idirectout_data_in_chain1;
assign idirectout_data_in_chain2_outbuf = idirectout_data_in_chain2;
assign irstb_out = irstb_pre_out;
assign osc_clkinb = ! osc_clkin;
assign ohssi_tx_sr_clk_in = ! osc_clkinb;
assign osc_clkout = ! osc_clkinb;

aibcr3_dly_mimic x66 ( ihssi_rx_data_out_dly[39:0],
     ihssi_dcc_dll_csr_reg[6], iaibdftcore2dll[1],
     ihssi_rx_data_out[39:0], ihssi_rb_dcc_byp, ihssi_rb_dcc_byp_dprio,
     vcc, vssl);
aibcr3_avmm1 xavmm1 ( ohssi_avmm1_data_in_aib[1:0],
     nc_avmm1_odat1[1:0], avmm2_rx_distclk_l0, avmm2_rx_distclk_l1,
     avmm2_tx_launch_clk_l6, iclkin_dist_ssrdin, iclkin_dist_ssrldin,
     iclkin_dist_vinp00, iclkin_dist_vinp01, idata0_srcclkoutn,
     idata0_voutp0, idata1_srcclkoutn, idata1_voutp0,
     idataselb_srcclkoutn, idataselb_voutp0, ilaunch_clk_voutp0,
     ilaunch_clk_voutp1, irxen_ssrdin[2:0], irxen_ssrldin[2:0],
     irxen_vinp00[2:0], irxen_vinp01[2:0], istrbclk_ssrdin,
     istrbclk_ssrldin, istrbclk_vinp00, istrbclk_vinp01,
     itxen_srcclkoutn, itxen_voutp0, jtag_clkdr_srcclkoutn,
     jtag_clkdr_ssrdin, jtag_clkdr_ssrldin, jtag_clkdr_vinp00,
     jtag_clkdr_vinp01, jtag_clkdr_voutp0, jtag_rx_scan_srcclkoutn,
     jtag_rx_scan_ssrdin, jtag_rx_scan_ssrldin, jtag_rx_scan_vinp00,
     jtag_rx_scan_vinp01, jtag_rx_scan_voutp0, odat0_aib_vinp00,
     odat0_aib_vinp01, odat1_aib_vinp00, odat1_aib_vinp01,
     odat_async_fsrldout, {ohssi_fsr_data_in_aib,
     ohssi_ssr_data_in_aib, ohssi_fsr_load_in_aib,
     ohssi_ssr_load_in_aib}, nc_sdr_odat1[3:0], ohssi_sr_clk_in_aib,
     ohssi_sr_clk_n_in, shift_en_srcclkoutn, shift_en_ssrdin,
     shift_en_ssrldin, shift_en_vinp00, shift_en_vinp01,
     shift_en_voutp0, u_avmm1_data_in[1:0], u_avmm1_data_out,
     u_sr_clk_n_out, u_sr_clk_out, u_sr_clk_n_in, u_sr_clk_in,
     {u_fsr_data_in, u_ssr_data_in, u_fsr_load_in, u_ssr_load_in},
     {u_fsr_data_out, u_ssr_data_out, u_fsr_load_out, u_ssr_load_out},
     vcc, vccl, vssl, async_dat_oshared4, ihssi_avmm1_data_out_buf,
     vssl, irstb_out, ihssi_sr_clk_out_buf, clkdr_scan_seg0b_AVMM1,
     clkdr_scan_seg0c_AVMM1, clkdr_scan_seg2b_AVMM1,
     clkdr_scan_seg2c_AVMM1, net0450, clkdr_scan_seg0a_AVMM1, /*net0519*/,
     clkdr_scan_seg2a_AVMM1, vcc, vssl, vssl, vcc, idata0_ptxclkout,
     idata0_ptxclkoutn, idata1_ptxclkout, idata1_ptxclkoutn,
     iavm1out_dataselb_out[2:0], idataselb_oshared4,
     idataselb_ptxclkout, idataselb_ptxclkoutn, ilaunch_clk_ptxclkout,
     ilaunch_clk_ptxclkoutn, indrv_ptxclkout[1:0],
     indrv_ptxclkoutn[1:0], indrv_r78_out[1:0], ipdrv_ptxclkout[1:0],
     ipdrv_ptxclkoutn[1:0], ipdrv_r78_out[1:0], irxen_inpshared2[2:0],
     iavm1in_en0_out[2:0], iavm1in_en1_out[2:0], iavm1in_en2_out[2:0],
     irxen_vinp10[2:0], irxen_vinp11[2:0], {ihssi_fsr_data_out_buf,
     ihssi_ssr_data_out_buf, ihssi_fsr_load_out_buf,
     ihssi_ssr_load_out_buf}, {vssl, vssl, vssl, vssl},
     iavm1out_en_out[2:0], itxen_oshared4, itxen_ptxclkout,
     itxen_ptxclkoutn, jtag_clkdr_inpshared2, jtag_clkdr_oshared4,
     jtag_clkdr_ptxclkout, jtag_clkdr_ptxclkoutn, jtag_clkdr_vinp10,
     jtag_clkdr_vinp11, jtag_clksel_int, jtag_intest_int,
     jtag_mode_int, jtag_rstb_int, jtag_rstb_en_int,
     jtag_rx_scan_inpshared2, jtag_rx_scan_oshared4,
     jtag_rx_scan_ptxclkout, jtag_rx_scan_ptxclkoutn,
     jtag_rx_scan_vinp10, jtag_rx_scan_vinp11, jtag_tx_scanen_out,
     jtag_weakpdn_int, jtag_weakpu_int, odat0_oshared2, odat0_oshared3,
     odat0_ptxclkout, odat0_ptxclkoutn, odat1_oshared2, odat1_oshared3,
     odat1_ptxclkout, odat1_ptxclkoutn, por_aib_vcchssi_int,
     por_aib_vccl_int, ired_avm1_shift_en_out[14:0],
     shift_en_inpshared2, shift_en_oshared4, shift_en_ptxclkout,
     shift_en_ptxclkoutn, shift_en_vinp10, shift_en_vinp11);
aibcr3_scan_iomux x67 ( iatpg_scan_shift_clk_seg0,
     iatpg_scan_shift_clk_seg1, iatpg_scan_shift_clk_seg2,
     iatpg_scan_shift_clk_seg3, init_oatpg_bsr0_scan_out,
     init_oatpg_bsr1_scan_out, init_oatpg_bsr2_scan_out,
     init_oatpg_bsr3_scan_out, jtag_tx_scanen_out,
     ojtag_clkdr_out_chain, ojtag_rx_scan_out_chain, scan_in_seg0,
     scan_in_seg1, scan_in_seg2, scan_in_seg3, buf_iatpg_bsr0_scan_in,
     buf_iatpg_bsr0_scan_shift_clk, buf_iatpg_bsr1_scan_in,
     buf_iatpg_bsr1_scan_shift_clk, buf_iatpg_bsr2_scan_in,
     buf_iatpg_bsr2_scan_shift_clk, buf_iatpg_bsr3_scan_in,
     buf_iatpg_bsr3_scan_shift_clk, buf_iatpg_bsr_scan_shift_n,
     iatpg_scan_mode_n_out, jtag_tx_scanen_in, ijtag_clkdr_in_chain,
     ijtag_tx_scan_in_chain, scan_out_seg0, scan_out_seg1,
     scan_out_seg2, scan_out_seg3, vcc, vssl);
aibcr3_avmm2 xavmm2 ( ohssi_avmm2_data_in_aib[1:0],
     nc_avmm2_odat1[1:0], idata0_voutp1, idata1_voutp1,
     idataselb_voutp1, irxen_vinp10[2:0], irxen_vinp11[2:0],
     itxen_voutp1, jtag_clkdr_vinp10, jtag_clkdr_vinp11,
     jtag_clkdr_voutp1, jtag_rx_scan_vinp10, jtag_rx_scan_vinp11,
     jtag_rx_scan_voutp1, odat_async_aib_vinp10, odat_async_aib_vinp11,
     shift_en_vinp10, shift_en_vinp11, shift_en_voutp1,
     u_avmm2_data_in[1:0], u_avmm2_data_out, vcc, vccl, vssl,
     ihssi_avmm2_data_out_buf, vssl, irstb_out, avmm2_rx_distclk_l0,
     avmm2_rx_distclk_l1, avmm2_rx_distclk_l0, avmm2_rx_distclk_l1,
     clkdr_scan_seg0a_AVMM2, /*net0459*/, clkdr_scan_seg2b_AVMM2, /*net0458*/,
     /*net0456*/, /*net0457*/, clkdr_scan_seg2a_AVMM2, /*net0455*/,
     idata0_srcclkoutn, idata1_srcclkoutn, iavm2out_dataselb_out,
     idataselb_srcclkoutn, indrv_r78_out[1:0], ipdrv_r78_out[1:0],
     irxen_inpdir1_1[2:0], irxen_inpdir2_1[2:0], iavm2in_en0_out[2:0],
     iavm2out_en_out, itxen_srcclkoutn, jtag_clkdr_inpdir1_1,
     jtag_clkdr_inpdir2_1, jtag_clkdr_srcclkoutn, jtag_clksel_int,
     jtag_intest_int, jtag_mode_int, jtag_rstb_int, jtag_rstb_en_int,
     jtag_rx_scan_inpdir1_1, jtag_rx_scan_inpdir2_1,
     jtag_rx_scan_srcclkoutn, jtag_tx_scanen_out, jtag_weakpdn_int,
     jtag_weakpu_int, odat0_aib_vinp00, odat0_aib_vinp01,
     odat1_aib_vinp00, odat1_aib_vinp01, por_aib_vcchssi_int,
     por_aib_vccl_int, ired_rshift_en_rx_avmm2_out[1:0],
     ired_rshift_en_tx_avmm2_out, shift_en_inpdir1_1,
     shift_en_inpdir2_1, shift_en_srcclkoutn, avmm2_tx_launch_clk_l6);
aibcr3_interface xint ( buf_iatpg_bsr0_scan_in,
     buf_iatpg_bsr0_scan_shift_clk, buf_iatpg_bsr1_scan_in,
     buf_iatpg_bsr1_scan_shift_clk, buf_iatpg_bsr2_scan_in,
     buf_iatpg_bsr2_scan_shift_clk, buf_iatpg_bsr3_scan_in,
     buf_iatpg_bsr3_scan_shift_clk, buf_iatpg_bsr_scan_shift_n,
     iaibdftcore2dll_out[2:0], iatpg_pipeline_global_en_out,
     iatpg_scan_clk_in0_out, iatpg_scan_clk_in1_out,
     iatpg_scan_in0_out, iatpg_scan_in1_out, iatpg_scan_mode_n_out,
     iatpg_scan_rst_n_out, iatpg_scan_shift_n_out,
     iavm1in_en0_out[2:0], iavm1in_en1_out[2:0], iavm1in_en2_out[2:0],
     iavm1out_dataselb_out[2:0], iavm1out_en_out[2:0],
     iavm2in_en0_out[2:0], iavm2out_dataselb_out, iavm2out_en_out,
     idatdll_test_clk_pll_en_n_out, ihssi_avmm1_data_out_buf,
     ihssi_avmm2_data_out_buf, ihssi_dcc_dft_nrst_coding_out,
     ihssi_dcc_dft_nrst_out, ihssi_dcc_dft_up_out,
     ihssi_dcc_dll_csr_reg_out[51:0], ihssi_dcc_dll_entest_out,
     ihssi_dcc_req_out, ihssi_fsr_data_out_buf, ihssi_fsr_load_out_buf,
     ihssi_pld_8g_rxelecidle_out, ihssi_pld_pcs_rx_clk_out_buf,
     ihssi_pld_pcs_rx_clk_out_n_buf, ihssi_pld_pcs_tx_clk_out_buf,
     ihssi_pld_pma_clkdiv_rx_user_out,
     ihssi_pld_pma_clkdiv_tx_user_out, ihssi_pld_pma_hclk_out,
     ihssi_pld_pma_internal_clk1_out, ihssi_pld_pma_internal_clk2_out,
     ihssi_pld_pma_pfdmode_lock_out, ihssi_pld_pma_rxpll_lock_out,
     ihssi_pld_rx_hssi_fifo_latency_pulse_out,
     ihssi_pld_tx_hssi_fifo_latency_pulse_out,
     ihssi_pma_aib_tx_clk_out, ihssi_rb_clkdiv_out[2:0],
     ihssi_rb_dcc_byp_dprio_out, ihssi_rb_dcc_byp_out,
     ihssi_rb_dcc_dft_out, ihssi_rb_dcc_dft_sel_out,
     ihssi_rb_dcc_en_dprio_out, ihssi_rb_dcc_en_out,
     ihssi_rb_dcc_manual_dn_out[4:0],
     ihssi_rb_dcc_manual_mode_dprio_out, ihssi_rb_dcc_manual_mode_out,
     ihssi_rb_dcc_manual_up_out[4:0], ihssi_rb_half_code_out,
     ihssi_rb_selflock_out, ihssi_rx_data_out_buf[39:0],
     ihssi_rx_transfer_clk_out, ihssi_sr_clk_out_buf,
     ihssi_ssr_data_out_buf, ihssi_ssr_load_out_buf,
     ihssi_tx_dcd_cal_req_out, ihssi_tx_dll_lock_req_out,
     ihssirx_async_en_out[2:0], ihssirx_clk_en_out[2:0],
     ihssirx_out_dataselb_out[2:0], ihssirx_out_ddren_out[1:0],
     ihssirx_out_en_out[3:0], ihssitx_in_en0_out[2:0],
     ihssitx_in_en1_out[2:0], ihssitx_in_en2_out[2:0],
     ihssitx_in_en3_out[2:0], ihssitx_out_dataselb_out[2:0],
     ihssitx_out_en_out[2:0], ihssitxdll_rb_clkdiv_str_out[2:0],
     ihssitxdll_rb_half_code_str_out, ihssitxdll_rb_selflock_str_out,
     ihssitxdll_str_align_dly_pst_out[9:0],
     ihssitxdll_str_align_dyconfig_ctl_static_out[9:0],
     ihssitxdll_str_align_dyconfig_ctlsel_out,
     ihssitxdll_str_align_entest_out,
     ihssitxdll_str_align_stconfig_core_dn_prgmnvrt_out,
     ihssitxdll_str_align_stconfig_core_up_prgmnvrt_out,
     ihssitxdll_str_align_stconfig_core_updnen_out,
     ihssitxdll_str_align_stconfig_dftmuxsel_out[19:0],
     ihssitxdll_str_align_stconfig_dll_en_out,
     ihssitxdll_str_align_stconfig_dll_rst_en_out,
     ihssitxdll_str_align_stconfig_hps_ctrl_en_out,
     ihssitxdll_str_align_stconfig_ndllrst_prgmnvrt_out,
     ihssitxdll_str_align_stconfig_new_dll_out[2:0],
     ihssitxdll_str_align_stconfig_spare_out, indrv_r12_out[1:0],
     indrv_r34_out[1:0], indrv_r56_out[1:0], indrv_r78_out[1:0],
     ipdrv_r12_out[1:0], ipdrv_r34_out[1:0], ipdrv_r56_out[1:0],
     ipdrv_r78_out[1:0], ired_avm1_shift_en_out[14:0],
     ired_rshift_en_dirclkn_out[1:0], ired_rshift_en_dirclkp_out[1:0],
     ired_rshift_en_drx_out[3:0], ired_rshift_en_dtx_out[2:0],
     ired_rshift_en_pinp_out[19:0], ired_rshift_en_rx_avmm2_out[1:0],
     ired_rshift_en_rx_out[3:0], ired_rshift_en_tx_avmm2_out,
     ired_rshift_en_tx_out[3:0], ired_rshift_en_txferclkout_out,
     ired_rshift_en_txferclkoutn_out, irstb_pre_out,
     ishared_direct_async_in_out[4:0], oaibdftdll2core[12:0],
     oatpg_bsr0_scan_out, oatpg_bsr1_scan_out, oatpg_bsr2_scan_out,
     oatpg_bsr3_scan_out, oatpg_scan_out0, oatpg_scan_out1,
     ohssi_adapter_rx_pld_rst_n, ohssi_adapter_tx_pld_rst_n,
     ohssi_avmm1_data_in[1:0], ohssi_avmm2_data_in[1:0],
     ohssi_fsr_data_in, ohssi_fsr_load_in, ohssi_pcs_rx_pld_rst_n,
     ohssi_pcs_tx_pld_rst_n, ohssi_pld_pma_coreclkin,
     ohssi_pld_pma_coreclkin_n, ohssi_pld_pma_rxpma_rstb,
     ohssi_pld_pma_txdetectrx, ohssi_pld_pma_txpma_rstb,
     ohssi_pld_sclk, ohssi_sr_clk_in, ohssi_ssr_data_in,
     ohssi_ssr_load_in, ohssi_tx_data_in[39:0], ohssi_tx_dcd_cal_done,
     ohssi_tx_dll_lock, ohssi_tx_transfer_clk, ohssirx_dcc_done,
     oshared_direct_async_out[2:0], rb_dcc_dll_dft_sel_out,
     rb_dcc_test_clk_pll_en_n_out, rb_dft_ch_muxsel_out,
     iaibdftcore2dll[2:0], iatpg_bsr0_scan_in,
     iatpg_bsr0_scan_shift_clk, iatpg_bsr1_scan_in,
     iatpg_bsr1_scan_shift_clk, iatpg_bsr2_scan_in,
     iatpg_bsr2_scan_shift_clk, iatpg_bsr3_scan_in,
     iatpg_bsr3_scan_shift_clk, iatpg_bsr_scan_shift_n,
     iatpg_pipeline_global_en, iatpg_scan_clk_in0, iatpg_scan_clk_in1,
     iatpg_scan_in0, iatpg_scan_in1, iatpg_scan_mode_n,
     iatpg_scan_rst_n, iatpg_scan_shift_n, iavm1in_en0[2:0],
     iavm1in_en1[2:0], iavm1in_en2[2:0], iavm1out_dataselb[2:0],
     iavm1out_en[2:0], iavm2in_en0[2:0], iavm2out_dataselb,
     iavm2out_en, idatdll_test_clk_pll_en_n, ihssi_avmm1_data_out,
     ihssi_avmm2_data_out, ihssi_dcc_dft_nrst,
     ihssi_dcc_dft_nrst_coding, ihssi_dcc_dft_up,
     ihssi_dcc_dll_csr_reg[51:0], ihssi_dcc_dll_entest, ihssi_dcc_req,
     ihssi_fsr_data_out, ihssi_fsr_load_out, ihssi_pld_8g_rxelecidle,
     ihssi_pld_pcs_rx_clk_out, ihssi_pld_pcs_rx_clk_out_n,
     ihssi_pld_pcs_tx_clk_out, ihssi_pld_pma_clkdiv_rx_user,
     ihssi_pld_pma_clkdiv_tx_user, ihssi_pld_pma_hclk,
     ihssi_pld_pma_internal_clk1, ihssi_pld_pma_internal_clk2,
     ihssi_pld_pma_pfdmode_lock, ihssi_pld_pma_rxpll_lock,
     ihssi_pld_rx_hssi_fifo_latency_pulse,
     ihssi_pld_tx_hssi_fifo_latency_pulse, ihssi_pma_aib_tx_clk,
     ihssi_rb_clkdiv[2:0], ihssi_rb_dcc_byp, ihssi_rb_dcc_byp_dprio,
     ihssi_rb_dcc_dft, ihssi_rb_dcc_dft_sel, ihssi_rb_dcc_en,
     ihssi_rb_dcc_en_dprio, ihssi_rb_dcc_manual_dn[4:0],
     ihssi_rb_dcc_manual_mode, ihssi_rb_dcc_manual_mode_dprio,
     ihssi_rb_dcc_manual_up[4:0], ihssi_rb_half_code,
     ihssi_rb_selflock, ihssi_rx_data_out_dly[39:0],
     ihssi_rx_transfer_clk, ihssi_sr_clk_out, ihssi_ssr_data_out,
     ihssi_ssr_load_out, ihssi_tx_dcd_cal_req, ihssi_tx_dll_lock_req,
     ihssirx_async_en[2:0], ihssirx_clk_en[2:0],
     ihssirx_out_dataselb[2:0], ihssirx_out_ddren[1:0],
     ihssirx_out_en[3:0], ihssitx_in_en0[2:0], ihssitx_in_en1[2:0],
     ihssitx_in_en2[2:0], ihssitx_in_en3[2:0],
     ihssitx_out_dataselb[2:0], ihssitx_out_en[2:0],
     ihssitxdll_rb_clkdiv_str[2:0], ihssitxdll_rb_half_code_str,
     ihssitxdll_rb_selflock_str, ihssitxdll_str_align_dly_pst[9:0],
     ihssitxdll_str_align_dyconfig_ctl_static[9:0],
     ihssitxdll_str_align_dyconfig_ctlsel, ihssitxdll_str_align_entest,
     ihssitxdll_str_align_stconfig_core_dn_prgmnvrt,
     ihssitxdll_str_align_stconfig_core_up_prgmnvrt,
     ihssitxdll_str_align_stconfig_core_updnen,
     ihssitxdll_str_align_stconfig_dftmuxsel[19:0],
     ihssitxdll_str_align_stconfig_dll_en,
     ihssitxdll_str_align_stconfig_dll_rst_en,
     ihssitxdll_str_align_stconfig_hps_ctrl_en,
     ihssitxdll_str_align_stconfig_ndllrst_prgmnvrt,
     ihssitxdll_str_align_stconfig_new_dll[2:0],
     ihssitxdll_str_align_stconfig_spare, indrv_r12[1:0],
     indrv_r34[1:0], indrv_r56[1:0], indrv_r78[1:0],
     init_oatpg_bsr0_scan_out, init_oatpg_bsr1_scan_out,
     init_oatpg_bsr2_scan_out, init_oatpg_bsr3_scan_out,
     ipdrv_r12[1:0], ipdrv_r34[1:0], ipdrv_r56[1:0], ipdrv_r78[1:0],
     ired_avm1_shift_en[14:0], ired_rshift_en_dirclkn[1:0],
     ired_rshift_en_dirclkp[1:0], ired_rshift_en_drx[3:0],
     ired_rshift_en_dtx[2:0], ired_rshift_en_pinp[19:0],
     ired_rshift_en_rx[3:0], ired_rshift_en_rx_avmm2[1:0],
     ired_rshift_en_tx[3:0], ired_rshift_en_tx_avmm2,
     ired_rshift_en_txferclkout, ired_rshift_en_txferclkoutn, irstb,
     ishared_direct_async_in[4:0], oaibdftdll2core_in[12:0],
     oatpg_scan_out0_in, oatpg_scan_out1_in,
     ohssi_adapter_rx_pld_rst_n_in, ohssi_adapter_tx_pld_rst_n_in,
     ohssi_avmm1_data_in_aib[1:0], ohssi_avmm2_data_in_aib[1:0],
     ohssi_fsr_data_in_aib, ohssi_fsr_load_in_aib,
     ohssi_pcs_rx_pld_rst_n_in, ohssi_pcs_tx_pld_rst_n_in,
     ohssi_pld_pma_coreclkin_in, ohssi_pld_pma_coreclkin_n_in,
     ohssi_pld_pma_rxpma_rstb_in, ohssi_pld_pma_txdetectrx_in,
     ohssi_pld_pma_txpma_rstb_in, ohssi_pld_sclk_in,
     ohssi_sr_clk_in_aib, ohssi_ssr_data_in_aib, ohssi_ssr_load_in_aib,
     ohssi_tx_data_in_aib[39:0], ohssi_tx_dcd_cal_done_in,
     ohssi_tx_dll_lock_in, ohssi_tx_transfer_clk_in,
     ohssirx_dcc_done_in, oshared_direct_async_out_in[2:0],
     rb_dcc_dll_dft_sel, rb_dcc_test_clk_pll_en_n, rb_dft_ch_muxsel,
     vcc, vssl);

endmodule
