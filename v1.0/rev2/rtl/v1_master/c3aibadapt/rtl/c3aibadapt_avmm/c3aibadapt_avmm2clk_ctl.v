// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3aibadapt_avmm2clk_ctl (
  // input  wire [`TCM_WRAP_CTRL_RNG] tst_tcm_ctrl,
  // input  wire                      test_clk,
  // input  wire                      scan_clk,
  input	 wire		           sr_clock_aib_rx_sr_clk,
  input	 wire		           sr_clock_tx_osc_clk_or_clkdiv,
  input  wire                      avmm_clock_reset_avmm2_clk,
  input	 wire		           avmm_reset_avmm_rst_n,
  input	 wire		           avmm_reset_rx_osc_clk_for_clkdiv_rst_n,
  input	 wire		           avmm_transfer_dcg_ungate,
  input	 wire		           avmm_transfer_dcg_gate,
  input	 wire		           r_avmm_osc_clk_scg_en,
  input	 wire		           r_avmm_avmm_clk_scg_en,	
  input	 wire                      r_avmm_avmm_clk_dcg_en,
  input  wire                      scan_mode_n,
  output wire		           hip_avmm_clk,
  output wire		           avmm_clock_reset_tx_osc_clk,
  output wire		           avmm_clock_reset_rx_osc_clk,
  output wire		           avmm_clock_reset_avmm_clk,
  output wire		           avmm_clock_tx_osc_clk,
  output wire		           avmm_clock_rx_osc_clk,
  output wire		           avmm_clock_avmm_clk,
  output wire		           avmm_clock_avmm_clk_scg,
  output wire		           avmm_clock_avmm_clk_dcg,
  output wire		           avmm_clock_dprio_clk,
  output wire [7:0]	           avmm_clock_dcg_testbus
);

wire   avmm_osc_clk_en;

wire   avmm_clock_tx_osc_clk_mux1;
wire   avmm_clock_tx_osc_clk_occ;

wire   avmm_clock_dprio_clk_mux1;
wire   avmm_clock_dprio_clk_mux2;
wire   avmm_dprio_clk_sel1;
wire   avmm_dprio_clk_sel2;
wire   avmm_clock_avmm_clk_scg_n;
wire   avmm_clock_avmm_clk_mux1;
wire   avmm_clock_avmm_clk_mux1_n;
wire   avmm_clock_avmm_clk_occ;
wire   avmm_avmm_clk_en;
wire   scan_mode;

//////////////////
// Clock muxing //
//////////////////

assign scan_mode = ~scan_mode_n;

////////// Rx Oscillator Clock //////////

assign avmm_clock_reset_rx_osc_clk = sr_clock_aib_rx_sr_clk;

assign avmm_osc_clk_en = scan_mode | (~r_avmm_osc_clk_scg_en);

c3lib_ckand2_ctn ckand2_avmm_rx_osc_clk_scg (
  .clk_out   (avmm_clock_rx_osc_clk),
  .clk_in0   (sr_clock_aib_rx_sr_clk),
  .clk_in1   (avmm_osc_clk_en));

// c3dfx_tcm_wrap 
// # (
//   .SYNC_FUNC_CLKEN   (0),          // Synchronize i_func_clken wih the i_func_clk
//   .RESET_VAL         (0),          // Reset value is LOW if set to 0, otherwise HIGH
//   .CLK_DIV           (0),          // clock Mux
//   .DST_CLK_FREQ_MHZ  (1000),       // Clock frequency for destination domain in MHz
//   .SRC_DATA_FREQ_MHZ (100)         // Average source data 'frequency' in MHz
// 
// ) tcm_ckmux2_avmm_tx_osc_clk_mux1 (
//   .i_func_clk     (aib_hssi_rx_sr_clk_in),      
//   .i_func_clken   (1'b1),                          
//   .i_rst_n        (1'b1),
//   .i_test_clk     (test_clk),                      
//   .i_scan_clk     (scan_clk),                      
//   .i_tst_tcm_ctrl (tst_tcm_ctrl),                  
//   .o_clk          (avmm_clock_rx_osc_clk_mux1));

// c3adapt_cmn_clkand2 cmn_clkand2_avmm_rx_osc_clk_scg
//     (
//         .Z(avmm_clock_rx_osc_clk),
//         .A1(avmm_clock_rx_osc_clk_mux1),
//         .A2(avmm_osc_clk_en)
//     );
// 
// c3adapt_cmn_clkmux2 cmn_clkmux2_avmm_rx_osc_clk_mux1
//     (
//         .clk_o(avmm_clock_rx_osc_clk_mux1),
//         .clk_0(avmm_clock_rx_osc_clk_occ),
//         .clk_1(aib_hssi_rx_sr_clk_in),
//         .clk_sel(avmm_clock_dft_clk_sel_n)
//     );
// 
// c3adapt_cmn_dft_clk_ctlr 
//     #(
//         .CONTROL_REGISTER_PRESENT(1)
//     ) cmn_dft_clk_ctlr_avmm_rx_osc_clk_occ
//     (
//         .user_clk(adapter_scan_user_clk3),              //User clock
//         .test_clk(adapter_scan_shift_clk),              //Test clock
//         .rst_n(1'b0),                                   //Reset (active low)
//         .clk_sel_n(adapter_clk_sel_n),                  //Mux sel between user or test clock, Active low
//         .scan_enable(adapter_scan_shift),               //Scan enable control signal, Active high in IP, Active low in top level
//         .occ_enable(adapter_occ_enable),                //Control signal to enable OCC, Active high in IP, Active low in top level
//         .atpg_mode(avmm_clock_dft_occ_atpg_mode),	//Control signal for test mode, Active high in IP, Active low in top level
//         .out_clk(avmm_clock_rx_osc_clk_occ)		//Output clock
//     );
// 
////////// Tx Oscillator Clock //////////

assign avmm_clock_reset_tx_osc_clk = sr_clock_tx_osc_clk_or_clkdiv;

// sr_clock_tx_osc_clk_or_clkdiv is derived from aib_hssi_tx_sr_clk_in or aib_hssi_tx_sr_clk_in/2 or aib_hssi_tx_sr_clk_in/4
// Each of those clocks are already being controlled by a TCM in module c3adapt_srclk_ctl
c3lib_ckand2_ctn ckand2_avmm_tx_osc_clk_scg (
  .clk_out   (avmm_clock_tx_osc_clk),
  .clk_in0   (sr_clock_tx_osc_clk_or_clkdiv),
  .clk_in1   (avmm_osc_clk_en));

// c3adapt_cmn_clkand2 cmn_clkand2_avmm_tx_osc_clk_scg
//     (
//         .Z(avmm_clock_tx_osc_clk),
//         .A1(avmm_clock_tx_osc_clk_mux1),
//         .A2(avmm_osc_clk_en)
//     );

// c3adapt_cmn_clkmux2 cmn_clkmux2_avmm_tx_osc_clk_mux1
//     (
//         .clk_o(avmm_clock_tx_osc_clk_mux1),
//         .clk_0(avmm_clock_tx_osc_clk_occ),
//         .clk_1(sr_clock_tx_osc_clk_or_clkdiv),
//         .clk_sel(avmm_clock_dft_clk_sel_n)
//     );
// 
// c3adapt_cmn_dft_clk_ctlr
//     #(
//         .CONTROL_REGISTER_PRESENT(1)
//     ) cmn_dft_clk_ctlr_avmm_tx_osc_clk_occ
//     (
//         .user_clk(adapter_scan_user_clk3),              //User clock
//         .test_clk(adapter_scan_shift_clk),              //Test clock
//         .rst_n(1'b0),                                   //Reset (active low)
//         .clk_sel_n(adapter_clk_sel_n),                  //Mux sel between user or test clock, Active low
//         .scan_enable(adapter_scan_shift),               //Scan enable control signal, Active high in IP, Active low in top level
//         .occ_enable(adapter_occ_enable),                //Control signal to enable OCC, Active high in IP, Active low in top level
//         .atpg_mode(avmm_clock_dft_occ_atpg_mode),	//Control signal for test mode, Active high in IP, Active low in top level
//         .out_clk(avmm_clock_tx_osc_clk_occ)               //Output clock
//     );
// 
////////// DPRIO Clock //////////

c3lib_ckbuf_ctn ckbuf_avmm_dprio_clk (
  .out    (avmm_clock_dprio_clk),
  .in     (avmm_clock_avmm_clk_dcg) 
);                             

////////// AVMM Clock //////////

assign hip_avmm_clk        = avmm_clock_avmm_clk_dcg;
assign avmm_clock_avmm_clk = avmm_clock_avmm_clk_scg;

// Reusing TCM module in avmm1: avmm_clock_reset_avmm2_clk comes from avmm1clk_ctl.
assign avmm_clock_reset_avmm_clk = avmm_clock_reset_avmm2_clk;

assign avmm_avmm_clk_en   = scan_mode | (~r_avmm_avmm_clk_scg_en);

c3lib_ckand2_ctn ckand2_avmm_avmm_clk_scg (
  .clk_out  (avmm_clock_avmm_clk_scg),
  .clk_in0  (avmm_clock_reset_avmm2_clk),
  .clk_in1  (avmm_avmm_clk_en));

// c3adapt_cmn_clkinv cmn_clkinv_avmm_avmm_clk_scg_n_inv
//     (
//         .ZN(avmm_clock_avmm_clk_scg),
//         .I(avmm_clock_avmm_clk_scg_n)
//     );
// 
// c3adapt_cmn_clkand2 cmn_clkand2_avmm_avmm_clk_scg_n_and2
//     (
//         .Z(avmm_clock_avmm_clk_scg_n),
//         .A1(avmm_avmm_clk_dis_n),
//         .A2(avmm_clock_avmm_clk_mux1_n)
//     );
// 
// c3adapt_cmn_clkinv cmn_clkinv_avmm_avmm_clk_dis_inv
//     (
//         .ZN(avmm_avmm_clk_dis_n),
//         .I(avmm_avmm_clk_dis)
//     );
// 
// c3adapt_cmn_clkinv cmn_clkinv_avmm_avmm_clk_mux1_inv
//     (
//         .ZN(avmm_clock_avmm_clk_mux1_n),
//         .I(avmm_clock_avmm_clk_mux1)
//     );
// 
// c3adapt_cmn_clkmux2 cmn_clkmux2_avmm_avmm_clk_mux1
//     (
//         .clk_o(avmm_clock_avmm_clk_mux1),
//         .clk_0(avmm_clock_avmm_clk_occ),
//         .clk_1(avmm_clock_avmm_clk_int),
//         .clk_sel(avmm_clock_dft_clk_sel_n)
//     );
// 
// c3adapt_cmn_dft_clk_ctlr 
//     #(
//         .CONTROL_REGISTER_PRESENT(1)
//     ) c3adapt_cmn_dft_clk_ctlr_avmm_avmm_clk_occ
//     (
//         .user_clk(adapter_scan_user_clk0),              //User clock
//         .test_clk(adapter_scan_shift_clk),              //Test clock
//         .rst_n(1'b0),                                   //Reset (active low)
//         .clk_sel_n(adapter_clk_sel_n),                  //Mux sel between user or test clock, Active low
//         .scan_enable(adapter_scan_shift),               //Scan enable control signal, Active high in IP, Active low in top level
//         .occ_enable(adapter_occ_enable),                //Control signal to enable OCC, Active high in IP, Active low in top level
//         .atpg_mode(avmm_clock_dft_occ_atpg_mode),	//Control signal for test mode, Active high in IP, Active low in top level
//         .out_clk(avmm_clock_avmm_clk_occ)               //Output clock
//     );

// Clock divider by 8
// c3dfx_tcm_wrap # (
//   .SYNC_FUNC_CLKEN   (0),          // Synchronize i_func_clken wih the i_func_clk
//   .RESET_VAL         (1),          // Reset value is LOW if set to 0, otherwise HIGH
//   .CLK_DIV           (8),          // i_func_clk divided by 8
//   .DST_CLK_FREQ_MHZ  (300),        // Clock frequency for destination domain in MHz
//   .SRC_DATA_FREQ_MHZ (100))        // Average source data 'frequency' in MHz
//   tcm_ckdiv8_avmm_clock_avmm_clk_int (
//     .i_func_clk     (avmm_clock_reset_rx_osc_clk),      
//     .i_func_clken   (1'b1),                          
//     .i_rst_n        (avmm_reset_rx_osc_clk_for_clkdiv_rst_n),
//     .i_test_clk     (test_clk),                      
//     .i_scan_clk     (scan_clk),                      
//     .i_tst_tcm_ctrl (tst_tcm_ctrl),                  
//     .o_clk          (avmm_clock_avmm_clk_int));

// avmm_clock_reset_rx_osc_clk is controlled by TCM. 
// c3lib_ckdiv8_ctn #( .RESET_VAL (1))           // Reset value is LOW if set to 0, otherwise HIGH 
//  ckdiv8_avmm_clock_avmm_clk_int (
//    .clk_in    (avmm_clock_reset_rx_osc_clk),
//    .rst_n     (avmm_reset_rx_osc_clk_for_clkdiv_rst_n),
//    .clk_out   (avmm_clock_avmm_clk_int));


c3aibadapt_avmmclk_dcg avmmclk_dcg (
  .clk               (avmm_clock_avmm_clk_scg),
  .rst_n             (avmm_reset_avmm_rst_n),
  .ungate            (avmm_transfer_dcg_ungate),
  .gate              (avmm_transfer_dcg_gate),
  .r_dcg_en          (r_avmm_avmm_clk_dcg_en),
  .r_dcg_cnt_bypass  (1'b0),
  .r_dcg_wait_cnt    (4'b1111),
  .te                (scan_mode),
  .gclk              (avmm_clock_avmm_clk_dcg),
  .dcg_testbus       (avmm_clock_dcg_testbus[7:0]));

endmodule // c3aibadapt_avmm2clk_ctl
