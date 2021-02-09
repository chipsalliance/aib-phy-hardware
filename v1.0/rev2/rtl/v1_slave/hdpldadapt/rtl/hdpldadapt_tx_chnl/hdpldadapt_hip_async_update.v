// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module hdpldadapt_hip_async_update (
// DPRIO
input   wire            r_tx_async_hip_aib_fsr_out_bit0_rst_val,
input   wire            r_tx_async_hip_aib_fsr_out_bit1_rst_val,
input   wire            r_tx_async_hip_aib_fsr_out_bit2_rst_val,
input   wire            r_tx_async_hip_aib_fsr_out_bit3_rst_val,

// TXCLK_CTL
input   wire            tx_clock_async_rx_osc_clk,     

// TXRST_CTL
input   wire            tx_reset_async_rx_osc_clk_rst_n,

// SR
input  wire    [3:0]    hip_aib_async_fsr_out,
input  wire    [7:0]    hip_aib_async_ssr_out,

input  wire             tx_async_hssi_fabric_fsr_load,      
input  wire             tx_async_hssi_fabric_ssr_load,      

// SR 
output wire             hip_fsr_parity_checker_in,
output wire    [5:0]    hip_ssr_parity_checker_in,

// PLD_IF
output wire    [3:0]    hip_aib_fsr_out,
output wire    [7:0]    hip_aib_ssr_out
);

wire  [3:0] hip_aib_fsr_out_rst0;
wire  [3:0] hip_aib_fsr_out_rst1;

// FSR SR: 
hdpldadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_hip_aib_fsr_out_bit0_rst0
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_hssi_fabric_fsr_load),
       .async_data_in   (hip_aib_async_fsr_out[0]),
       .async_data_out  (hip_aib_fsr_out_rst0[0])
     );

hdpldadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (1)
     ) async_hip_aib_fsr_out_bit0_rst1
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_hssi_fabric_fsr_load),
       .async_data_in   (hip_aib_async_fsr_out[0]),
       .async_data_out  (hip_aib_fsr_out_rst1[0])
     );

assign hip_aib_fsr_out[0] = r_tx_async_hip_aib_fsr_out_bit0_rst_val ? hip_aib_fsr_out_rst1[0] : hip_aib_fsr_out_rst0[0];
assign hip_fsr_parity_checker_in = hip_aib_fsr_out[0];

hdpldadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_hip_aib_fsr_out_bit1_rst0
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_hssi_fabric_fsr_load),
       .async_data_in   (hip_aib_async_fsr_out[1]),
       .async_data_out  (hip_aib_fsr_out_rst0[1])
     );

hdpldadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (1)
     ) async_hip_aib_fsr_out_bit1_rst1
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_hssi_fabric_fsr_load),
       .async_data_in   (hip_aib_async_fsr_out[1]),
       .async_data_out  (hip_aib_fsr_out_rst1[1])
     );

assign hip_aib_fsr_out[1] = r_tx_async_hip_aib_fsr_out_bit1_rst_val ? hip_aib_fsr_out_rst1[1] : hip_aib_fsr_out_rst0[1];

hdpldadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_hip_aib_fsr_out_bit2_rst0
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_hssi_fabric_fsr_load),
       .async_data_in   (hip_aib_async_fsr_out[2]),
       .async_data_out  (hip_aib_fsr_out_rst0[2])
     );

hdpldadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (1)
     ) async_hip_aib_fsr_out_bit2_rst1
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_hssi_fabric_fsr_load),
       .async_data_in   (hip_aib_async_fsr_out[2]),
       .async_data_out  (hip_aib_fsr_out_rst1[2])
     );

assign hip_aib_fsr_out[2] = r_tx_async_hip_aib_fsr_out_bit2_rst_val ? hip_aib_fsr_out_rst1[2] : hip_aib_fsr_out_rst0[2];

hdpldadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_hip_aib_fsr_out_bit3_rst0
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_hssi_fabric_fsr_load),
       .async_data_in   (hip_aib_async_fsr_out[3]),
       .async_data_out  (hip_aib_fsr_out_rst0[3])
     );

hdpldadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (1)
     ) async_hip_aib_fsr_out_bit3_rst1
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_hssi_fabric_fsr_load),
       .async_data_in   (hip_aib_async_fsr_out[3]),
       .async_data_out  (hip_aib_fsr_out_rst1[3])
     );

assign hip_aib_fsr_out[3] = r_tx_async_hip_aib_fsr_out_bit3_rst_val ? hip_aib_fsr_out_rst1[3] : hip_aib_fsr_out_rst0[3];

// SLOW SR 
hdpldadapt_async_update
    #( .AWIDTH       (8),
       .RESET_VAL    (0)
     ) async_hip_aib_ssr_out
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_hssi_fabric_ssr_load),
       .async_data_in   (hip_aib_async_ssr_out),
       .async_data_out  (hip_aib_ssr_out)
     );

assign hip_ssr_parity_checker_in = hip_aib_ssr_out[5:0];

endmodule
