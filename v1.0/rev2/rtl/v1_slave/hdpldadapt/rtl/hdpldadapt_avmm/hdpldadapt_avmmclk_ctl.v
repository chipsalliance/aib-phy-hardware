// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module hdpldadapt_avmmclk_ctl
(
	input	wire		csr_rdy_in,
	input	wire		csr_rdy_dly_in,
	input	wire		csr_clk_in,
	input	wire		aib_fabric_rx_sr_clk_in,
	input	wire		aib_fabric_tx_sr_clk_in,
	input	wire		pld_avmm_clk_rowclk,
	input	wire		nfrzdrv_in,
	input	wire		avmm_reset_avmm_rst_n,
	input	wire		r_avmm_osc_clk_scg_en,
	input	wire		r_avmm_avmm_clk_scg_en,
	input	wire		dft_adpt_aibiobsr_fastclkn,
        input   wire            adapter_scan_mode_n,
        input   wire            adapter_scan_shift_n,
        input   wire            adapter_scan_shift_clk,
        input   wire            adapter_scan_user_clk0,         // 125MHz
        input   wire            adapter_scan_user_clk3,         // 1GHz
        input   wire            adapter_clk_sel_n,
        input   wire            adapter_occ_enable,
	output	wire		avmm_clock_reset_rx_osc_clk,
	output	wire		avmm_clock_reset_tx_osc_clk,
	output	wire		avmm_clock_reset_avmm_clk,
	output	wire		avmm_clock_rx_osc_clk,
	output	wire		avmm_clock_tx_osc_clk,
	output	wire		avmm_clock_avmm_clk,
	output	wire		avmm_clock_dprio_clk,
	output	wire		pld_avmm_clk_out
);

        //wire            adapter_scan_mode;
        wire            adapter_scan_shift;
	wire            avmm_clock_dft_scg_bypass;
	wire            avmm_clock_dft_clk_sel_n;
	wire            avmm_clock_dft_occ_atpg_mode;

	wire		frz_2one_by_nfrzdrv;

        wire            avmm_clock_rx_osc_clk_mux1;
        wire            avmm_clock_rx_osc_clk_occ;
        wire            avmm_osc_clk_en;

        wire            avmm_clock_tx_osc_clk_mux1;
        wire            avmm_clock_tx_osc_clk_occ;

        wire            avmm_clock_dprio_clk_mux1;
        wire            avmm_clock_dprio_clk_mux2;
        wire            avmm_clock_dprio_clk_occ;
        wire            avmm_dprio_clk_sel1;
        wire            avmm_dprio_clk_sel2;
        wire            avmm_clock_avmm_clk_gate;
        reg             avmm_clk_gate;

        wire            avmm_clock_avmm_clk_mux1;
        wire            avmm_clock_avmm_clk_occ;
        wire            avmm_avmm_clk_en;

 
        assign adapter_scan_shift = ~adapter_scan_shift_n;
	assign avmm_clock_dft_scg_bypass = ~dft_adpt_aibiobsr_fastclkn | ~adapter_scan_mode_n;
	assign avmm_clock_dft_clk_sel_n = dft_adpt_aibiobsr_fastclkn & adapter_scan_mode_n;

	assign avmm_clock_dft_occ_atpg_mode = ~adapter_scan_mode_n;



assign frz_2one_by_nfrzdrv = ~(nfrzdrv_in);

hdpldadapt_cmn_clkor2 hdpldadapt_cmn_clkor2_pld_avmm_clk_rowclk
    (
        .clkout(pld_avmm_clk_out),
        .clk(pld_avmm_clk_rowclk),
        .en(frz_2one_by_nfrzdrv)
    );

//////////////////
// Clock muxing //
//////////////////

////////// Rx Oscillator Clock //////////

assign avmm_clock_reset_rx_osc_clk = avmm_clock_rx_osc_clk_mux1;

assign avmm_osc_clk_en = avmm_clock_dft_scg_bypass | ~r_avmm_osc_clk_scg_en;

hdpldadapt_cmn_clkand2 hdpldadapt_cmn_clkand2_avmm_rx_osc_clk_scg
    (
        .clkout(avmm_clock_rx_osc_clk),
        .clk(avmm_clock_rx_osc_clk_mux1),
        .en(avmm_osc_clk_en)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_avmm_rx_osc_clk_mux1
    (
        .clk_o(avmm_clock_rx_osc_clk_mux1),
        .clk_0(avmm_clock_rx_osc_clk_occ),
        .clk_1(aib_fabric_rx_sr_clk_in),
        .clk_sel(avmm_clock_dft_clk_sel_n)
    );

hdpldadapt_cmn_dft_clock_controller 
    #(
        .CONTROL_REGISTER_PRESENT(1)
    ) hdpldadapt_cmn_dft_clock_controller_avmm_rx_osc_clk_occ
    (
        .user_clk(adapter_scan_user_clk3),              //User clock
        .test_clk(adapter_scan_shift_clk),              //Test clock
        .rst_n(1'b0),                                   //Reset (active low)
        .clk_sel_n(adapter_clk_sel_n),                  //Mux sel between user or test clock, Active low
        .scan_enable(adapter_scan_shift),               //Scan enable control signal, Active high in IP, Active low in top level
        .occ_enable(adapter_occ_enable),                //Control signal to enable OCC, Active high in IP, Active low in top level
        .atpg_mode(avmm_clock_dft_occ_atpg_mode),	//Control signal for test mode, Active high in IP, Active low in top level
        .out_clk(avmm_clock_rx_osc_clk_occ)               //Output clock
    );

////////// Tx Oscillator Clock //////////

assign avmm_clock_reset_tx_osc_clk = avmm_clock_tx_osc_clk_mux1;

hdpldadapt_cmn_clkand2 hdpldadapt_cmn_clkand2_avmm_tx_osc_clk_scg
    (
        .clkout(avmm_clock_tx_osc_clk),
        .clk(avmm_clock_tx_osc_clk_mux1),
        .en(avmm_osc_clk_en)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_avmm_tx_osc_clk_mux1
    (
        .clk_o(avmm_clock_tx_osc_clk_mux1),
        .clk_0(avmm_clock_tx_osc_clk_occ),
        .clk_1(aib_fabric_tx_sr_clk_in),
        .clk_sel(avmm_clock_dft_clk_sel_n)
    );

hdpldadapt_cmn_dft_clock_controller 
    #(
        .CONTROL_REGISTER_PRESENT(1)
    ) hdpldadapt_cmn_dft_clock_controller_avmm_tx_osc_clk_occ
    (
        .user_clk(adapter_scan_user_clk3),              //User clock
        .test_clk(adapter_scan_shift_clk),              //Test clock
        .rst_n(1'b0),                                   //Reset (active low)
        .clk_sel_n(adapter_clk_sel_n),                  //Mux sel between user or test clock, Active low
        .scan_enable(adapter_scan_shift),               //Scan enable control signal, Active high in IP, Active low in top level
        .occ_enable(adapter_occ_enable),                //Control signal to enable OCC, Active high in IP, Active low in top level
        .atpg_mode(avmm_clock_dft_occ_atpg_mode),	//Control signal for test mode, Active high in IP, Active low in top level
        .out_clk(avmm_clock_tx_osc_clk_occ)               //Output clock
    );

////////// DPRIO Clock //////////

assign avmm_clock_dprio_clk = avmm_clock_dprio_clk_mux1;

assign avmm_dprio_clk_sel1 = avmm_clock_dft_clk_sel_n && (csr_rdy_dly_in == 1'b0);
assign avmm_dprio_clk_sel2 = avmm_clock_dft_clk_sel_n && (csr_rdy_in == 1'b1);

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_avmm_dprio_clk_mux1
    (
        .clk_o(avmm_clock_dprio_clk_mux1),
        .clk_0(avmm_clock_dprio_clk_mux2),
        .clk_1(csr_clk_in),
        .clk_sel(avmm_dprio_clk_sel1)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_avmm_dprio_clk_mux2
    (
        .clk_o(avmm_clock_dprio_clk_mux2),
	//.clk_0(adapter_scan_shift_clk),
        .clk_0(avmm_clock_dprio_clk_occ),
        .clk_1(avmm_clock_avmm_clk_gate),
        .clk_sel(avmm_dprio_clk_sel2)
    );

hdpldadapt_cmn_clkor2 hdpldadapt_cmn_clkor2_avmm_clock_avmm_clk_gate
    (
        .clkout(avmm_clock_avmm_clk_gate),
        .clk(avmm_clock_avmm_clk),
        .en(avmm_clk_gate)
    );

always @(negedge avmm_reset_avmm_rst_n or posedge avmm_clock_avmm_clk)
begin
        if (~avmm_reset_avmm_rst_n)
        begin
                avmm_clk_gate <= 1'b1;
        end
        else
        begin
                avmm_clk_gate <= 1'b0;
        end
end

hdpldadapt_cmn_dft_clock_controller
    #(
        .CONTROL_REGISTER_PRESENT(1)
    ) hdpldadapt_cmn_dft_clock_controller_avmm_dprio_clk_occ
    (
        .user_clk(adapter_scan_user_clk0),              //User clock
        .test_clk(adapter_scan_shift_clk),              //Test clock
        .rst_n(1'b0),                                   //Reset (active low)
        .clk_sel_n(adapter_clk_sel_n),                  //Mux sel between user or test clock, Active low
        .scan_enable(adapter_scan_shift),               //Scan enable control signal, Active high in IP, Active low in top level
        .occ_enable(adapter_occ_enable),                //Control signal to enable OCC, Active high in IP, Active low in top level
        .atpg_mode(avmm_clock_dft_occ_atpg_mode),	//Control signal for test mode, Active high in IP, Active low in top level
        .out_clk(avmm_clock_dprio_clk_occ)               //Output clock
    );

////////// AVMM Clock //////////

assign avmm_clock_reset_avmm_clk = avmm_clock_avmm_clk_mux1;

assign avmm_avmm_clk_en = avmm_clock_dft_scg_bypass | ~r_avmm_avmm_clk_scg_en;

hdpldadapt_cmn_clkand2 hdpldadapt_cmn_clkand2_avmm_avmm_clk_scg
    (
        .clkout(avmm_clock_avmm_clk),
        .clk(avmm_clock_avmm_clk_mux1),
        .en(avmm_avmm_clk_en)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_avmm_avmm_clk_mux1
    (
        .clk_o(avmm_clock_avmm_clk_mux1),
        .clk_0(avmm_clock_avmm_clk_occ),
        .clk_1(pld_avmm_clk_rowclk),
        .clk_sel(avmm_clock_dft_clk_sel_n)
    );

hdpldadapt_cmn_dft_clock_controller 
    #(
        .CONTROL_REGISTER_PRESENT(1)
    ) hdpldadapt_cmn_dft_clock_controller_avmm_avmm_clk_occ
    (
        .user_clk(adapter_scan_user_clk0),              //User clock
        .test_clk(adapter_scan_shift_clk),              //Test clock
        .rst_n(1'b0),                                   //Reset (active low)
        .clk_sel_n(adapter_clk_sel_n),                  //Mux sel between user or test clock, Active low
        .scan_enable(adapter_scan_shift),               //Scan enable control signal, Active high in IP, Active low in top level
        .occ_enable(adapter_occ_enable),                //Control signal to enable OCC, Active high in IP, Active low in top level
        .atpg_mode(avmm_clock_dft_occ_atpg_mode),	//Control signal for test mode, Active high in IP, Active low in top level
        .out_clk(avmm_clock_avmm_clk_occ)               //Output clock
    );

endmodule // hdpldadapt_avmmclk_ctl
