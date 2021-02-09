// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3aibadapt_rxasync_rsvd_capture (
input   wire   [1:0]    pld_rx_ssr_reserved_in,

// SR
input   wire            rx_async_hssi_fabric_ssr_load,

// RXCLK_CTL
input   wire            rx_clock_async_tx_osc_clk, 

// RXRST_CTL
input   wire            rx_reset_async_tx_osc_clk_rst_n, 

// SR
output  wire   [1:0]    rx_async_hssi_fabric_ssr_reserved 
);

wire [1:0] nc_0;

// SLOW SR:
generate
  genvar i;
    for (i=0; i < 2; i=i+1) begin: c3adapt_cmn_async_capture_bit
    c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (3),
       .RESET_VAL   (0)
       )
       async_rx_reserved_ssr_in
      (
          .clk         (rx_clock_async_tx_osc_clk),
          .rst_n       (rx_reset_async_tx_osc_clk_rst_n),
          .data_in     (pld_rx_ssr_reserved_in[i]),
          .unload      (rx_async_hssi_fabric_ssr_load),
          .data_in_sync_out (nc_0[i]),
          .data_out    (rx_async_hssi_fabric_ssr_reserved[i])
      );
   end
endgenerate

endmodule
