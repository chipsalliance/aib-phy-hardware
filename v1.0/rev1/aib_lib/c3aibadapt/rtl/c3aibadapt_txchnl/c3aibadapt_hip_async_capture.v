// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3aibadapt_hip_async_capture (
// DPRIO
input   wire            r_tx_async_hip_aib_fsr_out_bit0_rst_val,
input   wire            r_tx_async_hip_aib_fsr_out_bit1_rst_val,
input   wire            r_tx_async_hip_aib_fsr_out_bit2_rst_val,
input   wire            r_tx_async_hip_aib_fsr_out_bit3_rst_val,

// HIP IF 
input   wire   [3:0]    hip_aib_fsr_out,
input   wire   [7:0]    hip_aib_ssr_out,

// SR
input   wire            tx_async_hssi_fabric_fsr_load,
input   wire            tx_async_hssi_fabric_ssr_load,

// TXCLK_CTL
input   wire            tx_clock_async_tx_osc_clk,         

// TXRST_CTL
input   wire            tx_reset_async_tx_osc_clk_rst_n,  

// SR
output  wire   [3:0]    hip_aib_async_fsr_out,      
output  wire   [7:0]    hip_aib_async_ssr_out
);

// FAST SR:
wire    [3:0]    hip_aib_async_fsr_out_rst0_int;
wire    [3:0]    hip_aib_async_fsr_out_rst1_int;

wire  nc_0;
wire  nc_1;
wire  nc_2;
wire  nc_3;
wire  nc_4;
wire  nc_5;
wire  nc_6;
wire  nc_7;
wire  [7:0] nc_8;

// FAST SR:
assign hip_aib_async_fsr_out[0] = r_tx_async_hip_aib_fsr_out_bit0_rst_val ? hip_aib_async_fsr_out_rst1_int[0] : hip_aib_async_fsr_out_rst0_int[0];
assign hip_aib_async_fsr_out[1] = r_tx_async_hip_aib_fsr_out_bit1_rst_val ? hip_aib_async_fsr_out_rst1_int[1] : hip_aib_async_fsr_out_rst0_int[1];
assign hip_aib_async_fsr_out[2] = r_tx_async_hip_aib_fsr_out_bit2_rst_val ? hip_aib_async_fsr_out_rst1_int[2] : hip_aib_async_fsr_out_rst0_int[2];
assign hip_aib_async_fsr_out[3] = r_tx_async_hip_aib_fsr_out_bit3_rst_val ? hip_aib_async_fsr_out_rst1_int[3] : hip_aib_async_fsr_out_rst0_int[3];

c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (3),
       .RESET_VAL   (1)
       )
      async_hip_aib_fsr_out_bit0_rst1
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (hip_aib_fsr_out[0]),
          .unload   (tx_async_hssi_fabric_fsr_load),
          .data_in_sync_out (nc_0),
          .data_out (hip_aib_async_fsr_out_rst1_int[0])
      );

c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (3),
       .RESET_VAL   (0)
       )
      async_hip_aib_fsr_out_bit0_rst0
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (hip_aib_fsr_out[0]),
          .unload   (tx_async_hssi_fabric_fsr_load),
          .data_in_sync_out (nc_1),
          .data_out (hip_aib_async_fsr_out_rst0_int[0])
      );

c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (3),
       .RESET_VAL   (1)
       )
      async_hip_aib_fsr_out_bit1_rst1
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (hip_aib_fsr_out[1]),
          .unload   (tx_async_hssi_fabric_fsr_load),
          .data_in_sync_out (nc_2),
          .data_out (hip_aib_async_fsr_out_rst1_int[1])
      );

c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (3),
       .RESET_VAL   (0)
       )
      async_hip_aib_fsr_out_bit1_rst0
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (hip_aib_fsr_out[1]),
          .unload   (tx_async_hssi_fabric_fsr_load),
          .data_in_sync_out (nc_3),
          .data_out (hip_aib_async_fsr_out_rst0_int[1])
      );

c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (3),
       .RESET_VAL   (1)
       )
      async_hip_aib_fsr_out_bit2_rst1
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (hip_aib_fsr_out[2]),
          .unload   (tx_async_hssi_fabric_fsr_load),
          .data_in_sync_out (nc_4),
          .data_out (hip_aib_async_fsr_out_rst1_int[2])
      );

c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (3),
       .RESET_VAL   (0)
       )
      async_hip_aib_fsr_out_bit2_rst0
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (hip_aib_fsr_out[2]),
          .unload   (tx_async_hssi_fabric_fsr_load),
          .data_in_sync_out (nc_5),
          .data_out (hip_aib_async_fsr_out_rst0_int[2])
      );

c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (3),
       .RESET_VAL   (1)
       )
      async_hip_aib_fsr_out_bit3_rst1
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (hip_aib_fsr_out[3]),
          .unload   (tx_async_hssi_fabric_fsr_load),
          .data_in_sync_out (nc_6),
          .data_out (hip_aib_async_fsr_out_rst1_int[3])
      );

c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (3),
       .RESET_VAL   (0)
       )
      async_hip_aib_fsr_out_bit3_rst0
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (hip_aib_fsr_out[3]),
          .unload   (tx_async_hssi_fabric_fsr_load),
          .data_in_sync_out (nc_7),
          .data_out (hip_aib_async_fsr_out_rst0_int[3])
      );

// SLOW SR:
generate
  genvar i;
    for (i=0; i < 8; i=i+1) begin: c3adapt_cmn_async_capture_bit
    c3aibadapt_cmn_async_capture_bit
     #(
       .SYNC_STAGE  (3),
       .RESET_VAL   (0)
       )
      async_hip_aib_ssr_out
      (
          .clk         (tx_clock_async_tx_osc_clk),
          .rst_n       (tx_reset_async_tx_osc_clk_rst_n),
          .data_in     (hip_aib_ssr_out[i]),
          .unload      (tx_async_hssi_fabric_ssr_load),
          .data_in_sync_out (nc_8[i]),
          .data_out    (hip_aib_async_ssr_out[i])
      );
   end
endgenerate
 
endmodule
