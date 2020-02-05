// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module hdpldadapt_avmm2_async
(
input wire avmm_clock_rx_osc_clk,
input wire avmm_reset_rx_osc_clk_rst_n,

input wire [1:0] avmm2_hssi_fabric_ssr_data,

// SR
input wire avmm2_hssi_fabric_ssr_load,

// From PLD
//input  wire  pr_channel_freeze,

// From SSM
input  wire  nfrzdrv_in,

// SR
output wire [1:0] avmm2_ssr_parity_checker_in,

// To AVMM
output wire sr_hssi_avmm2_busy,

// To PLD
output wire pld_pll_cal_done
);

wire pld_pll_cal_done_int;
wire nfrz_output_2one;

hdpldadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_pld_pll_cal_done
     ( .clk             (avmm_clock_rx_osc_clk),
       .rst_n           (avmm_reset_rx_osc_clk_rst_n),
       .sr_load         (avmm2_hssi_fabric_ssr_load),
       .async_data_in   (avmm2_hssi_fabric_ssr_data[0]),
       .async_data_out  (pld_pll_cal_done_int)
     );

assign nfrz_output_2one  = nfrzdrv_in;
assign pld_pll_cal_done = nfrz_output_2one ? pld_pll_cal_done_int : 1'b1;


hdpldadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (1)
     ) async_sr_hssi_avmm2_busy
     ( .clk             (avmm_clock_rx_osc_clk),
       .rst_n           (avmm_reset_rx_osc_clk_rst_n),
       .sr_load         (avmm2_hssi_fabric_ssr_load),
       .async_data_in   (avmm2_hssi_fabric_ssr_data[1]),
       .async_data_out  (sr_hssi_avmm2_busy)
     );


assign avmm2_ssr_parity_checker_in = {sr_hssi_avmm2_busy, pld_pll_cal_done_int};

endmodule
