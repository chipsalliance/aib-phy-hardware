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
// Description: Channel Configuration arbitration and decoding
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
module c3aibadapt_avmm1_config (

// User AVMM1
input  wire           usr_avmm_clk,
input  wire           usr_avmm_rst_n,

// CRSSM AVMM
input  wire           cfg_avmm_clk,
input  wire           cfg_avmm_rst_n,
input  wire           cfg_avmm_raw_rst_n,
input  wire           cfg_avmm_write,
input  wire           cfg_avmm_read,
input  wire  [16:0]   cfg_avmm_addr,
input  wire  [31:0]   cfg_avmm_wdata,
input  wire  [3:0]    cfg_avmm_byte_en,
output wire  [31:0]   chnl_avmm_rdata,
output wire           chnl_avmm_rdatavld,
output wire           chnl_avmm_waitreq,
output wire  [31:0]   cfg_only_rdata,
output wire           cfg_only_rdatavld,
output wire           cfg_only_waitreq,
input  wire   [5:0]   cfg_avmm_addr_id,

// input  wire           avmm_clock_dprio_clk,
// input  wire           avmm_reset_avmm_rst_n,

// Status Register
input  wire [7:0]     rx_chnl_dprio_status,
input  wire           rx_chnl_dprio_status_write_en_ack,
input  wire [7:0]     tx_chnl_dprio_status,
input  wire           tx_chnl_dprio_status_write_en_ack,
input  wire [7:0]     sr_dprio_status,
input  wire           sr_dprio_status_write_en_ack,

// DFT
input  wire           scan_mode_n,
input  wire           scan_rst_n,

// AVMM Transfer
input  wire           remote_pld_avmm_read,
input  wire [9:0]     remote_pld_avmm_reg_addr,
input  wire [8:0]     remote_pld_avmm_rsvd,      // reserved bits from Usr AVMM1 to be used as address bits for ELANE
input  wire           remote_pld_avmm_request,
input  wire           remote_pld_avmm_write,
input  wire [7:0]     remote_pld_avmm_writedata,

output wire           remote_pld_avmm_writedone,
output wire           remote_pld_avmm_busy,
output wire [7:0]     remote_pld_avmm_readdata,
output wire           remote_pld_avmm_readdatavalid,

output wire           o_xcvrif_avmm_clk,
output wire           o_xcvrif_avmm_rst_n,
output wire           o_xcvrif_avmm_cfg_active,
output wire           o_xcvrif_avmm_write,
output wire           o_xcvrif_avmm_read,
output wire [8:0]     o_xcvrif_avmm_addr,
output wire [31:0]    o_xcvrif_avmm_wdata,
output wire [3:0]     o_xcvrif_avmm_byte_en,
input  wire [31:0]    i_xcvrif_avmm_rdata,
input  wire           i_xcvrif_avmm_rdatavld,
input  wire           i_xcvrif_avmm_waitreq,
output wire           o_elane_avmm_clk,
output wire           o_elane_avmm_rst_n,
output wire           o_elane_avmm_cfg_active,
output wire           o_elane_avmm_write,
output wire           o_elane_avmm_read,
output wire [16:0]    o_elane_avmm_addr,
output wire [31:0]    o_elane_avmm_wdata,
output wire [3:0]     o_elane_avmm_byte_en,
input  wire [31:0]    i_elane_avmm_rdata,
input  wire           i_elane_avmm_rdatavld,
input  wire           i_elane_avmm_waitreq,

// Status Register
output wire           rx_chnl_dprio_status_write_en,
output wire           tx_chnl_dprio_status_write_en,
output wire           sr_dprio_status_write_en,

// Test Bus
output wire [4:0]     avmm1_cmn_intf_testbus,
output wire [15:0]    dec_arb_tb_direct,

// DPRIO & IOCSR only
output wire           r_ifctl_usr_active,
output wire [2:0]     r_tx_chnl_datapath_map_mode,
output wire           r_tx_chnl_datapath_map_rxqpi_pullup_init_val,
output wire           r_tx_chnl_datapath_map_txqpi_pullup_init_val,
output wire           r_tx_chnl_datapath_map_txqpi_pulldn_init_val,
output wire           r_tx_qpi_sr_enable,
output wire           r_tx_usertest_sel,
output wire           r_tx_latency_src_xcvrif,
output wire [4:0]     r_tx_fifo_empty,
output wire [1:0]     r_tx_fifo_mode,
output wire           r_tx_indv,
output wire [4:0]     r_tx_fifo_full,
output wire [2:0]     r_tx_phcomp_rd_delay,
output wire           r_tx_double_read,
output wire           r_tx_stop_read,
output wire           r_tx_stop_write,
output wire [4:0]     r_tx_fifo_pempty,
output wire [4:0]     r_tx_fifo_pfull,
output wire [7:0]     r_tx_comp_cnt,
output wire           r_tx_us_master,
output wire           r_tx_ds_master,
output wire           r_tx_us_bypass_pipeln,
output wire           r_tx_ds_bypass_pipeln,
output wire [1:0]     r_tx_compin_sel,
output wire           r_tx_bonding_dft_in_en,
output wire           r_tx_bonding_dft_in_value,
output wire           r_tx_wa_en,
output wire [1:0]     r_tx_fifo_power_mode,
output wire [4:0]     r_tx_wren_fastbond,
output wire [2:0]     r_tx_stretch_num_stages,
output wire [2:0]     r_tx_datapath_tb_sel,
output wire           r_tx_wr_adj_en,
output wire           r_tx_rd_adj_en,
output wire           r_tx_async_pld_txelecidle_rst_val,
output wire           r_tx_async_hip_aib_fsr_in_bit0_rst_val,
output wire           r_tx_async_hip_aib_fsr_in_bit1_rst_val,
output wire           r_tx_async_hip_aib_fsr_in_bit2_rst_val,
output wire           r_tx_async_hip_aib_fsr_in_bit3_rst_val,
output wire           r_tx_async_pld_pmaif_mask_tx_pll_rst_val,
output wire           r_tx_async_hip_aib_fsr_out_bit0_rst_val,
output wire           r_tx_async_hip_aib_fsr_out_bit1_rst_val,
output wire           r_tx_async_hip_aib_fsr_out_bit2_rst_val,
output wire           r_tx_async_hip_aib_fsr_out_bit3_rst_val,
output wire [1:0]     r_tx_fifo_rd_clk_sel,
output wire           r_tx_dyn_clk_sw_en,
output wire [1:0]     r_tx_aib_clk_sel,
output wire           r_tx_fifo_wr_clk_scg_en,
output wire           r_tx_fifo_rd_clk_scg_en,
output wire           r_tx_osc_clk_scg_en,
output wire           r_tx_free_run_div_clk,
output wire           r_tx_hrdrst_rst_sm_dis,
output wire           r_tx_hrdrst_dcd_cal_done_bypass,
output wire           r_tx_hrdrst_dll_lock_bypass,
output wire           r_tx_hrdrst_align_bypass,
output wire           r_tx_hrdrst_user_ctl_en,
output wire           r_tx_presethint_bypass,
output wire           r_tx_hrdrst_rx_osc_clk_scg_en,
output wire           r_tx_hip_osc_clk_scg_en,
output wire [2:0]     r_rx_chnl_datapath_map_mode,
output wire [2:0]     r_rx_pcs_testbus_sel,
output wire [4:0]     r_rx_fifo_empty,
output wire [1:0]     r_rx_fifo_mode,
output wire           r_rx_wm_en,
output wire [4:0]     r_rx_fifo_full,
output wire [2:0]     r_rx_phcomp_rd_delay,
output wire           r_rx_double_write,
output wire           r_rx_stop_read,
output wire           r_rx_stop_write,
output wire [4:0]     r_rx_fifo_pempty,
output wire [3:0]     r_rx_mask_del,
output wire           r_rx_force_align,
output wire           r_rx_align_del,
output wire           r_rx_indv,
output wire [7:0]     r_rx_comp_cnt,
output wire           r_rx_us_master,
output wire           r_rx_ds_master,
output wire           r_rx_us_bypass_pipeln,
output wire           r_rx_ds_bypass_pipeln,
output wire [1:0]     r_rx_compin_sel,
output wire           r_rx_bonding_dft_in_en,
output wire           r_rx_bonding_dft_in_value,
output wire [1:0]     r_rx_fifo_power_mode,
output wire [4:0]     r_rx_fifo_pfull,
output wire [2:0]     r_rx_stretch_num_stages,
output wire [3:0]     r_rx_datapath_tb_sel,
output wire           r_rx_wr_adj_en,
output wire           r_rx_rd_adj_en,
output wire           r_rx_msb_rdptr_pipe_byp,
output wire           r_tx_dv_gating_en,
output wire [1:0]     r_rx_adapter_lpbk_mode,
output wire           r_rx_aib_lpbk_en,
output wire           r_tx_rev_lpbk,
output wire           r_rx_asn_en,
output wire           r_rx_slv_asn_en,
output wire           r_rx_asn_bypass_clock_gate,
output wire           r_rx_asn_bypass_pma_pcie_sw_done,
output wire           r_rx_hrdrst_user_ctl_en,
output wire [6:0]     r_rx_asn_wait_for_fifo_flush_cnt,
output wire [1:0]     r_rx_usertest_sel,
output wire [6:0]     r_rx_asn_wait_for_pma_pcie_sw_done_cnt,
output wire           r_rx_pld_8g_a1a2_k1k2_flag_polling_bypass,
output wire           r_rx_10g_krfec_rx_diag_data_status_polling_bypass,
output wire           r_rx_pld_8g_wa_boundary_polling_bypass,
output wire           r_rx_pcspma_testbus_sel,
output wire           r_rx_pld_pma_pcie_sw_done_polling_bypass,
output wire           r_rx_pld_pma_reser_in_polling_bypass,
output wire           r_rx_pld_pma_testbus_polling_bypass,
output wire           r_rx_pld_test_data_polling_bypass,
output wire           r_rx_txeq_en,
output wire           r_rx_rxeq_en,
output wire           r_rx_pre_cursor_en,
output wire           r_rx_post_cursor_en,
output wire           r_rx_invalid_no_change,
output wire           r_rx_adp_go_b4txeq_en,
output wire           r_rx_use_rxvalid_for_rxeq,
output wire           r_rx_pma_rstn_en,
output wire           r_rx_pma_rstn_cycles,
output wire [1:0]     r_rx_eq_iteration,
output wire [7:0]     r_rx_txeq_time,
output wire           r_rx_async_pld_ltr_rst_val,
output wire           r_rx_async_pld_pma_ltd_b_rst_val,
output wire           r_rx_async_pld_8g_signal_detect_out_rst_val,
output wire           r_rx_async_pld_10g_rx_crc32_err_rst_val,
output wire           r_rx_async_pld_rx_fifo_align_clr_rst_val,
output wire           r_rx_async_hip_en,
output wire   [1:0]   r_rx_parity_sel,
output wire           r_rx_internal_clk1_sel0,
output wire           r_rx_internal_clk1_sel1,
output wire           r_rx_internal_clk1_sel2,
output wire           r_rx_internal_clk1_sel3,
output wire           r_rx_txfiford_pre_ct_sel,
output wire           r_rx_txfiford_post_ct_sel,
output wire           r_rx_txfifowr_post_ct_sel,
output wire           r_rx_txfifowr_from_aib_sel,
output wire           r_rx_pma_coreclkin_sel,
output wire [2:0]     r_rx_fifo_wr_clk_sel,
output wire [2:0]     r_rx_fifo_rd_clk_sel,
output wire           r_rx_dyn_clk_sw_en,
output wire [3:0]     r_rx_internal_clk1_sel,
output wire [3:0]     r_rx_internal_clk2_sel,
output wire           r_rx_fifo_wr_clk_scg_en,
output wire           r_rx_fifo_rd_clk_scg_en,
output wire           r_rx_pma_hclk_scg_en,
output wire           r_rx_osc_clk_scg_en,
output wire           r_rx_free_run_div_clk,
output wire           r_rx_hrdrst_rst_sm_dis,
output wire           r_rx_hrdrst_dcd_cal_done_bypass,
output wire           r_rx_rmfflag_stretch_enable,
output wire [2:0]     r_rx_rmfflag_stretch_num_stages,
output wire           r_rx_hrdrst_rx_osc_clk_scg_en,
output wire           r_rx_txeq_rst_sel,
output wire           r_rx_txeq_clk_sel,
output wire           r_rx_txeq_clk_scg_en,
output wire           r_tx_ds_last_chnl,
output wire           r_tx_us_last_chnl,
output wire           r_rx_ds_last_chnl,
output wire           r_rx_us_last_chnl,
output  wire          r_rx_internal_clk2_sel0,
output  wire          r_rx_internal_clk2_sel1,
output  wire          r_rx_internal_clk2_sel2,
output  wire          r_rx_internal_clk2_sel3,
output  wire          r_rx_rxfifowr_pre_ct_sel,
output  wire          r_rx_rxfifowr_post_ct_sel,
output  wire          r_rx_rxfiford_post_ct_sel,
output  wire          r_rx_rxfiford_to_aib_sel,
output wire [6:0]     r_rx_asn_wait_for_dll_reset_cnt,
output wire [6:0]     r_rx_asn_wait_for_clock_gate_cnt,
output wire           r_avmm2_osc_clk_scg_en,
output wire           r_sr_hip_en,
output wire           r_sr_reserbits_in_en,
output wire           r_sr_reserbits_out_en,
output wire           r_sr_osc_clk_scg_en,
output wire [1:0]     r_sr_osc_clk_div_sel,
output wire           r_sr_free_run_div_clk,
output wire           r_sr_test_enable,
output wire           r_sr_parity_en,
output wire [7:0]     r_aib_dprio_ctrl_0,
output wire [7:0]     r_aib_dprio_ctrl_1,
output wire [7:0]     r_aib_dprio_ctrl_2,
output wire [7:0]     r_aib_dprio_ctrl_3,
output wire [7:0]     r_aib_dprio_ctrl_4,
output wire           r_avmm_hrdrst_osc_clk_scg_en,
output wire [1:0]     r_avmm_testbus_sel,
output wire           r_avmm1_osc_clk_scg_en,
output wire           r_avmm1_avmm_clk_scg_en,
output wire           r_avmm1_avmm_clk_dcg_en,
output wire           r_avmm1_free_run_div_clk,
output wire [5:0]     r_avmm1_rdfifo_full,
output wire           r_avmm1_rdfifo_stop_read,
output wire           r_avmm1_rdfifo_stop_write,
output wire [5:0]     r_avmm1_rdfifo_empty,
output wire           r_avmm1_use_rsvd_bit1,
output wire           r_avmm2_avmm_clk_scg_en,
output wire           r_avmm2_avmm_clk_dcg_en,
output wire           r_avmm2_free_run_div_clk,
output wire [5:0]     r_avmm2_rdfifo_full,
output wire           r_avmm2_rdfifo_stop_read,
output wire           r_avmm2_rdfifo_stop_write,
output wire [5:0]     r_avmm2_rdfifo_empty,
output wire           r_avmm2_hip_sel,
output wire           r_rstctl_tx_elane_ovrval,
output wire           r_rstctl_tx_elane_ovren,
output wire           r_rstctl_rx_elane_ovrval,
output wire           r_rstctl_rx_elane_ovren,
output wire           r_rstctl_tx_xcvrif_ovrval,
output wire           r_rstctl_tx_xcvrif_ovren,
output wire           r_rstctl_rx_xcvrif_ovrval,
output wire           r_rstctl_rx_xcvrif_ovren,
output wire           r_rstctl_tx_adpt_ovrval,
output wire           r_rstctl_tx_adpt_ovren,
output wire           r_rstctl_rx_adpt_ovrval,
output wire           r_rstctl_rx_adpt_ovren,
output wire           r_rstctl_tx_pld_div2_rst_opt ,
output wire [7:0]     r_aib_csr_ctrl_0,
output wire [7:0]     r_aib_csr_ctrl_1,
output wire [7:0]     r_aib_csr_ctrl_2,
output wire [7:0]     r_aib_csr_ctrl_3,
output wire [7:0]     r_aib_csr_ctrl_4,
output wire [7:0]     r_aib_csr_ctrl_5,
output wire [7:0]     r_aib_csr_ctrl_6,
output wire [7:0]     r_aib_csr_ctrl_7,
output wire [7:0]     r_aib_csr_ctrl_8,
output wire [7:0]     r_aib_csr_ctrl_9,
output wire [7:0]     r_aib_csr_ctrl_10,
output wire [7:0]     r_aib_csr_ctrl_11,
output wire [7:0]     r_aib_csr_ctrl_12,
output wire [7:0]     r_aib_csr_ctrl_13,
output wire [7:0]     r_aib_csr_ctrl_14,
output wire [7:0]     r_aib_csr_ctrl_15,
output wire [7:0]     r_aib_csr_ctrl_16,
output wire [7:0]     r_aib_csr_ctrl_17,
output wire [7:0]     r_aib_csr_ctrl_18,
output wire [7:0]     r_aib_csr_ctrl_19,
output wire [7:0]     r_aib_csr_ctrl_20,
output wire [7:0]     r_aib_csr_ctrl_21,
output wire [7:0]     r_aib_csr_ctrl_22,
output wire [7:0]     r_aib_csr_ctrl_23,
output wire [7:0]     r_aib_csr_ctrl_24,
output wire [7:0]     r_aib_csr_ctrl_25,
output wire [7:0]     r_aib_csr_ctrl_26,
output wire [7:0]     r_aib_csr_ctrl_27,
output wire [7:0]     r_aib_csr_ctrl_28,
output wire [7:0]     r_aib_csr_ctrl_29,
output wire [7:0]     r_aib_csr_ctrl_30,
output wire [7:0]     r_aib_csr_ctrl_31,
output wire [7:0]     r_aib_csr_ctrl_32,
output wire [7:0]     r_aib_csr_ctrl_33,
output wire [7:0]     r_aib_csr_ctrl_34,
output wire [7:0]     r_aib_csr_ctrl_35,
output wire [7:0]     r_aib_csr_ctrl_36,
output wire [7:0]     r_aib_csr_ctrl_37,
output wire [7:0]     r_aib_csr_ctrl_38,
output wire [7:0]     r_aib_csr_ctrl_39,
output wire [7:0]     r_aib_csr_ctrl_40,
output wire [7:0]     r_aib_csr_ctrl_41,
output wire [7:0]     r_aib_csr_ctrl_42,
output wire [7:0]     r_aib_csr_ctrl_43,
output wire [7:0]     r_aib_csr_ctrl_44,
output wire [7:0]     r_aib_csr_ctrl_45,
output wire [7:0]     r_aib_csr_ctrl_46,
output wire [7:0]     r_aib_csr_ctrl_47,
output wire [7:0]     r_aib_csr_ctrl_48,
output wire [7:0]     r_aib_csr_ctrl_49,
output wire [7:0]     r_aib_csr_ctrl_50,
output wire [7:0]     r_aib_csr_ctrl_51,
output wire [7:0]     r_aib_csr_ctrl_52,
output wire [7:0]     r_aib_csr_ctrl_53
);

localparam  NUM_STATUS_REGS   = 3;  // Number of n-bit status registers.
localparam  BYPASS_STAT_SYNC  = 0;  // to bypass the Synchronization SM in case of individual status bits
localparam  DATA_WIDTH        = 8;  // Data width

localparam  AVMM2_HIP_SEL     = 1'b1;

// Decoding byte address
localparam ND_AIB_BASE        = 11'h300;
localparam C3_EHIP_BASE       = 11'h400;
localparam CFG_INBOX_ADDR     = 7'h04;
localparam USR_INBOX_ADDR     = 8'h04;
localparam MAP_TX_PMADIR      = 3'b100;
localparam FIFOMODE_BYPASS    = 2'b00;
localparam FIFOMODE_PHASECOMP = 2'b01;


wire         csr_out_int;
wire [7:0]   master_pld_avmm_writedata;
wire [7:0]   master_pld_avmm_reg_addr;
wire         master_pld_avmm_write;
wire         master_pld_avmm_read;
wire [7:0]   readdata;
wire [551:0] extra_csr_out;
wire [399:0] user_dataout;
reg  [2:0]   csr_pipe_temp;
reg  [2:0]   csr_pipe_temp_n;
wire [2:0]   dprio_status_wen;
wire [2:0]   dprio_status_wen_ack;
wire [23:0]  dprio_status;
wire [23:0]  stat_data_out;


// wire         r_avmm_rd_block_enable;
// wire         r_avmm_uc_block_enable;
// wire         r_avmm_nfhssi_calibration_en;
// wire         r_avmm_force_inter_sel_csr_ctrl;
// wire         r_avmm_dprio_broadcast_en_csr_ctrl;
// wire [9:0]   r_avmm_nfhssi_base_addr;

wire         csr_out_chnl_n;

reg   [2:0]  csr_temp;
reg   [2:0]  csr_temp_n;

wire         crssm_cfg_active;
wire         adpt_avmm_usr_active;
wire [7:0]   r_dprio_status_rx_chnl;
wire [7:0]   r_dprio_status_tx_chnl;
wire [7:0]   r_dprio_status_sr;
wire [7:0]   w_dprio_status_rx_chnl;
wire [7:0]   w_dprio_status_tx_chnl;
wire [7:0]   w_dprio_status_sr;
wire         adpt_avmm_clk;
wire         adpt_avmm_rst_n;
wire [31:0]  adpt_avmm_wdata;
wire         adpt_avmm_read;
wire         adpt_avmm_write;
wire [3:0]   adpt_avmm_byte_en;
wire [31:0]  adpt_avmm_rdata;
wire         adpt_avmm_rdatavld;
wire [7:0]   adpt_avmm_addr;
wire [31:0]  w_aib_csr_ctrl10_4x;
wire [31:0]  w_aib_csr_ctrl11_4x;
wire [31:0]  w_aib_csr_ctrl12_4x;
wire [15:0]  w_aib_csr_ctrl13_5x;

wire [7:0]   w_aib_csr_ctrl_0;
wire [7:0]   w_aib_csr_ctrl_1;
wire [7:0]   w_aib_csr_ctrl_2;
wire [7:0]   w_aib_csr_ctrl_3;
wire [7:0]   w_aib_csr_ctrl_4;
wire [7:0]   w_aib_csr_ctrl_5;
wire [7:0]   w_aib_csr_ctrl_6;
wire [7:0]   w_aib_csr_ctrl_7;
wire [7:0]   w_aib_csr_ctrl_8;
wire [7:0]   w_aib_csr_ctrl_9;
wire [7:0]   w_aib_csr_ctrl_10;
wire [7:0]   w_aib_csr_ctrl_11;
wire [7:0]   w_aib_csr_ctrl_12;
wire [7:0]   w_aib_csr_ctrl_13;
wire [7:0]   w_aib_csr_ctrl_14;
wire [7:0]   w_aib_csr_ctrl_15;
wire [7:0]   w_aib_csr_ctrl_16;
wire [7:0]   w_aib_csr_ctrl_17;
wire [7:0]   w_aib_csr_ctrl_18;
wire [7:0]   w_aib_csr_ctrl_19;
wire [7:0]   w_aib_csr_ctrl_20;
wire [7:0]   w_aib_csr_ctrl_21;
wire [7:0]   w_aib_csr_ctrl_22;
wire [7:0]   w_aib_csr_ctrl_23;
wire [7:0]   w_aib_csr_ctrl_24;
wire [7:0]   w_aib_csr_ctrl_25;
wire [7:0]   w_aib_csr_ctrl_26;
wire [7:0]   w_aib_csr_ctrl_27;
wire [7:0]   w_aib_csr_ctrl_28;
wire [7:0]   w_aib_csr_ctrl_29;
wire [7:0]   w_aib_csr_ctrl_30;
wire [7:0]   w_aib_csr_ctrl_31;
wire [7:0]   w_aib_csr_ctrl_32;
wire [7:0]   w_aib_csr_ctrl_33;
wire [7:0]   w_aib_csr_ctrl_34;
wire [7:0]   w_aib_csr_ctrl_35;
wire [7:0]   w_aib_csr_ctrl_36;
wire [7:0]   w_aib_csr_ctrl_37;
wire [7:0]   w_aib_csr_ctrl_38;
wire [7:0]   w_aib_csr_ctrl_39;
wire         usr_csr_reset;
wire [5:0]   r_ifctl_mcast_addr;
wire         r_ifctl_mcast_en;
wire [29:0]  r_cfg_outbox_cfg_msg;
wire         r_cfg_outbox_send_msg;
wire [29:0]  r_cfg_inbox_cfg_msg;
wire         r_cfg_inbox_new_msg;
wire [29:0]  r_usr_outbox_usr_msg;
wire         r_usr_outbox_send_msg;
wire [29:0]  r_usr_inbox_usr_msg;
wire         r_usr_inbox_new_msg;
wire [29:0]  cfg2usr_msg;
wire [29:0]  usr2cfg_msg;
wire         usr_inbox_read_en;
wire         cfg_inbox_read_en;
wire         cfg_only_write;
wire         cfg_only_read;
wire         cfg_only_addr_match;
wire         cfg_only_id_match;
wire         cfg_csr_clk;
wire         cfg_csr_reset;
wire [31:0]  cfg_csr_wdata;
wire         cfg_csr_read;
wire         cfg_csr_write;
wire [3:0]   cfg_csr_byteen;
wire [31:0]  cfg_csr_rdata;
wire         cfg_csr_rdatavld;
wire [6:0]   cfg_csr_addr;
wire [7:0]   r_spare0_rsvd;
wire [3:0]   r_spare0_rsvd_prst;
wire         load_usr_msg;
wire [29:0]  r_usr_inbox_usr_msg_i;
wire [29:0]  r_cfg_inbox_cfg_msg_i;
wire         r_cfg_outbox_send_msg_i;
wire         r_cfg_inbox_new_msg_i;
wire         r_cfg_inbox_autoclear_dis;
wire         r_usr_outbox_send_msg_i;
wire         r_usr_inbox_new_msg_i;
wire         r_usr_inbox_autoclear_dis;
wire         cfg_autoclear_en;
wire         usr_autoclear_en;
wire         load_cfg_msg;
wire         cfg_outbox_send_ack;
wire         usr_outbox_send_ack;
wire [6:0]   r_ifctl_hwcfg_mode;
wire         r_ifctl_hwcfg_adpt_en;
wire         r_ifctl_hwcfg_aib_en;
wire         cfg_dout_vld;
wire         usr_dout_vld;
wire         w_ifctl_usr_active;
wire [2:0]   w_tx_chnl_datapath_map_mode;
wire         w_tx_usertest_sel;
wire         w_tx_latency_src_xcvrif;
wire [4:0]   w_tx_fifo_empty;
wire [4:0]   w_tx_fifo_full;
wire [2:0]   w_tx_phcomp_rd_delay;
wire         w_tx_double_read;
wire         w_tx_stop_read;
wire         w_tx_stop_write;
wire [4:0]   w_tx_fifo_pempty;
wire [4:0]   w_tx_fifo_pfull;
wire         w_tx_wa_en;
wire [1:0]   w_tx_fifo_power_mode;
wire [2:0]   w_tx_stretch_num_stages;
wire [2:0]   w_tx_datapath_tb_sel;
wire         w_tx_wr_adj_en;
wire         w_tx_rd_adj_en;
wire         w_tx_async_pld_txelecidle_rst_val;
wire         w_tx_async_hip_aib_fsr_in_bit0_rst_val;
wire         w_tx_async_hip_aib_fsr_in_bit1_rst_val;
wire         w_tx_async_hip_aib_fsr_in_bit2_rst_val;
wire         w_tx_async_hip_aib_fsr_in_bit3_rst_val;
wire         w_tx_async_pld_pmaif_mask_tx_pll_rst_val;
wire         w_tx_async_hip_aib_fsr_out_bit0_rst_val;
wire         w_tx_async_hip_aib_fsr_out_bit1_rst_val;
wire         w_tx_async_hip_aib_fsr_out_bit2_rst_val;
wire         w_tx_async_hip_aib_fsr_out_bit3_rst_val;
wire [1:0]   w_tx_fifo_rd_clk_sel;
wire         w_tx_fifo_wr_clk_scg_en;
wire         w_tx_fifo_rd_clk_scg_en;
wire         w_tx_osc_clk_scg_en;
wire         w_tx_free_run_div_clk;
wire         w_tx_hrdrst_rst_sm_dis;
wire         w_tx_hrdrst_dcd_cal_done_bypass;
wire         w_tx_hrdrst_dll_lock_bypass;
wire         w_tx_hrdrst_align_bypass;
wire         w_tx_hrdrst_user_ctl_en;
wire         w_tx_hrdrst_rx_osc_clk_scg_en;
wire         w_tx_hip_osc_clk_scg_en;
wire [2:0]   w_rx_chnl_datapath_map_mode;
wire [2:0]   w_rx_pcs_testbus_sel;
wire [4:0]   w_rx_fifo_empty;
wire [1:0]   w_rx_fifo_mode;
wire         w_rx_wm_en;
wire [4:0]   w_rx_fifo_full;
wire [2:0]   w_rx_phcomp_rd_delay;
wire         w_rx_double_write;
wire         w_rx_stop_read;
wire         w_rx_stop_write;
wire [4:0]   w_rx_fifo_pempty;
wire [1:0]   w_rx_fifo_power_mode;
wire [4:0]   w_rx_fifo_pfull;
wire [2:0]   w_rx_stretch_num_stages;
wire [3:0]   w_rx_datapath_tb_sel;
wire         w_rx_wr_adj_en;
wire         w_rx_rd_adj_en;
wire         w_tx_dv_gating_en;
wire [1:0]   w_rx_adapter_lpbk_mode;
wire         w_rx_aib_lpbk_en;
wire         w_tx_rev_lpbk;
wire         w_rx_hrdrst_user_ctl_en;
wire [1:0]   w_rx_usertest_sel;
wire         w_rx_pld_8g_a1a2_k1k2_flag_polling_bypass;
wire         w_rx_10g_krfec_rx_diag_data_status_polling_bypass;
wire         w_rx_pld_8g_wa_boundary_polling_bypass;
wire         w_rx_pcspma_testbus_sel;
wire         w_rx_pld_pma_pcie_sw_done_polling_bypass;
wire         w_rx_pld_pma_reser_in_polling_bypass;
wire         w_rx_pld_pma_testbus_polling_bypass;
wire         w_rx_pld_test_data_polling_bypass;
wire         w_rx_async_pld_ltr_rst_val;
wire         w_rx_async_pld_pma_ltd_b_rst_val;
wire         w_rx_async_pld_8g_signal_detect_out_rst_val;
wire         w_rx_async_pld_10g_rx_crc32_err_rst_val;
wire         w_rx_async_pld_rx_fifo_align_clr_rst_val;
wire         w_rx_async_hip_en;
wire [1:0]   w_rx_parity_sel;
wire         w_rx_internal_clk1_sel0;
wire         w_rx_internal_clk1_sel1;
wire         w_rx_internal_clk1_sel2;
wire         w_rx_internal_clk1_sel3;
wire         w_rx_txfiford_pre_ct_sel;
wire         w_rx_txfiford_post_ct_sel;
wire         w_rx_txfifowr_post_ct_sel;
wire         w_rx_txfifowr_from_aib_sel;
wire         w_rx_pma_coreclkin_sel;
wire [2:0]   w_rx_fifo_wr_clk_sel;
wire [2:0]   w_rx_fifo_rd_clk_sel;
wire [3:0]   w_rx_internal_clk1_sel;
wire [3:0]   w_rx_internal_clk2_sel;
wire         w_rx_fifo_wr_clk_scg_en;
wire         w_rx_fifo_rd_clk_scg_en;
wire         w_rx_osc_clk_scg_en;
wire         w_rx_free_run_div_clk;
wire         w_rx_hrdrst_rst_sm_dis;
wire         w_rx_hrdrst_dcd_cal_done_bypass;
wire         w_rx_rmfflag_stretch_enable;
wire [2:0]   w_rx_rmfflag_stretch_num_stages;
wire         w_rx_hrdrst_rx_osc_clk_scg_en;
wire         w_rx_internal_clk2_sel0;
wire         w_rx_internal_clk2_sel1;
wire         w_rx_internal_clk2_sel2;
wire         w_rx_internal_clk2_sel3;
wire         w_rx_rxfifowr_pre_ct_sel;
wire         w_rx_rxfifowr_post_ct_sel;
wire         w_rx_rxfiford_post_ct_sel;
wire         w_rx_rxfiford_to_aib_sel;
wire         w_avmm2_osc_clk_scg_en;
wire         w_sr_hip_en;
wire         w_sr_reserbits_in_en;
wire         w_sr_reserbits_out_en;
wire         w_sr_osc_clk_scg_en;
wire [1:0]   w_sr_osc_clk_div_sel;
wire         w_sr_free_run_div_clk;
wire         w_sr_test_enable;
wire         w_sr_parity_en;
wire [7:0]   w_aib_dprio_ctrl_0;
wire [7:0]   w_aib_dprio_ctrl_1;
wire [7:0]   w_aib_dprio_ctrl_2;
wire [7:0]   w_aib_dprio_ctrl_3;
wire [7:0]   w_aib_dprio_ctrl_4;
wire         w_avmm_hrdrst_osc_clk_scg_en;
wire [7:0]   w_avmm_spare_rsvd;
wire [3:0]   w_avmm_spare_rsvd_prst;
wire [1:0]   w_avmm_testbus_sel;
wire         w_avmm1_osc_clk_scg_en;
wire         w_avmm1_avmm_clk_scg_en;
wire         w_avmm1_avmm_clk_dcg_en;
wire         w_avmm1_free_run_div_clk;
wire [5:0]   w_avmm1_rdfifo_full;
wire         w_avmm1_rdfifo_stop_read;
wire         w_avmm1_rdfifo_stop_write;
wire [5:0]   w_avmm1_rdfifo_empty;
wire         w_avmm2_avmm_clk_scg_en;
wire         w_avmm2_avmm_clk_dcg_en;
wire         w_avmm2_free_run_div_clk;
wire [5:0]   w_avmm2_rdfifo_full;
wire         w_avmm2_rdfifo_stop_read;
wire         w_avmm2_rdfifo_stop_write;
wire [5:0]   w_avmm2_rdfifo_empty;
wire         w_rstctl_tx_elane_ovrval;
wire         w_rstctl_tx_elane_ovren;
wire         w_rstctl_rx_elane_ovrval;
wire         w_rstctl_rx_elane_ovren;
wire         w_rstctl_tx_xcvrif_ovrval;
wire         w_rstctl_tx_xcvrif_ovren;
wire         w_rstctl_rx_xcvrif_ovrval;
wire         w_rstctl_rx_xcvrif_ovren;
wire         w_rstctl_tx_adpt_ovrval;
wire         w_rstctl_tx_adpt_ovren;
wire         w_rstctl_rx_adpt_ovrval;
wire         w_rstctl_rx_adpt_ovren;
wire         w_rstctl_tx_pld_div2_rst_opt;
// wire         remote_pld_avmm_waitrequest;
reg          cfg_dout_vld_d0;
reg          usr_dout_vld_d0;
reg          usr_outbox_send_busy_d0;
reg          cfg_outbox_send_busy_d0;

// Deprecated Feature: ASN, EQ
assign r_rx_asn_wait_for_fifo_flush_cnt       = {7{1'b0}};
assign r_rx_asn_wait_for_pma_pcie_sw_done_cnt = {7{1'b0}};
assign r_rx_asn_wait_for_dll_reset_cnt        = {7{1'b0}};
assign r_rx_asn_wait_for_clock_gate_cnt       = {7{1'b0}};
assign r_rx_bonding_dft_in_en     = 1'b0;
assign r_rx_bonding_dft_in_value  = 1'b0;
assign r_rx_txeq_en               = 1'b0;
assign r_rx_rxeq_en               = 1'b0;
assign r_rx_pre_cursor_en         = 1'b0;
assign r_rx_post_cursor_en        = 1'b0;
assign r_rx_invalid_no_change     = 1'b0;
assign r_rx_adp_go_b4txeq_en      = 1'b0;
assign r_rx_use_rxvalid_for_rxeq  = 1'b0;
assign r_rx_eq_iteration          = 2'b00;
assign r_rx_txeq_time             = 8'h00;
assign r_rx_dyn_clk_sw_en         = 1'b0;
assign r_rx_pma_hclk_scg_en       = 1'b0;
assign r_rx_txeq_rst_sel          = 1'b0;
assign r_rx_txeq_clk_sel          = 1'b0;
assign r_rx_txeq_clk_scg_en       = 1'b0;
assign r_tx_ds_last_chnl          = 1'b1;
assign r_tx_us_last_chnl          = 1'b1;
assign r_rx_ds_last_chnl          = 1'b1;
assign r_rx_us_last_chnl          = 1'b1;
assign r_tx_aib_clk_sel           = 2'b00;

// Read response from chnl_ (Adapter usr_cfg, ELANE, or XCVRIF) should not be combined with
// cfg_only since SSM may access Inbox/Outbox while Usr is active
// assign cfg_avmm_rdata    = chnl_avmm_rdata    | cfg_only_rdata; 
// assign cfg_avmm_rdatavld = chnl_avmm_rdatavld | cfg_only_rdatavld;
// assign cfg_avmm_waitreq  = chnl_avmm_waitreq  & cfg_only_waitreq;


// Status Registers
assign sr_dprio_status_write_en      = dprio_status_wen[2];
assign tx_chnl_dprio_status_write_en = dprio_status_wen[1];
assign rx_chnl_dprio_status_write_en = dprio_status_wen[0];

assign dprio_status_wen_ack          = {sr_dprio_status_write_en_ack, tx_chnl_dprio_status_write_en_ack, rx_chnl_dprio_status_write_en_ack};
assign dprio_status                  = {sr_dprio_status[7:0], tx_chnl_dprio_status[7:0], rx_chnl_dprio_status[7:0]};


assign w_dprio_status_rx_chnl = rx_chnl_dprio_status_write_en ? stat_data_out[0+:8]  : r_dprio_status_rx_chnl;
assign w_dprio_status_tx_chnl = tx_chnl_dprio_status_write_en ? stat_data_out[8+:8]  : r_dprio_status_tx_chnl;
assign w_dprio_status_sr      = sr_dprio_status_write_en      ? stat_data_out[16+:8] : r_dprio_status_sr;

assign crssm_cfg_active         = ~r_ifctl_usr_active;
assign o_xcvrif_avmm_cfg_active = ~r_ifctl_usr_active;
assign o_elane_avmm_cfg_active  = ~r_ifctl_usr_active;

generate
  genvar i;
  for (i=0; i < NUM_STATUS_REGS; i=i+1) begin: stat_reg_nbits
  // Status register synchronizers
  // hd_dpcmn_dprio_status_sync_regs
  c3aibadapt_cmn_dprio_status_sync_regs
  #(
     .DATA_WIDTH(DATA_WIDTH),            // Data width
     .BYPASS_STAT_SYNC(BYPASS_STAT_SYNC) // Parameter to bypass the Synchronization SM in case of individual status bits
   ) dprio_status_sync_regs
  (
   .rst_n             (adpt_avmm_rst_n),                                    // reset
   .clk               (adpt_avmm_clk),                                      // clock
   .stat_data_in      (dprio_status[DATA_WIDTH*(i+1)-1:DATA_WIDTH*i]),      // status data input
   .write_en_ack      (dprio_status_wen_ack[i]),                            // write data acknowlege from user logic
   .write_en          (dprio_status_wen[i]),                                // write data enable to user logic
   .stat_data_out     (stat_data_out[DATA_WIDTH*(i+1)-1:DATA_WIDTH*i])      // status data output
  );
  end
endgenerate

assign remote_pld_avmm_busy       = crssm_cfg_active;
// assign remote_pld_avmm_write_busy = remote_pld_avmm_writedone;
assign avmm1_cmn_intf_testbus = {remote_pld_avmm_write, remote_pld_avmm_read, remote_pld_avmm_busy, remote_pld_avmm_writedone, remote_pld_avmm_readdatavalid};

// Arbitrates between User AVMM1 and CRSSM AVMM
c3aibadapt_avmm_dec_arb avmm_dec_arb (

      .i_usr_avmm_clk                (usr_avmm_clk                 ),// 150MHz clock
      .i_usr_avmm_rst_n              (usr_avmm_rst_n               ),//   async   User AVMM interface reset 0: Reset User AVMM interface Comes from the  AIB adapter
      .i_usr_avmm_read               (remote_pld_avmm_read         ),//   usr_avmm_clk      AVMM Read 1: Requests a read to the address given by i_avmm_addr. The data corresponding to this read request will be valid <avmm_latency>  cycles later Maps to status_read in Ethernet soft cores
      .i_usr_avmm_write              (remote_pld_avmm_write        ),//   usr_avmm_clk      AVMM Write 1: Requests the data given by i_avmm_wdata be written to the address given by i_avmm_addr Maps to status_write in Ethernet soft cores
      .i_usr_avmm_wdata              (remote_pld_avmm_writedata    ),//   usr_avmm_clk      AVMM Write Data Data to be written to the register addressed by i_avmm_addr for the current write request Maps to status_writedata in Ethernet soft cores
      .i_usr_avmm_addr               (remote_pld_avmm_reg_addr     ),//   usr_avmm_clk      AVMM Address Register address for read and write requests Maps to status_addr in Ethernet soft cores
      .i_usr_avmm_rsvd               (remote_pld_avmm_rsvd         ),//   usr_avmm_clk      AVMM1 Reserved bits
      .o_usr_avmm_rdata              (remote_pld_avmm_readdata     ),//   usr_avmm_clk      AVMM Read Data Data from the register addressed by i_avmm_addr on a previously accepted read request Maps to status_readdata in Ethernet soft cores
      .o_usr_avmm_readdatavalid      (remote_pld_avmm_readdatavalid),//   usr_avmm_clk      AVMM Read Data Valid 1: Data on o_user_avmm_rdata[7:0] is valid
      .o_usr_avmm_writedone          (remote_pld_avmm_writedone    ),//   usr_avmm_clk      AVMM Write Done 1: Most recently requested user AVMM write is complete
      .o_usr_avmm_waitrequest        (remote_pld_avmm_waitrequest  ),//   usr_avmm_clk      AVMM Waitrequest Arbiter is busy servicing User AVMM
      .i_config_avmm_clk             (cfg_avmm_clk                 ),// 250MHz clock
      .i_config_avmm_rst_n           (cfg_avmm_rst_n               ),//   cfg_avmm_clk (locally synchronized)  Configuration AVMM interface reset 0: EHIP Configuration AVMM interface held in reset by the SSM CNT-to-Fabric interface
      .i_config_avmm_raw_rst_n       (cfg_avmm_raw_rst_n           ),
      .i_config_avmm_write           (cfg_avmm_write               ),//   cfg_avmm_clk     Configuration AVMM Write control Write enable control signal feed through to next Hard IP
      .i_config_avmm_read            (cfg_avmm_read                ),//   cfg_avmm_clk     Configuration AVMM Read control 1: Requests a read to the address given by i_avmm_addr. The data corresponding to this read request will be valid <avmm_latency>  cycles later
      .i_config_avmm_addr            (cfg_avmm_addr[16:0]          ),//   cfg_avmm_clk     Configuration AVMM Address Register byte address for read and write requests
      .i_config_avmm_wdata           (cfg_avmm_wdata               ),//   cfg_avmm_clk     Configuration AVMM Write Data Data to be written to the register addressed by i_avmm_addr for the current write request
      .i_config_avmm_byte_en         (cfg_avmm_byte_en             ),//   cfg_avmm_clk     Configuration AVMM Byte enable selects  Byte enables
      .o_config_avmm_rdata           (chnl_avmm_rdata              ),//   cfg_avmm_clk     Configuration AVMM read data Register address for read and write requests
      .o_config_avmm_rdatavalid      (chnl_avmm_rdatavld           ),//   cfg_avmm_clk     Configuration AVMM read data Register address for read and write requests
      .o_config_avmm_waitrequest     (chnl_avmm_waitreq            ),//   cfg_avmm_clk     Configuration AVMM Waitrequest Waitrequest from previous Hard IP feedthrough to SSM
      .i_config_avmm_addr_id         (cfg_avmm_addr_id             ),//   cfg_avmm_clk
      .o_config_avmm_slave_active    (                             ),//   cfg_avmm_clk


      .o_pma_avmm_clk                (o_xcvrif_avmm_clk            ),// Mux    clock
      .o_pma_avmm_rst_n              (o_xcvrif_avmm_rst_n          ),//   o_pma_avmm_clk (locally synchronized)  Configuration AVMM interface reset 0: EHIP Configuration AVMM interface held in reset by the SSM CNT-to-Fabric interface
      .o_pma_avmm_from_usr_master    (                             ),//   o_aib_avmm_clk     When set indicates AVMM Master is the PLD User AVMM
      .o_pma_avmm_write              (o_xcvrif_avmm_write          ),//   o_pma_avmm_clk     Configuration AVMM Write control Write enable control signal feed through to next Hard IP
      .o_pma_avmm_read               (o_xcvrif_avmm_read           ),//   o_pma_avmm_clk     Configuration AVMM Read control 1: Requests a read to the address given by i_avmm_addr. The data corresponding to this read request will be valid <avmm_latency>  cycles later
      .o_pma_avmm_addr               (o_xcvrif_avmm_addr[8:0]      ),//   o_pma_avmm_clk     Configuration AVMM Address Register byte address for read and write requests
      .o_pma_avmm_wdata              (o_xcvrif_avmm_wdata          ),//   o_pma_avmm_clk     Configuration AVMM Write Data Data to be written to the register addressed by i_avmm_addr for the current write request
      .o_pma_avmm_byte_en            (o_xcvrif_avmm_byte_en        ),//   o_pma_avmm_clk     Configuration AVMM Byte enable selects SSM Byte enables
      .i_pma_avmm_rdata              (i_xcvrif_avmm_rdata          ),//   o_pma_avmm_clk     Configuration AVMM read data Register address for read and write requests
      .i_pma_avmm_rdatavalid         (i_xcvrif_avmm_rdatavld       ),//   o_pma_avmm_clk     Configuration AVMM read data Register address for read and write requests
      .i_pma_avmm_waitrequest        (i_xcvrif_avmm_waitreq        ),//   o_pma_avmm_clk     Configuration AVMM Waitrequest Waitrequest from previous Hard IP feedthrough to SSM


      .o_ehiplane_avmm_clk            (o_elane_avmm_clk            ),// Mux    clock
      .o_ehiplane_avmm_rst_n          (o_elane_avmm_rst_n          ),
      .o_ehiplane_avmm_from_usr_master(                            ),//   o_aib_avmm_clk     When set indicates AVMM Master is the PLD User AVMM
      .o_ehiplane_avmm_write          (o_elane_avmm_write          ),//   o_ehiplane_avmm_clk     Configuration AVMM Write control Write enable control signal feed through to next Hard IP
      .o_ehiplane_avmm_read           (o_elane_avmm_read           ),//   o_ehiplane_avmm_clk     Configuration AVMM Read control 1: Requests a read to the address given by i_avmm_addr. The data corresponding to this read request will be valid <avmm_latency>  cycles later
      .o_ehiplane_avmm_addr           (o_elane_avmm_addr[16:0]     ),//   o_ehiplane_avmm_clk     Configuration AVMM Address Register byte address for read and write requests
      .o_ehiplane_avmm_wdata          (o_elane_avmm_wdata          ),//   o_ehiplane_avmm_clk     Configuration AVMM Write Data Data to be written to the register addressed by i_avmm_addr for the current write request
      .o_ehiplane_avmm_byte_en        (o_elane_avmm_byte_en        ),
      .i_ehiplane_avmm_rdata          (i_elane_avmm_rdata          ),//   o_ehiplane_avmm_clk     Configuration AVMM read data Register address for read and write requests
      .i_ehiplane_avmm_rdatavalid     (i_elane_avmm_rdatavld       ),//   o_ehiplane_avmm_clk     Configuration AVMM read data Register address for read and write requests
      .i_ehiplane_avmm_waitrequest    (i_elane_avmm_waitreq        ),

      .o_aib_avmm_clk                 (adpt_avmm_clk               ),// Mux clock
      .o_aib_avmm_rst_n               (adpt_avmm_rst_n             ),
      .o_aib_avmm_from_usr_master     (adpt_avmm_usr_active        ),//   o_aib_avmm_clk     When set indicates AVMM Master is the PLD User AVMM
      .o_aib_avmm_write               (adpt_avmm_write             ),//   o_aib_avmm_clk     Configuration AVMM Write control Write enable control signal feed through to next Hard IP
      .o_aib_avmm_read                (adpt_avmm_read              ),//   o_aib_avmm_clk     Configuration AVMM Read control 1: Requests a read to the address given by i_avmm_addr. The data corresponding to this read request will be valid <avmm_latency>  cycles later
      .o_aib_avmm_addr                (adpt_avmm_addr[7:0]         ),//   o_aib_avmm_clk     Configuration AVMM Address Register byte address for read and write requests
      .o_aib_avmm_wdata               (adpt_avmm_wdata             ),//   o_aib_avmm_clk     Configuration AVMM Write Data Data to be written to the register addressed by i_avmm_addr for the current write request
      .o_aib_avmm_byte_en             (adpt_avmm_byte_en           ),
      .i_aib_avmm_rdata               (adpt_avmm_rdata             ),//   o_aib_avmm_clk     Configuration AVMM read data Register address for read and write requests
      .i_aib_avmm_rdatavalid          (adpt_avmm_rdatavld          ),//   o_aib_avmm_clk     Configuration AVMM read data Register address for read and write requests
      .i_aib_avmm_waitrequest         (1'b0                        ),

      .i_prg_mcast_addr               (r_ifctl_mcast_addr[5:0]     ), // i_config_avmm_clk
      .i_prg_mcast_addr_en            (r_ifctl_mcast_en            ), // i_config_avmm_clk
      .i_arbiter_base                 (r_ifctl_usr_active          ), // i_config_avmm_clk

      .i_scan_mode_n                  (scan_mode_n                 ),// Scan reset inputs
      .i_rst_n_bypass                 (scan_rst_n                  ),// Scan reset inputs
      .o_dec_arb_tb_direct            (dec_arb_tb_direct)
);

// Features not supported 
assign r_tx_dyn_clk_sw_en      = 1'b0;
assign r_rx_mask_del           = 4'h0;
assign r_rx_force_align        = 1'b0;
assign r_rx_align_del          = 1'b0;
assign r_rx_indv               = 1'b1;
assign r_rx_pma_rstn_cycles    = 1'b0;    // TXEQ
assign r_rx_pma_rstn_en        = 1'b0;    // TXEQ
assign r_tx_indv               = 1'b1;
assign r_tx_us_master          = 1'b0;
assign r_tx_ds_master          = 1'b0;
assign r_tx_us_bypass_pipeln   = 1'b0;
assign r_tx_ds_bypass_pipeln   = 1'b0;
assign r_rx_us_master          = 1'b0;
assign r_rx_ds_master          = 1'b0;
assign r_rx_us_bypass_pipeln   = 1'b0;
assign r_rx_ds_bypass_pipeln   = 1'b0;
assign r_tx_wren_fastbond      = {5{1'b0}};
assign r_tx_comp_cnt           = 8'h00;
assign r_rx_comp_cnt           = 8'h00;

assign r_tx_chnl_datapath_map_txqpi_pullup_init_val = 1'b0;
assign r_tx_chnl_datapath_map_txqpi_pulldn_init_val = 1'b0;
assign r_tx_chnl_datapath_map_rxqpi_pullup_init_val = 1'b0;
assign r_tx_compin_sel                              = 2'b01;
assign r_rx_compin_sel                              = 2'b01;
assign r_tx_bonding_dft_in_en                       = 1'b0;
assign r_tx_bonding_dft_in_value                    = 1'b0;
assign r_tx_presethint_bypass                       = 1'b0;
assign r_tx_qpi_sr_enable                           = 1'b0;
assign r_rx_asn_en                                  = 1'b0;
assign r_rx_asn_bypass_clock_gate                   = 1'b0;
assign r_rx_asn_bypass_pma_pcie_sw_done             = 1'b0;
assign r_rx_slv_asn_en                              = 1'b0;

// Features that are hard-coded
assign r_avmm2_hip_sel         = AVMM2_HIP_SEL;

// 00: bypass mode; 01: phase-comp mode; 11: reg mode
// assign r_tx_fifo_mode       = (r_tx_chnl_datapath_map_mode == MAP_TX_PMADIR) ? 2'b00 : 2'b01;
assign r_tx_fifo_mode          = (r_tx_chnl_datapath_map_mode == MAP_TX_PMADIR) ? FIFOMODE_BYPASS : FIFOMODE_PHASECOMP;

c3aibadapt_hwcfg_dec adapt_hwcfg_dec (
  // Output
  .o_ifctl_usr_active                                    (r_ifctl_usr_active),
  .o_tx_chnl_datapath_map_mode                           (r_tx_chnl_datapath_map_mode),
  .o_tx_usertest_sel                                     (r_tx_usertest_sel),
  .o_tx_latency_src_xcvrif                               (r_tx_latency_src_xcvrif),
  .o_tx_fifo_empty                                       (r_tx_fifo_empty),
  .o_tx_fifo_full                                        (r_tx_fifo_full),
  .o_tx_phcomp_rd_delay                                  (r_tx_phcomp_rd_delay),
  .o_tx_double_read                                      (r_tx_double_read),
  .o_tx_stop_read                                        (r_tx_stop_read),
  .o_tx_stop_write                                       (r_tx_stop_write),
  .o_tx_fifo_pempty                                      (r_tx_fifo_pempty),
  .o_tx_fifo_pfull                                       (r_tx_fifo_pfull),
  .o_tx_wa_en                                            (r_tx_wa_en),
  .o_tx_fifo_power_mode                                  (r_tx_fifo_power_mode),
  .o_tx_stretch_num_stages                               (r_tx_stretch_num_stages),
  .o_tx_datapath_tb_sel                                  (r_tx_datapath_tb_sel),
  .o_tx_wr_adj_en                                        (r_tx_wr_adj_en),
  .o_tx_rd_adj_en                                        (r_tx_rd_adj_en),
  .o_tx_async_pld_txelecidle_rst_val                     (r_tx_async_pld_txelecidle_rst_val),
  .o_tx_async_hip_aib_fsr_in_bit0_rst_val                (r_tx_async_hip_aib_fsr_in_bit0_rst_val),
  .o_tx_async_hip_aib_fsr_in_bit1_rst_val                (r_tx_async_hip_aib_fsr_in_bit1_rst_val),
  .o_tx_async_hip_aib_fsr_in_bit2_rst_val                (r_tx_async_hip_aib_fsr_in_bit2_rst_val),
  .o_tx_async_hip_aib_fsr_in_bit3_rst_val                (r_tx_async_hip_aib_fsr_in_bit3_rst_val),
  .o_tx_async_pld_pmaif_mask_tx_pll_rst_val              (r_tx_async_pld_pmaif_mask_tx_pll_rst_val),
  .o_tx_async_hip_aib_fsr_out_bit0_rst_val               (r_tx_async_hip_aib_fsr_out_bit0_rst_val),
  .o_tx_async_hip_aib_fsr_out_bit1_rst_val               (r_tx_async_hip_aib_fsr_out_bit1_rst_val),
  .o_tx_async_hip_aib_fsr_out_bit2_rst_val               (r_tx_async_hip_aib_fsr_out_bit2_rst_val),
  .o_tx_async_hip_aib_fsr_out_bit3_rst_val               (r_tx_async_hip_aib_fsr_out_bit3_rst_val),
  .o_tx_fifo_rd_clk_sel                                  (r_tx_fifo_rd_clk_sel),
  .o_tx_fifo_wr_clk_scg_en                               (r_tx_fifo_wr_clk_scg_en),
  .o_tx_fifo_rd_clk_scg_en                               (r_tx_fifo_rd_clk_scg_en),
  .o_tx_osc_clk_scg_en                                   (r_tx_osc_clk_scg_en),
  .o_tx_free_run_div_clk                                 (r_tx_free_run_div_clk),
  .o_tx_hrdrst_rst_sm_dis                                (r_tx_hrdrst_rst_sm_dis),
  .o_tx_hrdrst_dcd_cal_done_bypass                       (r_tx_hrdrst_dcd_cal_done_bypass),
  .o_tx_hrdrst_dll_lock_bypass                           (r_tx_hrdrst_dll_lock_bypass),
  .o_tx_hrdrst_align_bypass                              (r_tx_hrdrst_align_bypass),
  .o_tx_hrdrst_user_ctl_en                               (r_tx_hrdrst_user_ctl_en),
  .o_tx_hrdrst_rx_osc_clk_scg_en                         (r_tx_hrdrst_rx_osc_clk_scg_en),
  .o_tx_hip_osc_clk_scg_en                               (r_tx_hip_osc_clk_scg_en),
  .o_rx_chnl_datapath_map_mode                           (r_rx_chnl_datapath_map_mode),
  .o_rx_pcs_testbus_sel                                  (r_rx_pcs_testbus_sel),
  .o_rx_fifo_empty                                       (r_rx_fifo_empty),
  .o_rx_fifo_mode                                        (r_rx_fifo_mode),
  .o_rx_wm_en                                            (r_rx_wm_en),
  .o_rx_fifo_full                                        (r_rx_fifo_full),
  .o_rx_phcomp_rd_delay                                  (r_rx_phcomp_rd_delay),
  .o_rx_double_write                                     (r_rx_double_write),
  .o_rx_stop_read                                        (r_rx_stop_read),
  .o_rx_stop_write                                       (r_rx_stop_write),
  .o_rx_fifo_pempty                                      (r_rx_fifo_pempty),
  .o_rx_fifo_power_mode                                  (r_rx_fifo_power_mode),
  .o_rx_fifo_pfull                                       (r_rx_fifo_pfull),
  .o_rx_stretch_num_stages                               (r_rx_stretch_num_stages),
  .o_rx_datapath_tb_sel                                  (r_rx_datapath_tb_sel),
  .o_rx_wr_adj_en                                        (r_rx_wr_adj_en),
  .o_rx_rd_adj_en                                        (r_rx_rd_adj_en),
  .o_rx_msb_rdptr_pipe_byp                               (r_rx_msb_rdptr_pipe_byp),
  .o_tx_dv_gating_en                                     (r_tx_dv_gating_en),
  .o_rx_adapter_lpbk_mode                                (r_rx_adapter_lpbk_mode),
  .o_rx_aib_lpbk_en                                      (r_rx_aib_lpbk_en),
  .o_tx_rev_lpbk                                         (r_tx_rev_lpbk),
  .o_rx_hrdrst_user_ctl_en                               (r_rx_hrdrst_user_ctl_en),
  .o_rx_usertest_sel                                     (r_rx_usertest_sel),
  .o_rx_pld_8g_a1a2_k1k2_flag_polling_bypass             (r_rx_pld_8g_a1a2_k1k2_flag_polling_bypass),
  .o_rx_10g_krfec_rx_diag_data_status_polling_bypass     (r_rx_10g_krfec_rx_diag_data_status_polling_bypass),
  .o_rx_pld_8g_wa_boundary_polling_bypass                (r_rx_pld_8g_wa_boundary_polling_bypass),
  .o_rx_pcspma_testbus_sel                               (r_rx_pcspma_testbus_sel),
  .o_rx_pld_pma_pcie_sw_done_polling_bypass              (r_rx_pld_pma_pcie_sw_done_polling_bypass),
  .o_rx_pld_pma_reser_in_polling_bypass                  (r_rx_pld_pma_reser_in_polling_bypass),
  .o_rx_pld_pma_testbus_polling_bypass                   (r_rx_pld_pma_testbus_polling_bypass),
  .o_rx_pld_test_data_polling_bypass                     (r_rx_pld_test_data_polling_bypass),
  .o_rx_async_pld_ltr_rst_val                            (r_rx_async_pld_ltr_rst_val),
  .o_rx_async_pld_pma_ltd_b_rst_val                      (r_rx_async_pld_pma_ltd_b_rst_val),
  .o_rx_async_pld_8g_signal_detect_out_rst_val           (r_rx_async_pld_8g_signal_detect_out_rst_val),
  .o_rx_async_pld_10g_rx_crc32_err_rst_val               (r_rx_async_pld_10g_rx_crc32_err_rst_val),
  .o_rx_async_pld_rx_fifo_align_clr_rst_val              (r_rx_async_pld_rx_fifo_align_clr_rst_val),
  .o_rx_async_hip_en                                     (r_rx_async_hip_en),
  .o_rx_parity_sel                                       (r_rx_parity_sel),
  .o_rx_internal_clk1_sel0                               (r_rx_internal_clk1_sel0),
  .o_rx_internal_clk1_sel1                               (r_rx_internal_clk1_sel1),
  .o_rx_internal_clk1_sel2                               (r_rx_internal_clk1_sel2),
  .o_rx_internal_clk1_sel3                               (r_rx_internal_clk1_sel3),
  .o_rx_txfiford_pre_ct_sel                              (r_rx_txfiford_pre_ct_sel),
  .o_rx_txfiford_post_ct_sel                             (r_rx_txfiford_post_ct_sel),
  .o_rx_txfifowr_post_ct_sel                             (r_rx_txfifowr_post_ct_sel),
  .o_rx_txfifowr_from_aib_sel                            (r_rx_txfifowr_from_aib_sel),
  .o_rx_pma_coreclkin_sel                                (r_rx_pma_coreclkin_sel),
  .o_rx_fifo_wr_clk_sel                                  (r_rx_fifo_wr_clk_sel),
  .o_rx_fifo_rd_clk_sel                                  (r_rx_fifo_rd_clk_sel),
  .o_rx_internal_clk1_sel                                (r_rx_internal_clk1_sel),
  .o_rx_internal_clk2_sel                                (r_rx_internal_clk2_sel),
  .o_rx_fifo_wr_clk_scg_en                               (r_rx_fifo_wr_clk_scg_en),
  .o_rx_fifo_rd_clk_scg_en                               (r_rx_fifo_rd_clk_scg_en),
  .o_rx_osc_clk_scg_en                                   (r_rx_osc_clk_scg_en),
  .o_rx_free_run_div_clk                                 (r_rx_free_run_div_clk),
  .o_rx_hrdrst_rst_sm_dis                                (r_rx_hrdrst_rst_sm_dis),
  .o_rx_hrdrst_dcd_cal_done_bypass                       (r_rx_hrdrst_dcd_cal_done_bypass),
  .o_rx_rmfflag_stretch_enable                           (r_rx_rmfflag_stretch_enable),
  .o_rx_rmfflag_stretch_num_stages                       (r_rx_rmfflag_stretch_num_stages),
  .o_rx_hrdrst_rx_osc_clk_scg_en                         (r_rx_hrdrst_rx_osc_clk_scg_en),
  .o_rx_internal_clk2_sel0                               (r_rx_internal_clk2_sel0),
  .o_rx_internal_clk2_sel1                               (r_rx_internal_clk2_sel1),
  .o_rx_internal_clk2_sel2                               (r_rx_internal_clk2_sel2),
  .o_rx_internal_clk2_sel3                               (r_rx_internal_clk2_sel3),
  .o_rx_rxfifowr_pre_ct_sel                              (r_rx_rxfifowr_pre_ct_sel),
  .o_rx_rxfifowr_post_ct_sel                             (r_rx_rxfifowr_post_ct_sel),
  .o_rx_rxfiford_post_ct_sel                             (r_rx_rxfiford_post_ct_sel),
  .o_rx_rxfiford_to_aib_sel                              (r_rx_rxfiford_to_aib_sel),
  .o_avmm2_osc_clk_scg_en                                (r_avmm2_osc_clk_scg_en),
  .o_sr_hip_en                                           (r_sr_hip_en),
  .o_sr_reserbits_in_en                                  (r_sr_reserbits_in_en),
  .o_sr_reserbits_out_en                                 (r_sr_reserbits_out_en),
  .o_sr_osc_clk_scg_en                                   (r_sr_osc_clk_scg_en),
  .o_sr_osc_clk_div_sel                                  (r_sr_osc_clk_div_sel),
  .o_sr_free_run_div_clk                                 (r_sr_free_run_div_clk),
  .o_sr_test_enable                                      (r_sr_test_enable),
  .o_sr_parity_en                                        (r_sr_parity_en),
  .o_aib_dprio_ctrl_0                                    (r_aib_dprio_ctrl_0),
  .o_aib_dprio_ctrl_1                                    (r_aib_dprio_ctrl_1),
  .o_aib_dprio_ctrl_2                                    (r_aib_dprio_ctrl_2),
  .o_aib_dprio_ctrl_3                                    (r_aib_dprio_ctrl_3),
  .o_aib_dprio_ctrl_4                                    (r_aib_dprio_ctrl_4),
  .o_avmm_hrdrst_osc_clk_scg_en                          (r_avmm_hrdrst_osc_clk_scg_en),
  .o_avmm_testbus_sel                                    (r_avmm_testbus_sel),
  .o_avmm1_osc_clk_scg_en                                (r_avmm1_osc_clk_scg_en),
  .o_avmm1_avmm_clk_scg_en                               (r_avmm1_avmm_clk_scg_en),
  .o_avmm1_avmm_clk_dcg_en                               (r_avmm1_avmm_clk_dcg_en),
  .o_avmm1_free_run_div_clk                              (r_avmm1_free_run_div_clk),
  .o_avmm1_rdfifo_full                                   (r_avmm1_rdfifo_full),
  .o_avmm1_rdfifo_stop_read                              (r_avmm1_rdfifo_stop_read),
  .o_avmm1_rdfifo_stop_write                             (r_avmm1_rdfifo_stop_write),
  .o_avmm1_rdfifo_empty                                  (r_avmm1_rdfifo_empty),
  .o_avmm1_use_rsvd_bit1                                 (r_avmm1_use_rsvd_bit1),
  .o_avmm2_avmm_clk_scg_en                               (r_avmm2_avmm_clk_scg_en),
  .o_avmm2_avmm_clk_dcg_en                               (r_avmm2_avmm_clk_dcg_en),
  .o_avmm2_free_run_div_clk                              (r_avmm2_free_run_div_clk),
  .o_avmm2_rdfifo_full                                   (r_avmm2_rdfifo_full),
  .o_avmm2_rdfifo_stop_read                              (r_avmm2_rdfifo_stop_read),
  .o_avmm2_rdfifo_stop_write                             (r_avmm2_rdfifo_stop_write),
  .o_avmm2_rdfifo_empty                                  (r_avmm2_rdfifo_empty),
  .o_rstctl_tx_elane_ovrval                              (r_rstctl_tx_elane_ovrval),
  .o_rstctl_tx_elane_ovren                               (r_rstctl_tx_elane_ovren),
  .o_rstctl_rx_elane_ovrval                              (r_rstctl_rx_elane_ovrval),
  .o_rstctl_rx_elane_ovren                               (r_rstctl_rx_elane_ovren),
  .o_rstctl_tx_xcvrif_ovrval                             (r_rstctl_tx_xcvrif_ovrval),
  .o_rstctl_tx_xcvrif_ovren                              (r_rstctl_tx_xcvrif_ovren),
  .o_rstctl_rx_xcvrif_ovrval                             (r_rstctl_rx_xcvrif_ovrval),
  .o_rstctl_rx_xcvrif_ovren                              (r_rstctl_rx_xcvrif_ovren),
  .o_rstctl_tx_adpt_ovrval                               (r_rstctl_tx_adpt_ovrval),
  .o_rstctl_tx_adpt_ovren                                (r_rstctl_tx_adpt_ovren),
  .o_rstctl_rx_adpt_ovrval                               (r_rstctl_rx_adpt_ovrval),
  .o_rstctl_rx_adpt_ovren                                (r_rstctl_rx_adpt_ovren),
  .o_rstctl_tx_pld_div2_rst_opt                          (r_rstctl_tx_pld_div2_rst_opt),
  .o_aib_csr_ctrl_0                                      (r_aib_csr_ctrl_0),
  .o_aib_csr_ctrl_1                                      (r_aib_csr_ctrl_1),
  .o_aib_csr_ctrl_2                                      (r_aib_csr_ctrl_2),
  .o_aib_csr_ctrl_3                                      (r_aib_csr_ctrl_3),
  .o_aib_csr_ctrl_4                                      (r_aib_csr_ctrl_4),
  .o_aib_csr_ctrl_5                                      (r_aib_csr_ctrl_5),
  .o_aib_csr_ctrl_6                                      (r_aib_csr_ctrl_6),
  .o_aib_csr_ctrl_7                                      (r_aib_csr_ctrl_7),
  .o_aib_csr_ctrl_8                                      (r_aib_csr_ctrl_8),
  .o_aib_csr_ctrl_9                                      (r_aib_csr_ctrl_9),
  .o_aib_csr_ctrl_10                                     (r_aib_csr_ctrl_10),
  .o_aib_csr_ctrl_11                                     (r_aib_csr_ctrl_11),
  .o_aib_csr_ctrl_12                                     (r_aib_csr_ctrl_12),
  .o_aib_csr_ctrl_13                                     (r_aib_csr_ctrl_13),
  .o_aib_csr_ctrl_14                                     (r_aib_csr_ctrl_14),
  .o_aib_csr_ctrl_15                                     (r_aib_csr_ctrl_15),
  .o_aib_csr_ctrl_16                                     (r_aib_csr_ctrl_16),
  .o_aib_csr_ctrl_17                                     (r_aib_csr_ctrl_17),
  .o_aib_csr_ctrl_18                                     (r_aib_csr_ctrl_18),
  .o_aib_csr_ctrl_19                                     (r_aib_csr_ctrl_19),
  .o_aib_csr_ctrl_20                                     (r_aib_csr_ctrl_20),
  .o_aib_csr_ctrl_21                                     (r_aib_csr_ctrl_21),
  .o_aib_csr_ctrl_22                                     (r_aib_csr_ctrl_22),
  .o_aib_csr_ctrl_23                                     (r_aib_csr_ctrl_23),
  .o_aib_csr_ctrl_24                                     (r_aib_csr_ctrl_24),
  .o_aib_csr_ctrl_25                                     (r_aib_csr_ctrl_25),
  .o_aib_csr_ctrl_26                                     (r_aib_csr_ctrl_26),
  .o_aib_csr_ctrl_27                                     (r_aib_csr_ctrl_27),
  .o_aib_csr_ctrl_28                                     (r_aib_csr_ctrl_28),
  .o_aib_csr_ctrl_29                                     (r_aib_csr_ctrl_29),
  .o_aib_csr_ctrl_30                                     (r_aib_csr_ctrl_30),
  .o_aib_csr_ctrl_31                                     (r_aib_csr_ctrl_31),
  .o_aib_csr_ctrl_32                                     (r_aib_csr_ctrl_32),
  .o_aib_csr_ctrl_33                                     (r_aib_csr_ctrl_33),
  .o_aib_csr_ctrl_34                                     (r_aib_csr_ctrl_34),
  .o_aib_csr_ctrl_35                                     (r_aib_csr_ctrl_35),
  .o_aib_csr_ctrl_36                                     (r_aib_csr_ctrl_36),
  .o_aib_csr_ctrl_37                                     (r_aib_csr_ctrl_37),
  .o_aib_csr_ctrl_38                                     (r_aib_csr_ctrl_38),
  .o_aib_csr_ctrl_39                                     (r_aib_csr_ctrl_39),
  .o_aib_csr_ctrl_40                                     (r_aib_csr_ctrl_40),
  .o_aib_csr_ctrl_41                                     (r_aib_csr_ctrl_41),
  .o_aib_csr_ctrl_42                                     (r_aib_csr_ctrl_42),
  .o_aib_csr_ctrl_43                                     (r_aib_csr_ctrl_43),
  .o_aib_csr_ctrl_44                                     (r_aib_csr_ctrl_44),
  .o_aib_csr_ctrl_45                                     (r_aib_csr_ctrl_45),
  .o_aib_csr_ctrl_46                                     (r_aib_csr_ctrl_46),
  .o_aib_csr_ctrl_47                                     (r_aib_csr_ctrl_47),
  .o_aib_csr_ctrl_48                                     (r_aib_csr_ctrl_48),
  .o_aib_csr_ctrl_49                                     (r_aib_csr_ctrl_49),
  .o_aib_csr_ctrl_50                                     (r_aib_csr_ctrl_50),
  .o_aib_csr_ctrl_51                                     (r_aib_csr_ctrl_51),
  .o_aib_csr_ctrl_52                                     (r_aib_csr_ctrl_52),
  .o_aib_csr_ctrl_53                                     (r_aib_csr_ctrl_53),
  // Input
  .scan_mode_n                                           (scan_mode_n),
  .r_ifctl_hwcfg_aib_en                                  (r_ifctl_hwcfg_aib_en),
  .r_ifctl_hwcfg_adpt_en                                 (r_ifctl_hwcfg_adpt_en),
  .r_ifctl_hwcfg_mode                                    (r_ifctl_hwcfg_mode),
  .i_ifctl_usr_active                                    (w_ifctl_usr_active),
  .i_tx_chnl_datapath_map_mode                           (w_tx_chnl_datapath_map_mode),
  .i_tx_usertest_sel                                     (w_tx_usertest_sel),
  .i_tx_latency_src_xcvrif                               (w_tx_latency_src_xcvrif),
  .i_tx_fifo_empty                                       (w_tx_fifo_empty),
  .i_tx_fifo_full                                        (w_tx_fifo_full),
  .i_tx_phcomp_rd_delay                                  (w_tx_phcomp_rd_delay),
  .i_tx_double_read                                      (w_tx_double_read),
  .i_tx_stop_read                                        (w_tx_stop_read),
  .i_tx_stop_write                                       (w_tx_stop_write),
  .i_tx_fifo_pempty                                      (w_tx_fifo_pempty),
  .i_tx_fifo_pfull                                       (w_tx_fifo_pfull),
  .i_tx_wa_en                                            (w_tx_wa_en),
  .i_tx_fifo_power_mode                                  (w_tx_fifo_power_mode),
  .i_tx_stretch_num_stages                               (w_tx_stretch_num_stages),
  .i_tx_datapath_tb_sel                                  (w_tx_datapath_tb_sel),
  .i_tx_wr_adj_en                                        (w_tx_wr_adj_en),
  .i_tx_rd_adj_en                                        (w_tx_rd_adj_en),
  .i_tx_async_pld_txelecidle_rst_val                     (w_tx_async_pld_txelecidle_rst_val),
  .i_tx_async_hip_aib_fsr_in_bit0_rst_val                (w_tx_async_hip_aib_fsr_in_bit0_rst_val),
  .i_tx_async_hip_aib_fsr_in_bit1_rst_val                (w_tx_async_hip_aib_fsr_in_bit1_rst_val),
  .i_tx_async_hip_aib_fsr_in_bit2_rst_val                (w_tx_async_hip_aib_fsr_in_bit2_rst_val),
  .i_tx_async_hip_aib_fsr_in_bit3_rst_val                (w_tx_async_hip_aib_fsr_in_bit3_rst_val),
  .i_tx_async_pld_pmaif_mask_tx_pll_rst_val              (w_tx_async_pld_pmaif_mask_tx_pll_rst_val),
  .i_tx_async_hip_aib_fsr_out_bit0_rst_val               (w_tx_async_hip_aib_fsr_out_bit0_rst_val),
  .i_tx_async_hip_aib_fsr_out_bit1_rst_val               (w_tx_async_hip_aib_fsr_out_bit1_rst_val),
  .i_tx_async_hip_aib_fsr_out_bit2_rst_val               (w_tx_async_hip_aib_fsr_out_bit2_rst_val),
  .i_tx_async_hip_aib_fsr_out_bit3_rst_val               (w_tx_async_hip_aib_fsr_out_bit3_rst_val),
  .i_tx_fifo_rd_clk_sel                                  (w_tx_fifo_rd_clk_sel),
  .i_tx_fifo_wr_clk_scg_en                               (w_tx_fifo_wr_clk_scg_en),
  .i_tx_fifo_rd_clk_scg_en                               (w_tx_fifo_rd_clk_scg_en),
  .i_tx_osc_clk_scg_en                                   (w_tx_osc_clk_scg_en),
  .i_tx_free_run_div_clk                                 (w_tx_free_run_div_clk),
  .i_tx_hrdrst_rst_sm_dis                                (w_tx_hrdrst_rst_sm_dis),
  .i_tx_hrdrst_dcd_cal_done_bypass                       (w_tx_hrdrst_dcd_cal_done_bypass),
  .i_tx_hrdrst_dll_lock_bypass                           (w_tx_hrdrst_dll_lock_bypass),
  .i_tx_hrdrst_align_bypass                              (w_tx_hrdrst_align_bypass),
  .i_tx_hrdrst_user_ctl_en                               (w_tx_hrdrst_user_ctl_en),
  .i_tx_hrdrst_rx_osc_clk_scg_en                         (w_tx_hrdrst_rx_osc_clk_scg_en),
  .i_tx_hip_osc_clk_scg_en                               (w_tx_hip_osc_clk_scg_en),
  .i_rx_chnl_datapath_map_mode                           (w_rx_chnl_datapath_map_mode),
  .i_rx_pcs_testbus_sel                                  (w_rx_pcs_testbus_sel),
  .i_rx_fifo_empty                                       (w_rx_fifo_empty),
  .i_rx_fifo_mode                                        (w_rx_fifo_mode),
  .i_rx_wm_en                                            (w_rx_wm_en),
  .i_rx_fifo_full                                        (w_rx_fifo_full),
  .i_rx_phcomp_rd_delay                                  (w_rx_phcomp_rd_delay),
  .i_rx_double_write                                     (w_rx_double_write),
  .i_rx_stop_read                                        (w_rx_stop_read),
  .i_rx_stop_write                                       (w_rx_stop_write),
  .i_rx_fifo_pempty                                      (w_rx_fifo_pempty),
  .i_rx_fifo_power_mode                                  (w_rx_fifo_power_mode),
  .i_rx_fifo_pfull                                       (w_rx_fifo_pfull),
  .i_rx_stretch_num_stages                               (w_rx_stretch_num_stages),
  .i_rx_datapath_tb_sel                                  (w_rx_datapath_tb_sel),
  .i_rx_wr_adj_en                                        (w_rx_wr_adj_en),
  .i_rx_rd_adj_en                                        (w_rx_rd_adj_en),
  .i_rx_msb_rdptr_pipe_byp                               (w_rx_msb_rdptr_pipe_byp),
  .i_tx_dv_gating_en                                     (w_tx_dv_gating_en),
  .i_rx_adapter_lpbk_mode                                (w_rx_adapter_lpbk_mode),
  .i_rx_aib_lpbk_en                                      (w_rx_aib_lpbk_en),
  .i_tx_rev_lpbk                                         (w_tx_rev_lpbk),
  .i_rx_hrdrst_user_ctl_en                               (w_rx_hrdrst_user_ctl_en),
  .i_rx_usertest_sel                                     (w_rx_usertest_sel),
  .i_rx_pld_8g_a1a2_k1k2_flag_polling_bypass             (w_rx_pld_8g_a1a2_k1k2_flag_polling_bypass),
  .i_rx_10g_krfec_rx_diag_data_status_polling_bypass     (w_rx_10g_krfec_rx_diag_data_status_polling_bypass),
  .i_rx_pld_8g_wa_boundary_polling_bypass                (w_rx_pld_8g_wa_boundary_polling_bypass),
  .i_rx_pcspma_testbus_sel                               (w_rx_pcspma_testbus_sel),
  .i_rx_pld_pma_pcie_sw_done_polling_bypass              (w_rx_pld_pma_pcie_sw_done_polling_bypass),
  .i_rx_pld_pma_reser_in_polling_bypass                  (w_rx_pld_pma_reser_in_polling_bypass),
  .i_rx_pld_pma_testbus_polling_bypass                   (w_rx_pld_pma_testbus_polling_bypass),
  .i_rx_pld_test_data_polling_bypass                     (w_rx_pld_test_data_polling_bypass),
  .i_rx_async_pld_ltr_rst_val                            (w_rx_async_pld_ltr_rst_val),
  .i_rx_async_pld_pma_ltd_b_rst_val                      (w_rx_async_pld_pma_ltd_b_rst_val),
  .i_rx_async_pld_8g_signal_detect_out_rst_val           (w_rx_async_pld_8g_signal_detect_out_rst_val),
  .i_rx_async_pld_10g_rx_crc32_err_rst_val               (w_rx_async_pld_10g_rx_crc32_err_rst_val),
  .i_rx_async_pld_rx_fifo_align_clr_rst_val              (w_rx_async_pld_rx_fifo_align_clr_rst_val),
  .i_rx_async_hip_en                                     (w_rx_async_hip_en),
  .i_rx_parity_sel                                       (w_rx_parity_sel),
  .i_rx_internal_clk1_sel0                               (w_rx_internal_clk1_sel0),
  .i_rx_internal_clk1_sel1                               (w_rx_internal_clk1_sel1),
  .i_rx_internal_clk1_sel2                               (w_rx_internal_clk1_sel2),
  .i_rx_internal_clk1_sel3                               (w_rx_internal_clk1_sel3),
  .i_rx_txfiford_pre_ct_sel                              (w_rx_txfiford_pre_ct_sel),
  .i_rx_txfiford_post_ct_sel                             (w_rx_txfiford_post_ct_sel),
  .i_rx_txfifowr_post_ct_sel                             (w_rx_txfifowr_post_ct_sel),
  .i_rx_txfifowr_from_aib_sel                            (w_rx_txfifowr_from_aib_sel),
  .i_rx_pma_coreclkin_sel                                (w_rx_pma_coreclkin_sel),
  .i_rx_fifo_wr_clk_sel                                  (w_rx_fifo_wr_clk_sel),
  .i_rx_fifo_rd_clk_sel                                  (w_rx_fifo_rd_clk_sel),
  .i_rx_internal_clk1_sel                                (w_rx_internal_clk1_sel),
  .i_rx_internal_clk2_sel                                (w_rx_internal_clk2_sel),
  .i_rx_fifo_wr_clk_scg_en                               (w_rx_fifo_wr_clk_scg_en),
  .i_rx_fifo_rd_clk_scg_en                               (w_rx_fifo_rd_clk_scg_en),
  .i_rx_osc_clk_scg_en                                   (w_rx_osc_clk_scg_en),
  .i_rx_free_run_div_clk                                 (w_rx_free_run_div_clk),
  .i_rx_hrdrst_rst_sm_dis                                (w_rx_hrdrst_rst_sm_dis),
  .i_rx_hrdrst_dcd_cal_done_bypass                       (w_rx_hrdrst_dcd_cal_done_bypass),
  .i_rx_rmfflag_stretch_enable                           (w_rx_rmfflag_stretch_enable),
  .i_rx_rmfflag_stretch_num_stages                       (w_rx_rmfflag_stretch_num_stages),
  .i_rx_hrdrst_rx_osc_clk_scg_en                         (w_rx_hrdrst_rx_osc_clk_scg_en),
  .i_rx_internal_clk2_sel0                               (w_rx_internal_clk2_sel0),
  .i_rx_internal_clk2_sel1                               (w_rx_internal_clk2_sel1),
  .i_rx_internal_clk2_sel2                               (w_rx_internal_clk2_sel2),
  .i_rx_internal_clk2_sel3                               (w_rx_internal_clk2_sel3),
  .i_rx_rxfifowr_pre_ct_sel                              (w_rx_rxfifowr_pre_ct_sel),
  .i_rx_rxfifowr_post_ct_sel                             (w_rx_rxfifowr_post_ct_sel),
  .i_rx_rxfiford_post_ct_sel                             (w_rx_rxfiford_post_ct_sel),
  .i_rx_rxfiford_to_aib_sel                              (w_rx_rxfiford_to_aib_sel),
  .i_avmm2_osc_clk_scg_en                                (w_avmm2_osc_clk_scg_en),
  .i_sr_hip_en                                           (w_sr_hip_en),
  .i_sr_reserbits_in_en                                  (w_sr_reserbits_in_en),
  .i_sr_reserbits_out_en                                 (w_sr_reserbits_out_en),
  .i_sr_osc_clk_scg_en                                   (w_sr_osc_clk_scg_en),
  .i_sr_osc_clk_div_sel                                  (w_sr_osc_clk_div_sel),
  .i_sr_free_run_div_clk                                 (w_sr_free_run_div_clk),
  .i_sr_test_enable                                      (w_sr_test_enable),
  .i_sr_parity_en                                        (w_sr_parity_en),
  .i_aib_dprio_ctrl_0                                    (w_aib_dprio_ctrl_0),
  .i_aib_dprio_ctrl_1                                    (w_aib_dprio_ctrl_1),
  .i_aib_dprio_ctrl_2                                    (w_aib_dprio_ctrl_2),
  .i_aib_dprio_ctrl_3                                    (w_aib_dprio_ctrl_3),
  .i_aib_dprio_ctrl_4                                    (w_aib_dprio_ctrl_4),
  .i_avmm_hrdrst_osc_clk_scg_en                          (w_avmm_hrdrst_osc_clk_scg_en),
  .i_avmm_testbus_sel                                    (w_avmm_testbus_sel),
  .i_avmm1_osc_clk_scg_en                                (w_avmm1_osc_clk_scg_en),
  .i_avmm1_avmm_clk_scg_en                               (w_avmm1_avmm_clk_scg_en),
  .i_avmm1_avmm_clk_dcg_en                               (w_avmm1_avmm_clk_dcg_en),
  .i_avmm1_free_run_div_clk                              (w_avmm1_free_run_div_clk),
  .i_avmm1_rdfifo_full                                   (w_avmm1_rdfifo_full),
  .i_avmm1_rdfifo_stop_read                              (w_avmm1_rdfifo_stop_read),
  .i_avmm1_rdfifo_stop_write                             (w_avmm1_rdfifo_stop_write),
  .i_avmm1_rdfifo_empty                                  (w_avmm1_rdfifo_empty),
  .i_avmm1_use_rsvd_bit1                                 (w_avmm1_use_rsvd_bit1),
  .i_avmm2_avmm_clk_scg_en                               (w_avmm2_avmm_clk_scg_en),
  .i_avmm2_avmm_clk_dcg_en                               (w_avmm2_avmm_clk_dcg_en),
  .i_avmm2_free_run_div_clk                              (w_avmm2_free_run_div_clk),
  .i_avmm2_rdfifo_full                                   (w_avmm2_rdfifo_full),
  .i_avmm2_rdfifo_stop_read                              (w_avmm2_rdfifo_stop_read),
  .i_avmm2_rdfifo_stop_write                             (w_avmm2_rdfifo_stop_write),
  .i_avmm2_rdfifo_empty                                  (w_avmm2_rdfifo_empty),
  .i_rstctl_tx_elane_ovrval                              (w_rstctl_tx_elane_ovrval),
  .i_rstctl_tx_elane_ovren                               (w_rstctl_tx_elane_ovren),
  .i_rstctl_rx_elane_ovrval                              (w_rstctl_rx_elane_ovrval),
  .i_rstctl_rx_elane_ovren                               (w_rstctl_rx_elane_ovren),
  .i_rstctl_tx_xcvrif_ovrval                             (w_rstctl_tx_xcvrif_ovrval),
  .i_rstctl_tx_xcvrif_ovren                              (w_rstctl_tx_xcvrif_ovren),
  .i_rstctl_rx_xcvrif_ovrval                             (w_rstctl_rx_xcvrif_ovrval),
  .i_rstctl_rx_xcvrif_ovren                              (w_rstctl_rx_xcvrif_ovren),
  .i_rstctl_tx_adpt_ovrval                               (w_rstctl_tx_adpt_ovrval),
  .i_rstctl_tx_adpt_ovren                                (w_rstctl_tx_adpt_ovren),
  .i_rstctl_rx_adpt_ovrval                               (w_rstctl_rx_adpt_ovrval),
  .i_rstctl_rx_adpt_ovren                                (w_rstctl_rx_adpt_ovren),
  .i_rstctl_tx_pld_div2_rst_opt                          (w_rstctl_tx_pld_div2_rst_opt),
  .i_aib_csr_ctrl_0                                      (w_aib_csr_ctrl_0),
  .i_aib_csr_ctrl_1                                      (w_aib_csr_ctrl_1),
  .i_aib_csr_ctrl_2                                      (w_aib_csr_ctrl_2),
  .i_aib_csr_ctrl_3                                      (w_aib_csr_ctrl_3),
  .i_aib_csr_ctrl_4                                      (w_aib_csr_ctrl_4),
  .i_aib_csr_ctrl_5                                      (w_aib_csr_ctrl_5),
  .i_aib_csr_ctrl_6                                      (w_aib_csr_ctrl_6),
  .i_aib_csr_ctrl_7                                      (w_aib_csr_ctrl_7),
  .i_aib_csr_ctrl_8                                      (w_aib_csr_ctrl_8),
  .i_aib_csr_ctrl_9                                      (w_aib_csr_ctrl_9),
  .i_aib_csr_ctrl_10                                     (w_aib_csr_ctrl_10),
  .i_aib_csr_ctrl_11                                     (w_aib_csr_ctrl_11),
  .i_aib_csr_ctrl_12                                     (w_aib_csr_ctrl_12),
  .i_aib_csr_ctrl_13                                     (w_aib_csr_ctrl_13),
  .i_aib_csr_ctrl_14                                     (w_aib_csr_ctrl_14),
  .i_aib_csr_ctrl_15                                     (w_aib_csr_ctrl_15),
  .i_aib_csr_ctrl_16                                     (w_aib_csr_ctrl_16),
  .i_aib_csr_ctrl_17                                     (w_aib_csr_ctrl_17),
  .i_aib_csr_ctrl_18                                     (w_aib_csr_ctrl_18),
  .i_aib_csr_ctrl_19                                     (w_aib_csr_ctrl_19),
  .i_aib_csr_ctrl_20                                     (w_aib_csr_ctrl_20),
  .i_aib_csr_ctrl_21                                     (w_aib_csr_ctrl_21),
  .i_aib_csr_ctrl_22                                     (w_aib_csr_ctrl_22),
  .i_aib_csr_ctrl_23                                     (w_aib_csr_ctrl_23),
  .i_aib_csr_ctrl_24                                     (w_aib_csr_ctrl_24),
  .i_aib_csr_ctrl_25                                     (w_aib_csr_ctrl_25),
  .i_aib_csr_ctrl_26                                     (w_aib_csr_ctrl_26),
  .i_aib_csr_ctrl_27                                     (w_aib_csr_ctrl_27),
  .i_aib_csr_ctrl_28                                     (w_aib_csr_ctrl_28),
  .i_aib_csr_ctrl_29                                     (w_aib_csr_ctrl_29),
  .i_aib_csr_ctrl_30                                     (w_aib_csr_ctrl_30),
  .i_aib_csr_ctrl_31                                     (w_aib_csr_ctrl_31),
  .i_aib_csr_ctrl_32                                     (w_aib_csr_ctrl_32),
  .i_aib_csr_ctrl_33                                     (w_aib_csr_ctrl_33),
  .i_aib_csr_ctrl_34                                     (w_aib_csr_ctrl_34),
  .i_aib_csr_ctrl_35                                     (w_aib_csr_ctrl_35),
  .i_aib_csr_ctrl_36                                     (w_aib_csr_ctrl_36),
  .i_aib_csr_ctrl_37                                     (w_aib_csr_ctrl_37),
  .i_aib_csr_ctrl_38                                     (w_aib_csr_ctrl_38),
  .i_aib_csr_ctrl_39                                     (w_aib_csr_ctrl_39),
  .i_aib_csr_ctrl_40                                     (w_aib_csr_ctrl10_4x[0 +:8]),
  .i_aib_csr_ctrl_41                                     (w_aib_csr_ctrl10_4x[8 +:8]),
  .i_aib_csr_ctrl_42                                     (w_aib_csr_ctrl10_4x[16+:8]),
  .i_aib_csr_ctrl_43                                     (w_aib_csr_ctrl10_4x[24+:8]),
  .i_aib_csr_ctrl_44                                     (w_aib_csr_ctrl11_4x[0 +:8]),
  .i_aib_csr_ctrl_45                                     (w_aib_csr_ctrl11_4x[8 +:8]),
  .i_aib_csr_ctrl_46                                     (w_aib_csr_ctrl11_4x[16+:8]),
  .i_aib_csr_ctrl_47                                     (w_aib_csr_ctrl11_4x[24+:8]),
  .i_aib_csr_ctrl_48                                     (w_aib_csr_ctrl12_4x[0 +:8]),
  .i_aib_csr_ctrl_49                                     (w_aib_csr_ctrl12_4x[8 +:8]),
  .i_aib_csr_ctrl_50                                     (w_aib_csr_ctrl12_4x[16+:8]),
  .i_aib_csr_ctrl_51                                     (w_aib_csr_ctrl12_4x[24+:8]),
  .i_aib_csr_ctrl_52                                     (w_aib_csr_ctrl13_5x[0 +:8]),
  .i_aib_csr_ctrl_53                                     (w_aib_csr_ctrl13_5x[8 +:8])
  );

// Configuration registers for Adapter and AIBIO
assign cfg_only_id_match = (cfg_avmm_addr_id[5:0]      == cfg_avmm_addr[16:11]) |
                           ((r_ifctl_mcast_addr[5:0]   == cfg_avmm_addr[16:11]) & r_ifctl_mcast_en);

assign cfg_only_addr_match = (cfg_avmm_addr[10:0] >= ND_AIB_BASE) & (cfg_avmm_addr[10:0] < C3_EHIP_BASE) & cfg_only_id_match;
assign cfg_only_write      = cfg_only_addr_match & cfg_avmm_write;
assign cfg_only_read       = cfg_only_addr_match & cfg_avmm_read;

c3_avmm_rdl_intf #( .AVMM_ADDR_WIDTH(8), .RDL_ADDR_WIDTH (7)) 
  adapt_cfg_rdl_intf (
   .avmm_clk            (cfg_avmm_clk),        // input   logic  // AVMM Slave interface
   .avmm_rst_n          (cfg_avmm_rst_n),      // input   logic                         
   .i_avmm_write        (cfg_only_write),      // input   logic                         
   .i_avmm_read         (cfg_only_read),       // input   logic                         
   .i_avmm_addr         (cfg_avmm_addr[7:0]),  // input   logic  [AVMM_ADDR_WIDTH-1:0]  
   .i_avmm_wdata        (cfg_avmm_wdata),      // input   logic  [31:0]                 
   .i_avmm_byte_en      (cfg_avmm_byte_en),    // input   logic  [3:0]                  
   .o_avmm_rdata        (cfg_only_rdata),      // output  logic  [31:0]                 
   .o_avmm_rdatavalid   (cfg_only_rdatavld),   // output  logic                         
   .o_avmm_waitrequest  (cfg_only_waitreq),    // output  logic                         
   .clk                 (cfg_csr_clk),         // output  logic  // RDL-generated memory map interface
   .reset               (cfg_csr_reset),       // output  logic                         
   .writedata           (cfg_csr_wdata),       // output  logic  [31:0]                 
   .read                (cfg_csr_read),        // output  logic                         
   .write               (cfg_csr_write),       // output  logic                         
   .byteenable          (cfg_csr_byteen),      // output  logic  [3:0]                  
   .readdata            (cfg_csr_rdata),       // input   logic  [31:0]                 
   .readdatavalid       (cfg_csr_rdatavld),    // input   logic                         
   .address             (cfg_csr_addr)         // output  logic  [RDL_ADDR_WIDTH-1:0]   
);

// Manual decoding of inbox and outbox to generate clear-on-read signal
assign cfg_inbox_read_en   = (cfg_csr_addr == CFG_INBOX_ADDR) & cfg_csr_read & cfg_csr_rdatavld;

// send_message from usr to cfg
c3lib_vecsync_handshake #(
  .DWIDTH            (30),
  .RESET_VAL         (0),
  .DST_CLK_FREQ_MHZ  (300),
  .SRC_CLK_FREQ_MHZ (100)) 

  send_usr_msg_sync (
    .wr_clk             (adpt_avmm_clk),          // write clock... gf_clkmux of cfg_avmm_clk and usr_avmm_clk
    .wr_rst_n           (adpt_avmm_rst_n),        // async reset for write clock domain. If cfg_rst_n is asserted, hard_rst_n must be asserted
    .data_in            (r_usr_outbox_usr_msg),   // data in on write clock domain
    .load_data_in       (r_usr_outbox_send_msg),  // data valid
    .data_in_rdy2ld     (usr_outbox_send_busy),   // pulse indicating data has been captured

    .rd_clk             (cfg_avmm_clk),           // read clock
    .rd_rst_n           (cfg_avmm_rst_n),         // async reset for read clock domain
    .data_out           (usr2cfg_msg),            // data out
    .data_out_vld       (cfg_dout_vld),           // data valid
    .ack_data_out       (cfg_dout_vld_d0));          // level signal indicating data has been captured

always @(posedge adpt_avmm_clk or negedge adpt_avmm_rst_n) begin
  if (!adpt_avmm_rst_n) begin
    usr_outbox_send_busy_d0 <= 1'b1;
  end
  else begin
    usr_outbox_send_busy_d0 <= usr_outbox_send_busy;
  end
end

always @(posedge cfg_avmm_clk or negedge cfg_avmm_rst_n) begin
  if (!cfg_avmm_rst_n) begin
    cfg_dout_vld_d0        <= 1'b0;
  end
  else begin
    cfg_dout_vld_d0        <= cfg_dout_vld;
  end
end

assign load_cfg_msg = cfg_dout_vld & (~cfg_dout_vld_d0);
assign cfg_autoclear_en = ~r_cfg_inbox_autoclear_dis;

assign r_cfg_inbox_cfg_msg_i   = load_cfg_msg           ? usr2cfg_msg : r_cfg_inbox_cfg_msg;
assign r_cfg_outbox_send_msg_i = cfg_outbox_send_busy_d0 ? r_cfg_outbox_send_msg : 1'b0;

assign r_cfg_inbox_new_msg_i   = load_cfg_msg                           ? 1'b1 :
                                 (cfg_inbox_read_en & cfg_autoclear_en) ? 1'b0 : r_cfg_inbox_new_msg; 

c3aibadapt_cfg_csr adapt_cfg_csr (
  .r_cfg_outbox_cfg_msg              (r_cfg_outbox_cfg_msg),
  .r_cfg_outbox_send_msg             (r_cfg_outbox_send_msg),
  .r_cfg_inbox_cfg_msg               (r_cfg_inbox_cfg_msg),
  .r_cfg_inbox_autoclear_dis         (r_cfg_inbox_autoclear_dis),
  .r_cfg_inbox_new_msg               (r_cfg_inbox_new_msg),
  .r_cfg_inbox_cfg_msg_i             (r_cfg_inbox_cfg_msg_i),
  .r_cfg_outbox_send_msg_i           (r_cfg_outbox_send_msg_i),
  .r_cfg_inbox_new_msg_i             (r_cfg_inbox_new_msg_i),
  .r_ifctl_usr_active                (w_ifctl_usr_active),
  .r_ifctl_mcast_addr                (r_ifctl_mcast_addr),
  .r_ifctl_mcast_en                  (r_ifctl_mcast_en),
  .r_ifctl_hwcfg_mode                (r_ifctl_hwcfg_mode),
  .r_ifctl_hwcfg_adpt_en             (r_ifctl_hwcfg_adpt_en),
  .r_ifctl_hwcfg_aib_en              (r_ifctl_hwcfg_aib_en),
  .r_rstctl_tx_elane_ovrval          (w_rstctl_tx_elane_ovrval),
  .r_rstctl_tx_elane_ovren           (w_rstctl_tx_elane_ovren),
  .r_rstctl_rx_elane_ovrval          (w_rstctl_rx_elane_ovrval),
  .r_rstctl_rx_elane_ovren           (w_rstctl_rx_elane_ovren),
  .r_rstctl_tx_xcvrif_ovrval         (w_rstctl_tx_xcvrif_ovrval),
  .r_rstctl_tx_xcvrif_ovren          (w_rstctl_tx_xcvrif_ovren),
  .r_rstctl_rx_xcvrif_ovrval         (w_rstctl_rx_xcvrif_ovrval),
  .r_rstctl_rx_xcvrif_ovren          (w_rstctl_rx_xcvrif_ovren),
  .r_rstctl_tx_adpt_ovrval           (w_rstctl_tx_adpt_ovrval),
  .r_rstctl_tx_adpt_ovren            (w_rstctl_tx_adpt_ovren),
  .r_rstctl_rx_adpt_ovrval           (w_rstctl_rx_adpt_ovrval),
  .r_rstctl_rx_adpt_ovren            (w_rstctl_rx_adpt_ovren),
  .r_rstctl_tx_pld_div2_rst_opt      (w_rstctl_tx_pld_div2_rst_opt),
  .r_avmm_testbus_sel                (w_avmm_testbus_sel),
  .r_avmm_hrdrst_osc_clk_scg_en      (w_avmm_hrdrst_osc_clk_scg_en),
  .r_avmm_spare_rsvd                 (w_avmm_spare_rsvd),
  .r_avmm_spare_rsvd_prst            (w_avmm_spare_rsvd_prst),
  .r_sr_hip_en                       (w_sr_hip_en),
  .r_sr_reserbits_in_en              (w_sr_reserbits_in_en),
  .r_sr_reserbits_out_en             (w_sr_reserbits_out_en),
  .r_sr_parity_en                    (w_sr_parity_en),
  .r_sr_osc_clk_scg_en               (w_sr_osc_clk_scg_en),
  .r_sr_osc_clk_div_sel              (w_sr_osc_clk_div_sel),
  .r_sr_free_run_div_clk             (w_sr_free_run_div_clk),
  .r_avmm1_sr_test_enable            (w_sr_test_enable),
  .r_avmm1_osc_clk_scg_en            (w_avmm1_osc_clk_scg_en),
  .r_avmm1_avmm_clk_scg_en           (w_avmm1_avmm_clk_scg_en),
  .r_avmm1_avmm_clk_dcg_en           (w_avmm1_avmm_clk_dcg_en),
  .r_avmm1_free_run_div_clk          (w_avmm1_free_run_div_clk),
  .r_avmm1_rdfifo_full               (w_avmm1_rdfifo_full),
  .r_avmm1_rdfifo_stop_read          (w_avmm1_rdfifo_stop_read),
  .r_avmm1_rdfifo_stop_write         (w_avmm1_rdfifo_stop_write),
  .r_avmm1_rdfifo_empty              (w_avmm1_rdfifo_empty),
  .r_avmm1_use_rsvd_bit1             (w_avmm1_use_rsvd_bit1),
  .r_avmm2_osc_clk_scg_en            (w_avmm2_osc_clk_scg_en),
  .r_avmm2_avmm_clk_scg_en           (w_avmm2_avmm_clk_scg_en),
  .r_avmm2_avmm_clk_dcg_en           (w_avmm2_avmm_clk_dcg_en),
  .r_avmm2_free_run_div_clk          (w_avmm2_free_run_div_clk),
  .r_avmm2_rdfifo_full               (w_avmm2_rdfifo_full),
  .r_avmm2_rdfifo_stop_read          (w_avmm2_rdfifo_stop_read),
  .r_avmm2_rdfifo_stop_write         (w_avmm2_rdfifo_stop_write),
  .r_avmm2_rdfifo_empty              (w_avmm2_rdfifo_empty),
  .r_aib_csr0_aib_csr0_ctrl_0        (w_aib_csr_ctrl_0),
  .r_aib_csr0_aib_csr0_ctrl_1        (w_aib_csr_ctrl_1),
  .r_aib_csr0_aib_csr0_ctrl_2        (w_aib_csr_ctrl_2),
  .r_aib_csr0_aib_csr0_ctrl_3        (w_aib_csr_ctrl_3),
  .r_aib_csr1_aib_csr1_ctrl_4        (w_aib_csr_ctrl_4),
  .r_aib_csr1_aib_csr1_ctrl_5        (w_aib_csr_ctrl_5),
  .r_aib_csr1_aib_csr1_ctrl_6        (w_aib_csr_ctrl_6),
  .r_aib_csr1_aib_csr1_ctrl_7        (w_aib_csr_ctrl_7),
  .r_aib_csr2_aib_csr2_ctrl_8        (w_aib_csr_ctrl_8),
  .r_aib_csr2_aib_csr2_ctrl_9        (w_aib_csr_ctrl_9),
  .r_aib_csr2_aib_csr2_ctrl_10       (w_aib_csr_ctrl_10),
  .r_aib_csr2_aib_csr2_ctrl_11       (w_aib_csr_ctrl_11),
  .r_aib_csr3_aib_csr3_ctrl_12       (w_aib_csr_ctrl_12),
  .r_aib_csr3_aib_csr3_ctrl_13       (w_aib_csr_ctrl_13),
  .r_aib_csr3_aib_csr3_ctrl_14       (w_aib_csr_ctrl_14),
  .r_aib_csr3_aib_csr3_ctrl_15       (w_aib_csr_ctrl_15),
  .r_aib_csr4_aib_csr4_ctrl_16       (w_aib_csr_ctrl_16),
  .r_aib_csr4_aib_csr4_ctrl_17       (w_aib_csr_ctrl_17),
  .r_aib_csr4_aib_csr4_ctrl_18       (w_aib_csr_ctrl_18),
  .r_aib_csr4_aib_csr4_ctrl_19       (w_aib_csr_ctrl_19),
  .r_aib_csr5_aib_csr5_ctrl_20       (w_aib_csr_ctrl_20),
  .r_aib_csr5_aib_csr5_ctrl_21       (w_aib_csr_ctrl_21),
  .r_aib_csr5_aib_csr5_ctrl_22       (w_aib_csr_ctrl_22),
  .r_aib_csr5_aib_csr5_ctrl_23       (w_aib_csr_ctrl_23),
  .r_aib_csr6_aib_csr6_ctrl_24       (w_aib_csr_ctrl_24),
  .r_aib_csr6_aib_csr6_ctrl_25       (w_aib_csr_ctrl_25),
  .r_aib_csr6_aib_csr6_ctrl_26       (w_aib_csr_ctrl_26),
  .r_aib_csr6_aib_csr6_ctrl_27       (w_aib_csr_ctrl_27),
  .r_aib_csr7_aib_csr7_ctrl_28       (w_aib_csr_ctrl_28),
  .r_aib_csr7_aib_csr7_ctrl_29       (w_aib_csr_ctrl_29),
  .r_aib_csr7_aib_csr7_ctrl_30       (w_aib_csr_ctrl_30),
  .r_aib_csr7_aib_csr7_ctrl_31       (w_aib_csr_ctrl_31),
  .r_aib_csr8_aib_csr8_ctrl_32       (w_aib_csr_ctrl_32),
  .r_aib_csr8_aib_csr8_ctrl_33       (w_aib_csr_ctrl_33),
  .r_aib_csr8_aib_csr8_ctrl_34       (w_aib_csr_ctrl_34),
  .r_aib_csr8_aib_csr8_ctrl_35       (w_aib_csr_ctrl_35),
  .r_aib_csr9_aib_csr9_ctrl_36       (w_aib_csr_ctrl_36),
  .r_aib_csr9_aib_csr9_ctrl_37       (w_aib_csr_ctrl_37),
  .r_aib_csr9_aib_csr9_ctrl_38       (w_aib_csr_ctrl_38),
  .r_aib_csr9_aib_csr9_ctrl_39       (w_aib_csr_ctrl_39),
  .r_aib_csr10_aib_csr10_ctrl_4x     (w_aib_csr_ctrl10_4x),
  .r_aib_csr11_aib_csr11_ctrl_4x     (w_aib_csr_ctrl11_4x),
  .r_aib_csr12_aib_csr12_ctrl_4x     (w_aib_csr_ctrl12_4x),
  .r_aib_csr13_aib_csr13_ctrl_5x     (w_aib_csr_ctrl13_5x),
  .r_avmm_spare_rsvd_i               (w_avmm_spare_rsvd),
  .r_avmm_spare_rsvd_prst_i          (w_avmm_spare_rsvd_prst),

  .clk                               (cfg_csr_clk),
  .reset                             (cfg_csr_reset), 
  .writedata                         (cfg_csr_wdata),
  .read                              (cfg_csr_read),
  .write                             (cfg_csr_write),
  .byteenable                        (cfg_csr_byteen),
  .readdata                          (cfg_csr_rdata),
  .readdatavalid                     (cfg_csr_rdatavld),
  .address                           (cfg_csr_addr));

// Manual decoding of inbox and outbox to generate clear-on-read signal
// User AVMM does byte reads
assign usr_inbox_read_en   = (adpt_avmm_addr == USR_INBOX_ADDR) & (adpt_avmm_byte_en == 4'h8) & adpt_avmm_read;

// send_message from cfg to usr
c3lib_vecsync_handshake #(
  .DWIDTH            (30),
  .RESET_VAL         (0),
  .DST_CLK_FREQ_MHZ  (300),
  .SRC_CLK_FREQ_MHZ (100)) 

  send_cfg_msg_sync (
    .wr_clk             (cfg_avmm_clk),           // write clock
    .wr_rst_n           (cfg_avmm_rst_n),         // async reset for write clock domain
    .data_in            (r_cfg_outbox_cfg_msg),   // data in on write clock domain
    .load_data_in       (r_cfg_outbox_send_msg),  // data valid
    .data_in_rdy2ld     (cfg_outbox_send_busy),   // pulse indicating data has been captured

    
    .rd_clk             (adpt_avmm_clk),          // read clock
    .rd_rst_n           (adpt_avmm_rst_n),        // async reset for read clock domain
    .data_out           (cfg2usr_msg),            // data out
    .data_out_vld       (usr_dout_vld),           // data valid
    .ack_data_out       (usr_dout_vld_d0));       // level signal indicating data has been captured

always @(posedge cfg_avmm_clk or negedge cfg_avmm_rst_n) begin
  if (!cfg_avmm_rst_n) begin
    cfg_outbox_send_busy_d0 <= 1'b1;
  end
  else begin
    cfg_outbox_send_busy_d0 <= cfg_outbox_send_busy;
  end
end

always @(posedge adpt_avmm_clk or negedge adpt_avmm_rst_n) begin
  if (!adpt_avmm_rst_n) begin
    usr_dout_vld_d0        <= 1'b0;
  end
  else begin
    usr_dout_vld_d0        <= usr_dout_vld;
  end
end

assign load_usr_msg = usr_dout_vld & (~usr_dout_vld_d0);
assign usr_autoclear_en = ~r_usr_inbox_autoclear_dis;

assign r_usr_inbox_usr_msg_i   = load_usr_msg           ? cfg2usr_msg : r_usr_inbox_usr_msg;
assign r_usr_outbox_send_msg_i = usr_outbox_send_busy_d0 ? r_usr_outbox_send_msg : 1'b0;

assign r_usr_inbox_new_msg_i   = load_usr_msg                           ? 1'b1 :
                                 (usr_inbox_read_en & usr_autoclear_en) ? 1'b0 : r_usr_inbox_new_msg; 

assign usr_csr_reset = ~adpt_avmm_rst_n;

// assign r_tx_latency_src_xcvrif = 1'b0;

c3aibadapt_usr_csr adapt_usr_csr (
  .r_usr_outbox_usr_msg                                 (r_usr_outbox_usr_msg),
  .r_usr_outbox_send_msg                                (r_usr_outbox_send_msg),
  .r_usr_inbox_usr_msg                                  (r_usr_inbox_usr_msg),
  .r_usr_inbox_autoclear_dis                            (r_usr_inbox_autoclear_dis),
  .r_usr_inbox_new_msg                                  (r_usr_inbox_new_msg),
  .r_usr_outbox_send_msg_i                              (r_usr_outbox_send_msg_i),
  .r_usr_inbox_usr_msg_i                                (r_usr_inbox_usr_msg_i),
  .r_usr_inbox_new_msg_i                                (r_usr_inbox_new_msg_i),
  .r_dprio0_tx_chnl_dp_map_mode                         (w_tx_chnl_datapath_map_mode),
  .r_dprio0_tx_usertest_sel                             (w_tx_usertest_sel),
  .r_dprio0_tx_fifo_empty                               (w_tx_fifo_empty),
  .r_dprio0_tx_fifo_full                                (w_tx_fifo_full),
  .r_dprio0_tx_phcomp_rd_delay                          (w_tx_phcomp_rd_delay),
  .r_dprio0_tx_double_read                              (w_tx_double_read),
  .r_dprio0_tx_stop_read                                (w_tx_stop_read),
  .r_dprio0_tx_stop_write                               (w_tx_stop_write),
  .r_dprio1_tx_fifo_pempty                              (w_tx_fifo_pempty),
  .r_dprio1_tx_dv_gating_en                             (w_tx_dv_gating_en),
  .r_dprio1_tx_rev_lpbk                                 (w_tx_rev_lpbk),
  .r_dprio1_tx_fifo_pfull                               (w_tx_fifo_pfull),
  .r_dprio2_tx_wa_en                                    (w_tx_wa_en),
  .r_dprio2_tx_fifo_power_mode                          (w_tx_fifo_power_mode),
  .r_dprio2_tx_stretch_num_stages                       (w_tx_stretch_num_stages),
  .r_dprio2_tx_datapath_tb_sel                          (w_tx_datapath_tb_sel),
  .r_dprio2_tx_wr_adj_en                                (w_tx_wr_adj_en),
  .r_dprio2_tx_rd_adj_en                                (w_tx_rd_adj_en),
  .r_dprio2_tx_async_txelecidle_rstval                  (w_tx_async_pld_txelecidle_rst_val),
  .r_dprio2_tx_async_hip_aib_fsr_in_bit0_rstval         (w_tx_async_hip_aib_fsr_in_bit0_rst_val),
  .r_dprio2_tx_async_hip_aib_fsr_in_bit1_rstval         (w_tx_async_hip_aib_fsr_in_bit1_rst_val),
  .r_dprio2_tx_async_hip_aib_fsr_in_bit2_rstval         (w_tx_async_hip_aib_fsr_in_bit2_rst_val),
  .r_dprio2_tx_async_hip_aib_fsr_in_bit3_rstval         (w_tx_async_hip_aib_fsr_in_bit3_rst_val),
  .r_dprio2_tx_async_pld_pmaif_mask_tx_pll_rstval       (w_tx_async_pld_pmaif_mask_tx_pll_rst_val),
  .r_dprio2_tx_async_hip_aib_fsr_out_bit0_rstval        (w_tx_async_hip_aib_fsr_out_bit0_rst_val),
  .r_dprio2_tx_async_hip_aib_fsr_out_bit1_rstval        (w_tx_async_hip_aib_fsr_out_bit1_rst_val),
  .r_dprio2_tx_async_hip_aib_fsr_out_bit2_rstval        (w_tx_async_hip_aib_fsr_out_bit2_rst_val),
  .r_dprio2_tx_async_hip_aib_fsr_out_bit3_rstval        (w_tx_async_hip_aib_fsr_out_bit3_rst_val),
  .r_dprio3_tx_fifo_rd_clk_sel                          (w_tx_fifo_rd_clk_sel),
  .r_dprio3_tx_fifo_wr_clk_scg_en                       (w_tx_fifo_wr_clk_scg_en),
  .r_dprio3_tx_fifo_rd_clk_scg_en                       (w_tx_fifo_rd_clk_scg_en),
  .r_dprio3_tx_osc_clk_scg_en                           (w_tx_osc_clk_scg_en),
  .r_dprio3_tx_hrdrst_rx_osc_clk_scg_en                 (w_tx_hrdrst_rx_osc_clk_scg_en),
  .r_dprio3_tx_hip_osc_clk_scg_en                       (w_tx_hip_osc_clk_scg_en),
  .r_dprio3_tx_free_run_div_clk                         (w_tx_free_run_div_clk),
  .r_dprio3_tx_hrdrst_rst_sm_dis                        (w_tx_hrdrst_rst_sm_dis),
  .r_dprio3_tx_hrdrst_dcd_caldone_byp                   (w_tx_hrdrst_dcd_cal_done_bypass),
  .r_dprio3_tx_hrdrst_dll_lock_byp                      (w_tx_hrdrst_dll_lock_bypass),
  .r_dprio3_tx_hrdrst_align_byp                         (w_tx_hrdrst_align_bypass),
  .r_dprio3_tx_hrdrst_user_ctl_en                       (w_tx_hrdrst_user_ctl_en),
  .r_dprio0_rx_chnl_dp_map_mode                         (w_rx_chnl_datapath_map_mode),
  .r_dprio0_rx_pcs_testbus_sel                          (w_rx_pcs_testbus_sel),
  .r_dprio0_rx_pld_8g_a1a2_k1k2_flag_poll_byp           (w_rx_pld_8g_a1a2_k1k2_flag_polling_bypass),
  .r_dprio0_rx_pld_10g_krfec_rx_diag_data_stat_poll_byp (w_rx_10g_krfec_rx_diag_data_status_polling_bypass),
  .r_dprio0_rx_pld_pma_pcie_sw_done_poll_byp            (w_rx_pld_pma_pcie_sw_done_polling_bypass),
  .r_dprio0_rx_pld_pma_reser_in_poll_byp                (w_rx_pld_pma_reser_in_polling_bypass),
  .r_dprio0_rx_pld_pma_testbus_poll_byp                 (w_rx_pld_pma_testbus_polling_bypass),
  .r_dprio0_rx_pld_test_data_poll_byp                   (w_rx_pld_test_data_polling_bypass),
  .r_dprio0_rx_pld_8g_wa_boundary_poll_byp              (w_rx_pld_8g_wa_boundary_polling_bypass),
  .r_dprio0_rx_pcspma_testbus_sel                       (w_rx_pcspma_testbus_sel),
  .r_dprio0_rx_fifo_empty                               (w_rx_fifo_empty),
  .r_dprio0_rx_fifo_mode                                (w_rx_fifo_mode),
  .r_dprio0_rx_wm_en                                    (w_rx_wm_en),
  .r_dprio0_rx_fifo_full                                (w_rx_fifo_full),
  .r_dprio0_rx_phcomp_rd_delay                          (w_rx_phcomp_rd_delay),
  .r_dprio1_rx_double_write                             (w_rx_double_write),
  .r_dprio1_rx_stop_read                                (w_rx_stop_read),
  .r_dprio1_rx_stop_write                               (w_rx_stop_write),
  .r_dprio1_rx_fifo_pempty                              (w_rx_fifo_pempty),
  .r_dprio1_rx_adapter_lpbk_mode                        (w_rx_adapter_lpbk_mode),
  .r_dprio1_rx_aib_lpbk_en                              (w_rx_aib_lpbk_en),
  .r_dprio2_rx_fifo_pfull                               (w_rx_fifo_pfull),
  .r_dprio2_rx_fifo_power_mode                          (w_rx_fifo_power_mode),
  .r_dprio2_rx_usertest_sel                             (w_rx_usertest_sel),
  .r_dprio2_rx_hrdrst_user_ctl_en                       (w_rx_hrdrst_user_ctl_en),
  .r_dprio2_rx_wr_adj_en                                (w_rx_wr_adj_en),
  .r_dprio2_rx_rd_adj_en                                (w_rx_rd_adj_en),
  .r_dprio2_rx_msb_rdptr_pipe_byp                       (w_rx_msb_rdptr_pipe_byp),
  .r_dprio2_rx_async_ltr_rstval                         (w_rx_async_pld_ltr_rst_val),
  .r_dprio2_rx_async_ltd_b_rstval                       (w_rx_async_pld_pma_ltd_b_rst_val),
  .r_dprio2_rx_async_pld_8g_sig_det_out_rstval          (w_rx_async_pld_8g_signal_detect_out_rst_val),
  .r_dprio2_rx_async_pld_10g_rx_crc32_err_rstval        (w_rx_async_pld_10g_rx_crc32_err_rst_val),
  .r_dprio2_rx_async_rx_fifo_align_clr_rstval           (w_rx_async_pld_rx_fifo_align_clr_rst_val),
  .r_dprio2_rx_async_hip_en                             (w_rx_async_hip_en),
  .r_dprio2_rx_parity_sel                               (w_rx_parity_sel),
  .r_dprio2_rx_stretch_num_stages                       (w_rx_stretch_num_stages),
  .r_dprio3_rx_datapath_tb_sel                          (w_rx_datapath_tb_sel),
  .r_dprio3_rx_internal_clk1_sel0                       (w_rx_internal_clk1_sel0),
  .r_dprio3_rx_internal_clk1_sel1                       (w_rx_internal_clk1_sel1),
  .r_dprio3_rx_internal_clk1_sel2                       (w_rx_internal_clk1_sel2),
  .r_dprio3_rx_internal_clk1_sel3                       (w_rx_internal_clk1_sel3),
  .r_dprio3_rx_txfiford_prect_sel                       (w_rx_txfiford_pre_ct_sel),
  .r_dprio3_rx_txfiford_postct_sel                      (w_rx_txfiford_post_ct_sel),
  .r_dprio3_rx_txfifowr_postct_sel                      (w_rx_txfifowr_post_ct_sel),
  .r_dprio3_rx_txfifowr_from_aib_sel                    (w_rx_txfifowr_from_aib_sel),
  .r_dprio3_rx_rxfiford_to_aib_sel                      (w_rx_rxfiford_to_aib_sel),
  .r_dprio3_rx_fifo_wr_clk_sel                          (w_rx_fifo_wr_clk_sel),
  .r_dprio3_rx_fifo_rd_clk_sel                          (w_rx_fifo_rd_clk_sel),
  .r_dprio3_rx_latency_src_sel                          (w_tx_latency_src_xcvrif),
  .r_dprio3_rx_internal_clk1_sel                        (w_rx_internal_clk1_sel),
  .r_dprio3_rx_internal_clk2_sel                        (w_rx_internal_clk2_sel),
  .r_dprio3_rx_fifo_wr_clk_scg_en                       (w_rx_fifo_wr_clk_scg_en),
  .r_dprio3_rx_fifo_rd_clk_scg_en                       (w_rx_fifo_rd_clk_scg_en),
  .r_dprio3_rx_osc_clk_scg_en                           (w_rx_osc_clk_scg_en),
  .r_dprio3_rx_hrdrst_rx_osc_clk_scg_en                 (w_rx_hrdrst_rx_osc_clk_scg_en),
  .r_dprio4_rx_pma_coreclkin_sel                        (w_rx_pma_coreclkin_sel),
  .r_dprio4_rx_free_run_div_clk                         (w_rx_free_run_div_clk),
  .r_dprio4_rx_hrdrst_rst_sm_dis                        (w_rx_hrdrst_rst_sm_dis),
  .r_dprio4_rx_hrdrst_dcd_caldone_byp                   (w_rx_hrdrst_dcd_cal_done_bypass),
  .r_dprio4_rx_rmfflag_stretch_en                       (w_rx_rmfflag_stretch_enable),
  .r_dprio4_rx_rmfflag_stretch_num_stages               (w_rx_rmfflag_stretch_num_stages),
  .r_dprio4_rx_internal_clk2_sel0                       (w_rx_internal_clk2_sel0),
  .r_dprio4_rx_internal_clk2_sel1                       (w_rx_internal_clk2_sel1),
  .r_dprio4_rx_internal_clk2_sel2                       (w_rx_internal_clk2_sel2),
  .r_dprio4_rx_internal_clk2_sel3                       (w_rx_internal_clk2_sel3),
  .r_dprio4_rx_rxfifowr_prect_sel                       (w_rx_rxfifowr_pre_ct_sel),
  .r_dprio4_rx_rxfifowr_postct_sel                      (w_rx_rxfifowr_post_ct_sel),
  .r_dprio4_rx_rxfiford_postct_sel                      (w_rx_rxfiford_post_ct_sel),
  .r_dprio_status_rx_chnl                               (r_dprio_status_rx_chnl),
  .r_dprio_status_tx_chnl                               (r_dprio_status_tx_chnl),
  .r_dprio_status_sr                                    (r_dprio_status_sr),
  .r_aibdprio0_aib_dprio0_ctrl_0                        (w_aib_dprio_ctrl_0),
  .r_aibdprio0_aib_dprio0_ctrl_1                        (w_aib_dprio_ctrl_1),
  .r_aibdprio0_aib_dprio0_ctrl_2                        (w_aib_dprio_ctrl_2),
  .r_aibdprio0_aib_dprio0_ctrl_3                        (w_aib_dprio_ctrl_3),
  .r_aibdprio1_aib_dprio1_ctrl_4                        (w_aib_dprio_ctrl_4),
  .r_dprio_sr_reserved                                  (),
  .r_dprio_avmm1_reserved                               (),
  .r_dprio_avmm2_reserved                               (),
  .r_spare0_rsvd                                        (r_spare0_rsvd),
  .r_spare0_rsvd_prst                                   (r_spare0_rsvd_prst),
  .crssm_cfg_active                                     (crssm_cfg_active),
  .r_dprio_status_sr_i                                  (w_dprio_status_sr),
  .r_dprio_status_rx_chnl_i                             (w_dprio_status_rx_chnl),
  .r_dprio_status_tx_chnl_i                             (w_dprio_status_tx_chnl),
  .r_spare0_rsvd_i                                      (r_spare0_rsvd),
  .r_spare0_rsvd_prst_i                                 (r_spare0_rsvd_prst),

  .clk                                                  (adpt_avmm_clk),
  .reset                                                (usr_csr_reset),
  .writedata                                            (adpt_avmm_wdata),
  .read                                                 (adpt_avmm_read),
  .write                                                (adpt_avmm_write),
  .byteenable                                           (adpt_avmm_byte_en),
  .readdata                                             (adpt_avmm_rdata),
  .readdatavalid                                        (adpt_avmm_rdatavld),
  .address                                              (adpt_avmm_addr[7:0])
);

endmodule
