// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module hdpldadapt_rx_async_reserved_capture (
// SR
input   wire            rx_async_fabric_hssi_ssr_load,

// RXCLK_CTL
input   wire            rx_clock_async_tx_osc_clk,

// RXRST_CTL
input   wire            rx_reset_async_tx_osc_clk_rst_n,

// PCS_IF
input  wire    [1:0]    pld_rx_ssr_reserved_in,

output   wire  [1:0]    rx_async_fabric_hssi_ssr_reserved 
);

wire [1:0] nc_0;

//generate
//  genvar i;
//    for (i=0; i < 2; i=i+1) begin: hdpldadapt_cmn_async_capture_bit
//    hdpldadapt_cmn_async_capture_bit
//     #(
//       .RESET_VAL   (1),
//       .CLK_FREQ_MHZ(1200),
//       .TOGGLE_TYPE (3),
//       .SYNC_STAGE  (4)
//       )
//      async_rx_reserved_ssr_in
//      (
//          .clk         (rx_clock_async_tx_osc_clk),
//          .rst_n       (rx_reset_async_tx_osc_clk_rst_n),
//          .data_in     (pld_rx_ssr_reserved_in[i]),
//          .unload      (rx_async_fabric_hssi_ssr_load),
//          .data_in_sync_out (nc_0[i]),
//          .data_out    (rx_async_fabric_hssi_ssr_reserved[i])
//      );
//   end
//endgenerate

    hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (1),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (3),
       .SYNC_STAGE  (4)
       )
      async_rx_pld_rx_ssr_reserved_in0
      (
          .clk         (rx_clock_async_tx_osc_clk),
          .rst_n       (rx_reset_async_tx_osc_clk_rst_n),
          .data_in     (pld_rx_ssr_reserved_in[0]),
          .unload      (rx_async_fabric_hssi_ssr_load),
          .data_in_sync_out (nc_0[0]),
          .data_out    (rx_async_fabric_hssi_ssr_reserved[0])
      );


    hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (0),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (3),
       .SYNC_STAGE  (4)
       )
      async_rx_pld_rx_ssr_reserved_in1
      (
          .clk         (rx_clock_async_tx_osc_clk),
          .rst_n       (rx_reset_async_tx_osc_clk_rst_n),
          .data_in     (pld_rx_ssr_reserved_in[1]),
          .unload      (rx_async_fabric_hssi_ssr_load),
          .data_in_sync_out (nc_0[1]),
          .data_out    (rx_async_fabric_hssi_ssr_reserved[1])
      );

endmodule
