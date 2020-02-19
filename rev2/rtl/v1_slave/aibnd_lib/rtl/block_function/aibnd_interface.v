// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_interface, View - schematic
// LAST TIME SAVED: May 12 19:43:37 2015
// NETLIST TIME: May 12 19:44:01 2015
// `timescale 1ns / 1ns 

module aibnd_interface ( iasyncdata_out, iatpg_pipeline_global_en_out,
     iatpg_scan_clk_in0_out, iatpg_scan_clk_in1_out,
     iatpg_scan_in0_out, iatpg_scan_in1_out, iatpg_scan_mode_n_out,
     iatpg_scan_rst_n_out, iatpg_scan_shift_n_out,
     iavm1_sr_clk_out_out, iavm1in_en0_out, iavm1in_en1_out,
     iavm1in_en2_out, iavm1out_dataselb_out, iavm1out_en_out,
     iavm2in_en0_out, iavm2out_dataselb_out, iavm2out_en_out,
     ihssi_adapter_rx_pld_rst_n_out, ihssi_adapter_tx_pld_rst_n_out,
     ihssi_avmm1_data_out_out, ihssi_avmm2_data_out_out,
     ihssi_dcc_dft_nrst_coding_out, ihssi_dcc_dft_nrst_out,
     ihssi_dcc_dft_up_out, ihssi_dcc_dll_core2dll_str_out,
     ihssi_dcc_dll_csr_reg_out, ihssi_dcc_dll_entest_out,
     ihssi_dcc_req_out, ihssi_fsr_data_out_out, ihssi_fsr_load_out_out,
     ihssi_pcs_rx_pld_rst_n_out, ihssi_pcs_tx_pld_rst_n_out,
     ihssi_pld_pma_coreclkin_out, ihssi_pld_pma_rxpma_rstb_out,
     ihssi_pld_pma_txdetectrx_out, ihssi_pld_pma_txpma_rstb_out,
     ihssi_pld_sclk_out, ihssi_rb_clkdiv_out, ihssi_rb_dcc_byp_out,
     ihssi_rb_dcc_dft_out, ihssi_rb_dcc_dft_sel_out,
     ihssi_rb_dcc_dll_dft_sel_out, ihssi_rb_dcc_en_out,
     ihssi_rb_dcc_manual_dn_out, ihssi_rb_dcc_manual_mode_out,
     ihssi_rb_dcc_manual_up_out, ihssi_rb_dcc_test_clk_pll_en_n_out,
     ihssi_rb_dll_test_clk_pll_en_n_out, ihssi_rb_half_code_out,
     ihssi_rb_selflock_out, ihssi_ssr_data_out_out,
     ihssi_ssr_load_out_out, ihssi_tx_data_in_out,
     ihssi_tx_dll_lock_req_out, ihssi_tx_transfer_clk_out,
     ihssirx_async_en_out, ihssirx_clk_en_out,
     ihssirx_out_dataselb_out, ihssirx_out_ddren_out,
     ihssirx_out_en_out, ihssitx_in_en0_out, ihssitx_in_en1_out,
     ihssitx_in_en2_out, ihssitx_in_en3_out, ihssitx_out_dataselb_out,
     ihssitx_out_en_out, ihssitxdll_rb_clkdiv_str_out,
     ihssitxdll_rb_half_code_str_out, ihssitxdll_rb_selflock_str_out,
     ihssitxdll_str_align_dly_pst_out,
     ihssitxdll_str_align_dyconfig_ctl_static_out,
     ihssitxdll_str_align_dyconfig_ctlsel_out,
     ihssitxdll_str_align_entest_out,
     ihssitxdll_str_align_stconfig_core_dn_prgmnvrt_out,
     ihssitxdll_str_align_stconfig_core_up_prgmnvrt_out,
     ihssitxdll_str_align_stconfig_core_updnen_out,
     ihssitxdll_str_align_stconfig_dftmuxsel_out,
     ihssitxdll_str_align_stconfig_dll_en_out,
     ihssitxdll_str_align_stconfig_dll_rst_en_out,
     ihssitxdll_str_align_stconfig_hps_ctrl_en_out,
     ihssitxdll_str_align_stconfig_ndllrst_prgmnvrt_out,
     ihssitxdll_str_align_stconfig_new_dll_out,
     ihssitxdll_str_align_stconfig_spare_out, indrv_r12_out,
     indrv_r34_out, indrv_r56_out, indrv_r78_out, ipdrv_r12_out,
     ipdrv_r34_out, ipdrv_r56_out, ipdrv_r78_out,
     ired_avm1_shift_en_out, ired_rshift_en_rx_avmm2_out,
     ired_rshift_en_tx_avmm2_out, ired_rx_shift_en_out, irstb_out,
     oatpg_scan_out0, oatpg_scan_out1, odat_async, ohssi_avmm1_data_in,
     ohssi_avmm2_data_in, ohssi_fsr_data_in, ohssi_fsr_load_in,
     ohssi_pld_8g_rxelecidle, ohssi_pld_pcs_rx_clk_out,
     ohssi_pld_pcs_tx_clk_out, ohssi_pld_pma_clkdiv_rx_user,
     ohssi_pld_pma_clkdiv_tx_user, ohssi_pld_pma_hclk,
     ohssi_pld_pma_internal_clk1, ohssi_pld_pma_internal_clk2,
     ohssi_pld_pma_pfdmode_lock, ohssi_pld_pma_rxpll_lock,
     ohssi_pld_rx_hssi_fifo_latency_pulse,
     ohssi_pld_tx_hssi_fifo_latency_pulse, ohssi_pma_aib_tx_clk,
     ohssi_rx_data_out, ohssi_rx_transfer_clk, ohssi_sr_clk_in,
     ohssi_sr_clk_n_in, ohssi_ssr_data_in, ohssi_ssr_load_in,
     ohssi_tx_dll_lock, ohssitx_dcc_done, ohssitx_odcc_dll2core,
     iasyncdata, iatpg_pipeline_global_en, iatpg_scan_clk_in0,
     iatpg_scan_clk_in1, iatpg_scan_in0, iatpg_scan_in1,
     iatpg_scan_mode_n, iatpg_scan_rst_n, iatpg_scan_shift_n,
     iavm1_sr_clk_out, iavm1in_en0, iavm1in_en1, iavm1in_en2,
     iavm1out_dataselb, iavm1out_en, iavm2in_en0, iavm2out_dataselb,
     iavm2out_en, ihssi_adapter_rx_pld_rst_n,
     ihssi_adapter_tx_pld_rst_n, ihssi_avmm1_data_out,
     ihssi_avmm2_data_out, ihssi_dcc_dft_nrst,
     ihssi_dcc_dft_nrst_coding, ihssi_dcc_dft_up,
     ihssi_dcc_dll_core2dll_str, ihssi_dcc_dll_csr_reg,
     ihssi_dcc_dll_entest, ihssi_dcc_req, ihssi_fsr_data_out,
     ihssi_fsr_load_out, ihssi_pcs_rx_pld_rst_n,
     ihssi_pcs_tx_pld_rst_n, ihssi_pld_pma_coreclkin,
     ihssi_pld_pma_rxpma_rstb, ihssi_pld_pma_txdetectrx,
     ihssi_pld_pma_txpma_rstb, ihssi_pld_sclk, ihssi_rb_clkdiv,
     ihssi_rb_dcc_byp, ihssi_rb_dcc_dft, ihssi_rb_dcc_dft_sel,
     ihssi_rb_dcc_dll_dft_sel, ihssi_rb_dcc_en, ihssi_rb_dcc_manual_dn,
     ihssi_rb_dcc_manual_mode, ihssi_rb_dcc_manual_up,
     ihssi_rb_dcc_test_clk_pll_en_n, ihssi_rb_dll_test_clk_pll_en_n,
     ihssi_rb_half_code, ihssi_rb_selflock, ihssi_ssr_data_out,
     ihssi_ssr_load_out, ihssi_tx_data_in, ihssi_tx_dll_lock_req,
     ihssi_tx_transfer_clk, ihssirx_async_en, ihssirx_clk_en,
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
     ihssitxdll_str_align_stconfig_spare, indrv_r12, indrv_r34,
     indrv_r56, indrv_r78, ipdrv_r12, ipdrv_r34, ipdrv_r56, ipdrv_r78,
     ired_avm1_shift_en, ired_rshift_en_rx_avmm2,
     ired_rshift_en_tx_avmm2, ired_rx_shift_en, irstb,
     oatpg_scan_out0_in, oatpg_scan_out1_in, odat_async_in,
     ohssi_avmm1_data_in_in, ohssi_avmm2_data_in_in,
     ohssi_fsr_data_in_in, ohssi_fsr_load_in_in,
     ohssi_pld_8g_rxelecidle_in, ohssi_pld_pcs_rx_clk_out_in,
     ohssi_pld_pcs_tx_clk_out_in, ohssi_pld_pma_clkdiv_rx_user_in,
     ohssi_pld_pma_clkdiv_tx_user_in, ohssi_pld_pma_hclk_in,
     ohssi_pld_pma_internal_clk1_in, ohssi_pld_pma_internal_clk2_in,
     ohssi_pld_pma_pfdmode_lock_in, ohssi_pld_pma_rxpll_lock_in,
     ohssi_pld_rx_hssi_fifo_latency_pulse_in,
     ohssi_pld_tx_hssi_fifo_latency_pulse_in, ohssi_pma_aib_tx_clk_in,
     ohssi_rx_data_out_in, ohssi_rx_transfer_clk_in,
     ohssi_sr_clk_in_in, ohssi_sr_clk_n_in_in, ohssi_ssr_data_in_in,
     ohssi_ssr_load_in_in, ohssi_tx_dll_lock_in, ohssitx_dcc_done_in,
     ohssitx_odcc_dll2core_in, vccl_aibnd, vssl_aibnd );

output  iatpg_pipeline_global_en_out, iatpg_scan_clk_in0_out,
     iatpg_scan_clk_in1_out, iatpg_scan_in0_out, iatpg_scan_in1_out,
     iatpg_scan_mode_n_out, iatpg_scan_rst_n_out,
     iatpg_scan_shift_n_out, iavm1_sr_clk_out_out,
     iavm2out_dataselb_out, iavm2out_en_out,
     ihssi_adapter_rx_pld_rst_n_out, ihssi_adapter_tx_pld_rst_n_out,
     ihssi_dcc_dft_nrst_coding_out, ihssi_dcc_dft_nrst_out,
     ihssi_dcc_dft_up_out, ihssi_dcc_dll_entest_out, ihssi_dcc_req_out,
     ihssi_fsr_data_out_out, ihssi_fsr_load_out_out,
     ihssi_pcs_rx_pld_rst_n_out, ihssi_pcs_tx_pld_rst_n_out,
     ihssi_pld_pma_coreclkin_out, ihssi_pld_pma_rxpma_rstb_out,
     ihssi_pld_pma_txdetectrx_out, ihssi_pld_pma_txpma_rstb_out,
     ihssi_pld_sclk_out, ihssi_rb_dcc_byp_out, ihssi_rb_dcc_dft_out,
     ihssi_rb_dcc_dft_sel_out, ihssi_rb_dcc_dll_dft_sel_out,
     ihssi_rb_dcc_en_out, ihssi_rb_dcc_manual_mode_out,
     ihssi_rb_dcc_test_clk_pll_en_n_out,
     ihssi_rb_dll_test_clk_pll_en_n_out, ihssi_rb_half_code_out,
     ihssi_rb_selflock_out, ihssi_ssr_data_out_out,
     ihssi_ssr_load_out_out, ihssi_tx_dll_lock_req_out,
     ihssi_tx_transfer_clk_out, ihssirx_out_ddren_out,
     ihssitxdll_rb_half_code_str_out, ihssitxdll_rb_selflock_str_out,
     ihssitxdll_str_align_dyconfig_ctlsel_out,
     ihssitxdll_str_align_entest_out,
     ihssitxdll_str_align_stconfig_core_dn_prgmnvrt_out,
     ihssitxdll_str_align_stconfig_core_up_prgmnvrt_out,
     ihssitxdll_str_align_stconfig_core_updnen_out,
     ihssitxdll_str_align_stconfig_dll_en_out,
     ihssitxdll_str_align_stconfig_dll_rst_en_out,
     ihssitxdll_str_align_stconfig_hps_ctrl_en_out,
     ihssitxdll_str_align_stconfig_ndllrst_prgmnvrt_out,
     ihssitxdll_str_align_stconfig_spare_out,
     ired_rshift_en_rx_avmm2_out, irstb_out, oatpg_scan_out0,
     oatpg_scan_out1, ohssi_avmm1_data_in, ohssi_avmm2_data_in,
     ohssi_fsr_data_in, ohssi_fsr_load_in, ohssi_pld_8g_rxelecidle,
     ohssi_pld_pcs_rx_clk_out, ohssi_pld_pcs_tx_clk_out,
     ohssi_pld_pma_clkdiv_rx_user, ohssi_pld_pma_clkdiv_tx_user,
     ohssi_pld_pma_hclk, ohssi_pld_pma_internal_clk1,
     ohssi_pld_pma_internal_clk2, ohssi_pld_pma_pfdmode_lock,
     ohssi_pld_pma_rxpll_lock, ohssi_pld_rx_hssi_fifo_latency_pulse,
     ohssi_pld_tx_hssi_fifo_latency_pulse, ohssi_pma_aib_tx_clk,
     ohssi_rx_transfer_clk, ohssi_sr_clk_in, ohssi_sr_clk_n_in,
     ohssi_ssr_data_in, ohssi_ssr_load_in, ohssi_tx_dll_lock,
     ohssitx_dcc_done;

input  iatpg_pipeline_global_en, iatpg_scan_clk_in0,
     iatpg_scan_clk_in1, iatpg_scan_in0, iatpg_scan_in1,
     iatpg_scan_mode_n, iatpg_scan_rst_n, iatpg_scan_shift_n,
     iavm1_sr_clk_out, iavm2out_dataselb, iavm2out_en,
     ihssi_adapter_rx_pld_rst_n, ihssi_adapter_tx_pld_rst_n,
     ihssi_dcc_dft_nrst, ihssi_dcc_dft_nrst_coding, ihssi_dcc_dft_up,
     ihssi_dcc_dll_entest, ihssi_dcc_req, ihssi_fsr_data_out,
     ihssi_fsr_load_out, ihssi_pcs_rx_pld_rst_n,
     ihssi_pcs_tx_pld_rst_n, ihssi_pld_pma_coreclkin,
     ihssi_pld_pma_rxpma_rstb, ihssi_pld_pma_txdetectrx,
     ihssi_pld_pma_txpma_rstb, ihssi_pld_sclk, ihssi_rb_dcc_byp,
     ihssi_rb_dcc_dft, ihssi_rb_dcc_dft_sel, ihssi_rb_dcc_dll_dft_sel,
     ihssi_rb_dcc_en, ihssi_rb_dcc_manual_mode,
     ihssi_rb_dcc_test_clk_pll_en_n, ihssi_rb_dll_test_clk_pll_en_n,
     ihssi_rb_half_code, ihssi_rb_selflock, ihssi_ssr_data_out,
     ihssi_ssr_load_out, ihssi_tx_dll_lock_req, ihssi_tx_transfer_clk,
     ihssirx_out_ddren, ihssitxdll_rb_half_code_str,
     ihssitxdll_rb_selflock_str, ihssitxdll_str_align_dyconfig_ctlsel,
     ihssitxdll_str_align_entest,
     ihssitxdll_str_align_stconfig_core_dn_prgmnvrt,
     ihssitxdll_str_align_stconfig_core_up_prgmnvrt,
     ihssitxdll_str_align_stconfig_core_updnen,
     ihssitxdll_str_align_stconfig_dll_en,
     ihssitxdll_str_align_stconfig_dll_rst_en,
     ihssitxdll_str_align_stconfig_hps_ctrl_en,
     ihssitxdll_str_align_stconfig_ndllrst_prgmnvrt,
     ihssitxdll_str_align_stconfig_spare, ired_rshift_en_rx_avmm2,
     irstb, oatpg_scan_out0_in, oatpg_scan_out1_in,
     ohssi_avmm1_data_in_in, ohssi_avmm2_data_in_in,
     ohssi_fsr_data_in_in, ohssi_fsr_load_in_in,
     ohssi_pld_8g_rxelecidle_in, ohssi_pld_pcs_rx_clk_out_in,
     ohssi_pld_pcs_tx_clk_out_in, ohssi_pld_pma_clkdiv_rx_user_in,
     ohssi_pld_pma_clkdiv_tx_user_in, ohssi_pld_pma_hclk_in,
     ohssi_pld_pma_internal_clk1_in, ohssi_pld_pma_internal_clk2_in,
     ohssi_pld_pma_pfdmode_lock_in, ohssi_pld_pma_rxpll_lock_in,
     ohssi_pld_rx_hssi_fifo_latency_pulse_in,
     ohssi_pld_tx_hssi_fifo_latency_pulse_in, ohssi_pma_aib_tx_clk_in,
     ohssi_rx_transfer_clk_in, ohssi_sr_clk_in_in,
     ohssi_sr_clk_n_in_in, ohssi_ssr_data_in_in, ohssi_ssr_load_in_in,
     ohssi_tx_dll_lock_in, ohssitx_dcc_done_in, vccl_aibnd, vssl_aibnd;

output [39:0]  ohssi_rx_data_out;
output [51:0]  ihssi_dcc_dll_csr_reg_out;
output [2:0]  iasyncdata_out;
output [4:0]  ihssi_rb_dcc_manual_up_out;
output [2:0]  ihssitx_in_en3_out;
output [2:0]  ihssitx_in_en2_out;
output [2:0]  ihssitx_out_en_out;
output [2:0]  ihssirx_clk_en_out;
output [2:0]  ihssi_dcc_dll_core2dll_str_out;
output [2:0]  iavm1out_dataselb_out;
output [36:0]  ired_rx_shift_en_out;
output [4:0]  ihssi_rb_dcc_manual_dn_out;
output [14:0]  ired_avm1_shift_en_out;
output [19:0]  ihssitxdll_str_align_stconfig_dftmuxsel_out;
output [1:0]  ipdrv_r56_out;
output [2:0]  ihssitxdll_str_align_stconfig_new_dll_out;
output [1:0]  ipdrv_r12_out;
output [1:0]  ihssi_avmm2_data_out_out;
output [1:0]  ihssi_avmm1_data_out_out;
output [2:0]  ihssirx_async_en_out;
output [1:0]  indrv_r78_out;
output [3:0]  ihssirx_out_en_out;
output [1:0]  ired_rshift_en_tx_avmm2_out;
output [1:0]  ipdrv_r34_out;
output [2:0]  iavm1in_en1_out;
output [1:0]  ipdrv_r78_out;
output [9:0]  ihssitxdll_str_align_dly_pst_out;
output [1:0]  indrv_r12_out;
output [2:0]  ihssitx_in_en1_out;
output [9:0]  ihssitxdll_str_align_dyconfig_ctl_static_out;
output [3:0]  ihssirx_out_dataselb_out;
output [1:0]  indrv_r56_out;
output [2:0]  iavm1in_en2_out;
output [2:0]  ihssi_rb_clkdiv_out;
output [39:0]  ihssi_tx_data_in_out;
output [2:0]  iavm1out_en_out;
output [2:0]  iavm2in_en0_out;
output [2:0]  ihssitx_in_en0_out;
output [2:0]  iavm1in_en0_out;
output [1:0]  indrv_r34_out;
output [12:0]  ohssitx_odcc_dll2core;
output [2:0]  ihssitx_out_dataselb_out;
output [4:0]  odat_async;
output [2:0]  ihssitxdll_rb_clkdiv_str_out;

input [3:0]  ihssirx_out_dataselb;
input [14:0]  ired_avm1_shift_en;
input [12:0]  ohssitx_odcc_dll2core_in;
input [2:0]  ihssitxdll_rb_clkdiv_str;
input [19:0]  ihssitxdll_str_align_stconfig_dftmuxsel;
input [1:0]  ipdrv_r78;
input [1:0]  ired_rshift_en_tx_avmm2;
input [2:0]  ihssirx_clk_en;
input [2:0]  ihssi_rb_clkdiv;
input [2:0]  iavm1in_en1;
input [51:0]  ihssi_dcc_dll_csr_reg;
input [4:0]  ihssi_rb_dcc_manual_dn;
input [2:0]  ihssitx_in_en2;
input [2:0]  iavm1in_en2;
input [1:0]  ihssi_avmm2_data_out;
input [9:0]  ihssitxdll_str_align_dly_pst;
input [39:0]  ohssi_rx_data_out_in;
input [1:0]  ipdrv_r34;
input [3:0]  ihssirx_out_en;
input [9:0]  ihssitxdll_str_align_dyconfig_ctl_static;
input [1:0]  indrv_r78;
input [1:0]  indrv_r12;
input [2:0]  ihssitx_in_en0;
input [1:0]  ihssi_avmm1_data_out;
input [1:0]  indrv_r34;
input [2:0]  iavm2in_en0;
input [1:0]  ipdrv_r12;
input [2:0]  ihssitxdll_str_align_stconfig_new_dll;
input [1:0]  indrv_r56;
input [2:0]  ihssi_dcc_dll_core2dll_str;
input [2:0]  iavm1in_en0;
input [2:0]  ihssitx_out_en;
input [4:0]  odat_async_in;
input [2:0]  ihssitx_in_en3;
input [2:0]  ihssirx_async_en;
input [36:0]  ired_rx_shift_en;
input [2:0]  ihssitx_out_dataselb;
input [2:0]  iavm1out_en;
input [39:0]  ihssi_tx_data_in;
input [4:0]  ihssi_rb_dcc_manual_up;
input [2:0]  ihssitx_in_en1;
input [1:0]  ipdrv_r56;
input [2:0]  iavm1out_dataselb;
input [2:0]  iasyncdata;


// specify 
//     specparam CDS_LIBNAME  = "aibnd_lib";
//     specparam CDS_CELLNAME = "aibnd_interface";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

aibnd_rambit_buf x121[2:0] ( .sig_out(iavm2in_en0_out[2:0]),
     .sig_in(iavm2in_en0[2:0]), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x125 ( .sig_out(ired_rshift_en_rx_avmm2_out),
     .sig_in(ired_rshift_en_rx_avmm2), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x122 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .sig_in(iavm2out_en),
     .sig_out(iavm2out_en_out));
aibnd_rambit_buf x126[1:0] (
     .sig_out(ired_rshift_en_tx_avmm2_out[1:0]),
     .sig_in(ired_rshift_en_tx_avmm2[1:0]), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x120 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .sig_in(iavm2out_dataselb),
     .sig_out(iavm2out_dataselb_out));
aibnd_rambit_buf x5[2:0] ( .sig_out(iavm1in_en0_out[2:0]),
     .sig_in(iavm1in_en0[2:0]), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x107[14:0] ( .sig_out(ired_avm1_shift_en_out[14:0]),
     .sig_in(ired_avm1_shift_en[14:0]), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x106[2:0] ( .sig_out(iavm1out_en_out[2:0]),
     .sig_in(iavm1out_en[2:0]), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x105[2:0] ( .sig_out(iavm1out_dataselb_out[2:0]),
     .sig_in(iavm1out_dataselb[2:0]), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x104[2:0] ( .sig_out(iavm1in_en2_out[2:0]),
     .sig_in(iavm1in_en2[2:0]), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x103[2:0] ( .sig_out(iavm1in_en1_out[2:0]),
     .sig_in(iavm1in_en1[2:0]), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x66[9:0] (
     .sig_out(ihssitxdll_str_align_dyconfig_ctl_static_out[9:0]),
     .sig_in(ihssitxdll_str_align_dyconfig_ctl_static[9:0]),
     .vccl_aibnd(vccl_aibnd), .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x89[36:0] ( .sig_out(ired_rx_shift_en_out[36:0]),
     .sig_in(ired_rx_shift_en[36:0]), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x88[2:0] ( .sig_out(ihssitx_out_en_out[2:0]),
     .sig_in(ihssitx_out_en[2:0]), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x87[2:0] ( .sig_out(ihssitx_out_dataselb_out[2:0]),
     .sig_in(ihssitx_out_dataselb[2:0]), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x86[2:0] ( .sig_out(ihssitx_in_en3_out[2:0]),
     .sig_in(ihssitx_in_en3[2:0]), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x85[2:0] ( .sig_out(ihssitx_in_en2_out[2:0]),
     .sig_in(ihssitx_in_en2[2:0]), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x84[2:0] ( .sig_out(ihssitx_in_en1_out[2:0]),
     .sig_in(ihssitx_in_en1[2:0]), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x82 ( .sig_out(ihssi_rb_dll_test_clk_pll_en_n_out),
     .sig_in(ihssi_rb_dll_test_clk_pll_en_n), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x81 ( .sig_out(ihssitxdll_rb_selflock_str_out),
     .sig_in(ihssitxdll_rb_selflock_str), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x80 ( .sig_out(ihssitxdll_rb_half_code_str_out),
     .sig_in(ihssitxdll_rb_half_code_str), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x83[2:0] ( .sig_out(ihssitx_in_en0_out[2:0]),
     .sig_in(ihssitx_in_en0[2:0]), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x79[2:0] (
     .sig_out(ihssitxdll_rb_clkdiv_str_out[2:0]),
     .sig_in(ihssitxdll_rb_clkdiv_str[2:0]), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x77 (
     .sig_out(ihssitxdll_str_align_stconfig_spare_out),
     .sig_in(ihssitxdll_str_align_stconfig_spare),
     .vccl_aibnd(vccl_aibnd), .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x78[9:0] (
     .sig_out(ihssitxdll_str_align_dly_pst_out[9:0]),
     .sig_in(ihssitxdll_str_align_dly_pst[9:0]),
     .vccl_aibnd(vccl_aibnd), .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x75 (
     .sig_out(ihssitxdll_str_align_stconfig_ndllrst_prgmnvrt_out),
     .sig_in(ihssitxdll_str_align_stconfig_ndllrst_prgmnvrt),
     .vccl_aibnd(vccl_aibnd), .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x74 (
     .sig_out(ihssitxdll_str_align_stconfig_hps_ctrl_en_out),
     .sig_in(ihssitxdll_str_align_stconfig_hps_ctrl_en),
     .vccl_aibnd(vccl_aibnd), .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x73 (
     .sig_out(ihssitxdll_str_align_stconfig_dll_rst_en_out),
     .sig_in(ihssitxdll_str_align_stconfig_dll_rst_en),
     .vccl_aibnd(vccl_aibnd), .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x72 (
     .sig_out(ihssitxdll_str_align_stconfig_dll_en_out),
     .sig_in(ihssitxdll_str_align_stconfig_dll_en),
     .vccl_aibnd(vccl_aibnd), .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x76[2:0] (
     .sig_out(ihssitxdll_str_align_stconfig_new_dll_out[2:0]),
     .sig_in(ihssitxdll_str_align_stconfig_new_dll[2:0]),
     .vccl_aibnd(vccl_aibnd), .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x70 (
     .sig_out(ihssitxdll_str_align_stconfig_core_updnen_out),
     .sig_in(ihssitxdll_str_align_stconfig_core_updnen),
     .vccl_aibnd(vccl_aibnd), .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x69 (
     .sig_out(ihssitxdll_str_align_stconfig_core_up_prgmnvrt_out),
     .sig_in(ihssitxdll_str_align_stconfig_core_up_prgmnvrt),
     .vccl_aibnd(vccl_aibnd), .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x45 ( .sig_out(ihssi_rb_dcc_dll_dft_sel_out),
     .sig_in(ihssi_rb_dcc_dll_dft_sel), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x44 ( .sig_out(ihssi_rb_dcc_test_clk_pll_en_n_out),
     .sig_in(ihssi_rb_dcc_test_clk_pll_en_n), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x43 ( .sig_out(ihssi_rb_selflock_out),
     .sig_in(ihssi_rb_selflock), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x42 ( .sig_out(ihssi_rb_half_code_out),
     .sig_in(ihssi_rb_half_code), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x34[51:0] ( .sig_out(ihssi_dcc_dll_csr_reg_out[51:0]),
     .sig_in(ihssi_dcc_dll_csr_reg[51:0]), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x40 ( .sig_out(ihssi_rb_dcc_manual_mode_out),
     .sig_in(ihssi_rb_dcc_manual_mode), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x68 (
     .sig_out(ihssitxdll_str_align_stconfig_core_dn_prgmnvrt_out),
     .sig_in(ihssitxdll_str_align_stconfig_core_dn_prgmnvrt),
     .vccl_aibnd(vccl_aibnd), .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x38 ( .sig_out(ihssi_rb_dcc_en_out),
     .sig_in(ihssi_rb_dcc_en), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x37 ( .sig_out(ihssi_rb_dcc_dft_sel_out),
     .sig_in(ihssi_rb_dcc_dft_sel), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x36 ( .sig_out(ihssi_rb_dcc_dft_out),
     .sig_in(ihssi_rb_dcc_dft), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x35 ( .sig_out(ihssi_rb_dcc_byp_out),
     .sig_in(ihssi_rb_dcc_byp), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x39[4:0] ( .sig_out(ihssi_rb_dcc_manual_dn_out[4:0]),
     .sig_in(ihssi_rb_dcc_manual_dn[4:0]), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x32[3:0] ( .sig_out(ihssirx_out_en_out[3:0]),
     .sig_in(ihssirx_out_en[3:0]), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x4[2:0] ( .sig_out(ihssirx_clk_en_out[2:0]),
     .sig_in(ihssirx_clk_en[2:0]), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x31 ( .sig_out(ihssirx_out_ddren_out),
     .sig_in(ihssirx_out_ddren), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x41[4:0] ( .sig_out(ihssi_rb_dcc_manual_up_out[4:0]),
     .sig_in(ihssi_rb_dcc_manual_up[4:0]), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x33[2:0] ( .sig_out(ihssi_rb_clkdiv_out[2:0]),
     .sig_in(ihssi_rb_clkdiv[2:0]), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x30[3:0] ( .sig_out(ihssirx_out_dataselb_out[3:0]),
     .sig_in(ihssirx_out_dataselb[3:0]), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x67 (
     .sig_out(ihssitxdll_str_align_dyconfig_ctlsel_out),
     .sig_in(ihssitxdll_str_align_dyconfig_ctlsel),
     .vccl_aibnd(vccl_aibnd), .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x71[19:0] (
     .sig_out(ihssitxdll_str_align_stconfig_dftmuxsel_out[19:0]),
     .sig_in(ihssitxdll_str_align_stconfig_dftmuxsel[19:0]),
     .vccl_aibnd(vccl_aibnd), .vssl_aibnd(vssl_aibnd));
aibnd_rambit_buf x29[2:0] ( .sig_out(ihssirx_async_en_out[2:0]),
     .sig_in(ihssirx_async_en[2:0]), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_signal_buf x141[4:0] ( .sig_out(odat_async[4:0]),
     .sig_in(odat_async_in[4:0]), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_signal_buf x140[2:0] ( .sig_out(iasyncdata_out[2:0]),
     .sig_in(iasyncdata[2:0]), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_signal_buf x138 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .sig_in(ihssi_pld_pma_rxpma_rstb),
     .sig_out(ihssi_pld_pma_rxpma_rstb_out));
aibnd_signal_buf x137 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .sig_in(ihssi_adapter_rx_pld_rst_n),
     .sig_out(ihssi_adapter_rx_pld_rst_n_out));
aibnd_signal_buf x136 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .sig_in(ihssi_pcs_rx_pld_rst_n),
     .sig_out(ihssi_pcs_rx_pld_rst_n_out));
aibnd_signal_buf x135[1:0] ( .sig_out(ipdrv_r78_out[1:0]),
     .sig_in(ipdrv_r78[1:0]), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_signal_buf x134[1:0] ( .sig_out(ipdrv_r56_out[1:0]),
     .sig_in(ipdrv_r56[1:0]), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_signal_buf x133[1:0] ( .sig_out(ipdrv_r34_out[1:0]),
     .sig_in(ipdrv_r34[1:0]), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_signal_buf x132[1:0] ( .sig_out(ipdrv_r12_out[1:0]),
     .sig_in(ipdrv_r12[1:0]), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_signal_buf x131[1:0] ( .sig_out(indrv_r78_out[1:0]),
     .sig_in(indrv_r78[1:0]), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_signal_buf x130[1:0] ( .sig_out(indrv_r56_out[1:0]),
     .sig_in(indrv_r56[1:0]), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_signal_buf x128[1:0] ( .sig_out(indrv_r12_out[1:0]),
     .sig_in(indrv_r12[1:0]), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_signal_buf x129[1:0] ( .sig_out(indrv_r34_out[1:0]),
     .sig_in(indrv_r34[1:0]), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_signal_buf x127 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .sig_in(irstb), .sig_out(irstb_out));
aibnd_signal_buf x124 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .sig_in(ohssi_avmm2_data_in_in),
     .sig_out(ohssi_avmm2_data_in));
aibnd_signal_buf x10[1:0] ( .sig_out(ihssi_avmm2_data_out_out[1:0]),
     .sig_in(ihssi_avmm2_data_out[1:0]), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_signal_buf x119 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .sig_in(ohssi_ssr_load_in_in),
     .sig_out(ohssi_ssr_load_in));
aibnd_signal_buf x118 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .sig_in(ohssi_ssr_data_in_in),
     .sig_out(ohssi_ssr_data_in));
aibnd_signal_buf x117 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .sig_in(ohssi_fsr_load_in_in),
     .sig_out(ohssi_fsr_load_in));
aibnd_signal_buf x116 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .sig_in(ohssi_fsr_data_in_in),
     .sig_out(ohssi_fsr_data_in));
aibnd_signal_buf x115 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .sig_in(ohssi_avmm1_data_in_in),
     .sig_out(ohssi_avmm1_data_in));
aibnd_signal_buf x114 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .sig_in(ohssi_sr_clk_n_in_in),
     .sig_out(ohssi_sr_clk_n_in));
aibnd_signal_buf x113 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .sig_in(ohssi_sr_clk_in_in),
     .sig_out(ohssi_sr_clk_in));
aibnd_signal_buf x112 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .sig_in(ihssi_ssr_load_out),
     .sig_out(ihssi_ssr_load_out_out));
aibnd_signal_buf x111 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .sig_in(ihssi_ssr_data_out),
     .sig_out(ihssi_ssr_data_out_out));
aibnd_signal_buf x110 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .sig_in(ihssi_fsr_load_out),
     .sig_out(ihssi_fsr_load_out_out));
aibnd_signal_buf x109 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .sig_in(ihssi_fsr_data_out),
     .sig_out(ihssi_fsr_data_out_out));
aibnd_signal_buf x108[1:0] ( .sig_out(ihssi_avmm1_data_out_out[1:0]),
     .sig_in(ihssi_avmm1_data_out[1:0]), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_signal_buf x102 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .sig_in(oatpg_scan_out0_in),
     .sig_out(oatpg_scan_out0));
aibnd_signal_buf x92 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .sig_in(ihssi_tx_dll_lock_req),
     .sig_out(ihssi_tx_dll_lock_req_out));
aibnd_signal_buf x54[39:0] ( .sig_out(ohssi_rx_data_out[39:0]),
     .sig_in(ohssi_rx_data_out_in[39:0]), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_signal_buf x28[12:0] ( .sig_out(ohssitx_odcc_dll2core[12:0]),
     .sig_in(ohssitx_odcc_dll2core_in[12:0]), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_signal_buf x96 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .sig_in(iatpg_scan_rst_n),
     .sig_out(iatpg_scan_rst_n_out));
aibnd_signal_buf x99 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .sig_in(iatpg_scan_mode_n),
     .sig_out(iatpg_scan_mode_n_out));
aibnd_signal_buf x100 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .sig_in(oatpg_scan_out1_in),
     .sig_out(oatpg_scan_out1));
aibnd_signal_buf x47 ( .sig_out(iatpg_scan_shift_n_out),
     .sig_in(iatpg_scan_shift_n), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_signal_buf x95 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .sig_in(iatpg_pipeline_global_en),
     .sig_out(iatpg_pipeline_global_en_out));
aibnd_signal_buf x20[2:0] (
     .sig_out(ihssi_dcc_dll_core2dll_str_out[2:0]),
     .sig_in(ihssi_dcc_dll_core2dll_str[2:0]), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_signal_buf x27 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .sig_in(ohssitx_dcc_done_in),
     .sig_out(ohssitx_dcc_done));
aibnd_signal_buf x26 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .sig_in(ohssi_pld_pcs_tx_clk_out_in),
     .sig_out(ohssi_pld_pcs_tx_clk_out));
aibnd_signal_buf x25 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .sig_in(ohssi_pma_aib_tx_clk_in),
     .sig_out(ohssi_pma_aib_tx_clk));
aibnd_signal_buf x24 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd),
     .sig_in(ohssi_pld_tx_hssi_fifo_latency_pulse_in),
     .sig_out(ohssi_pld_tx_hssi_fifo_latency_pulse));
aibnd_signal_buf x23 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .sig_in(ohssi_pld_pma_pfdmode_lock_in),
     .sig_out(ohssi_pld_pma_pfdmode_lock));
aibnd_signal_buf x21 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .sig_in(ihssi_dcc_dll_entest),
     .sig_out(ihssi_dcc_dll_entest_out));
aibnd_signal_buf x19 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .sig_in(ihssi_dcc_req),
     .sig_out(ihssi_dcc_req_out));
aibnd_signal_buf x18 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .sig_in(ihssi_dcc_dft_up),
     .sig_out(ihssi_dcc_dft_up_out));
aibnd_signal_buf x17 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .sig_in(ihssi_dcc_dft_nrst_coding),
     .sig_out(ihssi_dcc_dft_nrst_coding_out));
aibnd_signal_buf x63 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd),
     .sig_in(ohssi_pld_rx_hssi_fifo_latency_pulse_in),
     .sig_out(ohssi_pld_rx_hssi_fifo_latency_pulse));
aibnd_signal_buf x62 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .sig_in(ohssi_pld_pma_rxpll_lock_in),
     .sig_out(ohssi_pld_pma_rxpll_lock));
aibnd_signal_buf x61 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .sig_in(ohssi_pld_8g_rxelecidle_in),
     .sig_out(ohssi_pld_8g_rxelecidle));
aibnd_signal_buf x60 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .sig_in(ohssi_pld_pma_hclk_in),
     .sig_out(ohssi_pld_pma_hclk));
aibnd_signal_buf x59 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .sig_in(ohssi_pld_pma_internal_clk2_in),
     .sig_out(ohssi_pld_pma_internal_clk2));
aibnd_signal_buf x58 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .sig_in(ohssi_pld_pma_internal_clk1_in),
     .sig_out(ohssi_pld_pma_internal_clk1));
aibnd_signal_buf x57 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .sig_in(ohssi_pld_pma_clkdiv_rx_user_in),
     .sig_out(ohssi_pld_pma_clkdiv_rx_user));
aibnd_signal_buf x56 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .sig_in(ohssi_pld_pcs_rx_clk_out_in),
     .sig_out(ohssi_pld_pcs_rx_clk_out));
aibnd_signal_buf x55 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .sig_in(ohssi_rx_transfer_clk_in),
     .sig_out(ohssi_rx_transfer_clk));
aibnd_signal_buf x101 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .sig_in(ohssi_tx_dll_lock_in),
     .sig_out(ohssi_tx_dll_lock));
aibnd_signal_buf x8 ( .sig_out(ihssitxdll_str_align_entest_out),
     .sig_in(ihssitxdll_str_align_entest), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_signal_buf x16 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .sig_in(ihssi_dcc_dft_nrst),
     .sig_out(ihssi_dcc_dft_nrst_out));
aibnd_signal_buf x22 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .sig_in(ohssi_pld_pma_clkdiv_tx_user_in),
     .sig_out(ohssi_pld_pma_clkdiv_tx_user));
aibnd_signal_buf x13 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .sig_in(ihssi_pld_pma_txpma_rstb),
     .sig_out(ihssi_pld_pma_txpma_rstb_out));
aibnd_signal_buf x12 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .sig_in(ihssi_pld_pma_txdetectrx),
     .sig_out(ihssi_pld_pma_txdetectrx_out));
aibnd_signal_buf x11 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .sig_in(ihssi_pcs_tx_pld_rst_n),
     .sig_out(ihssi_pcs_tx_pld_rst_n_out));
aibnd_signal_buf x1 ( .vssl_aibnd(vssl_aibnd), .vccl_aibnd(vccl_aibnd),
     .sig_in(ihssi_adapter_tx_pld_rst_n),
     .sig_out(ihssi_adapter_tx_pld_rst_n_out));
aibnd_data_buf x139 ( .vssl_aibnd(vssl_aibnd), .vccl_aibnd(vccl_aibnd),
     .sig_in(ihssi_pld_sclk), .sig_out(ihssi_pld_sclk_out));
aibnd_data_buf x6 ( .vssl_aibnd(vssl_aibnd), .vccl_aibnd(vccl_aibnd),
     .sig_in(iavm1_sr_clk_out), .sig_out(iavm1_sr_clk_out_out));
aibnd_data_buf x94 ( .vssl_aibnd(vssl_aibnd), .vccl_aibnd(vccl_aibnd),
     .sig_in(iatpg_scan_in0), .sig_out(iatpg_scan_in0_out));
aibnd_data_buf x93 ( .vssl_aibnd(vssl_aibnd), .vccl_aibnd(vccl_aibnd),
     .sig_in(iatpg_scan_clk_in0), .sig_out(iatpg_scan_clk_in0_out));
aibnd_data_buf x97 ( .vssl_aibnd(vssl_aibnd), .vccl_aibnd(vccl_aibnd),
     .sig_in(iatpg_scan_clk_in1), .sig_out(iatpg_scan_clk_in1_out));
aibnd_data_buf x98 ( .vssl_aibnd(vssl_aibnd), .vccl_aibnd(vccl_aibnd),
     .sig_in(iatpg_scan_in1), .sig_out(iatpg_scan_in1_out));
aibnd_data_buf x14[39:0] ( .sig_out(ihssi_tx_data_in_out[39:0]),
     .sig_in(ihssi_tx_data_in[39:0]), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd));
aibnd_data_buf x7 ( .vssl_aibnd(vssl_aibnd), .vccl_aibnd(vccl_aibnd),
     .sig_in(ihssi_pld_pma_coreclkin),
     .sig_out(ihssi_pld_pma_coreclkin_out));
aibnd_data_buf x15 ( .vssl_aibnd(vssl_aibnd), .vccl_aibnd(vccl_aibnd),
     .sig_in(ihssi_tx_transfer_clk),
     .sig_out(ihssi_tx_transfer_clk_out));

endmodule

