// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3aibadapt_srrst_ctl
(
	input   wire            csr_rdy_dly_in,
	input	wire		sr_clock_tx_sr_clk_in,
	input	wire		sr_clock_reset_rx_osc_clk,
	input	wire		sr_clock_reset_tx_osc_clk,
	input	wire		r_sr_free_run_div_clk,
	input	wire		dft_adpt_rst,
	input	wire		adapter_scan_rst_n,
	input	wire		adapter_scan_mode_n,
	output	wire		sr_reset_tx_sr_clk_in_rst_n,
	output	wire		sr_reset_rx_osc_clk_rst_n,
	output	wire		sr_reset_tx_osc_clk_rst_n
);

	wire		int_sr_hrd_rst_n;
	wire            int_div_clk_rst_n_bypass;
        wire            int_div_clk_scan_mode_n;
	//wire	sr_reset_tx_sr_clk_in_rst_n_int;

assign int_sr_hrd_rst_n = (adapter_scan_mode_n & ~dft_adpt_rst & csr_rdy_dly_in) | (~adapter_scan_mode_n & adapter_scan_rst_n);

// hd_dpcmn_rst_n_sync hd_dpcmn_rst_n_sync_rx_osc_clk
c3lib_rstsync #(.RESET_VAL(0), .DST_CLK_FREQ_MHZ(1000))
  rst_sync_rx_osc_clk 
  (
  .rst_n(int_sr_hrd_rst_n),
  .rst_n_bypass(adapter_scan_rst_n),
  .clk (sr_clock_reset_rx_osc_clk),
  .scan_mode_n(adapter_scan_mode_n),
  .rst_n_sync(sr_reset_rx_osc_clk_rst_n)
  );

// hd_dpcmn_rst_n_sync hd_dpcmn_rst_n_sync_tx_osc_clk
c3lib_rstsync #(.RESET_VAL(0), .DST_CLK_FREQ_MHZ(1000))
  rst_sync_tx_osc_clk 
  (
  .rst_n(int_sr_hrd_rst_n),
  .rst_n_bypass(adapter_scan_rst_n),
  .clk (sr_clock_reset_tx_osc_clk),
  .scan_mode_n(adapter_scan_mode_n),
  .rst_n_sync(sr_reset_tx_osc_clk_rst_n)
  );

        assign int_div_clk_rst_n_bypass = (adapter_scan_mode_n | adapter_scan_rst_n);
        assign int_div_clk_scan_mode_n = (adapter_scan_mode_n & ~r_sr_free_run_div_clk);

// hd_dpcmn_rst_n_sync hd_dpcmn_rst_n_sync_tx_sr_clk_in
c3lib_rstsync #(.RESET_VAL(0), .DST_CLK_FREQ_MHZ(1000))
  rst_sync_tx_sr_clk_in 
  (
  .rst_n(int_sr_hrd_rst_n),
  .rst_n_bypass(int_div_clk_rst_n_bypass),
  .clk (sr_clock_tx_sr_clk_in),
  .scan_mode_n(int_div_clk_scan_mode_n),
  .rst_n_sync(sr_reset_tx_sr_clk_in_rst_n)
  );

 //assign sr_reset_tx_sr_clk_in_rst_n = (r_sr_free_run_div_clk) ? 1'b1 : sr_reset_tx_sr_clk_in_rst_n_int;

endmodule // c3aibadapt_srrst_ctl
