// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3aibadapt_hrdrst_clkctl (
  input  wire                       scan_mode_n,
  input  wire                       cfg_avmm_clk,
  input	 wire	                    sr_clock_aib_rx_sr_clk,
  input	 wire	                    sr_clock_tx_osc_clk_or_clkdiv,
  input	 wire	                    r_avmm_hrdrst_osc_clk_scg_en,
  output wire	                    avmm_clock_reset_hrdrst_rx_osc_clk,
  output wire	                    avmm_clock_reset_hrdrst_tx_osc_clk,
  output wire	                    avmm_clock_hrdrst_rx_osc_clk,
  output wire	                    avmm_clock_hrdrst_tx_osc_clk,
  output wire	                    cfg_avmm_clk_out
);

wire            avmm_hrdrst_osc_clk_en;

// Feedthrough
assign cfg_avmm_clk_out = cfg_avmm_clk;

////////// Rx Oscillator Clock //////////

assign avmm_clock_reset_hrdrst_rx_osc_clk = sr_clock_aib_rx_sr_clk;

assign avmm_hrdrst_osc_clk_en = (~scan_mode_n) | (~r_avmm_hrdrst_osc_clk_scg_en);

c3lib_ckand2_ctn ckand2_avmm_hrdrst_rx_osc_clk_scg (
  .clk_out  (avmm_clock_hrdrst_rx_osc_clk),
  .clk_in0  (sr_clock_aib_rx_sr_clk),
  .clk_in1  (avmm_hrdrst_osc_clk_en)
);

// c3dfx_tcm_wrap 
// # (
//   .SYNC_FUNC_CLKEN   (0),          // Synchronize i_func_clken wih the i_func_clk
//   .RESET_VAL         (0),          // Reset value is LOW if set to 0, otherwise HIGH
//   .CLK_DIV           (0),          // i_func_clk divided by 2  if set to 2
//   .DST_CLK_FREQ_MHZ  (1000),        // Clock frequency for destination domain in MHz
//   .SRC_DATA_FREQ_MHZ (100)         // Average source data 'frequency' in MHz
// ) tcm_ckmux2_avmm_hrdrst_rx_osc_clk_mux1 (
//   .i_func_clk     (aib_hssi_rx_sr_clk_in),      
//   .i_func_clken   (1'b1),                          
//   .i_rst_n        (1'b1),
//   .i_test_clk     (test_clk),                      
//   .i_scan_clk     (scan_clk),                      
//   .i_tst_tcm_ctrl (tst_tcm_ctrl),                  
//   .o_clk          (avmm_clock_hrdrst_rx_osc_clk_mux1));

////////// Tx Oscillator Clock //////////

assign avmm_clock_reset_hrdrst_tx_osc_clk = sr_clock_tx_osc_clk_or_clkdiv;

// sr_clock_tx_osc_clk_or_clkdiv is derived from aib_hssi_tx_sr_clk_in or aib_hssi_tx_sr_clk_in/2 or aib_hssi_tx_sr_clk_in/4
// Each of those clocks are already being controlled by a TCM in module c3adapt_srclk_ctl
c3lib_ckand2_ctn ckand2_avmm_hrdrst_tx_osc_clk_scg (
  .clk_out  (avmm_clock_hrdrst_tx_osc_clk),
  .clk_in0  (sr_clock_tx_osc_clk_or_clkdiv),
  .clk_in1  (avmm_hrdrst_osc_clk_en)
);

// c3dfx_tcm_wrap 
// # (
//   .SYNC_FUNC_CLKEN   (0),          // Synchronize i_func_clken wih the i_func_clk
//   .RESET_VAL         (0),          // Reset value is LOW if set to 0, otherwise HIGH
//   .CLK_DIV           (0),          // i_func_clk divided by 2  if set to 2
//   .DST_CLK_FREQ_MHZ  (1000),        // Clock frequency for destination domain in MHz
//   .SRC_DATA_FREQ_MHZ (100)         // Average source data 'frequency' in MHz
// 
// ) tcm_ckmux2_avmm_hrdrst_tx_osc_clk_mux1 (
//   .i_func_clk     (sr_clock_tx_osc_clk_or_clkdiv),      
//   .i_func_clken   (1'b1),                          
//   .i_rst_n        (1'b1),
//   .i_test_clk     (test_clk),                      
//   .i_scan_clk     (scan_clk),                      
//   .i_tst_tcm_ctrl (tst_tcm_ctrl),                  
//   .o_clk          (avmm_clock_hrdrst_tx_osc_clk_mux1));

endmodule // c3aibadapt_hrdrst_clkctl
