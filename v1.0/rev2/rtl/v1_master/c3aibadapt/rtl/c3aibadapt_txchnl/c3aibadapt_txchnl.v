// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3aibadapt_txchnl(/*AUTOARG*/
   // Outputs
   tx_fsr_parity_checker_in, tx_ssr_parity_checker_in,
   hip_fsr_parity_checker_in, hip_ssr_parity_checker_in,
   tx_async_hssi_fabric_ssr_data, tx_async_hssi_fabric_fsr_data,
   txeq_rxeqinprogress, txeq_rxeqeval, rx_pld_rate, 
   tx_aib_transfer_clk,
   tx_aib_transfer_div2_clk,
   pld_txelecidle, 
   pld_polinv_tx, pld_pma_txpma_rstb,
   pld_pma_txdetectrx, pld_pma_tx_qpi_pullup, pld_pma_tx_qpi_pulldn,
   pld_pma_tx_bitslip, pld_pma_rx_qpi_pullup,
   pld_pma_nrpi_freeze, pld_pma_fpll_up_dn_lc_lf_rstn,
   pld_pma_fpll_pfden, pld_pma_fpll_num_phase_shifts,
   pld_pma_fpll_lc_csr_test_dis, pld_pma_fpll_extswitch,
   pld_pma_fpll_cnt_sel, pld_pma_csr_test_dis,
   pld_8g_wrenable_tx,
   pld_8g_tx_boundary_sel, 
   pld_8g_g3_tx_pld_rst_n, 
   pld_10g_tx_bitslip, usr_tx_elane_rst_n,
   pcs_fpll_shared_direct_async_out, txeq_invalid_req, //hip_tx_data,
   txeq_txdetectrx, txeq_rate, txeq_powerdown,
   tx_ehip_data, hip_aib_ssr_in, hip_aib_fsr_in,
   tx_elane_data,
   tx_rsfec_data,
   tx_pma_data,
   hip_aib_async_ssr_out, hip_aib_async_fsr_out,
   tx_clock_fifo_wr_clk,tx_clock_fifo_rd_clk,
   aib_pma_aib_tx_clk, aib_pma_aib_tx_div2_clk, aib_hssi_tx_fifo_latency_pls,
   aib_tx_pma_div66_clk,
   /*aib_hssi_pld_pcs_tx_clk_out,*/ aib_hssi_fpll_shared_direct_async_out,
   aib_hssi_tx_dcd_cal_req, aib_hssi_tx_dll_lock_req,
   tx_chnl_dprio_status, tx_chnl_dprio_status_write_en_ack, tx_async_hssi_fabric_ssr_reserved,
   tx_clock_fifo_rd_prect_clk,
   tx_aib_transfer_clk_rst_n,
   // Inputs
   scan_mode_n,
   t0_tst_tcm_ctrl,
   t0_test_clk,
   t0_scan_clk,
   t1_tst_tcm_ctrl,
   t1_test_clk,
   t1_scan_clk,
   t2_tst_tcm_ctrl,
   t2_test_clk,
   t2_scan_clk,
   dft_adpt_rst, adpt_scan_rst_n, adpt_scan_mode_n,
   tx_direct_transfer_testbus,
   avmm_hrdrst_hssi_osc_transfer_alive, tx_async_fabric_hssi_ssr_reserved,
   tx_async_hssi_fabric_ssr_load, tx_async_hssi_fabric_fsr_load,
   tx_async_fabric_hssi_ssr_load, tx_async_fabric_hssi_ssr_data,
   tx_async_fabric_hssi_fsr_load, tx_async_fabric_hssi_fsr_data,
   tx_ehip_clk, tx_rsfec_clk, tx_elane_clk,
   sr_pld_latency_pulse_sel,
   rx_asn_fifo_hold, 
   rx_asn_rate_change_in_progress, rx_asn_dll_lock_en,
   r_tx_wa_en, r_tx_us_master, r_tx_us_bypass_pipeln, r_tx_stop_write,
   r_tx_stop_read, r_tx_phcomp_rd_delay, r_tx_fifo_power_mode, r_tx_wren_fastbond,
   r_tx_osc_clk_scg_en, r_tx_indv,  r_tx_qpi_sr_enable, r_tx_usertest_sel, r_rstctl_tx_pld_div2_rst_opt,
   r_tx_latency_src_xcvrif,
   r_tx_ds_last_chnl, r_tx_us_last_chnl,
   r_tx_free_run_div_clk, r_tx_fifo_wr_clk_scg_en,
   r_tx_fifo_rd_clk_sel, r_tx_fifo_rd_clk_scg_en, r_tx_fifo_pfull,
   r_tx_fifo_pempty, r_tx_fifo_mode, r_tx_fifo_full, r_tx_fifo_empty,
   r_tx_dyn_clk_sw_en, r_tx_ds_master, r_tx_ds_bypass_pipeln,
   r_tx_double_read, r_tx_compin_sel, r_tx_comp_cnt,
   r_tx_chnl_datapath_map_txqpi_pullup_init_val,
   r_tx_chnl_datapath_map_txqpi_pulldn_init_val,
   r_tx_chnl_datapath_map_rxqpi_pullup_init_val,
   r_tx_chnl_datapath_map_mode, r_tx_bonding_dft_in_value,
   r_tx_bonding_dft_in_en, r_tx_async_pld_txelecidle_rst_val,
   r_tx_async_pld_pmaif_mask_tx_pll_rst_val,
   r_tx_async_hip_aib_fsr_out_bit3_rst_val,
   r_tx_async_hip_aib_fsr_out_bit2_rst_val,
   r_tx_async_hip_aib_fsr_out_bit1_rst_val,
   r_tx_async_hip_aib_fsr_out_bit0_rst_val,
   r_tx_async_hip_aib_fsr_in_bit3_rst_val,
   r_tx_async_hip_aib_fsr_in_bit2_rst_val,
   r_tx_async_hip_aib_fsr_in_bit1_rst_val,
   r_tx_async_hip_aib_fsr_in_bit0_rst_val, 
   tx_pma_clk, pld_pmaif_mask_tx_pll,
   pld_pma_fpll_phase_done,
   pld_pma_fpll_clksel, pld_pma_fpll_clk1bad, pld_pma_fpll_clk0bad,
   pld_pma_div66_clk, pld_krfec_tx_alignment,
   pcs_fpll_shared_direct_async_in, 
   hip_aib_ssr_out, hip_aib_fsr_out, 
   hip_aib_async_ssr_in, hip_aib_async_fsr_in,
   csr_rdy_dly_in, 
   aib_hssi_tx_dcd_cal_done, aib_hssi_tx_dll_lock,
   aib_hssi_tx_transfer_clk, aib_hssi_tx_data_in, aib_hssi_rx_sr_clk_in,
   aib_hssi_pld_sclk, aib_hssi_pld_pma_txpma_rstb,
   aib_hssi_pld_pma_txdetectrx, aib_hssi_pcs_tx_pld_rst_n,
   sr_clock_tx_osc_clk_or_clkdiv, aib_hssi_fpll_shared_direct_async_in,
   aib_hssi_adapter_tx_pld_rst_n, tx_chnl_dprio_status_write_en, r_tx_hrdrst_rst_sm_dis, r_tx_hrdrst_dcd_cal_done_bypass,
   r_tx_hrdrst_dll_lock_bypass, r_tx_hrdrst_align_bypass, r_tx_hrdrst_user_ctl_en,
   r_tx_presethint_bypass, r_tx_hrdrst_rx_osc_clk_scg_en, r_tx_hip_osc_clk_scg_en,
   sr_fabric_tx_transfer_en,
   r_tx_stretch_num_stages,
   r_tx_datapath_tb_sel, 
   r_tx_wr_adj_en, 
   r_tx_rd_adj_en,
   r_tx_dv_gating_en,
   r_tx_rev_lpbk,
   tx_fifo_data_lpbk,
   xcvrif_tx_latency_pls,
   aib_hssi_tx_data_lpbk,
   tx_pma_data_lpbk,
   pld_g3_current_rxpreset,
   tx_chnl_testbus,
   tx_hrdrst_tb_direct,
   aib_hssi_rx_data_out
   );


// Beginning of automatic inputs (from unused autoinst inputs)
input            scan_mode_n;
input [6:0]      t0_tst_tcm_ctrl;
input            t0_test_clk;
input            t0_scan_clk;
input [6:0]      t1_tst_tcm_ctrl;
input            t1_test_clk;
input            t1_scan_clk;
input [6:0]      t2_tst_tcm_ctrl;
input            t2_test_clk;
input            t2_scan_clk;
input		 dft_adpt_rst;
input		 adpt_scan_rst_n;
input		 adpt_scan_mode_n;
input [2:0] 	 pld_g3_current_rxpreset;
input		 aib_hssi_adapter_tx_pld_rst_n;         // To c3adapt_txrst_ctl of c3adapt_txrst_ctl.v
input [2:0]	 aib_hssi_fpll_shared_direct_async_in;  // To c3adapt_txclk_ctl of c3adapt_txclk_ctl.v, ...
input		 sr_clock_tx_osc_clk_or_clkdiv;	       // To c3adapt_txclk_ctl of c3adapt_txclk_ctl.v
input		 aib_hssi_pcs_tx_pld_rst_n;             // To c3adapt_txrst_ctl of c3adapt_txrst_ctl.v
input		 aib_hssi_pld_pma_txdetectrx;           // To c3adapt_tx_async of c3adapt_tx_async.v
input		 aib_hssi_pld_pma_txpma_rstb;           // To c3adapt_txrst_ctl of c3adapt_txrst_ctl.v
input		 aib_hssi_pld_sclk;	               // To c3adapt_txclk_ctl of c3adapt_txclk_ctl.v
input		 aib_hssi_rx_sr_clk_in;	               // To c3adapt_txclk_ctl of c3adapt_txclk_ctl.v
input [39:0]	 aib_hssi_tx_data_in;	               // To c3adapt_tx_datapath of c3adapt_tx_datapath.v
input		 aib_hssi_tx_transfer_clk;              // To c3adapt_txclk_ctl of c3adapt_txclk_ctl.v
input		 aib_hssi_tx_dcd_cal_done;
input		 aib_hssi_tx_dll_lock;
input		 csr_rdy_dly_in;		// To c3adapt_txrst_ctl of c3adapt_txrst_ctl.v
input [3:0]	 hip_aib_async_fsr_in;	// To c3adapt_tx_async of c3adapt_tx_async.v
input [39:0]	 hip_aib_async_ssr_in;	// To c3adapt_tx_async of c3adapt_tx_async.v
input            tx_ehip_clk;
input            tx_rsfec_clk;
input            tx_elane_clk;
input            tx_pma_clk;
input [3:0]	 hip_aib_fsr_out;	// To c3adapt_tx_async of c3adapt_tx_async.v
input [7:0]	 hip_aib_ssr_out;	// To c3adapt_tx_async of c3adapt_tx_async.v
input [4:0]	 pcs_fpll_shared_direct_async_in;// To c3adapt_tx_async of c3adapt_tx_async.v, ...
input		 pld_krfec_tx_alignment;	// To c3adapt_tx_datapath of c3adapt_tx_datapath.v
input		 pld_pma_div66_clk;	// To c3adapt_txclk_ctl of c3adapt_txclk_ctl.v
input		 pld_pma_fpll_clk0bad;	// To c3adapt_tx_async of c3adapt_tx_async.v
input		 pld_pma_fpll_clk1bad;	// To c3adapt_tx_async of c3adapt_tx_async.v
input		 pld_pma_fpll_clksel;	// To c3adapt_tx_async of c3adapt_tx_async.v
input		 pld_pma_fpll_phase_done;// To c3adapt_tx_async of c3adapt_tx_async.v
input		 pld_pmaif_mask_tx_pll;	// To c3adapt_tx_async of c3adapt_tx_async.v
input		 r_tx_async_hip_aib_fsr_in_bit0_rst_val;// To c3adapt_tx_async of c3adapt_tx_async.v
input		 r_tx_async_hip_aib_fsr_in_bit1_rst_val;// To c3adapt_tx_async of c3adapt_tx_async.v
input		 r_tx_async_hip_aib_fsr_in_bit2_rst_val;// To c3adapt_tx_async of c3adapt_tx_async.v
input		 r_tx_async_hip_aib_fsr_in_bit3_rst_val;// To c3adapt_tx_async of c3adapt_tx_async.v
input		 r_tx_async_hip_aib_fsr_out_bit0_rst_val;// To c3adapt_tx_async of c3adapt_tx_async.v
input		 r_tx_async_hip_aib_fsr_out_bit1_rst_val;// To c3adapt_tx_async of c3adapt_tx_async.v
input		 r_tx_async_hip_aib_fsr_out_bit2_rst_val;// To c3adapt_tx_async of c3adapt_tx_async.v
input		 r_tx_async_hip_aib_fsr_out_bit3_rst_val;// To c3adapt_tx_async of c3adapt_tx_async.v
input		 r_tx_async_pld_pmaif_mask_tx_pll_rst_val;// To c3adapt_tx_async of c3adapt_tx_async.v
input		 r_tx_async_pld_txelecidle_rst_val;// To c3adapt_tx_async of c3adapt_tx_async.v
input		 r_tx_bonding_dft_in_en;	// To c3adapt_tx_datapath of c3adapt_tx_datapath.v
input		 r_tx_bonding_dft_in_value;// To c3adapt_tx_datapath of c3adapt_tx_datapath.v
input [2:0] 	 r_tx_chnl_datapath_map_mode;// To c3adapt_tx_datapath of c3adapt_tx_datapath.v
input		 r_tx_chnl_datapath_map_rxqpi_pullup_init_val;// To c3adapt_tx_datapath of c3adapt_tx_datapath.v
input		 r_tx_chnl_datapath_map_txqpi_pulldn_init_val;// To c3adapt_tx_datapath of c3adapt_tx_datapath.v
input		 r_tx_chnl_datapath_map_txqpi_pullup_init_val;// To c3adapt_tx_datapath of c3adapt_tx_datapath.v
input [7:0]	 r_tx_comp_cnt;		// To c3adapt_tx_datapath of c3adapt_tx_datapath.v
input [1:0]	 r_tx_compin_sel;	// To c3adapt_tx_datapath of c3adapt_tx_datapath.v
input		 r_tx_double_read;	// To c3adapt_tx_datapath of c3adapt_tx_datapath.v
input		 r_tx_ds_bypass_pipeln;	// To c3adapt_tx_datapath of c3adapt_tx_datapath.v
input		 r_tx_ds_master;		// To c3adapt_tx_datapath of c3adapt_tx_datapath.v
input		 r_tx_dyn_clk_sw_en;	// To c3adapt_txclk_ctl of c3adapt_txclk_ctl.v
input [4:0]	 r_tx_fifo_empty;	// To c3adapt_tx_datapath of c3adapt_tx_datapath.v
input [4:0]	 r_tx_fifo_full;		// To c3adapt_tx_datapath of c3adapt_tx_datapath.v
input [1:0]	 r_tx_fifo_mode;		// To c3adapt_tx_datapath of c3adapt_tx_datapath.v
input [4:0]	 r_tx_fifo_pempty;	// To c3adapt_tx_datapath of c3adapt_tx_datapath.v
input [4:0]	 r_tx_fifo_pfull;	// To c3adapt_tx_datapath of c3adapt_tx_datapath.v
input		 r_tx_fifo_rd_clk_scg_en;// To c3adapt_txclk_ctl of c3adapt_txclk_ctl.v
input [1:0]	 r_tx_fifo_rd_clk_sel;	// To c3adapt_txclk_ctl of c3adapt_txclk_ctl.v
input		 r_tx_fifo_wr_clk_scg_en;// To c3adapt_txclk_ctl of c3adapt_txclk_ctl.v
input		 r_tx_free_run_div_clk;	// To c3adapt_txrst_ctl of c3adapt_txrst_ctl.v
//input [1:0]	 r_tx_hrdrst_master_sel;// To c3adapt_txrst_ctl of c3adapt_txrst_ctl.v
//input		 r_tx_hrdrst_dist_master_sel;// To c3adapt_txrst_ctl of c3adapt_txrst_ctl.v
input		 r_tx_ds_last_chnl;
input		 r_tx_us_last_chnl;
input		 r_tx_indv;		// To c3adapt_tx_datapath of c3adapt_tx_datapath.v
input		 r_tx_osc_clk_scg_en;	// To c3adapt_txclk_ctl of c3adapt_txclk_ctl.v
input [2:0]	 r_tx_phcomp_rd_delay;	// To c3adapt_tx_datapath of c3adapt_tx_datapath.v
input		 r_tx_stop_read;		// To c3adapt_tx_datapath of c3adapt_tx_datapath.v
input		 r_tx_stop_write;	// To c3adapt_tx_datapath of c3adapt_tx_datapath.v
input		 r_tx_us_bypass_pipeln;	// To c3adapt_tx_datapath of c3adapt_tx_datapath.v
input		 r_tx_us_master;		// To c3adapt_tx_datapath of c3adapt_tx_datapath.v
input		 r_tx_wa_en;		// To c3adapt_tx_datapath of c3adapt_tx_datapath.v
input  [1:0]	 r_tx_fifo_power_mode;
input  [4:0]     r_tx_wren_fastbond;   
input  [2:0]	 r_tx_stretch_num_stages; 
input  [2:0]	 r_tx_datapath_tb_sel;
input  		 r_tx_wr_adj_en;
input            r_tx_rd_adj_en;
input		 r_tx_dv_gating_en;
input            r_tx_qpi_sr_enable;
input            r_tx_usertest_sel;
input            r_tx_latency_src_xcvrif;
input            r_rstctl_tx_pld_div2_rst_opt;
input            sr_pld_latency_pulse_sel;
input		 rx_asn_fifo_hold;	// To c3adapt_tx_datapath of c3adapt_tx_datapath.v
input		 rx_asn_rate_change_in_progress;
input		 rx_asn_dll_lock_en;
input		 tx_async_fabric_hssi_fsr_data;// To c3adapt_tx_async of c3adapt_tx_async.v
input		 tx_async_fabric_hssi_fsr_load;// To c3adapt_tx_async of c3adapt_tx_async.v
input [35:0]	 tx_async_fabric_hssi_ssr_data;// To c3adapt_tx_async of c3adapt_tx_async.v
input		 tx_async_fabric_hssi_ssr_load;// To c3adapt_tx_async of c3adapt_tx_async.v
input		 tx_async_hssi_fabric_fsr_load;// To c3adapt_tx_async of c3adapt_tx_async.v
input		 tx_async_hssi_fabric_ssr_load;// To c3adapt_tx_async of c3adapt_tx_async.v
input		 avmm_hrdrst_hssi_osc_transfer_alive;
input            r_tx_hrdrst_rst_sm_dis;
input            r_tx_hrdrst_dcd_cal_done_bypass;
input            r_tx_hrdrst_dll_lock_bypass;
input            r_tx_hrdrst_align_bypass;
input		 r_tx_hrdrst_user_ctl_en;
input            r_tx_presethint_bypass;
input            r_tx_hrdrst_rx_osc_clk_scg_en;
input		 r_tx_hip_osc_clk_scg_en;
input [2:0]      tx_async_fabric_hssi_ssr_reserved;
input            tx_direct_transfer_testbus; 
// Beginning of automatic outputs (from unused autoinst outputs)
output [2:0]     tx_async_hssi_fabric_ssr_reserved;  
output           tx_clock_fifo_rd_prect_clk;
output           sr_fabric_tx_transfer_en;
output [4:0]	 aib_hssi_fpll_shared_direct_async_out;      // From c3adapt_tx_async of c3adapt_tx_async.v, ...
output		 aib_tx_pma_div66_clk;            // From c3adapt_txclk_ctl of c3adapt_txclk_ctl.v
output		 aib_hssi_tx_fifo_latency_pls;    // From c3adapt_tx_datapath of c3adapt_tx_datapath.v
output		 aib_pma_aib_tx_clk;                    // From c3adapt_txclk_ctl of c3adapt_txclk_ctl.v
output           aib_pma_aib_tx_div2_clk;
output		 aib_hssi_tx_dcd_cal_req;
output		 aib_hssi_tx_dll_lock_req;
output [3:0]	 hip_aib_async_fsr_out;	// From c3adapt_tx_async of c3adapt_tx_async.v
output [7:0]	 hip_aib_async_ssr_out;	// From c3adapt_tx_async of c3adapt_tx_async.v
output [3:0]	 hip_aib_fsr_in;		// From c3adapt_tx_async of c3adapt_tx_async.v
output [39:0]	 hip_aib_ssr_in;		// From c3adapt_tx_async of c3adapt_tx_async.v
output [77:0]	 tx_ehip_data;	// From c3adapt_tx_datapath of c3adapt_tx_datapath.v
output [77:0]    tx_elane_data;
output [77:0]    tx_rsfec_data;
output [39:0]    tx_pma_data;
output		 txeq_invalid_req;		// From c3adapt_tx_datapath of c3adapt_tx_datapath.v
output [2:0]	 pcs_fpll_shared_direct_async_out;    // From c3adapt_txclk_ctl of c3adapt_txclk_ctl.v, ...
output		 usr_tx_elane_rst_n;// From c3adapt_txrst_ctl of c3adapt_txrst_ctl.v
output [6:0]	 pld_10g_tx_bitslip;	// From c3adapt_tx_async of c3adapt_tx_async.v
output		 pld_8g_g3_tx_pld_rst_n;	// From c3adapt_txrst_ctl of c3adapt_txrst_ctl.v
output [4:0]	 pld_8g_tx_boundary_sel;	// From c3adapt_tx_async of c3adapt_tx_async.v
output		 pld_8g_wrenable_tx;	// From c3adapt_tx_datapath of c3adapt_tx_datapath.v
output		 pld_pma_csr_test_dis;	// From c3adapt_tx_async of c3adapt_tx_async.v
output [3:0]	 pld_pma_fpll_cnt_sel;	// From c3adapt_tx_async of c3adapt_tx_async.v
output		 pld_pma_fpll_extswitch;	// From c3adapt_tx_async of c3adapt_tx_async.v
output		 pld_pma_fpll_lc_csr_test_dis;// From c3adapt_tx_async of c3adapt_tx_async.v
output [2:0]	 pld_pma_fpll_num_phase_shifts;// From c3adapt_tx_async of c3adapt_tx_async.v
output		 pld_pma_fpll_pfden;	// From c3adapt_tx_async of c3adapt_tx_async.v
output		 pld_pma_fpll_up_dn_lc_lf_rstn;// From c3adapt_tx_async of c3adapt_tx_async.v
output		 pld_pma_nrpi_freeze;	// From c3adapt_tx_async of c3adapt_tx_async.v
output		 pld_pma_rx_qpi_pullup;	// From c3adapt_tx_datapath of c3adapt_tx_datapath.v
output		 pld_pma_tx_bitslip;	// From c3adapt_tx_async of c3adapt_tx_async.v
output		 pld_pma_tx_qpi_pulldn;	// From c3adapt_tx_datapath of c3adapt_tx_datapath.v
output		 pld_pma_tx_qpi_pullup;	// From c3adapt_tx_datapath of c3adapt_tx_datapath.v
output		 pld_pma_txdetectrx;	// From c3adapt_tx_async of c3adapt_tx_async.v
output		 pld_pma_txpma_rstb;	// From c3adapt_txrst_ctl of c3adapt_txrst_ctl.v
output		 pld_polinv_tx;		// From c3adapt_tx_async of c3adapt_tx_async.v
output		 pld_txelecidle;		// From c3adapt_tx_async of c3adapt_tx_async.v
output           tx_aib_transfer_clk;
output           tx_aib_transfer_clk_rst_n;
output           tx_aib_transfer_div2_clk;
output [1:0]	 rx_pld_rate;		// From c3adapt_tx_datapath of c3adapt_tx_datapath.v
output		 tx_clock_fifo_rd_clk;	// From c3adapt_txclk_ctl of c3adapt_txclk_ctl.v
output		 tx_clock_fifo_wr_clk;	// From c3adapt_txclk_ctl of c3adapt_txclk_ctl.v
output		 txeq_rxeqeval;		// From c3adapt_tx_datapath of c3adapt_tx_datapath.v
output		 txeq_rxeqinprogress;		// From c3adapt_tx_datapath of c3adapt_tx_datapath.v
output           txeq_txdetectrx;
output [1:0]     txeq_rate;
output [1:0]     txeq_powerdown;
output		 tx_async_hssi_fabric_fsr_data;// From c3adapt_tx_async of c3adapt_tx_async.v
output [12:0]	 tx_async_hssi_fabric_ssr_data;// From c3adapt_tx_async of c3adapt_tx_async.v
output [7:0]     tx_chnl_dprio_status;   // To hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output           tx_chnl_dprio_status_write_en_ack;// To hdpldadapt_avmm1 of hdpldadapt_avmm1.v
input            tx_chnl_dprio_status_write_en;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [79:0]	 tx_fifo_data_lpbk;
output [39:0]	 aib_hssi_tx_data_lpbk;
output [39:0]    tx_pma_data_lpbk;
output [19:0]	 tx_chnl_testbus;
input  [39:0]	 aib_hssi_rx_data_out;
input		 r_tx_rev_lpbk;
input            xcvrif_tx_latency_pls;
output           tx_fsr_parity_checker_in;
output  [38:0]   tx_ssr_parity_checker_in;
output           hip_fsr_parity_checker_in;
output  [4:0]    hip_ssr_parity_checker_in;
output  [3:0]    tx_hrdrst_tb_direct;


// assign tx_chnl_dprio_status = 8'h0;
// assign tx_chnl_dprio_status_write_en_ack = 1'b0;


/*AUTOWIRE*/
// Beginning of automatic wires (for undeclared instantiated-module outputs)
wire		 align_done;
wire		 fifo_empty;
wire		 fifo_full;
wire             fifo_full_sync;
wire		 tx_clock_reset_hrdrst_rx_osc_clk;
wire		 tx_clock_reset_fifo_wr_clk;
wire		 tx_clock_reset_fifo_rd_clk;
wire		 tx_clock_fifo_sclk;
wire		 tx_clock_reset_async_rx_osc_clk;
wire		 tx_clock_reset_async_tx_osc_clk;
wire		 tx_clock_pma_aib_tx_clk;
wire		 tx_clock_pma_aib_tx_div2_clk;
wire		 tx_clock_hrdrst_rx_osc_clk;
wire		 tx_clock_async_rx_osc_clk;
wire		 tx_clock_async_tx_osc_clk;
wire		 tx_clock_hip_async_tx_osc_clk;
wire		 tx_clock_hip_async_rx_osc_clk;
//wire		 tx_clock_fifo_rd_clk;
//wire		 tx_clock_fifo_wr_clk;
wire		 q1_tx_clock_fifo_wr_clk;
wire		 q2_tx_clock_fifo_wr_clk;
wire		 q3_tx_clock_fifo_wr_clk;
wire		 q4_tx_clock_fifo_wr_clk;
wire		 tx_reset_pma_aib_tx_clk_rst_n;
wire		 tx_reset_pma_aib_tx_clkdiv2_rst_n;
wire		 tx_reset_async_rx_osc_clk_rst_n;
wire		 tx_reset_async_tx_osc_clk_rst_n;
wire		 tx_reset_fifo_rd_rst_n;
wire		 tx_reset_fifo_sclk_rst_n;
wire		 tx_reset_fifo_wr_rst_n;
wire		 tx_hrdrst_tx_fifo_srst;
wire		 tx_hrdrst_hssi_tx_dcd_cal_done;
wire		 tx_hrdrst_hssi_tx_dll_lock;
wire		 tx_hrdrst_hssi_tx_transfer_en;
wire             sr_fabric_tx_dcd_cal_done;
wire             sr_pld_tx_dll_lock_req;
wire             pld_tx_fifo_latency_adj_en;
wire             sr_aib_hssi_tx_dcd_cal_req;
wire             sr_aib_hssi_tx_dll_lock_req;
wire             aib_hssi_tx_dcd_cal_done;
wire             aib_hssi_tx_dll_lock;
wire             pld_pma_tx_qpi_pulldn_sr;
wire             pld_pma_tx_qpi_pullup_sr;
wire             pld_pma_rx_qpi_pullup_sr;
wire             tx_reset_tx_transfer_clk_rst_n;

wire [19:0]      tx_fifo_testbus1; 
wire [19:0]      tx_fifo_testbus2;
wire [19:0]      word_align_testbus;
wire [19:0]      tx_cp_bond_testbus;
wire [19:0]      tx_hrdrst_testbus;

wire 		 wa_error;
wire  [3:0]	 wa_error_cnt;
wire		 tx_fifo_ready;

wire  [39:0]	 aib_hssi_tx_data_in_int;
wire             sr_pld_tx_fifo_srst;
wire             tx_ehip_early_clk;
wire             tx_rsfec_early_clk;
wire             tx_elane_early_clk;
wire             txdp_ehip_rst_n;
wire             txdp_elane_rst_n;
wire             txdp_rsfec_rst_n;

// disconnect revrse loopback that doesn't work.  Move to inside TX datapath to other side of FIFO.   
// assign aib_hssi_tx_data_in_int = r_tx_rev_lpbk ? aib_hssi_rx_data_out : aib_hssi_tx_data_in;

assign tx_aib_transfer_clk_rst_n = tx_reset_tx_transfer_clk_rst_n;
assign aib_hssi_tx_data_lpbk     = aib_hssi_tx_data_in;
assign tx_pma_data_lpbk          = tx_pma_data;

//wire pipe_mode = ~r_tx_chnl_datapath_map_hip_en && (r_tx_chnl_datapath_map_gen12_cap || r_tx_chnl_datapath_map_gen3_cap);
// wire pipe_mode = (r_tx_chnl_datapath_map_mode == 5'b0_1101) || (r_tx_chnl_datapath_map_mode == 5'b0_1110);
wire pipe_mode = 1'b0;

c3aibadapt_txdp tx_datapath (/*AUTOINST*/
    // Outputs
    .fifo_empty		        (fifo_empty),
    .fifo_full		        (fifo_full),
    .tx_ehip_data	        (tx_ehip_data),
    .tx_elane_data              (tx_elane_data),
    .tx_rsfec_data              (tx_rsfec_data),
    .tx_pma_data                (tx_pma_data),
    .txeq_invalid_req	        (txeq_invalid_req),
    .pld_10g_tx_burst_en	(),
    .pld_10g_tx_data_valid      (),
    .pld_10g_tx_diag_status     (),
    .pld_10g_tx_wordslip	(),
    .pld_8g_rddisable_tx	(/*NC*/),
    .pld_8g_wrenable_tx	        (pld_8g_wrenable_tx),
    .pld_pma_rx_qpi_pullup      (pld_pma_rx_qpi_pullup),
    .pld_pma_tx_qpi_pulldn      (pld_pma_tx_qpi_pulldn),
    .pld_pma_tx_qpi_pullup      (pld_pma_tx_qpi_pullup),
    .rx_pld_rate		(rx_pld_rate[1:0]),
    .txeq_rxeqeval	        (txeq_rxeqeval),
    .txeq_rxeqinprogress	(txeq_rxeqinprogress),
    .txeq_txdetectrx            (txeq_txdetectrx),
    .txeq_rate                  (txeq_rate),
    .txeq_powerdown             (txeq_powerdown),
    .aib_hssi_tx_fifo_latency_pls(aib_hssi_tx_fifo_latency_pls),
    .bond_tx_fifo_ds_out_dv     (),
    .bond_tx_fifo_ds_out_rden   (),
    .bond_tx_fifo_ds_out_wren   (),
    .bond_tx_fifo_us_out_dv     (),
    .bond_tx_fifo_us_out_rden   (),
    .bond_tx_fifo_us_out_wren   (),
    .align_done		        (align_done),
    .wa_error		        (wa_error),
    .wa_error_cnt		(wa_error_cnt[3:0]),
    .pipe_mode		        (pipe_mode),
    .tx_fifo_data_lpbk	        (tx_fifo_data_lpbk),
    .tx_fifo_testbus1	        (tx_fifo_testbus1),
    .tx_fifo_testbus2 	        (tx_fifo_testbus2), 
    .word_align_testbus	        (word_align_testbus),
    .tx_cp_bond_testbus	        (tx_cp_bond_testbus),
    .tx_fifo_ready	        (tx_fifo_ready),
    
    // Inputs
    .tx_direct_transfer_testbus (tx_direct_transfer_testbus),
    .dft_adpt_rst               (dft_adpt_rst),
    .pld_g3_current_rxpreset    (pld_g3_current_rxpreset),
//  .aib_hssi_tx_data_in	(aib_hssi_tx_data_in_int),  // disconnect reverse loopback that doesn't work. Move to other side of FIFO
    .aib_hssi_tx_data_in	(aib_hssi_tx_data_in),
    .aib_hssi_pld_tx_fifo_latency_adj_en (pld_tx_fifo_latency_adj_en),		// To be connected to SSR
    .aib_hssi_rx_data_out       (aib_hssi_rx_data_out),                
    .r_tx_rev_lpbk              (r_tx_rev_lpbk),           
    .r_tx_bonding_dft_in_en     (r_tx_bonding_dft_in_en),
    .r_tx_bonding_dft_in_value  (r_tx_bonding_dft_in_value),
    .r_tx_comp_cnt	        (r_tx_comp_cnt[8-1:0]),
    .r_tx_compin_sel	        (r_tx_compin_sel[1:0]),
    .r_tx_double_read	        (r_tx_double_read),
    .r_tx_ds_bypass_pipeln      (r_tx_ds_bypass_pipeln),
    .r_tx_ds_master	        (r_tx_ds_master),
    .r_tx_fifo_empty	        (r_tx_fifo_empty[5-1:0]),
    .r_tx_fifo_mode	        (r_tx_fifo_mode[1:0]),
    .r_tx_fifo_full	        (r_tx_fifo_full[5-1:0]),
    .r_tx_indv		        (r_tx_indv),
    .r_tx_fifo_pempty	        (r_tx_fifo_pempty[5-1:0]),
    .r_tx_fifo_pfull	        (r_tx_fifo_pfull[5-1:0]),
    .r_tx_phcomp_rd_delay	(r_tx_phcomp_rd_delay[2:0]),
    .r_tx_stop_read	        (r_tx_stop_read),
    .r_tx_stop_write	        (r_tx_stop_write),
    .r_tx_qpi_sr_enable         (r_tx_qpi_sr_enable),
    .r_tx_usertest_sel          (r_tx_usertest_sel),
    .r_tx_latency_src_xcvrif    (r_tx_latency_src_xcvrif),
    .r_tx_chnl_datapath_map_mode(r_tx_chnl_datapath_map_mode),
    .r_tx_us_bypass_pipeln      (r_tx_us_bypass_pipeln),
    .r_tx_us_master	        (r_tx_us_master),
    .r_tx_wa_en		        (r_tx_wa_en),
    .r_tx_wren_fastbond		(r_tx_wren_fastbond),                                                   
    .r_tx_fifo_power_mode       (r_tx_fifo_power_mode),
    .r_tx_stretch_num_stages    (r_tx_stretch_num_stages), 	
    .r_tx_datapath_tb_sel       (r_tx_datapath_tb_sel), 
    .r_tx_wr_adj_en             (r_tx_wr_adj_en), 
    .r_tx_rd_adj_en             (r_tx_rd_adj_en),
    .r_tx_dv_gating_en          (r_tx_dv_gating_en),
    .r_tx_ds_last_chnl          (r_tx_ds_last_chnl),
    .r_tx_us_last_chnl          (r_tx_us_last_chnl),
    .pld_pma_tx_qpi_pulldn_sr   (pld_pma_tx_qpi_pulldn_sr),
    .pld_pma_tx_qpi_pullup_sr   (pld_pma_tx_qpi_pullup_sr),
    .pld_pma_rx_qpi_pullup_sr   (pld_pma_rx_qpi_pullup_sr),
    .sr_pld_latency_pulse_sel   (sr_pld_latency_pulse_sel),
    .xcvrif_tx_latency_pls      (xcvrif_tx_latency_pls),
    .tx_ehip_clk                (tx_ehip_early_clk),
    .tx_elane_clk               (tx_elane_early_clk),
    .tx_rsfec_clk               (tx_rsfec_early_clk),
    .tx_aib_transfer_clk        (tx_aib_transfer_clk),    //Input: used to capture AIB data for PMA-Direct mode
    .tx_ehip_rst_n              (txdp_ehip_rst_n),
    .tx_elane_rst_n             (txdp_elane_rst_n),      //from txchnl_rstctl
    .tx_rsfec_rst_n             (txdp_rsfec_rst_n),      //from txchnl_rstctl
    .tx_aib_transfer_rst_n      (tx_reset_tx_transfer_clk_rst_n),
    .tx_clock_fifo_rd_clk       (tx_clock_fifo_rd_clk),
    .tx_reset_fifo_rd_rst_n     (tx_reset_fifo_rd_rst_n),
    .tx_clock_fifo_sclk	        (tx_clock_fifo_sclk),
    .tx_clock_fifo_wr_clk	(tx_clock_fifo_wr_clk),
    .q1_tx_clock_fifo_wr_clk    (q1_tx_clock_fifo_wr_clk),
    .q2_tx_clock_fifo_wr_clk    (q2_tx_clock_fifo_wr_clk),
    .q3_tx_clock_fifo_wr_clk    (q3_tx_clock_fifo_wr_clk),
    .q4_tx_clock_fifo_wr_clk    (q4_tx_clock_fifo_wr_clk),
    .tx_reset_fifo_wr_rst_n     (tx_reset_fifo_wr_rst_n),
    .tx_reset_fifo_sclk_rst_n   (tx_reset_fifo_sclk_rst_n),
    .bond_tx_fifo_ds_in_dv      (1'b0),
    .bond_tx_fifo_ds_in_rden    (1'b0),
    .bond_tx_fifo_ds_in_wren    (1'b0),
    .bond_tx_fifo_us_in_dv      (1'b0),
    .bond_tx_fifo_us_in_rden    (1'b0),
    .bond_tx_fifo_us_in_wren    (1'b0),
    .r_tx_presethint_bypass     (r_tx_presethint_bypass),
    .tx_asn_fifo_hold	        (rx_asn_fifo_hold),
    .tx_asn_fifo_srst	        (tx_hrdrst_tx_fifo_srst));

c3aibadapt_txasync tx_async(/*AUTOINST*/
    // Outputs
    .tx_async_hssi_fabric_ssr_reserved      (tx_async_hssi_fabric_ssr_reserved),
    .aib_hssi_fpll_shared_direct_async_out  (aib_hssi_fpll_shared_direct_async_out[4:4]),
    .pld_10g_tx_bitslip	                    (pld_10g_tx_bitslip[6:0]),
    .pld_8g_tx_boundary_sel                 (pld_8g_tx_boundary_sel[4:0]),
    .pld_pma_csr_test_dis                   (pld_pma_csr_test_dis),
    .pld_pma_fpll_cnt_sel                   (pld_pma_fpll_cnt_sel[3:0]),
    .pld_pma_fpll_extswitch                 (pld_pma_fpll_extswitch),
    .pld_pma_fpll_lc_csr_test_dis           (pld_pma_fpll_lc_csr_test_dis),
    .pld_pma_fpll_num_phase_shifts          (pld_pma_fpll_num_phase_shifts[2:0]),
    .pld_pma_fpll_pfden	                    (pld_pma_fpll_pfden),
    .pld_pma_nrpi_freeze                    (pld_pma_nrpi_freeze),
    .pld_pma_tx_bitslip	                    (pld_pma_tx_bitslip),
    .pld_pma_txdetectrx	                    (pld_pma_txdetectrx),
    .pld_polinv_tx	                    (pld_polinv_tx),
    .pld_txelecidle	                    (pld_txelecidle),
    .pld_pma_fpll_up_dn_lc_lf_rstn          (pld_pma_fpll_up_dn_lc_lf_rstn),
    .pld_tx_fifo_latency_adj_en             (pld_tx_fifo_latency_adj_en),
    .hip_aib_fsr_in	                    (hip_aib_fsr_in[3:0]),
    .hip_aib_ssr_in	                    (hip_aib_ssr_in[39:0]),
    .tx_async_hssi_fabric_fsr_data          (tx_async_hssi_fabric_fsr_data),
    .tx_async_hssi_fabric_ssr_data          (tx_async_hssi_fabric_ssr_data[12:0]),
    .hip_aib_async_fsr_out                  (hip_aib_async_fsr_out[3:0]),
    .hip_aib_async_ssr_out                  (hip_aib_async_ssr_out[7:0]),
    .sr_fabric_tx_dcd_cal_done              (sr_fabric_tx_dcd_cal_done),
    .sr_pld_tx_dll_lock_req                 (sr_pld_tx_dll_lock_req),
    .sr_fabric_tx_transfer_en               (sr_fabric_tx_transfer_en),
    .sr_aib_hssi_tx_dcd_cal_req             (sr_aib_hssi_tx_dcd_cal_req),
    .sr_aib_hssi_tx_dll_lock_req            (sr_aib_hssi_tx_dll_lock_req),
    .pld_pma_tx_qpi_pulldn_sr               (pld_pma_tx_qpi_pulldn_sr),
    .pld_pma_tx_qpi_pullup_sr               (pld_pma_tx_qpi_pullup_sr),
    .pld_pma_rx_qpi_pullup_sr               (pld_pma_rx_qpi_pullup_sr),
    .tx_fsr_parity_checker_in               (tx_fsr_parity_checker_in),
    .tx_ssr_parity_checker_in               (tx_ssr_parity_checker_in),
    .hip_fsr_parity_checker_in              (hip_fsr_parity_checker_in),
    .hip_ssr_parity_checker_in              (hip_ssr_parity_checker_in),
    .sr_pld_tx_fifo_srst                    (sr_pld_tx_fifo_srst),
    // Inputs
    .r_txchnl_dp_map_rxqpi_pullup_init_val  (r_tx_chnl_datapath_map_rxqpi_pullup_init_val),
    .tx_fifo_ready	(tx_fifo_ready),
    .dft_adpt_rst     (dft_adpt_rst),
    .tx_async_fabric_hssi_ssr_reserved (tx_async_fabric_hssi_ssr_reserved),
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
    .aib_hssi_pld_pma_txdetectrx(aib_hssi_pld_pma_txdetectrx),
    .pld_krfec_tx_alignment(pld_krfec_tx_alignment),
    .pld_pma_fpll_clk0bad(pld_pma_fpll_clk0bad),
    .pld_pma_fpll_clk1bad(pld_pma_fpll_clk1bad),
    .pld_pma_fpll_clksel(pld_pma_fpll_clksel),
    .pld_pma_fpll_phase_done(pld_pma_fpll_phase_done),
    .pld_pmaif_mask_tx_pll(pld_pmaif_mask_tx_pll),
    .pcs_fpll_shared_direct_async_in(pcs_fpll_shared_direct_async_in[4:4]),
    .hip_aib_fsr_out	(hip_aib_fsr_out[3:0]),
    .hip_aib_ssr_out	(hip_aib_ssr_out[7:0]),
    .tx_hrdrst_hssi_tx_dcd_cal_done (tx_hrdrst_hssi_tx_dcd_cal_done),
    .tx_hrdrst_hssi_tx_dll_lock   (tx_hrdrst_hssi_tx_dll_lock),
    .tx_hrdrst_hssi_tx_transfer_en(tx_hrdrst_hssi_tx_transfer_en),
    .aib_hssi_tx_dcd_cal_done (aib_hssi_tx_dcd_cal_done),
    .aib_hssi_tx_dll_lock     (aib_hssi_tx_dll_lock),
    .tx_async_fabric_hssi_fsr_data(tx_async_fabric_hssi_fsr_data),
    .tx_async_fabric_hssi_fsr_load(tx_async_fabric_hssi_fsr_load),
    .tx_async_fabric_hssi_ssr_data(tx_async_fabric_hssi_ssr_data[35:0]),
    .tx_async_fabric_hssi_ssr_load(tx_async_fabric_hssi_ssr_load),
    .tx_async_hssi_fabric_fsr_load(tx_async_hssi_fabric_fsr_load),
    .tx_async_hssi_fabric_ssr_load(tx_async_hssi_fabric_ssr_load),
    .hip_aib_async_fsr_in(hip_aib_async_fsr_in[3:0]),
    .hip_aib_async_ssr_in(hip_aib_async_ssr_in[39:0]),
    .tx_clock_hip_async_tx_osc_clk(tx_clock_hip_async_tx_osc_clk),
    .tx_clock_hip_async_rx_osc_clk(tx_clock_hip_async_rx_osc_clk),
    .tx_clock_async_rx_osc_clk(tx_clock_async_rx_osc_clk),
    .tx_clock_async_tx_osc_clk(tx_clock_async_tx_osc_clk),
    .tx_reset_async_rx_osc_clk_rst_n(tx_reset_async_rx_osc_clk_rst_n),
    .tx_reset_async_tx_osc_clk_rst_n(tx_reset_async_tx_osc_clk_rst_n),
    .align_done		(align_done),
    .fifo_empty		(fifo_empty),
    .fifo_full		(fifo_full));

c3aibadapt_txclk_ctl txclk_ctl(/*AUTOINST*/
    // Outputs
    .tx_ehip_early_clk                    (tx_ehip_early_clk),
    .tx_elane_early_clk                   (tx_elane_early_clk),
    .tx_rsfec_early_clk                   (tx_rsfec_early_clk),
    .pcs_fpll_shared_direct_async_out     (pcs_fpll_shared_direct_async_out[0:0]),
    .tx_clock_fifo_rd_prect_clk           (tx_clock_fifo_rd_prect_clk),
    // .aib_hssi_pld_pcs_tx_clk_out          (aib_hssi_pld_pcs_tx_clk_out),
    .aib_pma_aib_tx_clk                   (aib_pma_aib_tx_clk),
    .aib_pma_aib_tx_div2_clk              (aib_pma_aib_tx_div2_clk),
    .aib_tx_pma_div66_clk                 (aib_tx_pma_div66_clk),
    .aib_hssi_fpll_shared_direct_async_out(aib_hssi_fpll_shared_direct_async_out[3:0]),
    .tx_clock_reset_hrdrst_rx_osc_clk     (tx_clock_reset_hrdrst_rx_osc_clk),
    .tx_clock_reset_fifo_wr_clk           (tx_clock_reset_fifo_wr_clk),
    .tx_clock_reset_fifo_rd_clk           (tx_clock_reset_fifo_rd_clk),
    .tx_clock_fifo_sclk                   (tx_clock_fifo_sclk),
    .tx_clock_reset_async_rx_osc_clk      (tx_clock_reset_async_rx_osc_clk),
    .tx_clock_reset_async_tx_osc_clk      (tx_clock_reset_async_tx_osc_clk),
    .tx_clock_tx_transfer_clk             (tx_aib_transfer_clk),                     //Output of TCM-mux, sourced by aib_hssi_tx_transfer_clk
    .tx_clock_tx_transfer_div2_clk        (tx_aib_transfer_div2_clk),
    .tx_clock_pma_aib_tx_clk              (tx_clock_pma_aib_tx_clk),
    .tx_clock_pma_aib_tx_div2_clk         (tx_clock_pma_aib_tx_div2_clk),
    .tx_clock_fifo_wr_clk                 (tx_clock_fifo_wr_clk),
    .q1_tx_clock_fifo_wr_clk              (q1_tx_clock_fifo_wr_clk),
    .q2_tx_clock_fifo_wr_clk              (q2_tx_clock_fifo_wr_clk),
    .q3_tx_clock_fifo_wr_clk              (q3_tx_clock_fifo_wr_clk),
    .q4_tx_clock_fifo_wr_clk              (q4_tx_clock_fifo_wr_clk),
    .tx_clock_fifo_rd_clk                 (tx_clock_fifo_rd_clk),
    .tx_clock_hrdrst_rx_osc_clk           (tx_clock_hrdrst_rx_osc_clk),
    .tx_clock_async_rx_osc_clk            (tx_clock_async_rx_osc_clk),
    .tx_clock_async_tx_osc_clk            (tx_clock_async_tx_osc_clk),
    .tx_clock_hip_async_tx_osc_clk        (tx_clock_hip_async_tx_osc_clk),
    .tx_clock_hip_async_rx_osc_clk        (tx_clock_hip_async_rx_osc_clk),
    // Inputs
    .scan_mode_n                          (scan_mode_n),
    .t0_tst_tcm_ctrl                      (t0_tst_tcm_ctrl),
    .t0_test_clk                          (t0_test_clk),
    .t0_scan_clk                          (t0_scan_clk),
    .t1_tst_tcm_ctrl                      (t1_tst_tcm_ctrl),
    .t1_test_clk                          (t1_test_clk),
    .t1_scan_clk                          (t1_scan_clk),
    .t2_tst_tcm_ctrl                      (t2_tst_tcm_ctrl),
    .t2_test_clk                          (t2_test_clk),
    .t2_scan_clk                          (t2_scan_clk),
    .pld_pma_div66_clk                    (pld_pma_div66_clk),
    .pcs_fpll_shared_direct_async_in      (pcs_fpll_shared_direct_async_in[3:0]),
    .tx_ehip_clk	                  (tx_ehip_clk),
    .tx_rsfec_clk                         (tx_rsfec_clk),
    .tx_elane_clk                         (tx_elane_clk),
    .tx_pma_clk	                          (tx_pma_clk),
    .sr_clock_tx_osc_clk_or_clkdiv        (sr_clock_tx_osc_clk_or_clkdiv),
    .aib_hssi_fpll_shared_direct_async_in (aib_hssi_fpll_shared_direct_async_in[0:0]),
    .aib_hssi_tx_transfer_clk             (aib_hssi_tx_transfer_clk),
    .aib_hssi_rx_sr_clk_in                (aib_hssi_rx_sr_clk_in),
    .aib_hssi_pld_sclk                    (aib_hssi_pld_sclk),
    .r_tx_fifo_rd_clk_sel                 (r_tx_fifo_rd_clk_sel),
    .r_tx_fifo_wr_clk_scg_en              (r_tx_fifo_wr_clk_scg_en),
    .r_tx_fifo_rd_clk_scg_en              (r_tx_fifo_rd_clk_scg_en),
    .r_tx_hrdrst_rx_osc_clk_scg_en        (r_tx_hrdrst_rx_osc_clk_scg_en),
    .r_tx_hip_osc_clk_scg_en              (r_tx_hip_osc_clk_scg_en),
    .r_tx_osc_clk_scg_en                  (r_tx_osc_clk_scg_en),
    .r_tx_clkdiv2_dist_bypass_pipeln      (r_tx_ds_bypass_pipeln),
    .r_tx_fifo_power_mode                 (r_tx_fifo_power_mode[1:0]),
    .tx_reset_pma_aib_tx_clk_rst_n        (tx_reset_pma_aib_tx_clk_rst_n),
    .tx_reset_tx_transfer_clk_rst_n       (tx_reset_tx_transfer_clk_rst_n),
    .tx_reset_pma_aib_tx_clkdiv2_rst_n    (tx_reset_pma_aib_tx_clkdiv2_rst_n));

c3aibadapt_txrst_ctl txrst_ctl(
    // Outputs
    .tx_ehip_rst_n                               (txdp_ehip_rst_n),
    .tx_elane_rst_n                              (txdp_elane_rst_n),
    .tx_rsfec_rst_n                              (txdp_rsfec_rst_n),
    .pld_10g_krfec_tx_pld_rst_n                  (usr_tx_elane_rst_n),
    .pld_8g_g3_tx_pld_rst_n                      (pld_8g_g3_tx_pld_rst_n),
    .pld_pma_tx_bonding_rstb                     (),
    .pcs_fpll_shared_direct_async_out            (pcs_fpll_shared_direct_async_out[2:1]),
    .pld_pma_txpma_rstb                          (pld_pma_txpma_rstb),
    // .pld_pmaif_tx_pld_rst_n                   (pld_pmaif_tx_pld_rst_n),
    .aib_hssi_tx_dcd_cal_req                     (aib_hssi_tx_dcd_cal_req),
    .aib_hssi_tx_dll_lock_req                    (aib_hssi_tx_dll_lock_req),
    .tx_hrdrst_tx_fifo_srst                      (tx_hrdrst_tx_fifo_srst),
    .tx_hrdrst_hssi_tx_dcd_cal_done              (tx_hrdrst_hssi_tx_dcd_cal_done),
    .tx_hrdrst_hssi_tx_dll_lock                  (tx_hrdrst_hssi_tx_dll_lock),
    .tx_hrdrst_hssi_tx_transfer_en               (tx_hrdrst_hssi_tx_transfer_en),
    .tx_hrdrst_testbus                           (tx_hrdrst_testbus),
    .tx_hrdrst_tb_direct                         (tx_hrdrst_tb_direct),
    .tx_reset_fifo_wr_rst_n                      (tx_reset_fifo_wr_rst_n),
    .tx_reset_fifo_rd_rst_n                      (tx_reset_fifo_rd_rst_n),
    .tx_reset_fifo_sclk_rst_n                    (tx_reset_fifo_sclk_rst_n),
    .tx_reset_pma_aib_tx_clk_rst_n               (tx_reset_pma_aib_tx_clk_rst_n),
    .tx_reset_tx_transfer_clk_rst_n              (tx_reset_tx_transfer_clk_rst_n),
    .tx_reset_pma_aib_tx_clkdiv2_rst_n           (tx_reset_pma_aib_tx_clkdiv2_rst_n),
    .tx_reset_async_rx_osc_clk_rst_n             (tx_reset_async_rx_osc_clk_rst_n),
    .tx_reset_async_tx_osc_clk_rst_n             (tx_reset_async_tx_osc_clk_rst_n),
    // Inputs
    .tx_ehip_clk	                         (tx_ehip_early_clk),       //Used for reset sync
    .tx_rsfec_clk                                (tx_rsfec_early_clk),      //Used for reset sync
    .tx_elane_clk                                (tx_elane_early_clk),      //Used for reset sync
    .dft_adpt_rst                                (dft_adpt_rst),
    .adapter_scan_rst_n                          (adpt_scan_rst_n),
    .adapter_scan_mode_n                         (adpt_scan_mode_n),
    .csr_rdy_dly_in	                         (csr_rdy_dly_in),
    .aib_hssi_pcs_tx_pld_rst_n                   (aib_hssi_pcs_tx_pld_rst_n),
    .aib_hssi_adapter_tx_pld_rst_n               (aib_hssi_adapter_tx_pld_rst_n),
    .aib_hssi_fpll_shared_direct_async_in        (aib_hssi_fpll_shared_direct_async_in[2:1]),
    .aib_hssi_pld_pma_txpma_rstb                 (aib_hssi_pld_pma_txpma_rstb),
    .aib_hssi_tx_dcd_cal_done                    (aib_hssi_tx_dcd_cal_done),
    .aib_hssi_tx_dll_lock                        (aib_hssi_tx_dll_lock),
    .bond_tx_hrdrst_ds_in_hssi_tx_dcd_cal_done   (1'b0),
    .bond_tx_hrdrst_us_in_hssi_tx_dcd_cal_done   (1'b0),
    .bond_tx_hrdrst_ds_in_hssi_tx_dcd_cal_req    (1'b0),
    .bond_tx_hrdrst_us_in_hssi_tx_dcd_cal_req    (1'b0),
    .bond_tx_hrdrst_ds_in_hssi_tx_dll_lock       (1'b0),
    .bond_tx_hrdrst_us_in_hssi_tx_dll_lock       (1'b0),
    .bond_tx_hrdrst_ds_in_hssi_tx_dll_lock_req   (1'b0),
    .bond_tx_hrdrst_us_in_hssi_tx_dll_lock_req   (1'b0),
    .avmm_hrdrst_hssi_osc_transfer_alive         (avmm_hrdrst_hssi_osc_transfer_alive),
    .sr_pld_hssi_tx_fifo_srst                    (sr_pld_tx_fifo_srst),
    .sr_pld_tx_dll_lock_req                      (sr_pld_tx_dll_lock_req),
    .sr_fabric_tx_dcd_cal_done                   (sr_fabric_tx_dcd_cal_done),
    .sr_fabric_tx_transfer_en                    (sr_fabric_tx_transfer_en),
    .rx_asn_rate_change_in_progress              (rx_asn_rate_change_in_progress),
    .rx_asn_dll_lock_en                          (rx_asn_dll_lock_en),
    .align_done                                  (align_done),
    .sr_aib_hssi_tx_dcd_cal_req                  (sr_aib_hssi_tx_dcd_cal_req),
    .sr_aib_hssi_tx_dll_lock_req                 (sr_aib_hssi_tx_dll_lock_req),
    .tx_clock_reset_hrdrst_rx_osc_clk            (tx_clock_reset_hrdrst_rx_osc_clk),
    .tx_clock_reset_fifo_wr_clk                  (tx_clock_reset_fifo_wr_clk),
    .tx_clock_reset_fifo_rd_clk                  (tx_clock_reset_fifo_rd_clk),
    .tx_clock_fifo_sclk                          (tx_clock_fifo_sclk),
    .tx_clock_reset_async_rx_osc_clk             (tx_clock_reset_async_rx_osc_clk),
    .tx_clock_reset_async_tx_osc_clk             (tx_clock_reset_async_tx_osc_clk),
    .tx_clock_pma_aib_tx_clk                     (tx_clock_pma_aib_tx_clk),
    .tx_aib_transfer_clk                         (tx_aib_transfer_clk),                     //Input: drives reset_sync
    .tx_clock_pma_aib_tx_div2_clk                (tx_clock_pma_aib_tx_div2_clk),
    .tx_clock_hrdrst_rx_osc_clk                  (tx_clock_hrdrst_rx_osc_clk),
    .tx_fifo_ready		                 (tx_fifo_ready),					      
    .rx_asn_fifo_hold	                         (rx_asn_fifo_hold),
    .r_tx_free_run_div_clk	                 (r_tx_free_run_div_clk),
    .r_tx_hrdrst_rst_sm_dis                      (r_tx_hrdrst_rst_sm_dis),
    .r_tx_hrdrst_dcd_cal_done_bypass             (r_tx_hrdrst_dcd_cal_done_bypass),
    .r_tx_hrdrst_dll_lock_bypass                 (r_tx_hrdrst_dll_lock_bypass),
    .r_tx_hrdrst_align_bypass                    (r_tx_hrdrst_align_bypass),
    .r_tx_hrdrst_user_ctl_en                     (r_tx_hrdrst_user_ctl_en),
    .r_tx_indv                                   (r_tx_indv),
    .r_tx_master_sel                             (r_tx_compin_sel[1:0]),
    .r_tx_dist_master_sel                        (r_tx_ds_master),
    .r_tx_ds_last_chnl                           (r_tx_ds_last_chnl),
    .r_tx_us_last_chnl                           (r_tx_us_last_chnl),
    .r_tx_bonding_dft_in_en                      (r_tx_bonding_dft_in_en),
    .r_tx_bonding_dft_in_value                   (r_tx_bonding_dft_in_value),
    .r_rstctl_tx_pld_div2_rst_opt                (r_rstctl_tx_pld_div2_rst_opt));

c3lib_bitsync
   #(
   .SRC_DATA_FREQ_MHZ    (500),    // Source data freq
   .DST_CLK_FREQ_MHZ     (1000),   // Dest clock freq
   .DWIDTH               (1),      // Sync Data input
   .RESET_VAL            (0)  // Reset value
   )
     txchnl_txfifo_full_sync
       (
        .clk      (tx_clock_fifo_rd_clk),
        .rst_n    (tx_reset_fifo_rd_rst_n),
        .data_in  (fifo_full),
        .data_out (fifo_full_sync)
        );

// Status Register
c3aibadapt_cmn_shadow_status_regs #( .DATA_WIDTH (8))
  txchnl_shadow_status_regs0
    (
     .rst_n          (tx_reset_fifo_rd_rst_n),  // reset
     .clk            (tx_clock_fifo_rd_clk),    // clock
     .stat_data_in   ({fifo_full_sync, fifo_empty, wa_error_cnt, wa_error,align_done}),  // status data input
     .write_en       (tx_chnl_dprio_status_write_en),  // write data enable from DPRIO
     .write_en_ack   (tx_chnl_dprio_status_write_en_ack),  // write data enable acknowlege to DPRIO
     .stat_data_out  (tx_chnl_dprio_status)   // status data output
     );



c3aibadapt_txchnl_testbus txchnl_testbus (
  .r_tx_datapath_tb_sel	(r_tx_datapath_tb_sel),
  .tx_fifo_testbus1	(tx_fifo_testbus1),
  .tx_fifo_testbus2 	(tx_fifo_testbus2), 
  .word_align_testbus	(word_align_testbus),
  .tx_cp_bond_testbus	(tx_cp_bond_testbus),
  .tx_hrdrst_testbus	(tx_hrdrst_testbus),
  .tx_chnl_testbus	(tx_chnl_testbus));


endmodule
