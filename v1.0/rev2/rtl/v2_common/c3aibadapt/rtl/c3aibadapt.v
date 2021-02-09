// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//-----------------------------------------------------------------------------
// Copyright (C) 2015 Altera Corporation. 
//
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//  $Date: 2017/03/29 $
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


module c3aibadapt (

  // AIB
  input  wire                       i_aib_rx_adpt_rst_n,
  input  wire                       i_aib_tx_adpt_rst_n,
  input  wire [1:0]                 i_aib_avmm1_data,
  input  wire [1:0]                 i_aib_avmm2_data,
  input  wire [2:0]                 i_aib_shared_direct_async,
  input  wire                       i_aib_fsr_data,
  input  wire                       i_aib_fsr_load,
  input  wire                       i_aib_rx_elane_rst_n,
  input  wire                       i_aib_tx_elane_rst_n,
  input  wire                       i_aib_core_clk,
  input  wire                       i_aib_rx_xcvrif_rst_n,
  input  wire                       i_aib_rsvd_direct_async,
  input  wire                       i_aib_tx_xcvrif_rst_n,
  input  wire                       i_aib_sclk,
  input  wire                       i_aib_rx_dcd_cal_done,
  input  wire                       i_aib_rx_sr_clk,
  input  wire                       i_aib_ssr_data,
  input  wire                       i_aib_ssr_load,
  input  wire [39:0]                i_aib_tx_data,
  input  wire                       i_aib_tx_dcd_cal_done,
  input  wire                       i_aib_tx_dll_lock,
  input  wire                       i_aib_tx_sr_clk,
  input  wire                       i_aib_tx_transfer_clk,    //full-rate TX PMA clock from MAIB 

  // Adapter/CR3SSM
  // Config
  output wire                       o_adpt_hard_rst_n,
  output wire                       o_user_mode,

  input  wire                       i_user_mode,
  input  wire                       i_adpt_hard_rst_n,        // Hard reset replaces i_csr_rdy_dly

  output wire                       o_adpt_cfg_clk,
  output wire                       o_adpt_cfg_rst_n,         // CR3SSM config reset to Adapter in next channel
  output wire [16:0]                o_adpt_cfg_addr,
  output wire [31:0]                o_adpt_cfg_wdata,
  output wire                       o_adpt_cfg_write,
  output wire                       o_adpt_cfg_read,
  output wire [3:0]                 o_adpt_cfg_byte_en,
  input  wire [31:0]                i_adpt_cfg_rdata,
  input  wire                       i_adpt_cfg_rdatavld,
  input  wire                       i_adpt_cfg_waitreq,

  // CRSSM AVMM
  input  wire [5:0]                 i_cfg_avmm_addr_id,
  input  wire                       i_cfg_avmm_clk,
  input  wire                       i_cfg_avmm_rst_n,         // CR3SSM config reset replaces i_csr_rdy
  input  wire [16:0]                i_cfg_avmm_addr,
  input  wire [31:0]                i_cfg_avmm_wdata,
  input  wire                       i_cfg_avmm_write,
  input  wire                       i_cfg_avmm_read,
  input  wire [3:0]                 i_cfg_avmm_byte_en,
  output wire [31:0]                o_cfg_avmm_rdata,
  output wire                       o_cfg_avmm_rdatavld,
  output wire                       o_cfg_avmm_waitreq,

  // ELANE
  input  wire [4:0]                 i_fpll_shared_direct_async,
  input  wire                       i_rx_chnl_rsvd,          // to RX SSR reserved
  input  wire                       i_rsvd_direct_async,     // pld_8g_rxelecidle,
  input  wire                       i_rx_elane_clk,
  input  wire                       i_tx_elane_clk,
  input  wire                       i_rx_pma_div66_clk,
  input  wire                       i_tx_pma_div66_clk,
  input  wire [5:0]                 i_feedthru_clk,
  output wire                       o_elane_cfg_clk,
  output wire                       o_elane_cfg_rst_n,
  output wire                       o_elane_cfg_active,
  output wire                       o_elane_cfg_write,
  output wire                       o_elane_cfg_read,
  output wire [16:0]                o_elane_cfg_addr,
  output wire [31:0]                o_elane_cfg_wdata,
  output wire [3:0]                 o_elane_cfg_byte_en,
  input  wire [31:0]                i_elane_cfg_rdata,
  input  wire                       i_elane_cfg_rdatavld,
  input  wire                       i_elane_cfg_waitreq,

  // XCVRIF
  input   wire                      i_rx_pma_clk,
  input   wire                      i_rx_pma_div2_clk,
  input   wire                      i_tx_pma_clk,
  input   wire                      i_xcvrif_tx_rdy,        // pld_pma_pfdmode_lock,
  input   wire                      i_xcvrif_rx_rdy,
  input   wire                      i_xcvrif_rx_latency_pls,
  input   wire                      i_xcvrif_tx_latency_pls,
  output  wire                      o_xcvrif_sclk,
  output                            o_xcvrif_cfg_clk,
  output                            o_xcvrif_cfg_rst_n,
  output                            o_xcvrif_cfg_active,
  output                            o_xcvrif_cfg_write,
  output                            o_xcvrif_cfg_read,
  output [8:0]                      o_xcvrif_cfg_addr,
  output [31:0]                     o_xcvrif_cfg_wdata,
  output [3:0]                      o_xcvrif_cfg_byte_en,
  input  [31:0]                     i_xcvrif_cfg_rdata,
  input                             i_xcvrif_cfg_rdatavld,
  input                             i_xcvrif_cfg_waitreq,

  // AIB
  output  wire                      o_aib_avmm1_data,
  output  wire                      o_aib_avmm2_data,
  output  wire [4:0]                o_aib_shared_direct_async, // aib_hssi_fpll_shared_direct_async_out,
  output  wire                      o_aib_fsr_data,
  output  wire                      o_aib_fsr_load,
  output  wire                      o_aib_rsvd_direct_async,
  output  wire                      o_aib_rx_pma_div2_clk,
  output  wire                      o_aib_tx_pma_div2_clk,
  output  wire                      o_aib_rx_pma_div66_clk,
  output  wire                      o_aib_tx_pma_div66_clk,
  output  wire                      o_aib_h_clk,
  output  wire                      o_aib_bsr_scan_shift_clk,
  output  wire                      o_aib_internal1_clk,
  output  wire                      o_aib_internal2_clk,
  output  wire                      o_aib_xcvrif_tx_rdy,
  output  wire                      o_aib_xcvrif_rx_rdy,
  output  wire                      o_aib_rx_fifo_latency_pls,
  output  wire                      o_aib_tx_fifo_latency_pls,
  output  wire                      o_aib_tx_pma_clk,            //full-rate TX PMA clock to MAIB 
  output  wire [39:0]               o_aib_rx_data,
  output  wire                      o_aib_rx_dcd_cal_req,
  output  wire                      o_aib_rx_transfer_clk,
  output  wire                      o_aib_ssr_data,
  output  wire                      o_aib_ssr_load,
  output  wire                      o_aib_tx_dcd_cal_req,
  output  wire                      o_aib_tx_dll_lock_req,
  output  wire                      o_aib_tx_sr_clk,
  output  wire [7:0]                o_aib_csr_ctrl_0,
  output  wire [7:0]                o_aib_csr_ctrl_1,
  output  wire [7:0]                o_aib_csr_ctrl_10,
  output  wire [7:0]                o_aib_csr_ctrl_11,
  output  wire [7:0]                o_aib_csr_ctrl_12,
  output  wire [7:0]                o_aib_csr_ctrl_13,
  output  wire [7:0]                o_aib_csr_ctrl_14,
  output  wire [7:0]                o_aib_csr_ctrl_15,
  output  wire [7:0]                o_aib_csr_ctrl_16,
  output  wire [7:0]                o_aib_csr_ctrl_17,
  output  wire [7:0]                o_aib_csr_ctrl_18,
  output  wire [7:0]                o_aib_csr_ctrl_19,
  output  wire [7:0]                o_aib_csr_ctrl_2,
  output  wire [7:0]                o_aib_csr_ctrl_20,
  output  wire [7:0]                o_aib_csr_ctrl_21,
  output  wire [7:0]                o_aib_csr_ctrl_22,
  output  wire [7:0]                o_aib_csr_ctrl_23,
  output  wire [7:0]                o_aib_csr_ctrl_24,
  output  wire [7:0]                o_aib_csr_ctrl_25,
  output  wire [7:0]                o_aib_csr_ctrl_26,
  output  wire [7:0]                o_aib_csr_ctrl_27,
  output  wire [7:0]                o_aib_csr_ctrl_28,
  output  wire [7:0]                o_aib_csr_ctrl_29,
  output  wire [7:0]                o_aib_csr_ctrl_3,
  output  wire [7:0]                o_aib_csr_ctrl_30,
  output  wire [7:0]                o_aib_csr_ctrl_31,
  output  wire [7:0]                o_aib_csr_ctrl_32,
  output  wire [7:0]                o_aib_csr_ctrl_33,
  output  wire [7:0]                o_aib_csr_ctrl_34,
  output  wire [7:0]                o_aib_csr_ctrl_35,
  output  wire [7:0]                o_aib_csr_ctrl_36,
  output  wire [7:0]                o_aib_csr_ctrl_37,
  output  wire [7:0]                o_aib_csr_ctrl_38,
  output  wire [7:0]                o_aib_csr_ctrl_39,
  output  wire [7:0]                o_aib_csr_ctrl_4,
  output  wire [7:0]                o_aib_csr_ctrl_40,
  output  wire [7:0]                o_aib_csr_ctrl_41,
  output  wire [7:0]                o_aib_csr_ctrl_42,
  output  wire [7:0]                o_aib_csr_ctrl_43,
  output  wire [7:0]                o_aib_csr_ctrl_44,
  output  wire [7:0]                o_aib_csr_ctrl_45,
  output  wire [7:0]                o_aib_csr_ctrl_46,
  output  wire [7:0]                o_aib_csr_ctrl_47,
  output  wire [7:0]                o_aib_csr_ctrl_48,
  output  wire [7:0]                o_aib_csr_ctrl_49,
  output  wire [7:0]                o_aib_csr_ctrl_5,
  output  wire [7:0]                o_aib_csr_ctrl_50,
  output  wire [7:0]                o_aib_csr_ctrl_51,
  output  wire [7:0]                o_aib_csr_ctrl_52,
  output  wire [7:0]                o_aib_csr_ctrl_53,
  output  wire [7:0]                o_aib_csr_ctrl_6,
  output  wire [7:0]                o_aib_csr_ctrl_7,
  output  wire [7:0]                o_aib_csr_ctrl_8,
  output  wire [7:0]                o_aib_csr_ctrl_9,
  output  wire [7:0]                o_aib_dprio_ctrl_0,
  output  wire [7:0]                o_aib_dprio_ctrl_1,
  output  wire [7:0]                o_aib_dprio_ctrl_2,
  output  wire [7:0]                o_aib_dprio_ctrl_3,
  output  wire [7:0]                o_aib_dprio_ctrl_4,

  // DFT
  output  wire [1:0]                o_aibdftcore2dll,
  output  wire [12:0]               o_dftdll2core,

  input   wire                      i_scan_mode_n,

  input   wire [`TCM_WRAP_CTRL_RNG] i_avmm1_tst_tcm_ctrl,
  input   wire                      i_avmm1_test_clk,
  input   wire                      i_avmm1_scan_clk,

  input   wire [`TCM_WRAP_CTRL_RNG] i_txchnl_0_tst_tcm_ctrl,
  input   wire                      i_txchnl_0_test_clk,
  input   wire                      i_txchnl_0_scan_clk,
  input   wire [`TCM_WRAP_CTRL_RNG] i_txchnl_1_tst_tcm_ctrl,
  input   wire                      i_txchnl_1_test_clk,
  input   wire                      i_txchnl_1_scan_clk,
  input   wire [`TCM_WRAP_CTRL_RNG] i_txchnl_2_tst_tcm_ctrl,
  input   wire                      i_txchnl_2_test_clk,
  input   wire                      i_txchnl_2_scan_clk,

  input   wire [`TCM_WRAP_CTRL_RNG] i_rxchnl_tst_tcm_ctrl,
  input   wire                      i_rxchnl_test_clk,
  input   wire                      i_rxchnl_scan_clk,

  input   wire [`TCM_WRAP_CTRL_RNG] i_sr_0_tst_tcm_ctrl,
  input   wire                      i_sr_0_test_clk,
  input   wire                      i_sr_0_scan_clk,
  input   wire [`TCM_WRAP_CTRL_RNG] i_sr_1_tst_tcm_ctrl,
  input   wire                      i_sr_1_test_clk,
  input   wire                      i_sr_1_scan_clk,
  input   wire [`TCM_WRAP_CTRL_RNG] i_sr_2_tst_tcm_ctrl,
  input   wire                      i_sr_2_test_clk,
  input   wire                      i_sr_2_scan_clk,
  input   wire [`TCM_WRAP_CTRL_RNG] i_sr_3_tst_tcm_ctrl,
  input   wire                      i_sr_3_test_clk,
  input   wire                      i_sr_3_scan_clk,

  input   wire                      i_scan_rst_n,

  input  wire [1:0]                 i_dftcore2dll,
  input  wire [12:0]                i_aibdftdll2core,

  // EHIP
  output wire                       o_ehip_usr_clk,
  output wire                       o_ehip_usr_read,
  output wire [20:0]                o_ehip_usr_addr,
  output wire                       o_ehip_usr_write,
  output wire [7:0]                 o_ehip_usr_wdata,
  input  wire [7:0]                 i_ehip_usr_rdata,
  input  wire                       i_ehip_usr_rdatavld,
  input  wire                       i_ehip_usr_wrdone,

  output wire                       o_ehip_cfg_clk,
  output wire                       o_ehip_cfg_rst_n,
  output wire                       o_ehip_cfg_read,
  output wire                       o_ehip_cfg_write,
  output wire[16:0]                 o_ehip_cfg_addr,
  output wire[3:0]                  o_ehip_cfg_byte_en,
  output wire[31:0]                 o_ehip_cfg_wdata,
  input  wire[31:0]                 i_ehip_cfg_rdata,
  input  wire                       i_ehip_cfg_rdatavld,
  input  wire                       i_ehip_cfg_waitreq,
  output wire [3:0]                 o_ehip_fsr    ,
  output wire [39:0]                o_ehip_ssr,
  output wire [2:0]                 o_ehip_init_status,
  output wire [77:0]                o_tx_ehip_data,
  input  wire [77:0]                i_rx_ehip_data,
  input  wire [7:0]                 i_ehip_ssr,
  input  wire [3:0]                 i_ehip_fsr,

  input  wire                       i_rx_rsfec_clk,
  input  wire [77:0]                i_rx_rsfec_data,
  input  wire                       i_tx_rsfec_clk,
  input  wire                       i_rx_rsfec_frd_clk,
  output wire [77:0]                o_tx_rsfec_data,
  input  wire [39:0]                i_rx_pma_data,
  output wire [39:0]                o_tx_pma_data,

  // ELANE
  output wire [77:0]                o_tx_elane_data,
  input  wire [77:0]                i_rx_elane_data,
  output wire [2:0]                 o_fpll_shared_direct_async,
  output wire                       o_rx_elane_rst_n,
  output wire                       o_tx_elane_rst_n,
  output wire [60:0]                o_chnl_ssr,
  output wire [2:0]                 o_chnl_fsr,
  output wire                       o_xcvrif_core_clk,
  input  wire [2:0]                 i_chnl_fsr,
  input  wire [64:0]                i_chnl_ssr,
  output wire [80:0]                ms_sideband,
  output wire [72:0]                sl_sideband,
  output wire                       m_rxfifo_align_done,

// EHIP FSR/SSR
  input  wire                       i_rx_ehip_clk,
  input  wire                       i_tx_ehip_clk,
  input  wire                       i_rx_ehip_frd_clk,
  output wire                       o_rx_xcvrif_rst_n,
  output wire                       o_rsvd_direct_async,             // pass-thru from AIB I/O.. pld_pma_txdetectrx
  output wire                       o_tx_xcvrif_rst_n,
  output  wire                      o_tx_transfer_clk,
  output  wire                      o_tx_transfer_div2_clk

);

localparam TP_RX_RSTCTL   = 3'd1;
localparam TP_TX_RSTCTL   = 3'd2;
localparam TP_AVMM_RSTCTL = 3'd3;
localparam TP_AVMM_DEC0   = 3'd4;
localparam TP_AVMM_DEC1   = 3'd5;
localparam TP_AVMM_DEC2   = 3'd6;
localparam TP_AVMM_DEC3   = 3'd7;

wire                  avmm1_clock_avmm_clk_scg;
wire                  avmm1_clock_avmm_clk_dcg;
wire                  avmm2_clock_avmm_clk_scg;
wire                  avmm2_clock_avmm_clk_dcg;
wire                  avmm1_async_hssi_fabric_ssr_load;
wire [1:0]            avmm1_hssi_fabric_ssr_data;
wire                  avmm2_async_hssi_fabric_ssr_load;
wire [1:0]            avmm2_hssi_fabric_ssr_data;
wire                  avmm_hrdrst_hssi_osc_transfer_alive;
wire [3:0]            hip_aib_async_fsr_in;
wire [3:0]            hip_aib_async_fsr_out;
wire [39:0]           hip_aib_async_ssr_in;
wire [7:0]            hip_aib_async_ssr_out;
wire                  r_rx_align_del;
wire                  r_rx_asn_bypass_pma_pcie_sw_done;
wire                  r_rx_hrdrst_user_ctl_en;
wire                  r_rx_asn_bypass_clock_gate;
wire                  r_rx_asn_en;
wire                  r_rx_slv_asn_en;
wire [6:0]            r_rx_asn_wait_for_fifo_flush_cnt;
wire [1:0]            r_rx_usertest_sel;
wire [6:0]            r_rx_asn_wait_for_dll_reset_cnt;
wire [6:0]            r_rx_asn_wait_for_clock_gate_cnt;
wire [6:0]            r_rx_asn_wait_for_pma_pcie_sw_done_cnt;
wire                  r_rx_internal_clk1_sel0;
wire                  r_rx_internal_clk1_sel1;
wire                  r_rx_internal_clk1_sel2;
wire                  r_rx_internal_clk1_sel3;
wire                  r_rx_txfiford_pre_ct_sel;
wire                  r_rx_txfiford_post_ct_sel;
wire                  r_rx_txfifowr_post_ct_sel;
wire                  r_rx_txfifowr_from_aib_sel;
wire                  r_rx_internal_clk2_sel0;
wire                  r_rx_internal_clk2_sel1;
wire                  r_rx_internal_clk2_sel2;
wire                  r_rx_internal_clk2_sel3;
wire                  r_rx_rxfifowr_pre_ct_sel;
wire                  r_rx_rxfifowr_post_ct_sel;
wire                  r_rx_rxfiford_post_ct_sel;
wire                  r_rx_rxfiford_to_aib_sel;
wire                  r_rx_async_pld_10g_rx_crc32_err_rst_val;
wire                  r_rx_async_pld_8g_signal_detect_out_rst_val;
wire                  r_rx_async_pld_ltr_rst_val;
wire                  r_rx_async_pld_pma_ltd_b_rst_val;
wire                  r_rx_async_pld_rx_fifo_align_clr_rst_val;
wire                  r_rx_bonding_dft_in_en;
wire                  r_rx_async_hip_en;
wire                  r_rx_bonding_dft_in_value;
wire [2:0]            r_rx_chnl_datapath_map_mode;
wire [2:0]            r_rx_pcs_testbus_sel;
wire [7:0]            r_rx_comp_cnt;
wire [1:0]            r_rx_compin_sel;
wire                  r_rx_double_write;
wire                  r_rx_ds_bypass_pipeln;
wire                  r_rx_ds_master;
wire                  r_rx_dyn_clk_sw_en;
wire                  r_rx_txeq_en;
wire                  r_rx_rxeq_en;
wire                  r_rx_pre_cursor_en;
wire                  r_rx_post_cursor_en;
wire                  r_rx_invalid_no_change;
wire                  r_rx_adp_go_b4txeq_en;
wire                  r_rx_use_rxvalid_for_rxeq;
wire                  r_rx_pma_rstn_en;

wire                  r_rx_pma_rstn_cycles;
wire [7:0]            r_rx_txeq_time;        // unit is 1us for 8'h100 cycles
wire [1:0]            r_rx_eq_iteration;     //

wire [4:0]            r_rx_fifo_empty;
wire [4:0]            r_rx_fifo_full;
wire [1:0]            r_rx_fifo_mode;
wire [4:0]            r_rx_fifo_pempty;
wire [4:0]            r_rx_fifo_pfull;
wire                  r_rx_fifo_rd_clk_scg_en;
wire [2:0]            r_rx_fifo_rd_clk_sel;
wire                  r_rx_fifo_wr_clk_scg_en;
wire [2:0]            r_rx_fifo_wr_clk_sel;
wire                  r_rx_pma_coreclkin_sel;
wire                  r_rx_force_align;
wire                  r_rx_free_run_div_clk;
wire                  r_rx_txeq_rst_sel;
wire                  r_rx_indv;
wire [3:0]            r_rx_internal_clk1_sel;
wire [3:0]            r_rx_internal_clk2_sel;
wire [3:0]            r_rx_mask_del;
wire [2:0]            r_rx_phcomp_rd_delay;
wire                  r_rx_pma_hclk_scg_en;
wire                  r_rx_osc_clk_scg_en;
wire                  r_rx_stop_read;
wire                  r_rx_stop_write;
wire                  r_rx_txeq_clk_sel;
wire                  r_rx_txeq_clk_scg_en;
wire                  r_rx_us_bypass_pipeln;
wire                  r_rx_us_master;
wire                  r_rx_wm_en;
wire                  r_sr_hip_en;
wire                  r_sr_parity_en;
wire                  r_sr_hip_fsr_in_bit0_rst_val;
wire                  r_sr_hip_fsr_in_bit1_rst_val;
wire                  r_sr_hip_fsr_in_bit2_rst_val;
wire                  r_sr_hip_fsr_in_bit3_rst_val;
wire                  r_sr_hip_fsr_out_bit0_rst_val;
wire                  r_sr_hip_fsr_out_bit1_rst_val;
wire                  r_sr_hip_fsr_out_bit2_rst_val;
wire                  r_sr_hip_fsr_out_bit3_rst_val;
wire                  r_sr_pld_10g_rx_crc32_err_rst_val;
wire                  r_sr_pld_8g_signal_detect_out_rst_val;
wire                  r_sr_pld_ltr_rst_val;
wire                  r_sr_pld_pma_ltd_b_rst_val;
wire                  r_sr_pld_pmaif_mask_tx_pll_rst_val;
wire                  r_sr_pld_txelecidle_rst_val;
wire                  r_sr_osc_clk_scg_en;
wire [1:0]            r_sr_osc_clk_div_sel;
wire                  r_sr_free_run_div_clk;
wire [1:0]            r_tx_aib_clk_sel;
wire                  r_tx_async_hip_aib_fsr_in_bit0_rst_val;
wire                  r_tx_async_hip_aib_fsr_in_bit1_rst_val;
wire                  r_tx_async_hip_aib_fsr_in_bit2_rst_val;
wire                  r_tx_async_hip_aib_fsr_in_bit3_rst_val;
wire                  r_tx_async_hip_aib_fsr_out_bit0_rst_val;
wire                  r_tx_async_hip_aib_fsr_out_bit1_rst_val;
wire                  r_tx_async_hip_aib_fsr_out_bit2_rst_val;
wire                  r_tx_async_hip_aib_fsr_out_bit3_rst_val;
wire                  r_tx_async_pld_pmaif_mask_tx_pll_rst_val;
wire                  r_tx_async_pld_txelecidle_rst_val;
wire                  r_tx_bonding_dft_in_en;
wire                  r_tx_bonding_dft_in_value;
wire [2:0]            r_tx_chnl_datapath_map_mode;
wire                  r_tx_chnl_datapath_map_rxqpi_pullup_init_val;
wire                  r_tx_chnl_datapath_map_txqpi_pulldn_init_val;
wire                  r_tx_chnl_datapath_map_txqpi_pullup_init_val;
wire [7:0]            r_tx_comp_cnt;
wire [1:0]            r_tx_compin_sel;
wire                  r_tx_double_read;
wire                  r_tx_ds_bypass_pipeln;
wire                  r_tx_ds_master;
wire                  r_tx_dyn_clk_sw_en;
wire [4:0]            r_tx_fifo_empty;
wire [4:0]            r_tx_fifo_full;
wire [1:0]            r_tx_fifo_mode;
wire [4:0]            r_tx_fifo_pempty;
wire [4:0]            r_tx_fifo_pfull;
wire                  r_tx_fifo_rd_clk_scg_en;
wire [1:0]            r_tx_fifo_rd_clk_sel;
wire                  r_tx_fifo_wr_clk_scg_en;
wire                  r_tx_free_run_div_clk;
wire                  r_tx_indv;
wire [2:0]            r_tx_phcomp_rd_delay;
wire                  r_tx_osc_clk_scg_en;
wire                  r_tx_stop_read;
wire                  r_tx_stop_write;
wire                  r_tx_us_bypass_pipeln;
wire                  r_tx_us_master;
wire                  r_tx_wa_en;
wire                  rx_asn_rate_change_in_progress;
wire                  rx_asn_dll_lock_en;
wire                  rx_asn_fifo_hold;
wire                  rx_asn_clk_en;
wire                  rx_asn_gen3_sel;
wire [1:0]            rx_asn_rate;
wire [2:0]            rx_async_fabric_hssi_fsr_data;
wire                  rx_async_fabric_hssi_fsr_load;
wire [35:0]           rx_async_fabric_hssi_ssr_data;
wire                  rx_async_fabric_hssi_ssr_load;
wire [1:0]            rx_async_hssi_fabric_fsr_data;
wire                  rx_async_hssi_fabric_fsr_load;
wire [62:0]           rx_async_hssi_fabric_ssr_data;
wire                  rx_async_hssi_fabric_ssr_load;
wire [7:0]            rx_chnl_dprio_status;
wire                  rx_chnl_dprio_status_write_en;
wire                  rx_chnl_dprio_status_write_en_ack;
wire [7:0]            sr_dprio_status;
wire                  sr_dprio_status_write_en;
wire                  sr_dprio_status_write_en_ack;
wire [1:0]            rx_pld_rate;
wire                  tx_async_fabric_hssi_fsr_data;
wire                  tx_async_fabric_hssi_fsr_load;
wire [35:0]           tx_async_fabric_hssi_ssr_data;
wire                  tx_async_fabric_hssi_ssr_load;
wire                  tx_async_hssi_fabric_fsr_data;
wire                  tx_async_hssi_fabric_fsr_load;
wire [12:0]           tx_async_hssi_fabric_ssr_data;
wire                  tx_async_hssi_fabric_ssr_load;
wire [7:0]            tx_chnl_dprio_status;
wire                  tx_chnl_dprio_status_write_en;
wire                  tx_chnl_dprio_status_write_en_ack;
wire                  r_tx_hrdrst_rst_sm_dis;
wire                  r_tx_hrdrst_dcd_cal_done_bypass;
wire                  r_tx_hrdrst_dll_lock_bypass;
wire                  r_tx_hrdrst_align_bypass;
wire                  r_tx_hrdrst_user_ctl_en;
wire                  r_tx_presethint_bypass;
wire                  r_tx_hrdrst_rx_osc_clk_scg_en;
wire                  r_tx_hip_osc_clk_scg_en;
wire                  r_tx_ds_last_chnl;
wire                  r_tx_us_last_chnl;
wire                  sr_fabric_tx_transfer_en;
wire                  r_rx_hrdrst_rst_sm_dis;
wire                  r_rx_hrdrst_dcd_cal_done_bypass;
wire                  r_rx_rmfflag_stretch_enable;
wire  [2:0]           r_rx_rmfflag_stretch_num_stages;
wire                  r_rx_hrdrst_rx_osc_clk_scg_en;
wire                  r_rx_ds_last_chnl;
wire                  r_rx_us_last_chnl;
wire                  avmm_hrdrst_hssi_osc_transfer_en_ssr_data;
wire                  avmm_async_hssi_fabric_ssr_load;
wire                  avmm_hrdrst_fabric_osc_transfer_en_ssr_data;
wire                  avmm_async_fabric_hssi_ssr_load;
wire                  avmm_hrdrst_hssi_osc_transfer_en_sync;
wire  [1:0]           r_tx_fifo_power_mode;
wire [4:0]            r_tx_wren_fastbond;
wire  [2:0]           r_tx_stretch_num_stages;
wire  [2:0]           r_tx_datapath_tb_sel;
wire                  r_tx_wr_adj_en;
wire                  r_tx_rd_adj_en;

wire  [1:0]           r_rx_fifo_power_mode;
wire  [2:0]           r_rx_stretch_num_stages;
wire  [3:0]           r_rx_datapath_tb_sel;
wire                  r_rx_wr_adj_en;
wire                  r_rx_rd_adj_en;
wire                  r_rx_msb_rdptr_pipe_byp;
wire                  r_tx_dv_gating_en;
wire                  tx_direct_transfer_testbus;

wire                  tx_clock_fifo_wr_clk;
wire                  tx_clock_fifo_rd_clk;

wire                  txeq_rxeqeval;
wire                  txeq_rxeqinprogress;
wire                  txeq_invalid_req;
wire                  txeq_txdetectrx;
wire [1:0]            txeq_rate;
wire [1:0]            txeq_powerdown;
wire [1:0]            r_rx_adapter_lpbk_mode;
wire                  r_rx_aib_lpbk_en;

wire [39:0]           aib_hssi_tx_data_lpbk;
wire [39:0]           tx_pma_data_lpbk;
wire [79:0]           tx_fifo_data_lpbk;

wire                  sr_clock_tx_sr_clk_in_div2;
wire                  sr_clock_tx_sr_clk_in_div4;
wire                  sr_clock_tx_osc_clk_or_clkdiv;

wire [1:0]            rx_async_fabric_hssi_ssr_reserved;
wire [1:0]            rx_async_hssi_fabric_ssr_reserved;

wire [2:0]            tx_async_fabric_hssi_ssr_reserved;
wire [2:0]            tx_async_hssi_fabric_ssr_reserved;

wire                  r_sr_reserbits_in_en;
wire                  r_sr_reserbits_out_en;
wire                  r_tx_qpi_sr_enable;
wire                  r_tx_usertest_sel;
wire                  r_tx_latency_src_xcvrif;
wire                  r_rstctl_tx_pld_div2_rst_opt;
wire [19:0]           avmm_testbus;
wire [3:0]            avmm_hrdrst_tb_direct;
wire [15:0]           dec_arb_tb_direct;
wire                  sr_fabric_osc_transfer_en;
wire [2:0]            pld_g3_current_rxpreset;

wire [19:0]           tx_chnl_testbus;
wire                  r_rx_pld_8g_a1a2_k1k2_flag_polling_bypass;
wire                  r_rx_10g_krfec_rx_diag_data_stat_poll_byp;
wire                  r_rx_pld_8g_wa_boundary_polling_bypass;
wire                  r_rx_pcspma_testbus_sel;
wire                  r_rx_pld_pma_pcie_sw_done_polling_bypass;
wire                  r_rx_pld_pma_reser_in_polling_bypass;
wire                  r_rx_pld_pma_testbus_polling_bypass;
wire                  r_rx_pld_test_data_polling_bypass;
wire                  r_tx_rev_lpbk;
wire                  tx_fsr_parity_checker_in;
wire [38:0]           tx_ssr_parity_checker_in;
wire                  hip_fsr_parity_checker_in;
wire [4:0]            hip_ssr_parity_checker_in;
wire [2:0]            rx_fsr_parity_checker_in;
wire [37:0]           rx_ssr_parity_checker_in;
wire [5:0]            sr_parity_error_flag;
wire                  sr_clock_aib_rx_sr_clk;
wire                  avmm_transfer_error;
wire [1:0]            r_rx_parity_sel;
wire [7:0]            sr_testbus;

wire                  pld_10g_krfec_rx_clr_errblk_cnt;
wire                  pld_8g_a1a2_size;
wire                  pld_8g_bitloc_rev_en;
wire                  pld_polinv_rx;
wire                  pld_8g_byte_rev_en;
wire [2:0]            pld_8g_eidleinfersel;
wire                  pld_10g_rx_clr_ber_count;
wire                  pld_pma_rx_qpi_pullup;
wire                  pld_pma_tx_qpi_pullup;
wire                  pld_pma_tx_qpi_pulldn;
wire                  pld_polinv_tx;
wire [6:0]            pld_10g_tx_bitslip;
wire [4:0]            pld_8g_tx_boundary_sel;
wire                  pld_bitslip;
wire                  pld_rx_prbs_err;
wire                  pld_rx_prbs_done;
wire                  pld_10g_rx_hi_ber;
wire                  pld_10g_rx_frame_lock;
wire                  pld_10g_krfec_rx_frame;
wire [1:0]            pld_10g_krfec_rx_diag_data_status;
wire [4:0]            pld_8g_wa_boundary;
wire                  pld_8g_full_rmf;
wire                  pld_8g_empty_rmf;
wire [3:0]            pld_8g_a1a2_k1k2_flag;
wire                  pld_krfec_tx_alignment;
wire [7:0]            w_ehip_ssr;
wire                  pld_10g_krfec_rx_blk_lock;
wire [19:0]           pld_test_data;
wire                  pld_chnl_cal_done;
wire                  pld_pll_cal_done;
wire                  pld_pma_ltd_b;
wire                  pld_txelecidle;
wire                  pld_ltr;
wire                  pld_8g_encdt;
wire                  pld_rx_prbs_err_clr;
wire                  pld_syncsm_en;
wire                  pld_pma_adapt_start;
wire                  pld_pma_csr_test_dis;
wire                  pld_pma_early_eios;
wire [5:0]            pld_pma_eye_monitor;
wire [3:0]            pld_pma_fpll_cnt_sel;
wire                  pld_pma_fpll_extswitch;
wire                  pld_pma_fpll_lc_csr_test_dis;
wire [2:0]            pld_pma_fpll_num_phase_shifts;
wire                  pld_pma_fpll_pfden;
wire                  pld_pma_fpll_up_dn_lc_lf_rstn;
wire                  pld_pma_nrpi_freeze;
wire [1:0]            pld_pma_pcie_switch;
wire                  pld_pma_ppm_lock;
wire [4:0]            pld_pma_reserved_out;
wire                  pld_pma_rs_lpbk_b;
wire                  pld_pmaif_rxclkslip;
wire                  pld_pma_tx_bitslip;
wire                  pld_pma_fpll_clk0bad;
wire                  pld_pma_fpll_clk1bad;
wire                  pld_pma_fpll_clksel;
wire                  pld_pma_fpll_phase_done;
wire                  pld_pma_adapt_done;
wire [1:0]            pld_pma_pcie_sw_done;
wire                  pld_pma_rx_detect_valid;
wire                  pld_pma_signal_ok;
wire                  pld_pma_rx_found;
wire [7:0]            pld_pma_testbus;
wire [4:0]            pld_pma_reserved_in;

wire                  tx_aib_transfer_div2_clk;
wire                  tx_aib_transfer_clk;
wire                  pld_8g_signal_detect_out;
wire                  pld_10g_rx_crc32_err;
wire                  pld_pmaif_mask_tx_pll;
wire                  tx_clock_fifo_rd_prect_clk;
wire                  rx_chnl_fifo_sclk;
wire                  r_sr_test_enable;
wire [64:0]           w_chnl_ssr;
wire [3:0]            w_ehip_fsr;
wire                  w_aib_rx_adpt_rst_n;
wire                  w_aib_tx_adpt_rst_n;
wire                  w_aib_rx_elane_rst_n;
wire                  w_aib_tx_elane_rst_n;
wire                  w_aib_rx_xcvrif_rst_n;
wire                  w_aib_tx_xcvrif_rst_n;

wire                  r_rstctl_rx_adpt_ovren;
wire                  r_rstctl_tx_adpt_ovren;
wire                  r_rstctl_rx_elane_ovren;
wire                  r_rstctl_tx_elane_ovren;
wire                  r_rstctl_rx_xcvrif_ovren;
wire                  r_rstctl_tx_xcvrif_ovren;

wire                  r_rstctl_rx_adpt_ovrval;
wire                  r_rstctl_tx_adpt_ovrval;
wire                  r_rstctl_rx_elane_ovrval;
wire                  r_rstctl_tx_elane_ovrval;
wire                  r_rstctl_rx_xcvrif_ovrval;
wire                  r_rstctl_tx_xcvrif_ovrval;
wire                  sr_pld_latency_pulse_sel;
wire                  tx_aib_transfer_clk_rst_n;
wire [3:0]            rx_hrdrst_tb_direct;
wire [3:0]            tx_hrdrst_tb_direct;
wire [4:0]            fpll_shared_direct_async;
wire                  rsvd_direct_async;
wire [3:0]            tb_direct_async;

assign o_aibdftcore2dll = i_dftcore2dll;
assign o_dftdll2core    = i_aibdftdll2core;

assign o_ehip_cfg_clk      =  i_cfg_avmm_clk;
assign o_ehip_cfg_rst_n    =  i_cfg_avmm_rst_n;
assign o_ehip_cfg_addr     =  i_cfg_avmm_addr;
assign o_ehip_cfg_wdata    =  i_cfg_avmm_wdata;
assign o_ehip_cfg_byte_en  =  i_cfg_avmm_byte_en;

assign o_elane_cfg_rst_n   = i_cfg_avmm_rst_n;
assign o_xcvrif_cfg_rst_n  = i_cfg_avmm_rst_n;

// To Adapter in next channel
assign o_adpt_cfg_clk     =  i_cfg_avmm_clk;
assign o_adpt_cfg_rst_n   =  i_cfg_avmm_rst_n;
assign o_adpt_cfg_addr    =  i_cfg_avmm_addr;
assign o_adpt_cfg_wdata   =  i_cfg_avmm_wdata;
assign o_adpt_cfg_byte_en =  i_cfg_avmm_byte_en;

// Channel FSR/SSR assignment
assign o_chnl_ssr[0+:5]  = pld_8g_tx_boundary_sel[4:0];
assign o_chnl_ssr[5+:7]  = pld_10g_tx_bitslip[6:0];
assign o_chnl_ssr[12+:1] = pld_polinv_tx;
assign o_chnl_ssr[13+:1] = pld_pma_tx_qpi_pulldn;
assign o_chnl_ssr[14+:1] = pld_pma_tx_qpi_pullup;
assign o_chnl_ssr[15+:1] = pld_pma_rx_qpi_pullup;
assign o_chnl_ssr[16+:1] = pld_8g_a1a2_size;
assign o_chnl_ssr[17+:1] = pld_8g_bitloc_rev_en;
assign o_chnl_ssr[18+:1] = pld_8g_byte_rev_en;
assign o_chnl_ssr[19+:3] = pld_8g_eidleinfersel[2:0];
assign o_chnl_ssr[22+:1] = pld_8g_encdt;
assign o_chnl_ssr[23+:1] = pld_10g_krfec_rx_clr_errblk_cnt;
assign o_chnl_ssr[24+:1] = pld_10g_rx_clr_ber_count;
assign o_chnl_ssr[25+:1] = pld_bitslip;
assign o_chnl_ssr[26+:1] = pld_polinv_rx;
assign o_chnl_ssr[27+:1] = pld_rx_prbs_err_clr;
assign o_chnl_ssr[28+:1] = pld_syncsm_en;

assign o_chnl_ssr[29+:1] = pld_pma_csr_test_dis;
assign o_chnl_ssr[30+:4] = pld_pma_fpll_cnt_sel;
assign o_chnl_ssr[34+:1] = pld_pma_fpll_extswitch;
assign o_chnl_ssr[35+:3] = pld_pma_fpll_num_phase_shifts;
assign o_chnl_ssr[38+:1] = pld_pma_fpll_pfden;
assign o_chnl_ssr[39+:1] = pld_pma_fpll_up_dn_lc_lf_rstn;
assign o_chnl_ssr[40+:1] = pld_pma_fpll_lc_csr_test_dis;
assign o_chnl_ssr[41+:1] = pld_pma_nrpi_freeze;
assign o_chnl_ssr[42+:1] = pld_pma_tx_bitslip;
assign o_chnl_ssr[43+:1] = pld_pma_adapt_start;
assign o_chnl_ssr[44+:1] = pld_pma_early_eios;
assign o_chnl_ssr[45+:6] = pld_pma_eye_monitor;
assign o_chnl_ssr[51+:2] = pld_pma_pcie_switch;
assign o_chnl_ssr[53+:1] = pld_pma_ppm_lock;
assign o_chnl_ssr[54+:1] = pld_pma_rs_lpbk_b;
assign o_chnl_ssr[55+:1] = pld_pmaif_rxclkslip;
assign o_chnl_ssr[56+:5] = pld_pma_reserved_out;

// Route direct-async signals to FSR/SSR registers for testing
assign pld_8g_signal_detect_out  = r_sr_test_enable ? i_aib_tx_adpt_rst_n   : i_chnl_fsr[0];
assign pld_10g_rx_crc32_err      = r_sr_test_enable ? i_aib_rx_xcvrif_rst_n : i_chnl_fsr[1];
assign pld_pmaif_mask_tx_pll     = r_sr_test_enable ? i_aib_tx_xcvrif_rst_n : i_chnl_fsr[2];

generate
  genvar i;
  for (i=0; i <= 64; i=i+1) begin: sr_test_pld_test_data
    if (i%7==0) assign w_chnl_ssr[i] = r_sr_test_enable ? i_aib_rsvd_direct_async : i_chnl_ssr[i];
    if (i%7==1) assign w_chnl_ssr[i] = r_sr_test_enable ? i_aib_rx_elane_rst_n    : i_chnl_ssr[i];
    if (i%7==2) assign w_chnl_ssr[i] = r_sr_test_enable ? i_aib_tx_elane_rst_n    : i_chnl_ssr[i];
    if (i%7==3) assign w_chnl_ssr[i] = r_sr_test_enable ? i_aib_rx_adpt_rst_n     : i_chnl_ssr[i];
    if (i%7==4) assign w_chnl_ssr[i] = r_sr_test_enable ? i_aib_tx_adpt_rst_n     : i_chnl_ssr[i];
    if (i%7==5) assign w_chnl_ssr[i] = r_sr_test_enable ? i_aib_rx_xcvrif_rst_n   : i_chnl_ssr[i];
    if (i%7==6) assign w_chnl_ssr[i] = r_sr_test_enable ? i_aib_tx_xcvrif_rst_n   : i_chnl_ssr[i];
  end
endgenerate

assign pld_10g_krfec_rx_blk_lock         = w_chnl_ssr[0+:1];
assign pld_test_data[19:0]               = w_chnl_ssr[1+:20];
assign pld_chnl_cal_done                 = w_chnl_ssr[21+:1];
assign pld_pll_cal_done                  = w_chnl_ssr[22+:1];
assign pld_pma_fpll_clk0bad              = w_chnl_ssr[23+:1];
assign pld_pma_fpll_clk1bad              = w_chnl_ssr[24+:1];
assign pld_pma_fpll_clksel               = w_chnl_ssr[25+:1];
assign pld_pma_fpll_phase_done           = w_chnl_ssr[26+:1];
assign pld_pma_adapt_done                = w_chnl_ssr[27+:1];
assign pld_pma_pcie_sw_done              = w_chnl_ssr[28+:2];
assign pld_pma_rx_detect_valid           = w_chnl_ssr[30+:1];
assign pld_pma_signal_ok                 = w_chnl_ssr[31+:1];
assign pld_pma_rx_found                  = w_chnl_ssr[32+:1];
assign pld_pma_testbus                   = w_chnl_ssr[33+:8];
assign pld_pma_reserved_in               = w_chnl_ssr[41+:5];
assign pld_krfec_tx_alignment            = w_chnl_ssr[46+:1];
assign pld_8g_a1a2_k1k2_flag[3:0]        = w_chnl_ssr[47+:4];
assign pld_8g_empty_rmf                  = w_chnl_ssr[51+:1];
assign pld_8g_full_rmf                   = w_chnl_ssr[52+:1];
assign pld_8g_wa_boundary[4:0]           = w_chnl_ssr[53+:5];
assign pld_10g_krfec_rx_diag_data_status = w_chnl_ssr[58+:2];
assign pld_10g_krfec_rx_frame            = w_chnl_ssr[60+:1];
assign pld_10g_rx_frame_lock             = w_chnl_ssr[61+:1];
assign pld_10g_rx_hi_ber                 = w_chnl_ssr[62+:1];
assign pld_rx_prbs_done                  = w_chnl_ssr[63+:1];
assign pld_rx_prbs_err                   = w_chnl_ssr[64+:1];

// EHIP FSR/SSR
assign w_ehip_ssr[0]                     = r_sr_test_enable ? i_aib_rsvd_direct_async : i_ehip_ssr[0];
assign w_ehip_ssr[1]                     = r_sr_test_enable ? i_aib_rx_elane_rst_n    : i_ehip_ssr[1];
assign w_ehip_ssr[2]                     = r_sr_test_enable ? i_aib_tx_elane_rst_n    : i_ehip_ssr[2];
assign w_ehip_ssr[3]                     = r_sr_test_enable ? i_aib_rx_adpt_rst_n     : i_ehip_ssr[3];
assign w_ehip_ssr[4]                     = r_sr_test_enable ? i_aib_tx_adpt_rst_n     : i_ehip_ssr[4];
assign w_ehip_ssr[5]                     = r_sr_test_enable ? i_aib_rx_xcvrif_rst_n   : i_ehip_ssr[5];
assign w_ehip_ssr[6]                     = r_sr_test_enable ? i_aib_tx_xcvrif_rst_n   : i_ehip_ssr[6];
assign w_ehip_ssr[7]                     = r_sr_test_enable ? i_aib_rsvd_direct_async : i_ehip_ssr[7];

assign w_ehip_fsr[0]                     =  r_sr_test_enable ? i_aib_rsvd_direct_async : i_ehip_fsr[0];
assign w_ehip_fsr[1]                     =  r_sr_test_enable ? i_aib_rx_elane_rst_n    : i_ehip_fsr[1];
assign w_ehip_fsr[2]                     =  r_sr_test_enable ? i_aib_tx_elane_rst_n    : i_ehip_fsr[2];
assign w_ehip_fsr[3]                     =  r_sr_test_enable ? i_aib_rx_adpt_rst_n     : i_ehip_fsr[3];

assign o_chnl_fsr[0]                     = pld_txelecidle;
assign o_chnl_fsr[1]                     = pld_ltr;
assign o_chnl_fsr[2]                     = pld_pma_ltd_b;

assign o_tx_transfer_clk                 = tx_aib_transfer_clk;
assign o_tx_transfer_div2_clk            = tx_aib_transfer_div2_clk;

// PLD reset override
assign w_aib_rx_adpt_rst_n   = r_rstctl_rx_adpt_ovren   ? r_rstctl_rx_adpt_ovrval   : i_aib_rx_adpt_rst_n;
assign w_aib_tx_adpt_rst_n   = r_rstctl_tx_adpt_ovren   ? r_rstctl_tx_adpt_ovrval   : i_aib_tx_adpt_rst_n;
assign w_aib_rx_elane_rst_n  = r_rstctl_rx_elane_ovren  ? r_rstctl_rx_elane_ovrval  : i_aib_rx_elane_rst_n;
assign w_aib_tx_elane_rst_n  = r_rstctl_tx_elane_ovren  ? r_rstctl_tx_elane_ovrval  : i_aib_tx_elane_rst_n;
assign w_aib_rx_xcvrif_rst_n = r_rstctl_rx_xcvrif_ovren ? r_rstctl_rx_xcvrif_ovrval : i_aib_rx_xcvrif_rst_n;
assign w_aib_tx_xcvrif_rst_n = r_rstctl_tx_xcvrif_ovren ? r_rstctl_tx_xcvrif_ovrval : i_aib_tx_xcvrif_rst_n;

// i_fpll_shared_direct_async[4:0] --> o_aib_shared_direct_async[4:0]
// Re-purpose direct signal to observe internal states
// [4]                                     --> aib75
// [3:2] configured for differential clock --> aib70/71
// [1:0] configured for differential clock --> aib68/69
// rsvd_direct_async                       --> aib66
assign tb_direct_async = (i_aib_shared_direct_async[2:0] == TP_RX_RSTCTL)   ? rx_hrdrst_tb_direct      :
                         (i_aib_shared_direct_async[2:0] == TP_TX_RSTCTL)   ? tx_hrdrst_tb_direct      :
                         (i_aib_shared_direct_async[2:0] == TP_AVMM_RSTCTL) ? avmm_hrdrst_tb_direct    : 
                         (i_aib_shared_direct_async[2:0] == TP_AVMM_DEC0)   ? dec_arb_tb_direct[0+:4]  :
                         (i_aib_shared_direct_async[2:0] == TP_AVMM_DEC1)   ? dec_arb_tb_direct[4+:4]  :
                         (i_aib_shared_direct_async[2:0] == TP_AVMM_DEC2)   ? dec_arb_tb_direct[8+:4]  :
                         (i_aib_shared_direct_async[2:0] == TP_AVMM_DEC3)   ? dec_arb_tb_direct[12+:4] : '0;

assign rsvd_direct_async           = tb_direct_async[3];
assign fpll_shared_direct_async[4] = tb_direct_async[2];
assign fpll_shared_direct_async[3] = tb_direct_async[1];
assign fpll_shared_direct_async[2] = tb_direct_async[1];
assign fpll_shared_direct_async[1] = tb_direct_async[0];
assign fpll_shared_direct_async[0] = tb_direct_async[0];

assign sl_sideband = {sr_fabric_osc_transfer_en, rx_ssr_parity_checker_in[35:32], rx_ssr_parity_checker_in[30],tx_ssr_parity_checker_in[35:32], rx_ssr_parity_checker_in[31], rx_ssr_parity_checker_in[29:0], tx_ssr_parity_checker_in[31:0]};

c3aibadapt_txchnl adapt_txchnl   (/*AUTOINST*/
       // Outputs
       .tx_async_hssi_fabric_ssr_reserved           (tx_async_hssi_fabric_ssr_reserved),
       .tx_clock_fifo_rd_prect_clk                  (tx_clock_fifo_rd_prect_clk),
       .aib_hssi_fpll_shared_direct_async_out       (o_aib_shared_direct_async[4:0]),
       .aib_tx_pma_div66_clk                        (o_aib_tx_pma_div66_clk),
       .aib_hssi_tx_fifo_latency_pls                (o_aib_tx_fifo_latency_pls),
       .aib_pma_aib_tx_clk                          (o_aib_tx_pma_clk),
       .aib_pma_aib_tx_div2_clk                     (o_aib_tx_pma_div2_clk),
       .aib_hssi_tx_dcd_cal_req                     (o_aib_tx_dcd_cal_req),
       .aib_hssi_tx_dll_lock_req                    (o_aib_tx_dll_lock_req),
       .hip_aib_async_fsr_out                       (hip_aib_async_fsr_out[3:0]),
       .hip_aib_async_ssr_out                       (hip_aib_async_ssr_out[7:0]),
       .hip_aib_fsr_in                              (o_ehip_fsr[3:0]),
       .hip_aib_ssr_in                              (o_ehip_ssr[39:0]),
       .tx_ehip_data                                (o_tx_ehip_data[77:0]),
       .tx_elane_data                               (o_tx_elane_data),
       .tx_rsfec_data                               (o_tx_rsfec_data),
       .tx_pma_data                                 (o_tx_pma_data),
       .tx_fifo_data_lpbk                           (tx_fifo_data_lpbk),
       .aib_hssi_tx_data_lpbk                       (aib_hssi_tx_data_lpbk),
       .tx_pma_data_lpbk                            (tx_pma_data_lpbk),
       .tx_clock_fifo_wr_clk                        (tx_clock_fifo_wr_clk),
       .tx_clock_fifo_rd_clk                        (tx_clock_fifo_rd_clk),
       .txeq_invalid_req                            (txeq_invalid_req),
       .txeq_rxeqeval                               (txeq_rxeqeval),
       .txeq_rxeqinprogress                         (txeq_rxeqinprogress),
       .txeq_txdetectrx                             (txeq_txdetectrx),
       .txeq_rate                                   (txeq_rate),
       .txeq_powerdown                              (txeq_powerdown),
       .pcs_fpll_shared_direct_async_out            (o_fpll_shared_direct_async[2:0]),
       .usr_tx_elane_rst_n                          (o_tx_elane_rst_n),
       .pld_10g_tx_bitslip                          (pld_10g_tx_bitslip[6:0]),
       .pld_8g_g3_tx_pld_rst_n                      (/*NC*/),
       .pld_8g_tx_boundary_sel                      (pld_8g_tx_boundary_sel[4:0]),
       .pld_8g_wrenable_tx                          (),
       .pld_pma_csr_test_dis                        (pld_pma_csr_test_dis),
       .pld_pma_fpll_cnt_sel                        (pld_pma_fpll_cnt_sel[3:0]),
       .pld_pma_fpll_extswitch                      (pld_pma_fpll_extswitch),
       .pld_pma_fpll_lc_csr_test_dis                (pld_pma_fpll_lc_csr_test_dis),
       .pld_pma_fpll_num_phase_shifts               (pld_pma_fpll_num_phase_shifts[2:0]),
       .pld_pma_fpll_pfden                          (pld_pma_fpll_pfden),
       .pld_pma_fpll_up_dn_lc_lf_rstn               (pld_pma_fpll_up_dn_lc_lf_rstn),
       .pld_pma_nrpi_freeze                         (pld_pma_nrpi_freeze),
       .pld_pma_rx_qpi_pullup                       (pld_pma_rx_qpi_pullup),
       .pld_pma_tx_bitslip                          (pld_pma_tx_bitslip),
       .pld_pma_tx_qpi_pulldn                       (pld_pma_tx_qpi_pulldn),
       .pld_pma_tx_qpi_pullup                       (pld_pma_tx_qpi_pullup),
       .pld_pma_txdetectrx                          (o_rsvd_direct_async),
       .pld_pma_txpma_rstb                          (o_tx_xcvrif_rst_n),
       .pld_polinv_tx                               (pld_polinv_tx),
       .pld_txelecidle                              (pld_txelecidle),
       .tx_aib_transfer_clk                         (tx_aib_transfer_clk),
       .tx_aib_transfer_clk_rst_n                   (tx_aib_transfer_clk_rst_n),
       .tx_aib_transfer_div2_clk                    (tx_aib_transfer_div2_clk),
       .rx_pld_rate                                 (rx_pld_rate[1:0]),
       .tx_async_hssi_fabric_fsr_data               (tx_async_hssi_fabric_fsr_data),
       .tx_async_hssi_fabric_ssr_data               (tx_async_hssi_fabric_ssr_data[12:0]),
       .tx_chnl_dprio_status                        (tx_chnl_dprio_status[7:0]),
       .tx_chnl_dprio_status_write_en_ack           (tx_chnl_dprio_status_write_en_ack),
       .sr_fabric_tx_transfer_en                    (sr_fabric_tx_transfer_en),
       .tx_chnl_testbus                             (tx_chnl_testbus),
       .tx_hrdrst_tb_direct                         (tx_hrdrst_tb_direct),
       .tx_fsr_parity_checker_in                    (tx_fsr_parity_checker_in),
       .tx_ssr_parity_checker_in                    (tx_ssr_parity_checker_in),
       .hip_fsr_parity_checker_in                   (hip_fsr_parity_checker_in),
       .hip_ssr_parity_checker_in                   (hip_ssr_parity_checker_in),
       .align_done                                  (m_rxfifo_align_done),
       // Inputs
       .scan_mode_n                                 (i_scan_mode_n),
       .t0_tst_tcm_ctrl                             (i_txchnl_0_tst_tcm_ctrl),
       .t0_test_clk                                 (i_txchnl_0_test_clk),
       .t0_scan_clk                                 (i_txchnl_0_scan_clk),
       .t1_tst_tcm_ctrl                             (i_txchnl_1_tst_tcm_ctrl),
       .t1_test_clk                                 (i_txchnl_1_test_clk),
       .t1_scan_clk                                 (i_txchnl_1_scan_clk),
       .t2_tst_tcm_ctrl                             (i_txchnl_2_tst_tcm_ctrl),
       .t2_test_clk                                 (i_txchnl_2_test_clk),
       .t2_scan_clk                                 (i_txchnl_2_scan_clk),
       .dft_adpt_rst                                (1'b0),
       .adpt_scan_rst_n                             (i_scan_rst_n),
       .adpt_scan_mode_n                            (i_scan_mode_n),
       .tx_async_fabric_hssi_ssr_reserved           (tx_async_fabric_hssi_ssr_reserved),
       .aib_hssi_adapter_tx_pld_rst_n               (w_aib_tx_adpt_rst_n),
       .aib_hssi_fpll_shared_direct_async_in        (i_aib_shared_direct_async[2:0]),
       .sr_clock_tx_osc_clk_or_clkdiv               (sr_clock_tx_osc_clk_or_clkdiv),
       .aib_hssi_pld_sclk                           (rx_chnl_fifo_sclk),
       .aib_hssi_rx_sr_clk_in                       (sr_clock_aib_rx_sr_clk),
       .aib_hssi_pcs_tx_pld_rst_n                   (w_aib_tx_elane_rst_n),
       .aib_hssi_pld_pma_txdetectrx                 (i_aib_rsvd_direct_async),
       .aib_hssi_pld_pma_txpma_rstb                 (w_aib_tx_xcvrif_rst_n),
       .aib_hssi_tx_data_in                         (i_aib_tx_data[39:0]),
       .aib_hssi_rx_data_out                        (o_aib_rx_data[39:0]),
       .aib_hssi_tx_transfer_clk                    (i_aib_tx_transfer_clk),
       .aib_hssi_tx_dcd_cal_done                    (i_aib_tx_dcd_cal_done),
       .aib_hssi_tx_dll_lock                        (i_aib_tx_dll_lock),
       .csr_rdy_dly_in                              (i_adpt_hard_rst_n),
       .hip_aib_async_fsr_in                        (hip_aib_async_fsr_in[3:0]),
       .hip_aib_async_ssr_in                        (hip_aib_async_ssr_in[39:0]),
       .hip_aib_fsr_out                             (w_ehip_fsr),
       .hip_aib_ssr_out                             (w_ehip_ssr),
       .pcs_fpll_shared_direct_async_in             (fpll_shared_direct_async[4:0]),
       .pld_krfec_tx_alignment                      (pld_krfec_tx_alignment),
       .pld_pma_div66_clk                           (i_tx_pma_div66_clk),
       .pld_pma_fpll_clk0bad                        (pld_pma_fpll_clk0bad),
       .pld_pma_fpll_clk1bad                        (pld_pma_fpll_clk1bad),
       .pld_pma_fpll_clksel                         (pld_pma_fpll_clksel),
       .pld_pma_fpll_phase_done                     (pld_pma_fpll_phase_done),
       .pld_pmaif_mask_tx_pll                       (pld_pmaif_mask_tx_pll),
       .tx_ehip_clk                                 (i_tx_ehip_clk),
       .tx_rsfec_clk                                (i_tx_rsfec_clk),
       .tx_elane_clk                                (i_tx_elane_clk),
       .tx_pma_clk                                  (i_tx_pma_clk),
       .tx_direct_transfer_testbus                  (tx_direct_transfer_testbus),
       .xcvrif_tx_latency_pls                       (i_xcvrif_tx_latency_pls),
       .r_tx_qpi_sr_enable                          (r_tx_qpi_sr_enable),
       .r_tx_usertest_sel                           (r_tx_usertest_sel),
       .r_tx_latency_src_xcvrif                     (r_tx_latency_src_xcvrif),
       .r_rstctl_tx_pld_div2_rst_opt                (r_rstctl_tx_pld_div2_rst_opt),
       .r_tx_async_hip_aib_fsr_in_bit0_rst_val      (r_tx_async_hip_aib_fsr_in_bit0_rst_val),
       .r_tx_async_hip_aib_fsr_in_bit1_rst_val      (r_tx_async_hip_aib_fsr_in_bit1_rst_val),
       .r_tx_async_hip_aib_fsr_in_bit2_rst_val      (r_tx_async_hip_aib_fsr_in_bit2_rst_val),
       .r_tx_async_hip_aib_fsr_in_bit3_rst_val      (r_tx_async_hip_aib_fsr_in_bit3_rst_val),
       .r_tx_async_hip_aib_fsr_out_bit0_rst_val     (r_tx_async_hip_aib_fsr_out_bit0_rst_val),
       .r_tx_async_hip_aib_fsr_out_bit1_rst_val     (r_tx_async_hip_aib_fsr_out_bit1_rst_val),
       .r_tx_async_hip_aib_fsr_out_bit2_rst_val     (r_tx_async_hip_aib_fsr_out_bit2_rst_val),
       .r_tx_async_hip_aib_fsr_out_bit3_rst_val     (r_tx_async_hip_aib_fsr_out_bit3_rst_val),
       .r_tx_async_pld_pmaif_mask_tx_pll_rst_val    (r_tx_async_pld_pmaif_mask_tx_pll_rst_val),
       .r_tx_async_pld_txelecidle_rst_val           (r_tx_async_pld_txelecidle_rst_val),
       .r_tx_bonding_dft_in_en                      (r_tx_bonding_dft_in_en),
       .r_tx_bonding_dft_in_value                   (r_tx_bonding_dft_in_value),
       .r_tx_chnl_datapath_map_mode                 (r_tx_chnl_datapath_map_mode),
       .r_tx_chnl_datapath_map_rxqpi_pullup_init_val(r_tx_chnl_datapath_map_rxqpi_pullup_init_val),
       .r_tx_chnl_datapath_map_txqpi_pulldn_init_val(r_tx_chnl_datapath_map_txqpi_pulldn_init_val),
       .r_tx_chnl_datapath_map_txqpi_pullup_init_val(r_tx_chnl_datapath_map_txqpi_pullup_init_val),
       .r_tx_comp_cnt                               (r_tx_comp_cnt[7:0]),
       .r_tx_compin_sel                             (r_tx_compin_sel[1:0]),
       .r_tx_double_read                            (r_tx_double_read),
       .r_tx_ds_bypass_pipeln                       (r_tx_ds_bypass_pipeln),
       .r_tx_ds_master                              (r_tx_ds_master),
       .r_tx_dyn_clk_sw_en                          (r_tx_dyn_clk_sw_en),
       .r_tx_fifo_empty                             (r_tx_fifo_empty[4:0]),
       .r_tx_fifo_full                              (r_tx_fifo_full[4:0]),
       .r_tx_fifo_mode                              (r_tx_fifo_mode[1:0]),
       .r_tx_fifo_pempty                            (r_tx_fifo_pempty[4:0]),
       .r_tx_fifo_pfull                             (r_tx_fifo_pfull[4:0]),
       .r_tx_fifo_rd_clk_scg_en                     (r_tx_fifo_rd_clk_scg_en),
       .r_tx_fifo_rd_clk_sel                        (r_tx_fifo_rd_clk_sel),
       .r_tx_fifo_wr_clk_scg_en                     (r_tx_fifo_wr_clk_scg_en),
       .r_tx_indv                                   (r_tx_indv),
       .r_tx_osc_clk_scg_en                         (r_tx_osc_clk_scg_en),
       .r_tx_phcomp_rd_delay                        (r_tx_phcomp_rd_delay[2:0]),
       .r_tx_stop_read                              (r_tx_stop_read),
       .r_tx_stop_write                             (r_tx_stop_write),
       .r_tx_us_bypass_pipeln                       (r_tx_us_bypass_pipeln),
       .r_tx_us_master                              (r_tx_us_master),
       .r_tx_wa_en                                  (r_tx_wa_en),
       .r_tx_wren_fastbond                          (r_tx_wren_fastbond),
       .r_tx_fifo_power_mode                        (r_tx_fifo_power_mode),
       .r_tx_stretch_num_stages                     (r_tx_stretch_num_stages),
       .r_tx_datapath_tb_sel                        (r_tx_datapath_tb_sel),
       .r_tx_wr_adj_en                              (r_tx_wr_adj_en),
       .r_tx_rd_adj_en                              (r_tx_rd_adj_en),
       .r_tx_dv_gating_en                           (r_tx_dv_gating_en),
       .r_tx_rev_lpbk                               (r_tx_rev_lpbk),
       .pld_g3_current_rxpreset                     (pld_g3_current_rxpreset),
       .sr_pld_latency_pulse_sel                    (sr_pld_latency_pulse_sel),
       .rx_asn_fifo_hold                            (rx_asn_fifo_hold),
       .rx_asn_rate_change_in_progress              (rx_asn_rate_change_in_progress),
       .rx_asn_dll_lock_en                          (rx_asn_dll_lock_en),
       .r_tx_hrdrst_rst_sm_dis                      (r_tx_hrdrst_rst_sm_dis),
       .r_tx_hrdrst_dcd_cal_done_bypass             (r_tx_hrdrst_dcd_cal_done_bypass),
       .r_tx_hrdrst_dll_lock_bypass                 (r_tx_hrdrst_dll_lock_bypass),
       .r_tx_hrdrst_align_bypass                    (r_tx_hrdrst_align_bypass),
       .r_tx_hrdrst_user_ctl_en                     (r_tx_hrdrst_user_ctl_en),
       .r_tx_presethint_bypass                      (r_tx_presethint_bypass),
       .r_tx_ds_last_chnl                           (r_tx_ds_last_chnl),
       .r_tx_us_last_chnl                           (r_tx_us_last_chnl),
       .r_tx_free_run_div_clk                       (r_tx_free_run_div_clk),
       .r_tx_hrdrst_rx_osc_clk_scg_en               (r_tx_hrdrst_rx_osc_clk_scg_en),
       .r_tx_hip_osc_clk_scg_en                     (r_tx_hip_osc_clk_scg_en),
       .tx_async_fabric_hssi_fsr_data               (tx_async_fabric_hssi_fsr_data),
       .tx_async_fabric_hssi_fsr_load               (tx_async_fabric_hssi_fsr_load),
       .tx_async_fabric_hssi_ssr_data               (tx_async_fabric_hssi_ssr_data[35:0]),
       .tx_async_fabric_hssi_ssr_load               (tx_async_fabric_hssi_ssr_load),
       .tx_async_hssi_fabric_fsr_load               (tx_async_hssi_fabric_fsr_load),
       .tx_async_hssi_fabric_ssr_load               (tx_async_hssi_fabric_ssr_load),
       .avmm_hrdrst_hssi_osc_transfer_alive         (avmm_hrdrst_hssi_osc_transfer_alive),
       .tx_chnl_dprio_status_write_en               (tx_chnl_dprio_status_write_en)
);

c3aibadapt_rxchnl adapt_rxchnl   (/*AUTOINST*/
       // Outputs
       .aib_hssi_pld_pma_pfdmode_lock               (o_aib_xcvrif_tx_rdy),
       .pld_g3_current_rxpreset                     (pld_g3_current_rxpreset),
       .rx_async_hssi_fabric_ssr_reserved           (rx_async_hssi_fabric_ssr_reserved),
       .aib_hssi_pld_8g_rxelecidle                  (o_aib_rsvd_direct_async),
       .aib_rx_pma_div2_clk                         (o_aib_rx_pma_div2_clk),
       .aib_rx_pma_div66_clk                        (o_aib_rx_pma_div66_clk),
       .aib_hssi_pld_pma_hclk                       (o_aib_h_clk),
       .aib_hssi_pld_pma_internal_clk1              (o_aib_internal1_clk),
       .aib_hssi_pld_pma_internal_clk2              (o_aib_internal2_clk),
       .aib_hssi_pld_pma_rxpll_lock                 (o_aib_xcvrif_rx_rdy),
       .aib_hssi_rx_fifo_latency_pls                (o_aib_rx_fifo_latency_pls),
       .aib_hssi_rx_data_out                        (o_aib_rx_data[39:0]),
       .aib_hssi_rx_transfer_clk                    (o_aib_rx_transfer_clk),
       .aib_hssi_rx_dcd_cal_req                     (o_aib_rx_dcd_cal_req),
       .tx_direct_transfer_testbus                  (tx_direct_transfer_testbus),
       .pld_10g_krfec_rx_clr_errblk_cnt             (pld_10g_krfec_rx_clr_errblk_cnt),
       .usr_rx_elane_rst_n                          (o_rx_elane_rst_n),
       .pld_10g_rx_clr_ber_count                    (pld_10g_rx_clr_ber_count),
       .pld_8g_a1a2_size                            (pld_8g_a1a2_size),
       .pld_8g_bitloc_rev_en                        (pld_8g_bitloc_rev_en),
       .pld_8g_byte_rev_en                          (pld_8g_byte_rev_en),
       .pld_8g_eidleinfersel                        (pld_8g_eidleinfersel[2:0]),
       .pld_8g_encdt                                (pld_8g_encdt),
       .pld_bitslip                                 (pld_bitslip),
       .pld_ltr                                     (pld_ltr),
       .pld_pma_adapt_start                         (pld_pma_adapt_start),
       .pld_pma_coreclkin                           (o_xcvrif_core_clk),
       .pld_pma_early_eios                          (pld_pma_early_eios),
       .pld_pma_eye_monitor                         (pld_pma_eye_monitor[5:0]),
       .pld_pma_ltd_b                               (pld_pma_ltd_b),
       .pld_pma_pcie_switch                         (pld_pma_pcie_switch[1:0]),
       .pld_pma_ppm_lock                            (pld_pma_ppm_lock),
       .pld_pma_reserved_out                        (pld_pma_reserved_out[4:0]),
       .pld_pma_rs_lpbk_b                           (pld_pma_rs_lpbk_b),
       .pld_pma_rxpma_rstb                          (o_rx_xcvrif_rst_n),
       .pld_pmaif_rxclkslip                         (pld_pmaif_rxclkslip),
       .pld_polinv_rx                               (pld_polinv_rx),
       .pld_rx_prbs_err_clr                         (pld_rx_prbs_err_clr),
       .pld_syncsm_en                               (pld_syncsm_en),
       .sr_pld_latency_pulse_sel                    (sr_pld_latency_pulse_sel),
       .rx_asn_fifo_hold                            (rx_asn_fifo_hold),
       .rx_asn_rate                                 (rx_asn_rate[1:0]),
       .rx_asn_rate_change_in_progress              (rx_asn_rate_change_in_progress),
       .rx_asn_dll_lock_en                          (rx_asn_dll_lock_en),
       .rx_async_hssi_fabric_fsr_data               (rx_async_hssi_fabric_fsr_data[1:0]),
       .rx_async_hssi_fabric_ssr_data               (rx_async_hssi_fabric_ssr_data[62:0]),
       .hip_init_status                             (o_ehip_init_status[2:0]),
       .rx_asn_clk_en                               (rx_asn_clk_en),
       .rx_asn_gen3_sel                             (rx_asn_gen3_sel),
       .rx_chnl_dprio_status                        (rx_chnl_dprio_status[7:0]),
       .rx_chnl_dprio_status_write_en_ack           (rx_chnl_dprio_status_write_en_ack),
       .rx_fsr_parity_checker_in                    (rx_fsr_parity_checker_in),
       .rx_ssr_parity_checker_in                    (rx_ssr_parity_checker_in),
       .xcvrif_sclk                                 (o_xcvrif_sclk),
       .rx_chnl_fifo_sclk                           (rx_chnl_fifo_sclk),                    // shared TCM --> aib_hssi_pld_sclk
       .rx_hrdrst_tb_direct                         (rx_hrdrst_tb_direct),
       // Inputs
       .scan_mode_n                                 (i_scan_mode_n),
       .tst_tcm_ctrl                                (i_rxchnl_tst_tcm_ctrl),
       .test_clk                                    (i_rxchnl_test_clk),
       .scan_clk                                    (i_rxchnl_scan_clk),
       .rx_pma_data                                 (i_rx_pma_data),
       .sr_parity_error_flag                        (sr_parity_error_flag),
       .avmm_transfer_error                         (avmm_transfer_error),
       .pld_pma_pfdmode_lock                        (i_xcvrif_tx_rdy),
       .dft_adpt_rst                                (1'b0),
       .adpt_scan_rst_n                             (i_scan_rst_n),
       .r_rx_pld_8g_a1a2_k1k2_flag_polling_bypass   (r_rx_pld_8g_a1a2_k1k2_flag_polling_bypass),
       .r_rx_10g_krfec_rx_diag_data_status_polling_bypass(r_rx_10g_krfec_rx_diag_data_stat_poll_byp),
       .r_rx_pld_8g_wa_boundary_polling_bypass      (r_rx_pld_8g_wa_boundary_polling_bypass),
       .r_rx_pcspma_testbus_sel                     (r_rx_pcspma_testbus_sel),
       .r_rx_pld_pma_pcie_sw_done_polling_bypass    (r_rx_pld_pma_pcie_sw_done_polling_bypass),
       .r_rx_pld_pma_reser_in_polling_bypass        (r_rx_pld_pma_reser_in_polling_bypass),
       .r_rx_pld_pma_testbus_polling_bypass         (r_rx_pld_pma_testbus_polling_bypass),
       .r_rx_pld_test_data_polling_bypass           (r_rx_pld_test_data_polling_bypass),
       .rx_async_fabric_hssi_ssr_reserved           (rx_async_fabric_hssi_ssr_reserved),
       .sr_fabric_tx_transfer_en                    (sr_fabric_tx_transfer_en),
       .r_rx_txeq_en                                (r_rx_txeq_en),
       .r_rx_rxeq_en                                (r_rx_rxeq_en),
       .r_rx_pre_cursor_en                          (r_rx_pre_cursor_en),
       .r_rx_post_cursor_en                         (r_rx_post_cursor_en),
       .r_rx_invalid_no_change                      (r_rx_invalid_no_change),
       .r_rx_adp_go_b4txeq_en                       (r_rx_adp_go_b4txeq_en),
       .r_rx_use_rxvalid_for_rxeq                   (r_rx_use_rxvalid_for_rxeq),
       .r_rx_pma_rstn_en                            (r_rx_pma_rstn_en),
       .r_rx_pma_rstn_cycles                        (r_rx_pma_rstn_cycles),
       .r_rx_txeq_time                              (r_rx_txeq_time[7:0]),
       .r_rx_eq_iteration                           (r_rx_eq_iteration[1:0]),
       .r_rx_hrdrst_rst_sm_dis                      (r_rx_hrdrst_rst_sm_dis),
       .r_rx_hrdrst_dcd_cal_done_bypass             (r_rx_hrdrst_dcd_cal_done_bypass),
       .r_rx_rmfflag_stretch_enable                 (r_rx_rmfflag_stretch_enable),
       .r_rx_rmfflag_stretch_num_stages             (r_rx_rmfflag_stretch_num_stages),
       .r_rx_ds_last_chnl                           (r_rx_ds_last_chnl),
       .r_rx_us_last_chnl                           (r_rx_us_last_chnl),
       .r_rx_hrdrst_rx_osc_clk_scg_en               (r_rx_hrdrst_rx_osc_clk_scg_en),
       .aib_hssi_adapter_rx_pld_rst_n               (w_aib_rx_adpt_rst_n),
       .sr_clock_tx_sr_clk_in_div2                  (sr_clock_tx_sr_clk_in_div2),
       .sr_clock_tx_sr_clk_in_div4                  (sr_clock_tx_sr_clk_in_div4),
       .sr_clock_tx_osc_clk_or_clkdiv               (sr_clock_tx_osc_clk_or_clkdiv),
       .aib_hssi_pcs_rx_pld_rst_n                   (w_aib_rx_elane_rst_n),
       .aib_hssi_pld_pma_coreclkin                  (i_aib_core_clk),
       .aib_hssi_pld_pma_rxpma_rstb                 (w_aib_rx_xcvrif_rst_n),
       .aib_hssi_pld_sclk                           (i_aib_sclk),
       .aib_hssi_rx_sr_clk_in                       (sr_clock_aib_rx_sr_clk),
       .xcvrif_rx_latency_pls                       (i_xcvrif_rx_latency_pls),
       .tx_aib_transfer_clk                         (tx_aib_transfer_clk),             //Input: Used for loopback 1x, and drive (optionally) aib_rx_transfer_clk
       .tx_aib_transfer_clk_rst_n                   (tx_aib_transfer_clk_rst_n),
       .tx_aib_transfer_div2_clk                    (tx_aib_transfer_div2_clk),
       .aib_hssi_rx_dcd_cal_done                    (i_aib_rx_dcd_cal_done),
       .aib_hssi_fpll_shared_direct_async_in        (i_aib_shared_direct_async[0]),
       .avmm1_clock_avmm_clk_scg                    (avmm1_clock_avmm_clk_scg),
       .avmm1_clock_avmm_clk_dcg                    (avmm1_clock_avmm_clk_dcg),
       .avmm2_clock_avmm_clk_scg                    (avmm2_clock_avmm_clk_scg),
       .avmm2_clock_avmm_clk_dcg                    (avmm2_clock_avmm_clk_dcg),
       .avmm_hrdrst_hssi_osc_transfer_alive         (avmm_hrdrst_hssi_osc_transfer_alive),
       .csr_rdy_dly_in                              (i_adpt_hard_rst_n),
       .rx_ehip_clk                                 (i_rx_ehip_clk),
       .rx_ehip_frd_clk                             (i_rx_ehip_frd_clk),
       .rx_elane_clk                                (i_rx_elane_clk),
       .rx_rsfec_clk                                (i_rx_rsfec_clk),
       .rx_rsfec_frd_clk                            (i_rx_rsfec_frd_clk),
       .rx_pma_div2_clk                             (i_rx_pma_div2_clk),
       .rx_pma_clk                                  (i_rx_pma_clk),
       .tx_pma_clk                                  (i_tx_pma_clk),                    // Drives RX FIFO read-clock and (optionally) aib_rx_transfer_clk
       .tx_clock_fifo_rd_prect_clk                  (tx_clock_fifo_rd_prect_clk),
       .rx_ehip_data                                (i_rx_ehip_data),
       .rx_elane_data                               (i_rx_elane_data),
       .rx_rsfec_data                               (i_rx_rsfec_data),
       .tx_clock_fifo_wr_clk                        (tx_clock_fifo_wr_clk),
       .tx_clock_fifo_rd_clk                        (tx_clock_fifo_rd_clk),
       .pld_10g_krfec_rx_blk_lock                   (pld_10g_krfec_rx_blk_lock),
       .pld_10g_krfec_rx_diag_data_status           (pld_10g_krfec_rx_diag_data_status[1:0]),
       .pld_10g_krfec_rx_frame                      (pld_10g_krfec_rx_frame),
       .pld_10g_rx_crc32_err                        (pld_10g_rx_crc32_err),
       .pld_10g_rx_frame_lock                       (pld_10g_rx_frame_lock),
       .pld_10g_rx_hi_ber                           (pld_10g_rx_hi_ber),
       .pld_8g_a1a2_k1k2_flag                       (pld_8g_a1a2_k1k2_flag[3:0]),
       .pld_8g_empty_rmf                            (pld_8g_empty_rmf),
       .pld_8g_full_rmf                             (pld_8g_full_rmf),
       .pld_8g_rxelecidle                           (rsvd_direct_async),
       .pld_8g_signal_detect_out                    (pld_8g_signal_detect_out),
       .pld_8g_wa_boundary                          (pld_8g_wa_boundary[4:0]),
       .pld_pma_adapt_done                          (pld_pma_adapt_done),
       .rx_pma_div66_clk                            (i_rx_pma_div66_clk),
       .feedthru_clk                                (i_feedthru_clk),
       .pld_pma_pcie_sw_done                        (pld_pma_pcie_sw_done[1:0]),
       .pld_pma_reserved_in                         (pld_pma_reserved_in[4:0]),
       .pld_pma_rx_detect_valid                     (pld_pma_rx_detect_valid),
       .pld_pma_rx_found                            (pld_pma_rx_found),
       .pld_pma_rxpll_lock                          (i_xcvrif_rx_rdy),
       .pld_pma_signal_ok                           (pld_pma_signal_ok),
       .pld_pma_testbus                             (pld_pma_testbus[7:0]),
       .pld_pmaif_mask_tx_pll                       (pld_pmaif_mask_tx_pll),
       .pld_rx_prbs_done                            (pld_rx_prbs_done),
       .pld_rx_prbs_err                             (pld_rx_prbs_err),
       .pld_test_data                               (pld_test_data[19:0]),
       .r_rx_align_del                              (r_rx_align_del),
       .r_rx_async_pld_10g_rx_crc32_err_rst_val     (r_rx_async_pld_10g_rx_crc32_err_rst_val),
       .r_rx_async_pld_8g_signal_detect_out_rst_val (r_rx_async_pld_8g_signal_detect_out_rst_val),
       .r_rx_async_pld_ltr_rst_val                  (r_rx_async_pld_ltr_rst_val),
       .r_rx_async_pld_pma_ltd_b_rst_val            (r_rx_async_pld_pma_ltd_b_rst_val),
       .r_rx_async_pld_rx_fifo_align_clr_rst_val    (r_rx_async_pld_rx_fifo_align_clr_rst_val),
       .r_rx_async_hip_en                           (r_rx_async_hip_en),
       .r_rx_parity_sel                             (r_rx_parity_sel),
       .r_rx_bonding_dft_in_en                      (r_rx_bonding_dft_in_en),
       .r_rx_bonding_dft_in_value                   (r_rx_bonding_dft_in_value),
       .r_rx_asn_en                                 (r_rx_asn_en),
       .r_rx_slv_asn_en                             (r_rx_slv_asn_en),
       .r_rx_asn_bypass_clock_gate                  (r_rx_asn_bypass_clock_gate),
       .r_rx_asn_bypass_pma_pcie_sw_done            (r_rx_asn_bypass_pma_pcie_sw_done),
       .r_rx_hrdrst_user_ctl_en                     (r_rx_hrdrst_user_ctl_en),
       .r_rx_asn_wait_for_fifo_flush_cnt            (r_rx_asn_wait_for_fifo_flush_cnt[6:0]),
       .r_rx_usertest_sel                           (r_rx_usertest_sel),
       .r_tx_latency_src_xcvrif                     (r_tx_latency_src_xcvrif),
       .r_rx_asn_wait_for_dll_reset_cnt             (r_rx_asn_wait_for_dll_reset_cnt[6:0]),
       .r_rx_asn_wait_for_clock_gate_cnt            (r_rx_asn_wait_for_clock_gate_cnt[6:0]),
       .r_rx_asn_wait_for_pma_pcie_sw_done_cnt      (r_rx_asn_wait_for_pma_pcie_sw_done_cnt[6:0]),
       .r_rx_internal_clk1_sel0                     (r_rx_internal_clk1_sel0),
       .r_rx_internal_clk1_sel1                     (r_rx_internal_clk1_sel1),
       .r_rx_internal_clk1_sel2                     (r_rx_internal_clk1_sel2),
       .r_rx_internal_clk1_sel3                     (r_rx_internal_clk1_sel3),
       .r_rx_txfiford_pre_ct_sel                    (r_rx_txfiford_pre_ct_sel),
       .r_rx_txfiford_post_ct_sel                   (r_rx_txfiford_post_ct_sel),
       .r_rx_txfifowr_post_ct_sel                   (r_rx_txfifowr_post_ct_sel),
       .r_rx_txfifowr_from_aib_sel                  (r_rx_txfifowr_from_aib_sel),
       .r_rx_internal_clk2_sel0                     (r_rx_internal_clk2_sel0),
       .r_rx_internal_clk2_sel1                     (r_rx_internal_clk2_sel1),
       .r_rx_internal_clk2_sel2                     (r_rx_internal_clk2_sel2),
       .r_rx_internal_clk2_sel3                     (r_rx_internal_clk2_sel3),
       .r_rx_rxfifowr_pre_ct_sel                    (r_rx_rxfifowr_pre_ct_sel),
       .r_rx_rxfifowr_post_ct_sel                   (r_rx_rxfifowr_post_ct_sel),
       .r_rx_rxfiford_post_ct_sel                   (r_rx_rxfiford_post_ct_sel),
       .r_rx_rxfiford_to_aib_sel                    (r_rx_rxfiford_to_aib_sel),
       .r_rx_chnl_datapath_map_mode                 (r_rx_chnl_datapath_map_mode),
       .r_rx_pcs_testbus_sel                        (r_rx_pcs_testbus_sel),
       .r_rx_comp_cnt                               (r_rx_comp_cnt[7:0]),
       .r_rx_compin_sel                             (r_rx_compin_sel[1:0]),
       .r_rx_double_write                           (r_rx_double_write),
       .r_rx_ds_bypass_pipeln                       (r_rx_ds_bypass_pipeln),
       .r_rx_ds_master                              (r_rx_ds_master),
       .r_rx_dyn_clk_sw_en                          (r_rx_dyn_clk_sw_en),
       .r_rx_fifo_empty                             (r_rx_fifo_empty[4:0]),
       .r_rx_fifo_full                              (r_rx_fifo_full[4:0]),
       .r_rx_fifo_mode                              (r_rx_fifo_mode[1:0]),
       .r_rx_fifo_pempty                            (r_rx_fifo_pempty[4:0]),
       .r_rx_fifo_pfull                             (r_rx_fifo_pfull[4:0]),
       .r_rx_fifo_rd_clk_scg_en                     (r_rx_fifo_rd_clk_scg_en),
       .r_rx_fifo_rd_clk_sel                        (r_rx_fifo_rd_clk_sel[2:0]),
       .r_rx_fifo_wr_clk_scg_en                     (r_rx_fifo_wr_clk_scg_en),
       .r_rx_fifo_wr_clk_sel                        (r_rx_fifo_wr_clk_sel[2:0]),
       .r_rx_pma_coreclkin_sel                      (r_rx_pma_coreclkin_sel),
       .r_rx_force_align                            (r_rx_force_align),
       .r_rx_free_run_div_clk                       (r_rx_free_run_div_clk),
       .r_rx_txeq_rst_sel                           (r_rx_txeq_rst_sel),
       .r_rx_indv                                   (r_rx_indv),
       .r_rx_internal_clk1_sel                      (r_rx_internal_clk1_sel[3:0]),
       .r_rx_internal_clk2_sel                      (r_rx_internal_clk2_sel[3:0]),
       .r_rx_mask_del                               (r_rx_mask_del[3:0]),
       .r_rx_osc_clk_scg_en                         (r_rx_osc_clk_scg_en),
       .r_rx_phcomp_rd_delay                        (r_rx_phcomp_rd_delay[2:0]),
       .r_rx_pma_hclk_scg_en                        (r_rx_pma_hclk_scg_en),
       .r_rx_stop_read                              (r_rx_stop_read),
       .r_rx_stop_write                             (r_rx_stop_write),
       .r_rx_txeq_clk_sel                           (r_rx_txeq_clk_sel),
       .r_rx_txeq_clk_scg_en                        (r_rx_txeq_clk_scg_en),
       .r_rx_us_bypass_pipeln                       (r_rx_us_bypass_pipeln),
       .r_rx_us_master                              (r_rx_us_master),
       .r_rx_wm_en                                  (r_rx_wm_en),
       .r_rx_fifo_power_mode                        (r_rx_fifo_power_mode),
       .r_rx_stretch_num_stages                     (r_rx_stretch_num_stages),
       .r_rx_datapath_tb_sel                        (r_rx_datapath_tb_sel),
       .r_rx_wr_adj_en                              (r_rx_wr_adj_en),
       .r_rx_rd_adj_en                              (r_rx_rd_adj_en),
       .r_rx_msb_rdptr_pipe_byp                     (r_rx_msb_rdptr_pipe_byp),
       .r_rx_adapter_lpbk_mode                      (r_rx_adapter_lpbk_mode),
       .r_rx_aib_lpbk_en                            (r_rx_aib_lpbk_en),
       .tx_fifo_data_lpbk                           (tx_fifo_data_lpbk),
       .tx_pma_data_lpbk                            (tx_pma_data_lpbk),
       .aib_hssi_tx_data_lpbk                       (aib_hssi_tx_data_lpbk),
       .tx_chnl_testbus                             (tx_chnl_testbus),
       .avmm_testbus                                (avmm_testbus),
       .oaibdftdll2core                             (i_aibdftdll2core),
       .rx_async_fabric_hssi_fsr_data               (rx_async_fabric_hssi_fsr_data[2:0]),
       .rx_async_fabric_hssi_fsr_load               (rx_async_fabric_hssi_fsr_load),
       .rx_async_fabric_hssi_ssr_data               (rx_async_fabric_hssi_ssr_data[35:0]),
       .rx_async_fabric_hssi_ssr_load               (rx_async_fabric_hssi_ssr_load),
       .rx_async_hssi_fabric_fsr_load               (rx_async_hssi_fabric_fsr_load),
       .rx_async_hssi_fabric_ssr_load               (rx_async_hssi_fabric_ssr_load),
       .rx_pld_rate                                 (rx_pld_rate[1:0]),
       .txeq_invalid_req                            (txeq_invalid_req),
       .txeq_rxeqeval                               (txeq_rxeqeval),
       .txeq_rxeqinprogress                         (txeq_rxeqinprogress),
       .txeq_txdetectrx                             (txeq_txdetectrx),
       .txeq_rate                                   (txeq_rate),
       .txeq_powerdown                              (txeq_powerdown),
       .rx_chnl_dprio_status_write_en               (rx_chnl_dprio_status_write_en)
);

c3aibadapt_avmm adapt_avmm   (/*AUTOINST*/
       // Outputs
       .sr_fabric_osc_transfer_en                   (sr_fabric_osc_transfer_en),
       .avmm_transfer_error                         (avmm_transfer_error),
       .avmm_testbus                                (avmm_testbus),
       .avmm_hrdrst_tb_direct                       (avmm_hrdrst_tb_direct),
       .dec_arb_tb_direct                           (dec_arb_tb_direct),
       .avmm_hrdrst_hssi_osc_transfer_en_sync       (avmm_hrdrst_hssi_osc_transfer_en_sync),
       .avmm1_clock_avmm_clk_scg                    (avmm1_clock_avmm_clk_scg),
       .avmm1_clock_avmm_clk_dcg                    (avmm1_clock_avmm_clk_dcg),
       .avmm2_clock_avmm_clk_scg                    (avmm2_clock_avmm_clk_scg),
       .avmm2_clock_avmm_clk_dcg                    (avmm2_clock_avmm_clk_dcg),
       .aib_hssi_avmm1_data_out                     (o_aib_avmm1_data),
       .aib_hssi_avmm2_data_out                     (o_aib_avmm2_data),
       .avmm1_hssi_fabric_ssr_data                  (avmm1_hssi_fabric_ssr_data),
       .avmm2_hssi_fabric_ssr_data                  (avmm2_hssi_fabric_ssr_data),
       .avmm_hrdrst_hssi_osc_transfer_alive         (avmm_hrdrst_hssi_osc_transfer_alive),
       .aib_bsr_scan_shift_clk                      (o_aib_bsr_scan_shift_clk),
       // CRSSM AVMM
       .cfg_avmm_rdata                              (o_cfg_avmm_rdata),
       .cfg_avmm_rdatavld                           (o_cfg_avmm_rdatavld),
       .cfg_avmm_waitreq                            (o_cfg_avmm_waitreq),
       .o_hard_rst_n                                (o_adpt_hard_rst_n),
       .o_xcvrif_avmm_clk                           (o_xcvrif_cfg_clk),
       .o_xcvrif_avmm_rst_n                         (),
       .o_xcvrif_avmm_cfg_active                    (o_xcvrif_cfg_active),
       .o_xcvrif_avmm_write                         (o_xcvrif_cfg_write),
       .o_xcvrif_avmm_read                          (o_xcvrif_cfg_read),
       .o_xcvrif_avmm_addr                          (o_xcvrif_cfg_addr),
       .o_xcvrif_avmm_wdata                         (o_xcvrif_cfg_wdata),
       .o_xcvrif_avmm_byte_en                       (o_xcvrif_cfg_byte_en),
       .o_elane_avmm_clk                            (o_elane_cfg_clk),
       .o_elane_avmm_rst_n                          (),
       .o_elane_avmm_cfg_active                     (o_elane_cfg_active),
       .o_elane_avmm_write                          (o_elane_cfg_write),
       .o_elane_avmm_read                           (o_elane_cfg_read),
       .o_elane_avmm_addr                           (o_elane_cfg_addr[16:0]),
       .o_elane_avmm_wdata                          (o_elane_cfg_wdata),
       .o_elane_avmm_byte_en                        (o_elane_cfg_byte_en),
       .adpt_cfg_write                              (o_adpt_cfg_write),
       .adpt_cfg_read                               (o_adpt_cfg_read),
       .ehip_usr_clk                                (o_ehip_usr_clk),
       .ehip_usr_read                               (o_ehip_usr_read),
       .ehip_usr_addr                               (o_ehip_usr_addr[20:0]),
       .ehip_cfg_write                              (o_ehip_cfg_write),
       .ehip_cfg_read                               (o_ehip_cfg_read),
       .ehip_usr_write                              (o_ehip_usr_write),
       .ehip_usr_wdata                              (o_ehip_usr_wdata[7:0]),
       .r_aib_csr_ctrl_0                            (o_aib_csr_ctrl_0[7:0]),
       .r_aib_csr_ctrl_1                            (o_aib_csr_ctrl_1[7:0]),
       .r_aib_csr_ctrl_10                           (o_aib_csr_ctrl_10[7:0]),
       .r_aib_csr_ctrl_11                           (o_aib_csr_ctrl_11[7:0]),
       .r_aib_csr_ctrl_12                           (o_aib_csr_ctrl_12[7:0]),
       .r_aib_csr_ctrl_13                           (o_aib_csr_ctrl_13[7:0]),
       .r_aib_csr_ctrl_14                           (o_aib_csr_ctrl_14[7:0]),
       .r_aib_csr_ctrl_15                           (o_aib_csr_ctrl_15[7:0]),
       .r_aib_csr_ctrl_16                           (o_aib_csr_ctrl_16[7:0]),
       .r_aib_csr_ctrl_17                           (o_aib_csr_ctrl_17[7:0]),
       .r_aib_csr_ctrl_18                           (o_aib_csr_ctrl_18[7:0]),
       .r_aib_csr_ctrl_19                           (o_aib_csr_ctrl_19[7:0]),
       .r_aib_csr_ctrl_2                            (o_aib_csr_ctrl_2[7:0]),
       .r_aib_csr_ctrl_20                           (o_aib_csr_ctrl_20[7:0]),
       .r_aib_csr_ctrl_21                           (o_aib_csr_ctrl_21[7:0]),
       .r_aib_csr_ctrl_22                           (o_aib_csr_ctrl_22[7:0]),
       .r_aib_csr_ctrl_23                           (o_aib_csr_ctrl_23[7:0]),
       .r_aib_csr_ctrl_24                           (o_aib_csr_ctrl_24[7:0]),
       .r_aib_csr_ctrl_25                           (o_aib_csr_ctrl_25[7:0]),
       .r_aib_csr_ctrl_26                           (o_aib_csr_ctrl_26[7:0]),
       .r_aib_csr_ctrl_27                           (o_aib_csr_ctrl_27[7:0]),
       .r_aib_csr_ctrl_28                           (o_aib_csr_ctrl_28[7:0]),
       .r_aib_csr_ctrl_29                           (o_aib_csr_ctrl_29[7:0]),
       .r_aib_csr_ctrl_3                            (o_aib_csr_ctrl_3[7:0]),
       .r_aib_csr_ctrl_30                           (o_aib_csr_ctrl_30[7:0]),
       .r_aib_csr_ctrl_31                           (o_aib_csr_ctrl_31[7:0]),
       .r_aib_csr_ctrl_32                           (o_aib_csr_ctrl_32[7:0]),
       .r_aib_csr_ctrl_33                           (o_aib_csr_ctrl_33[7:0]),
       .r_aib_csr_ctrl_34                           (o_aib_csr_ctrl_34[7:0]),
       .r_aib_csr_ctrl_35                           (o_aib_csr_ctrl_35[7:0]),
       .r_aib_csr_ctrl_36                           (o_aib_csr_ctrl_36[7:0]),
       .r_aib_csr_ctrl_37                           (o_aib_csr_ctrl_37[7:0]),
       .r_aib_csr_ctrl_38                           (o_aib_csr_ctrl_38[7:0]),
       .r_aib_csr_ctrl_39                           (o_aib_csr_ctrl_39[7:0]),
       .r_aib_csr_ctrl_4                            (o_aib_csr_ctrl_4[7:0]),
       .r_aib_csr_ctrl_40                           (o_aib_csr_ctrl_40[7:0]),
       .r_aib_csr_ctrl_41                           (o_aib_csr_ctrl_41[7:0]),
       .r_aib_csr_ctrl_42                           (o_aib_csr_ctrl_42[7:0]),
       .r_aib_csr_ctrl_43                           (o_aib_csr_ctrl_43[7:0]),
       .r_aib_csr_ctrl_44                           (o_aib_csr_ctrl_44[7:0]),
       .r_aib_csr_ctrl_45                           (o_aib_csr_ctrl_45[7:0]),
       .r_aib_csr_ctrl_46                           (o_aib_csr_ctrl_46[7:0]),
       .r_aib_csr_ctrl_47                           (o_aib_csr_ctrl_47[7:0]),
       .r_aib_csr_ctrl_48                           (o_aib_csr_ctrl_48[7:0]),
       .r_aib_csr_ctrl_49                           (o_aib_csr_ctrl_49[7:0]),
       .r_aib_csr_ctrl_5                            (o_aib_csr_ctrl_5[7:0]),
       .r_aib_csr_ctrl_50                           (o_aib_csr_ctrl_50[7:0]),
       .r_aib_csr_ctrl_51                           (o_aib_csr_ctrl_51[7:0]),
       .r_aib_csr_ctrl_52                           (o_aib_csr_ctrl_52[7:0]),
       .r_aib_csr_ctrl_53                           (o_aib_csr_ctrl_53[7:0]),
       .r_aib_csr_ctrl_6                            (o_aib_csr_ctrl_6[7:0]),
       .r_aib_csr_ctrl_7                            (o_aib_csr_ctrl_7[7:0]),
       .r_aib_csr_ctrl_8                            (o_aib_csr_ctrl_8[7:0]),
       .r_aib_csr_ctrl_9                            (o_aib_csr_ctrl_9[7:0]),
       .r_aib_dprio_ctrl_0                          (o_aib_dprio_ctrl_0[7:0]),
       .r_aib_dprio_ctrl_1                          (o_aib_dprio_ctrl_1[7:0]),
       .r_aib_dprio_ctrl_2                          (o_aib_dprio_ctrl_2[7:0]),
       .r_aib_dprio_ctrl_3                          (o_aib_dprio_ctrl_3[7:0]),
       .r_aib_dprio_ctrl_4                          (o_aib_dprio_ctrl_4[7:0]),
       .r_rx_pld_8g_a1a2_k1k2_flag_polling_bypass   (r_rx_pld_8g_a1a2_k1k2_flag_polling_bypass),
       .r_rx_10g_krfec_rx_diag_data_stat_poll_byp(r_rx_10g_krfec_rx_diag_data_stat_poll_byp),
       .r_rx_pld_8g_wa_boundary_polling_bypass      (r_rx_pld_8g_wa_boundary_polling_bypass),
       .r_rx_pcspma_testbus_sel                     (r_rx_pcspma_testbus_sel),
       .r_rx_pld_pma_pcie_sw_done_polling_bypass    (r_rx_pld_pma_pcie_sw_done_polling_bypass),
       .r_rx_pld_pma_reser_in_polling_bypass        (r_rx_pld_pma_reser_in_polling_bypass),
       .r_rx_pld_pma_testbus_polling_bypass         (r_rx_pld_pma_testbus_polling_bypass),
       .r_rx_pld_test_data_polling_bypass           (r_rx_pld_test_data_polling_bypass),
       .r_rx_align_del                              (r_rx_align_del),
       .r_rx_async_pld_10g_rx_crc32_err_rst_val     (r_rx_async_pld_10g_rx_crc32_err_rst_val),
       .r_rx_async_pld_8g_signal_detect_out_rst_val (r_rx_async_pld_8g_signal_detect_out_rst_val),
       .r_rx_async_pld_ltr_rst_val                  (r_rx_async_pld_ltr_rst_val),
       .r_rx_async_pld_pma_ltd_b_rst_val            (r_rx_async_pld_pma_ltd_b_rst_val),
       .r_rx_async_pld_rx_fifo_align_clr_rst_val    (r_rx_async_pld_rx_fifo_align_clr_rst_val),
       .r_rx_async_hip_en                           (r_rx_async_hip_en),
       .r_rx_parity_sel                             (r_rx_parity_sel),
       .r_rx_bonding_dft_in_en                      (r_rx_bonding_dft_in_en),
       .r_rx_bonding_dft_in_value                   (r_rx_bonding_dft_in_value),
       .r_rx_asn_en                                 (r_rx_asn_en),
       .r_rx_slv_asn_en                             (r_rx_slv_asn_en),
       .r_rx_asn_bypass_clock_gate                  (r_rx_asn_bypass_clock_gate),
       .r_rx_asn_bypass_pma_pcie_sw_done            (r_rx_asn_bypass_pma_pcie_sw_done),
       .r_rx_hrdrst_user_ctl_en                     (r_rx_hrdrst_user_ctl_en),
       .r_rx_usertest_sel                           (r_rx_usertest_sel),
       .r_rx_asn_wait_for_fifo_flush_cnt            (r_rx_asn_wait_for_fifo_flush_cnt[6:0]),
       .r_rx_asn_wait_for_dll_reset_cnt             (r_rx_asn_wait_for_dll_reset_cnt[6:0]),
       .r_rx_asn_wait_for_clock_gate_cnt            (r_rx_asn_wait_for_clock_gate_cnt[6:0]),
       .r_rx_asn_wait_for_pma_pcie_sw_done_cnt      (r_rx_asn_wait_for_pma_pcie_sw_done_cnt[6:0]),
       .r_rx_txeq_en                                (r_rx_txeq_en),
       .r_rx_rxeq_en                                (r_rx_rxeq_en),
       .r_rx_pre_cursor_en                          (r_rx_pre_cursor_en),
       .r_rx_post_cursor_en                         (r_rx_post_cursor_en),
       .r_rx_invalid_no_change                      (r_rx_invalid_no_change),
       .r_rx_adp_go_b4txeq_en                       (r_rx_adp_go_b4txeq_en),
       .r_rx_use_rxvalid_for_rxeq                   (r_rx_use_rxvalid_for_rxeq),
       .r_rx_pma_rstn_en                            (r_rx_pma_rstn_en),
       .r_rx_pma_rstn_cycles                        (r_rx_pma_rstn_cycles),
       .r_sr_parity_en                              (r_sr_parity_en),
       .r_rx_txeq_time                              (r_rx_txeq_time[7:0]),
       .r_rx_eq_iteration                           (r_rx_eq_iteration[1:0]),
       .r_rx_internal_clk1_sel0                     (r_rx_internal_clk1_sel0),
       .r_rx_internal_clk1_sel1                     (r_rx_internal_clk1_sel1),
       .r_rx_internal_clk1_sel2                     (r_rx_internal_clk1_sel2),
       .r_rx_internal_clk1_sel3                     (r_rx_internal_clk1_sel3),
       .r_rx_txfiford_pre_ct_sel                    (r_rx_txfiford_pre_ct_sel),
       .r_rx_txfiford_post_ct_sel                   (r_rx_txfiford_post_ct_sel),
       .r_rx_txfifowr_post_ct_sel                   (r_rx_txfifowr_post_ct_sel),
       .r_rx_txfifowr_from_aib_sel                  (r_rx_txfifowr_from_aib_sel),
       .r_rx_internal_clk2_sel0                     (r_rx_internal_clk2_sel0),
       .r_rx_internal_clk2_sel1                     (r_rx_internal_clk2_sel1),
       .r_rx_internal_clk2_sel2                     (r_rx_internal_clk2_sel2),
       .r_rx_internal_clk2_sel3                     (r_rx_internal_clk2_sel3),
       .r_rx_rxfifowr_pre_ct_sel                    (r_rx_rxfifowr_pre_ct_sel),
       .r_rx_rxfifowr_post_ct_sel                   (r_rx_rxfifowr_post_ct_sel),
       .r_rx_rxfiford_post_ct_sel                   (r_rx_rxfiford_post_ct_sel),
       .r_rx_rxfiford_to_aib_sel                    (r_rx_rxfiford_to_aib_sel),
       .r_rx_chnl_datapath_map_mode                 (r_rx_chnl_datapath_map_mode),
       .r_rx_pcs_testbus_sel                        (r_rx_pcs_testbus_sel),
       .r_rx_comp_cnt                               (r_rx_comp_cnt[7:0]),
       .r_rx_compin_sel                             (r_rx_compin_sel[1:0]),
       .r_rx_double_write                           (r_rx_double_write),
       .r_rx_ds_bypass_pipeln                       (r_rx_ds_bypass_pipeln),
       .r_rx_ds_master                              (r_rx_ds_master),
       .r_rx_dyn_clk_sw_en                          (r_rx_dyn_clk_sw_en),
       .r_rx_fifo_empty                             (r_rx_fifo_empty[4:0]),
       .r_rx_fifo_full                              (r_rx_fifo_full[4:0]),
       .r_rx_fifo_mode                              (r_rx_fifo_mode[1:0]),
       .r_rx_fifo_pempty                            (r_rx_fifo_pempty[4:0]),
       .r_rx_fifo_pfull                             (r_rx_fifo_pfull[4:0]),
       .r_rx_fifo_rd_clk_scg_en                     (r_rx_fifo_rd_clk_scg_en),
       .r_rx_fifo_rd_clk_sel                        (r_rx_fifo_rd_clk_sel[2:0]),
       .r_rx_fifo_wr_clk_scg_en                     (r_rx_fifo_wr_clk_scg_en),
       .r_rx_fifo_wr_clk_sel                        (r_rx_fifo_wr_clk_sel[2:0]),
       .r_rx_pma_coreclkin_sel                      (r_rx_pma_coreclkin_sel),
       .r_rx_force_align                            (r_rx_force_align),
       .r_rx_free_run_div_clk                       (r_rx_free_run_div_clk),
       .r_rx_txeq_rst_sel                           (r_rx_txeq_rst_sel),
       .r_rx_indv                                   (r_rx_indv),
       .r_rx_internal_clk1_sel                      (r_rx_internal_clk1_sel[3:0]),
       .r_rx_internal_clk2_sel                      (r_rx_internal_clk2_sel[3:0]),
       .r_rx_mask_del                               (r_rx_mask_del[3:0]),
       .r_rx_osc_clk_scg_en                         (r_rx_osc_clk_scg_en),
       .r_rx_phcomp_rd_delay                        (r_rx_phcomp_rd_delay[2:0]),
       .r_rx_pma_hclk_scg_en                        (r_rx_pma_hclk_scg_en),
       .r_rx_stop_read                              (r_rx_stop_read),
       .r_rx_stop_write                             (r_rx_stop_write),
       .r_rx_txeq_clk_sel                           (r_rx_txeq_clk_sel),
       .r_rx_txeq_clk_scg_en                        (r_rx_txeq_clk_scg_en),
       .r_rx_us_bypass_pipeln                       (r_rx_us_bypass_pipeln),
       .r_rx_us_master                              (r_rx_us_master),
       .r_rx_wm_en                                  (r_rx_wm_en),
       .r_rx_fifo_power_mode                        (r_rx_fifo_power_mode),
       .r_rx_stretch_num_stages                     (r_rx_stretch_num_stages),
       .r_rx_datapath_tb_sel                        (r_rx_datapath_tb_sel),
       .r_rx_wr_adj_en                              (r_rx_wr_adj_en),
       .r_rx_rd_adj_en                              (r_rx_rd_adj_en),
       .r_rx_msb_rdptr_pipe_byp                     (r_rx_msb_rdptr_pipe_byp),
       .r_rx_adapter_lpbk_mode                      (r_rx_adapter_lpbk_mode),
       .r_rx_aib_lpbk_en                            (r_rx_aib_lpbk_en),
       .r_rx_hrdrst_rst_sm_dis                      (r_rx_hrdrst_rst_sm_dis),
       .r_rx_hrdrst_dcd_cal_done_bypass             (r_rx_hrdrst_dcd_cal_done_bypass),
       .r_rx_rmfflag_stretch_enable                 (r_rx_rmfflag_stretch_enable),
       .r_rx_rmfflag_stretch_num_stages             (r_rx_rmfflag_stretch_num_stages),
       .r_rx_ds_last_chnl                           (r_rx_ds_last_chnl),
       .r_rx_us_last_chnl                           (r_rx_us_last_chnl),
       .r_rx_hrdrst_rx_osc_clk_scg_en               (r_rx_hrdrst_rx_osc_clk_scg_en),
       .r_sr_hip_en                                 (r_sr_hip_en),
       .r_sr_reserbits_in_en                        (r_sr_reserbits_in_en),
       .r_sr_reserbits_out_en                       (r_sr_reserbits_out_en),
       .r_sr_osc_clk_scg_en                         (r_sr_osc_clk_scg_en),
       .r_sr_osc_clk_div_sel                        (r_sr_osc_clk_div_sel),
       .r_sr_free_run_div_clk                       (r_sr_free_run_div_clk),
       .r_sr_test_enable                            (r_sr_test_enable),
       .r_tx_qpi_sr_enable                          (r_tx_qpi_sr_enable),
       .r_tx_usertest_sel                           (r_tx_usertest_sel),
       .r_tx_latency_src_xcvrif                     (r_tx_latency_src_xcvrif),
       .r_tx_aib_clk_sel                            (r_tx_aib_clk_sel[1:0]),
       .r_tx_async_hip_aib_fsr_in_bit0_rst_val      (r_tx_async_hip_aib_fsr_in_bit0_rst_val),
       .r_tx_async_hip_aib_fsr_in_bit1_rst_val      (r_tx_async_hip_aib_fsr_in_bit1_rst_val),
       .r_tx_async_hip_aib_fsr_in_bit2_rst_val      (r_tx_async_hip_aib_fsr_in_bit2_rst_val),
       .r_tx_async_hip_aib_fsr_in_bit3_rst_val      (r_tx_async_hip_aib_fsr_in_bit3_rst_val),
       .r_tx_async_hip_aib_fsr_out_bit0_rst_val     (r_tx_async_hip_aib_fsr_out_bit0_rst_val),
       .r_tx_async_hip_aib_fsr_out_bit1_rst_val     (r_tx_async_hip_aib_fsr_out_bit1_rst_val),
       .r_tx_async_hip_aib_fsr_out_bit2_rst_val     (r_tx_async_hip_aib_fsr_out_bit2_rst_val),
       .r_tx_async_hip_aib_fsr_out_bit3_rst_val     (r_tx_async_hip_aib_fsr_out_bit3_rst_val),
       .r_tx_async_pld_pmaif_mask_tx_pll_rst_val    (r_tx_async_pld_pmaif_mask_tx_pll_rst_val),
       .r_tx_async_pld_txelecidle_rst_val           (r_tx_async_pld_txelecidle_rst_val),
       .r_tx_bonding_dft_in_en                      (r_tx_bonding_dft_in_en),
       .r_tx_bonding_dft_in_value                   (r_tx_bonding_dft_in_value),
       .r_tx_chnl_datapath_map_mode                 (r_tx_chnl_datapath_map_mode),
       .r_tx_chnl_datapath_map_rxqpi_pullup_init_val(r_tx_chnl_datapath_map_rxqpi_pullup_init_val),
       .r_tx_chnl_datapath_map_txqpi_pulldn_init_val(r_tx_chnl_datapath_map_txqpi_pulldn_init_val),
       .r_tx_chnl_datapath_map_txqpi_pullup_init_val(r_tx_chnl_datapath_map_txqpi_pullup_init_val),
       .r_tx_comp_cnt                               (r_tx_comp_cnt[7:0]),
       .r_tx_compin_sel                             (r_tx_compin_sel[1:0]),
       .r_tx_double_read                            (r_tx_double_read),
       .r_tx_ds_bypass_pipeln                       (r_tx_ds_bypass_pipeln),
       .r_tx_ds_master                              (r_tx_ds_master),
       .r_tx_dyn_clk_sw_en                          (r_tx_dyn_clk_sw_en),
       .r_tx_fifo_empty                             (r_tx_fifo_empty[4:0]),
       .r_tx_fifo_full                              (r_tx_fifo_full[4:0]),
       .r_tx_fifo_mode                              (r_tx_fifo_mode[1:0]),
       .r_tx_fifo_pempty                            (r_tx_fifo_pempty[4:0]),
       .r_tx_fifo_pfull                             (r_tx_fifo_pfull[4:0]),
       .r_tx_fifo_rd_clk_scg_en                     (r_tx_fifo_rd_clk_scg_en),
       .r_tx_fifo_rd_clk_sel                        (r_tx_fifo_rd_clk_sel),
       .r_tx_fifo_wr_clk_scg_en                     (r_tx_fifo_wr_clk_scg_en),
       .r_tx_indv                                   (r_tx_indv),
       .r_tx_osc_clk_scg_en                         (r_tx_osc_clk_scg_en),
       .r_tx_phcomp_rd_delay                        (r_tx_phcomp_rd_delay[2:0]),
       .r_tx_stop_read                              (r_tx_stop_read),
       .r_tx_stop_write                             (r_tx_stop_write),
       .r_tx_us_bypass_pipeln                       (r_tx_us_bypass_pipeln),
       .r_tx_us_master                              (r_tx_us_master),
       .r_tx_wa_en                                  (r_tx_wa_en),
       .r_tx_wren_fastbond                          (r_tx_wren_fastbond),
       .r_tx_fifo_power_mode                        (r_tx_fifo_power_mode),
       .r_tx_stretch_num_stages                     (r_tx_stretch_num_stages),
       .r_tx_datapath_tb_sel                        (r_tx_datapath_tb_sel),
       .r_tx_wr_adj_en                              (r_tx_wr_adj_en),
       .r_tx_rd_adj_en                              (r_tx_rd_adj_en),
       .r_tx_dv_gating_en                           (r_tx_dv_gating_en),
       .r_tx_rev_lpbk                               (r_tx_rev_lpbk),
       .r_tx_hrdrst_rst_sm_dis                      (r_tx_hrdrst_rst_sm_dis),
       .r_tx_hrdrst_dcd_cal_done_bypass             (r_tx_hrdrst_dcd_cal_done_bypass),
       .r_tx_hrdrst_dll_lock_bypass                 (r_tx_hrdrst_dll_lock_bypass),
       .r_tx_hrdrst_align_bypass                    (r_tx_hrdrst_align_bypass),
       .r_tx_hrdrst_user_ctl_en                     (r_tx_hrdrst_user_ctl_en),
       .r_tx_presethint_bypass                      (r_tx_presethint_bypass),
       .r_tx_ds_last_chnl                           (r_tx_ds_last_chnl),
       .r_tx_us_last_chnl                           (r_tx_us_last_chnl),
       .r_tx_free_run_div_clk                       (r_tx_free_run_div_clk),
       .r_tx_hrdrst_rx_osc_clk_scg_en               (r_tx_hrdrst_rx_osc_clk_scg_en),
       .r_tx_hip_osc_clk_scg_en                     (r_tx_hip_osc_clk_scg_en),
       .r_rstctl_tx_elane_ovrval                    (r_rstctl_tx_elane_ovrval),
       .r_rstctl_tx_elane_ovren                     (r_rstctl_tx_elane_ovren),
       .r_rstctl_rx_elane_ovrval                    (r_rstctl_rx_elane_ovrval),
       .r_rstctl_rx_elane_ovren                     (r_rstctl_rx_elane_ovren),
       .r_rstctl_tx_xcvrif_ovrval                   (r_rstctl_tx_xcvrif_ovrval),
       .r_rstctl_tx_xcvrif_ovren                    (r_rstctl_tx_xcvrif_ovren),
       .r_rstctl_rx_xcvrif_ovrval                   (r_rstctl_rx_xcvrif_ovrval),
       .r_rstctl_rx_xcvrif_ovren                    (r_rstctl_rx_xcvrif_ovren),
       .r_rstctl_tx_adpt_ovrval                     (r_rstctl_tx_adpt_ovrval),
       .r_rstctl_tx_adpt_ovren                      (r_rstctl_tx_adpt_ovren),
       .r_rstctl_rx_adpt_ovrval                     (r_rstctl_rx_adpt_ovrval),
       .r_rstctl_rx_adpt_ovren                      (r_rstctl_rx_adpt_ovren),
       .r_rstctl_tx_pld_div2_rst_opt                (r_rstctl_tx_pld_div2_rst_opt),
       .rx_chnl_dprio_status_write_en               (rx_chnl_dprio_status_write_en),
       .sr_dprio_status_write_en                    (sr_dprio_status_write_en),
       .tx_chnl_dprio_status_write_en               (tx_chnl_dprio_status_write_en),
       .usermode_out                                (o_user_mode),
       .avmm_hrdrst_hssi_osc_transfer_en_ssr_data   (avmm_hrdrst_hssi_osc_transfer_en_ssr_data),
       // Inputs
       .avmm1_tst_tcm_ctrl                          (i_avmm1_tst_tcm_ctrl),
       .avmm1_test_clk                              (i_avmm1_test_clk),
       .avmm1_scan_clk                              (i_avmm1_scan_clk),
       .sr_testbus                                  (sr_testbus),
       .scan_rst_n                                  (i_scan_rst_n),
       .scan_mode_n                                 (i_scan_mode_n),
       .avmm_async_fabric_hssi_ssr_load             (avmm_async_fabric_hssi_ssr_load),
       .avmm_hrdrst_fabric_osc_transfer_en_ssr_data (avmm_hrdrst_fabric_osc_transfer_en_ssr_data),
       .avmm_async_hssi_fabric_ssr_load             (avmm_async_hssi_fabric_ssr_load),
       .aib_hssi_avmm1_data_in                      (i_aib_avmm1_data[1:0]),
       .aib_hssi_avmm2_data_in                      (i_aib_avmm2_data[1:0]),
       .sr_clock_tx_osc_clk_or_clkdiv               (sr_clock_tx_osc_clk_or_clkdiv),
       .aib_hssi_rx_sr_clk_in                       (i_aib_rx_sr_clk),
       .sr_clock_aib_rx_sr_clk                      (sr_clock_aib_rx_sr_clk),
       .avmm1_async_hssi_fabric_ssr_load            (avmm1_async_hssi_fabric_ssr_load),
       .avmm2_async_hssi_fabric_ssr_load            (avmm2_async_hssi_fabric_ssr_load),
       .csr_rdy_dly_in                              (i_adpt_hard_rst_n),
       // CRSSM AVMM
       .cfg_avmm_addr_id                            (i_cfg_avmm_addr_id),
       .cfg_avmm_clk                                (i_cfg_avmm_clk),
       .cfg_avmm_rst_n                              (i_cfg_avmm_rst_n),
       .cfg_avmm_write                              (i_cfg_avmm_write),
       .cfg_avmm_read                               (i_cfg_avmm_read),
       .cfg_avmm_addr                               (i_cfg_avmm_addr),
       .cfg_avmm_wdata                              (i_cfg_avmm_wdata),
       .cfg_avmm_byte_en                            (i_cfg_avmm_byte_en),
       .i_xcvrif_avmm_rdata                         (i_xcvrif_cfg_rdata),
       .i_xcvrif_avmm_rdatavld                      (i_xcvrif_cfg_rdatavld),
       .i_xcvrif_avmm_waitreq                       (i_xcvrif_cfg_waitreq),
       .i_elane_avmm_rdata                          (i_elane_cfg_rdata),
       .i_elane_avmm_rdatavld                       (i_elane_cfg_rdatavld),
       .i_elane_avmm_waitreq                        (i_elane_cfg_waitreq),
       .ehip_usr_rdatavld                           (i_ehip_usr_rdatavld),
       .ehip_usr_rdata                              (i_ehip_usr_rdata),
       .ehip_usr_wrdone                             (i_ehip_usr_wrdone),
       .ehip_cfg_rdata                              (i_ehip_cfg_rdata),
       .ehip_cfg_rdatavld                           (i_ehip_cfg_rdatavld),
       .ehip_cfg_waitreq                            (i_ehip_cfg_waitreq),
       .adpt_cfg_rdata                              (i_adpt_cfg_rdata),
       .adpt_cfg_rdatavld                           (i_adpt_cfg_rdatavld),
       .adpt_cfg_waitreq                            (i_adpt_cfg_waitreq),
       .pld_chnl_cal_done                           (pld_chnl_cal_done),
       .pld_pll_cal_done                            (pld_pll_cal_done),
       .rx_chnl_dprio_status                        (rx_chnl_dprio_status[7:0]),
       .rx_chnl_dprio_status_write_en_ack           (rx_chnl_dprio_status_write_en_ack),
       .sr_dprio_status                             (sr_dprio_status[7:0]),
       .sr_dprio_status_write_en_ack                (sr_dprio_status_write_en_ack),
       .tx_chnl_dprio_status                        (tx_chnl_dprio_status[7:0]),
       .tx_chnl_dprio_status_write_en_ack           (tx_chnl_dprio_status_write_en_ack),
       .usermode_in                                 (i_user_mode)
);

c3aibadapt_sr adapt_sr (
       // Outputs
       .ms_sideband                                   (ms_sideband[80:0]), 
       .sr_testbus                                    (sr_testbus),
       .aib_hssi_tx_sr_clk_out                        (o_aib_tx_sr_clk),
       .aib_hssi_fsr_data_out                         (o_aib_fsr_data),
       .aib_hssi_fsr_load_out                         (o_aib_fsr_load),
       .aib_hssi_ssr_data_out                         (o_aib_ssr_data),
       .aib_hssi_ssr_load_out                         (o_aib_ssr_load),
       .hip_aib_async_fsr_in                          (hip_aib_async_fsr_in[3:0]),
       .hip_aib_async_ssr_in                          (hip_aib_async_ssr_in[39:0]),
       .sr_clock_tx_sr_clk_in_div2                    (sr_clock_tx_sr_clk_in_div2),
       .sr_clock_tx_sr_clk_in_div4                    (sr_clock_tx_sr_clk_in_div4),
       .sr_clock_tx_osc_clk_or_clkdiv                 (sr_clock_tx_osc_clk_or_clkdiv),
       .avmm1_async_hssi_fabric_ssr_load              (avmm1_async_hssi_fabric_ssr_load),
       .avmm2_async_hssi_fabric_ssr_load              (avmm2_async_hssi_fabric_ssr_load),
       .rx_async_fabric_hssi_fsr_data                 (rx_async_fabric_hssi_fsr_data[2:0]),
       .rx_async_fabric_hssi_fsr_load                 (rx_async_fabric_hssi_fsr_load),
       .rx_async_fabric_hssi_ssr_data                 (rx_async_fabric_hssi_ssr_data[35:0]),
       .rx_async_fabric_hssi_ssr_load                 (rx_async_fabric_hssi_ssr_load),
       .rx_async_hssi_fabric_fsr_load                 (rx_async_hssi_fabric_fsr_load),
       .rx_async_hssi_fabric_ssr_load                 (rx_async_hssi_fabric_ssr_load),
       .tx_async_fabric_hssi_fsr_data                 (tx_async_fabric_hssi_fsr_data),
       .tx_async_fabric_hssi_fsr_load                 (tx_async_fabric_hssi_fsr_load),
       .tx_async_fabric_hssi_ssr_data                 (tx_async_fabric_hssi_ssr_data[35:0]),
       .tx_async_fabric_hssi_ssr_load                 (tx_async_fabric_hssi_ssr_load),
       .tx_async_hssi_fabric_fsr_load                 (tx_async_hssi_fabric_fsr_load),
       .tx_async_hssi_fabric_ssr_load                 (tx_async_hssi_fabric_ssr_load),
       .avmm_async_hssi_fabric_ssr_load               (avmm_async_hssi_fabric_ssr_load),
       .avmm_hrdrst_fabric_osc_transfer_en_ssr_data   (avmm_hrdrst_fabric_osc_transfer_en_ssr_data),
       .avmm_async_fabric_hssi_ssr_load               (avmm_async_fabric_hssi_ssr_load),
       .rx_async_fabric_hssi_ssr_reserved             (rx_async_fabric_hssi_ssr_reserved),
       .tx_async_fabric_hssi_ssr_reserved             (tx_async_fabric_hssi_ssr_reserved),
       .sr_dprio_status                               (sr_dprio_status[7:0]),
       .sr_dprio_status_write_en_ack                  (sr_dprio_status_write_en_ack),
       .sr_parity_error_flag                          (sr_parity_error_flag),
       .sr_clock_aib_rx_sr_clk                        (sr_clock_aib_rx_sr_clk),                // shared TCM --> aib_hssi_rx_sr_clk_in

       // Inputs
       .scan_mode_n                                   (i_scan_mode_n),
       .t0_tst_tcm_ctrl                               (i_sr_0_tst_tcm_ctrl),
       .t0_test_clk                                   (i_sr_0_test_clk),
       .t0_scan_clk                                   (i_sr_0_scan_clk),
       .t1_tst_tcm_ctrl                               (i_sr_1_tst_tcm_ctrl),
       .t1_test_clk                                   (i_sr_1_test_clk),
       .t1_scan_clk                                   (i_sr_1_scan_clk),
       .t2_tst_tcm_ctrl                               (i_sr_2_tst_tcm_ctrl),
       .t2_test_clk                                   (i_sr_2_test_clk),
       .t2_scan_clk                                   (i_sr_2_scan_clk),
       .t3_tst_tcm_ctrl                               (i_sr_3_tst_tcm_ctrl),
       .t3_test_clk                                   (i_sr_3_test_clk),
       .t3_scan_clk                                   (i_sr_3_scan_clk),
       .adpt_scan_rst_n                               (i_scan_rst_n),
       .tx_fsr_parity_checker_in                      (tx_fsr_parity_checker_in),
       .tx_ssr_parity_checker_in                      (tx_ssr_parity_checker_in),
       .hip_fsr_parity_checker_in                     (hip_fsr_parity_checker_in),
       .hip_ssr_parity_checker_in                     (hip_ssr_parity_checker_in),
       .rx_fsr_parity_checker_in                      (rx_fsr_parity_checker_in),
       .rx_ssr_parity_checker_in                      (rx_ssr_parity_checker_in),
       .sr_fabric_osc_transfer_en                     (sr_fabric_osc_transfer_en),
       .dft_adpt_rst                                  (1'b0),
       .sr_dprio_status_write_en                      (sr_dprio_status_write_en),
       .r_sr_hip_en                                   (r_sr_hip_en),
       .r_sr_parity_en                                (r_sr_parity_en),
       .r_sr_reserbits_in_en                          (r_sr_reserbits_in_en),
       .r_sr_reserbits_out_en                         (r_sr_reserbits_out_en),
       .r_sr_osc_clk_scg_en                           (r_sr_osc_clk_scg_en),
       .r_sr_osc_clk_div_sel                          (r_sr_osc_clk_div_sel),
       .r_sr_free_run_div_clk                         (r_sr_free_run_div_clk),
       .rx_async_hssi_fabric_ssr_reserved             (rx_async_hssi_fabric_ssr_reserved),
       .tx_async_hssi_fabric_ssr_reserved             (tx_async_hssi_fabric_ssr_reserved),
       .avmm_hrdrst_hssi_osc_transfer_en_sync         (avmm_hrdrst_hssi_osc_transfer_en_sync),
       .aib_hssi_tx_sr_clk_in                         (i_aib_tx_sr_clk),
       .aib_hssi_fsr_data_in                          (i_aib_fsr_data),
       .aib_hssi_fsr_load_in                          (i_aib_fsr_load),
       .aib_hssi_rx_sr_clk_in                         (i_aib_rx_sr_clk),
       .aib_hssi_ssr_data_in                          (i_aib_ssr_data),
       .aib_hssi_ssr_load_in                          (i_aib_ssr_load),
       .avmm1_hssi_fabric_ssr_data                    (avmm1_hssi_fabric_ssr_data),
       .avmm2_hssi_fabric_ssr_data                    (avmm2_hssi_fabric_ssr_data),
       .hip_aib_async_fsr_out                         (hip_aib_async_fsr_out[3:0]),
       .hip_aib_async_ssr_out                         (hip_aib_async_ssr_out[7:0]),
       .rx_async_hssi_fabric_fsr_data                 (rx_async_hssi_fabric_fsr_data[1:0]),
       .rx_async_hssi_fabric_ssr_data                 (rx_async_hssi_fabric_ssr_data[62:0]),
       .tx_async_hssi_fabric_fsr_data                 (tx_async_hssi_fabric_fsr_data),
       .tx_async_hssi_fabric_ssr_data                 (tx_async_hssi_fabric_ssr_data[12:0]),
       .avmm_hrdrst_hssi_osc_transfer_en_ssr_data     (avmm_hrdrst_hssi_osc_transfer_en_ssr_data),
       .csr_rdy_dly_in                                (i_adpt_hard_rst_n));

endmodule
