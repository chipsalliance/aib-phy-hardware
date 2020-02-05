// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module hdpldadapt_srrst_ctl
(
	input   wire            csr_rdy_dly_in,
	input	wire		sr_clock_reset_rx_osc_clk,
	input	wire		sr_clock_reset_tx_osc_clk,
	input	wire		adapter_scan_rst_n,
	input	wire		adapter_scan_mode_n,
	output	wire		sr_reset_rx_osc_clk_rst_n,
	output	wire		sr_reset_tx_osc_clk_rst_n
);

	wire		int_sr_hrd_rst_n;

assign int_sr_hrd_rst_n = (adapter_scan_mode_n & csr_rdy_dly_in) | (~adapter_scan_mode_n & adapter_scan_rst_n);

cdclib_rst_n_sync cdclib_rst_n_sync_rx_osc_clk
	(
	.rst_n(int_sr_hrd_rst_n),
	.rst_n_bypass(adapter_scan_rst_n),
	.clk (sr_clock_reset_rx_osc_clk),
	.scan_mode_n(adapter_scan_mode_n),
	.rst_n_sync(sr_reset_rx_osc_clk_rst_n)
	);

cdclib_rst_n_sync cdclib_rst_n_sync_tx_osc_clk
	(
	.rst_n(int_sr_hrd_rst_n),
	.rst_n_bypass(adapter_scan_rst_n),
	.clk (sr_clock_reset_tx_osc_clk),
	.scan_mode_n(adapter_scan_mode_n),
	.rst_n_sync(sr_reset_tx_osc_clk_rst_n)
	);

endmodule // hdpldadapt_srrst_ctl
