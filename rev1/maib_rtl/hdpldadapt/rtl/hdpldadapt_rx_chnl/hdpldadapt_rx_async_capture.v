// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module hdpldadapt_rx_async_capture (
// DPRIO
input   wire            r_rx_async_pld_ltr_rst_val,
input   wire            r_rx_async_pld_pma_ltd_b_rst_val,
input   wire            r_rx_async_pld_rx_fifo_align_clr_rst_val,
input   wire            r_rx_pld_8g_eidleinfersel_polling_bypass,
input   wire            r_rx_pld_pma_eye_monitor_polling_bypass,
input   wire            r_rx_pld_pma_pcie_switch_polling_bypass,
input   wire            r_rx_pld_pma_reser_out_polling_bypass,

// SR
input   wire            rx_async_fabric_hssi_fsr_load,
input   wire            rx_async_fabric_hssi_ssr_load,

// RXCLK_CTL
input   wire            rx_clock_async_tx_osc_clk,

// RXRST_CTL
input   wire            rx_reset_async_tx_osc_clk_rst_n,

// PCS_IF
input  wire             pld_10g_krfec_rx_clr_errblk_cnt,
input  wire             pld_10g_rx_clr_ber_count,
input  wire             pld_8g_a1a2_size,
input  wire             pld_8g_bitloc_rev_en,
input  wire             pld_8g_byte_rev_en,
input  wire    [2:0]    pld_8g_eidleinfersel,
input  wire             pld_8g_encdt,
input  wire             pld_bitslip,
input  wire             pld_ltr,
input  wire             pld_pma_adapt_start,
input  wire             pld_pma_early_eios,
input  wire    [5:0]    pld_pma_eye_monitor,
input  wire             pld_pma_ltd_b,
input  wire    [1:0]    pld_pma_pcie_switch,
input  wire             pld_pma_ppm_lock,
input  wire    [4:0]    pld_pma_reserved_out,
input  wire             pld_pma_rs_lpbk_b,
input  wire             pld_pmaif_rxclkslip,
input  wire             pld_polinv_rx,
input  wire             pld_rx_prbs_err_clr,
input  wire             pld_syncsm_en,
input  wire             pld_rx_fifo_latency_adj_en,
input  wire             pld_rx_fabric_fifo_align_clr,
input  wire             pld_rx_dll_lock_req,
input  wire             pld_aib_hssi_rx_dcd_cal_req,

// Reset SM
input   wire            rx_hrdrst_fabric_rx_dll_lock,
input   wire            rx_hrdrst_fabric_rx_transfer_en,

output   wire   [2:0]   rx_async_fabric_hssi_fsr_data,
output   wire   [35:0]  rx_async_fabric_hssi_ssr_data
);

wire            pld_10g_krfec_rx_clr_errblk_cnt_int;
wire            pld_10g_rx_clr_ber_count_int;
wire            pld_8g_a1a2_size_int;
wire            pld_8g_bitloc_rev_en_int;
wire            pld_8g_byte_rev_en_int;
wire    [2:0]   pld_8g_eidleinfersel_int;
wire            pld_8g_encdt_int;
wire            pld_bitslip_int;
wire            pld_ltr_rst1_int;
wire            pld_ltr_rst0_int;
wire            pld_pma_adapt_start_int;
wire            pld_pma_early_eios_int;
wire    [5:0]   pld_pma_eye_monitor_int;
wire            pld_pma_ltd_b_rst1_int;
wire            pld_pma_ltd_b_rst0_int;
wire    [1:0]   pld_pma_pcie_switch_int;
wire            pld_pma_ppm_lock_int;
wire    [4:0]   pld_pma_reserved_out_int;
wire            pld_pma_rs_lpbk_b_int;
wire            pld_pmaif_rxclkslip_int;
wire            pld_polinv_rx_int;
wire            pld_rx_prbs_err_clr_int;
wire            pld_syncsm_en_int;
wire            pld_rx_fifo_latency_adj_en_int;
wire            pld_rx_dll_lock_req_int;
wire            pld_aib_hssi_rx_dcd_cal_req_int;
wire            rx_hrdrst_fabric_rx_dll_lock_int;
wire            rx_hrdrst_fabric_rx_transfer_en_int;
wire            pld_rx_fabric_fifo_align_clr_rst1_int;
wire            pld_rx_fabric_fifo_align_clr_rst0_int;

wire nc_0;
wire nc_1;
wire nc_2;
wire nc_3;
wire nc_4;
wire nc_5;
wire nc_6;
wire nc_7;
wire nc_8;
wire nc_9;
wire nc_10;
wire nc_11;
wire nc_12;
wire nc_13;
wire nc_14;
wire nc_15;
wire nc_16;
wire nc_17;
wire nc_18;
wire nc_19;
wire nc_20;
wire nc_21;
wire nc_22;
wire nc_23;
wire nc_24;
wire nc_25;
wire nc_26;

// FAST SR: 
assign rx_async_fabric_hssi_fsr_data[0] = r_rx_async_pld_ltr_rst_val ? pld_ltr_rst1_int : pld_ltr_rst0_int;
assign rx_async_fabric_hssi_fsr_data[1] = r_rx_async_pld_pma_ltd_b_rst_val ? pld_pma_ltd_b_rst1_int : pld_pma_ltd_b_rst0_int;
assign rx_async_fabric_hssi_fsr_data[2] = r_rx_async_pld_rx_fifo_align_clr_rst_val ? pld_rx_fabric_fifo_align_clr_rst1_int : pld_rx_fabric_fifo_align_clr_rst0_int;

hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (1),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (3),
       .SYNC_STAGE  (4)
       )
      async_pld_ltr_rst1
      (
          .clk      (rx_clock_async_tx_osc_clk),
          .rst_n    (rx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_ltr),
          .unload   (rx_async_fabric_hssi_fsr_load),
          .data_in_sync_out (nc_0),
          .data_out (pld_ltr_rst1_int)
      );

hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (0),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (3),
       .SYNC_STAGE  (4)
       )
      async_pld_ltr_rst0
      (
          .clk      (rx_clock_async_tx_osc_clk),
          .rst_n    (rx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_ltr),
          .unload   (rx_async_fabric_hssi_fsr_load),
          .data_in_sync_out (nc_1),
          .data_out (pld_ltr_rst0_int)
      );

hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (1),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (3),
       .SYNC_STAGE  (4)
       )
      async_pld_pma_ltd_b_rst1
      (
          .clk      (rx_clock_async_tx_osc_clk),
          .rst_n    (rx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_pma_ltd_b),
          .unload   (rx_async_fabric_hssi_fsr_load),
          .data_in_sync_out (nc_2),
          .data_out (pld_pma_ltd_b_rst1_int)
      );

hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (0),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (3),
       .SYNC_STAGE  (4)
       )
      async_pld_pma_ltd_b_rst0
      (
          .clk      (rx_clock_async_tx_osc_clk),
          .rst_n    (rx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_pma_ltd_b),
          .unload   (rx_async_fabric_hssi_fsr_load),
          .data_in_sync_out (nc_3),
          .data_out (pld_pma_ltd_b_rst0_int)
      );

hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (1),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (4),
       .SYNC_STAGE  (2)
       )
      async_pld_rx_fabric_fifo_align_clr_rst1
      (
          .clk      (rx_clock_async_tx_osc_clk),
          .rst_n    (rx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_rx_fabric_fifo_align_clr),
          .unload   (rx_async_fabric_hssi_fsr_load),
          .data_in_sync_out (nc_4),
          .data_out (pld_rx_fabric_fifo_align_clr_rst1_int)
      );

hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (0),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (4),
       .SYNC_STAGE  (2)
       )
      async_pld_rx_fabric_fifo_align_clr_rst0
      (
          .clk      (rx_clock_async_tx_osc_clk),
          .rst_n    (rx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_rx_fabric_fifo_align_clr),
          .unload   (rx_async_fabric_hssi_fsr_load),
          .data_in_sync_out (nc_5),
          .data_out (pld_rx_fabric_fifo_align_clr_rst0_int)
      );



// SLOW SR: AR: to check reset value
assign rx_async_fabric_hssi_ssr_data[0]     =   pld_8g_a1a2_size_int;
assign rx_async_fabric_hssi_ssr_data[1]     =   pld_8g_bitloc_rev_en_int;
assign rx_async_fabric_hssi_ssr_data[2]     =   pld_8g_byte_rev_en_int;
assign rx_async_fabric_hssi_ssr_data[5:3]   =   pld_8g_eidleinfersel_int;
assign rx_async_fabric_hssi_ssr_data[6]     =   pld_8g_encdt_int;

assign rx_async_fabric_hssi_ssr_data[7]     =   pld_10g_krfec_rx_clr_errblk_cnt_int;
assign rx_async_fabric_hssi_ssr_data[8]     =   pld_10g_rx_clr_ber_count_int;

assign rx_async_fabric_hssi_ssr_data[9]     =   pld_pma_adapt_start_int;  
assign rx_async_fabric_hssi_ssr_data[10]    =   pld_pma_early_eios_int; 
assign rx_async_fabric_hssi_ssr_data[16:11] =   pld_pma_eye_monitor_int;
assign rx_async_fabric_hssi_ssr_data[18:17] =   pld_pma_pcie_switch_int;
assign rx_async_fabric_hssi_ssr_data[19]    =   pld_pma_ppm_lock_int;  
assign rx_async_fabric_hssi_ssr_data[24:20] =   pld_pma_reserved_out_int;
assign rx_async_fabric_hssi_ssr_data[25]    =   pld_pma_rs_lpbk_b_int;  
assign rx_async_fabric_hssi_ssr_data[26]    =   pld_pmaif_rxclkslip_int;

assign rx_async_fabric_hssi_ssr_data[27]    =   pld_bitslip_int;      
assign rx_async_fabric_hssi_ssr_data[28]    =   pld_polinv_rx_int;   
assign rx_async_fabric_hssi_ssr_data[29]    =   pld_rx_prbs_err_clr_int;
assign rx_async_fabric_hssi_ssr_data[30]    =   pld_syncsm_en_int;     
assign rx_async_fabric_hssi_ssr_data[31]    =   pld_rx_fifo_latency_adj_en_int;     

assign rx_async_fabric_hssi_ssr_data[32]    =   rx_hrdrst_fabric_rx_dll_lock_int;
assign rx_async_fabric_hssi_ssr_data[33]    =   pld_rx_dll_lock_req_int;
assign rx_async_fabric_hssi_ssr_data[34]    =   rx_hrdrst_fabric_rx_transfer_en_int;
assign rx_async_fabric_hssi_ssr_data[35]    =   pld_aib_hssi_rx_dcd_cal_req_int;


// 8G ASYNC
hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (1),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (5),
       .SYNC_STAGE  (2)
       )
      async_pld_8g_a1a2_size
      (
          .clk      (rx_clock_async_tx_osc_clk),
          .rst_n    (rx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_8g_a1a2_size),
          .unload   (rx_async_fabric_hssi_ssr_load),
          .data_in_sync_out (nc_6),
          .data_out (pld_8g_a1a2_size_int)
      );


hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (1),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (5),
       .SYNC_STAGE  (2)
       )
      async_pld_8g_bitloc_rev_en
      (
          .clk      (rx_clock_async_tx_osc_clk),
          .rst_n    (rx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_8g_bitloc_rev_en),
          .unload   (rx_async_fabric_hssi_ssr_load),
          .data_in_sync_out (nc_7),
          .data_out (pld_8g_bitloc_rev_en_int)
      );


hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (1),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (5),
       .SYNC_STAGE  (2)
       )
      async_pld_8g_byte_rev_en
      (
          .clk      (rx_clock_async_tx_osc_clk),
          .rst_n    (rx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_8g_byte_rev_en),
          .unload   (rx_async_fabric_hssi_ssr_load),
          .data_in_sync_out (nc_8),
          .data_out (pld_8g_byte_rev_en_int)
      );

hdpldadapt_cmn_async_capture_bus
     #(
       .DWIDTH      (3),
       .RESET_VAL   (1),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (3),
       .SYNC_STAGE  (4)
       )
      async_pld_8g_eidleinfersel
      (
          .clk         (rx_clock_async_tx_osc_clk),
          .rst_n       (rx_reset_async_tx_osc_clk_rst_n),
          .data_in     (pld_8g_eidleinfersel),
          .unload      (rx_async_fabric_hssi_ssr_load),
          .r_capt_mode (r_rx_pld_8g_eidleinfersel_polling_bypass),
          .data_out    (pld_8g_eidleinfersel_int)
      );

hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (1),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (3),
       .SYNC_STAGE  (2)
       )
      async_pld_8g_encdt
      (
          .clk      (rx_clock_async_tx_osc_clk),
          .rst_n    (rx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_8g_encdt),
          .unload   (rx_async_fabric_hssi_ssr_load),
          .data_in_sync_out (nc_9),
          .data_out (pld_8g_encdt_int)
      );


hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (1),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (5),
       .SYNC_STAGE  (2)
       )
      async_pld_10g_krfec_rx_clr_errblk_cnt
      (
          .clk      (rx_clock_async_tx_osc_clk),
          .rst_n    (rx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_10g_krfec_rx_clr_errblk_cnt),
          .unload   (rx_async_fabric_hssi_ssr_load),
          .data_in_sync_out (nc_10),
          .data_out (pld_10g_krfec_rx_clr_errblk_cnt_int)
      );


hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (1),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (5),
       .SYNC_STAGE  (2)
       )
      async_pld_10g_rx_clr_ber_count
      (
          .clk      (rx_clock_async_tx_osc_clk),
          .rst_n    (rx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_10g_rx_clr_ber_count),
          .unload   (rx_async_fabric_hssi_ssr_load),
          .data_in_sync_out (nc_11),
          .data_out (pld_10g_rx_clr_ber_count_int)
      );

hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (1),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (3),
       .SYNC_STAGE  (4)
       )
      async_pld_pma_adapt_start
      (
          .clk      (rx_clock_async_tx_osc_clk),
          .rst_n    (rx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_pma_adapt_start),
          .unload   (rx_async_fabric_hssi_ssr_load),
          .data_in_sync_out (nc_12),
          .data_out (pld_pma_adapt_start_int)
      );


hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (1),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (3),
       .SYNC_STAGE  (4)
       )
      async_pld_pma_early_eios
      (
          .clk      (rx_clock_async_tx_osc_clk),
          .rst_n    (rx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_pma_early_eios),
          .unload   (rx_async_fabric_hssi_ssr_load),
          .data_in_sync_out (nc_13),
          .data_out (pld_pma_early_eios_int)
      );

hdpldadapt_cmn_async_capture_bus
     #(
       .DWIDTH      (6),
       .RESET_VAL   (1),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (3),
       .SYNC_STAGE  (4)
       )
      async_pld_pma_eye_monitor
      (
          .clk         (rx_clock_async_tx_osc_clk),
          .rst_n       (rx_reset_async_tx_osc_clk_rst_n),
          .data_in     (pld_pma_eye_monitor),
          .unload      (rx_async_fabric_hssi_ssr_load),
          .r_capt_mode (r_rx_pld_pma_eye_monitor_polling_bypass),
          .data_out    (pld_pma_eye_monitor_int)
      );


hdpldadapt_cmn_async_capture_bus
     #(
       .DWIDTH      (2),
       .RESET_VAL   (1),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (3),
       .SYNC_STAGE  (4)
       )
      async_pld_pma_pcie_switch
      (
          .clk         (rx_clock_async_tx_osc_clk),
          .rst_n       (rx_reset_async_tx_osc_clk_rst_n),
          .data_in     (pld_pma_pcie_switch),
          .unload      (rx_async_fabric_hssi_ssr_load),
          .r_capt_mode (r_rx_pld_pma_pcie_switch_polling_bypass),
          .data_out    (pld_pma_pcie_switch_int)
      );


hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (1),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (3),
       .SYNC_STAGE  (4)
       )
      async_pld_pma_ppm_lock
      (
          .clk      (rx_clock_async_tx_osc_clk),
          .rst_n    (rx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_pma_ppm_lock),
          .unload   (rx_async_fabric_hssi_ssr_load),
          .data_in_sync_out (nc_14),
          .data_out (pld_pma_ppm_lock_int)
      );

hdpldadapt_cmn_async_capture_bus
     #(
       .DWIDTH      (5),
       .RESET_VAL   (1),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (3),
       .SYNC_STAGE  (4)
       )
      async_pld_pma_reserved_out
      (
          .clk         (rx_clock_async_tx_osc_clk),
          .rst_n       (rx_reset_async_tx_osc_clk_rst_n),
          .data_in     (pld_pma_reserved_out),
          .unload      (rx_async_fabric_hssi_ssr_load),
          .r_capt_mode (r_rx_pld_pma_reser_out_polling_bypass),
          .data_out    (pld_pma_reserved_out_int)
      );


hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (1),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (3),
       .SYNC_STAGE  (4)
       )
      async_pld_pma_rs_lpbk_b
      (
          .clk      (rx_clock_async_tx_osc_clk),
          .rst_n    (rx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_pma_rs_lpbk_b),
          .unload   (rx_async_fabric_hssi_ssr_load),
          .data_in_sync_out (nc_15),
          .data_out (pld_pma_rs_lpbk_b_int)
      );


hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (1),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (3),
       .SYNC_STAGE  (4)
       )
      async_pld_pmaif_rxclkslip
      (
          .clk      (rx_clock_async_tx_osc_clk),
          .rst_n    (rx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_pmaif_rxclkslip),
          .unload   (rx_async_fabric_hssi_ssr_load),
          .data_in_sync_out (nc_16),
          .data_out (pld_pmaif_rxclkslip_int)
      );


hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (1),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (4),
       .SYNC_STAGE  (2)
       )
      async_pld_bitslip
      (
          .clk      (rx_clock_async_tx_osc_clk),
          .rst_n    (rx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_bitslip),
          .unload   (rx_async_fabric_hssi_ssr_load),
          .data_in_sync_out (nc_17),
          .data_out (pld_bitslip_int)
      );


hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (1),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (5),
       .SYNC_STAGE  (2)
       )
      async_pld_polinv_rx
      (
          .clk      (rx_clock_async_tx_osc_clk),
          .rst_n    (rx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_polinv_rx),
          .unload   (rx_async_fabric_hssi_ssr_load),
          .data_in_sync_out (nc_18),
          .data_out (pld_polinv_rx_int)
      );

hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (1),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (5),
       .SYNC_STAGE  (2)
       )
      async_pld_rx_prbs_err_clr
      (
          .clk      (rx_clock_async_tx_osc_clk),
          .rst_n    (rx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_rx_prbs_err_clr),
          .unload   (rx_async_fabric_hssi_ssr_load),
          .data_in_sync_out (nc_19),
          .data_out (pld_rx_prbs_err_clr_int)
      );


hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (1),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (5),
       .SYNC_STAGE  (2)
       )
      async_pld_syncsm_en
      (
          .clk      (rx_clock_async_tx_osc_clk),
          .rst_n    (rx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_syncsm_en),
          .unload   (rx_async_fabric_hssi_ssr_load),
          .data_in_sync_out (nc_20),
          .data_out (pld_syncsm_en_int)
      );

hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (1),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (5),
       .SYNC_STAGE  (2)
       )
      async_pld_rx_fifo_latency_adj_en
      (
          .clk      (rx_clock_async_tx_osc_clk),
          .rst_n    (rx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_rx_fifo_latency_adj_en),
          .unload   (rx_async_fabric_hssi_ssr_load),
          .data_in_sync_out (nc_21),
          .data_out (pld_rx_fifo_latency_adj_en_int)
      );


hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (0),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (2),
       .SYNC_STAGE  (4)
       )
      async_pld_rx_dll_lock_req
      (
          .clk      (rx_clock_async_tx_osc_clk),
          .rst_n    (rx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_rx_dll_lock_req),
          .unload   (rx_async_fabric_hssi_ssr_load),
          .data_in_sync_out (nc_22),
          .data_out (pld_rx_dll_lock_req_int)
      );


hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (0),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (2),
       .SYNC_STAGE  (4)
       )
      async_rx_hrdrst_fabric_rx_dll_lock
      (
          .clk      (rx_clock_async_tx_osc_clk),
          .rst_n    (rx_reset_async_tx_osc_clk_rst_n),
          .data_in  (rx_hrdrst_fabric_rx_dll_lock),
          .unload   (rx_async_fabric_hssi_ssr_load),
          .data_in_sync_out (nc_24),
          .data_out (rx_hrdrst_fabric_rx_dll_lock_int)
      );

hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (0),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (2),
       .SYNC_STAGE  (4)
       )
      async_rx_hrdrst_fabric_rx_transfer_en
      (
          .clk      (rx_clock_async_tx_osc_clk),
          .rst_n    (rx_reset_async_tx_osc_clk_rst_n),
          .data_in  (rx_hrdrst_fabric_rx_transfer_en),
          .unload   (rx_async_fabric_hssi_ssr_load),
          .data_in_sync_out (nc_25),
          .data_out (rx_hrdrst_fabric_rx_transfer_en_int)
      );

hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (0),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (2),
       .SYNC_STAGE  (4)
       )
      async_pld_aib_hssi_rx_dcd_cal_req
      (
          .clk      (rx_clock_async_tx_osc_clk),
          .rst_n    (rx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_aib_hssi_rx_dcd_cal_req),
          .unload   (rx_async_fabric_hssi_ssr_load),
          .data_in_sync_out (nc_26),
          .data_out (pld_aib_hssi_rx_dcd_cal_req_int)
      );



endmodule
