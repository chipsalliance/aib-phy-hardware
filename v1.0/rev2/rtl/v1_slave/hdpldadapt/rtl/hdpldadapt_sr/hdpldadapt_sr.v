// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module hdpldadapt_sr (
// AIB IF
input	wire		aib_fabric_rx_sr_clk_in,
input	wire		aib_fabric_tx_sr_clk_in,
input	wire		aib_fabric_fsr_data_in,
input	wire		aib_fabric_fsr_load_in,
input	wire		aib_fabric_ssr_data_in,
input	wire		aib_fabric_ssr_load_in,

// DPRIO
input   wire            r_sr_hip_en,
input   wire            r_sr_parity_en,
input   wire            r_sr_reserbits_in_en,  
input   wire            r_sr_reserbits_out_en,
input   wire            r_sr_testbus_sel,
input   wire            r_sr_osc_clk_scg_en, 

// RX ASYNC
input	wire	[2:0]	rx_async_fabric_hssi_fsr_data,
input	wire	[35:0]	rx_async_fabric_hssi_ssr_data,
input   wire    [1:0]   rx_async_fabric_hssi_ssr_reserved, 

input   wire  [1:0]     rx_fsr_parity_checker_in,
input   wire  [64:0]    rx_ssr_parity_checker_in,

// TX ASYNC
input	wire		tx_async_fabric_hssi_fsr_data,
input	wire	[35:0]	tx_async_fabric_hssi_ssr_data,
input   wire    [2:0]   tx_async_fabric_hssi_ssr_reserved,

input  wire             hip_fsr_parity_checker_in,
input  wire    [5:0]    hip_ssr_parity_checker_in,
input  wire             tx_fsr_parity_checker_in,
input  wire    [15:0]   tx_ssr_parity_checker_in,
	
// uC
input	wire		csr_rdy_dly_in,

// HIP IF
input  wire    [3:0]    hip_aib_async_fsr_in,      
input  wire    [39:0]   hip_aib_async_ssr_in,      

// AVMM
input   wire            avmm_hrdrst_fabric_osc_transfer_en_ssr_data,
input   wire            avmm_hrdrst_fabric_osc_transfer_en_sync,

input	wire		avmm1_transfer_error,
input	wire		avmm2_transfer_error,

input   wire   [1:0]    avmm1_ssr_parity_checker_in,
input   wire   [1:0]    avmm2_ssr_parity_checker_in,
input   wire            sr_hssi_osc_transfer_en,

// DFT
input	wire		dft_adpt_aibiobsr_fastclkn,
input   wire            adapter_scan_rst_n,
input   wire            adapter_scan_mode_n,
input   wire            adapter_scan_shift_n,
input   wire            adapter_scan_shift_clk,
input   wire            adapter_scan_user_clk3,         // 1GHz
input   wire            adapter_clk_sel_n,
input   wire            adapter_occ_enable,

// AIB IF
output	wire		aib_fabric_tx_sr_clk_out,
output	wire		aib_fabric_fsr_data_out,
output	wire		aib_fabric_fsr_load_out,
output	wire		aib_fabric_ssr_data_out,
output	wire		aib_fabric_ssr_load_out,

// HIP IF
output  wire    [3:0]   hip_aib_async_fsr_out,     
output  wire    [7:0]   hip_aib_async_ssr_out,     

// AVMM
output  wire            avmm_fabric_hssi_ssr_load, // for capture logic  
output  wire            avmm_hssi_fabric_ssr_load, // for update logic
output  wire            avmm_hrdrst_hssi_osc_transfer_en_ssr_data, 

// AVMM1
output	wire   [1:0]	avmm1_hssi_fabric_ssr_data,
output  wire            avmm1_hssi_fabric_ssr_load,

// AVMM2
output	wire	[1:0]	avmm2_hssi_fabric_ssr_data,
output  wire            avmm2_hssi_fabric_ssr_load,

// RX ASYNC
output	wire	[1:0]	rx_async_hssi_fabric_fsr_data,	
output	wire	[62:0]	rx_async_hssi_fabric_ssr_data,	
output  wire    [1:0]   rx_async_hssi_fabric_ssr_reserved, 
output	wire		rx_async_hssi_fabric_fsr_load,	// for update logic
output	wire		rx_async_hssi_fabric_ssr_load,	// for update logic
output	wire		rx_async_fabric_hssi_fsr_load,	// for capture logic
output	wire		rx_async_fabric_hssi_ssr_load,	// for capture logic
output  wire    [19:0]  sr_parity_error_flag,

// TX ASYNC
output	wire		tx_async_hssi_fabric_fsr_data,	
output	wire	[12:0]	tx_async_hssi_fabric_ssr_data,	
output  wire    [2:0]   tx_async_hssi_fabric_ssr_reserved,
output	wire		tx_async_hssi_fabric_fsr_load,	// for update logic
output	wire		tx_async_hssi_fabric_ssr_load,	// for update logic
output	wire		tx_async_fabric_hssi_fsr_load,	// for capture logic
output	wire		tx_async_fabric_hssi_ssr_load,	// for capture logic
output  wire  [117:0]   ssrin_parallel_in,  //Pull out for AIB SPEC Model. 12/27/18 JZ
output  reg   [93:0]    ssrout_parallel_out_latch, //Pull out for AIB SPEC Model. 12/27/18 JZ
// Test bus
output  wire  [19:0]    sr_testbus
);

localparam NUM_OF_PCS_CHAIN_SSRIN  = 7'd73;
localparam NUM_OF_RESERVED_CHAIN_SSRIN = 7'd5;
localparam NUM_OF_HIP_CHAIN_SSRIN  = 7'd40;
localparam NUM_OF_PCS_CHAIN_SSROUT = 7'd81;
localparam NUM_OF_RESERVED_CHAIN_SSROUT = 7'd5;
localparam NUM_OF_HIP_CHAIN_SSROUT = 7'd8;

localparam NUM_OF_PCS_CHAIN_FSRIN  = 7'd4;
localparam NUM_OF_HIP_CHAIN_FSRIN  = 7'd4;
localparam NUM_OF_PCS_CHAIN_FSROUT = 7'd3;
localparam NUM_OF_HIP_CHAIN_FSROUT = 7'd4;


localparam NUM_OF_PARITY_BIT_SSRIN  = 7'd5;
localparam NUM_OF_PARITY_BIT_FSRIN  = 7'd1;
localparam NUM_OF_PARITY_BIT_SSROUT = 7'd6;
localparam NUM_OF_PARITY_BIT_FSROUT = 7'd1;

//wire [(NUM_OF_PCS_CHAIN_SSRIN  + NUM_OF_HIP_CHAIN_SSRIN  + NUM_OF_RESERVED_CHAIN_SSRIN  - 1):0] ssrin_parallel_in;
wire [(NUM_OF_PCS_CHAIN_SSRIN  + NUM_OF_HIP_CHAIN_SSRIN  + NUM_OF_RESERVED_CHAIN_SSRIN  - 1):0] ssrin_parallel_in_temp;
wire [NUM_OF_PARITY_BIT_SSRIN-1:0] ssrin_parity_out;

wire [(NUM_OF_PCS_CHAIN_SSROUT + NUM_OF_HIP_CHAIN_SSROUT + NUM_OF_RESERVED_CHAIN_SSROUT - 1):0] ssrout_parallel_out;
wire [(NUM_OF_PCS_CHAIN_SSROUT + NUM_OF_RESERVED_CHAIN_SSROUT - 1):0] ssrout_parity_checker;
wire [(NUM_OF_PARITY_BIT_SSROUT - 1):0] ssrout_parity_error_flag;


wire [(NUM_OF_PCS_CHAIN_FSRIN + NUM_OF_HIP_CHAIN_FSRIN - 1):0]   fsrin_parallel_in;
wire [(NUM_OF_PCS_CHAIN_FSRIN + NUM_OF_HIP_CHAIN_FSRIN - 1):0]   fsrin_parallel_in_temp;
wire [NUM_OF_PARITY_BIT_FSRIN-1:0] fsrin_parity_out;

wire [(NUM_OF_PCS_CHAIN_FSROUT + NUM_OF_HIP_CHAIN_FSROUT - 1):0] fsrout_parallel_out;
wire [(NUM_OF_PCS_CHAIN_FSROUT - 1):0] fsrout_parity_checker;
wire [(NUM_OF_PARITY_BIT_FSROUT - 1):0] fsrout_parity_error_flag;

//assign r_sr_hip_en                     = sr_dprio_ctrl[0];

//assign r_sr_pld_txelecidle_rst_val     = sr_dprio_ctrl[1];
//assign r_sr_pld_ltr_rst_val            = sr_dprio_ctrl[2];
//assign r_sr_pld_pma_ltd_b_rst_val      = sr_dprio_ctrl[3];
//assign r_sr_hip_fsr_in_bit0_rst_val    = sr_dprio_ctrl[4];
//assign r_sr_hip_fsr_in_bit1_rst_val    = sr_dprio_ctrl[5];
//assign r_sr_hip_fsr_in_bit2_rst_val    = sr_dprio_ctrl[6];
//assign r_sr_hip_fsr_in_bit3_rst_val    = sr_dprio_ctrl[7];
//assign r_sr_pld_pmaif_mask_tx_pll_rst_val   = sr_dprio_ctrl[8];
//assign r_sr_pld_8g_signal_detect_out_rst_val      = sr_dprio_ctrl[9];
//assign r_sr_pld_10g_rx_crc32_err_rst_val = sr_dprio_ctrl[10];
//assign r_sr_hip_fsr_out_bit0_rst_val   = sr_dprio_ctrl[11];
//assign r_sr_hip_fsr_out_bit1_rst_val   = sr_dprio_ctrl[12];
//assign r_sr_hip_fsr_out_bit2_rst_val   = sr_dprio_ctrl[13];
//assign r_sr_hip_fsr_out_bit3_rst_val   = sr_dprio_ctrl[14];

//assign r_sr_osc_clk_scg_en             = sr_dprio_ctrl[16];

reg  aib_fabric_fsr_load_in_dly;
reg  aib_fabric_fsr_load_in_ctrl;
wire aib_fabric_fsr_load_in_gated;

reg ssr_parity_checker_qualifier_dly0;
reg ssr_parity_checker_qualifier;

reg fsr_parity_checker_qualifier_dly0;
reg fsr_parity_checker_qualifier;

reg  aib_fabric_ssr_load_in_dly;
reg  aib_fabric_ssr_load_in_ctrl;
wire aib_fabric_ssr_load_in_gated;
wire sr_reset_rx_osc_clk_rst_n;
wire sr_clock_rx_osc_clk;
wire sr_clock_reset_rx_osc_clk;
wire sr_clock_reset_tx_osc_clk;

wire [19:0] fast_sr_testbus;
wire [19:0] slow_sr_testbus;
wire [11:0] fast_sr_sm_testbus;
wire [11:0] slow_sr_sm_testbus;

assign fast_sr_testbus = {5'h00, aib_fabric_fsr_load_in, aib_fabric_fsr_load_in_gated, aib_fabric_fsr_load_out, fast_sr_sm_testbus}; 
assign slow_sr_testbus = {5'h00, aib_fabric_ssr_load_in, aib_fabric_ssr_load_in_gated, aib_fabric_ssr_load_out, slow_sr_sm_testbus}; 

assign sr_testbus     = r_sr_testbus_sel ? fast_sr_testbus : slow_sr_testbus;
 
// Fast Load
always @(negedge sr_reset_rx_osc_clk_rst_n or posedge sr_clock_rx_osc_clk)
  if (sr_reset_rx_osc_clk_rst_n == 1'b0)
    begin
      aib_fabric_fsr_load_in_dly <= 1'b0;
    end
  else
    begin
      aib_fabric_fsr_load_in_dly <= aib_fabric_fsr_load_in;
    end

always @(negedge sr_reset_rx_osc_clk_rst_n or posedge sr_clock_rx_osc_clk)
  if (sr_reset_rx_osc_clk_rst_n == 1'b0)
    begin
      aib_fabric_fsr_load_in_ctrl <= 1'b0;
    end
  else
    begin
      if (aib_fabric_fsr_load_in_ctrl == 1'b0)
       begin
          aib_fabric_fsr_load_in_ctrl <= (aib_fabric_fsr_load_in_dly == 1'b1) && (aib_fabric_fsr_load_in == 1'b0);
       end
       else begin
          aib_fabric_fsr_load_in_ctrl <=  aib_fabric_fsr_load_in_ctrl; 
       end
    end

assign aib_fabric_fsr_load_in_gated = aib_fabric_fsr_load_in_ctrl & aib_fabric_fsr_load_in;

assign rx_async_hssi_fabric_fsr_load = aib_fabric_fsr_load_in_gated;
assign tx_async_hssi_fabric_fsr_load = aib_fabric_fsr_load_in_gated;

// Slow 
always @(negedge sr_reset_rx_osc_clk_rst_n or posedge sr_clock_rx_osc_clk)
  if (sr_reset_rx_osc_clk_rst_n == 1'b0)
    begin
      aib_fabric_ssr_load_in_dly <= 1'b0;
    end
  else
    begin
      aib_fabric_ssr_load_in_dly <= aib_fabric_ssr_load_in;
    end

always @(negedge sr_reset_rx_osc_clk_rst_n or posedge sr_clock_rx_osc_clk)
  if (sr_reset_rx_osc_clk_rst_n == 1'b0)
    begin
      aib_fabric_ssr_load_in_ctrl <= 1'b0;
    end
  else
    begin
      if (aib_fabric_ssr_load_in_ctrl == 1'b0)
       begin
          aib_fabric_ssr_load_in_ctrl <= (aib_fabric_ssr_load_in_dly == 1'b1) && (aib_fabric_ssr_load_in == 1'b0);
       end
      else begin
          aib_fabric_ssr_load_in_ctrl <= aib_fabric_ssr_load_in_ctrl;
      end
    end

assign aib_fabric_ssr_load_in_gated = aib_fabric_ssr_load_in_ctrl & aib_fabric_ssr_load_in;

assign rx_async_hssi_fabric_ssr_load = aib_fabric_ssr_load_in_gated;
assign tx_async_hssi_fabric_ssr_load = aib_fabric_ssr_load_in_gated;
assign avmm1_hssi_fabric_ssr_load    = aib_fabric_ssr_load_in_gated;
assign avmm2_hssi_fabric_ssr_load    = aib_fabric_ssr_load_in_gated;
assign avmm_hssi_fabric_ssr_load     = aib_fabric_ssr_load_in_gated;

// SSR IN
assign ssrin_parallel_in_temp = {hip_aib_async_ssr_in, ({2{r_sr_reserbits_in_en}} & rx_async_fabric_hssi_ssr_reserved), ({3{r_sr_reserbits_in_en}} & tx_async_fabric_hssi_ssr_reserved), avmm_hrdrst_fabric_osc_transfer_en_ssr_data, rx_async_fabric_hssi_ssr_data[35:32], rx_async_fabric_hssi_ssr_data[30], tx_async_fabric_hssi_ssr_data[35:32], rx_async_fabric_hssi_ssr_data[31], rx_async_fabric_hssi_ssr_data[29:0], tx_async_fabric_hssi_ssr_data[31:0]};

hdpldadapt_cmn_parity_gen 
 #(
     .WIDTH (16)
  )
hdpldadapt_cmn_parity_gen_ssr_in_parity0
(
     // input
     .data (ssrin_parallel_in_temp[15:0]),
     // output
     .parity (ssrin_parity_out[0])
  );

hdpldadapt_cmn_parity_gen
 #(
     .WIDTH (16)
  )
hdpldadapt_cmn_parity_gen_ssr_in_parity1
(
     // input
     .data (ssrin_parallel_in_temp[31:16]),
     // output
     .parity (ssrin_parity_out[1])
  );

hdpldadapt_cmn_parity_gen
 #(
     .WIDTH (16)
  )
hdpldadapt_cmn_parity_gen_ssr_in_parity2
(
     // input
     .data (ssrin_parallel_in_temp[47:32]),
     // output
     .parity (ssrin_parity_out[2])
  );

hdpldadapt_cmn_parity_gen
 #(
     .WIDTH (16)
  )
hdpldadapt_cmn_parity_gen_ssr_in_parity3
(
     // input
     .data (ssrin_parallel_in_temp[63:48]),
     // output
     .parity (ssrin_parity_out[3])
  );

hdpldadapt_cmn_parity_gen
 #(
     .WIDTH (14)
  )
hdpldadapt_cmn_parity_gen_ssr_in_parity4
(
     // input
     .data (ssrin_parallel_in_temp[77:64]),
     // output
     .parity (ssrin_parity_out[4])
  );

assign ssrin_parallel_in = (r_sr_hip_en || !r_sr_parity_en) ? ssrin_parallel_in_temp : {35'd0, ssrin_parity_out, ssrin_parallel_in_temp[(NUM_OF_PCS_CHAIN_SSRIN + NUM_OF_RESERVED_CHAIN_SSRIN - 1):0]};

hdpldadapt_ssr_in
 #(
    .NUM_OF_PCS_CHAIN  (NUM_OF_PCS_CHAIN_SSRIN),
    .NUM_OF_HIP_CHAIN  (NUM_OF_HIP_CHAIN_SSRIN),
    .NUM_OF_RESERVED_CHAIN_SSRIN (NUM_OF_RESERVED_CHAIN_SSRIN),
    .NUM_OF_PARITY_BIT_SSRIN (NUM_OF_PARITY_BIT_SSRIN)
  )
hdpldadapt_ssr_in (
    // input
    .sr_parallel_in(ssrin_parallel_in),
    .sr_load       (aib_fabric_ssr_load_out), // Internal generate load
    .clk           (sr_clock_tx_osc_clk),        // Internal clock. 
    .rst_n         (sr_reset_tx_osc_clk_rst_n),  // Internal reset. 
    .r_sr_hip_en   (r_sr_hip_en),
    .r_sr_parity_en(r_sr_parity_en),
    .r_sr_reserbits_in_en (r_sr_reserbits_in_en),
    // output
    .sr_serial_out (aib_fabric_ssr_data_out)  // To AIB
);

// SSR OUT
assign {hip_aib_async_ssr_out, rx_async_hssi_fabric_ssr_reserved, tx_async_hssi_fabric_ssr_reserved, avmm_hrdrst_hssi_osc_transfer_en_ssr_data, rx_async_hssi_fabric_ssr_data[62:61], tx_async_hssi_fabric_ssr_data[12:9], tx_async_hssi_fabric_ssr_data[5], avmm2_hssi_fabric_ssr_data[1:0], avmm1_hssi_fabric_ssr_data[1:0], rx_async_hssi_fabric_ssr_data[60:0], tx_async_hssi_fabric_ssr_data[8:6], tx_async_hssi_fabric_ssr_data[4:0]} = ssrout_parallel_out;
//Added for AIB spec modeling. 12/27/2018 JZ
always @(negedge sr_reset_rx_osc_clk_rst_n or posedge sr_clock_rx_osc_clk)
  if (sr_reset_rx_osc_clk_rst_n == 1'b0)
    begin
      ssrout_parallel_out_latch <= 94'b0;
    end
  else if (aib_fabric_ssr_load_in)
    begin
      ssrout_parallel_out_latch <= ssrout_parallel_out;
    end

hdpldadapt_ssr_out
 #(
    .NUM_OF_PCS_CHAIN  (NUM_OF_PCS_CHAIN_SSROUT),
    .NUM_OF_HIP_CHAIN  (NUM_OF_HIP_CHAIN_SSROUT),
    .NUM_OF_RESERVED_CHAIN_SSROUT (NUM_OF_RESERVED_CHAIN_SSROUT),
    .NUM_OF_PARITY_BIT_SSROUT (NUM_OF_PARITY_BIT_SSROUT)
  )
hdpldadapt_ssr_out (
    // input
    .sr_serial_in    (aib_fabric_ssr_data_in),
    .sr_load         (aib_fabric_ssr_load_in),     // From AIB load
    .clk             (sr_clock_rx_osc_clk),        // Internal clock. 
    .rst_n           (sr_reset_rx_osc_clk_rst_n),  // Internal reset.
    .r_sr_hip_en     (r_sr_hip_en),
    .r_sr_parity_en  (r_sr_parity_en),
    .r_sr_reserbits_out_en (r_sr_reserbits_out_en),
    // output
    .sr_parallel_out (ssrout_parallel_out)
);

// FSR IN
assign fsrin_parallel_in_temp = {hip_aib_async_fsr_in, rx_async_fabric_hssi_fsr_data, tx_async_fabric_hssi_fsr_data};

hdpldadapt_cmn_parity_gen
 #(
     .WIDTH (4)
  )
hdpldadapt_cmn_parity_gen_fsr_in_parity
(
     // input
     .data (fsrin_parallel_in_temp[3:0]),
     // output
     .parity (fsrin_parity_out)
  );

assign fsrin_parallel_in = (r_sr_hip_en || !r_sr_parity_en) ? fsrin_parallel_in_temp : {3'b000, fsrin_parity_out, fsrin_parallel_in_temp[(NUM_OF_PCS_CHAIN_FSRIN-1):0]};

hdpldadapt_fsr_in
 #(
    .NUM_OF_PCS_CHAIN  (NUM_OF_PCS_CHAIN_FSRIN),
    .NUM_OF_HIP_CHAIN  (NUM_OF_HIP_CHAIN_FSRIN),
    .NUM_OF_PARITY_BIT_FSRIN (NUM_OF_PARITY_BIT_FSRIN)
  )
hdpldadapt_fsr_in (
    // input
    .sr_parallel_in(fsrin_parallel_in),
    .sr_load       (aib_fabric_fsr_load_out),    // Internal generate load
    .clk           (sr_clock_tx_osc_clk),        // Internal clock. 
    .rst_n         (sr_reset_tx_osc_clk_rst_n),  // Internal reset. 
    .r_sr_hip_en   (r_sr_hip_en),
    .r_sr_parity_en(r_sr_parity_en),
    // output
    .sr_serial_out (aib_fabric_fsr_data_out)        // To AIB
);

// FSR OUT
assign {hip_aib_async_fsr_out, rx_async_hssi_fabric_fsr_data, tx_async_hssi_fabric_fsr_data} = fsrout_parallel_out;

hdpldadapt_fsr_out
 #(
    .NUM_OF_PCS_CHAIN  (NUM_OF_PCS_CHAIN_FSROUT),
    .NUM_OF_HIP_CHAIN  (NUM_OF_HIP_CHAIN_FSROUT),
    .NUM_OF_PARITY_BIT_FSROUT (NUM_OF_PARITY_BIT_FSROUT)
  )
hdpldadapt_fsr_out (
    // input
    .sr_serial_in    (aib_fabric_fsr_data_in),
    .sr_load         (aib_fabric_fsr_load_in),     // From AIB load
    .clk             (sr_clock_rx_osc_clk),        // Internal clock. 
    .rst_n           (sr_reset_rx_osc_clk_rst_n),  // Internal reset.
    .r_sr_hip_en     (r_sr_hip_en),
    .r_sr_parity_en  (r_sr_parity_en),
    //.r_sr_bit        (r_fsrout_bit),
    // output
    .sr_parallel_out (fsrout_parallel_out)
);

// SSR SM
hdpldadapt_sr_sm
 #(
    .NUM_OF_PCS_CHAIN  (NUM_OF_PCS_CHAIN_SSRIN),
    .NUM_OF_HIP_CHAIN  (NUM_OF_HIP_CHAIN_SSRIN),
    .NUM_OF_RESERVED_CHAIN_SSRIN (NUM_OF_RESERVED_CHAIN_SSRIN),
    .NUM_OF_PARITY_IN  (NUM_OF_PARITY_BIT_SSRIN)
  )
hdpldadapt_ssr_sm (
    // input
    .clk           (sr_clock_tx_osc_clk),        // Internal clock. 
    .rst_n         (sr_reset_tx_osc_clk_rst_n),  // Internal reset. 
    .r_sr_hip_en   (r_sr_hip_en),
    .r_sr_reserbits_in_en (r_sr_reserbits_in_en),
    .r_sr_parity_en (r_sr_parity_en),
    .avmm_hrdrst_fabric_osc_transfer_en_sync (avmm_hrdrst_fabric_osc_transfer_en_sync),
    // output
    .sr_sm_testbus (slow_sr_sm_testbus),
    .sr_loadout    (aib_fabric_ssr_load_out)
);

assign rx_async_fabric_hssi_ssr_load = aib_fabric_ssr_load_out;
assign tx_async_fabric_hssi_ssr_load = aib_fabric_ssr_load_out;
assign avmm_fabric_hssi_ssr_load     = aib_fabric_ssr_load_out;

// FSR SM
hdpldadapt_sr_sm
 #(
    .NUM_OF_PCS_CHAIN  (NUM_OF_PCS_CHAIN_FSRIN),
    .NUM_OF_HIP_CHAIN  (NUM_OF_HIP_CHAIN_FSRIN),
    .NUM_OF_RESERVED_CHAIN_SSRIN (NUM_OF_RESERVED_CHAIN_SSRIN),
    .NUM_OF_PARITY_IN  (NUM_OF_PARITY_BIT_FSRIN)
  )
hdpldadapt_fsr_sm (
    // input
    .clk           (sr_clock_tx_osc_clk),        // Internal clock. 
    .rst_n         (sr_reset_tx_osc_clk_rst_n),  // Internal reset. 
    .r_sr_hip_en   (r_sr_hip_en),
    .r_sr_reserbits_in_en (1'b0),
    .r_sr_parity_en (r_sr_parity_en),
    .avmm_hrdrst_fabric_osc_transfer_en_sync (avmm_hrdrst_fabric_osc_transfer_en_sync),
    // output
    .sr_sm_testbus (fast_sr_sm_testbus),
    .sr_loadout    (aib_fabric_fsr_load_out)
);

assign rx_async_fabric_hssi_fsr_load = aib_fabric_fsr_load_out;
assign tx_async_fabric_hssi_fsr_load = aib_fabric_fsr_load_out;

// SR CLK
hdpldadapt_srclk_ctl hdpldadapt_srclk_ctl (
     // input
     .dft_adpt_aibiobsr_fastclkn(dft_adpt_aibiobsr_fastclkn),
     .adapter_scan_mode_n(adapter_scan_mode_n),
     .adapter_scan_shift_n(adapter_scan_shift_n),
     .adapter_scan_shift_clk(adapter_scan_shift_clk),
     .adapter_scan_user_clk3(adapter_scan_user_clk3),         // 1GHz
     .adapter_clk_sel_n(adapter_clk_sel_n),
     .adapter_occ_enable(adapter_occ_enable),
     .aib_fabric_rx_sr_clk_in (aib_fabric_rx_sr_clk_in),
     .aib_fabric_tx_sr_clk_in (aib_fabric_tx_sr_clk_in),
     .r_sr_osc_clk_scg_en  (r_sr_osc_clk_scg_en),
     // output
     .aib_fabric_tx_sr_clk_out(aib_fabric_tx_sr_clk_out),
    .sr_clock_reset_rx_osc_clk       (sr_clock_reset_rx_osc_clk),
    .sr_clock_reset_tx_osc_clk       (sr_clock_reset_tx_osc_clk),
     .sr_clock_rx_osc_clk     (sr_clock_rx_osc_clk),
     .sr_clock_tx_osc_clk     (sr_clock_tx_osc_clk)
);

// SR RST
hdpldadapt_srrst_ctl hdpldadapt_srrst_ctl (
    // input
    .adapter_scan_rst_n(adapter_scan_rst_n),
    .adapter_scan_mode_n(adapter_scan_mode_n),
    .csr_rdy_dly_in            (csr_rdy_dly_in),
    .sr_clock_reset_rx_osc_clk       (sr_clock_reset_rx_osc_clk),
    .sr_clock_reset_tx_osc_clk       (sr_clock_reset_tx_osc_clk),
    // output
    .sr_reset_rx_osc_clk_rst_n (sr_reset_rx_osc_clk_rst_n),
    .sr_reset_tx_osc_clk_rst_n (sr_reset_tx_osc_clk_rst_n)
);

// parity checker
//assign ssrin_parallel_in_temp = {hip_aib_async_ssr_out, ({2{r_sr_reserbits_in_en}} & rx_async_hssi_fabric_ssr_reserved), ({3{r_sr_reserbits_in_en}} & tx_async_hssi_fabric_ssr_reserved), avmm_hrdrst_hssi_osc_transfer_en_ssr_data, rx_async_hssi_fabric_ssr_data[62:61], tx_async_hssi_fabric_ssr_data[12:9], tx_async_hssi_fabric_ssr_data[5], avmm2_hssi_fabric_ssr_data[1:0], avmm1_hssi_fabric_ssr_data[1:0], rx_async_hssi_fabric_ssr_data[60:0], tx_async_hssi_fabric_ssr_data[8:6], tx_async_hssi_fabric_ssr_data[4:0]};

assign ssrout_parity_checker = {({2{r_sr_reserbits_in_en}} & rx_ssr_parity_checker_in[64:63]), ({3{r_sr_reserbits_in_en}} & tx_ssr_parity_checker_in[15:13]), sr_hssi_osc_transfer_en, rx_ssr_parity_checker_in[62:61], tx_ssr_parity_checker_in[12:9], tx_ssr_parity_checker_in[5], avmm2_ssr_parity_checker_in[1:0], avmm1_ssr_parity_checker_in[1:0], rx_ssr_parity_checker_in[60:0],tx_ssr_parity_checker_in[8:6], tx_ssr_parity_checker_in[4:0]};

// Qualifier to trigger SSR parity checking
always @(negedge sr_reset_rx_osc_clk_rst_n or posedge sr_clock_rx_osc_clk)
  if (sr_reset_rx_osc_clk_rst_n == 1'b0)
    begin
      ssr_parity_checker_qualifier_dly0 <= 1'b0;
    end
  else
    begin
      if (!ssr_parity_checker_qualifier_dly0)
        ssr_parity_checker_qualifier_dly0 <= aib_fabric_ssr_load_in_gated;
      else
        ssr_parity_checker_qualifier_dly0 <= ssr_parity_checker_qualifier_dly0;
    end

always @(negedge sr_reset_rx_osc_clk_rst_n or posedge sr_clock_rx_osc_clk)
  if (sr_reset_rx_osc_clk_rst_n == 1'b0)
    begin
      ssr_parity_checker_qualifier <= 1'b0;
    end
  else
    begin
      if (!ssr_parity_checker_qualifier)
        ssr_parity_checker_qualifier <= aib_fabric_ssr_load_in_gated && ssr_parity_checker_qualifier_dly0;
      else
        ssr_parity_checker_qualifier <= ssr_parity_checker_qualifier;
    end

hdpldadapt_cmn_parity_checker
 #(
       .WIDTH        (16)
  )
hdpldadapt_cmn_parity_checker_ssr_out_parity0 (
         // input
         .clk              (sr_clock_rx_osc_clk),
         .rst_n            (sr_reset_rx_osc_clk_rst_n),
         .data             (ssrout_parity_checker[15:0]),
         .parity_received  (hip_ssr_parity_checker_in[0]),
         .parity_checker_ena (ssr_parity_checker_qualifier),
         // output
         .parity_error     (ssrout_parity_error_flag[0])
);

hdpldadapt_cmn_parity_checker
 #(
       .WIDTH        (16)
  )
hdpldadapt_cmn_parity_checker_ssr_out_parity1 (
         // input
         .clk              (sr_clock_rx_osc_clk),
         .rst_n            (sr_reset_rx_osc_clk_rst_n),
         .data             (ssrout_parity_checker[31:16]),
         .parity_received  (hip_ssr_parity_checker_in[1]),
         .parity_checker_ena (ssr_parity_checker_qualifier),
         // output
         .parity_error     (ssrout_parity_error_flag[1])
);

hdpldadapt_cmn_parity_checker
 #(
       .WIDTH        (16)
  )
hdpldadapt_cmn_parity_checker_ssr_out_parity2 (
         // input
         .clk              (sr_clock_rx_osc_clk),
         .rst_n            (sr_reset_rx_osc_clk_rst_n),
         .data             (ssrout_parity_checker[47:32]),
         .parity_received  (hip_ssr_parity_checker_in[2]),
         .parity_checker_ena (ssr_parity_checker_qualifier),
         // output
         .parity_error     (ssrout_parity_error_flag[2])
);

hdpldadapt_cmn_parity_checker
 #(
       .WIDTH        (16)
  )
hdpldadapt_cmn_parity_checker_ssr_out_parity3 (
         // input
         .clk              (sr_clock_rx_osc_clk),
         .rst_n            (sr_reset_rx_osc_clk_rst_n),
         .data             (ssrout_parity_checker[63:48]),
         .parity_received  (hip_ssr_parity_checker_in[3]),
         .parity_checker_ena (ssr_parity_checker_qualifier),
         // output
         .parity_error     (ssrout_parity_error_flag[3])
);

hdpldadapt_cmn_parity_checker
 #(
       .WIDTH        (16)
  )
hdpldadapt_cmn_parity_checker_ssr_out_parity4 (
         // input
         .clk              (sr_clock_rx_osc_clk),
         .rst_n            (sr_reset_rx_osc_clk_rst_n),
         .data             (ssrout_parity_checker[79:64]),
         .parity_received  (hip_ssr_parity_checker_in[4]),
         .parity_checker_ena (ssr_parity_checker_qualifier),
         // output
         .parity_error     (ssrout_parity_error_flag[4])
);

hdpldadapt_cmn_parity_checker
 #(
       .WIDTH        (6)
  )
hdpldadapt_cmn_parity_checker_ssr_out_parity5 (
         // input
         .clk              (sr_clock_rx_osc_clk),
         .rst_n            (sr_reset_rx_osc_clk_rst_n),
         .data             (ssrout_parity_checker[85:80]),
         .parity_received  (hip_ssr_parity_checker_in[5]),
         .parity_checker_ena (ssr_parity_checker_qualifier),
         // output
         .parity_error     (ssrout_parity_error_flag[5])
);

assign fsrout_parity_checker = {rx_fsr_parity_checker_in, tx_fsr_parity_checker_in};

// Qualifier to trigger FSR parity checking
always @(negedge sr_reset_rx_osc_clk_rst_n or posedge sr_clock_rx_osc_clk)
  if (sr_reset_rx_osc_clk_rst_n == 1'b0)
    begin
      fsr_parity_checker_qualifier_dly0 <= 1'b0;
    end
  else
    begin
      if (!fsr_parity_checker_qualifier_dly0)
        fsr_parity_checker_qualifier_dly0 <= aib_fabric_fsr_load_in_gated;
      else
        fsr_parity_checker_qualifier_dly0 <= fsr_parity_checker_qualifier_dly0;
    end

always @(negedge sr_reset_rx_osc_clk_rst_n or posedge sr_clock_rx_osc_clk)
  if (sr_reset_rx_osc_clk_rst_n == 1'b0)
    begin
      fsr_parity_checker_qualifier <= 1'b0;
    end
  else
    begin
      if (!fsr_parity_checker_qualifier)
        fsr_parity_checker_qualifier <= aib_fabric_fsr_load_in_gated && fsr_parity_checker_qualifier_dly0;
      else
        fsr_parity_checker_qualifier <= fsr_parity_checker_qualifier;
    end


hdpldadapt_cmn_parity_checker
 #(
       .WIDTH        (3)
  )
hdpldadapt_cmn_parity_checker_fsr_out_parity (
         // input
         .clk              (sr_clock_rx_osc_clk),
         .rst_n            (sr_reset_rx_osc_clk_rst_n),
         .data             (fsrout_parity_checker),
         .parity_received  (hip_fsr_parity_checker_in),
         .parity_checker_ena (fsr_parity_checker_qualifier),
         // output
         .parity_error     (fsrout_parity_error_flag)
);

assign sr_parity_error_flag = { 11'd0, avmm2_transfer_error, avmm1_transfer_error, ({ssrout_parity_error_flag[5:0], fsrout_parity_error_flag} & {7{r_sr_parity_en}})};

endmodule
