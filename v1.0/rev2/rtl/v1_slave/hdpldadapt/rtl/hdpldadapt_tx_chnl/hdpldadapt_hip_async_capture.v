// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module hdpldadapt_hip_async_capture (
// DPRIO
input   wire            r_tx_async_hip_aib_fsr_in_bit0_rst_val, 
input   wire            r_tx_async_hip_aib_fsr_in_bit1_rst_val, 
input   wire            r_tx_async_hip_aib_fsr_in_bit2_rst_val, 
input   wire            r_tx_async_hip_aib_fsr_in_bit3_rst_val,
input   wire  [3:0]     r_tx_hip_aib_ssr_in_polling_bypass,
 
// SR
input   wire            tx_async_fabric_hssi_fsr_load,
input   wire            tx_async_fabric_hssi_ssr_load,

// TXCLK_CTL
input   wire            tx_clock_async_tx_osc_clk,     

// TXRST_CTL
input   wire            tx_reset_async_tx_osc_clk_rst_n,

// PLD_IF 
input  wire    [3:0]    hip_aib_fsr_in, 
input  wire    [39:0]   hip_aib_ssr_in,  

// SR
output  wire    [3:0]   hip_aib_async_fsr_in,  
output  wire    [39:0]  hip_aib_async_ssr_in 
);

wire    [3:0]    hip_aib_async_fsr_in_rst0_int;
wire    [3:0]    hip_aib_async_fsr_in_rst1_int;

wire  nc_0;
wire  nc_1;
wire  nc_2;
wire  nc_3;
wire  nc_4;
wire  nc_5;
wire  nc_6;
wire  nc_7;
wire [39:32]  nc_8;

// FAST SR:
assign hip_aib_async_fsr_in[0] = r_tx_async_hip_aib_fsr_in_bit0_rst_val ? hip_aib_async_fsr_in_rst1_int[0] : hip_aib_async_fsr_in_rst0_int[0]; 
assign hip_aib_async_fsr_in[1] = r_tx_async_hip_aib_fsr_in_bit1_rst_val ? hip_aib_async_fsr_in_rst1_int[1] : hip_aib_async_fsr_in_rst0_int[1]; 
assign hip_aib_async_fsr_in[2] = r_tx_async_hip_aib_fsr_in_bit2_rst_val ? hip_aib_async_fsr_in_rst1_int[2] : hip_aib_async_fsr_in_rst0_int[2]; 
assign hip_aib_async_fsr_in[3] = r_tx_async_hip_aib_fsr_in_bit3_rst_val ? hip_aib_async_fsr_in_rst1_int[3] : hip_aib_async_fsr_in_rst0_int[3]; 

hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (1),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (2),
       .SYNC_STAGE  (4)
       )
      async_hip_aib_fsr_in_bit0_rst1
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (hip_aib_fsr_in[0]),
          .unload   (tx_async_fabric_hssi_fsr_load),
          .data_in_sync_out (nc_0),
          .data_out (hip_aib_async_fsr_in_rst1_int[0])
      );

hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (0),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (2),
       .SYNC_STAGE  (4)
       )
      async_hip_aib_fsr_in_bit0_rst0
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (hip_aib_fsr_in[0]),
          .unload   (tx_async_fabric_hssi_fsr_load),
          .data_in_sync_out (nc_1),
          .data_out (hip_aib_async_fsr_in_rst0_int[0])
      );

hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (1),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (2),
       .SYNC_STAGE  (4)
       )
      async_hip_aib_fsr_in_bit1_rst1
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (hip_aib_fsr_in[1]),
          .unload   (tx_async_fabric_hssi_fsr_load),
          .data_in_sync_out (nc_2),
          .data_out (hip_aib_async_fsr_in_rst1_int[1])
      );

hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (0),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (2),
       .SYNC_STAGE  (4)
       )
      async_hip_aib_fsr_in_bit1_rst0
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (hip_aib_fsr_in[1]),
          .unload   (tx_async_fabric_hssi_fsr_load),
          .data_in_sync_out (nc_3),
          .data_out (hip_aib_async_fsr_in_rst0_int[1])
      );

hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (1),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (2),
       .SYNC_STAGE  (4)
       )
      async_hip_aib_fsr_in_bit2_rst1
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (hip_aib_fsr_in[2]),
          .unload   (tx_async_fabric_hssi_fsr_load),
          .data_in_sync_out (nc_4),
          .data_out (hip_aib_async_fsr_in_rst1_int[2])
      );

hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (0),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (2),
       .SYNC_STAGE  (4)
       )
      async_hip_aib_fsr_in_bit2_rst0
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (hip_aib_fsr_in[2]),
          .unload   (tx_async_fabric_hssi_fsr_load),
          .data_in_sync_out (nc_5),
          .data_out (hip_aib_async_fsr_in_rst0_int[2])
      );

hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (1),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (2),
       .SYNC_STAGE  (4)
       )
      async_hip_aib_fsr_in_bit3_rst1
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (hip_aib_fsr_in[3]),
          .unload   (tx_async_fabric_hssi_fsr_load),
          .data_in_sync_out (nc_6),
          .data_out (hip_aib_async_fsr_in_rst1_int[3])
      );

hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (0),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (2),
       .SYNC_STAGE  (4)
       )
      async_hip_aib_fsr_in_bit3_rst0
      (
          .clk      (tx_clock_async_tx_osc_clk),
          .rst_n    (tx_reset_async_tx_osc_clk_rst_n),
          .data_in  (hip_aib_fsr_in[3]),
          .unload   (tx_async_fabric_hssi_fsr_load),
          .data_in_sync_out (nc_7),
          .data_out (hip_aib_async_fsr_in_rst0_int[3])
      );


// SLOW SR:
hdpldadapt_cmn_async_capture_bus
     #(
       .DWIDTH      (8),
       .RESET_VAL   (1),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (2),
       .SYNC_STAGE  (4)
       )
      async_hip_aib_ssr_in_byte0
      (
          .clk         (tx_clock_async_tx_osc_clk),
          .rst_n       (tx_reset_async_tx_osc_clk_rst_n),
          .data_in     (hip_aib_ssr_in[7:0]),
          .unload      (tx_async_fabric_hssi_ssr_load),
          .r_capt_mode (r_tx_hip_aib_ssr_in_polling_bypass[0]),
          .data_out    (hip_aib_async_ssr_in[7:0])
      );

hdpldadapt_cmn_async_capture_bus
     #(
       .DWIDTH      (8),
       .RESET_VAL   (1),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (2),
       .SYNC_STAGE  (4)
       )
      async_hip_aib_ssr_in_byte1
      (
          .clk         (tx_clock_async_tx_osc_clk),
          .rst_n       (tx_reset_async_tx_osc_clk_rst_n),
          .data_in     (hip_aib_ssr_in[15:8]),
          .unload      (tx_async_fabric_hssi_ssr_load),
          .r_capt_mode (r_tx_hip_aib_ssr_in_polling_bypass[1]),
          .data_out    (hip_aib_async_ssr_in[15:8])
      );

hdpldadapt_cmn_async_capture_bus
     #(
       .DWIDTH      (8),
       .RESET_VAL   (1),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (2),
       .SYNC_STAGE  (4)
       )
      async_hip_aib_ssr_in_byte2
      (
          .clk         (tx_clock_async_tx_osc_clk),
          .rst_n       (tx_reset_async_tx_osc_clk_rst_n),
          .data_in     (hip_aib_ssr_in[23:16]),
          .unload      (tx_async_fabric_hssi_ssr_load),
          .r_capt_mode (r_tx_hip_aib_ssr_in_polling_bypass[2]),
          .data_out    (hip_aib_async_ssr_in[23:16])
      );

hdpldadapt_cmn_async_capture_bus
     #(
       .DWIDTH      (8),
       .RESET_VAL   (1),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (2),
       .SYNC_STAGE  (4)
       )
      async_hip_aib_ssr_in_byte3
      (
          .clk         (tx_clock_async_tx_osc_clk),
          .rst_n       (tx_reset_async_tx_osc_clk_rst_n),
          .data_in     (hip_aib_ssr_in[31:24]),
          .unload      (tx_async_fabric_hssi_ssr_load),
          .r_capt_mode (r_tx_hip_aib_ssr_in_polling_bypass[3]),
          .data_out    (hip_aib_async_ssr_in[31:24])
      );


generate 
  genvar i;
    for (i=32; i < 40; i=i+1) begin: hdpldadapt_cmn_async_capture_bit
    hdpldadapt_cmn_async_capture_bit
     #(
       .RESET_VAL   (1),
       .CLK_FREQ_MHZ(1200),
       .TOGGLE_TYPE (2),
       .SYNC_STAGE  (4)
       )
      async_hip_aib_ssr_in
      (
          .clk         (tx_clock_async_tx_osc_clk),
          .rst_n       (tx_reset_async_tx_osc_clk_rst_n),
          .data_in     (hip_aib_ssr_in[i]),
          .unload      (tx_async_fabric_hssi_ssr_load),
          .data_in_sync_out (nc_8[i]),
          .data_out    (hip_aib_async_ssr_in[i])
      );
   end
endgenerate

endmodule
