// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3aibadapt_avmm1clk_ctl (
  input  wire [`TCM_WRAP_CTRL_RNG] tst_tcm_ctrl,
  input  wire                      test_clk,
  input  wire                      scan_clk,
  input  wire		           aib_hssi_rx_sr_clk_in,
  input  wire                      sr_clock_aib_rx_sr_clk,
  input  wire		           sr_clock_tx_osc_clk_or_clkdiv,
  input  wire		           avmm_reset_avmm_rst_n,
  input  wire		           avmm_reset_rx_osc_clk_for_clkdiv_rst_n,
  input  wire		           avmm_transfer_dcg_ungate,
  input  wire		           avmm_transfer_dcg_gate,
  input  wire		           r_avmm_osc_clk_scg_en,
  input  wire		           r_avmm_avmm_clk_scg_en,	
  input  wire                      r_avmm_avmm_clk_dcg_en,
  input  wire                      scan_mode_n,
  output wire	                   avmm_clock_reset_tx_osc_clk,
  output wire	                   avmm_clock_reset_rx_osc_clk,
  output wire	                   avmm_clock_reset_avmm1_clk,
  output wire	                   avmm_clock_reset_avmm2_clk,
  output wire	                   avmm_clock_tx_osc_clk,
  output wire	                   avmm_clock_rx_osc_clk,
  output wire	                   avmm_clock_avmm_clk,
  output wire	                   avmm_clock_avmm_clk_scg,
  output wire	                   avmm_clock_avmm_clk_dcg,
  output wire	                   avmm_clock_dprio_clk,
  output wire [7:0]                avmm_clock_dcg_testbus
);

wire            avmm_osc_clk_en;
wire            avmm_clock_avmm_clk_int;
wire		avmm_avmm_clk_en;
wire            scan_mode;
wire            avmm_transfer_dcg_gate_sync;


//////////////////
// Clock muxing //
//////////////////

////////// Rx Oscillator Clock //////////

assign scan_mode = ~scan_mode_n;

// Note: sr_clock_aib_rx_sr_clk is aib_hssi_rx_sr_clk_in post TCM module residing in srclk_ctl module
assign avmm_clock_reset_rx_osc_clk = sr_clock_aib_rx_sr_clk;

// scg_en = 1: clock disabled
assign avmm_osc_clk_en = scan_mode | (~r_avmm_osc_clk_scg_en);

c3lib_ckand2_ctn ckand2_avmm_rx_osc_clk_scg (
  .clk_out   (avmm_clock_rx_osc_clk),
  .clk_in0   (sr_clock_aib_rx_sr_clk),
  .clk_in1   (avmm_osc_clk_en));

// c3dfx_tcm_wrap 
// # (
//   .SYNC_FUNC_CLKEN   (0),          // Synchronize i_func_clken wih the i_func_clk
//   .RESET_VAL         (0),          // Reset value is LOW if set to 0, otherwise HIGH
//   .CLK_DIV           (0),          // i_func_clk divided by 2  if set to 2
//   .DST_CLK_FREQ_MHZ  (1000),       // Clock frequency for destination domain in MHz
//   .SRC_DATA_FREQ_MHZ (100)         // Average source data 'frequency' in MHz
// 
// ) tcm_ckmux2_avmm_rx_osc_clk_mux1 (
//   .i_func_clk     (aib_hssi_rx_sr_clk_in),      
//   .i_func_clken   (1'b1),                          
//   .i_rst_n        (1'b1),
//   .i_test_clk     (test_clk),                      
//   .i_scan_clk     (scan_clk),                      
//   .i_tst_tcm_ctrl (tst_tcm_ctrl),                  
//   .o_clk          (avmm_clock_rx_osc_clk_mux1));


////////// Tx Oscillator Clock //////////

assign avmm_clock_reset_tx_osc_clk = sr_clock_tx_osc_clk_or_clkdiv;

// sr_clock_tx_osc_clk_or_clkdiv is derived from aib_hssi_tx_sr_clk_in or aib_hssi_tx_sr_clk_in/2 or aib_hssi_tx_sr_clk_in/4
// Each of those clocks are already being controlled by a TCM in module c3adapt_srclk_ctl
c3lib_ckand2_ctn ckand2_avmm_tx_osc_clk_scg (
  .clk_out  (avmm_clock_tx_osc_clk),
  .clk_in0  (sr_clock_tx_osc_clk_or_clkdiv),
  .clk_in1  (avmm_osc_clk_en)
);

////////// DPRIO Clock //////////

// avmm_clock_dprio_clk drives User AVMM1 interface
assign avmm_clock_dprio_clk = avmm_clock_avmm_clk_dcg;

////////// AVMM Clock //////////

assign avmm_clock_avmm_clk = avmm_clock_avmm_clk_scg;

assign avmm_clock_reset_avmm1_clk  = avmm_clock_avmm_clk_int;

// Reuse AVMM1 TCM
assign avmm_clock_reset_avmm2_clk = avmm_clock_avmm_clk_int;

assign avmm_avmm_clk_en = scan_mode | (~r_avmm_avmm_clk_scg_en);

c3lib_ckand2_ctn ckand2_avmm_hrdrst_tx_osc_clk_scg (
  .clk_out  (avmm_clock_avmm_clk_scg),
  .clk_in0  (avmm_clock_avmm_clk_int),
  .clk_in1  (avmm_avmm_clk_en)
);

// Clock divider by 8
 c3dfx_tcm_wrap 
 # (
   .SYNC_FUNC_CLKEN   (0),          // Synchronize i_func_clken wih the i_func_clk
   .RESET_VAL         (1),          // Reset value is LOW if set to 0, otherwise HIGH
   .CLK_DIV           (8),          // i_func_clk divided by 8
   .DST_CLK_FREQ_MHZ  (300),        // Clock frequency for destination domain in MHz
   .SRC_DATA_FREQ_MHZ (100))        // Average source data 'frequency' in MHz
   tcm_ckdiv8_avmm_clock_avmm_clk_int (
     .i_func_clk     (aib_hssi_rx_sr_clk_in),      
     .i_func_clken   (1'b1),                          
     .i_rst_n        (avmm_reset_rx_osc_clk_for_clkdiv_rst_n),
     .i_test_clk     (test_clk),                      
     .i_scan_clk     (scan_clk),                      
     .i_tst_tcm_ctrl (tst_tcm_ctrl),                  
     .o_clk          (avmm_clock_avmm_clk_int));

// avmm_clock_reset_rx_osc_clk is avmm_clock_rx_osc_clk_mux1, which is output of TCM
// c3lib_ckdiv8_ctn #( .RESET_VAL (1))           // Reset value is LOW if set to 0, otherwise HIGH 
//  ckdiv8_avmm_clock_avmm_clk_int (
//   .clk_in    (avmm_clock_reset_rx_osc_clk),
//   .rst_n     (avmm_reset_rx_osc_clk_for_clkdiv_rst_n),
//   .clk_out   (avmm_clock_avmm_clk_int));

c3lib_bitsync #(
   .DWIDTH            (1  ),
   .RESET_VAL         (0  ),
   .DST_CLK_FREQ_MHZ  (500),
   .SRC_DATA_FREQ_MHZ (100)
) dcg_gate_sync (
  .clk                (avmm_clock_avmm_clk_int),
  .rst_n              (avmm_reset_avmm_rst_n),
  .data_in            (avmm_transfer_dcg_gate),
  .data_out           (avmm_transfer_dcg_gate_sync));


c3aibadapt_avmmclk_dcg avmmclk_dcg (
  .clk              (avmm_clock_avmm_clk_scg),
  .rst_n            (avmm_reset_avmm_rst_n),
  .ungate           (avmm_transfer_dcg_ungate),
  .gate             (avmm_transfer_dcg_gate_sync),
  .r_dcg_en         (r_avmm_avmm_clk_dcg_en),
  .r_dcg_cnt_bypass (1'b0),
  .r_dcg_wait_cnt   (4'b1111),
  .te               (scan_mode),
  .gclk             (avmm_clock_avmm_clk_dcg),
  .dcg_testbus      (avmm_clock_dcg_testbus[7:0]));

endmodule // c3adapt_avmm1clk_ctl
