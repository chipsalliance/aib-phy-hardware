// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3aibadapt_hip_async_update (
// DPRIO
input   wire            r_tx_async_hip_aib_fsr_in_bit0_rst_val,
input   wire            r_tx_async_hip_aib_fsr_in_bit1_rst_val,
input   wire            r_tx_async_hip_aib_fsr_in_bit2_rst_val,
input   wire            r_tx_async_hip_aib_fsr_in_bit3_rst_val,

// SR
input   wire            tx_async_fabric_hssi_fsr_load,    
input   wire            tx_async_fabric_hssi_ssr_load, 
input   wire    [3:0]   hip_aib_async_fsr_in,
input   wire    [39:0]  hip_aib_async_ssr_in,

// TXCLK_CTL
input   wire            tx_clock_async_rx_osc_clk,      

// TXRST_CTL
input   wire            tx_reset_async_rx_osc_clk_rst_n, 

// SR
output  wire            hip_fsr_parity_checker_in,
output  wire   [4:0]    hip_ssr_parity_checker_in,

// HIP IF
output  wire   [3:0]    hip_aib_fsr_in,
output  wire   [39:0]   hip_aib_ssr_in
);


// FAST SR: to check reset value
wire  [3:0] hip_aib_fsr_in_rst0;
wire  [3:0] hip_aib_fsr_in_rst1;

// FSR SR:
c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_hip_aib_fsr_in_bit0_rst0
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_fabric_hssi_fsr_load),
       .async_data_in   (hip_aib_async_fsr_in[0]),
       .async_data_out  (hip_aib_fsr_in_rst0[0])
     );

c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (1)
     ) async_hip_aib_fsr_in_bit0_rst1
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_fabric_hssi_fsr_load),
       .async_data_in   (hip_aib_async_fsr_in[0]),
       .async_data_out  (hip_aib_fsr_in_rst1[0])
     );

assign hip_aib_fsr_in[0] = r_tx_async_hip_aib_fsr_in_bit0_rst_val ? hip_aib_fsr_in_rst1[0] : hip_aib_fsr_in_rst0[0];
assign hip_fsr_parity_checker_in = hip_aib_fsr_in[0];

c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_hip_aib_fsr_in_bit1_rst0
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_fabric_hssi_fsr_load),
       .async_data_in   (hip_aib_async_fsr_in[1]),
       .async_data_out  (hip_aib_fsr_in_rst0[1])
     );

c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (1)
     ) async_hip_aib_fsr_in_bit1_rst1
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_fabric_hssi_fsr_load),
       .async_data_in   (hip_aib_async_fsr_in[1]),
       .async_data_out  (hip_aib_fsr_in_rst1[1])
     );

assign hip_aib_fsr_in[1] = r_tx_async_hip_aib_fsr_in_bit1_rst_val ? hip_aib_fsr_in_rst1[1] : hip_aib_fsr_in_rst0[1];

c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_hip_aib_fsr_in_bit2_rst0
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_fabric_hssi_fsr_load),
       .async_data_in   (hip_aib_async_fsr_in[2]),
       .async_data_out  (hip_aib_fsr_in_rst0[2])
     );

c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (1)
     ) async_hip_aib_fsr_in_bit2_rst1
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_fabric_hssi_fsr_load),
       .async_data_in   (hip_aib_async_fsr_in[2]),
       .async_data_out  (hip_aib_fsr_in_rst1[2])
     );

assign hip_aib_fsr_in[2] = r_tx_async_hip_aib_fsr_in_bit2_rst_val ? hip_aib_fsr_in_rst1[2] : hip_aib_fsr_in_rst0[2];

c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (0)
     ) async_hip_aib_fsr_in_bit3_rst0
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_fabric_hssi_fsr_load),
       .async_data_in   (hip_aib_async_fsr_in[3]),
       .async_data_out  (hip_aib_fsr_in_rst0[3])
     );

c3aibadapt_async_update
    #( .AWIDTH       (1),
       .RESET_VAL    (1)
     ) async_hip_aib_fsr_in_bit3_rst1
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_fabric_hssi_fsr_load),
       .async_data_in   (hip_aib_async_fsr_in[3]),
       .async_data_out  (hip_aib_fsr_in_rst1[3])
     );

assign hip_aib_fsr_in[3] = r_tx_async_hip_aib_fsr_in_bit3_rst_val ? hip_aib_fsr_in_rst1[3] : hip_aib_fsr_in_rst0[3];

// SLOW SR: 
c3aibadapt_async_update
    #( .AWIDTH       (40),
       .RESET_VAL    (1)
     ) async_hip_aib_ssr_in
     ( .clk             (tx_clock_async_rx_osc_clk),
       .rst_n           (tx_reset_async_rx_osc_clk_rst_n),
       .sr_load         (tx_async_fabric_hssi_ssr_load),
       .async_data_in   (hip_aib_async_ssr_in),
       .async_data_out  (hip_aib_ssr_in)
     );

assign hip_ssr_parity_checker_in = hip_aib_ssr_in[4:0];

endmodule 
