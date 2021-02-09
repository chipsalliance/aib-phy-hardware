// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module hdpldadapt_rx_chnl(/*AUTOARG*/
   // Outputs
   rx_fsr_parity_checker_in, rx_ssr_parity_checker_in,
   rx_async_fabric_hssi_ssr_data, rx_async_fabric_hssi_fsr_data, pld_aib_hssi_rx_dcd_cal_done,
   pld_rx_fifo_ready, rx_clock_pld_sclk,
   rx_asn_rate_change_in_progress, rx_asn_dll_lock_en, //rx_asn_gen3_sel, //rx_asn_fifo_srst,
   rx_asn_fifo_hold, pld_test_data, pld_rx_prbs_err, pld_rx_prbs_done,
   pld_rx_hssi_fifo_full, pld_rx_hssi_fifo_empty, pld_pma_rx_found,
   pld_rx_fabric_fifo_pfull, pld_rx_fabric_fifo_pempty,
   pld_rx_fabric_fifo_latency_pulse, pld_rx_fabric_fifo_insert,
   pld_rx_fabric_fifo_full, pld_rx_fabric_fifo_empty,
   pld_rx_fabric_data_out, pld_rx_fabric_align_done, pld_pma_testbus,
   pld_pma_signal_ok, pld_pma_rxpll_lock, pld_pma_rx_detect_valid,
   pld_pma_reserved_in, pld_pma_pcie_sw_done,
   pld_pma_internal_clk2_hioint, //pld_pma_internal_clk2_dcm,
   pld_pma_internal_clk1_hioint, //pld_pma_internal_clk1_dcm,
   pld_pma_hclk_hioint, //pld_pma_hclk_dcm, 
   pld_pma_adapt_done,
   pld_pcs_rx_clk_out2_hioint, pld_pcs_rx_clk_out2_dcm,
   pld_pcs_rx_clk_out1_hioint, pld_pcs_rx_clk_out1_dcm,
   pld_8g_wa_boundary, pld_8g_signal_detect_out, pld_8g_rxelecidle,
   pld_8g_full_rmf, pld_8g_empty_rmf, pld_8g_a1a2_k1k2_flag,
   pld_10g_rx_hi_ber, pld_10g_rx_frame_lock, pld_10g_rx_crc32_err,
   pld_10g_krfec_rx_frame, pld_10g_krfec_rx_diag_data_status,
   pld_10g_krfec_rx_blk_lock, bond_rx_fifo_us_out_wren,
   bond_rx_fifo_us_out_rden, bond_rx_fifo_ds_out_wren,
   bond_rx_fifo_ds_out_rden,
   bond_rx_hrdrst_ds_out_fabric_rx_dll_lock,
   bond_rx_hrdrst_us_out_fabric_rx_dll_lock,
   bond_rx_hrdrst_ds_out_fabric_rx_dll_lock_req,
   bond_rx_hrdrst_us_out_fabric_rx_dll_lock_req,
   aib_fabric_pld_sclk,
   aib_fabric_pld_pma_rxpma_rstb, aib_fabric_pld_pma_coreclkin,
   aib_fabric_pcs_rx_pld_rst_n, aib_fabric_adapter_rx_pld_rst_n,
   rx_chnl_dprio_status, rx_chnl_dprio_status_write_en_ack,
   bond_rx_asn_ds_out_fifo_hold,
   //bond_rx_asn_ds_out_dll_lock_en,
   bond_rx_asn_us_out_fifo_hold,
   //bond_rx_asn_us_out_dll_lock_en,
   pld_hssi_asn_dll_lock_en,
   pld_fabric_asn_dll_lock_en,
   pld_hssi_rx_transfer_en,
   pld_aib_fabric_rx_dll_lock, pld_rx_ssr_reserved_out, rx_async_fabric_hssi_ssr_reserved,
   adapter_scan_out_occ1,
   adapter_scan_out_occ2,
   adapter_scan_out_occ3,
   adapter_scan_out_occ4,
   adapter_scan_out_occ5,
   adapter_scan_out_occ6,
   adapter_scan_out_occ7,
   adapter_scan_out_occ8,
   adapter_scan_out_occ9,
   adapter_scan_out_occ10,
   adapter_scan_out_occ11,
   adapter_scan_out_occ12,
   adapter_scan_out_occ13,
   adapter_scan_out_occ14,
   adapter_scan_out_occ15,
   adapter_scan_out_occ16,
   adapter_scan_out_occ17,
   adapter_scan_out_occ18,
   adapter_scan_out_occ19,
   adapter_scan_out_occ20,
   adapter_scan_out_occ21,
   adapter_non_occ_scan_out,
   adapter_occ_scan_out,
   dft_fabric_oaibdftdll2core,
   pld_pma_pfdmode_lock,
   // Inputs
// new inputs for ECO8
r_rx_wren_fastbond,
r_rx_rden_fastbond,                          
   sr_parity_error_flag,
   aib_fabric_pld_pma_pfdmode_lock,
   r_rx_pld_8g_eidleinfersel_polling_bypass,
   r_rx_pld_pma_eye_monitor_polling_bypass,
   r_rx_pld_pma_pcie_switch_polling_bypass,
   r_rx_pld_pma_reser_out_polling_bypass,
   oaibdftdll2core,
   dft_adpt_aibiobsr_fastclkn,
   adapter_scan_rst_n, adapter_scan_mode_n,
   adapter_scan_shift_n, adapter_scan_shift_clk,
   adapter_scan_user_clk0, adapter_scan_user_clk1, adapter_scan_user_clk2, adapter_scan_user_clk3,
   adapter_clk_sel_n, adapter_occ_enable,
   pld_clk_dft_sel,
   rx_fsr_mask_tx_pll, rx_async_hssi_fabric_ssr_load, pld_aib_hssi_rx_dcd_cal_req,
   rx_async_hssi_fabric_ssr_data, rx_async_hssi_fabric_fsr_load,
   rx_async_hssi_fabric_fsr_data, rx_async_fabric_hssi_ssr_load,
   rx_async_fabric_hssi_fsr_load, r_rx_wa_en, r_rx_us_master,
   r_rx_us_bypass_pipeln, r_rx_osc_clk_scg_en, r_rx_truebac2bac,
   r_rx_fifo_wr_clk_del_sm_scg_en, r_rx_fifo_rd_clk_ins_sm_scg_en, 
   r_rx_stop_write, r_rx_stop_read, r_rx_sclk_sel,
   r_rx_pma_hclk_scg_en, //r_rx_pld_clk2_sel,
   r_rx_pld_clk1_sel, r_rx_phcomp_rd_delay, r_rx_indv, r_rx_gb_dv_en,
   r_rx_fifo_wr_clk_sel, r_rx_fifo_wr_clk_scg_en,
   r_rx_fifo_rd_clk_sel, r_rx_fifo_rd_clk_scg_en, r_rx_fifo_pfull,
   r_rx_fifo_pempty, r_rx_fifo_mode, r_rx_fifo_full, r_rx_fifo_empty,
   r_rx_ds_master, r_rx_ds_bypass_pipeln, r_rx_double_read,
   //r_rx_coreclkin_sel, 
   r_rx_internal_clk1_sel1,
   r_rx_internal_clk1_sel2,
   r_rx_txfiford_post_ct_sel,
   r_rx_txfifowr_post_ct_sel,
   r_rx_internal_clk2_sel1,
   r_rx_internal_clk2_sel2,
   r_rx_rxfifowr_post_ct_sel,
   r_rx_rxfiford_post_ct_sel,
   r_rx_pld_clk1_delay_en, r_rx_pld_clk1_delay_sel, r_rx_pld_clk1_inv_en,
   r_rx_compin_sel, r_rx_comp_cnt,
   //r_rx_chnl_datapath_asn_4, r_rx_chnl_datapath_asn_3,
   //r_rx_chnl_datapath_asn_2, r_rx_chnl_datapath_asn_1,
   r_rx_asn_en,
   r_rx_asn_bypass_pma_pcie_sw_done,
   r_rx_asn_wait_for_fifo_flush_cnt,
   r_rx_asn_wait_for_dll_reset_cnt,
   r_rx_asn_wait_for_pma_pcie_sw_done_cnt, r_rx_usertest_sel,
   r_rx_bonding_dft_in_en,
   r_rx_bonding_dft_in_value,
   //r_rx_bonding_dft_in_value, r_rx_bonding_dft_in_en,
   r_rx_async_pld_rx_fifo_align_clr_rst_val,
   r_rx_async_prbs_flags_sr_enable,
   r_rx_async_pld_pma_ltd_b_rst_val, r_rx_async_pld_ltr_rst_val,
   r_rx_async_pld_8g_signal_detect_out_rst_val,
   r_rx_async_pld_10g_rx_crc32_err_rst_val, r_rx_aib_clk2_sel,
   r_rx_aib_clk1_sel, pld_syncsm_en, pld_sclk1_rowclk, pld_sclk2_rowclk,
   r_rx_hip_en,
   pld_rx_prbs_err_clr, pld_rx_fabric_fifo_rd_en,
   pld_rx_fabric_fifo_align_clr, pld_rx_clk2_rowclk, //pld_rx_clk2_dcm,
   pld_rx_clk1_rowclk, pld_rx_clk1_dcm, pld_polinv_rx,
   pld_pmaif_rxclkslip, pld_pma_rxpma_rstb, pld_pma_rs_lpbk_b,
   pld_pma_reserved_out, pld_pma_ppm_lock, pld_pma_pcie_switch,
   pld_pma_ltd_b, pld_pma_eye_monitor, pld_pma_early_eios,
   pld_pma_coreclkin_rowclk, //pld_pma_coreclkin_dcm,
   pld_pma_adapt_start, pld_pcs_rx_pld_rst_n, pld_ltr, pld_bitslip,
   pld_adapter_rx_pld_rst_n, pld_8g_encdt, pld_8g_eidleinfersel,
   pld_8g_byte_rev_en, pld_8g_bitloc_rev_en, pld_8g_a1a2_size,
   pld_10g_rx_clr_ber_count, pld_10g_krfec_rx_clr_errblk_cnt,
   nfrzdrv_in, csr_rdy_dly_in, usermode_in, bond_rx_fifo_us_in_wren, pr_channel_freeze_n,
   tx_hrdrst_fabric_tx_transfer_en,
   tx_clock_fifo_wr_clk, tx_clock_fifo_rd_clk,
   avmm_hrdrst_fabric_osc_transfer_en,
   bond_rx_fifo_us_in_rden, bond_rx_fifo_ds_in_wren,
   bond_rx_fifo_ds_in_rden, //avmm_hrdrst_data_transfer_en,
   bond_rx_asn_ds_in_fifo_hold,
   //bond_rx_asn_ds_in_dll_lock_en,
   //bond_rx_asn_ds_in_gen3_sel,
   bond_rx_asn_us_in_fifo_hold,
   //bond_rx_asn_us_in_dll_lock_en,
   //bond_rx_asn_us_in_gen3_sel,
   bond_rx_hrdrst_ds_in_fabric_rx_dll_lock,
   bond_rx_hrdrst_us_in_fabric_rx_dll_lock,
   bond_rx_hrdrst_ds_in_fabric_rx_dll_lock_req,
   bond_rx_hrdrst_us_in_fabric_rx_dll_lock_req,
   aib_fabric_tx_transfer_clk, aib_fabric_tx_sr_clk_in,
   aib_fabric_rx_transfer_clk, aib_fabric_rx_sr_clk_in,
   aib_fabric_rx_dll_lock_req, aib_fabric_rx_dll_lock,
   aib_fabric_rx_data_in, aib_fabric_pld_pma_rxpll_lock,
   aib_fabric_pld_pma_internal_clk2, aib_fabric_pld_pma_internal_clk1,
   aib_fabric_pld_pma_hclk, aib_fabric_pld_pma_clkdiv_rx_user,
   aib_fabric_pld_pcs_rx_clk_out, aib_fabric_pld_8g_rxelecidle, pld_fsr_load, pld_ssr_load,
   pld_aib_fabric_rx_dll_lock_req,
   pld_fabric_rx_fifo_srst, pld_fabric_rx_asn_data_transfer_en, 
   rx_chnl_dprio_status_write_en, pld_rx_dll_lock_req,
   r_rx_hrdrst_rx_osc_clk_scg_en, r_rx_free_run_div_clk, r_rx_hrdrst_rst_sm_dis, r_rx_hrdrst_dll_lock_bypass, r_rx_hrdrst_align_bypass, r_rx_hrdrst_user_ctl_en,
//   r_rx_hrdrst_master_sel, r_rx_hrdrst_dist_master_sel, 
   r_rx_ds_last_chnl, r_rx_us_last_chnl,
   r_rx_write_ctrl,
   r_rx_fifo_power_mode,
   r_rx_stretch_num_stages,
   r_rx_datapath_tb_sel, 
   r_rx_wr_adj_en, 
   r_rx_rd_adj_en,
   aib_fabric_pld_rx_hssi_fifo_latency_pulse,
   pld_rx_hssi_fifo_latency_pulse,
   pld_rx_fifo_latency_adj_en,
   r_rx_pipe_en,
   r_rx_lpbk_en,
   aib_fabric_tx_data_lpbk,
   rx_pld_rate, rx_async_hssi_fabric_ssr_reserved, pld_rx_ssr_reserved_in,
   sr_testbus,
   avmm_testbus,
   tx_chnl_testbus,
   pld_rx_fabric_fifo_del
   );


/*AUTOINPUT*/
// Beginning of automatic inputs (from unused autoinst inputs)

// new inputs for ECO8
    input  wire [1:0]  r_rx_wren_fastbond;
    input  wire [1:0]  r_rx_rden_fastbond;   
   
input [12:0]		oaibdftdll2core;
input			dft_adpt_aibiobsr_fastclkn;
input                   adapter_scan_rst_n;
input                   adapter_scan_mode_n;
input                   adapter_scan_shift_n;
input                   adapter_scan_shift_clk;
input                   adapter_scan_user_clk0;         // 125MHz
input                   adapter_scan_user_clk1;         // 250MHz
input                   adapter_scan_user_clk2;         // 500MHz
input                   adapter_scan_user_clk3;         // 1GHz
input                   adapter_clk_sel_n;
input                   adapter_occ_enable;
input			pld_clk_dft_sel;
input			aib_fabric_pld_8g_rxelecidle;// To hdpldadapt_rx_async of hdpldadapt_rx_async.v
input			aib_fabric_pld_pcs_rx_clk_out;// To hdpldadapt_rxclk_ctl of hdpldadapt_rxclk_ctl.v
input			aib_fabric_pld_pma_clkdiv_rx_user;// To hdpldadapt_rxclk_ctl of hdpldadapt_rxclk_ctl.v
input			aib_fabric_pld_pma_hclk;// To hdpldadapt_rxclk_ctl of hdpldadapt_rxclk_ctl.v, ...
input			aib_fabric_pld_pma_internal_clk1;// To hdpldadapt_rxclk_ctl of hdpldadapt_rxclk_ctl.v
input			aib_fabric_pld_pma_internal_clk2;// To hdpldadapt_rxclk_ctl of hdpldadapt_rxclk_ctl.v
input			aib_fabric_pld_pma_rxpll_lock;// To hdpldadapt_rx_async of hdpldadapt_rx_async.v
input [39:0]		aib_fabric_rx_data_in;	// To hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v
input			aib_fabric_rx_dll_lock;	// To hdpldadapt_rx_async of hdpldadapt_rx_async.v
input			aib_fabric_rx_sr_clk_in;// To hdpldadapt_rxclk_ctl of hdpldadapt_rxclk_ctl.v
input			aib_fabric_rx_transfer_clk;// To hdpldadapt_rxclk_ctl of hdpldadapt_rxclk_ctl.v
input			aib_fabric_tx_sr_clk_in;// To hdpldadapt_rxclk_ctl of hdpldadapt_rxclk_ctl.v
input			aib_fabric_tx_transfer_clk;// To hdpldadapt_rxclk_ctl of hdpldadapt_rxclk_ctl.v
input    		aib_fabric_pld_rx_hssi_fifo_latency_pulse;
input			pld_aib_fabric_rx_dll_lock_req;
input                   pld_rx_dll_lock_req;
input			pld_fabric_rx_fifo_srst; 
input			pld_fabric_rx_asn_data_transfer_en; 
//input			avmm_hrdrst_data_transfer_en;// To hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v
input			tx_hrdrst_fabric_tx_transfer_en;
input			tx_clock_fifo_wr_clk;
input			tx_clock_fifo_rd_clk;
input			avmm_hrdrst_fabric_osc_transfer_en;
input			bond_rx_fifo_ds_in_rden;// To hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v
input			bond_rx_fifo_ds_in_wren;// To hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v
input			bond_rx_fifo_us_in_rden;// To hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v
input			bond_rx_fifo_us_in_wren;// To hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v
input                   bond_rx_hrdrst_ds_in_fabric_rx_dll_lock;
input                   bond_rx_hrdrst_us_in_fabric_rx_dll_lock;
input                   bond_rx_hrdrst_ds_in_fabric_rx_dll_lock_req;
input                   bond_rx_hrdrst_us_in_fabric_rx_dll_lock_req;
input			csr_rdy_dly_in;		// To hdpldadapt_rxrst_ctl of hdpldadapt_rxrst_ctl.v
input			usermode_in;
input			nfrzdrv_in;		// To hdpldadapt_rxclk_ctl of hdpldadapt_rxclk_ctl.v
input                   aib_fabric_pld_pma_pfdmode_lock; 
input                   pr_channel_freeze_n;
input			pld_10g_krfec_rx_clr_errblk_cnt;// To hdpldadapt_rx_async of hdpldadapt_rx_async.v
input			pld_10g_rx_clr_ber_count;// To hdpldadapt_rx_async of hdpldadapt_rx_async.v
input			pld_8g_a1a2_size;	// To hdpldadapt_rx_async of hdpldadapt_rx_async.v
input			pld_8g_bitloc_rev_en;	// To hdpldadapt_rx_async of hdpldadapt_rx_async.v
input			pld_8g_byte_rev_en;	// To hdpldadapt_rx_async of hdpldadapt_rx_async.v
input [2:0]		pld_8g_eidleinfersel;	// To hdpldadapt_rx_async of hdpldadapt_rx_async.v
input			pld_8g_encdt;		// To hdpldadapt_rx_async of hdpldadapt_rx_async.v
input			pld_adapter_rx_pld_rst_n;// To hdpldadapt_rxrst_ctl of hdpldadapt_rxrst_ctl.v
input			pld_bitslip;		// To hdpldadapt_rx_async of hdpldadapt_rx_async.v
input			pld_ltr;		// To hdpldadapt_rx_async of hdpldadapt_rx_async.v
input			pld_pcs_rx_pld_rst_n;	// To hdpldadapt_rxrst_ctl of hdpldadapt_rxrst_ctl.v
input			pld_pma_adapt_start;	// To hdpldadapt_rx_async of hdpldadapt_rx_async.v
//input			pld_pma_coreclkin_dcm;	// To hdpldadapt_rxclk_ctl of hdpldadapt_rxclk_ctl.v
input			pld_pma_coreclkin_rowclk;// To hdpldadapt_rxclk_ctl of hdpldadapt_rxclk_ctl.v
input			pld_pma_early_eios;	// To hdpldadapt_rx_async of hdpldadapt_rx_async.v
input [5:0]		pld_pma_eye_monitor;	// To hdpldadapt_rx_async of hdpldadapt_rx_async.v
input			pld_pma_ltd_b;		// To hdpldadapt_rx_async of hdpldadapt_rx_async.v
input [1:0]		pld_pma_pcie_switch;	// To hdpldadapt_rx_async of hdpldadapt_rx_async.v
input			pld_pma_ppm_lock;	// To hdpldadapt_rx_async of hdpldadapt_rx_async.v
input [4:0]		pld_pma_reserved_out;	// To hdpldadapt_rx_async of hdpldadapt_rx_async.v
input			pld_pma_rs_lpbk_b;	// To hdpldadapt_rx_async of hdpldadapt_rx_async.v
input			pld_pma_rxpma_rstb;	// To hdpldadapt_rxrst_ctl of hdpldadapt_rxrst_ctl.v
input			pld_pmaif_rxclkslip;	// To hdpldadapt_rx_async of hdpldadapt_rx_async.v
input			pld_polinv_rx;		// To hdpldadapt_rx_async of hdpldadapt_rx_async.v
input			pld_rx_clk1_dcm;	// To hdpldadapt_rxclk_ctl of hdpldadapt_rxclk_ctl.v
input			pld_rx_clk1_rowclk;	// To hdpldadapt_rxclk_ctl of hdpldadapt_rxclk_ctl.v
//input			pld_rx_clk2_dcm;	// To hdpldadapt_rxclk_ctl of hdpldadapt_rxclk_ctl.v
input			pld_rx_clk2_rowclk;	// To hdpldadapt_rxclk_ctl of hdpldadapt_rxclk_ctl.v
input			pld_rx_fabric_fifo_align_clr;// To hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v, ...
input			pld_rx_fabric_fifo_rd_en;// To hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v
input			pld_rx_prbs_err_clr;	// To hdpldadapt_rx_async of hdpldadapt_rx_async.v
input			pld_sclk2_rowclk;		// To hdpldadapt_rxclk_ctl of hdpldadapt_rxclk_ctl.v
input			pld_sclk1_rowclk;	// To hdpldadapt_rxclk_ctl of hdpldadapt_rxclk_ctl.v
input			pld_syncsm_en;		// To hdpldadapt_rx_async of hdpldadapt_rx_async.v
input                   pld_aib_hssi_rx_dcd_cal_req;
input [1:0]		r_rx_aib_clk1_sel;	// To hdpldadapt_rxclk_ctl of hdpldadapt_rxclk_ctl.v
input [1:0]		r_rx_aib_clk2_sel;	// To hdpldadapt_rxclk_ctl of hdpldadapt_rxclk_ctl.v
input			r_rx_async_pld_10g_rx_crc32_err_rst_val;// To hdpldadapt_rx_async of hdpldadapt_rx_async.v
input			r_rx_async_pld_8g_signal_detect_out_rst_val;// To hdpldadapt_rx_async of hdpldadapt_rx_async.v
input			r_rx_async_pld_ltr_rst_val;// To hdpldadapt_rx_async of hdpldadapt_rx_async.v
input			r_rx_async_pld_pma_ltd_b_rst_val;// To hdpldadapt_rx_async of hdpldadapt_rx_async.v
input			r_rx_async_pld_rx_fifo_align_clr_rst_val;// To hdpldadapt_rx_async of hdpldadapt_rx_async.v
input			r_rx_async_prbs_flags_sr_enable;// To hdpldadapt_rx_async of hdpldadapt_rx_async.v
input			r_rx_bonding_dft_in_en;	// To hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v
input			r_rx_bonding_dft_in_value;// To hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v
input              bond_rx_asn_ds_in_fifo_hold;
//input              bond_rx_asn_ds_in_dll_lock_en;
//input              bond_rx_asn_ds_in_gen3_sel;
input              bond_rx_asn_us_in_fifo_hold;
//input              bond_rx_asn_us_in_dll_lock_en;
//input              bond_rx_asn_us_in_gen3_sel;
input		   r_rx_asn_en;
input		   r_rx_usertest_sel;
input		   r_rx_asn_bypass_pma_pcie_sw_done;
input   [7:0]      r_rx_asn_wait_for_fifo_flush_cnt;
input   [7:0]      r_rx_asn_wait_for_dll_reset_cnt;
input   [7:0]      r_rx_asn_wait_for_pma_pcie_sw_done_cnt;
//input              r_rx_bonding_dft_in_en;
//input              r_rx_bonding_dft_in_value;
//input [7:0]		r_rx_chnl_datapath_asn_1;// To hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v
//input [7:0]		r_rx_chnl_datapath_asn_2;// To hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v
//input [7:0]		r_rx_chnl_datapath_asn_3;// To hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v
//input [7:0]		r_rx_chnl_datapath_asn_4;// To hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v
input [7:0]		r_rx_comp_cnt;		// To hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v
input [1:0]		r_rx_compin_sel;	// To hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v
//input			r_rx_coreclkin_sel;	// To hdpldadapt_rxclk_ctl of hdpldadapt_rxclk_ctl.v
input			r_rx_double_read;	// To hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v
input			r_rx_ds_bypass_pipeln;	// To hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v
input			r_rx_ds_master;		// To hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v
input [5:0]		r_rx_fifo_empty;	// To hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v
input [5:0]		r_rx_fifo_full;		// To hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v
input [2:0]		r_rx_fifo_mode;		// To hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v
input [5:0]		r_rx_fifo_pempty;	// To hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v
input [5:0]		r_rx_fifo_pfull;	// To hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v
input			r_rx_fifo_rd_clk_scg_en;// To hdpldadapt_rxclk_ctl of hdpldadapt_rxclk_ctl.v
input [1:0]		r_rx_fifo_rd_clk_sel;	// To hdpldadapt_rxclk_ctl of hdpldadapt_rxclk_ctl.v
input			r_rx_fifo_wr_clk_scg_en;// To hdpldadapt_rxclk_ctl of hdpldadapt_rxclk_ctl.v
input 			r_rx_fifo_wr_clk_sel;	// To hdpldadapt_rxclk_ctl of hdpldadapt_rxclk_ctl.v
input			r_rx_gb_dv_en;		// To hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v
input			r_rx_indv;		// To hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v
input [2:0]		r_rx_phcomp_rd_delay;	// To hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v
input			r_rx_pld_clk1_sel;	// To hdpldadapt_rxclk_ctl of hdpldadapt_rxclk_ctl.v
//input			r_rx_pld_clk2_sel;	// To hdpldadapt_rxclk_ctl of hdpldadapt_rxclk_ctl.v
input			r_rx_pma_hclk_scg_en;	// To hdpldadapt_rxclk_ctl of hdpldadapt_rxclk_ctl.v
input			r_rx_osc_clk_scg_en;	// To hdpldadapt_rxclk_ctl of hdpldadapt_rxclk_ctl.v
input			r_rx_fifo_wr_clk_del_sm_scg_en;
input			r_rx_fifo_rd_clk_ins_sm_scg_en;
input			r_rx_sclk_sel;		// To hdpldadapt_rxclk_ctl of hdpldadapt_rxclk_ctl.v
input                   r_rx_internal_clk1_sel1;
input                   r_rx_internal_clk1_sel2;
input                   r_rx_txfiford_post_ct_sel;
input                   r_rx_txfifowr_post_ct_sel;
input                   r_rx_internal_clk2_sel1;
input                   r_rx_internal_clk2_sel2;
input                   r_rx_rxfifowr_post_ct_sel;
input                   r_rx_rxfiford_post_ct_sel;
input			r_rx_pld_clk1_delay_en;
input [3:0]		r_rx_pld_clk1_delay_sel;
input			r_rx_pld_clk1_inv_en;
input			r_rx_stop_read;		// To hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v
input			r_rx_stop_write;	// To hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v
input			r_rx_truebac2bac;	// To hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v
input			r_rx_us_bypass_pipeln;	// To hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v
input			r_rx_us_master;		// To hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v
input			r_rx_wa_en;		// To hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v
input                   r_rx_pld_8g_eidleinfersel_polling_bypass;
input                   r_rx_pld_pma_eye_monitor_polling_bypass;
input                   r_rx_pld_pma_pcie_switch_polling_bypass;
input                   r_rx_pld_pma_reser_out_polling_bypass;
input			rx_async_fabric_hssi_fsr_load;// To hdpldadapt_rx_async of hdpldadapt_rx_async.v
input			rx_async_fabric_hssi_ssr_load;// To hdpldadapt_rx_async of hdpldadapt_rx_async.v
input [1:0]		rx_async_hssi_fabric_fsr_data;// To hdpldadapt_rx_async of hdpldadapt_rx_async.v
input			rx_async_hssi_fabric_fsr_load;// To hdpldadapt_rx_async of hdpldadapt_rx_async.v
input [62:0]		rx_async_hssi_fabric_ssr_data;// To hdpldadapt_rx_async of hdpldadapt_rx_async.v
input			rx_async_hssi_fabric_ssr_load;// To hdpldadapt_rx_async of hdpldadapt_rx_async.v
input			rx_fsr_mask_tx_pll;	// To hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v
input                   r_rx_hrdrst_rx_osc_clk_scg_en;
input			r_rx_free_run_div_clk;
input                   r_rx_hrdrst_rst_sm_dis;
input                   r_rx_hrdrst_dll_lock_bypass;
input                   r_rx_hrdrst_align_bypass;
input			r_rx_hrdrst_user_ctl_en;
//input [1:0]        	r_rx_hrdrst_master_sel;
//input               	r_rx_hrdrst_dist_master_sel;
input               	r_rx_ds_last_chnl;
input               	r_rx_us_last_chnl;

input 			r_rx_write_ctrl;
input [2:0]	        r_rx_fifo_power_mode;
input [2:0]	        r_rx_stretch_num_stages; 
input [3:0]	        r_rx_datapath_tb_sel;
input 		        r_rx_wr_adj_en;
input                   r_rx_rd_adj_en; 
input			r_rx_hip_en;
input                   pld_rx_fifo_latency_adj_en;
input 			r_rx_pipe_en;
input			r_rx_lpbk_en;
input [39:0]		aib_fabric_tx_data_lpbk;
input [1:0]		rx_pld_rate;
input [1:0]             pld_rx_ssr_reserved_in;
input [1:0]             rx_async_hssi_fabric_ssr_reserved;
input [19:0]		sr_testbus;
input [19:0]		avmm_testbus;
input [19:0]		tx_chnl_testbus;
input [19:0]		sr_parity_error_flag;



// End of automatics
/*AUTOOUTPUT*/
// Beginning of automatic outputs (from unused autoinst outputs)
   
output [12:0]		dft_fabric_oaibdftdll2core;
output			pld_hssi_asn_dll_lock_en;
output			pld_fabric_asn_dll_lock_en;
output			pld_hssi_rx_transfer_en;
output			pld_aib_fabric_rx_dll_lock;
output			aib_fabric_adapter_rx_pld_rst_n;// From hdpldadapt_rxrst_ctl of hdpldadapt_rxrst_ctl.v
output			aib_fabric_pcs_rx_pld_rst_n;// From hdpldadapt_rxrst_ctl of hdpldadapt_rxrst_ctl.v
output			aib_fabric_pld_pma_coreclkin;// From hdpldadapt_rxclk_ctl of hdpldadapt_rxclk_ctl.v
output			aib_fabric_pld_pma_rxpma_rstb;// From hdpldadapt_rxrst_ctl of hdpldadapt_rxrst_ctl.v
output			aib_fabric_pld_sclk;	// From hdpldadapt_rxclk_ctl of hdpldadapt_rxclk_ctl.v
output			aib_fabric_rx_dll_lock_req;// To hdpldadapt_rx_async of hdpldadapt_rx_async.v
output              bond_rx_asn_ds_out_fifo_hold;
//output              bond_rx_asn_ds_out_dll_lock_en;
output              bond_rx_asn_us_out_fifo_hold;
//output              bond_rx_asn_us_out_dll_lock_en;
output			bond_rx_fifo_ds_out_rden;// From hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v
output			bond_rx_fifo_ds_out_wren;// From hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v
output			bond_rx_fifo_us_out_rden;// From hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v
output			bond_rx_fifo_us_out_wren;// From hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v
output                  bond_rx_hrdrst_ds_out_fabric_rx_dll_lock;
output                  bond_rx_hrdrst_us_out_fabric_rx_dll_lock;
output                  bond_rx_hrdrst_ds_out_fabric_rx_dll_lock_req;
output                  bond_rx_hrdrst_us_out_fabric_rx_dll_lock_req;
output			pld_10g_krfec_rx_blk_lock;// From hdpldadapt_rx_async of hdpldadapt_rx_async.v
output [1:0]		pld_10g_krfec_rx_diag_data_status;// From hdpldadapt_rx_async of hdpldadapt_rx_async.v
output			pld_10g_krfec_rx_frame;	// From hdpldadapt_rx_async of hdpldadapt_rx_async.v
output			pld_10g_rx_crc32_err;	// From hdpldadapt_rx_async of hdpldadapt_rx_async.v
output			pld_10g_rx_frame_lock;	// From hdpldadapt_rx_async of hdpldadapt_rx_async.v
output			pld_10g_rx_hi_ber;	// From hdpldadapt_rx_async of hdpldadapt_rx_async.v
output [3:0]		pld_8g_a1a2_k1k2_flag;	// From hdpldadapt_rx_async of hdpldadapt_rx_async.v
output			pld_8g_empty_rmf;	// From hdpldadapt_rx_async of hdpldadapt_rx_async.v
output			pld_8g_full_rmf;	// From hdpldadapt_rx_async of hdpldadapt_rx_async.v
output			pld_8g_rxelecidle;	// From hdpldadapt_rx_async of hdpldadapt_rx_async.v
output			pld_8g_signal_detect_out;// From hdpldadapt_rx_async of hdpldadapt_rx_async.v
output [4:0]		pld_8g_wa_boundary;	// From hdpldadapt_rx_async of hdpldadapt_rx_async.v
output			pld_pcs_rx_clk_out1_dcm;// From hdpldadapt_rxclk_ctl of hdpldadapt_rxclk_ctl.v
output			pld_pcs_rx_clk_out1_hioint;// From hdpldadapt_rxclk_ctl of hdpldadapt_rxclk_ctl.v
output			pld_pcs_rx_clk_out2_dcm;// From hdpldadapt_rxclk_ctl of hdpldadapt_rxclk_ctl.v
output			pld_pcs_rx_clk_out2_hioint;// From hdpldadapt_rxclk_ctl of hdpldadapt_rxclk_ctl.v
output			pld_pma_adapt_done;	// From hdpldadapt_rx_async of hdpldadapt_rx_async.v
//output			pld_pma_hclk_dcm;	// From hdpldadapt_rxclk_ctl of hdpldadapt_rxclk_ctl.v
output			pld_pma_hclk_hioint;	// From hdpldadapt_rxclk_ctl of hdpldadapt_rxclk_ctl.v
//output			pld_pma_internal_clk1_dcm;// From hdpldadapt_rxclk_ctl of hdpldadapt_rxclk_ctl.v
output			pld_pma_internal_clk1_hioint;// From hdpldadapt_rxclk_ctl of hdpldadapt_rxclk_ctl.v
//output			pld_pma_internal_clk2_dcm;// From hdpldadapt_rxclk_ctl of hdpldadapt_rxclk_ctl.v
output			pld_pma_internal_clk2_hioint;// From hdpldadapt_rxclk_ctl of hdpldadapt_rxclk_ctl.v
output [1:0]		pld_pma_pcie_sw_done;	// From hdpldadapt_rx_async of hdpldadapt_rx_async.v
output [4:0]		pld_pma_reserved_in;	// From hdpldadapt_rx_async of hdpldadapt_rx_async.v
output			pld_pma_rx_detect_valid;// From hdpldadapt_rx_async of hdpldadapt_rx_async.v
output			pld_pma_rxpll_lock;	// From hdpldadapt_rx_async of hdpldadapt_rx_async.v
output			pld_pma_signal_ok;	// From hdpldadapt_rx_async of hdpldadapt_rx_async.v
output [7:0]		pld_pma_testbus;	// From hdpldadapt_rx_async of hdpldadapt_rx_async.v
output			pld_rx_fabric_align_done;// From hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v
output [79:0]		pld_rx_fabric_data_out;	// From hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v
output			pld_rx_fabric_fifo_empty;// From hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v
output			pld_rx_fabric_fifo_full;// From hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v
output			pld_rx_fabric_fifo_insert;// From hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v
output			pld_rx_fabric_fifo_latency_pulse;// From hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v
output			pld_rx_fabric_fifo_pempty;// From hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v
output			pld_rx_fabric_fifo_pfull;// From hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v
output			pld_rx_hssi_fifo_empty;	// From hdpldadapt_rx_async of hdpldadapt_rx_async.v
output			pld_rx_hssi_fifo_full;	// From hdpldadapt_rx_async of hdpldadapt_rx_async.v
output			pld_rx_prbs_done;	// From hdpldadapt_rx_async of hdpldadapt_rx_async.v
output			pld_rx_prbs_err;	// From hdpldadapt_rx_async of hdpldadapt_rx_async.v
output [19:0]		pld_test_data;		// From hdpldadapt_rx_async of hdpldadapt_rx_async.v
output			rx_clock_pld_sclk;
output			rx_asn_fifo_hold;	// From hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v
//output			rx_asn_fifo_srst;	// From hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v
//output			rx_asn_gen3_sel;	// From hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v
output			rx_asn_rate_change_in_progress;
output			rx_asn_dll_lock_en;	// From hdpldadapt_rx_datapath of hdpldadapt_rx_datapath.v
output [2:0]		rx_async_fabric_hssi_fsr_data;// From hdpldadapt_rx_async of hdpldadapt_rx_async.v
output [35:0]		rx_async_fabric_hssi_ssr_data;// From hdpldadapt_rx_async of hdpldadapt_rx_async.v
output                  pld_fsr_load;
output                  pld_ssr_load;
output			pld_rx_hssi_fifo_latency_pulse;
output			pld_aib_hssi_rx_dcd_cal_done;
output [1:0]            pld_rx_ssr_reserved_out;
output [1:0]            rx_async_fabric_hssi_ssr_reserved;
output                  pld_pma_pfdmode_lock; 
output [1:0]            rx_fsr_parity_checker_in;
output [64:0]           rx_ssr_parity_checker_in;
output			pld_rx_fifo_ready;
// End of automatics

output [1:0]            adapter_scan_out_occ1;
output [4:0]            adapter_scan_out_occ2;
output                  adapter_scan_out_occ3;
output                  adapter_scan_out_occ4;
output [1:0]            adapter_scan_out_occ5;
output [10:0]           adapter_scan_out_occ6;
output                  adapter_scan_out_occ7;
output                  adapter_scan_out_occ8;
output                  adapter_scan_out_occ9;
output                  adapter_scan_out_occ10;
output                  adapter_scan_out_occ11;
output                  adapter_scan_out_occ12;
output                  adapter_scan_out_occ13;
output                  adapter_scan_out_occ14;
output                  adapter_scan_out_occ15;
output                  adapter_scan_out_occ16;
output                  adapter_scan_out_occ17;
output [1:0]            adapter_scan_out_occ18;
output                  adapter_scan_out_occ19;
output                  adapter_scan_out_occ20;
output [1:0]            adapter_scan_out_occ21;
output                  adapter_non_occ_scan_out;
output                  adapter_occ_scan_out;

// temp
output [7:0]             rx_chnl_dprio_status;   // To hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output                   rx_chnl_dprio_status_write_en_ack;// To hdpldadapt_avmm1 of hdpldadapt_avmm1.v
input                  rx_chnl_dprio_status_write_en;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v

output 			pld_rx_fabric_fifo_del;
output                  pld_pma_rx_found;
//assign rx_chnl_dprio_status = 8'h0;
//assign rx_chnl_dprio_status_write_en_ack = 1'b0;



/*AUTOWIRE*/
// Beginning of automatic wires (for undeclared instantiated-module outputs)
wire			rx_clock_asn_pma_hclk;	// From hdpldadapt_rxclk_ctl of hdpldadapt_rxclk_ctl.v
wire			rx_clock_async_rx_osc_clk;// From hdpldadapt_rxclk_ctl of hdpldadapt_rxclk_ctl.v
wire			rx_clock_async_tx_osc_clk;// From hdpldadapt_rxclk_ctl of hdpldadapt_rxclk_ctl.v
wire			rx_clock_fifo_rd_clk_ins_sm;
wire			rx_clock_fifo_rd_clk;	// From hdpldadapt_rxclk_ctl of hdpldadapt_rxclk_ctl.v
wire			rx_clock_fifo_sclk;	// From hdpldadapt_rxclk_ctl of hdpldadapt_rxclk_ctl.v
wire			rx_clock_fifo_wr_clk_del_sm;
wire			rx_clock_fifo_wr_clk;	// From hdpldadapt_rxclk_ctl of hdpldadapt_rxclk_ctl.v
wire			rx_reset_asn_pma_hclk_rst_n;// From hdpldadapt_rxrst_ctl of hdpldadapt_rxrst_ctl.v
wire			rx_reset_async_rx_osc_clk_rst_n;// From hdpldadapt_rxrst_ctl of hdpldadapt_rxrst_ctl.v
wire			rx_reset_async_tx_osc_clk_rst_n;// From hdpldadapt_rxrst_ctl of hdpldadapt_rxrst_ctl.v
wire			rx_reset_fifo_rd_rst_n;	// From hdpldadapt_rxrst_ctl of hdpldadapt_rxrst_ctl.v
wire			rx_reset_fifo_sclk_rst_n;// From hdpldadapt_rxrst_ctl of hdpldadapt_rxrst_ctl.v
wire			rx_reset_fifo_wr_rst_n;	// From hdpldadapt_rxrst_ctl of hdpldadapt_rxrst_ctl.v
wire			rx_reset_pld_pma_hclk_rst_n;// From hdpldadapt_rxrst_ctl of hdpldadapt_rxrst_ctl.v
wire [1:0]		rx_ssr_pcie_sw_done;	// From hdpldadapt_rx_async of hdpldadapt_rx_async.v
// End of automatics
wire			rx_hrdrst_rx_fifo_srst;
wire			rx_hrdrst_fabric_rx_dll_lock;
wire			rx_hrdrst_fabric_rx_transfer_en;
wire			rx_hrdrst_asn_data_transfer_en;
wire                    sr_hssi_rx_dcd_cal_done;
wire                    sr_hssi_rx_transfer_en;
//wire [1:0]        	r_rx_master_sel = 2'b00;
//wire               	r_rx_dist_master_sel = 1'b0;
//wire			r_rx_ds_last_chnl = 1'b0;
//wire			r_rx_us_last_chnl = 1'b0;

wire			rx_fabric_align_done_raw;
wire			rx_fifo_ready;
wire 			wa_error;
wire  [3:0]		wa_error_cnt;
wire  [39:0] aib_fabric_rx_data_in_int	= r_rx_lpbk_en ? aib_fabric_tx_data_lpbk : aib_fabric_rx_data_in;

wire [19:0]           rx_fifo_testbus1; 		// RX FIFO
wire [19:0]           rx_fifo_testbus2; 		// RX FIFO
wire [19:0]           rx_cp_bond_testbus;
wire [19:0]           rx_asn_testbus;
wire [19:0]           deletion_sm_testbus;
wire [19:0]           insertion_sm_testbus;
wire [19:0]           word_align_testbus;
wire [19:0]           rx_hrdrst_testbus; 
wire [19:0]	      rx_chnl_testbus;
wire [19:0]	      sr_test_data;
wire 		      rd_align_clr_reg;
wire [19:0]           sr_testbus_int;

assign dft_fabric_oaibdftdll2core = nfrzdrv_in ? oaibdftdll2core : 13'b1111_1111_1111;

assign adapter_scan_out_occ1[1:0] = 2'b00;
assign adapter_scan_out_occ2[4:0] = 5'b00000;
assign adapter_scan_out_occ3 = 1'b0;
assign adapter_scan_out_occ4 = 1'b0;
assign adapter_scan_out_occ5[1:0] = 2'b00;
assign adapter_scan_out_occ6[10:0] = 11'b000_0000_0000;
assign adapter_scan_out_occ7 = 1'b0;
assign adapter_scan_out_occ8 = 1'b0;
assign adapter_scan_out_occ9 = 1'b0;
assign adapter_scan_out_occ10 = 1'b0;
assign adapter_scan_out_occ11 = 1'b0;
assign adapter_scan_out_occ12 = 1'b0;
assign adapter_scan_out_occ13 = 1'b0;
assign adapter_scan_out_occ14 = 1'b0;
assign adapter_scan_out_occ15 = 1'b0;
assign adapter_scan_out_occ16 = 1'b0;
assign adapter_scan_out_occ17 = 1'b0;
assign adapter_scan_out_occ18[1:0] = 2'b00;
assign adapter_scan_out_occ19 = 1'b0;
assign adapter_scan_out_occ20 = 1'b0;
assign adapter_scan_out_occ21[1:0] = 2'b00;
assign adapter_non_occ_scan_out = 1'b0;
//assign adapter_occ_scan_out = 1'b0;

assign adapter_occ_scan_out = nfrzdrv_in ? 1'b0 : 1'b1;


/*  REMOVED FOR ECO8
 
// Separate HIP and non-HIP bonding paths for TIMING closure purpose
assign bond_rx_fifo_ds_in_wren_hip = bond_rx_fifo_ds_in_wren; 
assign bond_rx_fifo_ds_in_wren_non_hip = bond_rx_fifo_ds_in_wren; 
assign bond_rx_fifo_us_in_wren_hip = bond_rx_fifo_us_in_wren; 
assign bond_rx_fifo_us_in_wren_non_hip = bond_rx_fifo_us_in_wren; 

assign bond_rx_fifo_ds_in_wren_int = r_rx_hip_en ? bond_rx_fifo_ds_in_wren_hip: bond_rx_fifo_ds_in_wren_non_hip;
assign bond_rx_fifo_us_in_wren_int = r_rx_hip_en ? bond_rx_fifo_us_in_wren_hip: bond_rx_fifo_us_in_wren_non_hip;

*/ 

hdpldadapt_rx_datapath hdpldadapt_rx_datapath(/*AUTOINST*/
					      // Outputs
					      .pld_rx_fabric_data_out(pld_rx_fabric_data_out[79:0]),
					      .pld_fabric_asn_dll_lock_en(pld_fabric_asn_dll_lock_en),
					      .rx_fabric_align_done_raw(rx_fabric_align_done_raw),
					      .rx_asn_rate_change_in_progress(rx_asn_rate_change_in_progress),
					      .rx_asn_dll_lock_en(rx_asn_dll_lock_en),
					      .rx_asn_fifo_hold	(rx_asn_fifo_hold),
					      .pld_rx_hssi_fifo_latency_pulse (pld_rx_hssi_fifo_latency_pulse),
					      //.rx_asn_fifo_srst	(rx_asn_fifo_srst),
					      //.rx_asn_gen3_sel	(rx_asn_gen3_sel),
					      .pld_rx_fabric_fifo_full(pld_rx_fabric_fifo_full),
					      .pld_rx_fabric_fifo_empty(pld_rx_fabric_fifo_empty),
					      .pld_rx_fabric_fifo_pfull(pld_rx_fabric_fifo_pfull),
					      .pld_rx_fabric_fifo_pempty(pld_rx_fabric_fifo_pempty),
					      .pld_rx_fabric_fifo_latency_pulse(pld_rx_fabric_fifo_latency_pulse),
					      .pld_rx_fabric_fifo_insert(pld_rx_fabric_fifo_insert),
					      .pld_rx_fabric_fifo_del(pld_rx_fabric_fifo_del),
					      .pld_rx_fabric_align_done(pld_rx_fabric_align_done),
					      .pld_rx_fifo_ready(pld_rx_fifo_ready),
					      .bond_rx_fifo_ds_out_rden(bond_rx_fifo_ds_out_rden),
					      .bond_rx_fifo_ds_out_wren(bond_rx_fifo_ds_out_wren),
					      .bond_rx_fifo_us_out_rden(bond_rx_fifo_us_out_rden),
					      .bond_rx_fifo_us_out_wren(bond_rx_fifo_us_out_wren),
                                                                .bond_rx_asn_ds_out_fifo_hold(bond_rx_asn_ds_out_fifo_hold),
                                                                //.bond_rx_asn_ds_out_dll_lock_en(bond_rx_asn_ds_out_dll_lock_en),
                                                                .bond_rx_asn_us_out_fifo_hold(bond_rx_asn_us_out_fifo_hold),
                                                                //.bond_rx_asn_us_out_dll_lock_en(bond_rx_asn_us_out_dll_lock_en),
					      .wa_error		(wa_error),
					      .wa_error_cnt		(wa_error_cnt[3:0]),
					      .rd_align_clr_reg 	(rd_align_clr_reg),
					      .rx_fifo_ready	(rx_fifo_ready),

					      // Inputs
                                                // new inputs for ECO8
                                                .r_rx_wren_fastbond (r_rx_wren_fastbond),
                                                .r_rx_rden_fastbond (r_rx_rden_fastbond),                                                 
					      .aib_fabric_rx_data_in(aib_fabric_rx_data_in_int[39:0]),
					      .aib_fabric_pld_rx_hssi_fifo_latency_pulse (aib_fabric_pld_rx_hssi_fifo_latency_pulse),
					      .r_rx_usertest_sel(r_rx_usertest_sel),
					      //.avmm_hrdrst_data_transfer_en(avmm_hrdrst_data_transfer_en),
					      .rx_hrdrst_asn_data_transfer_en(rx_hrdrst_asn_data_transfer_en),
					      .rx_hrdrst_rx_fifo_srst(rx_hrdrst_rx_fifo_srst),
					      .r_rx_hrdrst_user_ctl_en(r_rx_hrdrst_user_ctl_en),
					      .r_rx_bonding_dft_in_en(r_rx_bonding_dft_in_en),
					      .r_rx_bonding_dft_in_value(r_rx_bonding_dft_in_value),
					      .r_rx_comp_cnt	(r_rx_comp_cnt[7:0]),
					      .r_rx_compin_sel	(r_rx_compin_sel[1:0]),
					      .r_rx_double_read	(r_rx_double_read),
					      .r_rx_ds_bypass_pipeln(r_rx_ds_bypass_pipeln),
					      .r_rx_ds_master	(r_rx_ds_master),
					      .r_rx_fifo_empty	(r_rx_fifo_empty[5:0]),
					      .r_rx_fifo_mode	(r_rx_fifo_mode[2:0]),
					      .r_rx_fifo_full	(r_rx_fifo_full[5:0]),
					      .r_rx_indv	(r_rx_indv),
					      .r_rx_fifo_pempty	(r_rx_fifo_pempty[5:0]),
					      .r_rx_fifo_pfull	(r_rx_fifo_pfull[5:0]),
					      .r_rx_phcomp_rd_delay(r_rx_phcomp_rd_delay[2:0]),
                                                                .bond_rx_asn_ds_in_fifo_hold(bond_rx_asn_ds_in_fifo_hold),
                                                                //.bond_rx_asn_ds_in_dll_lock_en(bond_rx_asn_ds_in_dll_lock_en),
                                                                //.bond_rx_asn_ds_in_gen3_sel(bond_rx_asn_ds_in_gen3_sel),
                                                                .bond_rx_asn_us_in_fifo_hold(bond_rx_asn_us_in_fifo_hold),
                                                                //.bond_rx_asn_us_in_dll_lock_en(bond_rx_asn_us_in_dll_lock_en),
                                                                //.bond_rx_asn_us_in_gen3_sel(bond_rx_asn_us_in_gen3_sel),
                                                                .r_rx_asn_en(r_rx_asn_en),
                                                                .r_rx_asn_bypass_pma_pcie_sw_done(r_rx_asn_bypass_pma_pcie_sw_done),
                                                                .r_rx_asn_wait_for_fifo_flush_cnt(r_rx_asn_wait_for_fifo_flush_cnt),
                                                                .r_rx_asn_wait_for_dll_reset_cnt(r_rx_asn_wait_for_dll_reset_cnt),
                                                                .r_rx_asn_wait_for_pma_pcie_sw_done_cnt(r_rx_asn_wait_for_pma_pcie_sw_done_cnt),
//                                                                .r_rx_master_sel(r_rx_compin_sel[1:0]),
//                                                                .r_rx_dist_master_sel(r_rx_ds_master),
                                                                //.r_rx_bonding_dft_in_en(r_rx_bonding_dft_in_en),
                                                                //.r_rx_bonding_dft_in_value(r_rx_bonding_dft_in_value),
					      //.r_rx_chnl_datapath_asn_1(r_rx_chnl_datapath_asn_1[7:0]),
					      //.r_rx_chnl_datapath_asn_2(r_rx_chnl_datapath_asn_2[7:0]),
					      //.r_rx_chnl_datapath_asn_3(r_rx_chnl_datapath_asn_3[7:0]),
					      //.r_rx_chnl_datapath_asn_4(r_rx_chnl_datapath_asn_4[7:0]),
					      .r_rx_stop_read	(r_rx_stop_read),
					      .r_rx_stop_write	(r_rx_stop_write),
					      .r_rx_truebac2bac	(r_rx_truebac2bac),
					      .r_rx_us_bypass_pipeln(r_rx_us_bypass_pipeln),
					      .r_rx_us_master	(r_rx_us_master),
					      .r_rx_gb_dv_en	(r_rx_gb_dv_en),
					      .r_rx_wa_en	(r_rx_wa_en),
					      .r_rx_write_ctrl	(r_rx_write_ctrl),
      				              .r_rx_fifo_power_mode				 (r_rx_fifo_power_mode),
                                              .r_rx_stretch_num_stages				 (r_rx_stretch_num_stages), 	
//                                              .r_rx_datapath_tb_sel 				 (r_rx_datapath_tb_sel), 
                                              .r_rx_wr_adj_en 					 (r_rx_wr_adj_en), 
                                              .r_rx_rd_adj_en					 (r_rx_rd_adj_en),
                                              .r_rx_pipe_en					 (r_rx_pipe_en),
					      .r_rx_ds_last_chnl(r_rx_ds_last_chnl),
					      .r_rx_us_last_chnl(r_rx_us_last_chnl),
                                              .rx_pld_rate					 (rx_pld_rate),
                                              .pr_channel_freeze_n(pr_channel_freeze_n),
                                              .nfrzdrv_in             (nfrzdrv_in),
					      .rx_fifo_testbus1	(rx_fifo_testbus1),
					      .rx_fifo_testbus2 	(rx_fifo_testbus2), 
        				      .rx_cp_bond_testbus	(rx_cp_bond_testbus),
					      .rx_asn_testbus		(rx_asn_testbus),
					      .word_align_testbus	(word_align_testbus),
	                                      .deletion_sm_testbus		(deletion_sm_testbus),
	                                      .insertion_sm_testbus		(insertion_sm_testbus),
					      
					      .rx_clock_asn_pma_hclk(rx_clock_asn_pma_hclk),
					      .rx_reset_asn_pma_hclk_rst_n(rx_reset_asn_pma_hclk_rst_n),
					      .rx_fsr_mask_tx_pll(rx_fsr_mask_tx_pll),
					      .rx_ssr_pcie_sw_done(rx_ssr_pcie_sw_done[1:0]),
					      .rx_clock_fifo_rd_clk(rx_clock_fifo_rd_clk),
					      .rx_clock_fifo_wr_clk(rx_clock_fifo_wr_clk),
					      .rx_clock_fifo_wr_clk_del_sm(rx_clock_fifo_wr_clk_del_sm),
					      .rx_clock_fifo_rd_clk_ins_sm(rx_clock_fifo_rd_clk_ins_sm),
					      .q1_rx_clock_fifo_wr_clk(q1_rx_clock_fifo_wr_clk),
					      .q2_rx_clock_fifo_wr_clk(q2_rx_clock_fifo_wr_clk), 
					      .q3_rx_clock_fifo_wr_clk(q3_rx_clock_fifo_wr_clk),  
					      .q4_rx_clock_fifo_wr_clk(q4_rx_clock_fifo_wr_clk),   
					      .q5_rx_clock_fifo_wr_clk(q5_rx_clock_fifo_wr_clk),   
					      .q6_rx_clock_fifo_wr_clk(q6_rx_clock_fifo_wr_clk),   
					      .rx_reset_fifo_wr_rst_n(rx_reset_fifo_wr_rst_n),
					      .rx_reset_fifo_sclk_rst_n(rx_reset_fifo_sclk_rst_n),
					      .rx_reset_fifo_rd_rst_n(rx_reset_fifo_rd_rst_n),
					      .rx_clock_fifo_sclk(rx_clock_fifo_sclk),
					      .bond_rx_fifo_ds_in_rden(bond_rx_fifo_ds_in_rden),
					      .bond_rx_fifo_ds_in_wren(bond_rx_fifo_ds_in_wren),
					      .bond_rx_fifo_us_in_rden(bond_rx_fifo_us_in_rden),
					      .bond_rx_fifo_us_in_wren(bond_rx_fifo_us_in_wren),
					      .pld_fabric_rx_asn_data_transfer_en(pld_fabric_rx_asn_data_transfer_en),
					      .pld_rx_fabric_fifo_rd_en(pld_rx_fabric_fifo_rd_en),
				              .pld_rx_fifo_latency_adj_en (pld_rx_fifo_latency_adj_en),
					      .pld_rx_fabric_fifo_align_clr(pld_rx_fabric_fifo_align_clr));
hdpldadapt_rx_async hdpldadapt_rx_async(/*AUTOINST*/
					// Outputs
                                        .pld_pma_pfdmode_lock (pld_pma_pfdmode_lock),
                                        .pld_rx_ssr_reserved_out (pld_rx_ssr_reserved_out),
                                        .rx_async_fabric_hssi_ssr_reserved (rx_async_fabric_hssi_ssr_reserved),
					.pld_8g_rxelecidle(pld_8g_rxelecidle),
					.pld_pma_rxpll_lock(pld_pma_rxpll_lock),
					.pld_8g_signal_detect_out(pld_8g_signal_detect_out),
					.pld_10g_krfec_rx_blk_lock(pld_10g_krfec_rx_blk_lock),
					.pld_10g_krfec_rx_diag_data_status(pld_10g_krfec_rx_diag_data_status[1:0]),
					.pld_10g_rx_crc32_err(pld_10g_rx_crc32_err),
					.pld_10g_rx_frame_lock(pld_10g_rx_frame_lock),
					.pld_10g_rx_hi_ber(pld_10g_rx_hi_ber),
					.pld_8g_a1a2_k1k2_flag(pld_8g_a1a2_k1k2_flag[3:0]),
					.pld_8g_empty_rmf(pld_8g_empty_rmf),
					.pld_8g_full_rmf(pld_8g_full_rmf),
					.pld_8g_wa_boundary(pld_8g_wa_boundary[4:0]),
					.pld_pma_adapt_done(pld_pma_adapt_done),
					.pld_pma_pcie_sw_done(pld_pma_pcie_sw_done[1:0]),
					.pld_pma_reserved_in(pld_pma_reserved_in[4:0]),
					.pld_pma_rx_detect_valid(pld_pma_rx_detect_valid),
					.pld_pma_signal_ok(pld_pma_signal_ok),
					.pld_pma_testbus(pld_pma_testbus[7:0]),
					.pld_rx_prbs_done(pld_rx_prbs_done),
					.pld_rx_prbs_err(pld_rx_prbs_err),
					.pld_test_data	(pld_test_data[19:0]),
					.pld_10g_krfec_rx_frame(pld_10g_krfec_rx_frame),
					.pld_rx_hssi_fifo_full(pld_rx_hssi_fifo_full),
					.pld_rx_hssi_fifo_empty(pld_rx_hssi_fifo_empty),
					.rx_ssr_pcie_sw_done(rx_ssr_pcie_sw_done[1:0]),
					.rx_async_fabric_hssi_fsr_data(rx_async_fabric_hssi_fsr_data[2:0]),
					.rx_async_fabric_hssi_ssr_data(rx_async_fabric_hssi_ssr_data[35:0]),
                                        .pld_fsr_load(pld_fsr_load),
                                        .pld_ssr_load(pld_ssr_load),
                                        .sr_hssi_rx_dcd_cal_done(sr_hssi_rx_dcd_cal_done),
                                        .sr_hssi_rx_transfer_en(sr_hssi_rx_transfer_en),
                                        .pld_aib_hssi_rx_dcd_cal_done(pld_aib_hssi_rx_dcd_cal_done),
                                        .sr_test_data (sr_test_data),
                                        .pld_pma_rx_found  (pld_pma_rx_found),
                                        .rx_fsr_parity_checker_in (rx_fsr_parity_checker_in),
                                        .rx_ssr_parity_checker_in (rx_ssr_parity_checker_in),
                                 	.sr_testbus_int		(sr_testbus_int),
					// Inputs 
					.usermode_in	(usermode_in),
	                                .sr_testbus		(sr_testbus),
                                        .aib_fabric_pld_pma_pfdmode_lock (aib_fabric_pld_pma_pfdmode_lock),
                                        .r_rx_pld_8g_eidleinfersel_polling_bypass   (r_rx_pld_8g_eidleinfersel_polling_bypass),
                                        .r_rx_pld_pma_eye_monitor_polling_bypass   (r_rx_pld_pma_eye_monitor_polling_bypass),
                                        .r_rx_pld_pma_pcie_switch_polling_bypass   (r_rx_pld_pma_pcie_switch_polling_bypass),
                                        .r_rx_pld_pma_reser_out_polling_bypass   (r_rx_pld_pma_reser_out_polling_bypass),
					.pld_test_data_int	(rx_chnl_testbus),                                        
                                        .pld_rx_ssr_reserved_in (pld_rx_ssr_reserved_in),
                                        .rx_async_hssi_fabric_ssr_reserved (rx_async_hssi_fabric_ssr_reserved),
                                        //.pld_rx_fabric_data_out (pld_rx_fabric_data_out[1:0]),
				        .pld_rx_fifo_latency_adj_en (pld_rx_fifo_latency_adj_en),
                                        .pld_aib_hssi_rx_dcd_cal_req (pld_aib_hssi_rx_dcd_cal_req),
                                        .rx_hrdrst_fabric_rx_dll_lock(rx_hrdrst_fabric_rx_dll_lock),
                                        .rx_hrdrst_fabric_rx_transfer_en(rx_hrdrst_fabric_rx_transfer_en),
                                        .pld_rx_dll_lock_req (pld_rx_dll_lock_req),
                                        .pr_channel_freeze_n(pr_channel_freeze_n),
                                        .nfrzdrv_in             (nfrzdrv_in),
					.r_rx_async_pld_ltr_rst_val(r_rx_async_pld_ltr_rst_val),
					.r_rx_async_pld_pma_ltd_b_rst_val(r_rx_async_pld_pma_ltd_b_rst_val),
					.r_rx_async_pld_8g_signal_detect_out_rst_val(r_rx_async_pld_8g_signal_detect_out_rst_val),
					.r_rx_async_pld_10g_rx_crc32_err_rst_val(r_rx_async_pld_10g_rx_crc32_err_rst_val),
					.r_rx_async_pld_rx_fifo_align_clr_rst_val(r_rx_async_pld_rx_fifo_align_clr_rst_val),
					.r_rx_async_prbs_flags_sr_enable(r_rx_async_prbs_flags_sr_enable),
					.pld_ltr	(pld_ltr),
					.pld_pma_ltd_b	(pld_pma_ltd_b),
					.pld_10g_krfec_rx_clr_errblk_cnt(pld_10g_krfec_rx_clr_errblk_cnt),
					.pld_10g_rx_clr_ber_count(pld_10g_rx_clr_ber_count),
					.pld_8g_a1a2_size(pld_8g_a1a2_size),
					.pld_8g_bitloc_rev_en(pld_8g_bitloc_rev_en),
					.pld_8g_byte_rev_en(pld_8g_byte_rev_en),
					.pld_8g_eidleinfersel(pld_8g_eidleinfersel[2:0]),
					.pld_8g_encdt	(pld_8g_encdt),
					.pld_bitslip	(pld_bitslip),
					.pld_pma_adapt_start(pld_pma_adapt_start),
					.pld_pma_early_eios(pld_pma_early_eios),
					.pld_pma_eye_monitor(pld_pma_eye_monitor[5:0]),
					.pld_pma_pcie_switch(pld_pma_pcie_switch[1:0]),
					.pld_pma_ppm_lock(pld_pma_ppm_lock),
					.pld_pma_reserved_out(pld_pma_reserved_out[4:0]),
					.pld_pma_rs_lpbk_b(pld_pma_rs_lpbk_b),
					.pld_pmaif_rxclkslip(pld_pmaif_rxclkslip),
					.pld_polinv_rx	(pld_polinv_rx),
					.pld_rx_prbs_err_clr(pld_rx_prbs_err_clr),
					.pld_syncsm_en	(pld_syncsm_en),
//					.pld_rx_fabric_fifo_align_clr(pld_rx_fabric_fifo_align_clr), // To reg version to avoid glitching
					.pld_rx_fabric_fifo_align_clr(rd_align_clr_reg),
					.rx_reset_async_rx_osc_clk_rst_n(rx_reset_async_rx_osc_clk_rst_n),
					.rx_reset_async_tx_osc_clk_rst_n(rx_reset_async_tx_osc_clk_rst_n),
					.rx_clock_async_rx_osc_clk(rx_clock_async_rx_osc_clk),
					.rx_clock_async_tx_osc_clk(rx_clock_async_tx_osc_clk),
					.rx_async_hssi_fabric_fsr_load(rx_async_hssi_fabric_fsr_load),
					.rx_async_hssi_fabric_ssr_load(rx_async_hssi_fabric_ssr_load),
					.rx_async_hssi_fabric_fsr_data(rx_async_hssi_fabric_fsr_data[1:0]),
					.rx_async_hssi_fabric_ssr_data(rx_async_hssi_fabric_ssr_data[62:0]),
					.rx_async_fabric_hssi_fsr_load(rx_async_fabric_hssi_fsr_load),
					.rx_async_fabric_hssi_ssr_load(rx_async_fabric_hssi_ssr_load),
					.aib_fabric_pld_8g_rxelecidle(aib_fabric_pld_8g_rxelecidle),
					.aib_fabric_pld_pma_rxpll_lock(aib_fabric_pld_pma_rxpll_lock));
hdpldadapt_rxclk_ctl hdpldadapt_rxclk_ctl(/*AUTOINST*/
					  // Outputs
					  .aib_fabric_pld_pma_coreclkin(aib_fabric_pld_pma_coreclkin),
					  .aib_fabric_pld_sclk	(aib_fabric_pld_sclk),
					  .pld_pcs_rx_clk_out1_hioint(pld_pcs_rx_clk_out1_hioint),
					  .pld_pcs_rx_clk_out1_dcm(pld_pcs_rx_clk_out1_dcm),
					  .pld_pcs_rx_clk_out2_hioint(pld_pcs_rx_clk_out2_hioint),
					  .pld_pcs_rx_clk_out2_dcm(pld_pcs_rx_clk_out2_dcm),
					  .pld_pma_internal_clk1_hioint(pld_pma_internal_clk1_hioint),
					  //.pld_pma_internal_clk1_dcm(pld_pma_internal_clk1_dcm),
					  .pld_pma_internal_clk2_hioint(pld_pma_internal_clk2_hioint),
					  //.pld_pma_internal_clk2_dcm(pld_pma_internal_clk2_dcm),
					  .pld_pma_hclk_hioint	(pld_pma_hclk_hioint),
					  //.pld_pma_hclk_dcm	(pld_pma_hclk_dcm),
					  .rx_clock_pld_sclk(rx_clock_pld_sclk),
					  .rx_clock_reset_hrdrst_rx_osc_clk(rx_clock_reset_hrdrst_rx_osc_clk),
					  .rx_clock_reset_fifo_wr_clk(rx_clock_reset_fifo_wr_clk),
					  .rx_clock_reset_fifo_rd_clk(rx_clock_reset_fifo_rd_clk),
					  .rx_clock_fifo_sclk(rx_clock_fifo_sclk),
					  .rx_clock_reset_asn_pma_hclk(rx_clock_reset_asn_pma_hclk),
					  .rx_clock_reset_async_rx_osc_clk(rx_clock_reset_async_rx_osc_clk),
					  .rx_clock_reset_async_tx_osc_clk(rx_clock_reset_async_tx_osc_clk),
					  .rx_clock_pld_pma_hclk(rx_clock_pld_pma_hclk),
					  .rx_clock_fifo_wr_clk_del_sm(rx_clock_fifo_wr_clk_del_sm),
					  .rx_clock_fifo_wr_clk(rx_clock_fifo_wr_clk),     
					  .q1_rx_clock_fifo_wr_clk(q1_rx_clock_fifo_wr_clk),
					  .q2_rx_clock_fifo_wr_clk(q2_rx_clock_fifo_wr_clk), 
					  .q3_rx_clock_fifo_wr_clk(q3_rx_clock_fifo_wr_clk),  
					  .q4_rx_clock_fifo_wr_clk(q4_rx_clock_fifo_wr_clk),   
					  .q5_rx_clock_fifo_wr_clk(q5_rx_clock_fifo_wr_clk),   
					  .q6_rx_clock_fifo_wr_clk(q6_rx_clock_fifo_wr_clk),   
					  .rx_clock_fifo_rd_clk_ins_sm(rx_clock_fifo_rd_clk_ins_sm),
					  .rx_clock_fifo_rd_clk(rx_clock_fifo_rd_clk),          
					  .rx_clock_asn_pma_hclk(rx_clock_asn_pma_hclk),         
					  .rx_clock_hrdrst_rx_osc_clk(rx_clock_hrdrst_rx_osc_clk),
					  .rx_clock_async_rx_osc_clk(rx_clock_async_rx_osc_clk),
					  .rx_clock_async_tx_osc_clk(rx_clock_async_tx_osc_clk),
					  // Inputs
                                                .dft_adpt_aibiobsr_fastclkn(dft_adpt_aibiobsr_fastclkn),
                                                .adapter_scan_mode_n(adapter_scan_mode_n),
                                                .adapter_scan_shift_n(adapter_scan_shift_n),
                                                .adapter_scan_shift_clk(adapter_scan_shift_clk),
                                                .adapter_scan_user_clk0(adapter_scan_user_clk0),         // 125MHz
                                                .adapter_scan_user_clk1(adapter_scan_user_clk1),         // 250MHz
                                                .adapter_scan_user_clk2(adapter_scan_user_clk2),         // 500MHz
                                                .adapter_scan_user_clk3(adapter_scan_user_clk3),         // 1GHz
                                                .adapter_clk_sel_n(adapter_clk_sel_n),
                                                .adapter_occ_enable(adapter_occ_enable),
					  .aib_fabric_rx_transfer_clk(aib_fabric_rx_transfer_clk),
					  .aib_fabric_tx_transfer_clk(aib_fabric_tx_transfer_clk),
					  .aib_fabric_pld_pcs_rx_clk_out(aib_fabric_pld_pcs_rx_clk_out),
					  .aib_fabric_pld_pma_clkdiv_rx_user(aib_fabric_pld_pma_clkdiv_rx_user),
					  .aib_fabric_pld_pma_internal_clk1(aib_fabric_pld_pma_internal_clk1),
					  .aib_fabric_pld_pma_internal_clk2(aib_fabric_pld_pma_internal_clk2),
					  .aib_fabric_pld_pma_hclk(aib_fabric_pld_pma_hclk),
					  .aib_fabric_rx_sr_clk_in(aib_fabric_rx_sr_clk_in),
					  .aib_fabric_tx_sr_clk_in(aib_fabric_tx_sr_clk_in),
					  .pld_pma_coreclkin_rowclk(pld_pma_coreclkin_rowclk),
					  //.pld_pma_coreclkin_dcm(pld_pma_coreclkin_dcm),
					  .pld_rx_clk1_rowclk	(pld_rx_clk1_rowclk),
					  .pld_rx_clk1_dcm	(pld_rx_clk1_dcm),
					  .pld_rx_clk2_rowclk	(pld_rx_clk2_rowclk),
					  //.pld_rx_clk2_dcm	(pld_rx_clk2_dcm),
					  .pld_sclk1_rowclk	(pld_sclk1_rowclk),
					  .pld_sclk2_rowclk	(pld_sclk2_rowclk),
					  .nfrzdrv_in		(nfrzdrv_in),
                                          .pr_channel_freeze_n(pr_channel_freeze_n),
                                          .pld_clk_dft_sel(pld_clk_dft_sel),
					  .tx_clock_fifo_wr_clk(tx_clock_fifo_wr_clk),
					  .tx_clock_fifo_rd_clk(tx_clock_fifo_rd_clk),
					  //.r_rx_coreclkin_sel	(r_rx_coreclkin_sel),
					  .r_rx_aib_clk1_sel	(r_rx_aib_clk1_sel[1:0]),
					  .r_rx_aib_clk2_sel	(r_rx_aib_clk2_sel[1:0]),
					  .r_rx_fifo_wr_clk_sel	(r_rx_fifo_wr_clk_sel),
					  .r_rx_fifo_rd_clk_sel	(r_rx_fifo_rd_clk_sel[1:0]),
					  .r_rx_pld_clk1_sel	(r_rx_pld_clk1_sel),
					  //.r_rx_pld_clk2_sel	(r_rx_pld_clk2_sel),
					  .r_rx_sclk_sel	(r_rx_sclk_sel),
					  .r_rx_internal_clk1_sel1(r_rx_internal_clk1_sel1),
					  .r_rx_internal_clk1_sel2(r_rx_internal_clk1_sel2),
					  .r_rx_txfiford_post_ct_sel(r_rx_txfiford_post_ct_sel),
					  .r_rx_txfifowr_post_ct_sel(r_rx_txfifowr_post_ct_sel),
					  .r_rx_internal_clk2_sel1(r_rx_internal_clk2_sel1),
					  .r_rx_internal_clk2_sel2(r_rx_internal_clk2_sel2),
					  .r_rx_rxfifowr_post_ct_sel(r_rx_rxfifowr_post_ct_sel),
					  .r_rx_rxfiford_post_ct_sel(r_rx_rxfiford_post_ct_sel),
					  .r_rx_fifo_wr_clk_scg_en(r_rx_fifo_wr_clk_scg_en),
					  .r_rx_fifo_rd_clk_scg_en(r_rx_fifo_rd_clk_scg_en),
					  .r_rx_pma_hclk_scg_en	(r_rx_pma_hclk_scg_en),
					  .r_rx_hrdrst_rx_osc_clk_scg_en(r_rx_hrdrst_rx_osc_clk_scg_en),
					  .r_rx_osc_clk_scg_en(r_rx_osc_clk_scg_en),
					  .r_rx_fifo_wr_clk_del_sm_scg_en(r_rx_fifo_wr_clk_del_sm_scg_en),
					  .r_rx_fifo_rd_clk_ins_sm_scg_en(r_rx_fifo_rd_clk_ins_sm_scg_en),
					  .r_rx_fifo_power_mode(r_rx_fifo_power_mode[2:0]),
					  .r_rx_pld_clk1_delay_en(r_rx_pld_clk1_delay_en),
					  .r_rx_pld_clk1_delay_sel(r_rx_pld_clk1_delay_sel[3:0]),
					  .r_rx_pld_clk1_inv_en(r_rx_pld_clk1_inv_en),
					  .rx_reset_pld_pma_hclk_rst_n(rx_reset_pld_pma_hclk_rst_n));

hdpldadapt_rxrst_ctl hdpldadapt_rxrst_ctl(/*AUTOINST*/
					  // Outputs
					  .aib_fabric_pcs_rx_pld_rst_n(aib_fabric_pcs_rx_pld_rst_n),
					  .aib_fabric_adapter_rx_pld_rst_n(aib_fabric_adapter_rx_pld_rst_n),
					  .aib_fabric_pld_pma_rxpma_rstb(aib_fabric_pld_pma_rxpma_rstb),
					  .aib_fabric_rx_dll_lock_req(aib_fabric_rx_dll_lock_req),
					  .bond_rx_hrdrst_ds_out_fabric_rx_dll_lock(bond_rx_hrdrst_ds_out_fabric_rx_dll_lock),
					  .bond_rx_hrdrst_us_out_fabric_rx_dll_lock(bond_rx_hrdrst_us_out_fabric_rx_dll_lock),
					  .bond_rx_hrdrst_ds_out_fabric_rx_dll_lock_req(bond_rx_hrdrst_ds_out_fabric_rx_dll_lock_req),
					  .bond_rx_hrdrst_us_out_fabric_rx_dll_lock_req(bond_rx_hrdrst_us_out_fabric_rx_dll_lock_req),
					  .pld_hssi_rx_transfer_en(pld_hssi_rx_transfer_en),
					  .pld_aib_fabric_rx_dll_lock(pld_aib_fabric_rx_dll_lock),
					  .pld_hssi_asn_dll_lock_en(pld_hssi_asn_dll_lock_en),
					  .rx_hrdrst_rx_fifo_srst(rx_hrdrst_rx_fifo_srst),
					  .rx_hrdrst_fabric_rx_dll_lock(rx_hrdrst_fabric_rx_dll_lock),
					  .rx_hrdrst_fabric_rx_transfer_en(rx_hrdrst_fabric_rx_transfer_en),
					  .rx_hrdrst_asn_data_transfer_en(rx_hrdrst_asn_data_transfer_en),
					  .rx_hrdrst_testbus(rx_hrdrst_testbus),
					  .rx_reset_fifo_wr_rst_n(rx_reset_fifo_wr_rst_n),
					  .rx_reset_fifo_rd_rst_n(rx_reset_fifo_rd_rst_n),
					  .rx_reset_fifo_sclk_rst_n(rx_reset_fifo_sclk_rst_n),
					  .rx_reset_pld_pma_hclk_rst_n(rx_reset_pld_pma_hclk_rst_n),
					  .rx_reset_asn_pma_hclk_rst_n(rx_reset_asn_pma_hclk_rst_n),
					  .rx_reset_async_rx_osc_clk_rst_n(rx_reset_async_rx_osc_clk_rst_n),
					  .rx_reset_async_tx_osc_clk_rst_n(rx_reset_async_tx_osc_clk_rst_n),
					  // Inputs
                                          .adapter_scan_rst_n(adapter_scan_rst_n),
                                          .adapter_scan_mode_n(adapter_scan_mode_n),
					  .csr_rdy_dly_in	(csr_rdy_dly_in),
					  .nfrzdrv_in	(nfrzdrv_in),
					  .pr_channel_freeze_n(pr_channel_freeze_n),
					  .usermode_in	(usermode_in),
					  .pld_pcs_rx_pld_rst_n	(pld_pcs_rx_pld_rst_n),
					  .pld_adapter_rx_pld_rst_n(pld_adapter_rx_pld_rst_n),
					  .pld_pma_rxpma_rstb	(pld_pma_rxpma_rstb),
					  .pld_aib_fabric_rx_dll_lock_req(pld_aib_fabric_rx_dll_lock_req),
					  .pld_fabric_rx_fifo_srst(pld_fabric_rx_fifo_srst), 
					  .aib_fabric_rx_dll_lock(aib_fabric_rx_dll_lock),
					  .bond_rx_hrdrst_ds_in_fabric_rx_dll_lock(bond_rx_hrdrst_ds_in_fabric_rx_dll_lock),
					  .bond_rx_hrdrst_us_in_fabric_rx_dll_lock(bond_rx_hrdrst_us_in_fabric_rx_dll_lock),
					  .bond_rx_hrdrst_ds_in_fabric_rx_dll_lock_req(bond_rx_hrdrst_ds_in_fabric_rx_dll_lock_req),
					  .bond_rx_hrdrst_us_in_fabric_rx_dll_lock_req(bond_rx_hrdrst_us_in_fabric_rx_dll_lock_req),
					  .avmm_hrdrst_fabric_osc_transfer_en(avmm_hrdrst_fabric_osc_transfer_en),
					  .sr_hssi_rx_dcd_cal_done(sr_hssi_rx_dcd_cal_done),
					  .sr_hssi_rx_transfer_en(sr_hssi_rx_transfer_en),
					  .tx_hrdrst_fabric_tx_transfer_en(tx_hrdrst_fabric_tx_transfer_en),
					  .rx_fabric_align_done(rx_fabric_align_done_raw),
					  .rx_asn_rate_change_in_progress(rx_asn_rate_change_in_progress),
					  .rx_asn_dll_lock_en(rx_asn_dll_lock_en),
					  .rx_asn_fifo_hold(rx_asn_fifo_hold),
					  .rx_fifo_ready(rx_fifo_ready),
					  .r_rx_free_run_div_clk(r_rx_free_run_div_clk),
					  .r_rx_hrdrst_rst_sm_dis(r_rx_hrdrst_rst_sm_dis),
					  .r_rx_hrdrst_dll_lock_bypass(r_rx_hrdrst_dll_lock_bypass),
					  .r_rx_hrdrst_align_bypass(r_rx_hrdrst_align_bypass),
					  .r_rx_hrdrst_user_ctl_en(r_rx_hrdrst_user_ctl_en),
					  .r_rx_master_sel(r_rx_compin_sel[1:0]),
					  .r_rx_dist_master_sel(r_rx_ds_master),
					  .r_rx_ds_last_chnl(r_rx_ds_last_chnl),
					  .r_rx_us_last_chnl(r_rx_us_last_chnl),
					  .r_rx_bonding_dft_in_en(r_rx_bonding_dft_in_en),
					  .r_rx_bonding_dft_in_value(r_rx_bonding_dft_in_value),
					  .rx_clock_reset_hrdrst_rx_osc_clk(rx_clock_reset_hrdrst_rx_osc_clk),
					  .rx_clock_reset_fifo_wr_clk(rx_clock_reset_fifo_wr_clk),
					  .rx_clock_reset_fifo_rd_clk(rx_clock_reset_fifo_rd_clk),
					  .rx_clock_fifo_sclk(rx_clock_fifo_sclk),
					  .rx_clock_reset_asn_pma_hclk(rx_clock_reset_asn_pma_hclk),
					  .rx_clock_reset_async_rx_osc_clk(rx_clock_reset_async_rx_osc_clk),
					  .rx_clock_reset_async_tx_osc_clk(rx_clock_reset_async_tx_osc_clk),
					  .rx_clock_pld_pma_hclk(rx_clock_pld_pma_hclk),
					  .rx_clock_hrdrst_rx_osc_clk(rx_clock_hrdrst_rx_osc_clk));


// Status Register
   cfg_dprio_shadow_status_regs 
     #(
       .DATA_WIDTH        (8),
       .CLK_FREQ_MHZ      (1000),      // Clock freq in MHz
       .TOGGLE_TYPE (3),
       .VID (1)
       )
       cfg_dprio_shadow_status_regs0
         (
          .rst_n          (rx_reset_fifo_rd_rst_n),  // reset
          .clk            (rx_clock_fifo_rd_clk),  // clock
          .stat_data_in   ({3'b000,wa_error_cnt, wa_error}),  // status data input
          .write_en       (rx_chnl_dprio_status_write_en),  // write data enable from DPRIO
          .write_en_ack   (rx_chnl_dprio_status_write_en_ack),  // write data enable acknowlege to DPRIO
          .stat_data_out  (rx_chnl_dprio_status)   // status data output
          );

// Testbus
// Testbus
hdpldadapt_rx_chnl_testbus hdpldadapt_rx_chnl_testbus (
	.r_rx_datapath_tb_sel	(r_rx_datapath_tb_sel),
	.rx_fifo_testbus1	(rx_fifo_testbus1),
	.rx_fifo_testbus2 	(rx_fifo_testbus2), 
        .rx_cp_bond_testbus	(rx_cp_bond_testbus),
	.rx_hrdrst_testbus 	(rx_hrdrst_testbus), 
	.rx_asn_testbus		(rx_asn_testbus),
	.word_align_testbus	(word_align_testbus),
	.deletion_sm_testbus		(deletion_sm_testbus),
	.insertion_sm_testbus		(insertion_sm_testbus),
	.tx_chnl_testbus	(tx_chnl_testbus),
	.avmm_testbus		(avmm_testbus),
	.sr_testbus		(sr_testbus_int),
	.sr_test_data		(sr_test_data),
	.sr_parity_error_flag   (sr_parity_error_flag),
	.rx_chnl_testbus	(rx_chnl_testbus)	// Go to async block for frz logic
	);

endmodule


