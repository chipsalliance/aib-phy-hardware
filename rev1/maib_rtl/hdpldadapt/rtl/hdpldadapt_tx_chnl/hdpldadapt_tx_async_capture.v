// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module hdpldadapt_tx_async_capture (
// DPRIO
input   wire            r_tx_async_pld_txelecidle_rst_val,
input  wire             r_tx_pld_8g_tx_boundary_sel_polling_bypass,
input  wire             r_tx_pld_10g_tx_bitslip_polling_bypass,
input  wire             r_tx_pld_pma_fpll_cnt_sel_polling_bypass,
input  wire             r_tx_pld_pma_fpll_num_phase_shifts_polling_bypass,

// SR
input   wire            tx_async_fabric_hssi_fsr_load,
input   wire            tx_async_fabric_hssi_ssr_load,

// TXCLK_CTL
input   wire            tx_clock_async_tx_osc_clk,     

// TXRST_CTL
input   wire            tx_reset_async_tx_osc_clk_rst_n,

// PLD_IF
input  wire    [4:0]    pld_8g_tx_boundary_sel,
input  wire    [6:0]    pld_10g_tx_bitslip,
input  wire             pld_pma_csr_test_dis,
input  wire    [3:0]    pld_pma_fpll_cnt_sel,
input  wire             pld_pma_fpll_extswitch,
input  wire    [2:0]    pld_pma_fpll_num_phase_shifts,
input  wire             pld_pma_fpll_pfden,
input  wire             pld_pma_fpll_up_dn_lc_lf_rstn,
input  wire             pld_pma_fpll_lc_csr_test_dis,
input  wire             pld_pma_nrpi_freeze,
input  wire             pld_pma_tx_bitslip,
input  wire             pld_polinv_tx,
input  wire             pld_tx_fifo_latency_adj_en,
input  wire             pld_txelecidle,
input   wire            pld_tx_dll_lock_req,
input   wire            pld_aib_hssi_tx_dcd_cal_req,
input   wire            pld_aib_hssi_tx_dll_lock_req,
input   wire            pld_pma_tx_qpi_pulldn,
input   wire            pld_pma_tx_qpi_pullup,
input   wire            pld_pma_rx_qpi_pullup,

// Reset SM
input   wire            tx_hrdrst_fabric_tx_dcd_cal_done,
input   wire            tx_hrdrst_fabric_tx_transfer_en,

// SR
output   wire           tx_async_fabric_hssi_fsr_data,
output   wire  [35:0]   tx_async_fabric_hssi_ssr_data 
);

wire    [4:0]    pld_8g_tx_boundary_sel_int;
wire    [6:0]    pld_10g_tx_bitslip_int;
wire             pld_pma_csr_test_dis_int;
wire    [3:0]    pld_pma_fpll_cnt_sel_int;
wire             pld_pma_fpll_extswitch_int;
wire    [2:0]    pld_pma_fpll_num_phase_shifts_int;
wire             pld_pma_fpll_pfden_int;
wire             pld_pma_fpll_up_dn_lc_lf_rstn_int;
wire             pld_pma_fpll_lc_csr_test_dis_int;
wire             pld_pma_nrpi_freeze_int;
wire             pld_pma_tx_bitslip_int;
wire             pld_polinv_tx_int;
wire             pld_tx_fifo_latency_adj_en_int;
wire             tx_hrdrst_fabric_tx_dcd_cal_done_int;
wire             tx_hrdrst_fabric_tx_transfer_en_int;
wire             pld_tx_dll_lock_req_int;
wire             pld_aib_hssi_tx_dcd_cal_req_int;
wire             pld_aib_hssi_tx_dll_lock_req_int;
wire             pld_txelecidle_rst1_int;
wire             pld_txelecidle_rst0_int;
wire             pld_pma_tx_qpi_pulldn_int;
wire             pld_pma_tx_qpi_pullup_int;
wire             pld_pma_rx_qpi_pullup_int;

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

// FAST SR:
assign tx_async_fabric_hssi_fsr_data = r_tx_async_pld_txelecidle_rst_val ? pld_txelecidle_rst1_int : pld_txelecidle_rst0_int; 

hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (1),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (3),
       .SYNC_STAGE  (4)
       )
      async_pld_txelecidle_rst1
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_txelecidle),
          .unload   (tx_async_fabric_hssi_fsr_load),
          .data_in_sync_out (nc_17),
          .data_out (pld_txelecidle_rst1_int)
      );

hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (0),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (3),
       .SYNC_STAGE  (4)
       )
      async_pld_txelecidle_rst0
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_txelecidle),
          .unload   (tx_async_fabric_hssi_fsr_load),
          .data_in_sync_out (nc_18),
          .data_out (pld_txelecidle_rst0_int)
      );

// 10G 
// PMA IF

// SLOW SR: 
assign tx_async_fabric_hssi_ssr_data[4:0]   =  pld_8g_tx_boundary_sel_int;
assign tx_async_fabric_hssi_ssr_data[11:5]  =  pld_10g_tx_bitslip_int;
assign tx_async_fabric_hssi_ssr_data[12]    =  pld_pma_csr_test_dis_int;
assign tx_async_fabric_hssi_ssr_data[16:13] =  pld_pma_fpll_cnt_sel_int;
assign tx_async_fabric_hssi_ssr_data[17]    =  pld_pma_fpll_extswitch_int;
assign tx_async_fabric_hssi_ssr_data[20:18] =  pld_pma_fpll_num_phase_shifts_int;
assign tx_async_fabric_hssi_ssr_data[21]    =  pld_pma_fpll_pfden_int;
assign tx_async_fabric_hssi_ssr_data[22]    =  pld_pma_fpll_up_dn_lc_lf_rstn_int;
assign tx_async_fabric_hssi_ssr_data[23]    =  pld_pma_fpll_lc_csr_test_dis_int;
assign tx_async_fabric_hssi_ssr_data[24]    =  pld_pma_nrpi_freeze_int;
assign tx_async_fabric_hssi_ssr_data[25]    =  pld_pma_tx_bitslip_int;
assign tx_async_fabric_hssi_ssr_data[26]    =  pld_polinv_tx_int;
assign tx_async_fabric_hssi_ssr_data[27]    =  pld_tx_fifo_latency_adj_en_int;
assign tx_async_fabric_hssi_ssr_data[28]    =  pld_pma_tx_qpi_pulldn_int;
assign tx_async_fabric_hssi_ssr_data[29]    =  pld_pma_tx_qpi_pullup_int;
assign tx_async_fabric_hssi_ssr_data[30]    =  pld_pma_rx_qpi_pullup_int;

assign tx_async_fabric_hssi_ssr_data[31]    =  tx_hrdrst_fabric_tx_dcd_cal_done_int;
assign tx_async_fabric_hssi_ssr_data[32]    =  pld_tx_dll_lock_req_int;
assign tx_async_fabric_hssi_ssr_data[33]    =  tx_hrdrst_fabric_tx_transfer_en_int;
assign tx_async_fabric_hssi_ssr_data[34]    =  pld_aib_hssi_tx_dcd_cal_req_int;
assign tx_async_fabric_hssi_ssr_data[35]    =  pld_aib_hssi_tx_dll_lock_req_int;


// 8G ASYNC
hdpldadapt_cmn_async_capture_bus
     #(
       .DWIDTH      (5),
       .RESET_VAL   (1),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (4),
       .SYNC_STAGE  (2)
       )
      async_pld_8g_tx_boundary_sel
      (
          .clk         (tx_clock_async_tx_osc_clk),
          .rst_n       (tx_reset_async_tx_osc_clk_rst_n),
          .data_in     (pld_8g_tx_boundary_sel),
          .unload      (tx_async_fabric_hssi_ssr_load),
          .r_capt_mode (r_tx_pld_8g_tx_boundary_sel_polling_bypass),
          .data_out    (pld_8g_tx_boundary_sel_int)
      );


// 10G ASYNC
hdpldadapt_cmn_async_capture_bus
     #(
       .DWIDTH      (7),
       .RESET_VAL   (1),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (5),
       .SYNC_STAGE  (2)
       )
      async_pld_10g_tx_bitslip
      (
          .clk         (tx_clock_async_tx_osc_clk),
          .rst_n       (tx_reset_async_tx_osc_clk_rst_n),
          .data_in     (pld_10g_tx_bitslip),
          .unload      (tx_async_fabric_hssi_ssr_load),
          .r_capt_mode (r_tx_pld_10g_tx_bitslip_polling_bypass),
          .data_out    (pld_10g_tx_bitslip_int)
      );


// PMA IF ASYNC
hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (1),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (3),
       .SYNC_STAGE  (4)
       )
      async_pld_pma_csr_test_dis
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_pma_csr_test_dis),
          .unload   (tx_async_fabric_hssi_ssr_load),
          .data_in_sync_out (nc_19),
          .data_out (pld_pma_csr_test_dis_int)
      );


hdpldadapt_cmn_async_capture_bus
     #(
       .DWIDTH      (4),
       .RESET_VAL   (1),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (3),
       .SYNC_STAGE  (4)
       )
      async_pld_pma_fpll_cnt_sel
      (
          .clk         (tx_clock_async_tx_osc_clk),
          .rst_n       (tx_reset_async_tx_osc_clk_rst_n),
          .data_in     (pld_pma_fpll_cnt_sel),
          .unload      (tx_async_fabric_hssi_ssr_load),
          .r_capt_mode (r_tx_pld_pma_fpll_cnt_sel_polling_bypass),
          .data_out    (pld_pma_fpll_cnt_sel_int)
      );

hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (1),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (3),
       .SYNC_STAGE  (4)
       )
      async_pld_pma_fpll_extswitch
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_pma_fpll_extswitch),
          .unload   (tx_async_fabric_hssi_ssr_load),
          .data_in_sync_out (nc_1),
          .data_out (pld_pma_fpll_extswitch_int)
      );


hdpldadapt_cmn_async_capture_bus
     #(
       .DWIDTH      (3),
       .RESET_VAL   (1),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (3),
       .SYNC_STAGE  (4)
       )
      async_pld_pma_fpll_num_phase_shifts
      (
          .clk         (tx_clock_async_tx_osc_clk),
          .rst_n       (tx_reset_async_tx_osc_clk_rst_n),
          .data_in     (pld_pma_fpll_num_phase_shifts),
          .unload      (tx_async_fabric_hssi_ssr_load),
          .r_capt_mode (r_tx_pld_pma_fpll_num_phase_shifts_polling_bypass),
          .data_out    (pld_pma_fpll_num_phase_shifts_int)
      );


hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (1),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (3),
       .SYNC_STAGE  (4)
       )
      async_pld_pma_fpll_pfden
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_pma_fpll_pfden),
          .unload   (tx_async_fabric_hssi_ssr_load),
          .data_in_sync_out (nc_2),
          .data_out (pld_pma_fpll_pfden_int)
      );

hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (1),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (3),
       .SYNC_STAGE  (4)
       )
      async_pld_pma_fpll_up_dn_lc_lf_rstn
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_pma_fpll_up_dn_lc_lf_rstn),
          .unload   (tx_async_fabric_hssi_ssr_load),
          .data_in_sync_out (nc_3),
          .data_out (pld_pma_fpll_up_dn_lc_lf_rstn_int)
      );

hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (1),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (3),
       .SYNC_STAGE  (4)
       )
      async_pld_pma_fpll_lc_csr_test_dis
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_pma_fpll_lc_csr_test_dis),
          .unload   (tx_async_fabric_hssi_ssr_load),
          .data_in_sync_out (nc_4),
          .data_out (pld_pma_fpll_lc_csr_test_dis_int)
      );


hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (1),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (3),
       .SYNC_STAGE  (4)
       )
      async_pld_pma_nrpi_freeze
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_pma_nrpi_freeze),
          .unload   (tx_async_fabric_hssi_ssr_load),
          .data_in_sync_out (nc_5),
          .data_out (pld_pma_nrpi_freeze_int)
      );

hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (1),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (3),
       .SYNC_STAGE  (4)
       )
      async_pld_pma_tx_bitslip
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_pma_tx_bitslip),
          .unload   (tx_async_fabric_hssi_ssr_load),
          .data_in_sync_out (nc_6),
          .data_out (pld_pma_tx_bitslip_int)
      );

hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (1),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (5),
       .SYNC_STAGE  (2)
       )
      async_pld_polinv_tx
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_polinv_tx),
          .unload   (tx_async_fabric_hssi_ssr_load),
          .data_in_sync_out (nc_7),
          .data_out (pld_polinv_tx_int)
      );

hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (1),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (5),
       .SYNC_STAGE  (2)
       )
      async_pld_tx_fifo_latency_adj_en
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_tx_fifo_latency_adj_en),
          .unload   (tx_async_fabric_hssi_ssr_load),
          .data_in_sync_out (nc_8),
          .data_out (pld_tx_fifo_latency_adj_en_int)
      );

hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (0),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (3),
       .SYNC_STAGE  (4)
       )
      async_pld_pma_tx_qpi_pulldn
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_pma_tx_qpi_pulldn),
          .unload   (tx_async_fabric_hssi_ssr_load),
          .data_in_sync_out (nc_9),
          .data_out (pld_pma_tx_qpi_pulldn_int)
      );

hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (0),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (3),
       .SYNC_STAGE  (4)
       )
      async_pld_pma_tx_qpi_pullup
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_pma_tx_qpi_pullup),
          .unload   (tx_async_fabric_hssi_ssr_load),
          .data_in_sync_out (nc_10),
          .data_out (pld_pma_tx_qpi_pullup_int)
      );

hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (0),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (3),
       .SYNC_STAGE  (4)
       )
      async_pld_pma_rx_qpi_pullup
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_pma_rx_qpi_pullup),
          .unload   (tx_async_fabric_hssi_ssr_load),
          .data_in_sync_out (nc_11),
          .data_out (pld_pma_rx_qpi_pullup_int)
      );


hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (0),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (2),
       .SYNC_STAGE  (4)
       )
      async_tx_hrdrst_fabric_tx_dcd_cal_done
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (tx_hrdrst_fabric_tx_dcd_cal_done),
          .unload   (tx_async_fabric_hssi_ssr_load),
          .data_in_sync_out (nc_12),
          .data_out (tx_hrdrst_fabric_tx_dcd_cal_done_int)
      );

hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (0),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (2),
       .SYNC_STAGE  (4)
       )
      async_pld_tx_dll_lock_req
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_tx_dll_lock_req),
          .unload   (tx_async_fabric_hssi_ssr_load),
          .data_in_sync_out (nc_13),
          .data_out (pld_tx_dll_lock_req_int)
      );

hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (0),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (2),
       .SYNC_STAGE  (4)
       )
      async_tx_hrdrst_fabric_tx_transfer_en
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (tx_hrdrst_fabric_tx_transfer_en),
          .unload   (tx_async_fabric_hssi_ssr_load),
          .data_in_sync_out (nc_14),
          .data_out (tx_hrdrst_fabric_tx_transfer_en_int)
      );

hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (0),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (2),
       .SYNC_STAGE  (4)
       )
      async_pld_aib_hssi_tx_dcd_cal_req
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_aib_hssi_tx_dcd_cal_req),
          .unload   (tx_async_fabric_hssi_ssr_load),
          .data_in_sync_out (nc_15),
          .data_out (pld_aib_hssi_tx_dcd_cal_req_int)
      );

hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (0),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (2),
       .SYNC_STAGE  (4)
       )
      async_pld_aib_hssi_tx_dll_lock_req
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_aib_hssi_tx_dll_lock_req),
          .unload   (tx_async_fabric_hssi_ssr_load),
          .data_in_sync_out (nc_16),
          .data_out (pld_aib_hssi_tx_dll_lock_req_int)
      );




endmodule
