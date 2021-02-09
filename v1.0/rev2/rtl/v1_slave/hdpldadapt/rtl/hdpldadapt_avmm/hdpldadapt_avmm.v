// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module hdpldadapt_avmm(/*AUTOARG*/
   // Outputs

// new ouputs for ECO8
r_tx_wren_fastbond,
r_tx_rden_fastbond,                                
r_rx_wren_fastbond,
r_rx_rden_fastbond, 
                       
   usermode_out, avmm_testbus, r_tx_usertest_sel, r_rx_usertest_sel, 
   avmm1_transfer_error, avmm2_transfer_error,
   r_sr_testbus_sel, sr_hssi_osc_transfer_en, 
   r_sr_parity_en, avmm1_ssr_parity_checker_in, avmm2_ssr_parity_checker_in, 
   tx_chnl_dprio_status_write_en, adapter_config_scan_out,
   rx_chnl_dprio_status_write_en, r_tx_wordslip, r_tx_wm_en,
   r_tx_us_master, r_tx_us_bypass_pipeln, r_tx_osc_clk_scg_en,
   r_tx_stop_write, r_tx_stop_read, r_tx_sh_err,
   r_tx_pyld_ins, r_tx_pld_clk2_sel,
   r_tx_pld_clk1_delay_en, r_tx_pld_clk1_delay_sel, r_tx_pld_clk1_inv_en,
   r_tx_pld_clk1_sel, r_tx_pipeln_frmgen, r_tx_phcomp_rd_delay,
   r_tx_mfrm_length, r_tx_indv, r_tx_gb_odwidth, r_tx_gb_idwidth,
   r_tx_gb_dv_en, r_tx_fpll_shared_direct_async_in_sel, 
   //r_tx_fifo_wr_clk_sel, 
   r_tx_fifo_wr_clk_scg_en,
   r_tx_fifo_rd_clk_frm_gen_scg_en,
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
   r_tx_aib_clk1_sel, r_sr_osc_clk_scg_en, 
   r_rx_pld_8g_eidleinfersel_polling_bypass,
   r_rx_pld_pma_eye_monitor_polling_bypass,
   r_rx_pld_pma_pcie_switch_polling_bypass,
   r_rx_pld_pma_reser_out_polling_bypass,
   //r_sr_pld_txelecidle_rst_val, r_sr_pld_rx_fifo_align_clr_rst_val,
   //r_sr_pld_pmaif_mask_tx_pll_rst_val, r_sr_pld_pma_ltd_b_rst_val,
   //r_sr_pld_ltr_rst_val, r_sr_pld_8g_signal_detect_out_rst_val,
   //r_sr_pld_10g_rx_crc32_err_rst_val, r_sr_hip_fsr_out_bit3_rst_val,
   //r_sr_hip_fsr_out_bit2_rst_val, r_sr_hip_fsr_out_bit1_rst_val,
   //r_sr_hip_fsr_out_bit0_rst_val, r_sr_hip_fsr_in_bit3_rst_val,
   //r_sr_hip_fsr_in_bit2_rst_val, r_sr_hip_fsr_in_bit1_rst_val,
   //r_sr_hip_fsr_in_bit0_rst_val, 
   r_sr_hip_en, r_rx_wa_en,
   r_rx_us_master, r_rx_us_bypass_pipeln, r_rx_osc_clk_scg_en,
   r_rx_fifo_wr_clk_del_sm_scg_en, r_rx_fifo_rd_clk_ins_sm_scg_en,
   r_rx_truebac2bac, r_rx_stop_write, r_rx_stop_read, r_rx_sclk_sel,
   r_rx_pma_hclk_scg_en, //r_rx_pld_clk2_sel,
   r_rx_pld_clk1_sel, r_rx_phcomp_rd_delay, r_rx_indv, r_rx_gb_dv_en,
   r_rx_pld_clk1_delay_en, r_rx_pld_clk1_delay_sel, r_rx_pld_clk1_inv_en,
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
   r_rx_compin_sel, r_rx_comp_cnt,
   r_rx_asn_en, r_rx_asn_bypass_pma_pcie_sw_done,
   r_rx_asn_wait_for_fifo_flush_cnt, r_rx_asn_wait_for_dll_reset_cnt,
   r_rx_asn_wait_for_pma_pcie_sw_done_cnt, 
   r_tx_hip_aib_ssr_in_polling_bypass,
   r_tx_pld_8g_tx_boundary_sel_polling_bypass,
   r_tx_pld_10g_tx_bitslip_polling_bypass,
   r_tx_pld_pma_fpll_cnt_sel_polling_bypass,
   r_tx_pld_pma_fpll_num_phase_shifts_polling_bypass,
//   r_rx_asn_master_sel,
//   r_rx_asn_dist_master_sel, //r_rx_asn_bonding_dft_in_en, r_rx_asn_bonding_dft_in_value,
   r_rx_bonding_dft_in_value, r_rx_bonding_dft_in_en,
   r_rx_async_pld_rx_fifo_align_clr_rst_val, r_rx_async_prbs_flags_sr_enable,
   r_rx_async_pld_pma_ltd_b_rst_val, r_rx_async_pld_ltr_rst_val,
   r_rx_async_pld_8g_signal_detect_out_rst_val,
   r_rx_async_pld_10g_rx_crc32_err_rst_val, r_rx_aib_clk2_sel,
   r_rx_aib_clk1_sel, r_aib_dprio_ctrl_4, r_aib_dprio_ctrl_3,
   r_aib_dprio_ctrl_2, r_aib_dprio_ctrl_1, r_aib_dprio_ctrl_0,
   r_aib_csr_ctrl_9, r_aib_csr_ctrl_8, r_aib_csr_ctrl_7,
   r_aib_csr_ctrl_6, r_aib_csr_ctrl_57, r_aib_csr_ctrl_56,
   r_aib_csr_ctrl_55, r_aib_csr_ctrl_54, r_aib_csr_ctrl_53,
   r_aib_csr_ctrl_52, r_aib_csr_ctrl_51, r_aib_csr_ctrl_50,
   r_aib_csr_ctrl_5, r_aib_csr_ctrl_49, r_aib_csr_ctrl_48,
   r_aib_csr_ctrl_47, r_aib_csr_ctrl_46, r_aib_csr_ctrl_45,
   r_aib_csr_ctrl_44, r_aib_csr_ctrl_43, r_aib_csr_ctrl_42,
   r_aib_csr_ctrl_41, r_aib_csr_ctrl_40, r_aib_csr_ctrl_4,
   r_aib_csr_ctrl_39, r_aib_csr_ctrl_38, r_aib_csr_ctrl_37,
   r_aib_csr_ctrl_36, r_aib_csr_ctrl_35, r_aib_csr_ctrl_34,
   r_aib_csr_ctrl_33, r_aib_csr_ctrl_32, r_aib_csr_ctrl_31,
   r_aib_csr_ctrl_30, r_aib_csr_ctrl_3, r_aib_csr_ctrl_29,
   r_aib_csr_ctrl_28, r_aib_csr_ctrl_27, r_aib_csr_ctrl_26,
   r_aib_csr_ctrl_25, r_aib_csr_ctrl_24, r_aib_csr_ctrl_23,
   r_aib_csr_ctrl_22, r_aib_csr_ctrl_21, r_aib_csr_ctrl_20,
   r_aib_csr_ctrl_2, r_aib_csr_ctrl_19, r_aib_csr_ctrl_18,
   r_aib_csr_ctrl_17, r_aib_csr_ctrl_16, r_aib_csr_ctrl_15,
   r_aib_csr_ctrl_14, r_aib_csr_ctrl_13, r_aib_csr_ctrl_12,
   r_aib_csr_ctrl_11, r_aib_csr_ctrl_10, r_aib_csr_ctrl_1,
   r_aib_csr_ctrl_0, pld_pll_cal_done, pld_chnl_cal_done,
   pld_avmm2_readdatavalid, pld_avmm2_readdata, 
   pld_avmm2_cmdfifo_wr_pfull, pld_avmm2_cmdfifo_wr_full,
   pld_avmm2_busy, pld_avmm1_readdatavalid, pld_avmm1_readdata,
   pld_avmm1_reserved_out, pld_avmm2_reserved_out,
   pld_avmm1_cmdfifo_wr_pfull, pld_avmm1_cmdfifo_wr_full,
   pld_avmm1_busy, nfrzdrv_out, hip_avmm_writedone,
   hip_avmm_readdatavalid, hip_avmm_readdata, 
   hip_avmm_reserved_out, csr_rdy_out,
   csr_rdy_dly_out, csr_pipe_out, csr_out, csr_clk_out,
   //avmm_hrdrst_data_transfer_en, 
   pld_hssi_osc_transfer_en,
   avmm_hrdrst_fabric_osc_transfer_en_sync, 
   avmm_hrdrst_fabric_osc_transfer_en, 
   //avmm_clock_dprio_clk,
   //avmm_clock_csr_clk_n, avmm_clock_csr_clk,
   //aib_fabric_rx_dll_lock_req, 
   aib_fabric_csr_rdy_dly_in,
   aib_fabric_avmm2_data_out, aib_fabric_avmm1_data_out,
   r_tx_fifo_power_mode,
   r_tx_stretch_num_stages,
   r_tx_datapath_tb_sel, 
   r_tx_wr_adj_en, 
   r_tx_rd_adj_en, 
   r_rx_write_ctrl,
   r_rx_fifo_power_mode,
   r_rx_stretch_num_stages,
   r_rx_datapath_tb_sel, 
   r_rx_wr_adj_en, 
   r_rx_rd_adj_en,       
   r_rx_pipe_en,
   r_rx_lpbk_en,
   r_sr_reserbits_in_en,
   r_sr_reserbits_out_en, 
   // Inputs
   dft_adpt_aibiobsr_fastclkn,
   adapter_scan_rst_n, adapter_scan_mode_n,
   adapter_scan_shift_n, adapter_scan_shift_clk,
   adapter_scan_user_clk0, adapter_scan_user_clk3,
   adapter_clk_sel_n, adapter_occ_enable,
   usermode_in, csr_config, adapter_config_scan_in,
   tx_chnl_dprio_status_write_en_ack,
   tx_chnl_dprio_status, 
   rx_chnl_dprio_status_write_en_ack, rx_chnl_dprio_status, 
   //rx_asn_dll_lock_en, 
   pld_avmm2_writedata, pld_avmm2_write,
   pld_avmm2_request, pld_avmm2_reg_addr, pld_avmm2_read,
   pld_avmm2_clk_rowclk, pld_avmm1_writedata,
   pld_avmm1_write, pld_avmm1_request, pld_avmm1_reg_addr,
   pld_avmm1_read, pld_avmm1_clk_rowclk,
   pld_avmm1_reserved_in, pld_avmm2_reserved_in,
   nfrzdrv_in, pr_channel_freeze_n,
   hip_avmm_writedata, hip_avmm_write, hip_avmm_reg_addr, 
   hip_avmm_read, csr_rdy_in, csr_rdy_dly_in, csr_pipe_in, csr_in,
   csr_clk_in, avmm2_hssi_fabric_ssr_load, avmm2_hssi_fabric_ssr_data,
   avmm1_hssi_fabric_ssr_load, avmm1_hssi_fabric_ssr_data,
   aib_fabric_tx_sr_clk_in, aib_fabric_rx_sr_clk_in,
   //aib_fabric_rx_dll_lock, 
   //aib_fabric_osc_dll_lock,
   aib_fabric_avmm2_data_in, aib_fabric_avmm1_data_in,
   r_rx_hrdrst_rx_osc_clk_scg_en, r_rx_free_run_div_clk, r_rx_hrdrst_rst_sm_dis, r_rx_hrdrst_dll_lock_bypass, r_rx_hrdrst_align_bypass, r_rx_hrdrst_user_ctl_en,
//   r_rx_hrdrst_master_sel, r_rx_hrdrst_dist_master_sel, 
   r_rx_ds_last_chnl, r_rx_us_last_chnl,
   r_tx_hrdrst_rx_osc_clk_scg_en, r_tx_hip_osc_clk_scg_en,
   r_tx_hrdrst_rst_sm_dis, r_tx_hrdrst_dcd_cal_done_bypass, r_tx_hrdrst_user_ctl_en,
//   r_tx_hrdrst_master_sel, r_tx_hrdrst_dist_master_sel, 
   r_tx_ds_last_chnl, r_tx_us_last_chnl,
   avmm_hrdrst_fabric_osc_transfer_en_ssr_data, avmm_fabric_hssi_ssr_load, 
   avmm_hrdrst_hssi_osc_transfer_en_ssr_data, avmm_hssi_fabric_ssr_load
   );


/*AUTOINPUT*/
// Beginning of automatic inputs (from unused autoinst inputs)
input			dft_adpt_aibiobsr_fastclkn;
input                   adapter_scan_rst_n;
input                   adapter_scan_mode_n;
input                   adapter_scan_shift_n;
input                   adapter_scan_shift_clk;
input                   adapter_scan_user_clk0;         // 125MHz
input                   adapter_scan_user_clk3;         // 1GHz
input                   adapter_clk_sel_n;
input                   adapter_occ_enable;
input 		aib_fabric_avmm1_data_in;// To hdpldadapt_avmm1 of hdpldadapt_avmm1.v
input 		aib_fabric_avmm2_data_in;// To hdpldadapt_avmm2 of hdpldadapt_avmm2.v
//input			aib_fabric_osc_dll_lock;// To hdpldadapt_hrdrst_rstctrl of hdpldadapt_hrdrst_rstctrl.v
//input			aib_fabric_rx_dll_lock;	// To hdpldadapt_hrdrst_rstctrl of hdpldadapt_hrdrst_rstctrl.v
input			aib_fabric_rx_sr_clk_in;// To hdpldadapt_avmm1 of hdpldadapt_avmm1.v, ...
input			aib_fabric_tx_sr_clk_in;// To hdpldadapt_avmm1 of hdpldadapt_avmm1.v, ...
input [1:0]		avmm1_hssi_fabric_ssr_data;// To hdpldadapt_avmm1 of hdpldadapt_avmm1.v
input			avmm1_hssi_fabric_ssr_load;// To hdpldadapt_avmm1 of hdpldadapt_avmm1.v
input [1:0]		avmm2_hssi_fabric_ssr_data;// To hdpldadapt_avmm2 of hdpldadapt_avmm2.v
input			avmm2_hssi_fabric_ssr_load;// To hdpldadapt_avmm2 of hdpldadapt_avmm2.v
input			csr_clk_in;		// To hdpldadapt_avmm1 of hdpldadapt_avmm1.v, ...
input [2:0]             csr_config;
input [2:0]		csr_in;			// To hdpldadapt_avmm1 of hdpldadapt_avmm1.v
input [2:0]		csr_pipe_in;		// To hdpldadapt_avmm1 of hdpldadapt_avmm1.v
input			csr_rdy_dly_in;		// To hdpldadapt_avmm1 of hdpldadapt_avmm1.v, ...
input			csr_rdy_in;		// To hdpldadapt_avmm1 of hdpldadapt_avmm1.v, ...
input			hip_avmm_read;		// To hdpldadapt_avmm2 of hdpldadapt_avmm2.v
input [20:0]		hip_avmm_reg_addr;	// To hdpldadapt_avmm2 of hdpldadapt_avmm2.v
input			hip_avmm_write;		// To hdpldadapt_avmm2 of hdpldadapt_avmm2.v
input [7:0]		hip_avmm_writedata;	// To hdpldadapt_avmm2 of hdpldadapt_avmm2.v
input			nfrzdrv_in;		// To hdpldadapt_hrdrst_rstctrl of hdpldadapt_hrdrst_rstctrl.v
input                   pr_channel_freeze_n;
input			pld_avmm1_clk_rowclk;	// To hdpldadapt_avmm1 of hdpldadapt_avmm1.v
input			pld_avmm1_read;		// To hdpldadapt_avmm1 of hdpldadapt_avmm1.v
input [9:0]		pld_avmm1_reg_addr;	// To hdpldadapt_avmm1 of hdpldadapt_avmm1.v
input			pld_avmm1_request;	// To hdpldadapt_avmm1 of hdpldadapt_avmm1.v
input			pld_avmm1_write;	// To hdpldadapt_avmm1 of hdpldadapt_avmm1.v
input [7:0]		pld_avmm1_writedata;	// To hdpldadapt_avmm1 of hdpldadapt_avmm1.v
input [8:0]		pld_avmm1_reserved_in;
input			pld_avmm2_clk_rowclk;	// To hdpldadapt_avmm2 of hdpldadapt_avmm2.v
input			pld_avmm2_read;		// To hdpldadapt_avmm2 of hdpldadapt_avmm2.v
input [8:0]		pld_avmm2_reg_addr;	// To hdpldadapt_avmm2 of hdpldadapt_avmm2.v
input			pld_avmm2_request;	// To hdpldadapt_avmm2 of hdpldadapt_avmm2.v
input			pld_avmm2_write;	// To hdpldadapt_avmm2 of hdpldadapt_avmm2.v
input [7:0]		pld_avmm2_writedata;	// To hdpldadapt_avmm2 of hdpldadapt_avmm2.v
input [9:4]		pld_avmm2_reserved_in;
//input			rx_asn_dll_lock_en;	// To hdpldadapt_hrdrst_rstctrl of hdpldadapt_hrdrst_rstctrl.v
input [7:0]		rx_chnl_dprio_status;	// To hdpldadapt_avmm1 of hdpldadapt_avmm1.v
input			rx_chnl_dprio_status_write_en_ack;// To hdpldadapt_avmm1 of hdpldadapt_avmm1.v
input [3:0] 	        adapter_config_scan_in;		// To hdpldadapt_avmm1 of hdpldadapt_avmm1.v
input [7:0]		tx_chnl_dprio_status;	// To hdpldadapt_avmm1 of hdpldadapt_avmm1.v
input			tx_chnl_dprio_status_write_en_ack;// To hdpldadapt_avmm1 of hdpldadapt_avmm1.v
input			usermode_in;		// To hdpldadapt_hrdrst_rstctrl of hdpldadapt_hrdrst_rstctrl.v
input                   avmm_fabric_hssi_ssr_load;
input                   avmm_hrdrst_hssi_osc_transfer_en_ssr_data;
input                   avmm_hssi_fabric_ssr_load;
// End of automatics
/*AUTOOUTPUT*/
// Beginning of automatic outputs (from unused autoinst outputs)

// new ouputs for ECO8
    output  wire [1:0]  r_tx_wren_fastbond;
    output  wire [1:0]  r_tx_rden_fastbond;                                
    output  wire [1:0]  r_rx_wren_fastbond;
    output  wire [1:0]  r_rx_rden_fastbond;
   
output                  sr_hssi_osc_transfer_en;
output                  avmm_hrdrst_fabric_osc_transfer_en_ssr_data;
output [1:0]		aib_fabric_avmm1_data_out;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [1:0]		aib_fabric_avmm2_data_out;// From hdpldadapt_avmm2 of hdpldadapt_avmm2.v
output			aib_fabric_csr_rdy_dly_in;
//output			aib_fabric_rx_dll_lock_req;// From hdpldadapt_hrdrst_rstctrl of hdpldadapt_hrdrst_rstctrl.v
//output			avmm_clock_csr_clk;	// From hdpldadapt_avmm2 of hdpldadapt_avmm2.v
//output			avmm_clock_csr_clk_n;	// From hdpldadapt_avmm2 of hdpldadapt_avmm2.v
//output			avmm_clock_dprio_clk;	// From hdpldadapt_avmm2 of hdpldadapt_avmm2.v
//output			avmm_hrdrst_data_transfer_en;// From hdpldadapt_hrdrst_rstctrl of hdpldadapt_hrdrst_rstctrl.v
output			avmm1_transfer_error;
output			avmm2_transfer_error;
output [19:0]		avmm_testbus;
output			pld_hssi_osc_transfer_en;
output			avmm_hrdrst_fabric_osc_transfer_en_sync;
output			avmm_hrdrst_fabric_osc_transfer_en;
output			csr_clk_out;		// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [2:0]		csr_out;		// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [2:0]		csr_pipe_out;		// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			csr_rdy_dly_out;	// From hdpldadapt_hrdrst_rstctrl of hdpldadapt_hrdrst_rstctrl.v
output			csr_rdy_out;		// From hdpldadapt_hrdrst_rstctrl of hdpldadapt_hrdrst_rstctrl.v
output [7:0]		hip_avmm_readdata;	// From hdpldadapt_avmm2 of hdpldadapt_avmm2.v
output			hip_avmm_readdatavalid;	// From hdpldadapt_avmm2 of hdpldadapt_avmm2.v
output			hip_avmm_writedone;	// From hdpldadapt_avmm2 of hdpldadapt_avmm2.v
output [4:0]		hip_avmm_reserved_out;
output			nfrzdrv_out;		// From hdpldadapt_hrdrst_rstctrl of hdpldadapt_hrdrst_rstctrl.v
output			pld_avmm1_busy;		// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			pld_avmm1_cmdfifo_wr_full;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			pld_avmm1_cmdfifo_wr_pfull;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		pld_avmm1_readdata;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			pld_avmm1_readdatavalid;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [2:0]		pld_avmm1_reserved_out;
output			pld_avmm2_busy;		// From hdpldadapt_avmm2 of hdpldadapt_avmm2.v
output			pld_avmm2_cmdfifo_wr_full;// From hdpldadapt_avmm2 of hdpldadapt_avmm2.v
output			pld_avmm2_cmdfifo_wr_pfull;// From hdpldadapt_avmm2 of hdpldadapt_avmm2.v
output [7:0]		pld_avmm2_readdata;	// From hdpldadapt_avmm2 of hdpldadapt_avmm2.v
output			pld_avmm2_readdatavalid;// From hdpldadapt_avmm2 of hdpldadapt_avmm2.v
output [2:2]		pld_avmm2_reserved_out;
output			pld_chnl_cal_done;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			pld_pll_cal_done;	// From hdpldadapt_avmm2 of hdpldadapt_avmm2.v
output [7:0]		r_aib_csr_ctrl_0;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_1;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_10;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_11;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_12;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_13;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_14;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_15;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_16;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_17;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_18;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_19;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_2;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_20;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_21;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_22;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_23;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_24;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_25;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_26;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_27;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_28;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_29;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_3;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_30;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_31;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_32;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_33;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_34;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_35;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_36;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_37;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_38;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_39;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_4;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_40;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_41;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_42;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_43;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_44;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_45;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_46;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_47;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_48;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_49;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_5;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_50;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_51;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_52;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_53;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_54;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_55;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_56;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_57;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_6;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_7;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_8;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_csr_ctrl_9;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_dprio_ctrl_0;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_dprio_ctrl_1;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_dprio_ctrl_2;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_dprio_ctrl_3;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_aib_dprio_ctrl_4;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [1:0]		r_rx_aib_clk1_sel;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [1:0]		r_rx_aib_clk2_sel;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output                  r_rx_pld_8g_eidleinfersel_polling_bypass;
output                  r_rx_pld_pma_eye_monitor_polling_bypass;
output                  r_rx_pld_pma_pcie_switch_polling_bypass;
output                  r_rx_pld_pma_reser_out_polling_bypass;
output			r_rx_async_pld_10g_rx_crc32_err_rst_val;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_rx_async_pld_8g_signal_detect_out_rst_val;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_rx_async_pld_ltr_rst_val;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_rx_async_pld_pma_ltd_b_rst_val;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_rx_async_pld_rx_fifo_align_clr_rst_val;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_rx_async_prbs_flags_sr_enable;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output                   r_rx_hrdrst_rx_osc_clk_scg_en;
output                   r_rx_free_run_div_clk;
output                   r_rx_hrdrst_rst_sm_dis;
output                   r_rx_hrdrst_dll_lock_bypass;
output                   r_rx_hrdrst_align_bypass;
output			r_rx_hrdrst_user_ctl_en;
//output [1:0]      	r_rx_hrdrst_master_sel;
//output            	r_rx_hrdrst_dist_master_sel;
output            	r_rx_ds_last_chnl;
output            	r_rx_us_last_chnl;
output			r_rx_bonding_dft_in_en;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_rx_bonding_dft_in_value;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output                  r_rx_asn_en;
output                  r_rx_asn_bypass_pma_pcie_sw_done;
output [7:0]            r_rx_asn_wait_for_fifo_flush_cnt;
output [7:0]            r_rx_asn_wait_for_dll_reset_cnt;
output [7:0]            r_rx_asn_wait_for_pma_pcie_sw_done_cnt;
//output [1:0]            r_rx_asn_master_sel;
//output                  r_rx_asn_dist_master_sel;
//output                  r_rx_asn_bonding_dft_in_en;
//output                  r_rx_asn_bonding_dft_in_value;
output [7:0]		r_rx_comp_cnt;		// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [1:0]		r_rx_compin_sel;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
//output			r_rx_coreclkin_sel;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_rx_double_read;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_rx_ds_bypass_pipeln;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_rx_ds_master;		// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [5:0]		r_rx_fifo_empty;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [5:0]		r_rx_fifo_full;		// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [2:0]		r_rx_fifo_mode;		// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [5:0]		r_rx_fifo_pempty;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [5:0]		r_rx_fifo_pfull;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_rx_fifo_rd_clk_scg_en;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [1:0]		r_rx_fifo_rd_clk_sel;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_rx_fifo_wr_clk_scg_en;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output 			r_rx_fifo_wr_clk_sel;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_rx_gb_dv_en;		// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_rx_indv;		// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [2:0]		r_rx_phcomp_rd_delay;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_rx_pld_clk1_sel;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_rx_pld_clk1_delay_en;
output[3:0]		r_rx_pld_clk1_delay_sel;
output			r_rx_pld_clk1_inv_en;
//output			r_rx_pld_clk2_sel;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_rx_pma_hclk_scg_en;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_rx_osc_clk_scg_en;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_rx_fifo_wr_clk_del_sm_scg_en; 
output			r_rx_fifo_rd_clk_ins_sm_scg_en;
output			r_rx_sclk_sel;		// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output                   r_rx_internal_clk1_sel1;
output                   r_rx_internal_clk1_sel2;
output                   r_rx_txfiford_post_ct_sel;
output                   r_rx_txfifowr_post_ct_sel;
output                   r_rx_internal_clk2_sel1;
output                   r_rx_internal_clk2_sel2;
output                   r_rx_rxfifowr_post_ct_sel;
output                   r_rx_rxfiford_post_ct_sel;
output			r_rx_stop_read;		// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_rx_stop_write;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_rx_truebac2bac;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_rx_us_bypass_pipeln;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_rx_us_master;		// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_rx_wa_en;		// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_sr_hip_en;		// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_rx_write_ctrl;
output  [2:0]	        r_rx_fifo_power_mode;
output  [2:0]	        r_rx_stretch_num_stages; 
output  [3:0]	        r_rx_datapath_tb_sel;
output  		r_rx_wr_adj_en;
output                  r_rx_rd_adj_en;
output                  r_rx_pipe_en; 
output                  r_rx_lpbk_en;
//output			r_sr_hip_fsr_in_bit0_rst_val;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
//output			r_sr_hip_fsr_in_bit1_rst_val;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
//output			r_sr_hip_fsr_in_bit2_rst_val;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
//output			r_sr_hip_fsr_in_bit3_rst_val;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
//output			r_sr_hip_fsr_out_bit0_rst_val;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
//output			r_sr_hip_fsr_out_bit1_rst_val;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
//output			r_sr_hip_fsr_out_bit2_rst_val;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
//output			r_sr_hip_fsr_out_bit3_rst_val;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
//output			r_sr_pld_10g_rx_crc32_err_rst_val;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
//output			r_sr_pld_8g_signal_detect_out_rst_val;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
//output			r_sr_pld_ltr_rst_val;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
//output			r_sr_pld_pma_ltd_b_rst_val;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
//output			r_sr_pld_pmaif_mask_tx_pll_rst_val;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
//output			r_sr_pld_rx_fifo_align_clr_rst_val;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
//output			r_sr_pld_txelecidle_rst_val;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_sr_osc_clk_scg_en;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [3:0]            r_tx_hip_aib_ssr_in_polling_bypass;
output                  r_tx_pld_8g_tx_boundary_sel_polling_bypass;
output                  r_tx_pld_10g_tx_bitslip_polling_bypass;
output                  r_tx_pld_pma_fpll_cnt_sel_polling_bypass;
output                  r_tx_pld_pma_fpll_num_phase_shifts_polling_bypass;
output [1:0]		r_tx_aib_clk1_sel;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [1:0]		r_tx_aib_clk2_sel;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_tx_async_hip_aib_fsr_in_bit0_rst_val;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_tx_async_hip_aib_fsr_in_bit1_rst_val;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_tx_async_hip_aib_fsr_in_bit2_rst_val;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_tx_async_hip_aib_fsr_in_bit3_rst_val;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_tx_async_hip_aib_fsr_out_bit0_rst_val;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_tx_async_hip_aib_fsr_out_bit1_rst_val;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_tx_async_hip_aib_fsr_out_bit2_rst_val;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_tx_async_hip_aib_fsr_out_bit3_rst_val;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_tx_async_pld_pmaif_mask_tx_pll_rst_val;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_tx_async_pld_txelecidle_rst_val;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_tx_bonding_dft_in_en;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_tx_bonding_dft_in_value;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_tx_burst_en;		// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_tx_bypass_frmgen;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [7:0]		r_tx_comp_cnt;		// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [1:0]		r_tx_compin_sel;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_tx_double_write;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_tx_ds_bypass_pipeln;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_tx_ds_master;		// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_tx_dv_indv;		// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [4:0]		r_tx_fifo_empty;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [4:0]		r_tx_fifo_full;		// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [2:0]		r_tx_fifo_mode;		// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [4:0]		r_tx_fifo_pempty;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [4:0]		r_tx_fifo_pfull;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_tx_fifo_rd_clk_frm_gen_scg_en;
output			r_tx_fifo_rd_clk_scg_en;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [1:0]		r_tx_fifo_rd_clk_sel;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_tx_fifo_wr_clk_scg_en;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
//output			r_tx_fifo_wr_clk_sel;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_tx_fpll_shared_direct_async_in_sel;
output			r_tx_gb_dv_en;		// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [2:0]		r_tx_gb_idwidth;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [1:0]		r_tx_gb_odwidth;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_tx_indv;		// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [15:0]		r_tx_mfrm_length;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [2:0]		r_tx_phcomp_rd_delay;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_tx_pipeln_frmgen;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_tx_pld_clk1_sel;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_tx_pld_clk1_delay_en;
output[3:0]		r_tx_pld_clk1_delay_sel;
output			r_tx_pld_clk1_inv_en;
output			r_tx_pld_clk2_sel;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_tx_pyld_ins;		// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_tx_osc_clk_scg_en;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_tx_sh_err;		// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_tx_stop_read;		// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_tx_stop_write;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_tx_us_bypass_pipeln;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_tx_us_master;		// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			r_tx_wm_en;		// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output  [2:0]	        r_tx_fifo_power_mode;
output  [2:0]	        r_tx_stretch_num_stages; 
output  [2:0]	        r_tx_datapath_tb_sel; 
output  		r_tx_wr_adj_en;
output                  r_tx_rd_adj_en;
output                  r_tx_usertest_sel;
output                  r_rx_usertest_sel;

output			r_tx_wordslip;		// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			rx_chnl_dprio_status_write_en;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output [3:0]		adapter_config_scan_out;		// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			tx_chnl_dprio_status_write_en;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
output			usermode_out;		// From hdpldadapt_hrdrst_rstctrl of hdpldadapt_hrdrst_rstctrl.v
output                  r_tx_hrdrst_rst_sm_dis;
output                  r_tx_hrdrst_dcd_cal_done_bypass;
output			r_tx_hrdrst_user_ctl_en;
//output [1:0]      	r_tx_hrdrst_master_sel;
//output            	r_tx_hrdrst_dist_master_sel;
output            	r_tx_ds_last_chnl;
output            	r_tx_us_last_chnl;
output                  r_tx_hrdrst_rx_osc_clk_scg_en;
output			r_tx_hip_osc_clk_scg_en;
output                  r_sr_reserbits_in_en;
output                  r_sr_reserbits_out_en;
output                  r_sr_testbus_sel;
output                  r_sr_parity_en;
output [1:0]            avmm1_ssr_parity_checker_in;
output [1:0]            avmm2_ssr_parity_checker_in;

// End of automatics
/*AUTOWIRE*/
// Beginning of automatic wires (for undeclared instantiated-module outputs)
wire [1:0]              r_avmm_testbus_sel;  
wire			r_avmm2_avmm_clk_scg_en;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
//wire			r_avmm2_avmm_clk_sel;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
wire [5:0]		r_avmm2_cmdfifo_empty;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
wire [5:0]		r_avmm2_cmdfifo_full;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
wire [5:0]		r_avmm2_cmdfifo_pfull;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
wire			r_avmm2_cmdfifo_stop_read;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
wire			r_avmm2_cmdfifo_stop_write;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
wire			r_avmm2_hip_sel;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
wire			r_avmm2_gate_dis;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
wire [5:0]		r_avmm2_rdfifo_empty;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
wire [5:0]		r_avmm2_rdfifo_full;	// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
wire			r_avmm2_rdfifo_stop_read;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
wire			r_avmm2_rdfifo_stop_write;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
wire			r_avmm2_osc_clk_scg_en;// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
//wire [7:0]		r_avmm_reset_0;		// From hdpldadapt_avmm1 of hdpldadapt_avmm1.v
wire			avmm_clock_csr_clk;
wire			avmm_clock_csr_clk_n;
// End of automatics
wire                    sr_hssi_osc_transfer_en;
//wire                    r_avmm_hrdrst_osc_dll_lock_bypass;
wire                    r_avmm_hrdrst_osc_clk_scg_en;
wire                    avmm_reset_hrdrst_rx_osc_clk_rst_n;
wire                    avmm_reset_hrdrst_tx_osc_clk_rst_n;
wire                    avmm_clock_hrdrst_tx_osc_clk;
wire			avmm_clock_hrdrst_rx_osc_clk;
wire			avmm_clock_reset_hrdrst_rx_osc_clk;
wire			avmm_clock_reset_hrdrst_tx_osc_clk;

wire                    avmm_hrdrst_testbus; 
wire [10:0]             avmm1_cmn_intf_testbus;
wire [10:0]             avmm1_transfer_testbus;
wire [10:0]             avmm2_transfer_testbus;
wire [9:0]		int_pld_avmm2_reserved_in;
wire [2:0]		int_pld_avmm2_reserved_out;
wire [1:0]		nc_pld_avmm2_reserved_out;

assign avmm_testbus  = (r_avmm_testbus_sel == 2'b00) ? {8'h00,avmm_hrdrst_testbus,avmm1_transfer_testbus} : 
                       (r_avmm_testbus_sel == 2'b01) ? {9'h000, avmm2_transfer_testbus} :
                       (r_avmm_testbus_sel == 2'b10) ? {9'h000, avmm1_cmn_intf_testbus} : 20'd0;

assign nc_pld_avmm2_reserved_out[1:0] = int_pld_avmm2_reserved_out[1:0];
assign pld_avmm2_reserved_out[2] = int_pld_avmm2_reserved_out[2];

assign int_pld_avmm2_reserved_in[9:0] = {pld_avmm2_reserved_in[9:4],4'b0000};

hdpldadapt_avmm1 hdpldadapt_avmm1(/*AUTOINST*/
				  // Outputs
                                                // new ouputs for ECO8
                                                .r_tx_wren_fastbond (r_tx_wren_fastbond),
                                                .r_tx_rden_fastbond (r_tx_rden_fastbond),                                
                                                .r_rx_wren_fastbond (r_rx_wren_fastbond),
                                                .r_rx_rden_fastbond (r_rx_rden_fastbond),                                  
                                  .avmm1_transfer_error (avmm1_transfer_error),
                                  .avmm1_transfer_testbus (avmm1_transfer_testbus),
                                  .avmm1_cmn_intf_testbus (avmm1_cmn_intf_testbus),
				  .aib_fabric_avmm1_data_out(aib_fabric_avmm1_data_out[1:0]),
				  .csr_out		(csr_out),
				  .csr_pipe_out		(csr_pipe_out),
				  .pld_avmm1_busy	(pld_avmm1_busy),
				  .pld_avmm1_cmdfifo_wr_full(pld_avmm1_cmdfifo_wr_full),
				  .pld_avmm1_cmdfifo_wr_pfull(pld_avmm1_cmdfifo_wr_pfull),
				  .pld_avmm1_readdata	(pld_avmm1_readdata[7:0]),
				  .pld_avmm1_readdatavalid(pld_avmm1_readdatavalid),
				  .pld_avmm1_reserved_out(pld_avmm1_reserved_out),
				  .pld_chnl_cal_done	(pld_chnl_cal_done),
                                  .avmm1_ssr_parity_checker_in (avmm1_ssr_parity_checker_in),
				  .r_aib_csr_ctrl_0	(r_aib_csr_ctrl_0[7:0]),
				  .r_aib_csr_ctrl_1	(r_aib_csr_ctrl_1[7:0]),
				  .r_aib_csr_ctrl_10	(r_aib_csr_ctrl_10[7:0]),
				  .r_aib_csr_ctrl_11	(r_aib_csr_ctrl_11[7:0]),
				  .r_aib_csr_ctrl_12	(r_aib_csr_ctrl_12[7:0]),
				  .r_aib_csr_ctrl_13	(r_aib_csr_ctrl_13[7:0]),
				  .r_aib_csr_ctrl_14	(r_aib_csr_ctrl_14[7:0]),
				  .r_aib_csr_ctrl_15	(r_aib_csr_ctrl_15[7:0]),
				  .r_aib_csr_ctrl_16	(r_aib_csr_ctrl_16[7:0]),
				  .r_aib_csr_ctrl_17	(r_aib_csr_ctrl_17[7:0]),
				  .r_aib_csr_ctrl_18	(r_aib_csr_ctrl_18[7:0]),
				  .r_aib_csr_ctrl_19	(r_aib_csr_ctrl_19[7:0]),
				  .r_aib_csr_ctrl_2	(r_aib_csr_ctrl_2[7:0]),
				  .r_aib_csr_ctrl_20	(r_aib_csr_ctrl_20[7:0]),
				  .r_aib_csr_ctrl_21	(r_aib_csr_ctrl_21[7:0]),
				  .r_aib_csr_ctrl_22	(r_aib_csr_ctrl_22[7:0]),
				  .r_aib_csr_ctrl_23	(r_aib_csr_ctrl_23[7:0]),
				  .r_aib_csr_ctrl_24	(r_aib_csr_ctrl_24[7:0]),
				  .r_aib_csr_ctrl_25	(r_aib_csr_ctrl_25[7:0]),
				  .r_aib_csr_ctrl_26	(r_aib_csr_ctrl_26[7:0]),
				  .r_aib_csr_ctrl_27	(r_aib_csr_ctrl_27[7:0]),
				  .r_aib_csr_ctrl_28	(r_aib_csr_ctrl_28[7:0]),
				  .r_aib_csr_ctrl_29	(r_aib_csr_ctrl_29[7:0]),
				  .r_aib_csr_ctrl_3	(r_aib_csr_ctrl_3[7:0]),
				  .r_aib_csr_ctrl_30	(r_aib_csr_ctrl_30[7:0]),
				  .r_aib_csr_ctrl_31	(r_aib_csr_ctrl_31[7:0]),
				  .r_aib_csr_ctrl_32	(r_aib_csr_ctrl_32[7:0]),
				  .r_aib_csr_ctrl_33	(r_aib_csr_ctrl_33[7:0]),
				  .r_aib_csr_ctrl_34	(r_aib_csr_ctrl_34[7:0]),
				  .r_aib_csr_ctrl_35	(r_aib_csr_ctrl_35[7:0]),
				  .r_aib_csr_ctrl_36	(r_aib_csr_ctrl_36[7:0]),
				  .r_aib_csr_ctrl_37	(r_aib_csr_ctrl_37[7:0]),
				  .r_aib_csr_ctrl_38	(r_aib_csr_ctrl_38[7:0]),
				  .r_aib_csr_ctrl_39	(r_aib_csr_ctrl_39[7:0]),
				  .r_aib_csr_ctrl_4	(r_aib_csr_ctrl_4[7:0]),
				  .r_aib_csr_ctrl_40	(r_aib_csr_ctrl_40[7:0]),
				  .r_aib_csr_ctrl_41	(r_aib_csr_ctrl_41[7:0]),
				  .r_aib_csr_ctrl_42	(r_aib_csr_ctrl_42[7:0]),
				  .r_aib_csr_ctrl_43	(r_aib_csr_ctrl_43[7:0]),
				  .r_aib_csr_ctrl_44	(r_aib_csr_ctrl_44[7:0]),
				  .r_aib_csr_ctrl_45	(r_aib_csr_ctrl_45[7:0]),
				  .r_aib_csr_ctrl_46	(r_aib_csr_ctrl_46[7:0]),
				  .r_aib_csr_ctrl_47	(r_aib_csr_ctrl_47[7:0]),
				  .r_aib_csr_ctrl_48	(r_aib_csr_ctrl_48[7:0]),
				  .r_aib_csr_ctrl_49	(r_aib_csr_ctrl_49[7:0]),
				  .r_aib_csr_ctrl_5	(r_aib_csr_ctrl_5[7:0]),
				  .r_aib_csr_ctrl_50	(r_aib_csr_ctrl_50[7:0]),
				  .r_aib_csr_ctrl_51	(r_aib_csr_ctrl_51[7:0]),
				  .r_aib_csr_ctrl_52	(r_aib_csr_ctrl_52[7:0]),
				  .r_aib_csr_ctrl_53	(r_aib_csr_ctrl_53[7:0]),
				  .r_aib_csr_ctrl_54	(r_aib_csr_ctrl_54[7:0]),
				  .r_aib_csr_ctrl_55	(r_aib_csr_ctrl_55[7:0]),
				  .r_aib_csr_ctrl_56	(r_aib_csr_ctrl_56[7:0]),
				  .r_aib_csr_ctrl_57	(r_aib_csr_ctrl_57[7:0]),
				  .r_aib_csr_ctrl_6	(r_aib_csr_ctrl_6[7:0]),
				  .r_aib_csr_ctrl_7	(r_aib_csr_ctrl_7[7:0]),
				  .r_aib_csr_ctrl_8	(r_aib_csr_ctrl_8[7:0]),
				  .r_aib_csr_ctrl_9	(r_aib_csr_ctrl_9[7:0]),
				  .r_aib_dprio_ctrl_0	(r_aib_dprio_ctrl_0[7:0]),
				  .r_aib_dprio_ctrl_1	(r_aib_dprio_ctrl_1[7:0]),
				  .r_aib_dprio_ctrl_2	(r_aib_dprio_ctrl_2[7:0]),
				  .r_aib_dprio_ctrl_3	(r_aib_dprio_ctrl_3[7:0]),
				  .r_aib_dprio_ctrl_4	(r_aib_dprio_ctrl_4[7:0]),
				  .r_avmm2_avmm_clk_scg_en(r_avmm2_avmm_clk_scg_en),
				  .r_avmm2_cmdfifo_empty(r_avmm2_cmdfifo_empty[5:0]),
				  .r_avmm2_cmdfifo_full	(r_avmm2_cmdfifo_full[5:0]),
				  .r_avmm2_cmdfifo_pfull(r_avmm2_cmdfifo_pfull[5:0]),
				  .r_avmm2_cmdfifo_stop_read(r_avmm2_cmdfifo_stop_read),
				  .r_avmm2_cmdfifo_stop_write(r_avmm2_cmdfifo_stop_write),
				  .r_avmm2_hip_sel	(r_avmm2_hip_sel),
				  .r_avmm2_gate_dis	(r_avmm2_gate_dis),
				  .r_avmm2_rdfifo_empty	(r_avmm2_rdfifo_empty[5:0]),
				  .r_avmm2_rdfifo_full	(r_avmm2_rdfifo_full[5:0]),
				  .r_avmm2_rdfifo_stop_read(r_avmm2_rdfifo_stop_read),
				  .r_avmm2_rdfifo_stop_write(r_avmm2_rdfifo_stop_write),
				  .r_avmm2_osc_clk_scg_en(r_avmm2_osc_clk_scg_en),
                                  .r_avmm_testbus_sel   (r_avmm_testbus_sel),
                                  .r_rx_usertest_sel(r_rx_usertest_sel),
                                  .r_tx_usertest_sel(r_tx_usertest_sel),
				  .r_rx_aib_clk1_sel	(r_rx_aib_clk1_sel[1:0]),
				  .r_rx_aib_clk2_sel	(r_rx_aib_clk2_sel[1:0]),
                                  .r_rx_pld_8g_eidleinfersel_polling_bypass   (r_rx_pld_8g_eidleinfersel_polling_bypass),
                                  .r_rx_pld_pma_eye_monitor_polling_bypass   (r_rx_pld_pma_eye_monitor_polling_bypass),
                                  .r_rx_pld_pma_pcie_switch_polling_bypass   (r_rx_pld_pma_pcie_switch_polling_bypass),
                                  .r_rx_pld_pma_reser_out_polling_bypass   (r_rx_pld_pma_reser_out_polling_bypass),
				  .r_rx_async_pld_10g_rx_crc32_err_rst_val(r_rx_async_pld_10g_rx_crc32_err_rst_val),
				  .r_rx_async_pld_8g_signal_detect_out_rst_val(r_rx_async_pld_8g_signal_detect_out_rst_val),
				  .r_rx_async_pld_ltr_rst_val(r_rx_async_pld_ltr_rst_val),
				  .r_rx_async_pld_pma_ltd_b_rst_val(r_rx_async_pld_pma_ltd_b_rst_val),
				  .r_rx_async_pld_rx_fifo_align_clr_rst_val(r_rx_async_pld_rx_fifo_align_clr_rst_val),
				  .r_rx_async_prbs_flags_sr_enable(r_rx_async_prbs_flags_sr_enable),
				  .r_rx_bonding_dft_in_en(r_rx_bonding_dft_in_en),
				  .r_rx_bonding_dft_in_value(r_rx_bonding_dft_in_value),
                                  .r_rx_hrdrst_rx_osc_clk_scg_en(r_rx_hrdrst_rx_osc_clk_scg_en),
                                  .r_rx_free_run_div_clk(r_rx_free_run_div_clk),
                                  .r_rx_hrdrst_rst_sm_dis(r_rx_hrdrst_rst_sm_dis),
                                  .r_rx_hrdrst_dll_lock_bypass(r_rx_hrdrst_dll_lock_bypass),
                                  .r_rx_hrdrst_align_bypass(r_rx_hrdrst_align_bypass),
                                  .r_rx_hrdrst_user_ctl_en(r_rx_hrdrst_user_ctl_en),
                                  .r_rx_ds_last_chnl(r_rx_ds_last_chnl),
                                  .r_rx_us_last_chnl(r_rx_us_last_chnl),
                                  .r_rx_asn_en                              (r_rx_asn_en),
                                  .r_rx_asn_bypass_pma_pcie_sw_done         (r_rx_asn_bypass_pma_pcie_sw_done),
                                  .r_rx_asn_wait_for_fifo_flush_cnt       (r_rx_asn_wait_for_fifo_flush_cnt),
                                  .r_rx_asn_wait_for_dll_reset_cnt           (r_rx_asn_wait_for_dll_reset_cnt),
                                  .r_rx_asn_wait_for_pma_pcie_sw_done_cnt   (r_rx_asn_wait_for_pma_pcie_sw_done_cnt),
				  .r_rx_comp_cnt	(r_rx_comp_cnt[7:0]),
				  .r_rx_compin_sel	(r_rx_compin_sel[1:0]),
				  .r_rx_double_read	(r_rx_double_read),
				  .r_rx_ds_bypass_pipeln(r_rx_ds_bypass_pipeln),
				  .r_rx_ds_master	(r_rx_ds_master),
				  .r_rx_fifo_empty	(r_rx_fifo_empty[5:0]),
				  .r_rx_fifo_full	(r_rx_fifo_full[5:0]),
				  .r_rx_fifo_mode	(r_rx_fifo_mode[2:0]),
				  .r_rx_fifo_pempty	(r_rx_fifo_pempty[5:0]),
				  .r_rx_fifo_pfull	(r_rx_fifo_pfull[5:0]),
				  .r_rx_fifo_rd_clk_scg_en(r_rx_fifo_rd_clk_scg_en),
				  .r_rx_fifo_rd_clk_sel	(r_rx_fifo_rd_clk_sel[1:0]),
				  .r_rx_fifo_wr_clk_scg_en(r_rx_fifo_wr_clk_scg_en),
				  .r_rx_fifo_wr_clk_sel	(r_rx_fifo_wr_clk_sel),
				  .r_rx_gb_dv_en	(r_rx_gb_dv_en),
				  .r_rx_indv		(r_rx_indv),
				  .r_rx_phcomp_rd_delay	(r_rx_phcomp_rd_delay[2:0]),
				  .r_rx_pld_clk1_sel	(r_rx_pld_clk1_sel),
				  .r_rx_pld_clk1_delay_en(r_rx_pld_clk1_delay_en),
				  .r_rx_pld_clk1_delay_sel(r_rx_pld_clk1_delay_sel[3:0]),
				  .r_rx_pld_clk1_inv_en(r_rx_pld_clk1_inv_en),
				  .r_rx_pma_hclk_scg_en	(r_rx_pma_hclk_scg_en),
				  .r_rx_osc_clk_scg_en(r_rx_osc_clk_scg_en),
				  .r_rx_fifo_wr_clk_del_sm_scg_en(r_rx_fifo_wr_clk_del_sm_scg_en),
                                  .r_rx_fifo_rd_clk_ins_sm_scg_en(r_rx_fifo_rd_clk_ins_sm_scg_en),
				  .r_rx_sclk_sel	(r_rx_sclk_sel),
                                  .r_rx_internal_clk1_sel1(r_rx_internal_clk1_sel1),
                                  .r_rx_internal_clk1_sel2(r_rx_internal_clk1_sel2),
                                  .r_rx_txfiford_post_ct_sel(r_rx_txfiford_post_ct_sel),
                                  .r_rx_txfifowr_post_ct_sel(r_rx_txfifowr_post_ct_sel),
                                  .r_rx_internal_clk2_sel1(r_rx_internal_clk2_sel1),
                                  .r_rx_internal_clk2_sel2(r_rx_internal_clk2_sel2),
                                  .r_rx_rxfifowr_post_ct_sel(r_rx_rxfifowr_post_ct_sel),
                                  .r_rx_rxfiford_post_ct_sel(r_rx_rxfiford_post_ct_sel),
				  .r_rx_stop_read	(r_rx_stop_read),
				  .r_rx_stop_write	(r_rx_stop_write),
				  .r_rx_truebac2bac	(r_rx_truebac2bac),
				  .r_rx_us_bypass_pipeln(r_rx_us_bypass_pipeln),
				  .r_rx_us_master	(r_rx_us_master),
				  .r_rx_wa_en		(r_rx_wa_en),
				  .r_rx_write_ctrl	(r_rx_write_ctrl),
      				  .r_rx_fifo_power_mode	(r_rx_fifo_power_mode),
                                  .r_rx_stretch_num_stages(r_rx_stretch_num_stages), 	
                                  .r_rx_datapath_tb_sel (r_rx_datapath_tb_sel), 
                                  .r_rx_wr_adj_en 	(r_rx_wr_adj_en), 
                                  .r_rx_rd_adj_en	(r_rx_rd_adj_en),				      
                                  .r_rx_pipe_en		(r_rx_pipe_en),
                                  .r_rx_lpbk_en		(r_rx_lpbk_en),
                                  .r_avmm_hrdrst_osc_clk_scg_en(r_avmm_hrdrst_osc_clk_scg_en),
				  .r_sr_hip_en		(r_sr_hip_en),
                                  .r_sr_testbus_sel     (r_sr_testbus_sel),
                                  .r_sr_parity_en       (r_sr_parity_en),
				  .r_sr_osc_clk_scg_en(r_sr_osc_clk_scg_en),
                                  .r_tx_hip_aib_ssr_in_polling_bypass (r_tx_hip_aib_ssr_in_polling_bypass),
                                  .r_tx_pld_8g_tx_boundary_sel_polling_bypass          (r_tx_pld_8g_tx_boundary_sel_polling_bypass),
                                  .r_tx_pld_10g_tx_bitslip_polling_bypass              (r_tx_pld_10g_tx_bitslip_polling_bypass),
                                  .r_tx_pld_pma_fpll_cnt_sel_polling_bypass            (r_tx_pld_pma_fpll_cnt_sel_polling_bypass),
                                  .r_tx_pld_pma_fpll_num_phase_shifts_polling_bypass   (r_tx_pld_pma_fpll_num_phase_shifts_polling_bypass),
				  .r_tx_aib_clk1_sel	(r_tx_aib_clk1_sel[1:0]),
				  .r_tx_aib_clk2_sel	(r_tx_aib_clk2_sel[1:0]),
				  .r_tx_async_hip_aib_fsr_in_bit0_rst_val(r_tx_async_hip_aib_fsr_in_bit0_rst_val),
				  .r_tx_async_hip_aib_fsr_in_bit1_rst_val(r_tx_async_hip_aib_fsr_in_bit1_rst_val),
				  .r_tx_async_hip_aib_fsr_in_bit2_rst_val(r_tx_async_hip_aib_fsr_in_bit2_rst_val),
				  .r_tx_async_hip_aib_fsr_in_bit3_rst_val(r_tx_async_hip_aib_fsr_in_bit3_rst_val),
				  .r_tx_async_hip_aib_fsr_out_bit0_rst_val(r_tx_async_hip_aib_fsr_out_bit0_rst_val),
				  .r_tx_async_hip_aib_fsr_out_bit1_rst_val(r_tx_async_hip_aib_fsr_out_bit1_rst_val),
				  .r_tx_async_hip_aib_fsr_out_bit2_rst_val(r_tx_async_hip_aib_fsr_out_bit2_rst_val),
				  .r_tx_async_hip_aib_fsr_out_bit3_rst_val(r_tx_async_hip_aib_fsr_out_bit3_rst_val),
				  .r_tx_async_pld_pmaif_mask_tx_pll_rst_val(r_tx_async_pld_pmaif_mask_tx_pll_rst_val),
				  .r_tx_async_pld_txelecidle_rst_val(r_tx_async_pld_txelecidle_rst_val),
				  .r_tx_bonding_dft_in_en(r_tx_bonding_dft_in_en),
				  .r_tx_bonding_dft_in_value(r_tx_bonding_dft_in_value),
				  .r_tx_burst_en	(r_tx_burst_en),
				  .r_tx_bypass_frmgen	(r_tx_bypass_frmgen),
				  .r_tx_comp_cnt	(r_tx_comp_cnt[7:0]),
				  .r_tx_compin_sel	(r_tx_compin_sel[1:0]),
				  .r_tx_double_write	(r_tx_double_write),
				  .r_tx_ds_bypass_pipeln(r_tx_ds_bypass_pipeln),
				  .r_tx_ds_master	(r_tx_ds_master),
				  .r_tx_dv_indv		(r_tx_dv_indv),
				  .r_tx_fifo_empty	(r_tx_fifo_empty[4:0]),
				  .r_tx_fifo_full	(r_tx_fifo_full[4:0]),
				  .r_tx_fifo_mode	(r_tx_fifo_mode[2:0]),
				  .r_tx_fifo_pempty	(r_tx_fifo_pempty[4:0]),
				  .r_tx_fifo_pfull	(r_tx_fifo_pfull[4:0]),
				  .r_tx_fifo_rd_clk_frm_gen_scg_en(r_tx_fifo_rd_clk_frm_gen_scg_en),
				  .r_tx_fifo_rd_clk_scg_en(r_tx_fifo_rd_clk_scg_en),
				  .r_tx_fifo_rd_clk_sel	(r_tx_fifo_rd_clk_sel[1:0]),
				  .r_tx_fifo_wr_clk_scg_en(r_tx_fifo_wr_clk_scg_en),
				  .r_tx_fpll_shared_direct_async_in_sel(r_tx_fpll_shared_direct_async_in_sel),
				  .r_tx_gb_dv_en	(r_tx_gb_dv_en),
				  .r_tx_gb_idwidth	(r_tx_gb_idwidth[2:0]),
				  .r_tx_gb_odwidth	(r_tx_gb_odwidth[1:0]),
				  .r_tx_indv		(r_tx_indv),
				  .r_tx_mfrm_length	(r_tx_mfrm_length[15:0]),
				  .r_tx_phcomp_rd_delay	(r_tx_phcomp_rd_delay[2:0]),
				  .r_tx_pipeln_frmgen	(r_tx_pipeln_frmgen),
				  .r_tx_pld_clk1_sel	(r_tx_pld_clk1_sel),
				  .r_tx_pld_clk1_delay_en(r_tx_pld_clk1_delay_en),
				  .r_tx_pld_clk1_delay_sel(r_tx_pld_clk1_delay_sel[3:0]),
				  .r_tx_pld_clk1_inv_en(r_tx_pld_clk1_inv_en),
				  .r_tx_pld_clk2_sel	(r_tx_pld_clk2_sel),
				  .r_tx_pyld_ins	(r_tx_pyld_ins),
				  .r_tx_osc_clk_scg_en(r_tx_osc_clk_scg_en),
				  .r_tx_sh_err		(r_tx_sh_err),
				  .r_tx_stop_read	(r_tx_stop_read),
				  .r_tx_stop_write	(r_tx_stop_write),
				  .r_tx_us_bypass_pipeln(r_tx_us_bypass_pipeln),
				  .r_tx_us_master	(r_tx_us_master),
				  .r_tx_wm_en		(r_tx_wm_en),
      				  .r_tx_fifo_power_mode				 (r_tx_fifo_power_mode),
                                  .r_tx_stretch_num_stages				 (r_tx_stretch_num_stages), 	
                                  .r_tx_datapath_tb_sel 				 (r_tx_datapath_tb_sel), 
                                  .r_tx_wr_adj_en 					 (r_tx_wr_adj_en), 
                                  .r_tx_rd_adj_en					 (r_tx_rd_adj_en),				  
				  .r_tx_wordslip	(r_tx_wordslip),
                                  .r_tx_hrdrst_rst_sm_dis(r_tx_hrdrst_rst_sm_dis),
                                  .r_tx_hrdrst_dcd_cal_done_bypass(r_tx_hrdrst_dcd_cal_done_bypass),
                                  .r_tx_hrdrst_user_ctl_en(r_tx_hrdrst_user_ctl_en),
                                  .r_tx_ds_last_chnl(r_tx_ds_last_chnl),
                                  .r_tx_us_last_chnl(r_tx_us_last_chnl),
                                  .r_tx_hrdrst_rx_osc_clk_scg_en(r_tx_hrdrst_rx_osc_clk_scg_en),
                                  .r_tx_hip_osc_clk_scg_en(r_tx_hip_osc_clk_scg_en),
                                  .r_sr_reserbits_in_en (r_sr_reserbits_in_en),
                                  .r_sr_reserbits_out_en (r_sr_reserbits_out_en),
				  .rx_chnl_dprio_status_write_en(rx_chnl_dprio_status_write_en),
				  .adapter_config_scan_out (adapter_config_scan_out),
				  .tx_chnl_dprio_status_write_en(tx_chnl_dprio_status_write_en),
				  // Inputs
				  .dft_adpt_aibiobsr_fastclkn(dft_adpt_aibiobsr_fastclkn),
				  .adapter_scan_rst_n(adapter_scan_rst_n),
				  .adapter_scan_mode_n  (adapter_scan_mode_n),
				  .adapter_scan_shift_n (adapter_scan_shift_n),
				  .adapter_scan_shift_clk(adapter_scan_shift_clk),
                                  .adapter_scan_user_clk0(adapter_scan_user_clk0),         // 125MHz
                                  .adapter_scan_user_clk3(adapter_scan_user_clk3),         // 1GHz
                                  .adapter_clk_sel_n(adapter_clk_sel_n),
                                  .adapter_occ_enable(adapter_occ_enable),
				  .aib_fabric_avmm1_data_in(aib_fabric_avmm1_data_in),
				  .aib_fabric_rx_sr_clk_in(aib_fabric_rx_sr_clk_in),
				  .aib_fabric_tx_sr_clk_in(aib_fabric_tx_sr_clk_in),
				  .avmm1_hssi_fabric_ssr_data(avmm1_hssi_fabric_ssr_data),
				  .avmm1_hssi_fabric_ssr_load(avmm1_hssi_fabric_ssr_load),
				  .avmm_clock_csr_clk	(avmm_clock_csr_clk),
				  .avmm_clock_csr_clk_n	(avmm_clock_csr_clk_n),
                                  .csr_config           (csr_config),
				  .csr_clk_in		(csr_clk_in),
				  .csr_in		(csr_in),
				  .csr_pipe_in		(csr_pipe_in),
				  .csr_rdy_dly_in	(csr_rdy_dly_in),
				  .csr_rdy_in		(csr_rdy_in),
				  .pld_avmm1_clk_rowclk	(pld_avmm1_clk_rowclk),
				  .pld_avmm1_read	(pld_avmm1_read),
				  .pld_avmm1_reg_addr	(pld_avmm1_reg_addr[9:0]),
				  .pld_avmm1_request	(pld_avmm1_request),
				  .pld_avmm1_write	(pld_avmm1_write),
				  .pld_avmm1_writedata	(pld_avmm1_writedata[7:0]),
				  .pld_avmm1_reserved_in(pld_avmm1_reserved_in[8:0]),
				  .rx_chnl_dprio_status	(rx_chnl_dprio_status[7:0]),
				  .rx_chnl_dprio_status_write_en_ack(rx_chnl_dprio_status_write_en_ack),
                                  .usermode_in          (usermode_in),
                                  .nfrzdrv_in           (nfrzdrv_in),
                                  //.pr_channel_freeze (pr_channel_freeze),
				  .adapter_config_scan_in (adapter_config_scan_in),
				  .tx_chnl_dprio_status	(tx_chnl_dprio_status[7:0]),
				  .tx_chnl_dprio_status_write_en_ack(tx_chnl_dprio_status_write_en_ack));
				  
hdpldadapt_hrdrst_rstctrl hdpldadapt_hrdrst_rstctrl(/*AUTOINST*/
						    // Outputs
						    .csr_rdy_out	(csr_rdy_out),
						    .csr_rdy_dly_out	(csr_rdy_dly_out),
						    .aib_fabric_csr_rdy_dly_in(aib_fabric_csr_rdy_dly_in),
						    .usermode_out	(usermode_out),
						    .nfrzdrv_out	(nfrzdrv_out),
                                                    .pld_hssi_osc_transfer_en(pld_hssi_osc_transfer_en),
                                                    .avmm_reset_hrdrst_rx_osc_clk_rst_n(avmm_reset_hrdrst_rx_osc_clk_rst_n),
                                                    .avmm_reset_hrdrst_tx_osc_clk_rst_n(avmm_reset_hrdrst_tx_osc_clk_rst_n),
                                                    .avmm_hrdrst_fabric_osc_transfer_en(avmm_hrdrst_fabric_osc_transfer_en),
                                                    .avmm_hrdrst_testbus(avmm_hrdrst_testbus),
						    // Inputs
                                                    .adapter_scan_rst_n(adapter_scan_rst_n),
                                                    .adapter_scan_mode_n(adapter_scan_mode_n),
                                                    .avmm_clock_hrdrst_rx_osc_clk(avmm_clock_hrdrst_rx_osc_clk),
                                                    .avmm_clock_reset_hrdrst_rx_osc_clk(avmm_clock_reset_hrdrst_rx_osc_clk),
                                                    .avmm_clock_reset_hrdrst_tx_osc_clk(avmm_clock_reset_hrdrst_tx_osc_clk),
                                                    .sr_hssi_osc_transfer_en(sr_hssi_osc_transfer_en),
						    .csr_rdy_in		(csr_rdy_in),
						    .csr_rdy_dly_in	(csr_rdy_dly_in),
						    .usermode_in	(usermode_in),
						    .pr_channel_freeze_n(pr_channel_freeze_n),
						    .nfrzdrv_in		(nfrzdrv_in));

hdpldadapt_hrdrst_clkctl hdpldadapt_hrdrst_clkctl(/*AUTOINST*/
                                   // output
				  .csr_clk_out		(csr_clk_out),
				  .avmm_clock_csr_clk	(avmm_clock_csr_clk),
				  .avmm_clock_csr_clk_n	(avmm_clock_csr_clk_n),
                                  .avmm_clock_hrdrst_rx_osc_clk(avmm_clock_hrdrst_rx_osc_clk),
                                  .avmm_clock_hrdrst_tx_osc_clk(avmm_clock_hrdrst_tx_osc_clk),
                                  .avmm_clock_reset_hrdrst_rx_osc_clk(avmm_clock_reset_hrdrst_rx_osc_clk),
                                  .avmm_clock_reset_hrdrst_tx_osc_clk(avmm_clock_reset_hrdrst_tx_osc_clk),
                                  // input
                                                .dft_adpt_aibiobsr_fastclkn(dft_adpt_aibiobsr_fastclkn),
                                                .adapter_scan_mode_n(adapter_scan_mode_n),
                                                .adapter_scan_shift_n(adapter_scan_shift_n),
                                                .adapter_scan_shift_clk(adapter_scan_shift_clk),
                                                .adapter_scan_user_clk3(adapter_scan_user_clk3),         // 1GHz
                                                .adapter_clk_sel_n(adapter_clk_sel_n),
                                                .adapter_occ_enable(adapter_occ_enable),
                                  .aib_fabric_rx_sr_clk_in(aib_fabric_rx_sr_clk_in),
                                  .aib_fabric_tx_sr_clk_in(aib_fabric_tx_sr_clk_in),
                                  .r_avmm_hrdrst_osc_clk_scg_en(r_avmm_hrdrst_osc_clk_scg_en),
				  .csr_clk_in		(csr_clk_in));

hdpldadapt_avmm_async hdpldadapt_avmm_async (
                                // input
                               .avmm_clock_hrdrst_rx_osc_clk(avmm_clock_hrdrst_rx_osc_clk),
                               .avmm_reset_hrdrst_rx_osc_clk_rst_n(avmm_reset_hrdrst_rx_osc_clk_rst_n),
                               .avmm_clock_hrdrst_tx_osc_clk(avmm_clock_hrdrst_tx_osc_clk),
                               .avmm_reset_hrdrst_tx_osc_clk_rst_n(avmm_reset_hrdrst_tx_osc_clk_rst_n),
                               .avmm_hrdrst_fabric_osc_transfer_en(avmm_hrdrst_fabric_osc_transfer_en),
                               .avmm_fabric_hssi_ssr_load(avmm_fabric_hssi_ssr_load),
                               .avmm_hssi_fabric_ssr_load(avmm_hssi_fabric_ssr_load),
                               .avmm_hrdrst_hssi_osc_transfer_en_ssr_data(avmm_hrdrst_hssi_osc_transfer_en_ssr_data),
                               // output 
                               .avmm_hrdrst_fabric_osc_transfer_en_sync(avmm_hrdrst_fabric_osc_transfer_en_sync),
                              .sr_hssi_osc_transfer_en(sr_hssi_osc_transfer_en),
                              .avmm_hrdrst_fabric_osc_transfer_en_ssr_data(avmm_hrdrst_fabric_osc_transfer_en_ssr_data)
                          );



hdpldadapt_avmm2 hdpldadapt_avmm2(/*AUTOINST*/
				  // Outputs
				  .aib_fabric_avmm2_data_out(aib_fabric_avmm2_data_out[1:0]),
				  //.avmm_clock_csr_clk	(avmm_clock_csr_clk),
				  //.avmm_clock_csr_clk_n	(avmm_clock_csr_clk_n),
				  //.avmm_clock_dprio_clk	(avmm_clock_dprio_clk),
				  .hip_avmm_readdata	(hip_avmm_readdata[7:0]),
				  .hip_avmm_readdatavalid(hip_avmm_readdatavalid),
				  .hip_avmm_writedone	(hip_avmm_writedone),
				  .hip_avmm_reserved_out(hip_avmm_reserved_out[4:0]),
				  .pld_avmm2_busy	(pld_avmm2_busy),
				  .pld_avmm2_cmdfifo_wr_full(pld_avmm2_cmdfifo_wr_full),
				  .pld_avmm2_cmdfifo_wr_pfull(pld_avmm2_cmdfifo_wr_pfull),
				  .pld_avmm2_readdata	(pld_avmm2_readdata[7:0]),
				  .pld_avmm2_readdatavalid(pld_avmm2_readdatavalid),
				  .pld_avmm2_reserved_out(int_pld_avmm2_reserved_out[2:0]),
				  .pld_pll_cal_done	(pld_pll_cal_done),
                                  .avmm2_transfer_error (avmm2_transfer_error),
                                  .avmm2_transfer_testbus (avmm2_transfer_testbus),
                                  .avmm2_ssr_parity_checker_in (avmm2_ssr_parity_checker_in),
				  // Inputs
                                        .dft_adpt_aibiobsr_fastclkn(dft_adpt_aibiobsr_fastclkn),
                                        .adapter_scan_rst_n(adapter_scan_rst_n),
                                                .adapter_scan_mode_n(adapter_scan_mode_n),
                                                .adapter_scan_shift_n(adapter_scan_shift_n),
                                                .adapter_scan_shift_clk(adapter_scan_shift_clk),
                                                .adapter_scan_user_clk0(adapter_scan_user_clk0),         // 125MHz
                                                .adapter_scan_user_clk3(adapter_scan_user_clk3),         // 1GHz
                                                .adapter_clk_sel_n(adapter_clk_sel_n),
                                                .adapter_occ_enable(adapter_occ_enable),
				  .aib_fabric_avmm2_data_in(aib_fabric_avmm2_data_in),
				  .aib_fabric_rx_sr_clk_in(aib_fabric_rx_sr_clk_in),
				  .aib_fabric_tx_sr_clk_in(aib_fabric_tx_sr_clk_in),
				  .avmm2_hssi_fabric_ssr_data(avmm2_hssi_fabric_ssr_data),
				  .avmm2_hssi_fabric_ssr_load(avmm2_hssi_fabric_ssr_load),
				  .csr_clk_in		(csr_clk_in),
				  .csr_rdy_dly_in	(csr_rdy_dly_in),
				  .csr_rdy_in		(csr_rdy_in),
                                  .usermode_in          (usermode_in),
                                  .nfrzdrv_in           (nfrzdrv_in),
                                  //.pr_channel_freeze (pr_channel_freeze),
				  .hip_avmm_read	(hip_avmm_read),
				  .hip_avmm_reg_addr	(hip_avmm_reg_addr[20:0]),
				  .hip_avmm_write	(hip_avmm_write),
				  .hip_avmm_writedata	(hip_avmm_writedata[7:0]),
				  .pld_avmm2_clk_rowclk	(pld_avmm2_clk_rowclk),
				  .pld_avmm2_read	(pld_avmm2_read),
				  .pld_avmm2_reg_addr	(pld_avmm2_reg_addr[8:0]),
				  .pld_avmm2_request	(pld_avmm2_request),
				  .pld_avmm2_write	(pld_avmm2_write),
				  .pld_avmm2_writedata	(pld_avmm2_writedata[7:0]),
				  .pld_avmm2_reserved_in(int_pld_avmm2_reserved_in[9:0]),
				  .r_avmm2_avmm_clk_scg_en(r_avmm2_avmm_clk_scg_en),
				  //.r_avmm2_avmm_clk_sel	(r_avmm2_avmm_clk_sel),
				  .r_avmm2_cmdfifo_empty(r_avmm2_cmdfifo_empty[5:0]),
				  .r_avmm2_cmdfifo_full	(r_avmm2_cmdfifo_full[5:0]),
				  .r_avmm2_cmdfifo_pfull(r_avmm2_cmdfifo_pfull[5:0]),
				  .r_avmm2_cmdfifo_stop_read(r_avmm2_cmdfifo_stop_read),
				  .r_avmm2_cmdfifo_stop_write(r_avmm2_cmdfifo_stop_write),
				  .r_avmm2_hip_sel	(r_avmm2_hip_sel),
				  .r_avmm2_gate_dis	(r_avmm2_gate_dis),
				  .r_avmm2_rdfifo_empty	(r_avmm2_rdfifo_empty[5:0]),
				  .r_avmm2_rdfifo_full	(r_avmm2_rdfifo_full[5:0]),
				  .r_avmm2_rdfifo_stop_read(r_avmm2_rdfifo_stop_read),
				  .r_avmm2_rdfifo_stop_write(r_avmm2_rdfifo_stop_write),
				  .r_avmm2_osc_clk_scg_en(r_avmm2_osc_clk_scg_en));

endmodule
