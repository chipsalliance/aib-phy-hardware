// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3aibadapt_sr (
  // DPRIO
  input  wire           r_sr_hip_en,
  input  wire           r_sr_parity_en,
  input  wire           r_sr_reserbits_in_en, 
  input  wire           r_sr_reserbits_out_en, 
  input  wire           r_sr_osc_clk_scg_en,
  input	 wire [1:0]	r_sr_osc_clk_div_sel,
  input	 wire		r_sr_free_run_div_clk,
  
  // AIB_IF
  input	 wire		aib_hssi_fsr_data_in,
  input	 wire		aib_hssi_fsr_load_in,
  input	 wire		aib_hssi_tx_sr_clk_in,
  input	 wire		aib_hssi_rx_sr_clk_in,
  input	 wire		aib_hssi_ssr_data_in,
  input	 wire		aib_hssi_ssr_load_in,
  output wire	        aib_hssi_tx_sr_clk_out,
  
  output wire           sr_clock_aib_rx_sr_clk,
  // AVMM
  input  wire           avmm_hrdrst_hssi_osc_transfer_en_ssr_data, 
  input  wire           avmm_hrdrst_hssi_osc_transfer_en_sync,
  input  wire           sr_fabric_osc_transfer_en,
  
  // AVMM1
  input	 wire   [1:0]	avmm1_hssi_fabric_ssr_data,
  
  // AVMM2
  input	wire	[1:0]	avmm2_hssi_fabric_ssr_data,
  
  // TX - HIP IF
  input  wire   [3:0]   hip_aib_async_fsr_out,
  input  wire   [7:0]   hip_aib_async_ssr_out,
  
  // RX_ASYNC
  input	 wire   [1:0]   rx_async_hssi_fabric_fsr_data,
  input	 wire   [62:0]	rx_async_hssi_fabric_ssr_data,
  input	 wire   [1:0]	rx_async_hssi_fabric_ssr_reserved, 
  input  wire   [2:0]   rx_fsr_parity_checker_in,
  input  wire   [37:0]  rx_ssr_parity_checker_in,
  
  // TX_ASYNC
  input	 wire		tx_async_hssi_fabric_fsr_data,
  input	 wire   [12:0]  tx_async_hssi_fabric_ssr_data,
  input	 wire   [2:0]   tx_async_hssi_fabric_ssr_reserved, 
  input  wire           tx_fsr_parity_checker_in,
  input  wire   [38:0]  tx_ssr_parity_checker_in,
  input  wire           hip_fsr_parity_checker_in,
  input  wire   [4:0]   hip_ssr_parity_checker_in,
  
  // uC
  input	wire		csr_rdy_dly_in,
  
  // Status Registers
  input   wire          sr_dprio_status_write_en,
  
  // DFT
  input  wire           scan_mode_n,
  input  wire [6:0]     t0_tst_tcm_ctrl,
  input  wire           t0_test_clk,
  input  wire           t0_scan_clk,
  input  wire [6:0]     t1_tst_tcm_ctrl,
  input  wire           t1_test_clk,
  input  wire           t1_scan_clk,
  input  wire [6:0]     t2_tst_tcm_ctrl,
  input  wire           t2_test_clk,
  input  wire           t2_scan_clk,
  input  wire [6:0]     t3_tst_tcm_ctrl,
  input  wire           t3_test_clk,
  input  wire           t3_scan_clk,
  
  input  wire           dft_adpt_rst,
  input  wire           adpt_scan_rst_n,
  
  output wire		sr_clock_tx_sr_clk_in_div2,
  output wire		sr_clock_tx_sr_clk_in_div4,
  output wire		sr_clock_tx_osc_clk_or_clkdiv,
  
  // Status Registers
  output wire [7:0]     sr_dprio_status,   
  output wire           sr_dprio_status_write_en_ack,
  
  // AIB_IF
  output wire		aib_hssi_fsr_data_out,
  output wire		aib_hssi_fsr_load_out,
  output wire		aib_hssi_ssr_data_out,
  output wire		aib_hssi_ssr_load_out,
  
  // HIP IF
  output wire   [3:0]   hip_aib_async_fsr_in, 
  output wire   [39:0]  hip_aib_async_ssr_in,
  
  // AVMM 
  output wire           avmm1_async_hssi_fabric_ssr_load, // For capture logic
  output wire           avmm2_async_hssi_fabric_ssr_load, // For capture logic
  output wire           avmm_async_fabric_hssi_ssr_load,  // For update logic 
  output wire           avmm_hrdrst_fabric_osc_transfer_en_ssr_data, 
  output wire           avmm_async_hssi_fabric_ssr_load, //  for capture logic 
  output wire   [7:0]   sr_testbus,
  
  // RX_ASYNC
  output wire   [2:0]	rx_async_fabric_hssi_fsr_data, 
  output wire      	rx_async_fabric_hssi_fsr_load,  // For update logic
  output wire   [35:0]	rx_async_fabric_hssi_ssr_data,   
  output wire   [1:0]	rx_async_fabric_hssi_ssr_reserved,  
  output wire		rx_async_fabric_hssi_ssr_load,  // For update logic
  output wire           rx_async_hssi_fabric_fsr_load,  // For capture logic
  output wire           rx_async_hssi_fabric_ssr_load,  // For capture logic
  output wire   [5:0]   sr_parity_error_flag,
  
  // TX_ASYNC
  output wire		tx_async_fabric_hssi_fsr_data,
  output wire		tx_async_fabric_hssi_fsr_load,  // For Update logic
  output wire  [35:0]	tx_async_fabric_hssi_ssr_data,  
  output wire  [2:0]	tx_async_fabric_hssi_ssr_reserved, 
  output wire		tx_async_fabric_hssi_ssr_load,  // For update logic
  output wire           tx_async_hssi_fabric_fsr_load,  // For capture logic
  output wire           tx_async_hssi_fabric_ssr_load   // For capture logic
);


localparam NUM_OF_PCS_CHAIN_SSRIN  = 7'd81;
localparam NUM_OF_RESERVED_CHAIN_SSRIN  = 7'd5;
localparam NUM_OF_HIP_CHAIN_SSRIN  = 7'd8;
localparam NUM_OF_PCS_CHAIN_SSROUT = 7'd73;
localparam NUM_OF_RESERVED_CHAIN_SSROUT = 7'd5;
localparam NUM_OF_HIP_CHAIN_SSROUT = 7'd40;

localparam NUM_OF_PCS_CHAIN_FSRIN  = 7'd3;
localparam NUM_OF_HIP_CHAIN_FSRIN  = 7'd4;
localparam NUM_OF_PCS_CHAIN_FSROUT = 7'd4;
localparam NUM_OF_HIP_CHAIN_FSROUT = 7'd4;

localparam NUM_OF_PARITY_BIT_SSRIN  = 7'd6;
localparam NUM_OF_PARITY_BIT_FSRIN  = 7'd1;
localparam NUM_OF_PARITY_BIT_SSROUT = 7'd5;
localparam NUM_OF_PARITY_BIT_FSROUT = 7'd1;

wire [(NUM_OF_PCS_CHAIN_SSRIN  + NUM_OF_HIP_CHAIN_SSRIN  + NUM_OF_RESERVED_CHAIN_SSRIN  - 1):0]   ssrin_parallel_in;
wire [(NUM_OF_PCS_CHAIN_SSRIN  + NUM_OF_HIP_CHAIN_SSRIN  + NUM_OF_RESERVED_CHAIN_SSRIN  - 1):0]   ssrin_parallel_in_temp;
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

wire sr_parity_error_flag_temp;

wire sr_clock_tx_sr_clk_in;
wire sr_clock_reset_tx_osc_clk;
wire sr_clock_reset_rx_osc_clk;
wire sr_clock_tx_osc_clk;
wire sr_clock_rx_osc_clk;
wire sr_reset_tx_sr_clk_in_rst_n;
wire sr_reset_tx_osc_clk_rst_n;
wire sr_reset_rx_osc_clk_rst_n;

wire [3:0] ssr_sr_testbus;
wire [3:0] fsr_sr_testbus;
//wire [7:0] sr_testbus;

// Feedthrough 
reg aib_hssi_fsr_load_in_dly;
reg aib_hssi_fsr_load_in_ctrl;
wire aib_hssi_fsr_load_in_gated;

reg aib_hssi_ssr_load_in_dly;
reg aib_hssi_ssr_load_in_ctrl;
wire aib_hssi_ssr_load_in_gated;

reg ssr_parity_checker_qualifier_dly0;
reg ssr_parity_checker_qualifier;

reg fsr_parity_checker_qualifier_dly0;
reg fsr_parity_checker_qualifier;


assign sr_testbus = {fsr_sr_testbus, ssr_sr_testbus};

// Fast Load
always @(negedge sr_reset_rx_osc_clk_rst_n or posedge sr_clock_rx_osc_clk)
  if (sr_reset_rx_osc_clk_rst_n == 1'b0)
    begin
      aib_hssi_fsr_load_in_dly <= 1'b0;
    end
  else
    begin
      aib_hssi_fsr_load_in_dly <= aib_hssi_fsr_load_in;
    end

always @(negedge sr_reset_rx_osc_clk_rst_n or posedge sr_clock_rx_osc_clk)
  if (sr_reset_rx_osc_clk_rst_n == 1'b0)
    begin
      aib_hssi_fsr_load_in_ctrl <= 1'b0;
    end
  else
    begin
      if (!aib_hssi_fsr_load_in_ctrl)
       begin
          aib_hssi_fsr_load_in_ctrl <= (aib_hssi_fsr_load_in_dly == 1'b1) & (aib_hssi_fsr_load_in == 1'b0);
       end
      else begin
          aib_hssi_fsr_load_in_ctrl <= aib_hssi_fsr_load_in_ctrl; 
      end
    end

assign aib_hssi_fsr_load_in_gated = aib_hssi_fsr_load_in_ctrl & aib_hssi_fsr_load_in;

assign rx_async_fabric_hssi_fsr_load    = aib_hssi_fsr_load_in_gated;
assign tx_async_fabric_hssi_fsr_load    = aib_hssi_fsr_load_in_gated;

// Slow Load
always @(negedge sr_reset_rx_osc_clk_rst_n or posedge sr_clock_rx_osc_clk)
  if (sr_reset_rx_osc_clk_rst_n == 1'b0)
    begin
      aib_hssi_ssr_load_in_dly <= 1'b0;
    end
  else
    begin
      aib_hssi_ssr_load_in_dly <= aib_hssi_ssr_load_in;
    end

always @(negedge sr_reset_rx_osc_clk_rst_n or posedge sr_clock_rx_osc_clk)
  if (sr_reset_rx_osc_clk_rst_n == 1'b0)
    begin
      aib_hssi_ssr_load_in_ctrl <= 1'b0;
    end
  else
    begin
      if (!aib_hssi_ssr_load_in_ctrl)
       begin
          aib_hssi_ssr_load_in_ctrl <= (aib_hssi_ssr_load_in_dly == 1'b1) & (aib_hssi_ssr_load_in == 1'b0);
       end
      else begin
          aib_hssi_ssr_load_in_ctrl <= aib_hssi_ssr_load_in_ctrl; 
      end
    end

assign aib_hssi_ssr_load_in_gated = aib_hssi_ssr_load_in_ctrl & aib_hssi_ssr_load_in;

assign rx_async_fabric_hssi_ssr_load    = aib_hssi_ssr_load_in_gated;
assign tx_async_fabric_hssi_ssr_load    = aib_hssi_ssr_load_in_gated;
assign avmm_async_fabric_hssi_ssr_load  = aib_hssi_ssr_load_in_gated;

// SSR IN
assign ssrin_parallel_in_temp = {hip_aib_async_ssr_out, ({2{r_sr_reserbits_in_en}} & rx_async_hssi_fabric_ssr_reserved), ({3{r_sr_reserbits_in_en}} & tx_async_hssi_fabric_ssr_reserved), avmm_hrdrst_hssi_osc_transfer_en_ssr_data, rx_async_hssi_fabric_ssr_data[62:61], tx_async_hssi_fabric_ssr_data[12:9], tx_async_hssi_fabric_ssr_data[5], avmm2_hssi_fabric_ssr_data[1:0], avmm1_hssi_fabric_ssr_data[1:0], rx_async_hssi_fabric_ssr_data[60:0], tx_async_hssi_fabric_ssr_data[8:6], tx_async_hssi_fabric_ssr_data[4:0]};


c3aibadapt_cmn_parity_gen 
 #(
     .WIDTH (16)
  )
adapt_cmn_parity_gen_ssr_in_parity0 (
     // input
     .data (ssrin_parallel_in_temp[15:0]), 
    // output
     .parity (ssrin_parity_out[0])
  );
 
c3aibadapt_cmn_parity_gen
 #(
     .WIDTH (16)
  )
adapt_cmn_parity_gen_ssr_in_parity1 (
     // input
     .data (ssrin_parallel_in_temp[31:16]),
    // output
     .parity (ssrin_parity_out[1])
  );

c3aibadapt_cmn_parity_gen
 #(
     .WIDTH (16)
  )
adapt_cmn_parity_gen_ssr_in_parity2 (
     // input
     .data (ssrin_parallel_in_temp[47:32]),
    // output
     .parity (ssrin_parity_out[2])
  );

c3aibadapt_cmn_parity_gen
 #(
     .WIDTH (16)
  )
adapt_cmn_parity_gen_ssr_in_parity3 (
     // input
     .data (ssrin_parallel_in_temp[63:48]),
    // output
     .parity (ssrin_parity_out[3])
  );

c3aibadapt_cmn_parity_gen
 #(
     .WIDTH (16)
  )
adapt_cmn_parity_gen_ssr_in_parity4 (
     // input
     .data (ssrin_parallel_in_temp[79:64]),
    // output
     .parity (ssrin_parity_out[4])
  );

c3aibadapt_cmn_parity_gen
 #(
     .WIDTH (6)
  )
adapt_cmn_parity_gen_ssr_in_parity5 (
     // input
     .data (ssrin_parallel_in_temp[85:80]),
    // output
     .parity (ssrin_parity_out[5])
  );

assign ssrin_parallel_in = (r_sr_hip_en || !r_sr_parity_en) ? ssrin_parallel_in_temp : {2'b00, ssrin_parity_out, ssrin_parallel_in_temp[(NUM_OF_PCS_CHAIN_SSRIN + NUM_OF_RESERVED_CHAIN_SSRIN - 1):0]}; 

c3aibadapt_ssr_in
 #(
    .NUM_OF_PCS_CHAIN  (NUM_OF_PCS_CHAIN_SSRIN),
    .NUM_OF_HIP_CHAIN  (NUM_OF_HIP_CHAIN_SSRIN),
    .NUM_OF_RESERVED_CHAIN_SSRIN (NUM_OF_RESERVED_CHAIN_SSRIN),
    .NUM_OF_PARITY_BIT_SSRIN (NUM_OF_PARITY_BIT_SSRIN)
  )
adapt_ssr_in (
    // input
    .sr_parallel_in(ssrin_parallel_in),
    .sr_load       (aib_hssi_ssr_load_out),       // Internal generate load
    .clk           (sr_clock_tx_osc_clk),        // Internal clock.
    .rst_n         (sr_reset_tx_osc_clk_rst_n),  // Internal reset.
    .r_sr_hip_en   (r_sr_hip_en),
    .r_sr_parity_en(r_sr_parity_en),
    .r_sr_reserbits_in_en (r_sr_reserbits_in_en),
    // output
    .sr_serial_out (aib_hssi_ssr_data_out)        // To AIB
);

// SSR OUT
assign {hip_aib_async_ssr_in, 
        rx_async_fabric_hssi_ssr_reserved, 
        tx_async_fabric_hssi_ssr_reserved, 
        avmm_hrdrst_fabric_osc_transfer_en_ssr_data, 
        rx_async_fabric_hssi_ssr_data[35:32], 
        rx_async_fabric_hssi_ssr_data[30], 
        tx_async_fabric_hssi_ssr_data[35:32], 
        rx_async_fabric_hssi_ssr_data[31], 
        rx_async_fabric_hssi_ssr_data[29:0], 
        tx_async_fabric_hssi_ssr_data[31:0]} = ssrout_parallel_out;

c3aibadapt_ssr_out 
 #(
    .NUM_OF_PCS_CHAIN  (NUM_OF_PCS_CHAIN_SSROUT),
    .NUM_OF_HIP_CHAIN  (NUM_OF_HIP_CHAIN_SSROUT),
    .NUM_OF_RESERVED_CHAIN_SSROUT (NUM_OF_RESERVED_CHAIN_SSROUT),
    .NUM_OF_PARITY_BIT_SSROUT (NUM_OF_PARITY_BIT_SSROUT)
  )
adapt_ssr_out (
    // input
    .sr_serial_in    (aib_hssi_ssr_data_in),
    .sr_load         (aib_hssi_ssr_load_in),       // From AIB load
    .clk             (sr_clock_rx_osc_clk),        // Internal clock.
    .rst_n           (sr_reset_rx_osc_clk_rst_n),  // Internal reset.
    .r_sr_hip_en     (r_sr_hip_en),
    .r_sr_parity_en  (r_sr_parity_en),
    .r_sr_reserbits_out_en (r_sr_reserbits_out_en),
    // output
    .sr_parallel_out (ssrout_parallel_out)
);

// FSR IN
assign fsrin_parallel_in_temp = {hip_aib_async_fsr_out, rx_async_hssi_fabric_fsr_data, tx_async_hssi_fabric_fsr_data};

c3aibadapt_cmn_parity_gen #( .WIDTH (3))
  adapt_cmn_parity_gen_fsr_in_parity (
    // input
    .data (fsrin_parallel_in_temp[2:0]),
    // output
    .parity (fsrin_parity_out));

assign fsrin_parallel_in = (r_sr_hip_en || !r_sr_parity_en) ? fsrin_parallel_in_temp : {3'b000, fsrin_parity_out, fsrin_parallel_in_temp[(NUM_OF_PCS_CHAIN_FSRIN-1):0]};

c3aibadapt_fsr_in 
 #(
    .NUM_OF_PCS_CHAIN  (NUM_OF_PCS_CHAIN_FSRIN),
    .NUM_OF_HIP_CHAIN  (NUM_OF_HIP_CHAIN_FSRIN),
    .NUM_OF_PARITY_BIT_FSRIN (NUM_OF_PARITY_BIT_FSRIN)
  )
  adapt_fsr_in (
    // input
    .sr_parallel_in(fsrin_parallel_in),
    .sr_load       (aib_hssi_fsr_load_out),       // Internal generate load
    .clk           (sr_clock_tx_osc_clk),        // Internal clock. 
    .rst_n         (sr_reset_tx_osc_clk_rst_n),  // Internal reset.
    .r_sr_hip_en   (r_sr_hip_en),
    .r_sr_parity_en(r_sr_parity_en),
    // output
    .sr_serial_out (aib_hssi_fsr_data_out)        // To AIB
);

// FSR OUT
assign {hip_aib_async_fsr_in, rx_async_fabric_hssi_fsr_data, tx_async_fabric_hssi_fsr_data} = fsrout_parallel_out;

c3aibadapt_fsr_out
 #(
    .NUM_OF_PCS_CHAIN  (NUM_OF_PCS_CHAIN_FSROUT),
    .NUM_OF_HIP_CHAIN  (NUM_OF_HIP_CHAIN_FSROUT),
    .NUM_OF_PARITY_BIT_FSROUT (NUM_OF_PARITY_BIT_FSROUT)
  )
adapt_fsr_out (
    // input
    .sr_serial_in    (aib_hssi_fsr_data_in),
    .sr_load         (aib_hssi_fsr_load_in),       // From AIB load
    .clk             (sr_clock_rx_osc_clk),        // Internal clock.
    .rst_n           (sr_reset_rx_osc_clk_rst_n),  // Internal reset.
    .r_sr_hip_en     (r_sr_hip_en),
    .r_sr_parity_en  (r_sr_parity_en),
    // output
    .sr_parallel_out (fsrout_parallel_out)
);

// SSR SM
c3aibadapt_sr_sm 
 #(
    .NUM_OF_PCS_CHAIN  (NUM_OF_PCS_CHAIN_SSRIN),
    .NUM_OF_HIP_CHAIN  (NUM_OF_HIP_CHAIN_SSRIN),
    .NUM_OF_PARITY_IN  (NUM_OF_PARITY_BIT_SSRIN),
    .NUM_OF_RESERVED_CHAIN_SSRIN (NUM_OF_RESERVED_CHAIN_SSRIN)
  )
adapt_ssr_sm (
    // input
    .clk           (sr_clock_tx_osc_clk),        // Internal clock.
    .rst_n         (sr_reset_tx_osc_clk_rst_n),  // Internal reset
    .r_sr_hip_en   (r_sr_hip_en),
    .r_sr_parity_en (r_sr_parity_en),
    .r_sr_reserbits_in_en (r_sr_reserbits_in_en),
    .avmm_hrdrst_hssi_osc_transfer_en_sync (avmm_hrdrst_hssi_osc_transfer_en_sync),
    // output
    .sr_testbus    (ssr_sr_testbus),
    .sr_loadout    (aib_hssi_ssr_load_out)
);

assign avmm1_async_hssi_fabric_ssr_load = aib_hssi_ssr_load_out;
assign avmm2_async_hssi_fabric_ssr_load = aib_hssi_ssr_load_out;
assign rx_async_hssi_fabric_ssr_load = aib_hssi_ssr_load_out;
assign tx_async_hssi_fabric_ssr_load = aib_hssi_ssr_load_out;
assign avmm_async_hssi_fabric_ssr_load = aib_hssi_ssr_load_out;

// FSR SM
c3aibadapt_sr_sm  
 #(
    .NUM_OF_PCS_CHAIN  (NUM_OF_PCS_CHAIN_FSRIN),
    .NUM_OF_HIP_CHAIN  (NUM_OF_HIP_CHAIN_FSRIN),
    .NUM_OF_PARITY_IN  (NUM_OF_PARITY_BIT_FSRIN),
    .NUM_OF_RESERVED_CHAIN_SSRIN (NUM_OF_RESERVED_CHAIN_SSRIN)
  )
adapt_fsr_sm (
    // input
    .clk           (sr_clock_tx_osc_clk),        // Internal clock.
    .rst_n         (sr_reset_tx_osc_clk_rst_n),  // Internal reset.
    .r_sr_hip_en   (r_sr_hip_en),
    .r_sr_parity_en (r_sr_parity_en),
    .r_sr_reserbits_in_en (1'b0),
    .avmm_hrdrst_hssi_osc_transfer_en_sync (avmm_hrdrst_hssi_osc_transfer_en_sync),
    // output
    .sr_testbus    (fsr_sr_testbus),
    .sr_loadout    (aib_hssi_fsr_load_out)
);

assign rx_async_hssi_fabric_fsr_load = aib_hssi_fsr_load_out;
assign tx_async_hssi_fabric_fsr_load = aib_hssi_fsr_load_out;


// SR CLK
c3aibadapt_srclk_ctl adapt_srclk_ctl (
   // input
   .scan_mode_n                     (scan_mode_n),
   .t0_tst_tcm_ctrl                 (t0_tst_tcm_ctrl),
   .t0_test_clk                     (t0_test_clk),
   .t0_scan_clk                     (t0_scan_clk),
   .t1_tst_tcm_ctrl                 (t1_tst_tcm_ctrl),
   .t1_test_clk                     (t1_test_clk),
   .t1_scan_clk                     (t1_scan_clk),
   .t2_tst_tcm_ctrl                 (t2_tst_tcm_ctrl),
   .t2_test_clk                     (t2_test_clk),
   .t2_scan_clk                     (t2_scan_clk),
   .t3_tst_tcm_ctrl                 (t3_tst_tcm_ctrl),
   .t3_test_clk                     (t3_test_clk),
   .t3_scan_clk                     (t3_scan_clk),
   .aib_hssi_tx_sr_clk_in           (aib_hssi_tx_sr_clk_in),
   .aib_hssi_rx_sr_clk_in           (aib_hssi_rx_sr_clk_in),
   .sr_reset_tx_sr_clk_in_rst_n     (sr_reset_tx_sr_clk_in_rst_n),
   .r_sr_osc_clk_scg_en             (r_sr_osc_clk_scg_en),
   .r_sr_osc_clk_div_sel            (r_sr_osc_clk_div_sel),
   // output
   .aib_hssi_tx_sr_clk_out          (aib_hssi_tx_sr_clk_out),
   .sr_clock_aib_rx_sr_clk          (sr_clock_aib_rx_sr_clk),
   .sr_clock_tx_sr_clk_in           (sr_clock_tx_sr_clk_in),
   .sr_clock_reset_rx_osc_clk       (sr_clock_reset_rx_osc_clk),
   .sr_clock_reset_tx_osc_clk       (sr_clock_reset_tx_osc_clk),
   .sr_clock_tx_sr_clk_in_div2      (sr_clock_tx_sr_clk_in_div2),
   .sr_clock_tx_sr_clk_in_div4      (sr_clock_tx_sr_clk_in_div4),
   .sr_clock_tx_osc_clk_or_clkdiv   (sr_clock_tx_osc_clk_or_clkdiv),
   .sr_clock_rx_osc_clk             (sr_clock_rx_osc_clk),
   .sr_clock_tx_osc_clk             (sr_clock_tx_osc_clk));

// SR RST
c3aibadapt_srrst_ctl adapt_srrst_ctl (
     // input
    .dft_adpt_rst                (dft_adpt_rst),
    .adapter_scan_rst_n          (adpt_scan_rst_n),
    .adapter_scan_mode_n         (scan_mode_n),
    .csr_rdy_dly_in              (csr_rdy_dly_in),
    .sr_clock_tx_sr_clk_in       (sr_clock_tx_sr_clk_in),
    .sr_clock_reset_rx_osc_clk   (sr_clock_reset_rx_osc_clk),
    .sr_clock_reset_tx_osc_clk   (sr_clock_reset_tx_osc_clk),
    .r_sr_free_run_div_clk       (r_sr_free_run_div_clk),
    // output
    .sr_reset_tx_sr_clk_in_rst_n (sr_reset_tx_sr_clk_in_rst_n),
    .sr_reset_rx_osc_clk_rst_n   (sr_reset_rx_osc_clk_rst_n),
    .sr_reset_tx_osc_clk_rst_n   (sr_reset_tx_osc_clk_rst_n)
);

// Status Registers
c3aibadapt_cmn_shadow_status_regs #( .DATA_WIDTH  (8))
   shadow_status_regs_sr (
     // input
     .rst_n          (sr_reset_tx_osc_clk_rst_n),  // reset
     .clk            (sr_clock_tx_osc_clk),        // clock
     .stat_data_in   (sr_testbus),                 // status data input
     .write_en       (sr_dprio_status_write_en),   // write data enable from DPRIO
     // output
     .write_en_ack   (sr_dprio_status_write_en_ack),  // write data enable acknowlege to DPRIO
     .stat_data_out  (sr_dprio_status)                // status data output
     );

// parity checker
//assign ssrin_parallel_in_temp = {hip_aib_async_ssr_in, ({2{r_sr_reserbits_in_en}} & rx_async_fabric_hssi_ssr_reserved), ({3{r_sr_reserbits_in_en}} & tx_async_fabric_hssi_ssr_reserved), avmm_hrdrst_fabric_osc_transfer_en_ssr_data, rx_async_fabric_hssi_ssr_data[35:32], rx_async_fabric_hssi_ssr_data[30], tx_async_fabric_hssi_ssr_data[35:32], rx_async_fabric_hssi_ssr_data[31], rx_async_fabric_hssi_ssr_data[29:0], tx_async_fabric_hssi_ssr_data[31:0]};

assign ssrout_parity_checker = {({2{r_sr_reserbits_in_en}} & rx_ssr_parity_checker_in[37:36]), 
                                ({3{r_sr_reserbits_in_en}} & tx_ssr_parity_checker_in[38:36]), 
                                    sr_fabric_osc_transfer_en, rx_ssr_parity_checker_in[35:32], 
                                    rx_ssr_parity_checker_in[30], tx_ssr_parity_checker_in[35:32], 
                                    rx_ssr_parity_checker_in[31], rx_ssr_parity_checker_in[29:0], 
                                    tx_ssr_parity_checker_in[31:0]}; 

// Qualifier to trigger SSR parity checking
always @(negedge sr_reset_rx_osc_clk_rst_n or posedge sr_clock_rx_osc_clk)
  if (sr_reset_rx_osc_clk_rst_n == 1'b0)
    begin
      ssr_parity_checker_qualifier_dly0 <= 1'b0;
    end
  else
    begin
      if (!ssr_parity_checker_qualifier_dly0)
        ssr_parity_checker_qualifier_dly0 <= aib_hssi_ssr_load_in_gated;
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
        ssr_parity_checker_qualifier <= aib_hssi_ssr_load_in_gated && ssr_parity_checker_qualifier_dly0;
      else
        ssr_parity_checker_qualifier <= ssr_parity_checker_qualifier;
    end



c3aibadapt_cmn_parity_checker 
 #(
       .WIDTH        (16)
  )
adapt_cmn_parity_checker_parity0 (
         // input
         .clk              (sr_clock_rx_osc_clk),
         .rst_n            (sr_reset_rx_osc_clk_rst_n),
         .data             (ssrout_parity_checker[15:0]),
         .parity_received  (hip_ssr_parity_checker_in[0]),
         .parity_checker_ena (ssr_parity_checker_qualifier),
         // output
         .parity_error     (ssrout_parity_error_flag[0])
);

c3aibadapt_cmn_parity_checker
 #(
       .WIDTH        (16)
  )
adapt_cmn_parity_checker_parity1 (
         // input
         .clk              (sr_clock_rx_osc_clk),
         .rst_n            (sr_reset_rx_osc_clk_rst_n),
         .data             (ssrout_parity_checker[31:16]),
         .parity_received  (hip_ssr_parity_checker_in[1]),
         .parity_checker_ena (ssr_parity_checker_qualifier),
         // output
         .parity_error     (ssrout_parity_error_flag[1])
);


c3aibadapt_cmn_parity_checker
 #(
       .WIDTH        (16)
  )
adapt_cmn_parity_checker_parity2 (
         // input
         .clk              (sr_clock_rx_osc_clk),
         .rst_n            (sr_reset_rx_osc_clk_rst_n),
         .data             (ssrout_parity_checker[47:32]),
         .parity_received  (hip_ssr_parity_checker_in[2]),
         .parity_checker_ena (ssr_parity_checker_qualifier),
         // output
         .parity_error     (ssrout_parity_error_flag[2])
);


c3aibadapt_cmn_parity_checker
 #(
       .WIDTH        (16)
  )
adapt_cmn_parity_checker_ssr_out_parity3 (
         // input
         .clk              (sr_clock_rx_osc_clk),
         .rst_n            (sr_reset_rx_osc_clk_rst_n),
         .data             (ssrout_parity_checker[63:48]),
         .parity_received  (hip_ssr_parity_checker_in[3]),
         .parity_checker_ena (ssr_parity_checker_qualifier),
         // output
         .parity_error     (ssrout_parity_error_flag[3])
);


c3aibadapt_cmn_parity_checker
 #(
       .WIDTH        (14)
  )
adapt_cmn_parity_checker_ssr_out_parity4 (
         // input
         .clk              (sr_clock_rx_osc_clk),
         .rst_n            (sr_reset_rx_osc_clk_rst_n),
         .data             (ssrout_parity_checker[77:64]),
         .parity_received  (hip_ssr_parity_checker_in[4]),
         .parity_checker_ena (ssr_parity_checker_qualifier),
         // output
         .parity_error     (ssrout_parity_error_flag[4])
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
        fsr_parity_checker_qualifier_dly0 <= aib_hssi_fsr_load_in_gated;
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
        fsr_parity_checker_qualifier <= aib_hssi_fsr_load_in_gated && fsr_parity_checker_qualifier_dly0;
      else
        fsr_parity_checker_qualifier <= fsr_parity_checker_qualifier;
    end

c3aibadapt_cmn_parity_checker
 #(
       .WIDTH        (4)
  )
adapt_cmn_parity_checker_fsr_out_parity (
         // input
         .clk              (sr_clock_rx_osc_clk),
         .rst_n            (sr_reset_rx_osc_clk_rst_n),
         .data             (fsrout_parity_checker),
         .parity_received  (hip_fsr_parity_checker_in),
         .parity_checker_ena (fsr_parity_checker_qualifier),
         // output
         .parity_error     (fsrout_parity_error_flag)
);

assign sr_parity_error_flag = {ssrout_parity_error_flag[4:0], fsrout_parity_error_flag} & {6{r_sr_parity_en}};

endmodule
