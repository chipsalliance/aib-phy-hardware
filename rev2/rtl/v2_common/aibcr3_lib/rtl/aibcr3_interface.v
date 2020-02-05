// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3_lib, Cell - aibcr3_interface, View - schematic
// LAST TIME SAVED: Sep  5 23:52:37 2016
// NETLIST TIME: Sep 13 21:47:08 2016
`timescale 1ns / 1ns 

module aibcr3_interface ( buf_iatpg_bsr0_scan_in,
     buf_iatpg_bsr0_scan_shift_clk, buf_iatpg_bsr1_scan_in,
     buf_iatpg_bsr1_scan_shift_clk, buf_iatpg_bsr2_scan_in,
     buf_iatpg_bsr2_scan_shift_clk, buf_iatpg_bsr3_scan_in,
     buf_iatpg_bsr3_scan_shift_clk, buf_iatpg_bsr_scan_shift_n,
     iaibdftcore2dll_out, iatpg_pipeline_global_en_out,
     iatpg_scan_clk_in0_out, iatpg_scan_clk_in1_out,
     iatpg_scan_in0_out, iatpg_scan_in1_out, iatpg_scan_mode_n_out,
     iatpg_scan_rst_n_out, iatpg_scan_shift_n_out, iavm1in_en0_out,
     iavm1in_en1_out, iavm1in_en2_out, iavm1out_dataselb_out,
     iavm1out_en_out, iavm2in_en0_out, iavm2out_dataselb_out,
     iavm2out_en_out, idatdll_test_clk_pll_en_n_out,
     ihssi_avmm1_data_out_buf, ihssi_avmm2_data_out_buf,
     ihssi_dcc_dft_nrst_coding_out, ihssi_dcc_dft_nrst_out,
     ihssi_dcc_dft_up_out, ihssi_dcc_dll_csr_reg_out,
     ihssi_dcc_dll_entest_out, ihssi_dcc_req_out,
     ihssi_fsr_data_out_buf, ihssi_fsr_load_out_buf,
     ihssi_pld_8g_rxelecidle_out, ihssi_pld_pcs_rx_clk_out_buf,
     ihssi_pld_pcs_rx_clk_out_n_buf, ihssi_pld_pcs_tx_clk_out_buf,
     ihssi_pld_pma_clkdiv_rx_user_out,
     ihssi_pld_pma_clkdiv_tx_user_out, ihssi_pld_pma_hclk_out,
     ihssi_pld_pma_internal_clk1_out, ihssi_pld_pma_internal_clk2_out,
     ihssi_pld_pma_pfdmode_lock_out, ihssi_pld_pma_rxpll_lock_out,
     ihssi_pld_rx_hssi_fifo_latency_pulse_out,
     ihssi_pld_tx_hssi_fifo_latency_pulse_out,
     ihssi_pma_aib_tx_clk_out, ihssi_rb_clkdiv_out,
     ihssi_rb_dcc_byp_dprio_out, ihssi_rb_dcc_byp_out,
     ihssi_rb_dcc_dft_out, ihssi_rb_dcc_dft_sel_out,
     ihssi_rb_dcc_en_dprio_out, ihssi_rb_dcc_en_out,
     ihssi_rb_dcc_manual_dn_out, ihssi_rb_dcc_manual_mode_dprio_out,
     ihssi_rb_dcc_manual_mode_out, ihssi_rb_dcc_manual_up_out,
     ihssi_rb_half_code_out, ihssi_rb_selflock_out,
     ihssi_rx_data_out_buf, ihssi_rx_transfer_clk_out,
     ihssi_sr_clk_out_in, ihssi_ssr_data_out_buf,
     ihssi_ssr_load_out_buf, ihssi_tx_dcd_cal_req_out,
     ihssi_tx_dll_lock_req_out, ihssirx_async_en_out,
     ihssirx_clk_en_out, ihssirx_out_dataselb_out,
     ihssirx_out_ddren_out, ihssirx_out_en_out, ihssitx_in_en0_out,
     ihssitx_in_en1_out, ihssitx_in_en2_out, ihssitx_in_en3_out,
     ihssitx_out_dataselb_out, ihssitx_out_en_out,
     ihssitxdll_rb_clkdiv_str_out, ihssitxdll_rb_half_code_str_out,
     ihssitxdll_rb_selflock_str_out, ihssitxdll_str_align_dly_pst_out,
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
     ired_avm1_shift_en_out, ired_rshift_en_dirclkn_out,
     ired_rshift_en_dirclkp_out, ired_rshift_en_drx_out,
     ired_rshift_en_dtx_out, ired_rshift_en_pinp_out,
     ired_rshift_en_rx_avmm2_out, ired_rshift_en_rx_out,
     ired_rshift_en_tx_avmm2_out, ired_rshift_en_tx_out,
     ired_rshift_en_txferclkout_out, ired_rshift_en_txferclkoutn_out,
     irstb_out, ishared_direct_async_in_outs, oaibdftdll2core,
     oatpg_bsr0_scan_out, oatpg_bsr1_scan_out, oatpg_bsr2_scan_out,
     oatpg_bsr3_scan_out, oatpg_scan_out0, oatpg_scan_out1,
     ohssi_adapter_rx_pld_rst_n, ohssi_adapter_tx_pld_rst_n,
     ohssi_avmm1_data_in, ohssi_avmm2_data_in, ohssi_fsr_data_in,
     ohssi_fsr_load_in, ohssi_pcs_rx_pld_rst_n, ohssi_pcs_tx_pld_rst_n,
     ohssi_pld_pma_coreclkin, ohssi_pld_pma_coreclkin_n,
     ohssi_pld_pma_rxpma_rstb, ohssi_pld_pma_txdetectrx,
     ohssi_pld_pma_txpma_rstb, ohssi_pld_sclk, ohssi_sr_clk_in,
     ohssi_ssr_data_in, ohssi_ssr_load_in, ohssi_tx_data_in,
     ohssi_tx_dcd_cal_done, ohssi_tx_dll_lock, ohssi_tx_transfer_clk,
     ohssirx_dcc_done, oshared_direct_async_out,
     rb_dcc_dll_dft_sel_out, rb_dcc_test_clk_pll_en_n_out,
     rb_dft_ch_muxsel_out, iaibdftcore2dll, iatpg_bsr0_scan_in,
     iatpg_bsr0_scan_shift_clk, iatpg_bsr1_scan_in,
     iatpg_bsr1_scan_shift_clk, iatpg_bsr2_scan_in,
     iatpg_bsr2_scan_shift_clk, iatpg_bsr3_scan_in,
     iatpg_bsr3_scan_shift_clk, iatpg_bsr_scan_shift_n,
     iatpg_pipeline_global_en, iatpg_scan_clk_in0, iatpg_scan_clk_in1,
     iatpg_scan_in0, iatpg_scan_in1, iatpg_scan_mode_n,
     iatpg_scan_rst_n, iatpg_scan_shift_n, iavm1in_en0, iavm1in_en1,
     iavm1in_en2, iavm1out_dataselb, iavm1out_en, iavm2in_en0,
     iavm2out_dataselb, iavm2out_en, idatdll_test_clk_pll_en_n,
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
     ihssitxdll_str_align_stconfig_spare, indrv_r12, indrv_r34,
     indrv_r56, indrv_r78, init_oatpg_bsr0_scan_out,
     init_oatpg_bsr1_scan_out, init_oatpg_bsr2_scan_out,
     init_oatpg_bsr3_scan_out, ipdrv_r12, ipdrv_r34, ipdrv_r56,
     ipdrv_r78, ired_avm1_shift_en, ired_rshift_en_dirclkn,
     ired_rshift_en_dirclkp, ired_rshift_en_drx, ired_rshift_en_dtx,
     ired_rshift_en_pinp, ired_rshift_en_rx, ired_rshift_en_rx_avmm2,
     ired_rshift_en_tx, ired_rshift_en_tx_avmm2,
     ired_rshift_en_txferclkout, ired_rshift_en_txferclkoutn, irstb,
     ishared_direct_async_in, oaibdftdll2core_in, oatpg_scan_out0_in,
     oatpg_scan_out1_in, ohssi_adapter_rx_pld_rst_n_in,
     ohssi_adapter_tx_pld_rst_n_in, ohssi_avmm1_data_in_aib,
     ohssi_avmm2_data_in_aib, ohssi_fsr_data_in_aib,
     ohssi_fsr_load_in_aib, ohssi_pcs_rx_pld_rst_n_in,
     ohssi_pcs_tx_pld_rst_n_in, ohssi_pld_pma_coreclkin_in,
     ohssi_pld_pma_coreclkin_n_in, ohssi_pld_pma_rxpma_rstb_in,
     ohssi_pld_pma_txdetectrx_in, ohssi_pld_pma_txpma_rstb_in,
     ohssi_pld_sclk_in, ohssi_sr_clk_in_aib, ohssi_ssr_data_in_aib,
     ohssi_ssr_load_in_aib, ohssi_tx_data_in_aib,
     ohssi_tx_dcd_cal_done_in, ohssi_tx_dll_lock_in,
     ohssi_tx_transfer_clk_in, ohssirx_dcc_done_in,
     oshared_direct_async_out_in, rb_dcc_dll_dft_sel,
     rb_dcc_test_clk_pll_en_n, rb_dft_ch_muxsel, vcc, vssl );

output  buf_iatpg_bsr0_scan_in, buf_iatpg_bsr0_scan_shift_clk,
     buf_iatpg_bsr1_scan_in, buf_iatpg_bsr1_scan_shift_clk,
     buf_iatpg_bsr2_scan_in, buf_iatpg_bsr2_scan_shift_clk,
     buf_iatpg_bsr3_scan_in, buf_iatpg_bsr3_scan_shift_clk,
     buf_iatpg_bsr_scan_shift_n, iatpg_pipeline_global_en_out,
     iatpg_scan_clk_in0_out, iatpg_scan_clk_in1_out,
     iatpg_scan_in0_out, iatpg_scan_in1_out, iatpg_scan_mode_n_out,
     iatpg_scan_rst_n_out, iatpg_scan_shift_n_out,
     iavm2out_dataselb_out, iavm2out_en_out,
     idatdll_test_clk_pll_en_n_out, ihssi_avmm1_data_out_buf,
     ihssi_avmm2_data_out_buf, ihssi_dcc_dft_nrst_coding_out,
     ihssi_dcc_dft_nrst_out, ihssi_dcc_dft_up_out,
     ihssi_dcc_dll_entest_out, ihssi_dcc_req_out,
     ihssi_fsr_data_out_buf, ihssi_fsr_load_out_buf,
     ihssi_pld_8g_rxelecidle_out, ihssi_pld_pcs_rx_clk_out_buf,
     ihssi_pld_pcs_rx_clk_out_n_buf, ihssi_pld_pcs_tx_clk_out_buf,
     ihssi_pld_pma_clkdiv_rx_user_out,
     ihssi_pld_pma_clkdiv_tx_user_out, ihssi_pld_pma_hclk_out,
     ihssi_pld_pma_internal_clk1_out, ihssi_pld_pma_internal_clk2_out,
     ihssi_pld_pma_pfdmode_lock_out, ihssi_pld_pma_rxpll_lock_out,
     ihssi_pld_rx_hssi_fifo_latency_pulse_out,
     ihssi_pld_tx_hssi_fifo_latency_pulse_out,
     ihssi_pma_aib_tx_clk_out, ihssi_rb_dcc_byp_dprio_out,
     ihssi_rb_dcc_byp_out, ihssi_rb_dcc_dft_out,
     ihssi_rb_dcc_dft_sel_out, ihssi_rb_dcc_en_dprio_out,
     ihssi_rb_dcc_en_out, ihssi_rb_dcc_manual_mode_dprio_out,
     ihssi_rb_dcc_manual_mode_out, ihssi_rb_half_code_out,
     ihssi_rb_selflock_out, ihssi_rx_transfer_clk_out,
     ihssi_sr_clk_out_in, ihssi_ssr_data_out_buf,
     ihssi_ssr_load_out_buf, ihssi_tx_dcd_cal_req_out,
     ihssi_tx_dll_lock_req_out, ihssitxdll_rb_half_code_str_out,
     ihssitxdll_rb_selflock_str_out,
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
     ired_rshift_en_tx_avmm2_out, ired_rshift_en_txferclkout_out,
     ired_rshift_en_txferclkoutn_out, irstb_out, oatpg_bsr0_scan_out,
     oatpg_bsr1_scan_out, oatpg_bsr2_scan_out, oatpg_bsr3_scan_out,
     oatpg_scan_out0, oatpg_scan_out1, ohssi_adapter_rx_pld_rst_n,
     ohssi_adapter_tx_pld_rst_n, ohssi_fsr_data_in, ohssi_fsr_load_in,
     ohssi_pcs_rx_pld_rst_n, ohssi_pcs_tx_pld_rst_n,
     ohssi_pld_pma_coreclkin, ohssi_pld_pma_coreclkin_n,
     ohssi_pld_pma_rxpma_rstb, ohssi_pld_pma_txdetectrx,
     ohssi_pld_pma_txpma_rstb, ohssi_pld_sclk, ohssi_sr_clk_in,
     ohssi_ssr_data_in, ohssi_ssr_load_in, ohssi_tx_dcd_cal_done,
     ohssi_tx_dll_lock, ohssi_tx_transfer_clk, ohssirx_dcc_done,
     rb_dcc_dll_dft_sel_out, rb_dcc_test_clk_pll_en_n_out,
     rb_dft_ch_muxsel_out;

input  iatpg_bsr0_scan_in, iatpg_bsr0_scan_shift_clk,
     iatpg_bsr1_scan_in, iatpg_bsr1_scan_shift_clk, iatpg_bsr2_scan_in,
     iatpg_bsr2_scan_shift_clk, iatpg_bsr3_scan_in,
     iatpg_bsr3_scan_shift_clk, iatpg_bsr_scan_shift_n,
     iatpg_pipeline_global_en, iatpg_scan_clk_in0, iatpg_scan_clk_in1,
     iatpg_scan_in0, iatpg_scan_in1, iatpg_scan_mode_n,
     iatpg_scan_rst_n, iatpg_scan_shift_n, iavm2out_dataselb,
     iavm2out_en, idatdll_test_clk_pll_en_n, ihssi_avmm1_data_out,
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
     ihssitxdll_str_align_stconfig_spare, init_oatpg_bsr0_scan_out,
     init_oatpg_bsr1_scan_out, init_oatpg_bsr2_scan_out,
     init_oatpg_bsr3_scan_out, ired_rshift_en_tx_avmm2,
     ired_rshift_en_txferclkout, ired_rshift_en_txferclkoutn, irstb,
     oatpg_scan_out0_in, oatpg_scan_out1_in,
     ohssi_adapter_rx_pld_rst_n_in, ohssi_adapter_tx_pld_rst_n_in,
     ohssi_fsr_data_in_aib, ohssi_fsr_load_in_aib,
     ohssi_pcs_rx_pld_rst_n_in, ohssi_pcs_tx_pld_rst_n_in,
     ohssi_pld_pma_coreclkin_in, ohssi_pld_pma_coreclkin_n_in,
     ohssi_pld_pma_rxpma_rstb_in, ohssi_pld_pma_txdetectrx_in,
     ohssi_pld_pma_txpma_rstb_in, ohssi_pld_sclk_in,
     ohssi_sr_clk_in_aib, ohssi_ssr_data_in_aib, ohssi_ssr_load_in_aib,
     ohssi_tx_dcd_cal_done_in, ohssi_tx_dll_lock_in,
     ohssi_tx_transfer_clk_in, ohssirx_dcc_done_in, rb_dcc_dll_dft_sel,
     rb_dcc_test_clk_pll_en_n, rb_dft_ch_muxsel, vcc, vssl;

output [2:0]  ihssi_rb_clkdiv_out;
output [3:0]  ihssirx_out_en_out;
output [1:0]  indrv_r56_out;
output [2:0]  oshared_direct_async_out;
output [1:0]  ired_rshift_en_rx_avmm2_out;
output [4:0]  ihssi_rb_dcc_manual_up_out;
output [2:0]  ihssirx_out_dataselb_out;
output [1:0]  ihssirx_out_ddren_out;
output [2:0]  iaibdftcore2dll_out;
output [1:0]  indrv_r34_out;
output [2:0]  iavm1in_en1_out;
output [2:0]  ihssitx_out_en_out;
output [1:0]  indrv_r12_out;
output [19:0]  ired_rshift_en_pinp_out;
output [2:0]  ihssitx_in_en1_out;
output [1:0]  ohssi_avmm1_data_in;
output [2:0]  ihssirx_async_en_out;
output [2:0]  iavm1in_en0_out;
output [19:0]  ihssitxdll_str_align_stconfig_dftmuxsel_out;
output [51:0]  ihssi_dcc_dll_csr_reg_out;
output [3:0]  ired_rshift_en_tx_out;
output [1:0]  ipdrv_r78_out;
output [1:0]  ipdrv_r12_out;
output [1:0]  ipdrv_r56_out;
output [3:0]  ired_rshift_en_drx_out;
output [1:0]  ired_rshift_en_dirclkp_out;
output [39:0]  ihssi_rx_data_out_buf;
output [2:0]  ired_rshift_en_dtx_out;
output [2:0]  iavm1in_en2_out;
output [2:0]  ihssirx_clk_en_out;
output [4:0]  ihssi_rb_dcc_manual_dn_out;
output [12:0]  oaibdftdll2core;
output [39:0]  ohssi_tx_data_in;
output [2:0]  ihssitxdll_str_align_stconfig_new_dll_out;
output [1:0]  indrv_r78_out;
output [3:0]  ired_rshift_en_rx_out;
output [2:0]  iavm1out_dataselb_out;
output [2:0]  ihssitx_in_en0_out;
output [4:0]  ishared_direct_async_in_outs;
output [1:0]  ipdrv_r34_out;
output [9:0]  ihssitxdll_str_align_dly_pst_out;
output [2:0]  ihssitxdll_rb_clkdiv_str_out;
output [9:0]  ihssitxdll_str_align_dyconfig_ctl_static_out;
output [1:0]  ired_rshift_en_dirclkn_out;
output [2:0]  ihssitx_in_en2_out;
output [2:0]  iavm2in_en0_out;
output [2:0]  ihssitx_out_dataselb_out;
output [2:0]  ihssitx_in_en3_out;
output [1:0]  ohssi_avmm2_data_in;
output [14:0]  ired_avm1_shift_en_out;
output [2:0]  iavm1out_en_out;

input [3:0]  ihssirx_out_en;
input [2:0]  iavm1in_en2;
input [2:0]  iavm1in_en0;
input [2:0]  iavm2in_en0;
input [2:0]  ihssitx_in_en2;
input [3:0]  ired_rshift_en_drx;
input [51:0]  ihssi_dcc_dll_csr_reg;
input [14:0]  ired_avm1_shift_en;
input [4:0]  ihssi_rb_dcc_manual_up;
input [1:0]  ipdrv_r12;
input [3:0]  ired_rshift_en_rx;
input [2:0]  iavm1out_en;
input [2:0]  ihssirx_async_en;
input [2:0]  ihssitxdll_rb_clkdiv_str;
input [39:0]  ohssi_tx_data_in_aib;
input [4:0]  ishared_direct_async_in;
input [2:0]  oshared_direct_async_out_in;
input [19:0]  ired_rshift_en_pinp;
input [2:0]  ihssirx_out_dataselb;
input [19:0]  ihssitxdll_str_align_stconfig_dftmuxsel;
input [9:0]  ihssitxdll_str_align_dyconfig_ctl_static;
input [1:0]  ired_rshift_en_dirclkp;
input [1:0]  indrv_r34;
input [1:0]  indrv_r12;
input [1:0]  ipdrv_r34;
input [12:0]  oaibdftdll2core_in;
input [1:0]  indrv_r78;
input [2:0]  ihssitxdll_str_align_stconfig_new_dll;
input [2:0]  ihssitx_out_dataselb;
input [2:0]  iavm1out_dataselb;
input [1:0]  ohssi_avmm2_data_in_aib;
input [2:0]  ihssi_rb_clkdiv;
input [4:0]  ihssi_rb_dcc_manual_dn;
input [2:0]  ihssitx_in_en3;
input [2:0]  ihssitx_in_en1;
input [1:0]  indrv_r56;
input [1:0]  ihssirx_out_ddren;
input [2:0]  iaibdftcore2dll;
input [9:0]  ihssitxdll_str_align_dly_pst;
input [2:0]  ihssirx_clk_en;
input [3:0]  ired_rshift_en_tx;
input [2:0]  ired_rshift_en_dtx;
input [2:0]  ihssitx_in_en0;
input [1:0]  ired_rshift_en_dirclkn;
input [2:0]  ihssitx_out_en;
input [1:0]  ired_rshift_en_rx_avmm2;
input [39:0]  ihssi_rx_data_out;
input [2:0]  iavm1in_en1;
input [1:0]  ohssi_avmm1_data_in_aib;
input [1:0]  ipdrv_r56;
input [1:0]  ipdrv_r78;


aibcr3_data_buf x237[4:0] ( ishared_direct_async_in_outs[4:0],
     ishared_direct_async_in[4:0], vcc, vssl);
aibcr3_data_buf x238 ( ihssi_pld_pcs_tx_clk_out_buf,
     ihssi_pld_pcs_tx_clk_out, vcc, vssl);
aibcr3_data_buf x231 ( iatpg_scan_in1_out, iatpg_scan_in1, vcc, vssl);
aibcr3_data_buf x204 ( ihssi_rx_transfer_clk_out,
     ihssi_rx_transfer_clk, vcc, vssl);
aibcr3_data_buf x232 ( iatpg_scan_clk_in1_out, iatpg_scan_clk_in1, vcc,
     vssl);
aibcr3_data_buf x236 ( ihssi_pma_aib_tx_clk_out, ihssi_pma_aib_tx_clk,
     vcc, vssl);
aibcr3_data_buf x120 ( ihssi_sr_clk_out_in, ihssi_sr_clk_out, vcc,
     vssl);
aibcr3_data_buf x205[39:0] ( ihssi_rx_data_out_buf[39:0],
     ihssi_rx_data_out[39:0], vcc, vssl);
aibcr3_signal_buf x245[39:0] ( ohssi_tx_data_in[39:0],
     ohssi_tx_data_in_aib[39:0], vcc, vssl);
aibcr3_signal_buf x242 ( ohssi_pcs_tx_pld_rst_n,
     ohssi_pcs_tx_pld_rst_n_in, vcc, vssl);
aibcr3_signal_buf x244 ( ohssi_tx_transfer_clk,
     ohssi_tx_transfer_clk_in, vcc, vssl);
aibcr3_signal_buf x243[2:0] ( oshared_direct_async_out[2:0],
     oshared_direct_async_out_in[2:0], vcc, vssl);
aibcr3_signal_buf x241 ( ohssi_adapter_tx_pld_rst_n,
     ohssi_adapter_tx_pld_rst_n_in, vcc, vssl);
aibcr3_signal_buf x240 ( ohssi_pld_pma_txdetectrx,
     ohssi_pld_pma_txdetectrx_in, vcc, vssl);
aibcr3_signal_buf x239 ( ohssi_pld_pma_txpma_rstb,
     ohssi_pld_pma_txpma_rstb_in, vcc, vssl);
aibcr3_signal_buf x207 ( ohssi_pld_pma_rxpma_rstb,
     ohssi_pld_pma_rxpma_rstb_in, vcc, vssl);
aibcr3_signal_buf x253[1:0] ( indrv_r12_out[1:0], indrv_r12[1:0], vcc,
     vssl);
aibcr3_signal_buf x254 ( irstb_out, irstb, vcc, vssl);
aibcr3_signal_buf x252[1:0] ( indrv_r34_out[1:0], indrv_r34[1:0], vcc,
     vssl);
aibcr3_signal_buf x251[1:0] ( indrv_r56_out[1:0], indrv_r56[1:0], vcc,
     vssl);
aibcr3_signal_buf x250[1:0] ( indrv_r78_out[1:0], indrv_r78[1:0], vcc,
     vssl);
aibcr3_signal_buf x249[1:0] ( ipdrv_r12_out[1:0], ipdrv_r12[1:0], vcc,
     vssl);
aibcr3_signal_buf x248[1:0] ( ipdrv_r34_out[1:0], ipdrv_r34[1:0], vcc,
     vssl);
aibcr3_signal_buf x211 ( ohssi_pld_pma_coreclkin,
     ohssi_pld_pma_coreclkin_in, vcc, vssl);
aibcr3_signal_buf x210 ( ohssi_pld_pma_coreclkin_n,
     ohssi_pld_pma_coreclkin_n_in, vcc, vssl);
aibcr3_signal_buf x209 ( ohssi_pcs_rx_pld_rst_n,
     ohssi_pcs_rx_pld_rst_n_in, vcc, vssl);
aibcr3_signal_buf x208 ( ohssi_adapter_rx_pld_rst_n,
     ohssi_adapter_rx_pld_rst_n_in, vcc, vssl);
aibcr3_signal_buf x206 ( ohssi_pld_sclk, ohssi_pld_sclk_in, vcc, vssl);
aibcr3_signal_buf x246[1:0] ( ipdrv_r78_out[1:0], ipdrv_r78[1:0], vcc,
     vssl);
aibcr3_signal_buf x224[2:0] ( iaibdftcore2dll_out[2:0],
     iaibdftcore2dll[2:0], vcc, vssl);
aibcr3_signal_buf x247[1:0] ( ipdrv_r56_out[1:0], ipdrv_r56[1:0], vcc,
     vssl);
aibcr3_signal_buf x212 ( ihssi_avmm2_data_out_buf,
     ihssi_avmm2_data_out, vcc, vssl);
aibcr3_signal_buf x233 ( ihssi_pld_tx_hssi_fifo_latency_pulse_out,
     ihssi_pld_tx_hssi_fifo_latency_pulse, vcc, vssl);
aibcr3_signal_buf x201 ( ihssi_pld_pma_rxpll_lock_out,
     ihssi_pld_pma_rxpll_lock, vcc, vssl);
aibcr3_signal_buf x230 ( ohssi_tx_dcd_cal_done,
     ohssi_tx_dcd_cal_done_in, vcc, vssl);
aibcr3_signal_buf x229 ( oatpg_scan_out1, oatpg_scan_out1_in, vcc,
     vssl);
aibcr3_signal_buf x228 ( ohssi_tx_dll_lock, ohssi_tx_dll_lock_in, vcc,
     vssl);
aibcr3_signal_buf x297 ( buf_iatpg_bsr2_scan_shift_clk,
     iatpg_bsr2_scan_shift_clk, vcc, vssl);
aibcr3_signal_buf x234 ( ihssi_pld_pma_pfdmode_lock_out,
     ihssi_pld_pma_pfdmode_lock, vcc, vssl);
aibcr3_signal_buf x235 ( ihssi_pld_pma_clkdiv_tx_user_out,
     ihssi_pld_pma_clkdiv_tx_user, vcc, vssl);
aibcr3_signal_buf x213[1:0] ( ohssi_avmm2_data_in[1:0],
     ohssi_avmm2_data_in_aib[1:0], vcc, vssl);
aibcr3_signal_buf x197 ( ihssi_pld_pma_clkdiv_rx_user_out,
     ihssi_pld_pma_clkdiv_rx_user, vcc, vssl);
aibcr3_signal_buf x196 ( ihssi_pld_pma_internal_clk1_out,
     ihssi_pld_pma_internal_clk1, vcc, vssl);
aibcr3_signal_buf x195 ( ihssi_pld_pma_internal_clk2_out,
     ihssi_pld_pma_internal_clk2, vcc, vssl);
aibcr3_signal_buf x186 ( ihssi_dcc_dft_nrst_out, ihssi_dcc_dft_nrst,
     vcc, vssl);
aibcr3_signal_buf x185 ( ihssi_dcc_dft_nrst_coding_out,
     ihssi_dcc_dft_nrst_coding, vcc, vssl);
aibcr3_signal_buf x184 ( ihssi_dcc_dft_up_out, ihssi_dcc_dft_up, vcc,
     vssl);
aibcr3_signal_buf x183 ( ihssi_dcc_req_out, ihssi_dcc_req, vcc, vssl);
aibcr3_signal_buf x190 ( iatpg_scan_clk_in0_out, iatpg_scan_clk_in0,
     vcc, vssl);
aibcr3_signal_buf x189 ( iatpg_scan_in0_out, iatpg_scan_in0, vcc,
     vssl);
aibcr3_signal_buf x303 ( buf_iatpg_bsr3_scan_in, iatpg_bsr3_scan_in,
     vcc, vssl);
aibcr3_signal_buf x302 ( buf_iatpg_bsr1_scan_in, iatpg_bsr1_scan_in,
     vcc, vssl);
aibcr3_signal_buf x301 ( buf_iatpg_bsr2_scan_in, iatpg_bsr2_scan_in,
     vcc, vssl);
aibcr3_signal_buf x203 ( ihssi_pld_pma_hclk_out, ihssi_pld_pma_hclk,
     vcc, vssl);
aibcr3_signal_buf x202 ( ihssi_pld_8g_rxelecidle_out,
     ihssi_pld_8g_rxelecidle, vcc, vssl);
aibcr3_signal_buf x300 ( buf_iatpg_bsr0_scan_in, iatpg_bsr0_scan_in,
     vcc, vssl);
aibcr3_signal_buf x200 ( ihssi_pld_rx_hssi_fifo_latency_pulse_out,
     ihssi_pld_rx_hssi_fifo_latency_pulse, vcc, vssl);
aibcr3_signal_buf x299 ( buf_iatpg_bsr3_scan_shift_clk,
     iatpg_bsr3_scan_shift_clk, vcc, vssl);
aibcr3_signal_buf x307 ( oatpg_bsr0_scan_out, init_oatpg_bsr0_scan_out,
     vcc, vssl);
aibcr3_signal_buf x306 ( oatpg_bsr1_scan_out, init_oatpg_bsr1_scan_out,
     vcc, vssl);
aibcr3_signal_buf x305 ( oatpg_bsr2_scan_out, init_oatpg_bsr2_scan_out,
     vcc, vssl);
aibcr3_signal_buf x304 ( oatpg_bsr3_scan_out, init_oatpg_bsr3_scan_out,
     vcc, vssl);
aibcr3_signal_buf x298 ( buf_iatpg_bsr1_scan_shift_clk,
     iatpg_bsr1_scan_shift_clk, vcc, vssl);
aibcr3_signal_buf x296 ( buf_iatpg_bsr0_scan_shift_clk,
     iatpg_bsr0_scan_shift_clk, vcc, vssl);
aibcr3_signal_buf x226 ( ihssi_tx_dll_lock_req_out,
     ihssi_tx_dll_lock_req, vcc, vssl);
aibcr3_signal_buf x225 ( ihssitxdll_str_align_entest_out,
     ihssitxdll_str_align_entest, vcc, vssl);
aibcr3_signal_buf x223 ( iatpg_pipeline_global_en_out,
     iatpg_pipeline_global_en, vcc, vssl);
aibcr3_signal_buf x220 ( iatpg_scan_rst_n_out, iatpg_scan_rst_n, vcc,
     vssl);
aibcr3_signal_buf x222 ( iatpg_scan_mode_n_out, iatpg_scan_mode_n, vcc,
     vssl);
aibcr3_signal_buf x221 ( iatpg_scan_shift_n_out, iatpg_scan_shift_n,
     vcc, vssl);
aibcr3_signal_buf x182[12:0] ( oaibdftdll2core[12:0],
     oaibdftdll2core_in[12:0], vcc, vssl);
aibcr3_signal_buf x194 ( ohssirx_dcc_done, ohssirx_dcc_done_in, vcc,
     vssl);
aibcr3_signal_buf x199 ( ihssi_pld_pcs_rx_clk_out_n_buf,
     ihssi_pld_pcs_rx_clk_out_n, vcc, vssl);
aibcr3_signal_buf x198 ( ihssi_pld_pcs_rx_clk_out_buf,
     ihssi_pld_pcs_rx_clk_out, vcc, vssl);
aibcr3_signal_buf x193 ( oatpg_scan_out0, oatpg_scan_out0_in, vcc,
     vssl);
aibcr3_signal_buf x187 ( ihssi_dcc_dll_entest_out,
     ihssi_dcc_dll_entest, vcc, vssl);
aibcr3_signal_buf x173 ( ihssi_fsr_load_out_buf, ihssi_fsr_load_out,
     vcc, vssl);
aibcr3_signal_buf x172 ( ihssi_ssr_data_out_buf, ihssi_ssr_data_out,
     vcc, vssl);
aibcr3_signal_buf x171 ( ihssi_fsr_data_out_buf, ihssi_fsr_data_out,
     vcc, vssl);
aibcr3_signal_buf x181 ( ohssi_sr_clk_in, ohssi_sr_clk_in_aib, vcc,
     vssl);
aibcr3_signal_buf x179 ( ohssi_fsr_data_in, ohssi_fsr_data_in_aib, vcc,
     vssl);
aibcr3_signal_buf x180[1:0] ( ohssi_avmm1_data_in[1:0],
     ohssi_avmm1_data_in_aib[1:0], vcc, vssl);
aibcr3_signal_buf x295 ( buf_iatpg_bsr_scan_shift_n,
     iatpg_bsr_scan_shift_n, vcc, vssl);
aibcr3_signal_buf x176 ( ohssi_ssr_load_in, ohssi_ssr_load_in_aib, vcc,
     vssl);
aibcr3_signal_buf x178 ( ohssi_fsr_load_in, ohssi_fsr_load_in_aib, vcc,
     vssl);
aibcr3_signal_buf x177 ( ohssi_ssr_data_in, ohssi_ssr_data_in_aib, vcc,
     vssl);
aibcr3_signal_buf x174 ( ihssi_ssr_load_out_buf, ihssi_ssr_load_out,
     vcc, vssl);
aibcr3_signal_buf x170 ( ihssi_avmm1_data_out_buf,
     ihssi_avmm1_data_out, vcc, vssl);
aibcr3_rambit_buf x263[9:0] (
     ihssitxdll_str_align_dyconfig_ctl_static_out[9:0],
     ihssitxdll_str_align_dyconfig_ctl_static[9:0], vcc, vssl);
aibcr3_rambit_buf x268[2:0] ( ihssitxdll_rb_clkdiv_str_out[2:0],
     ihssitxdll_rb_clkdiv_str[2:0], vcc, vssl);
aibcr3_rambit_buf x267 ( ihssitxdll_rb_half_code_str_out,
     ihssitxdll_rb_half_code_str, vcc, vssl);
aibcr3_rambit_buf x266 ( ihssitxdll_rb_selflock_str_out,
     ihssitxdll_rb_selflock_str, vcc, vssl);
aibcr3_rambit_buf x270[2:0] ( ihssitx_out_dataselb_out[2:0],
     ihssitx_out_dataselb[2:0], vcc, vssl);
aibcr3_rambit_buf x271[2:0] ( ihssitx_in_en3_out[2:0],
     ihssitx_in_en3[2:0], vcc, vssl);
aibcr3_rambit_buf x147[1:0] ( ihssirx_out_ddren_out[1:0],
     ihssirx_out_ddren[1:0], vcc, vssl);
aibcr3_rambit_buf x138[2:0] ( ihssirx_clk_en_out[2:0],
     ihssirx_clk_en[2:0], vcc, vssl);
aibcr3_rambit_buf x148[3:0] ( ihssirx_out_en_out[3:0],
     ihssirx_out_en[3:0], vcc, vssl);
aibcr3_rambit_buf x292 ( ihssitxdll_str_align_stconfig_dll_en_out,
     ihssitxdll_str_align_stconfig_dll_en, vcc, vssl);
aibcr3_rambit_buf x265 ( rb_dcc_dll_dft_sel_out, rb_dcc_dll_dft_sel,
     vcc, vssl);
aibcr3_rambit_buf x264 ( idatdll_test_clk_pll_en_n_out,
     idatdll_test_clk_pll_en_n, vcc, vssl);
aibcr3_rambit_buf x261 (
     ihssitxdll_str_align_stconfig_core_dn_prgmnvrt_out,
     ihssitxdll_str_align_stconfig_core_dn_prgmnvrt, vcc, vssl);
aibcr3_rambit_buf x262 ( ihssitxdll_str_align_dyconfig_ctlsel_out,
     ihssitxdll_str_align_dyconfig_ctlsel, vcc, vssl);
aibcr3_rambit_buf x258[19:0] (
     ihssitxdll_str_align_stconfig_dftmuxsel_out[19:0],
     ihssitxdll_str_align_stconfig_dftmuxsel[19:0], vcc, vssl);
aibcr3_rambit_buf x260 (
     ihssitxdll_str_align_stconfig_core_up_prgmnvrt_out,
     ihssitxdll_str_align_stconfig_core_up_prgmnvrt, vcc, vssl);
aibcr3_rambit_buf x259 ( ihssitxdll_str_align_stconfig_core_updnen_out,
     ihssitxdll_str_align_stconfig_core_updnen, vcc, vssl);
aibcr3_rambit_buf x257 ( ihssi_tx_dcd_cal_req_out,
     ihssi_tx_dcd_cal_req, vcc, vssl);
aibcr3_rambit_buf x145[2:0] ( ihssirx_async_en_out[2:0],
     ihssirx_async_en[2:0], vcc, vssl);
aibcr3_rambit_buf x274[2:0] ( ihssitx_in_en0_out[2:0],
     ihssitx_in_en0[2:0], vcc, vssl);
aibcr3_rambit_buf x273[2:0] ( ihssitx_in_en1_out[2:0],
     ihssitx_in_en1[2:0], vcc, vssl);
aibcr3_rambit_buf x290 ( ihssitxdll_str_align_stconfig_hps_ctrl_en_out,
     ihssitxdll_str_align_stconfig_hps_ctrl_en, vcc, vssl);
aibcr3_rambit_buf x272[2:0] ( ihssitx_in_en2_out[2:0],
     ihssitx_in_en2[2:0], vcc, vssl);
aibcr3_rambit_buf x291 ( ihssitxdll_str_align_stconfig_dll_rst_en_out,
     ihssitxdll_str_align_stconfig_dll_rst_en, vcc, vssl);
aibcr3_rambit_buf x288 (
     ihssitxdll_str_align_stconfig_ndllrst_prgmnvrt_out,
     ihssitxdll_str_align_stconfig_ndllrst_prgmnvrt, vcc, vssl);
aibcr3_rambit_buf x289[2:0] (
     ihssitxdll_str_align_stconfig_new_dll_out[2:0],
     ihssitxdll_str_align_stconfig_new_dll[2:0], vcc, vssl);
aibcr3_rambit_buf x287 ( ihssitxdll_str_align_stconfig_spare_out,
     ihssitxdll_str_align_stconfig_spare, vcc, vssl);
aibcr3_rambit_buf x286[9:0] ( ihssitxdll_str_align_dly_pst_out[9:0],
     ihssitxdll_str_align_dly_pst[9:0], vcc, vssl);
aibcr3_rambit_buf x285[1:0] ( ired_rshift_en_dirclkn_out[1:0],
     ired_rshift_en_dirclkn[1:0], vcc, vssl);
aibcr3_rambit_buf x284[1:0] ( ired_rshift_en_dirclkp_out[1:0],
     ired_rshift_en_dirclkp[1:0], vcc, vssl);
aibcr3_rambit_buf x283[3:0] ( ired_rshift_en_drx_out[3:0],
     ired_rshift_en_drx[3:0], vcc, vssl);
aibcr3_rambit_buf x282[2:0] ( ired_rshift_en_dtx_out[2:0],
     ired_rshift_en_dtx[2:0], vcc, vssl);
aibcr3_rambit_buf x281[19:0] ( ired_rshift_en_pinp_out[19:0],
     ired_rshift_en_pinp[19:0], vcc, vssl);
aibcr3_rambit_buf x280[3:0] ( ired_rshift_en_rx_out[3:0],
     ired_rshift_en_rx[3:0], vcc, vssl);
aibcr3_rambit_buf x279[3:0] ( ired_rshift_en_tx_out[3:0],
     ired_rshift_en_tx[3:0], vcc, vssl);
aibcr3_rambit_buf x278 ( ired_rshift_en_txferclkout_out,
     ired_rshift_en_txferclkout, vcc, vssl);
aibcr3_rambit_buf x277 ( ired_rshift_en_txferclkoutn_out,
     ired_rshift_en_txferclkoutn, vcc, vssl);
aibcr3_rambit_buf x276 ( rb_dft_ch_muxsel_out, rb_dft_ch_muxsel, vcc,
     vssl);
aibcr3_rambit_buf x146[2:0] ( ihssirx_out_dataselb_out[2:0],
     ihssirx_out_dataselb[2:0], vcc, vssl);
aibcr3_rambit_buf x149[51:0] ( ihssi_dcc_dll_csr_reg_out[51:0],
     ihssi_dcc_dll_csr_reg[51:0], vcc, vssl);
aibcr3_rambit_buf x153[2:0] ( ihssi_rb_clkdiv_out[2:0],
     ihssi_rb_clkdiv[2:0], vcc, vssl);
aibcr3_rambit_buf x168[2:0] ( iavm1in_en1_out[2:0], iavm1in_en1[2:0],
     vcc, vssl);
aibcr3_rambit_buf x167[2:0] ( iavm1in_en2_out[2:0], iavm1in_en2[2:0],
     vcc, vssl);
aibcr3_rambit_buf x165[2:0] ( iavm1out_en_out[2:0], iavm1out_en[2:0],
     vcc, vssl);
aibcr3_rambit_buf x269[2:0] ( ihssitx_out_en_out[2:0],
     ihssitx_out_en[2:0], vcc, vssl);
aibcr3_rambit_buf x159 ( ihssi_rb_selflock_out, ihssi_rb_selflock, vcc,
     vssl);
aibcr3_rambit_buf x158 ( ihssi_rb_half_code_out, ihssi_rb_half_code,
     vcc, vssl);
aibcr3_rambit_buf x169[2:0] ( iavm1in_en0_out[2:0], iavm1in_en0[2:0],
     vcc, vssl);
aibcr3_rambit_buf x150 ( ihssi_rb_dcc_byp_out, ihssi_rb_dcc_byp, vcc,
     vssl);
aibcr3_rambit_buf x152 ( ihssi_rb_dcc_dft_out, ihssi_rb_dcc_dft, vcc,
     vssl);
aibcr3_rambit_buf x151 ( ihssi_rb_dcc_dft_sel_out,
     ihssi_rb_dcc_dft_sel, vcc, vssl);
aibcr3_rambit_buf x156 ( ihssi_rb_dcc_en_out, ihssi_rb_dcc_en, vcc,
     vssl);
aibcr3_rambit_buf x166[2:0] ( iavm1out_dataselb_out[2:0],
     iavm1out_dataselb[2:0], vcc, vssl);
aibcr3_rambit_buf x154 ( ihssi_rb_dcc_manual_mode_out,
     ihssi_rb_dcc_manual_mode, vcc, vssl);
aibcr3_rambit_buf x157[4:0] ( ihssi_rb_dcc_manual_up_out[4:0],
     ihssi_rb_dcc_manual_up[4:0], vcc, vssl);
aibcr3_rambit_buf x160 ( rb_dcc_test_clk_pll_en_n_out,
     rb_dcc_test_clk_pll_en_n, vcc, vssl);
aibcr3_rambit_buf x163 ( ihssi_rb_dcc_byp_dprio_out,
     ihssi_rb_dcc_byp_dprio, vcc, vssl);
aibcr3_rambit_buf x162 ( ihssi_rb_dcc_en_dprio_out,
     ihssi_rb_dcc_en_dprio, vcc, vssl);
aibcr3_rambit_buf x161 ( ihssi_rb_dcc_manual_mode_dprio_out,
     ihssi_rb_dcc_manual_mode_dprio, vcc, vssl);
aibcr3_rambit_buf x216[2:0] ( iavm2in_en0_out[2:0], iavm2in_en0[2:0],
     vcc, vssl);
aibcr3_rambit_buf x215 ( iavm2out_dataselb_out, iavm2out_dataselb, vcc,
     vssl);
aibcr3_rambit_buf x218[1:0] ( ired_rshift_en_rx_avmm2_out[1:0],
     ired_rshift_en_rx_avmm2[1:0], vcc, vssl);
aibcr3_rambit_buf x217 ( iavm2out_en_out, iavm2out_en, vcc, vssl);
aibcr3_rambit_buf x219 ( ired_rshift_en_tx_avmm2_out,
     ired_rshift_en_tx_avmm2, vcc, vssl);
aibcr3_rambit_buf x155[4:0] ( ihssi_rb_dcc_manual_dn_out[4:0],
     ihssi_rb_dcc_manual_dn[4:0], vcc, vssl);
aibcr3_rambit_buf x164[14:0] ( ired_avm1_shift_en_out[14:0],
     ired_avm1_shift_en[14:0], vcc, vssl);

endmodule
