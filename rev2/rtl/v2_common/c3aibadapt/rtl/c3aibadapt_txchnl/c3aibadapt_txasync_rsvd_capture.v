// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3aibadapt_txasync_rsvd_capture (
// 
input   wire   [2:0]    pld_tx_ssr_reserved_in,

// SR
input   wire            tx_async_hssi_fabric_ssr_load,

// TXCLK_CTL
input   wire            tx_clock_async_tx_osc_clk,         

// TXRST_CTL
input   wire            tx_reset_async_tx_osc_clk_rst_n,  

// SR
output  wire   [2:0]    tx_async_hssi_fabric_ssr_reserved 
);

wire [2:0] nc_0;

// SLOW SR:
generate
  genvar i;
    for (i=0; i < 3; i=i+1) begin: c3adapt_cmn_async_capture_bit
       c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (3),
       .RESET_VAL   (0)
       )
       async_tx_reserved_ssr_in     
      (
          .clk         (tx_clock_async_tx_osc_clk),
          .rst_n       (tx_reset_async_tx_osc_clk_rst_n),
          .data_in     (pld_tx_ssr_reserved_in[i]),
          .unload      (tx_async_hssi_fabric_ssr_load),
          .data_in_sync_out (nc_0[i]),
          .data_out    (tx_async_hssi_fabric_ssr_reserved[i])
      );
   end
endgenerate
 
endmodule
