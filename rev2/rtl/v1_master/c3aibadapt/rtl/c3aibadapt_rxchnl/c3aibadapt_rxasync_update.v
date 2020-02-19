// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3aibadapt_rxasync_update (
// DPRIO
input   wire            r_rx_async_pld_ltr_rst_val,
input   wire            r_rx_async_pld_pma_ltd_b_rst_val,
input   wire            r_rx_async_pld_rx_fifo_align_clr_rst_val,

// RXCLK_CTL
input   wire            rx_clock_async_rx_osc_clk,

// RXRST_CTL
input   wire            rx_reset_async_rx_osc_clk_rst_n,

// SR
input   wire   [2:0]    rx_async_fabric_hssi_fsr_data,
input   wire            rx_async_fabric_hssi_fsr_load,
input   wire   [35:0]   rx_async_fabric_hssi_ssr_data,
input   wire            rx_async_fabric_hssi_ssr_load, 

// PCS_IF
output  wire            pld_10g_krfec_rx_clr_errblk_cnt,
output  wire            pld_10g_rx_clr_ber_count,
output  wire            pld_8g_a1a2_size,
output  wire            pld_8g_bitloc_rev_en,
output  wire            pld_8g_byte_rev_en,
output  wire    [2:0]   pld_8g_eidleinfersel,
output  wire            pld_8g_encdt,
output  wire            pld_bitslip,
output  wire            pld_ltr,
output  wire            pld_pma_adapt_start,
output  wire            pld_pma_early_eios,
output  wire    [5:0]   pld_pma_eye_monitor,
output  wire            pld_pma_ltd_b,
output  wire    [1:0]   pld_pma_pcie_switch,
output  wire            pld_pma_ppm_lock,
output  wire    [4:0]   pld_pma_reserved_out,
output  wire            pld_pma_rs_lpbk_b,
output  wire            pld_pmaif_rxclkslip,
output  wire            pld_polinv_rx,
output  wire            pld_rx_prbs_err_clr,
output  wire            pld_syncsm_en,
output  wire            pld_rx_fifo_latency_adj_en,

// SR
output  wire   [2:0]    rx_fsr_parity_checker_in,
output  wire   [35:0]   rx_ssr_parity_checker_in,

// RX FIFO
output  wire            wr_align_clr,

// Reset SM
output  wire            sr_fabric_rx_dll_lock,
output  wire            sr_pld_rx_dll_lock_req,
output  wire            sr_fabric_rx_transfer_en,
output  wire            sr_aib_hssi_rx_dcd_cal_req 
);

wire            pld_10g_krfec_rx_clr_errblk_cnt_int;
wire            pld_10g_rx_clr_ber_count_int;
wire            pld_8g_a1a2_size_int;
wire            pld_8g_bitloc_rev_en_int;
wire            pld_8g_byte_rev_en_int;
wire    [2:0]   pld_8g_eidleinfersel_int;
wire            pld_8g_encdt_int;
wire            pld_bitslip_int;
wire            pld_ltr_int;
wire            pld_pma_adapt_start_int;
wire            pld_pma_early_eios_int;
wire    [5:0]   pld_pma_eye_monitor_int;
wire            pld_pma_ltd_b_int;
wire    [1:0]   pld_pma_pcie_switch_int;
wire            pld_pma_ppm_lock_int;
wire    [4:0]   pld_pma_reserved_out_int;
wire            pld_pma_rs_lpbk_b_int;
wire            pld_pmaif_rxclkslip_int;
wire            pld_polinv_rx_int;
wire            pld_rx_prbs_err_clr_int;
wire            pld_syncsm_en_int;
wire            pld_rx_fifo_latency_adj_en_int;
wire            aib_fabric_rx_dll_lock_int;
wire            aib_fabric_osc_dll_lock_int;
wire            aib_fabric_rx_dll_lock_req_int;
wire            pld_ltr_rst0;
wire            pld_ltr_rst1;
wire            pld_pma_ltd_b_rst0;
wire            pld_pma_ltd_b_rst1;
wire            pld_rx_fifo_align_clr_rst0;
wire            pld_rx_fifo_align_clr_rst1;
wire            pld_rx_fifo_align_clr_int;
wire            sr_fabric_rx_dll_lock_int;
wire            sr_pld_rx_dll_lock_req_int;
wire            sr_fabric_rx_transfer_en_int;
wire            sr_aib_hssi_rx_dcd_cal_req_int;

// FAST SR: 
assign pld_ltr_int       = rx_async_fabric_hssi_fsr_data[0]; 
assign pld_pma_ltd_b_int = rx_async_fabric_hssi_fsr_data[1];
assign pld_rx_fifo_align_clr_int = rx_async_fabric_hssi_fsr_data[2];

assign rx_fsr_parity_checker_in = {wr_align_clr, pld_pma_ltd_b, pld_ltr};

// 8G ASYNC
// 10G ASYNC
// PMA IF ASYNC
c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (1)
     ) async_pld_ltr_rst1
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_fabric_hssi_fsr_load),
       .async_data_in   (pld_ltr_int),
       .async_data_out  (pld_ltr_rst1)
     );

c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_pld_ltr_rst0
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_fabric_hssi_fsr_load),
       .async_data_in   (pld_ltr_int),
       .async_data_out  (pld_ltr_rst0)
     );

assign pld_ltr = r_rx_async_pld_ltr_rst_val ? pld_ltr_rst1 : pld_ltr_rst0;

c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (1)
     ) async_pld_pma_ltd_b_rst1
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_fabric_hssi_fsr_load),
       .async_data_in   (pld_pma_ltd_b_int),
       .async_data_out  (pld_pma_ltd_b_rst1)
     );

c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_pld_pma_ltd_b_rst0
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_fabric_hssi_fsr_load),
       .async_data_in   (pld_pma_ltd_b_int),
       .async_data_out  (pld_pma_ltd_b_rst0)
     );

assign pld_pma_ltd_b = r_rx_async_pld_pma_ltd_b_rst_val ? pld_pma_ltd_b_rst1 : pld_pma_ltd_b_rst0;

c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (1)
     ) async_pld_rx_fifo_align_clr_rst1
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_fabric_hssi_fsr_load),
       .async_data_in   (pld_rx_fifo_align_clr_int),
       .async_data_out  (pld_rx_fifo_align_clr_rst1)
     );

c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_pld_rx_fifo_align_clr_rst0
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_fabric_hssi_fsr_load),
       .async_data_in   (pld_rx_fifo_align_clr_int),
       .async_data_out  (pld_rx_fifo_align_clr_rst0)
     );

assign wr_align_clr = r_rx_async_pld_rx_fifo_align_clr_rst_val ? pld_rx_fifo_align_clr_rst1 : pld_rx_fifo_align_clr_rst0;

// SLOW SR: 
assign pld_8g_a1a2_size_int                = rx_async_fabric_hssi_ssr_data[0];
assign pld_8g_bitloc_rev_en_int            = rx_async_fabric_hssi_ssr_data[1];
assign pld_8g_byte_rev_en_int              = rx_async_fabric_hssi_ssr_data[2];
assign pld_8g_eidleinfersel_int            = rx_async_fabric_hssi_ssr_data[5:3];
assign pld_8g_encdt_int                    = rx_async_fabric_hssi_ssr_data[6];

assign pld_10g_krfec_rx_clr_errblk_cnt_int = rx_async_fabric_hssi_ssr_data[7];
assign pld_10g_rx_clr_ber_count_int        = rx_async_fabric_hssi_ssr_data[8];

assign pld_pma_adapt_start_int             = rx_async_fabric_hssi_ssr_data[9];
assign pld_pma_early_eios_int              = rx_async_fabric_hssi_ssr_data[10];
assign pld_pma_eye_monitor_int             = rx_async_fabric_hssi_ssr_data[16:11];
assign pld_pma_pcie_switch_int             = rx_async_fabric_hssi_ssr_data[18:17];
assign pld_pma_ppm_lock_int                = rx_async_fabric_hssi_ssr_data[19];
assign pld_pma_reserved_out_int            = rx_async_fabric_hssi_ssr_data[24:20];
assign pld_pma_rs_lpbk_b_int               = rx_async_fabric_hssi_ssr_data[25];
assign pld_pmaif_rxclkslip_int             = rx_async_fabric_hssi_ssr_data[26];

assign pld_bitslip_int                     = rx_async_fabric_hssi_ssr_data[27];
assign pld_polinv_rx_int                   = rx_async_fabric_hssi_ssr_data[28];
assign pld_rx_prbs_err_clr_int             = rx_async_fabric_hssi_ssr_data[29];
assign pld_syncsm_en_int                   = rx_async_fabric_hssi_ssr_data[30];
assign pld_rx_fifo_latency_adj_en_int      = rx_async_fabric_hssi_ssr_data[31];

assign sr_fabric_rx_dll_lock_int           = rx_async_fabric_hssi_ssr_data[32];
assign sr_pld_rx_dll_lock_req_int          = rx_async_fabric_hssi_ssr_data[33];
assign sr_fabric_rx_transfer_en_int        = rx_async_fabric_hssi_ssr_data[34];
assign sr_aib_hssi_rx_dcd_cal_req_int      = rx_async_fabric_hssi_ssr_data[35];

assign rx_ssr_parity_checker_in = {sr_aib_hssi_rx_dcd_cal_req, sr_fabric_rx_transfer_en, sr_pld_rx_dll_lock_req,          sr_fabric_rx_dll_lock, 
                                   pld_rx_fifo_latency_adj_en, pld_syncsm_en,            pld_rx_prbs_err_clr,             pld_polinv_rx, 
                                   pld_bitslip,                pld_pmaif_rxclkslip,      pld_pma_rs_lpbk_b,               pld_pma_reserved_out, 
                                   pld_pma_ppm_lock,           pld_pma_pcie_switch,      pld_pma_eye_monitor,             pld_pma_early_eios, 
                                   pld_pma_adapt_start,        pld_10g_rx_clr_ber_count, pld_10g_krfec_rx_clr_errblk_cnt, pld_8g_encdt, 
                                   pld_8g_eidleinfersel,       pld_8g_byte_rev_en,       pld_8g_bitloc_rev_en,            pld_8g_a1a2_size};

// 8G ASYNC
c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (1)
     ) async_pld_8g_a1a2_size
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_fabric_hssi_ssr_load),
       .async_data_in   (pld_8g_a1a2_size_int),
       .async_data_out  (pld_8g_a1a2_size)
     );

c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (1)
     ) async_pld_8g_bitloc_rev_en
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_fabric_hssi_ssr_load),
       .async_data_in   (pld_8g_bitloc_rev_en_int),
       .async_data_out  (pld_8g_bitloc_rev_en)
     );

c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (1)
     ) async_pld_8g_byte_rev_en
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_fabric_hssi_ssr_load),
       .async_data_in   (pld_8g_byte_rev_en_int),
       .async_data_out  (pld_8g_byte_rev_en)
     );

c3aibadapt_async_update
    #( .AWIDTH       (3),
       .RESET_VAL    (1)
     ) async_pld_8g_eidleinfersel
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_fabric_hssi_ssr_load),
       .async_data_in   (pld_8g_eidleinfersel_int),
       .async_data_out  (pld_8g_eidleinfersel)
     );

c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (1)
     ) async_pld_8g_encdt
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_fabric_hssi_ssr_load),
       .async_data_in   (pld_8g_encdt_int),
       .async_data_out  (pld_8g_encdt)
     );

// 10G ASYNC
c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (1)
     ) async_pld_10g_krfec_rx_clr_errblk_cnt
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_fabric_hssi_ssr_load),
       .async_data_in   (pld_10g_krfec_rx_clr_errblk_cnt_int),
       .async_data_out  (pld_10g_krfec_rx_clr_errblk_cnt)
     );

c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (1)
     ) async_pld_10g_rx_clr_ber_count
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_fabric_hssi_ssr_load),
       .async_data_in   (pld_10g_rx_clr_ber_count_int),
       .async_data_out  (pld_10g_rx_clr_ber_count)
     );

// PMA IF ASYNC
c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (1)
     ) async_pld_pma_adapt_start
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_fabric_hssi_ssr_load),
       .async_data_in   (pld_pma_adapt_start_int),
       .async_data_out  (pld_pma_adapt_start)
     );

c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (1)
     ) async_pld_pma_early_eios
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_fabric_hssi_ssr_load),
       .async_data_in   (pld_pma_early_eios_int),
       .async_data_out  (pld_pma_early_eios)
     );

c3aibadapt_async_update
    #( .AWIDTH       (6),
       .RESET_VAL    (1)
     ) async_pld_pma_eye_monitor
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_fabric_hssi_ssr_load),
       .async_data_in   (pld_pma_eye_monitor_int),
       .async_data_out  (pld_pma_eye_monitor)
     );

c3aibadapt_async_update
    #( .AWIDTH       (2),
       .RESET_VAL    (1)
     ) async_pld_pma_pcie_switch
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_fabric_hssi_ssr_load),
       .async_data_in   (pld_pma_pcie_switch_int),
       .async_data_out  (pld_pma_pcie_switch)
     );

c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (1)
     ) async_pld_pma_ppm_lock
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_fabric_hssi_ssr_load),
       .async_data_in   (pld_pma_ppm_lock_int),
       .async_data_out  (pld_pma_ppm_lock)
     );

c3aibadapt_async_update
    #( .AWIDTH       (5),
       .RESET_VAL    (1)
     ) async_pld_pma_reserved_out
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_fabric_hssi_ssr_load),
       .async_data_in   (pld_pma_reserved_out_int),
       .async_data_out  (pld_pma_reserved_out)
     );

c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (1)
     ) async_pld_pma_rs_lpbk_b
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_fabric_hssi_ssr_load),
       .async_data_in   (pld_pma_rs_lpbk_b_int),
       .async_data_out  (pld_pma_rs_lpbk_b)
     );

c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (1)
     ) async_pld_pmaif_rxclkslip
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_fabric_hssi_ssr_load),
       .async_data_in   (pld_pmaif_rxclkslip_int),
       .async_data_out  (pld_pmaif_rxclkslip)
     );

// PLD IF ASYNC
c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (1)
     ) async_pld_bitslip
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_fabric_hssi_ssr_load),
       .async_data_in   (pld_bitslip_int),
       .async_data_out  (pld_bitslip)
     );

c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (1)
     ) async_pld_polinv_rx
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_fabric_hssi_ssr_load),
       .async_data_in   (pld_polinv_rx_int),
       .async_data_out  (pld_polinv_rx)
     );

c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (1)
     ) async_pld_rx_prbs_err_clr
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_fabric_hssi_ssr_load),
       .async_data_in   (pld_rx_prbs_err_clr_int),
       .async_data_out  (pld_rx_prbs_err_clr)
     );

c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (1)
     ) async_pld_syncsm_en
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_fabric_hssi_ssr_load),
       .async_data_in   (pld_syncsm_en_int),
       .async_data_out  (pld_syncsm_en)
     );

c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (1)
     ) async_pld_rx_fifo_latency_adj_en
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_fabric_hssi_ssr_load),
       .async_data_in   (pld_rx_fifo_latency_adj_en_int),
       .async_data_out  (pld_rx_fifo_latency_adj_en)
     );


// Reset SM 
c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_sr_fabric_rx_dll_lock
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_fabric_hssi_ssr_load),
       .async_data_in   (sr_fabric_rx_dll_lock_int),
       .async_data_out  (sr_fabric_rx_dll_lock)
     );

c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_sr_pld_rx_dll_lock_req
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_fabric_hssi_ssr_load),
       .async_data_in   (sr_pld_rx_dll_lock_req_int),
       .async_data_out  (sr_pld_rx_dll_lock_req)
     );

c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_sr_fabric_rx_transfer_en
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_fabric_hssi_ssr_load),
       .async_data_in   (sr_fabric_rx_transfer_en_int),
       .async_data_out  (sr_fabric_rx_transfer_en)
     );

c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_sr_aib_hssi_rx_dcd_cal_req
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_fabric_hssi_ssr_load),
       .async_data_in   (sr_aib_hssi_rx_dcd_cal_req_int),
       .async_data_out  (sr_aib_hssi_rx_dcd_cal_req)
     );

endmodule
