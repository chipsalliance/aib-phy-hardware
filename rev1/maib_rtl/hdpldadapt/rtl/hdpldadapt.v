// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module hdpldadapt
(
	// AIB
	input	wire		aib_fabric_avmm1_data_in,
	input	wire		aib_fabric_avmm2_data_in,
	input	wire	[4:0]	aib_fabric_fpll_shared_direct_async_in,
	input	wire		aib_fabric_fsr_data_in,
	input	wire		aib_fabric_fsr_load_in,
	//input	wire		aib_fabric_osc_dll_lock,
	input	wire		aib_fabric_pld_8g_rxelecidle,
	input	wire		aib_fabric_pld_pcs_rx_clk_out,
	input	wire		aib_fabric_pld_pcs_tx_clk_out,
	input	wire		aib_fabric_pld_pma_clkdiv_rx_user,
	input	wire		aib_fabric_pld_pma_clkdiv_tx_user,
	input	wire		aib_fabric_pld_pma_hclk,
	input	wire		aib_fabric_pld_pma_internal_clk1,
	input	wire		aib_fabric_pld_pma_internal_clk2,
	input	wire		aib_fabric_pld_pma_pfdmode_lock,
	input	wire		aib_fabric_pld_pma_rxpll_lock,
	input	wire		aib_fabric_pld_rx_hssi_fifo_latency_pulse,
	input	wire		aib_fabric_pld_tx_hssi_fifo_latency_pulse,
	input	wire		aib_fabric_pma_aib_tx_clk,
	input	wire	[39:0]	aib_fabric_rx_data_in,
	input	wire		aib_fabric_rx_dll_lock,
	input	wire		aib_fabric_rx_sr_clk_in,
	input	wire		aib_fabric_rx_transfer_clk,
	input	wire		aib_fabric_ssr_data_in,
	input	wire		aib_fabric_ssr_load_in,
	input	wire		aib_fabric_tx_dcd_cal_done,
	input	wire		aib_fabric_tx_sr_clk_in,

	// Adapter
	//input	wire		bond_rx_asn_ds_in_dll_lock_en,
	input	wire		bond_rx_asn_ds_in_fifo_hold,
	//input	wire		bond_rx_asn_ds_in_gen3_sel,
	//input	wire		bond_rx_asn_us_in_dll_lock_en,
	input	wire		bond_rx_asn_us_in_fifo_hold,
	//input	wire		bond_rx_asn_us_in_gen3_sel,
	input	wire		bond_rx_fifo_ds_in_rden,
	input	wire		bond_rx_fifo_ds_in_wren,
	input	wire		bond_rx_fifo_us_in_rden,
	input	wire		bond_rx_fifo_us_in_wren,
        input   wire            bond_rx_hrdrst_ds_in_fabric_rx_dll_lock,
        input   wire            bond_rx_hrdrst_us_in_fabric_rx_dll_lock,
        input   wire            bond_rx_hrdrst_ds_in_fabric_rx_dll_lock_req,
        input   wire            bond_rx_hrdrst_us_in_fabric_rx_dll_lock_req,
	input	wire		bond_tx_fifo_ds_in_dv,
	input	wire		bond_tx_fifo_ds_in_rden,
	input	wire		bond_tx_fifo_ds_in_wren,
	input	wire		bond_tx_fifo_us_in_dv,
	input	wire		bond_tx_fifo_us_in_rden,
	input	wire		bond_tx_fifo_us_in_wren,
        input   wire            bond_tx_hrdrst_ds_in_fabric_tx_dcd_cal_done,
        input   wire            bond_tx_hrdrst_us_in_fabric_tx_dcd_cal_done,
        input   wire            bond_tx_hrdrst_ds_in_fabric_tx_dcd_cal_req,
        input   wire            bond_tx_hrdrst_us_in_fabric_tx_dcd_cal_req,

	// Config
        input   wire   [2:0]    csr_config,
	input	wire		csr_clk_in,
	input	wire   [2:0]	csr_in,
	input	wire   [2:0] 	csr_pipe_in,
	input	wire		csr_rdy_dly_in,
	input	wire		csr_rdy_in,
	input	wire		nfrzdrv_in,
	input	wire		usermode_in,

	// PLD
	input	wire	[3:0]	hip_aib_fsr_in,
	input	wire	[39:0]	hip_aib_ssr_in,
	input	wire		hip_avmm_read,
	input	wire	[20:0]	hip_avmm_reg_addr,
	input	wire		hip_avmm_write,
	input	wire	[7:0]	hip_avmm_writedata,
	input	wire		pld_10g_krfec_rx_clr_errblk_cnt,
	input	wire		pld_10g_rx_align_clr,
	input	wire		pld_10g_rx_clr_ber_count,
	input	wire	[6:0]	pld_10g_tx_bitslip,
	input	wire		pld_10g_tx_burst_en,
	input	wire	[1:0]	pld_10g_tx_diag_status,
	input	wire		pld_10g_tx_wordslip,
	input	wire		pld_8g_a1a2_size,
	input	wire		pld_8g_bitloc_rev_en,
	input	wire		pld_8g_byte_rev_en,
	input	wire	[2:0]	pld_8g_eidleinfersel,
	input	wire		pld_8g_encdt,
	input	wire	[4:0]	pld_8g_tx_boundary_sel,
	input	wire		pld_adapter_rx_pld_rst_n,
	input	wire		pld_adapter_tx_pld_rst_n,
	//input	wire		pld_atpg_los_en_n,
	input	wire		pld_avmm1_clk_rowclk,
	input	wire		pld_avmm1_read,
	input	wire	[9:0]	pld_avmm1_reg_addr,
	input	wire		pld_avmm1_request,
	input	wire		pld_avmm1_write,
	input	wire	[7:0]	pld_avmm1_writedata,
	input	wire	[8:0]	pld_avmm1_reserved_in,
	input	wire		pld_avmm2_clk_rowclk,
	input	wire		pld_avmm2_read,
	input	wire	[8:0]	pld_avmm2_reg_addr,
	input	wire		pld_avmm2_request,
	input	wire		pld_avmm2_write,
	input	wire	[7:0]	pld_avmm2_writedata,
	input	wire	[9:0]	pld_avmm2_reserved_in,
	input	wire		pld_bitslip,
	input	wire	[1:0]	pld_fpll_shared_direct_async_in,
	input	wire		pld_fpll_shared_direct_async_in_rowclk,
	input	wire		pld_fpll_shared_direct_async_in_dcm,
	input	wire		pld_ltr,
	//input	wire		pld_mem_atpg_rst_n,
	input	wire		pr_channel_freeze_n,
	input	wire		pld_pcs_rx_pld_rst_n,
	input	wire		pld_pcs_tx_pld_rst_n,
	input	wire		pld_pma_adapt_start,
	input	wire		pld_pma_coreclkin_rowclk,
	input	wire		pld_pma_csr_test_dis,
	input	wire		pld_pma_early_eios,
	input	wire	[5:0]	pld_pma_eye_monitor,
	input	wire	[3:0]	pld_pma_fpll_cnt_sel,
	input	wire		pld_pma_fpll_extswitch,
	input	wire		pld_pma_fpll_lc_csr_test_dis,
	input	wire	[2:0]	pld_pma_fpll_num_phase_shifts,
	input	wire		pld_pma_fpll_pfden,
	input	wire		pld_pma_fpll_up_dn_lc_lf_rstn,
	input	wire		pld_pma_ltd_b,
	input	wire		pld_pma_nrpi_freeze,
	input	wire	[1:0]	pld_pma_pcie_switch,
	input	wire		pld_pma_ppm_lock,
	input	wire	[4:0]	pld_pma_reserved_out,
	input	wire		pld_pma_rs_lpbk_b,
	input	wire		pld_pma_rxpma_rstb,
	input	wire		pld_pma_tx_bitslip,
	input	wire		pld_pma_txdetectrx,
	input	wire		pld_pma_txpma_rstb,
	input	wire		pld_pmaif_rxclkslip,
	input	wire		pld_polinv_rx,
	input	wire		pld_polinv_tx,
	input	wire		pld_rx_clk1_rowclk,
	input	wire		pld_rx_clk2_rowclk,
//	input	wire		pld_rx_dll_lock_request,
	input	wire		pld_rx_dll_lock_req,
	input	wire		pld_rx_fabric_fifo_align_clr,
	input	wire		pld_rx_fabric_fifo_rd_en,
	input	wire		pld_rx_prbs_err_clr,
	//input	wire		pld_scan_mode_n,
	//input	wire		pld_scan_shift_n,
	input	wire		pld_sclk1_rowclk,
	input	wire		pld_sclk2_rowclk,
	input	wire		pld_syncsm_en,
	input	wire		pld_tx_clk1_rowclk,
	input	wire		pld_tx_clk2_rowclk,
//	input	wire		pld_tx_dll_lock_request,
	input	wire	[79:0]	pld_tx_fabric_data_in,
	input	wire		pld_txelecidle,
        input   wire            pld_tx_dll_lock_req,
        input   wire		pld_tx_fifo_latency_adj_en,
        input   wire		pld_rx_fifo_latency_adj_en,
	input   wire            pld_aib_fabric_rx_dll_lock_req,
	input	wire		pld_aib_fabric_tx_dcd_cal_req,
        input   wire            pld_aib_hssi_tx_dcd_cal_req,
        input   wire            pld_aib_hssi_tx_dll_lock_req,
        input   wire            pld_aib_hssi_rx_dcd_cal_req,
        input   wire    [2:0]   pld_tx_ssr_reserved_in, 
        input   wire    [1:0]   pld_rx_ssr_reserved_in, 
        input   wire            pld_pma_tx_qpi_pulldn,
        input   wire            pld_pma_tx_qpi_pullup,
        input   wire            pld_pma_rx_qpi_pullup,

	// PLD DCM
	//input	wire		pld_pma_coreclkin_dcm,
	input	wire		pld_rx_clk1_dcm,
	//input	wire		pld_rx_clk2_dcm,
	input	wire		pld_tx_clk1_dcm,
	input	wire		pld_tx_clk2_dcm,

	// uC AVMM

        // DFT
	input	wire		dft_adpt_aibiobsr_fastclkn,
        input   wire            adapter_scan_rst_n,
        input   wire            adapter_scan_mode_n,
        input   wire            adapter_scan_shift_n,
        input   wire            adapter_scan_shift_clk,
        input   wire            adapter_scan_user_clk0,         // 125MHz
        input   wire            adapter_scan_user_clk1,         // 250MHz
        input   wire            adapter_scan_user_clk2,         // 500MHz
        input   wire            adapter_scan_user_clk3,         // 1GHz
        input   wire            adapter_clk_sel_n,
        input   wire            adapter_occ_enable,
        input   wire            adapter_global_pipe_se,
        input   wire [3:0]	adapter_config_scan_in,
        input   wire [1:0]      adapter_scan_in_occ1,
        input   wire [4:0]      adapter_scan_in_occ2,
        input   wire            adapter_scan_in_occ3,
        input   wire            adapter_scan_in_occ4,
        input   wire [1:0]      adapter_scan_in_occ5,
        input   wire [10:0]     adapter_scan_in_occ6,
        input   wire            adapter_scan_in_occ7,
        input   wire            adapter_scan_in_occ8,
        input   wire            adapter_scan_in_occ9,
        input   wire            adapter_scan_in_occ10,
        input   wire            adapter_scan_in_occ11,
        input   wire            adapter_scan_in_occ12,
        input   wire            adapter_scan_in_occ13,
        input   wire            adapter_scan_in_occ14,
        input   wire            adapter_scan_in_occ15,
        input   wire            adapter_scan_in_occ16,
        input   wire            adapter_scan_in_occ17,
        input   wire [1:0]      adapter_scan_in_occ18,
        input   wire            adapter_scan_in_occ19,
        input   wire            adapter_scan_in_occ20,
        input   wire [1:0]	adapter_scan_in_occ21,
        input   wire            adapter_non_occ_scan_in,
        input   wire            adapter_occ_scan_in,
	input   wire [2:0]	dft_fabric_iaibdftcore2dll,
	input   wire [12:0]	oaibdftdll2core,


        // DFT
        output  wire [3:0]	adapter_config_scan_out,
        output  wire [1:0]      adapter_scan_out_occ1,
        output  wire [4:0]      adapter_scan_out_occ2,
        output  wire            adapter_scan_out_occ3,
        output  wire            adapter_scan_out_occ4,
        output  wire [1:0]      adapter_scan_out_occ5,
        output  wire [10:0]     adapter_scan_out_occ6,
        output  wire            adapter_scan_out_occ7,
        output  wire            adapter_scan_out_occ8,
        output  wire            adapter_scan_out_occ9,
        output  wire            adapter_scan_out_occ10,
        output  wire            adapter_scan_out_occ11,
        output  wire            adapter_scan_out_occ12,
        output  wire            adapter_scan_out_occ13,
        output  wire            adapter_scan_out_occ14,
        output  wire            adapter_scan_out_occ15,
        output  wire            adapter_scan_out_occ16,
        output  wire            adapter_scan_out_occ17,
        output  wire [1:0]      adapter_scan_out_occ18,
        output  wire            adapter_scan_out_occ19,
        output  wire            adapter_scan_out_occ20,
        output  wire [1:0]	adapter_scan_out_occ21,
        output  wire            adapter_non_occ_scan_out,
        output  wire            adapter_occ_scan_out,
	output   wire   [2:0]	iaibdftcore2dll,
	output   wire   [12:0]	dft_fabric_oaibdftdll2core,

	// AIB
	output	wire		aib_fabric_csr_rdy_dly_in,
	output	wire		aib_fabric_adapter_rx_pld_rst_n,
	output	wire		aib_fabric_adapter_tx_pld_rst_n,
	output	wire	[1:0]	aib_fabric_avmm1_data_out,
	output	wire	[1:0]	aib_fabric_avmm2_data_out,
	output	wire	[2:0]	aib_fabric_fpll_shared_direct_async_out,
	output	wire		aib_fabric_fsr_data_out,
	output	wire		aib_fabric_fsr_load_out,
	output	wire		aib_fabric_pcs_rx_pld_rst_n,
	output	wire		aib_fabric_pcs_tx_pld_rst_n,
	output	wire		aib_fabric_pld_pma_coreclkin,
	output	wire		aib_fabric_pld_pma_rxpma_rstb,
	output	wire		aib_fabric_pld_pma_txdetectrx,
	output	wire		aib_fabric_pld_pma_txpma_rstb,
	output	wire		aib_fabric_pld_sclk,
	output	wire		aib_fabric_rx_dll_lock_req,
	output	wire		aib_fabric_ssr_data_out,
	output	wire		aib_fabric_ssr_load_out,
	output	wire	[39:0]	aib_fabric_tx_data_out,
	output	wire		aib_fabric_tx_dcd_cal_req,
	output	wire		aib_fabric_tx_sr_clk_out,
	output	wire		aib_fabric_tx_transfer_clk,
	output	wire	[7:0]	r_aib_csr_ctrl_0,
	output	wire	[7:0]	r_aib_csr_ctrl_1,
	output	wire	[7:0]	r_aib_csr_ctrl_10,
	output	wire	[7:0]	r_aib_csr_ctrl_11,
	output	wire	[7:0]	r_aib_csr_ctrl_12,
	output	wire	[7:0]	r_aib_csr_ctrl_13,
	output	wire	[7:0]	r_aib_csr_ctrl_14,
	output	wire	[7:0]	r_aib_csr_ctrl_15,
	output	wire	[7:0]	r_aib_csr_ctrl_16,
	output	wire	[7:0]	r_aib_csr_ctrl_17,
	output	wire	[7:0]	r_aib_csr_ctrl_18,
	output	wire	[7:0]	r_aib_csr_ctrl_19,
	output	wire	[7:0]	r_aib_csr_ctrl_2,
	output	wire	[7:0]	r_aib_csr_ctrl_20,
	output	wire	[7:0]	r_aib_csr_ctrl_21,
	output	wire	[7:0]	r_aib_csr_ctrl_22,
	output	wire	[7:0]	r_aib_csr_ctrl_23,
	output	wire	[7:0]	r_aib_csr_ctrl_24,
	output	wire	[7:0]	r_aib_csr_ctrl_25,
	output	wire	[7:0]	r_aib_csr_ctrl_26,
	output	wire	[7:0]	r_aib_csr_ctrl_27,
	output	wire	[7:0]	r_aib_csr_ctrl_28,
	output	wire	[7:0]	r_aib_csr_ctrl_29,
	output	wire	[7:0]	r_aib_csr_ctrl_3,
	output	wire	[7:0]	r_aib_csr_ctrl_30,
	output	wire	[7:0]	r_aib_csr_ctrl_31,
	output	wire	[7:0]	r_aib_csr_ctrl_32,
	output	wire	[7:0]	r_aib_csr_ctrl_33,
	output	wire	[7:0]	r_aib_csr_ctrl_34,
	output	wire	[7:0]	r_aib_csr_ctrl_35,
	output	wire	[7:0]	r_aib_csr_ctrl_36,
	output	wire	[7:0]	r_aib_csr_ctrl_37,
	output	wire	[7:0]	r_aib_csr_ctrl_38,
	output	wire	[7:0]	r_aib_csr_ctrl_39,
	output	wire	[7:0]	r_aib_csr_ctrl_4,
	output	wire	[7:0]	r_aib_csr_ctrl_40,
	output	wire	[7:0]	r_aib_csr_ctrl_41,
	output	wire	[7:0]	r_aib_csr_ctrl_42,
	output	wire	[7:0]	r_aib_csr_ctrl_43,
	output	wire	[7:0]	r_aib_csr_ctrl_44,
	output	wire	[7:0]	r_aib_csr_ctrl_45,
	output	wire	[7:0]	r_aib_csr_ctrl_46,
	output	wire	[7:0]	r_aib_csr_ctrl_47,
	output	wire	[7:0]	r_aib_csr_ctrl_48,
	output	wire	[7:0]	r_aib_csr_ctrl_49,
	output	wire	[7:0]	r_aib_csr_ctrl_5,
	output	wire	[7:0]	r_aib_csr_ctrl_50,
	output	wire	[7:0]	r_aib_csr_ctrl_51,
	output	wire	[7:0]	r_aib_csr_ctrl_52,
	output	wire	[7:0]	r_aib_csr_ctrl_53,
	output	wire	[7:0]	r_aib_csr_ctrl_54,
	output	wire	[7:0]	r_aib_csr_ctrl_55,
	output	wire	[7:0]	r_aib_csr_ctrl_56,
	output	wire	[7:0]	r_aib_csr_ctrl_57,
	output	wire	[7:0]	r_aib_csr_ctrl_6,
	output	wire	[7:0]	r_aib_csr_ctrl_7,
	output	wire	[7:0]	r_aib_csr_ctrl_8,
	output	wire	[7:0]	r_aib_csr_ctrl_9,
	output	wire	[7:0]	r_aib_dprio_ctrl_0,
	output	wire	[7:0]	r_aib_dprio_ctrl_1,
	output	wire	[7:0]	r_aib_dprio_ctrl_2,
	output	wire	[7:0]	r_aib_dprio_ctrl_3,
	output	wire	[7:0]	r_aib_dprio_ctrl_4,

	// Adapter
	//output	wire		bond_rx_asn_ds_out_dll_lock_en,
	output	wire		bond_rx_asn_ds_out_fifo_hold,
	//output	wire		bond_rx_asn_us_out_dll_lock_en,
	output	wire		bond_rx_asn_us_out_fifo_hold,
	output	wire		bond_rx_fifo_ds_out_rden,
	output	wire		bond_rx_fifo_ds_out_wren,
	output	wire		bond_rx_fifo_us_out_rden,
	output	wire		bond_rx_fifo_us_out_wren,
        output  wire            bond_rx_hrdrst_ds_out_fabric_rx_dll_lock,
        output  wire            bond_rx_hrdrst_us_out_fabric_rx_dll_lock,
        output  wire            bond_rx_hrdrst_ds_out_fabric_rx_dll_lock_req,
        output  wire            bond_rx_hrdrst_us_out_fabric_rx_dll_lock_req,
	output	wire		bond_tx_fifo_ds_out_dv,
	output	wire		bond_tx_fifo_ds_out_rden,
	output	wire		bond_tx_fifo_ds_out_wren,
	output	wire		bond_tx_fifo_us_out_dv,
	output	wire		bond_tx_fifo_us_out_rden,
	output	wire		bond_tx_fifo_us_out_wren,
        output  wire            bond_tx_hrdrst_ds_out_fabric_tx_dcd_cal_done,
        output  wire            bond_tx_hrdrst_us_out_fabric_tx_dcd_cal_done,
        output  wire            bond_tx_hrdrst_ds_out_fabric_tx_dcd_cal_req,
        output  wire            bond_tx_hrdrst_us_out_fabric_tx_dcd_cal_req,


	// Config
	output	wire		csr_clk_out,
	output	wire   [2:0]    csr_out,
	output	wire   [2:0]	csr_pipe_out,
	output	wire		csr_rdy_dly_out,
	output	wire		csr_rdy_out,
	output	wire		nfrzdrv_out,
	output	wire		usermode_out,

	// PLD
	output	wire	[3:0]	hip_aib_fsr_out,
	output	wire	[7:0]	hip_aib_ssr_out,
	output	wire	[7:0]	hip_avmm_readdata,
	output	wire		hip_avmm_readdatavalid,
	output	wire		hip_avmm_writedone,
	output	wire 	[4:0]	hip_avmm_reserved_out,
	output	wire		pld_10g_krfec_rx_blk_lock,
	output	wire	[1:0]	pld_10g_krfec_rx_diag_data_status,
	output	wire		pld_10g_krfec_rx_frame,
	output	wire		pld_10g_krfec_tx_frame,
	output	wire		pld_krfec_tx_alignment,
//	output	wire		pld_10g_rx_align_val,
	output	wire		pld_10g_rx_crc32_err,
	output	wire		pld_rx_fabric_fifo_insert,
	output	wire		pld_rx_fabric_fifo_del,
	
	output	wire		pld_10g_rx_frame_lock,
	output	wire		pld_10g_rx_hi_ber,
	output	wire		pld_10g_tx_burst_en_exe,
	output	wire	[3:0]	pld_8g_a1a2_k1k2_flag,
	output	wire		pld_8g_empty_rmf,
	output	wire		pld_8g_full_rmf,
	output	wire		pld_8g_rxelecidle,
	output	wire		pld_8g_signal_detect_out,
	output	wire	[4:0]	pld_8g_wa_boundary,
	output	wire		pld_avmm1_busy,
	output	wire		pld_avmm1_cmdfifo_wr_full,
	output	wire		pld_avmm1_cmdfifo_wr_pfull,
	output	wire	[7:0]	pld_avmm1_readdata,
	output	wire		pld_avmm1_readdatavalid,
	output	wire	[2:0]	pld_avmm1_reserved_out,
	output	wire		pld_avmm2_busy,
	output	wire		pld_avmm2_cmdfifo_wr_full,
	output	wire		pld_avmm2_cmdfifo_wr_pfull,
	output	wire	[7:0]	pld_avmm2_readdata,
	output	wire		pld_avmm2_readdatavalid,
	output	wire	[2:0]	pld_avmm2_reserved_out,
	output	wire		pld_chnl_cal_done,
	output	wire		pld_fpll_shared_direct_async_out,
	output	wire	[3:0]	pld_fpll_shared_direct_async_out_hioint,
	output	wire	[3:0]	pld_fpll_shared_direct_async_out_dcm,
	output	wire		pld_fsr_load,
	output	wire		pld_pcs_rx_clk_out1_hioint,
	output	wire		pld_pcs_rx_clk_out2_hioint,
	output	wire		pld_pcs_tx_clk_out1_hioint,
	output	wire		pld_pcs_tx_clk_out2_hioint,
	output	wire		pld_pll_cal_done,
	output	wire		pld_pma_adapt_done,
	output	wire		pld_pma_fpll_clk0bad,
	output	wire		pld_pma_fpll_clk1bad,
	output	wire		pld_pma_fpll_clksel,
	output	wire		pld_pma_fpll_phase_done,
	output	wire		pld_pma_hclk_hioint,
	output	wire		pld_pma_internal_clk1_hioint,
	output	wire		pld_pma_internal_clk2_hioint,
	output	wire	[1:0]	pld_pma_pcie_sw_done,
	output	wire		pld_pma_pfdmode_lock,
	output	wire	[4:0]	pld_pma_reserved_in,
	output	wire		pld_pma_rx_detect_valid,
	output	wire		pld_pma_rx_found,
	output	wire		pld_pma_rxpll_lock,
	output	wire		pld_pma_signal_ok,
	output	wire	[7:0]	pld_pma_testbus,
	output	wire		pld_pmaif_mask_tx_pll,
	output	wire		pld_rx_fabric_align_done,
	output	wire	[79:0]	pld_rx_fabric_data_out,
	output	wire		pld_rx_fabric_fifo_empty,
	output	wire		pld_rx_fabric_fifo_full,
	output	wire		pld_rx_fabric_fifo_latency_pulse,
	output	wire		pld_rx_fabric_fifo_pempty,
	output	wire		pld_rx_fabric_fifo_pfull,
//	output	wire		pld_rx_fabric_realgin,
	output	wire		pld_rx_hssi_fifo_empty,
	output	wire		pld_rx_hssi_fifo_full,
	output	wire		pld_rx_hssi_fifo_latency_pulse,
	output	wire		pld_rx_prbs_done,
	output	wire		pld_rx_prbs_err,
	output	wire		pld_ssr_load,
	output	wire	[19:0]	pld_test_data,
	output	wire		pld_tx_fabric_fifo_empty,
	output	wire		pld_tx_fabric_fifo_full,
	output	wire		pld_tx_fabric_fifo_latency_pulse,
	output	wire		pld_tx_fabric_fifo_pempty,
	output	wire		pld_tx_fabric_fifo_pfull,
	output	wire		pld_tx_hssi_align_done,
	output	wire		pld_tx_hssi_fifo_empty,
	output	wire		pld_tx_hssi_fifo_full,
	output	wire		pld_tx_hssi_fifo_latency_pulse,
//	output	wire		pld_tx_hssi_realgin,
	output	wire		pld_hssi_osc_transfer_en,
        output  wire            pld_hssi_rx_transfer_en,
        output  wire            pld_fabric_tx_transfer_en,
        output  wire            pld_aib_fabric_rx_dll_lock,
        output  wire            pld_aib_fabric_tx_dcd_cal_done,
	output	wire		pld_aib_hssi_rx_dcd_cal_done,
        output  wire            pld_aib_hssi_tx_dcd_cal_done,
        output  wire            pld_aib_hssi_tx_dll_lock,
	output	wire		pld_hssi_asn_dll_lock_en,
	output	wire		pld_fabric_asn_dll_lock_en,	
        output  wire   [2:0]    pld_tx_ssr_reserved_out,
        output  wire   [1:0]    pld_rx_ssr_reserved_out,
        output  wire   [117:0]  ssrin_parallel_in,
        output  wire   [93:0]   ssrout_parallel_out_latch,

	// PLD DCM
	output	wire		pld_pcs_rx_clk_out1_dcm,
	output	wire		pld_pcs_rx_clk_out2_dcm,
	output	wire		pld_pcs_tx_clk_out1_dcm,
	output	wire		pld_pcs_tx_clk_out2_dcm
	//output	wire		pld_pma_hclk_dcm,
	//output	wire		pld_pma_internal_clk1_dcm,
	//output	wire		pld_pma_internal_clk2_dcm,

	// uC AVMM
);
// Beginning of automatic wires (for undeclared instantiated-module outputs)
//wire			aib_fabric_rx_dll_lock_req;// From hdpldadapt_avmm of hdpldadapt_avmm.v
//wire			aib_fabric_tx_transfer_clk;// From hdpldadapt_tx_chnl of hdpldadapt_tx_chnl.v
wire [1:0]		avmm1_hssi_fabric_ssr_data;// From hdpldadapt_sr of hdpldadapt_sr.v
wire			avmm1_hssi_fabric_ssr_load;// From hdpldadapt_sr of hdpldadapt_sr.v
wire [1:0]		avmm2_hssi_fabric_ssr_data;// From hdpldadapt_sr of hdpldadapt_sr.v
wire			avmm2_hssi_fabric_ssr_load;// From hdpldadapt_sr of hdpldadapt_sr.v
//wire			avmm_hrdrst_data_transfer_en;// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire [3:0]		hip_aib_async_fsr_in;	// From hdpldadapt_tx_chnl of hdpldadapt_tx_chnl.v
wire [3:0]		hip_aib_async_fsr_out;	// From hdpldadapt_sr of hdpldadapt_sr.v
wire [39:0]		hip_aib_async_ssr_in;	// From hdpldadapt_tx_chnl of hdpldadapt_tx_chnl.v
wire [7:0]		hip_aib_async_ssr_out;	// From hdpldadapt_sr of hdpldadapt_sr.v
wire [1:0]		r_rx_aib_clk1_sel;	// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire [1:0]		r_rx_aib_clk2_sel;	// From hdpldadapt_avmm of hdpldadapt_avmm.v
//wire			r_rx_asn_bonding_dft_in_en;// From hdpldadapt_avmm of hdpldadapt_avmm.v
//wire			r_rx_asn_bonding_dft_in_value;// From hdpldadapt_avmm of hdpldadapt_avmm.v
//wire			r_rx_asn_bypass_data_transfer_en;// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_rx_asn_bypass_pma_pcie_sw_done;// From hdpldadapt_avmm of hdpldadapt_avmm.v
//wire			r_rx_asn_bypass_wait_clock_idle;// From hdpldadapt_avmm of hdpldadapt_avmm.v
//wire			r_rx_asn_dist_master_sel;// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_rx_asn_en;		// From hdpldadapt_avmm of hdpldadapt_avmm.v
//wire [1:0]		r_rx_asn_master_sel;	// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire [7:0]		r_rx_asn_wait_for_fifo_flush_cnt;// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire [7:0]		r_rx_asn_wait_for_dll_reset_cnt;// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire [7:0]		r_rx_asn_wait_for_pma_pcie_sw_done_cnt;// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_rx_async_pld_10g_rx_crc32_err_rst_val;// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_rx_async_pld_8g_signal_detect_out_rst_val;// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_rx_async_pld_ltr_rst_val;// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_rx_async_pld_pma_ltd_b_rst_val;// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_rx_async_pld_rx_fifo_align_clr_rst_val;// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_rx_async_prbs_flags_sr_enable;// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_rx_bonding_dft_in_en;	// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_rx_bonding_dft_in_value;// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire [7:0]		r_rx_comp_cnt;		// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire [1:0]		r_rx_compin_sel;	// From hdpldadapt_avmm of hdpldadapt_avmm.v
//wire			r_rx_coreclkin_sel;	// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_rx_double_read;	// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_rx_ds_bypass_pipeln;	// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_rx_ds_master;		// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire [5:0]		r_rx_fifo_empty;	// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire [5:0]		r_rx_fifo_full;		// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire [2:0]		r_rx_fifo_mode;		// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire [5:0]		r_rx_fifo_pempty;	// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire [5:0]		r_rx_fifo_pfull;	// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_rx_fifo_rd_clk_scg_en;// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire [1:0]		r_rx_fifo_rd_clk_sel;	// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_rx_fifo_wr_clk_scg_en;// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire 			r_rx_fifo_wr_clk_sel;	// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_rx_gb_dv_en;		// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_rx_indv;		// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire [2:0]		r_rx_phcomp_rd_delay;	// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_rx_pld_clk1_sel;	// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_rx_pld_clk1_delay_en;
wire [3:0]		r_rx_pld_clk1_delay_sel;
wire			r_rx_pld_clk1_inv_en;
//wire			r_rx_pld_clk2_sel;	// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_rx_pma_hclk_scg_en;	// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_rx_osc_clk_scg_en;	// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_rx_fifo_wr_clk_del_sm_scg_en;
wire			r_rx_fifo_rd_clk_ins_sm_scg_en;
wire			r_rx_sclk_sel;		// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire                   r_rx_internal_clk1_sel1;
wire                   r_rx_internal_clk1_sel2;
wire                   r_rx_txfiford_post_ct_sel;
wire                   r_rx_txfifowr_post_ct_sel;
wire                   r_rx_internal_clk2_sel1;
wire                   r_rx_internal_clk2_sel2;
wire                   r_rx_rxfifowr_post_ct_sel;
wire                   r_rx_rxfiford_post_ct_sel;
wire			r_rx_stop_read;		// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_rx_stop_write;	// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_rx_truebac2bac;	// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_rx_us_bypass_pipeln;	// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_rx_us_master;		// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_rx_wa_en;		// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_sr_hip_en;		// From hdpldadapt_avmm of hdpldadapt_avmm.v
//wire			r_sr_hip_fsr_in_bit0_rst_val;// From hdpldadapt_avmm of hdpldadapt_avmm.v
//wire			r_sr_hip_fsr_in_bit1_rst_val;// From hdpldadapt_avmm of hdpldadapt_avmm.v
//wire			r_sr_hip_fsr_in_bit2_rst_val;// From hdpldadapt_avmm of hdpldadapt_avmm.v
//wire			r_sr_hip_fsr_in_bit3_rst_val;// From hdpldadapt_avmm of hdpldadapt_avmm.v
//wire			r_sr_hip_fsr_out_bit0_rst_val;// From hdpldadapt_avmm of hdpldadapt_avmm.v
//wire			r_sr_hip_fsr_out_bit1_rst_val;// From hdpldadapt_avmm of hdpldadapt_avmm.v
//wire			r_sr_hip_fsr_out_bit2_rst_val;// From hdpldadapt_avmm of hdpldadapt_avmm.v
//wire			r_sr_hip_fsr_out_bit3_rst_val;// From hdpldadapt_avmm of hdpldadapt_avmm.v
//wire			r_sr_pld_10g_rx_crc32_err_rst_val;// From hdpldadapt_avmm of hdpldadapt_avmm.v
//wire			r_sr_pld_8g_signal_detect_out_rst_val;// From hdpldadapt_avmm of hdpldadapt_avmm.v
//wire			r_sr_pld_ltr_rst_val;	// From hdpldadapt_avmm of hdpldadapt_avmm.v
//wire			r_sr_pld_pma_ltd_b_rst_val;// From hdpldadapt_avmm of hdpldadapt_avmm.v
//wire			r_sr_pld_pmaif_mask_tx_pll_rst_val;// From hdpldadapt_avmm of hdpldadapt_avmm.v
//wire			r_sr_pld_rx_fifo_align_clr_rst_val;// From hdpldadapt_avmm of hdpldadapt_avmm.v
//wire			r_sr_pld_txelecidle_rst_val;// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_sr_osc_clk_scg_en;	// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire [1:0]		r_tx_aib_clk1_sel;	// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire [1:0]		r_tx_aib_clk2_sel;	// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_tx_async_hip_aib_fsr_in_bit0_rst_val;// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_tx_async_hip_aib_fsr_in_bit1_rst_val;// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_tx_async_hip_aib_fsr_in_bit2_rst_val;// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_tx_async_hip_aib_fsr_in_bit3_rst_val;// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_tx_async_hip_aib_fsr_out_bit0_rst_val;// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_tx_async_hip_aib_fsr_out_bit1_rst_val;// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_tx_async_hip_aib_fsr_out_bit2_rst_val;// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_tx_async_hip_aib_fsr_out_bit3_rst_val;// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_tx_async_pld_pmaif_mask_tx_pll_rst_val;// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_tx_async_pld_txelecidle_rst_val;// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_tx_bonding_dft_in_en;	// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_tx_bonding_dft_in_value;// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_tx_burst_en;		// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_tx_bypass_frmgen;	// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire [7:0]		r_tx_comp_cnt;		// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire [1:0]		r_tx_compin_sel;	// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_tx_double_write;	// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_tx_ds_bypass_pipeln;	// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_tx_ds_master;		// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_tx_dv_indv;		// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire [4:0]		r_tx_fifo_empty;	// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire [4:0]		r_tx_fifo_full;		// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire [2:0]		r_tx_fifo_mode;		// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire [4:0]		r_tx_fifo_pempty;	// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire [4:0]		r_tx_fifo_pfull;	// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_tx_fifo_rd_clk_frm_gen_scg_en;
wire			r_tx_fifo_rd_clk_scg_en;// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire [1:0]		r_tx_fifo_rd_clk_sel;	// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_tx_fifo_wr_clk_scg_en;// From hdpldadapt_avmm of hdpldadapt_avmm.v
//wire			r_tx_fifo_wr_clk_sel;	// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_tx_fpll_shared_direct_async_in_sel;// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_tx_gb_dv_en;		// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire [2:0]		r_tx_gb_idwidth;	// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire [1:0]		r_tx_gb_odwidth;	// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_tx_indv;		// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire [15:0]		r_tx_mfrm_length;	// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire [2:0]		r_tx_phcomp_rd_delay;	// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_tx_pipeln_frmgen;	// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_tx_pld_clk1_sel;	// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_tx_pld_clk1_delay_en;
wire [3:0]		r_tx_pld_clk1_delay_sel;
wire			r_tx_pld_clk1_inv_en;
wire			r_tx_pld_clk2_sel;	// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_tx_pyld_ins;		// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_tx_osc_clk_scg_en;	// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_tx_sh_err;		// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_tx_stop_read;		// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_tx_stop_write;	// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_tx_us_bypass_pipeln;	// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_tx_us_master;		// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_tx_wm_en;		// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			r_tx_wordslip;		// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			rx_asn_rate_change_in_progress;
wire			rx_asn_dll_lock_en;	// From hdpldadapt_rx_chnl of hdpldadapt_rx_chnl.v
//wire			rx_asn_fifo_srst;	// From hdpldadapt_rx_chnl of hdpldadapt_rx_chnl.v
//wire			rx_asn_gen3_sel;	// From hdpldadapt_rx_chnl of hdpldadapt_rx_chnl.v
wire [2:0]		rx_async_fabric_hssi_fsr_data;// From hdpldadapt_rx_chnl of hdpldadapt_rx_chnl.v
wire			rx_async_fabric_hssi_fsr_load;// From hdpldadapt_sr of hdpldadapt_sr.v
wire [35:0]		rx_async_fabric_hssi_ssr_data;// From hdpldadapt_rx_chnl of hdpldadapt_rx_chnl.v
wire			rx_async_fabric_hssi_ssr_load;// From hdpldadapt_sr of hdpldadapt_sr.v
wire [1:0]		rx_async_hssi_fabric_fsr_data;// From hdpldadapt_sr of hdpldadapt_sr.v
wire			rx_async_hssi_fabric_fsr_load;// From hdpldadapt_sr of hdpldadapt_sr.v
wire [62:0]		rx_async_hssi_fabric_ssr_data;// From hdpldadapt_sr of hdpldadapt_sr.v
wire			rx_async_hssi_fabric_ssr_load;// From hdpldadapt_sr of hdpldadapt_sr.v
wire [7:0]		rx_chnl_dprio_status;	// From hdpldadapt_rx_chnl of hdpldadapt_rx_chnl.v
wire			rx_chnl_dprio_status_write_en;// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			rx_chnl_dprio_status_write_en_ack;// From hdpldadapt_rx_chnl of hdpldadapt_rx_chnl.v
wire			rx_fsr_mask_tx_pll;	// From hdpldadapt_tx_chnl of hdpldadapt_tx_chnl.v
wire			tx_async_fabric_hssi_fsr_data;// From hdpldadapt_tx_chnl of hdpldadapt_tx_chnl.v
wire			tx_async_fabric_hssi_fsr_load;// From hdpldadapt_sr of hdpldadapt_sr.v
wire [35:0]		tx_async_fabric_hssi_ssr_data;// From hdpldadapt_tx_chnl of hdpldadapt_tx_chnl.v
wire			tx_async_fabric_hssi_ssr_load;// From hdpldadapt_sr of hdpldadapt_sr.v
wire			tx_async_hssi_fabric_fsr_data;// From hdpldadapt_sr of hdpldadapt_sr.v
wire			tx_async_hssi_fabric_fsr_load;// From hdpldadapt_sr of hdpldadapt_sr.v
wire [12:0]		tx_async_hssi_fabric_ssr_data;// From hdpldadapt_sr of hdpldadapt_sr.v
wire			tx_async_hssi_fabric_ssr_load;// From hdpldadapt_sr of hdpldadapt_sr.v
wire [7:0]		tx_chnl_dprio_status;	// From hdpldadapt_tx_chnl of hdpldadapt_tx_chnl.v
wire			tx_chnl_dprio_status_write_en;// From hdpldadapt_avmm of hdpldadapt_avmm.v
wire			tx_chnl_dprio_status_write_en_ack;// From hdpldadapt_tx_chnl of hdpldadapt_tx_chnl.v
wire                    r_rx_hrdrst_rx_osc_clk_scg_en;
wire			r_rx_free_run_div_clk;
wire                    r_rx_hrdrst_rst_sm_dis;
wire                    r_rx_hrdrst_dll_lock_bypass;
wire                    r_rx_hrdrst_align_bypass;
wire			r_rx_hrdrst_user_ctl_en;
//wire [1:0]      	r_rx_hrdrst_master_sel;
//wire            	r_rx_hrdrst_dist_master_sel;
wire            	r_rx_ds_last_chnl;
wire            	r_rx_us_last_chnl;
wire                    r_tx_hrdrst_rst_sm_dis;
wire                    r_tx_hrdrst_dcd_cal_done_bypass;
wire			r_tx_hrdrst_user_ctl_en;
//wire [1:0]      	r_tx_hrdrst_master_sel;
//wire            	r_tx_hrdrst_dist_master_sel;
wire            	r_tx_ds_last_chnl;
wire            	r_tx_us_last_chnl;
wire                    r_tx_hrdrst_rx_osc_clk_scg_en;
wire			r_tx_hip_osc_clk_scg_en;
wire                    avmm_hrdrst_fabric_osc_transfer_en_ssr_data;
wire			avmm_hrdrst_fabric_osc_transfer_en_sync;
wire			avmm_hrdrst_fabric_osc_transfer_en;
wire                    avmm_fabric_hssi_ssr_load;
wire                    avmm_hssi_fabric_ssr_load;
wire                    avmm_hrdrst_hssi_osc_transfer_en_ssr_data;

wire  [2:0]	        r_tx_fifo_power_mode;
wire  [2:0]	        r_tx_stretch_num_stages; 
wire  [2:0]	        r_tx_datapath_tb_sel; 
wire  		        r_tx_wr_adj_en; 
wire                    r_tx_rd_adj_en; 

wire    	        r_rx_write_ctrl;
wire  [2:0]	        r_rx_fifo_power_mode;
wire  [2:0]	        r_rx_stretch_num_stages; 
wire  [3:0]	        r_rx_datapath_tb_sel;
wire  		        r_rx_wr_adj_en;
wire                    r_rx_rd_adj_en;
wire			r_rx_lpbk_en;
wire  [1:0]		rx_pld_rate;
wire  [39:0]		aib_fabric_tx_data_lpbk;

wire			tx_hrdrst_fabric_tx_transfer_en;
wire			tx_clock_fifo_rd_clk;
wire			tx_clock_fifo_wr_clk;

wire  [2:0]             tx_async_fabric_hssi_ssr_reserved;
wire  [2:0]             tx_async_hssi_fabric_ssr_reserved;
wire  [1:0]             rx_async_fabric_hssi_ssr_reserved;
wire  [1:0]             rx_async_hssi_fabric_ssr_reserved;

wire                    r_sr_reserbits_in_en;
wire                    r_sr_reserbits_out_en;
wire                    r_sr_testbus_sel;  
wire                    r_sr_parity_en;  
wire			avmm1_transfer_error;
wire			avmm2_transfer_error;
wire  [19:0]            avmm_testbus;
wire  [19:0]            sr_testbus;

wire [3:0]              r_tx_hip_aib_ssr_in_polling_bypass;
wire                    r_tx_pld_8g_tx_boundary_sel_polling_bypass;
wire                    r_tx_pld_10g_tx_bitslip_polling_bypass;
wire                    r_tx_pld_pma_fpll_cnt_sel_polling_bypass;
wire                    r_tx_pld_pma_fpll_num_phase_shifts_polling_bypass;
wire                    r_rx_pld_8g_eidleinfersel_polling_bypass;
wire                    r_rx_pld_pma_eye_monitor_polling_bypass;
wire                    r_rx_pld_pma_pcie_switch_polling_bypass;
wire                    r_rx_pld_pma_reser_out_polling_bypass;
wire                  hip_fsr_parity_checker_in;
wire  [5:0]           hip_ssr_parity_checker_in;
wire                  tx_fsr_parity_checker_in;
wire  [15:0]          tx_ssr_parity_checker_in;
wire  [1:0]           rx_fsr_parity_checker_in;
wire  [64:0]          rx_ssr_parity_checker_in;
wire  [1:0]           avmm1_ssr_parity_checker_in;
wire  [1:0]           avmm2_ssr_parity_checker_in;
wire                  sr_hssi_osc_transfer_en;
wire                  r_tx_usertest_sel;
wire                  r_rx_usertest_sel;
wire  [19:0]          sr_parity_error_flag;

// End of automatics
   
// ECO8
    wire [1:0]  r_tx_wren_fastbond;
    wire [1:0]  r_tx_rden_fastbond;                                
    wire [1:0]  r_rx_wren_fastbond;
    wire [1:0]  r_rx_rden_fastbond;   

/* hdpldadapt_avmm AUTO_TEMPLATE (
.scan_mode_n    (pld_scan_mode_n),
.scan_shift_n   (pld_scan_shift_n),
);
*/

// DFT
assign iaibdftcore2dll = dft_fabric_iaibdftcore2dll;
//assign dft_fabric_oaibdftdll2core = oaibdftdll2core;

wire  [19:0]            tx_chnl_testbus;
wire			rx_asn_fifo_hold;


hdpldadapt_avmm hdpldadapt_avmm(/*AUTOINST*/
				//   Outputs
                                                // new ouputs for ECO8
                                                .r_tx_wren_fastbond (r_tx_wren_fastbond),
                                                .r_tx_rden_fastbond (r_tx_rden_fastbond),                                
                                                .r_rx_wren_fastbond (r_rx_wren_fastbond),
                                                .r_rx_rden_fastbond (r_rx_rden_fastbond),
                                .sr_hssi_osc_transfer_en  (sr_hssi_osc_transfer_en),
                                .avmm1_ssr_parity_checker_in (avmm1_ssr_parity_checker_in),
                                .avmm2_ssr_parity_checker_in (avmm2_ssr_parity_checker_in),
                                .avmm1_transfer_error(avmm1_transfer_error),
                                .avmm2_transfer_error(avmm2_transfer_error),
                                .avmm_testbus (avmm_testbus),
				.aib_fabric_avmm1_data_out(aib_fabric_avmm1_data_out[1:0]),
				.aib_fabric_avmm2_data_out(aib_fabric_avmm2_data_out[1:0]),
				.aib_fabric_csr_rdy_dly_in(aib_fabric_csr_rdy_dly_in),
				//.aib_fabric_rx_dll_lock_req(aib_fabric_rx_dll_lock_req),
				//.avmm_clock_dprio_clk(avmm_clock_dprio_clk),
				//.avmm_hrdrst_data_transfer_en(avmm_hrdrst_data_transfer_en),
                                .pld_hssi_osc_transfer_en(pld_hssi_osc_transfer_en),
                                .avmm_hrdrst_fabric_osc_transfer_en_sync(avmm_hrdrst_fabric_osc_transfer_en_sync),
                                .avmm_hrdrst_fabric_osc_transfer_en(avmm_hrdrst_fabric_osc_transfer_en),
				.csr_clk_out	(csr_clk_out),
				.csr_out	(csr_out),
				.csr_pipe_out	(csr_pipe_out),
				.csr_rdy_dly_out(csr_rdy_dly_out),
				.csr_rdy_out	(csr_rdy_out),
				.hip_avmm_readdata(hip_avmm_readdata[7:0]),
				.hip_avmm_readdatavalid(hip_avmm_readdatavalid),
				.hip_avmm_writedone(hip_avmm_writedone),
				.hip_avmm_reserved_out(hip_avmm_reserved_out[4:0]),
				.nfrzdrv_out	(nfrzdrv_out),
				.pld_avmm1_busy	(pld_avmm1_busy),
				.pld_avmm1_cmdfifo_wr_full(pld_avmm1_cmdfifo_wr_full),
				.pld_avmm1_cmdfifo_wr_pfull(pld_avmm1_cmdfifo_wr_pfull),
				.pld_avmm1_readdata(pld_avmm1_readdata[7:0]),
				.pld_avmm1_readdatavalid(pld_avmm1_readdatavalid),
				.pld_avmm1_reserved_out(pld_avmm1_reserved_out[2:0]),
				.pld_avmm2_busy	(pld_avmm2_busy),
				.pld_avmm2_cmdfifo_wr_full(pld_avmm2_cmdfifo_wr_full),
				.pld_avmm2_cmdfifo_wr_pfull(pld_avmm2_cmdfifo_wr_pfull),
				.pld_avmm2_readdata(pld_avmm2_readdata[7:0]),
				.pld_avmm2_readdatavalid(pld_avmm2_readdatavalid),
				.pld_avmm2_reserved_out(pld_avmm2_reserved_out[2]),
				.pld_chnl_cal_done(pld_chnl_cal_done),
				.pld_pll_cal_done(pld_pll_cal_done),
				.r_aib_csr_ctrl_0(r_aib_csr_ctrl_0[7:0]),
				.r_aib_csr_ctrl_1(r_aib_csr_ctrl_1[7:0]),
				.r_aib_csr_ctrl_10(r_aib_csr_ctrl_10[7:0]),
				.r_aib_csr_ctrl_11(r_aib_csr_ctrl_11[7:0]),
				.r_aib_csr_ctrl_12(r_aib_csr_ctrl_12[7:0]),
				.r_aib_csr_ctrl_13(r_aib_csr_ctrl_13[7:0]),
				.r_aib_csr_ctrl_14(r_aib_csr_ctrl_14[7:0]),
				.r_aib_csr_ctrl_15(r_aib_csr_ctrl_15[7:0]),
				.r_aib_csr_ctrl_16(r_aib_csr_ctrl_16[7:0]),
				.r_aib_csr_ctrl_17(r_aib_csr_ctrl_17[7:0]),
				.r_aib_csr_ctrl_18(r_aib_csr_ctrl_18[7:0]),
				.r_aib_csr_ctrl_19(r_aib_csr_ctrl_19[7:0]),
				.r_aib_csr_ctrl_2(r_aib_csr_ctrl_2[7:0]),
				.r_aib_csr_ctrl_20(r_aib_csr_ctrl_20[7:0]),
				.r_aib_csr_ctrl_21(r_aib_csr_ctrl_21[7:0]),
				.r_aib_csr_ctrl_22(r_aib_csr_ctrl_22[7:0]),
				.r_aib_csr_ctrl_23(r_aib_csr_ctrl_23[7:0]),
				.r_aib_csr_ctrl_24(r_aib_csr_ctrl_24[7:0]),
				.r_aib_csr_ctrl_25(r_aib_csr_ctrl_25[7:0]),
				.r_aib_csr_ctrl_26(r_aib_csr_ctrl_26[7:0]),
				.r_aib_csr_ctrl_27(r_aib_csr_ctrl_27[7:0]),
				.r_aib_csr_ctrl_28(r_aib_csr_ctrl_28[7:0]),
				.r_aib_csr_ctrl_29(r_aib_csr_ctrl_29[7:0]),
				.r_aib_csr_ctrl_3(r_aib_csr_ctrl_3[7:0]),
				.r_aib_csr_ctrl_30(r_aib_csr_ctrl_30[7:0]),
				.r_aib_csr_ctrl_31(r_aib_csr_ctrl_31[7:0]),
				.r_aib_csr_ctrl_32(r_aib_csr_ctrl_32[7:0]),
				.r_aib_csr_ctrl_33(r_aib_csr_ctrl_33[7:0]),
				.r_aib_csr_ctrl_34(r_aib_csr_ctrl_34[7:0]),
				.r_aib_csr_ctrl_35(r_aib_csr_ctrl_35[7:0]),
				.r_aib_csr_ctrl_36(r_aib_csr_ctrl_36[7:0]),
				.r_aib_csr_ctrl_37(r_aib_csr_ctrl_37[7:0]),
				.r_aib_csr_ctrl_38(r_aib_csr_ctrl_38[7:0]),
				.r_aib_csr_ctrl_39(r_aib_csr_ctrl_39[7:0]),
				.r_aib_csr_ctrl_4(r_aib_csr_ctrl_4[7:0]),
				.r_aib_csr_ctrl_40(r_aib_csr_ctrl_40[7:0]),
				.r_aib_csr_ctrl_41(r_aib_csr_ctrl_41[7:0]),
				.r_aib_csr_ctrl_42(r_aib_csr_ctrl_42[7:0]),
				.r_aib_csr_ctrl_43(r_aib_csr_ctrl_43[7:0]),
				.r_aib_csr_ctrl_44(r_aib_csr_ctrl_44[7:0]),
				.r_aib_csr_ctrl_45(r_aib_csr_ctrl_45[7:0]),
				.r_aib_csr_ctrl_46(r_aib_csr_ctrl_46[7:0]),
				.r_aib_csr_ctrl_47(r_aib_csr_ctrl_47[7:0]),
				.r_aib_csr_ctrl_48(r_aib_csr_ctrl_48[7:0]),
				.r_aib_csr_ctrl_49(r_aib_csr_ctrl_49[7:0]),
				.r_aib_csr_ctrl_5(r_aib_csr_ctrl_5[7:0]),
				.r_aib_csr_ctrl_50(r_aib_csr_ctrl_50[7:0]),
				.r_aib_csr_ctrl_51(r_aib_csr_ctrl_51[7:0]),
				.r_aib_csr_ctrl_52(r_aib_csr_ctrl_52[7:0]),
				.r_aib_csr_ctrl_53(r_aib_csr_ctrl_53[7:0]),
				.r_aib_csr_ctrl_54(r_aib_csr_ctrl_54[7:0]),
				.r_aib_csr_ctrl_55(r_aib_csr_ctrl_55[7:0]),
				.r_aib_csr_ctrl_56(r_aib_csr_ctrl_56[7:0]),
				.r_aib_csr_ctrl_57(r_aib_csr_ctrl_57[7:0]),
				.r_aib_csr_ctrl_6(r_aib_csr_ctrl_6[7:0]),
				.r_aib_csr_ctrl_7(r_aib_csr_ctrl_7[7:0]),
				.r_aib_csr_ctrl_8(r_aib_csr_ctrl_8[7:0]),
				.r_aib_csr_ctrl_9(r_aib_csr_ctrl_9[7:0]),
				.r_aib_dprio_ctrl_0(r_aib_dprio_ctrl_0[7:0]),
				.r_aib_dprio_ctrl_1(r_aib_dprio_ctrl_1[7:0]),
				.r_aib_dprio_ctrl_2(r_aib_dprio_ctrl_2[7:0]),
				.r_aib_dprio_ctrl_3(r_aib_dprio_ctrl_3[7:0]),
				.r_aib_dprio_ctrl_4(r_aib_dprio_ctrl_4[7:0]),
                                .r_rx_pld_8g_eidleinfersel_polling_bypass   (r_rx_pld_8g_eidleinfersel_polling_bypass),
                                .r_rx_pld_pma_eye_monitor_polling_bypass   (r_rx_pld_pma_eye_monitor_polling_bypass),
                                .r_rx_pld_pma_pcie_switch_polling_bypass   (r_rx_pld_pma_pcie_switch_polling_bypass),
                                .r_rx_pld_pma_reser_out_polling_bypass   (r_rx_pld_pma_reser_out_polling_bypass),
				.r_rx_aib_clk1_sel(r_rx_aib_clk1_sel[1:0]),
				.r_rx_aib_clk2_sel(r_rx_aib_clk2_sel[1:0]),
                                .r_rx_hrdrst_rx_osc_clk_scg_en(r_rx_hrdrst_rx_osc_clk_scg_en),
                                .r_rx_free_run_div_clk(r_rx_free_run_div_clk),
                                .r_rx_hrdrst_rst_sm_dis(r_rx_hrdrst_rst_sm_dis),
                                .r_rx_hrdrst_dll_lock_bypass(r_rx_hrdrst_dll_lock_bypass),
                                .r_rx_hrdrst_align_bypass(r_rx_hrdrst_align_bypass),
                                .r_rx_hrdrst_user_ctl_en(r_rx_hrdrst_user_ctl_en),
//        			.r_rx_hrdrst_master_sel(r_rx_hrdrst_master_sel[1:0]),
//				.r_rx_hrdrst_dist_master_sel(r_rx_hrdrst_dist_master_sel),
				.r_tx_usertest_sel(r_tx_usertest_sel),
				.r_rx_usertest_sel(r_rx_usertest_sel),
				.r_rx_ds_last_chnl(r_rx_ds_last_chnl),
				.r_rx_us_last_chnl(r_rx_us_last_chnl),
				.r_rx_async_pld_10g_rx_crc32_err_rst_val(r_rx_async_pld_10g_rx_crc32_err_rst_val),
				.r_rx_async_pld_8g_signal_detect_out_rst_val(r_rx_async_pld_8g_signal_detect_out_rst_val),
				.r_rx_async_pld_ltr_rst_val(r_rx_async_pld_ltr_rst_val),
				.r_rx_async_pld_pma_ltd_b_rst_val(r_rx_async_pld_pma_ltd_b_rst_val),
				.r_rx_async_pld_rx_fifo_align_clr_rst_val(r_rx_async_pld_rx_fifo_align_clr_rst_val),
				.r_rx_async_prbs_flags_sr_enable(r_rx_async_prbs_flags_sr_enable),
				.r_rx_bonding_dft_in_en(r_rx_bonding_dft_in_en),
				.r_rx_bonding_dft_in_value(r_rx_bonding_dft_in_value),
				.r_rx_asn_en	(r_rx_asn_en),
				.r_rx_asn_bypass_pma_pcie_sw_done(r_rx_asn_bypass_pma_pcie_sw_done),
				.r_rx_asn_wait_for_fifo_flush_cnt(r_rx_asn_wait_for_fifo_flush_cnt[7:0]),
				.r_rx_asn_wait_for_dll_reset_cnt(r_rx_asn_wait_for_dll_reset_cnt[7:0]),
				.r_rx_asn_wait_for_pma_pcie_sw_done_cnt(r_rx_asn_wait_for_pma_pcie_sw_done_cnt[7:0]),
//				.r_rx_asn_master_sel(r_rx_asn_master_sel[1:0]),
//				.r_rx_asn_dist_master_sel(r_rx_asn_dist_master_sel),
				//.r_rx_asn_bonding_dft_in_en(r_rx_asn_bonding_dft_in_en),
				//.r_rx_asn_bonding_dft_in_value(r_rx_asn_bonding_dft_in_value),
				.r_rx_comp_cnt	(r_rx_comp_cnt[7:0]),
				.r_rx_compin_sel(r_rx_compin_sel[1:0]),
				//.r_rx_coreclkin_sel(r_rx_coreclkin_sel),
				.r_rx_double_read(r_rx_double_read),
				.r_rx_ds_bypass_pipeln(r_rx_ds_bypass_pipeln),
				.r_rx_ds_master	(r_rx_ds_master),
				.r_rx_fifo_empty(r_rx_fifo_empty[5:0]),
				.r_rx_fifo_full	(r_rx_fifo_full[5:0]),
				.r_rx_fifo_mode	(r_rx_fifo_mode[2:0]),
				.r_rx_fifo_pempty(r_rx_fifo_pempty[5:0]),
				.r_rx_fifo_pfull(r_rx_fifo_pfull[5:0]),
				.r_rx_fifo_rd_clk_scg_en(r_rx_fifo_rd_clk_scg_en),
				.r_rx_fifo_rd_clk_sel(r_rx_fifo_rd_clk_sel[1:0]),
				.r_rx_fifo_wr_clk_scg_en(r_rx_fifo_wr_clk_scg_en),
				.r_rx_fifo_wr_clk_sel(r_rx_fifo_wr_clk_sel),
				.r_rx_gb_dv_en	(r_rx_gb_dv_en),
				.r_rx_indv	(r_rx_indv),
				.r_rx_phcomp_rd_delay(r_rx_phcomp_rd_delay[2:0]),
				.r_rx_pld_clk1_sel(r_rx_pld_clk1_sel),
				.r_rx_pld_clk1_delay_en(r_rx_pld_clk1_delay_en),
				.r_rx_pld_clk1_delay_sel(r_rx_pld_clk1_delay_sel[3:0]),
				.r_rx_pld_clk1_inv_en(r_rx_pld_clk1_inv_en),
				//.r_rx_pld_clk2_sel(r_rx_pld_clk2_sel),
				.r_rx_pma_hclk_scg_en(r_rx_pma_hclk_scg_en),
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
				.r_rx_stop_write(r_rx_stop_write),
				.r_rx_truebac2bac(r_rx_truebac2bac),
				.r_rx_us_bypass_pipeln(r_rx_us_bypass_pipeln),
				.r_rx_us_master	(r_rx_us_master),
				.r_rx_wa_en	(r_rx_wa_en),
				.r_rx_write_ctrl	(r_rx_write_ctrl),
      				.r_rx_fifo_power_mode				 (r_rx_fifo_power_mode),
                                .r_rx_stretch_num_stages				 (r_rx_stretch_num_stages), 	
                                .r_rx_datapath_tb_sel 				 (r_rx_datapath_tb_sel), 
                                .r_rx_wr_adj_en 					 (r_rx_wr_adj_en), 
                                .r_rx_rd_adj_en					 (r_rx_rd_adj_en),				      
                                .r_rx_pipe_en					 (r_rx_pipe_en),
                                .r_rx_lpbk_en					 (r_rx_lpbk_en),
				.r_sr_hip_en	(r_sr_hip_en),
                                .r_sr_reserbits_in_en  (r_sr_reserbits_in_en),
                                .r_sr_reserbits_out_en (r_sr_reserbits_out_en),
                                .r_sr_testbus_sel     (r_sr_testbus_sel),
                                .r_sr_parity_en       (r_sr_parity_en),
				//.r_sr_hip_fsr_in_bit0_rst_val(r_sr_hip_fsr_in_bit0_rst_val),
				//.r_sr_hip_fsr_in_bit1_rst_val(r_sr_hip_fsr_in_bit1_rst_val),
				//.r_sr_hip_fsr_in_bit2_rst_val(r_sr_hip_fsr_in_bit2_rst_val),
				//.r_sr_hip_fsr_in_bit3_rst_val(r_sr_hip_fsr_in_bit3_rst_val),
				//.r_sr_hip_fsr_out_bit0_rst_val(r_sr_hip_fsr_out_bit0_rst_val),
				//.r_sr_hip_fsr_out_bit1_rst_val(r_sr_hip_fsr_out_bit1_rst_val),
				//.r_sr_hip_fsr_out_bit2_rst_val(r_sr_hip_fsr_out_bit2_rst_val),
				//.r_sr_hip_fsr_out_bit3_rst_val(r_sr_hip_fsr_out_bit3_rst_val),
				//.r_sr_pld_10g_rx_crc32_err_rst_val(r_sr_pld_10g_rx_crc32_err_rst_val),
				//.r_sr_pld_8g_signal_detect_out_rst_val(r_sr_pld_8g_signal_detect_out_rst_val),
				//.r_sr_pld_ltr_rst_val(r_sr_pld_ltr_rst_val),
				//.r_sr_pld_pma_ltd_b_rst_val(r_sr_pld_pma_ltd_b_rst_val),
				//.r_sr_pld_pmaif_mask_tx_pll_rst_val(r_sr_pld_pmaif_mask_tx_pll_rst_val),
				//.r_sr_pld_rx_fifo_align_clr_rst_val(r_sr_pld_rx_fifo_align_clr_rst_val),
				//.r_sr_pld_txelecidle_rst_val(r_sr_pld_txelecidle_rst_val),
				.r_sr_osc_clk_scg_en(r_sr_osc_clk_scg_en),
                                .r_tx_hip_aib_ssr_in_polling_bypass (r_tx_hip_aib_ssr_in_polling_bypass),
                                .r_tx_pld_8g_tx_boundary_sel_polling_bypass          (r_tx_pld_8g_tx_boundary_sel_polling_bypass),
                                .r_tx_pld_10g_tx_bitslip_polling_bypass              (r_tx_pld_10g_tx_bitslip_polling_bypass),
                                .r_tx_pld_pma_fpll_cnt_sel_polling_bypass            (r_tx_pld_pma_fpll_cnt_sel_polling_bypass),
                                .r_tx_pld_pma_fpll_num_phase_shifts_polling_bypass   (r_tx_pld_pma_fpll_num_phase_shifts_polling_bypass),
				.r_tx_aib_clk1_sel(r_tx_aib_clk1_sel[1:0]),
				.r_tx_aib_clk2_sel(r_tx_aib_clk2_sel[1:0]),
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
				.r_tx_bypass_frmgen(r_tx_bypass_frmgen),
				.r_tx_comp_cnt	(r_tx_comp_cnt[7:0]),
				.r_tx_compin_sel(r_tx_compin_sel[1:0]),
				.r_tx_double_write(r_tx_double_write),
				.r_tx_ds_bypass_pipeln(r_tx_ds_bypass_pipeln),
				.r_tx_ds_master	(r_tx_ds_master),
				.r_tx_dv_indv	(r_tx_dv_indv),
				.r_tx_fifo_empty(r_tx_fifo_empty[4:0]),
				.r_tx_fifo_full	(r_tx_fifo_full[4:0]),
				.r_tx_fifo_mode	(r_tx_fifo_mode[2:0]),
				.r_tx_fifo_pempty(r_tx_fifo_pempty[4:0]),
				.r_tx_fifo_pfull(r_tx_fifo_pfull[4:0]),
				.r_tx_fifo_rd_clk_frm_gen_scg_en(r_tx_fifo_rd_clk_frm_gen_scg_en),
				.r_tx_fifo_rd_clk_scg_en(r_tx_fifo_rd_clk_scg_en),
				.r_tx_fifo_rd_clk_sel(r_tx_fifo_rd_clk_sel[1:0]),
				.r_tx_fifo_wr_clk_scg_en(r_tx_fifo_wr_clk_scg_en),
				//.r_tx_fifo_wr_clk_sel(r_tx_fifo_wr_clk_sel),
				.r_tx_fpll_shared_direct_async_in_sel(r_tx_fpll_shared_direct_async_in_sel),
				.r_tx_gb_dv_en	(r_tx_gb_dv_en),
				.r_tx_gb_idwidth(r_tx_gb_idwidth[2:0]),
				.r_tx_gb_odwidth(r_tx_gb_odwidth[1:0]),
				.r_tx_indv	(r_tx_indv),
				.r_tx_mfrm_length(r_tx_mfrm_length[15:0]),
				.r_tx_phcomp_rd_delay(r_tx_phcomp_rd_delay[2:0]),
				.r_tx_pipeln_frmgen(r_tx_pipeln_frmgen),
				.r_tx_pld_clk1_sel(r_tx_pld_clk1_sel),
				.r_tx_pld_clk1_delay_en(r_tx_pld_clk1_delay_en),
				.r_tx_pld_clk1_delay_sel(r_tx_pld_clk1_delay_sel[3:0]),
				.r_tx_pld_clk1_inv_en(r_tx_pld_clk1_inv_en),
				.r_tx_pld_clk2_sel(r_tx_pld_clk2_sel),
				.r_tx_pyld_ins	(r_tx_pyld_ins),
				.r_tx_osc_clk_scg_en(r_tx_osc_clk_scg_en),
				.r_tx_sh_err	(r_tx_sh_err),
				.r_tx_stop_read	(r_tx_stop_read),
				.r_tx_stop_write(r_tx_stop_write),
				.r_tx_us_bypass_pipeln(r_tx_us_bypass_pipeln),
				.r_tx_us_master	(r_tx_us_master),
				.r_tx_wm_en	(r_tx_wm_en),
      				.r_tx_fifo_power_mode				 (r_tx_fifo_power_mode),
                                .r_tx_stretch_num_stages				 (r_tx_stretch_num_stages), 	
                                .r_tx_datapath_tb_sel 				 (r_tx_datapath_tb_sel), 
                                .r_tx_wr_adj_en 					 (r_tx_wr_adj_en), 
                                .r_tx_rd_adj_en					 (r_tx_rd_adj_en),
				
				.r_tx_wordslip	(r_tx_wordslip),
                                .r_tx_hrdrst_rst_sm_dis(r_tx_hrdrst_rst_sm_dis),
                                .r_tx_hrdrst_dcd_cal_done_bypass(r_tx_hrdrst_dcd_cal_done_bypass),
                                .r_tx_hrdrst_user_ctl_en(r_tx_hrdrst_user_ctl_en),
//        			.r_tx_hrdrst_master_sel(r_tx_hrdrst_master_sel[1:0]),
//				.r_tx_hrdrst_dist_master_sel(r_tx_hrdrst_dist_master_sel),
				.r_tx_ds_last_chnl(r_tx_ds_last_chnl),
				.r_tx_us_last_chnl(r_tx_us_last_chnl),
                                .r_tx_hrdrst_rx_osc_clk_scg_en(r_tx_hrdrst_rx_osc_clk_scg_en),
                                .r_tx_hip_osc_clk_scg_en(r_tx_hip_osc_clk_scg_en),
				.rx_chnl_dprio_status_write_en(rx_chnl_dprio_status_write_en),
				.adapter_config_scan_out (adapter_config_scan_out),
				.tx_chnl_dprio_status_write_en(tx_chnl_dprio_status_write_en),
				.usermode_out	(usermode_out),
                                .avmm_hrdrst_fabric_osc_transfer_en_ssr_data(avmm_hrdrst_fabric_osc_transfer_en_ssr_data),
				// Input
				.dft_adpt_aibiobsr_fastclkn(dft_adpt_aibiobsr_fastclkn),
				.adapter_scan_rst_n(adapter_scan_rst_n),
				.adapter_scan_mode_n	(adapter_scan_mode_n),
				.adapter_scan_shift_n (adapter_scan_shift_n),
				.adapter_scan_shift_clk(adapter_scan_shift_clk),
                                                .adapter_scan_user_clk0(adapter_scan_user_clk0),         // 125MHz
                                                .adapter_scan_user_clk3(adapter_scan_user_clk3),         // 1GHz
                                                .adapter_clk_sel_n(adapter_clk_sel_n),
                                                .adapter_occ_enable(adapter_occ_enable),
                                .avmm_fabric_hssi_ssr_load(avmm_fabric_hssi_ssr_load),
                                .avmm_hrdrst_hssi_osc_transfer_en_ssr_data(avmm_hrdrst_hssi_osc_transfer_en_ssr_data),
                                .avmm_hssi_fabric_ssr_load(avmm_hssi_fabric_ssr_load),
				.aib_fabric_avmm1_data_in(aib_fabric_avmm1_data_in),
				.aib_fabric_avmm2_data_in(aib_fabric_avmm2_data_in),
				//.aib_fabric_osc_dll_lock(aib_fabric_osc_dll_lock),
				//.aib_fabric_rx_dll_lock(aib_fabric_rx_dll_lock),
				.aib_fabric_rx_sr_clk_in(aib_fabric_rx_sr_clk_in),
				.aib_fabric_tx_sr_clk_in(aib_fabric_tx_sr_clk_in),
				.avmm1_hssi_fabric_ssr_data(avmm1_hssi_fabric_ssr_data),
				.avmm1_hssi_fabric_ssr_load(avmm1_hssi_fabric_ssr_load),
				.avmm2_hssi_fabric_ssr_data(avmm2_hssi_fabric_ssr_data),
				.avmm2_hssi_fabric_ssr_load(avmm2_hssi_fabric_ssr_load),
                                .csr_config     (csr_config),
				.csr_clk_in	(csr_clk_in),
				.csr_in		(csr_in),
				.csr_pipe_in	(csr_pipe_in),
				.csr_rdy_dly_in	(csr_rdy_dly_in),
				.csr_rdy_in	(csr_rdy_in),
				.hip_avmm_read	(hip_avmm_read),
				.hip_avmm_reg_addr(hip_avmm_reg_addr[20:0]),
				.hip_avmm_write	(hip_avmm_write),
				.hip_avmm_writedata(hip_avmm_writedata[7:0]),
				.nfrzdrv_in	(nfrzdrv_in),
				.pr_channel_freeze_n(pr_channel_freeze_n),
				.pld_avmm1_clk_rowclk(pld_avmm1_clk_rowclk),
				.pld_avmm1_read	(pld_avmm1_read),
				.pld_avmm1_reg_addr(pld_avmm1_reg_addr[9:0]),
				.pld_avmm1_request(pld_avmm1_request),
				.pld_avmm1_write(pld_avmm1_write),
				.pld_avmm1_writedata(pld_avmm1_writedata[7:0]),
				.pld_avmm1_reserved_in(pld_avmm1_reserved_in[8:0]),
				.pld_avmm2_clk_rowclk(pld_avmm2_clk_rowclk),
				.pld_avmm2_read	(pld_avmm2_read),
				.pld_avmm2_reg_addr(pld_avmm2_reg_addr[8:0]),
				.pld_avmm2_request(pld_avmm2_request),
				.pld_avmm2_write(pld_avmm2_write),
				.pld_avmm2_writedata(pld_avmm2_writedata[7:0]),
				.pld_avmm2_reserved_in(pld_avmm2_reserved_in[9:4]),
				.rx_chnl_dprio_status(rx_chnl_dprio_status[7:0]),
				.rx_chnl_dprio_status_write_en_ack(rx_chnl_dprio_status_write_en_ack),
				.adapter_config_scan_in (adapter_config_scan_in), // Templated
				.tx_chnl_dprio_status(tx_chnl_dprio_status[7:0]),
				.tx_chnl_dprio_status_write_en_ack(tx_chnl_dprio_status_write_en_ack),
				.usermode_in	(usermode_in));

hdpldadapt_tx_chnl hdpldadapt_tx_chnl(/*AUTOINST*/
				      // Outputs
                                      .pld_tx_ssr_reserved_out (pld_tx_ssr_reserved_out),
                                      .tx_async_fabric_hssi_ssr_reserved (tx_async_fabric_hssi_ssr_reserved),
				      .aib_fabric_adapter_tx_pld_rst_n(aib_fabric_adapter_tx_pld_rst_n),
				      .aib_fabric_fpll_shared_direct_async_out(aib_fabric_fpll_shared_direct_async_out[2:0]),
				      .aib_fabric_pcs_tx_pld_rst_n(aib_fabric_pcs_tx_pld_rst_n),
				      .aib_fabric_pld_pma_txdetectrx(aib_fabric_pld_pma_txdetectrx),
				      .aib_fabric_pld_pma_txpma_rstb(aib_fabric_pld_pma_txpma_rstb),
				      .aib_fabric_tx_data_out(aib_fabric_tx_data_out[39:0]),
				      .aib_fabric_tx_transfer_clk(aib_fabric_tx_transfer_clk),
                                      .aib_fabric_tx_dcd_cal_req(aib_fabric_tx_dcd_cal_req),                                      
                                      .tx_hrdrst_fabric_tx_transfer_en(tx_hrdrst_fabric_tx_transfer_en),
                                      .tx_clock_fifo_wr_clk(tx_clock_fifo_wr_clk),
                                      .tx_clock_fifo_rd_clk(tx_clock_fifo_rd_clk),
				      .bond_tx_fifo_ds_out_dv(bond_tx_fifo_ds_out_dv),
				      .bond_tx_fifo_ds_out_rden(bond_tx_fifo_ds_out_rden),
				      .bond_tx_fifo_ds_out_wren(bond_tx_fifo_ds_out_wren),
				      .bond_tx_fifo_us_out_dv(bond_tx_fifo_us_out_dv),
				      .bond_tx_fifo_us_out_rden(bond_tx_fifo_us_out_rden),
				      .bond_tx_fifo_us_out_wren(bond_tx_fifo_us_out_wren),
                                      .bond_tx_hrdrst_ds_out_fabric_tx_dcd_cal_done(bond_tx_hrdrst_ds_out_fabric_tx_dcd_cal_done),
                                      .bond_tx_hrdrst_us_out_fabric_tx_dcd_cal_done(bond_tx_hrdrst_us_out_fabric_tx_dcd_cal_done),
                                      .bond_tx_hrdrst_ds_out_fabric_tx_dcd_cal_req(bond_tx_hrdrst_ds_out_fabric_tx_dcd_cal_req),
                                      .bond_tx_hrdrst_us_out_fabric_tx_dcd_cal_req(bond_tx_hrdrst_us_out_fabric_tx_dcd_cal_req),
				      .hip_aib_async_fsr_in(hip_aib_async_fsr_in[3:0]),
				      .hip_aib_async_ssr_in(hip_aib_async_ssr_in[39:0]),
				      .hip_aib_fsr_out	(hip_aib_fsr_out[3:0]),
				      .hip_aib_ssr_out	(hip_aib_ssr_out[7:0]),
				      .pld_10g_krfec_tx_frame(pld_10g_krfec_tx_frame),
				      .pld_krfec_tx_alignment(pld_krfec_tx_alignment),
				      .pld_10g_tx_burst_en_exe(pld_10g_tx_burst_en_exe),
				      .pld_10g_tx_wordslip_exe(pld_10g_tx_wordslip_exe),
				      .pld_fpll_shared_direct_async_out(pld_fpll_shared_direct_async_out),
				      .pld_fpll_shared_direct_async_out_hioint(pld_fpll_shared_direct_async_out_hioint[3:0]),
				      .pld_fpll_shared_direct_async_out_dcm(pld_fpll_shared_direct_async_out_dcm[3:0]),
				      .pld_pcs_tx_clk_out1_dcm(pld_pcs_tx_clk_out1_dcm),
				      .pld_pcs_tx_clk_out1_hioint(pld_pcs_tx_clk_out1_hioint),
				      .pld_pcs_tx_clk_out2_dcm(pld_pcs_tx_clk_out2_dcm),
				      .pld_pcs_tx_clk_out2_hioint(pld_pcs_tx_clk_out2_hioint),
				      .pld_pma_fpll_clk0bad(pld_pma_fpll_clk0bad),
				      .pld_pma_fpll_clk1bad(pld_pma_fpll_clk1bad),
				      .pld_pma_fpll_clksel(pld_pma_fpll_clksel),
				      .pld_pma_fpll_phase_done(pld_pma_fpll_phase_done),
				      .pld_pmaif_mask_tx_pll(pld_pmaif_mask_tx_pll),
				      .pld_tx_fabric_fifo_empty(pld_tx_fabric_fifo_empty),
				      .pld_tx_fabric_fifo_full(pld_tx_fabric_fifo_full),
				      .pld_tx_fabric_fifo_latency_pulse(pld_tx_fabric_fifo_latency_pulse),
				      .pld_tx_fabric_fifo_pempty(pld_tx_fabric_fifo_pempty),
				      .pld_tx_fabric_fifo_pfull(pld_tx_fabric_fifo_pfull),
				      .pld_tx_hssi_align_done(pld_tx_hssi_align_done),
				      .pld_tx_hssi_fifo_empty(pld_tx_hssi_fifo_empty),
				      .pld_tx_hssi_fifo_full(pld_tx_hssi_fifo_full),
				      .rx_pld_rate	(rx_pld_rate),
				      .aib_fabric_tx_data_lpbk	(aib_fabric_tx_data_lpbk),
				      .hip_fsr_parity_checker_in (hip_fsr_parity_checker_in),
                                      .hip_ssr_parity_checker_in (hip_ssr_parity_checker_in),
                                      .tx_fsr_parity_checker_in  (tx_fsr_parity_checker_in),
                                      .tx_ssr_parity_checker_in  (tx_ssr_parity_checker_in),
                                      .pld_tx_fifo_ready (pld_avmm2_reserved_out[0]),
				      .pld_tx_hssi_fifo_latency_pulse (pld_tx_hssi_fifo_latency_pulse),
				      .pld_aib_hssi_tx_dcd_cal_done(pld_aib_hssi_tx_dcd_cal_done),
                                      .pld_aib_hssi_tx_dll_lock(pld_aib_hssi_tx_dll_lock),
                                      .pld_aib_fabric_tx_dcd_cal_done(pld_aib_fabric_tx_dcd_cal_done),
                                      .pld_fabric_tx_transfer_en(pld_fabric_tx_transfer_en),
				      .rx_fsr_mask_tx_pll(rx_fsr_mask_tx_pll),
				      .tx_async_fabric_hssi_fsr_data(tx_async_fabric_hssi_fsr_data),
				      .tx_async_fabric_hssi_ssr_data(tx_async_fabric_hssi_ssr_data[35:0]),
				      .tx_chnl_dprio_status(tx_chnl_dprio_status[7:0]),
				      .tx_chnl_dprio_status_write_en_ack(tx_chnl_dprio_status_write_en_ack),
				      .tx_chnl_testbus	(tx_chnl_testbus),
				      // Inputs
                                                // new inputs for ECO8
                                                .r_tx_wren_fastbond (r_tx_wren_fastbond),
                                                .r_tx_rden_fastbond (r_tx_rden_fastbond), 
                                      .r_tx_usertest_sel (r_tx_usertest_sel),
				      .dft_adpt_aibiobsr_fastclkn(dft_adpt_aibiobsr_fastclkn),
                                      .adapter_scan_rst_n(adapter_scan_rst_n),
                                      .adapter_scan_mode_n(adapter_scan_mode_n),
                                      .adapter_scan_shift_n(adapter_scan_shift_n),
                                      .adapter_scan_shift_clk(adapter_scan_shift_clk),
                                      .adapter_scan_user_clk0(adapter_scan_user_clk0),         // 125MHz
                                      .adapter_scan_user_clk1(adapter_scan_user_clk1),         // 250MHz
                                      .adapter_scan_user_clk2(adapter_scan_user_clk2),         // 500MHz
                                      .adapter_scan_user_clk3(adapter_scan_user_clk3),         // 1GHz
                                      .adapter_clk_sel_n(adapter_clk_sel_n),
                                      .adapter_occ_enable(adapter_occ_enable),
                                      .pld_clk_dft_sel(pld_avmm2_reserved_in[3]),
                                      .r_tx_hip_aib_ssr_in_polling_bypass (r_tx_hip_aib_ssr_in_polling_bypass),
                                      .r_tx_pld_8g_tx_boundary_sel_polling_bypass          (r_tx_pld_8g_tx_boundary_sel_polling_bypass),
                                      .r_tx_pld_10g_tx_bitslip_polling_bypass              (r_tx_pld_10g_tx_bitslip_polling_bypass),
                                      .r_tx_pld_pma_fpll_cnt_sel_polling_bypass            (r_tx_pld_pma_fpll_cnt_sel_polling_bypass),
                                      .r_tx_pld_pma_fpll_num_phase_shifts_polling_bypass   (r_tx_pld_pma_fpll_num_phase_shifts_polling_bypass),
                                      .r_tx_hrdrst_rst_sm_dis(r_tx_hrdrst_rst_sm_dis),
                                      .r_tx_hrdrst_dcd_cal_done_bypass(r_tx_hrdrst_dcd_cal_done_bypass),
                                      .r_tx_hrdrst_user_ctl_en(r_tx_hrdrst_user_ctl_en),
//        			      .r_tx_hrdrst_master_sel(r_tx_hrdrst_master_sel[1:0]),
//				      .r_tx_hrdrst_dist_master_sel(r_tx_hrdrst_dist_master_sel),
				      .r_tx_ds_last_chnl(r_tx_ds_last_chnl),
				      .r_tx_us_last_chnl(r_tx_us_last_chnl),
                                      .r_tx_hrdrst_rx_osc_clk_scg_en(r_tx_hrdrst_rx_osc_clk_scg_en),
                                      .r_tx_hip_osc_clk_scg_en(r_tx_hip_osc_clk_scg_en),
                                      .pld_tx_ssr_reserved_in (pld_tx_ssr_reserved_in),
                                      .tx_async_hssi_fabric_ssr_reserved (tx_async_hssi_fabric_ssr_reserved),
                                      .pld_aib_fabric_tx_dcd_cal_req(pld_aib_fabric_tx_dcd_cal_req),
                                      .pld_tx_dll_lock_req(pld_tx_dll_lock_req),
				      .aib_fabric_fpll_shared_direct_async_in(aib_fabric_fpll_shared_direct_async_in[4:0]),
				      .aib_fabric_pld_pcs_tx_clk_out(aib_fabric_pld_pcs_tx_clk_out),
				      .aib_fabric_pld_pma_clkdiv_tx_user(aib_fabric_pld_pma_clkdiv_tx_user),
				      .aib_fabric_pma_aib_tx_clk(aib_fabric_pma_aib_tx_clk),
				      .aib_fabric_rx_sr_clk_in(aib_fabric_rx_sr_clk_in),
				      .aib_fabric_tx_sr_clk_in(aib_fabric_tx_sr_clk_in),
                                      .aib_fabric_tx_dcd_cal_done(aib_fabric_tx_dcd_cal_done),
                                      .aib_fabric_pld_tx_hssi_fifo_latency_pulse (aib_fabric_pld_tx_hssi_fifo_latency_pulse),
                                      .avmm_hrdrst_fabric_osc_transfer_en(avmm_hrdrst_fabric_osc_transfer_en),  // temp
				      .bond_tx_fifo_ds_in_dv(bond_tx_fifo_ds_in_dv),
				      .bond_tx_fifo_ds_in_rden(bond_tx_fifo_ds_in_rden),
				      .bond_tx_fifo_ds_in_wren(bond_tx_fifo_ds_in_wren),
				      .bond_tx_fifo_us_in_dv(bond_tx_fifo_us_in_dv),
				      .bond_tx_fifo_us_in_rden(bond_tx_fifo_us_in_rden),
				      .bond_tx_fifo_us_in_wren(bond_tx_fifo_us_in_wren),
                                      .bond_tx_hrdrst_ds_in_fabric_tx_dcd_cal_done(bond_tx_hrdrst_ds_in_fabric_tx_dcd_cal_done),
                                      .bond_tx_hrdrst_us_in_fabric_tx_dcd_cal_done(bond_tx_hrdrst_us_in_fabric_tx_dcd_cal_done),
                                      .bond_tx_hrdrst_ds_in_fabric_tx_dcd_cal_req(bond_tx_hrdrst_ds_in_fabric_tx_dcd_cal_req),
                                      .bond_tx_hrdrst_us_in_fabric_tx_dcd_cal_req(bond_tx_hrdrst_us_in_fabric_tx_dcd_cal_req),
				      .csr_rdy_dly_in	(csr_rdy_dly_in),
				      .usermode_in	(usermode_in),
				      .hip_aib_async_fsr_out(hip_aib_async_fsr_out[3:0]),
				      .hip_aib_async_ssr_out(hip_aib_async_ssr_out[7:0]),
				      .hip_aib_fsr_in	(hip_aib_fsr_in[3:0]),
				      .hip_aib_ssr_in	(hip_aib_ssr_in[39:0]),
				      .nfrzdrv_in	(nfrzdrv_in),
				      .pr_channel_freeze_n(pr_channel_freeze_n),
				      .pld_10g_tx_bitslip(pld_10g_tx_bitslip[6:0]),
				      .pld_10g_tx_burst_en(pld_10g_tx_burst_en),
				      .pld_10g_tx_diag_status(pld_10g_tx_diag_status[1:0]),
				      .pld_10g_tx_wordslip(pld_10g_tx_wordslip),
				      .pld_8g_tx_boundary_sel(pld_8g_tx_boundary_sel[4:0]),
				      .pld_adapter_tx_pld_rst_n(pld_adapter_tx_pld_rst_n),
				      .pld_fpll_shared_direct_async_in(pld_fpll_shared_direct_async_in[1:0]),
				      .pld_fpll_shared_direct_async_in_rowclk(pld_fpll_shared_direct_async_in_rowclk),
				      .pld_fpll_shared_direct_async_in_dcm(pld_fpll_shared_direct_async_in_dcm),
				      .pld_pcs_tx_pld_rst_n(pld_pcs_tx_pld_rst_n),
				      .pld_pma_csr_test_dis(pld_pma_csr_test_dis),
				      .pld_pma_fpll_cnt_sel(pld_pma_fpll_cnt_sel[3:0]),
				      .pld_pma_fpll_extswitch(pld_pma_fpll_extswitch),
				      .pld_pma_fpll_lc_csr_test_dis(pld_pma_fpll_lc_csr_test_dis),
				      .pld_pma_fpll_num_phase_shifts(pld_pma_fpll_num_phase_shifts[2:0]),
				      .pld_pma_fpll_pfden(pld_pma_fpll_pfden),
				      .pld_pma_fpll_up_dn_lc_lf_rstn(pld_pma_fpll_up_dn_lc_lf_rstn),
				      .pld_pma_nrpi_freeze(pld_pma_nrpi_freeze),
				      .pld_pma_tx_bitslip(pld_pma_tx_bitslip),
				      .pld_pma_txdetectrx(pld_pma_txdetectrx),
				      .pld_pma_txpma_rstb(pld_pma_txpma_rstb),
				      .pld_polinv_tx	(pld_polinv_tx),
				      .pld_tx_clk1_dcm	(pld_tx_clk1_dcm),
				      .pld_tx_clk1_rowclk(pld_tx_clk1_rowclk),
				      .pld_tx_clk2_dcm	(pld_tx_clk2_dcm),
				      .pld_tx_clk2_rowclk(pld_tx_clk2_rowclk),
				      .pld_tx_fabric_data_in(pld_tx_fabric_data_in[79:0]),
				      .pld_txelecidle	(pld_txelecidle),
				      .pld_tx_fifo_latency_adj_en (pld_tx_fifo_latency_adj_en),
                                      .pld_aib_hssi_tx_dcd_cal_req  (pld_aib_hssi_tx_dcd_cal_req),
                                      .pld_aib_hssi_tx_dll_lock_req (pld_aib_hssi_tx_dll_lock_req),
                                      .pld_fabric_tx_fifo_srst (pld_avmm2_reserved_in[0]),
                                      .pld_pma_tx_qpi_pulldn (pld_pma_tx_qpi_pulldn),
                                      .pld_pma_tx_qpi_pullup (pld_pma_tx_qpi_pullup),
                                      .pld_pma_rx_qpi_pullup (pld_pma_rx_qpi_pullup),
				      .r_tx_aib_clk1_sel(r_tx_aib_clk1_sel[1:0]),
				      .r_tx_aib_clk2_sel(r_tx_aib_clk2_sel[1:0]),
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
				      .r_tx_bypass_frmgen(r_tx_bypass_frmgen),
				      .r_tx_comp_cnt	(r_tx_comp_cnt[7:0]),
				      .r_tx_compin_sel	(r_tx_compin_sel[1:0]),
				      .r_tx_double_write(r_tx_double_write),
				      .r_tx_ds_bypass_pipeln(r_tx_ds_bypass_pipeln),
				      .r_tx_ds_master	(r_tx_ds_master),
				      .r_tx_dv_indv	(r_tx_dv_indv),
				      .r_tx_fifo_empty	(r_tx_fifo_empty[4:0]),
				      .r_tx_fifo_full	(r_tx_fifo_full[4:0]),
				      .r_tx_fifo_mode	(r_tx_fifo_mode[2:0]),
				      .r_tx_fifo_pempty	(r_tx_fifo_pempty[4:0]),
				      .r_tx_fifo_pfull	(r_tx_fifo_pfull[4:0]),
				      .r_tx_fifo_rd_clk_frm_gen_scg_en(r_tx_fifo_rd_clk_frm_gen_scg_en),
				      .r_tx_fifo_rd_clk_scg_en(r_tx_fifo_rd_clk_scg_en),
				      .r_tx_fifo_rd_clk_sel(r_tx_fifo_rd_clk_sel[1:0]),
				      .r_tx_fifo_wr_clk_scg_en(r_tx_fifo_wr_clk_scg_en),
				      //.r_tx_fifo_wr_clk_sel(r_tx_fifo_wr_clk_sel),
				      .r_tx_fpll_shared_direct_async_in_sel(r_tx_fpll_shared_direct_async_in_sel),
				      .r_tx_gb_dv_en	(r_tx_gb_dv_en),
				      .r_tx_gb_idwidth	(r_tx_gb_idwidth[2:0]),
				      .r_tx_gb_odwidth	(r_tx_gb_odwidth[1:0]),
				      .r_tx_indv	(r_tx_indv),
				      .r_tx_mfrm_length	(r_tx_mfrm_length[15:0]),
				      .r_tx_phcomp_rd_delay(r_tx_phcomp_rd_delay[2:0]),
				      .r_tx_pipeln_frmgen(r_tx_pipeln_frmgen),
				      .r_tx_pld_clk1_sel(r_tx_pld_clk1_sel),
				      .r_tx_pld_clk1_delay_en(r_tx_pld_clk1_delay_en),
				      .r_tx_pld_clk1_delay_sel(r_tx_pld_clk1_delay_sel[3:0]),
				      .r_tx_pld_clk1_inv_en(r_tx_pld_clk1_inv_en),
				      .r_tx_pld_clk2_sel(r_tx_pld_clk2_sel),
				      .r_tx_pyld_ins	(r_tx_pyld_ins),
				      .r_tx_osc_clk_scg_en(r_tx_osc_clk_scg_en),
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

				      .r_tx_wordslip	(r_tx_wordslip),
				      .rx_clock_pld_sclk(rx_clock_pld_sclk),
				      .rx_asn_rate_change_in_progress(rx_asn_rate_change_in_progress),
				      .rx_asn_fifo_hold	(rx_asn_fifo_hold),
				      .rx_asn_dll_lock_en(rx_asn_dll_lock_en),
				      //.rx_asn_fifo_srst	(rx_asn_fifo_srst),
				      //.rx_asn_gen3_sel	(rx_asn_gen3_sel),
				      .tx_async_fabric_hssi_fsr_load(tx_async_fabric_hssi_fsr_load),
				      .tx_async_fabric_hssi_ssr_load(tx_async_fabric_hssi_ssr_load),
				      .tx_async_hssi_fabric_fsr_data(tx_async_hssi_fabric_fsr_data),
				      .tx_async_hssi_fabric_fsr_load(tx_async_hssi_fabric_fsr_load),
				      .tx_async_hssi_fabric_ssr_data(tx_async_hssi_fabric_ssr_data[12:0]),
				      .tx_async_hssi_fabric_ssr_load(tx_async_hssi_fabric_ssr_load),
				      .tx_chnl_dprio_status_write_en(tx_chnl_dprio_status_write_en));

hdpldadapt_rx_chnl hdpldadapt_rx_chnl(/*AUTOINST*/
				      // Outputs
				      .pld_pma_pfdmode_lock(pld_pma_pfdmode_lock),
                                      .dft_fabric_oaibdftdll2core(dft_fabric_oaibdftdll2core),
                                      .pld_rx_ssr_reserved_out(pld_rx_ssr_reserved_out),
                                      .rx_async_fabric_hssi_ssr_reserved(rx_async_fabric_hssi_ssr_reserved),
				      .pld_hssi_asn_dll_lock_en(pld_hssi_asn_dll_lock_en),
				      .pld_fabric_asn_dll_lock_en(pld_fabric_asn_dll_lock_en),
                                      .pld_hssi_rx_transfer_en(pld_hssi_rx_transfer_en),
                                      .pld_aib_fabric_rx_dll_lock(pld_aib_fabric_rx_dll_lock),
				      .aib_fabric_adapter_rx_pld_rst_n(aib_fabric_adapter_rx_pld_rst_n),
				      .aib_fabric_pcs_rx_pld_rst_n(aib_fabric_pcs_rx_pld_rst_n),
				      .aib_fabric_pld_pma_coreclkin(aib_fabric_pld_pma_coreclkin),
				      .aib_fabric_pld_pma_rxpma_rstb(aib_fabric_pld_pma_rxpma_rstb),
				      .aib_fabric_pld_sclk(aib_fabric_pld_sclk),
                                      .aib_fabric_pld_rx_hssi_fifo_latency_pulse (aib_fabric_pld_rx_hssi_fifo_latency_pulse),
				      .bond_rx_asn_ds_out_fifo_hold(bond_rx_asn_ds_out_fifo_hold),
				      //.bond_rx_asn_ds_out_dll_lock_en(bond_rx_asn_ds_out_dll_lock_en),
				      .bond_rx_asn_us_out_fifo_hold(bond_rx_asn_us_out_fifo_hold),
				      //.bond_rx_asn_us_out_dll_lock_en(bond_rx_asn_us_out_dll_lock_en),
				      .bond_rx_fifo_ds_out_rden(bond_rx_fifo_ds_out_rden),
				      .bond_rx_fifo_ds_out_wren(bond_rx_fifo_ds_out_wren),
				      .bond_rx_fifo_us_out_rden(bond_rx_fifo_us_out_rden),
				      .bond_rx_fifo_us_out_wren(bond_rx_fifo_us_out_wren),
                                      .bond_rx_hrdrst_ds_out_fabric_rx_dll_lock(bond_rx_hrdrst_ds_out_fabric_rx_dll_lock),
                                      .bond_rx_hrdrst_us_out_fabric_rx_dll_lock(bond_rx_hrdrst_us_out_fabric_rx_dll_lock),
                                      .bond_rx_hrdrst_ds_out_fabric_rx_dll_lock_req(bond_rx_hrdrst_ds_out_fabric_rx_dll_lock_req),
                                      .bond_rx_hrdrst_us_out_fabric_rx_dll_lock_req(bond_rx_hrdrst_us_out_fabric_rx_dll_lock_req),
				      .pld_10g_krfec_rx_blk_lock(pld_10g_krfec_rx_blk_lock),
				      .pld_10g_krfec_rx_diag_data_status(pld_10g_krfec_rx_diag_data_status[1:0]),
				      .pld_10g_krfec_rx_frame(pld_10g_krfec_rx_frame),
				      .pld_10g_rx_crc32_err(pld_10g_rx_crc32_err),
				      .pld_10g_rx_frame_lock(pld_10g_rx_frame_lock),
				      .pld_10g_rx_hi_ber(pld_10g_rx_hi_ber),
				      .pld_8g_a1a2_k1k2_flag(pld_8g_a1a2_k1k2_flag[3:0]),
				      .pld_8g_empty_rmf	(pld_8g_empty_rmf),
				      .pld_8g_full_rmf	(pld_8g_full_rmf),
				      .pld_8g_rxelecidle(pld_8g_rxelecidle),
				      .pld_8g_signal_detect_out(pld_8g_signal_detect_out),
				      .pld_8g_wa_boundary(pld_8g_wa_boundary[4:0]),
				      .pld_pcs_rx_clk_out1_dcm(pld_pcs_rx_clk_out1_dcm),
				      .pld_pcs_rx_clk_out1_hioint(pld_pcs_rx_clk_out1_hioint),
				      .pld_pcs_rx_clk_out2_dcm(pld_pcs_rx_clk_out2_dcm),
				      .pld_pcs_rx_clk_out2_hioint(pld_pcs_rx_clk_out2_hioint),
				      .pld_pma_adapt_done(pld_pma_adapt_done),
				      //.pld_pma_hclk_dcm	(pld_pma_hclk_dcm),
				      .pld_pma_hclk_hioint(pld_pma_hclk_hioint),
				      //.pld_pma_internal_clk1_dcm(pld_pma_internal_clk1_dcm),
				      .pld_pma_internal_clk1_hioint(pld_pma_internal_clk1_hioint),
				      //.pld_pma_internal_clk2_dcm(pld_pma_internal_clk2_dcm),
				      .pld_pma_internal_clk2_hioint(pld_pma_internal_clk2_hioint),
				      .pld_pma_pcie_sw_done(pld_pma_pcie_sw_done[1:0]),
				      .pld_pma_reserved_in(pld_pma_reserved_in[4:0]),
				      .pld_pma_rx_detect_valid(pld_pma_rx_detect_valid),
				      .pld_pma_rxpll_lock(pld_pma_rxpll_lock),
				      .pld_pma_signal_ok(pld_pma_signal_ok),
				      .pld_pma_testbus	(pld_pma_testbus[7:0]),
				      .pld_rx_fabric_align_done(pld_rx_fabric_align_done),
				      .pld_rx_fabric_data_out(pld_rx_fabric_data_out[79:0]),
				      .pld_rx_fabric_fifo_empty(pld_rx_fabric_fifo_empty),
				      .pld_rx_fabric_fifo_full(pld_rx_fabric_fifo_full),
				      .pld_rx_fabric_fifo_insert(pld_rx_fabric_fifo_insert),
				      .pld_rx_fabric_fifo_del(pld_rx_fabric_fifo_del),
				      .pld_rx_fabric_fifo_latency_pulse(pld_rx_fabric_fifo_latency_pulse),
				      .pld_rx_fabric_fifo_pempty(pld_rx_fabric_fifo_pempty),
				      .pld_rx_fabric_fifo_pfull(pld_rx_fabric_fifo_pfull),
				      .pld_rx_hssi_fifo_empty(pld_rx_hssi_fifo_empty),
				      .pld_rx_hssi_fifo_full(pld_rx_hssi_fifo_full),
				      .pld_rx_prbs_done	(pld_rx_prbs_done),
				      .pld_rx_prbs_err	(pld_rx_prbs_err),
				      .pld_pma_rx_found (pld_pma_rx_found),
				      .pld_test_data	(pld_test_data[19:0]),
				      .pld_rx_hssi_fifo_latency_pulse (pld_rx_hssi_fifo_latency_pulse),
				      .rx_clock_pld_sclk(rx_clock_pld_sclk),
				      .rx_asn_fifo_hold	(rx_asn_fifo_hold),
				      //.rx_asn_fifo_srst	(rx_asn_fifo_srst),
				      //.rx_asn_gen3_sel	(rx_asn_gen3_sel),
				      .rx_asn_rate_change_in_progress(rx_asn_rate_change_in_progress),
				      .rx_asn_dll_lock_en(rx_asn_dll_lock_en),
				      .rx_async_fabric_hssi_fsr_data(rx_async_fabric_hssi_fsr_data[2:0]),
				      .rx_async_fabric_hssi_ssr_data(rx_async_fabric_hssi_ssr_data[35:0]),
				      .pld_fsr_load	(pld_fsr_load),
				      .pld_ssr_load	(pld_ssr_load),
				      .pld_aib_hssi_rx_dcd_cal_done (pld_aib_hssi_rx_dcd_cal_done),
				      .rx_chnl_dprio_status(rx_chnl_dprio_status[7:0]),
				      .rx_chnl_dprio_status_write_en_ack(rx_chnl_dprio_status_write_en_ack),
                                        .adapter_scan_out_occ1(adapter_scan_out_occ1),
                                        .adapter_scan_out_occ2(adapter_scan_out_occ2),
                                        .adapter_scan_out_occ3(adapter_scan_out_occ3),
                                        .adapter_scan_out_occ4(adapter_scan_out_occ4),
                                        .adapter_scan_out_occ5(adapter_scan_out_occ5),
                                        .adapter_scan_out_occ6(adapter_scan_out_occ6),
                                        .adapter_scan_out_occ7(adapter_scan_out_occ7),
                                        .adapter_scan_out_occ8(adapter_scan_out_occ8),
                                        .adapter_scan_out_occ9(adapter_scan_out_occ9),
                                        .adapter_scan_out_occ10(adapter_scan_out_occ10),
                                        .adapter_scan_out_occ11(adapter_scan_out_occ11),
                                        .adapter_scan_out_occ12(adapter_scan_out_occ12),
                                        .adapter_scan_out_occ13(adapter_scan_out_occ13),
                                        .adapter_scan_out_occ14(adapter_scan_out_occ14),
                                        .adapter_scan_out_occ15(adapter_scan_out_occ15),
                                        .adapter_scan_out_occ16(adapter_scan_out_occ16),
                                        .adapter_scan_out_occ17(adapter_scan_out_occ17),
                                        .adapter_scan_out_occ18(adapter_scan_out_occ18),
                                        .adapter_scan_out_occ19(adapter_scan_out_occ19),
                                        .adapter_scan_out_occ20(adapter_scan_out_occ20),
                                        .adapter_scan_out_occ21(adapter_scan_out_occ21),
                                        .adapter_non_occ_scan_out(adapter_non_occ_scan_out),
                                        .adapter_occ_scan_out(adapter_occ_scan_out),
                                        .rx_fsr_parity_checker_in (rx_fsr_parity_checker_in),
                                        .rx_ssr_parity_checker_in (rx_ssr_parity_checker_in),
                                        .pld_rx_fifo_ready (pld_avmm2_reserved_out[1]),
				      // Inputs
                                                // new inputs for ECO8
                                                .r_rx_wren_fastbond (r_rx_wren_fastbond),
                                                .r_rx_rden_fastbond (r_rx_rden_fastbond),                                      
                                        .r_rx_usertest_sel (r_rx_usertest_sel),
				        .sr_parity_error_flag(sr_parity_error_flag),
				        .aib_fabric_pld_pma_pfdmode_lock(aib_fabric_pld_pma_pfdmode_lock),
				        .dft_adpt_aibiobsr_fastclkn(dft_adpt_aibiobsr_fastclkn),
                                        .adapter_scan_rst_n(adapter_scan_rst_n),
                                        .adapter_scan_mode_n(adapter_scan_mode_n),
                                        .adapter_scan_shift_n(adapter_scan_shift_n),
                                        .adapter_scan_shift_clk(adapter_scan_shift_clk),
                                        .adapter_scan_user_clk0(adapter_scan_user_clk0),         // 125MHz
                                        .adapter_scan_user_clk1(adapter_scan_user_clk1),         // 250MHz
                                        .adapter_scan_user_clk2(adapter_scan_user_clk2),         // 500MHz
                                        .adapter_scan_user_clk3(adapter_scan_user_clk3),         // 1GHz
                                        .adapter_clk_sel_n(adapter_clk_sel_n),
                                        .adapter_occ_enable(adapter_occ_enable),
                                        .pld_clk_dft_sel(pld_avmm2_reserved_in[3]),
                                      .r_rx_pld_8g_eidleinfersel_polling_bypass   (r_rx_pld_8g_eidleinfersel_polling_bypass),
                                      .r_rx_pld_pma_eye_monitor_polling_bypass   (r_rx_pld_pma_eye_monitor_polling_bypass),
                                      .r_rx_pld_pma_pcie_switch_polling_bypass   (r_rx_pld_pma_pcie_switch_polling_bypass),
                                      .r_rx_pld_pma_reser_out_polling_bypass   (r_rx_pld_pma_reser_out_polling_bypass),
                                      .pld_rx_ssr_reserved_in (pld_rx_ssr_reserved_in),
                                      .rx_async_hssi_fabric_ssr_reserved (rx_async_hssi_fabric_ssr_reserved),
                                      .pld_aib_fabric_rx_dll_lock_req(pld_aib_fabric_rx_dll_lock_req),
                                      .pld_fabric_rx_fifo_srst (pld_avmm2_reserved_in[1]),
                                      .pld_fabric_rx_asn_data_transfer_en(pld_avmm2_reserved_in[2]),
                                      .pld_rx_dll_lock_req (pld_rx_dll_lock_req),
                                      .pld_aib_hssi_rx_dcd_cal_req (pld_aib_hssi_rx_dcd_cal_req),
                                      .r_rx_hrdrst_rx_osc_clk_scg_en(r_rx_hrdrst_rx_osc_clk_scg_en),
                                      .r_rx_free_run_div_clk(r_rx_free_run_div_clk),
                                      .r_rx_hrdrst_rst_sm_dis(r_rx_hrdrst_rst_sm_dis),
                                      .r_rx_hrdrst_dll_lock_bypass(r_rx_hrdrst_dll_lock_bypass),
                                      .r_rx_hrdrst_align_bypass(r_rx_hrdrst_align_bypass),
                                      .r_rx_hrdrst_user_ctl_en(r_rx_hrdrst_user_ctl_en),
//        			      .r_rx_hrdrst_master_sel(r_rx_hrdrst_master_sel[1:0]),
//				      .r_rx_hrdrst_dist_master_sel(r_rx_hrdrst_dist_master_sel),
				      .r_rx_ds_last_chnl(r_rx_ds_last_chnl),
				      .r_rx_us_last_chnl(r_rx_us_last_chnl),
				      .r_rx_hip_en	(r_sr_hip_en),
				      .oaibdftdll2core  (oaibdftdll2core), 
				      .aib_fabric_pld_8g_rxelecidle(aib_fabric_pld_8g_rxelecidle),
				      .aib_fabric_pld_pcs_rx_clk_out(aib_fabric_pld_pcs_rx_clk_out),
				      .aib_fabric_pld_pma_clkdiv_rx_user(aib_fabric_pld_pma_clkdiv_rx_user),
				      .aib_fabric_pld_pma_hclk(aib_fabric_pld_pma_hclk),
				      .aib_fabric_pld_pma_internal_clk1(aib_fabric_pld_pma_internal_clk1),
				      .aib_fabric_pld_pma_internal_clk2(aib_fabric_pld_pma_internal_clk2),
				      .aib_fabric_pld_pma_rxpll_lock(aib_fabric_pld_pma_rxpll_lock),
				      .aib_fabric_rx_data_in(aib_fabric_rx_data_in[39:0]),
				      .aib_fabric_rx_dll_lock(aib_fabric_rx_dll_lock),
				      .aib_fabric_rx_dll_lock_req(aib_fabric_rx_dll_lock_req),
				      .aib_fabric_rx_sr_clk_in(aib_fabric_rx_sr_clk_in),
				      .aib_fabric_rx_transfer_clk(aib_fabric_rx_transfer_clk),
				      .aib_fabric_tx_sr_clk_in(aib_fabric_tx_sr_clk_in),
				      .aib_fabric_tx_transfer_clk(aib_fabric_tx_transfer_clk),
				      //.avmm_hrdrst_data_transfer_en(avmm_hrdrst_data_transfer_en),
                                      .avmm_hrdrst_fabric_osc_transfer_en(avmm_hrdrst_fabric_osc_transfer_en),  // temp
                                      .tx_clock_fifo_wr_clk(tx_clock_fifo_wr_clk),
                                      .tx_clock_fifo_rd_clk(tx_clock_fifo_rd_clk),
                                      .tx_hrdrst_fabric_tx_transfer_en(tx_hrdrst_fabric_tx_transfer_en),
				      .bond_rx_fifo_ds_in_rden(bond_rx_fifo_ds_in_rden),
				      .bond_rx_fifo_ds_in_wren(bond_rx_fifo_ds_in_wren),
				      .bond_rx_fifo_us_in_rden(bond_rx_fifo_us_in_rden),
				      .bond_rx_fifo_us_in_wren(bond_rx_fifo_us_in_wren),
                                      .bond_rx_hrdrst_ds_in_fabric_rx_dll_lock(bond_rx_hrdrst_ds_in_fabric_rx_dll_lock),
                                      .bond_rx_hrdrst_us_in_fabric_rx_dll_lock(bond_rx_hrdrst_us_in_fabric_rx_dll_lock),
                                      .bond_rx_hrdrst_ds_in_fabric_rx_dll_lock_req(bond_rx_hrdrst_ds_in_fabric_rx_dll_lock_req),
                                      .bond_rx_hrdrst_us_in_fabric_rx_dll_lock_req(bond_rx_hrdrst_us_in_fabric_rx_dll_lock_req),
				      .csr_rdy_dly_in	(csr_rdy_dly_in),
				      .usermode_in	(usermode_in),
				      .nfrzdrv_in	(nfrzdrv_in),
				      .pr_channel_freeze_n(pr_channel_freeze_n),
				      .tx_chnl_testbus	(tx_chnl_testbus),
				      .avmm_testbus	(avmm_testbus),
				      .pld_10g_krfec_rx_clr_errblk_cnt(pld_10g_krfec_rx_clr_errblk_cnt),
				      .pld_10g_rx_clr_ber_count(pld_10g_rx_clr_ber_count),
				      .pld_8g_a1a2_size	(pld_8g_a1a2_size),
				      .pld_8g_bitloc_rev_en(pld_8g_bitloc_rev_en),
				      .pld_8g_byte_rev_en(pld_8g_byte_rev_en),
				      .pld_8g_eidleinfersel(pld_8g_eidleinfersel[2:0]),
				      .pld_8g_encdt	(pld_8g_encdt),
				      .pld_adapter_rx_pld_rst_n(pld_adapter_rx_pld_rst_n),
				      .pld_bitslip	(pld_bitslip),
				      .pld_ltr		(pld_ltr),
				      .pld_pcs_rx_pld_rst_n(pld_pcs_rx_pld_rst_n),
				      .pld_pma_adapt_start(pld_pma_adapt_start),
				      //.pld_pma_coreclkin_dcm(pld_pma_coreclkin_dcm),
				      .pld_pma_coreclkin_rowclk(pld_pma_coreclkin_rowclk),
				      .pld_pma_early_eios(pld_pma_early_eios),
				      .pld_pma_eye_monitor(pld_pma_eye_monitor[5:0]),
				      .pld_pma_ltd_b	(pld_pma_ltd_b),
				      .pld_pma_pcie_switch(pld_pma_pcie_switch[1:0]),
				      .pld_pma_ppm_lock	(pld_pma_ppm_lock),
				      .pld_pma_reserved_out(pld_pma_reserved_out[4:0]),
				      .pld_pma_rs_lpbk_b(pld_pma_rs_lpbk_b),
				      .pld_pma_rxpma_rstb(pld_pma_rxpma_rstb),
				      .pld_pmaif_rxclkslip(pld_pmaif_rxclkslip),
				      .pld_polinv_rx	(pld_polinv_rx),
				      .pld_rx_clk1_dcm	(pld_rx_clk1_dcm),
				      .pld_rx_clk1_rowclk(pld_rx_clk1_rowclk),
				      //.pld_rx_clk2_dcm	(pld_rx_clk2_dcm),
				      .pld_rx_clk2_rowclk(pld_rx_clk2_rowclk),
				      .pld_rx_fabric_fifo_align_clr(pld_rx_fabric_fifo_align_clr),
				      .pld_rx_fabric_fifo_rd_en(pld_rx_fabric_fifo_rd_en),
				      .pld_rx_prbs_err_clr(pld_rx_prbs_err_clr),
				      .pld_sclk2_rowclk	(pld_sclk2_rowclk),
				      .pld_sclk1_rowclk	(pld_sclk1_rowclk),
				      .pld_syncsm_en	(pld_syncsm_en),
				      .pld_rx_fifo_latency_adj_en (pld_rx_fifo_latency_adj_en),
				      .r_rx_aib_clk1_sel(r_rx_aib_clk1_sel[1:0]),
				      .r_rx_aib_clk2_sel(r_rx_aib_clk2_sel[1:0]),
				      .r_rx_async_pld_10g_rx_crc32_err_rst_val(r_rx_async_pld_10g_rx_crc32_err_rst_val),
				      .r_rx_async_pld_8g_signal_detect_out_rst_val(r_rx_async_pld_8g_signal_detect_out_rst_val),
				      .r_rx_async_pld_ltr_rst_val(r_rx_async_pld_ltr_rst_val),
				      .r_rx_async_pld_pma_ltd_b_rst_val(r_rx_async_pld_pma_ltd_b_rst_val),
				      .r_rx_async_pld_rx_fifo_align_clr_rst_val(r_rx_async_pld_rx_fifo_align_clr_rst_val),
				      .r_rx_async_prbs_flags_sr_enable(r_rx_async_prbs_flags_sr_enable),
				      .r_rx_bonding_dft_in_en(r_rx_bonding_dft_in_en),
				      .r_rx_bonding_dft_in_value(r_rx_bonding_dft_in_value),
				      .bond_rx_asn_ds_in_fifo_hold(bond_rx_asn_ds_in_fifo_hold),
				      //.bond_rx_asn_ds_in_dll_lock_en(bond_rx_asn_ds_in_dll_lock_en),
				      //.bond_rx_asn_ds_in_gen3_sel(bond_rx_asn_ds_in_gen3_sel),
				      .bond_rx_asn_us_in_fifo_hold(bond_rx_asn_us_in_fifo_hold),
				      //.bond_rx_asn_us_in_dll_lock_en(bond_rx_asn_us_in_dll_lock_en),
				      //.bond_rx_asn_us_in_gen3_sel(bond_rx_asn_us_in_gen3_sel),
				      .r_rx_asn_en	(r_rx_asn_en),
				      .r_rx_asn_bypass_pma_pcie_sw_done(r_rx_asn_bypass_pma_pcie_sw_done),
				      .r_rx_asn_wait_for_fifo_flush_cnt(r_rx_asn_wait_for_fifo_flush_cnt[7:0]),
				      .r_rx_asn_wait_for_dll_reset_cnt(r_rx_asn_wait_for_dll_reset_cnt[7:0]),
				      .r_rx_asn_wait_for_pma_pcie_sw_done_cnt(r_rx_asn_wait_for_pma_pcie_sw_done_cnt[7:0]),
//				      .r_rx_asn_master_sel(r_rx_asn_master_sel[1:0]),
//				      .r_rx_asn_dist_master_sel(r_rx_asn_dist_master_sel),
				      //.r_rx_asn_bonding_dft_in_en(r_rx_asn_bonding_dft_in_en),
				      //.r_rx_asn_bonding_dft_in_value(r_rx_asn_bonding_dft_in_value),
				      .r_rx_comp_cnt	(r_rx_comp_cnt[7:0]),
				      .r_rx_compin_sel	(r_rx_compin_sel[1:0]),
				      //.r_rx_coreclkin_sel(r_rx_coreclkin_sel),
				      .r_rx_double_read	(r_rx_double_read),
				      .r_rx_ds_bypass_pipeln(r_rx_ds_bypass_pipeln),
				      .r_rx_ds_master	(r_rx_ds_master),
				      .r_rx_fifo_empty	(r_rx_fifo_empty[5:0]),
				      .r_rx_fifo_full	(r_rx_fifo_full[5:0]),
				      .r_rx_fifo_mode	(r_rx_fifo_mode[2:0]),
				      .r_rx_fifo_pempty	(r_rx_fifo_pempty[5:0]),
				      .r_rx_fifo_pfull	(r_rx_fifo_pfull[5:0]),
				      .r_rx_fifo_rd_clk_scg_en(r_rx_fifo_rd_clk_scg_en),
				      .r_rx_fifo_rd_clk_sel(r_rx_fifo_rd_clk_sel[1:0]),
				      .r_rx_fifo_wr_clk_scg_en(r_rx_fifo_wr_clk_scg_en),
				      .r_rx_fifo_wr_clk_sel(r_rx_fifo_wr_clk_sel),
				      .r_rx_gb_dv_en	(r_rx_gb_dv_en),
				      .r_rx_indv	(r_rx_indv),
				      .r_rx_phcomp_rd_delay(r_rx_phcomp_rd_delay[2:0]),
				      .r_rx_pld_clk1_sel(r_rx_pld_clk1_sel),
				      .r_rx_pld_clk1_delay_en(r_rx_pld_clk1_delay_en),
				      .r_rx_pld_clk1_delay_sel(r_rx_pld_clk1_delay_sel[3:0]),
				      .r_rx_pld_clk1_inv_en(r_rx_pld_clk1_inv_en),
				      //.r_rx_pld_clk2_sel(r_rx_pld_clk2_sel),
				      .r_rx_pma_hclk_scg_en(r_rx_pma_hclk_scg_en),
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
				      .r_rx_wa_en	(r_rx_wa_en),
				      .r_rx_write_ctrl	(r_rx_write_ctrl),
      				      .r_rx_fifo_power_mode				 (r_rx_fifo_power_mode),
                                      .r_rx_stretch_num_stages				 (r_rx_stretch_num_stages), 	
                                      .r_rx_datapath_tb_sel 				 (r_rx_datapath_tb_sel), 
                                      .r_rx_wr_adj_en 					 (r_rx_wr_adj_en), 
                                      .r_rx_rd_adj_en					 (r_rx_rd_adj_en),				      
                                      .r_rx_pipe_en					 (r_rx_pipe_en),
                                      .r_rx_lpbk_en					 (r_rx_lpbk_en),
				      .rx_pld_rate	(rx_pld_rate),
                            	      .sr_testbus (sr_testbus),
				      .aib_fabric_tx_data_lpbk	(aib_fabric_tx_data_lpbk),
				      .rx_async_fabric_hssi_fsr_load(rx_async_fabric_hssi_fsr_load),
				      .rx_async_fabric_hssi_ssr_load(rx_async_fabric_hssi_ssr_load),
				      .rx_async_hssi_fabric_fsr_data(rx_async_hssi_fabric_fsr_data[1:0]),
				      .rx_async_hssi_fabric_fsr_load(rx_async_hssi_fabric_fsr_load),
				      .rx_async_hssi_fabric_ssr_data(rx_async_hssi_fabric_ssr_data[62:0]),
				      .rx_async_hssi_fabric_ssr_load(rx_async_hssi_fabric_ssr_load),
				      .rx_fsr_mask_tx_pll(rx_fsr_mask_tx_pll),
				      .rx_chnl_dprio_status_write_en(rx_chnl_dprio_status_write_en));
   

hdpldadapt_sr hdpldadapt_sr(/*AUTOINST*/
			    // Outputs
			    .ssrin_parallel_in(ssrin_parallel_in[117:0]),
			    .ssrout_parallel_out_latch(ssrout_parallel_out_latch[93:0]),
                            .sr_testbus (sr_testbus),
                            .rx_async_hssi_fabric_ssr_reserved (rx_async_hssi_fabric_ssr_reserved),
                            .tx_async_hssi_fabric_ssr_reserved (tx_async_hssi_fabric_ssr_reserved), 
			    .aib_fabric_tx_sr_clk_out(aib_fabric_tx_sr_clk_out),
			    .aib_fabric_fsr_data_out(aib_fabric_fsr_data_out),
			    .aib_fabric_fsr_load_out(aib_fabric_fsr_load_out),
			    .aib_fabric_ssr_data_out(aib_fabric_ssr_data_out),
			    .aib_fabric_ssr_load_out(aib_fabric_ssr_load_out),
			    .hip_aib_async_fsr_out(hip_aib_async_fsr_out[3:0]),
			    .hip_aib_async_ssr_out(hip_aib_async_ssr_out[7:0]),
			    .avmm1_hssi_fabric_ssr_data(avmm1_hssi_fabric_ssr_data),
			    .avmm1_hssi_fabric_ssr_load(avmm1_hssi_fabric_ssr_load),
			    .avmm2_hssi_fabric_ssr_data(avmm2_hssi_fabric_ssr_data),
			    .avmm2_hssi_fabric_ssr_load(avmm2_hssi_fabric_ssr_load),
			    .rx_async_hssi_fabric_fsr_data(rx_async_hssi_fabric_fsr_data[1:0]),
			    .rx_async_hssi_fabric_ssr_data(rx_async_hssi_fabric_ssr_data[62:0]),
			    .rx_async_hssi_fabric_fsr_load(rx_async_hssi_fabric_fsr_load),
			    .rx_async_hssi_fabric_ssr_load(rx_async_hssi_fabric_ssr_load),
			    .rx_async_fabric_hssi_fsr_load(rx_async_fabric_hssi_fsr_load),
			    .rx_async_fabric_hssi_ssr_load(rx_async_fabric_hssi_ssr_load),
			    .tx_async_hssi_fabric_fsr_data(tx_async_hssi_fabric_fsr_data),
			    .tx_async_hssi_fabric_ssr_data(tx_async_hssi_fabric_ssr_data[12:0]),
			    .tx_async_hssi_fabric_fsr_load(tx_async_hssi_fabric_fsr_load),
			    .tx_async_hssi_fabric_ssr_load(tx_async_hssi_fabric_ssr_load),
			    .tx_async_fabric_hssi_fsr_load(tx_async_fabric_hssi_fsr_load),
			    .tx_async_fabric_hssi_ssr_load(tx_async_fabric_hssi_ssr_load),
                            .avmm_fabric_hssi_ssr_load(avmm_fabric_hssi_ssr_load),
                            .avmm_hrdrst_hssi_osc_transfer_en_ssr_data(avmm_hrdrst_hssi_osc_transfer_en_ssr_data),
                            .avmm_hssi_fabric_ssr_load(avmm_hssi_fabric_ssr_load),
                            .sr_parity_error_flag(sr_parity_error_flag),
			    // Inputs
                            .avmm1_transfer_error(avmm1_transfer_error),
                            .avmm2_transfer_error(avmm2_transfer_error),
                            .sr_hssi_osc_transfer_en (sr_hssi_osc_transfer_en),
                            .rx_fsr_parity_checker_in (rx_fsr_parity_checker_in),
                            .rx_ssr_parity_checker_in (rx_ssr_parity_checker_in),
                            .hip_fsr_parity_checker_in (hip_fsr_parity_checker_in),
                            .hip_ssr_parity_checker_in (hip_ssr_parity_checker_in),
                            .tx_fsr_parity_checker_in  (tx_fsr_parity_checker_in),
                            .tx_ssr_parity_checker_in  (tx_ssr_parity_checker_in),
                            .avmm1_ssr_parity_checker_in (avmm1_ssr_parity_checker_in),
                            .avmm2_ssr_parity_checker_in (avmm2_ssr_parity_checker_in),
			    .dft_adpt_aibiobsr_fastclkn(dft_adpt_aibiobsr_fastclkn),
                            .adapter_scan_rst_n(adapter_scan_rst_n),
                            .adapter_scan_mode_n(adapter_scan_mode_n),
                            .adapter_scan_shift_n(adapter_scan_shift_n),
                            .adapter_scan_shift_clk(adapter_scan_shift_clk),
                            .adapter_scan_user_clk3(adapter_scan_user_clk3),         // 1GHz
                            .adapter_clk_sel_n(adapter_clk_sel_n),
                            .adapter_occ_enable(adapter_occ_enable),
                            .rx_async_fabric_hssi_ssr_reserved (rx_async_fabric_hssi_ssr_reserved),
                            .tx_async_fabric_hssi_ssr_reserved (tx_async_fabric_hssi_ssr_reserved),
                            .avmm_hrdrst_fabric_osc_transfer_en_sync (avmm_hrdrst_fabric_osc_transfer_en_sync),
                            .avmm_hrdrst_fabric_osc_transfer_en_ssr_data(avmm_hrdrst_fabric_osc_transfer_en_ssr_data),
			    .aib_fabric_rx_sr_clk_in(aib_fabric_rx_sr_clk_in),
			    .aib_fabric_tx_sr_clk_in(aib_fabric_tx_sr_clk_in),
			    .aib_fabric_fsr_data_in(aib_fabric_fsr_data_in),
			    .aib_fabric_fsr_load_in(aib_fabric_fsr_load_in),
			    .aib_fabric_ssr_data_in(aib_fabric_ssr_data_in),
			    .aib_fabric_ssr_load_in(aib_fabric_ssr_load_in),
			    .r_sr_hip_en	  (r_sr_hip_en),
                            .r_sr_reserbits_in_en  (r_sr_reserbits_in_en),
                            .r_sr_reserbits_out_en (r_sr_reserbits_out_en),
                            .r_sr_testbus_sel     (r_sr_testbus_sel),
                            .r_sr_parity_en       (r_sr_parity_en),
			    .r_sr_osc_clk_scg_en(r_sr_osc_clk_scg_en),
			    .rx_async_fabric_hssi_fsr_data(rx_async_fabric_hssi_fsr_data[2:0]),
			    .rx_async_fabric_hssi_ssr_data(rx_async_fabric_hssi_ssr_data[35:0]),
			    .tx_async_fabric_hssi_fsr_data(tx_async_fabric_hssi_fsr_data),
			    .tx_async_fabric_hssi_ssr_data(tx_async_fabric_hssi_ssr_data[35:0]),
			    .csr_rdy_dly_in	(csr_rdy_dly_in),
			    .hip_aib_async_fsr_in(hip_aib_async_fsr_in[3:0]),
			    .hip_aib_async_ssr_in(hip_aib_async_ssr_in[39:0]));
   

endmodule
