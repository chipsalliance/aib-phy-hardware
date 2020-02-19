// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module hdpldadapt_tx_async_reserved_capture (
// SR
input   wire            tx_async_fabric_hssi_ssr_load,

// TXCLK_CTL
input   wire            tx_clock_async_tx_osc_clk,     

// TXRST_CTL
input   wire            tx_reset_async_tx_osc_clk_rst_n,

// PLD_IF 
input  wire    [2:0]    pld_tx_ssr_reserved_in, 

// SR
output  wire    [2:0]   tx_async_fabric_hssi_ssr_reserved 
);

wire [2:0] nc_1;

generate 
  genvar i;
    for (i=0; i < 3; i=i+1) begin: hdpldadapt_cmn_async_capture_bit
    hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (1),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (3),
       .SYNC_STAGE  (4)
       )
      async_tx_reserved_ssr_in
      (
          .clk         (tx_clock_async_tx_osc_clk),
          .rst_n       (tx_reset_async_tx_osc_clk_rst_n),
          .data_in     (pld_tx_ssr_reserved_in[i]),
          .unload      (tx_async_fabric_hssi_ssr_load),
          .data_in_sync_out (nc_1[i]),
          .data_out    (tx_async_fabric_hssi_ssr_reserved[i])
      );
   end
endgenerate

endmodule
