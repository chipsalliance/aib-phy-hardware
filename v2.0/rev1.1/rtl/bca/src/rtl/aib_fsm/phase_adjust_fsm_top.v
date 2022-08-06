// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.


module phase_adjust_fsm_top(
			    input m_ns_fwd_clk, //Tx SOC clock
			    input tx_clk_adapter, //Tx adapter clock
			    input tx_clk_even, //Tx_even clock
			    input rx_clk_ana, //piclk_odd(Rx Clock)
			    input rclk_adapt, //piclk_adapter clock
			    input fs_fwd_clk, //Rx SOC Clock
			    input ck_sys, //System clock
			    input reset_n,
			    input phase_tx_adapt_ovrd_sel,
			    input phase_tx_adapt_locked_ovrd,
			    input [3:0]phase_tx_adapt_code_ovrd,
			    input phase_tx_soc_ovrd_sel,
			    input phase_tx_soc_locked_ovrd,
			    input [3:0]phase_tx_soc_code_ovrd,
			    input phase_rx_adapt_ovrd_sel,
			    input phase_rx_adapt_locked_ovrd,
			    input [3:0]phase_rx_adapt_code_ovrd,
			    input phase_rx_soc_ovrd_sel,
			    input phase_rx_soc_locked_ovrd,
			    input [3:0]phase_rx_soc_code_ovrd,
			    input tx_adapt_start_phase_lock,
			    input tx_ana_start_phase_lock,
			    input rx_adapt_start_phase_lock,
			    input rx_ana_start_phase_lock,
			    input tx_en,
			    input rx_en,
			    input [1:0]sel_avg,
			    output wire tx_adapt_phase_locked,
			    output wire tx_ana_phase_locked,
			    output wire rx_adapt_phase_locked,
			    output wire rx_ana_phase_locked,
			    output wire [3:0]tx_adapt_phase_sel_code, //dll_ckadapter_code
			    output wire [3:0]tx_ana_phase_sel_code, //dll_cksoc_code
			    output wire [3:0]rx_adapt_phase_sel_code, //dll_piadapter_code
			    output wire [3:0]rx_ana_phase_sel_code //dll_pisoc_code
			   );


//Transmitter Block
phase_adjust_fsm i_tx_adapt(
	.ref_clk(m_ns_fwd_clk), //TDB
	.rst_n(reset_n),
	.phase_adjust_ovrd_sel(phase_tx_adapt_ovrd_sel),
	.phase_locked_ovrd(phase_tx_adapt_locked_ovrd),
	.phase_sel_code_ovrd(phase_tx_adapt_code_ovrd),
	.sample_clk(tx_clk_adapter),
	.sys_clk(ck_sys), //System clock
	.start_phase_lock(tx_adapt_start_phase_lock),
	.enable(tx_en),
	.sel_avg(sel_avg), //From AVMM
	.phase_locked(tx_adapt_phase_locked),
	.phase_sel_code(tx_adapt_phase_sel_code)
	 );

phase_adjust_fsm i_tx_analog(
	.ref_clk(tx_clk_adapter), //Adapter Clock
	.rst_n(reset_n),
	.phase_adjust_ovrd_sel(phase_tx_soc_ovrd_sel),
	.phase_locked_ovrd(phase_tx_soc_locked_ovrd),
	.phase_sel_code_ovrd(phase_tx_soc_code_ovrd),
	.sample_clk(tx_clk_even), //TXDLL even Clock
	.sys_clk(ck_sys), //System clock
	.start_phase_lock(tx_ana_start_phase_lock),
	.enable(tx_en),
	.sel_avg(sel_avg),
	.phase_locked(tx_ana_phase_locked),
	.phase_sel_code(tx_ana_phase_sel_code)
	 );

//Receiver Block
phase_adjust_fsm i_rx_analog(
	.ref_clk(rx_clk_ana),
	.rst_n(reset_n),
	.phase_adjust_ovrd_sel(phase_rx_soc_ovrd_sel),
	.phase_locked_ovrd(phase_rx_soc_locked_ovrd),
	.phase_sel_code_ovrd(phase_rx_soc_code_ovrd),
	.sample_clk(rclk_adapt), //piclk_adapt
	.sys_clk(ck_sys), //System clock
	.start_phase_lock(rx_ana_start_phase_lock),
	.enable(rx_en),
	.sel_avg(sel_avg),
	.phase_locked(rx_ana_phase_locked),
	.phase_sel_code(rx_adapt_phase_sel_code)
	 );

phase_adjust_fsm i_rx_adapt(
	.ref_clk(rclk_adapt), //piclk_adapt
	.rst_n(reset_n),
	.phase_adjust_ovrd_sel(phase_rx_adapt_ovrd_sel),
	.phase_locked_ovrd(phase_rx_adapt_locked_ovrd),
	.phase_sel_code_ovrd(phase_rx_adapt_code_ovrd),
	.sample_clk(fs_fwd_clk), //piclk_soc
	.sys_clk(ck_sys),
	.start_phase_lock(rx_adapt_start_phase_lock),
	.enable(rx_en),
	.sel_avg(sel_avg),
	.phase_locked(rx_adapt_phase_locked),
	.phase_sel_code(rx_ana_phase_sel_code)
	 );

endmodule
