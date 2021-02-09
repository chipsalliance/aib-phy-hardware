// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module hdpldadapt_tx_chnl(/*AUTOARG*/
   // Outputs
   hip_fsr_parity_checker_in, hip_ssr_parity_checker_in, 
   tx_fsr_parity_checker_in, tx_ssr_parity_checker_in,
   tx_async_fabric_hssi_ssr_data, tx_async_fabric_hssi_fsr_data,
   rx_fsr_mask_tx_pll, pld_tx_hssi_fifo_full, pld_tx_hssi_fifo_empty,
   pld_tx_hssi_align_done, pld_tx_fabric_fifo_pfull,
   pld_tx_fabric_fifo_pempty, pld_tx_fabric_fifo_latency_pulse,
   pld_tx_fabric_fifo_full, pld_tx_fabric_fifo_empty,
   pld_pmaif_mask_tx_pll,
   pld_pma_fpll_phase_done, pld_pma_fpll_clksel, pld_pma_fpll_clk1bad,
   pld_pma_fpll_clk0bad, pld_pcs_tx_clk_out2_hioint,
   pld_pcs_tx_clk_out2_dcm, pld_pcs_tx_clk_out1_hioint,
   pld_pcs_tx_clk_out1_dcm, pld_fpll_shared_direct_async_out,
   pld_fpll_shared_direct_async_out_hioint, pld_fpll_shared_direct_async_out_dcm,
   pld_10g_tx_wordslip_exe, pld_10g_tx_burst_en_exe,
   pld_10g_krfec_tx_frame, hip_aib_ssr_out, hip_aib_fsr_out, pld_krfec_tx_alignment,
   hip_aib_async_ssr_in, hip_aib_async_fsr_in,
   bond_tx_fifo_us_out_wren, bond_tx_fifo_us_out_rden,
   bond_tx_fifo_us_out_dv, bond_tx_fifo_ds_out_wren,
   bond_tx_fifo_ds_out_rden, bond_tx_fifo_ds_out_dv,
   bond_tx_hrdrst_ds_out_fabric_tx_dcd_cal_done,
   bond_tx_hrdrst_us_out_fabric_tx_dcd_cal_done,
   bond_tx_hrdrst_ds_out_fabric_tx_dcd_cal_req,
   bond_tx_hrdrst_us_out_fabric_tx_dcd_cal_req,
   avmm_hrdrst_fabric_osc_transfer_en,
   tx_hrdrst_fabric_tx_transfer_en,
   aib_fabric_tx_dcd_cal_req,
   aib_fabric_tx_transfer_clk, aib_fabric_tx_data_out,
   aib_fabric_pld_pma_txpma_rstb, aib_fabric_pld_pma_txdetectrx,
   aib_fabric_pcs_tx_pld_rst_n,
   aib_fabric_fpll_shared_direct_async_out,
   aib_fabric_adapter_tx_pld_rst_n, tx_chnl_dprio_status,
   tx_chnl_dprio_status_write_en_ack,
   pld_tx_hssi_fifo_latency_pulse,
   pld_tx_fifo_ready,
   rx_pld_rate,
   tx_clock_fifo_rd_clk,tx_clock_fifo_wr_clk,
   pld_aib_fabric_tx_dcd_cal_done,
   pld_fabric_tx_transfer_en, pld_tx_ssr_reserved_out, tx_async_fabric_hssi_ssr_reserved, 
   // Inputs
// new inputs for ECO8
r_tx_wren_fastbond,
r_tx_rden_fastbond,                          
   r_tx_hip_aib_ssr_in_polling_bypass, r_tx_usertest_sel,
   r_tx_pld_8g_tx_boundary_sel_polling_bypass,
   r_tx_pld_10g_tx_bitslip_polling_bypass,
   r_tx_pld_pma_fpll_cnt_sel_polling_bypass,
   r_tx_pld_pma_fpll_num_phase_shifts_polling_bypass,
   dft_adpt_aibiobsr_fastclkn,
   adapter_scan_rst_n, adapter_scan_mode_n,
   adapter_scan_shift_n, adapter_scan_shift_clk,
   adapter_scan_user_clk0, adapter_scan_user_clk1, adapter_scan_user_clk2, adapter_scan_user_clk3,
   adapter_clk_sel_n, adapter_occ_enable,
   pld_clk_dft_sel,
   tx_async_hssi_fabric_ssr_load, tx_async_hssi_fabric_ssr_data,
   tx_async_hssi_fabric_fsr_load, tx_async_hssi_fabric_fsr_data,
   tx_async_fabric_hssi_ssr_load, tx_async_fabric_hssi_fsr_load,
   rx_asn_rate_change_in_progress, rx_asn_dll_lock_en,
   //rx_asn_gen3_sel, //rx_asn_fifo_srst, 
   r_tx_wordslip, r_tx_wm_en,
   r_tx_us_master, r_tx_us_bypass_pipeln, r_tx_fifo_power_mode,
   r_tx_stop_write, r_tx_stop_read, r_tx_sh_err,
   r_tx_osc_clk_scg_en, r_tx_pyld_ins, r_tx_pld_clk2_sel,
   r_tx_pld_clk1_sel, r_tx_pipeln_frmgen, r_tx_phcomp_rd_delay,
   r_tx_mfrm_length, r_tx_indv, r_tx_gb_odwidth, r_tx_gb_idwidth,
   r_tx_gb_dv_en, r_tx_fpll_shared_direct_async_in_sel,
   //r_tx_fifo_wr_clk_sel, 
   r_tx_fifo_rd_clk_frm_gen_scg_en,
   r_tx_fifo_wr_clk_scg_en,
   r_tx_fifo_rd_clk_sel, r_tx_fifo_rd_clk_scg_en, r_tx_fifo_pfull,
   r_tx_fifo_pempty, r_tx_fifo_mode, r_tx_fifo_full, r_tx_fifo_empty,
   r_tx_dv_indv, r_tx_ds_master, r_tx_ds_bypass_pipeln,
   r_tx_double_write, r_tx_compin_sel, r_tx_comp_cnt,
   r_tx_bypass_frmgen, r_tx_burst_en, r_tx_bonding_dft_in_value,
   r_tx_bonding_dft_in_en, r_tx_async_pld_txelecidle_rst_val,
   r_tx_async_pld_pmaif_mask_tx_pll_rst_val,
   r_tx_async_hip_aib_fsr_out_bit3_rst_val,
   r_tx_async_hip_aib_fsr_out_bit2_rst_val,
   r_tx_async_hip_aib_fsr_out_bit1_rst_val,
   r_tx_async_hip_aib_fsr_out_bit0_rst_val,
   r_tx_async_hip_aib_fsr_in_bit3_rst_val,
   r_tx_async_hip_aib_fsr_in_bit2_rst_val,
   r_tx_async_hip_aib_fsr_in_bit1_rst_val,
   r_tx_async_hip_aib_fsr_in_bit0_rst_val, r_tx_aib_clk2_sel,
   r_tx_aib_clk1_sel, pld_txelecidle, pld_tx_fabric_data_in,
   pld_pma_tx_qpi_pulldn,
   pld_pma_tx_qpi_pullup,
   pld_pma_rx_qpi_pullup,
   pld_tx_clk2_rowclk, pld_tx_clk2_dcm, pld_tx_clk1_rowclk,
   pld_tx_clk1_dcm, pld_polinv_tx, pld_pma_txpma_rstb,
   pld_pma_txdetectrx, pld_pma_tx_bitslip, pld_pma_nrpi_freeze,
   pld_pma_fpll_up_dn_lc_lf_rstn, pld_pma_fpll_pfden,
   pld_pma_fpll_num_phase_shifts, pld_pma_fpll_lc_csr_test_dis,
   pld_pma_fpll_extswitch, pld_pma_fpll_cnt_sel, pld_pma_csr_test_dis,
   pld_pcs_tx_pld_rst_n, pld_fpll_shared_direct_async_in,
   pld_fpll_shared_direct_async_in_rowclk, pld_fpll_shared_direct_async_in_dcm,
   pld_adapter_tx_pld_rst_n, pld_8g_tx_boundary_sel,
   pld_10g_tx_wordslip, pld_10g_tx_diag_status, pld_10g_tx_burst_en,
   pld_10g_tx_bitslip, nfrzdrv_in, hip_aib_ssr_in, hip_aib_fsr_in, pr_channel_freeze_n,
   hip_aib_async_ssr_out, hip_aib_async_fsr_out, csr_rdy_dly_in, usermode_in,
   bond_tx_fifo_us_in_wren, bond_tx_fifo_us_in_rden,
   bond_tx_fifo_us_in_dv, bond_tx_fifo_ds_in_wren,
   bond_tx_fifo_ds_in_rden, bond_tx_fifo_ds_in_dv,
   bond_tx_hrdrst_ds_in_fabric_tx_dcd_cal_done,
   bond_tx_hrdrst_us_in_fabric_tx_dcd_cal_done,
   bond_tx_hrdrst_ds_in_fabric_tx_dcd_cal_req,
   bond_tx_hrdrst_us_in_fabric_tx_dcd_cal_req,
   aib_fabric_tx_sr_clk_in, aib_fabric_rx_sr_clk_in,
   aib_fabric_pma_aib_tx_clk, rx_clock_pld_sclk,
   aib_fabric_pld_pma_clkdiv_tx_user,
   aib_fabric_pld_pcs_tx_clk_out,
   aib_fabric_fpll_shared_direct_async_in,
   aib_fabric_tx_dcd_cal_done,
   tx_chnl_dprio_status_write_en, pld_tx_dll_lock_req,
   r_tx_hrdrst_rx_osc_clk_scg_en, r_tx_hip_osc_clk_scg_en,
   r_tx_hrdrst_rst_sm_dis, r_tx_hrdrst_dcd_cal_done_bypass, r_tx_hrdrst_user_ctl_en,
   r_tx_pld_clk1_delay_en, r_tx_pld_clk1_delay_sel, r_tx_pld_clk1_inv_en,
//   r_tx_hrdrst_master_sel, r_tx_hrdrst_dist_master_sel, 
   r_tx_ds_last_chnl, r_tx_us_last_chnl,
   r_tx_stretch_num_stages,
   r_tx_datapath_tb_sel, 
   r_tx_wr_adj_en, 
   r_tx_rd_adj_en, pld_tx_ssr_reserved_in, tx_async_hssi_fabric_ssr_reserved,       
   aib_fabric_pld_tx_hssi_fifo_latency_pulse,
   pld_aib_fabric_tx_dcd_cal_req,
   pld_tx_fifo_latency_adj_en,  pld_aib_hssi_tx_dcd_cal_req, pld_aib_hssi_tx_dll_lock_req,
   aib_fabric_tx_data_lpbk, pld_aib_hssi_tx_dcd_cal_done, pld_aib_hssi_tx_dll_lock,
   pld_fabric_tx_fifo_srst,
   tx_chnl_testbus,
   rx_asn_fifo_hold
   );

/*AUTOINPUT*/
// Beginning of automatic inputs (from unused autoinst inputs)
   
// new inputs for ECO8
    input  wire [1:0]  r_tx_wren_fastbond;
    input  wire [1:0]  r_tx_rden_fastbond;
   
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
input                   pld_tx_dll_lock_req;
input [4:0]		aib_fabric_fpll_shared_direct_async_in;// To hdpldadapt_tx_async of hdpldadapt_tx_async.v, ...
input			aib_fabric_pld_pcs_tx_clk_out;// To hdpldadapt_txclk_ctl of hdpldadapt_txclk_ctl.v
input			aib_fabric_pld_pma_clkdiv_tx_user;// To hdpldadapt_txclk_ctl of hdpldadapt_txclk_ctl.v
input			rx_clock_pld_sclk;	// To hdpldadapt_txclk_ctl of hdpldadapt_txclk_ctl.v
input			aib_fabric_pma_aib_tx_clk;// To hdpldadapt_txclk_ctl of hdpldadapt_txclk_ctl.v
input			aib_fabric_rx_sr_clk_in;// To hdpldadapt_txclk_ctl of hdpldadapt_txclk_ctl.v
input			aib_fabric_tx_sr_clk_in;// To hdpldadapt_txclk_ctl of hdpldadapt_txclk_ctl.v
input			aib_fabric_tx_dcd_cal_done;
input    		aib_fabric_pld_tx_hssi_fifo_latency_pulse;
input			avmm_hrdrst_fabric_osc_transfer_en;
input			bond_tx_fifo_ds_in_dv;	// To hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
input			bond_tx_fifo_ds_in_rden;// To hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
input			bond_tx_fifo_ds_in_wren;// To hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
input			bond_tx_fifo_us_in_dv;	// To hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
input			bond_tx_fifo_us_in_rden;// To hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
input			bond_tx_fifo_us_in_wren;// To hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
input                   bond_tx_hrdrst_ds_in_fabric_tx_dcd_cal_done;
input                   bond_tx_hrdrst_us_in_fabric_tx_dcd_cal_done;
input                   bond_tx_hrdrst_ds_in_fabric_tx_dcd_cal_req;
input                   bond_tx_hrdrst_us_in_fabric_tx_dcd_cal_req;
input			csr_rdy_dly_in;		// To hdpldadapt_txrst_ctl of hdpldadapt_txrst_ctl.v
input			usermode_in;
input [3:0]		hip_aib_async_fsr_out;	// To hdpldadapt_tx_async of hdpldadapt_tx_async.v
input [7:0]		hip_aib_async_ssr_out;	// To hdpldadapt_tx_async of hdpldadapt_tx_async.v
input [3:0]		hip_aib_fsr_in;		// To hdpldadapt_tx_async of hdpldadapt_tx_async.v
input [39:0]		hip_aib_ssr_in;		// To hdpldadapt_tx_async of hdpldadapt_tx_async.v
input			nfrzdrv_in;		// To hdpldadapt_txclk_ctl of hdpldadapt_txclk_ctl.v, ...
input                   pr_channel_freeze_n;
input [6:0]		pld_10g_tx_bitslip;	// To hdpldadapt_tx_async of hdpldadapt_tx_async.v
input			pld_10g_tx_burst_en;	// To hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
input [1:0]		pld_10g_tx_diag_status;	// To hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
input			pld_10g_tx_wordslip;	// To hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
input [4:0]		pld_8g_tx_boundary_sel;	// To hdpldadapt_tx_async of hdpldadapt_tx_async.v
input			pld_adapter_tx_pld_rst_n;// To hdpldadapt_txrst_ctl of hdpldadapt_txrst_ctl.v
input [1:0]		pld_fpll_shared_direct_async_in;// To hdpldadapt_txclk_ctl of hdpldadapt_txclk_ctl.v, ...
input			pld_fpll_shared_direct_async_in_rowclk;// To hdpldadapt_txclk_ctl of hdpldadapt_txclk_ctl.v, ...
input			pld_fpll_shared_direct_async_in_dcm;
input			pld_pcs_tx_pld_rst_n;	// To hdpldadapt_txrst_ctl of hdpldadapt_txrst_ctl.v
input			pld_pma_csr_test_dis;	// To hdpldadapt_tx_async of hdpldadapt_tx_async.v
input [3:0]		pld_pma_fpll_cnt_sel;	// To hdpldadapt_tx_async of hdpldadapt_tx_async.v
input			pld_pma_fpll_extswitch;	// To hdpldadapt_tx_async of hdpldadapt_tx_async.v
input			pld_pma_fpll_lc_csr_test_dis;// To hdpldadapt_tx_async of hdpldadapt_tx_async.v
input [2:0]		pld_pma_fpll_num_phase_shifts;// To hdpldadapt_tx_async of hdpldadapt_tx_async.v
input			pld_pma_fpll_pfden;	// To hdpldadapt_tx_async of hdpldadapt_tx_async.v
input			pld_pma_fpll_up_dn_lc_lf_rstn;// To hdpldadapt_tx_async of hdpldadapt_tx_async.v
input			pld_pma_nrpi_freeze;	// To hdpldadapt_tx_async of hdpldadapt_tx_async.v
input			pld_pma_tx_bitslip;	// To hdpldadapt_tx_async of hdpldadapt_tx_async.v
input			pld_pma_txdetectrx;	// To hdpldadapt_tx_async of hdpldadapt_tx_async.v
input			pld_pma_txpma_rstb;	// To hdpldadapt_txrst_ctl of hdpldadapt_txrst_ctl.v
input			pld_polinv_tx;		// To hdpldadapt_tx_async of hdpldadapt_tx_async.v
input			pld_tx_clk1_dcm;	// To hdpldadapt_txclk_ctl of hdpldadapt_txclk_ctl.v
input			pld_tx_clk1_rowclk;	// To hdpldadapt_txclk_ctl of hdpldadapt_txclk_ctl.v
input			pld_tx_clk2_dcm;	// To hdpldadapt_txclk_ctl of hdpldadapt_txclk_ctl.v
input			pld_tx_clk2_rowclk;	// To hdpldadapt_txclk_ctl of hdpldadapt_txclk_ctl.v
input [79:0]		pld_tx_fabric_data_in;	// To hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
input			pld_txelecidle;		// To hdpldadapt_tx_async of hdpldadapt_tx_async.v
input		        pld_tx_fifo_latency_adj_en;
input                   pld_aib_hssi_tx_dcd_cal_req;
input                   pld_aib_hssi_tx_dll_lock_req;
input			pld_aib_fabric_tx_dcd_cal_req;
input			pld_fabric_tx_fifo_srst;
input [3:0]             r_tx_hip_aib_ssr_in_polling_bypass;
input                   r_tx_pld_8g_tx_boundary_sel_polling_bypass;
input                   r_tx_usertest_sel;
input                   r_tx_pld_10g_tx_bitslip_polling_bypass;
input                   r_tx_pld_pma_fpll_cnt_sel_polling_bypass;
input                   r_tx_pld_pma_fpll_num_phase_shifts_polling_bypass;
input [1:0]		r_tx_aib_clk1_sel;	// To hdpldadapt_txclk_ctl of hdpldadapt_txclk_ctl.v
input [1:0]		r_tx_aib_clk2_sel;	// To hdpldadapt_txclk_ctl of hdpldadapt_txclk_ctl.v
input			r_tx_async_hip_aib_fsr_in_bit0_rst_val;// To hdpldadapt_tx_async of hdpldadapt_tx_async.v
input			r_tx_async_hip_aib_fsr_in_bit1_rst_val;// To hdpldadapt_tx_async of hdpldadapt_tx_async.v
input			r_tx_async_hip_aib_fsr_in_bit2_rst_val;// To hdpldadapt_tx_async of hdpldadapt_tx_async.v
input			r_tx_async_hip_aib_fsr_in_bit3_rst_val;// To hdpldadapt_tx_async of hdpldadapt_tx_async.v
input			r_tx_async_hip_aib_fsr_out_bit0_rst_val;// To hdpldadapt_tx_async of hdpldadapt_tx_async.v
input			r_tx_async_hip_aib_fsr_out_bit1_rst_val;// To hdpldadapt_tx_async of hdpldadapt_tx_async.v
input			r_tx_async_hip_aib_fsr_out_bit2_rst_val;// To hdpldadapt_tx_async of hdpldadapt_tx_async.v
input			r_tx_async_hip_aib_fsr_out_bit3_rst_val;// To hdpldadapt_tx_async of hdpldadapt_tx_async.v
input			r_tx_async_pld_pmaif_mask_tx_pll_rst_val;// To hdpldadapt_tx_async of hdpldadapt_tx_async.v
input			r_tx_async_pld_txelecidle_rst_val;// To hdpldadapt_tx_async of hdpldadapt_tx_async.v
input			r_tx_bonding_dft_in_en;	// To hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
input			r_tx_bonding_dft_in_value;// To hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
input			r_tx_burst_en;		// To hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
input			r_tx_bypass_frmgen;	// To hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
input [7:0]		r_tx_comp_cnt;		// To hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
input [1:0]		r_tx_compin_sel;	// To hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
input			r_tx_double_write;	// To hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
input			r_tx_ds_bypass_pipeln;	// To hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
input			r_tx_ds_master;		// To hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
input			r_tx_dv_indv;		// To hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
input [4:0]		r_tx_fifo_empty;	// To hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
input [4:0]		r_tx_fifo_full;		// To hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
input [2:0]		r_tx_fifo_mode;		// To hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
input [4:0]		r_tx_fifo_pempty;	// To hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
input [4:0]		r_tx_fifo_pfull;	// To hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
input			r_tx_fifo_rd_clk_frm_gen_scg_en;
input			r_tx_fifo_rd_clk_scg_en;// To hdpldadapt_txclk_ctl of hdpldadapt_txclk_ctl.v
input [1:0]		r_tx_fifo_rd_clk_sel;	// To hdpldadapt_txclk_ctl of hdpldadapt_txclk_ctl.v
input			r_tx_fifo_wr_clk_scg_en;// To hdpldadapt_txclk_ctl of hdpldadapt_txclk_ctl.v
//input			r_tx_fifo_wr_clk_sel;	// To hdpldadapt_txclk_ctl of hdpldadapt_txclk_ctl.v
input			r_tx_fpll_shared_direct_async_in_sel;
input			r_tx_gb_dv_en;		// To hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
input [2:0]		r_tx_gb_idwidth;	// To hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
input [1:0]		r_tx_gb_odwidth;	// To hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
input			r_tx_indv;		// To hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
input [15:0]		r_tx_mfrm_length;	// To hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
input [2:0]		r_tx_phcomp_rd_delay;	// To hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
input			r_tx_pipeln_frmgen;	// To hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
input			r_tx_pld_clk1_sel;	// To hdpldadapt_txclk_ctl of hdpldadapt_txclk_ctl.v
input			r_tx_pld_clk2_sel;	// To hdpldadapt_txclk_ctl of hdpldadapt_txclk_ctl.v
input			r_tx_pyld_ins;		// To hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
input			r_tx_osc_clk_scg_en;	// To hdpldadapt_txclk_ctl of hdpldadapt_txclk_ctl.v
input			r_tx_sh_err;		// To hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
input			r_tx_stop_read;		// To hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
input			r_tx_stop_write;	// To hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
input			r_tx_us_bypass_pipeln;	// To hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
input			r_tx_us_master;		// To hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
input			r_tx_wm_en;		// To hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
input			r_tx_wordslip;		// To hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
//input			rx_asn_fifo_srst;	// To hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
input			rx_asn_rate_change_in_progress;
input			rx_asn_dll_lock_en;
//input			rx_asn_gen3_sel;	// To hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
input			tx_async_fabric_hssi_fsr_load;// To hdpldadapt_tx_async of hdpldadapt_tx_async.v
input			tx_async_fabric_hssi_ssr_load;// To hdpldadapt_tx_async of hdpldadapt_tx_async.v
input			tx_async_hssi_fabric_fsr_data;// To hdpldadapt_tx_async of hdpldadapt_tx_async.v
input			tx_async_hssi_fabric_fsr_load;// To hdpldadapt_tx_async of hdpldadapt_tx_async.v
input [12:0]		tx_async_hssi_fabric_ssr_data;// To hdpldadapt_tx_async of hdpldadapt_tx_async.v
input			tx_async_hssi_fabric_ssr_load;// To hdpldadapt_tx_async of hdpldadapt_tx_async.v
input                   r_tx_hrdrst_rst_sm_dis;
input                   r_tx_hrdrst_dcd_cal_done_bypass;
input			r_tx_hrdrst_user_ctl_en;
//input [1:0]      	r_tx_hrdrst_master_sel;
//input                   r_tx_hrdrst_dist_master_sel;
input                   r_tx_ds_last_chnl;
input                   r_tx_us_last_chnl;
input                   r_tx_hrdrst_rx_osc_clk_scg_en;
input			r_tx_hip_osc_clk_scg_en;
input			r_tx_pld_clk1_delay_en;
input [3:0]		r_tx_pld_clk1_delay_sel;
input			r_tx_pld_clk1_inv_en;
input  [2:0]	        r_tx_fifo_power_mode;
input  [2:0]	        r_tx_stretch_num_stages; 
input  [2:0]	        r_tx_datapath_tb_sel;
input  		        r_tx_wr_adj_en;
input                   r_tx_rd_adj_en;
input  [2:0]            pld_tx_ssr_reserved_in;
input  [2:0]            tx_async_hssi_fabric_ssr_reserved;
input                   pld_pma_tx_qpi_pulldn;
input                   pld_pma_tx_qpi_pullup;
input                   pld_pma_rx_qpi_pullup;
input			rx_asn_fifo_hold;

// End of automatics
/*AUTOOUTPUT*/
// Beginning of automatic outputs (from unused autoinst outputs)
output			aib_fabric_adapter_tx_pld_rst_n;// From hdpldadapt_txrst_ctl of hdpldadapt_txrst_ctl.v
output [2:0]		aib_fabric_fpll_shared_direct_async_out;// From hdpldadapt_txclk_ctl of hdpldadapt_txclk_ctl.v, ...
output			aib_fabric_pcs_tx_pld_rst_n;// From hdpldadapt_txrst_ctl of hdpldadapt_txrst_ctl.v
output			aib_fabric_pld_pma_txdetectrx;// From hdpldadapt_tx_async of hdpldadapt_tx_async.v
output			aib_fabric_pld_pma_txpma_rstb;// From hdpldadapt_txrst_ctl of hdpldadapt_txrst_ctl.v
output [39:0]		aib_fabric_tx_data_out;	// From hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
output [39:0]		aib_fabric_tx_data_lpbk;
output			aib_fabric_tx_transfer_clk;// From hdpldadapt_txclk_ctl of hdpldadapt_txclk_ctl.v
output			aib_fabric_tx_dcd_cal_req;
output			tx_hrdrst_fabric_tx_transfer_en;
output			bond_tx_fifo_ds_out_dv;	// From hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
output			bond_tx_fifo_ds_out_rden;// From hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
output			bond_tx_fifo_ds_out_wren;// From hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
output			bond_tx_fifo_us_out_dv;	// From hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
output			bond_tx_fifo_us_out_rden;// From hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
output			bond_tx_fifo_us_out_wren;// From hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
output                  bond_tx_hrdrst_ds_out_fabric_tx_dcd_cal_done;
output                  bond_tx_hrdrst_us_out_fabric_tx_dcd_cal_done;
output                  bond_tx_hrdrst_ds_out_fabric_tx_dcd_cal_req;
output                  bond_tx_hrdrst_us_out_fabric_tx_dcd_cal_req;
output [3:0]		hip_aib_async_fsr_in;	// From hdpldadapt_tx_async of hdpldadapt_tx_async.v
output [39:0]		hip_aib_async_ssr_in;	// From hdpldadapt_tx_async of hdpldadapt_tx_async.v
output [3:0]		hip_aib_fsr_out;	// From hdpldadapt_tx_async of hdpldadapt_tx_async.v
output [7:0]		hip_aib_ssr_out;	// From hdpldadapt_tx_async of hdpldadapt_tx_async.v
output			pld_10g_krfec_tx_frame;	// From hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v, ...
output			pld_krfec_tx_alignment;	// From hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v, ...
output			pld_10g_tx_burst_en_exe;// From hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
output			pld_10g_tx_wordslip_exe;// From hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
output			pld_fpll_shared_direct_async_out;
output [3:0]		pld_fpll_shared_direct_async_out_hioint;// From hdpldadapt_tx_async of hdpldadapt_tx_async.v, ...
output [3:0]		pld_fpll_shared_direct_async_out_dcm;// From hdpldadapt_tx_async of hdpldadapt_tx_async.v, ...
output			pld_pcs_tx_clk_out1_dcm;// From hdpldadapt_txclk_ctl of hdpldadapt_txclk_ctl.v
output			pld_pcs_tx_clk_out1_hioint;// From hdpldadapt_txclk_ctl of hdpldadapt_txclk_ctl.v
output			pld_pcs_tx_clk_out2_dcm;// From hdpldadapt_txclk_ctl of hdpldadapt_txclk_ctl.v
output			pld_pcs_tx_clk_out2_hioint;// From hdpldadapt_txclk_ctl of hdpldadapt_txclk_ctl.v
output			pld_pma_fpll_clk0bad;	// From hdpldadapt_tx_async of hdpldadapt_tx_async.v
output			pld_pma_fpll_clk1bad;	// From hdpldadapt_tx_async of hdpldadapt_tx_async.v
output			pld_pma_fpll_clksel;	// From hdpldadapt_tx_async of hdpldadapt_tx_async.v
output			pld_pma_fpll_phase_done;// From hdpldadapt_tx_async of hdpldadapt_tx_async.v
output			pld_pmaif_mask_tx_pll;	// From hdpldadapt_tx_async of hdpldadapt_tx_async.v
output			pld_tx_fabric_fifo_empty;// From hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
output			pld_tx_fabric_fifo_full;// From hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
output			pld_tx_fabric_fifo_latency_pulse;// From hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
output			pld_tx_fabric_fifo_pempty;// From hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
output			pld_tx_fabric_fifo_pfull;// From hdpldadapt_tx_datapath of hdpldadapt_tx_datapath.v
output			pld_tx_hssi_align_done;	// From hdpldadapt_tx_async of hdpldadapt_tx_async.v
output			pld_tx_hssi_fifo_empty;	// From hdpldadapt_tx_async of hdpldadapt_tx_async.v
output			pld_tx_hssi_fifo_full;	// From hdpldadapt_tx_async of hdpldadapt_tx_async.v
output			pld_tx_fifo_ready;
output			rx_fsr_mask_tx_pll;	// From hdpldadapt_tx_async of hdpldadapt_tx_async.v
output			tx_async_fabric_hssi_fsr_data;// From hdpldadapt_tx_async of hdpldadapt_tx_async.v
output [35:0]		tx_async_fabric_hssi_ssr_data;// From hdpldadapt_tx_async of hdpldadapt_tx_async.v
output                  hip_fsr_parity_checker_in;
output  [5:0]           hip_ssr_parity_checker_in;
output                  tx_fsr_parity_checker_in;
output  [15:0]          tx_ssr_parity_checker_in;

// End of automatics
// temp
output [7:0]             tx_chnl_dprio_status;   // To hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output                   tx_chnl_dprio_status_write_en_ack;// To hdpldadapt_avmm1 of hdpldadapt_avmm1.v
input                    tx_chnl_dprio_status_write_en;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			pld_tx_hssi_fifo_latency_pulse;
output                  pld_aib_hssi_tx_dcd_cal_done;
output                  pld_aib_hssi_tx_dll_lock;
output			pld_aib_fabric_tx_dcd_cal_done;
output			pld_fabric_tx_transfer_en;
output [1:0]		rx_pld_rate;
output			tx_clock_fifo_rd_clk;
output			tx_clock_fifo_wr_clk;
output [2:0]            pld_tx_ssr_reserved_out;
output [2:0]            tx_async_fabric_hssi_ssr_reserved;
output [19:0]		tx_chnl_testbus;

assign tx_chnl_dprio_status = 8'h0;
assign tx_chnl_dprio_status_write_en_ack = 1'b0;

assign aib_fabric_tx_data_lpbk =	aib_fabric_tx_data_out;
assign rx_pld_rate	       = pld_tx_fabric_data_in[33:32];


/*AUTOWIRE*/
// Beginning of automatic wires (for undeclared instantiated-module outputs)
wire			tx_clock_async_rx_osc_clk;// From hdpldadapt_txclk_ctl of hdpldadapt_txclk_ctl.v
wire			tx_clock_async_tx_osc_clk;// From hdpldadapt_txclk_ctl of hdpldadapt_txclk_ctl.v
wire			tx_clock_hip_async_tx_osc_clk;
wire			tx_clock_hip_async_rx_osc_clk;
wire			tx_clock_fifo_rd_clk_frm_gen;
//wire			tx_clock_fifo_rd_clk;	// From hdpldadapt_txclk_ctl of hdpldadapt_txclk_ctl.v
wire			tx_clock_fifo_sclk;	// From hdpldadapt_txclk_ctl of hdpldadapt_txclk_ctl.v
//wire			tx_clock_fifo_wr_clk;	// From hdpldadapt_txclk_ctl of hdpldadapt_txclk_ctl.v
wire			q1_tx_clock_fifo_wr_clk;
wire			q2_tx_clock_fifo_wr_clk;
wire			q3_tx_clock_fifo_wr_clk;
wire			q4_tx_clock_fifo_wr_clk;
wire			q5_tx_clock_fifo_wr_clk;
wire			q6_tx_clock_fifo_wr_clk;
wire			tx_reset_async_rx_osc_clk_rst_n;// From hdpldadapt_txrst_ctl of hdpldadapt_txrst_ctl.v
wire			tx_reset_async_tx_osc_clk_rst_n;// From hdpldadapt_txrst_ctl of hdpldadapt_txrst_ctl.v
wire			tx_reset_fifo_rd_rst_n;	// From hdpldadapt_txrst_ctl of hdpldadapt_txrst_ctl.v
wire			tx_reset_fifo_sclk_rst_n;// From hdpldadapt_txrst_ctl of hdpldadapt_txrst_ctl.v
wire			tx_reset_fifo_wr_rst_n;	// From hdpldadapt_txrst_ctl of hdpldadapt_txrst_ctl.v
// End of automatics
wire                    tx_hrdrst_fabric_tx_dcd_cal_done;
wire                    tx_hrdrst_fabric_tx_transfer_en;
wire                    sr_hssi_tx_dcd_cal_done;
wire                    sr_hssi_tx_dll_lock;
wire                    sr_hssi_tx_transfer_en;
//wire [1:0]		r_tx_master_sel = 2'b00;
//wire			r_tx_dist_master_sel = 1'b0;
//wire			r_tx_ds_last_chnl = 1'b0;
//wire			r_tx_us_last_chnl = 1'b0;

wire [19:0]           tx_fifo_testbus1; 
wire [19:0]           tx_fifo_testbus2; 
wire [19:0]           frame_gen_testbus1;
wire [19:0]           frame_gen_testbus2;
wire [19:0]	      dv_gen_testbus;
wire [19:0]           tx_cp_bond_testbus;
wire [19:0]           tx_hrdrst_testbus; 

/* hdpldadapt_tx_datapath AUTO_TEMPLATE (
.tx_asn_fifo_srst(rx_asn_fifo_srst),
.tx_asn_gen3_sel(rx_asn_gen3_sel),
);
*/
wire			tx_hrdrst_tx_fifo_srst;
wire			tx_fifo_ready;

hdpldadapt_tx_datapath hdpldadapt_tx_datapath(/*AUTOINST*/
					      // Outputs
					      .aib_fabric_tx_data_out(aib_fabric_tx_data_out[40-1:0]),
					      .aib_fabric_pld_tx_hssi_fifo_latency_pulse (aib_fabric_pld_tx_hssi_fifo_latency_pulse),
					      .bond_tx_fifo_ds_out_dv(bond_tx_fifo_ds_out_dv),
					      .bond_tx_fifo_ds_out_rden(bond_tx_fifo_ds_out_rden),
					      .bond_tx_fifo_ds_out_wren(bond_tx_fifo_ds_out_wren),
					      .bond_tx_fifo_us_out_dv(bond_tx_fifo_us_out_dv),
					      .bond_tx_fifo_us_out_rden(bond_tx_fifo_us_out_rden),
					      .bond_tx_fifo_us_out_wren(bond_tx_fifo_us_out_wren),
					      .pld_10g_tx_burst_en_exe(pld_10g_tx_burst_en_exe),
					      .pld_10g_tx_wordslip_exe(pld_10g_tx_wordslip_exe),
					      .pld_tx_fabric_fifo_full(pld_tx_fabric_fifo_full),
					      .pld_tx_fabric_fifo_empty(pld_tx_fabric_fifo_empty),
					      .pld_tx_fabric_fifo_pfull(pld_tx_fabric_fifo_pfull),
					      .pld_tx_fabric_fifo_pempty(pld_tx_fabric_fifo_pempty),
					      .pld_tx_fabric_fifo_latency_pulse(pld_tx_fabric_fifo_latency_pulse),
					      .pld_10g_krfec_tx_frame(pld_10g_krfec_tx_frame),
					      .pld_tx_hssi_fifo_latency_pulse (pld_tx_hssi_fifo_latency_pulse),
					      .pld_tx_fifo_ready	(pld_tx_fifo_ready),
					      .frame_gen_testbus1	(frame_gen_testbus1),
					      .frame_gen_testbus2 	(frame_gen_testbus2), 
	                                      .tx_fifo_testbus1	(tx_fifo_testbus1),
	                                      .tx_fifo_testbus2 	(tx_fifo_testbus2), 
	                                      .dv_gen_testbus		(dv_gen_testbus),
	                                      .tx_cp_bond_testbus	(tx_cp_bond_testbus),
					      .tx_fifo_ready	(tx_fifo_ready),
					      				      
					      // Inputs
                                                 // new inputs for ECO8
                                                .r_tx_wren_fastbond (r_tx_wren_fastbond),
                                                .r_tx_rden_fastbond (r_tx_rden_fastbond),                                              
					      .pld_tx_fabric_data_in(pld_tx_fabric_data_in[80-1:0]),
					      .r_tx_usertest_sel(r_tx_usertest_sel),
					      .r_tx_bonding_dft_in_en(r_tx_bonding_dft_in_en),
					      .r_tx_bonding_dft_in_value(r_tx_bonding_dft_in_value),
					      .r_tx_burst_en	(r_tx_burst_en),
					      .r_tx_bypass_frmgen(r_tx_bypass_frmgen),
					      .r_tx_comp_cnt	(r_tx_comp_cnt[8-1:0]),
					      .r_tx_compin_sel	(r_tx_compin_sel[1:0]),
					      .r_tx_double_write(r_tx_double_write),
					      .r_tx_ds_bypass_pipeln(r_tx_ds_bypass_pipeln),
					      .r_tx_ds_master	(r_tx_ds_master),
					      .r_tx_dv_indv	(r_tx_dv_indv),
					      .r_tx_fifo_empty	(r_tx_fifo_empty[4:0]),
					      .r_tx_fifo_mode	(r_tx_fifo_mode[2:0]),
					      .r_tx_fifo_full	(r_tx_fifo_full[4:0]),
					      .r_tx_gb_dv_en	(r_tx_gb_dv_en),
					      .r_tx_gb_idwidth	(r_tx_gb_idwidth[2:0]),
					      .r_tx_gb_odwidth	(r_tx_gb_odwidth[1:0]),
					      .r_tx_indv	(r_tx_indv),
					      .r_tx_mfrm_length	(r_tx_mfrm_length[15:0]),
					      .r_tx_fifo_pempty	(r_tx_fifo_pempty[4:0]),
					      .r_tx_fifo_pfull	(r_tx_fifo_pfull[4:0]),
					      .r_tx_phcomp_rd_delay(r_tx_phcomp_rd_delay[2:0]),
					      .r_tx_pipeln_frmgen(r_tx_pipeln_frmgen),
					      .r_tx_pyld_ins	(r_tx_pyld_ins),
					      .r_tx_sh_err	(r_tx_sh_err),
					      .r_tx_stop_read	(r_tx_stop_read),
					      .r_tx_stop_write	(r_tx_stop_write),
					      .r_tx_us_bypass_pipeln(r_tx_us_bypass_pipeln),
					      .r_tx_us_master	(r_tx_us_master),
					      .r_tx_wm_en	(r_tx_wm_en),
      				              .r_tx_fifo_power_mode				 (r_tx_fifo_power_mode),
                                              .r_tx_stretch_num_stages				 (r_tx_stretch_num_stages), 	
                                              .r_tx_datapath_tb_sel 				 (r_tx_datapath_tb_sel), 
                                              .r_tx_wr_adj_en 					 (r_tx_wr_adj_en), 
                                              .r_tx_rd_adj_en					 (r_tx_rd_adj_en),
                                              .pr_channel_freeze_n(pr_channel_freeze_n),
                                              .nfrzdrv_in             (nfrzdrv_in),
					      .r_tx_ds_last_chnl(r_tx_ds_last_chnl),
					      .r_tx_us_last_chnl(r_tx_us_last_chnl),
					      
					      .r_tx_wordslip	(r_tx_wordslip),
					      .pld_10g_tx_burst_en(pld_10g_tx_burst_en),
					      .tx_reset_fifo_wr_rst_n(tx_reset_fifo_wr_rst_n),
					      .tx_reset_fifo_rd_rst_n(tx_reset_fifo_rd_rst_n),
					      .tx_reset_fifo_sclk_rst_n(tx_reset_fifo_sclk_rst_n),
					      .tx_clock_fifo_wr_clk(tx_clock_fifo_wr_clk),
					.      tx_clock_fifo_rd_clk_frm_gen(tx_clock_fifo_rd_clk_frm_gen),
					      .q1_tx_clock_fifo_wr_clk(q1_tx_clock_fifo_wr_clk),
					      .q2_tx_clock_fifo_wr_clk(q2_tx_clock_fifo_wr_clk),
					      .q3_tx_clock_fifo_wr_clk(q3_tx_clock_fifo_wr_clk),
					      .q4_tx_clock_fifo_wr_clk(q4_tx_clock_fifo_wr_clk),
					      .q5_tx_clock_fifo_wr_clk(q5_tx_clock_fifo_wr_clk),
					      .q6_tx_clock_fifo_wr_clk(q6_tx_clock_fifo_wr_clk),
					      .tx_clock_fifo_rd_clk(tx_clock_fifo_rd_clk),
					      .tx_clock_fifo_sclk(tx_clock_fifo_sclk),
					      .bond_tx_fifo_ds_in_dv(bond_tx_fifo_ds_in_dv),
					      .bond_tx_fifo_ds_in_rden(bond_tx_fifo_ds_in_rden),
					      .bond_tx_fifo_ds_in_wren(bond_tx_fifo_ds_in_wren),
					      .bond_tx_fifo_us_in_dv(bond_tx_fifo_us_in_dv),
					      .bond_tx_fifo_us_in_rden(bond_tx_fifo_us_in_rden),
					      .bond_tx_fifo_us_in_wren(bond_tx_fifo_us_in_wren),
					      .pld_10g_tx_diag_status(pld_10g_tx_diag_status[1:0]),
					      .pld_10g_tx_wordslip(pld_10g_tx_wordslip),
				              .pld_tx_fifo_latency_adj_en (pld_tx_fifo_latency_adj_en),
					      //.tx_asn_fifo_srst	(rx_asn_fifo_srst), // Templated
					      .tx_asn_fifo_srst	(tx_hrdrst_tx_fifo_srst),
					      .tx_asn_fifo_hold (rx_asn_fifo_hold),
					      .tx_asn_gen3_sel	(1'b0)); // Templated
hdpldadapt_tx_async hdpldadapt_tx_async(/*AUTOINST*/
					// Outputs
                                        .pld_tx_ssr_reserved_out (pld_tx_ssr_reserved_out),
                                        .tx_async_fabric_hssi_ssr_reserved (tx_async_fabric_hssi_ssr_reserved),
					.aib_fabric_pld_pma_txdetectrx(aib_fabric_pld_pma_txdetectrx),
					.pld_krfec_tx_alignment(pld_krfec_tx_alignment),
					.pld_pma_fpll_clk0bad(pld_pma_fpll_clk0bad),
					.pld_pma_fpll_clk1bad(pld_pma_fpll_clk1bad),
					.pld_pma_fpll_clksel(pld_pma_fpll_clksel),
					.pld_pma_fpll_phase_done(pld_pma_fpll_phase_done),
					.pld_pmaif_mask_tx_pll(pld_pmaif_mask_tx_pll),
					.pld_tx_hssi_align_done(pld_tx_hssi_align_done),
					.pld_tx_hssi_fifo_full(pld_tx_hssi_fifo_full),
					.pld_tx_hssi_fifo_empty(pld_tx_hssi_fifo_empty),
					.hip_aib_fsr_out(hip_aib_fsr_out[3:0]),
					.hip_aib_ssr_out(hip_aib_ssr_out[7:0]),
					.pld_fpll_shared_direct_async_out(pld_fpll_shared_direct_async_out),
					.rx_fsr_mask_tx_pll(rx_fsr_mask_tx_pll),
					.hip_aib_async_fsr_in(hip_aib_async_fsr_in[3:0]),
					.hip_aib_async_ssr_in(hip_aib_async_ssr_in[39:0]),
					.tx_async_fabric_hssi_fsr_data(tx_async_fabric_hssi_fsr_data),
					.tx_async_fabric_hssi_ssr_data(tx_async_fabric_hssi_ssr_data[35:0]),
                                        .sr_hssi_tx_dcd_cal_done(sr_hssi_tx_dcd_cal_done),
                                        .sr_hssi_tx_dll_lock(sr_hssi_tx_dll_lock),
                                        .sr_hssi_tx_transfer_en(sr_hssi_tx_transfer_en),
                                        .pld_aib_hssi_tx_dcd_cal_done(pld_aib_hssi_tx_dcd_cal_done),
                                        .pld_aib_hssi_tx_dll_lock(pld_aib_hssi_tx_dll_lock),
                                        .hip_fsr_parity_checker_in (hip_fsr_parity_checker_in),
                                        .hip_ssr_parity_checker_in (hip_ssr_parity_checker_in),
                                        .tx_fsr_parity_checker_in  (tx_fsr_parity_checker_in),
                                        .tx_ssr_parity_checker_in  (tx_ssr_parity_checker_in),
					// Inputs
					.usermode_in	(usermode_in),
                                        .r_tx_hip_aib_ssr_in_polling_bypass (r_tx_hip_aib_ssr_in_polling_bypass),
                                        .r_tx_pld_8g_tx_boundary_sel_polling_bypass          (r_tx_pld_8g_tx_boundary_sel_polling_bypass),
                                        .r_tx_pld_10g_tx_bitslip_polling_bypass              (r_tx_pld_10g_tx_bitslip_polling_bypass),
                                        .r_tx_pld_pma_fpll_cnt_sel_polling_bypass            (r_tx_pld_pma_fpll_cnt_sel_polling_bypass),
                                        .r_tx_pld_pma_fpll_num_phase_shifts_polling_bypass   (r_tx_pld_pma_fpll_num_phase_shifts_polling_bypass),
                                        .pld_pma_tx_qpi_pulldn (pld_pma_tx_qpi_pulldn),
                                        .pld_pma_tx_qpi_pullup (pld_pma_tx_qpi_pullup),
                                        .pld_pma_rx_qpi_pullup (pld_pma_rx_qpi_pullup),
                                        .pld_tx_ssr_reserved_in (pld_tx_ssr_reserved_in),
                                        .tx_async_hssi_fabric_ssr_reserved (tx_async_hssi_fabric_ssr_reserved),
				        .pld_tx_fifo_latency_adj_en (pld_tx_fifo_latency_adj_en),
                                        .pld_tx_dll_lock_req(pld_tx_dll_lock_req),
                                        .pld_aib_hssi_tx_dcd_cal_req  (pld_aib_hssi_tx_dcd_cal_req),
                                        .pld_aib_hssi_tx_dll_lock_req (pld_aib_hssi_tx_dll_lock_req),
                                        .tx_hrdrst_fabric_tx_dcd_cal_done(tx_hrdrst_fabric_tx_dcd_cal_done),
                                        .tx_hrdrst_fabric_tx_transfer_en(tx_hrdrst_fabric_tx_transfer_en),
                                        .pr_channel_freeze_n(pr_channel_freeze_n),
					.nfrzdrv_in		(nfrzdrv_in),
					.aib_fabric_fpll_shared_direct_async_in(aib_fabric_fpll_shared_direct_async_in[4:4]),
					.r_tx_async_pld_txelecidle_rst_val(r_tx_async_pld_txelecidle_rst_val),
					.r_tx_async_hip_aib_fsr_in_bit0_rst_val(r_tx_async_hip_aib_fsr_in_bit0_rst_val),
					.r_tx_async_hip_aib_fsr_in_bit1_rst_val(r_tx_async_hip_aib_fsr_in_bit1_rst_val),
					.r_tx_async_hip_aib_fsr_in_bit2_rst_val(r_tx_async_hip_aib_fsr_in_bit2_rst_val),
					.r_tx_async_hip_aib_fsr_in_bit3_rst_val(r_tx_async_hip_aib_fsr_in_bit3_rst_val),
					.r_tx_async_pld_pmaif_mask_tx_pll_rst_val(r_tx_async_pld_pmaif_mask_tx_pll_rst_val),
					.r_tx_async_hip_aib_fsr_out_bit0_rst_val(r_tx_async_hip_aib_fsr_out_bit0_rst_val),
					.r_tx_async_hip_aib_fsr_out_bit1_rst_val(r_tx_async_hip_aib_fsr_out_bit1_rst_val),
					.r_tx_async_hip_aib_fsr_out_bit2_rst_val(r_tx_async_hip_aib_fsr_out_bit2_rst_val),
					.r_tx_async_hip_aib_fsr_out_bit3_rst_val(r_tx_async_hip_aib_fsr_out_bit3_rst_val),
                                        .tx_clock_hip_async_tx_osc_clk(tx_clock_hip_async_tx_osc_clk),
                                        .tx_clock_hip_async_rx_osc_clk(tx_clock_hip_async_rx_osc_clk),
					.pld_10g_tx_bitslip(pld_10g_tx_bitslip[6:0]),
					.pld_8g_tx_boundary_sel(pld_8g_tx_boundary_sel[4:0]),
					.pld_pma_csr_test_dis(pld_pma_csr_test_dis),
					.pld_pma_fpll_cnt_sel(pld_pma_fpll_cnt_sel[3:0]),
					.pld_pma_fpll_extswitch(pld_pma_fpll_extswitch),
					.pld_pma_fpll_lc_csr_test_dis(pld_pma_fpll_lc_csr_test_dis),
					.pld_pma_fpll_num_phase_shifts(pld_pma_fpll_num_phase_shifts[2:0]),
					.pld_pma_fpll_pfden(pld_pma_fpll_pfden),
					.pld_pma_nrpi_freeze(pld_pma_nrpi_freeze),
					.pld_pma_tx_bitslip(pld_pma_tx_bitslip),
					.pld_pma_txdetectrx(pld_pma_txdetectrx),
					.pld_polinv_tx	(pld_polinv_tx),
					.pld_txelecidle	(pld_txelecidle),
					.pld_pma_fpll_up_dn_lc_lf_rstn(pld_pma_fpll_up_dn_lc_lf_rstn),
					.hip_aib_fsr_in	(hip_aib_fsr_in[3:0]),
					.hip_aib_ssr_in	(hip_aib_ssr_in[39:0]),
					.tx_async_hssi_fabric_fsr_data(tx_async_hssi_fabric_fsr_data),
					.tx_async_hssi_fabric_fsr_load(tx_async_hssi_fabric_fsr_load),
					.tx_async_hssi_fabric_ssr_data(tx_async_hssi_fabric_ssr_data[12:0]),
					.tx_async_hssi_fabric_ssr_load(tx_async_hssi_fabric_ssr_load),
					.tx_async_fabric_hssi_fsr_load(tx_async_fabric_hssi_fsr_load),
					.tx_async_fabric_hssi_ssr_load(tx_async_fabric_hssi_ssr_load),
					.hip_aib_async_fsr_out(hip_aib_async_fsr_out[3:0]),
					.hip_aib_async_ssr_out(hip_aib_async_ssr_out[7:0]),
					.tx_clock_async_rx_osc_clk(tx_clock_async_rx_osc_clk),
					.tx_clock_async_tx_osc_clk(tx_clock_async_tx_osc_clk),
					.tx_reset_async_rx_osc_clk_rst_n(tx_reset_async_rx_osc_clk_rst_n),
					.tx_reset_async_tx_osc_clk_rst_n(tx_reset_async_tx_osc_clk_rst_n));
hdpldadapt_txclk_ctl hdpldadapt_txclk_ctl(/*AUTOINST*/
					  // Outputs
					  .aib_fabric_fpll_shared_direct_async_out(aib_fabric_fpll_shared_direct_async_out[0:0]),
					  .aib_fabric_tx_transfer_clk(aib_fabric_tx_transfer_clk),
					  .pld_pcs_tx_clk_out1_hioint(pld_pcs_tx_clk_out1_hioint),
					  .pld_pcs_tx_clk_out1_dcm(pld_pcs_tx_clk_out1_dcm),
					  .pld_pcs_tx_clk_out2_hioint(pld_pcs_tx_clk_out2_hioint),
					  .pld_pcs_tx_clk_out2_dcm(pld_pcs_tx_clk_out2_dcm),
					  .pld_fpll_shared_direct_async_out_hioint(pld_fpll_shared_direct_async_out_hioint[3:0]),
					  .pld_fpll_shared_direct_async_out_dcm(pld_fpll_shared_direct_async_out_dcm[3:0]),
					  .tx_clock_reset_hrdrst_rx_osc_clk(tx_clock_reset_hrdrst_rx_osc_clk),
					  .tx_clock_reset_fifo_wr_clk(tx_clock_reset_fifo_wr_clk),
					  .tx_clock_reset_fifo_rd_clk(tx_clock_reset_fifo_rd_clk),
					  .tx_clock_fifo_sclk(tx_clock_fifo_sclk),
					  .tx_clock_reset_async_rx_osc_clk(tx_clock_reset_async_rx_osc_clk),
					  .tx_clock_reset_async_tx_osc_clk(tx_clock_reset_async_tx_osc_clk),
					  .tx_clock_fifo_wr_clk(tx_clock_fifo_wr_clk),
					  .q1_tx_clock_fifo_wr_clk(q1_tx_clock_fifo_wr_clk),
					  .q2_tx_clock_fifo_wr_clk(q2_tx_clock_fifo_wr_clk),
					  .q3_tx_clock_fifo_wr_clk(q3_tx_clock_fifo_wr_clk),
					  .q4_tx_clock_fifo_wr_clk(q4_tx_clock_fifo_wr_clk),
					  .q5_tx_clock_fifo_wr_clk(q5_tx_clock_fifo_wr_clk),
					  .q6_tx_clock_fifo_wr_clk(q6_tx_clock_fifo_wr_clk),
					  .tx_clock_fifo_rd_clk_frm_gen(tx_clock_fifo_rd_clk_frm_gen),
					  .tx_clock_fifo_rd_clk	(tx_clock_fifo_rd_clk),
					  .tx_clock_hrdrst_rx_osc_clk(tx_clock_hrdrst_rx_osc_clk),
					  .tx_clock_async_rx_osc_clk(tx_clock_async_rx_osc_clk),
					  .tx_clock_async_tx_osc_clk(tx_clock_async_tx_osc_clk),
					  .tx_clock_hip_async_tx_osc_clk(tx_clock_hip_async_tx_osc_clk),
					  .tx_clock_hip_async_rx_osc_clk(tx_clock_hip_async_rx_osc_clk),
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
					  .aib_fabric_pld_pcs_tx_clk_out(aib_fabric_pld_pcs_tx_clk_out),
					  .aib_fabric_pma_aib_tx_clk(aib_fabric_pma_aib_tx_clk),
					  .aib_fabric_pld_pma_clkdiv_tx_user(aib_fabric_pld_pma_clkdiv_tx_user),
					  .aib_fabric_fpll_shared_direct_async_in(aib_fabric_fpll_shared_direct_async_in[3:0]),
					  .rx_clock_pld_sclk	(rx_clock_pld_sclk),
					  .aib_fabric_rx_sr_clk_in(aib_fabric_rx_sr_clk_in),
					  .aib_fabric_tx_sr_clk_in(aib_fabric_tx_sr_clk_in),
					  .pld_fpll_shared_direct_async_in_rowclk(pld_fpll_shared_direct_async_in_rowclk),
					  .pld_fpll_shared_direct_async_in_dcm(pld_fpll_shared_direct_async_in_dcm),
					  .pld_tx_clk1_rowclk	(pld_tx_clk1_rowclk),
					  .pld_tx_clk1_dcm	(pld_tx_clk1_dcm),
					  .pld_tx_clk2_rowclk	(pld_tx_clk2_rowclk),
					  .pld_tx_clk2_dcm	(pld_tx_clk2_dcm),
					  .nfrzdrv_in		(nfrzdrv_in),
                                          .pr_channel_freeze_n (pr_channel_freeze_n),
                                          .pld_clk_dft_sel(pld_clk_dft_sel),
					  .r_tx_fpll_shared_direct_async_in_sel(r_tx_fpll_shared_direct_async_in_sel),
					  .r_tx_aib_clk1_sel	(r_tx_aib_clk1_sel[1:0]),
					  .r_tx_aib_clk2_sel	(r_tx_aib_clk2_sel[1:0]),
					  .r_tx_fifo_rd_clk_sel	(r_tx_fifo_rd_clk_sel[1:0]),
					  //.r_tx_fifo_wr_clk_sel	(r_tx_fifo_wr_clk_sel),
					  .r_tx_pld_clk1_sel	(r_tx_pld_clk1_sel),
					  .r_tx_pld_clk2_sel	(r_tx_pld_clk2_sel),
					  .r_tx_fifo_rd_clk_frm_gen_scg_en(r_tx_fifo_rd_clk_frm_gen_scg_en),
					  .r_tx_fifo_rd_clk_scg_en(r_tx_fifo_rd_clk_scg_en),
					  .r_tx_fifo_wr_clk_scg_en(r_tx_fifo_wr_clk_scg_en),
					  .r_tx_osc_clk_scg_en(r_tx_osc_clk_scg_en),
					  .r_tx_hrdrst_rx_osc_clk_scg_en(r_tx_hrdrst_rx_osc_clk_scg_en),
					  .r_tx_hip_osc_clk_scg_en(r_tx_hip_osc_clk_scg_en),
					  .r_tx_pld_clk1_delay_en(r_tx_pld_clk1_delay_en),
					  .r_tx_pld_clk1_delay_sel(r_tx_pld_clk1_delay_sel[3:0]),
					  .r_tx_pld_clk1_inv_en(r_tx_pld_clk1_inv_en),
					  .r_tx_fifo_power_mode(r_tx_fifo_power_mode[2:0]));

hdpldadapt_txrst_ctl hdpldadapt_txrst_ctl(/*AUTOINST*/
					  // Outputs
					  .aib_fabric_pcs_tx_pld_rst_n(aib_fabric_pcs_tx_pld_rst_n),
					  .aib_fabric_adapter_tx_pld_rst_n(aib_fabric_adapter_tx_pld_rst_n),
					  .aib_fabric_fpll_shared_direct_async_out(aib_fabric_fpll_shared_direct_async_out[2:1]),
					  .aib_fabric_pld_pma_txpma_rstb(aib_fabric_pld_pma_txpma_rstb),
					  .aib_fabric_tx_dcd_cal_req(aib_fabric_tx_dcd_cal_req),
                                          .pld_aib_fabric_tx_dcd_cal_done(pld_aib_fabric_tx_dcd_cal_done),
                                          .pld_fabric_tx_transfer_en(pld_fabric_tx_transfer_en),
					  .bond_tx_hrdrst_ds_out_fabric_tx_dcd_cal_done(bond_tx_hrdrst_ds_out_fabric_tx_dcd_cal_done),
					  .bond_tx_hrdrst_us_out_fabric_tx_dcd_cal_done(bond_tx_hrdrst_us_out_fabric_tx_dcd_cal_done),
					  .bond_tx_hrdrst_ds_out_fabric_tx_dcd_cal_req(bond_tx_hrdrst_ds_out_fabric_tx_dcd_cal_req),
					  .bond_tx_hrdrst_us_out_fabric_tx_dcd_cal_req(bond_tx_hrdrst_us_out_fabric_tx_dcd_cal_req),
					  .tx_hrdrst_tx_fifo_srst(tx_hrdrst_tx_fifo_srst),
					  .tx_hrdrst_fabric_tx_dcd_cal_done(tx_hrdrst_fabric_tx_dcd_cal_done),
					  .tx_hrdrst_fabric_tx_transfer_en(tx_hrdrst_fabric_tx_transfer_en),
					  .tx_hrdrst_testbus(tx_hrdrst_testbus),
					  .tx_reset_fifo_wr_rst_n(tx_reset_fifo_wr_rst_n),
					  .tx_reset_fifo_rd_rst_n(tx_reset_fifo_rd_rst_n),
					  .tx_reset_fifo_sclk_rst_n(tx_reset_fifo_sclk_rst_n),
					  .tx_reset_async_rx_osc_clk_rst_n(tx_reset_async_rx_osc_clk_rst_n),
					  .tx_reset_async_tx_osc_clk_rst_n(tx_reset_async_tx_osc_clk_rst_n),
					  // Inputs
                                          .adapter_scan_rst_n(adapter_scan_rst_n),
                                          .adapter_scan_mode_n(adapter_scan_mode_n),
					  .csr_rdy_dly_in	(csr_rdy_dly_in),
					  .usermode_in	(usermode_in),
					  .pr_channel_freeze_n(pr_channel_freeze_n),
					  .pld_pcs_tx_pld_rst_n	(pld_pcs_tx_pld_rst_n),
					  .pld_adapter_tx_pld_rst_n(pld_adapter_tx_pld_rst_n),
					  .pld_fpll_shared_direct_async_in(pld_fpll_shared_direct_async_in[1:0]),
					  .pld_pma_txpma_rstb	(pld_pma_txpma_rstb),
					  .pld_fabric_tx_fifo_srst(pld_fabric_tx_fifo_srst),
					  .pld_aib_fabric_tx_dcd_cal_req(pld_aib_fabric_tx_dcd_cal_req),
					  .nfrzdrv_in		(nfrzdrv_in),
					  .aib_fabric_tx_dcd_cal_done(aib_fabric_tx_dcd_cal_done),
					  .bond_tx_hrdrst_ds_in_fabric_tx_dcd_cal_done(bond_tx_hrdrst_ds_in_fabric_tx_dcd_cal_done),
					  .bond_tx_hrdrst_us_in_fabric_tx_dcd_cal_done(bond_tx_hrdrst_us_in_fabric_tx_dcd_cal_done),
					  .bond_tx_hrdrst_ds_in_fabric_tx_dcd_cal_req(bond_tx_hrdrst_ds_in_fabric_tx_dcd_cal_req),
					  .bond_tx_hrdrst_us_in_fabric_tx_dcd_cal_req(bond_tx_hrdrst_us_in_fabric_tx_dcd_cal_req),
					  .avmm_hrdrst_fabric_osc_transfer_en(avmm_hrdrst_fabric_osc_transfer_en),
					  .sr_hssi_tx_dcd_cal_done(sr_hssi_tx_dcd_cal_done),
					  .sr_hssi_tx_dll_lock(sr_hssi_tx_dll_lock),
					  .sr_hssi_tx_transfer_en(sr_hssi_tx_transfer_en),
					  .rx_asn_rate_change_in_progress(rx_asn_rate_change_in_progress),
					  .rx_asn_dll_lock_en(rx_asn_dll_lock_en),
					  .rx_asn_fifo_hold(rx_asn_fifo_hold),
					  .tx_fifo_ready(tx_fifo_ready),
					  .r_tx_hrdrst_rst_sm_dis(r_tx_hrdrst_rst_sm_dis),
					  .r_tx_hrdrst_dcd_cal_done_bypass(r_tx_hrdrst_dcd_cal_done_bypass),
					  .r_tx_hrdrst_user_ctl_en(r_tx_hrdrst_user_ctl_en),
					  .r_tx_master_sel(r_tx_compin_sel[1:0]),
					  .r_tx_dist_master_sel(r_tx_ds_master),
					  .r_tx_ds_last_chnl(r_tx_ds_last_chnl),
					  .r_tx_us_last_chnl(r_tx_us_last_chnl),
					  .r_tx_bonding_dft_in_en(r_tx_bonding_dft_in_en),
					  .r_tx_bonding_dft_in_value(r_tx_bonding_dft_in_value),
					  .tx_clock_reset_hrdrst_rx_osc_clk(tx_clock_reset_hrdrst_rx_osc_clk),
					  .tx_clock_reset_fifo_wr_clk(tx_clock_reset_fifo_wr_clk),
					  .tx_clock_reset_fifo_rd_clk(tx_clock_reset_fifo_rd_clk),
					  .tx_clock_fifo_sclk(tx_clock_fifo_sclk),
					  .tx_clock_reset_async_rx_osc_clk(tx_clock_reset_async_rx_osc_clk),
					  .tx_clock_reset_async_tx_osc_clk(tx_clock_reset_async_tx_osc_clk),
					  .tx_clock_hrdrst_rx_osc_clk(tx_clock_hrdrst_rx_osc_clk));

// Testbus
hdpldadapt_tx_chnl_testbus hdpldadapt_tx_chnl_testbus (
	.r_tx_datapath_tb_sel	(r_tx_datapath_tb_sel),
	.frame_gen_testbus1	(frame_gen_testbus1),
	.frame_gen_testbus2 	(frame_gen_testbus2), 
	.tx_fifo_testbus1	(tx_fifo_testbus1),
	.tx_fifo_testbus2 	(tx_fifo_testbus2), 
	.dv_gen_testbus		(dv_gen_testbus),
	.tx_cp_bond_testbus	(tx_cp_bond_testbus),
	.tx_hrdrst_testbus	(tx_hrdrst_testbus),
	.tx_chnl_testbus	(tx_chnl_testbus));
	
endmodule

