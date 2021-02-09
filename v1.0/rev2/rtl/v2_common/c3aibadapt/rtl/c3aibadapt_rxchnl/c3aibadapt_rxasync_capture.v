// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3aibadapt_rxasync_capture (
// DPRIO
input   wire            r_rx_async_pld_8g_signal_detect_out_rst_val,
input   wire            r_rx_async_pld_10g_rx_crc32_err_rst_val,
input   wire            r_rx_pld_8g_a1a2_k1k2_flag_polling_bypass,
input   wire            r_rx_10g_krfec_rx_diag_data_status_polling_bypass,
input   wire            r_rx_pld_8g_wa_boundary_polling_bypass,
input   wire            r_rx_pld_pma_pcie_sw_done_polling_bypass,
input   wire            r_rx_pld_pma_reser_in_polling_bypass,
input   wire            r_rx_pld_pma_testbus_polling_bypass,
input   wire            r_rx_pld_test_data_polling_bypass,

// SR
input   wire            rx_async_hssi_fabric_fsr_load,
input   wire            rx_async_hssi_fabric_ssr_load,

// PCS_IF
input   wire            pld_10g_krfec_rx_blk_lock,
input   wire    [1:0]   pld_10g_krfec_rx_diag_data_status,
input   wire            pld_10g_krfec_rx_frame,
input   wire            pld_10g_rx_crc32_err,
input   wire            pld_10g_rx_frame_lock,
input   wire            pld_10g_rx_hi_ber,
input   wire    [3:0]   pld_8g_a1a2_k1k2_flag,
input   wire            pld_8g_empty_rmf,
input   wire            pld_8g_full_rmf,
input   wire            pld_8g_signal_detect_out,
input   wire    [4:0]   pld_8g_wa_boundary,
input   wire            pld_pma_adapt_done,
input   wire    [1:0]   pld_pma_pcie_sw_done,
input   wire    [4:0]   pld_pma_reserved_in,
input   wire            pld_pma_rx_detect_valid,
input   wire            pld_pma_signal_ok,
input   wire    [7:0]   pld_pma_testbus,
input   wire            pld_rx_prbs_done,
input   wire            pld_rx_prbs_err,
input   wire    [19:0]  pld_test_data,
input   wire            pld_pma_rx_found,

// Reset SM
input   wire            rx_hrdrst_hssi_rx_dcd_cal_done,
input   wire            rx_hrdrst_hssi_rx_transfer_en,
input   wire            aib_hssi_rx_dcd_cal_done,

// RXCLK_CTL
input   wire            rx_clock_async_tx_osc_clk, 

// RXRST_CTL
input   wire            rx_reset_async_tx_osc_clk_rst_n, 

// RX_DATAPATH
input   wire            fifo_empty,
input   wire            fifo_full,

// SR
output  wire   [1:0]    rx_async_hssi_fabric_fsr_data,
output  wire   [62:0]   rx_async_hssi_fabric_ssr_data  
);

wire            pld_10g_krfec_rx_blk_lock_int;
wire    [1:0]   pld_10g_krfec_rx_diag_data_status_int;
wire            pld_10g_krfec_rx_frame_int;
wire            pld_10g_rx_crc32_err_rst1_int;
wire            pld_10g_rx_crc32_err_rst0_int;
wire            pld_10g_rx_frame_lock_int;
wire            pld_10g_rx_hi_ber_int;
wire    [3:0]   pld_8g_a1a2_k1k2_flag_int;
wire            pld_8g_empty_rmf_int;
wire            pld_8g_full_rmf_int;
wire            pld_8g_signal_detect_out_rst0_int;
wire            pld_8g_signal_detect_out_rst1_int;
wire    [4:0]   pld_8g_wa_boundary_int;
wire            pld_pma_adapt_done_int;
wire    [1:0]   pld_pma_pcie_sw_done_int;
wire    [4:0]   pld_pma_reserved_in_int;
wire            pld_pma_rx_detect_valid_int;
wire            pld_pma_signal_ok_int;
wire    [7:0]   pld_pma_testbus_int;
wire            pld_rx_prbs_done_int;
wire            pld_rx_prbs_err_int;
wire    [19:0]  pld_test_data_int;
wire            pld_pma_rx_found_int;
wire            fifo_empty_int;
wire            fifo_full_int;
wire            rx_hrdrst_hssi_rx_dcd_cal_done_int;
wire            rx_hrdrst_hssi_rx_transfer_en_int;
wire            aib_hssi_rx_dcd_cal_done_int;

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

// FAST SR:
assign rx_async_hssi_fabric_fsr_data[0] = r_rx_async_pld_8g_signal_detect_out_rst_val ? pld_8g_signal_detect_out_rst1_int : pld_8g_signal_detect_out_rst0_int;
assign rx_async_hssi_fabric_fsr_data[1] = r_rx_async_pld_10g_rx_crc32_err_rst_val     ? pld_10g_rx_crc32_err_rst1_int     : pld_10g_rx_crc32_err_rst0_int;

c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (3),
       .RESET_VAL   (1)
       )
      async_pld_8g_signal_detect_out_rst1
      (
          .clk      (rx_clock_async_tx_osc_clk),
          .rst_n    (rx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_8g_signal_detect_out),
          .unload   (rx_async_hssi_fabric_fsr_load),
          .data_in_sync_out (nc_0),
          .data_out (pld_8g_signal_detect_out_rst1_int)
      );

c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (3),
       .RESET_VAL   (0)
       )
      async_pld_8g_signal_detect_out_rst0
      (
          .clk      (rx_clock_async_tx_osc_clk),
          .rst_n    (rx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_8g_signal_detect_out),
          .unload   (rx_async_hssi_fabric_fsr_load),
          .data_in_sync_out (nc_1),
          .data_out (pld_8g_signal_detect_out_rst0_int)
      );

c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (2),
       .RESET_VAL   (1)
       )
      async_pld_10g_rx_crc32_err_rst1
      (
          .clk      (rx_clock_async_tx_osc_clk),
          .rst_n    (rx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_10g_rx_crc32_err),
          .unload   (rx_async_hssi_fabric_fsr_load),
          .data_in_sync_out (nc_2),
          .data_out (pld_10g_rx_crc32_err_rst1_int)
      );

c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (2),
       .RESET_VAL   (0)
       )
      async_pld_10g_rx_crc32_err_rst0
      (
          .clk      (rx_clock_async_tx_osc_clk),
          .rst_n    (rx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_10g_rx_crc32_err),
          .unload   (rx_async_hssi_fabric_fsr_load),
          .data_in_sync_out (nc_3),
          .data_out (pld_10g_rx_crc32_err_rst0_int)
      );

// SLOW SR:
assign rx_async_hssi_fabric_ssr_data[3:0]   =  pld_8g_a1a2_k1k2_flag_int;
assign rx_async_hssi_fabric_ssr_data[4]     =  pld_8g_empty_rmf_int;
assign rx_async_hssi_fabric_ssr_data[5]     =  pld_8g_full_rmf_int;
assign rx_async_hssi_fabric_ssr_data[10:6]  =  pld_8g_wa_boundary_int;


assign rx_async_hssi_fabric_ssr_data[11]    =  pld_10g_krfec_rx_blk_lock_int;
assign rx_async_hssi_fabric_ssr_data[13:12] =  pld_10g_krfec_rx_diag_data_status_int;
assign rx_async_hssi_fabric_ssr_data[14]    =  pld_10g_krfec_rx_frame_int;
assign rx_async_hssi_fabric_ssr_data[15]    =  pld_10g_rx_frame_lock_int;
assign rx_async_hssi_fabric_ssr_data[16]    =  pld_10g_rx_hi_ber_int;

assign rx_async_hssi_fabric_ssr_data[17]    =  pld_pma_adapt_done_int;
assign rx_async_hssi_fabric_ssr_data[19:18] =  pld_pma_pcie_sw_done_int;
assign rx_async_hssi_fabric_ssr_data[24:20] =  pld_pma_reserved_in_int;
assign rx_async_hssi_fabric_ssr_data[25]    =  pld_pma_rx_detect_valid_int;
assign rx_async_hssi_fabric_ssr_data[26]    =  pld_pma_signal_ok_int;
assign rx_async_hssi_fabric_ssr_data[34:27] =  pld_pma_testbus_int;

assign rx_async_hssi_fabric_ssr_data[35]    =  pld_rx_prbs_done_int;
assign rx_async_hssi_fabric_ssr_data[36]    =  pld_rx_prbs_err_int;
assign rx_async_hssi_fabric_ssr_data[56:37] =  pld_test_data_int;
assign rx_async_hssi_fabric_ssr_data[57]    =  pld_pma_rx_found_int; 
assign rx_async_hssi_fabric_ssr_data[58]    =  fifo_empty_int; 
assign rx_async_hssi_fabric_ssr_data[59]    =  fifo_full_int;

assign rx_async_hssi_fabric_ssr_data[60]    =  rx_hrdrst_hssi_rx_dcd_cal_done_int;
assign rx_async_hssi_fabric_ssr_data[61]    =  rx_hrdrst_hssi_rx_transfer_en_int;
assign rx_async_hssi_fabric_ssr_data[62]    =  aib_hssi_rx_dcd_cal_done_int;

c3aibadapt_cmn_async_capture_bus
     #(
       .SYNC_STAGE  (2),
       .DWIDTH      (4),
       .RESET_VAL   (0)
       )
      async_pld_8g_a1a2_k1k2_flag
      (
          .clk         (rx_clock_async_tx_osc_clk),
          .rst_n       (rx_reset_async_tx_osc_clk_rst_n),
          .data_in     (pld_8g_a1a2_k1k2_flag),
          .unload      (rx_async_hssi_fabric_ssr_load),
          .r_capt_mode (r_rx_pld_8g_a1a2_k1k2_flag_polling_bypass),
          .data_out    (pld_8g_a1a2_k1k2_flag_int)
      );

c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (2),
       .RESET_VAL   (0)
       )
      async_pld_8g_empty_rmf
      (
          .clk      (rx_clock_async_tx_osc_clk),
          .rst_n    (rx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_8g_empty_rmf),
          .unload   (rx_async_hssi_fabric_ssr_load),
          .data_in_sync_out (nc_4),
          .data_out (pld_8g_empty_rmf_int)
      );


c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (2),
       .RESET_VAL   (0)
       )
      async_pld_8g_full_rmf
      (
          .clk      (rx_clock_async_tx_osc_clk),
          .rst_n    (rx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_8g_full_rmf),
          .unload   (rx_async_hssi_fabric_ssr_load),
          .data_in_sync_out (nc_5),
          .data_out (pld_8g_full_rmf_int)
      );

c3aibadapt_cmn_async_capture_bus
     #(
       .SYNC_STAGE  (3),
       .DWIDTH      (5),
       .RESET_VAL   (0)
       )
      async_pld_8g_wa_boundary
      (
          .clk         (rx_clock_async_tx_osc_clk),
          .rst_n       (rx_reset_async_tx_osc_clk_rst_n),
          .data_in     (pld_8g_wa_boundary),
          .unload      (rx_async_hssi_fabric_ssr_load),
          .r_capt_mode (r_rx_pld_8g_wa_boundary_polling_bypass),
          .data_out    (pld_8g_wa_boundary_int)
      );

c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (2),
       .RESET_VAL   (0)
       )
      async_pld_10g_krfec_rx_blk_lock
      (
          .clk      (rx_clock_async_tx_osc_clk),
          .rst_n    (rx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_10g_krfec_rx_blk_lock),
          .unload   (rx_async_hssi_fabric_ssr_load),
          .data_in_sync_out (nc_20),
          .data_out (pld_10g_krfec_rx_blk_lock_int)
      );

c3aibadapt_cmn_async_capture_bus
     #(
       .SYNC_STAGE  (2),
       .DWIDTH      (2),
       .RESET_VAL   (0)
       )
      async_pld_10g_krfec_rx_diag_data_status
      (
          .clk         (rx_clock_async_tx_osc_clk),
          .rst_n       (rx_reset_async_tx_osc_clk_rst_n),
          .data_in     (pld_10g_krfec_rx_diag_data_status),
          .unload      (rx_async_hssi_fabric_ssr_load),
          .r_capt_mode (r_rx_10g_krfec_rx_diag_data_status_polling_bypass),
          .data_out    (pld_10g_krfec_rx_diag_data_status_int)
      );

c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (2),
       .RESET_VAL   (0)
       )
      async_pld_10g_krfec_rx_frame
      (
          .clk      (rx_clock_async_tx_osc_clk),
          .rst_n    (rx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_10g_krfec_rx_frame),
          .unload   (rx_async_hssi_fabric_ssr_load),
          .data_in_sync_out (nc_6),
          .data_out (pld_10g_krfec_rx_frame_int)
      );


c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (2),
       .RESET_VAL   (0)
       )
      async_pld_10g_rx_frame_lock
      (
          .clk      (rx_clock_async_tx_osc_clk),
          .rst_n    (rx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_10g_rx_frame_lock),
          .unload   (rx_async_hssi_fabric_ssr_load),
          .data_in_sync_out (nc_7),
          .data_out (pld_10g_rx_frame_lock_int)
      );


c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (2),
       .RESET_VAL   (0)
       )
      async_pld_10g_rx_hi_ber
      (
          .clk      (rx_clock_async_tx_osc_clk),
          .rst_n    (rx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_10g_rx_hi_ber),
          .unload   (rx_async_hssi_fabric_ssr_load),
          .data_in_sync_out (nc_8),
          .data_out (pld_10g_rx_hi_ber_int)
      );


c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (3),
       .RESET_VAL   (0)
       )
      async_pld_pma_adapt_done
      (
          .clk      (rx_clock_async_tx_osc_clk),
          .rst_n    (rx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_pma_adapt_done),
          .unload   (rx_async_hssi_fabric_ssr_load),
          .data_in_sync_out (nc_9),
          .data_out (pld_pma_adapt_done_int)
      );

c3aibadapt_cmn_async_capture_bus
     #(
       .SYNC_STAGE  (3),
       .DWIDTH      (2),
       .RESET_VAL   (0)
       )
      async_pld_pma_pcie_sw_done
      (
          .clk         (rx_clock_async_tx_osc_clk),
          .rst_n       (rx_reset_async_tx_osc_clk_rst_n),
          .data_in     (pld_pma_pcie_sw_done),
          .unload      (rx_async_hssi_fabric_ssr_load),
          .r_capt_mode (r_rx_pld_pma_pcie_sw_done_polling_bypass),
          .data_out    (pld_pma_pcie_sw_done_int)
      );

c3aibadapt_cmn_async_capture_bus
     #(
       .SYNC_STAGE  (3),
       .DWIDTH      (5),
       .RESET_VAL   (0)
       )
      async_pld_pma_reserved_in
      (
          .clk         (rx_clock_async_tx_osc_clk),
          .rst_n       (rx_reset_async_tx_osc_clk_rst_n),
          .data_in     (pld_pma_reserved_in),
          .unload      (rx_async_hssi_fabric_ssr_load),
          .r_capt_mode (r_rx_pld_pma_reser_in_polling_bypass),
          .data_out    (pld_pma_reserved_in_int)
      );

c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (3),
       .RESET_VAL   (0)
       )
      async_pld_pma_rx_detect_valid
      (
          .clk      (rx_clock_async_tx_osc_clk),
          .rst_n    (rx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_pma_rx_detect_valid),
          .unload   (rx_async_hssi_fabric_ssr_load),
          .data_in_sync_out (nc_10),
          .data_out (pld_pma_rx_detect_valid_int)
      );


c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (2),
       .RESET_VAL   (0)
       )
      async_pld_pma_signal_ok
      (
          .clk      (rx_clock_async_tx_osc_clk),
          .rst_n    (rx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_pma_signal_ok),
          .unload   (rx_async_hssi_fabric_ssr_load),
          .data_in_sync_out (nc_11),
          .data_out (pld_pma_signal_ok_int)
      );

c3aibadapt_cmn_async_capture_bus
     #(
       .SYNC_STAGE  (3),
       .DWIDTH      (8),
       .RESET_VAL   (0)
       )
      async_pld_pma_testbus
      (
          .clk         (rx_clock_async_tx_osc_clk),
          .rst_n       (rx_reset_async_tx_osc_clk_rst_n),
          .data_in     (pld_pma_testbus),
          .unload      (rx_async_hssi_fabric_ssr_load),
          .r_capt_mode (r_rx_pld_pma_testbus_polling_bypass),
          .data_out    (pld_pma_testbus_int)
      );


c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (2),
       .RESET_VAL   (0)
       )
      async_pld_rx_prbs_done
      (
          .clk      (rx_clock_async_tx_osc_clk),
          .rst_n    (rx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_rx_prbs_done),
          .unload   (rx_async_hssi_fabric_ssr_load),
          .data_in_sync_out (nc_12),
          .data_out (pld_rx_prbs_done_int)
      );


c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (2),
       .RESET_VAL   (0)
       )
      async_pld_rx_prbs_err
      (
          .clk      (rx_clock_async_tx_osc_clk),
          .rst_n    (rx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_rx_prbs_err),
          .unload   (rx_async_hssi_fabric_ssr_load),
          .data_in_sync_out (nc_13),
          .data_out (pld_rx_prbs_err_int)
      );

c3aibadapt_cmn_async_capture_bus
     #(
       .SYNC_STAGE  (3),
       .DWIDTH      (20),
       .RESET_VAL   (0)
       )
      async_pld_test_data
      (
          .clk         (rx_clock_async_tx_osc_clk),
          .rst_n       (rx_reset_async_tx_osc_clk_rst_n),
          .data_in     (pld_test_data),
          .unload      (rx_async_hssi_fabric_ssr_load),
          .r_capt_mode (r_rx_pld_test_data_polling_bypass),
          .data_out    (pld_test_data_int)
      );

c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (2),
       .RESET_VAL   (0)
       )
      async_pld_pma_rx_found
      (
          .clk      (rx_clock_async_tx_osc_clk),
          .rst_n    (rx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_pma_rx_found),
          .unload   (rx_async_hssi_fabric_ssr_load),
          .data_in_sync_out (nc_14),
          .data_out (pld_pma_rx_found_int)
      );

c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (2),
       .RESET_VAL   (1)
       )
      async_fifo_empty
      (
          .clk      (rx_clock_async_tx_osc_clk),
          .rst_n    (rx_reset_async_tx_osc_clk_rst_n),
          .data_in  (fifo_empty),
          .unload   (rx_async_hssi_fabric_ssr_load),
          .data_in_sync_out (nc_15),
          .data_out (fifo_empty_int)
      );


c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (2),
       .RESET_VAL   (0)
       )
      async_fifo_full
      (
          .clk      (rx_clock_async_tx_osc_clk),
          .rst_n    (rx_reset_async_tx_osc_clk_rst_n),
          .data_in  (fifo_full),
          .unload   (rx_async_hssi_fabric_ssr_load),
          .data_in_sync_out (nc_16),
          .data_out (fifo_full_int)
      );


c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (3),
       .RESET_VAL   (0)
       )
      async_rx_hrdrst_hssi_rx_dcd_cal_done
      (
          .clk      (rx_clock_async_tx_osc_clk),
          .rst_n    (rx_reset_async_tx_osc_clk_rst_n),
          .data_in  (rx_hrdrst_hssi_rx_dcd_cal_done),
          .unload   (rx_async_hssi_fabric_ssr_load),
          .data_in_sync_out (nc_17),
          .data_out (rx_hrdrst_hssi_rx_dcd_cal_done_int)
      );

c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (3),
       .RESET_VAL   (0)
       )
      async_rx_hrdrst_hssi_rx_transfer_en
      (
          .clk      (rx_clock_async_tx_osc_clk),
          .rst_n    (rx_reset_async_tx_osc_clk_rst_n),
          .data_in  (rx_hrdrst_hssi_rx_transfer_en),
          .unload   (rx_async_hssi_fabric_ssr_load),
          .data_in_sync_out (nc_18),
          .data_out (rx_hrdrst_hssi_rx_transfer_en_int)
      );

c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (3),
       .RESET_VAL   (0)
       )
      async_aib_hssi_rx_dcd_cal_done
      (
          .clk      (rx_clock_async_tx_osc_clk),
          .rst_n    (rx_reset_async_tx_osc_clk_rst_n),
          .data_in  (aib_hssi_rx_dcd_cal_done),
          .unload   (rx_async_hssi_fabric_ssr_load),
          .data_in_sync_out (nc_19),
          .data_out (aib_hssi_rx_dcd_cal_done_int)
      );

endmodule
