// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3aibadapt_avmm2_async
(
input  wire avmm_clock_tx_osc_clk,
input  wire avmm_reset_tx_osc_clk_rst_n,

// From NF HSSI
input  wire pld_pll_cal_done,
input  wire pld_avmm2_busy,

// FRom SR
input  wire avmm2_async_hssi_fabric_ssr_load,

// To SR
output wire [1:0] avmm2_hssi_fabric_ssr_data
);

wire nc_0;
wire nc_1;

c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (2),
       .RESET_VAL   (0)
       )
      async_pld_pll_cal_done
      (
          .clk      (avmm_clock_tx_osc_clk),
          .rst_n    (avmm_reset_tx_osc_clk_rst_n),
          .data_in  (pld_pll_cal_done),
          .unload   (avmm2_async_hssi_fabric_ssr_load),
          .data_in_sync_out (nc_0),
          .data_out (avmm2_hssi_fabric_ssr_data[0])
      );

c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (2),
       .RESET_VAL   (1)
       )
      async_pld_avmm2_busy
      (
          .clk      (avmm_clock_tx_osc_clk),
          .rst_n    (avmm_reset_tx_osc_clk_rst_n),
          .data_in  (pld_avmm2_busy),
          .unload   (avmm2_async_hssi_fabric_ssr_load),
          .data_in_sync_out (nc_1),
          .data_out (avmm2_hssi_fabric_ssr_data[1])
      );


endmodule
