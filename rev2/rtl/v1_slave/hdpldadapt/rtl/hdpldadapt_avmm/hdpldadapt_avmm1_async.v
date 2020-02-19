// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module hdpldadapt_avmm1_async
(
//input  wire avmm_clock_osc_clk,
input  wire avmm_clock_rx_osc_clk,
//input  wire avmm_reset_osc_clk_rst_n,
input  wire avmm_reset_rx_osc_clk_rst_n,

input  wire [1:0] avmm1_hssi_fabric_ssr_data,

// SR
input  wire avmm1_hssi_fabric_ssr_load,

// From PLD
//input  wire  pr_channel_freeze,

// From SSM
input  wire  nfrzdrv_in,

// to SSR
output wire [1:0] avmm1_ssr_parity_checker_in, 

// To AVMM 
output wire sr_hssi_avmm1_busy, 

// To PLD
output wire pld_chnl_cal_done
);

wire pld_chnl_cal_done_int;
wire nfrz_output_2one;

hdpldadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_pld_chnl_cal_done
     ( .clk             (avmm_clock_rx_osc_clk),
       .rst_n           (avmm_reset_rx_osc_clk_rst_n),
       .sr_load         (avmm1_hssi_fabric_ssr_load),
       .async_data_in   (avmm1_hssi_fabric_ssr_data[0]),
       .async_data_out  (pld_chnl_cal_done_int)
     );

assign nfrz_output_2one  = nfrzdrv_in; 
assign pld_chnl_cal_done = nfrz_output_2one ? pld_chnl_cal_done_int : 1'b1;


hdpldadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (1)
     ) async_pld_avmm1_busy
     ( .clk             (avmm_clock_rx_osc_clk),
       .rst_n           (avmm_reset_rx_osc_clk_rst_n),
       .sr_load         (avmm1_hssi_fabric_ssr_load),
       .async_data_in   (avmm1_hssi_fabric_ssr_data[1]),
       .async_data_out  (sr_hssi_avmm1_busy)
     );


assign avmm1_ssr_parity_checker_in = {sr_hssi_avmm1_busy, pld_chnl_cal_done_int};





endmodule
