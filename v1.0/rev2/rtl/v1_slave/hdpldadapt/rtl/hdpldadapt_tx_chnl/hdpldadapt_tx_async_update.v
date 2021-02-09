// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module hdpldadapt_tx_async_update (
// DPRIO
input   wire            r_tx_async_pld_pmaif_mask_tx_pll_rst_val,
// TXCLK_CTL
input   wire            tx_clock_async_rx_osc_clk,     

// TXRST_CTL
input   wire            tx_reset_async_rx_osc_clk_rst_n,

// SR
input  wire             tx_async_hssi_fabric_fsr_data,  
input  wire             tx_async_hssi_fabric_fsr_load,      
input  wire   [12:0]    tx_async_hssi_fabric_ssr_data,   
input  wire             tx_async_hssi_fabric_ssr_load,

// Reset SM
output   wire            sr_hssi_tx_dcd_cal_done,
output   wire            sr_hssi_tx_dll_lock,
output   wire            sr_hssi_tx_transfer_en,

// PLD_IF
output   wire            pld_krfec_tx_alignment,
output   wire            pld_pma_fpll_clk0bad,
output   wire            pld_pma_fpll_clk1bad,
output   wire            pld_pma_fpll_clksel,
output   wire            pld_pma_fpll_phase_done,
output   wire            pld_pmaif_mask_tx_pll,
output   wire            pld_tx_hssi_align_done,
output   wire            pld_tx_hssi_fifo_full,
output   wire            pld_tx_hssi_fifo_empty,
output   wire            pld_aib_hssi_tx_dcd_cal_done,
output   wire            pld_aib_hssi_tx_dll_lock,

// SR
output   wire [12:0]     tx_ssr_parity_checker_in,
output   wire            tx_fsr_parity_checker_in,

// ASN
output   wire            rx_fsr_mask_tx_pll
);

wire            pld_krfec_tx_alignment_int;
wire            pld_pma_fpll_clk0bad_int;
wire            pld_pma_fpll_clk1bad_int;
wire            pld_pma_fpll_clksel_int;
wire            pld_pma_fpll_phase_done_int;
wire            pld_pmaif_mask_tx_pll_int;
wire            pld_tx_hssi_align_done_int;
wire            pld_tx_hssi_fifo_full_int;
wire            pld_tx_hssi_fifo_empty_int;
wire            pld_pmaif_mask_tx_pll_rst0;
wire            pld_pmaif_mask_tx_pll_rst1;
wire            sr_hssi_tx_dcd_cal_done_int;
wire            sr_hssi_tx_dll_lock_int;
wire            sr_hssi_tx_transfer_en_int;
wire            pld_aib_hssi_tx_dcd_cal_done_int;
wire            pld_aib_hssi_tx_dll_lock_int;

// FAST SR: 
assign pld_pmaif_mask_tx_pll_int = tx_async_hssi_fabric_fsr_data;
// 8G
// 10G
// PMA IF
hdpldadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_pld_pmaif_mask_tx_pll_rst0
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_hssi_fabric_fsr_load),
       .async_data_in   (pld_pmaif_mask_tx_pll_int),
       .async_data_out  (pld_pmaif_mask_tx_pll_rst0)
     );

hdpldadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (1)
     ) async_pld_pmaif_mask_tx_pll_rst1
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_hssi_fabric_fsr_load),
       .async_data_in   (pld_pmaif_mask_tx_pll_int),
       .async_data_out  (pld_pmaif_mask_tx_pll_rst1)
     );

assign pld_pmaif_mask_tx_pll =  r_tx_async_pld_pmaif_mask_tx_pll_rst_val? pld_pmaif_mask_tx_pll_rst1 : pld_pmaif_mask_tx_pll_rst0;
assign rx_fsr_mask_tx_pll    =  pld_pmaif_mask_tx_pll;

assign tx_fsr_parity_checker_in = pld_pmaif_mask_tx_pll;

// SLOW SR: 
assign  pld_krfec_tx_alignment_int   = tx_async_hssi_fabric_ssr_data[0];
assign  pld_pma_fpll_clk0bad_int     = tx_async_hssi_fabric_ssr_data[1];
assign  pld_pma_fpll_clk1bad_int     = tx_async_hssi_fabric_ssr_data[2];
assign  pld_pma_fpll_clksel_int      = tx_async_hssi_fabric_ssr_data[3];
assign  pld_pma_fpll_phase_done_int  = tx_async_hssi_fabric_ssr_data[4];
assign  pld_tx_hssi_align_done_int   = tx_async_hssi_fabric_ssr_data[5];
//assign  pld_tx_hssi_realgin_int      = tx_async_hssi_fabric_ssr_data[6];
assign  pld_tx_hssi_fifo_empty_int  = tx_async_hssi_fabric_ssr_data[6];
assign  pld_tx_hssi_fifo_full_int   = tx_async_hssi_fabric_ssr_data[7];
assign  sr_hssi_tx_dcd_cal_done_int = tx_async_hssi_fabric_ssr_data[8];
assign  sr_hssi_tx_dll_lock_int     = tx_async_hssi_fabric_ssr_data[9];
assign  sr_hssi_tx_transfer_en_int  = tx_async_hssi_fabric_ssr_data[10];
assign  pld_aib_hssi_tx_dcd_cal_done_int = tx_async_hssi_fabric_ssr_data[11];
assign  pld_aib_hssi_tx_dll_lock_int = tx_async_hssi_fabric_ssr_data[12];

assign  tx_ssr_parity_checker_in = {pld_aib_hssi_tx_dll_lock, pld_aib_hssi_tx_dcd_cal_done, sr_hssi_tx_transfer_en, sr_hssi_tx_dll_lock, sr_hssi_tx_dcd_cal_done, pld_tx_hssi_fifo_full, pld_tx_hssi_fifo_empty, pld_tx_hssi_align_done, pld_pma_fpll_phase_done, pld_pma_fpll_clksel, pld_pma_fpll_clk1bad, pld_pma_fpll_clk0bad, pld_krfec_tx_alignment};
// 8G
// 10G
hdpldadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_pld_krfec_tx_alignment
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_hssi_fabric_ssr_load),
       .async_data_in   (pld_krfec_tx_alignment_int),
       .async_data_out  (pld_krfec_tx_alignment)
     );

// PMA IF
hdpldadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_pld_pma_fpll_clk0bad
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_hssi_fabric_ssr_load),
       .async_data_in   (pld_pma_fpll_clk0bad_int),
       .async_data_out  (pld_pma_fpll_clk0bad)
     );

hdpldadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_pld_pma_fpll_clk1bad
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_hssi_fabric_ssr_load),
       .async_data_in   (pld_pma_fpll_clk1bad_int),
       .async_data_out  (pld_pma_fpll_clk1bad)
     );

hdpldadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_pld_pma_fpll_clksel
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_hssi_fabric_ssr_load),
       .async_data_in   (pld_pma_fpll_clksel_int),
       .async_data_out  (pld_pma_fpll_clksel)
     );

hdpldadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_pld_pma_fpll_phase_done
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_hssi_fabric_ssr_load),
       .async_data_in   (pld_pma_fpll_phase_done_int),
       .async_data_out  (pld_pma_fpll_phase_done)
     );


// FIFO
hdpldadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_pld_tx_hssi_align_done
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_hssi_fabric_ssr_load),
       .async_data_in   (pld_tx_hssi_align_done_int),
       .async_data_out  (pld_tx_hssi_align_done)
     );

//hdpldadapt_async_update
//    #( .AWIDTH       (1),
//       .RESET_VAL    (0)
//     ) async_pld_tx_hssi_realgin
//     ( .clk             (tx_clock_async_rx_osc_clk),
//       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
//       .sr_load         (tx_async_hssi_fabric_ssr_load),
//       .async_data_in   (pld_tx_hssi_realgin_int),
//       .async_data_out  (pld_tx_hssi_realgin)
//     );

hdpldadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_pld_tx_hssi_fifo_full
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_hssi_fabric_ssr_load),
       .async_data_in   (pld_tx_hssi_fifo_full_int),
       .async_data_out  (pld_tx_hssi_fifo_full)
     );

hdpldadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (1)
     ) async_pld_tx_hssi_fifo_empty
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_hssi_fabric_ssr_load),
       .async_data_in   (pld_tx_hssi_fifo_empty_int),
       .async_data_out  (pld_tx_hssi_fifo_empty)
     );

hdpldadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_sr_hssi_tx_dcd_cal_done
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_hssi_fabric_ssr_load),
       .async_data_in   (sr_hssi_tx_dcd_cal_done_int),
       .async_data_out  (sr_hssi_tx_dcd_cal_done)
     );

hdpldadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_sr_hssi_tx_dll_lock
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_hssi_fabric_ssr_load),
       .async_data_in   (sr_hssi_tx_dll_lock_int),
       .async_data_out  (sr_hssi_tx_dll_lock)
     );

hdpldadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_sr_hssi_tx_transfer_en
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_hssi_fabric_ssr_load),
       .async_data_in   (sr_hssi_tx_transfer_en_int),
       .async_data_out  (sr_hssi_tx_transfer_en)
     );

hdpldadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_pld_aib_hssi_tx_dcd_cal_done
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_hssi_fabric_ssr_load),
       .async_data_in   (pld_aib_hssi_tx_dcd_cal_done_int),
       .async_data_out  (pld_aib_hssi_tx_dcd_cal_done)
     );

hdpldadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_pld_aib_hssi_tx_dll_lock
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_hssi_fabric_ssr_load),
       .async_data_in   (pld_aib_hssi_tx_dll_lock_int),
       .async_data_out  (pld_aib_hssi_tx_dll_lock)
     );

endmodule
