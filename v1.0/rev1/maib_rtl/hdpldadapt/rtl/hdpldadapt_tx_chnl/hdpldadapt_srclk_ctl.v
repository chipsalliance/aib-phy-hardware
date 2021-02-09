// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module hdpldadapt_srclk_ctl
(
	input	wire		aib_fabric_rx_sr_clk_in,
	input	wire		aib_fabric_tx_sr_clk_in,
	input	wire            r_sr_osc_clk_scg_en,
	input	wire		dft_adpt_aibiobsr_fastclkn,
        input   wire            adapter_scan_mode_n,
        input   wire            adapter_scan_shift_n,
        input   wire            adapter_scan_shift_clk,
        input   wire            adapter_scan_user_clk3,         // 1GHz
        input   wire            adapter_clk_sel_n,
        input   wire            adapter_occ_enable,
	output	wire		aib_fabric_tx_sr_clk_out,
	output	wire		sr_clock_reset_rx_osc_clk,
	output	wire		sr_clock_reset_tx_osc_clk,
	output	wire		sr_clock_rx_osc_clk,
	output	wire		sr_clock_tx_osc_clk
);

        //wire            adapter_scan_mode;
        wire            adapter_scan_shift;
	wire            sr_clock_dft_scg_bypass;
	wire            sr_clock_dft_clk_sel_n;
	wire            sr_clock_dft_occ_atpg_mode;

        wire            sr_clock_rx_osc_clk_mux1;
        wire            sr_clock_rx_osc_clk_occ;
        wire            sr_osc_clk_en;

        wire            sr_clock_tx_osc_clk_mux1;
        wire            sr_clock_tx_osc_clk_occ;

        // DFX
        //assign adapter_scan_mode = ~adapter_scan_mode_n;
        assign adapter_scan_shift = ~adapter_scan_shift_n;
	assign sr_clock_dft_scg_bypass = ~dft_adpt_aibiobsr_fastclkn | ~adapter_scan_mode_n;
        assign sr_clock_dft_clk_sel_n = dft_adpt_aibiobsr_fastclkn & adapter_scan_mode_n;

        assign sr_clock_dft_occ_atpg_mode = ~adapter_scan_mode_n;

//////////////////
// Clock muxing //
//////////////////

////////// Rx Oscillator Clock //////////

assign sr_clock_reset_rx_osc_clk = sr_clock_rx_osc_clk_mux1;

assign sr_osc_clk_en = sr_clock_dft_scg_bypass | ~r_sr_osc_clk_scg_en;

hdpldadapt_cmn_clkand2 hdpldadapt_cmn_clkand2_sr_rx_osc_clk_scg
    (
        .clkout(sr_clock_rx_osc_clk),
        .clk(sr_clock_rx_osc_clk_mux1),
        .en(sr_osc_clk_en)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_sr_rx_osc_clk_mux1
    (
        .clk_o(sr_clock_rx_osc_clk_mux1),
        .clk_0(sr_clock_rx_osc_clk_occ),
        .clk_1(aib_fabric_rx_sr_clk_in),
        .clk_sel(sr_clock_dft_clk_sel_n)
    );

hdpldadapt_cmn_dft_clock_controller 
    #(
        .CONTROL_REGISTER_PRESENT(1)
    ) hdpldadapt_cmn_dft_clock_controller_sr_rx_osc_clk_occ12
    (
        .user_clk(adapter_scan_user_clk3),              //User clock
        .test_clk(adapter_scan_shift_clk),              //Test clock
        .rst_n(1'b0),                                   //Reset (active low)
        .clk_sel_n(adapter_clk_sel_n),                  //Mux sel between user or test clock, Active low
        .scan_enable(adapter_scan_shift),               //Scan enable control signal, Active high in IP, Active low in top level
        .occ_enable(adapter_occ_enable),                //Control signal to enable OCC, Active high in IP, Active low in top level
        .atpg_mode(sr_clock_dft_occ_atpg_mode),		//Control signal for test mode, Active high in IP, Active low in top level
        .out_clk(sr_clock_rx_osc_clk_occ)               //Output clock
    );

////////// Tx Oscillator Clock //////////

//assign aib_fabric_tx_sr_clk_out = aib_fabric_tx_sr_clk_in;

assign aib_fabric_tx_sr_clk_out = sr_clock_tx_osc_clk_mux1;
assign sr_clock_reset_tx_osc_clk = sr_clock_tx_osc_clk_mux1;

hdpldadapt_cmn_clkand2 hdpldadapt_cmn_clkand2_sr_tx_osc_clk_scg
    (
        .clkout(sr_clock_tx_osc_clk),
        .clk(sr_clock_tx_osc_clk_mux1),
        .en(sr_osc_clk_en)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_sr_clock_tx_sr_clk_in_mux1
    (
        .clk_o(sr_clock_tx_osc_clk_mux1),
        .clk_0(sr_clock_tx_osc_clk_occ),
        .clk_1(aib_fabric_tx_sr_clk_in),
        .clk_sel(sr_clock_dft_clk_sel_n)
    );

hdpldadapt_cmn_dft_clock_controller
    #(
        .CONTROL_REGISTER_PRESENT(1)
    ) hdpldadapt_cmn_dft_clock_controller_sr_tx_osc_clk_occ13
    (
        .user_clk(adapter_scan_user_clk3),              //User clock
        .test_clk(adapter_scan_shift_clk),              //Test clock
        .rst_n(1'b0),                                   //Reset (active low)
        .clk_sel_n(adapter_clk_sel_n),                  //Mux sel between user or test clock, Active low
        .scan_enable(adapter_scan_shift),               //Scan enable control signal, Active high in IP, Active low in top level
        .occ_enable(adapter_occ_enable),                //Control signal to enable OCC, Active high in IP, Active low in top level
        .atpg_mode(sr_clock_dft_occ_atpg_mode),		//Control signal for test mode, Active high in IP, Active low in top level
        .out_clk(sr_clock_tx_osc_clk_occ)               //Output clock
    );




endmodule // hdpldadapt_srclk_ctl
