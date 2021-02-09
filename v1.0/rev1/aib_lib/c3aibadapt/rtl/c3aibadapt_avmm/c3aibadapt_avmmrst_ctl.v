// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3aibadapt_avmmrst_ctl
(
	input	wire		csr_rdy_dly_in,
	input	wire		avmm_clock_reset_rx_osc_clk,
	input	wire		avmm_clock_reset_tx_osc_clk,
	input	wire		avmm_clock_reset_avmm_clk,
	input	wire		r_avmm_free_run_div_clk,
	input	wire		dft_adpt_rst,
	input	wire		scan_rst_n,
	input	wire		scan_mode_n,
	output	wire		avmm_reset_rx_osc_clk_rst_n,
	output	wire		avmm_reset_rx_osc_clk_for_clkdiv_rst_n,
	output	wire		avmm_reset_tx_osc_clk_rst_n,
	output	wire		avmm_reset_avmm_rst_n
);

	wire		int_avmm_hrd_rst_n;
	wire            int_div_clk_rst_n_bypass;
        wire            int_div_clk_scan_mode_n;

assign int_avmm_hrd_rst_n = (scan_mode_n & ~dft_adpt_rst & csr_rdy_dly_in) | (~scan_mode_n & scan_rst_n);

// hd_dpcmn_rst_n_sync hd_dpcmn_rst_n_sync_rx_osc_clk
c3lib_rstsync #(.RESET_VAL(0), .DST_CLK_FREQ_MHZ(1000))
  rst_n_sync_rx_osc_clk 
  (
  .rst_n(int_avmm_hrd_rst_n),
  .rst_n_bypass(scan_rst_n),
  .clk (avmm_clock_reset_rx_osc_clk),
  .scan_mode_n(scan_mode_n),
  .rst_n_sync(avmm_reset_rx_osc_clk_rst_n)
  );

c3lib_rstsync #(.RESET_VAL(0), .DST_CLK_FREQ_MHZ(1000))
  rst_n_sync_tx_osc_clk 
  (
  .rst_n(int_avmm_hrd_rst_n),
  .rst_n_bypass(scan_rst_n),
  .clk (avmm_clock_reset_tx_osc_clk),
  .scan_mode_n(scan_mode_n),
  .rst_n_sync(avmm_reset_tx_osc_clk_rst_n)
  );

c3lib_rstsync #(.RESET_VAL(0), .DST_CLK_FREQ_MHZ(200))
  rst_n_sync_avmm_clk
  (
  .rst_n(int_avmm_hrd_rst_n),
  .rst_n_bypass(scan_rst_n),
  .clk (avmm_clock_reset_avmm_clk),
  .scan_mode_n(scan_mode_n),
  .rst_n_sync(avmm_reset_avmm_rst_n)
  );

assign int_div_clk_rst_n_bypass = (scan_mode_n | scan_rst_n);
assign int_div_clk_scan_mode_n = (scan_mode_n & ~r_avmm_free_run_div_clk);

c3lib_rstsync #(.RESET_VAL(0), .DST_CLK_FREQ_MHZ(1000))
  rst_n_sync_rx_osc_clk_for_clkdiv 
  (
  .rst_n(int_avmm_hrd_rst_n),
  .rst_n_bypass(int_div_clk_rst_n_bypass),
  .clk (avmm_clock_reset_rx_osc_clk),
  .scan_mode_n(int_div_clk_scan_mode_n),
  .rst_n_sync(avmm_reset_rx_osc_clk_for_clkdiv_rst_n)
  );

	//assign avmm_reset_rx_osc_clk_for_clkdiv_rst_n = (r_avmm_free_run_div_clk) ? 1'b1 : avmm_reset_rx_osc_clk_rst_n;

endmodule // c3aibadapt_avmmrst_ctl
