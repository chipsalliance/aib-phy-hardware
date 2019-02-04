// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved
module ndaibadapt_wrap (

// EMIB
    inout             io_aib0, 
    inout             io_aib1, 
    inout             io_aib10,
    inout             io_aib11,
    inout             io_aib12,
    inout             io_aib13,
    inout             io_aib14,
    inout             io_aib15,
    inout             io_aib16,
    inout             io_aib17,
    inout             io_aib18,
    inout             io_aib19,
    inout             io_aib2, 
    inout             io_aib20,
    inout             io_aib21,
    inout             io_aib22,
    inout             io_aib23,
    inout             io_aib24,
    inout             io_aib25,
    inout             io_aib26,
    inout             io_aib27,
    inout             io_aib28,
    inout             io_aib29,
    inout             io_aib3, 
    inout             io_aib30,
    inout             io_aib31,
    inout             io_aib32,
    inout             io_aib33,
    inout             io_aib34,
    inout             io_aib35,
    inout             io_aib36,
    inout             io_aib37,
    inout             io_aib38,
    inout             io_aib39,
    inout             io_aib4, 
    inout             io_aib40,
    inout             io_aib41,
    inout             io_aib42,
    inout             io_aib43,
    inout             io_aib44,
    inout             io_aib45,
    inout             io_aib46,
    inout             io_aib47,
    inout             io_aib48,
    inout             io_aib49,
    inout             io_aib5, 
    inout             io_aib50,
    inout             io_aib51,
    inout             io_aib52,
    inout             io_aib53,
    inout             io_aib54,
    inout             io_aib55,
    inout             io_aib56,
    inout             io_aib57,
    inout             io_aib58,
    inout             io_aib59,
    inout             io_aib6, 
    inout             io_aib60,
    inout             io_aib61,
    inout             io_aib62,
    inout             io_aib63,
    inout             io_aib64,
    inout             io_aib65,
    inout             io_aib66,
    inout             io_aib67,
    inout             io_aib68,
    inout             io_aib69,
    inout             io_aib7, 
    inout             io_aib70,
    inout             io_aib71,
    inout             io_aib72,
    inout             io_aib73,
    inout             io_aib74,
    inout             io_aib75,
    inout             io_aib76,
    inout             io_aib77,
    inout             io_aib78,
    inout             io_aib79,
    inout             io_aib8, 
    inout             io_aib80,
    inout             io_aib81,
    inout             io_aib82,
    inout             io_aib83,
    inout             io_aib84,
    inout             io_aib85,
    inout             io_aib86,
    inout             io_aib87,
    inout             io_aib88,
    inout             io_aib89,
    inout             io_aib9, 
    inout             io_aib90,
    inout             io_aib91,
    inout             io_aib92,
    inout             io_aib93,
    inout             io_aib94,
    inout             io_aib95,

    // Adapter        
    input  wire	      bond_rx_asn_ds_in_fifo_hold,
    input  wire	      bond_rx_asn_us_in_fifo_hold,
    input  wire	      bond_rx_fifo_ds_in_rden,
    input  wire	      bond_rx_fifo_ds_in_wren,
    input  wire	      bond_rx_fifo_us_in_rden,
    input  wire	      bond_rx_fifo_us_in_wren,
    input  wire       bond_rx_hrdrst_ds_in_fabric_rx_dll_lock,
    input  wire       bond_rx_hrdrst_us_in_fabric_rx_dll_lock,
    input  wire       bond_rx_hrdrst_ds_in_fabric_rx_dll_lock_req,
    input  wire       bond_rx_hrdrst_us_in_fabric_rx_dll_lock_req,
    input  wire	      bond_tx_fifo_ds_in_dv,
    input  wire	      bond_tx_fifo_ds_in_rden,
    input  wire	      bond_tx_fifo_ds_in_wren,
    input  wire	      bond_tx_fifo_us_in_dv,
    input  wire	      bond_tx_fifo_us_in_rden,
    input  wire	      bond_tx_fifo_us_in_wren,
    input  wire       bond_tx_hrdrst_ds_in_fabric_tx_dcd_cal_done,
    input  wire       bond_tx_hrdrst_us_in_fabric_tx_dcd_cal_done,
    input  wire       bond_tx_hrdrst_ds_in_fabric_tx_dcd_cal_req,
    input  wire       bond_tx_hrdrst_us_in_fabric_tx_dcd_cal_req,
    
    // Config  
    input  wire [2:0] csr_config,
    input  wire       csr_clk_in,
    input  wire [2:0] csr_in,
    input  wire [2:0] csr_pipe_in,
    input  wire       csr_rdy_dly_in,
    input  wire       csr_rdy_in,
    input  wire       nfrzdrv_in,
    input  wire       usermode_in,
    
    // PLD
    input  wire	[3:0]  hip_aib_fsr_in,
    input  wire	[39:0] hip_aib_ssr_in,
    input  wire	       hip_avmm_read,
    input  wire	[20:0] hip_avmm_reg_addr,
    input  wire	       hip_avmm_write,
    input  wire	[7:0]  hip_avmm_writedata,
    input  wire	       pld_10g_krfec_rx_clr_errblk_cnt,
    input  wire	       pld_10g_rx_align_clr,
    input  wire	       pld_10g_rx_clr_ber_count,
    input  wire	[6:0]  pld_10g_tx_bitslip,
    input  wire	       pld_10g_tx_burst_en,
    input  wire	[1:0]  pld_10g_tx_diag_status,
    input  wire	       pld_10g_tx_wordslip,
    input  wire	       pld_8g_a1a2_size,
    input  wire	       pld_8g_bitloc_rev_en,
    input  wire	       pld_8g_byte_rev_en,
    input  wire	[2:0]  pld_8g_eidleinfersel,
    input  wire	       pld_8g_encdt,
    input  wire	[4:0]  pld_8g_tx_boundary_sel,
    input  wire	       pld_adapter_rx_pld_rst_n,
    input  wire	       pld_adapter_tx_pld_rst_n,
    input  wire	       pld_avmm1_clk_rowclk,
    input  wire	       pld_avmm1_read,
    input  wire	[9:0]  pld_avmm1_reg_addr,
    input  wire	       pld_avmm1_request,
    input  wire	       pld_avmm1_write,
    input  wire	[7:0]  pld_avmm1_writedata,
    input  wire	[8:0]  pld_avmm1_reserved_in,
    input  wire	       pld_avmm2_clk_rowclk,
    input  wire	       pld_avmm2_read,
    input  wire	[8:0]  pld_avmm2_reg_addr,
    input  wire	       pld_avmm2_request,
    input  wire	       pld_avmm2_write,
    input  wire	[7:0]  pld_avmm2_writedata,
    input  wire	[9:0]  pld_avmm2_reserved_in,
    input  wire	       pld_bitslip,
    input  wire	[1:0]  pld_fpll_shared_direct_async_in,
    input  wire	       pld_fpll_shared_direct_async_in_rowclk,
    input  wire	       pld_fpll_shared_direct_async_in_dcm,
    input  wire	       pld_ltr,
    input  wire	       pr_channel_freeze_n,
    input  wire	       pld_pcs_rx_pld_rst_n,
    input  wire	       pld_pcs_tx_pld_rst_n,
    input  wire	       pld_pma_adapt_start,
    input  wire	       pld_pma_coreclkin_rowclk,
    input  wire	       pld_pma_csr_test_dis,
    input  wire	       pld_pma_early_eios,
    input  wire	[5:0]  pld_pma_eye_monitor,
    input  wire	[3:0]  pld_pma_fpll_cnt_sel,
    input  wire	       pld_pma_fpll_extswitch,
    input  wire	       pld_pma_fpll_lc_csr_test_dis,
    input  wire	[2:0]  pld_pma_fpll_num_phase_shifts,
    input  wire	       pld_pma_fpll_pfden,
    input  wire	       pld_pma_fpll_up_dn_lc_lf_rstn,
    input  wire	       pld_pma_ltd_b,
    input  wire	       pld_pma_nrpi_freeze,
    input  wire	[1:0]  pld_pma_pcie_switch,
    input  wire	       pld_pma_ppm_lock,
    input  wire	[4:0]  pld_pma_reserved_out,
    input  wire	       pld_pma_rs_lpbk_b,
    input  wire	       pld_pma_rxpma_rstb,
    input  wire	       pld_pma_tx_bitslip,
    input  wire	       pld_pma_txdetectrx,
    input  wire	       pld_pma_txpma_rstb,
    input  wire	       pld_pmaif_rxclkslip,
    input  wire	       pld_polinv_rx,
    input  wire	       pld_polinv_tx,
    input  wire	       pld_rx_clk1_rowclk,
    input  wire	       pld_rx_clk2_rowclk,
    input  wire	       pld_rx_dll_lock_req,
    input  wire	       pld_rx_fabric_fifo_align_clr,
    input  wire	       pld_rx_fabric_fifo_rd_en,
    input  wire	       pld_rx_prbs_err_clr,
    input  wire	       pld_sclk1_rowclk,
    input  wire	       pld_sclk2_rowclk,
    input  wire	       pld_syncsm_en,
    input  wire	       pld_tx_clk1_rowclk,
    input  wire	       pld_tx_clk2_rowclk,
    input  wire	[79:0] pld_tx_fabric_data_in,
    input  wire	       pld_txelecidle,
    input  wire        pld_tx_dll_lock_req,
    input  wire        pld_tx_fifo_latency_adj_en,
    input  wire        pld_rx_fifo_latency_adj_en,
    input  wire        pld_aib_fabric_rx_dll_lock_req,
    input  wire        pld_aib_fabric_tx_dcd_cal_req,
    input  wire        pld_aib_hssi_tx_dcd_cal_req,
    input  wire        pld_aib_hssi_tx_dll_lock_req,
    input  wire        pld_aib_hssi_rx_dcd_cal_req,
    input  wire [2:0]  pld_tx_ssr_reserved_in, 
    input  wire [1:0]  pld_rx_ssr_reserved_in, 
    input  wire        pld_pma_tx_qpi_pulldn,
    input  wire        pld_pma_tx_qpi_pullup,
    input  wire        pld_pma_rx_qpi_pullup,
    
    // PLD DCM
    input  wire        pld_rx_clk1_dcm,
    input  wire        pld_tx_clk1_dcm,
    input  wire        pld_tx_clk2_dcm,
    
    // uC AVMM
    
    // DFT
    input  wire        dft_adpt_aibiobsr_fastclkn,
    input  wire        adapter_scan_rst_n,
    input  wire        adapter_scan_mode_n,
    input  wire        adapter_scan_shift_n,
    input  wire        adapter_scan_shift_clk,
    input  wire        adapter_scan_user_clk0,         // 125MHz
    input  wire        adapter_scan_user_clk1,         // 250MHz
    input  wire        adapter_scan_user_clk2,         // 500MHz
    input  wire        adapter_scan_user_clk3,         // 1GHz
    input  wire        adapter_clk_sel_n,
    input  wire        adapter_occ_enable,
    input  wire        adapter_global_pipe_se,
    input  wire [3:0]  adapter_config_scan_in,
    input  wire [1:0]  adapter_scan_in_occ1,
    input  wire [4:0]  adapter_scan_in_occ2,
    input  wire        adapter_scan_in_occ3,
    input  wire        adapter_scan_in_occ4,
    input  wire [1:0]  adapter_scan_in_occ5,
    input  wire [10:0] adapter_scan_in_occ6,
    input  wire        adapter_scan_in_occ7,
    input  wire        adapter_scan_in_occ8,
    input  wire        adapter_scan_in_occ9,
    input  wire        adapter_scan_in_occ10,
    input  wire        adapter_scan_in_occ11,
    input  wire        adapter_scan_in_occ12,
    input  wire        adapter_scan_in_occ13,
    input  wire        adapter_scan_in_occ14,
    input  wire        adapter_scan_in_occ15,
    input  wire        adapter_scan_in_occ16,
    input  wire        adapter_scan_in_occ17,
    input  wire [1:0]  adapter_scan_in_occ18,
    input  wire        adapter_scan_in_occ19,
    input  wire        adapter_scan_in_occ20,
    input  wire [1:0]  adapter_scan_in_occ21,
    input  wire        adapter_non_occ_scan_in,
    input  wire        adapter_occ_scan_in,
    input  wire [2:0]  dft_fabric_iaibdftcore2dll,
    
    
    // DFT
    output wire [3:0]  adapter_config_scan_out,
    output wire [1:0]  adapter_scan_out_occ1,
    output wire [4:0]  adapter_scan_out_occ2,
    output wire        adapter_scan_out_occ3,
    output wire        adapter_scan_out_occ4,
    output wire [1:0]  adapter_scan_out_occ5,
    output wire [10:0] adapter_scan_out_occ6,
    output wire        adapter_scan_out_occ7,
    output wire        adapter_scan_out_occ8,
    output wire        adapter_scan_out_occ9,
    output wire        adapter_scan_out_occ10,
    output wire        adapter_scan_out_occ11,
    output wire        adapter_scan_out_occ12,
    output wire        adapter_scan_out_occ13,
    output wire        adapter_scan_out_occ14,
    output wire        adapter_scan_out_occ15,
    output wire        adapter_scan_out_occ16,
    output wire        adapter_scan_out_occ17,
    output wire [1:0]  adapter_scan_out_occ18,
    output wire        adapter_scan_out_occ19,
    output wire        adapter_scan_out_occ20,
    output wire [1:0]  adapter_scan_out_occ21,
    output wire        adapter_non_occ_scan_out,
    output wire        adapter_occ_scan_out,
    output wire [12:0] dft_fabric_oaibdftdll2core,
    
    // Adapter
    output wire        bond_rx_asn_ds_out_fifo_hold,
    output wire        bond_rx_asn_us_out_fifo_hold,
    output wire        bond_rx_fifo_ds_out_rden,
    output wire        bond_rx_fifo_ds_out_wren,
    output wire        bond_rx_fifo_us_out_rden,
    output wire        bond_rx_fifo_us_out_wren,
    output wire        bond_rx_hrdrst_ds_out_fabric_rx_dll_lock,
    output wire        bond_rx_hrdrst_us_out_fabric_rx_dll_lock,
    output wire        bond_rx_hrdrst_ds_out_fabric_rx_dll_lock_req,
    output wire        bond_rx_hrdrst_us_out_fabric_rx_dll_lock_req,
    output wire        bond_tx_fifo_ds_out_dv,
    output wire        bond_tx_fifo_ds_out_rden,
    output wire        bond_tx_fifo_ds_out_wren,
    output wire        bond_tx_fifo_us_out_dv,
    output wire        bond_tx_fifo_us_out_rden,
    output wire        bond_tx_fifo_us_out_wren,
    output wire        bond_tx_hrdrst_ds_out_fabric_tx_dcd_cal_done,
    output wire        bond_tx_hrdrst_us_out_fabric_tx_dcd_cal_done,
    output wire        bond_tx_hrdrst_ds_out_fabric_tx_dcd_cal_req,
    output wire        bond_tx_hrdrst_us_out_fabric_tx_dcd_cal_req,
    
    
    // Config
    output wire        csr_clk_out,
    output wire [2:0]  csr_out,
    output wire [2:0]  csr_pipe_out,
    output wire	       csr_rdy_dly_out,
    output wire	       csr_rdy_out,
    output wire	       nfrzdrv_out,
    output wire	       usermode_out,
           
    // PLD 
    output wire	[3:0]  hip_aib_fsr_out,
    output wire	[7:0]  hip_aib_ssr_out,
    output wire	[7:0]  hip_avmm_readdata,
    output wire	       hip_avmm_readdatavalid,
    output wire	       hip_avmm_writedone,
    output wire [4:0]  hip_avmm_reserved_out,
    output wire	       pld_10g_krfec_rx_blk_lock,
    output wire	[1:0]  pld_10g_krfec_rx_diag_data_status,
    output wire	       pld_10g_krfec_rx_frame,
    output wire	       pld_10g_krfec_tx_frame,
    output wire	       pld_krfec_tx_alignment,
    output wire	       pld_10g_rx_crc32_err,
    output wire	       pld_rx_fabric_fifo_insert,
    output wire	       pld_rx_fabric_fifo_del,
           
    output wire	       pld_10g_rx_frame_lock,
    output wire	       pld_10g_rx_hi_ber,
    output wire	       pld_10g_tx_burst_en_exe,
    output wire	[3:0]  pld_8g_a1a2_k1k2_flag,
    output wire	       pld_8g_empty_rmf,
    output wire	       pld_8g_full_rmf,
    output wire	       pld_8g_rxelecidle,
    output wire	       pld_8g_signal_detect_out,
    output wire	[4:0]  pld_8g_wa_boundary,
    output wire	       pld_avmm1_busy,
    output wire	       pld_avmm1_cmdfifo_wr_full,
    output wire	       pld_avmm1_cmdfifo_wr_pfull,
    output wire	[7:0]  pld_avmm1_readdata,
    output wire	       pld_avmm1_readdatavalid,
    output wire	[2:0]  pld_avmm1_reserved_out,
    output wire	       pld_avmm2_busy,
    output wire	       pld_avmm2_cmdfifo_wr_full,
    output wire	       pld_avmm2_cmdfifo_wr_pfull,
    output wire	[7:0]  pld_avmm2_readdata,
    output wire	       pld_avmm2_readdatavalid,
    output wire	[2:0]  pld_avmm2_reserved_out,
    output wire	       pld_chnl_cal_done,
    output wire	       pld_fpll_shared_direct_async_out,
    output wire	[3:0]  pld_fpll_shared_direct_async_out_hioint,
    output wire	[3:0]  pld_fpll_shared_direct_async_out_dcm,
    output wire	       pld_fsr_load,
    output wire	       pld_pcs_rx_clk_out1_hioint,
    output wire	       pld_pcs_rx_clk_out2_hioint,
    output wire	       pld_pcs_tx_clk_out1_hioint,
    output wire	       pld_pcs_tx_clk_out2_hioint,
    output wire	       pld_pll_cal_done,
    output wire	       pld_pma_adapt_done,
    output wire	       pld_pma_fpll_clk0bad,
    output wire	       pld_pma_fpll_clk1bad,
    output wire	       pld_pma_fpll_clksel,
    output wire	       pld_pma_fpll_phase_done,
    output wire	       pld_pma_hclk_hioint,
    output wire	       pld_pma_internal_clk1_hioint,
    output wire	       pld_pma_internal_clk2_hioint,
    output wire	[1:0]  pld_pma_pcie_sw_done,
    output wire	       pld_pma_pfdmode_lock,
    output wire	[4:0]  pld_pma_reserved_in,
    output wire	       pld_pma_rx_detect_valid,
    output wire	       pld_pma_rx_found,
    output wire	       pld_pma_rxpll_lock,
    output wire	       pld_pma_signal_ok,
    output wire	[7:0]  pld_pma_testbus,
    output wire	       pld_pmaif_mask_tx_pll,
    output wire	       pld_rx_fabric_align_done,
    output wire	[79:0] pld_rx_fabric_data_out,
    output wire	       pld_rx_fabric_fifo_empty,
    output wire	       pld_rx_fabric_fifo_full,
    output wire	       pld_rx_fabric_fifo_latency_pulse,
    output wire	       pld_rx_fabric_fifo_pempty,
    output wire	       pld_rx_fabric_fifo_pfull,
    output wire	       pld_rx_hssi_fifo_empty,
    output wire	       pld_rx_hssi_fifo_full,
    output wire	       pld_rx_hssi_fifo_latency_pulse,
    output wire	       pld_rx_prbs_done,
    output wire	       pld_rx_prbs_err,
    output wire	       pld_ssr_load,
    output wire	[19:0] pld_test_data,
    output wire	       pld_tx_fabric_fifo_empty,
    output wire	       pld_tx_fabric_fifo_full,
    output wire	       pld_tx_fabric_fifo_latency_pulse,
    output wire	       pld_tx_fabric_fifo_pempty,
    output wire	       pld_tx_fabric_fifo_pfull,
    output wire	       pld_tx_hssi_align_done,
    output wire	       pld_tx_hssi_fifo_empty,
    output wire	       pld_tx_hssi_fifo_full,
    output wire	       pld_tx_hssi_fifo_latency_pulse,
    output wire	       pld_hssi_osc_transfer_en,
    output wire        pld_hssi_rx_transfer_en,
    output wire        pld_fabric_tx_transfer_en,
    output wire        pld_aib_fabric_rx_dll_lock,
    output wire        pld_aib_fabric_tx_dcd_cal_done,
    output wire        pld_aib_hssi_rx_dcd_cal_done,
    output wire        pld_aib_hssi_tx_dcd_cal_done,
    output wire        pld_aib_hssi_tx_dll_lock,
    output wire        pld_hssi_asn_dll_lock_en,
    output wire        pld_fabric_asn_dll_lock_en,	
    output wire [2:0]  pld_tx_ssr_reserved_out,
    output wire [1:0]  pld_rx_ssr_reserved_out,
    
    // PLD DCM
    output wire        pld_pcs_rx_clk_out1_dcm,
    output wire        pld_pcs_rx_clk_out2_dcm,
    output wire        pld_pcs_tx_clk_out1_dcm,
    output wire        pld_pcs_tx_clk_out2_dcm,

    input  wire        iatpg_pipeline_global_en,
    input  wire        iatpg_scan_clk_in0,
    input  wire        iatpg_scan_clk_in1,
    input  wire        iatpg_scan_in0,
    input  wire        iatpg_scan_in1,
    input  wire        iatpg_scan_shift_n,
    input  wire        iatpg_scan_mode_n,
    input  wire        iatpg_scan_rst_n,
    input  wire        ijtag_clkdr_in_chain,
    input  wire        ijtag_last_bs_in_chain,
    input  wire        ijtag_tx_scan_in_chain,
    input  wire        ired_directin_data_in_chain1,
    input  wire        ired_directin_data_in_chain2,
    input  wire [2:0]  ired_irxen_in_chain1,
    input  wire [2:0]  ired_irxen_in_chain2,
    input  wire        ired_shift_en_in_chain1,
    input  wire        ired_shift_en_in_chain2,
    input  wire        jtag_clksel,
    input  wire        jtag_intest,
    input  wire        jtag_mode_in,
    input  wire        jtag_rstb,
    input  wire        jtag_rstb_en,
    input  wire        jtag_tx_scanen_in,
    input  wire        jtag_weakpdn,
    input  wire        jtag_weakpu,
    output wire        jtag_clksel_out,
    output wire        jtag_intest_out,
    output wire        jtag_mode_out,
    output wire        jtag_rstb_en_out,
    output wire        jtag_rstb_out,
    output wire        jtag_tx_scanen_out,
    output wire        jtag_weakpdn_out,
    output wire        jtag_weakpu_out,
    output wire        oatpg_scan_out0,
    output wire        oatpg_scan_out1,
    output wire        ojtag_clkdr_out_chain,
    output wire        ojtag_last_bs_out_chain,
    output wire        ojtag_rx_scan_out_chain,
    output wire        ored_directin_data_out0_chain1,
    output wire        ored_directin_data_out0_chain2,
    output wire [2:0]  ored_rxen_out_chain1,
    output wire [2:0]  ored_rxen_out_chain2,
    output wire        ored_shift_en_out_chain1,
    output wire        ored_shift_en_out_chain2
);
    
// Internal wires
wire	      aib_fabric_avmm1_data_in;
wire	      aib_fabric_avmm2_data_in;
wire [4:0]    aib_fabric_fpll_shared_direct_async_in;
wire	      aib_fabric_fsr_data_in;
wire	      aib_fabric_fsr_load_in;
wire	      aib_fabric_pld_8g_rxelecidle;
wire	      aib_fabric_pld_pcs_rx_clk_out;
wire	      aib_fabric_pld_pcs_tx_clk_out;
wire	      aib_fabric_pld_pma_clkdiv_rx_user;
wire	      aib_fabric_pld_pma_clkdiv_tx_user;
wire	      aib_fabric_pld_pma_hclk;
wire	      aib_fabric_pld_pma_internal_clk1;
wire	      aib_fabric_pld_pma_internal_clk2;
wire	      aib_fabric_pld_pma_pfdmode_lock;
wire	      aib_fabric_pld_pma_rxpll_lock;
wire	      aib_fabric_pld_rx_hssi_fifo_latency_pulse;
wire	      aib_fabric_pld_tx_hssi_fifo_latency_pulse;
wire	      aib_fabric_pma_aib_tx_clk;
wire [39:0]   aib_fabric_rx_data_in;
wire	      aib_fabric_rx_dll_lock;
wire	      aib_fabric_rx_sr_clk_in;
wire	      aib_fabric_rx_transfer_clk;
wire	      aib_fabric_ssr_data_in;
wire	      aib_fabric_ssr_load_in;
wire	      aib_fabric_tx_dcd_cal_done;
wire	      aib_fabric_tx_sr_clk_in;
wire [7:0]    aib_csr_ctrl_0;
wire [7:0]    aib_csr_ctrl_1;
wire [7:0]    aib_csr_ctrl_10;
wire [7:0]    aib_csr_ctrl_11;
wire [7:0]    aib_csr_ctrl_12;
wire [7:0]    aib_csr_ctrl_13;
wire [7:0]    aib_csr_ctrl_14;
wire [7:0]    aib_csr_ctrl_15;
wire [7:0]    aib_csr_ctrl_16;
wire [7:0]    aib_csr_ctrl_17;
wire [7:0]    aib_csr_ctrl_18;
wire [7:0]    aib_csr_ctrl_19;
wire [7:0]    aib_csr_ctrl_2;
wire [7:0]    aib_csr_ctrl_20;
wire [7:0]    aib_csr_ctrl_21;
wire [7:0]    aib_csr_ctrl_22;
wire [7:0]    aib_csr_ctrl_23;
wire [7:0]    aib_csr_ctrl_24;
wire [7:0]    aib_csr_ctrl_25;
wire [7:0]    aib_csr_ctrl_26;
wire [7:0]    aib_csr_ctrl_27;
wire [7:0]    aib_csr_ctrl_28;
wire [7:0]    aib_csr_ctrl_29;
wire [7:0]    aib_csr_ctrl_3;
wire [7:0]    aib_csr_ctrl_30;
wire [7:0]    aib_csr_ctrl_31;
wire [7:0]    aib_csr_ctrl_32;
wire [7:0]    aib_csr_ctrl_33;
wire [7:0]    aib_csr_ctrl_34;
wire [7:0]    aib_csr_ctrl_35;
wire [7:0]    aib_csr_ctrl_36;
wire [7:0]    aib_csr_ctrl_37;
wire [7:0]    aib_csr_ctrl_38;
wire [7:0]    aib_csr_ctrl_39;
wire [7:0]    aib_csr_ctrl_4;
wire [7:0]    aib_csr_ctrl_40;
wire [7:0]    aib_csr_ctrl_41;
wire [7:0]    aib_csr_ctrl_42;
wire [7:0]    aib_csr_ctrl_43;
wire [7:0]    aib_csr_ctrl_44;
wire [7:0]    aib_csr_ctrl_45;
wire [7:0]    aib_csr_ctrl_46;
wire [7:0]    aib_csr_ctrl_47;
wire [7:0]    aib_csr_ctrl_48;
wire [7:0]    aib_csr_ctrl_49;
wire [7:0]    aib_csr_ctrl_5;
wire [7:0]    aib_csr_ctrl_50;
wire [7:0]    aib_csr_ctrl_51;
wire [7:0]    aib_csr_ctrl_52;
wire [7:0]    aib_csr_ctrl_53;
wire [7:0]    aib_csr_ctrl_54;
wire [7:0]    aib_csr_ctrl_55;
wire [7:0]    aib_csr_ctrl_56;
wire [7:0]    aib_csr_ctrl_57;
wire [7:0]    aib_csr_ctrl_6;
wire [7:0]    aib_csr_ctrl_7;
wire [7:0]    aib_csr_ctrl_8;
wire [7:0]    aib_csr_ctrl_9;
wire [7:0]    aib_dprio_ctrl_0;
wire [7:0]    aib_dprio_ctrl_1;
wire [7:0]    aib_dprio_ctrl_2;
wire [7:0]    aib_dprio_ctrl_3;
wire [7:0]    aib_dprio_ctrl_4;
wire [12:0]   oaibdftdll2core;
wire          w_atpg_pipeline_global_en;
wire [2:0]    iaibdftcore2dll;

// ADPT -> AIB
wire          aib_fabric_csr_rdy_dly_in;
wire          aib_fabric_adapter_rx_pld_rst_n;
wire          aib_fabric_adapter_tx_pld_rst_n;
wire [1:0]    aib_fabric_avmm1_data_out;
wire [1:0]    aib_fabric_avmm2_data_out;
wire [2:0]    aib_fabric_fpll_shared_direct_async_out;
wire          aib_fabric_fsr_data_out;
wire          aib_fabric_fsr_load_out;
wire          aib_fabric_pcs_rx_pld_rst_n;
wire          aib_fabric_pcs_tx_pld_rst_n;
wire          aib_fabric_pld_pma_coreclkin;
wire          aib_fabric_pld_pma_rxpma_rstb;
wire          aib_fabric_pld_pma_txdetectrx;
wire          aib_fabric_pld_pma_txpma_rstb;
wire          aib_fabric_pld_sclk;
wire          aib_fabric_rx_dll_lock_req;
wire          aib_fabric_ssr_data_out;
wire          aib_fabric_ssr_load_out;
wire [39:0]   aib_fabric_tx_data_out;
wire          aib_fabric_tx_dcd_cal_req;
wire          aib_fabric_tx_sr_clk_out;
wire          aib_fabric_tx_transfer_clk;
    

                      
hdpldadapt hdpldadapt (
  // AIB
  .aib_fabric_avmm1_data_in                 (aib_fabric_avmm1_data_in),
  .aib_fabric_avmm2_data_in                 (aib_fabric_avmm2_data_in),
  .aib_fabric_fpll_shared_direct_async_in   (aib_fabric_fpll_shared_direct_async_in),
  .aib_fabric_fsr_data_in                   (aib_fabric_fsr_data_in),
  .aib_fabric_fsr_load_in                   (aib_fabric_fsr_load_in),
  .aib_fabric_pld_8g_rxelecidle             (aib_fabric_pld_8g_rxelecidle),
  .aib_fabric_pld_pcs_rx_clk_out            (aib_fabric_pld_pcs_rx_clk_out),
  .aib_fabric_pld_pcs_tx_clk_out            (aib_fabric_pld_pcs_tx_clk_out),
  .aib_fabric_pld_pma_clkdiv_rx_user        (aib_fabric_pld_pma_clkdiv_rx_user),
  .aib_fabric_pld_pma_clkdiv_tx_user        (aib_fabric_pld_pma_clkdiv_tx_user),
  .aib_fabric_pld_pma_hclk                  (aib_fabric_pld_pma_hclk),
  .aib_fabric_pld_pma_internal_clk1         (aib_fabric_pld_pma_internal_clk1),
  .aib_fabric_pld_pma_internal_clk2         (aib_fabric_pld_pma_internal_clk2),
  .aib_fabric_pld_pma_pfdmode_lock          (aib_fabric_pld_pma_pfdmode_lock),
  .aib_fabric_pld_pma_rxpll_lock            (aib_fabric_pld_pma_rxpll_lock),
  .aib_fabric_pld_rx_hssi_fifo_latency_pulse(aib_fabric_pld_rx_hssi_fifo_latency_pulse),
  .aib_fabric_pld_tx_hssi_fifo_latency_pulse(aib_fabric_pld_tx_hssi_fifo_latency_pulse),
  .aib_fabric_pma_aib_tx_clk                (aib_fabric_pma_aib_tx_clk),
  .aib_fabric_rx_data_in                    (aib_fabric_rx_data_in),
  .aib_fabric_rx_dll_lock                   (aib_fabric_rx_dll_lock),
  .aib_fabric_rx_sr_clk_in                  (aib_fabric_rx_sr_clk_in),
  .aib_fabric_rx_transfer_clk               (aib_fabric_rx_transfer_clk),
  .aib_fabric_ssr_data_in                   (aib_fabric_ssr_data_in),
  .aib_fabric_ssr_load_in                   (aib_fabric_ssr_load_in),
  .aib_fabric_tx_dcd_cal_done               (aib_fabric_tx_dcd_cal_done),
  .aib_fabric_tx_sr_clk_in                  (aib_fabric_tx_sr_clk_in),
  
  // Adapter
  .bond_rx_asn_ds_in_fifo_hold                (bond_rx_asn_ds_in_fifo_hold),
  .bond_rx_asn_us_in_fifo_hold                (bond_rx_asn_us_in_fifo_hold),
  .bond_rx_fifo_ds_in_rden                    (bond_rx_fifo_ds_in_rden),
  .bond_rx_fifo_ds_in_wren                    (bond_rx_fifo_ds_in_wren),
  .bond_rx_fifo_us_in_rden                    (bond_rx_fifo_us_in_rden),
  .bond_rx_fifo_us_in_wren                    (bond_rx_fifo_us_in_wren),
  .bond_rx_hrdrst_ds_in_fabric_rx_dll_lock    (bond_rx_hrdrst_ds_in_fabric_rx_dll_lock),
  .bond_rx_hrdrst_us_in_fabric_rx_dll_lock    (bond_rx_hrdrst_us_in_fabric_rx_dll_lock),
  .bond_rx_hrdrst_ds_in_fabric_rx_dll_lock_req(bond_rx_hrdrst_ds_in_fabric_rx_dll_lock_req),
  .bond_rx_hrdrst_us_in_fabric_rx_dll_lock_req(bond_rx_hrdrst_us_in_fabric_rx_dll_lock_req),
  .bond_tx_fifo_ds_in_dv                      (bond_tx_fifo_ds_in_dv),
  .bond_tx_fifo_ds_in_rden                    (bond_tx_fifo_ds_in_rden),
  .bond_tx_fifo_ds_in_wren                    (bond_tx_fifo_ds_in_wren),
  .bond_tx_fifo_us_in_dv                      (bond_tx_fifo_us_in_dv),
  .bond_tx_fifo_us_in_rden                    (bond_tx_fifo_us_in_rden),
  .bond_tx_fifo_us_in_wren                    (bond_tx_fifo_us_in_wren),
  .bond_tx_hrdrst_ds_in_fabric_tx_dcd_cal_done(bond_tx_hrdrst_ds_in_fabric_tx_dcd_cal_done),
  .bond_tx_hrdrst_us_in_fabric_tx_dcd_cal_done(bond_tx_hrdrst_us_in_fabric_tx_dcd_cal_done),
  .bond_tx_hrdrst_ds_in_fabric_tx_dcd_cal_req (bond_tx_hrdrst_ds_in_fabric_tx_dcd_cal_req),
  .bond_tx_hrdrst_us_in_fabric_tx_dcd_cal_req (bond_tx_hrdrst_us_in_fabric_tx_dcd_cal_req),
  
  // Config
  .csr_config                                 (csr_config),
  .csr_clk_in                                 (csr_clk_in),
  .csr_in                                     (csr_in),
  .csr_pipe_in                                (csr_pipe_in),
  .csr_rdy_dly_in                             (csr_rdy_dly_in),
  .csr_rdy_in                                 (csr_rdy_in),
  .nfrzdrv_in                                 (nfrzdrv_in),
  .usermode_in                                (usermode_in),
  
  // PLD
  .hip_aib_fsr_in                             (hip_aib_fsr_in),
  .hip_aib_ssr_in                             (hip_aib_ssr_in),
  .hip_avmm_read                              (hip_avmm_read),
  .hip_avmm_reg_addr                          (hip_avmm_reg_addr),
  .hip_avmm_write                             (hip_avmm_write),
  .hip_avmm_writedata                         (hip_avmm_writedata),
  .pld_10g_krfec_rx_clr_errblk_cnt            (pld_10g_krfec_rx_clr_errblk_cnt),
  .pld_10g_rx_align_clr                       (pld_10g_rx_align_clr),
  .pld_10g_rx_clr_ber_count                   (pld_10g_rx_clr_ber_count),
  .pld_10g_tx_bitslip                         (pld_10g_tx_bitslip),
  .pld_10g_tx_burst_en                        (pld_10g_tx_burst_en),
  .pld_10g_tx_diag_status                     (pld_10g_tx_diag_status),
  .pld_10g_tx_wordslip                        (pld_10g_tx_wordslip),
  .pld_8g_a1a2_size                           (pld_8g_a1a2_size),
  .pld_8g_bitloc_rev_en                       (pld_8g_bitloc_rev_en),
  .pld_8g_byte_rev_en                         (pld_8g_byte_rev_en),
  .pld_8g_eidleinfersel                       (pld_8g_eidleinfersel),
  .pld_8g_encdt                               (pld_8g_encdt),
  .pld_8g_tx_boundary_sel                     (pld_8g_tx_boundary_sel),
  .pld_adapter_rx_pld_rst_n                   (pld_adapter_rx_pld_rst_n),
  .pld_adapter_tx_pld_rst_n                   (pld_adapter_tx_pld_rst_n),
  .pld_avmm1_clk_rowclk                       (pld_avmm1_clk_rowclk),
  .pld_avmm1_read                             (pld_avmm1_read),
  .pld_avmm1_reg_addr                         (pld_avmm1_reg_addr),
  .pld_avmm1_request                          (pld_avmm1_request),
  .pld_avmm1_write                            (pld_avmm1_write),
  .pld_avmm1_writedata                        (pld_avmm1_writedata),
  .pld_avmm1_reserved_in                      (pld_avmm1_reserved_in),
  .pld_avmm2_clk_rowclk                       (pld_avmm2_clk_rowclk),
  .pld_avmm2_read                             (pld_avmm2_read),
  .pld_avmm2_reg_addr                         (pld_avmm2_reg_addr),
  .pld_avmm2_request                          (pld_avmm2_request),
  .pld_avmm2_write                            (pld_avmm2_write),
  .pld_avmm2_writedata                        (pld_avmm2_writedata),
  .pld_avmm2_reserved_in                      (pld_avmm2_reserved_in),
  .pld_bitslip                                (pld_bitslip),
  .pld_fpll_shared_direct_async_in            (pld_fpll_shared_direct_async_in),
  .pld_fpll_shared_direct_async_in_rowclk     (pld_fpll_shared_direct_async_in_rowclk),
  .pld_fpll_shared_direct_async_in_dcm        (pld_fpll_shared_direct_async_in_dcm),
  .pld_ltr                                    (pld_ltr),
  .pr_channel_freeze_n                        (pr_channel_freeze_n),
  .pld_pcs_rx_pld_rst_n                       (pld_pcs_rx_pld_rst_n),
  .pld_pcs_tx_pld_rst_n                       (pld_pcs_tx_pld_rst_n),
  .pld_pma_adapt_start                        (pld_pma_adapt_start),
  .pld_pma_coreclkin_rowclk                   (pld_pma_coreclkin_rowclk),
  .pld_pma_csr_test_dis                       (pld_pma_csr_test_dis),
  .pld_pma_early_eios                         (pld_pma_early_eios),
  .pld_pma_eye_monitor                        (pld_pma_eye_monitor),
  .pld_pma_fpll_cnt_sel                       (pld_pma_fpll_cnt_sel),
  .pld_pma_fpll_extswitch                     (pld_pma_fpll_extswitch),
  .pld_pma_fpll_lc_csr_test_dis               (pld_pma_fpll_lc_csr_test_dis),
  .pld_pma_fpll_num_phase_shifts              (pld_pma_fpll_num_phase_shifts),
  .pld_pma_fpll_pfden                         (pld_pma_fpll_pfden),
  .pld_pma_fpll_up_dn_lc_lf_rstn              (pld_pma_fpll_up_dn_lc_lf_rstn),
  .pld_pma_ltd_b                              (pld_pma_ltd_b),
  .pld_pma_nrpi_freeze                        (pld_pma_nrpi_freeze),
  .pld_pma_pcie_switch                        (pld_pma_pcie_switch),
  .pld_pma_ppm_lock                           (pld_pma_ppm_lock),
  .pld_pma_reserved_out                       (pld_pma_reserved_out),
  .pld_pma_rs_lpbk_b                          (pld_pma_rs_lpbk_b),
  .pld_pma_rxpma_rstb                         (pld_pma_rxpma_rstb),
  .pld_pma_tx_bitslip                         (pld_pma_tx_bitslip),
  .pld_pma_txdetectrx                         (pld_pma_txdetectrx),
  .pld_pma_txpma_rstb                         (pld_pma_txpma_rstb),
  .pld_pmaif_rxclkslip                        (pld_pmaif_rxclkslip),
  .pld_polinv_rx                              (pld_polinv_rx),
  .pld_polinv_tx                              (pld_polinv_tx),
  .pld_rx_clk1_rowclk                         (pld_rx_clk1_rowclk),
  .pld_rx_clk2_rowclk                         (pld_rx_clk2_rowclk),
  .pld_rx_dll_lock_req                        (pld_rx_dll_lock_req),
  .pld_rx_fabric_fifo_align_clr               (pld_rx_fabric_fifo_align_clr),
  .pld_rx_fabric_fifo_rd_en                   (pld_rx_fabric_fifo_rd_en),
  .pld_rx_prbs_err_clr                        (pld_rx_prbs_err_clr),
  .pld_sclk1_rowclk                           (pld_sclk1_rowclk),
  .pld_sclk2_rowclk                           (pld_sclk2_rowclk),
  .pld_syncsm_en                              (pld_syncsm_en),
  .pld_tx_clk1_rowclk                         (pld_tx_clk1_rowclk),
  .pld_tx_clk2_rowclk                         (pld_tx_clk2_rowclk),
  .pld_tx_fabric_data_in                      (pld_tx_fabric_data_in),
  .pld_txelecidle                             (pld_txelecidle),
  .pld_tx_dll_lock_req                        (pld_tx_dll_lock_req),
  .pld_tx_fifo_latency_adj_en                 (pld_tx_fifo_latency_adj_en),
  .pld_rx_fifo_latency_adj_en                 (pld_rx_fifo_latency_adj_en),
  .pld_aib_fabric_rx_dll_lock_req             (pld_aib_fabric_rx_dll_lock_req),
  .pld_aib_fabric_tx_dcd_cal_req              (pld_aib_fabric_tx_dcd_cal_req),
  .pld_aib_hssi_tx_dcd_cal_req                (pld_aib_hssi_tx_dcd_cal_req),
  .pld_aib_hssi_tx_dll_lock_req               (pld_aib_hssi_tx_dll_lock_req),
  .pld_aib_hssi_rx_dcd_cal_req                (pld_aib_hssi_rx_dcd_cal_req),
  .pld_tx_ssr_reserved_in                     (pld_tx_ssr_reserved_in), 
  .pld_rx_ssr_reserved_in                     (pld_rx_ssr_reserved_in), 
  .pld_pma_tx_qpi_pulldn                      (pld_pma_tx_qpi_pulldn),
  .pld_pma_tx_qpi_pullup                      (pld_pma_tx_qpi_pullup),
  .pld_pma_rx_qpi_pullup                      (pld_pma_rx_qpi_pullup),
  
  // PLD DCM
  .pld_rx_clk1_dcm                            (pld_rx_clk1_dcm),
  .pld_tx_clk1_dcm                            (pld_tx_clk1_dcm),
  .pld_tx_clk2_dcm                            (pld_tx_clk2_dcm),
  
  // uC AVMM
  
  // DFT
  .dft_adpt_aibiobsr_fastclkn                 (dft_adpt_aibiobsr_fastclkn),
  .adapter_scan_rst_n                         (adapter_scan_rst_n),
  .adapter_scan_mode_n                        (adapter_scan_mode_n),
  .adapter_scan_shift_n                       (adapter_scan_shift_n),
  .adapter_scan_shift_clk                     (adapter_scan_shift_clk),
  .adapter_scan_user_clk0                     (adapter_scan_user_clk0),         // 125MHz
  .adapter_scan_user_clk1                     (adapter_scan_user_clk1),         // 250MHz
  .adapter_scan_user_clk2                     (adapter_scan_user_clk2),         // 500MHz
  .adapter_scan_user_clk3                     (adapter_scan_user_clk3),         // 1GHz
  .adapter_clk_sel_n                          (adapter_clk_sel_n),
  .adapter_occ_enable                         (adapter_occ_enable),
  .adapter_global_pipe_se                     (adapter_global_pipe_se),
  .adapter_config_scan_in                     (adapter_config_scan_in),
  .adapter_scan_in_occ1                       (adapter_scan_in_occ1),
  .adapter_scan_in_occ2                       (adapter_scan_in_occ2),
  .adapter_scan_in_occ3                       (adapter_scan_in_occ3),
  .adapter_scan_in_occ4                       (adapter_scan_in_occ4),
  .adapter_scan_in_occ5                       (adapter_scan_in_occ5),
  .adapter_scan_in_occ6                       (adapter_scan_in_occ6),
  .adapter_scan_in_occ7                       (adapter_scan_in_occ7),
  .adapter_scan_in_occ8                       (adapter_scan_in_occ8),
  .adapter_scan_in_occ9                       (adapter_scan_in_occ9),
  .adapter_scan_in_occ10                      (adapter_scan_in_occ10),
  .adapter_scan_in_occ11                      (adapter_scan_in_occ11),
  .adapter_scan_in_occ12                      (adapter_scan_in_occ12),
  .adapter_scan_in_occ13                      (adapter_scan_in_occ13),
  .adapter_scan_in_occ14                      (adapter_scan_in_occ14),
  .adapter_scan_in_occ15                      (adapter_scan_in_occ15),
  .adapter_scan_in_occ16                      (adapter_scan_in_occ16),
  .adapter_scan_in_occ17                      (adapter_scan_in_occ17),
  .adapter_scan_in_occ18                      (adapter_scan_in_occ18),
  .adapter_scan_in_occ19                      (adapter_scan_in_occ19),
  .adapter_scan_in_occ20                      (adapter_scan_in_occ20),
  .adapter_scan_in_occ21                      (adapter_scan_in_occ21),
  .adapter_non_occ_scan_in                    (adapter_non_occ_scan_in),
  .adapter_occ_scan_in                        (adapter_occ_scan_in),
  .dft_fabric_iaibdftcore2dll                 (dft_fabric_iaibdftcore2dll),
  .oaibdftdll2core                            (oaibdftdll2core),
  
  
  // DFT
  .adapter_config_scan_out                    (adapter_config_scan_out),
  .adapter_scan_out_occ1                      (adapter_scan_out_occ1),
  .adapter_scan_out_occ2                      (adapter_scan_out_occ2),
  .adapter_scan_out_occ3                      (adapter_scan_out_occ3),
  .adapter_scan_out_occ4                      (adapter_scan_out_occ4),
  .adapter_scan_out_occ5                      (adapter_scan_out_occ5),
  .adapter_scan_out_occ6                      (adapter_scan_out_occ6),
  .adapter_scan_out_occ7                      (adapter_scan_out_occ7),
  .adapter_scan_out_occ8                      (adapter_scan_out_occ8),
  .adapter_scan_out_occ9                      (adapter_scan_out_occ9),
  .adapter_scan_out_occ10                     (adapter_scan_out_occ10),
  .adapter_scan_out_occ11                     (adapter_scan_out_occ11),
  .adapter_scan_out_occ12                     (adapter_scan_out_occ12),
  .adapter_scan_out_occ13                     (adapter_scan_out_occ13),
  .adapter_scan_out_occ14                     (adapter_scan_out_occ14),
  .adapter_scan_out_occ15                     (adapter_scan_out_occ15),
  .adapter_scan_out_occ16                     (adapter_scan_out_occ16),
  .adapter_scan_out_occ17                     (adapter_scan_out_occ17),
  .adapter_scan_out_occ18                     (adapter_scan_out_occ18),
  .adapter_scan_out_occ19                     (adapter_scan_out_occ19),
  .adapter_scan_out_occ20                     (adapter_scan_out_occ20),
  .adapter_scan_out_occ21                     (adapter_scan_out_occ21),
  .adapter_non_occ_scan_out                   (adapter_non_occ_scan_out),
  .adapter_occ_scan_out                       (adapter_occ_scan_out),
  .iaibdftcore2dll                            (iaibdftcore2dll),
  .dft_fabric_oaibdftdll2core                 (dft_fabric_oaibdftdll2core),
  
  // AIB
  .aib_fabric_csr_rdy_dly_in                  (aib_fabric_csr_rdy_dly_in),
  .aib_fabric_adapter_rx_pld_rst_n            (aib_fabric_adapter_rx_pld_rst_n),
  .aib_fabric_adapter_tx_pld_rst_n            (aib_fabric_adapter_tx_pld_rst_n),
  .aib_fabric_avmm1_data_out                  (aib_fabric_avmm1_data_out),
  .aib_fabric_avmm2_data_out                  (aib_fabric_avmm2_data_out),
  .aib_fabric_fpll_shared_direct_async_out    (aib_fabric_fpll_shared_direct_async_out),
  .aib_fabric_fsr_data_out                    (aib_fabric_fsr_data_out),
  .aib_fabric_fsr_load_out                    (aib_fabric_fsr_load_out),
  .aib_fabric_pcs_rx_pld_rst_n                (aib_fabric_pcs_rx_pld_rst_n),
  .aib_fabric_pcs_tx_pld_rst_n                (aib_fabric_pcs_tx_pld_rst_n),
  .aib_fabric_pld_pma_coreclkin               (aib_fabric_pld_pma_coreclkin),
  .aib_fabric_pld_pma_rxpma_rstb              (aib_fabric_pld_pma_rxpma_rstb),
  .aib_fabric_pld_pma_txdetectrx              (aib_fabric_pld_pma_txdetectrx),
  .aib_fabric_pld_pma_txpma_rstb              (aib_fabric_pld_pma_txpma_rstb),
  .aib_fabric_pld_sclk                        (aib_fabric_pld_sclk),
  .aib_fabric_rx_dll_lock_req                 (aib_fabric_rx_dll_lock_req),
  .aib_fabric_ssr_data_out                    (aib_fabric_ssr_data_out),
  .aib_fabric_ssr_load_out                    (aib_fabric_ssr_load_out),
  .aib_fabric_tx_data_out                     (aib_fabric_tx_data_out),
  .aib_fabric_tx_dcd_cal_req                  (aib_fabric_tx_dcd_cal_req),
  .aib_fabric_tx_sr_clk_out                   (aib_fabric_tx_sr_clk_out),
  .aib_fabric_tx_transfer_clk                 (aib_fabric_tx_transfer_clk),
  .r_aib_csr_ctrl_0                           (aib_csr_ctrl_0),
  .r_aib_csr_ctrl_1                           (aib_csr_ctrl_1),
  .r_aib_csr_ctrl_10                          (aib_csr_ctrl_10),
  .r_aib_csr_ctrl_11                          (aib_csr_ctrl_11),
  .r_aib_csr_ctrl_12                          (aib_csr_ctrl_12),
  .r_aib_csr_ctrl_13                          (aib_csr_ctrl_13),
  .r_aib_csr_ctrl_14                          (aib_csr_ctrl_14),
  .r_aib_csr_ctrl_15                          (aib_csr_ctrl_15),
  .r_aib_csr_ctrl_16                          (aib_csr_ctrl_16),
  .r_aib_csr_ctrl_17                          (aib_csr_ctrl_17),
  .r_aib_csr_ctrl_18                          (aib_csr_ctrl_18),
  .r_aib_csr_ctrl_19                          (aib_csr_ctrl_19),
  .r_aib_csr_ctrl_2                           (aib_csr_ctrl_2),
  .r_aib_csr_ctrl_20                          (aib_csr_ctrl_20),
  .r_aib_csr_ctrl_21                          (aib_csr_ctrl_21),
  .r_aib_csr_ctrl_22                          (aib_csr_ctrl_22),
  .r_aib_csr_ctrl_23                          (aib_csr_ctrl_23),
  .r_aib_csr_ctrl_24                          (aib_csr_ctrl_24),
  .r_aib_csr_ctrl_25                          (aib_csr_ctrl_25),
  .r_aib_csr_ctrl_26                          (aib_csr_ctrl_26),
  .r_aib_csr_ctrl_27                          (aib_csr_ctrl_27),
  .r_aib_csr_ctrl_28                          (aib_csr_ctrl_28),
  .r_aib_csr_ctrl_29                          (aib_csr_ctrl_29),
  .r_aib_csr_ctrl_3                           (aib_csr_ctrl_3),
  .r_aib_csr_ctrl_30                          (aib_csr_ctrl_30),
  .r_aib_csr_ctrl_31                          (aib_csr_ctrl_31),
  .r_aib_csr_ctrl_32                          (aib_csr_ctrl_32),
  .r_aib_csr_ctrl_33                          (aib_csr_ctrl_33),
  .r_aib_csr_ctrl_34                          (aib_csr_ctrl_34),
  .r_aib_csr_ctrl_35                          (aib_csr_ctrl_35),
  .r_aib_csr_ctrl_36                          (aib_csr_ctrl_36),
  .r_aib_csr_ctrl_37                          (aib_csr_ctrl_37),
  .r_aib_csr_ctrl_38                          (aib_csr_ctrl_38),
  .r_aib_csr_ctrl_39                          (aib_csr_ctrl_39),
  .r_aib_csr_ctrl_4                           (aib_csr_ctrl_4),
  .r_aib_csr_ctrl_40                          (aib_csr_ctrl_40),
  .r_aib_csr_ctrl_41                          (aib_csr_ctrl_41),
  .r_aib_csr_ctrl_42                          (aib_csr_ctrl_42),
  .r_aib_csr_ctrl_43                          (aib_csr_ctrl_43),
  .r_aib_csr_ctrl_44                          (aib_csr_ctrl_44),
  .r_aib_csr_ctrl_45                          (aib_csr_ctrl_45),
  .r_aib_csr_ctrl_46                          (aib_csr_ctrl_46),
  .r_aib_csr_ctrl_47                          (aib_csr_ctrl_47),
  .r_aib_csr_ctrl_48                          (aib_csr_ctrl_48),
  .r_aib_csr_ctrl_49                          (aib_csr_ctrl_49),
  .r_aib_csr_ctrl_5                           (aib_csr_ctrl_5),
  .r_aib_csr_ctrl_50                          (aib_csr_ctrl_50),
  .r_aib_csr_ctrl_51                          (aib_csr_ctrl_51),
  .r_aib_csr_ctrl_52                          (aib_csr_ctrl_52),
  .r_aib_csr_ctrl_53                          (aib_csr_ctrl_53),
  .r_aib_csr_ctrl_54                          (aib_csr_ctrl_54),
  .r_aib_csr_ctrl_55                          (aib_csr_ctrl_55),
  .r_aib_csr_ctrl_56                          (aib_csr_ctrl_56),
  .r_aib_csr_ctrl_57                          (aib_csr_ctrl_57),
  .r_aib_csr_ctrl_6                           (aib_csr_ctrl_6),
  .r_aib_csr_ctrl_7                           (aib_csr_ctrl_7),
  .r_aib_csr_ctrl_8                           (aib_csr_ctrl_8),
  .r_aib_csr_ctrl_9                           (aib_csr_ctrl_9),
  .r_aib_dprio_ctrl_0                         (aib_dprio_ctrl_0),
  .r_aib_dprio_ctrl_1                         (aib_dprio_ctrl_1),
  .r_aib_dprio_ctrl_2                         (aib_dprio_ctrl_2),
  .r_aib_dprio_ctrl_3                         (aib_dprio_ctrl_3),
  .r_aib_dprio_ctrl_4                         (aib_dprio_ctrl_4),
  
  // Adapter
  .bond_rx_asn_ds_out_fifo_hold               (bond_rx_asn_ds_out_fifo_hold),
  .bond_rx_asn_us_out_fifo_hold               (bond_rx_asn_us_out_fifo_hold),
  .bond_rx_fifo_ds_out_rden                   (bond_rx_fifo_ds_out_rden),
  .bond_rx_fifo_ds_out_wren                   (bond_rx_fifo_ds_out_wren),
  .bond_rx_fifo_us_out_rden                   (bond_rx_fifo_us_out_rden),
  .bond_rx_fifo_us_out_wren                   (bond_rx_fifo_us_out_wren),
  .bond_rx_hrdrst_ds_out_fabric_rx_dll_lock   (bond_rx_hrdrst_ds_out_fabric_rx_dll_lock),
  .bond_rx_hrdrst_us_out_fabric_rx_dll_lock   (bond_rx_hrdrst_us_out_fabric_rx_dll_lock),
  .bond_rx_hrdrst_ds_out_fabric_rx_dll_lock_req (bond_rx_hrdrst_ds_out_fabric_rx_dll_lock_req),
  .bond_rx_hrdrst_us_out_fabric_rx_dll_lock_req (bond_rx_hrdrst_us_out_fabric_rx_dll_lock_req),
  .bond_tx_fifo_ds_out_dv                       (bond_tx_fifo_ds_out_dv),
  .bond_tx_fifo_ds_out_rden                     (bond_tx_fifo_ds_out_rden),
  .bond_tx_fifo_ds_out_wren                     (bond_tx_fifo_ds_out_wren),
  .bond_tx_fifo_us_out_dv                       (bond_tx_fifo_us_out_dv),
  .bond_tx_fifo_us_out_rden                     (bond_tx_fifo_us_out_rden),
  .bond_tx_fifo_us_out_wren                     (bond_tx_fifo_us_out_wren),
  .bond_tx_hrdrst_ds_out_fabric_tx_dcd_cal_done (bond_tx_hrdrst_ds_out_fabric_tx_dcd_cal_done),
  .bond_tx_hrdrst_us_out_fabric_tx_dcd_cal_done (bond_tx_hrdrst_us_out_fabric_tx_dcd_cal_done),
  .bond_tx_hrdrst_ds_out_fabric_tx_dcd_cal_req  (bond_tx_hrdrst_ds_out_fabric_tx_dcd_cal_req),
  .bond_tx_hrdrst_us_out_fabric_tx_dcd_cal_req  (bond_tx_hrdrst_us_out_fabric_tx_dcd_cal_req),
  
  
  // Config
  .csr_clk_out                                  (csr_clk_out),
  .csr_out                                      (csr_out),
  .csr_pipe_out                                 (csr_pipe_out),
  .csr_rdy_dly_out                              (csr_rdy_dly_out),
  .csr_rdy_out                                  (csr_rdy_out),
  .nfrzdrv_out                                  (nfrzdrv_out),
  .usermode_out                                 (usermode_out),
  
  // PLD
  .hip_aib_fsr_out                              (hip_aib_fsr_out),
  .hip_aib_ssr_out                              (hip_aib_ssr_out),
  .hip_avmm_readdata                            (hip_avmm_readdata),
  .hip_avmm_readdatavalid                       (hip_avmm_readdatavalid),
  .hip_avmm_writedone                           (hip_avmm_writedone),
  .hip_avmm_reserved_out                        (hip_avmm_reserved_out),
  .pld_10g_krfec_rx_blk_lock                    (pld_10g_krfec_rx_blk_lock),
  .pld_10g_krfec_rx_diag_data_status            (pld_10g_krfec_rx_diag_data_status),
  .pld_10g_krfec_rx_frame                       (pld_10g_krfec_rx_frame),
  .pld_10g_krfec_tx_frame                       (pld_10g_krfec_tx_frame),
  .pld_krfec_tx_alignment                       (pld_krfec_tx_alignment),
  .pld_10g_rx_crc32_err                         (pld_10g_rx_crc32_err),
  .pld_rx_fabric_fifo_insert                    (pld_rx_fabric_fifo_insert),
  .pld_rx_fabric_fifo_del                       (pld_rx_fabric_fifo_del),
  
  .pld_10g_rx_frame_lock                        (pld_10g_rx_frame_lock),
  .pld_10g_rx_hi_ber                            (pld_10g_rx_hi_ber),
  .pld_10g_tx_burst_en_exe                      (pld_10g_tx_burst_en_exe),
  .pld_8g_a1a2_k1k2_flag                        (pld_8g_a1a2_k1k2_flag),
  .pld_8g_empty_rmf                             (pld_8g_empty_rmf),
  .pld_8g_full_rmf                              (pld_8g_full_rmf),
  .pld_8g_rxelecidle                            (pld_8g_rxelecidle),
  .pld_8g_signal_detect_out                     (pld_8g_signal_detect_out),
  .pld_8g_wa_boundary                           (pld_8g_wa_boundary),
  .pld_avmm1_busy                               (pld_avmm1_busy),
  .pld_avmm1_cmdfifo_wr_full                    (pld_avmm1_cmdfifo_wr_full),
  .pld_avmm1_cmdfifo_wr_pfull                   (pld_avmm1_cmdfifo_wr_pfull),
  .pld_avmm1_readdata                           (pld_avmm1_readdata),
  .pld_avmm1_readdatavalid                      (pld_avmm1_readdatavalid),
  .pld_avmm1_reserved_out                       (pld_avmm1_reserved_out),
  .pld_avmm2_busy                               (pld_avmm2_busy),
  .pld_avmm2_cmdfifo_wr_full                    (pld_avmm2_cmdfifo_wr_full),
  .pld_avmm2_cmdfifo_wr_pfull                   (pld_avmm2_cmdfifo_wr_pfull),
  .pld_avmm2_readdata                           (pld_avmm2_readdata),
  .pld_avmm2_readdatavalid                      (pld_avmm2_readdatavalid),
  .pld_avmm2_reserved_out                       (pld_avmm2_reserved_out),
  .pld_chnl_cal_done                            (pld_chnl_cal_done),
  .pld_fpll_shared_direct_async_out             (pld_fpll_shared_direct_async_out),
  .pld_fpll_shared_direct_async_out_hioint      (pld_fpll_shared_direct_async_out_hioint),
  .pld_fpll_shared_direct_async_out_dcm         (pld_fpll_shared_direct_async_out_dcm),
  .pld_fsr_load                                 (pld_fsr_load),
  .pld_pcs_rx_clk_out1_hioint                   (pld_pcs_rx_clk_out1_hioint),
  .pld_pcs_rx_clk_out2_hioint                   (pld_pcs_rx_clk_out2_hioint),
  .pld_pcs_tx_clk_out1_hioint                   (pld_pcs_tx_clk_out1_hioint),
  .pld_pcs_tx_clk_out2_hioint                   (pld_pcs_tx_clk_out2_hioint),
  .pld_pll_cal_done                             (pld_pll_cal_done),
  .pld_pma_adapt_done                           (pld_pma_adapt_done),
  .pld_pma_fpll_clk0bad                         (pld_pma_fpll_clk0bad),
  .pld_pma_fpll_clk1bad                         (pld_pma_fpll_clk1bad),
  .pld_pma_fpll_clksel                          (pld_pma_fpll_clksel),
  .pld_pma_fpll_phase_done                      (pld_pma_fpll_phase_done),
  .pld_pma_hclk_hioint                          (pld_pma_hclk_hioint),
  .pld_pma_internal_clk1_hioint                 (pld_pma_internal_clk1_hioint),
  .pld_pma_internal_clk2_hioint                 (pld_pma_internal_clk2_hioint),
  .pld_pma_pcie_sw_done                         (pld_pma_pcie_sw_done),
  .pld_pma_pfdmode_lock                         (pld_pma_pfdmode_lock),
  .pld_pma_reserved_in                          (pld_pma_reserved_in),
  .pld_pma_rx_detect_valid                      (pld_pma_rx_detect_valid),
  .pld_pma_rx_found                             (pld_pma_rx_found),
  .pld_pma_rxpll_lock                           (pld_pma_rxpll_lock),
  .pld_pma_signal_ok                            (pld_pma_signal_ok),
  .pld_pma_testbus                              (pld_pma_testbus),
  .pld_pmaif_mask_tx_pll                        (pld_pmaif_mask_tx_pll),
  .pld_rx_fabric_align_done                     (pld_rx_fabric_align_done),
  .pld_rx_fabric_data_out                       (pld_rx_fabric_data_out),
  .pld_rx_fabric_fifo_empty                     (pld_rx_fabric_fifo_empty),
  .pld_rx_fabric_fifo_full                      (pld_rx_fabric_fifo_full),
  .pld_rx_fabric_fifo_latency_pulse             (pld_rx_fabric_fifo_latency_pulse),
  .pld_rx_fabric_fifo_pempty                    (pld_rx_fabric_fifo_pempty),
  .pld_rx_fabric_fifo_pfull                     (pld_rx_fabric_fifo_pfull),
  .pld_rx_hssi_fifo_empty                       (pld_rx_hssi_fifo_empty),
  .pld_rx_hssi_fifo_full                        (pld_rx_hssi_fifo_full),
  .pld_rx_hssi_fifo_latency_pulse               (pld_rx_hssi_fifo_latency_pulse),
  .pld_rx_prbs_done                             (pld_rx_prbs_done),
  .pld_rx_prbs_err                              (pld_rx_prbs_err),
  .pld_ssr_load                                 (pld_ssr_load),
  .pld_test_data                                (pld_test_data),
  .pld_tx_fabric_fifo_empty                     (pld_tx_fabric_fifo_empty),
  .pld_tx_fabric_fifo_full                      (pld_tx_fabric_fifo_full),
  .pld_tx_fabric_fifo_latency_pulse             (pld_tx_fabric_fifo_latency_pulse),
  .pld_tx_fabric_fifo_pempty                    (pld_tx_fabric_fifo_pempty),
  .pld_tx_fabric_fifo_pfull                     (pld_tx_fabric_fifo_pfull),
  .pld_tx_hssi_align_done                       (pld_tx_hssi_align_done),
  .pld_tx_hssi_fifo_empty                       (pld_tx_hssi_fifo_empty),
  .pld_tx_hssi_fifo_full                        (pld_tx_hssi_fifo_full),
  .pld_tx_hssi_fifo_latency_pulse               (pld_tx_hssi_fifo_latency_pulse),
  .pld_hssi_osc_transfer_en                     (pld_hssi_osc_transfer_en),
  .pld_hssi_rx_transfer_en                      (pld_hssi_rx_transfer_en),
  .pld_fabric_tx_transfer_en                    (pld_fabric_tx_transfer_en),
  .pld_aib_fabric_rx_dll_lock                   (pld_aib_fabric_rx_dll_lock),
  .pld_aib_fabric_tx_dcd_cal_done               (pld_aib_fabric_tx_dcd_cal_done),
  .pld_aib_hssi_rx_dcd_cal_done                 (pld_aib_hssi_rx_dcd_cal_done),
  .pld_aib_hssi_tx_dcd_cal_done                 (pld_aib_hssi_tx_dcd_cal_done),
  .pld_aib_hssi_tx_dll_lock                     (pld_aib_hssi_tx_dll_lock),
  .pld_hssi_asn_dll_lock_en                     (pld_hssi_asn_dll_lock_en),
  .pld_fabric_asn_dll_lock_en                   (pld_fabric_asn_dll_lock_en),	
  .pld_tx_ssr_reserved_out                      (pld_tx_ssr_reserved_out),
  .pld_rx_ssr_reserved_out                      (pld_rx_ssr_reserved_out),
  
  // PLD DCM
  .pld_pcs_rx_clk_out1_dcm                      (pld_pcs_rx_clk_out1_dcm),
  .pld_pcs_rx_clk_out2_dcm                      (pld_pcs_rx_clk_out2_dcm),
  .pld_pcs_tx_clk_out1_dcm                      (pld_pcs_tx_clk_out1_dcm),
  .pld_pcs_tx_clk_out2_dcm                      (pld_pcs_tx_clk_out2_dcm)
);

/***
aibnd_top_wrp aibnd_top_wrp ( 
                                    .aib0               (),       // Templated
                                    .aib1               (),       // Templated
                                    .aib2               (),       // Templated
                                    .aib3               (),       // Templated
                                    .aib4               (),       // Templated
                                    .aib5               (),       // Templated
                                    .aib6               (),       // Templated
                                    .aib7               (),       // Templated
                                    .aib8               (),       // Templated
                                    .aib9               (),       // Templated
                                    .aib10              (),      // Templated
                                    .aib11              (),      // Templated
                                    .aib12              (),      // Templated
                                    .aib13              (),      // Templated
                                    .aib14              (),      // Templated
                                    .aib15              (),      // Templated
                                    .aib16              (),      // Templated
                                    .aib17              (),      // Templated
                                    .aib18              (),      // Templated
                                    .aib19              (),      // Templated
                                    .aib20              (),      // Templated
                                    .aib21              (),      // Templated
                                    .aib22              (),      // Templated
                                    .aib23              (),      // Templated
                                    .aib24              (),      // Templated
                                    .aib25              (),      // Templated
                                    .aib26              (),      // Templated
                                    .aib27              (),      // Templated
                                    .aib28              (),      // Templated
                                    .aib29              (),      // Templated
                                    .aib30              (),      // Templated
                                    .aib31              (),      // Templated
                                    .aib32              (),      // Templated
                                    .aib33              (),      // Templated
                                    .aib34              (),      // Templated
                                    .aib35              (),      // Templated
                                    .aib36              (),      // Templated
                                    .aib37              (),      // Templated
                                    .aib38              (),      // Templated
                                    .aib39              (),      // Templated
                                    .aib40              (),      // Templated
                                    .aib41              (),      // Templated
                                    .aib42              (),      // Templated
                                    .aib43              (),      // Templated
                                    //.aib0               (io_aib0),       // Templated
                                    //.aib1               (io_aib1),       // Templated
                                    //.aib2               (io_aib2),       // Templated
                                    //.aib3               (io_aib3),       // Templated
                                    //.aib4               (io_aib4),       // Templated
                                    //.aib5               (io_aib5),       // Templated
                                    //.aib6               (io_aib6),       // Templated
                                    //.aib7               (io_aib7),       // Templated
                                    //.aib8               (io_aib8),       // Templated
                                    //.aib9               (io_aib9),       // Templated
                                    //.aib10              (io_aib10),      // Templated
                                    //.aib11              (io_aib11),      // Templated
                                    //.aib12              (io_aib12),      // Templated
                                    //.aib13              (io_aib13),      // Templated
                                    //.aib14              (io_aib14),      // Templated
                                    //.aib15              (io_aib15),      // Templated
                                    //.aib16              (io_aib16),      // Templated
                                    //.aib17              (io_aib17),      // Templated
                                    //.aib18              (io_aib18),      // Templated
                                    //.aib19              (io_aib19),      // Templated
                                    //.aib20              (io_aib20),      // Templated
                                    //.aib21              (io_aib21),      // Templated
                                    //.aib22              (io_aib22),      // Templated
                                    //.aib23              (io_aib23),      // Templated
                                    //.aib24              (io_aib24),      // Templated
                                    //.aib25              (io_aib25),      // Templated
                                    //.aib26              (io_aib26),      // Templated
                                    //.aib27              (io_aib27),      // Templated
                                    //.aib28              (io_aib28),      // Templated
                                    //.aib29              (io_aib29),      // Templated
                                    //.aib30              (io_aib30),      // Templated
                                    //.aib31              (io_aib31),      // Templated
                                    //.aib32              (io_aib32),      // Templated
                                    //.aib33              (io_aib33),      // Templated
                                    //.aib34              (io_aib34),      // Templated
                                    //.aib35              (io_aib35),      // Templated
                                    //.aib36              (io_aib36),      // Templated
                                    //.aib37              (io_aib37),      // Templated
                                    //.aib38              (io_aib38),      // Templated
                                    //.aib39              (io_aib39),      // Templated
                                    //.aib40              (io_aib40),      // Templated
                                    //.aib41              (io_aib41),      // Templated
                                    //.aib42              (io_aib42),      // Templated
                                    //.aib43              (io_aib43),      // Templated
    .aib44                                     (io_aib44),
    .aib45                                     (io_aib45),
    .aib46                                     (io_aib46),
    .aib47                                     (io_aib47),
    .aib48                                     (io_aib48),
    .aib49                                     (io_aib49),
    .aib5                                      (io_aib5),
    .aib50                                     (io_aib50),
    .aib51                                     (io_aib51),
    .aib52                                     (io_aib52),
    .aib53                                     (io_aib53),
    .aib54                                     (io_aib54),
    .aib55                                     (io_aib55),
    .aib56                                     (io_aib56),
    .aib57                                     (io_aib57),
    .aib58                                     (io_aib58),
    .aib59                                     (io_aib59),
    .aib6                                      (io_aib6),
    .aib60                                     (io_aib60),
    .aib61                                     (io_aib61),
    .aib62                                     (io_aib62),
    .aib63                                     (io_aib63),
    .aib64                                     (io_aib64),
    .aib65                                     (io_aib65),
    .aib66                                     (io_aib66),
    .aib67                                     (io_aib67),
    .aib68                                     (io_aib68),
    .aib69                                     (io_aib69),
    .aib7                                      (io_aib7),
    .aib70                                     (io_aib70),
    .aib71                                     (io_aib71),
    .aib72                                     (io_aib72),
    .aib73                                     (io_aib73),
    .aib74                                     (io_aib74),
    .aib75                                     (io_aib75),
    .aib76                                     (io_aib76),
    .aib77                                     (io_aib77),
    .aib78                                     (io_aib78),
    .aib79                                     (io_aib79),
    .aib8                                      (io_aib8),
    .aib80                                     (io_aib80),
    .aib81                                     (io_aib81),
                                    .aib82              (),      // Templated
                                    .aib83              (),      // Templated
                                    .aib84              (),      // Templated
                                    .aib85              (),      // Templated
    //.aib82                                     (io_aib82),
    //.aib83                                     (io_aib83),
    //.aib84                                     (io_aib84),
    //.aib85                                     (io_aib85),
    .aib86                                     (io_aib86),
    .aib87                                     (io_aib87),
    .aib88                                     (io_aib88),
    .aib89                                     (io_aib89),
    .aib9                                      (io_aib9),
    .aib90                                     (io_aib90),
    .aib91                                     (io_aib91),
    //.aib92                                     (io_aib92),
    //.aib93                                     (io_aib93),
    //.aib94                                     (io_aib94),
    //.aib95                                     (io_aib95),
                                    .aib92              (),      // Templated
                                    .aib93              (),      // Templated
                                    .aib94              (),      // Templated
                                    .aib95              (),      // Templated
    .aib_fabric_adapter_rx_pld_rst_n           (aib_fabric_adapter_rx_pld_rst_n),
    .aib_fabric_adapter_tx_pld_rst_n           (aib_fabric_adapter_tx_pld_rst_n),
    .aib_fabric_avmm1_data_in                  (aib_fabric_avmm1_data_in),
    .aib_fabric_avmm1_data_out                 (aib_fabric_avmm1_data_out),
    .aib_fabric_avmm2_data_in                  (aib_fabric_avmm2_data_in),
    .aib_fabric_avmm2_data_out                 (aib_fabric_avmm2_data_out),
    .aib_fabric_fsr_data_in                    (aib_fabric_fsr_data_in),
    .aib_fabric_fsr_data_out                   (aib_fabric_fsr_data_out),
    .aib_fabric_fsr_load_in                    (aib_fabric_fsr_load_in),
    .aib_fabric_fsr_load_out                   (aib_fabric_fsr_load_out),
    .aib_fabric_pcs_rx_pld_rst_n               (aib_fabric_pcs_rx_pld_rst_n),
    .aib_fabric_pcs_tx_pld_rst_n               (aib_fabric_pcs_tx_pld_rst_n),
    .aib_fabric_pld_8g_rxelecidle              (aib_fabric_pld_8g_rxelecidle),
    .aib_fabric_pld_pcs_rx_clk_out             (aib_fabric_pld_pcs_rx_clk_out),
    .aib_fabric_pld_pcs_tx_clk_out             (aib_fabric_pld_pcs_tx_clk_out),
    .aib_fabric_pld_pma_clkdiv_rx_user         (aib_fabric_pld_pma_clkdiv_rx_user),
    .aib_fabric_pld_pma_clkdiv_tx_user         (aib_fabric_pld_pma_clkdiv_tx_user),
    .aib_fabric_pld_pma_coreclkin              (aib_fabric_pld_pma_coreclkin),
    .aib_fabric_pld_pma_hclk                   (aib_fabric_pld_pma_hclk),
    .aib_fabric_pld_pma_internal_clk1          (aib_fabric_pld_pma_internal_clk1),
    .aib_fabric_pld_pma_internal_clk2          (aib_fabric_pld_pma_internal_clk2),
    .aib_fabric_pld_pma_pfdmode_lock           (aib_fabric_pld_pma_pfdmode_lock),
    .aib_fabric_pld_pma_rxpll_lock             (aib_fabric_pld_pma_rxpll_lock),
    .aib_fabric_pld_pma_rxpma_rstb             (aib_fabric_pld_pma_rxpma_rstb),
    .aib_fabric_pld_pma_txdetectrx             (aib_fabric_pld_pma_txdetectrx),
    .aib_fabric_pld_pma_txpma_rstb             (aib_fabric_pld_pma_txpma_rstb),
    .aib_fabric_pld_rx_hssi_fifo_latency_pulse (aib_fabric_pld_rx_hssi_fifo_latency_pulse),
    .aib_fabric_pld_sclk                       (aib_fabric_pld_sclk),
    .aib_fabric_pld_tx_hssi_fifo_latency_pulse (aib_fabric_pld_tx_hssi_fifo_latency_pulse),
    .aib_fabric_pma_aib_tx_clk                 (aib_fabric_pma_aib_tx_clk),
    .aib_fabric_rx_data_in                     (aib_fabric_rx_data_in),
    .aib_fabric_rx_transfer_clk                (aib_fabric_rx_transfer_clk),
    .aib_fabric_tx_sr_clk_out                  (aib_fabric_tx_sr_clk_out),
    .aib_fabric_rx_sr_clk_in                   (aib_fabric_rx_sr_clk_in),
    .aib_fabric_tx_sr_clk_in                   (aib_fabric_tx_sr_clk_in),
    .aib_fabric_ssr_data_in                    (aib_fabric_ssr_data_in),
    .aib_fabric_ssr_load_out                   (aib_fabric_ssr_load_out),
    .aib_fabric_tx_data_out                    (aib_fabric_tx_data_out),
    .aib_fabric_tx_transfer_clk                (aib_fabric_tx_transfer_clk),
    .aib_fabric_fpll_shared_direct_async_in    (aib_fabric_fpll_shared_direct_async_in),
    .aib_fabric_fpll_shared_direct_async_out   (aib_fabric_fpll_shared_direct_async_out),
    .aib_fabric_tx_dcd_cal_req                 (aib_fabric_tx_dcd_cal_req),
    .aib_fabric_rx_dll_lock_req                (aib_fabric_rx_dll_lock_req),
    .aib_fabric_rx_dll_lock                    (aib_fabric_rx_dll_lock),
    .aib_fabric_tx_dcd_cal_done                (aib_fabric_tx_dcd_cal_done),
    .aib_fabric_csr_rdy_dly_in                 (aib_fabric_csr_rdy_dly_in),
    .r_aib_csr_ctrl_0                          (aib_csr_ctrl_0),
    .r_aib_csr_ctrl_1                          (aib_csr_ctrl_1),
    .r_aib_csr_ctrl_2                          (aib_csr_ctrl_2),
    .r_aib_csr_ctrl_3                          (aib_csr_ctrl_3),
    .r_aib_csr_ctrl_4                          (aib_csr_ctrl_4),
    .r_aib_csr_ctrl_5                          (aib_csr_ctrl_5),
    .r_aib_csr_ctrl_6                          (aib_csr_ctrl_6),
    .r_aib_csr_ctrl_7                          (aib_csr_ctrl_7),
    .r_aib_csr_ctrl_8                          (aib_csr_ctrl_8),
    .r_aib_csr_ctrl_9                          (aib_csr_ctrl_9),
    .r_aib_csr_ctrl_10                         (aib_csr_ctrl_10),
    .r_aib_csr_ctrl_11                         (aib_csr_ctrl_11),
    .r_aib_csr_ctrl_12                         (aib_csr_ctrl_12),
    .r_aib_csr_ctrl_13                         (aib_csr_ctrl_13),
    .r_aib_csr_ctrl_14                         (aib_csr_ctrl_14),
    .r_aib_csr_ctrl_15                         (aib_csr_ctrl_15),
    .r_aib_csr_ctrl_16                         (aib_csr_ctrl_16),
    .r_aib_csr_ctrl_17                         (aib_csr_ctrl_17),
    .r_aib_csr_ctrl_18                         (aib_csr_ctrl_18),
    .r_aib_csr_ctrl_19                         (aib_csr_ctrl_19),
    .r_aib_csr_ctrl_20                         (aib_csr_ctrl_20),
    .r_aib_csr_ctrl_21                         (aib_csr_ctrl_21),
    .r_aib_csr_ctrl_22                         (aib_csr_ctrl_22),
    .r_aib_csr_ctrl_23                         (aib_csr_ctrl_23),
    .r_aib_csr_ctrl_24                         (aib_csr_ctrl_24),
    .r_aib_csr_ctrl_25                         (aib_csr_ctrl_25),
    .r_aib_csr_ctrl_26                         (aib_csr_ctrl_26),
    .r_aib_csr_ctrl_27                         (aib_csr_ctrl_27),
    .r_aib_csr_ctrl_28                         (aib_csr_ctrl_28),
    .r_aib_csr_ctrl_29                         (aib_csr_ctrl_29),
    .r_aib_csr_ctrl_30                         (aib_csr_ctrl_30),
    .r_aib_csr_ctrl_31                         (aib_csr_ctrl_31),
    .r_aib_csr_ctrl_32                         (aib_csr_ctrl_32),
    .r_aib_csr_ctrl_33                         (aib_csr_ctrl_33),
    .r_aib_csr_ctrl_34                         (aib_csr_ctrl_34),
    .r_aib_csr_ctrl_35                         (aib_csr_ctrl_35),
    .r_aib_csr_ctrl_36                         (aib_csr_ctrl_36),
    .r_aib_csr_ctrl_37                         (aib_csr_ctrl_37),
    .r_aib_csr_ctrl_38                         (aib_csr_ctrl_38),
    .r_aib_csr_ctrl_39                         (aib_csr_ctrl_39),
    .r_aib_csr_ctrl_40                         (aib_csr_ctrl_40),
    .r_aib_csr_ctrl_41                         (aib_csr_ctrl_41),
    .r_aib_csr_ctrl_42                         (aib_csr_ctrl_42),
    .r_aib_csr_ctrl_43                         (aib_csr_ctrl_43),
    .r_aib_csr_ctrl_44                         (aib_csr_ctrl_44),
    .r_aib_csr_ctrl_45                         (aib_csr_ctrl_45),
    .r_aib_csr_ctrl_46                         (aib_csr_ctrl_46),
    .r_aib_csr_ctrl_47                         (aib_csr_ctrl_47),
    .r_aib_csr_ctrl_48                         (aib_csr_ctrl_48),
    .r_aib_csr_ctrl_49                         (aib_csr_ctrl_49),
    .r_aib_csr_ctrl_50                         (aib_csr_ctrl_50),
    .r_aib_csr_ctrl_51                         (aib_csr_ctrl_51),
    .r_aib_csr_ctrl_52                         (aib_csr_ctrl_52),
    .r_aib_csr_ctrl_53                         (aib_csr_ctrl_53),
    .r_aib_csr_ctrl_54                         (aib_csr_ctrl_54),
    .r_aib_csr_ctrl_55                         (aib_csr_ctrl_55),
    .r_aib_csr_ctrl_56                         (aib_csr_ctrl_56),
    .r_aib_csr_ctrl_57                         (aib_csr_ctrl_57),
    .r_aib_dprio_ctrl_0                        (aib_dprio_ctrl_0),
    .r_aib_dprio_ctrl_1                        (aib_dprio_ctrl_1),
    .r_aib_dprio_ctrl_2                        (aib_dprio_ctrl_2),
    .r_aib_dprio_ctrl_3                        (aib_dprio_ctrl_3),
    .r_aib_dprio_ctrl_4                        (aib_dprio_ctrl_4),
    .ired_directin_data_in_chain1              (ired_directin_data_in_chain1),
    .ired_directin_data_in_chain2              (ired_directin_data_in_chain2),
    .ired_irxen_in_chain1                      (ired_irxen_in_chain1),
    .ired_irxen_in_chain2                      (ired_irxen_in_chain2),
    .ored_directin_data_out0_chain1            (ored_directin_data_out0_chain1),
    .ored_directin_data_out0_chain2            (ored_directin_data_out0_chain2),
    .ored_rxen_out_chain1                      (ored_rxen_out_chain1),
    .ored_rxen_out_chain2                      (ored_rxen_out_chain2),
    .aib_fabric_ssr_data_out                   (aib_fabric_ssr_data_out),
    .aib_fabric_ssr_load_in                    (aib_fabric_ssr_load_in),
    .oaibdftdll2core                           (oaibdftdll2core),
    .ojtag_clkdr_out_chain                     (ojtag_clkdr_out_chain),
    .ojtag_last_bs_out_chain                   (ojtag_last_bs_out_chain),
    .ojtag_rx_scan_out_chain                   (ojtag_rx_scan_out_chain),
    .ijtag_clkdr_in_chain                      (ijtag_clkdr_in_chain),
    .ijtag_last_bs_in_chain                    (ijtag_last_bs_in_chain),
    .ijtag_tx_scan_in_chain                    (ijtag_tx_scan_in_chain),
    .iaibdftcore2dll                           (iaibdftcore2dll),
    .jtag_mode_in                              (jtag_mode_in),
    .jtag_rstb_en                              (jtag_rstb_en),
    .jtag_rstb                                 (jtag_rstb),
    .jtag_tx_scanen_in                         (jtag_tx_scanen_in),
    .jtag_weakpdn                              (jtag_weakpdn),
    .jtag_weakpu                               (jtag_weakpu),
    .jtag_intest                               (jtag_intest),
    .jtag_clksel                               (jtag_clksel),
    .jtag_mode_out                             (jtag_mode_out),
    .jtag_rstb_en_out                          (jtag_rstb_en_out),
    .jtag_rstb_out                             (jtag_rstb_out),
    .jtag_tx_scanen_out                        (jtag_tx_scanen_out),
    .jtag_weakpdn_out                          (jtag_weakpdn_out),
    .jtag_weakpu_out                           (jtag_weakpu_out),
    .jtag_intest_out                           (jtag_intest_out),
    .jtag_clksel_out                           (jtag_clksel_out),
    .iatpg_scan_rst_n                          (iatpg_scan_rst_n),          //TODO: hook up scan and JTAG
    .iatpg_pipeline_global_en                  (iatpg_pipeline_global_en),
    .iatpg_scan_mode_n                         (iatpg_scan_mode_n),
    .iatpg_scan_shift_n                        (iatpg_scan_shift_n),
    .iatpg_scan_clk_in0                        (iatpg_scan_clk_in0),
    .iatpg_scan_clk_in1                        (iatpg_scan_clk_in1),
    .iatpg_scan_in0                            (iatpg_scan_in0),
    .iatpg_scan_in1                            (iatpg_scan_in1),
    .oatpg_scan_out0                           (oatpg_scan_out0),
    .oatpg_scan_out1                           (oatpg_scan_out1),
    .ired_shift_en_in_chain2                   (ired_shift_en_in_chain2),
    .ired_shift_en_in_chain1                   (ired_shift_en_in_chain1),
    .ored_shift_en_out_chain1                  (ored_shift_en_out_chain1),
    .ored_shift_en_out_chain2                  (ored_shift_en_out_chain2) 
);
***/
wire [19:0] sl_dataout0,sl_dataout1;

    parameter DATAWIDTH      = 20;
aib #(.DATAWIDTH(DATAWIDTH))  slave
 ( 
    .iopad_tx({io_aib39, io_aib38,
     io_aib37, io_aib36, io_aib35, io_aib34, io_aib33, io_aib32, io_aib31, io_aib30, io_aib29,
     io_aib28, io_aib27, io_aib26, io_aib25, io_aib24, io_aib23, io_aib22, io_aib21, io_aib20}),
    .iopad_rx({io_aib19, io_aib18, io_aib17,
     io_aib16, io_aib15, io_aib14, io_aib13, io_aib12, io_aib11, io_aib10, io_aib9, io_aib8, io_aib7,
     io_aib6, io_aib5, io_aib4, io_aib3, io_aib2, io_aib1, io_aib0}),
    .iopad_ns_rcv_clkb(io_aib59), 
    .iopad_ns_rcv_clk(io_aib57),
    //.iopad_ns_fwd_clk(aib43), 
    //.iopad_ns_fwd_clkb(aib42),
    .iopad_ns_fwd_clk(io_aib43), 
    .iopad_ns_fwd_clkb(io_aib42),
    .iopad_ns_sr_clk(io_aib83), 
    .iopad_ns_sr_clkb(io_aib82),
    .iopad_ns_sr_load(io_aib92), 
    .iopad_ns_sr_data(io_aib93),
    //.iopad_ns_mac_rdy(sl_rstno), 
    //.iopad_ns_adapter_rstn(sl_arstno),
    .iopad_ns_mac_rdy(io_aib44), 
    .iopad_ns_adapter_rstn(io_aib65),
    .iopad_spare1(), 
    .iopad_spare0(),
    .iopad_fs_rcv_clkb(io_aib86), 
    .iopad_fs_rcv_clk(io_aib87),
    .iopad_fs_fwd_clkb(io_aib40), 
    .iopad_fs_fwd_clk(io_aib41),
    .iopad_fs_sr_clkb(io_aib84), 
    .iopad_fs_sr_clk(io_aib85),
    .iopad_fs_sr_load(io_aib94), 
    .iopad_fs_sr_data(io_aib95),
    //.iopad_fs_mac_rdy(pld_adapter_rx_pld_rst_n), 
    //.iopad_fs_adapter_rstn(pld_adapter_tx_pld_rst_n),
    .iopad_fs_mac_rdy(io_aib49), 
    .iopad_fs_adapter_rstn(io_aib56),

    .iopad_device_detect(device_detect),
    .iopad_device_detect_copy(device_detectrdcy),
    .iopad_por(),
    .iopad_por_copy(),

    .data_in({sl_dataout1[19:0],sl_dataout0[19:0]}), //output data to pad
    .data_out({sl_dataout1[19:0],sl_dataout0[19:0]}), //input data from pad
    .m_ns_fwd_clk(pld_tx_clk1_rowclk), //output data clock
    .m_fs_rvc_clk(),
    .m_fs_fwd_clk(),
    .m_ns_rvc_clk(pld_tx_clk1_rowclk),

    .ms_ns_adapter_rstn(pld_adapter_tx_pld_rst_n),
    .sl_ns_adapter_rstn(pld_adapter_tx_pld_rst_n),
    .ms_ns_mac_rdy(pld_adapter_rx_pld_rst_n),
    .sl_ns_mac_rdy(pld_adapter_rx_pld_rst_n),
    .fs_mac_rdy(),

    .ms_config_done(1'b1),
    .ms_rx_dcc_dll_lock_req(1'b0),
    .ms_tx_dcc_dll_lock_req(1'b0),
    .sl_config_done(pld_adapter_rx_pld_rst_n),
    .sl_rx_dcc_dll_lock_req(pld_rx_dll_lock_req),
    .sl_tx_dcc_dll_lock_req(pld_tx_dll_lock_req),
    .ms_tx_transfer_en(),
    .ms_rx_transfer_en(),
    .sl_tx_transfer_en(),
    .sl_rx_transfer_en(),
    .sr_ms_tomac(),
    .sr_sl_tomac(),
    .ms_nsl(1'b0),

    .iddren(1'b1),
    .idataselb(1'b0), //output async data selection
    .itxen(1'b1), //data tx enable
    .irxen(3'b111),//data input enable

    .ms_device_detect(),
    .sl_por(pld_adapter_rx_pld_rst_n),

    .jtag_clkdr_in(1'b0),
    .scan_out(),
    .jtag_intest(1'b0),
    .jtag_mode_in(1'b0),
    .jtag_rstb(1'b0),
    .jtag_rstb_en(1'b0),
    .jtag_weakpdn(1'b0),
    .jtag_weakpu(1'b0),
    .jtag_tx_scanen_in(1'b0),
    .scan_in(1'b0),

//Redundancy control signals
`include "redundancy_ctrl_sim.vh"

    .vccl_aib(1'b1),
    .vssl_aib(1'b0) );

endmodule
