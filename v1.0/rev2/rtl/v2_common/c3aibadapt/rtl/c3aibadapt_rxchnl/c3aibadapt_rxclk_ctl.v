// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
// (C) 2009 Altera Corporation. .
//
//------------------------------------------------------------------------
// Revision:    $Revision: #8 $
// Date:        $Date: 2017/04/03 $
//------------------------------------------------------------------------
// Description:
//
//------------------------------------------------------------------------
module c3aibadapt_rxclk_ctl (
  input  wire                       scan_mode_n,
  input  wire [`TCM_WRAP_CTRL_RNG]  tst_tcm_ctrl,
  input  wire                       test_clk,
  input  wire                       scan_clk,
  input  wire                       rx_pma_div2_clk,
  input  wire                       rx_ehip_clk,
  input  wire                       rx_elane_clk,
  input  wire                       rx_rsfec_clk,
  input  wire                       rx_ehip_frd_clk,
  input  wire                       rx_rsfec_frd_clk,
  input	 wire		            rx_pma_div66_clk,
  input	 wire [5:0]                 feedthru_clk,
  input	 wire		            rx_pma_clk,
  input	 wire		            tx_pma_clk,
  input  wire                       tx_clock_fifo_rd_prect_clk,
  input	 wire		            aib_hssi_pld_pma_coreclkin,
  input  wire                       tx_aib_transfer_clk,
  input  wire                       tx_aib_transfer_div2_clk,
  // input wire                        tx_clock_pma_aib_tx_clkdiv2,
  input	 wire		            aib_hssi_rx_sr_clk_in,
  input	 wire		            aib_hssi_pld_sclk,
  input  wire                       aib_hssi_fpll_shared_direct_async_in,
  input	 wire		            tx_clock_fifo_wr_clk,
  input	 wire		            tx_clock_fifo_rd_clk,
  input	 wire		            avmm1_clock_avmm_clk_scg,
  input	 wire		            avmm1_clock_avmm_clk_dcg,
  input	 wire		            avmm2_clock_avmm_clk_scg,
  input	 wire		            avmm2_clock_avmm_clk_dcg,
  input	 wire		            sr_clock_tx_sr_clk_in_div2,
  input	 wire		            sr_clock_tx_sr_clk_in_div4,
  input	 wire		            sr_clock_tx_osc_clk_or_clkdiv,
  input	 wire		            r_rx_pma_coreclkin_sel,
  input	 wire [2:0]	            r_rx_fifo_wr_clk_sel,
  input	 wire [2:0]	            r_rx_fifo_rd_clk_sel,
  input	 wire		            r_rx_dyn_clk_sw_en,
  input	 wire [3:0]	            r_rx_internal_clk1_sel,
  input	 wire [3:0]	            r_rx_internal_clk2_sel,
  input  wire                       r_rx_internal_clk1_sel0,
  input  wire                       r_rx_internal_clk1_sel1,
  input  wire                       r_rx_internal_clk1_sel2,
  input  wire                       r_rx_internal_clk1_sel3,
  input  wire                       r_rx_txfiford_pre_ct_sel,
  input  wire                       r_rx_txfiford_post_ct_sel,
  input  wire                       r_rx_txfifowr_post_ct_sel,
  input  wire                       r_rx_txfifowr_from_aib_sel,
  input  wire                       r_rx_internal_clk2_sel0,
  input  wire                       r_rx_internal_clk2_sel1,
  input  wire                       r_rx_internal_clk2_sel2,
  input  wire                       r_rx_internal_clk2_sel3,
  input  wire                       r_rx_rxfifowr_pre_ct_sel,
  input  wire                       r_rx_rxfifowr_post_ct_sel,
  input  wire                       r_rx_rxfiford_post_ct_sel,
  input  wire                       r_rx_rxfiford_to_aib_sel,
  input	 wire		            r_rx_fifo_wr_clk_scg_en,
  input	 wire		            r_rx_fifo_rd_clk_scg_en,
  input	 wire		            r_rx_txeq_clk_scg_en,
  input	 wire		            r_rx_pma_hclk_scg_en,
  input	 wire		            r_rx_osc_clk_scg_en,
  input	 wire		            r_rx_hrdrst_rx_osc_clk_scg_en,
  input	 wire [1:0]	            r_rx_fifo_power_mode,
  input	 wire		            r_rx_bonding_dft_in_en,
  input	 wire		            r_rx_bonding_dft_in_value,
  output wire                       xcvrif_sclk,
  output wire		            pld_pma_coreclkin,
  output wire		            aib_hssi_rx_transfer_clk,
  output wire		            aib_rx_pma_div2_clk,
  output wire		            aib_rx_pma_div66_clk,
  output wire		            aib_hssi_pld_pma_internal_clk1,
  output wire		            aib_hssi_pld_pma_internal_clk2,
  output wire		            aib_hssi_pld_pma_hclk,
  output wire                       rx_ehip_early_clk,
  output wire                       rx_elane_early_clk,
  output wire                       rx_rsfec_early_clk,
  output wire                       rx_pma_early_clk,
  output wire                       rx_clock_reset_hrdrst_rx_osc_clk,
  output wire                       rx_clock_reset_fifo_wr_clk,
  output wire                       rx_clock_reset_fifo_rd_clk,
  output wire		            rx_clock_fifo_sclk,
  output wire		            rx_clock_reset_txeq_clk,
  output wire                       rx_clock_reset_asn_pma_hclk,
  output wire                       rx_clock_reset_async_rx_osc_clk,
  output wire                       rx_clock_reset_async_tx_osc_clk,
  output wire                       rx_clock_pld_pma_hclk,
  output wire		            rx_clock_fifo_wr_clk,           // Static clock gated
  output wire                       q1_rx_clock_fifo_wr_clk,        // Static clock gated
  output wire                       q2_rx_clock_fifo_wr_clk,        // Static clock gated
  output wire                       q3_rx_clock_fifo_wr_clk,        // Static clock gated
  output wire                       q4_rx_clock_fifo_wr_clk,        // Static clock gated
  output wire		            rx_clock_fifo_rd_clk,           // Static clock gated
  output wire		            rx_clock_txeq_clk,              // Static clock gated
  output wire		            rx_clock_asn_pma_hclk,          // Static clock gated
  output wire		            rx_clock_hrdrst_rx_osc_clk,     // Static clock gated
  output wire		            rx_clock_async_rx_osc_clk,      // Static clock gated
  output wire		            rx_clock_async_tx_osc_clk       // Static clock gated
);

wire            rx_clock_fifo_wr_clk_mux1;
wire            rx_clock_fifo_wr_clk_mux2;
wire            rx_clock_fifo_wr_clk_mux3;
wire            rx_clock_fifo_wr_clk_mux4;
wire            q1_rx_fifo_wr_clk_en;
wire            q2_rx_fifo_wr_clk_en;
wire            q3_rx_fifo_wr_clk_en;
wire            q4_rx_fifo_wr_clk_en;
wire [2:0]      rx_fifo_wr_clk_sel;

wire		rx_clock_fifo_rd_clk_mux;
wire		rx_clock_fifo_rd_clk_mux1;
wire		rx_fifo_rd_clk_en;

wire		rx_clock_fifo_sclk_mux1;

wire		rx_clock_pld_sclk_mux0;
wire		rx_clock_pld_sclk_mux1;
wire		rx_clock_pld_sclk_mux2;
wire		rx_clock_pld_sclk_mux3;
wire		rx_clock_pld_sclk_mux4;

wire		rx_clock_internal_clk1_mux0;
wire		rx_clock_internal_clk1_mux1;
wire		rx_clock_internal_clk1_mux2;
wire		rx_clock_internal_clk1_mux3;
wire            rx_clock_txfifowr_from_aib_mux1;
wire            rx_clock_txfifowr_post_ct_mux1;
wire            rx_clock_txfiford_post_ct_mux1;
wire            rx_clock_txfiford_pre_ct_mux1;
wire		rx_clock_internal_clk1_mux4;
wire		rx_clock_internal_clk1_mux5;
wire		rx_clock_internal_clk1_mux6;
wire		rx_clock_internal_clk1_mux7;
wire		rx_clock_internal_clk1_mux8;
wire		rx_clock_internal_clk1_mux9;
wire		rx_clock_internal_clk1_mux10;
wire		rx_clock_internal_clk1_mux11;
wire		rx_clock_internal_clk1_mux12;
wire		rx_clock_internal_clk1_mux13;
wire		rx_clock_internal_clk1_mux14;
wire		rx_clock_internal_clk1_mux15;
wire		rx_internal_clk1_sel4;
wire		rx_internal_clk1_sel5;
wire		rx_internal_clk1_sel6;
wire		rx_internal_clk1_sel7;
wire		rx_internal_clk1_sel8;
wire		rx_internal_clk1_sel9;
wire		rx_internal_clk1_sel10;
wire		rx_internal_clk1_sel11;
wire		rx_internal_clk1_sel12;
wire		rx_internal_clk1_sel13;
wire		rx_internal_clk1_sel14;
wire		rx_internal_clk1_sel15;

wire		rx_clock_internal_clk2_mux0;
wire		rx_clock_internal_clk2_mux1;
wire		rx_clock_internal_clk2_mux2;
wire		rx_clock_internal_clk2_mux3;
wire            rx_clock_rxfiford_to_aib_mux1;
wire            rx_clock_rxfiford_post_ct_mux1;
wire            rx_clock_rxfifowr_post_ct_mux1;
wire            rx_clock_rxfifowr_pre_ct_mux1;
wire		rx_clock_internal_clk2_mux4;
wire		rx_clock_internal_clk2_mux5;
wire		rx_clock_internal_clk2_mux6;
wire		rx_clock_internal_clk2_mux7;
wire		rx_clock_internal_clk2_mux8;
wire		rx_clock_internal_clk2_mux9;
wire		rx_clock_internal_clk2_mux10;
wire		rx_clock_internal_clk2_mux11;
wire		rx_clock_internal_clk2_mux12;
wire		rx_clock_internal_clk2_mux13;
wire		rx_clock_internal_clk2_mux14;
wire		rx_clock_internal_clk2_mux15;
wire		rx_internal_clk2_sel4;
wire		rx_internal_clk2_sel5;
wire		rx_internal_clk2_sel6;
wire		rx_internal_clk2_sel7;
wire		rx_internal_clk2_sel8;
wire		rx_internal_clk2_sel9;
wire		rx_internal_clk2_sel10;
wire		rx_internal_clk2_sel11;
wire		rx_internal_clk2_sel12;
wire		rx_internal_clk2_sel13;
wire		rx_internal_clk2_sel14;
wire		rx_internal_clk2_sel15;

wire            rx_hrdrst_rx_osc_clk_en;
wire            rx_osc_clk_en;

wire [2:0]      rx_fifo_rd_clk_sel;


assign aib_hssi_pld_pma_hclk = 1'b0;

// Feedthrough from PMA to AIB
c3lib_ckbuf_ctn ckbuf_rx_pma_aib_div66_clk (
  .out (aib_rx_pma_div66_clk),
  .in  (rx_pma_div66_clk));

c3lib_ckbuf_ctn ckbuf_rx_ehip_early_clk (
  .out (rx_ehip_early_clk),
  .in  (rx_ehip_clk));

c3lib_ckbuf_ctn ckbuf_rx_elane_early_clk (
  .out (rx_elane_early_clk),
  .in  (rx_elane_clk));

c3lib_ckbuf_ctn ckbuf_rx_rsfec_early_clk (
  .out (rx_rsfec_early_clk),
  .in  (rx_rsfec_clk));

c3lib_ckbuf_ctn ckbuf_rx_pma_early_clk (
  .out (rx_pma_early_clk),
  .in  (rx_pma_clk));

// Feedthrough from AIB to PCS
c3lib_mux2_ctn cmn_clkmux2_pma_coreclkin (
  .ck_out    (pld_pma_coreclkin),
  .ck0       (sr_clock_tx_sr_clk_in_div2),
  .ck1       (aib_hssi_pld_pma_coreclkin),
  .s0        (r_rx_pma_coreclkin_sel));

//////////////////
// Clock muxing //
//////////////////

////////// FIFO Write Clock //////////

assign rx_clock_fifo_wr_clk = q1_rx_clock_fifo_wr_clk;

assign rx_clock_reset_fifo_wr_clk = rx_clock_fifo_wr_clk_mux1;

assign q1_rx_fifo_wr_clk_en = (~scan_mode_n) | (~r_rx_fifo_wr_clk_scg_en);
assign q2_rx_fifo_wr_clk_en = (~scan_mode_n) | (~r_rx_fifo_wr_clk_scg_en & r_rx_fifo_power_mode[0]);
assign q3_rx_fifo_wr_clk_en = (~scan_mode_n) | (~r_rx_fifo_wr_clk_scg_en & r_rx_fifo_power_mode[1]);
assign q4_rx_fifo_wr_clk_en = (~scan_mode_n) | (~r_rx_fifo_wr_clk_scg_en & r_rx_fifo_power_mode[1] & r_rx_fifo_power_mode[0]);

c3lib_ckand2_ctn cmn_clkand2_q1_rx_fifo_wr_clk_scg (
  .clk_out    (q1_rx_clock_fifo_wr_clk),
  .clk_in0    (rx_clock_fifo_wr_clk_mux1),
  .clk_in1    (q1_rx_fifo_wr_clk_en)
);

c3lib_ckand2_ctn cmn_clkand2_q2_rx_fifo_wr_clk_scg (
  .clk_out    (q2_rx_clock_fifo_wr_clk),
  .clk_in0    (rx_clock_fifo_wr_clk_mux1),
  .clk_in1    (q2_rx_fifo_wr_clk_en)
);

 c3lib_ckand2_ctn cmn_clkand2_q3_rx_fifo_wr_clk_scg (
  .clk_out    (q3_rx_clock_fifo_wr_clk),
  .clk_in0    (rx_clock_fifo_wr_clk_mux1),
  .clk_in1    (q3_rx_fifo_wr_clk_en)
);

c3lib_ckand2_ctn cmn_clkand2_q4_rx_fifo_wr_clk_scg (
  .clk_out    (q4_rx_clock_fifo_wr_clk),
  .clk_in0    (rx_clock_fifo_wr_clk_mux1),
  .clk_in1    (q4_rx_fifo_wr_clk_en)
);

assign rx_fifo_wr_clk_sel = {3{scan_mode_n}} & r_rx_fifo_wr_clk_sel[2:0];

c3lib_mux2_ctn cmn_clkmux2_rx_fifo_wr_clk_mux1 (
  .ck_out   (rx_clock_fifo_wr_clk_mux1),
  .ck0      (rx_clock_fifo_wr_clk_mux2),
  .ck1      (rx_clock_fifo_wr_clk_mux3),
  .s0       (rx_fifo_wr_clk_sel[2]));

c3lib_mux4_ctn cmn_clkmux2_rx_fifo_wr_clk2 ( 
  .ck_out       (rx_clock_fifo_wr_clk_mux2),
  .ck0          (rx_ehip_clk),
  .ck1          (rx_rsfec_clk),
  .ck2          (rx_elane_clk),
  .ck3          (rx_pma_div2_clk),
  .s0           (rx_fifo_wr_clk_sel[0]),
  .s1           (rx_fifo_wr_clk_sel[1]));

c3lib_mux4_ctn cmn_clkmux2_rx_fifo_wr_clk3 ( 
  .ck_out       (rx_clock_fifo_wr_clk_mux3),
  .ck0          (tx_aib_transfer_clk),             // <-- aib_hssi_tx_transfer_clk
  .ck1          (tx_aib_transfer_div2_clk),
  .ck2          (1'b0),
  .ck3          (1'b0),
  .s0           (rx_fifo_wr_clk_sel[0]),
  .s1           (rx_fifo_wr_clk_sel[1]));

////////// FIFO Read Clock //////////

assign aib_hssi_rx_transfer_clk   = rx_clock_fifo_rd_clk_mux; // Should this be on separate clock source?
assign rx_clock_reset_fifo_rd_clk = rx_clock_fifo_rd_clk_mux;
assign rx_fifo_rd_clk_en          = (~scan_mode_n) | (~r_rx_fifo_rd_clk_scg_en);

// c3adapt_cmn_clkand2 cmn_clkand2_rx_fifo_rd_clk_scg
c3lib_ckand2_ctn cmn_clkand2_rx_fifo_rd_clk_scg (
  .clk_out   (rx_clock_fifo_rd_clk),
  .clk_in0   (rx_clock_fifo_rd_clk_mux),
  .clk_in1   (rx_fifo_rd_clk_en)
);

// assign rx_fifo_rd_static_clk_sel1 = rx_clock_dft_clk_sel_n && (r_rx_fifo_rd_clk_sel == 3'b000);
// assign rx_fifo_rd_static_clk_sel2 = rx_clock_dft_clk_sel_n && (r_rx_fifo_rd_clk_sel == 3'b001);
// assign rx_fifo_rd_static_clk_sel3 = rx_clock_dft_clk_sel_n && (r_rx_fifo_rd_clk_sel == 3'b010);
// assign rx_fifo_rd_static_clk_sel4 = rx_clock_dft_clk_sel_n && (r_rx_fifo_rd_clk_sel == 3'b011);
// assign rx_fifo_rd_static_clk_sel5 = rx_clock_dft_clk_sel_n && (r_rx_fifo_rd_clk_sel == 3'b100);
// assign rx_fifo_rd_static_clk_sel6 = rx_clock_dft_clk_sel_n && (r_rx_fifo_rd_clk_sel == 3'b101);

assign rx_fifo_rd_clk_sel = {3{~scan_mode_n}} | r_rx_fifo_rd_clk_sel;

// Select RX FIFO read clock
// rx_fifo_rd_clk_sel:
// 000: rx_ehip_frd_clk  (RX full-rate distributed)
// 001: rx_rsfec_frd_clk (RX full-rate distributed)
// 010: rx_pma_clk       (RX full-rate)
// 011: tx_pma_clk       (TX full-rate)
// 100: tx_aib_transfer_clk (AIB TX Transfer full-rate); also use this clock for single-width loopback mode.
// else:
c3lib_mux2_ctn cmn_clkmux2_rx_fifo_rd_clk (
  .ck_out   (rx_clock_fifo_rd_clk_mux),
  .ck0      (rx_clock_fifo_rd_clk_mux1),
  .ck1      (tx_aib_transfer_clk),
  .s0       (rx_fifo_rd_clk_sel[2]));

c3lib_mux4_ctn cmn_clkmux4_rx_fifo_rd_clk1 ( 
  .ck_out       (rx_clock_fifo_rd_clk_mux1),
  .ck0          (rx_ehip_frd_clk),
  .ck1          (rx_rsfec_frd_clk),
  .ck2          (rx_pma_clk),
  .ck3          (tx_pma_clk),
  .s0           (rx_fifo_rd_clk_sel[0]),
  .s1           (rx_fifo_rd_clk_sel[1])); 

////////// Sample Clock //////////

assign rx_clock_fifo_sclk = rx_clock_fifo_sclk_mux1;
assign xcvrif_sclk        = rx_clock_fifo_sclk_mux1;

c3dfx_tcm_wrap 
# (
  .SYNC_FUNC_CLKEN   (0),          // Synchronize i_func_clken wih the i_func_clk
  .RESET_VAL         (0),          // Reset value is LOW if set to 0, otherwise HIGH
  .CLK_DIV           (0),          // i_func_clk divided by 2  if set to 2
  .DST_CLK_FREQ_MHZ  (300),        // Clock frequency for destination domain in MHz
  .SRC_DATA_FREQ_MHZ (100)         // Average source data 'frequency' in MHz

) tcm_ckmux2_rx_fifo_sclk (
  .i_func_clk     (aib_hssi_pld_sclk),      
  .i_func_clken   (1'b1),                          
  .i_rst_n        (1'b1),
  .i_test_clk     (test_clk),                      
  .i_scan_clk     (scan_clk),                      
  .i_tst_tcm_ctrl (tst_tcm_ctrl),                  
  .o_clk          (rx_clock_fifo_sclk_mux1));

// c3adapt_cmn_clkmux2 cmn_clkmux2_rx_pld_sclk_mux4
c3lib_mux2_ctn cmn_clkmux2_rx_pld_sclk_mux4 (
  .ck_out   (rx_clock_pld_sclk_mux4),
  .ck0      (rx_clock_pld_sclk_mux3),
  .ck1      (1'b0),
  .s0       (1'b0));

// c3adapt_cmn_clkmux2 cmn_clkmux2_rx_pld_sclk_mux3
c3lib_mux2_ctn cmn_clkmux2_rx_pld_sclk_mux3 (
  .ck_out   (rx_clock_pld_sclk_mux3),
  .ck0      (rx_clock_pld_sclk_mux2),
  .ck1      (1'b0),
  .s0       (1'b0));

// c3adapt_cmn_clkmux2 cmn_clkmux2_rx_pld_sclk_mux2
c3lib_mux2_ctn cmn_clkmux2_rx_pld_sclk_mux2 (
  .ck_out   (rx_clock_pld_sclk_mux2),
  .ck0      (rx_clock_pld_sclk_mux1),
  .ck1      (1'b0),
  .s0       (1'b0));

// c3adapt_cmn_clkmux2 cmn_clkmux2_rx_pld_sclk_mux1
c3lib_mux2_ctn cmn_clkmux2_rx_pld_sclk_mux1 (
  .ck_out   (rx_clock_pld_sclk_mux1),
  .ck0      (rx_clock_pld_sclk_mux0),
  .ck1      (1'b0),
  .s0       (1'b0));

// c3adapt_cmn_clkmux2 cmn_clkmux2_rx_pld_sclk_mux0
c3lib_mux2_ctn cmn_clkmux2_rx_pld_sclk_mux0 (
   .ck_out   (rx_clock_pld_sclk_mux0),
   .ck0      (aib_hssi_pld_sclk),
   .ck1      (1'b0),
   .s0       (1'b0));

////////// TX EQ Clock //////////

//  TXEQ not supported in CR3
assign rx_clock_txeq_clk       = 1'b0;
assign rx_clock_reset_txeq_clk = 1'b0;

////////// Internal Clock 1 //////////

assign aib_hssi_pld_pma_internal_clk1 = rx_clock_internal_clk1_mux0;

// rx_clock_txfifowr_from_aib_mux1 = r_rx_txfifowr_from_aib_sel ? aib_hssi_tx_transfer_clk : rx_clock_pld_sclk_mux1
c3lib_mux2_ctn cmn_clkmux2_rx_internal_clk1_mux0 (
  .ck_out   (rx_clock_internal_clk1_mux0),
  .ck0      (rx_clock_internal_clk1_mux1),
  .ck1      (rx_clock_txfifowr_from_aib_mux1),
  .s0       (r_rx_internal_clk1_sel0));

// c3adapt_cmn_clkmux2 cmn_clkmux2_rx_internal_clk1_mux1
c3lib_mux2_ctn cmn_clkmux2_rx_internal_clk1_mux1 (
   .ck_out   (rx_clock_internal_clk1_mux1),
   .ck0      (rx_clock_internal_clk1_mux2),
   .ck1      (rx_clock_txfifowr_post_ct_mux1),
   .s0       (r_rx_internal_clk1_sel1));

// c3adapt_cmn_clkmux2 cmn_clkmux2_rx_internal_clk1_mux2
c3lib_mux2_ctn cmn_clkmux2_rx_internal_clk1_mux2 (
   .ck_out   (rx_clock_internal_clk1_mux2),
   .ck0      (rx_clock_internal_clk1_mux3),
   .ck1      (rx_clock_txfiford_post_ct_mux1),
   .s0       (r_rx_internal_clk1_sel2));

// c3adapt_cmn_clkmux2 cmn_clkmux2_rx_internal_clk1_mux3
c3lib_mux2_ctn cmn_clkmux2_rx_internal_clk1_mux3 (
   .ck_out   (rx_clock_internal_clk1_mux3),
   .ck0      (rx_clock_internal_clk1_mux4),
   .ck1      (rx_clock_txfiford_pre_ct_mux1),
   .s0       (r_rx_internal_clk1_sel3));

// c3adapt_cmn_clkmux2 cmn_clkmux2_rx_txfifowr_from_aib_mux1
c3lib_mux2_ctn cmn_clkmux2_rx_txfifowr_from_aib_mux1 (
   .ck_out   (rx_clock_txfifowr_from_aib_mux1),
   .ck0      (rx_clock_pld_sclk_mux1),
   .ck1      (tx_aib_transfer_clk),
   .s0       (r_rx_txfifowr_from_aib_sel));

// c3adapt_cmn_clkmux2 cmn_clkmux2_rx_txfifowr_post_ct_mux1
c3lib_mux2_ctn cmn_clkmux2_rx_txfifowr_post_ct_mux1 (
  .ck_out   (rx_clock_txfifowr_post_ct_mux1),
  .ck0      (rx_clock_pld_sclk_mux2),
  .ck1      (tx_clock_fifo_wr_clk),
  .s0       (r_rx_txfifowr_post_ct_sel));

// c3adapt_cmn_clkmux2 cmn_clkmux2_rx_txfiford_post_ct_mux1
c3lib_mux2_ctn cmn_clkmux2_rx_txfiford_post_ct_mux1 (
  .ck_out   (rx_clock_txfiford_post_ct_mux1),
  .ck0      (rx_clock_pld_sclk_mux3),
  .ck1      (tx_clock_fifo_rd_clk),
  .s0       (r_rx_txfiford_post_ct_sel));

// c3adapt_cmn_clkmux2 cmn_clkmux2_rx_txfiford_pre_ct_mux1
c3lib_mux2_ctn cmn_clkmux2_rx_txfiford_pre_ct_mux1 (
    .ck_out (rx_clock_txfiford_pre_ct_mux1),
    .ck0    (rx_clock_pld_sclk_mux4),
    .ck1    (tx_clock_fifo_rd_prect_clk),
    .s0     (r_rx_txfiford_pre_ct_sel));

assign rx_internal_clk1_sel4 = (r_rx_internal_clk1_sel == 4'b0000);
assign rx_internal_clk1_sel5 = (r_rx_internal_clk1_sel == 4'b0001);
assign rx_internal_clk1_sel6 = (r_rx_internal_clk1_sel == 4'b0010);
assign rx_internal_clk1_sel7 = (r_rx_internal_clk1_sel == 4'b0011);
assign rx_internal_clk1_sel8 = (r_rx_internal_clk1_sel == 4'b0100);
assign rx_internal_clk1_sel9 = (r_rx_internal_clk1_sel == 4'b0101);
assign rx_internal_clk1_sel10 = (r_rx_internal_clk1_sel == 4'b0110);
assign rx_internal_clk1_sel11 = (r_rx_internal_clk1_sel == 4'b0111);
assign rx_internal_clk1_sel12 = (r_rx_internal_clk1_sel == 4'b1000);
assign rx_internal_clk1_sel13 = (r_rx_internal_clk1_sel == 4'b1001);
assign rx_internal_clk1_sel14 = (r_rx_internal_clk1_sel == 4'b1010);
assign rx_internal_clk1_sel15 = (r_rx_internal_clk1_sel == 4'b1011);

// c3adapt_cmn_clkmux2 cmn_clkmux2_rx_internal_clk1_mux4
c3lib_mux2_ctn cmn_clkmux2_rx_internal_clk1_mux4 (
  .ck_out   (rx_clock_internal_clk1_mux4),
  .ck0      (rx_clock_internal_clk1_mux5),
  .ck1      (feedthru_clk[0]),
  .s0       (rx_internal_clk1_sel4));

// c3adapt_cmn_clkmux2 cmn_clkmux2_rx_internal_clk1_mux5
c3lib_mux2_ctn cmn_clkmux2_rx_internal_clk1_mux5 (
  .ck_out   (rx_clock_internal_clk1_mux5),
  .ck0      (rx_clock_internal_clk1_mux6),
  .ck1      (feedthru_clk[1]),
  .s0       (rx_internal_clk1_sel5));

// c3adapt_cmn_clkmux2 cmn_clkmux2_rx_internal_clk1_mux6
c3lib_mux2_ctn cmn_clkmux2_rx_internal_clk1_mux6 (
  .ck_out   (rx_clock_internal_clk1_mux6),
  .ck0      (rx_clock_internal_clk1_mux7),
  .ck1      (feedthru_clk[2]),
  .s0       (rx_internal_clk1_sel6));

// c3adapt_cmn_clkmux2 cmn_clkmux2_rx_internal_clk1_mux7
c3lib_mux2_ctn cmn_clkmux2_rx_internal_clk1_mux7 (
  .ck_out   (rx_clock_internal_clk1_mux7),
  .ck0      (rx_clock_internal_clk1_mux8),
  .ck1      (feedthru_clk[3]),
  .s0       (rx_internal_clk1_sel7));

// c3adapt_cmn_clkmux2 cmn_clkmux2_rx_internal_clk1_mux8
c3lib_mux2_ctn cmn_clkmux2_rx_internal_clk1_mux8 (
  .ck_out   (rx_clock_internal_clk1_mux8),
  .ck0      (rx_clock_internal_clk1_mux9),
  .ck1      (feedthru_clk[4]),
  .s0       (rx_internal_clk1_sel8));

// c3adapt_cmn_clkmux2 cmn_clkmux2_rx_internal_clk1_mux9
c3lib_mux2_ctn cmn_clkmux2_rx_internal_clk1_mux9 (
  .ck_out   (rx_clock_internal_clk1_mux9),
  .ck0      (rx_clock_internal_clk1_mux10),
  .ck1      (feedthru_clk[5]),
  .s0       (rx_internal_clk1_sel9));

// c3adapt_cmn_clkmux2 cmn_clkmux2_rx_internal_clk1_mux10
c3lib_mux2_ctn cmn_clkmux2_rx_internal_clk1_mux10 (
  .ck_out   (rx_clock_internal_clk1_mux10),
  .ck0      (rx_clock_internal_clk1_mux11),
  .ck1      (avmm1_clock_avmm_clk_scg),
  .s0       (rx_internal_clk1_sel10));

// c3adapt_cmn_clkmux2 cmn_clkmux2_rx_internal_clk1_mux11
c3lib_mux2_ctn cmn_clkmux2_rx_internal_clk1_mux11 (
  .ck_out   (rx_clock_internal_clk1_mux11),
  .ck0      (rx_clock_internal_clk1_mux12),
  .ck1      (avmm1_clock_avmm_clk_dcg),
  .s0       (rx_internal_clk1_sel11));

// c3adapt_cmn_clkmux2 cmn_clkmux2_rx_internal_clk1_mux12
c3lib_mux2_ctn cmn_clkmux2_rx_internal_clk1_mux12 (
  .ck_out   (rx_clock_internal_clk1_mux12),
  .ck0      (rx_clock_internal_clk1_mux13),
  .ck1      (sr_clock_tx_osc_clk_or_clkdiv),
  .s0       (rx_internal_clk1_sel12));

// c3adapt_cmn_clkmux2 cmn_clkmux2_rx_internal_clk1_mux13
c3lib_mux2_ctn cmn_clkmux2_rx_internal_clk1_mux13 (
  .ck_out   (rx_clock_internal_clk1_mux13),
  .ck0      (rx_clock_internal_clk1_mux14),
  .ck1      (sr_clock_tx_sr_clk_in_div2),
  .s0       (rx_internal_clk1_sel13));

// c3adapt_cmn_clkmux2 cmn_clkmux2_rx_internal_clk1_mux14
c3lib_mux2_ctn cmn_clkmux2_rx_internal_clk1_mux14 (
  .ck_out   (rx_clock_internal_clk1_mux14),
  .ck0      (rx_clock_internal_clk1_mux15),
  .ck1      (aib_hssi_fpll_shared_direct_async_in),
  .s0       (rx_internal_clk1_sel14));

c3lib_mux2_ctn cmn_clkmux2_rx_internal_clk1_mux15 (
  .ck_out   (rx_clock_internal_clk1_mux15),
  .ck0      (1'b0),
  .ck1      (1'b1),
  .s0       (rx_internal_clk1_sel15));

////////// Internal Clock 2 //////////

assign aib_hssi_pld_pma_internal_clk2 = rx_clock_internal_clk2_mux0;

// aib_hssi_rx_transfer_clk = rx_clock_fifo_rd_clk_mux1;
// rx_clock_rxfiford_to_aib_mux1 = r_rx_rxfiford_to_aib_sel ? aib_hssi_rx_transfer_clk : rx_clock_pld_sclk_mux1
c3lib_mux2_ctn cmn_clkmux2_rx_internal_clk2_mux0 (
  .ck_out   (rx_clock_internal_clk2_mux0),
  .ck0      (rx_clock_internal_clk2_mux1),
  .ck1      (rx_clock_rxfiford_to_aib_mux1),
  .s0       (r_rx_internal_clk2_sel0));

// rx_clock_rxfiford_post_ct_mux1 = ? rx_clock_fifo_rd_clk : rx_clock_pld_sclk_mux2
c3lib_mux2_ctn cmn_clkmux2_rx_internal_clk2_mux1 (
  .ck_out   (rx_clock_internal_clk2_mux1),
  .ck0      (rx_clock_internal_clk2_mux2),
  .ck1      (rx_clock_rxfiford_post_ct_mux1),
  .s0       (r_rx_internal_clk2_sel1));

// rx_clock_rxfifowr_post_ct_mux1 = r_rx_rxfifowr_post_ct_sel ? rx_clock_fifo_wr_clk : rx_clock_pld_sclk_mux3
c3lib_mux2_ctn cmn_clkmux2_rx_internal_clk2_mux2 (
   .ck_out   (rx_clock_internal_clk2_mux2),
   .ck0      (rx_clock_internal_clk2_mux3),
   .ck1      (rx_clock_rxfifowr_post_ct_mux1),
   .s0       (r_rx_internal_clk2_sel2));

// rx_clock_rxfifowr_pre_ct_mux1 = r_rx_rxfifowr_pre_ct_sel ? rx_clock_fifo_wr_clk_mux1 : rx_clock_pld_sclk_mux4
c3lib_mux2_ctn cmn_clkmux2_rx_internal_clk2_mux3 (
   .ck_out   (rx_clock_internal_clk2_mux3),
   .ck0      (rx_clock_internal_clk2_mux4),
   .ck1      (rx_clock_rxfifowr_pre_ct_mux1),
   .s0       (r_rx_internal_clk2_sel3));

// c3adapt_cmn_clkmux2 cmn_clkmux2_rx_rxfiford_to_aib_mux1
c3lib_mux2_ctn cmn_clkmux2_rx_rxfiford_to_aib_mux1 (
   .ck_out   (rx_clock_rxfiford_to_aib_mux1),
   .ck0      (rx_clock_pld_sclk_mux1),
   .ck1      (aib_hssi_rx_transfer_clk),
   .s0       (r_rx_rxfiford_to_aib_sel));

// c3adapt_cmn_clkmux2 cmn_clkmux2_rx_rxfiford_post_ct_mux1
c3lib_mux2_ctn cmn_clkmux2_rx_rxfiford_post_ct_mux1 (
   .ck_out   (rx_clock_rxfiford_post_ct_mux1),
   .ck0      (rx_clock_pld_sclk_mux2),
   .ck1      (rx_clock_fifo_rd_clk),
   .s0       (r_rx_rxfiford_post_ct_sel));

// c3adapt_cmn_clkmux2 cmn_clkmux2_rx_rxfifowr_post_ct_mux1
c3lib_mux2_ctn cmn_clkmux2_rx_rxfifowr_post_ct_mux1 (
   .ck_out   (rx_clock_rxfifowr_post_ct_mux1),
   .ck0      (rx_clock_pld_sclk_mux3),
   .ck1      (rx_clock_fifo_wr_clk),
   .s0       (r_rx_rxfifowr_post_ct_sel));

// c3adapt_cmn_clkmux2 cmn_clkmux2_rx_rxfifowr_pre_ct_mux1
c3lib_mux2_ctn cmn_clkmux2_rx_rxfifowr_pre_ct_mux1 (
  .ck_out   (rx_clock_rxfifowr_pre_ct_mux1),
  .ck0      (rx_clock_pld_sclk_mux4),
  .ck1      (rx_clock_fifo_wr_clk_mux1),
  .s0       (r_rx_rxfifowr_pre_ct_sel));

assign rx_internal_clk2_sel4 = (r_rx_internal_clk2_sel == 4'b0000);
assign rx_internal_clk2_sel5 = (r_rx_internal_clk2_sel == 4'b0001);
assign rx_internal_clk2_sel6 = (r_rx_internal_clk2_sel == 4'b0010);
assign rx_internal_clk2_sel7 = (r_rx_internal_clk2_sel == 4'b0011);
assign rx_internal_clk2_sel8 = (r_rx_internal_clk2_sel == 4'b0100);
assign rx_internal_clk2_sel9 = (r_rx_internal_clk2_sel == 4'b0101);
assign rx_internal_clk2_sel10 = (r_rx_internal_clk2_sel == 4'b0110);
assign rx_internal_clk2_sel11 = (r_rx_internal_clk2_sel == 4'b0111);
assign rx_internal_clk2_sel12 = (r_rx_internal_clk2_sel == 4'b1000);
assign rx_internal_clk2_sel13 = (r_rx_internal_clk2_sel == 4'b1001);
assign rx_internal_clk2_sel14 = (r_rx_internal_clk2_sel == 4'b1010);
assign rx_internal_clk2_sel15 = (r_rx_internal_clk2_sel == 4'b1011);

// c3adapt_cmn_clkmux2 cmn_clkmux2_rx_internal_clk2_mux4
c3lib_mux2_ctn cmn_clkmux2_rx_internal_clk2_mux4 (
  .ck_out   (rx_clock_internal_clk2_mux4),
  .ck0      (rx_clock_internal_clk2_mux5),
  .ck1      (feedthru_clk[5]),
  .s0       (rx_internal_clk2_sel4));

// c3adapt_cmn_clkmux2 cmn_clkmux2_rx_internal_clk2_mux5
c3lib_mux2_ctn cmn_clkmux2_rx_internal_clk2_mux5 (
  .ck_out   (rx_clock_internal_clk2_mux5),
  .ck0      (rx_clock_internal_clk2_mux6),
  .ck1      (feedthru_clk[4]),
  .s0       (rx_internal_clk2_sel5));

// c3adapt_cmn_clkmux2 cmn_clkmux2_rx_internal_clk2_mux6
c3lib_mux2_ctn cmn_clkmux2_rx_internal_clk2_mux6 (
  .ck_out   (rx_clock_internal_clk2_mux6),
  .ck0      (rx_clock_internal_clk2_mux7),
  .ck1      (feedthru_clk[3]),
  .s0       (rx_internal_clk2_sel6));

// c3adapt_cmn_clkmux2 cmn_clkmux2_rx_internal_clk2_mux7
c3lib_mux2_ctn cmn_clkmux2_rx_internal_clk2_mux7 (
  .ck_out   (rx_clock_internal_clk2_mux7),
  .ck0      (rx_clock_internal_clk2_mux8),
  .ck1      (feedthru_clk[2]),
  .s0       (rx_internal_clk2_sel7));

// c3adapt_cmn_clkmux2 cmn_clkmux2_rx_internal_clk2_mux8
c3lib_mux2_ctn cmn_clkmux2_rx_internal_clk2_mux8 (
  .ck_out   (rx_clock_internal_clk2_mux8),
  .ck0      (rx_clock_internal_clk2_mux9),
  .ck1      (feedthru_clk[1]),
  .s0       (rx_internal_clk2_sel8));

// c3adapt_cmn_clkmux2 cmn_clkmux2_rx_internal_clk2_mux9
c3lib_mux2_ctn cmn_clkmux2_rx_internal_clk2_mux9 (
  .ck_out   (rx_clock_internal_clk2_mux9),
  .ck0      (rx_clock_internal_clk2_mux10),
  .ck1      (feedthru_clk[0]),
  .s0       (rx_internal_clk2_sel9));

// c3adapt_cmn_clkmux2 cmn_clkmux2_rx_internal_clk2_mux10
c3lib_mux2_ctn cmn_clkmux2_rx_internal_clk2_mux10 (
  .ck_out   (rx_clock_internal_clk2_mux10),
  .ck0      (rx_clock_internal_clk2_mux11),
  .ck1      (avmm2_clock_avmm_clk_scg),
  .s0       (rx_internal_clk2_sel10));

// c3adapt_cmn_clkmux2 cmn_clkmux2_rx_internal_clk2_mux11
c3lib_mux2_ctn cmn_clkmux2_rx_internal_clk2_mux11 (
  .ck_out   (rx_clock_internal_clk2_mux11),
  .ck0      (rx_clock_internal_clk2_mux12),
  .ck1      (avmm2_clock_avmm_clk_dcg),
  .s0       (rx_internal_clk2_sel11));

// c3adapt_cmn_clkmux2 cmn_clkmux2_rx_internal_clk2_mux12
c3lib_mux2_ctn cmn_clkmux2_rx_internal_clk2_mux12 (
  .ck_out   (rx_clock_internal_clk2_mux12),
  .ck0      (rx_clock_internal_clk2_mux13),
  .ck1      (aib_hssi_rx_sr_clk_in),
  .s0       (rx_internal_clk2_sel12));

// c3adapt_cmn_clkmux2 cmn_clkmux2_rx_internal_clk2_mux13
c3lib_mux2_ctn cmn_clkmux2_rx_internal_clk2_mux13 (
  .ck_out   (rx_clock_internal_clk2_mux13),
  .ck0      (rx_clock_internal_clk2_mux14),
  .ck1      (sr_clock_tx_sr_clk_in_div4),
  .s0       (rx_internal_clk2_sel13));

// c3adapt_cmn_clkmux2 cmn_clkmux2_rx_internal_clk2_mux14
c3lib_mux2_ctn cmn_clkmux2_rx_internal_clk2_mux14 (
  .ck_out   (rx_clock_internal_clk2_mux14),
  .ck0      (rx_clock_internal_clk2_mux15),
  .ck1      (aib_hssi_pld_pma_coreclkin),
  .s0       (rx_internal_clk2_sel14));

c3lib_mux2_ctn cmn_clkmux2_rx_internal_clk2_mux15 (
  .ck_out   (rx_clock_internal_clk2_mux15),
  .ck0      (1'b0),
  .ck1      (1'b1),
  .s0       (rx_internal_clk2_sel15));

////////// Rx Oscillator Clock //////////

// Note: aib_hssi_rx_sr_clk_in comes from TCM module residing in srclk_ctl module
assign rx_clock_reset_hrdrst_rx_osc_clk = aib_hssi_rx_sr_clk_in;
assign rx_clock_reset_async_rx_osc_clk  = aib_hssi_rx_sr_clk_in;

assign rx_hrdrst_rx_osc_clk_en = (~scan_mode_n) | (~r_rx_hrdrst_rx_osc_clk_scg_en);
assign rx_osc_clk_en           = (~scan_mode_n) | (~r_rx_osc_clk_scg_en);

c3lib_ckand2_ctn cmn_clkand2_rx_hrdrst_rx_osc_clk_scg (
  .clk_out   (rx_clock_hrdrst_rx_osc_clk),
  .clk_in0   (aib_hssi_rx_sr_clk_in),
  .clk_in1   (rx_hrdrst_rx_osc_clk_en));

// c3adapt_cmn_clkand2 cmn_clkand2_rx_async_rx_osc_clk_scg
c3lib_ckand2_ctn cmn_clkand2_rx_async_rx_osc_clk_scg (
  .clk_out   (rx_clock_async_rx_osc_clk),
  .clk_in0   (aib_hssi_rx_sr_clk_in),
  .clk_in1   (rx_osc_clk_en));

// c3dfx_tcm_wrap 
// # (
//   .SYNC_FUNC_CLKEN   (0),          // Synchronize i_func_clken wih the i_func_clk
//   .RESET_VAL         (0),          // Reset value is LOW if set to 0, otherwise HIGH
//   .CLK_DIV           (0),          // i_func_clk divided by 2  if set to 2
//   .DST_CLK_FREQ_MHZ  (900),        // Clock frequency for destination domain in MHz
//   .SRC_DATA_FREQ_MHZ (100)         // Average source data 'frequency' in MHz
// 
// ) tcm_ckmux2_rx_osc_clk (
//   .i_func_clk     (aib_hssi_rx_sr_clk_in),      
//   .i_func_clken   (1'b1),                          
//   .i_rst_n        (1'b1),
//   .i_test_clk     (test_clk),                      
//   .i_scan_clk     (scan_clk),                      
//   .i_tst_tcm_ctrl (tst_tcm_ctrl),                  
//   .o_clk          (rx_clock_rx_osc_clk_mux1));

////////// Tx Oscillator Clock //////////

assign rx_clock_reset_async_tx_osc_clk = sr_clock_tx_osc_clk_or_clkdiv;

// Note: sr_clock_tx_osc_clk_or_clkdiv should already be controlled by a TCM in c3adapt_srclk_ctl.v
c3lib_ckand2_ctn cmn_clkand2_rx_async_tx_osc_clk_scg (
  .clk_out  (rx_clock_async_tx_osc_clk),
  .clk_in0  (sr_clock_tx_osc_clk_or_clkdiv),
  .clk_in1  (rx_osc_clk_en));


////////// PMA HCLK Clock //////////

assign rx_clock_reset_asn_pma_hclk = 1'b0;

//  ASN not supported in CR3
assign rx_clock_asn_pma_hclk = 1'b0;
assign rx_clock_pld_pma_hclk = 1'b0;

////////// PMA AIB Clock //////////

// Half-rate from SerDes
c3lib_ckbuf_ctn ckbuf_rx_pma_aib_div2_clk (
  .out (aib_rx_pma_div2_clk),
  .in  (rx_pma_div2_clk));

// c3lib_mux2_ctn cmn_clkmux2_rx_pma_aib_tx_clk_mux1 (
//   .ck_out   (rx_clock_pma_aib_tx_clk_mux1),
//   .ck0      (rx_clock_pma_aib_tx_clk_occ),
//   .ck1      (tx_pma_clk),
//   .s0       (rx_clock_dft_clk_sel_n)
// );

endmodule // c3adapt_rxclk_ctl
