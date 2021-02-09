// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module hdpldadapt_rx_async_update (
// DPRIO
input   wire            r_rx_async_pld_8g_signal_detect_out_rst_val,
input   wire            r_rx_async_pld_10g_rx_crc32_err_rst_val,

// RXCLK_CTL
input   wire            rx_clock_async_rx_osc_clk, 

// RXRST_CTL
input   wire            rx_reset_async_rx_osc_clk_rst_n,

// SR
input  wire    [1:0]    rx_async_hssi_fabric_fsr_data,
input  wire             rx_async_hssi_fabric_fsr_load,
input  wire    [62:0]   rx_async_hssi_fabric_ssr_data,
input  wire             rx_async_hssi_fabric_ssr_load,

// PLD IF
output   wire            pld_10g_krfec_rx_blk_lock,
output   wire    [1:0]   pld_10g_krfec_rx_diag_data_status,
output   wire            pld_10g_krfec_rx_frame,
output   wire            pld_10g_rx_crc32_err,
output   wire            pld_10g_rx_frame_lock,
output   wire            pld_10g_rx_hi_ber,
output   wire    [3:0]   pld_8g_a1a2_k1k2_flag,
output   wire            pld_8g_empty_rmf,
output   wire            pld_8g_full_rmf,
output   wire            pld_8g_signal_detect_out,
output   wire    [4:0]   pld_8g_wa_boundary,
output   wire            pld_pma_adapt_done,
output   wire    [1:0]   pld_pma_pcie_sw_done,
output   wire    [1:0]   rx_ssr_pcie_sw_done, 
output   wire    [4:0]   pld_pma_reserved_in,
output   wire            pld_pma_rx_detect_valid,
output   wire            pld_pma_signal_ok,
output   wire    [7:0]   pld_pma_testbus,
output   wire            pld_rx_prbs_done,
output   wire            pld_rx_prbs_err,
output   wire    [19:0]  pld_test_data,
output   wire            pld_pma_rx_found,
output   wire            pld_rx_hssi_fifo_empty,
output   wire            pld_rx_hssi_fifo_full,

// SR
output   wire  [1:0]     rx_fsr_parity_checker_in,
output   wire  [62:0]    rx_ssr_parity_checker_in,

// Reset SM
output   wire           sr_hssi_rx_dcd_cal_done,
output   wire           sr_hssi_rx_transfer_en,
output   wire           pld_aib_hssi_rx_dcd_cal_done
);

wire            pld_10g_krfec_rx_blk_lock_int;
wire    [1:0]   pld_10g_krfec_rx_diag_data_status_int;
wire            pld_10g_krfec_rx_frame_int;
wire            pld_10g_rx_crc32_err_int;
wire            pld_10g_rx_frame_lock_int;
wire            pld_10g_rx_hi_ber_int;
wire    [3:0]   pld_8g_a1a2_k1k2_flag_int;
wire            pld_8g_empty_rmf_int;
wire            pld_8g_full_rmf_int;
wire            pld_8g_signal_detect_out_int;
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
wire            pld_rx_hssi_fifo_empty_int;
wire            pld_rx_hssi_fifo_full_int;
wire            sr_hssi_rx_dcd_cal_done_int;
wire            sr_hssi_rx_transfer_en_int;
wire            pld_aib_hssi_rx_dcd_cal_done_int;
wire            pld_8g_signal_detect_out_rst1;
wire            pld_8g_signal_detect_out_rst0;
wire            pld_10g_rx_crc32_err_rst1;
wire            pld_10g_rx_crc32_err_rst0;

// FAST SR:
assign pld_8g_signal_detect_out_int = rx_async_hssi_fabric_fsr_data[0];
assign pld_10g_rx_crc32_err_int     = rx_async_hssi_fabric_fsr_data[1];

assign rx_fsr_parity_checker_in     = {pld_10g_rx_crc32_err, pld_8g_signal_detect_out};
// 8G
hdpldadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (1)
     ) async_pld_8g_signal_detect_out_rst1
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_hssi_fabric_fsr_load),
       .async_data_in   (pld_8g_signal_detect_out_int),
       .async_data_out  (pld_8g_signal_detect_out_rst1)
     );

hdpldadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_pld_8g_signal_detect_out_rst0
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_hssi_fabric_fsr_load),
       .async_data_in   (pld_8g_signal_detect_out_int),
       .async_data_out  (pld_8g_signal_detect_out_rst0)
     );

assign pld_8g_signal_detect_out = r_rx_async_pld_8g_signal_detect_out_rst_val ? pld_8g_signal_detect_out_rst1 : pld_8g_signal_detect_out_rst0;

// 10G
hdpldadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (1)
     ) async_pld_10g_rx_crc32_err_rst1
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_hssi_fabric_fsr_load),
       .async_data_in   (pld_10g_rx_crc32_err_int),
       .async_data_out  (pld_10g_rx_crc32_err_rst1)
     );

hdpldadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_pld_10g_rx_crc32_err_rst0
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_hssi_fabric_fsr_load),
       .async_data_in   (pld_10g_rx_crc32_err_int),
       .async_data_out  (pld_10g_rx_crc32_err_rst0)
     );

assign pld_10g_rx_crc32_err     = r_rx_async_pld_10g_rx_crc32_err_rst_val     ? pld_10g_rx_crc32_err_rst1 : pld_10g_rx_crc32_err_rst0;

// PMA IF
// PLD IF

// SLOW SR:
assign pld_8g_a1a2_k1k2_flag_int             = rx_async_hssi_fabric_ssr_data[3:0];
assign pld_8g_empty_rmf_int                  = rx_async_hssi_fabric_ssr_data[4];
assign pld_8g_full_rmf_int                   = rx_async_hssi_fabric_ssr_data[5];
assign pld_8g_wa_boundary_int                = rx_async_hssi_fabric_ssr_data[10:6];

assign pld_10g_krfec_rx_blk_lock_int         = rx_async_hssi_fabric_ssr_data[11];
assign pld_10g_krfec_rx_diag_data_status_int = rx_async_hssi_fabric_ssr_data[13:12];
assign pld_10g_krfec_rx_frame_int            = rx_async_hssi_fabric_ssr_data[14];
assign pld_10g_rx_frame_lock_int             = rx_async_hssi_fabric_ssr_data[15];
assign pld_10g_rx_hi_ber_int                 = rx_async_hssi_fabric_ssr_data[16];

assign pld_pma_adapt_done_int                = rx_async_hssi_fabric_ssr_data[17];
assign pld_pma_pcie_sw_done_int              = rx_async_hssi_fabric_ssr_data[19:18];
assign pld_pma_reserved_in_int               = rx_async_hssi_fabric_ssr_data[24:20];
assign pld_pma_rx_detect_valid_int           = rx_async_hssi_fabric_ssr_data[25];
assign pld_pma_signal_ok_int                 = rx_async_hssi_fabric_ssr_data[26];
assign pld_pma_testbus_int                   = rx_async_hssi_fabric_ssr_data[34:27];

assign pld_rx_prbs_done_int                  = rx_async_hssi_fabric_ssr_data[35];
assign pld_rx_prbs_err_int                   = rx_async_hssi_fabric_ssr_data[36];
assign pld_test_data_int                     = rx_async_hssi_fabric_ssr_data[56:37];
assign pld_pma_rx_found_int                  = rx_async_hssi_fabric_ssr_data[57];
assign pld_rx_hssi_fifo_empty_int            = rx_async_hssi_fabric_ssr_data[58];
assign pld_rx_hssi_fifo_full_int             = rx_async_hssi_fabric_ssr_data[59];

assign sr_hssi_rx_dcd_cal_done_int           = rx_async_hssi_fabric_ssr_data[60];
assign sr_hssi_rx_transfer_en_int            = rx_async_hssi_fabric_ssr_data[61];
assign pld_aib_hssi_rx_dcd_cal_done_int      = rx_async_hssi_fabric_ssr_data[62];

assign rx_ssr_parity_checker_in = {pld_aib_hssi_rx_dcd_cal_done, sr_hssi_rx_transfer_en, sr_hssi_rx_dcd_cal_done, pld_rx_hssi_fifo_full, pld_rx_hssi_fifo_empty, pld_pma_rx_found, pld_test_data, pld_rx_prbs_err, pld_rx_prbs_done, pld_pma_testbus, pld_pma_signal_ok, pld_pma_rx_detect_valid, pld_pma_reserved_in, pld_pma_pcie_sw_done, pld_pma_adapt_done, pld_10g_rx_hi_ber, pld_10g_rx_frame_lock, pld_10g_krfec_rx_frame, pld_10g_krfec_rx_diag_data_status, pld_10g_krfec_rx_blk_lock, pld_8g_wa_boundary, pld_8g_full_rmf, pld_8g_empty_rmf, pld_8g_a1a2_k1k2_flag};

// 8G ASYNC
hdpldadapt_async_update
    #( .AWIDTH       (4),
       .RESET_VAL    (0)
     ) async_pld_8g_a1a2_k1k2_flag
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_hssi_fabric_ssr_load),
       .async_data_in   (pld_8g_a1a2_k1k2_flag_int),
       .async_data_out  (pld_8g_a1a2_k1k2_flag)
     );

hdpldadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_pld_8g_empty_rmf
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_hssi_fabric_ssr_load),
       .async_data_in   (pld_8g_empty_rmf_int),
       .async_data_out  (pld_8g_empty_rmf)
     );

hdpldadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_pld_8g_full_rmf
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_hssi_fabric_ssr_load),
       .async_data_in   (pld_8g_full_rmf_int),
       .async_data_out  (pld_8g_full_rmf)
     );

hdpldadapt_async_update
    #( .AWIDTH       (5),
       .RESET_VAL    (0)
     ) async_pld_8g_wa_boundary
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_hssi_fabric_ssr_load),
       .async_data_in   (pld_8g_wa_boundary_int),
       .async_data_out  (pld_8g_wa_boundary)
     );

// 10G ASYNC
hdpldadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_pld_10g_krfec_rx_blk_lock
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_hssi_fabric_ssr_load),
       .async_data_in   (pld_10g_krfec_rx_blk_lock_int),
       .async_data_out  (pld_10g_krfec_rx_blk_lock)
     );

hdpldadapt_async_update
    #( .AWIDTH       (2),
       .RESET_VAL    (0)
     ) async_pld_10g_krfec_rx_diag_data_status
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_hssi_fabric_ssr_load),
       .async_data_in   (pld_10g_krfec_rx_diag_data_status_int),
       .async_data_out  (pld_10g_krfec_rx_diag_data_status)
     );

hdpldadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_pld_10g_krfec_rx_frame
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_hssi_fabric_ssr_load),
       .async_data_in   (pld_10g_krfec_rx_frame_int),
       .async_data_out  (pld_10g_krfec_rx_frame)
     );

hdpldadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_pld_10g_rx_frame_lock
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_hssi_fabric_ssr_load),
       .async_data_in   (pld_10g_rx_frame_lock_int),
       .async_data_out  (pld_10g_rx_frame_lock)
     );

hdpldadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_pld_10g_rx_hi_ber
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_hssi_fabric_ssr_load),
       .async_data_in   (pld_10g_rx_hi_ber_int),
       .async_data_out  (pld_10g_rx_hi_ber)
     );

// PMA IF ASYNC
hdpldadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_pld_pma_adapt_done
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_hssi_fabric_ssr_load),
       .async_data_in   (pld_pma_adapt_done_int),
       .async_data_out  (pld_pma_adapt_done)
     );

hdpldadapt_async_update
    #( .AWIDTH       (2),
       .RESET_VAL    (0)
     ) async_pld_pma_pcie_sw_done
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_hssi_fabric_ssr_load),
       .async_data_in   (pld_pma_pcie_sw_done_int),
       .async_data_out  (pld_pma_pcie_sw_done)
     );
assign rx_ssr_pcie_sw_done = pld_pma_pcie_sw_done;

hdpldadapt_async_update
    #( .AWIDTH       (5),
       .RESET_VAL    (0)
     ) async_pld_pma_reserved_in
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_hssi_fabric_ssr_load),
       .async_data_in   (pld_pma_reserved_in_int),
       .async_data_out  (pld_pma_reserved_in)
     );

hdpldadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_pld_pma_rx_detect_valid
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_hssi_fabric_ssr_load),
       .async_data_in   (pld_pma_rx_detect_valid_int),
       .async_data_out  (pld_pma_rx_detect_valid)
     );

hdpldadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_pld_pma_signal_ok
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_hssi_fabric_ssr_load),
       .async_data_in   (pld_pma_signal_ok_int),
       .async_data_out  (pld_pma_signal_ok)
     );

hdpldadapt_async_update
    #( .AWIDTH       (8),
       .RESET_VAL    (0)
     ) async_pld_pma_testbus
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_hssi_fabric_ssr_load),
       .async_data_in   (pld_pma_testbus_int),
       .async_data_out  (pld_pma_testbus)
     );

// PLD IF ASYNC
hdpldadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_pld_rx_prbs_done
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_hssi_fabric_ssr_load),
       .async_data_in   (pld_rx_prbs_done_int),
       .async_data_out  (pld_rx_prbs_done)
     );

hdpldadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_pld_rx_prbs_err
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_hssi_fabric_ssr_load),
       .async_data_in   (pld_rx_prbs_err_int),
       .async_data_out  (pld_rx_prbs_err)
     );

hdpldadapt_async_update
    #( .AWIDTH       (20),
       .RESET_VAL    (0)
     ) async_pld_test_data
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_hssi_fabric_ssr_load),
       .async_data_in   (pld_test_data_int),
       .async_data_out  (pld_test_data)
     );

hdpldadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_pld_pma_rx_found
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_hssi_fabric_ssr_load),
       .async_data_in   (pld_pma_rx_found_int),
       .async_data_out  (pld_pma_rx_found)
     );



hdpldadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (1)
     ) async_pld_rx_hssi_fifo_empty
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_hssi_fabric_ssr_load),
       .async_data_in   (pld_rx_hssi_fifo_empty_int),
       .async_data_out  (pld_rx_hssi_fifo_empty)
     );

hdpldadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_pld_rx_hssi_fifo_full
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_hssi_fabric_ssr_load),
       .async_data_in   (pld_rx_hssi_fifo_full_int),
       .async_data_out  (pld_rx_hssi_fifo_full)
     );

// DLL Lock
hdpldadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_sr_hssi_rx_dcd_cal_done
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_hssi_fabric_ssr_load),
       .async_data_in   (sr_hssi_rx_dcd_cal_done_int),
       .async_data_out  (sr_hssi_rx_dcd_cal_done)
     );

hdpldadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_sr_hssi_rx_transfer_en
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_hssi_fabric_ssr_load),
       .async_data_in   (sr_hssi_rx_transfer_en_int),
       .async_data_out  (sr_hssi_rx_transfer_en)
     );

hdpldadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_pld_aib_hssi_rx_dcd_cal_done
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_hssi_fabric_ssr_load),
       .async_data_in   (pld_aib_hssi_rx_dcd_cal_done_int),
       .async_data_out  (pld_aib_hssi_rx_dcd_cal_done)
     );


endmodule
