// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3aibadapt_srclk_ctl (
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
  input	 wire		aib_hssi_tx_sr_clk_in,
  input	 wire		aib_hssi_rx_sr_clk_in,
  input	 wire		sr_reset_tx_sr_clk_in_rst_n,
  input	 wire           r_sr_osc_clk_scg_en,
  input	 wire [1:0]	r_sr_osc_clk_div_sel,
  output wire		aib_hssi_tx_sr_clk_out,
  output wire           sr_clock_aib_rx_sr_clk,
  output wire		sr_clock_tx_sr_clk_in,
  output wire		sr_clock_tx_sr_clk_in_div2,
  output wire		sr_clock_tx_sr_clk_in_div4,
  output wire		sr_clock_reset_rx_osc_clk,
  output wire		sr_clock_reset_tx_osc_clk,
  output wire		sr_clock_tx_osc_clk_or_clkdiv,
  output wire		sr_clock_rx_osc_clk,
  output wire		sr_clock_tx_osc_clk
);

wire            sr_clock_rx_osc_clk_mux1;
wire            sr_osc_clk_en;

wire            sr_clock_tx_osc_clk_buf;
wire		sr_clock_tx_osc_clk_or_clkdiv_mux1;
wire		sr_clock_tx_osc_clk_or_clkdiv_mux2;
wire		sr_tx_osc_clk_div_sel1;
wire		sr_tx_osc_clk_div_sel2;

wire		sr_clock_tx_sr_clk_in_mux1;

wire		ckdiv2_sr_tx_sr_clk;
//////////////////
// Clock muxing //
//////////////////

////////// Rx Oscillator Clock //////////

assign sr_clock_reset_rx_osc_clk  = sr_clock_rx_osc_clk_mux1;
assign sr_clock_aib_rx_sr_clk     = sr_clock_rx_osc_clk_mux1;
assign sr_clock_tx_sr_clk_in_div2 = ckdiv2_sr_tx_sr_clk;


assign sr_osc_clk_en = (~scan_mode_n) | (~r_sr_osc_clk_scg_en);

c3lib_ckand2_ctn ckand2_sr_rx_osc_clk_scg (
  .clk_out  (sr_clock_rx_osc_clk),
  .clk_in0  (sr_clock_rx_osc_clk_mux1),
  .clk_in1  (sr_osc_clk_en));

c3dfx_tcm_wrap 
# (
  .SYNC_FUNC_CLKEN   (0),          // Synchronize i_func_clken wih the i_func_clk
  .RESET_VAL         (0),          // Reset value is LOW if set to 0, otherwise HIGH
  .CLK_DIV           (0),          // i_func_clk divided by 2  if set to 2
  .DST_CLK_FREQ_MHZ  (10000),      // Clock frequency for destination domain in MHz
  .SRC_DATA_FREQ_MHZ (100)         // Average source data 'frequency' in MHz

) tcm_ckmux2_sr_rx_osc_clk (
  .i_func_clk     (aib_hssi_rx_sr_clk_in),      
  .i_func_clken   (1'b1),                          
  .i_rst_n        (1'b1),
  .i_test_clk     (t0_test_clk),                      
  .i_scan_clk     (t0_scan_clk),                      
  .i_tst_tcm_ctrl (t0_tst_tcm_ctrl),                  
  .o_clk          (sr_clock_rx_osc_clk_mux1));

////////// Tx Oscillator Clock //////////

assign aib_hssi_tx_sr_clk_out    = sr_clock_tx_osc_clk_buf;
assign sr_clock_reset_tx_osc_clk = sr_clock_tx_osc_clk_buf;

c3lib_ckand2_ctn ckand2_sr_tx_osc_clk_scg (
  .clk_out  (sr_clock_tx_osc_clk),
  .clk_in0  (sr_clock_tx_osc_clk_buf),
  .clk_in1  (sr_osc_clk_en));

// Divided Clock
c3lib_ckbuf_ctn ckbuf_sr_tx_osc_clk (
  .out (sr_clock_tx_osc_clk_buf),
  .in  (sr_clock_tx_osc_clk_or_clkdiv_mux1));

//assign aib_hssi_tx_sr_clk_out = sr_clock_tx_osc_clk_or_clkdiv_mux1;
assign sr_clock_tx_osc_clk_or_clkdiv = sr_clock_tx_osc_clk_or_clkdiv_mux1;

assign sr_tx_osc_clk_div_sel1 = (~scan_mode_n) | (r_sr_osc_clk_div_sel == 2'b00);
assign sr_tx_osc_clk_div_sel2 = (r_sr_osc_clk_div_sel == 2'b01);

c3lib_mux2_ctn ckmux2_sr_clock_tx_osc_clk_or_clkdiv_mux1 (
  .ck_out   (sr_clock_tx_osc_clk_or_clkdiv_mux1),
  .ck0      (sr_clock_tx_osc_clk_or_clkdiv_mux2),
  .ck1      (sr_clock_tx_sr_clk_in_mux1),
  .s0       (sr_tx_osc_clk_div_sel1));

c3lib_mux2_ctn ckmux2_sr_clock_tx_osc_clk_or_clkdiv_mux2 (
  .ck_out   (sr_clock_tx_osc_clk_or_clkdiv_mux2),
  .ck0      (sr_clock_tx_sr_clk_in_div4),
  .ck1      (ckdiv2_sr_tx_sr_clk),
  .s0       (sr_tx_osc_clk_div_sel2));

assign sr_clock_tx_sr_clk_in = sr_clock_tx_sr_clk_in_mux1;

// Non Divided Clock
c3dfx_tcm_wrap 
# (
  .SYNC_FUNC_CLKEN   (0),          // Synchronize i_func_clken wih the i_func_clk
  .RESET_VAL         (0),          // Reset value is LOW if set to 0, otherwise HIGH
  .CLK_DIV           (0),          // i_func_clk divided by 2  if set to 2
  .DST_CLK_FREQ_MHZ  (10000),      // Clock frequency for destination domain in MHz
  .SRC_DATA_FREQ_MHZ (100)         // Average source data 'frequency' in MHz

) tcm_ckmux2_tx_sr_clk_in (
  .i_func_clk     (aib_hssi_tx_sr_clk_in),      
  .i_func_clken   (1'b1),                          
  .i_rst_n        (1'b1),
  .i_test_clk     (t1_test_clk),                      
  .i_scan_clk     (t1_scan_clk),                      
  .i_tst_tcm_ctrl (t1_tst_tcm_ctrl),                  
  .o_clk          (sr_clock_tx_sr_clk_in_mux1));

// Clock divider by 2 and by 4

c3dfx_tcm_wrap 
# (
  .SYNC_FUNC_CLKEN   (0),          // Synchronize i_func_clken wih the i_func_clk
  .RESET_VAL         (1),          // Reset value is LOW if set to 0, otherwise HIGH
  .CLK_DIV           (2),          // i_func_clk divided by 2  if set to 2
  .DST_CLK_FREQ_MHZ  (10000),      // Clock frequency for destination domain in MHz
  .SRC_DATA_FREQ_MHZ (200)         // Average source data 'frequency' in MHz

) tcm_ckdiv2_sr_tx_sr_clk  (
  .i_func_clk     (aib_hssi_tx_sr_clk_in),      
  .i_func_clken   (1'b1),                          
  .i_rst_n        (sr_reset_tx_sr_clk_in_rst_n),
  .i_test_clk     (t2_test_clk),                      
  .i_scan_clk     (t2_scan_clk),                      
  .i_tst_tcm_ctrl (t2_tst_tcm_ctrl),                  
  .o_clk          (ckdiv2_sr_tx_sr_clk));

c3dfx_tcm_wrap 
# (
  .SYNC_FUNC_CLKEN   (0),          // Synchronize i_func_clken wih the i_func_clk
  .RESET_VAL         (1),          // Reset value is LOW if set to 0, otherwise HIGH
  .CLK_DIV           (4),          // i_func_clk divided by 4  if set to 4
  .DST_CLK_FREQ_MHZ  (10000),      // Clock frequency for destination domain in MHz
  .SRC_DATA_FREQ_MHZ (200)         // Average source data 'frequency' in MHz

) tcm_ckdiv4_sr_tx_sr_clk  (
  .i_func_clk     (aib_hssi_tx_sr_clk_in),      
  .i_func_clken   (1'b1),                          
  .i_rst_n        (sr_reset_tx_sr_clk_in_rst_n),
  .i_test_clk     (t3_test_clk),                      
  .i_scan_clk     (t3_scan_clk),                      
  .i_tst_tcm_ctrl (t3_tst_tcm_ctrl),                  
  .o_clk          (sr_clock_tx_sr_clk_in_div4));


endmodule // c3aibadapt_srclk_ctl
