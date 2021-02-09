// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3aibadapt_rxasync_rsvd_update (
// RXCLK_CTL
input   wire            rx_clock_async_rx_osc_clk,

// RXRST_CTL
input   wire            rx_reset_async_rx_osc_clk_rst_n,

// SR
input   wire            rx_async_fabric_hssi_ssr_load, 
input   wire [1:0]      rx_async_fabric_hssi_ssr_reserved,

output  wire [1:0]      pld_rx_ssr_reserved_out 
);


// SLOW SR:
c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (1)
     ) async_rx_pld_rx_ssr_reserved_out0
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_fabric_hssi_ssr_load),
       .async_data_in   (rx_async_fabric_hssi_ssr_reserved[0]),
       .async_data_out  (pld_rx_ssr_reserved_out[0])
     );

c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_rx_pld_rx_ssr_reserved_out1
     ( .clk             (rx_clock_async_rx_osc_clk),
       .rst_n           (rx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (rx_async_fabric_hssi_ssr_load),
       .async_data_in   (rx_async_fabric_hssi_ssr_reserved[1]),
       .async_data_out  (pld_rx_ssr_reserved_out[1])
     );


endmodule
