// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//-----------------------------------------------------------------------------
// Copyright (C) 2015 Altera Corporation. .  Altera products are
// protected under numerous U.S. and foreign patents, maskwork rights, copyrights and
// other intellectual property laws.
//
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// Description: Hardware-based configuration decoding logic
//
//
//---------------------------------------------------------------------------
//
//
//-----------------------------------------------------------------------------
// Change log
//
//
//
//
//-----------------------------------------------------------------------------
module c3aibadapt_hwcfg_dec (

  output wire           o_ifctl_usr_active,
  output wire [2:0]     o_tx_chnl_datapath_map_mode,
  output wire           o_tx_usertest_sel,
  output wire           o_tx_latency_src_xcvrif,
  output wire [4:0]     o_tx_fifo_empty,
  output wire [4:0]     o_tx_fifo_full,
  output wire [2:0]     o_tx_phcomp_rd_delay,
  output wire           o_tx_double_read,
  output wire           o_tx_stop_read,
  output wire           o_tx_stop_write,
  output wire [4:0]     o_tx_fifo_pempty,
  output wire [4:0]     o_tx_fifo_pfull,
  output wire           o_tx_wa_en,
  output wire [1:0]     o_tx_fifo_power_mode,
  output wire [2:0]     o_tx_stretch_num_stages,
  output wire [2:0]     o_tx_datapath_tb_sel,
  output wire           o_tx_wr_adj_en,
  output wire           o_tx_rd_adj_en,
  output wire           o_tx_async_pld_txelecidle_rst_val,
  output wire           o_tx_async_hip_aib_fsr_in_bit0_rst_val,
  output wire           o_tx_async_hip_aib_fsr_in_bit1_rst_val,
  output wire           o_tx_async_hip_aib_fsr_in_bit2_rst_val,
  output wire           o_tx_async_hip_aib_fsr_in_bit3_rst_val,
  output wire           o_tx_async_pld_pmaif_mask_tx_pll_rst_val,
  output wire           o_tx_async_hip_aib_fsr_out_bit0_rst_val,
  output wire           o_tx_async_hip_aib_fsr_out_bit1_rst_val,
  output wire           o_tx_async_hip_aib_fsr_out_bit2_rst_val,
  output wire           o_tx_async_hip_aib_fsr_out_bit3_rst_val,
  output wire [1:0]     o_tx_fifo_rd_clk_sel,
  output wire           o_tx_fifo_wr_clk_scg_en,
  output wire           o_tx_fifo_rd_clk_scg_en,
  output wire           o_tx_osc_clk_scg_en,
  output wire           o_tx_free_run_div_clk,
  output wire           o_tx_hrdrst_rst_sm_dis,
  output wire           o_tx_hrdrst_dcd_cal_done_bypass,
  output wire           o_tx_hrdrst_dll_lock_bypass,
  output wire           o_tx_hrdrst_align_bypass,
  output wire           o_tx_hrdrst_user_ctl_en,
  output wire           o_tx_hrdrst_rx_osc_clk_scg_en,
  output wire           o_tx_hip_osc_clk_scg_en,
  output wire [2:0]     o_rx_chnl_datapath_map_mode,
  output wire [2:0]     o_rx_pcs_testbus_sel,
  output wire [4:0]     o_rx_fifo_empty,
  output wire [1:0]     o_rx_fifo_mode,
  output wire           o_rx_wm_en,
  output wire [4:0]     o_rx_fifo_full,
  output wire [2:0]     o_rx_phcomp_rd_delay,
  output wire           o_rx_double_write,
  output wire           o_rx_stop_read,
  output wire           o_rx_stop_write,
  output wire [4:0]     o_rx_fifo_pempty,
  output wire [1:0]     o_rx_fifo_power_mode,
  output wire [4:0]     o_rx_fifo_pfull,
  output wire [2:0]     o_rx_stretch_num_stages,
  output wire [3:0]     o_rx_datapath_tb_sel,
  output wire           o_rx_wr_adj_en,
  output wire           o_rx_rd_adj_en,
  output wire           o_rx_msb_rdptr_pipe_byp,
  output wire           o_tx_dv_gating_en,
  output wire [1:0]     o_rx_adapter_lpbk_mode,
  output wire           o_rx_aib_lpbk_en,
  output wire           o_tx_rev_lpbk,
  output wire           o_rx_hrdrst_user_ctl_en,
  output wire [1:0]     o_rx_usertest_sel,
  output wire           o_rx_pld_8g_a1a2_k1k2_flag_polling_bypass,
  output wire           o_rx_10g_krfec_rx_diag_data_status_polling_bypass,
  output wire           o_rx_pld_8g_wa_boundary_polling_bypass,
  output wire           o_rx_pcspma_testbus_sel,
  output wire           o_rx_pld_pma_pcie_sw_done_polling_bypass,
  output wire           o_rx_pld_pma_reser_in_polling_bypass,
  output wire           o_rx_pld_pma_testbus_polling_bypass,
  output wire           o_rx_pld_test_data_polling_bypass,
  output wire           o_rx_async_pld_ltr_rst_val,
  output wire           o_rx_async_pld_pma_ltd_b_rst_val,
  output wire           o_rx_async_pld_8g_signal_detect_out_rst_val,
  output wire           o_rx_async_pld_10g_rx_crc32_err_rst_val,
  output wire           o_rx_async_pld_rx_fifo_align_clr_rst_val,
  output wire           o_rx_async_hip_en,
  output wire   [1:0]   o_rx_parity_sel,
  output wire           o_rx_internal_clk1_sel0,
  output wire           o_rx_internal_clk1_sel1,
  output wire           o_rx_internal_clk1_sel2,
  output wire           o_rx_internal_clk1_sel3,
  output wire           o_rx_txfiford_pre_ct_sel,
  output wire           o_rx_txfiford_post_ct_sel,
  output wire           o_rx_txfifowr_post_ct_sel,
  output wire           o_rx_txfifowr_from_aib_sel,
  output wire           o_rx_pma_coreclkin_sel,
  output wire [2:0]     o_rx_fifo_wr_clk_sel,
  output wire [2:0]     o_rx_fifo_rd_clk_sel,
  output wire [3:0]     o_rx_internal_clk1_sel,
  output wire [3:0]     o_rx_internal_clk2_sel,
  output wire           o_rx_fifo_wr_clk_scg_en,
  output wire           o_rx_fifo_rd_clk_scg_en,
  output wire           o_rx_osc_clk_scg_en,
  output wire           o_rx_free_run_div_clk,
  output wire           o_rx_hrdrst_rst_sm_dis,
  output wire           o_rx_hrdrst_dcd_cal_done_bypass,
  output wire           o_rx_rmfflag_stretch_enable,
  output wire [2:0]     o_rx_rmfflag_stretch_num_stages,
  output wire           o_rx_hrdrst_rx_osc_clk_scg_en,
  output  wire          o_rx_internal_clk2_sel0,
  output  wire          o_rx_internal_clk2_sel1,
  output  wire          o_rx_internal_clk2_sel2,
  output  wire          o_rx_internal_clk2_sel3,
  output  wire          o_rx_rxfifowr_pre_ct_sel,
  output  wire          o_rx_rxfifowr_post_ct_sel,
  output  wire          o_rx_rxfiford_post_ct_sel,
  output  wire          o_rx_rxfiford_to_aib_sel,
  output wire           o_avmm2_osc_clk_scg_en,
  output wire           o_sr_hip_en,
  output wire           o_sr_reserbits_in_en,
  output wire           o_sr_reserbits_out_en,
  output wire           o_sr_osc_clk_scg_en,
  output wire [1:0]     o_sr_osc_clk_div_sel,
  output wire           o_sr_free_run_div_clk,
  output wire           o_sr_test_enable,
  output wire           o_sr_parity_en,
  output wire [7:0]     o_aib_dprio_ctrl_0,
  output wire [7:0]     o_aib_dprio_ctrl_1,
  output wire [7:0]     o_aib_dprio_ctrl_2,
  output wire [7:0]     o_aib_dprio_ctrl_3,
  output wire [7:0]     o_aib_dprio_ctrl_4,
  output wire           o_avmm_hrdrst_osc_clk_scg_en,
  output wire [1:0]     o_avmm_testbus_sel,
  output wire           o_avmm1_osc_clk_scg_en,
  output wire           o_avmm1_avmm_clk_scg_en,
  output wire           o_avmm1_avmm_clk_dcg_en,
  output wire           o_avmm1_free_run_div_clk,
  output wire [5:0]     o_avmm1_rdfifo_full,
  output wire           o_avmm1_rdfifo_stop_read,
  output wire           o_avmm1_rdfifo_stop_write,
  output wire [5:0]     o_avmm1_rdfifo_empty,
  output wire           o_avmm1_use_rsvd_bit1,
  output wire           o_avmm2_avmm_clk_scg_en,
  output wire           o_avmm2_avmm_clk_dcg_en,
  output wire           o_avmm2_free_run_div_clk,
  output wire [5:0]     o_avmm2_rdfifo_full,
  output wire           o_avmm2_rdfifo_stop_read,
  output wire           o_avmm2_rdfifo_stop_write,
  output wire [5:0]     o_avmm2_rdfifo_empty,
  output wire           o_rstctl_tx_elane_ovrval,
  output wire           o_rstctl_tx_elane_ovren,
  output wire           o_rstctl_rx_elane_ovrval,
  output wire           o_rstctl_rx_elane_ovren,
  output wire           o_rstctl_tx_xcvrif_ovrval,
  output wire           o_rstctl_tx_xcvrif_ovren,
  output wire           o_rstctl_rx_xcvrif_ovrval,
  output wire           o_rstctl_rx_xcvrif_ovren,
  output wire           o_rstctl_tx_adpt_ovrval,
  output wire           o_rstctl_tx_adpt_ovren,
  output wire           o_rstctl_rx_adpt_ovrval,
  output wire           o_rstctl_rx_adpt_ovren,
  output wire           o_rstctl_tx_pld_div2_rst_opt ,
  output wire [7:0]     o_aib_csr_ctrl_0,
  output wire [7:0]     o_aib_csr_ctrl_1,
  output wire [7:0]     o_aib_csr_ctrl_2,
  output wire [7:0]     o_aib_csr_ctrl_3,
  output wire [7:0]     o_aib_csr_ctrl_4,
  output wire [7:0]     o_aib_csr_ctrl_5,
  output wire [7:0]     o_aib_csr_ctrl_6,
  output wire [7:0]     o_aib_csr_ctrl_7,
  output wire [7:0]     o_aib_csr_ctrl_8,
  output wire [7:0]     o_aib_csr_ctrl_9,
  output wire [7:0]     o_aib_csr_ctrl_10,
  output wire [7:0]     o_aib_csr_ctrl_11,
  output wire [7:0]     o_aib_csr_ctrl_12,
  output wire [7:0]     o_aib_csr_ctrl_13,
  output wire [7:0]     o_aib_csr_ctrl_14,
  output wire [7:0]     o_aib_csr_ctrl_15,
  output wire [7:0]     o_aib_csr_ctrl_16,
  output wire [7:0]     o_aib_csr_ctrl_17,
  output wire [7:0]     o_aib_csr_ctrl_18,
  output wire [7:0]     o_aib_csr_ctrl_19,
  output wire [7:0]     o_aib_csr_ctrl_20,
  output wire [7:0]     o_aib_csr_ctrl_21,
  output wire [7:0]     o_aib_csr_ctrl_22,
  output wire [7:0]     o_aib_csr_ctrl_23,
  output wire [7:0]     o_aib_csr_ctrl_24,
  output wire [7:0]     o_aib_csr_ctrl_25,
  output wire [7:0]     o_aib_csr_ctrl_26,
  output wire [7:0]     o_aib_csr_ctrl_27,
  output wire [7:0]     o_aib_csr_ctrl_28,
  output wire [7:0]     o_aib_csr_ctrl_29,
  output wire [7:0]     o_aib_csr_ctrl_30,
  output wire [7:0]     o_aib_csr_ctrl_31,
  output wire [7:0]     o_aib_csr_ctrl_32,
  output wire [7:0]     o_aib_csr_ctrl_33,
  output wire [7:0]     o_aib_csr_ctrl_34,
  output wire [7:0]     o_aib_csr_ctrl_35,
  output wire [7:0]     o_aib_csr_ctrl_36,
  output wire [7:0]     o_aib_csr_ctrl_37,
  output wire [7:0]     o_aib_csr_ctrl_38,
  output wire [7:0]     o_aib_csr_ctrl_39,
  output wire [7:0]     o_aib_csr_ctrl_40,
  output wire [7:0]     o_aib_csr_ctrl_41,
  output wire [7:0]     o_aib_csr_ctrl_42,
  output wire [7:0]     o_aib_csr_ctrl_43,
  output wire [7:0]     o_aib_csr_ctrl_44,
  output wire [7:0]     o_aib_csr_ctrl_45,
  output wire [7:0]     o_aib_csr_ctrl_46,
  output wire [7:0]     o_aib_csr_ctrl_47,
  output wire [7:0]     o_aib_csr_ctrl_48,
  output wire [7:0]     o_aib_csr_ctrl_49,
  output wire [7:0]     o_aib_csr_ctrl_50,
  output wire [7:0]     o_aib_csr_ctrl_51,
  output wire [7:0]     o_aib_csr_ctrl_52,
  output wire [7:0]     o_aib_csr_ctrl_53,
  
  input  wire           scan_mode_n,
  input  wire           r_ifctl_hwcfg_aib_en,
  input  wire           r_ifctl_hwcfg_adpt_en,
  input  wire [6:0]     r_ifctl_hwcfg_mode,
  input  wire           i_ifctl_usr_active,
  input  wire [2:0]     i_tx_chnl_datapath_map_mode,
  input  wire           i_tx_usertest_sel,
  input  wire           i_tx_latency_src_xcvrif,
  input  wire [4:0]     i_tx_fifo_empty,
  input  wire [4:0]     i_tx_fifo_full,
  input  wire [2:0]     i_tx_phcomp_rd_delay,
  input  wire           i_tx_double_read,
  input  wire           i_tx_stop_read,
  input  wire           i_tx_stop_write,
  input  wire [4:0]     i_tx_fifo_pempty,
  input  wire [4:0]     i_tx_fifo_pfull,
  input  wire           i_tx_wa_en,
  input  wire [1:0]     i_tx_fifo_power_mode,
  input  wire [2:0]     i_tx_stretch_num_stages,
  input  wire [2:0]     i_tx_datapath_tb_sel,
  input  wire           i_tx_wr_adj_en,
  input  wire           i_tx_rd_adj_en,
  input  wire           i_tx_async_pld_txelecidle_rst_val,
  input  wire           i_tx_async_hip_aib_fsr_in_bit0_rst_val,
  input  wire           i_tx_async_hip_aib_fsr_in_bit1_rst_val,
  input  wire           i_tx_async_hip_aib_fsr_in_bit2_rst_val,
  input  wire           i_tx_async_hip_aib_fsr_in_bit3_rst_val,
  input  wire           i_tx_async_pld_pmaif_mask_tx_pll_rst_val,
  input  wire           i_tx_async_hip_aib_fsr_out_bit0_rst_val,
  input  wire           i_tx_async_hip_aib_fsr_out_bit1_rst_val,
  input  wire           i_tx_async_hip_aib_fsr_out_bit2_rst_val,
  input  wire           i_tx_async_hip_aib_fsr_out_bit3_rst_val,
  input  wire [1:0]     i_tx_fifo_rd_clk_sel,
  input  wire           i_tx_fifo_wr_clk_scg_en,
  input  wire           i_tx_fifo_rd_clk_scg_en,
  input  wire           i_tx_osc_clk_scg_en,
  input  wire           i_tx_free_run_div_clk,
  input  wire           i_tx_hrdrst_rst_sm_dis,
  input  wire           i_tx_hrdrst_dcd_cal_done_bypass,
  input  wire           i_tx_hrdrst_dll_lock_bypass,
  input  wire           i_tx_hrdrst_align_bypass,
  input  wire           i_tx_hrdrst_user_ctl_en,
  input  wire           i_tx_hrdrst_rx_osc_clk_scg_en,
  input  wire           i_tx_hip_osc_clk_scg_en,
  input  wire [2:0]     i_rx_chnl_datapath_map_mode,
  input  wire [2:0]     i_rx_pcs_testbus_sel,
  input  wire [4:0]     i_rx_fifo_empty,
  input  wire [1:0]     i_rx_fifo_mode,
  input  wire           i_rx_wm_en,
  input  wire [4:0]     i_rx_fifo_full,
  input  wire [2:0]     i_rx_phcomp_rd_delay,
  input  wire           i_rx_double_write,
  input  wire           i_rx_stop_read,
  input  wire           i_rx_stop_write,
  input  wire [4:0]     i_rx_fifo_pempty,
  input  wire [1:0]     i_rx_fifo_power_mode,
  input  wire [4:0]     i_rx_fifo_pfull,
  input  wire [2:0]     i_rx_stretch_num_stages,
  input  wire [3:0]     i_rx_datapath_tb_sel,
  input  wire           i_rx_wr_adj_en,
  input  wire           i_rx_rd_adj_en,
  input  wire           i_rx_msb_rdptr_pipe_byp,
  input  wire           i_tx_dv_gating_en,
  input  wire [1:0]     i_rx_adapter_lpbk_mode,
  input  wire           i_rx_aib_lpbk_en,
  input  wire           i_tx_rev_lpbk,
  input  wire           i_rx_hrdrst_user_ctl_en,
  input  wire [1:0]     i_rx_usertest_sel,
  input  wire           i_rx_pld_8g_a1a2_k1k2_flag_polling_bypass,
  input  wire           i_rx_10g_krfec_rx_diag_data_status_polling_bypass,
  input  wire           i_rx_pld_8g_wa_boundary_polling_bypass,
  input  wire           i_rx_pcspma_testbus_sel,
  input  wire           i_rx_pld_pma_pcie_sw_done_polling_bypass,
  input  wire           i_rx_pld_pma_reser_in_polling_bypass,
  input  wire           i_rx_pld_pma_testbus_polling_bypass,
  input  wire           i_rx_pld_test_data_polling_bypass,
  input  wire           i_rx_async_pld_ltr_rst_val,
  input  wire           i_rx_async_pld_pma_ltd_b_rst_val,
  input  wire           i_rx_async_pld_8g_signal_detect_out_rst_val,
  input  wire           i_rx_async_pld_10g_rx_crc32_err_rst_val,
  input  wire           i_rx_async_pld_rx_fifo_align_clr_rst_val,
  input  wire           i_rx_async_hip_en,
  input  wire   [1:0]   i_rx_parity_sel,
  input  wire           i_rx_internal_clk1_sel0,
  input  wire           i_rx_internal_clk1_sel1,
  input  wire           i_rx_internal_clk1_sel2,
  input  wire           i_rx_internal_clk1_sel3,
  input  wire           i_rx_txfiford_pre_ct_sel,
  input  wire           i_rx_txfiford_post_ct_sel,
  input  wire           i_rx_txfifowr_post_ct_sel,
  input  wire           i_rx_txfifowr_from_aib_sel,
  input  wire           i_rx_pma_coreclkin_sel,
  input  wire [2:0]     i_rx_fifo_wr_clk_sel,
  input  wire [2:0]     i_rx_fifo_rd_clk_sel,
  input  wire [3:0]     i_rx_internal_clk1_sel,
  input  wire [3:0]     i_rx_internal_clk2_sel,
  input  wire           i_rx_fifo_wr_clk_scg_en,
  input  wire           i_rx_fifo_rd_clk_scg_en,
  input  wire           i_rx_osc_clk_scg_en,
  input  wire           i_rx_free_run_div_clk,
  input  wire           i_rx_hrdrst_rst_sm_dis,
  input  wire           i_rx_hrdrst_dcd_cal_done_bypass,
  input  wire           i_rx_rmfflag_stretch_enable,
  input  wire [2:0]     i_rx_rmfflag_stretch_num_stages,
  input  wire           i_rx_hrdrst_rx_osc_clk_scg_en,
  input   wire          i_rx_internal_clk2_sel0,
  input   wire          i_rx_internal_clk2_sel1,
  input   wire          i_rx_internal_clk2_sel2,
  input   wire          i_rx_internal_clk2_sel3,
  input   wire          i_rx_rxfifowr_pre_ct_sel,
  input   wire          i_rx_rxfifowr_post_ct_sel,
  input   wire          i_rx_rxfiford_post_ct_sel,
  input   wire          i_rx_rxfiford_to_aib_sel,
  input  wire           i_avmm2_osc_clk_scg_en,
  input  wire           i_sr_hip_en,
  input  wire           i_sr_reserbits_in_en,
  input  wire           i_sr_reserbits_out_en,
  input  wire           i_sr_osc_clk_scg_en,
  input  wire [1:0]     i_sr_osc_clk_div_sel,
  input  wire           i_sr_free_run_div_clk,
  input  wire           i_sr_test_enable,
  input  wire           i_sr_parity_en,
  input  wire [7:0]     i_aib_dprio_ctrl_0,
  input  wire [7:0]     i_aib_dprio_ctrl_1,
  input  wire [7:0]     i_aib_dprio_ctrl_2,
  input  wire [7:0]     i_aib_dprio_ctrl_3,
  input  wire [7:0]     i_aib_dprio_ctrl_4,
  input  wire           i_avmm_hrdrst_osc_clk_scg_en,
  input  wire [1:0]     i_avmm_testbus_sel,
  input  wire           i_avmm1_osc_clk_scg_en,
  input  wire           i_avmm1_avmm_clk_scg_en,
  input  wire           i_avmm1_avmm_clk_dcg_en,
  input  wire           i_avmm1_free_run_div_clk,
  input  wire [5:0]     i_avmm1_rdfifo_full,
  input  wire           i_avmm1_rdfifo_stop_read,
  input  wire           i_avmm1_rdfifo_stop_write,
  input  wire [5:0]     i_avmm1_rdfifo_empty,
  input  wire           i_avmm1_use_rsvd_bit1,
  input  wire           i_avmm2_avmm_clk_scg_en,
  input  wire           i_avmm2_avmm_clk_dcg_en,
  input  wire           i_avmm2_free_run_div_clk,
  input  wire [5:0]     i_avmm2_rdfifo_full,
  input  wire           i_avmm2_rdfifo_stop_read,
  input  wire           i_avmm2_rdfifo_stop_write,
  input  wire [5:0]     i_avmm2_rdfifo_empty,
  input  wire           i_rstctl_tx_elane_ovrval,
  input  wire           i_rstctl_tx_elane_ovren,
  input  wire           i_rstctl_rx_elane_ovrval,
  input  wire           i_rstctl_rx_elane_ovren,
  input  wire           i_rstctl_tx_xcvrif_ovrval,
  input  wire           i_rstctl_tx_xcvrif_ovren,
  input  wire           i_rstctl_rx_xcvrif_ovrval,
  input  wire           i_rstctl_rx_xcvrif_ovren,
  input  wire           i_rstctl_tx_adpt_ovrval,
  input  wire           i_rstctl_tx_adpt_ovren,
  input  wire           i_rstctl_rx_adpt_ovrval,
  input  wire           i_rstctl_rx_adpt_ovren,
  input  wire           i_rstctl_tx_pld_div2_rst_opt ,
  input  wire [7:0]     i_aib_csr_ctrl_0,
  input  wire [7:0]     i_aib_csr_ctrl_1,
  input  wire [7:0]     i_aib_csr_ctrl_2,
  input  wire [7:0]     i_aib_csr_ctrl_3,
  input  wire [7:0]     i_aib_csr_ctrl_4,
  input  wire [7:0]     i_aib_csr_ctrl_5,
  input  wire [7:0]     i_aib_csr_ctrl_6,
  input  wire [7:0]     i_aib_csr_ctrl_7,
  input  wire [7:0]     i_aib_csr_ctrl_8,
  input  wire [7:0]     i_aib_csr_ctrl_9,
  input  wire [7:0]     i_aib_csr_ctrl_10,
  input  wire [7:0]     i_aib_csr_ctrl_11,
  input  wire [7:0]     i_aib_csr_ctrl_12,
  input  wire [7:0]     i_aib_csr_ctrl_13,
  input  wire [7:0]     i_aib_csr_ctrl_14,
  input  wire [7:0]     i_aib_csr_ctrl_15,
  input  wire [7:0]     i_aib_csr_ctrl_16,
  input  wire [7:0]     i_aib_csr_ctrl_17,
  input  wire [7:0]     i_aib_csr_ctrl_18,
  input  wire [7:0]     i_aib_csr_ctrl_19,
  input  wire [7:0]     i_aib_csr_ctrl_20,
  input  wire [7:0]     i_aib_csr_ctrl_21,
  input  wire [7:0]     i_aib_csr_ctrl_22,
  input  wire [7:0]     i_aib_csr_ctrl_23,
  input  wire [7:0]     i_aib_csr_ctrl_24,
  input  wire [7:0]     i_aib_csr_ctrl_25,
  input  wire [7:0]     i_aib_csr_ctrl_26,
  input  wire [7:0]     i_aib_csr_ctrl_27,
  input  wire [7:0]     i_aib_csr_ctrl_28,
  input  wire [7:0]     i_aib_csr_ctrl_29,
  input  wire [7:0]     i_aib_csr_ctrl_30,
  input  wire [7:0]     i_aib_csr_ctrl_31,
  input  wire [7:0]     i_aib_csr_ctrl_32,
  input  wire [7:0]     i_aib_csr_ctrl_33,
  input  wire [7:0]     i_aib_csr_ctrl_34,
  input  wire [7:0]     i_aib_csr_ctrl_35,
  input  wire [7:0]     i_aib_csr_ctrl_36,
  input  wire [7:0]     i_aib_csr_ctrl_37,
  input  wire [7:0]     i_aib_csr_ctrl_38,
  input  wire [7:0]     i_aib_csr_ctrl_39,
  input  wire [7:0]     i_aib_csr_ctrl_40,
  input  wire [7:0]     i_aib_csr_ctrl_41,
  input  wire [7:0]     i_aib_csr_ctrl_42,
  input  wire [7:0]     i_aib_csr_ctrl_43,
  input  wire [7:0]     i_aib_csr_ctrl_44,
  input  wire [7:0]     i_aib_csr_ctrl_45,
  input  wire [7:0]     i_aib_csr_ctrl_46,
  input  wire [7:0]     i_aib_csr_ctrl_47,
  input  wire [7:0]     i_aib_csr_ctrl_48,
  input  wire [7:0]     i_aib_csr_ctrl_49,
  input  wire [7:0]     i_aib_csr_ctrl_50,
  input  wire [7:0]     i_aib_csr_ctrl_51,
  input  wire [7:0]     i_aib_csr_ctrl_52,
  input  wire [7:0]     i_aib_csr_ctrl_53 
);

localparam DISABLED_BLOCK        = 7'b000_0000;
localparam PMA_DIR_SC            = 7'b000_0001;
localparam PMA_DIR_DC_P0         = 7'b000_0010;
localparam PMA_DIR_DC_P1         = 7'b000_0011;
localparam EHIP_4CH_P0           = 7'b000_0100;
localparam EHIP_4CH_P1           = 7'b000_0101;
localparam EHIP_4CH_P2           = 7'b000_0110;
localparam EHIP_4CH_P3           = 7'b000_0111;
localparam EHIP_4CH_P4           = 7'b000_1000;
localparam ELANE_1CH_P0          = 7'b000_1001;
localparam ELANE_1CH_P1          = 7'b000_1010;
localparam ELANE_1CH_P2          = 7'b000_1011;
localparam ELANE_1CH_P3          = 7'b000_1100;
localparam ELANE_1CH_P4          = 7'b000_1101;
localparam EHIP_4CH_FEC_P0       = 7'b000_1110;
localparam EHIP_4CH_FEC_P1       = 7'b000_1111;
localparam EHIP_4CH_FEC_P2       = 7'b001_0000;
localparam EHIP_4CH_FEC_P3       = 7'b001_0001;
localparam EHIP_4CH_FEC_P4       = 7'b001_0010;
localparam EHIP_4CH_PTP_FEC      = 7'b001_0011;
localparam ELANE_1CH_FEC_4CH_P0  = 7'b001_0100;
localparam ELANE_1CH_FEC_4CH_P1  = 7'b001_0101;
localparam ELANE_1CH_FEC_4CH_P2  = 7'b001_0110;
localparam ELANE_1CH_FEC_4CH_P3  = 7'b001_0111;
localparam ELANE_1CH_FEC_4CH_P4  = 7'b001_1000;
localparam ELANE_1CH_FEC_4CH_PTP = 7'b001_1001;
localparam DIRFEC_1CH_DIRFEC_4CH = 7'b001_1010;
localparam DIRFEC_100G           = 7'b001_1011;

localparam ADPT_ENABLE              = 1'b1;
localparam ADPT_DISABLE             = 1'b0;
localparam MAP_TX_DIS               = 3'b000;
localparam MAP_TX_EHIP              = 3'b001;
localparam MAP_TX_ELANE             = 3'b010;
localparam MAP_TX_PMADIR            = 3'b100;
localparam MAP_TX_RSFEC             = 3'b011;
localparam MAP_RX_DIS               = 3'b000;
localparam MAP_RX_EHIP              = 3'b001;
localparam MAP_RX_ELANE             = 3'b010;
localparam MAP_RX_RSFEC             = 3'b011;
localparam MAP_RX_PMADIR            = 3'b100;
localparam TXFIFO_EMPTY             = 5'b0_0000;
localparam TXFIFOFULL_SW            = 5'b0_0111;
localparam TXFIFOFULL_DW            = 5'b0_1111;
localparam PHCOMP_RD_DEL2           = 3'b010;
localparam PHCOMP_RD_DEL3           = 3'b011;
localparam RXFIFOMODE_PHCOMP        = 2'b01;
localparam RXFIFOMODE_BYPASS        = 2'b00;
localparam RXFIFOFULL_SW            = 5'b00111;
localparam RXFIFOFULL_DW            = 5'b01110;
localparam FIFOSTOPRD_EMPTY         = 1'b0;
localparam FIFOSTOPWR_FULL          = 1'b0;
localparam HALF_W_HALF_D            = 2'b00;
localparam FULL_W_FULL_D            = 2'b11;
localparam ZERO_STAGE               = 3'b000;
localparam SEVEN_STAGE              = 3'b111;
localparam RXFIFOWRCLK_RX_EHIP      = 3'b000;
localparam RXFIFOWRCLK_RX_RSFEC     = 3'b001;
localparam RXFIFOWRCLK_RX_ELANE     = 3'b010;
localparam RXFIFOWRCLK_XFER_DIV2    = 3'b101;
localparam RXFIFORDCLK_RX_PMA       = 3'b010;
localparam RXFIFORDCLK_TX_PMA       = 3'b011;
localparam RXFIFORDCLK_TX_XFER      = 3'b100;
localparam RXFIFORDCLK_RX_EHIP_FRD  = 3'b000;
localparam OUT_OF_RESET_SYNC        = 1'b0;
localparam RMFFLAG_ZERO_STAGE       = 3'b000;
localparam RMFFLAG_TWO_STAGE        = 3'b010;
localparam NO_DIV                   = 2'b00;
localparam DIV2                     = 2'b01;
localparam AVMM1_OUT_OF_RESET_SYNC  = 1'b0;
localparam AVMM1_RDFIFO_N_RD_EMPTY  = 1'b0;
localparam AVMM1_RDFIFO_N_WR_FULL   = 1'b1;
localparam AVMM2_OUT_OF_RESET_SYNC  = 1'b0;
localparam AVMM2_RDFIFO_N_RD_EMPTY  = 1'b0;
localparam AVMM2_RDFIFO_N_WR_FULL   = 1'b1;
localparam TXFIFORDCLK_TX_EHIP      = 2'b00;
localparam TXFIFORDCLK_TX_ELANE     = 2'b01;
localparam TXFIFORDCLK_TX_RSFEC     = 2'b10;
localparam TXFIFORDCLK_TX_XFER_DIV2 = 2'b11;
localparam SRPARITY_FUNC_SEL        = 2'b00;

wire block_disabled;
wire mode_pmadir;
wire mode_ehip;
wire mode_elane_pcs_rc;
wire mode_rsfec;
wire mode_dirfec;
wire mode_elane_ptp;
wire mode_elane_1ch;
wire mode_ptp_active;

assign block_disabled = (r_ifctl_hwcfg_mode == DISABLED_BLOCK);

assign mode_dirfec = (r_ifctl_hwcfg_mode == DIRFEC_100G);
assign mode_rsfec  = mode_dirfec || (r_ifctl_hwcfg_mode == DIRFEC_1CH_DIRFEC_4CH);

assign mode_pmadir = (r_ifctl_hwcfg_mode == PMA_DIR_SC)    ||
                     (r_ifctl_hwcfg_mode == PMA_DIR_DC_P0) ||
                     (r_ifctl_hwcfg_mode == PMA_DIR_DC_P1);

assign mode_ehip   = (r_ifctl_hwcfg_mode == EHIP_4CH_P0)     ||
                     (r_ifctl_hwcfg_mode == EHIP_4CH_P1)     ||
                     (r_ifctl_hwcfg_mode == EHIP_4CH_P2)     ||
                     (r_ifctl_hwcfg_mode == EHIP_4CH_P3)     ||
                     (r_ifctl_hwcfg_mode == EHIP_4CH_P4)     ||
                     (r_ifctl_hwcfg_mode == EHIP_4CH_FEC_P0) ||
                     (r_ifctl_hwcfg_mode == EHIP_4CH_FEC_P1) ||
                     (r_ifctl_hwcfg_mode == EHIP_4CH_FEC_P2) ||
                     (r_ifctl_hwcfg_mode == EHIP_4CH_FEC_P3) ||
                     (r_ifctl_hwcfg_mode == EHIP_4CH_FEC_P4) ||
                     (r_ifctl_hwcfg_mode == EHIP_4CH_PTP_FEC);

assign mode_elane_ptp    = (r_ifctl_hwcfg_mode == ELANE_1CH_FEC_4CH_PTP);

assign mode_elane_1ch    = (r_ifctl_hwcfg_mode == ELANE_1CH_P0)          ||
                           (r_ifctl_hwcfg_mode == ELANE_1CH_P1)          ||
                           (r_ifctl_hwcfg_mode == ELANE_1CH_P2)          ||
                           (r_ifctl_hwcfg_mode == ELANE_1CH_P3)          ||
                           (r_ifctl_hwcfg_mode == ELANE_1CH_P4);

assign mode_elane_pcs_rc = mode_elane_1ch                                ||
                           mode_elane_ptp                                ||
                           (r_ifctl_hwcfg_mode == ELANE_1CH_FEC_4CH_P0)  ||
                           (r_ifctl_hwcfg_mode == ELANE_1CH_FEC_4CH_P1)  ||
                           (r_ifctl_hwcfg_mode == ELANE_1CH_FEC_4CH_P2)  ||
                           (r_ifctl_hwcfg_mode == ELANE_1CH_FEC_4CH_P3)  ||
                           (r_ifctl_hwcfg_mode == ELANE_1CH_FEC_4CH_P4);

assign mode_ptp_active   = (r_ifctl_hwcfg_mode == ELANE_1CH_FEC_4CH_PTP) ||
                           (r_ifctl_hwcfg_mode == EHIP_4CH_PTP_FEC);

assign o_ifctl_usr_active                                =  i_ifctl_usr_active;
assign o_tx_chnl_datapath_map_mode                       =  r_ifctl_hwcfg_adpt_en ? 
                                                            block_disabled        ? MAP_TX_DIS    : 
                                                            mode_ehip             ? MAP_TX_EHIP   : 
                                                            mode_elane_pcs_rc     ? MAP_TX_ELANE  : 
                                                            mode_pmadir           ? MAP_TX_PMADIR : 
                                                            mode_rsfec            ? MAP_TX_RSFEC  : MAP_TX_DIS
                                                                                  : i_tx_chnl_datapath_map_mode;
assign o_tx_usertest_sel                                 =  i_tx_usertest_sel;
assign o_tx_latency_src_xcvrif                           =  i_tx_latency_src_xcvrif;
assign o_tx_fifo_empty                                   =  r_ifctl_hwcfg_adpt_en ? TXFIFO_EMPTY : i_tx_fifo_empty;
assign o_tx_fifo_full                                    =  r_ifctl_hwcfg_adpt_en ?
                                                            block_disabled        ? 5'd5          : 
                                                            mode_ehip             ? TXFIFOFULL_DW : 
                                                            mode_elane_pcs_rc     ? TXFIFOFULL_DW : 
                                                            mode_pmadir           ? TXFIFOFULL_SW : 
                                                            mode_rsfec            ? TXFIFOFULL_DW : 5'd5  
                                                                                  : i_tx_fifo_full;
assign o_tx_phcomp_rd_delay                              =  r_ifctl_hwcfg_adpt_en ? PHCOMP_RD_DEL2 : i_tx_phcomp_rd_delay;
assign o_tx_double_read                                  =  r_ifctl_hwcfg_adpt_en ?
                                                            block_disabled        ? ADPT_DISABLE :
                                                            mode_ehip             ? ADPT_ENABLE  : 
                                                            mode_elane_pcs_rc     ? ADPT_ENABLE  : 
                                                            mode_pmadir           ? ADPT_DISABLE : 
                                                            mode_rsfec            ? ADPT_ENABLE  : ADPT_DISABLE
                                                                                  : i_tx_double_read;

assign o_tx_stop_read                                    =  r_ifctl_hwcfg_adpt_en ? FIFOSTOPRD_EMPTY : i_tx_stop_read;
assign o_tx_stop_write                                   =  r_ifctl_hwcfg_adpt_en ? FIFOSTOPWR_FULL  : i_tx_stop_write;

assign o_tx_fifo_pempty                                  =  r_ifctl_hwcfg_adpt_en ? 5'd2 : i_tx_fifo_pempty;

assign o_tx_fifo_pfull                                   =  r_ifctl_hwcfg_adpt_en ? 5'd5 : i_tx_fifo_pfull;
assign o_tx_wa_en                                        =  r_ifctl_hwcfg_adpt_en ?
                                                            block_disabled        ? ADPT_DISABLE   : 
                                                            mode_ehip             ? ADPT_ENABLE    :
                                                            mode_elane_pcs_rc     ? ADPT_ENABLE    :
                                                            mode_pmadir           ? ADPT_DISABLE   :
                                                            mode_rsfec            ? ADPT_ENABLE    : ADPT_DISABLE
                                                                                  : i_tx_wa_en;
assign o_tx_fifo_power_mode                              =  r_ifctl_hwcfg_adpt_en ?
                                                            block_disabled        ? HALF_W_HALF_D : 
                                                            mode_ehip             ? FULL_W_FULL_D : 
                                                            mode_elane_pcs_rc     ? FULL_W_FULL_D : 
                                                            mode_pmadir           ? HALF_W_HALF_D : 
                                                            mode_rsfec            ? FULL_W_FULL_D : HALF_W_HALF_D
                                                                                  : i_tx_fifo_power_mode;
assign o_tx_stretch_num_stages                           =  i_tx_stretch_num_stages;
assign o_tx_datapath_tb_sel                              =  i_tx_datapath_tb_sel;
assign o_tx_wr_adj_en                                    =  i_tx_wr_adj_en;
assign o_tx_rd_adj_en                                    =  i_tx_rd_adj_en;
assign o_tx_async_pld_txelecidle_rst_val                 =  i_tx_async_pld_txelecidle_rst_val;
assign o_tx_async_hip_aib_fsr_in_bit0_rst_val            =  i_tx_async_hip_aib_fsr_in_bit0_rst_val;
assign o_tx_async_hip_aib_fsr_in_bit1_rst_val            =  i_tx_async_hip_aib_fsr_in_bit1_rst_val;
assign o_tx_async_hip_aib_fsr_in_bit2_rst_val            =  i_tx_async_hip_aib_fsr_in_bit2_rst_val;
assign o_tx_async_hip_aib_fsr_in_bit3_rst_val            =  i_tx_async_hip_aib_fsr_in_bit3_rst_val;
assign o_tx_async_pld_pmaif_mask_tx_pll_rst_val          =  i_tx_async_pld_pmaif_mask_tx_pll_rst_val;
assign o_tx_async_hip_aib_fsr_out_bit0_rst_val           =  i_tx_async_hip_aib_fsr_out_bit0_rst_val;
assign o_tx_async_hip_aib_fsr_out_bit1_rst_val           =  i_tx_async_hip_aib_fsr_out_bit1_rst_val;
assign o_tx_async_hip_aib_fsr_out_bit2_rst_val           =  i_tx_async_hip_aib_fsr_out_bit2_rst_val;
assign o_tx_async_hip_aib_fsr_out_bit3_rst_val           =  i_tx_async_hip_aib_fsr_out_bit3_rst_val;
assign o_tx_fifo_rd_clk_sel                              =  r_ifctl_hwcfg_adpt_en ?
                                                            block_disabled        ? TXFIFORDCLK_TX_XFER_DIV2 : 
                                                            mode_ehip             ? TXFIFORDCLK_TX_EHIP      : 
                                                            mode_rsfec            ? TXFIFORDCLK_TX_RSFEC     :
                                                            mode_elane_pcs_rc     ? TXFIFORDCLK_TX_ELANE     : TXFIFORDCLK_TX_XFER_DIV2
                                                                                  : i_tx_fifo_rd_clk_sel;
assign o_tx_fifo_wr_clk_scg_en                           =  r_ifctl_hwcfg_adpt_en ?
                                                            block_disabled        ? ADPT_ENABLE  : 
                                                            mode_ehip             ? ADPT_DISABLE : 
                                                            mode_elane_pcs_rc     ? ADPT_DISABLE : 
                                                            mode_pmadir           ? ADPT_ENABLE  : 
                                                            mode_rsfec            ? ADPT_DISABLE : ADPT_ENABLE
                                                                                  : i_tx_fifo_wr_clk_scg_en;
assign o_tx_fifo_rd_clk_scg_en                           =  r_ifctl_hwcfg_adpt_en ?
                                                            block_disabled        ? ADPT_ENABLE  : 
                                                            mode_ehip             ? ADPT_DISABLE : 
                                                            mode_elane_pcs_rc     ? ADPT_DISABLE : 
                                                            mode_pmadir           ? ADPT_ENABLE  : 
                                                            mode_rsfec            ? ADPT_DISABLE : ADPT_ENABLE
                                                                                  : i_tx_fifo_rd_clk_scg_en;
assign o_tx_osc_clk_scg_en                               =  r_ifctl_hwcfg_adpt_en ?
                                                            block_disabled        ? ADPT_ENABLE  :
                                                            mode_ehip             ? ADPT_DISABLE : 
                                                            mode_elane_pcs_rc     ? ADPT_DISABLE : 
                                                            mode_pmadir           ? ADPT_DISABLE : 
                                                            mode_rsfec            ? ADPT_DISABLE : ADPT_ENABLE
                                                                                  : i_tx_osc_clk_scg_en;
assign o_tx_free_run_div_clk                             =  i_tx_free_run_div_clk;
assign o_tx_hrdrst_rst_sm_dis                            =  i_tx_hrdrst_rst_sm_dis;
assign o_tx_hrdrst_dcd_cal_done_bypass                   =  mode_ptp_active ? ADPT_ENABLE : i_tx_hrdrst_dcd_cal_done_bypass;
assign o_tx_hrdrst_dll_lock_bypass                       =  i_tx_hrdrst_dll_lock_bypass;
assign o_tx_hrdrst_align_bypass                          =  r_ifctl_hwcfg_adpt_en ? 
                                                            block_disabled        ? ADPT_DISABLE  :
                                                            mode_pmadir           ? ADPT_ENABLE   : ADPT_DISABLE
                                                                                  : i_tx_hrdrst_align_bypass;
assign o_tx_hrdrst_user_ctl_en                           =  i_tx_hrdrst_user_ctl_en;
assign o_tx_hrdrst_rx_osc_clk_scg_en                     =  r_ifctl_hwcfg_adpt_en ? 
                                                            block_disabled        ? ADPT_ENABLE  : 
                                                            mode_ehip             ? ADPT_DISABLE : 
                                                            mode_elane_pcs_rc     ? ADPT_DISABLE : 
                                                            mode_pmadir           ? ADPT_DISABLE : 
                                                            mode_rsfec            ? ADPT_DISABLE : ADPT_ENABLE
                                                                                  : i_tx_hrdrst_rx_osc_clk_scg_en;
assign o_tx_hip_osc_clk_scg_en                           =  r_ifctl_hwcfg_adpt_en ?
                                                            block_disabled        ? ADPT_ENABLE  : 
                                                            mode_ehip             ? ADPT_DISABLE : 
                                                            mode_elane_pcs_rc     ? ADPT_DISABLE : 
                                                            mode_pmadir           ? ADPT_DISABLE : 
                                                            mode_rsfec            ? ADPT_DISABLE : ADPT_ENABLE
                                                                                  : i_tx_hip_osc_clk_scg_en;
assign o_rx_chnl_datapath_map_mode                       =  r_ifctl_hwcfg_adpt_en ?
                                                            block_disabled        ? MAP_RX_DIS    : 
                                                            mode_ehip             ? MAP_RX_EHIP   : 
                                                            mode_elane_pcs_rc     ? MAP_RX_ELANE  : 
                                                            mode_pmadir           ? MAP_RX_PMADIR : 
                                                            mode_rsfec            ? MAP_RX_RSFEC  : MAP_RX_DIS
                                                                                  : i_rx_chnl_datapath_map_mode;
assign o_rx_pcs_testbus_sel                              =  i_rx_pcs_testbus_sel;
assign o_rx_fifo_empty                                   =  i_rx_fifo_empty;
assign o_rx_fifo_mode                                    =  r_ifctl_hwcfg_adpt_en ? 
                                                            block_disabled        ? RXFIFOMODE_PHCOMP : 
                                                            mode_ehip             ? RXFIFOMODE_PHCOMP : 
                                                            mode_elane_pcs_rc     ? RXFIFOMODE_PHCOMP : 
                                                            mode_pmadir           ? RXFIFOMODE_BYPASS : 
                                                            mode_rsfec            ? RXFIFOMODE_PHCOMP : RXFIFOMODE_PHCOMP
                                                                                  : i_rx_fifo_mode;
assign o_rx_wm_en                                        =  r_ifctl_hwcfg_adpt_en ?
                                                            block_disabled        ? ADPT_DISABLE : 
                                                            mode_ehip             ? ADPT_ENABLE  : 
                                                            mode_elane_pcs_rc     ? ADPT_ENABLE  : 
                                                            mode_pmadir           ? ADPT_DISABLE : 
                                                            mode_rsfec            ? ADPT_ENABLE  : ADPT_DISABLE
                                                                                  : i_rx_wm_en;
assign o_rx_fifo_full                                    =  r_ifctl_hwcfg_adpt_en ?
                                                            block_disabled        ? RXFIFOFULL_DW : 
                                                            mode_ehip             ? RXFIFOFULL_DW : 
                                                            mode_elane_pcs_rc     ? RXFIFOFULL_DW : 
                                                            mode_pmadir           ? RXFIFOFULL_SW : 
                                                            mode_rsfec            ? RXFIFOFULL_DW : RXFIFOFULL_DW
                                                                                  : i_rx_fifo_full;
assign o_rx_phcomp_rd_delay                              =  r_ifctl_hwcfg_adpt_en ?
                                                            block_disabled        ? PHCOMP_RD_DEL2 :
                                                            mode_ehip             ? PHCOMP_RD_DEL3 : 
                                                            mode_elane_pcs_rc     ? PHCOMP_RD_DEL3 : 
                                                            mode_pmadir           ? PHCOMP_RD_DEL2 : 
                                                            mode_rsfec            ? PHCOMP_RD_DEL3 : PHCOMP_RD_DEL2
                                                                                  : i_rx_phcomp_rd_delay;
assign o_rx_double_write                                 =  r_ifctl_hwcfg_adpt_en ?
                                                            block_disabled        ? ADPT_DISABLE :
                                                            mode_ehip             ? ADPT_ENABLE  : 
                                                            mode_elane_pcs_rc     ? ADPT_ENABLE  : 
                                                            mode_pmadir           ? ADPT_DISABLE : 
                                                            mode_rsfec            ? ADPT_ENABLE  : ADPT_DISABLE
                                                                                  : i_rx_double_write;
assign o_rx_stop_read                                    =  r_ifctl_hwcfg_adpt_en ? FIFOSTOPRD_EMPTY : i_rx_stop_read;
assign o_rx_stop_write                                   =  r_ifctl_hwcfg_adpt_en ? FIFOSTOPWR_FULL  : i_rx_stop_write;
assign o_rx_fifo_pempty                                  =  r_ifctl_hwcfg_adpt_en ? 5'd2             : i_rx_fifo_pempty;
assign o_rx_fifo_power_mode                              =  r_ifctl_hwcfg_adpt_en ?
                                                            block_disabled        ? HALF_W_HALF_D :
                                                            mode_ehip             ? FULL_W_FULL_D : 
                                                            mode_elane_pcs_rc     ? FULL_W_FULL_D : 
                                                            mode_pmadir           ? HALF_W_HALF_D : 
                                                            mode_rsfec            ? FULL_W_FULL_D : HALF_W_HALF_D
                                                                                  : i_rx_fifo_power_mode;
assign o_rx_fifo_pfull                                   =  r_ifctl_hwcfg_adpt_en ? 5'd5 : i_rx_fifo_pfull;
assign o_rx_stretch_num_stages                           =  r_ifctl_hwcfg_adpt_en ? 
                                                            block_disabled        ? ZERO_STAGE : SEVEN_STAGE
                                                                                  : i_rx_stretch_num_stages;
assign o_rx_datapath_tb_sel                              =  i_rx_datapath_tb_sel;
assign o_rx_wr_adj_en                                    =  i_rx_wr_adj_en;
assign o_rx_rd_adj_en                                    =  i_rx_rd_adj_en;
assign o_rx_msb_rdptr_pipe_byp                           =  i_rx_msb_rdptr_pipe_byp;
assign o_tx_dv_gating_en                                 =  i_tx_dv_gating_en;
assign o_rx_adapter_lpbk_mode                            =  i_rx_adapter_lpbk_mode;
assign o_rx_aib_lpbk_en                                  =  i_rx_aib_lpbk_en;
assign o_tx_rev_lpbk                                     =  i_tx_rev_lpbk;
assign o_rx_hrdrst_user_ctl_en                           =  i_rx_hrdrst_user_ctl_en;
assign o_rx_usertest_sel                                 =  i_rx_usertest_sel;
assign o_rx_pld_8g_a1a2_k1k2_flag_polling_bypass         =  i_rx_pld_8g_a1a2_k1k2_flag_polling_bypass;
assign o_rx_10g_krfec_rx_diag_data_status_polling_bypass =  i_rx_10g_krfec_rx_diag_data_status_polling_bypass;
assign o_rx_pld_8g_wa_boundary_polling_bypass            =  i_rx_pld_8g_wa_boundary_polling_bypass;
assign o_rx_pcspma_testbus_sel                           =  i_rx_pcspma_testbus_sel;
assign o_rx_pld_pma_pcie_sw_done_polling_bypass          =  i_rx_pld_pma_pcie_sw_done_polling_bypass;
assign o_rx_pld_pma_reser_in_polling_bypass              =  i_rx_pld_pma_reser_in_polling_bypass;
assign o_rx_pld_pma_testbus_polling_bypass               =  i_rx_pld_pma_testbus_polling_bypass;
assign o_rx_pld_test_data_polling_bypass                 =  i_rx_pld_test_data_polling_bypass;
assign o_rx_async_pld_ltr_rst_val                        =  i_rx_async_pld_ltr_rst_val;
assign o_rx_async_pld_pma_ltd_b_rst_val                  =  i_rx_async_pld_pma_ltd_b_rst_val;
assign o_rx_async_pld_8g_signal_detect_out_rst_val       =  i_rx_async_pld_8g_signal_detect_out_rst_val;
assign o_rx_async_pld_10g_rx_crc32_err_rst_val           =  i_rx_async_pld_10g_rx_crc32_err_rst_val;
assign o_rx_async_pld_rx_fifo_align_clr_rst_val          =  i_rx_async_pld_rx_fifo_align_clr_rst_val;
assign o_rx_async_hip_en                                 =  i_rx_async_hip_en;
assign o_rx_parity_sel                                   =  r_ifctl_hwcfg_adpt_en ? SRPARITY_FUNC_SEL : i_rx_parity_sel;
assign o_rx_internal_clk1_sel0                           =  i_rx_internal_clk1_sel0;
assign o_rx_internal_clk1_sel1                           =  i_rx_internal_clk1_sel1;
assign o_rx_internal_clk1_sel2                           =  i_rx_internal_clk1_sel2;
assign o_rx_internal_clk1_sel3                           =  i_rx_internal_clk1_sel3;
assign o_rx_txfiford_pre_ct_sel                          =  i_rx_txfiford_pre_ct_sel;
assign o_rx_txfiford_post_ct_sel                         =  i_rx_txfiford_post_ct_sel;
assign o_rx_txfifowr_post_ct_sel                         =  i_rx_txfifowr_post_ct_sel;
assign o_rx_txfifowr_from_aib_sel                        =  i_rx_txfifowr_from_aib_sel;
assign o_rx_pma_coreclkin_sel                            =  i_rx_pma_coreclkin_sel;
assign o_rx_fifo_wr_clk_sel                              =  r_ifctl_hwcfg_adpt_en ? 
                                                            block_disabled        ? RXFIFOWRCLK_RX_EHIP   : 
                                                            mode_ehip             ? RXFIFOWRCLK_RX_EHIP   : 
                                                            mode_elane_pcs_rc     ? RXFIFOWRCLK_RX_ELANE  : 
                                                            mode_pmadir           ? RXFIFOWRCLK_XFER_DIV2 :
                                                            mode_rsfec            ? RXFIFOWRCLK_RX_RSFEC  : RXFIFOWRCLK_RX_EHIP
                                                                                  : i_rx_fifo_wr_clk_sel;
assign o_rx_fifo_rd_clk_sel                              =  r_ifctl_hwcfg_adpt_en ?
                                                            block_disabled        ? RXFIFORDCLK_RX_PMA      :
                                                            mode_pmadir           ? RXFIFORDCLK_RX_PMA      :
                                                            mode_ptp_active       ? RXFIFORDCLK_TX_XFER     :
                                                            mode_ehip             ? RXFIFORDCLK_TX_PMA      : 
                                                            mode_dirfec           ? RXFIFORDCLK_TX_PMA      : 
                                                            mode_rsfec            ? RXFIFORDCLK_TX_XFER     : 
                                                            mode_elane_1ch        ? RXFIFORDCLK_TX_PMA      : 
                                                            mode_elane_ptp        ? RXFIFORDCLK_RX_EHIP_FRD : 
                                                            mode_elane_pcs_rc     ? RXFIFORDCLK_TX_XFER     : RXFIFORDCLK_RX_PMA 
                                                                                  : i_rx_fifo_rd_clk_sel;
assign o_rx_internal_clk1_sel                            =  i_rx_internal_clk1_sel;
assign o_rx_internal_clk2_sel                            =  i_rx_internal_clk2_sel;
assign o_rx_fifo_wr_clk_scg_en                           =  r_ifctl_hwcfg_adpt_en ? 
                                                            block_disabled        ? ADPT_ENABLE  : 
                                                            mode_ehip             ? ADPT_DISABLE : 
                                                            mode_elane_pcs_rc     ? ADPT_DISABLE : 
                                                            mode_pmadir           ? ADPT_ENABLE  : 
                                                            mode_rsfec            ? ADPT_DISABLE : ADPT_ENABLE
                                                                                  : i_rx_fifo_wr_clk_scg_en;
assign o_rx_fifo_rd_clk_scg_en                           =  r_ifctl_hwcfg_adpt_en ?
                                                            block_disabled        ? ADPT_ENABLE  : 
                                                            mode_ehip             ? ADPT_DISABLE : 
                                                            mode_elane_pcs_rc     ? ADPT_DISABLE : 
                                                            mode_pmadir           ? ADPT_ENABLE  : 
                                                            mode_rsfec            ? ADPT_DISABLE : ADPT_ENABLE
                                                                                  : i_rx_fifo_rd_clk_scg_en;
assign o_rx_osc_clk_scg_en                               =  i_rx_osc_clk_scg_en;
assign o_rx_free_run_div_clk                             =  r_ifctl_hwcfg_adpt_en ? OUT_OF_RESET_SYNC : i_rx_free_run_div_clk;
assign o_rx_hrdrst_rst_sm_dis                            =  i_rx_hrdrst_rst_sm_dis;
assign o_rx_hrdrst_dcd_cal_done_bypass                   =  r_ifctl_hwcfg_adpt_en ? ADPT_DISABLE : i_rx_hrdrst_dcd_cal_done_bypass;
assign o_rx_rmfflag_stretch_enable                       =  r_ifctl_hwcfg_adpt_en ?
                                                            block_disabled        ? ADPT_DISABLE : ADPT_ENABLE 
                                                                                  : i_rx_rmfflag_stretch_enable;
assign o_rx_rmfflag_stretch_num_stages                   =  r_ifctl_hwcfg_adpt_en ? 
                                                            block_disabled        ? RMFFLAG_ZERO_STAGE : RMFFLAG_TWO_STAGE 
                                                                                  : i_rx_rmfflag_stretch_num_stages;
assign o_rx_hrdrst_rx_osc_clk_scg_en                     =  r_ifctl_hwcfg_adpt_en ?
                                                            block_disabled        ? ADPT_ENABLE : ADPT_DISABLE 
                                                                                  : i_rx_hrdrst_rx_osc_clk_scg_en;
assign o_rx_internal_clk2_sel0                           =  i_rx_internal_clk2_sel0;
assign o_rx_internal_clk2_sel1                           =  i_rx_internal_clk2_sel1;
assign o_rx_internal_clk2_sel2                           =  i_rx_internal_clk2_sel2;
assign o_rx_internal_clk2_sel3                           =  i_rx_internal_clk2_sel3;
assign o_rx_rxfifowr_pre_ct_sel                          =  i_rx_rxfifowr_pre_ct_sel;
assign o_rx_rxfifowr_post_ct_sel                         =  i_rx_rxfifowr_post_ct_sel;
assign o_rx_rxfiford_post_ct_sel                         =  i_rx_rxfiford_post_ct_sel;
assign o_rx_rxfiford_to_aib_sel                          =  i_rx_rxfiford_to_aib_sel;
assign o_avmm2_osc_clk_scg_en                            =  r_ifctl_hwcfg_adpt_en ? 
                                                            block_disabled        ? ADPT_ENABLE : ADPT_DISABLE 
                                                                                  : i_avmm2_osc_clk_scg_en;
assign o_sr_hip_en                                       =  r_ifctl_hwcfg_adpt_en ?
                                                            block_disabled        ? ADPT_DISABLE :
                                                            mode_ehip             ? ADPT_ENABLE  : 
                                                            mode_rsfec            ? ADPT_ENABLE  :  ADPT_DISABLE
                                                                                  : i_sr_hip_en;
assign o_sr_reserbits_in_en                              =  r_ifctl_hwcfg_adpt_en ?
                                                            block_disabled        ? ADPT_DISABLE : ADPT_ENABLE
                                                                                  : i_sr_reserbits_in_en;
assign o_sr_reserbits_out_en                             =  r_ifctl_hwcfg_adpt_en ?
                                                            block_disabled        ? ADPT_DISABLE : ADPT_ENABLE
                                                                                  : i_sr_reserbits_out_en;
assign o_sr_osc_clk_scg_en                               =  r_ifctl_hwcfg_adpt_en ?
                                                            block_disabled        ? ADPT_ENABLE : ADPT_DISABLE
                                                                                  : i_sr_osc_clk_scg_en;
assign o_sr_osc_clk_div_sel                              =  r_ifctl_hwcfg_adpt_en ?
                                                            block_disabled        ? NO_DIV : DIV2
                                                                                  : i_sr_osc_clk_div_sel;
assign o_sr_free_run_div_clk                             =  r_ifctl_hwcfg_adpt_en ? OUT_OF_RESET_SYNC : i_sr_free_run_div_clk;
assign o_sr_test_enable                                  =  i_sr_test_enable;
assign o_sr_parity_en                                    =  r_ifctl_hwcfg_adpt_en ? ADPT_DISABLE : i_sr_parity_en;
assign o_aib_dprio_ctrl_0                                =  i_aib_dprio_ctrl_0;
assign o_aib_dprio_ctrl_1                                =  i_aib_dprio_ctrl_1;
assign o_aib_dprio_ctrl_2                                =  i_aib_dprio_ctrl_2;
assign o_aib_dprio_ctrl_3                                =  i_aib_dprio_ctrl_3;
assign o_aib_dprio_ctrl_4                                =  i_aib_dprio_ctrl_4;
assign o_avmm_hrdrst_osc_clk_scg_en                      =  r_ifctl_hwcfg_adpt_en ? ADPT_DISABLE            : i_avmm_hrdrst_osc_clk_scg_en;
assign o_avmm_testbus_sel                                =  i_avmm_testbus_sel;
assign o_avmm1_osc_clk_scg_en                            =  r_ifctl_hwcfg_adpt_en ? ADPT_DISABLE            : i_avmm1_osc_clk_scg_en;
assign o_avmm1_avmm_clk_scg_en                           =  r_ifctl_hwcfg_adpt_en ? ADPT_DISABLE            : i_avmm1_avmm_clk_scg_en;
assign o_avmm1_avmm_clk_dcg_en                           =  r_ifctl_hwcfg_adpt_en ? ADPT_DISABLE            : i_avmm1_avmm_clk_dcg_en;
assign o_avmm1_free_run_div_clk                          =  r_ifctl_hwcfg_adpt_en ? AVMM1_OUT_OF_RESET_SYNC : i_avmm1_free_run_div_clk;
assign o_avmm1_rdfifo_full                               =  r_ifctl_hwcfg_adpt_en ? 6'b111000               : i_avmm1_rdfifo_full;
assign o_avmm1_rdfifo_stop_read                          =  r_ifctl_hwcfg_adpt_en ? AVMM1_RDFIFO_N_RD_EMPTY : i_avmm1_rdfifo_stop_read;
assign o_avmm1_rdfifo_stop_write                         =  r_ifctl_hwcfg_adpt_en ? AVMM1_RDFIFO_N_WR_FULL  : i_avmm1_rdfifo_stop_write;
assign o_avmm1_rdfifo_empty                              =  r_ifctl_hwcfg_adpt_en ? 6'b000000               : i_avmm1_rdfifo_empty;
assign o_avmm1_use_rsvd_bit1                             =  r_ifctl_hwcfg_adpt_en ? 1'b1                    : i_avmm1_use_rsvd_bit1;
assign o_avmm2_avmm_clk_scg_en                           =  r_ifctl_hwcfg_adpt_en ? ADPT_DISABLE            : i_avmm2_avmm_clk_scg_en;
assign o_avmm2_avmm_clk_dcg_en                           =  r_ifctl_hwcfg_adpt_en ? ADPT_DISABLE            : i_avmm2_avmm_clk_dcg_en;
assign o_avmm2_free_run_div_clk                          =  r_ifctl_hwcfg_adpt_en ? AVMM2_OUT_OF_RESET_SYNC : i_avmm2_free_run_div_clk;
assign o_avmm2_rdfifo_full                               =  r_ifctl_hwcfg_adpt_en ? 6'b111000               : i_avmm2_rdfifo_full;
assign o_avmm2_rdfifo_stop_read                          =  r_ifctl_hwcfg_adpt_en ? AVMM2_RDFIFO_N_RD_EMPTY : i_avmm2_rdfifo_stop_read;
assign o_avmm2_rdfifo_stop_write                         =  r_ifctl_hwcfg_adpt_en ? AVMM2_RDFIFO_N_WR_FULL  : i_avmm2_rdfifo_stop_write;
assign o_avmm2_rdfifo_empty                              =  r_ifctl_hwcfg_adpt_en ? 6'b000000               : i_avmm2_rdfifo_empty;
assign o_rstctl_tx_elane_ovrval                          =  i_rstctl_tx_elane_ovrval;
assign o_rstctl_tx_elane_ovren                           =  i_rstctl_tx_elane_ovren;
assign o_rstctl_rx_elane_ovrval                          =  i_rstctl_rx_elane_ovrval;
assign o_rstctl_rx_elane_ovren                           =  i_rstctl_rx_elane_ovren;
assign o_rstctl_tx_xcvrif_ovrval                         =  i_rstctl_tx_xcvrif_ovrval;
assign o_rstctl_tx_xcvrif_ovren                          =  i_rstctl_tx_xcvrif_ovren;
assign o_rstctl_rx_xcvrif_ovrval                         =  i_rstctl_rx_xcvrif_ovrval;
assign o_rstctl_rx_xcvrif_ovren                          =  i_rstctl_rx_xcvrif_ovren;
assign o_rstctl_tx_adpt_ovrval                           =  i_rstctl_tx_adpt_ovrval;
assign o_rstctl_tx_adpt_ovren                            =  i_rstctl_tx_adpt_ovren;
assign o_rstctl_rx_adpt_ovrval                           =  i_rstctl_rx_adpt_ovrval;
assign o_rstctl_rx_adpt_ovren                            =  i_rstctl_rx_adpt_ovren;
assign o_rstctl_tx_pld_div2_rst_opt                      =  i_rstctl_tx_pld_div2_rst_opt;
assign o_aib_csr_ctrl_0                                  =  scan_mode_n ? i_aib_csr_ctrl_0  : 8'h00;
assign o_aib_csr_ctrl_1                                  =  scan_mode_n ? i_aib_csr_ctrl_1  : 8'h00;
assign o_aib_csr_ctrl_2                                  =  scan_mode_n ? i_aib_csr_ctrl_2  : 8'h00;
assign o_aib_csr_ctrl_3                                  =  scan_mode_n ? i_aib_csr_ctrl_3  : 8'h00;
assign o_aib_csr_ctrl_4                                  =  scan_mode_n ? i_aib_csr_ctrl_4  : 8'h00;
assign o_aib_csr_ctrl_5                                  =  scan_mode_n ? i_aib_csr_ctrl_5  : 8'h00;
assign o_aib_csr_ctrl_6                                  =  scan_mode_n ? i_aib_csr_ctrl_6  : 8'h00;
assign o_aib_csr_ctrl_7                                  =  scan_mode_n ? i_aib_csr_ctrl_7  : 8'h00;
assign o_aib_csr_ctrl_8                                  =  scan_mode_n ? i_aib_csr_ctrl_8  : 8'h00;
assign o_aib_csr_ctrl_9                                  =  scan_mode_n ? i_aib_csr_ctrl_9  : 8'h00;
assign o_aib_csr_ctrl_10                                 =  scan_mode_n ? i_aib_csr_ctrl_10 : 8'h00;
assign o_aib_csr_ctrl_11                                 =  scan_mode_n ? i_aib_csr_ctrl_11 : 8'h00;
assign o_aib_csr_ctrl_12                                 =  scan_mode_n ? r_ifctl_hwcfg_aib_en  ? block_disabled  ? 8'h00 : 8'h19 
                                                                                                : i_aib_csr_ctrl_12
                                                                        : 8'h00;
assign o_aib_csr_ctrl_13                                 =  scan_mode_n ? r_ifctl_hwcfg_aib_en  ? block_disabled  ? 8'h00 : 8'hA6
                                                                                                : i_aib_csr_ctrl_13
                                                                        : 8'h00;
assign o_aib_csr_ctrl_14                                 =  scan_mode_n ? i_aib_csr_ctrl_14 : 8'h00;
assign o_aib_csr_ctrl_15                                 =  scan_mode_n ? i_aib_csr_ctrl_15 : 8'h00;
assign o_aib_csr_ctrl_16                                 =  scan_mode_n ? r_ifctl_hwcfg_aib_en  ?  block_disabled ? 8'h00 : 8'h02
                                                                                                : i_aib_csr_ctrl_16
                                                                        : 8'h00;
assign o_aib_csr_ctrl_17                                 =  scan_mode_n ? i_aib_csr_ctrl_17 : 8'h00;
assign o_aib_csr_ctrl_18                                 =  scan_mode_n ? r_ifctl_hwcfg_aib_en  ? block_disabled ? 8'h00 : 8'h40
                                                                                                : i_aib_csr_ctrl_18
                                                                        : 8'h00;
assign o_aib_csr_ctrl_19                                 =  scan_mode_n ? i_aib_csr_ctrl_19 : 8'h00;
assign o_aib_csr_ctrl_20                                 =  scan_mode_n ? i_aib_csr_ctrl_20 : 8'h00;
assign o_aib_csr_ctrl_21                                 =  scan_mode_n ? r_ifctl_hwcfg_aib_en  ? block_disabled  ? 8'h00 : 8'hB0
                                                                                                : i_aib_csr_ctrl_21
                                                                        : 8'h00;
assign o_aib_csr_ctrl_22                                 =  scan_mode_n ? r_ifctl_hwcfg_aib_en  ?  block_disabled ? 8'h00 : 8'h07
                                                                                                : i_aib_csr_ctrl_22
                                                                        : 8'h00;
assign o_aib_csr_ctrl_23                                 =  scan_mode_n ? r_ifctl_hwcfg_aib_en  ? block_disabled  ? 8'h00 : 8'hBF
                                                                                                : i_aib_csr_ctrl_23
                                                                        : 8'h00;
assign o_aib_csr_ctrl_24                                 =  scan_mode_n ? r_ifctl_hwcfg_aib_en  ? block_disabled  ? 8'h00 : 8'hE1
                                                                                                : i_aib_csr_ctrl_24
                                                                        : 8'h00;
assign o_aib_csr_ctrl_25                                 =  scan_mode_n ? r_ifctl_hwcfg_aib_en  ?  block_disabled ? 8'h00 : 8'h25
                                                                                                : i_aib_csr_ctrl_25
                                                                        : 8'h00;
assign o_aib_csr_ctrl_26                                 =  scan_mode_n ? r_ifctl_hwcfg_aib_en  ? block_disabled  ? 8'h00 : 8'h02
                                                                                                : i_aib_csr_ctrl_26
                                                                        : 8'h00;
assign o_aib_csr_ctrl_27                                 =  scan_mode_n ? i_aib_csr_ctrl_27 : 8'h00;
assign o_aib_csr_ctrl_28                                 =  scan_mode_n ? r_ifctl_hwcfg_aib_en  ? block_disabled ? 8'h00 : 8'h04
                                                                                                : i_aib_csr_ctrl_28
                                                                        : 8'h00;
assign o_aib_csr_ctrl_29                                 =  scan_mode_n ? i_aib_csr_ctrl_29 : 8'h00;
assign o_aib_csr_ctrl_30                                 =  scan_mode_n ? i_aib_csr_ctrl_30 : 8'h00;
assign o_aib_csr_ctrl_31                                 =  scan_mode_n ? i_aib_csr_ctrl_31 : 8'h00;
assign o_aib_csr_ctrl_32                                 =  scan_mode_n ? i_aib_csr_ctrl_32 : 8'h00;
assign o_aib_csr_ctrl_33                                 =  scan_mode_n ? i_aib_csr_ctrl_33 : 8'h00;
assign o_aib_csr_ctrl_34                                 =  scan_mode_n ? r_ifctl_hwcfg_aib_en  ?  block_disabled ? 8'h00 : 8'h1C
                                                                                                : i_aib_csr_ctrl_34
                                                                        : 8'h00;
assign o_aib_csr_ctrl_35                                 =  scan_mode_n ? r_ifctl_hwcfg_aib_en  ?  block_disabled ? 8'h00 : 8'h7F
                                                                                                : i_aib_csr_ctrl_35
                                                                        : 8'h00;
assign o_aib_csr_ctrl_36                                 =  scan_mode_n ? i_aib_csr_ctrl_36 : 8'h00;
assign o_aib_csr_ctrl_37                                 =  scan_mode_n ? r_ifctl_hwcfg_aib_en  ?  block_disabled ? 8'h00 : 8'h1C
                                                                                                : i_aib_csr_ctrl_37
                                                                        : 8'h00;
assign o_aib_csr_ctrl_38                                 =  scan_mode_n ? i_aib_csr_ctrl_38 : 8'h00;
assign o_aib_csr_ctrl_39                                 =  scan_mode_n ? i_aib_csr_ctrl_39 : 8'h00;
assign o_aib_csr_ctrl_40                                 =  scan_mode_n ? i_aib_csr_ctrl_40 : 8'h00;
assign o_aib_csr_ctrl_41                                 =  scan_mode_n ? i_aib_csr_ctrl_41 : 8'h00;
assign o_aib_csr_ctrl_42                                 =  scan_mode_n ? i_aib_csr_ctrl_42 : 8'h00;
assign o_aib_csr_ctrl_43                                 =  scan_mode_n ? i_aib_csr_ctrl_43 : 8'h00;
assign o_aib_csr_ctrl_44                                 =  scan_mode_n ? i_aib_csr_ctrl_44 : 8'h00;
assign o_aib_csr_ctrl_45                                 =  scan_mode_n ? i_aib_csr_ctrl_45 : 8'h00;
assign o_aib_csr_ctrl_46                                 =  scan_mode_n ? i_aib_csr_ctrl_46 : 8'h00;
assign o_aib_csr_ctrl_47                                 =  scan_mode_n ? i_aib_csr_ctrl_47 : 8'h00;
assign o_aib_csr_ctrl_48                                 =  scan_mode_n ? i_aib_csr_ctrl_48 : 8'h00;
assign o_aib_csr_ctrl_49                                 =  scan_mode_n ? i_aib_csr_ctrl_49 : 8'h00;
assign o_aib_csr_ctrl_50                                 =  scan_mode_n ? i_aib_csr_ctrl_50 : 8'h00;
assign o_aib_csr_ctrl_51                                 =  scan_mode_n ? i_aib_csr_ctrl_51 : 8'h00;
assign o_aib_csr_ctrl_52                                 =  scan_mode_n ? i_aib_csr_ctrl_52 : 8'h00;
assign o_aib_csr_ctrl_53                                 =  scan_mode_n ? i_aib_csr_ctrl_53 : 8'h00;

endmodule
