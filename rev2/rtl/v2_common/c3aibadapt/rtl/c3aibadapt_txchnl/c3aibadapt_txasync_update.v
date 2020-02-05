// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3aibadapt_txasync_update (
// DPRIO
input   wire            r_tx_async_pld_txelecidle_rst_val,

// SR
input   wire            tx_async_fabric_hssi_fsr_data,
input   wire            tx_async_fabric_hssi_fsr_load,    
input   wire    [35:0]  tx_async_fabric_hssi_ssr_data, 
input   wire            tx_async_fabric_hssi_ssr_load,    

// TXCLK_CTL
input   wire            tx_clock_async_rx_osc_clk,      

// TXRST_CTL
input   wire            tx_reset_async_rx_osc_clk_rst_n, 

// PCS_IF
output  wire    [4:0]   pld_8g_tx_boundary_sel,
output  wire    [6:0]   pld_10g_tx_bitslip,
output  wire            pld_pma_csr_test_dis,
output  wire    [3:0]   pld_pma_fpll_cnt_sel,
output  wire            pld_pma_fpll_extswitch,
output  wire    [2:0]   pld_pma_fpll_num_phase_shifts,
output  wire            pld_pma_fpll_pfden,
output  wire            pld_pma_fpll_up_dn_lc_lf_rstn,
output  wire            pld_pma_fpll_lc_csr_test_dis,
output  wire            pld_pma_nrpi_freeze,
output  wire            pld_pma_tx_bitslip,
output  wire            pld_polinv_tx,
output  wire            pld_tx_fifo_latency_adj_en,
output  wire            pld_txelecidle,

// TX Data Mapping Block
output wire             pld_pma_tx_qpi_pulldn_sr, 
output wire             pld_pma_tx_qpi_pullup_sr, 
output wire             pld_pma_rx_qpi_pullup_sr, 

// SR
output  wire            tx_fsr_parity_checker_in,
output  wire   [35:0]   tx_ssr_parity_checker_in,

// Reset SM
output  wire            sr_fabric_tx_dcd_cal_done,
output  wire            sr_pld_tx_dll_lock_req,
output  wire            sr_fabric_tx_transfer_en,
output  wire            sr_aib_hssi_tx_dcd_cal_req,
output  wire            sr_aib_hssi_tx_dll_lock_req
);

wire    [4:0]   pld_8g_tx_boundary_sel_int;
wire    [6:0]   pld_10g_tx_bitslip_int;
wire            pld_pma_csr_test_dis_int;
wire    [3:0]   pld_pma_fpll_cnt_sel_int;
wire            pld_pma_fpll_extswitch_int;
wire    [2:0]   pld_pma_fpll_num_phase_shifts_int;
wire            pld_pma_fpll_pfden_int;
wire            pld_pma_fpll_up_dn_lc_lf_rstn_int;
wire            pld_pma_fpll_lc_csr_test_dis_int;
wire            pld_pma_nrpi_freeze_int;
wire            pld_pma_tx_bitslip_int;
wire            pld_polinv_tx_int;
wire            pld_tx_fifo_latency_adj_en_int;
wire            sr_fabric_tx_dcd_cal_done_int;
wire            sr_pld_tx_dll_lock_req_int;
wire            sr_fabric_tx_transfer_en_int;
wire            sr_aib_hssi_tx_dcd_cal_req_int;
wire            sr_aib_hssi_tx_dll_lock_req_int;
wire            pld_txelecidle_int;
wire            pld_txelecidle_rst0;
wire            pld_txelecidle_rst1;
wire            pld_pma_tx_qpi_pulldn_int;
wire            pld_pma_tx_qpi_pullup_int;
wire            pld_pma_rx_qpi_pullup_int;


// FAST SR: to check reset value
assign pld_txelecidle_int = tx_async_fabric_hssi_fsr_data;
// 8G ASYNC 
c3aibadapt_async_update 
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_pld_txelecidle_rst0 
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_fabric_hssi_fsr_load),
       .async_data_in   (pld_txelecidle_int),
       .async_data_out  (pld_txelecidle_rst0)
     );

c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (1)
     ) async_pld_txelecidle_rst1
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_fabric_hssi_fsr_load),
       .async_data_in   (pld_txelecidle_int),
       .async_data_out  (pld_txelecidle_rst1)
     );

assign pld_txelecidle = r_tx_async_pld_txelecidle_rst_val ? pld_txelecidle_rst1 : pld_txelecidle_rst0;

assign tx_fsr_parity_checker_in = pld_txelecidle;
// 10G ASYNC
// PMA ASYNC

// SLOW SR: AR
assign pld_8g_tx_boundary_sel_int         = tx_async_fabric_hssi_ssr_data[4:0];
assign pld_10g_tx_bitslip_int             = tx_async_fabric_hssi_ssr_data[11:5];
assign pld_pma_csr_test_dis_int           = tx_async_fabric_hssi_ssr_data[12];
assign pld_pma_fpll_cnt_sel_int           = tx_async_fabric_hssi_ssr_data[16:13];
assign pld_pma_fpll_extswitch_int         = tx_async_fabric_hssi_ssr_data[17];
assign pld_pma_fpll_num_phase_shifts_int  = tx_async_fabric_hssi_ssr_data[20:18];
assign pld_pma_fpll_pfden_int             = tx_async_fabric_hssi_ssr_data[21];
assign pld_pma_fpll_up_dn_lc_lf_rstn_int  = tx_async_fabric_hssi_ssr_data[22];
assign pld_pma_fpll_lc_csr_test_dis_int   = tx_async_fabric_hssi_ssr_data[23];
assign pld_pma_nrpi_freeze_int            = tx_async_fabric_hssi_ssr_data[24];
assign pld_pma_tx_bitslip_int             = tx_async_fabric_hssi_ssr_data[25];
assign pld_polinv_tx_int                  = tx_async_fabric_hssi_ssr_data[26];
assign pld_tx_fifo_latency_adj_en_int     = tx_async_fabric_hssi_ssr_data[27];
assign pld_pma_tx_qpi_pulldn_int          = tx_async_fabric_hssi_ssr_data[28];
assign pld_pma_tx_qpi_pullup_int          = tx_async_fabric_hssi_ssr_data[29];
assign pld_pma_rx_qpi_pullup_int          = tx_async_fabric_hssi_ssr_data[30];
assign sr_fabric_tx_dcd_cal_done_int      = tx_async_fabric_hssi_ssr_data[31];
assign sr_pld_tx_dll_lock_req_int         = tx_async_fabric_hssi_ssr_data[32];
assign sr_fabric_tx_transfer_en_int       = tx_async_fabric_hssi_ssr_data[33];
assign sr_aib_hssi_tx_dcd_cal_req_int     = tx_async_fabric_hssi_ssr_data[34];
assign sr_aib_hssi_tx_dll_lock_req_int    = tx_async_fabric_hssi_ssr_data[35];

assign tx_ssr_parity_checker_in = {sr_aib_hssi_tx_dll_lock_req, sr_aib_hssi_tx_dcd_cal_req, sr_fabric_tx_transfer_en, sr_pld_tx_dll_lock_req, sr_fabric_tx_dcd_cal_done, pld_pma_rx_qpi_pullup_sr, pld_pma_tx_qpi_pullup_sr, pld_pma_tx_qpi_pulldn_sr, pld_tx_fifo_latency_adj_en, pld_polinv_tx, pld_pma_tx_bitslip, pld_pma_nrpi_freeze, pld_pma_fpll_lc_csr_test_dis ,pld_pma_fpll_up_dn_lc_lf_rstn, pld_pma_fpll_pfden, pld_pma_fpll_num_phase_shifts, pld_pma_fpll_extswitch, pld_pma_fpll_cnt_sel, pld_pma_csr_test_dis, pld_10g_tx_bitslip, pld_8g_tx_boundary_sel};

// 8G ASYNC
c3aibadapt_async_update
    #( .AWIDTH       (5),
       .RESET_VAL    (1)
     ) async_pld_8g_tx_boundary_sel 
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_fabric_hssi_ssr_load),
       .async_data_in   (pld_8g_tx_boundary_sel_int),
       .async_data_out  (pld_8g_tx_boundary_sel)
     );


// 10G ASYNC
c3aibadapt_async_update
    #( .AWIDTH       (7),
       .RESET_VAL    (1)
     ) async_pld_10g_tx_bitslip
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_fabric_hssi_ssr_load),
       .async_data_in   (pld_10g_tx_bitslip_int),
       .async_data_out  (pld_10g_tx_bitslip)
     );

// PMA ASYNC
c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (1)
     ) async_pld_pma_csr_test_dis
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_fabric_hssi_ssr_load),
       .async_data_in   (pld_pma_csr_test_dis_int),
       .async_data_out  (pld_pma_csr_test_dis)
     );

c3aibadapt_async_update
    #( .AWIDTH       (4),
       .RESET_VAL    (1)
     ) async_pld_pma_fpll_cnt_sel
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_fabric_hssi_ssr_load),
       .async_data_in   (pld_pma_fpll_cnt_sel_int),
       .async_data_out  (pld_pma_fpll_cnt_sel)
     );

c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (1)
     ) async_pld_pma_fpll_extswitch
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_fabric_hssi_ssr_load),
       .async_data_in   (pld_pma_fpll_extswitch_int),
       .async_data_out  (pld_pma_fpll_extswitch)
     );

c3aibadapt_async_update
    #( .AWIDTH       (3),
       .RESET_VAL    (1)
     ) async_pld_pma_fpll_num_phase_shifts
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_fabric_hssi_ssr_load),
       .async_data_in   (pld_pma_fpll_num_phase_shifts_int),
       .async_data_out  (pld_pma_fpll_num_phase_shifts)
     );

c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (1)
     ) async_pld_pma_fpll_pfden
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_fabric_hssi_ssr_load),
       .async_data_in   (pld_pma_fpll_pfden_int),
       .async_data_out  (pld_pma_fpll_pfden)
     );

c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (1)
     ) async_pld_pma_fpll_up_dn_lc_lf_rstn
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_fabric_hssi_ssr_load),
       .async_data_in   (pld_pma_fpll_up_dn_lc_lf_rstn_int),
       .async_data_out  (pld_pma_fpll_up_dn_lc_lf_rstn)
     );

c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (1)
     ) async_pld_pma_fpll_lc_csr_test_dis
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_fabric_hssi_ssr_load),
       .async_data_in   (pld_pma_fpll_lc_csr_test_dis_int),
       .async_data_out  (pld_pma_fpll_lc_csr_test_dis)
     );

c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (1)
     ) async_pld_pma_nrpi_freeze
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_fabric_hssi_ssr_load),
       .async_data_in   (pld_pma_nrpi_freeze_int),
       .async_data_out  (pld_pma_nrpi_freeze)
     );

c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (1)
     ) async_pld_pma_tx_bitslip
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_fabric_hssi_ssr_load),
       .async_data_in   (pld_pma_tx_bitslip_int),
       .async_data_out  (pld_pma_tx_bitslip)
     );

c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (1)
     ) async_pld_polinv_tx
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_fabric_hssi_ssr_load),
       .async_data_in   (pld_polinv_tx_int),
       .async_data_out  (pld_polinv_tx)
     );

c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (1)
     ) async_pld_tx_fifo_latency_adj_en
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_fabric_hssi_ssr_load),
       .async_data_in   (pld_tx_fifo_latency_adj_en_int),
       .async_data_out  (pld_tx_fifo_latency_adj_en)
     );

c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_pld_pma_tx_qpi_pulldn
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_fabric_hssi_ssr_load),
       .async_data_in   (pld_pma_tx_qpi_pulldn_int),
       .async_data_out  (pld_pma_tx_qpi_pulldn_sr)
     );

c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_pld_pma_tx_qpi_pullup
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_fabric_hssi_ssr_load),
       .async_data_in   (pld_pma_tx_qpi_pullup_int),
       .async_data_out  (pld_pma_tx_qpi_pullup_sr)
     );

c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_pld_pma_rx_qpi_pullup
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_fabric_hssi_ssr_load),
       .async_data_in   (pld_pma_rx_qpi_pullup_int),
       .async_data_out  (pld_pma_rx_qpi_pullup_sr)
     );

c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_sr_fabric_tx_dcd_cal_done
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_fabric_hssi_ssr_load),
       .async_data_in   (sr_fabric_tx_dcd_cal_done_int),
       .async_data_out  (sr_fabric_tx_dcd_cal_done)
     );

c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_sr_pld_tx_dll_lock_req
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_fabric_hssi_ssr_load),
       .async_data_in   (sr_pld_tx_dll_lock_req_int),
       .async_data_out  (sr_pld_tx_dll_lock_req)
     );

c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_sr_fabric_tx_transfer_en
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_fabric_hssi_ssr_load),
       .async_data_in   (sr_fabric_tx_transfer_en_int),
       .async_data_out  (sr_fabric_tx_transfer_en)
     );

c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_sr_aib_hssi_tx_dcd_cal_req
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_fabric_hssi_ssr_load),
       .async_data_in   (sr_aib_hssi_tx_dcd_cal_req_int),
       .async_data_out  (sr_aib_hssi_tx_dcd_cal_req)
     );

c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_sr_aib_hssi_tx_dll_lock_req
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_fabric_hssi_ssr_load),
       .async_data_in   (sr_aib_hssi_tx_dll_lock_req_int),
       .async_data_out  (sr_aib_hssi_tx_dll_lock_req)
     );



endmodule 
