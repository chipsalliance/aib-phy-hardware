// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module hdpldadapt_hrdrst_clkctl
(
	input	wire		aib_fabric_rx_sr_clk_in,
	input	wire		aib_fabric_tx_sr_clk_in,
	input	wire		csr_clk_in,
	input	wire		r_avmm_hrdrst_osc_clk_scg_en,
	input	wire		dft_adpt_aibiobsr_fastclkn,
       	input   wire            adapter_scan_mode_n,
        input   wire            adapter_scan_shift_n,
        input   wire            adapter_scan_shift_clk,
        input   wire            adapter_scan_user_clk3,         // 1GHz
        input   wire            adapter_clk_sel_n,
        input   wire            adapter_occ_enable,
	output	wire		avmm_clock_reset_hrdrst_rx_osc_clk,
	output	wire		avmm_clock_reset_hrdrst_tx_osc_clk,
	output	wire		avmm_clock_hrdrst_rx_osc_clk,
	output	wire		avmm_clock_hrdrst_tx_osc_clk,
        output  wire            avmm_clock_csr_clk,
        output  wire            avmm_clock_csr_clk_n,
	output	wire		csr_clk_out
);

        //wire            adapter_scan_mode;
        wire            adapter_scan_shift;
	wire            avmm_clock_dft_scg_bypass;
        wire            avmm_clock_dft_clk_sel_n;
        wire            avmm_clock_dft_occ_atpg_mode;

        wire            avmm_clock_csr_clk_mux1;
        wire            avmm_clock_csr_clk_n_mux1;
        wire            csr_clk_in_n;

        wire            avmm_clock_hrdrst_rx_osc_clk_mux1;
        wire            avmm_clock_hrdrst_rx_osc_clk_occ;
        wire            avmm_hrdrst_osc_clk_en;

        wire            avmm_clock_hrdrst_tx_osc_clk_mux1;
        wire            avmm_clock_hrdrst_tx_osc_clk_occ;

        // DFX
        //assign adapter_scan_mode = ~adapter_scan_mode_n;
        assign adapter_scan_shift = ~adapter_scan_shift_n;
	assign avmm_clock_dft_scg_bypass = ~dft_adpt_aibiobsr_fastclkn | ~adapter_scan_mode_n;
	assign avmm_clock_dft_clk_sel_n = dft_adpt_aibiobsr_fastclkn & adapter_scan_mode_n;

	assign avmm_clock_dft_occ_atpg_mode = ~adapter_scan_mode_n;

	// Feedthrough
	assign csr_clk_out = csr_clk_in;

//////////////////
// Clock muxing //
//////////////////

assign avmm_clock_csr_clk = avmm_clock_csr_clk_mux1;
assign avmm_clock_csr_clk_n = avmm_clock_csr_clk_n_mux1;

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_avmm_clock_csr_clk_mux1
    (
        .clk_o(avmm_clock_csr_clk_mux1),
        .clk_0(adapter_scan_shift_clk),
        .clk_1(csr_clk_in),
        .clk_sel(adapter_scan_mode_n)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_avmm_clock_csr_clk_n_mux1
    (
        .clk_o(avmm_clock_csr_clk_n_mux1),
        .clk_0(adapter_scan_shift_clk),
        .clk_1(csr_clk_in_n),
        .clk_sel(adapter_scan_mode_n)
    );

hdpldadapt_cmn_clkinv hdpldadapt_cmn_clkinv_csr_clk_in_inv
    (
        .clkout(csr_clk_in_n),
        .clk(csr_clk_in)
    );

////////// Rx Oscillator Clock //////////

assign avmm_clock_reset_hrdrst_rx_osc_clk = avmm_clock_hrdrst_rx_osc_clk_mux1;

assign avmm_hrdrst_osc_clk_en = avmm_clock_dft_scg_bypass | ~r_avmm_hrdrst_osc_clk_scg_en;

hdpldadapt_cmn_clkand2 hdpldadapt_cmn_clkand2_avmm_hrdrst_rx_osc_clk_scg
    (
        .clkout(avmm_clock_hrdrst_rx_osc_clk),
        .clk(avmm_clock_hrdrst_rx_osc_clk_mux1),
        .en(avmm_hrdrst_osc_clk_en)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_avmm_hrdrst_rx_osc_clk_mux1
    (
        .clk_o(avmm_clock_hrdrst_rx_osc_clk_mux1),
        .clk_0(avmm_clock_hrdrst_rx_osc_clk_occ),
        .clk_1(aib_fabric_rx_sr_clk_in),
        .clk_sel(avmm_clock_dft_clk_sel_n)
    );

hdpldadapt_cmn_dft_clock_controller 
    #(
        .CONTROL_REGISTER_PRESENT(1)
    ) hdpldadapt_cmn_dft_clock_controller_avmm_hrdrst_rx_osc_clk_occ14
    (
        .user_clk(adapter_scan_user_clk3),              //User clock
        .test_clk(adapter_scan_shift_clk),              //Test clock
        .rst_n(1'b0),                                   //Reset (active low)
        .clk_sel_n(adapter_clk_sel_n),                  //Mux sel between user or test clock, Active low
        .scan_enable(adapter_scan_shift),               //Scan enable control signal, Active high in IP, Active low in top level
        .occ_enable(adapter_occ_enable),                //Control signal to enable OCC, Active high in IP, Active low in top level
        .atpg_mode(avmm_clock_dft_occ_atpg_mode),	//Control signal for test mode, Active high in IP, Active low in top level
        .out_clk(avmm_clock_hrdrst_rx_osc_clk_occ)      //Output clock
    );

////////// Tx Oscillator Clock //////////

assign avmm_clock_reset_hrdrst_tx_osc_clk = avmm_clock_hrdrst_tx_osc_clk_mux1;

hdpldadapt_cmn_clkand2 hdpldadapt_cmn_clkand2_avmm_hrdrst_tx_osc_clk_scg
    (
        .clkout(avmm_clock_hrdrst_tx_osc_clk),
        .clk(avmm_clock_hrdrst_tx_osc_clk_mux1),
        .en(avmm_hrdrst_osc_clk_en)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_avmm_hrdrst_tx_osc_clk_mux1
    (
        .clk_o(avmm_clock_hrdrst_tx_osc_clk_mux1),
        .clk_0(avmm_clock_hrdrst_tx_osc_clk_occ),
        .clk_1(aib_fabric_tx_sr_clk_in),
        .clk_sel(avmm_clock_dft_clk_sel_n)
    );

hdpldadapt_cmn_dft_clock_controller 
    #(
        .CONTROL_REGISTER_PRESENT(1)
    ) hdpldadapt_cmn_dft_clock_controller_avmm_hrdrst_tx_osc_clk_occ15
    (
        .user_clk(adapter_scan_user_clk3),              //User clock
        .test_clk(adapter_scan_shift_clk),              //Test clock
        .rst_n(1'b0),                                   //Reset (active low)
        .clk_sel_n(adapter_clk_sel_n),                  //Mux sel between user or test clock, Active low
        .scan_enable(adapter_scan_shift),               //Scan enable control signal, Active high in IP, Active low in top level
        .occ_enable(adapter_occ_enable),                //Control signal to enable OCC, Active high in IP, Active low in top level
        .atpg_mode(avmm_clock_dft_occ_atpg_mode),	//Control signal for test mode, Active high in IP, Active low in top level
        .out_clk(avmm_clock_hrdrst_tx_osc_clk_occ)               //Output clock
    );

endmodule // hdpldadapt_hrdrst_clkctl
