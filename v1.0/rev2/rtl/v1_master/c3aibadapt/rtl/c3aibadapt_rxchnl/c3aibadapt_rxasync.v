// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3aibadapt_rxasync
(

	// DPRIO
        input   wire            r_rx_rxeq_en,
        input   wire            r_rx_async_pld_ltr_rst_val,
        input   wire            r_rx_async_pld_pma_ltd_b_rst_val,
        input   wire            r_rx_async_pld_8g_signal_detect_out_rst_val,
        input   wire            r_rx_async_pld_10g_rx_crc32_err_rst_val,
        input   wire            r_rx_async_pld_rx_fifo_align_clr_rst_val,
        input   wire            r_rx_async_hip_en,
        input   wire    [1:0]   r_rx_parity_sel,
        input   wire            r_rx_pld_8g_a1a2_k1k2_flag_polling_bypass,
        input   wire            r_rx_10g_krfec_rx_diag_data_status_polling_bypass,
        input   wire            r_rx_pld_8g_wa_boundary_polling_bypass,
        input   wire            r_rx_pld_pma_pcie_sw_done_polling_bypass,
        input   wire            r_rx_pld_pma_reser_in_polling_bypass,
        input   wire            r_rx_pld_pma_testbus_polling_bypass,
        input   wire            r_rx_pld_test_data_polling_bypass,
        input   wire            r_rx_usertest_sel,
        input   wire            r_rx_rmfflag_stretch_enable,
        input   wire   [2:0]    r_rx_rmfflag_stretch_num_stages,

	// PCS_IF
	input	wire		pld_10g_krfec_rx_blk_lock,
	input	wire	[1:0]	pld_10g_krfec_rx_diag_data_status,
	input	wire		pld_10g_krfec_rx_frame,
	input	wire		pld_10g_rx_crc32_err,
	input	wire		pld_10g_rx_frame_lock,
	input	wire		pld_10g_rx_hi_ber,
	input	wire	[3:0]	pld_8g_a1a2_k1k2_flag,
	input	wire		pld_8g_empty_rmf,
	input	wire		pld_8g_full_rmf,
	input	wire		pld_8g_rxelecidle,
	input	wire		pld_8g_signal_detect_out,
	input	wire	[4:0]	pld_8g_wa_boundary,
	input	wire		pld_pma_adapt_done,
	input	wire	[1:0]	pld_pma_pcie_sw_done,
	input	wire	[4:0]	pld_pma_reserved_in,
	input	wire		pld_pma_rx_detect_valid,
	input	wire		pld_pma_rxpll_lock,
	input	wire		pld_pma_signal_ok,
	input	wire	[7:0]	pld_pma_testbus,
	input	wire		pld_rx_prbs_done,
	input	wire		pld_rx_prbs_err,
	input	wire	[19:0]	pld_test_data,
        input   wire            pld_pma_rx_found, 
        input   wire            pld_pma_pfdmode_lock,

	// RXCLK_CTL
	input	wire		rx_clock_async_rx_osc_clk,
	input	wire		rx_clock_async_tx_osc_clk,
	input	wire		rx_clock_reset_fifo_rd_clk,

	// RXRST_CTL
	input	wire		rx_reset_async_rx_osc_clk_rst_n,
	input	wire		rx_reset_async_tx_osc_clk_rst_n,
	input	wire		rx_reset_fifo_rd_rst_n,

	// RX_DATAPATH
	input	wire		fifo_empty,
	input	wire		fifo_full,
	input	wire		pma_adapt_rstn,
	input	wire		rx_fifo_ready,

	// SR
	input	wire   [2:0]	rx_async_fabric_hssi_fsr_data,
	input	wire		rx_async_fabric_hssi_fsr_load,
	input	wire   [35:0]	rx_async_fabric_hssi_ssr_data,
	input	wire		rx_async_fabric_hssi_ssr_load,
        input   wire            rx_async_hssi_fabric_fsr_load,
        input   wire            rx_async_hssi_fabric_ssr_load,
        input   wire   [1:0]    rx_async_fabric_hssi_ssr_reserved, // new
        input   wire   [5:0]    sr_parity_error_flag, 
	input	wire		avmm_transfer_error,
 
        // Reset SM 
        input   wire            rx_hrdrst_hssi_rx_dcd_cal_done,
        input   wire            rx_hrdrst_hssi_rx_transfer_en,
        input   wire            aib_hssi_rx_dcd_cal_done,
       
        // Testbus
        input   wire            rx_direct_transfer_testbus,
        // HIP 
        input   wire            hip_aib_async_out,
 
        // DFT
	input   wire            dft_adpt_rst,

	// AIB_IF
	output	wire		aib_hssi_pld_8g_rxelecidle,
	output	wire		aib_hssi_pld_pma_rxpll_lock,
        output  wire            aib_hssi_pld_pma_pfdmode_lock,

	// PCS_IF
	output	wire		pld_10g_krfec_rx_clr_errblk_cnt,
	// output	wire		pld_10g_rx_align_clr,
	output	wire		pld_10g_rx_clr_ber_count,
	output	wire		pld_8g_a1a2_size,
	output	wire		pld_8g_bitloc_rev_en,
	output	wire		pld_8g_byte_rev_en,
	output	wire	[2:0]	pld_8g_eidleinfersel,
	output	wire		pld_8g_encdt,
	output	wire		pld_bitslip,
	output	wire		pld_ltr,
	output	wire		pld_pma_adapt_start,
	output	wire		pld_pma_early_eios,
	output	wire	[5:0]	pld_pma_eye_monitor,
	output	wire		pld_pma_ltd_b,
	output	wire	[1:0]	pld_pma_pcie_switch,
	output	wire		pld_pma_ppm_lock,
	output	wire	[4:0]	pld_pma_reserved_out,
	output	wire		pld_pma_rs_lpbk_b,
	output	wire		pld_pmaif_rxclkslip,
	output	wire		pld_polinv_rx,
	output	wire		pld_rx_prbs_err_clr,
	output	wire		pld_syncsm_en,
	output	wire		pld_rx_fifo_latency_adj_en,

        // Reset SM
        output  wire            sr_fabric_rx_dll_lock, 
        output  wire            sr_pld_rx_dll_lock_req, 
        output  wire            sr_fabric_rx_transfer_en, 
        output  wire            sr_aib_hssi_rx_dcd_cal_req, 
        output  wire            sr_pld_rx_fifo_srst, 
        output  wire            sr_pld_rx_asn_data_transfer_en, 

        // RX FIFO
        output  wire            wr_align_clr,

	// SR
        output  wire   [2:0]    rx_fsr_parity_checker_in,
        output  wire   [37:0]   rx_ssr_parity_checker_in,

	output	wire	[1:0]   rx_async_hssi_fabric_fsr_data,
	output	wire    [62:0]	rx_async_hssi_fabric_ssr_data,
        output  wire    [1:0]   rx_async_hssi_fabric_ssr_reserved // new
);

// update
//assign r_rx_async_pld_ltr_rst_val       = avmm_rx_user_datain[0]
//assign r_rx_async_pld_pma_ltd_b_rst_val  = avmm_rx_user_datain[1]
// capture
//assign r_rx_async_pld_8g_signal_detect_out_rst_val  = avmm_rx_user_datain[2]
//assign r_rx_async_pld_10g_rx_crc32_err_rst_val      = avmm_rx_user_datain[3]
//assign r_rx_async_8g_dlsm_imm = avmm_rx_user_datain[4]
wire [1:0] pld_rx_ssr_reserved_in;
wire [1:0] pld_rx_ssr_reserved_out;
// wire       pld_10g_rx_align_clr_int;
wire       pld_ltr_int;
wire       pld_pma_ltd_b_int;
wire [35:0] rx_ssr_parity_checker_in_int;
wire        pld_8g_empty_rmf_pulse_stretch;
wire        pld_8g_full_rmf_pulse_stretch;
wire        pld_rx_prbs_err_pulse_stretch;
wire        pld_8g_empty_rmf_sync;
wire        pld_8g_full_rmf_sync;
wire        pld_rx_prbs_err_sync;
wire        pld_8g_empty_rmf_mux;
wire        pld_8g_full_rmf_mux;
wire        pld_rx_prbs_err_mux;

wire        pld_10g_rx_hi_ber_int;
wire        pld_rx_prbs_done_int;
wire        fifo_empty_int;
wire        fifo_full_int;

// Simply tied to SSR inputs
assign pld_rx_ssr_reserved_in = {pld_10g_krfec_rx_blk_lock, rx_fifo_ready};

assign rx_ssr_parity_checker_in = {pld_rx_ssr_reserved_out, rx_ssr_parity_checker_in_int};

// assign pld_10g_rx_align_clr = dft_adpt_rst ? 1'b1 : pld_10g_rx_align_clr_int;
assign pld_ltr              = dft_adpt_rst ? 1'b1 : pld_ltr_int;
assign pld_pma_ltd_b        = dft_adpt_rst ? 1'b1 : pld_pma_ltd_b_int;

assign sr_pld_rx_fifo_srst = pld_rx_ssr_reserved_out[0]; 
assign sr_pld_rx_asn_data_transfer_en =  pld_rx_ssr_reserved_out[1];

assign pld_10g_rx_hi_ber_int =  r_rx_pld_8g_a1a2_k1k2_flag_polling_bypass ? pld_8g_bitloc_rev_en         : pld_10g_rx_hi_ber;
assign pld_rx_prbs_done_int  =  r_rx_pld_8g_a1a2_k1k2_flag_polling_bypass ? pld_8g_byte_rev_en           : pld_rx_prbs_done;
assign fifo_empty_int        =  r_rx_pld_8g_a1a2_k1k2_flag_polling_bypass ? pld_rx_fifo_latency_adj_en   : fifo_empty;
assign fifo_full_int         =  r_rx_pld_8g_a1a2_k1k2_flag_polling_bypass ? sr_aib_hssi_rx_dcd_cal_req   : fifo_full;

// Pulse Stretch for 8G Empty/Full RMF: This only for GIGE mode
// hd_dpcmn_bitsync2
c3lib_bitsync
    #(
        .SRC_DATA_FREQ_MHZ  (500),    // Source data frequency
        .DST_CLK_FREQ_MHZ  (1000),    // Destination clock frequency
        .DWIDTH      (1),             // Sync Data input
        .RESET_VAL   (0)              // Reset value
    ) bitsync2_pld_8g_empty_rmf
    (
      .clk      (rx_clock_reset_fifo_rd_clk),
      .rst_n    (rx_reset_fifo_rd_rst_n),
      .data_in  (pld_8g_empty_rmf),
      .data_out (pld_8g_empty_rmf_sync)
    );

// hd_dpcmn_bitsync2
c3lib_bitsync
    #(
        .SRC_DATA_FREQ_MHZ  (500),    // Source data frequency
        .DST_CLK_FREQ_MHZ  (1000),    // Destination clock frequency
        .DWIDTH            (1),       // Sync Data input
        .RESET_VAL         (0)        // Reset value
    ) bitsync2_pld_8g_full_rmf
    (
      .clk      (rx_clock_reset_fifo_rd_clk),
      .rst_n    (rx_reset_fifo_rd_rst_n),
      .data_in  (pld_8g_full_rmf),
      .data_out (pld_8g_full_rmf_sync)
    );

// hd_dpcmn_bitsync2
c3lib_bitsync
    #(
        .SRC_DATA_FREQ_MHZ  (500),     // Source data frequency
        .DST_CLK_FREQ_MHZ  (1000),    // Destination clock frequency
        .DWIDTH      (1),             // Sync Data input
        .RESET_VAL   (0)              // Reset value
    ) bitsync2_pld_rx_prbs_err
    (
      .clk      (rx_clock_reset_fifo_rd_clk),
      .rst_n    (rx_reset_fifo_rd_rst_n),
      .data_in  (pld_rx_prbs_err),
      .data_out (pld_rx_prbs_err_sync)
    );


   c3aibadapt_cmn_pulse_stretch
     #(
       .RESET_VAL   (0)         // Reset Value
       ) adapt_cmn_pulse_stretch_pld_8g_empty_rmf
     (
      .clk           (rx_clock_reset_fifo_rd_clk),
      .rst_n         (rx_reset_fifo_rd_rst_n),
      .num_stages    (r_rx_rmfflag_stretch_num_stages),
      .data_in       (pld_8g_empty_rmf_sync),
      .data_out      (pld_8g_empty_rmf_pulse_stretch)
      );

   c3aibadapt_cmn_pulse_stretch
     #(
       .RESET_VAL   (0)         // Reset Value
       ) adapt_cmn_pulse_stretch_pld_8g_full_rmf
     (
      .clk           (rx_clock_reset_fifo_rd_clk),
      .rst_n         (rx_reset_fifo_rd_rst_n),
      .num_stages    (r_rx_rmfflag_stretch_num_stages),
      .data_in       (pld_8g_full_rmf_sync),
      .data_out      (pld_8g_full_rmf_pulse_stretch)
      );

   c3aibadapt_cmn_pulse_stretch
     #(
       .RESET_VAL   (0)         // Reset Value
       ) adapt_cmn_pulse_stretch_pld_rx_prbs_err
     (
      .clk           (rx_clock_reset_fifo_rd_clk),
      .rst_n         (rx_reset_fifo_rd_rst_n),
      .num_stages    (r_rx_rmfflag_stretch_num_stages),
      .data_in       (pld_rx_prbs_err_sync),
      .data_out      (pld_rx_prbs_err_pulse_stretch)
      );

assign pld_8g_empty_rmf_mux = r_rx_rmfflag_stretch_enable ? pld_8g_empty_rmf_pulse_stretch : pld_8g_empty_rmf;
assign pld_8g_full_rmf_mux  = r_rx_rmfflag_stretch_enable ? pld_8g_full_rmf_pulse_stretch  : pld_8g_full_rmf;
assign pld_rx_prbs_err_mux  = r_rx_rmfflag_stretch_enable ? pld_rx_prbs_err_pulse_stretch  : pld_rx_prbs_err;
// END Pulse Stretch for 8G Empty/Full RMF

c3aibadapt_rxasync_rsvd_capture adapt_rxasync_rsvd_capture (
     // input
     .pld_rx_ssr_reserved_in              (pld_rx_ssr_reserved_in),
     .rx_async_hssi_fabric_ssr_load       (rx_async_hssi_fabric_ssr_load),
     .rx_clock_async_tx_osc_clk           (rx_clock_async_tx_osc_clk),
     .rx_reset_async_tx_osc_clk_rst_n     (rx_reset_async_tx_osc_clk_rst_n),
     // output
     .rx_async_hssi_fabric_ssr_reserved   (rx_async_hssi_fabric_ssr_reserved)
);

c3aibadapt_rxasync_rsvd_update adapt_rxasync_rsvd_update (
     // input
    .rx_async_fabric_hssi_ssr_reserved    (rx_async_fabric_hssi_ssr_reserved),
    .rx_clock_async_rx_osc_clk            (rx_clock_async_rx_osc_clk),
    .rx_reset_async_rx_osc_clk_rst_n      (rx_reset_async_rx_osc_clk_rst_n),
    .rx_async_fabric_hssi_ssr_load        (rx_async_fabric_hssi_ssr_load),
    // output
    .pld_rx_ssr_reserved_out              (pld_rx_ssr_reserved_out)
);

c3aibadapt_rxasync_capture adapt_rxasync_capture (
     // input
     .rx_async_hssi_fabric_fsr_load       (rx_async_hssi_fabric_fsr_load),
     .rx_async_hssi_fabric_ssr_load       (rx_async_hssi_fabric_ssr_load),
     .pld_10g_krfec_rx_blk_lock           (pld_10g_krfec_rx_blk_lock),
     .pld_10g_krfec_rx_diag_data_status   (pld_10g_krfec_rx_diag_data_status),
     .pld_10g_krfec_rx_frame              (pld_10g_krfec_rx_frame),
     .pld_10g_rx_crc32_err                (pld_10g_rx_crc32_err),
     .pld_10g_rx_frame_lock               (pld_10g_rx_frame_lock),
     .pld_10g_rx_hi_ber                   (pld_10g_rx_hi_ber_int),
     .pld_8g_a1a2_k1k2_flag               (pld_8g_a1a2_k1k2_flag),
     .pld_8g_empty_rmf                    (pld_8g_empty_rmf_mux),
     .pld_8g_full_rmf                     (pld_8g_full_rmf_mux),
     .pld_8g_signal_detect_out            (pld_8g_signal_detect_out),
     .pld_8g_wa_boundary                  (pld_8g_wa_boundary),
     .pld_pma_adapt_done                  (pld_pma_adapt_done),
     .pld_pma_pcie_sw_done                (pld_pma_pcie_sw_done),
     .pld_pma_reserved_in                 (pld_pma_reserved_in),
     .pld_pma_rx_detect_valid             (pld_pma_rx_detect_valid),
     .pld_pma_signal_ok                   (pld_pma_signal_ok),
     .pld_pma_testbus                     (pld_pma_testbus),
     .pld_rx_prbs_done                    (pld_rx_prbs_done_int),
     .pld_rx_prbs_err                     (pld_rx_prbs_err_mux),
     .pld_test_data                       (pld_test_data),
     .pld_pma_rx_found                    (pld_pma_rx_found),
     .rx_clock_async_tx_osc_clk           (rx_clock_async_tx_osc_clk),
     .rx_reset_async_tx_osc_clk_rst_n     (rx_reset_async_tx_osc_clk_rst_n),
     .fifo_empty                          (fifo_empty_int),
     .fifo_full                           (fifo_full_int),
     .rx_hrdrst_hssi_rx_dcd_cal_done      (rx_hrdrst_hssi_rx_dcd_cal_done),
     .rx_hrdrst_hssi_rx_transfer_en       (rx_hrdrst_hssi_rx_transfer_en),
     .aib_hssi_rx_dcd_cal_done            (aib_hssi_rx_dcd_cal_done),
     .r_rx_async_pld_8g_signal_detect_out_rst_val (r_rx_async_pld_8g_signal_detect_out_rst_val),
     .r_rx_async_pld_10g_rx_crc32_err_rst_val     (r_rx_async_pld_10g_rx_crc32_err_rst_val),
     .r_rx_pld_8g_a1a2_k1k2_flag_polling_bypass   (r_rx_pld_8g_a1a2_k1k2_flag_polling_bypass),
     .r_rx_10g_krfec_rx_diag_data_status_polling_bypass(r_rx_10g_krfec_rx_diag_data_status_polling_bypass),
     .r_rx_pld_8g_wa_boundary_polling_bypass      (r_rx_pld_8g_wa_boundary_polling_bypass),
     .r_rx_pld_pma_pcie_sw_done_polling_bypass    (r_rx_pld_pma_pcie_sw_done_polling_bypass),
     .r_rx_pld_pma_reser_in_polling_bypass     (r_rx_pld_pma_reser_in_polling_bypass),
     .r_rx_pld_pma_testbus_polling_bypass         (r_rx_pld_pma_testbus_polling_bypass),
     .r_rx_pld_test_data_polling_bypass           (r_rx_pld_test_data_polling_bypass),
     // output
     .rx_async_hssi_fabric_fsr_data       (rx_async_hssi_fabric_fsr_data),
     .rx_async_hssi_fabric_ssr_data       (rx_async_hssi_fabric_ssr_data)
);

wire [4:0] pld_pma_reserved_out_i;

c3aibadapt_rxasync_update adapt_rxasync_update (
     // input
    .rx_clock_async_rx_osc_clk            (rx_clock_async_rx_osc_clk),
    .rx_reset_async_rx_osc_clk_rst_n      (rx_reset_async_rx_osc_clk_rst_n),
    .rx_async_fabric_hssi_fsr_data        (rx_async_fabric_hssi_fsr_data),
    .rx_async_fabric_hssi_fsr_load        (rx_async_fabric_hssi_fsr_load),
    .rx_async_fabric_hssi_ssr_data        (rx_async_fabric_hssi_ssr_data),
    .rx_async_fabric_hssi_ssr_load        (rx_async_fabric_hssi_ssr_load),
    .r_rx_async_pld_ltr_rst_val           (r_rx_async_pld_ltr_rst_val),
    .r_rx_async_pld_pma_ltd_b_rst_val     (r_rx_async_pld_pma_ltd_b_rst_val),
    .r_rx_async_pld_rx_fifo_align_clr_rst_val (r_rx_async_pld_rx_fifo_align_clr_rst_val),
    // output
    .rx_fsr_parity_checker_in             (rx_fsr_parity_checker_in),
    .rx_ssr_parity_checker_in             (rx_ssr_parity_checker_in_int),
    .pld_10g_krfec_rx_clr_errblk_cnt      (pld_10g_krfec_rx_clr_errblk_cnt),
    // .pld_10g_rx_align_clr                 (pld_10g_rx_align_clr_int),
    .pld_10g_rx_clr_ber_count             (pld_10g_rx_clr_ber_count),
    .pld_8g_a1a2_size                     (pld_8g_a1a2_size),
    .pld_8g_bitloc_rev_en                 (pld_8g_bitloc_rev_en),
    .pld_8g_byte_rev_en                   (pld_8g_byte_rev_en),
    .pld_8g_eidleinfersel                 (pld_8g_eidleinfersel),
    .pld_8g_encdt                         (pld_8g_encdt),
    .pld_bitslip                          (pld_bitslip),
    .pld_ltr                              (pld_ltr_int),
    .pld_pma_adapt_start                  (pld_pma_adapt_start),
    .pld_pma_early_eios                   (pld_pma_early_eios),
    .pld_pma_eye_monitor                  (pld_pma_eye_monitor),
    .pld_pma_ltd_b                        (pld_pma_ltd_b_int),
    .pld_pma_pcie_switch                  (pld_pma_pcie_switch),
    .pld_pma_ppm_lock                     (pld_pma_ppm_lock),
    .pld_pma_reserved_out                 (pld_pma_reserved_out_i),
    .pld_pma_rs_lpbk_b                    (pld_pma_rs_lpbk_b),
    .pld_pmaif_rxclkslip                  (pld_pmaif_rxclkslip),
    .pld_polinv_rx                        (pld_polinv_rx),
    .pld_rx_prbs_err_clr                  (pld_rx_prbs_err_clr),
    .pld_syncsm_en                        (pld_syncsm_en),
    .pld_rx_fifo_latency_adj_en           (pld_rx_fifo_latency_adj_en),
    .wr_align_clr                         (wr_align_clr),
    .sr_fabric_rx_dll_lock                (sr_fabric_rx_dll_lock),
    .sr_pld_rx_dll_lock_req               (sr_pld_rx_dll_lock_req),
    .sr_fabric_rx_transfer_en             (sr_fabric_rx_transfer_en),
    .sr_aib_hssi_rx_dcd_cal_req           (sr_aib_hssi_rx_dcd_cal_req)
);

// overwrite pld_pma_reserved_out[4] with pma_adapt_rstn from TxEq if r_rx_rxeq_en == 1
assign pld_pma_reserved_out = r_rx_rxeq_en ? {pma_adapt_rstn,pld_pma_reserved_out_i[3:0]} : pld_pma_reserved_out_i[4:0];

c3aibadapt_rxasync_direct adapt_rxasync_direct (
    // input
    .pld_8g_rxelecidle          (pld_8g_rxelecidle),
    .pld_pma_rxpll_lock         (pld_pma_rxpll_lock),  
    .pld_pma_pfdmode_lock       (pld_pma_pfdmode_lock),
    .hip_aib_async_out          (hip_aib_async_out),
    .rx_direct_transfer_testbus (rx_direct_transfer_testbus),
    .sr_parity_error_flag       (sr_parity_error_flag),
    .avmm_transfer_error        (avmm_transfer_error),
    .r_rx_async_hip_en          (r_rx_async_hip_en),
    .r_rx_parity_sel            (r_rx_parity_sel),
    .r_rx_usertest_sel          (r_rx_usertest_sel),
    // output
    .aib_hssi_pld_pma_pfdmode_lock (aib_hssi_pld_pma_pfdmode_lock),
    .aib_hssi_pld_8g_rxelecidle (aib_hssi_pld_8g_rxelecidle),
    .aib_hssi_pld_pma_rxpll_lock(aib_hssi_pld_pma_rxpll_lock)
);

endmodule
