// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module hdpldadapt_tx_async_reserved_update (
// TXCLK_CTL
input   wire            tx_clock_async_rx_osc_clk,     

// TXRST_CTL
input   wire            tx_reset_async_rx_osc_clk_rst_n,

// SR
input  wire    [2:0]    tx_async_hssi_fabric_ssr_reserved,

input  wire             tx_async_hssi_fabric_ssr_load,      

// PLD_IF
output wire    [2:0]    pld_tx_ssr_reserved_out 
);

// SLOW SR 
hdpldadapt_async_update
    #( .AWIDTH       (3),
       .RESET_VAL    (0)
     ) async_tx_reserved_ssr_out
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_hssi_fabric_ssr_load),
       .async_data_in   (tx_async_hssi_fabric_ssr_reserved),
       .async_data_out  (pld_tx_ssr_reserved_out)
     );


endmodule
