// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3aibadapt_rxchnl(/*AUTOARG*/
   // Outputs
   rx_fsr_parity_checker_in, rx_ssr_parity_checker_in, tx_direct_transfer_testbus,
   rx_async_hssi_fabric_ssr_data, rx_async_hssi_fabric_fsr_data,
   rx_asn_rate_change_in_progress, rx_asn_dll_lock_en, 
   rx_asn_rate, //rx_asn_fifo_srst,
   rx_asn_fifo_hold, pld_syncsm_en, 
   pld_rx_prbs_err_clr, pld_polinv_rx,
   pld_pmaif_rxclkslip, pld_pma_rxpma_rstb,
   pld_pma_rs_lpbk_b, pld_pma_reserved_out, pld_pma_ppm_lock,
   pld_pma_pcie_switch, pld_pma_ltd_b, pld_pma_eye_monitor,
   pld_pma_early_eios, pld_pma_coreclkin, pld_pma_adapt_start,
   pld_ltr, pld_bitslip,
   pld_8g_encdt,
   pld_8g_eidleinfersel, pld_8g_byte_rev_en, pld_8g_bitloc_rev_en,
   pld_8g_a1a2_size, pld_10g_rx_clr_ber_count,
   usr_rx_elane_rst_n,
   pld_10g_krfec_rx_clr_errblk_cnt,
   pld_g3_current_rxpreset,
   aib_hssi_pld_pma_pfdmode_lock,
   aib_hssi_rx_transfer_clk,
   aib_hssi_rx_data_out, aib_hssi_rx_fifo_latency_pls,
   aib_hssi_pld_pma_rxpll_lock, aib_hssi_pld_pma_internal_clk2,
   aib_hssi_pld_pma_internal_clk1, aib_hssi_pld_pma_hclk,
   aib_rx_pma_div66_clk, aib_rx_pma_div2_clk,
   aib_hssi_pld_8g_rxelecidle, 
   rx_asn_clk_en, rx_asn_gen3_sel,
   rx_chnl_dprio_status, rx_chnl_dprio_status_write_en_ack,
   hip_init_status, rx_async_hssi_fabric_ssr_reserved,
   xcvrif_sclk,
   rx_chnl_fifo_sclk,
   sr_pld_latency_pulse_sel,
   // Inputs
   scan_mode_n,
   tst_tcm_ctrl,
   test_clk,
   scan_clk,
   tx_pma_clk,
   rx_pma_clk,
   tx_clock_fifo_rd_prect_clk,
   dft_adpt_rst, adpt_scan_rst_n, pld_pma_pfdmode_lock,
   sr_parity_error_flag, avmm_transfer_error,
   rx_pld_rate, txeq_rxeqeval, txeq_rxeqinprogress, 
   rx_async_hssi_fabric_ssr_load, rx_async_hssi_fabric_fsr_load,
   rx_async_fabric_hssi_ssr_load, rx_async_fabric_hssi_ssr_data,
   rx_async_fabric_hssi_fsr_load, rx_async_fabric_hssi_fsr_data, r_rx_chnl_datapath_map_mode,
//   r_rx_write_ctrl, 
   r_rx_wm_en, r_rx_us_master, r_rx_us_bypass_pipeln, r_rx_async_hip_en,
   r_rx_stop_write, r_rx_stop_read, r_rx_parity_sel, r_rx_pcs_testbus_sel,
   r_rx_txeq_en,r_rx_rxeq_en,r_rx_pre_cursor_en,r_rx_post_cursor_en,
   r_rx_invalid_no_change,r_rx_adp_go_b4txeq_en,r_rx_use_rxvalid_for_rxeq,r_rx_pma_rstn_en,r_rx_pma_rstn_cycles,
   r_rx_txeq_time,r_rx_eq_iteration,
   r_rx_pma_hclk_scg_en, r_rx_phcomp_rd_delay, rx_async_fabric_hssi_ssr_reserved,
   r_rx_osc_clk_scg_en, r_rx_mask_del,
   r_rx_internal_clk2_sel,
   r_rx_internal_clk1_sel, r_rx_indv, //r_rx_hrc_chnl_en,
   r_rx_free_run_div_clk, r_rx_txeq_rst_sel, r_rx_force_align, r_rx_fifo_wr_clk_sel,
   r_rx_pma_coreclkin_sel, r_rx_txeq_clk_sel,r_rx_txeq_clk_scg_en,
   r_rx_fifo_wr_clk_scg_en, r_rx_fifo_rd_clk_sel,
   r_rx_fifo_rd_clk_scg_en, r_rx_fifo_pfull, r_rx_fifo_pempty,
   r_rx_fifo_mode, r_rx_fifo_full, r_rx_fifo_empty,
   r_rx_dyn_clk_sw_en, r_rx_ds_master,
   r_rx_ds_bypass_pipeln, r_rx_double_write, r_rx_compin_sel,
   r_rx_comp_cnt,  r_rx_rmfflag_stretch_enable,
//   r_rx_clkdiv2_master_sel,
//   r_rx_clkdiv2_dist_master_sel, r_rx_clkdiv2_dist_bypass_pipeln,
   r_rx_internal_clk1_sel0,
   r_rx_internal_clk1_sel1,
   r_rx_internal_clk1_sel2,
   r_rx_internal_clk1_sel3,
   r_rx_txfiford_pre_ct_sel,
   r_rx_txfiford_post_ct_sel,
   r_rx_txfifowr_post_ct_sel,
   r_rx_txfifowr_from_aib_sel,
   r_rx_internal_clk2_sel0,
   r_rx_internal_clk2_sel1,
   r_rx_internal_clk2_sel2,
   r_rx_internal_clk2_sel3,
   r_rx_rxfifowr_pre_ct_sel,
   r_rx_rxfifowr_post_ct_sel,
   r_rx_rxfiford_post_ct_sel,
   r_rx_rxfiford_to_aib_sel,
   r_rx_asn_en, r_rx_slv_asn_en,
   r_rx_asn_bypass_clock_gate,
   r_rx_asn_bypass_pma_pcie_sw_done,
   r_rx_hrdrst_user_ctl_en,
   r_rx_usertest_sel,
   r_tx_latency_src_xcvrif,
   r_rx_asn_wait_for_fifo_flush_cnt,
   r_rx_asn_wait_for_dll_reset_cnt,
   r_rx_asn_wait_for_clock_gate_cnt,
   r_rx_asn_wait_for_pma_pcie_sw_done_cnt,
   r_rx_pld_8g_a1a2_k1k2_flag_polling_bypass,
   r_rx_10g_krfec_rx_diag_data_status_polling_bypass,
   r_rx_pld_8g_wa_boundary_polling_bypass,
   r_rx_pcspma_testbus_sel,
   r_rx_pld_pma_pcie_sw_done_polling_bypass,
   r_rx_pld_pma_reser_in_polling_bypass,
   r_rx_pld_pma_testbus_polling_bypass,
   r_rx_pld_test_data_polling_bypass,
//   r_rx_asn_master_sel,
//   r_rx_asn_dist_master_sel,
   r_rx_bonding_dft_in_value,
   r_rx_bonding_dft_in_en, r_rx_async_pld_rx_fifo_align_clr_rst_val,
   r_rx_async_pld_pma_ltd_b_rst_val, r_rx_async_pld_ltr_rst_val,
   r_rx_async_pld_8g_signal_detect_out_rst_val,
   r_rx_async_pld_10g_rx_crc32_err_rst_val, r_rx_align_del,
   pld_test_data, pld_rx_prbs_err,
   rx_pma_data,
   rx_pma_div2_clk,
   rx_ehip_clk,
   rx_ehip_frd_clk,
   rx_elane_clk,
   rx_rsfec_clk,
   rx_rsfec_frd_clk,
   pld_rx_prbs_done, 
   pld_pmaif_mask_tx_pll, feedthru_clk, pld_pma_testbus,
   pld_pma_signal_ok, pld_pma_rxpll_lock, pld_pma_rx_found,
   pld_pma_rx_detect_valid, pld_pma_reserved_in,
   pld_pma_pcie_sw_done, 
   rx_pma_div66_clk, pld_pma_adapt_done, 
   pld_8g_wa_boundary, pld_8g_signal_detect_out,
   pld_8g_rxelecidle, pld_8g_full_rmf,
   pld_8g_empty_rmf, pld_8g_a1a2_k1k2_flag,
   pld_10g_rx_hi_ber, pld_10g_rx_frame_lock, 
   pld_10g_rx_crc32_err, 
   pld_10g_krfec_rx_frame, pld_10g_krfec_rx_diag_data_status,
   pld_10g_krfec_rx_blk_lock, txeq_invalid_req, //hip_rx_data, 
   //hip_rst, 
   txeq_txdetectrx, txeq_rate, txeq_powerdown,
   rx_ehip_data, rx_elane_data, rx_rsfec_data, 
   csr_rdy_dly_in, 
   tx_clock_fifo_wr_clk,tx_clock_fifo_rd_clk,
   //bond_rx_asn_us_in_dll_lock_en,
   // bond_rx_asn_us_in_gen3_sel,
   avmm_hrdrst_hssi_osc_transfer_alive,
   aib_hssi_rx_dcd_cal_done,
   tx_aib_transfer_clk,
   tx_aib_transfer_clk_rst_n,
   tx_aib_transfer_div2_clk,
   aib_hssi_rx_sr_clk_in, aib_hssi_pld_sclk,
   aib_hssi_pld_pma_rxpma_rstb, aib_hssi_pld_pma_coreclkin,
   aib_hssi_pcs_rx_pld_rst_n, 
   aib_hssi_fpll_shared_direct_async_in,
   xcvrif_rx_latency_pls,
   avmm1_clock_avmm_clk_scg,avmm1_clock_avmm_clk_dcg,
   avmm2_clock_avmm_clk_scg,avmm2_clock_avmm_clk_dcg,
   sr_clock_tx_sr_clk_in_div2, sr_clock_tx_sr_clk_in_div4, sr_clock_tx_osc_clk_or_clkdiv,
   aib_hssi_adapter_rx_pld_rst_n, rx_chnl_dprio_status_write_en,
   sr_fabric_tx_transfer_en, r_rx_hrdrst_dcd_cal_done_bypass, r_rx_hrdrst_rst_sm_dis, r_rx_rmfflag_stretch_num_stages,
//   r_rx_hrdrst_master_sel, r_rx_hrdrst_dist_master_sel,
   r_rx_ds_last_chnl, r_rx_us_last_chnl,
   r_rx_hrdrst_rx_osc_clk_scg_en, aib_hssi_rx_dcd_cal_req,
   r_rx_fifo_power_mode,
   r_rx_stretch_num_stages,
   r_rx_datapath_tb_sel, 
   r_rx_wr_adj_en, 
   r_rx_rd_adj_en,
   r_rx_msb_rdptr_pipe_byp,
   r_rx_aib_lpbk_en,
   r_rx_adapter_lpbk_mode,
   tx_fifo_data_lpbk,
   aib_hssi_tx_data_lpbk,
   tx_pma_data_lpbk,
   oaibdftdll2core,
   avmm_testbus,
   tx_chnl_testbus,
   rx_hrdrst_tb_direct
   );


/*AUTOINPUT*/
// Beginning of automatic inputs (from unused autoinst inputs)
input                   scan_mode_n;
input [6:0]             tst_tcm_ctrl;
input                   test_clk;
input                   scan_clk;
input   		dft_adpt_rst;
input                   adpt_scan_rst_n;
input			aib_hssi_adapter_rx_pld_rst_n;// To c3adapt_rxrst_ctl of c3adapt_rxrst_ctl.v
input			avmm1_clock_avmm_clk_scg;
input			avmm1_clock_avmm_clk_dcg;
input			avmm2_clock_avmm_clk_scg;
input			avmm2_clock_avmm_clk_dcg;
input			sr_clock_tx_sr_clk_in_div2;
input			sr_clock_tx_sr_clk_in_div4;
input			sr_clock_tx_osc_clk_or_clkdiv;	// To c3adapt_rxclk_ctl of c3adapt_rxclk_ctl.v
input			aib_hssi_pcs_rx_pld_rst_n;// To c3adapt_rxrst_ctl of c3adapt_rxrst_ctl.v
input			aib_hssi_pld_pma_coreclkin;// To c3adapt_rxclk_ctl of c3adapt_rxclk_ctl.v
input      		aib_hssi_fpll_shared_direct_async_in;
input			aib_hssi_pld_pma_rxpma_rstb;// To c3adapt_rxrst_ctl of c3adapt_rxrst_ctl.v
input			aib_hssi_pld_sclk;	// To c3adapt_rxclk_ctl of c3adapt_rxclk_ctl.v
input			aib_hssi_rx_sr_clk_in;	// To c3adapt_rxclk_ctl of c3adapt_rxclk_ctl.v
input                   tx_aib_transfer_clk;
input                   tx_aib_transfer_clk_rst_n;
input                   tx_aib_transfer_div2_clk;
input			aib_hssi_rx_dcd_cal_done;
input			avmm_hrdrst_hssi_osc_transfer_alive;
input			csr_rdy_dly_in;		// To c3adapt_rxrst_ctl of c3adapt_rxrst_ctl.v
input [77:0]		rx_ehip_data;	// To c3adapt_rx_datapath of c3adapt_rx_datapath.v
input [77:0]		rx_elane_data;	// To c3adapt_rx_datapath of c3adapt_rx_datapath.v
input [77:0]		rx_rsfec_data;	// To c3adapt_rx_datapath of c3adapt_rx_datapath.v
input			tx_clock_fifo_wr_clk;
input			tx_clock_fifo_rd_clk;
input			txeq_invalid_req;		// To c3adapt_rxdp of c3adapt_rxdp.v
input			pld_10g_krfec_rx_blk_lock;// To c3adapt_rxasync of c3adapt_rxasync.v
input [1:0]		pld_10g_krfec_rx_diag_data_status;// To c3adapt_rxasync of c3adapt_rxasync.v
input			pld_10g_krfec_rx_frame;	// To c3adapt_rxasync of c3adapt_rxasync.v
input			pld_10g_rx_crc32_err;	// To c3adapt_rxasync of c3adapt_rxasync.v
input			pld_10g_rx_frame_lock;	// To c3adapt_rxasync of c3adapt_rxasync.v
input			pld_10g_rx_hi_ber;	// To c3adapt_rxasync of c3adapt_rxasync.v
input [3:0]		pld_8g_a1a2_k1k2_flag;	// To c3adapt_rxasync of c3adapt_rxasync.v
input			pld_8g_empty_rmf;	// To c3adapt_rxasync of c3adapt_rxasync.v
input			pld_8g_full_rmf;	// To c3adapt_rxasync of c3adapt_rxasync.v
input			pld_8g_rxelecidle;	// To c3adapt_rxasync of c3adapt_rxasync.v
input			pld_8g_signal_detect_out;// To c3adapt_rxasync of c3adapt_rxasync.v
input [4:0]		pld_8g_wa_boundary;	// To c3adapt_rxasync of c3adapt_rxasync.v
input			pld_pma_adapt_done;	// To c3adapt_rxasync of c3adapt_rxasync.v
input			rx_pma_div66_clk;	// To c3adapt_rxclk_ctl of c3adapt_rxclk_ctl.v
input [5:0]             feedthru_clk;
input [1:0]		pld_pma_pcie_sw_done;	// To c3adapt_rxddp of c3adapt_rxdp.v, ...
input [4:0]		pld_pma_reserved_in;	// To c3adapt_rxasync of c3adapt_rxasync.v
input			pld_pma_rx_detect_valid;// To c3adapt_rxasync of c3adapt_rxasync.v
input			pld_pma_rx_found;	// To c3adapt_rxdp of c3adapt_rxdp.v
input			pld_pma_rxpll_lock;	// To c3adapt_rxasync of c3adapt_rxasync.v
input			pld_pma_signal_ok;	// To c3adapt_rxasync of c3adapt_rxasync.v
input [7:0]		pld_pma_testbus;	// To c3adapt_rxasync of c3adapt_rxasync.v
input			pld_pmaif_mask_tx_pll;	// To c3adapt_rxdp of c3adapt_rxdp.v
input			pld_rx_prbs_done;	// To c3adapt_rxasync of c3adapt_rxasync.v
input			pld_rx_prbs_err;	// To c3adapt_rxasync of c3adapt_rxasync.v
input [19:0]		pld_test_data;		// To c3adapt_rxasync of c3adapt_rxasync.v
input			rx_pma_clk;
input                   rx_pma_div2_clk;
input                   rx_ehip_clk;
input                   rx_elane_clk;
input                   rx_rsfec_clk;
input                   rx_ehip_frd_clk;
input                   rx_rsfec_frd_clk;
input			tx_pma_clk;		// To c3adapt_rxclk_ctl of c3adapt_rxclk_ctl.v, ...
input                   tx_clock_fifo_rd_prect_clk;
input                   pld_pma_pfdmode_lock;
input			r_rx_align_del;		// To c3adapt_rxdp of c3adapt_rxdp.v
input			r_rx_async_pld_10g_rx_crc32_err_rst_val;// To c3adapt_rxasync of c3adapt_rxasync.v
input			r_rx_async_pld_8g_signal_detect_out_rst_val;// To c3adapt_rxasync of c3adapt_rxasync.v
input			r_rx_async_pld_ltr_rst_val;// To c3adapt_rxasync of c3adapt_rxasync.v
input			r_rx_async_pld_pma_ltd_b_rst_val;// To c3adapt_rxasync of c3adapt_rxasync.v
input			r_rx_async_pld_rx_fifo_align_clr_rst_val;// To c3adapt_rxasync of c3adapt_rxasync.v
input			r_rx_bonding_dft_in_en;	// To c3adapt_rxdp of c3adapt_rxdp.v
input			r_rx_bonding_dft_in_value;// To c3adapt_rxdp of c3adapt_rxdp.v
input                   r_rx_asn_en;
input                   r_rx_slv_asn_en;
input                   r_rx_asn_bypass_clock_gate;
input                   r_rx_asn_bypass_pma_pcie_sw_done;
input		        r_rx_hrdrst_user_ctl_en;
input   [1:0]           r_rx_usertest_sel;
input                   r_tx_latency_src_xcvrif;
input   [6:0]           r_rx_asn_wait_for_fifo_flush_cnt;
input   [6:0]           r_rx_asn_wait_for_dll_reset_cnt;
input   [6:0]           r_rx_asn_wait_for_clock_gate_cnt;
input   [6:0]           r_rx_asn_wait_for_pma_pcie_sw_done_cnt;
input		        r_rx_stop_write;
input		        r_rx_stop_read;
input                   r_rx_internal_clk1_sel0;
input                   r_rx_internal_clk1_sel1;
input                   r_rx_internal_clk1_sel2;
input                   r_rx_internal_clk1_sel3;
input                   r_rx_txfiford_pre_ct_sel;
input                   r_rx_txfiford_post_ct_sel;
input                   r_rx_txfifowr_post_ct_sel;
input                   r_rx_txfifowr_from_aib_sel;
input                   r_rx_internal_clk2_sel0;
input                   r_rx_internal_clk2_sel1;
input                   r_rx_internal_clk2_sel2;
input                   r_rx_internal_clk2_sel3;
input                   r_rx_rxfifowr_pre_ct_sel;
input                   r_rx_rxfifowr_post_ct_sel;
input                   r_rx_rxfiford_post_ct_sel;
input                   r_rx_rxfiford_to_aib_sel;
input [2:0]             r_rx_chnl_datapath_map_mode;
input [2:0]             r_rx_pcs_testbus_sel;
input                   r_rx_async_hip_en;  
input [1:0]             r_rx_parity_sel;  
input [7:0]		r_rx_comp_cnt;		// To c3adapt_rxdp of c3adapt_rxdp.v
input [1:0]		r_rx_compin_sel;	// To c3adapt_rxdp of c3adapt_rxdp.v
input			r_rx_double_write;	// To c3adapt_rxdp of c3adapt_rxdp.v
input			r_rx_ds_bypass_pipeln;	// To c3adapt_rxdp of c3adapt_rxdp.v
input			r_rx_ds_master;		// To c3adapt_rxdp of c3adapt_rxdp.v
input			r_rx_dyn_clk_sw_en;	// To c3adapt_rxclk_ctl of c3adapt_rxclk_ctl.v
input [4:0]		r_rx_fifo_empty;	// To c3adapt_rxdp of c3adapt_rxdp.v
input [4:0]		r_rx_fifo_full;		// To c3adapt_rxdp of c3adapt_rxdp.v
input [1:0]		r_rx_fifo_mode;		// To c3adapt_rxdp of c3adapt_rxdp.v
input [4:0]		r_rx_fifo_pempty;	// To c3adapt_rxdp of c3adapt_rxdp.v
input [4:0]		r_rx_fifo_pfull;	// To c3adapt_rxdp of c3adapt_rxdp.v
input			r_rx_fifo_rd_clk_scg_en;// To c3adapt_rxclk_ctl of c3adapt_rxclk_ctl.v
input [2:0]		r_rx_fifo_rd_clk_sel;	// To c3adapt_rxclk_ctl of c3adapt_rxclk_ctl.v
input			r_rx_fifo_wr_clk_scg_en;// To c3adapt_rxclk_ctl of c3adapt_rxclk_ctl.v
input [2:0]		r_rx_fifo_wr_clk_sel;	// To c3adapt_rxclk_ctl of c3adapt_rxclk_ctl.v
input			r_rx_pma_coreclkin_sel;
input   		r_rx_txeq_clk_sel;
input			r_rx_txeq_clk_scg_en;
input			r_rx_force_align;	// To c3adapt_rxdp of c3adapt_rxdp.v
input			r_rx_free_run_div_clk;	// To c3adapt_rxrst_ctl of c3adapt_rxrst_ctl.v
input			r_rx_txeq_rst_sel;
input			r_rx_indv;		// To c3adapt_rxdp of c3adapt_rxdp.v
input [3:0]		r_rx_internal_clk1_sel;	// To c3adapt_rxclk_ctl of c3adapt_rxclk_ctl.v
input [3:0]		r_rx_internal_clk2_sel;	// To c3adapt_rxclk_ctl of c3adapt_rxclk_ctl.v
input [3:0]		r_rx_mask_del;		// To c3adapt_rxdp of c3adapt_rxdp.v
input			r_rx_osc_clk_scg_en;	// To c3adapt_rxclk_ctl of c3adapt_rxclk_ctl.v
input [2:0]		r_rx_phcomp_rd_delay;	// To c3adapt_rxdp of c3adapt_rxdp.v
input			r_rx_pma_hclk_scg_en;	// To c3adapt_rxclk_ctl of c3adapt_rxclk_ctl.v
input [39:0]            rx_pma_data;

input wire              r_rx_txeq_en;
input wire              r_rx_rxeq_en;
input wire              r_rx_pre_cursor_en;
input wire              r_rx_post_cursor_en;
input wire              r_rx_invalid_no_change;
input wire              r_rx_adp_go_b4txeq_en;
input wire              r_rx_use_rxvalid_for_rxeq;
input wire              r_rx_pma_rstn_en;

input wire              r_rx_pma_rstn_cycles;
input wire [7:0]        r_rx_txeq_time;        // unit is 1us for 8'h100 cycles
input wire [1:0]        r_rx_eq_iteration;     //

input wire [12:0]	oaibdftdll2core;
input wire [19:0]	avmm_testbus;
input wire [19:0]	tx_chnl_testbus;

input			r_rx_us_bypass_pipeln;	// To c3adapt_rxdp of c3adapt_rxdp.v
input			r_rx_us_master;		// To c3adapt_rxdp of c3adapt_rxdp.v
input			r_rx_wm_en;		// To c3adapt_rxdp of c3adapt_rxdp.v
input  [1:0]	        r_rx_fifo_power_mode;
input  [2:0]	        r_rx_stretch_num_stages; 
input                   r_rx_rmfflag_stretch_enable; 
input  [3:0]	        r_rx_datapath_tb_sel; 
input  		        r_rx_wr_adj_en;
input                   r_rx_rd_adj_en;
input                   r_rx_msb_rdptr_pipe_byp;
input  [1:0]            r_rx_adapter_lpbk_mode;
input			r_rx_aib_lpbk_en;
input                   r_rx_pld_8g_a1a2_k1k2_flag_polling_bypass;
input                   r_rx_10g_krfec_rx_diag_data_status_polling_bypass;
input                   r_rx_pld_8g_wa_boundary_polling_bypass;
input                   r_rx_pcspma_testbus_sel;
input                   r_rx_pld_pma_pcie_sw_done_polling_bypass;
input                   r_rx_pld_pma_reser_in_polling_bypass;
input                   r_rx_pld_pma_testbus_polling_bypass;
input                   r_rx_pld_test_data_polling_bypass;
input [2:0]		rx_async_fabric_hssi_fsr_data;
input			rx_async_fabric_hssi_fsr_load;
input [35:0]		rx_async_fabric_hssi_ssr_data;
input			rx_async_fabric_hssi_ssr_load;
input			rx_async_hssi_fabric_fsr_load;
input			rx_async_hssi_fabric_ssr_load;
input [1:0]		rx_pld_rate;
input			txeq_rxeqeval;
input			txeq_rxeqinprogress;
input                   sr_fabric_tx_transfer_en;
input                   r_rx_hrdrst_rst_sm_dis;
input                   r_rx_hrdrst_dcd_cal_done_bypass;
input [2:0]             r_rx_rmfflag_stretch_num_stages;
input                   r_rx_hrdrst_rx_osc_clk_scg_en;
input			r_rx_ds_last_chnl;
input			r_rx_us_last_chnl;
input                   txeq_txdetectrx;
input [5:0]             sr_parity_error_flag;
input			avmm_transfer_error;
input [1:0]             txeq_rate;
input [1:0]             txeq_powerdown;
input [1:0]             rx_async_fabric_hssi_ssr_reserved;
input                   xcvrif_rx_latency_pls;
output                  xcvrif_sclk;
output                  rx_chnl_fifo_sclk;
output [1:0]            rx_async_hssi_fabric_ssr_reserved;   
output			aib_hssi_pld_8g_rxelecidle;
output			aib_rx_pma_div2_clk;
output			aib_rx_pma_div66_clk;
output			aib_hssi_pld_pma_hclk;
output			aib_hssi_pld_pma_internal_clk1;
output			aib_hssi_pld_pma_internal_clk2;
output			aib_hssi_pld_pma_rxpll_lock;
output			aib_hssi_rx_fifo_latency_pls;
output [39:0]		aib_hssi_rx_data_out;
output			aib_hssi_rx_transfer_clk;
output			aib_hssi_rx_dcd_cal_req;
output			pld_10g_krfec_rx_clr_errblk_cnt;
output			usr_rx_elane_rst_n;
output			pld_10g_rx_clr_ber_count;
output			pld_8g_a1a2_size;
output			pld_8g_bitloc_rev_en;
output			pld_8g_byte_rev_en;
output [2:0]		pld_8g_eidleinfersel;
output			pld_8g_encdt;
output			pld_bitslip;
output			pld_ltr;
output			pld_pma_adapt_start;
output			pld_pma_coreclkin;
output			pld_pma_early_eios;
output [5:0]		pld_pma_eye_monitor;
output			pld_pma_ltd_b;
output [1:0]		pld_pma_pcie_switch;
output			pld_pma_ppm_lock;
output [4:0]		pld_pma_reserved_out;
output			pld_pma_rs_lpbk_b;
output			pld_pma_rxpma_rstb;
output			pld_pmaif_rxclkslip;
output			pld_polinv_rx;
output			pld_rx_prbs_err_clr;
output			pld_syncsm_en;
output			rx_asn_fifo_hold;
output [2:0]            pld_g3_current_rxpreset;
output [1:0]		rx_asn_rate;
output			rx_asn_rate_change_in_progress;
output			rx_asn_dll_lock_en;
output [1:0]		rx_async_hssi_fabric_fsr_data;
output [62:0]		rx_async_hssi_fabric_ssr_data;
output                  aib_hssi_pld_pma_pfdmode_lock;
output                  tx_direct_transfer_testbus;

output [2:0]		hip_init_status;
output 			rx_asn_clk_en;
output 			rx_asn_gen3_sel;

output [7:0]            rx_chnl_dprio_status;
output                  rx_chnl_dprio_status_write_en_ack;
input                   rx_chnl_dprio_status_write_en;

input  [79:0]	        tx_fifo_data_lpbk;
input  [39:0]		aib_hssi_tx_data_lpbk;
input  [39:0]           tx_pma_data_lpbk;

output [2:0]            rx_fsr_parity_checker_in;
output [37:0]           rx_ssr_parity_checker_in;

output                  sr_pld_latency_pulse_sel;
output [3:0]            rx_hrdrst_tb_direct;

wire  [2:0]		hip_init_status;
wire  [2:0]             hip_init_status_sync;
wire  [19:0]            rx_fifo_testbus1; 
wire  [19:0]            rx_fifo_testbus2;
wire  [19:0]            rx_cp_bond_testbus;
wire  [19:0]            rx_asn_testbus1;
wire  [19:0]            rx_asn_testbus2;
wire  [19:0]            txeq_testbus1;
wire  [19:0]            txeq_testbus2;
wire  [19:0]            rx_hrdrst_testbus;
wire  [19:0]            rx_chnl_testbus;
wire  [1:0]             rx_direct_transfer_testbus;

reg   [39:0]		aib_hssi_tx_data_lpbk_reg;
wire                    rx_clock_reset_fifo_rd_clk;
wire                    rx_reset_fifo_rd_rst_n;
wire                    rx_fifo_ready;
wire [39:0]             aib_hssi_rx_data_out_int;

wire			fifo_empty;
wire			fifo_full;
wire                    fifo_full_sync;
wire			rx_clock_reset_hrdrst_rx_osc_clk;
wire			rx_clock_reset_fifo_wr_clk;
wire			rx_clock_fifo_sclk;
wire			rx_clock_reset_txeq_clk;
wire			rx_clock_reset_asn_pma_hclk;
wire			rx_clock_reset_async_rx_osc_clk;
wire			rx_clock_reset_async_tx_osc_clk;
wire			rx_clock_pld_pma_hclk;
wire			rx_clock_hrdrst_rx_osc_clk;
wire			rx_clock_asn_pma_hclk;
wire			rx_clock_async_rx_osc_clk;
wire			rx_clock_async_tx_osc_clk;
wire			rx_clock_fifo_rd_clk;
wire			rx_clock_fifo_wr_clk;
wire			q1_rx_clock_fifo_wr_clk;
wire			q2_rx_clock_fifo_wr_clk;
wire			q3_rx_clock_fifo_wr_clk;
wire			q4_rx_clock_fifo_wr_clk;
wire			rx_clock_txeq_clk;
wire			rx_reset_asn_pma_hclk_rst_n;
wire			rx_reset_async_rx_osc_clk_rst_n;
wire			rx_reset_async_tx_osc_clk_rst_n;
wire			rx_reset_fifo_sclk_rst_n;
wire			rx_reset_fifo_wr_rst_n;
wire			rx_reset_txeq_clk_rst_n;
wire			wr_align_clr;
wire			rx_hrdrst_rx_fifo_srst;
wire			rx_hrdrst_hssi_rx_dcd_cal_done;
wire			rx_hrdrst_hssi_rx_transfer_en;
wire			rx_hrdrst_asn_data_transfer_en;
wire                    sr_fabric_rx_dll_lock;
wire                    sr_pld_rx_dll_lock_req;
wire                    sr_fabric_rx_transfer_en;
wire                    pld_rx_fifo_latency_adj_en;
wire                    sr_aib_hssi_rx_dcd_cal_req;
wire                    aib_hssi_rx_dcd_cal_done;
wire                    sr_pld_rx_fifo_srst;
wire                    sr_pld_rx_asn_data_transfer_en;

wire                    pma_adapt_rstn;
wire [2:0]              pld_g3_current_rxpreset;
wire                    rx_ehip_early_clk;
wire                    rx_elane_early_clk;
wire                    rx_rsfec_early_clk;
wire                    rx_pma_early_clk;
wire                    rx_ehip_rst_n;
wire                    rx_elane_rst_n;
wire                    rx_rsfec_rst_n;
wire                    rx_pma_rst_n;
wire [3:0]              rx_hrdrst_tb_direct;


// Send to TX Channel
assign rx_chnl_fifo_sclk = rx_clock_fifo_sclk;

// Unused bits
assign rx_chnl_dprio_status[7:6] = 2'b00;

// Add pipeline to loopback path
//assign aib_hssi_rx_data_out = r_rx_aib_lpbk_en ? aib_hssi_tx_data_lpbk : aib_hssi_rx_data_out_int;
// loop TX data (before TX FIFO) back to AIB
assign aib_hssi_rx_data_out = (r_rx_aib_lpbk_en & (r_rx_adapter_lpbk_mode == 2'b11)) ? aib_hssi_tx_data_lpbk_reg : aib_hssi_rx_data_out_int;

always @(negedge rx_reset_fifo_rd_rst_n or posedge rx_clock_reset_fifo_rd_clk) begin
   if (rx_reset_fifo_rd_rst_n == 1'b0)
      aib_hssi_tx_data_lpbk_reg <= 40'd0;
   else
      if (r_rx_aib_lpbk_en) aib_hssi_tx_data_lpbk_reg <= aib_hssi_tx_data_lpbk;
      else aib_hssi_tx_data_lpbk_reg <= aib_hssi_tx_data_lpbk_reg;
end      

//repurposed to select source of latency pulse
assign sr_pld_latency_pulse_sel = sr_pld_rx_asn_data_transfer_en;

c3aibadapt_rxdp rx_datapath (/*AUTOINST*/
  // Outputs
  .pld_g3_current_rxpreset                (pld_g3_current_rxpreset),
  .pma_adapt_rstn                         (pma_adapt_rstn),
  .aib_hip_txeq_in                        (/*NC*/),
  .aib_hssi_rx_data_out	                  (aib_hssi_rx_data_out_int[40-1:0]),
  .fifo_empty		                  (fifo_empty),
  .fifo_full		                  (fifo_full),
  .rx_asn_fifo_hold	                  (rx_asn_fifo_hold),
  .rx_asn_rate_change_in_progress         (rx_asn_rate_change_in_progress),
  .rx_asn_dll_lock_en                     (rx_asn_dll_lock_en),
  .rx_asn_clk_en                          (rx_asn_clk_en),
  .rx_asn_gen3_sel	                  (rx_asn_gen3_sel),
  .rx_asn_rate		                  (rx_asn_rate[1:0]),
  .aib_hssi_rx_fifo_latency_pls           (aib_hssi_rx_fifo_latency_pls),
  .rx_fifo_ready	                  (rx_fifo_ready),
  .rx_fifo_testbus1	                  (rx_fifo_testbus1),
  .rx_fifo_testbus2 	                  (rx_fifo_testbus2), 
  .rx_cp_bond_testbus	                  (rx_cp_bond_testbus),
  .rx_asn_testbus1	                  (rx_asn_testbus1),
  .rx_asn_testbus2	                  (rx_asn_testbus2),
  .txeq_testbus1		          (txeq_testbus1),
  .txeq_testbus2		          (txeq_testbus2),
  // Inputs
  .rx_ehip_clk                            (rx_ehip_early_clk),
  .rx_elane_clk                           (rx_elane_early_clk),
  .rx_rsfec_clk                           (rx_rsfec_early_clk),
  .rx_pma_clk                             (rx_pma_early_clk),
  .tx_aib_transfer_clk                    (tx_aib_transfer_clk),      // for 1x loopback where TX PMA-direct path is routed to RX PMA-direct
  .tx_aib_transfer_clk_rst_n              (tx_aib_transfer_clk_rst_n),
  .rx_ehip_rst_n                          (rx_ehip_rst_n),
  .rx_elane_rst_n                         (rx_elane_rst_n),
  .rx_rsfec_rst_n                         (rx_rsfec_rst_n),
  .rx_pma_rst_n                           (rx_pma_rst_n),
  .rx_pma_data                            (rx_pma_data),
  .tx_pma_data_lpbk                       (tx_pma_data_lpbk),
  .rx_direct_transfer_testbus             (rx_direct_transfer_testbus[0]),
  .dft_adpt_rst	                          (dft_adpt_rst),
  .pld_pma_reserved_in                    (pld_pma_reserved_in[4:1]),
  .pld_8g_rxelecidle	                  (pld_8g_rxelecidle),
  .pld_rx_prbs_done                       (pld_rx_prbs_done),
  .pld_rx_prbs_err                        (pld_rx_prbs_err),
  .sr_pld_latency_pulse_sel               (sr_pld_latency_pulse_sel),
  .rx_hrdrst_asn_data_transfer_en         (rx_hrdrst_asn_data_transfer_en),
  .rx_hrdrst_rx_fifo_srst                 (rx_hrdrst_rx_fifo_srst),
  .rx_ehip_data                           (rx_ehip_data),
  .rx_elane_data                          (rx_elane_data),
  .rx_rsfec_data                          (rx_rsfec_data),
  .rx_clock_txeq_clk                      (rx_clock_txeq_clk),
  .rx_reset_txeq_clk_rst_n                (rx_reset_txeq_clk_rst_n),
  .txeq_invalid_req                       (txeq_invalid_req),
  .txeq_txdetectrx                        (txeq_txdetectrx),
  .txeq_rate                              (txeq_rate),
  .txeq_powerdown                         (txeq_powerdown),
  .pld_pma_pcie_sw_done	                  (pld_pma_pcie_sw_done[1:0]),
  .pld_pma_rx_found	                  (pld_pma_rx_found),
  .pld_pmaif_mask_tx_pll                  (pld_pmaif_mask_tx_pll),
  .r_rx_align_del	                  (r_rx_align_del),
  .r_rx_bonding_dft_in_en                 (r_rx_bonding_dft_in_en),
  .r_rx_bonding_dft_in_value              (r_rx_bonding_dft_in_value),
  .r_rx_comp_cnt	                  (r_rx_comp_cnt[8-1:0]),
  .r_rx_compin_sel	                  (r_rx_compin_sel[1:0]),
  .r_rx_double_write	                  (r_rx_double_write),
  .r_rx_ds_bypass_pipeln                  (r_rx_ds_bypass_pipeln),
  .r_rx_ds_master	                  (r_rx_ds_master),
  .r_rx_fifo_empty	                  (r_rx_fifo_empty[5-1:0]),
  .r_rx_fifo_mode	                  (r_rx_fifo_mode[1:0]),
  .r_rx_force_align	                  (r_rx_force_align),
  .r_rx_fifo_full	                  (r_rx_fifo_full[5-1:0]),
  .r_rx_indv		                  (r_rx_indv),
  .r_rx_mask_del	                  (r_rx_mask_del[3:0]),
  .r_rx_fifo_pempty	                  (r_rx_fifo_pempty[5-1:0]),
  .r_rx_fifo_pfull	                  (r_rx_fifo_pfull[5-1:0]),
  .r_rx_phcomp_rd_delay	                  (r_rx_phcomp_rd_delay[2:0]),
  .r_rx_ds_last_chnl                      (1'b0),
  .r_rx_us_last_chnl                      (1'b0),

  .bond_rx_asn_ds_in_fifo_hold            (1'b0),
  .bond_rx_asn_ds_in_clk_en               (1'b0),
  .bond_rx_asn_ds_in_gen3_sel             (1'b0),
  .bond_rx_asn_us_in_fifo_hold            (1'b0),
  .bond_rx_asn_us_in_clk_en               (1'b0),
  .bond_rx_asn_us_in_gen3_sel             (1'b0),
  .r_rx_usertest_sel                      (r_rx_usertest_sel[0]),
  .r_tx_latency_src_xcvrif                (r_tx_latency_src_xcvrif),
  .r_rx_hrdrst_user_ctl_en                (r_rx_hrdrst_user_ctl_en),
  .r_rx_asn_en                            (r_rx_asn_en),
  .r_rx_slv_asn_en                        (r_rx_slv_asn_en),
  .r_rx_asn_bypass_clock_gate             (r_rx_asn_bypass_clock_gate),
  .r_rx_asn_bypass_pma_pcie_sw_done       (r_rx_asn_bypass_pma_pcie_sw_done),
  .r_rx_asn_wait_for_fifo_flush_cnt       (r_rx_asn_wait_for_fifo_flush_cnt),
  .r_rx_asn_wait_for_dll_reset_cnt        (r_rx_asn_wait_for_dll_reset_cnt),
  .r_rx_asn_wait_for_clock_gate_cnt       (r_rx_asn_wait_for_clock_gate_cnt),
  .r_rx_asn_wait_for_pma_pcie_sw_done_cnt (r_rx_asn_wait_for_pma_pcie_sw_done_cnt),
  .r_rx_chnl_datapath_map_mode            (r_rx_chnl_datapath_map_mode),
  .r_rx_txeq_en                           (r_rx_txeq_en),
  .r_rx_rxeq_en                           (r_rx_rxeq_en),
  .r_rx_pre_cursor_en                     (r_rx_pre_cursor_en),
  .r_rx_post_cursor_en                    (r_rx_post_cursor_en),
  .r_rx_invalid_no_change                 (r_rx_invalid_no_change),
  .r_rx_adp_go_b4txeq_en                  (r_rx_adp_go_b4txeq_en),
  .r_rx_use_rxvalid_for_rxeq              (r_rx_use_rxvalid_for_rxeq),
  .r_rx_pma_rstn_en                       (r_rx_pma_rstn_en),
  .r_rx_pma_rstn_cycles                   (r_rx_pma_rstn_cycles),

  .r_rx_txeq_time                         (r_rx_txeq_time[7:0]),
  .r_rx_eq_iteration                      (r_rx_eq_iteration[1:0]),
  .r_rx_stop_read	                  (r_rx_stop_read),
  .r_rx_stop_write	                  (r_rx_stop_write),
  .r_rx_us_bypass_pipeln                  (r_rx_us_bypass_pipeln),
  .r_rx_us_master	                  (r_rx_us_master),
  .r_rx_wm_en		                  (r_rx_wm_en),
  // .r_rx_write_ctrl	                  (r_rx_write_ctrl),
  .r_rx_fifo_power_mode			  (r_rx_fifo_power_mode),
  .r_rx_stretch_num_stages		  (r_rx_stretch_num_stages), 	
  // .r_rx_datapath_tb_sel 		  (r_rx_datapath_tb_sel), 
  .r_rx_wr_adj_en 			  (r_rx_wr_adj_en), 
  .r_rx_rd_adj_en			  (r_rx_rd_adj_en),
  .r_rx_msb_rdptr_pipe_byp                (r_rx_msb_rdptr_pipe_byp),
  .r_rx_aib_lpbk_en                       (r_rx_aib_lpbk_en),
  .r_rx_adapter_lpbk_mode		  (r_rx_adapter_lpbk_mode),
  .rx_fifo_latency_adj_en                 (pld_rx_fifo_latency_adj_en),		//Driven by SSR
  .xcvrif_rx_latency_pls                  (xcvrif_rx_latency_pls),
  .tx_fifo_data_lpbk			  (tx_fifo_data_lpbk),
  .rx_clock_asn_pma_hclk                  (rx_clock_asn_pma_hclk),
  .rx_clock_fifo_wr_clk	                  (rx_clock_fifo_wr_clk),
  .q1_rx_clock_fifo_wr_clk                (q1_rx_clock_fifo_wr_clk),
  .q2_rx_clock_fifo_wr_clk                (q2_rx_clock_fifo_wr_clk), 
  .q3_rx_clock_fifo_wr_clk                (q3_rx_clock_fifo_wr_clk),  
  .q4_rx_clock_fifo_wr_clk                (q4_rx_clock_fifo_wr_clk),   
  .rx_pld_rate		                  (rx_pld_rate[1:0]),
  .rx_reset_asn_pma_hclk_rst_n            (rx_reset_asn_pma_hclk_rst_n),
  .rx_reset_fifo_wr_rst_n                 (rx_reset_fifo_wr_rst_n),
  .txeq_rxeqeval	                  (txeq_rxeqeval),
  .txeq_rxeqinprogress	                  (txeq_rxeqinprogress),
  .wr_align_clr		                  (wr_align_clr),
  .rx_clock_fifo_rd_clk	                  (rx_clock_fifo_rd_clk),
  .rx_clock_fifo_sclk	                  (rx_clock_fifo_sclk),
  .rx_reset_fifo_rd_rst_n                 (rx_reset_fifo_rd_rst_n),
  .rx_reset_fifo_sclk_rst_n               (rx_reset_fifo_sclk_rst_n),
  .bond_rx_fifo_ds_in_rden                (1'b0),
  .bond_rx_fifo_ds_in_wren                (1'b0),
  .bond_rx_fifo_us_in_rden                (1'b0),
  .bond_rx_fifo_us_in_wren                (1'b0));

c3aibadapt_rxasync rx_async(/*AUTOINST*/
  // Outputs
  .rx_async_hssi_fabric_ssr_reserved                  (rx_async_hssi_fabric_ssr_reserved),
  .aib_hssi_pld_8g_rxelecidle                         (aib_hssi_pld_8g_rxelecidle),
  .aib_hssi_pld_pma_rxpll_lock                        (aib_hssi_pld_pma_rxpll_lock),
  .pld_10g_krfec_rx_clr_errblk_cnt                    (pld_10g_krfec_rx_clr_errblk_cnt),
  // .pld_10g_rx_align_clr                               (pld_10g_rx_align_clr),
  .pld_10g_rx_clr_ber_count                           (pld_10g_rx_clr_ber_count),
  .pld_8g_a1a2_size	                              (pld_8g_a1a2_size),
  .pld_8g_bitloc_rev_en                               (pld_8g_bitloc_rev_en),
  .pld_8g_byte_rev_en	                              (pld_8g_byte_rev_en),
  .pld_8g_eidleinfersel                               (pld_8g_eidleinfersel[2:0]),
  .pld_8g_encdt	                                      (pld_8g_encdt),
  .pld_bitslip	                                      (pld_bitslip),
  .pld_ltr		                              (pld_ltr),
  .pld_pma_adapt_start                                (pld_pma_adapt_start),
  .pld_pma_early_eios	                              (pld_pma_early_eios),
  .pld_pma_eye_monitor                                (pld_pma_eye_monitor[5:0]),
  .pld_pma_ltd_b	                              (pld_pma_ltd_b),
  .pld_pma_pcie_switch                                (pld_pma_pcie_switch[1:0]),
  .pld_pma_ppm_lock	                              (pld_pma_ppm_lock),
  .pld_pma_reserved_out                               (pld_pma_reserved_out[4:0]),
  .pld_pma_rs_lpbk_b	                              (pld_pma_rs_lpbk_b),
  .pld_pmaif_rxclkslip                                (pld_pmaif_rxclkslip),
  .pld_polinv_rx	                              (pld_polinv_rx),
  .pld_rx_prbs_err_clr                                (pld_rx_prbs_err_clr),
  .pld_syncsm_en	                              (pld_syncsm_en),
  .pld_rx_fifo_latency_adj_en                         (pld_rx_fifo_latency_adj_en),
  .wr_align_clr	                                      (wr_align_clr),
  .rx_async_hssi_fabric_fsr_data                      (rx_async_hssi_fabric_fsr_data[1:0]),
  .rx_async_hssi_fabric_ssr_data                      (rx_async_hssi_fabric_ssr_data[62:0]),
  .sr_fabric_rx_dll_lock                              (sr_fabric_rx_dll_lock),
  .sr_pld_rx_dll_lock_req                             (sr_pld_rx_dll_lock_req),
  .sr_fabric_rx_transfer_en                           (sr_fabric_rx_transfer_en),
  .sr_aib_hssi_rx_dcd_cal_req                         (sr_aib_hssi_rx_dcd_cal_req),
  .aib_hssi_pld_pma_pfdmode_lock                      (aib_hssi_pld_pma_pfdmode_lock),
  .rx_fsr_parity_checker_in                           (rx_fsr_parity_checker_in),
  .rx_ssr_parity_checker_in                           (rx_ssr_parity_checker_in),
  .sr_pld_rx_fifo_srst                                (sr_pld_rx_fifo_srst),
  .sr_pld_rx_asn_data_transfer_en                     (sr_pld_rx_asn_data_transfer_en),
  // Inputs
  .rx_fifo_ready	                              (rx_fifo_ready),
  .rx_direct_transfer_testbus                         (rx_direct_transfer_testbus[1]),
  .sr_parity_error_flag                               (sr_parity_error_flag),
  .avmm_transfer_error                                (avmm_transfer_error),
  .pld_pma_pfdmode_lock                               (pld_pma_pfdmode_lock),
  .pld_pma_rx_found	                              (pld_pma_rx_found),
  .dft_adpt_rst	                                      (dft_adpt_rst),
  .pma_adapt_rstn                                     (pma_adapt_rstn),
  .r_rx_usertest_sel                                  (r_rx_usertest_sel[1]),
  .r_rx_rxeq_en                                       (r_rx_rxeq_en),
  .r_rx_async_pld_ltr_rst_val                         (r_rx_async_pld_ltr_rst_val),
  .r_rx_async_pld_pma_ltd_b_rst_val                   (r_rx_async_pld_pma_ltd_b_rst_val),
  .r_rx_async_pld_8g_signal_detect_out_rst_val        (r_rx_async_pld_8g_signal_detect_out_rst_val),
  .r_rx_async_pld_10g_rx_crc32_err_rst_val            (r_rx_async_pld_10g_rx_crc32_err_rst_val),
  .r_rx_async_pld_rx_fifo_align_clr_rst_val           (r_rx_async_pld_rx_fifo_align_clr_rst_val),
  .r_rx_async_hip_en                                  (r_rx_async_hip_en),
  .r_rx_parity_sel                                    (r_rx_parity_sel),
  .r_rx_pld_8g_a1a2_k1k2_flag_polling_bypass          (r_rx_pld_8g_a1a2_k1k2_flag_polling_bypass),
  .r_rx_10g_krfec_rx_diag_data_status_polling_bypass  (r_rx_10g_krfec_rx_diag_data_status_polling_bypass),
  .r_rx_pld_8g_wa_boundary_polling_bypass             (r_rx_pld_8g_wa_boundary_polling_bypass),
  .r_rx_pld_pma_pcie_sw_done_polling_bypass           (r_rx_pld_pma_pcie_sw_done_polling_bypass),
  .r_rx_pld_pma_reser_in_polling_bypass               (r_rx_pld_pma_reser_in_polling_bypass),
  .r_rx_pld_pma_testbus_polling_bypass                (r_rx_pld_pma_testbus_polling_bypass),
  .r_rx_pld_test_data_polling_bypass                  (r_rx_pld_test_data_polling_bypass),
  .r_rx_rmfflag_stretch_num_stages                    (r_rx_rmfflag_stretch_num_stages),
  .r_rx_rmfflag_stretch_enable                        (r_rx_rmfflag_stretch_enable),
  .rx_clock_reset_fifo_rd_clk                         (rx_clock_reset_fifo_rd_clk),
  .rx_reset_fifo_rd_rst_n                             (rx_reset_fifo_rd_rst_n), // Pulse Stretch RMF
  .rx_hrdrst_hssi_rx_dcd_cal_done                     (rx_hrdrst_hssi_rx_dcd_cal_done),
  .rx_async_fabric_hssi_ssr_reserved                  (rx_async_fabric_hssi_ssr_reserved),
  .aib_hssi_rx_dcd_cal_done                           (aib_hssi_rx_dcd_cal_done),
  .pld_10g_krfec_rx_blk_lock                          (pld_10g_krfec_rx_blk_lock),
  .pld_10g_krfec_rx_diag_data_status                  (pld_10g_krfec_rx_diag_data_status[1:0]),
  .pld_10g_krfec_rx_frame                             (pld_10g_krfec_rx_frame),
  .pld_10g_rx_crc32_err                               (pld_10g_rx_crc32_err),
  .pld_10g_rx_frame_lock                              (pld_10g_rx_frame_lock),
  .pld_10g_rx_hi_ber	                              (pld_10g_rx_hi_ber),
  .pld_8g_a1a2_k1k2_flag                              (pld_8g_a1a2_k1k2_flag[3:0]),
  .pld_8g_empty_rmf	                              (pld_8g_empty_rmf),
  .pld_8g_full_rmf	                              (pld_8g_full_rmf),
  .pld_8g_rxelecidle	                              (pld_8g_rxelecidle),
  .pld_8g_signal_detect_out                           (pld_8g_signal_detect_out),
  .pld_8g_wa_boundary	                              (pld_8g_wa_boundary[4:0]),
  .pld_pma_adapt_done	                              (pld_pma_adapt_done),
  .pld_pma_pcie_sw_done                               (pld_pma_pcie_sw_done[1:0]),
  .pld_pma_reserved_in                                (pld_pma_reserved_in[4:0]),
  .pld_pma_rx_detect_valid                            (pld_pma_rx_detect_valid),
  .pld_pma_rxpll_lock	                              (pld_pma_rxpll_lock),
  .pld_pma_signal_ok	                              (pld_pma_signal_ok),
  .pld_pma_testbus	                              (pld_pma_testbus[7:0]),
  .pld_rx_prbs_done	                              (pld_rx_prbs_done),
  .pld_rx_prbs_err	                              (pld_rx_prbs_err),
  .pld_test_data	                              (rx_chnl_testbus),
  .hip_aib_async_out                                  (pld_8g_rxelecidle),
  .rx_clock_async_rx_osc_clk                          (rx_clock_async_rx_osc_clk),
  .rx_clock_async_tx_osc_clk                          (rx_clock_async_tx_osc_clk),
  .rx_reset_async_rx_osc_clk_rst_n                    (rx_reset_async_rx_osc_clk_rst_n),
  .rx_reset_async_tx_osc_clk_rst_n                    (rx_reset_async_tx_osc_clk_rst_n),
  .fifo_empty		                              (fifo_empty),
  .fifo_full		                              (fifo_full),
  .rx_async_fabric_hssi_fsr_data                      (rx_async_fabric_hssi_fsr_data[2:0]),
  .rx_async_fabric_hssi_fsr_load                      (rx_async_fabric_hssi_fsr_load),
  .rx_async_fabric_hssi_ssr_data                      (rx_async_fabric_hssi_ssr_data[35:0]),
  .rx_async_fabric_hssi_ssr_load                      (rx_async_fabric_hssi_ssr_load),
  .rx_async_hssi_fabric_fsr_load                      (rx_async_hssi_fabric_fsr_load),
  .rx_async_hssi_fabric_ssr_load                      (rx_async_hssi_fabric_ssr_load),
  .rx_hrdrst_hssi_rx_transfer_en                      (rx_hrdrst_hssi_rx_transfer_en));

c3aibadapt_rxclk_ctl rxclk_ctl(/*AUTOINST*/
  // Outputs
  .xcvrif_sclk                           (xcvrif_sclk),
  .pld_pma_coreclkin                     (pld_pma_coreclkin),
  .rx_ehip_early_clk                     (rx_ehip_early_clk),
  .rx_elane_early_clk                    (rx_elane_early_clk),
  .rx_rsfec_early_clk                    (rx_rsfec_early_clk),
  .rx_pma_early_clk                      (rx_pma_early_clk),
  .aib_hssi_rx_transfer_clk              (aib_hssi_rx_transfer_clk),
  .aib_rx_pma_div2_clk                   (aib_rx_pma_div2_clk),
  .aib_rx_pma_div66_clk                  (aib_rx_pma_div66_clk),
  .aib_hssi_pld_pma_internal_clk1        (aib_hssi_pld_pma_internal_clk1),
  .aib_hssi_pld_pma_internal_clk2        (aib_hssi_pld_pma_internal_clk2),
  .aib_hssi_pld_pma_hclk                 (aib_hssi_pld_pma_hclk),
  .rx_clock_reset_hrdrst_rx_osc_clk      (rx_clock_reset_hrdrst_rx_osc_clk),
  .rx_clock_reset_fifo_wr_clk            (rx_clock_reset_fifo_wr_clk),
  .rx_clock_reset_fifo_rd_clk            (rx_clock_reset_fifo_rd_clk),
  .rx_clock_fifo_sclk                    (rx_clock_fifo_sclk),
  .rx_clock_reset_txeq_clk               (rx_clock_reset_txeq_clk),
  .rx_clock_reset_asn_pma_hclk           (rx_clock_reset_asn_pma_hclk),
  .rx_clock_reset_async_rx_osc_clk       (rx_clock_reset_async_rx_osc_clk),
  .rx_clock_reset_async_tx_osc_clk       (rx_clock_reset_async_tx_osc_clk),
  .rx_clock_pld_pma_hclk                 (rx_clock_pld_pma_hclk),
  .rx_clock_fifo_wr_clk                  (rx_clock_fifo_wr_clk),
  .q1_rx_clock_fifo_wr_clk               (q1_rx_clock_fifo_wr_clk),
  .q2_rx_clock_fifo_wr_clk               (q2_rx_clock_fifo_wr_clk),
  .q3_rx_clock_fifo_wr_clk               (q3_rx_clock_fifo_wr_clk),
  .q4_rx_clock_fifo_wr_clk               (q4_rx_clock_fifo_wr_clk),
  .rx_clock_fifo_rd_clk                  (rx_clock_fifo_rd_clk),
  .rx_clock_txeq_clk                     (rx_clock_txeq_clk),
  .rx_clock_asn_pma_hclk                 (rx_clock_asn_pma_hclk),
  .rx_clock_hrdrst_rx_osc_clk            (rx_clock_hrdrst_rx_osc_clk),
  .rx_clock_async_rx_osc_clk             (rx_clock_async_rx_osc_clk),
  .rx_clock_async_tx_osc_clk             (rx_clock_async_tx_osc_clk),
  // Inputs
  .scan_mode_n                           (scan_mode_n),
  .tst_tcm_ctrl                          (tst_tcm_ctrl),
  .test_clk                              (test_clk),
  .scan_clk                              (scan_clk),
  .rx_pma_div2_clk                       (rx_pma_div2_clk),
  .rx_ehip_clk                           (rx_ehip_clk),
  .rx_ehip_frd_clk                       (rx_ehip_frd_clk),
  .rx_rsfec_frd_clk                      (rx_rsfec_frd_clk),
  .rx_rsfec_clk                          (rx_rsfec_clk),
  .rx_elane_clk                          (rx_elane_clk),
  .rx_pma_div66_clk                      (rx_pma_div66_clk),
  .feedthru_clk   	                 (feedthru_clk), 
  .rx_pma_clk                            (rx_pma_clk),
  .tx_pma_clk	                         (tx_pma_clk),
  .tx_clock_fifo_rd_prect_clk            (tx_clock_fifo_rd_prect_clk),   // TX FIFO Read Clock (pre-CT)
  .aib_hssi_pld_pma_coreclkin            (aib_hssi_pld_pma_coreclkin),
  .tx_aib_transfer_clk                   (tx_aib_transfer_clk),
  .tx_aib_transfer_div2_clk              (tx_aib_transfer_div2_clk),
  .aib_hssi_rx_sr_clk_in                 (aib_hssi_rx_sr_clk_in),
  .aib_hssi_pld_sclk                     (aib_hssi_pld_sclk),
  .aib_hssi_fpll_shared_direct_async_in  (aib_hssi_fpll_shared_direct_async_in),
  .tx_clock_fifo_wr_clk                  (tx_clock_fifo_wr_clk),
  .tx_clock_fifo_rd_clk                  (tx_clock_fifo_rd_clk),
  .avmm1_clock_avmm_clk_scg              (avmm1_clock_avmm_clk_scg),
  .avmm1_clock_avmm_clk_dcg              (avmm1_clock_avmm_clk_dcg),
  .avmm2_clock_avmm_clk_scg              (avmm2_clock_avmm_clk_scg),
  .avmm2_clock_avmm_clk_dcg              (avmm2_clock_avmm_clk_dcg),
  .sr_clock_tx_sr_clk_in_div2            (sr_clock_tx_sr_clk_in_div2),
  .sr_clock_tx_sr_clk_in_div4            (sr_clock_tx_sr_clk_in_div4),
  .sr_clock_tx_osc_clk_or_clkdiv         (sr_clock_tx_osc_clk_or_clkdiv),
  .r_rx_pma_coreclkin_sel                (r_rx_pma_coreclkin_sel),
  .r_rx_fifo_wr_clk_sel                  (r_rx_fifo_wr_clk_sel[2:0]),
  .r_rx_fifo_rd_clk_sel                  (r_rx_fifo_rd_clk_sel[2:0]),
  .r_rx_dyn_clk_sw_en                    (r_rx_dyn_clk_sw_en),
  .r_rx_internal_clk1_sel                (r_rx_internal_clk1_sel[3:0]),
  .r_rx_internal_clk2_sel                (r_rx_internal_clk2_sel[3:0]),
  .r_rx_internal_clk1_sel0               (r_rx_internal_clk1_sel0),
  .r_rx_internal_clk1_sel1               (r_rx_internal_clk1_sel1),
  .r_rx_internal_clk1_sel2               (r_rx_internal_clk1_sel2),
  .r_rx_internal_clk1_sel3               (r_rx_internal_clk1_sel3),
  .r_rx_txfiford_pre_ct_sel              (r_rx_txfiford_pre_ct_sel),
  .r_rx_txfiford_post_ct_sel             (r_rx_txfiford_post_ct_sel),
  .r_rx_txfifowr_post_ct_sel             (r_rx_txfifowr_post_ct_sel),
  .r_rx_txfifowr_from_aib_sel            (r_rx_txfifowr_from_aib_sel),
  .r_rx_internal_clk2_sel0               (r_rx_internal_clk2_sel0),
  .r_rx_internal_clk2_sel1               (r_rx_internal_clk2_sel1),
  .r_rx_internal_clk2_sel2               (r_rx_internal_clk2_sel2),
  .r_rx_internal_clk2_sel3               (r_rx_internal_clk2_sel3),
  .r_rx_rxfifowr_pre_ct_sel              (r_rx_rxfifowr_pre_ct_sel),
  .r_rx_rxfifowr_post_ct_sel             (r_rx_rxfifowr_post_ct_sel),
  .r_rx_rxfiford_post_ct_sel             (r_rx_rxfiford_post_ct_sel),
  .r_rx_rxfiford_to_aib_sel              (r_rx_rxfiford_to_aib_sel),
  .r_rx_fifo_wr_clk_scg_en               (r_rx_fifo_wr_clk_scg_en),
  .r_rx_fifo_rd_clk_scg_en               (r_rx_fifo_rd_clk_scg_en),
  .r_rx_txeq_clk_scg_en                  (r_rx_txeq_clk_scg_en),
  .r_rx_pma_hclk_scg_en                  (r_rx_pma_hclk_scg_en),
  .r_rx_osc_clk_scg_en                   (r_rx_osc_clk_scg_en),
  .r_rx_hrdrst_rx_osc_clk_scg_en         (r_rx_hrdrst_rx_osc_clk_scg_en),
  .r_rx_fifo_power_mode                  (r_rx_fifo_power_mode[1:0]),
  .r_rx_bonding_dft_in_en                (r_rx_bonding_dft_in_en),
  .r_rx_bonding_dft_in_value             (r_rx_bonding_dft_in_value));

c3lib_bitsync
   #(
   .SRC_DATA_FREQ_MHZ    (500),    // Source data freq
   .DST_CLK_FREQ_MHZ     (1000),   // Dest clock freq
   .DWIDTH               (1),      // Sync Data input
   .RESET_VAL            (0)  // Reset value
   )
  rxchnl_rxfifo_full_sync
    (
     .clk      (rx_clock_fifo_rd_clk),
     .rst_n    (rx_reset_fifo_rd_rst_n),
     .data_in  (fifo_full),
     .data_out (fifo_full_sync)
     );

c3lib_bitsync
   #(
   .SRC_DATA_FREQ_MHZ    (500),    // Source data freq
   .DST_CLK_FREQ_MHZ     (1000),   // Dest clock freq
   .DWIDTH               (3),      // Sync Data input
   .RESET_VAL            (0)  // Reset value
   )
  rxchnl_rstinit_status
    (
     .clk      (rx_clock_fifo_rd_clk),
     .rst_n    (rx_reset_fifo_rd_rst_n),
     .data_in  (hip_init_status),
     .data_out (hip_init_status_sync)
     );

// Status Register
c3aibadapt_cmn_shadow_status_regs #( .DATA_WIDTH (6))
  rxchnl_shadow_status_regs0
    (
     .rst_n          (rx_reset_fifo_rd_rst_n),                             // reset
     .clk            (rx_clock_fifo_rd_clk),                               // clock
     .stat_data_in   ({fifo_full_sync, fifo_empty, rx_fifo_ready, hip_init_status_sync}),  // status data input
     .write_en       (rx_chnl_dprio_status_write_en),                      // write data enable from DPRIO
     .write_en_ack   (rx_chnl_dprio_status_write_en_ack),                  // write data enable acknowlege to DPRIO
     .stat_data_out  (rx_chnl_dprio_status[5:0])                                // status data output
     );


c3aibadapt_rxrst_ctl rxrst_ctl(
  // Outputs
  .rx_ehip_rst_n                        (rx_ehip_rst_n),
  .rx_elane_rst_n                       (rx_elane_rst_n),
  .rx_rsfec_rst_n                       (rx_rsfec_rst_n),
  .rx_pma_rst_n                         (rx_pma_rst_n),
  .pld_10g_krfec_rx_pld_rst_n           (usr_rx_elane_rst_n),
  .pld_pma_rxpma_rstb                   (pld_pma_rxpma_rstb),
  .aib_hssi_rx_dcd_cal_req              (aib_hssi_rx_dcd_cal_req),
  .rx_hrdrst_rx_fifo_srst               (rx_hrdrst_rx_fifo_srst),
  .rx_hrdrst_hssi_rx_dcd_cal_done       (rx_hrdrst_hssi_rx_dcd_cal_done),
  .rx_hrdrst_hssi_rx_transfer_en        (rx_hrdrst_hssi_rx_transfer_en),
  .rx_hrdrst_asn_data_transfer_en       (rx_hrdrst_asn_data_transfer_en),
  .hip_init_status                      (hip_init_status),
  .rx_hrdrst_testbus                    (rx_hrdrst_testbus),
  .rx_hrdrst_tb_direct                  (rx_hrdrst_tb_direct),
  .rx_reset_fifo_wr_rst_n               (rx_reset_fifo_wr_rst_n),
  .rx_reset_fifo_rd_rst_n               (rx_reset_fifo_rd_rst_n),
  .rx_reset_fifo_sclk_rst_n             (rx_reset_fifo_sclk_rst_n),
  .rx_reset_asn_pma_hclk_rst_n          (rx_reset_asn_pma_hclk_rst_n),
  .rx_reset_async_rx_osc_clk_rst_n      (rx_reset_async_rx_osc_clk_rst_n),
  .rx_reset_async_tx_osc_clk_rst_n      (rx_reset_async_tx_osc_clk_rst_n),
  .rx_reset_txeq_clk_rst_n              (rx_reset_txeq_clk_rst_n),
  // Inputs
  .dft_adpt_rst	                        (dft_adpt_rst),
  .adapter_scan_rst_n                   (adpt_scan_rst_n),
  .adapter_scan_mode_n                  (scan_mode_n),
  .csr_rdy_dly_in	                (csr_rdy_dly_in),
  .hip_aib_txeq_rst_n                   (1'b0),                            //TXEQ not supported in CR3.
  .aib_hssi_pcs_rx_pld_rst_n            (aib_hssi_pcs_rx_pld_rst_n),
  .aib_hssi_adapter_rx_pld_rst_n        (aib_hssi_adapter_rx_pld_rst_n),
  .aib_hssi_pld_pma_rxpma_rstb          (aib_hssi_pld_pma_rxpma_rstb),
  .aib_hssi_rx_dcd_cal_done             (aib_hssi_rx_dcd_cal_done),
  .avmm_hrdrst_hssi_osc_transfer_alive  (avmm_hrdrst_hssi_osc_transfer_alive),
  .sr_pld_hssi_rx_fifo_srst             (sr_pld_rx_fifo_srst),
  .sr_pld_rx_dll_lock_req               (sr_pld_rx_dll_lock_req),
  .sr_fabric_rx_dll_lock                (sr_fabric_rx_dll_lock),
  .sr_fabric_rx_transfer_en             (sr_fabric_rx_transfer_en),
  .sr_fabric_tx_transfer_en             (sr_fabric_tx_transfer_en),
  .rx_asn_rate_change_in_progress       (1'b0),
  .rx_asn_dll_lock_en                   (rx_asn_dll_lock_en),
  .sr_aib_hssi_rx_dcd_cal_req           (sr_aib_hssi_rx_dcd_cal_req),
  .rx_ehip_clk                          (rx_ehip_early_clk),
  .rx_rsfec_clk                         (rx_rsfec_early_clk),
  .rx_elane_clk                         (rx_elane_early_clk),
  .rx_pma_clk                           (rx_pma_early_clk),
  .rx_clock_reset_hrdrst_rx_osc_clk     (rx_clock_reset_hrdrst_rx_osc_clk),
  .rx_clock_reset_fifo_wr_clk           (rx_clock_reset_fifo_wr_clk),
  .rx_clock_reset_fifo_rd_clk           (rx_clock_reset_fifo_rd_clk),
  .rx_clock_fifo_sclk                   (rx_clock_fifo_sclk),
  .rx_clock_reset_txeq_clk              (rx_clock_reset_txeq_clk),
  .rx_clock_reset_asn_pma_hclk          (rx_clock_reset_asn_pma_hclk),
  .rx_clock_reset_async_rx_osc_clk      (rx_clock_reset_async_rx_osc_clk),
  .rx_clock_reset_async_tx_osc_clk      (rx_clock_reset_async_tx_osc_clk),
  .rx_clock_pld_pma_hclk                (rx_clock_pld_pma_hclk),
  .rx_clock_hrdrst_rx_osc_clk           (rx_clock_hrdrst_rx_osc_clk),
  .rx_fifo_ready	                (rx_fifo_ready),
  .rx_asn_fifo_hold	                (rx_asn_fifo_hold),
  .r_rx_free_run_div_clk                (r_rx_free_run_div_clk),
  .r_rx_txeq_rst_sel                    (1'b0),                                        //TXEQ not supported in CR3
  .r_rx_hrdrst_rst_sm_dis               (r_rx_hrdrst_rst_sm_dis),
  .r_rx_hrdrst_user_ctl_en              (r_rx_hrdrst_user_ctl_en),
  .r_rx_hrdrst_dcd_cal_done_bypass      (r_rx_hrdrst_dcd_cal_done_bypass),
  .r_rx_master_sel                      (r_rx_compin_sel[1:0]),
  .r_rx_dist_master_sel                 (r_rx_ds_master),
  .r_rx_ds_last_chnl                    (r_rx_ds_last_chnl),
  .r_rx_us_last_chnl                    (r_rx_us_last_chnl),
  .r_rx_bonding_dft_in_en               (r_rx_bonding_dft_in_en),
  .r_rx_bonding_dft_in_value            (r_rx_bonding_dft_in_value));
      
// Testbus
c3aibadapt_rxchnl_testbus rxchnl_testbus (
  .r_rx_datapath_tb_sel	      (r_rx_datapath_tb_sel),
  .r_rx_pcs_testbus_sel       (r_rx_pcs_testbus_sel),
  .r_rx_pcspma_testbus_sel    (r_rx_pcspma_testbus_sel),
  .rx_fifo_testbus1	      (rx_fifo_testbus1),
  .rx_fifo_testbus2 	      (rx_fifo_testbus2), 
  .rx_cp_bond_testbus	      (rx_cp_bond_testbus),
  .rx_hrdrst_testbus 	      (rx_hrdrst_testbus), 
  .rx_asn_testbus1	      (rx_asn_testbus1),
  .rx_asn_testbus2	      (rx_asn_testbus2),
  .txeq_testbus1	      (txeq_testbus1),
  .txeq_testbus2	      (txeq_testbus2),
  .tx_chnl_testbus	      (tx_chnl_testbus),
  .avmm_testbus		      (avmm_testbus),
  .oaibdftdll2core	      (oaibdftdll2core),
  .pld_pma_testbus            (pld_pma_testbus),
  .pld_test_data	      (pld_test_data),
  .tx_direct_transfer_testbus (tx_direct_transfer_testbus),
  .rx_direct_transfer_testbus (rx_direct_transfer_testbus),
  .rx_chnl_testbus	      (rx_chnl_testbus));



endmodule
