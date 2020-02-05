// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3aibadapt_txasync_capture (
// DPRIO
input   wire            r_tx_async_pld_pmaif_mask_tx_pll_rst_val,

// PCS_IF
input   wire            pld_krfec_tx_alignment,
input   wire            pld_pma_fpll_clk0bad,
input   wire            pld_pma_fpll_clk1bad,
input   wire            pld_pma_fpll_clksel,
input   wire            pld_pma_fpll_phase_done,
input   wire            pld_pmaif_mask_tx_pll,

// SR
input   wire            tx_async_hssi_fabric_fsr_load,
input   wire            tx_async_hssi_fabric_ssr_load,

// TXCLK_CTL
input   wire            tx_clock_async_tx_osc_clk,         

// TXRST_CTL
input   wire            tx_reset_async_tx_osc_clk_rst_n,  

// TX_DATAPATH
input   wire            align_done,
input   wire            fifo_empty,
input   wire            fifo_full,

// Reset SM
input   wire            tx_hrdrst_hssi_tx_dcd_cal_done,
input   wire            tx_hrdrst_hssi_tx_dll_lock,
input   wire            tx_hrdrst_hssi_tx_transfer_en,
input   wire            aib_hssi_tx_dcd_cal_done,
input   wire            aib_hssi_tx_dll_lock,

// SR
output  wire            tx_async_hssi_fabric_fsr_data,      
output  wire   [12:0]   tx_async_hssi_fabric_ssr_data       
);

wire            pld_krfec_tx_alignment_int;
wire            pld_pma_fpll_clk0bad_int;
wire            pld_pma_fpll_clk1bad_int;
wire            pld_pma_fpll_clksel_int;
wire            pld_pma_fpll_phase_done_int;
wire            pld_pmaif_mask_tx_pll_rst0_int;
wire            pld_pmaif_mask_tx_pll_rst1_int;
wire            align_done_int;
wire            fifo_empty_int;
wire            fifo_full_int;
wire            tx_hrdrst_hssi_tx_dcd_cal_done_int;
wire            tx_hrdrst_hssi_tx_dll_lock_int;
wire            tx_hrdrst_hssi_tx_transfer_en_int;
wire            aib_hssi_tx_dcd_cal_done_int;
wire            aib_hssi_tx_dll_lock_int;
wire		pld_krfec_tx_alignment_stretch;
reg		pld_krfec_tx_alignment_int_reg;

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
 
// FAST SR:
assign tx_async_hssi_fabric_fsr_data   = r_tx_async_pld_pmaif_mask_tx_pll_rst_val? pld_pmaif_mask_tx_pll_rst1_int : pld_pmaif_mask_tx_pll_rst0_int;

c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (3),
       .RESET_VAL   (1)
       )
      async_pld_pmaif_mask_tx_pll_rst1
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_pmaif_mask_tx_pll),
          .unload   (tx_async_hssi_fabric_fsr_load),
          .data_in_sync_out (nc_0),
          .data_out (pld_pmaif_mask_tx_pll_rst1_int)
      );

c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (3),
       .RESET_VAL   (0)
       )
      async_pld_pmaif_mask_tx_pll_rst0
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_pmaif_mask_tx_pll),
          .unload   (tx_async_hssi_fabric_fsr_load),
          .data_in_sync_out (nc_1),
          .data_out (pld_pmaif_mask_tx_pll_rst0_int)
      );

// 8G
// 10G
// PMA IF

// SLOW SR:
assign tx_async_hssi_fabric_ssr_data[0] = pld_krfec_tx_alignment_stretch;
assign tx_async_hssi_fabric_ssr_data[1] = pld_pma_fpll_clk0bad_int;
assign tx_async_hssi_fabric_ssr_data[2] = pld_pma_fpll_clk1bad_int;
assign tx_async_hssi_fabric_ssr_data[3] = pld_pma_fpll_clksel_int;
assign tx_async_hssi_fabric_ssr_data[4] = pld_pma_fpll_phase_done_int;
assign tx_async_hssi_fabric_ssr_data[5] = align_done_int;
//assign tx_async_hssi_fabric_ssr_data[6] = realgin_int;
assign tx_async_hssi_fabric_ssr_data[6] = fifo_empty_int;
assign tx_async_hssi_fabric_ssr_data[7] = fifo_full_int;
assign tx_async_hssi_fabric_ssr_data[8] = tx_hrdrst_hssi_tx_dcd_cal_done_int;
assign tx_async_hssi_fabric_ssr_data[9] = tx_hrdrst_hssi_tx_dll_lock_int;
assign tx_async_hssi_fabric_ssr_data[10] = tx_hrdrst_hssi_tx_transfer_en_int;
assign tx_async_hssi_fabric_ssr_data[11] = aib_hssi_tx_dcd_cal_done_int;
assign tx_async_hssi_fabric_ssr_data[12] = aib_hssi_tx_dll_lock_int;


c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (2),
       .RESET_VAL   (0)
       )
      async_pld_krfec_tx_alignment
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_krfec_tx_alignment),
          .unload   (tx_async_hssi_fabric_ssr_load),
          .data_in_sync_out (nc_2),
          .data_out (pld_krfec_tx_alignment_int)
      );


// pld_krfec_tx_alignment is already stretched to 2 cycles inside KRFEC block at Fmax of 500MHz
   always @(negedge tx_reset_async_tx_osc_clk_rst_n or posedge tx_clock_async_tx_osc_clk) begin
      if (~tx_reset_async_tx_osc_clk_rst_n) begin
         pld_krfec_tx_alignment_int_reg <= 1'b0;
      end
      else begin
         pld_krfec_tx_alignment_int_reg <= pld_krfec_tx_alignment_int;
      end
   end


assign pld_krfec_tx_alignment_stretch = pld_krfec_tx_alignment_int || pld_krfec_tx_alignment_int_reg;

c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (3),
       .RESET_VAL   (0)
       )
      async_pld_pma_fpll_clk0bad
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_pma_fpll_clk0bad),
          .unload   (tx_async_hssi_fabric_ssr_load),
          .data_in_sync_out (nc_3),
          .data_out (pld_pma_fpll_clk0bad_int)
      );


c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (3),
       .RESET_VAL   (0)
       )
      async_pld_pma_fpll_clk1bad
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_pma_fpll_clk1bad),
          .unload   (tx_async_hssi_fabric_ssr_load),
          .data_in_sync_out (nc_4),
          .data_out (pld_pma_fpll_clk1bad_int)
      );


c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (3),
       .RESET_VAL   (0)
       )
      async_pld_pma_fpll_clksel
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_pma_fpll_clksel),
          .unload   (tx_async_hssi_fabric_ssr_load),
          .data_in_sync_out (nc_5),
          .data_out (pld_pma_fpll_clksel_int)
      );


c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (3),
       .RESET_VAL   (0)
       )
      async_pld_pma_fpll_phase_done
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (pld_pma_fpll_phase_done),
          .unload   (tx_async_hssi_fabric_ssr_load),
          .data_in_sync_out (nc_6),
          .data_out (pld_pma_fpll_phase_done_int)
      );


c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (2),
       .RESET_VAL   (0)
       )
      async_align_done
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (align_done),
          .unload   (tx_async_hssi_fabric_ssr_load),
          .data_in_sync_out (nc_7),
          .data_out (align_done_int)
      );


//hd_hssiadapt_cmn_async_capture_bit
//     #(
//       .RESET_VAL   (0)
//       )
//      async_realgin
//      (
//          .clk      (tx_clock_async_tx_osc_clk),
//          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
//          .data_in  (realgin),
//          .unload   (tx_async_hssi_fabric_ssr_load),
//          .data_out (realgin_int)
//      );


c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (2),
       .RESET_VAL   (1)
       )
      async_fifo_empty
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (fifo_empty),
          .unload   (tx_async_hssi_fabric_ssr_load),
          .data_in_sync_out (nc_8),
          .data_out (fifo_empty_int)
      );


c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (2),
       .RESET_VAL   (0)
       )
      async_fifo_full
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (fifo_full),
          .unload   (tx_async_hssi_fabric_ssr_load),
          .data_in_sync_out (nc_9),
          .data_out (fifo_full_int)
      );

c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (3),
       .RESET_VAL   (0)
       )
      async_tx_hrdrst_hssi_tx_dcd_cal_done
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (tx_hrdrst_hssi_tx_dcd_cal_done),
          .unload   (tx_async_hssi_fabric_ssr_load),
          .data_in_sync_out (nc_10),
          .data_out (tx_hrdrst_hssi_tx_dcd_cal_done_int)
      );

c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (3),
       .RESET_VAL   (0)
       )
      async_tx_hrdrst_hssi_tx_dll_lock
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (tx_hrdrst_hssi_tx_dll_lock),
          .unload   (tx_async_hssi_fabric_ssr_load),
          .data_in_sync_out (nc_11),
          .data_out (tx_hrdrst_hssi_tx_dll_lock_int)
      );

c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (3),
       .RESET_VAL   (0)
       )
      async_tx_hrdrst_hssi_tx_transfer_en
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (tx_hrdrst_hssi_tx_transfer_en),
          .unload   (tx_async_hssi_fabric_ssr_load),
          .data_in_sync_out (nc_12),
          .data_out (tx_hrdrst_hssi_tx_transfer_en_int)
      );

c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (3),
       .RESET_VAL   (0)
       )
      async_aib_hssi_tx_dcd_cal_done
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (aib_hssi_tx_dcd_cal_done),
          .unload   (tx_async_hssi_fabric_ssr_load),
          .data_in_sync_out (nc_13),
          .data_out (aib_hssi_tx_dcd_cal_done_int)
      );

c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (3),
       .RESET_VAL   (0)
       )
      async_aib_hssi_tx_dll_lock
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (aib_hssi_tx_dll_lock),
          .unload   (tx_async_hssi_fabric_ssr_load),
          .data_in_sync_out (nc_14),
          .data_out (aib_hssi_tx_dll_lock_int)
      );


endmodule
