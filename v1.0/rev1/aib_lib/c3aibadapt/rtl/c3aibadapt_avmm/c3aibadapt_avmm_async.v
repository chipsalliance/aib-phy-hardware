// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3aibadapt_avmm_async
(
input  wire avmm_clock_hrdrst_tx_osc_clk,
input  wire avmm_reset_hrdrst_tx_osc_clk_rst_n,
input  wire avmm_clock_hrdrst_rx_osc_clk,
input  wire avmm_reset_hrdrst_rx_osc_clk_rst_n,

// From SR
input  wire avmm_async_fabric_hssi_ssr_load,
input  wire avmm_hrdrst_fabric_osc_transfer_en_ssr_data, 
input  wire avmm_async_hssi_fabric_ssr_load,

// From Reset SM
input  wire avmm_hrdrst_hssi_osc_transfer_en,

// To SR
output wire avmm_hrdrst_hssi_osc_transfer_en_ssr_data,

// To Reset SM
output wire avmm_hrdrst_hssi_osc_transfer_en_sync, 
output wire sr_fabric_osc_transfer_en 
);

c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_avmm_hrdrst_fabric_osc_transfer_en
     ( .clk             (avmm_clock_hrdrst_rx_osc_clk),
       .rst_n           (avmm_reset_hrdrst_rx_osc_clk_rst_n),
       .sr_load         (avmm_async_fabric_hssi_ssr_load),
       .async_data_in   (avmm_hrdrst_fabric_osc_transfer_en_ssr_data),
       .async_data_out  (sr_fabric_osc_transfer_en)
     );

c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (3),
       .RESET_VAL   (0)
       )
      async_avmm_hrdrst_hssi_osc_transfer_en
      (
          .clk      (avmm_clock_hrdrst_tx_osc_clk),
          .rst_n    (avmm_reset_hrdrst_tx_osc_clk_rst_n),
          .data_in  (avmm_hrdrst_hssi_osc_transfer_en),
          .unload   (avmm_async_hssi_fabric_ssr_load),
          .data_in_sync_out (avmm_hrdrst_hssi_osc_transfer_en_sync),
          .data_out (avmm_hrdrst_hssi_osc_transfer_en_ssr_data)
      );

endmodule
