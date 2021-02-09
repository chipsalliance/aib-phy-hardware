// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module hdpldadapt_avmm1_dprio_mapping (
// IOCSR Only
input   wire    [55:0]  avmm_csr_ctrl, 
input   wire    [55:0]  avmm1_csr_ctrl,
input   wire    [55:0]  avmm2_csr_ctrl,
input   wire    [463:0] aib_csr_ctrl,
input   wire    [7:0]   avmm_res_csr_ctrl,

// DPRIO
input   wire    [135:0] tx_chnl_dprio_ctrl, 
input   wire    [167:0] rx_chnl_dprio_ctrl,
input   wire    [23:0]  sr_dprio_ctrl,    
input   wire    [7:0]   avmm1_dprio_ctrl, 
input   wire    [7:0]   avmm2_dprio_ctrl, 
input   wire    [39:0]  aib_dprio_ctrl,

// new ouputs for ECO8
    output  wire [1:0]  r_tx_wren_fastbond,
    output  wire [1:0]  r_tx_rden_fastbond,                                
    output  wire [1:0]  r_rx_wren_fastbond,
    output  wire [1:0]  r_rx_rden_fastbond,
                                       
output  wire    [3:0]   r_tx_hip_aib_ssr_in_polling_bypass,
output  wire            r_tx_pld_8g_tx_boundary_sel_polling_bypass,
output  wire            r_tx_pld_10g_tx_bitslip_polling_bypass,
output  wire            r_tx_pld_pma_fpll_cnt_sel_polling_bypass,
output  wire            r_tx_pld_pma_fpll_num_phase_shifts_polling_bypass,
output  wire [4:0]      r_tx_fifo_empty,
output  wire [2:0]      r_tx_fifo_mode,
output  wire [4:0]      r_tx_fifo_full,
output  wire [2:0]      r_tx_phcomp_rd_delay,
output  wire [4:0]      r_tx_fifo_pempty,
output  wire            r_tx_indv,
output  wire            r_tx_stop_read,
output  wire            r_tx_stop_write,
output  wire [4:0]      r_tx_fifo_pfull,
output  wire            r_tx_double_write,
//output  wire [1:0]      r_tx_chnl_datapath_fifo_3_res_6_2,
output  wire [7:0]      r_tx_comp_cnt,
output  wire            r_tx_us_master,
output  wire            r_tx_ds_master,
output  wire            r_tx_us_bypass_pipeln,
output  wire            r_tx_ds_bypass_pipeln,
output  wire [1:0]      r_tx_compin_sel,
output  wire            r_tx_bonding_dft_in_en,
output  wire            r_tx_bonding_dft_in_value,
output  wire            r_tx_dv_indv,
output  wire [2:0]      r_tx_gb_idwidth,
output  wire [1:0]      r_tx_gb_odwidth,
output  wire            r_tx_gb_dv_en,
//output  wire            r_tx_chnl_datapath_dv_en_0_res_7_1,
output  wire [15:0]     r_tx_mfrm_length,
output  wire            r_tx_bypass_frmgen,
output  wire            r_tx_pipeln_frmgen,
output  wire            r_tx_pyld_ins,
output  wire            r_tx_sh_err,
output  wire            r_tx_burst_en,
output  wire            r_tx_wm_en,
output  wire            r_tx_wordslip,
//output  wire            r_tx_chnl_datapath_frm_gen_async_res_7_1,
output  wire            r_tx_async_pld_txelecidle_rst_val,
output  wire            r_tx_async_hip_aib_fsr_in_bit0_rst_val,
output  wire            r_tx_async_hip_aib_fsr_in_bit1_rst_val,
output  wire            r_tx_async_hip_aib_fsr_in_bit2_rst_val,
output  wire            r_tx_async_hip_aib_fsr_in_bit3_rst_val,
output  wire            r_tx_async_pld_pmaif_mask_tx_pll_rst_val,
output  wire            r_tx_async_hip_aib_fsr_out_bit0_rst_val,
output  wire            r_tx_async_hip_aib_fsr_out_bit1_rst_val,
output  wire            r_tx_async_hip_aib_fsr_out_bit2_rst_val,
output  wire            r_tx_async_hip_aib_fsr_out_bit3_rst_val,
output  wire            r_tx_usertest_sel,
output  wire            r_rx_usertest_sel,
//output  wire [5:0]      r_tx_chnl_datapath_async_reserved_11_2,
//output  wire [7:0]      r_tx_chnl_datapath_async_3_clk0,
output  wire [2:0]	r_tx_fifo_power_mode,
output  wire [2:0]	r_tx_stretch_num_stages, 
output  wire [2:0]	r_tx_datapath_tb_sel, 
output  wire		r_tx_wr_adj_en, 
output  wire            r_tx_rd_adj_en, 
output  wire            r_tx_fpll_shared_direct_async_in_sel,
output  wire [1:0]      r_tx_aib_clk1_sel,
output  wire [1:0]      r_tx_aib_clk2_sel,
output  wire [1:0]      r_tx_fifo_rd_clk_sel,
//output  wire            r_tx_chnl_datapath_clk_1_res_0,
output  wire            r_tx_pld_clk1_sel,
output	wire		r_tx_pld_clk1_delay_en,
output	wire [3:0]	r_tx_pld_clk1_delay_sel,
output	wire		r_tx_pld_clk1_inv_en,
output  wire            r_tx_pld_clk2_sel,
output	wire		r_tx_fifo_rd_clk_frm_gen_scg_en,
output  wire            r_tx_fifo_rd_clk_scg_en,
output  wire            r_tx_fifo_wr_clk_scg_en,
output  wire            r_tx_osc_clk_scg_en,
//output  wire            r_tx_tx_osc_clk_scg_en,
output  wire            r_tx_hrdrst_rst_sm_dis,
output  wire            r_tx_hrdrst_dcd_cal_done_bypass,
output	wire		r_tx_hrdrst_user_ctl_en,
output  wire            r_tx_hrdrst_rx_osc_clk_scg_en,
output	wire		r_tx_hip_osc_clk_scg_en,
//output  wire [7:0]      r_tx_chnl_datapath_res_1,
//output  wire [7:0]      r_tx_chnl_datapath_res_2,
output  wire [5:0]      r_rx_fifo_empty,
//output  wire [1:0]      r_rx_chnl_datapath_fifo_0_res_6_2,
output  wire [5:0]      r_rx_fifo_full,
output  wire            r_rx_double_read,
output  wire            r_rx_gb_dv_en,
output  wire [5:0]      r_rx_fifo_pempty,
output  wire            r_rx_stop_read,
output  wire            r_rx_stop_write,
output  wire [5:0]      r_rx_fifo_pfull,
output  wire            r_rx_indv,
output  wire            r_rx_truebac2bac,
output  wire [2:0]      r_rx_fifo_mode,
output  wire [2:0]      r_rx_phcomp_rd_delay,
//output  wire [1:0]      r_rx_chnl_datapath_fifo_4_res_6_2,
output  wire [7:0]      r_rx_comp_cnt,
output  wire            r_rx_us_master,
output  wire            r_rx_ds_master,
output  wire            r_rx_us_bypass_pipeln,
output  wire            r_rx_ds_bypass_pipeln,
output  wire [1:0]      r_rx_compin_sel,
output  wire            r_rx_bonding_dft_in_en,
output  wire            r_rx_bonding_dft_in_value,
output  wire            r_rx_wa_en,
output  wire            r_rx_write_ctrl,
output  wire [2:0]	r_rx_fifo_power_mode,
output  wire [2:0]	r_rx_stretch_num_stages, 
output  wire [3:0]	r_rx_datapath_tb_sel, 
output  wire		r_rx_wr_adj_en, 
output  wire            r_rx_rd_adj_en, 
output  wire            r_rx_pipe_en,
output  wire            r_rx_lpbk_en,

//output  wire [6:0]      r_rx_chnl_datapath_wa_0_res_1_7,
//output  wire [7:0]      r_rx_chnl_datapath_wa_1_ins_0_asn_0,
//output  wire [7:0]      r_rx_chnl_datapath_asn_1,
//output  wire [7:0]      r_rx_chnl_datapath_asn_2,
//output  wire [7:0]      r_rx_chnl_datapath_asn_3,
//output  wire [7:0]      r_rx_chnl_datapath_asn_4,
//output  wire [7:0]      r_rx_chnl_datapath_asn_5_async_0,
output  wire            r_rx_asn_en,
output  wire            r_rx_asn_bypass_pma_pcie_sw_done,
//output  wire [1:0]      r_rx_asn_master_sel,
//output  wire            r_rx_asn_dist_master_sel,
//output  wire            r_rx_asn_bonding_dft_in_en,
//output  wire            r_rx_asn_bonding_dft_in_value,
output  wire            r_rx_async_pld_ltr_rst_val,
output  wire            r_rx_async_pld_pma_ltd_b_rst_val,
output  wire            r_rx_async_pld_8g_signal_detect_out_rst_val,
output  wire            r_rx_async_pld_10g_rx_crc32_err_rst_val,
output  wire            r_rx_async_pld_rx_fifo_align_clr_rst_val,
output  wire            r_rx_async_prbs_flags_sr_enable,
output	wire		r_rx_free_run_div_clk,
output  wire            r_rx_hrdrst_rst_sm_dis,
output  wire            r_rx_hrdrst_dll_lock_bypass,
output  wire            r_rx_hrdrst_align_bypass,
output	wire		r_rx_hrdrst_user_ctl_en,
//output	wire [1:0]	r_rx_hrdrst_master_sel,
output	wire		r_rx_ds_last_chnl,
output	wire		r_rx_us_last_chnl,
//output  wire [2:0]      r_rx_chnl_datapath_async_reserved_2_4,
//output  wire [7:0]      r_rx_chnl_datapath_async_2,
//output  wire [7:0]      r_rx_chnl_datapath_async_3_clk_0,
output  wire [1:0]      r_rx_aib_clk1_sel,
output  wire [1:0]      r_rx_aib_clk2_sel,
output  wire 		r_rx_fifo_wr_clk_sel,
output  wire [1:0]      r_rx_fifo_rd_clk_sel,
output  wire            r_rx_pld_clk1_sel,
output	wire		r_rx_pld_clk1_delay_en,
output	wire [3:0]	r_rx_pld_clk1_delay_sel,
output	wire		r_rx_pld_clk1_inv_en,
//output  wire            r_rx_pld_clk2_sel,
output  wire            r_rx_sclk_sel,
output  wire            r_rx_fifo_wr_clk_scg_en,
output  wire            r_rx_fifo_rd_clk_scg_en,
output  wire            r_rx_pma_hclk_scg_en,
output  wire            r_rx_osc_clk_scg_en,
output  wire            r_rx_hrdrst_rx_osc_clk_scg_en,
output	wire		r_rx_fifo_wr_clk_del_sm_scg_en,
output	wire		r_rx_fifo_rd_clk_ins_sm_scg_en,
//output	wire		r_rx_hrdrst_dist_master_sel,
output  wire            r_rx_internal_clk1_sel1,
output  wire            r_rx_internal_clk1_sel2,
output  wire            r_rx_txfiford_post_ct_sel,
output  wire            r_rx_txfifowr_post_ct_sel,
output  wire            r_rx_internal_clk2_sel1,
output  wire            r_rx_internal_clk2_sel2,
output  wire            r_rx_rxfifowr_post_ct_sel,
output  wire            r_rx_rxfiford_post_ct_sel,
//output  wire [1:0]      r_tx_hrdrst_master_sel,
//output  wire            r_tx_hrdrst_dist_master_sel,
output  wire            r_tx_ds_last_chnl,
output  wire            r_tx_us_last_chnl,
output  wire [7:0]      r_rx_asn_wait_for_fifo_flush_cnt,
output  wire [7:0]      r_rx_asn_wait_for_dll_reset_cnt,
output  wire [7:0]      r_rx_asn_wait_for_pma_pcie_sw_done_cnt,
output  wire            r_rx_pld_8g_eidleinfersel_polling_bypass,
output  wire            r_rx_pld_pma_eye_monitor_polling_bypass,
output  wire            r_rx_pld_pma_pcie_switch_polling_bypass,
output  wire            r_rx_pld_pma_reser_out_polling_bypass,
//output  wire            r_rx_coreclkin_sel,
output  wire            r_avmm_hrdrst_osc_clk_scg_en,
//output  wire [6:0]      r_rx_chnl_datapath_clk_2_res_1_7,
//output  wire [7:0]      r_rx_chnl_datapath_res_1,
output  wire            r_sr_hip_en,
output  wire            r_sr_reserbits_in_en,
output  wire            r_sr_reserbits_out_en,
output  wire            r_sr_testbus_sel,
output  wire            r_sr_parity_en,
//output  wire            r_sr_pld_txelecidle_rst_val,
//output  wire            r_sr_pld_ltr_rst_val,
//output  wire            r_sr_pld_pma_ltd_b_rst_val,
//output  wire            r_sr_hip_fsr_in_bit0_rst_val,
//output  wire            r_sr_hip_fsr_in_bit1_rst_val,
//output  wire            r_sr_hip_fsr_in_bit2_rst_val,
//output  wire            r_sr_hip_fsr_in_bit3_rst_val,
//output  wire            r_sr_pld_pmaif_mask_tx_pll_rst_val,
//output  wire            r_sr_pld_8g_signal_detect_out_rst_val,
//output  wire            r_sr_pld_10g_rx_crc32_err_rst_val,
//output  wire            r_sr_hip_fsr_out_bit0_rst_val,
//output  wire            r_sr_hip_fsr_out_bit1_rst_val,
//output  wire            r_sr_hip_fsr_out_bit2_rst_val,
//output  wire            r_sr_hip_fsr_out_bit3_rst_val,
//output  wire            r_sr_pld_rx_fifo_align_clr_rst_val,
output  wire            r_sr_osc_clk_scg_en,
//output  wire [5:0]      r_sr_clk_0_res_2_7,
//output  wire [7:0]      r_avmm1_arbiter_ctrl_0,
//output  wire [7:0]      r_avmm2_arbiter_ctrl_0,
output  wire [7:0]      r_aib_dprio_ctrl_0,
output  wire [7:0]      r_aib_dprio_ctrl_1,
output  wire [7:0]      r_aib_dprio_ctrl_2,
output  wire [7:0]      r_aib_dprio_ctrl_3,
output  wire [7:0]      r_aib_dprio_ctrl_4,
output  wire [9:0]      r_avmm_adapt_base_addr,
output  wire            r_avmm_rd_block_enable,
output  wire            r_avmm_uc_block_enable,
output  wire [1:0]      r_avmm_testbus_sel, 
//output  wire            r_avmm_general_reserved_1_2,
output  wire            r_avmm_nfhssi_calibration_en,
//output  wire            r_avmm_general_reserved_1_4,
output  wire            r_avmm_force_inter_sel_csr_ctrl,
output  wire            r_avmm_dprio_broadcast_en_csr_ctrl,
//output  wire            r_avmm_general_reserved_1_7,
output  wire [9:0]      r_avmm_nfhssi_base_addr,
//output  wire [6:0]      r_avmm_general_reserved_4_1,
//output  wire [7:0]      r_avmm_reset_0,
output  wire            r_avmm1_osc_clk_scg_en,
output  wire            r_avmm1_avmm_clk_scg_en,
//output  wire [3:0]      r_avmm1_clk_reserved_4_7,
output  wire [5:0]      r_avmm1_cmdfifo_full,
output  wire            r_avmm1_cmdfifo_stop_read,
output  wire            r_avmm1_cmdfifo_stop_write,
output  wire [5:0]      r_avmm1_cmdfifo_empty,
//output  wire [1:0]      r_avmm1_cmdfifo_1_res_6_7,
output  wire [5:0]      r_avmm1_cmdfifo_pfull,
//output  wire [1:0]      r_avmm1_cmdfifo_2_res_6_7,
//output  wire [7:0]      r_avmm1_cmdfifo_3_res_0_7,
output  wire [5:0]      r_avmm1_rdfifo_full,
output  wire            r_avmm1_rdfifo_stop_read,
output  wire            r_avmm1_rdfifo_stop_write,
output  wire [5:0]      r_avmm1_rdfifo_empty,
output  wire            r_avmm1_gate_dis,
//output  wire [1:0]      r_avmm1_rdfifo_1_res_6_7,
output  wire            r_avmm2_osc_clk_scg_en,
output  wire            r_avmm2_avmm_clk_scg_en,
//output  wire [3:0]      r_avmm2_clk_reserved_4_7,
output  wire [5:0]      r_avmm2_cmdfifo_full,
output  wire            r_avmm2_cmdfifo_stop_read,
output  wire            r_avmm2_cmdfifo_stop_write,
output  wire [5:0]      r_avmm2_cmdfifo_empty,
//output  wire [1:0]      r_avmm2_cmdfifo_1_res_6_7,
output  wire [5:0]      r_avmm2_cmdfifo_pfull,
//output  wire [1:0]      r_avmm2_cmdfifo_2_res_6_7,
//output  wire [7:0]      r_avmm2_cmdfifo_3_res_0_7,
output  wire [5:0]      r_avmm2_rdfifo_full,
output  wire            r_avmm2_rdfifo_stop_read,
output  wire            r_avmm2_rdfifo_stop_write,
output  wire [5:0]      r_avmm2_rdfifo_empty,
output  wire            r_avmm2_hip_sel,
output  wire            r_avmm2_gate_dis,
//output  wire            r_avmm2_rdfifo_1_res_6_7,
output  wire [7:0]      r_aib_csr_ctrl_0,
output  wire [7:0]      r_aib_csr_ctrl_1,
output  wire [7:0]      r_aib_csr_ctrl_2,
output  wire [7:0]      r_aib_csr_ctrl_3,
output  wire [7:0]      r_aib_csr_ctrl_4,
output  wire [7:0]      r_aib_csr_ctrl_5,
output  wire [7:0]      r_aib_csr_ctrl_6,
output  wire [7:0]      r_aib_csr_ctrl_7,
output  wire [7:0]      r_aib_csr_ctrl_8,
output  wire [7:0]      r_aib_csr_ctrl_9,
output  wire [7:0]      r_aib_csr_ctrl_10,
output  wire [7:0]      r_aib_csr_ctrl_11,
output  wire [7:0]      r_aib_csr_ctrl_12,
output  wire [7:0]      r_aib_csr_ctrl_13,
output  wire [7:0]      r_aib_csr_ctrl_14,
output  wire [7:0]      r_aib_csr_ctrl_15,
output  wire [7:0]      r_aib_csr_ctrl_16,
output  wire [7:0]      r_aib_csr_ctrl_17,
output  wire [7:0]      r_aib_csr_ctrl_18,
output  wire [7:0]      r_aib_csr_ctrl_19,
output  wire [7:0]      r_aib_csr_ctrl_20,
output  wire [7:0]      r_aib_csr_ctrl_21,
output  wire [7:0]      r_aib_csr_ctrl_22,
output  wire [7:0]      r_aib_csr_ctrl_23,
output  wire [7:0]      r_aib_csr_ctrl_24,
output  wire [7:0]      r_aib_csr_ctrl_25,
output  wire [7:0]      r_aib_csr_ctrl_26,
output  wire [7:0]      r_aib_csr_ctrl_27,
output  wire [7:0]      r_aib_csr_ctrl_28,
output  wire [7:0]      r_aib_csr_ctrl_29,
output  wire [7:0]      r_aib_csr_ctrl_30,
output  wire [7:0]      r_aib_csr_ctrl_31,
output  wire [7:0]      r_aib_csr_ctrl_32,
output  wire [7:0]      r_aib_csr_ctrl_33,
output  wire [7:0]      r_aib_csr_ctrl_34,
output  wire [7:0]      r_aib_csr_ctrl_35,
output  wire [7:0]      r_aib_csr_ctrl_36,
output  wire [7:0]      r_aib_csr_ctrl_37,
output  wire [7:0]      r_aib_csr_ctrl_38,
output  wire [7:0]      r_aib_csr_ctrl_39,
output  wire [7:0]      r_aib_csr_ctrl_40,
output  wire [7:0]      r_aib_csr_ctrl_41,
output  wire [7:0]      r_aib_csr_ctrl_42,
output  wire [7:0]      r_aib_csr_ctrl_43,
output  wire [7:0]      r_aib_csr_ctrl_44,
output  wire [7:0]      r_aib_csr_ctrl_45,
output  wire [7:0]      r_aib_csr_ctrl_46,
output  wire [7:0]      r_aib_csr_ctrl_47,
output  wire [7:0]      r_aib_csr_ctrl_48,
output  wire [7:0]      r_aib_csr_ctrl_49,
output  wire [7:0]      r_aib_csr_ctrl_50,
output  wire [7:0]      r_aib_csr_ctrl_51,
output  wire [7:0]      r_aib_csr_ctrl_52,
output  wire [7:0]      r_aib_csr_ctrl_53,
output  wire [7:0]      r_aib_csr_ctrl_54,
output  wire [7:0]      r_aib_csr_ctrl_55,
output  wire [7:0]      r_aib_csr_ctrl_56,
output  wire [7:0]      r_aib_csr_ctrl_57
);

// Unused DPRIO/CSR bits
//wire [1:0]      r_tx_chnl_datapath_fifo_3_res_6_2;
//wire            r_tx_chnl_datapath_dv_en_0_res_7_1;
//wire            r_tx_chnl_datapath_frm_gen_async_res_7_1;
//wire [1:0]      r_tx_chnl_datapath_async_reserved_11_2;
//wire [7:0]      r_tx_chnl_datapath_async_3_clk0_res;
//wire [1:0]	r_tx_chnl_datapath_clk_res_6_7;
//wire            r_tx_chnl_datapath_rst_0_res_7;
//wire [1:0]	r_tx_chnl_datapath_1_res_3_4;
//wire [7:0]      r_tx_chnl_datapath_res_2;
//wire [1:0]      r_rx_chnl_datapath_fifo_0_res_6_2;
//wire [1:0]      r_rx_chnl_datapath_fifo_4_res_6_2;
//wire            r_rx_chnl_datapath_fifo_4_res_7_1;
wire [7:0]      r_rx_chnl_datapath_wa_1_ins_0_asn_0_res;
//wire [1:0]      r_rx_chnl_datapath_asn_0_res_5_2;
wire [3:0]      r_rx_chnl_datapath_asn_5_async_0_res;
wire [5:0]      r_rx_chnl_datapath_wa_0_res_2_6;
wire [7:0]      r_rx_chnl_datapath_wa_1_ins_0_asn_0;
wire [7:0]      r_rx_chnl_datapath_asn_5_async_0;
wire [1:0]      r_rx_chnl_datapath_async_reserved_2_4;
//wire [7:0]      r_rx_chnl_datapath_async_3_clk_0_res;
wire [1:0]      r_rx_chnl_datapath_clk_res_6_7;
wire [6:0]      r_sr_clk_0_res_1_7;
wire            r_avmm_general_reserved_1_2;
wire            r_avmm_general_reserved_1_4;
wire            r_avmm_general_reserved_1_7;
wire            r_avmm_general_reserved_4_3;
wire            r_avmm_general_reserved_4_5;
wire [6:0]      r_avmm_rst_0_res_1_7;
wire [7:0]      r_avmm_rst_reserved_1;
wire            r_avmm1_clk_reserved_0;
wire [4:0]      r_avmm1_clk_reserved_3_7;
wire [1:0]      r_avmm1_cmdfifo_1_res_6_7;
wire [1:0]      r_avmm1_cmdfifo_2_res_6_7;
wire [7:0]      r_avmm1_cmdfifo_3_res_0_7;
wire            r_avmm1_rdfifo_1_res_6_7;
wire            r_avmm2_clk_reserved_0;
wire [4:0]      r_avmm2_clk_reserved_3_7;
wire [1:0]      r_avmm2_cmdfifo_1_res_6_7;
wire [1:0]      r_avmm2_cmdfifo_2_res_6_7;
wire [7:0]      r_avmm2_cmdfifo_3_res_0_7;
wire [4:0]      r_avmm_rst_0_res_3_7;
wire [2:0]      r_sr_res_0_1;
wire 		r_rx_chnl_datapath_1_res_5;
wire [7:0]      r_sr_res_1_0;
//wire            r_rx_async_res_0;
wire            r_rx_async_res_1;
// wire [1:0]	r_rx_chnl_datapath_fifo_0_res_6_2;
wire [7:0]	r_avmm1_res_0;
wire [7:0]	r_avmm2_res_0;
wire [2:0]	r_avmm_res_0;
wire [7:0]      r_avmm_res_csr_ctrl;

wire r_sr_reserved_0;
wire r_sr_reserved_1;
wire r_sr_reserved_2;
wire r_sr_reserved_4;
wire r_sr_reserved_5;


assign r_tx_fifo_empty[4:0]                          = tx_chnl_dprio_ctrl[4:0];
assign r_tx_fifo_mode[2:0]                           = tx_chnl_dprio_ctrl[7:5];
assign r_tx_fifo_full[4:0]                           = tx_chnl_dprio_ctrl[12:8];
assign r_tx_phcomp_rd_delay[2:0]                     = tx_chnl_dprio_ctrl[15:13];
assign r_tx_fifo_pempty[4:0]                         = tx_chnl_dprio_ctrl[20:16];
assign r_tx_indv                                     = tx_chnl_dprio_ctrl[21];
assign r_tx_stop_read                                = tx_chnl_dprio_ctrl[22];
assign r_tx_stop_write                               = tx_chnl_dprio_ctrl[23];
assign r_tx_fifo_pfull[4:0]                          = tx_chnl_dprio_ctrl[28:24];
//assign r_tx_double_write                             = tx_chnl_dprio_ctrl[29];
assign r_tx_fifo_power_mode[2:0]                     = tx_chnl_dprio_ctrl[31:29];
assign r_tx_comp_cnt[7:0]                            = tx_chnl_dprio_ctrl[39:32];
assign r_tx_us_master                                = tx_chnl_dprio_ctrl[40];
assign r_tx_ds_master                                = tx_chnl_dprio_ctrl[41];
assign r_tx_us_bypass_pipeln                         = tx_chnl_dprio_ctrl[42];
assign r_tx_ds_bypass_pipeln                         = tx_chnl_dprio_ctrl[43];
assign r_tx_compin_sel[1:0]                          = tx_chnl_dprio_ctrl[45:44];
assign r_tx_bonding_dft_in_en                        = tx_chnl_dprio_ctrl[46];
assign r_tx_bonding_dft_in_value                     = tx_chnl_dprio_ctrl[47];
assign r_tx_dv_indv                                  = tx_chnl_dprio_ctrl[48];
assign r_tx_gb_idwidth[2:0]                          = tx_chnl_dprio_ctrl[51:49];
assign r_tx_gb_odwidth[1:0]                          = tx_chnl_dprio_ctrl[53:52];
assign r_tx_gb_dv_en                                 = tx_chnl_dprio_ctrl[54];
assign r_tx_double_write		             = tx_chnl_dprio_ctrl[55];
assign r_tx_mfrm_length[7:0]                         = tx_chnl_dprio_ctrl[63:56];
assign r_tx_mfrm_length[15:8]                        = tx_chnl_dprio_ctrl[71:64];
assign r_tx_bypass_frmgen                            = tx_chnl_dprio_ctrl[72];
assign r_tx_pipeln_frmgen                            = tx_chnl_dprio_ctrl[73];
assign r_tx_pyld_ins                                 = tx_chnl_dprio_ctrl[74];
assign r_tx_sh_err                                   = tx_chnl_dprio_ctrl[75];
assign r_tx_burst_en                                 = tx_chnl_dprio_ctrl[76];
assign r_tx_wm_en                                    = tx_chnl_dprio_ctrl[77];
assign r_tx_wordslip                                 = tx_chnl_dprio_ctrl[78];
assign r_tx_pld_pma_fpll_num_phase_shifts_polling_bypass = tx_chnl_dprio_ctrl[79];
assign r_tx_async_pld_txelecidle_rst_val             = tx_chnl_dprio_ctrl[80];
assign r_tx_async_hip_aib_fsr_in_bit0_rst_val        = tx_chnl_dprio_ctrl[81];
assign r_tx_async_hip_aib_fsr_in_bit1_rst_val        = tx_chnl_dprio_ctrl[82];
assign r_tx_async_hip_aib_fsr_in_bit2_rst_val        = tx_chnl_dprio_ctrl[83];
assign r_tx_async_hip_aib_fsr_in_bit3_rst_val        = tx_chnl_dprio_ctrl[84];
assign r_tx_async_pld_pmaif_mask_tx_pll_rst_val      = tx_chnl_dprio_ctrl[85];
assign r_tx_async_hip_aib_fsr_out_bit0_rst_val       = tx_chnl_dprio_ctrl[86];
assign r_tx_async_hip_aib_fsr_out_bit1_rst_val       = tx_chnl_dprio_ctrl[87];
assign r_tx_async_hip_aib_fsr_out_bit2_rst_val       = tx_chnl_dprio_ctrl[88];
assign r_tx_async_hip_aib_fsr_out_bit3_rst_val       = tx_chnl_dprio_ctrl[89];
assign r_tx_pld_8g_tx_boundary_sel_polling_bypass    = tx_chnl_dprio_ctrl[90];
assign r_tx_pld_10g_tx_bitslip_polling_bypass        = tx_chnl_dprio_ctrl[91];
assign r_tx_hip_aib_ssr_in_polling_bypass[3:0]       = tx_chnl_dprio_ctrl[95:92];
assign r_tx_pld_clk1_delay_en			     = tx_chnl_dprio_ctrl[96];
assign r_tx_pld_clk1_delay_sel[3:0]		     = tx_chnl_dprio_ctrl[100:97];
assign r_tx_pld_clk1_inv_en                          = tx_chnl_dprio_ctrl[101];
//assign r_tx_chnl_datapath_clk_res_6_7[1:0]           = tx_chnl_dprio_ctrl[103:102];
   assign r_tx_wren_fastbond[1:0]           = tx_chnl_dprio_ctrl[103:102];
assign r_tx_fifo_rd_clk_frm_gen_scg_en        	     = tx_chnl_dprio_ctrl[104];
assign r_tx_fpll_shared_direct_async_in_sel          = tx_chnl_dprio_ctrl[105];
assign r_tx_aib_clk1_sel[1:0]                        = tx_chnl_dprio_ctrl[107:106];
assign r_tx_aib_clk2_sel[1:0]                        = tx_chnl_dprio_ctrl[109:108];
assign r_tx_fifo_rd_clk_sel[1:0]                     = tx_chnl_dprio_ctrl[111:110];
assign r_tx_pld_pma_fpll_cnt_sel_polling_bypass      = tx_chnl_dprio_ctrl[112];
assign r_tx_pld_clk1_sel                             = tx_chnl_dprio_ctrl[113];
assign r_tx_pld_clk2_sel                             = tx_chnl_dprio_ctrl[114];
assign r_tx_fifo_rd_clk_scg_en                       = tx_chnl_dprio_ctrl[115];
assign r_tx_fifo_wr_clk_scg_en                       = tx_chnl_dprio_ctrl[116];
assign r_tx_osc_clk_scg_en                           = tx_chnl_dprio_ctrl[117];
assign r_tx_hrdrst_rx_osc_clk_scg_en                 = tx_chnl_dprio_ctrl[118];
assign r_tx_hip_osc_clk_scg_en                    = tx_chnl_dprio_ctrl[119];
assign r_tx_hrdrst_rst_sm_dis                        = tx_chnl_dprio_ctrl[120];
assign r_tx_hrdrst_dcd_cal_done_bypass               = tx_chnl_dprio_ctrl[121];
assign r_tx_hrdrst_user_ctl_en			     = tx_chnl_dprio_ctrl[122];
//assign r_tx_chnl_datapath_1_res_3_4	             = tx_chnl_dprio_ctrl[124:123];
   assign r_tx_rden_fastbond[1:0]	             = tx_chnl_dprio_ctrl[124:123];
//assign r_tx_hrdrst_master_sel[1:0]                   = tx_chnl_dprio_ctrl[123:122];
//assign r_tx_hrdrst_dist_master_sel                   = tx_chnl_dprio_ctrl[124];
assign r_tx_ds_last_chnl                      = tx_chnl_dprio_ctrl[125];
assign r_tx_us_last_chnl                      = tx_chnl_dprio_ctrl[126];
assign r_tx_usertest_sel                      = tx_chnl_dprio_ctrl[127];
assign r_tx_stretch_num_stages[2:0]                  = tx_chnl_dprio_ctrl[130:128];
assign r_tx_datapath_tb_sel[2:0]                     = tx_chnl_dprio_ctrl[133:131];
assign r_tx_wr_adj_en                                = tx_chnl_dprio_ctrl[134];
assign r_tx_rd_adj_en                                = tx_chnl_dprio_ctrl[135];
assign r_rx_fifo_empty[5:0]                          = rx_chnl_dprio_ctrl[5:0];
//assign r_rx_chnl_datapath_fifo_0_res_6_2             = rx_chnl_dprio_ctrl[7:6];
   assign r_rx_wren_fastbond[1:0]             = rx_chnl_dprio_ctrl[7:6];
assign r_rx_fifo_full[5:0]                           = rx_chnl_dprio_ctrl[13:8];
assign r_rx_double_read                              = rx_chnl_dprio_ctrl[14];
assign r_rx_gb_dv_en                                 = rx_chnl_dprio_ctrl[15];
assign r_rx_fifo_pempty[5:0]                         = rx_chnl_dprio_ctrl[21:16];
assign r_rx_stop_read                                = rx_chnl_dprio_ctrl[22];
assign r_rx_stop_write                               = rx_chnl_dprio_ctrl[23];
assign r_rx_fifo_pfull[5:0]                          = rx_chnl_dprio_ctrl[29:24];
assign r_rx_indv                                     = rx_chnl_dprio_ctrl[30];
assign r_rx_truebac2bac                              = rx_chnl_dprio_ctrl[31];
assign r_rx_fifo_mode[2:0]                           = rx_chnl_dprio_ctrl[34:32];
assign r_rx_phcomp_rd_delay[2:0]                     = rx_chnl_dprio_ctrl[37:35];
assign r_rx_lpbk_en                                  = rx_chnl_dprio_ctrl[38];
assign r_rx_wr_adj_en             		     = rx_chnl_dprio_ctrl[39];
assign r_rx_comp_cnt[7:0]                            = rx_chnl_dprio_ctrl[47:40];
assign r_rx_us_master                                = rx_chnl_dprio_ctrl[48];
assign r_rx_ds_master                                = rx_chnl_dprio_ctrl[49];
assign r_rx_us_bypass_pipeln                         = rx_chnl_dprio_ctrl[50];
assign r_rx_ds_bypass_pipeln                         = rx_chnl_dprio_ctrl[51];
assign r_rx_compin_sel[1:0]                          = rx_chnl_dprio_ctrl[53:52];
assign r_rx_bonding_dft_in_en                        = rx_chnl_dprio_ctrl[54];
assign r_rx_bonding_dft_in_value                     = rx_chnl_dprio_ctrl[55];
assign r_rx_wa_en                                    = rx_chnl_dprio_ctrl[56];
assign r_rx_write_ctrl                               = rx_chnl_dprio_ctrl[57];
assign r_rx_chnl_datapath_wa_0_res_2_6[5:0]          = rx_chnl_dprio_ctrl[63:58];
assign r_rx_chnl_datapath_wa_1_ins_0_asn_0_res[7:0]  = rx_chnl_dprio_ctrl[71:64];
assign r_rx_asn_en                                   = rx_chnl_dprio_ctrl[72];
assign r_rx_asn_bypass_pma_pcie_sw_done              = rx_chnl_dprio_ctrl[73];
assign r_rx_fifo_power_mode			     = rx_chnl_dprio_ctrl[76:74];
//assign r_rx_asn_master_sel[1:0]                      = rx_chnl_dprio_ctrl[75:74];
//assign r_rx_asn_dist_master_sel                      = rx_chnl_dprio_ctrl[76];
//assign r_rx_chnl_datapath_asn_0_res_5_2[1:0]         = rx_chnl_dprio_ctrl[78:77];
   assign r_rx_rden_fastbond[1:0]        = rx_chnl_dprio_ctrl[78:77];
assign r_rx_pipe_en                                  = rx_chnl_dprio_ctrl[79];
assign r_rx_asn_wait_for_fifo_flush_cnt[7:0]         = rx_chnl_dprio_ctrl[87:80];
assign r_rx_asn_wait_for_dll_reset_cnt[7:0]          = rx_chnl_dprio_ctrl[95:88];
assign r_rx_asn_wait_for_pma_pcie_sw_done_cnt[7:0]   = rx_chnl_dprio_ctrl[103:96];
assign r_rx_chnl_datapath_asn_5_async_0_res[3:0]     = rx_chnl_dprio_ctrl[107:104];
assign r_rx_pld_8g_eidleinfersel_polling_bypass      = rx_chnl_dprio_ctrl[108];
assign r_rx_pld_pma_eye_monitor_polling_bypass       = rx_chnl_dprio_ctrl[109];
assign r_rx_pld_pma_pcie_switch_polling_bypass       = rx_chnl_dprio_ctrl[110];
assign r_rx_pld_pma_reser_out_polling_bypass      = rx_chnl_dprio_ctrl[111];
assign r_rx_async_pld_ltr_rst_val                    = rx_chnl_dprio_ctrl[112];
assign r_rx_async_pld_pma_ltd_b_rst_val              = rx_chnl_dprio_ctrl[113];
assign r_rx_async_pld_8g_signal_detect_out_rst_val   = rx_chnl_dprio_ctrl[114];
assign r_rx_async_pld_10g_rx_crc32_err_rst_val       = rx_chnl_dprio_ctrl[115];
assign r_rx_async_pld_rx_fifo_align_clr_rst_val      = rx_chnl_dprio_ctrl[116];
assign r_rx_async_prbs_flags_sr_enable               = rx_chnl_dprio_ctrl[117];
assign r_rx_usertest_sel                             = rx_chnl_dprio_ctrl[118];
assign r_rx_async_res_1                              = rx_chnl_dprio_ctrl[119];
assign r_rx_stretch_num_stages[2:0]                  = rx_chnl_dprio_ctrl[122:120];
assign r_rx_datapath_tb_sel[3:0]                     = rx_chnl_dprio_ctrl[126:123];
//assign r_rx_wr_adj_en                                = rx_chnl_dprio_ctrl[126];
assign r_rx_rd_adj_en                                = rx_chnl_dprio_ctrl[127];
assign r_rx_pld_clk1_delay_en			     = rx_chnl_dprio_ctrl[128];
assign r_rx_pld_clk1_delay_sel[3:0]		     = rx_chnl_dprio_ctrl[132:129];
assign r_rx_pld_clk1_inv_en                          = rx_chnl_dprio_ctrl[133];
assign r_rx_chnl_datapath_clk_res_6_7[1:0]           = rx_chnl_dprio_ctrl[135:134];
assign r_rx_aib_clk1_sel[1:0]                        = rx_chnl_dprio_ctrl[137:136];
assign r_rx_aib_clk2_sel[1:0]                        = rx_chnl_dprio_ctrl[139:138];
assign r_rx_fifo_wr_clk_sel                          = rx_chnl_dprio_ctrl[140];
assign r_rx_fifo_rd_clk_sel[1:0]                     = rx_chnl_dprio_ctrl[142:141];
assign r_rx_pld_clk1_sel                             = rx_chnl_dprio_ctrl[143];
assign r_rx_sclk_sel                                 = rx_chnl_dprio_ctrl[144];
assign r_rx_fifo_wr_clk_scg_en                       = rx_chnl_dprio_ctrl[145];
assign r_rx_fifo_rd_clk_scg_en                       = rx_chnl_dprio_ctrl[146];
assign r_rx_pma_hclk_scg_en                          = rx_chnl_dprio_ctrl[147];
assign r_rx_osc_clk_scg_en                           = rx_chnl_dprio_ctrl[148];
assign r_rx_hrdrst_rx_osc_clk_scg_en                 = rx_chnl_dprio_ctrl[149];
assign r_rx_fifo_wr_clk_del_sm_scg_en                = rx_chnl_dprio_ctrl[150];
assign r_rx_fifo_rd_clk_ins_sm_scg_en		     = rx_chnl_dprio_ctrl[151];
assign r_rx_internal_clk1_sel1                       = rx_chnl_dprio_ctrl[152];
assign r_rx_internal_clk1_sel2                       = rx_chnl_dprio_ctrl[153];
assign r_rx_txfiford_post_ct_sel                     = rx_chnl_dprio_ctrl[154];
assign r_rx_txfifowr_post_ct_sel                     = rx_chnl_dprio_ctrl[155];
assign r_rx_internal_clk2_sel1                       = rx_chnl_dprio_ctrl[156];
assign r_rx_internal_clk2_sel2                       = rx_chnl_dprio_ctrl[157];
assign r_rx_rxfifowr_post_ct_sel                     = rx_chnl_dprio_ctrl[158];
assign r_rx_rxfiford_post_ct_sel                     = rx_chnl_dprio_ctrl[159];
assign r_rx_free_run_div_clk                         = rx_chnl_dprio_ctrl[160];
assign r_rx_hrdrst_rst_sm_dis                        = rx_chnl_dprio_ctrl[161];
assign r_rx_hrdrst_dll_lock_bypass                   = rx_chnl_dprio_ctrl[162];
assign r_rx_hrdrst_align_bypass                      = rx_chnl_dprio_ctrl[163];
assign r_rx_hrdrst_user_ctl_en			     = rx_chnl_dprio_ctrl[164];
assign r_rx_chnl_datapath_1_res_5                    = rx_chnl_dprio_ctrl[165];
assign r_rx_ds_last_chnl                             = rx_chnl_dprio_ctrl[166];
assign r_rx_us_last_chnl                             = rx_chnl_dprio_ctrl[167];
//assign r_sr_hip_en                                   = sr_dprio_ctrl[0];
//assign r_sr_reserbits_in_en                          = sr_dprio_ctrl[1];
//assign r_sr_reserbits_out_en                         = sr_dprio_ctrl[2];
//assign r_sr_testbus_sel                              = sr_dprio_ctrl[3];
//assign r_sr_parity_en                                = sr_dprio_ctrl[4];
assign r_sr_reserved_0                               = sr_dprio_ctrl[0];
assign r_sr_reserved_1                               = sr_dprio_ctrl[1];
assign r_sr_reserved_2                               = sr_dprio_ctrl[2];
assign r_sr_testbus_sel                              = sr_dprio_ctrl[3];
assign r_sr_reserved_4                               = sr_dprio_ctrl[4];
assign r_sr_res_0_1[2:0]                             = sr_dprio_ctrl[7:5];
assign r_sr_res_1_0[7:0]                             = sr_dprio_ctrl[15:8];
//assign r_sr_osc_clk_scg_en                           = sr_dprio_ctrl[16];
assign r_sr_reserved_5                               = sr_dprio_ctrl[16];
assign r_sr_clk_0_res_1_7[6:0]                       = sr_dprio_ctrl[23:17];
assign r_avmm1_res_0[7:0]                   	     = avmm1_dprio_ctrl[7:0];
assign r_avmm2_res_0[7:0]                   	     = avmm2_dprio_ctrl[7:0];
assign r_aib_dprio_ctrl_0[7:0]                       = aib_dprio_ctrl[7:0];
assign r_aib_dprio_ctrl_1[7:0]                       = aib_dprio_ctrl[15:8];
assign r_aib_dprio_ctrl_2[7:0]                       = aib_dprio_ctrl[23:16];
assign r_aib_dprio_ctrl_3[7:0]                       = aib_dprio_ctrl[31:24];
assign r_aib_dprio_ctrl_4[7:0]                       = aib_dprio_ctrl[39:32];

assign r_avmm_adapt_base_addr[9:0]                        = avmm_csr_ctrl[9:0];
assign r_avmm_general_reserved_1_2                        = avmm_csr_ctrl[10];
assign r_avmm_nfhssi_calibration_en                       = avmm_csr_ctrl[11];
assign r_avmm_general_reserved_1_4                        = avmm_csr_ctrl[12];
assign r_avmm_force_inter_sel_csr_ctrl                    = avmm_csr_ctrl[13];
assign r_avmm_dprio_broadcast_en_csr_ctrl                 = avmm_csr_ctrl[14];
assign r_avmm_general_reserved_1_7                        = avmm_csr_ctrl[15];
//assign r_avmm_res_0[7:0]                                  = avmm_csr_ctrl[23:16];
assign r_sr_hip_en                                        = avmm_csr_ctrl[16];
assign r_sr_reserbits_in_en                               = avmm_csr_ctrl[17];
assign r_sr_reserbits_out_en                              = avmm_csr_ctrl[18];
assign r_sr_parity_en                                     = avmm_csr_ctrl[19];
assign r_sr_osc_clk_scg_en                                = avmm_csr_ctrl[20];
assign r_avmm_res_0[2:0]                                  = avmm_csr_ctrl[23:21];
assign r_avmm_nfhssi_base_addr[9:0]                       = avmm_csr_ctrl[33:24];
assign r_avmm_general_reserved_4_3                        = avmm_csr_ctrl[34];
assign r_avmm_rd_block_enable                             = avmm_csr_ctrl[35];
assign r_avmm_uc_block_enable                             = avmm_csr_ctrl[36];
assign r_avmm_testbus_sel[1:0]                            = avmm_csr_ctrl[38:37];
assign r_avmm_general_reserved_4_5                        = avmm_csr_ctrl[39];
assign r_avmm_hrdrst_osc_clk_scg_en                       = avmm_csr_ctrl[40];
assign r_avmm_rst_0_res_1_7[6:0]                          = avmm_csr_ctrl[47:41];
assign r_avmm_rst_reserved_1[7:0]                         = avmm_csr_ctrl[55:48];
assign r_avmm1_clk_reserved_0                             = avmm1_csr_ctrl[0];
assign r_avmm1_osc_clk_scg_en                             = avmm1_csr_ctrl[1];
assign r_avmm1_avmm_clk_scg_en                            = avmm1_csr_ctrl[2];
assign r_avmm1_clk_reserved_3_7[4:0]                      = avmm1_csr_ctrl[7:3];
assign r_avmm1_cmdfifo_full[5:0]                          = avmm1_csr_ctrl[13:8];
assign r_avmm1_cmdfifo_stop_read                          = avmm1_csr_ctrl[14];
assign r_avmm1_cmdfifo_stop_write                         = avmm1_csr_ctrl[15];
assign r_avmm1_cmdfifo_empty[5:0]                         = avmm1_csr_ctrl[21:16];
assign r_avmm1_cmdfifo_1_res_6_7[1:0]                     = avmm1_csr_ctrl[23:22];
assign r_avmm1_cmdfifo_pfull[5:0]                         = avmm1_csr_ctrl[29:24];
assign r_avmm1_cmdfifo_2_res_6_7[1:0]                     = avmm1_csr_ctrl[31:30];
assign r_avmm1_cmdfifo_3_res_0_7[7:0]                     = avmm1_csr_ctrl[39:32];
assign r_avmm1_rdfifo_full[5:0]                           = avmm1_csr_ctrl[45:40];
assign r_avmm1_rdfifo_stop_read                           = avmm1_csr_ctrl[46];
assign r_avmm1_rdfifo_stop_write                          = avmm1_csr_ctrl[47];
assign r_avmm1_rdfifo_empty[5:0]                          = avmm1_csr_ctrl[53:48];
assign r_avmm1_gate_dis                                   = avmm1_csr_ctrl[54];
assign r_avmm1_rdfifo_1_res_6_7                           = avmm1_csr_ctrl[55];
assign r_avmm2_clk_reserved_0                             = avmm2_csr_ctrl[0];
assign r_avmm2_osc_clk_scg_en                             = avmm2_csr_ctrl[1];
assign r_avmm2_avmm_clk_scg_en                            = avmm2_csr_ctrl[2];
assign r_avmm2_clk_reserved_3_7[4:0]                      = avmm2_csr_ctrl[7:3];
assign r_avmm2_cmdfifo_full[5:0]                          = avmm2_csr_ctrl[13:8];
assign r_avmm2_cmdfifo_stop_read                          = avmm2_csr_ctrl[14];
assign r_avmm2_cmdfifo_stop_write                         = avmm2_csr_ctrl[15];
assign r_avmm2_cmdfifo_empty[5:0]                         = avmm2_csr_ctrl[21:16];
assign r_avmm2_cmdfifo_1_res_6_7[1:0]                     = avmm2_csr_ctrl[23:22];
assign r_avmm2_cmdfifo_pfull[5:0]                         = avmm2_csr_ctrl[29:24];
assign r_avmm2_cmdfifo_2_res_6_7[1:0]                     = avmm2_csr_ctrl[31:30];
assign r_avmm2_cmdfifo_3_res_0_7[7:0]                     = avmm2_csr_ctrl[39:32];
assign r_avmm2_rdfifo_full[5:0]                           = avmm2_csr_ctrl[45:40];
assign r_avmm2_rdfifo_stop_read                           = avmm2_csr_ctrl[46];
assign r_avmm2_rdfifo_stop_write                          = avmm2_csr_ctrl[47];
assign r_avmm2_rdfifo_empty[5:0]                          = avmm2_csr_ctrl[53:48];
assign r_avmm2_hip_sel                                    = avmm2_csr_ctrl[54];
assign r_avmm2_gate_dis                                   = avmm2_csr_ctrl[55];
assign r_aib_csr_ctrl_0[7:0]                              = aib_csr_ctrl[7:0];
assign r_aib_csr_ctrl_1[7:0]                              = aib_csr_ctrl[15:8];
assign r_aib_csr_ctrl_2[7:0]                              = aib_csr_ctrl[23:16];
assign r_aib_csr_ctrl_3[7:0]                              = aib_csr_ctrl[31:24];
assign r_aib_csr_ctrl_4[7:0]                              = aib_csr_ctrl[39:32];
assign r_aib_csr_ctrl_5[7:0]                              = aib_csr_ctrl[47:40];
assign r_aib_csr_ctrl_6[7:0]                              = aib_csr_ctrl[55:48];
assign r_aib_csr_ctrl_7[7:0]                              = aib_csr_ctrl[63:56];
assign r_aib_csr_ctrl_8[7:0]                              = aib_csr_ctrl[71:64];
assign r_aib_csr_ctrl_9[7:0]                              = aib_csr_ctrl[79:72];
assign r_aib_csr_ctrl_10[7:0]                             = aib_csr_ctrl[87:80];
assign r_aib_csr_ctrl_11[7:0]                             = aib_csr_ctrl[95:88];
assign r_aib_csr_ctrl_12[7:0]                             = aib_csr_ctrl[103:96];
assign r_aib_csr_ctrl_13[7:0]                             = aib_csr_ctrl[111:104];
assign r_aib_csr_ctrl_14[7:0]                             = aib_csr_ctrl[119:112];
assign r_aib_csr_ctrl_15[7:0]                             = aib_csr_ctrl[127:120];
assign r_aib_csr_ctrl_16[7:0]                             = aib_csr_ctrl[135:128];
assign r_aib_csr_ctrl_17[7:0]                             = aib_csr_ctrl[143:136];
assign r_aib_csr_ctrl_18[7:0]                             = aib_csr_ctrl[151:144];
assign r_aib_csr_ctrl_19[7:0]                             = aib_csr_ctrl[159:152];
assign r_aib_csr_ctrl_20[7:0]                             = aib_csr_ctrl[167:160];
assign r_aib_csr_ctrl_21[7:0]                             = aib_csr_ctrl[175:168];
assign r_aib_csr_ctrl_22[7:0]                             = aib_csr_ctrl[183:176];
assign r_aib_csr_ctrl_23[7:0]                             = aib_csr_ctrl[191:184];
assign r_aib_csr_ctrl_24[7:0]                             = aib_csr_ctrl[199:192];
assign r_aib_csr_ctrl_25[7:0]                             = aib_csr_ctrl[207:200];
assign r_aib_csr_ctrl_26[7:0]                             = aib_csr_ctrl[215:208];
assign r_aib_csr_ctrl_27[7:0]                             = aib_csr_ctrl[223:216];
assign r_aib_csr_ctrl_28[7:0]                             = aib_csr_ctrl[231:224];
assign r_aib_csr_ctrl_29[7:0]                             = aib_csr_ctrl[239:232];
assign r_aib_csr_ctrl_30[7:0]                             = aib_csr_ctrl[247:240];
assign r_aib_csr_ctrl_31[7:0]                             = aib_csr_ctrl[255:248];
assign r_aib_csr_ctrl_32[7:0]                             = aib_csr_ctrl[263:256];
assign r_aib_csr_ctrl_33[7:0]                             = aib_csr_ctrl[271:264];
assign r_aib_csr_ctrl_34[7:0]                             = aib_csr_ctrl[279:272];
assign r_aib_csr_ctrl_35[7:0]                             = aib_csr_ctrl[287:280];
assign r_aib_csr_ctrl_36[7:0]                             = aib_csr_ctrl[295:288];
assign r_aib_csr_ctrl_37[7:0]                             = aib_csr_ctrl[303:296];
assign r_aib_csr_ctrl_38[7:0]                             = aib_csr_ctrl[311:304];
assign r_aib_csr_ctrl_39[7:0]                             = aib_csr_ctrl[319:312];
assign r_aib_csr_ctrl_40[7:0]                             = aib_csr_ctrl[327:320];
assign r_aib_csr_ctrl_41[7:0]                             = aib_csr_ctrl[335:328];
assign r_aib_csr_ctrl_42[7:0]                             = aib_csr_ctrl[343:336];
assign r_aib_csr_ctrl_43[7:0]                             = aib_csr_ctrl[351:344];
assign r_aib_csr_ctrl_44[7:0]                             = aib_csr_ctrl[359:352];
assign r_aib_csr_ctrl_45[7:0]                             = aib_csr_ctrl[367:360];
assign r_aib_csr_ctrl_46[7:0]                             = aib_csr_ctrl[375:368];
assign r_aib_csr_ctrl_47[7:0]                             = aib_csr_ctrl[383:376];
assign r_aib_csr_ctrl_48[7:0]                             = aib_csr_ctrl[391:384];
assign r_aib_csr_ctrl_49[7:0]                             = aib_csr_ctrl[399:392];
assign r_aib_csr_ctrl_50[7:0]                             = aib_csr_ctrl[407:400];
assign r_aib_csr_ctrl_51[7:0]                             = aib_csr_ctrl[415:408];
assign r_aib_csr_ctrl_52[7:0]                             = aib_csr_ctrl[423:416];
assign r_aib_csr_ctrl_53[7:0]                             = aib_csr_ctrl[431:424];
assign r_aib_csr_ctrl_54[7:0]                             = aib_csr_ctrl[439:432];
assign r_aib_csr_ctrl_55[7:0]                             = aib_csr_ctrl[447:440];
assign r_aib_csr_ctrl_56[7:0]                             = aib_csr_ctrl[455:448];
assign r_aib_csr_ctrl_57[7:0]                             = aib_csr_ctrl[463:456];
assign r_avmm_res_csr_ctrl[7:0]                           = avmm_res_csr_ctrl[7:0];
endmodule
