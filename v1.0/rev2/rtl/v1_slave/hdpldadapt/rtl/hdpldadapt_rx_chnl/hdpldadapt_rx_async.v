// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module hdpldadapt_rx_async (
// DPRIO 
input   wire            r_rx_async_pld_ltr_rst_val,
input   wire            r_rx_async_pld_pma_ltd_b_rst_val,
input   wire            r_rx_async_pld_8g_signal_detect_out_rst_val,
input   wire            r_rx_async_pld_10g_rx_crc32_err_rst_val,
input   wire            r_rx_async_pld_rx_fifo_align_clr_rst_val,
input   wire            r_rx_async_prbs_flags_sr_enable,
input   wire            r_rx_pld_8g_eidleinfersel_polling_bypass,
input   wire            r_rx_pld_pma_eye_monitor_polling_bypass,
input   wire            r_rx_pld_pma_pcie_switch_polling_bypass,
input   wire            r_rx_pld_pma_reser_out_polling_bypass,

input   wire            nfrzdrv_in,
input   wire            usermode_in,

// PLD IF
input   wire            pr_channel_freeze_n,
input	wire		pld_ltr,
input	wire		pld_pma_ltd_b,
input	wire		pld_10g_krfec_rx_clr_errblk_cnt,
input	wire		pld_10g_rx_clr_ber_count,
input	wire		pld_8g_a1a2_size,
input	wire		pld_8g_bitloc_rev_en,
input	wire		pld_8g_byte_rev_en,
input	wire	[2:0]	pld_8g_eidleinfersel,
input	wire		pld_8g_encdt,
input	wire		pld_bitslip,
input	wire		pld_pma_adapt_start,
input	wire		pld_pma_early_eios,
input	wire	[5:0]	pld_pma_eye_monitor,
input	wire	[1:0]	pld_pma_pcie_switch,
input	wire		pld_pma_ppm_lock,
input	wire	[4:0]	pld_pma_reserved_out,
input	wire		pld_pma_rs_lpbk_b,
input	wire		pld_pmaif_rxclkslip,
input	wire		pld_polinv_rx,
input	wire		pld_rx_prbs_err_clr,
input	wire		pld_syncsm_en,
input   wire            pld_rx_fabric_fifo_align_clr,
input   wire            pld_rx_dll_lock_req,
input   wire            pld_rx_fifo_latency_adj_en,
input   wire            pld_aib_hssi_rx_dcd_cal_req,
input   wire    [1:0]   pld_rx_ssr_reserved_in,  

// RXRST_CTL
input	wire		rx_reset_async_rx_osc_clk_rst_n,
input	wire		rx_reset_async_tx_osc_clk_rst_n,

// RXCLK_CTL
input	wire		rx_clock_async_rx_osc_clk,
input	wire		rx_clock_async_tx_osc_clk,

// SR
input	wire		rx_async_hssi_fabric_fsr_load,
input	wire		rx_async_hssi_fabric_ssr_load,
input	wire  [1:0]	rx_async_hssi_fabric_fsr_data,
input	wire  [62:0]	rx_async_hssi_fabric_ssr_data,
input   wire            rx_async_fabric_hssi_fsr_load,
input   wire            rx_async_fabric_hssi_ssr_load,
input   wire  [1:0]     rx_async_hssi_fabric_ssr_reserved, 
input   wire  [19:0]    sr_testbus,

// AIB IF
input	wire		aib_fabric_pld_8g_rxelecidle,
input	wire		aib_fabric_pld_pma_rxpll_lock,
input   wire            aib_fabric_pld_pma_pfdmode_lock,

// Reset SM 
input   wire            rx_hrdrst_fabric_rx_dll_lock,
input   wire            rx_hrdrst_fabric_rx_transfer_en,

// RX FIFO
//input   wire    [1:0]   pld_rx_fabric_data_out,

// PLD IF
output  wire            pld_pma_pfdmode_lock,
output	wire		pld_8g_rxelecidle,
output	wire		pld_pma_rxpll_lock,
output	wire		pld_8g_signal_detect_out,
output	wire		pld_10g_krfec_rx_blk_lock,
output	wire	[1:0]	pld_10g_krfec_rx_diag_data_status,
output	wire		pld_10g_rx_crc32_err,
output	wire		pld_10g_rx_frame_lock,
output	wire		pld_10g_rx_hi_ber,
output	wire	[3:0]	pld_8g_a1a2_k1k2_flag,
output	wire		pld_8g_empty_rmf,
output	wire		pld_8g_full_rmf,
output	wire	[4:0]	pld_8g_wa_boundary,
output	wire		pld_pma_adapt_done,
output	wire	[1:0]	pld_pma_pcie_sw_done,
output	wire	[4:0]	pld_pma_reserved_in,
output	wire		pld_pma_rx_detect_valid,
output	wire		pld_pma_signal_ok,
output	wire	[7:0]	pld_pma_testbus,
output	wire		pld_rx_prbs_done,
output	wire		pld_rx_prbs_err,
output	wire		pld_pma_rx_found,
output	wire	[19:0]	pld_test_data,
output	wire	[19:0]  sr_test_data,
input	wire	[19:0]	pld_test_data_int,

output	wire		pld_10g_krfec_rx_frame,
output	wire		pld_rx_hssi_fifo_full,
output	wire		pld_rx_hssi_fifo_empty,
output  wire            pld_fsr_load,
output  wire            pld_ssr_load,
output  wire            pld_aib_hssi_rx_dcd_cal_done,
output  wire    [1:0]   pld_rx_ssr_reserved_out, 

// ASN
output   wire   [1:0]   rx_ssr_pcie_sw_done,

// Reset SM 
output   wire           sr_hssi_rx_dcd_cal_done,
output   wire           sr_hssi_rx_transfer_en,

// testbus
output   wire  [19:0]   sr_testbus_int,

// SR
output   wire  [1:0]     rx_fsr_parity_checker_in,
output   wire  [64:0]    rx_ssr_parity_checker_in,

output	wire   [2:0]    rx_async_fabric_hssi_fsr_data,
output	wire   [35:0]	rx_async_fabric_hssi_ssr_data,
output  wire    [1:0]   rx_async_fabric_hssi_ssr_reserved

);

// capture
//assign r_rx_async_pld_ltr_rst_val       = avmm_rx_user_datain[0]
//assign r_rx_async_pld_pma_ltd_b_rst_val  = avmm_rx_user_datain[1]
// update
//assign r_rx_async_pld_8g_signal_detect_out_rst_val  = avmm_rx_user_datain[2]
//assign r_rx_async_pld_10g_rx_crc32_err_rst_val      = avmm_rx_user_datain[3]

wire            pld_8g_rxelecidle_int;
wire            pld_pma_rxpll_lock_int;
wire            pld_8g_signal_detect_out_int;
wire            pld_10g_krfec_rx_blk_lock_int;
wire    [1:0]   pld_10g_krfec_rx_diag_data_status_int;
wire            pld_10g_rx_crc32_err_int;
wire            pld_10g_rx_frame_lock_int;
wire            pld_10g_rx_hi_ber_int;
wire    [3:0]   pld_8g_a1a2_k1k2_flag_int;
wire            pld_8g_empty_rmf_int;
wire            pld_8g_full_rmf_int;
wire    [4:0]   pld_8g_wa_boundary_int;
wire            pld_pma_adapt_done_int;
wire    [1:0]   pld_pma_pcie_sw_done_int;
wire    [4:0]   pld_pma_reserved_in_int;
wire            pld_pma_rx_detect_valid_int;
wire            pld_pma_signal_ok_int;
wire    [7:0]   pld_pma_testbus_int;
wire            pld_rx_prbs_done_int;
wire            pld_rx_prbs_err_int;
//wire    [19:0]  pld_test_data_int;
wire            pld_10g_krfec_rx_frame_int;
wire            pld_rx_hssi_fifo_full_int;
wire            pld_rx_hssi_fifo_empty_int;
wire            nfrz_output_2one;
wire            pld_pma_rx_found_int;
wire            pld_aib_hssi_rx_dcd_cal_done_int;
wire  [1:0]     pld_rx_ssr_reserved_out_int;
wire            pld_pma_pfdmode_lock_int;
wire  [62:0]    rx_ssr_parity_checker_in_int;
reg             ssr_load_int;
reg             fsr_load_int;
reg   [14:0]    sr_testbus_internal;
wire            pld_rx_dll_lock_req_int;
wire            pld_aib_hssi_rx_dcd_cal_req_int;

assign nfrz_output_2one  = nfrzdrv_in & pr_channel_freeze_n;

assign pld_8g_rxelecidle                  = nfrz_output_2one ? pld_8g_rxelecidle_int                 : 1'b1;
assign pld_pma_rxpll_lock                 = nfrz_output_2one ? pld_pma_rxpll_lock_int                : 1'b1;
assign pld_8g_signal_detect_out           = nfrz_output_2one ? pld_8g_signal_detect_out_int          : 1'b1;
assign pld_10g_krfec_rx_blk_lock          = nfrz_output_2one ? pld_10g_krfec_rx_blk_lock_int         : 1'b1;
assign pld_10g_krfec_rx_diag_data_status  = nfrz_output_2one ? pld_10g_krfec_rx_diag_data_status_int : 2'b11;
assign pld_10g_rx_crc32_err               = nfrz_output_2one ? pld_10g_rx_crc32_err_int              : 1'b1;
assign pld_10g_rx_frame_lock              = nfrz_output_2one ? pld_10g_rx_frame_lock_int             : 1'b1;
assign pld_10g_rx_hi_ber                  = nfrz_output_2one ? pld_10g_rx_hi_ber_int                 : 1'b1;
assign pld_8g_a1a2_k1k2_flag              = nfrz_output_2one ? pld_8g_a1a2_k1k2_flag_int             : 4'b1111;
assign pld_8g_empty_rmf                   = nfrz_output_2one ? pld_8g_empty_rmf_int                  : 1'b1;
assign pld_8g_full_rmf                    = nfrz_output_2one ? pld_8g_full_rmf_int                   : 1'b1;
assign pld_8g_wa_boundary                 = nfrz_output_2one ? pld_8g_wa_boundary_int                : 5'b11111;
assign pld_pma_adapt_done                 = nfrz_output_2one ? pld_pma_adapt_done_int                : 1'b1;
assign pld_pma_pcie_sw_done               = nfrz_output_2one ? pld_pma_pcie_sw_done_int              : 2'b11;
assign pld_pma_reserved_in                = nfrz_output_2one ? pld_pma_reserved_in_int               : 5'b11111;
assign pld_pma_rx_detect_valid            = nfrz_output_2one ? pld_pma_rx_detect_valid_int           : 1'b1;
assign pld_pma_signal_ok                  = nfrz_output_2one ? pld_pma_signal_ok_int                 : 1'b1;
assign pld_pma_testbus                    = nfrz_output_2one ? pld_pma_testbus_int                   : 8'hFF;
assign pld_rx_prbs_done                   = nfrz_output_2one ? pld_rx_prbs_done_int                  : 1'b1;
assign pld_rx_prbs_err                    = nfrz_output_2one ? pld_rx_prbs_err_int                   : 1'b1;
assign pld_pma_rx_found                   = nfrz_output_2one ? pld_pma_rx_found_int                  : 1'b1;  
assign pld_test_data                      = nfrz_output_2one ? pld_test_data_int                     : 20'hFFFFF;
assign pld_10g_krfec_rx_frame             = nfrz_output_2one ? pld_10g_krfec_rx_frame_int            : 1'b1;
assign pld_rx_hssi_fifo_full              = nfrz_output_2one ? pld_rx_hssi_fifo_full_int             : 1'b1;
assign pld_rx_hssi_fifo_empty             = nfrz_output_2one ? pld_rx_hssi_fifo_empty_int            : 1'b1;
assign pld_aib_hssi_rx_dcd_cal_done       = nfrz_output_2one ? pld_aib_hssi_rx_dcd_cal_done_int      : 1'b1;
assign pld_fsr_load                       = nfrz_output_2one ? fsr_load_int                          : 1'b1; 
assign pld_ssr_load                       = nfrz_output_2one ? ssr_load_int                          : 1'b1;
assign pld_rx_ssr_reserved_out            = nfrz_output_2one ? pld_rx_ssr_reserved_out_int           : 2'b11;
assign pld_pma_pfdmode_lock               = nfrz_output_2one ? pld_pma_pfdmode_lock_int              : 1'b1;

//assign pld_rx_prbs_done_internal          = r_rx_async_prbs_flags_sr_enable ? pld_rx_prbs_done_int : pld_rx_fabric_data_out[1];
//assign pld_rx_prbs_done_internal          = r_rx_async_prbs_flags_sr_enable ? pld_rx_prbs_done_int : pld_rx_fabric_data_out[1];

assign rx_ssr_parity_checker_in           = {pld_rx_ssr_reserved_out_int, rx_ssr_parity_checker_in_int};

assign pld_rx_dll_lock_req_int         = usermode_in & pld_rx_dll_lock_req; 
assign pld_aib_hssi_rx_dcd_cal_req_int = usermode_in & pld_aib_hssi_rx_dcd_cal_req;

always @(negedge rx_reset_async_tx_osc_clk_rst_n or posedge rx_clock_async_tx_osc_clk) begin
   if (rx_reset_async_tx_osc_clk_rst_n == 1'b0) begin
       ssr_load_int     <= 1'b1;
       fsr_load_int     <= 1'b1;
     end
   else 
     begin
       ssr_load_int     <= rx_async_fabric_hssi_ssr_load;
       fsr_load_int     <= rx_async_fabric_hssi_fsr_load;
     end
  end

assign sr_testbus_int = {5'd0, sr_testbus_internal};

always @(negedge rx_reset_async_tx_osc_clk_rst_n or posedge rx_clock_async_tx_osc_clk) begin
   if (rx_reset_async_tx_osc_clk_rst_n == 1'b0) begin
       sr_testbus_internal[12:0] <= 13'b1_0010_0000_0000;
     end
   else
     begin
       sr_testbus_internal[12:0] <= sr_testbus[12:0];
     end
  end

always @(negedge rx_reset_async_rx_osc_clk_rst_n or posedge rx_clock_async_rx_osc_clk) begin
   if (rx_reset_async_rx_osc_clk_rst_n == 1'b0) begin
       sr_testbus_internal[14:13] <= 2'b10;
     end
   else
     begin
       sr_testbus_internal[14:13] <= sr_testbus[14:13];
     end
  end


hdpldadapt_rx_async_reserved_capture hdpldadapt_rx_async_reserved_capture (
    // input
    .rx_async_fabric_hssi_ssr_load    (rx_async_fabric_hssi_ssr_load),
    .rx_clock_async_tx_osc_clk        (rx_clock_async_tx_osc_clk),
    .rx_reset_async_tx_osc_clk_rst_n  (rx_reset_async_tx_osc_clk_rst_n),
    .pld_rx_ssr_reserved_in           (pld_rx_ssr_reserved_in),
    // output
    .rx_async_fabric_hssi_ssr_reserved(rx_async_fabric_hssi_ssr_reserved)
);

hdpldadapt_rx_async_reserved_update hdpldadapt_rx_async_reserved_update (
    // input
    .rx_clock_async_rx_osc_clk        (rx_clock_async_rx_osc_clk),
    .rx_reset_async_rx_osc_clk_rst_n  (rx_reset_async_rx_osc_clk_rst_n),
    .rx_async_hssi_fabric_ssr_load    (rx_async_hssi_fabric_ssr_load),
    .rx_async_hssi_fabric_ssr_reserved(rx_async_hssi_fabric_ssr_reserved),
    // output
    .pld_rx_ssr_reserved_out          (pld_rx_ssr_reserved_out_int)
); 

hdpldadapt_rx_async_capture hdpldadapt_rx_async_capture (
    // input
    .rx_async_fabric_hssi_fsr_load    (rx_async_fabric_hssi_fsr_load),
    .rx_async_fabric_hssi_ssr_load    (rx_async_fabric_hssi_ssr_load),
    .rx_clock_async_tx_osc_clk        (rx_clock_async_tx_osc_clk),
    .rx_reset_async_tx_osc_clk_rst_n  (rx_reset_async_tx_osc_clk_rst_n),
    .pld_10g_krfec_rx_clr_errblk_cnt  (pld_10g_krfec_rx_clr_errblk_cnt),
    .pld_10g_rx_clr_ber_count         (pld_10g_rx_clr_ber_count),
    .pld_8g_a1a2_size                 (pld_8g_a1a2_size),
    .pld_8g_bitloc_rev_en             (pld_8g_bitloc_rev_en),
    .pld_8g_byte_rev_en               (pld_8g_byte_rev_en),
    .pld_8g_eidleinfersel             (pld_8g_eidleinfersel),
    .pld_8g_encdt                     (pld_8g_encdt),
    .pld_bitslip                      (pld_bitslip),
    .pld_ltr                          (pld_ltr),
    .pld_pma_adapt_start              (pld_pma_adapt_start),
    .pld_pma_early_eios               (pld_pma_early_eios),
    .pld_pma_eye_monitor              (pld_pma_eye_monitor),
    .pld_pma_ltd_b                    (pld_pma_ltd_b),
    .pld_pma_pcie_switch              (pld_pma_pcie_switch),
    .pld_pma_ppm_lock                 (pld_pma_ppm_lock),
    .pld_pma_reserved_out             (pld_pma_reserved_out),
    .pld_pma_rs_lpbk_b                (pld_pma_rs_lpbk_b),
    .pld_pmaif_rxclkslip              (pld_pmaif_rxclkslip),
    .pld_polinv_rx                    (pld_polinv_rx),
    .pld_rx_prbs_err_clr              (pld_rx_prbs_err_clr),
    .pld_syncsm_en                    (pld_syncsm_en),
    .pld_rx_fifo_latency_adj_en       (pld_rx_fifo_latency_adj_en),
    .pld_rx_fabric_fifo_align_clr     (pld_rx_fabric_fifo_align_clr),
    .pld_rx_dll_lock_req              (pld_rx_dll_lock_req_int),
    .pld_aib_hssi_rx_dcd_cal_req      (pld_aib_hssi_rx_dcd_cal_req_int),
    .rx_hrdrst_fabric_rx_dll_lock     (rx_hrdrst_fabric_rx_dll_lock),
    .rx_hrdrst_fabric_rx_transfer_en  (rx_hrdrst_fabric_rx_transfer_en), 
    .r_rx_async_pld_ltr_rst_val       (r_rx_async_pld_ltr_rst_val),
    .r_rx_async_pld_pma_ltd_b_rst_val (r_rx_async_pld_pma_ltd_b_rst_val),
    .r_rx_async_pld_rx_fifo_align_clr_rst_val (r_rx_async_pld_rx_fifo_align_clr_rst_val),
    .r_rx_pld_8g_eidleinfersel_polling_bypass (r_rx_pld_8g_eidleinfersel_polling_bypass),
    .r_rx_pld_pma_eye_monitor_polling_bypass  (r_rx_pld_pma_eye_monitor_polling_bypass),
    .r_rx_pld_pma_pcie_switch_polling_bypass  (r_rx_pld_pma_pcie_switch_polling_bypass),
    .r_rx_pld_pma_reser_out_polling_bypass (r_rx_pld_pma_reser_out_polling_bypass),
    // output
    .rx_async_fabric_hssi_fsr_data    (rx_async_fabric_hssi_fsr_data),
    .rx_async_fabric_hssi_ssr_data    (rx_async_fabric_hssi_ssr_data)
);

hdpldadapt_rx_async_update hdpldadapt_rx_async_update (
    // input
   .rx_clock_async_rx_osc_clk        (rx_clock_async_rx_osc_clk),
   .rx_reset_async_rx_osc_clk_rst_n  (rx_reset_async_rx_osc_clk_rst_n),
   .rx_async_hssi_fabric_fsr_data    (rx_async_hssi_fabric_fsr_data),
   .rx_async_hssi_fabric_fsr_load    (rx_async_hssi_fabric_fsr_load),
   .rx_async_hssi_fabric_ssr_data    (rx_async_hssi_fabric_ssr_data),
   .rx_async_hssi_fabric_ssr_load    (rx_async_hssi_fabric_ssr_load),
   .r_rx_async_pld_8g_signal_detect_out_rst_val (r_rx_async_pld_8g_signal_detect_out_rst_val),
   .r_rx_async_pld_10g_rx_crc32_err_rst_val     (r_rx_async_pld_10g_rx_crc32_err_rst_val),
   // output
   .rx_fsr_parity_checker_in         (rx_fsr_parity_checker_in),
   .rx_ssr_parity_checker_in         (rx_ssr_parity_checker_in_int),
   .pld_10g_krfec_rx_blk_lock        (pld_10g_krfec_rx_blk_lock_int),
   .pld_10g_krfec_rx_diag_data_status(pld_10g_krfec_rx_diag_data_status_int),
   .pld_10g_krfec_rx_frame           (pld_10g_krfec_rx_frame_int),
   .pld_10g_rx_crc32_err             (pld_10g_rx_crc32_err_int),
   .pld_10g_rx_frame_lock            (pld_10g_rx_frame_lock_int),
   .pld_10g_rx_hi_ber                (pld_10g_rx_hi_ber_int),
   .pld_8g_a1a2_k1k2_flag            (pld_8g_a1a2_k1k2_flag_int),
   .pld_8g_empty_rmf                 (pld_8g_empty_rmf_int),
   .pld_8g_full_rmf                  (pld_8g_full_rmf_int),
   .pld_8g_signal_detect_out         (pld_8g_signal_detect_out_int),
   .pld_8g_wa_boundary               (pld_8g_wa_boundary_int),
   .pld_pma_adapt_done               (pld_pma_adapt_done_int),
   .pld_pma_pcie_sw_done             (pld_pma_pcie_sw_done_int),
   .rx_ssr_pcie_sw_done              (rx_ssr_pcie_sw_done),
   .pld_pma_reserved_in              (pld_pma_reserved_in_int),
   .pld_pma_rx_detect_valid          (pld_pma_rx_detect_valid_int),
   .pld_pma_signal_ok                (pld_pma_signal_ok_int),
   .pld_pma_testbus                  (pld_pma_testbus_int),
   .pld_rx_prbs_done                 (pld_rx_prbs_done_int),
   .pld_rx_prbs_err                  (pld_rx_prbs_err_int),
   .pld_test_data                    (sr_test_data),
   .pld_pma_rx_found                 (pld_pma_rx_found_int),
   .pld_rx_hssi_fifo_empty           (pld_rx_hssi_fifo_empty_int),
   .pld_rx_hssi_fifo_full            (pld_rx_hssi_fifo_full_int),
   .pld_aib_hssi_rx_dcd_cal_done     (pld_aib_hssi_rx_dcd_cal_done_int),
   .sr_hssi_rx_dcd_cal_done          (sr_hssi_rx_dcd_cal_done),
   .sr_hssi_rx_transfer_en           (sr_hssi_rx_transfer_en)
);

hdpldadapt_rx_async_direct hdpldadapt_rx_async_direct (
   // input
   .aib_fabric_pld_8g_rxelecidle (aib_fabric_pld_8g_rxelecidle),
   .aib_fabric_pld_pma_rxpll_lock(aib_fabric_pld_pma_rxpll_lock),
   .aib_fabric_pld_pma_pfdmode_lock(aib_fabric_pld_pma_pfdmode_lock),
   // output
   .pld_pma_pfdmode_lock           (pld_pma_pfdmode_lock_int),
   .pld_8g_rxelecidle            (pld_8g_rxelecidle_int),
   .pld_pma_rxpll_lock           (pld_pma_rxpll_lock_int)
);

endmodule
