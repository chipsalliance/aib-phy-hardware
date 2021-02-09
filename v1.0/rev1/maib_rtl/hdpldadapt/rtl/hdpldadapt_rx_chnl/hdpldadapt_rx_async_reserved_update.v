// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module hdpldadapt_rx_async_reserved_update (
// RXCLK_CTL
input   wire            rx_clock_async_rx_osc_clk, 

// RXRST_CTL
input   wire            rx_reset_async_rx_osc_clk_rst_n,

// SR
input  wire    [1:0]    rx_async_hssi_fabric_ssr_reserved,
input  wire             rx_async_hssi_fabric_ssr_load,

// PLD IF
output   wire  [1:0]    pld_rx_ssr_reserved_out 
);

// SLOW SR
hdpldadapt_async_update
    #( .AWIDTH       (2),
       .RESET_VAL    (0)
     ) async_rx_reserved_ssr_out
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_hssi_fabric_ssr_load),
       .async_data_in   (rx_async_hssi_fabric_ssr_reserved),
       .async_data_out  (pld_rx_ssr_reserved_out)
     );

endmodule
