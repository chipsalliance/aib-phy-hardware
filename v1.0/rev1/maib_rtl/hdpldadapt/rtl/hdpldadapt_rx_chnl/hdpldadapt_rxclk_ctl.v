// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module hdpldadapt_rxclk_ctl
(
	input	wire		aib_fabric_rx_transfer_clk,
	input	wire		aib_fabric_tx_transfer_clk,
	input	wire		aib_fabric_pld_pcs_rx_clk_out,
	input	wire		aib_fabric_pld_pma_clkdiv_rx_user,
	input	wire		aib_fabric_pld_pma_internal_clk1,
	input	wire		aib_fabric_pld_pma_internal_clk2,
	input	wire		aib_fabric_pld_pma_hclk,
	input   wire            aib_fabric_rx_sr_clk_in,
	input   wire            aib_fabric_tx_sr_clk_in,
	input	wire		pld_pma_coreclkin_rowclk,
	//input	wire		pld_pma_coreclkin_dcm,
	input	wire		pld_rx_clk1_rowclk,
	input	wire		pld_rx_clk1_dcm,
	input	wire		pld_rx_clk2_rowclk,
	//input	wire		pld_rx_clk2_dcm,
	input	wire		pld_sclk1_rowclk,
	input	wire		pld_sclk2_rowclk,
	//input	wire		pld_sclk_rowclk,
	//input	wire		pld_sclk_dcm,
	input	wire		nfrzdrv_in,
	input	wire		pr_channel_freeze_n,
	input	wire		pld_clk_dft_sel,
	//input	wire		r_rx_coreclkin_sel,
	input	wire [1:0]	r_rx_aib_clk1_sel,
	input	wire [1:0]	r_rx_aib_clk2_sel,
	input	wire		r_rx_fifo_wr_clk_sel,
	input	wire [1:0]	r_rx_fifo_rd_clk_sel,
	input	wire		r_rx_pld_clk1_sel,
	//input	wire		r_rx_pld_clk2_sel,
	input	wire		r_rx_sclk_sel,
	input	wire		r_rx_internal_clk1_sel1,
	input	wire		r_rx_internal_clk1_sel2,
	input	wire		r_rx_txfiford_post_ct_sel,
	input	wire		r_rx_txfifowr_post_ct_sel,
	input	wire		r_rx_internal_clk2_sel1,
	input	wire		r_rx_internal_clk2_sel2,
	input	wire		r_rx_rxfifowr_post_ct_sel,
	input	wire		r_rx_rxfiford_post_ct_sel,
	input	wire		r_rx_fifo_wr_clk_scg_en,
	input	wire		r_rx_fifo_rd_clk_scg_en,
	input	wire		r_rx_pma_hclk_scg_en,
	input	wire		r_rx_hrdrst_rx_osc_clk_scg_en,
	input	wire		r_rx_osc_clk_scg_en,
	input	wire		r_rx_fifo_wr_clk_del_sm_scg_en,
	input	wire		r_rx_fifo_rd_clk_ins_sm_scg_en,
	input	wire [2:0]	r_rx_fifo_power_mode,
	input   wire            r_rx_pld_clk1_delay_en,
	input   wire [3:0]      r_rx_pld_clk1_delay_sel,
	input	wire		r_rx_pld_clk1_inv_en,
	input	wire		rx_reset_pld_pma_hclk_rst_n,
	input	wire		tx_clock_fifo_wr_clk,
	input	wire		tx_clock_fifo_rd_clk,
	input	wire		dft_adpt_aibiobsr_fastclkn,
        input   wire            adapter_scan_mode_n,
        input   wire            adapter_scan_shift_n,
        input   wire            adapter_scan_shift_clk,
        input   wire            adapter_scan_user_clk0,         // 125MHz
        input   wire            adapter_scan_user_clk1,         // 250MHz
        input   wire            adapter_scan_user_clk2,         // 500MHz
        input   wire            adapter_scan_user_clk3,         // 1GHz
        input   wire            adapter_clk_sel_n,
        input   wire            adapter_occ_enable,
	output	wire		aib_fabric_pld_pma_coreclkin,
	output	wire		aib_fabric_pld_sclk,
	output	wire		pld_pcs_rx_clk_out1_hioint,
	output	wire		pld_pcs_rx_clk_out1_dcm,
	output	wire		pld_pcs_rx_clk_out2_hioint,
	output	wire		pld_pcs_rx_clk_out2_dcm,
	output	wire		pld_pma_internal_clk1_hioint,
	//output	wire		pld_pma_internal_clk1_dcm,
	output	wire		pld_pma_internal_clk2_hioint,
	//output	wire		pld_pma_internal_clk2_dcm,
	output	wire		pld_pma_hclk_hioint,
	//output	wire		pld_pma_hclk_dcm,
	output	wire		rx_clock_pld_sclk,	// To Tx channel
	output	wire            rx_clock_reset_hrdrst_rx_osc_clk,
	output	wire            rx_clock_reset_fifo_wr_clk,
	output	wire            rx_clock_reset_fifo_rd_clk,
	output	wire		rx_clock_fifo_sclk,
	output	wire            rx_clock_reset_asn_pma_hclk,
	output	wire            rx_clock_reset_async_rx_osc_clk,
	output	wire            rx_clock_reset_async_tx_osc_clk,
	output	wire		rx_clock_pld_pma_hclk,
	output	wire		rx_clock_fifo_wr_clk_del_sm,	// Static clock gated
	output	wire		rx_clock_fifo_wr_clk,		// Static clock gated
        output  wire            q1_rx_clock_fifo_wr_clk,        // Static clock gated
        output  wire            q2_rx_clock_fifo_wr_clk,        // Static clock gated
        output  wire            q3_rx_clock_fifo_wr_clk,        // Static clock gated
        output  wire            q4_rx_clock_fifo_wr_clk,        // Static clock gated
        output  wire            q5_rx_clock_fifo_wr_clk,        // Static clock gated
        output  wire            q6_rx_clock_fifo_wr_clk,        // Static clock gated
	output	wire		rx_clock_fifo_rd_clk_ins_sm,	// Static clock gated
	output	wire		rx_clock_fifo_rd_clk,		// Static clock gated
	output	wire		rx_clock_asn_pma_hclk,		// Static clock gated
	output	wire		rx_clock_hrdrst_rx_osc_clk,	// Static clock gated
	output	wire		rx_clock_async_rx_osc_clk,	// Static clock gated
	output	wire		rx_clock_async_tx_osc_clk	// Static clock gated
);

	//wire		nfrz_output_2one;
	//assign nfrz_output_2one = nfrzdrv_in & pr_channel_freeze_n;

        //wire            adapter_scan_mode;
        wire            adapter_scan_shift;
	wire            rx_clock_dft_scg_bypass;
	wire            rx_clock_dft_clk_sel_n;
	wire            rx_clock_dft_occ_atpg_mode;

        wire            frz_2one_by_nfrzdrv_or_pr_channel_freeze_n;
        wire            frz_2one_by_nfrzdrv;

	wire		nc_pld_rx_clk2;

	wire		rx_clock_pld_sclk_mux0;
	wire		rx_clock_pld_sclk_mux1;
	wire		rx_clock_pld_sclk_mux2;

        wire            rx_clock_internal_clk1_mux1;
        wire            rx_clock_internal_clk1_mux2;
        wire            rx_clock_txfifowr_post_ct_mux1;
        wire            rx_clock_txfiford_post_ct_mux1;

        wire            rx_clock_internal_clk2_mux1;
        wire            rx_clock_internal_clk2_mux2;
        wire            rx_clock_rxfiford_post_ct_mux1;
        wire            rx_clock_rxfifowr_post_ct_mux1;

        wire            rx_clock_aib_clk1_hioint_dft_mux1;
        wire            rx_clock_aib_clk1_hioint_dft_mux2;
        wire            rx_clock_aib_clk1_dcm_dft_mux1;
        wire            rx_clock_aib_clk1_mux1;
        wire            rx_clock_aib_clk1_mux2;
        wire            rx_aib_clk1_sel1;
        wire            rx_aib_clk1_sel2;

        wire            rx_clock_aib_clk2_hioint_dft_mux1;
        wire            rx_clock_aib_clk2_hioint_dft_mux2;
        wire            rx_clock_aib_clk2_dcm_dft_mux1;
        wire            rx_clock_aib_clk2_mux1;
        wire            rx_clock_aib_clk2_mux2;
        wire            rx_aib_clk2_sel1;
        wire            rx_aib_clk2_sel2;

	wire		rx_clock_fifo_wr_clk_scg;
        wire            q1_rx_clock_fifo_wr_clk_scg;
        wire            q2_rx_clock_fifo_wr_clk_scg;
        wire            q3_rx_clock_fifo_wr_clk_scg;
        wire            q4_rx_clock_fifo_wr_clk_scg;
        wire            q5_rx_clock_fifo_wr_clk_scg;
        wire            q6_rx_clock_fifo_wr_clk_scg;

        wire            rx_clock_fifo_wr_clk_mux1;
        wire            rx_clock_fifo_wr_clk_mux2;
        wire            rx_clock_fifo_wr_clk_occ;
	wire		rx_fifo_wr_clk_del_sm_clk_en;
        wire            q1_rx_fifo_wr_clk_en;
        wire            q2_rx_fifo_wr_clk_en;
        wire            q3_rx_fifo_wr_clk_en;
        wire            q4_rx_fifo_wr_clk_en;
        wire            q5_rx_fifo_wr_clk_en;
        wire            q6_rx_fifo_wr_clk_en;
        wire            rx_fifo_wr_clk_sel1;
        wire            rx_fifo_wr_clk_sel2;

	wire            rx_clock_fifo_rd_clk_mux1;
	wire            rx_clock_fifo_rd_clk_mux2;
	wire            rx_clock_fifo_rd_clk_mux3;
	wire            rx_clock_fifo_rd_clk_occ;
	wire		rx_fifo_rd_clk_ins_sm_clk_en;
	wire		rx_fifo_rd_clk_en;
	wire		rx_fifo_rd_clk_sel1;
	wire		rx_fifo_rd_clk_sel2;
	wire		rx_fifo_rd_clk_sel3;

	wire		rx_clock_fifo_wr_clk_int;
	wire		rx_clock_fifo_rd_clk_scg;
	wire		rx_clock_fifo_rd_clk_int;

	wire            rx_clock_pld_clk1_delay_mux1;
        wire            rx_clock_pld_clk1_delay;
	wire		rx_clock_pld_clk1_inv_mux1;
	wire		rx_clock_pld_clk1_inv;
	wire		rx_clock_pld_clk1_mux1;

        wire            rx_clock_fifo_sclk_mux1;
        wire            rx_clock_fifo_sclk_occ;

        wire            rx_clock_rx_osc_clk_mux1;
        wire            rx_clock_rx_osc_clk_occ;
        wire            rx_hrdrst_rx_osc_clk_en;
        wire            rx_osc_clk_en;

        wire            rx_clock_tx_osc_clk_mux1;
        wire            rx_clock_tx_osc_clk_occ;

        wire            rx_clock_asn_pma_hclk_mux1;
        wire            rx_clock_pld_pma_hclk_mux1;
        wire            rx_clock_pld_pma_hclk_occ;
        wire            rx_pma_hclk_en;
        reg             rx_clock_asn_pma_hclk_div2;

        // DFX
        //assign adapter_scan_mode = ~adapter_scan_mode_n;
        assign adapter_scan_shift = ~adapter_scan_shift_n;
	assign rx_clock_dft_scg_bypass = ~dft_adpt_aibiobsr_fastclkn | ~adapter_scan_mode_n;
	assign rx_clock_dft_clk_sel_n = dft_adpt_aibiobsr_fastclkn & adapter_scan_mode_n;

	assign rx_clock_dft_occ_atpg_mode = ~adapter_scan_mode_n;

	assign nc_pld_rx_clk2 = pld_rx_clk2_rowclk;

	// Feedthrough from PLD to AIB
	assign aib_fabric_pld_pma_coreclkin = pld_pma_coreclkin_rowclk;

//////////////////
// Clock muxing //
//////////////////

assign frz_2one_by_nfrzdrv_or_pr_channel_freeze_n = ~(nfrzdrv_in & pr_channel_freeze_n);
assign frz_2one_by_nfrzdrv = ~(nfrzdrv_in);

////////// Internal Clock 1 //////////

hdpldadapt_cmn_clkor2 hdpldadapt_cmn_clkor2_pld_pma_internal_clk1_hioint_frz
    (
        .clkout(pld_pma_internal_clk1_hioint),
        .clk(rx_clock_internal_clk1_mux1),
        .en(frz_2one_by_nfrzdrv_or_pr_channel_freeze_n)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_rx_internal_clk1_mux1
    (
        .clk_o(rx_clock_internal_clk1_mux1),
        .clk_0(rx_clock_internal_clk1_mux2),
        .clk_1(rx_clock_txfifowr_post_ct_mux1),
        .clk_sel(r_rx_internal_clk1_sel1)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_rx_internal_clk1_mux2
    (
        .clk_o(rx_clock_internal_clk1_mux2),
        .clk_0(aib_fabric_pld_pma_internal_clk1),
        .clk_1(rx_clock_txfiford_post_ct_mux1),
        .clk_sel(r_rx_internal_clk1_sel2)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_rx_txfifowr_post_ct_mux1
    (
        .clk_o(rx_clock_txfifowr_post_ct_mux1),
        .clk_0(rx_clock_pld_sclk_mux1),
        .clk_1(tx_clock_fifo_wr_clk),
        .clk_sel(r_rx_txfifowr_post_ct_sel)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_rx_txfiford_post_ct_mux1
    (
        .clk_o(rx_clock_txfiford_post_ct_mux1),
        .clk_0(rx_clock_pld_sclk_mux2),
        .clk_1(tx_clock_fifo_rd_clk),
        .clk_sel(r_rx_txfiford_post_ct_sel)
    );

////////// Internal Clock 2 //////////

hdpldadapt_cmn_clkor2 hdpldadapt_cmn_clkor2_pld_pma_internal_clk2_hioint_frz
    (
        .clkout(pld_pma_internal_clk2_hioint),
        .clk(rx_clock_internal_clk2_mux1),
        .en(frz_2one_by_nfrzdrv_or_pr_channel_freeze_n)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_rx_internal_clk2_mux1
    (
        .clk_o(rx_clock_internal_clk2_mux1),
        .clk_0(rx_clock_internal_clk2_mux2),
        .clk_1(rx_clock_rxfiford_post_ct_mux1),
        .clk_sel(r_rx_internal_clk2_sel1)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_rx_internal_clk2_mux2
    (
        .clk_o(rx_clock_internal_clk2_mux2),
        .clk_0(aib_fabric_pld_pma_internal_clk2),
        .clk_1(rx_clock_rxfifowr_post_ct_mux1),
        .clk_sel(r_rx_internal_clk2_sel2)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_rx_rxfiford_post_ct_mux1
    (
        .clk_o(rx_clock_rxfiford_post_ct_mux1),
        .clk_0(rx_clock_pld_sclk_mux1),
        .clk_1(rx_clock_fifo_rd_clk),
        .clk_sel(r_rx_rxfiford_post_ct_sel)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_rx_rxfifowr_post_ct_mux1
    (
        .clk_o(rx_clock_rxfifowr_post_ct_mux1),
	.clk_0(rx_clock_pld_sclk_mux2),
        .clk_1(rx_clock_fifo_wr_clk),
        .clk_sel(r_rx_rxfifowr_post_ct_sel)
    );

hdpldadapt_cmn_clkor2 hdpldadapt_cmn_clkor2_pld_pcs_rx_clk_out1_hioint_frz
    (
        .clkout(pld_pcs_rx_clk_out1_hioint),
        // ECO .clk(rx_clock_aib_clk1_mux1),
        .clk(rx_clock_aib_clk1_hioint_dft_mux1),
        .en(frz_2one_by_nfrzdrv_or_pr_channel_freeze_n)
    );

hdpldadapt_cmn_clkor2 hdpldadapt_cmn_clkor2_pld_pcs_rx_clk_out1_dcm_frz
    (
        .clkout(pld_pcs_rx_clk_out1_dcm),
        // ECO .clk(rx_clock_aib_clk1_mux1),
        .clk(rx_clock_aib_clk1_dcm_dft_mux1),
        .en(frz_2one_by_nfrzdrv)
    );

hdpldadapt_cmn_clkor2 hdpldadapt_cmn_clkor2_pld_pcs_rx_clk_out2_hioint_frz
    (
        .clkout(pld_pcs_rx_clk_out2_hioint),
        // ECO .clk(rx_clock_aib_clk2_mux1),
        .clk(rx_clock_aib_clk2_hioint_dft_mux1),
        .en(frz_2one_by_nfrzdrv_or_pr_channel_freeze_n)
    );

hdpldadapt_cmn_clkor2 hdpldadapt_cmn_clkor2_pld_pcs_rx_clk_out2_dcm_frz
    (
        .clkout(pld_pcs_rx_clk_out2_dcm),
        // ECO .clk(rx_clock_aib_clk2_mux1),
        .clk(rx_clock_aib_clk2_dcm_dft_mux1),
        .en(frz_2one_by_nfrzdrv)
    );

// ECO Start //

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_rx_clock_aib_clk1_hioint_dft_mux1
    (
        .clk_o(rx_clock_aib_clk1_hioint_dft_mux1),
        .clk_0(rx_clock_aib_clk1_hioint_dft_mux2),
        .clk_1(rx_clock_aib_clk1_mux1),
        .clk_sel(adapter_scan_mode_n)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_rx_clock_aib_clk1_hioint_dft_mux2
    (
        .clk_o(rx_clock_aib_clk1_hioint_dft_mux2),
        .clk_0(rx_clock_pld_clk1_delay_mux1),
        .clk_1(rx_clock_aib_clk1_mux1),
        .clk_sel(pld_clk_dft_sel)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_rx_clock_aib_clk1_dcm_dft_mux1
    (
        .clk_o(rx_clock_aib_clk1_dcm_dft_mux1),
        .clk_0(adapter_scan_shift_clk),
        .clk_1(rx_clock_aib_clk1_mux1),
        .clk_sel(adapter_scan_mode_n)
    );

// ECO End //

assign rx_aib_clk1_sel1 = (r_rx_aib_clk1_sel == 2'b10);
assign rx_aib_clk1_sel2 = (r_rx_aib_clk1_sel == 2'b01);

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_rx_aib_clk1_mux1
    (
        .clk_o(rx_clock_aib_clk1_mux1),
        .clk_0(rx_clock_aib_clk1_mux2),
        .clk_1(aib_fabric_pld_pma_clkdiv_rx_user),
        .clk_sel(rx_aib_clk1_sel1)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_rx_aib_clk1_mux2
    (
        .clk_o(rx_clock_aib_clk1_mux2),
        .clk_0(aib_fabric_rx_transfer_clk),
        .clk_1(aib_fabric_pld_pcs_rx_clk_out),
        .clk_sel(rx_aib_clk1_sel2)
    );

// ECO Start //

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_rx_clock_aib_clk2_hioint_dft_mux1
    (
        .clk_o(rx_clock_aib_clk2_hioint_dft_mux1),
        .clk_0(rx_clock_aib_clk2_hioint_dft_mux2),
        .clk_1(rx_clock_aib_clk2_mux1),
        .clk_sel(adapter_scan_mode_n)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_rx_clock_aib_clk2_hioint_dft_mux2
    (
        .clk_o(rx_clock_aib_clk2_hioint_dft_mux2),
        .clk_0(rx_clock_pld_sclk_mux0),
        .clk_1(rx_clock_aib_clk2_mux1),
        .clk_sel(pld_clk_dft_sel)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_rx_clock_aib_clk2_dcm_dft_mux1
    (
        .clk_o(rx_clock_aib_clk2_dcm_dft_mux1),
        .clk_0(adapter_scan_shift_clk),
        .clk_1(rx_clock_aib_clk2_mux1),
        .clk_sel(adapter_scan_mode_n)
    );

// ECO End //

assign rx_aib_clk2_sel1 = (r_rx_aib_clk2_sel == 2'b10);
assign rx_aib_clk2_sel2 = (r_rx_aib_clk2_sel == 2'b01);

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_rx_aib_clk2_mux1
    (
        .clk_o(rx_clock_aib_clk2_mux1),
        .clk_0(rx_clock_aib_clk2_mux2),
        .clk_1(aib_fabric_pld_pma_clkdiv_rx_user),
        .clk_sel(rx_aib_clk2_sel1)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_rx_aib_clk2_mux2
    (
        .clk_o(rx_clock_aib_clk2_mux2),
        .clk_0(aib_fabric_rx_transfer_clk),
        .clk_1(aib_fabric_pld_pcs_rx_clk_out),
        .clk_sel(rx_aib_clk2_sel2)
    );

///////// FIFO Write Clock //////////

assign rx_clock_fifo_wr_clk = q1_rx_clock_fifo_wr_clk;          // Should this be on separate clock source?

assign rx_clock_reset_fifo_wr_clk = rx_clock_fifo_wr_clk_mux1;

assign rx_fifo_wr_clk_del_sm_clk_en = rx_clock_dft_scg_bypass | ~r_rx_fifo_wr_clk_del_sm_scg_en;
assign q1_rx_fifo_wr_clk_en = rx_clock_dft_scg_bypass | ~r_rx_fifo_wr_clk_scg_en;
assign q2_rx_fifo_wr_clk_en = rx_clock_dft_scg_bypass | (~r_rx_fifo_wr_clk_scg_en & r_rx_fifo_power_mode[0]);
assign q3_rx_fifo_wr_clk_en = rx_clock_dft_scg_bypass | (~r_rx_fifo_wr_clk_scg_en & r_rx_fifo_power_mode[1]);
assign q4_rx_fifo_wr_clk_en = rx_clock_dft_scg_bypass | (~r_rx_fifo_wr_clk_scg_en & r_rx_fifo_power_mode[1] & r_rx_fifo_power_mode[0]);
assign q5_rx_fifo_wr_clk_en = rx_clock_dft_scg_bypass | (~r_rx_fifo_wr_clk_scg_en & r_rx_fifo_power_mode[2] & r_rx_fifo_power_mode[1]);
assign q6_rx_fifo_wr_clk_en = rx_clock_dft_scg_bypass | (~r_rx_fifo_wr_clk_scg_en & r_rx_fifo_power_mode[2] & r_rx_fifo_power_mode[1] & r_rx_fifo_power_mode[0]);

hdpldadapt_cmn_clkand2 hdpldadapt_cmn_clkand2_rx_fifo_wr_clk_del_sm_scg
    (
        .clkout(rx_clock_fifo_wr_clk_del_sm),
        .clk(rx_clock_fifo_wr_clk_mux1),
        .en(rx_fifo_wr_clk_del_sm_clk_en)
    );

hdpldadapt_cmn_clkand2 hdpldadapt_cmn_clkand2_q1_rx_fifo_wr_clk_scg
    (
        .clkout(q1_rx_clock_fifo_wr_clk),
        .clk(rx_clock_fifo_wr_clk_mux1),
        .en(q1_rx_fifo_wr_clk_en)
    );

hdpldadapt_cmn_clkand2 hdpldadapt_cmn_clkand2_q2_rx_fifo_wr_clk_scg
    (
        .clkout(q2_rx_clock_fifo_wr_clk),
        .clk(rx_clock_fifo_wr_clk_mux1),
        .en(q2_rx_fifo_wr_clk_en)
    );

hdpldadapt_cmn_clkand2 hdpldadapt_cmn_clkand2_q3_rx_fifo_wr_clk_scg
    (
        .clkout(q3_rx_clock_fifo_wr_clk),
        .clk(rx_clock_fifo_wr_clk_mux1),
        .en(q3_rx_fifo_wr_clk_en)
    );

hdpldadapt_cmn_clkand2 hdpldadapt_cmn_clkand2_q4_rx_fifo_wr_clk_scg
    (
        .clkout(q4_rx_clock_fifo_wr_clk),
        .clk(rx_clock_fifo_wr_clk_mux1),
        .en(q4_rx_fifo_wr_clk_en)
    );

hdpldadapt_cmn_clkand2 hdpldadapt_cmn_clkand2_q5_rx_fifo_wr_clk_scg
    (
        .clkout(q5_rx_clock_fifo_wr_clk),
        .clk(rx_clock_fifo_wr_clk_mux1),
        .en(q5_rx_fifo_wr_clk_en)
    );

hdpldadapt_cmn_clkand2 hdpldadapt_cmn_clkand2_q6_rx_fifo_wr_clk_scg
    (
        .clkout(q6_rx_clock_fifo_wr_clk),
        .clk(rx_clock_fifo_wr_clk_mux1),
        .en(q6_rx_fifo_wr_clk_en)
    );

assign rx_fifo_wr_clk_sel1 = rx_clock_dft_clk_sel_n && (r_rx_fifo_wr_clk_sel == 1'b0);
assign rx_fifo_wr_clk_sel2 = rx_clock_dft_clk_sel_n && (r_rx_fifo_wr_clk_sel == 1'b1);

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_rx_fifo_wr_clk_mux1
    (
        .clk_o(rx_clock_fifo_wr_clk_mux1),
        .clk_0(rx_clock_fifo_wr_clk_mux2),
        .clk_1(aib_fabric_rx_transfer_clk),
        .clk_sel(rx_fifo_wr_clk_sel1)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_rx_fifo_wr_clk_mux2
    (
        .clk_o(rx_clock_fifo_wr_clk_mux2),
        .clk_0(rx_clock_fifo_wr_clk_occ),
        .clk_1(aib_fabric_tx_transfer_clk),
        .clk_sel(rx_fifo_wr_clk_sel2)
        //.clk_sel(adapter_scan_mode_n)
    );

hdpldadapt_cmn_dft_clock_controller 
    #(
        .CONTROL_REGISTER_PRESENT(1)
    ) hdpldadapt_cmn_dft_clock_controller_rx_fifo_wr_clk_occ6
    (
        .user_clk(adapter_scan_user_clk3),              //User clock
        .test_clk(adapter_scan_shift_clk),              //Test clock
        .rst_n(1'b0),                                   //Reset (active low)
        .clk_sel_n(adapter_clk_sel_n),                  //Mux sel between user or test clock, Active low
        .scan_enable(adapter_scan_shift),               //Scan enable control signal, Active high in IP, Active low in top level
        .occ_enable(adapter_occ_enable),                //Control signal to enable OCC, Active high in IP, Active low in top level
        .atpg_mode(rx_clock_dft_occ_atpg_mode),		//Control signal for test mode, Active high in IP, Active low in top level
        .out_clk(rx_clock_fifo_wr_clk_occ)              //Output clock
    );

////////// FIFO Read Clock //////////

assign rx_clock_reset_fifo_rd_clk = rx_clock_fifo_rd_clk_mux1;

assign rx_fifo_rd_clk_ins_sm_clk_en = rx_clock_dft_scg_bypass | ~r_rx_fifo_rd_clk_ins_sm_scg_en;
assign rx_fifo_rd_clk_en = rx_clock_dft_scg_bypass | ~r_rx_fifo_rd_clk_scg_en;

hdpldadapt_cmn_clkand2 hdpldadapt_cmn_clkand2_rx_fifo_rd_clk_ins_sm_scg
    (
        .clkout(rx_clock_fifo_rd_clk_ins_sm),
        .clk(rx_clock_fifo_rd_clk_mux1),
        .en(rx_fifo_rd_clk_ins_sm_clk_en)
    );

hdpldadapt_cmn_clkand2 hdpldadapt_cmn_clkand2_rx_fifo_rd_clk_scg
    (
        .clkout(rx_clock_fifo_rd_clk),
        .clk(rx_clock_fifo_rd_clk_mux1),
        .en(rx_fifo_rd_clk_en)
    );

assign rx_fifo_rd_clk_sel1 = rx_clock_dft_clk_sel_n && (r_rx_fifo_rd_clk_sel == 2'b00);
assign rx_fifo_rd_clk_sel2 = rx_clock_dft_clk_sel_n && (r_rx_fifo_rd_clk_sel == 2'b01);
assign rx_fifo_rd_clk_sel3 = rx_clock_dft_clk_sel_n && (r_rx_fifo_rd_clk_sel == 2'b10);

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_rx_fifo_rd_clk_mux1
    (
        .clk_o(rx_clock_fifo_rd_clk_mux1),
        .clk_0(rx_clock_fifo_rd_clk_mux2),
        .clk_1(aib_fabric_rx_transfer_clk),
        .clk_sel(rx_fifo_rd_clk_sel1)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_rx_fifo_rd_clk_mux2
    (
        .clk_o(rx_clock_fifo_rd_clk_mux2),
        .clk_0(rx_clock_fifo_rd_clk_mux3),
        .clk_1(aib_fabric_tx_transfer_clk),
        .clk_sel(rx_fifo_rd_clk_sel2)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_rx_fifo_rd_clk_mux3
    (
        .clk_o(rx_clock_fifo_rd_clk_mux3),
        .clk_0(rx_clock_fifo_rd_clk_occ),
        .clk_1(rx_clock_pld_clk1_delay_mux1),
        .clk_sel(rx_fifo_rd_clk_sel3)
    );

hdpldadapt_cmn_dft_clock_controller 
    #(
        .CONTROL_REGISTER_PRESENT(1)
    ) hdpldadapt_cmn_dft_clock_controller_rx_fifo_rd_clk_occ7
    (
        .user_clk(adapter_scan_user_clk3),              //User clock
        .test_clk(adapter_scan_shift_clk),              //Test clock
        .rst_n(1'b0),                                   //Reset (active low)
        .clk_sel_n(adapter_clk_sel_n),                  //Mux sel between user or test clock, Active low
        .scan_enable(adapter_scan_shift),               //Scan enable control signal, Active high in IP, Active low in top level
        .occ_enable(adapter_occ_enable),                //Control signal to enable OCC, Active high in IP, Active low in top level
        .atpg_mode(rx_clock_dft_occ_atpg_mode),		//Control signal for test mode, Active high in IP, Active low in top level
        .out_clk(rx_clock_fifo_rd_clk_occ)              //Output clock
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_rx_pld_clk1_delay_mux1
    (
        .clk_o(rx_clock_pld_clk1_delay_mux1),
        .clk_0(rx_clock_pld_clk1_inv_mux1),
        .clk_1(rx_clock_pld_clk1_delay),
        .clk_sel(r_rx_pld_clk1_delay_en)
    );

hdpldadapt_cmn_clkdelay_map hdpldadapt_cmn_clkdelay_rx_pld_clk1
    (
        .clkout(rx_clock_pld_clk1_delay),
        .r_clk_delay_sel(r_rx_pld_clk1_delay_sel),
        .clk(rx_clock_pld_clk1_inv_mux1)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_rx_pld_clk1_inv_mux1
    (
        .clk_o(rx_clock_pld_clk1_inv_mux1),
        .clk_0(rx_clock_pld_clk1_mux1),
        .clk_1(rx_clock_pld_clk1_inv),
        .clk_sel(r_rx_pld_clk1_inv_en)
    );

hdpldadapt_cmn_clkinv hdpldadapt_cmn_clkinv_rx_pld_clk1_inv
    (
        .clkout(rx_clock_pld_clk1_inv),
        .clk(rx_clock_pld_clk1_mux1)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_rx_pld_clk1_mux1
    (
        .clk_o(rx_clock_pld_clk1_mux1),
        .clk_0(pld_rx_clk1_rowclk),
        .clk_1(pld_rx_clk1_dcm),
        .clk_sel(r_rx_pld_clk1_sel)
    );

////////// Sample Clock //////////

assign rx_clock_fifo_sclk = rx_clock_fifo_sclk_mux1;

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_rx_fifo_sclk_mux1
    (
        .clk_o(rx_clock_fifo_sclk_mux1),
        .clk_0(rx_clock_fifo_sclk_occ),
        .clk_1(rx_clock_pld_sclk_mux1),
        .clk_sel(rx_clock_dft_clk_sel_n)
    );

hdpldadapt_cmn_dft_clock_controller 
    #(
        .CONTROL_REGISTER_PRESENT(1)
    ) hdpldadapt_cmn_dft_clock_controller_rx_fifo_sclk_occ8
    (
        .user_clk(adapter_scan_user_clk1),              //User clock
        .test_clk(adapter_scan_shift_clk),              //Test clock
        .rst_n(1'b0),                                   //Reset (active low)
        .clk_sel_n(adapter_clk_sel_n),                  //Mux sel between user or test clock, Active low
        .scan_enable(adapter_scan_shift),               //Scan enable control signal, Active high in IP, Active low in top level
        .occ_enable(adapter_occ_enable),                //Control signal to enable OCC, Active high in IP, Active low in top level
        .atpg_mode(rx_clock_dft_occ_atpg_mode),		//Control signal for test mode, Active high in IP, Active low in top level
        .out_clk(rx_clock_fifo_sclk_occ)            //Output clock
    );

assign aib_fabric_pld_sclk = rx_clock_pld_sclk_mux1;
assign rx_clock_pld_sclk = rx_clock_pld_sclk_mux0; 

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_rx_pld_sclk_mux2
    (
        .clk_o(rx_clock_pld_sclk_mux2),
        .clk_0(rx_clock_pld_sclk_mux1),
        .clk_1(1'b0),
        .clk_sel(1'b0)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_rx_pld_sclk_mux1
    (
        .clk_o(rx_clock_pld_sclk_mux1),
        .clk_0(rx_clock_pld_sclk_mux0),
        .clk_1(1'b0),
        .clk_sel(1'b0)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_rx_pld_sclk_mux0
    (
        .clk_o(rx_clock_pld_sclk_mux0),
        .clk_0(pld_sclk1_rowclk),
        .clk_1(pld_sclk2_rowclk),
        .clk_sel(r_rx_sclk_sel)
    );

////////// Rx Oscillator Clock //////////

assign rx_clock_reset_hrdrst_rx_osc_clk = rx_clock_rx_osc_clk_mux1;
assign rx_clock_reset_async_rx_osc_clk = rx_clock_rx_osc_clk_mux1;

assign rx_hrdrst_rx_osc_clk_en = rx_clock_dft_scg_bypass | ~r_rx_hrdrst_rx_osc_clk_scg_en;
assign rx_osc_clk_en = rx_clock_dft_scg_bypass | ~r_rx_osc_clk_scg_en;

hdpldadapt_cmn_clkand2 hdpldadapt_cmn_clkand2_rx_hrdrst_rx_osc_clk_scg
    (
        .clkout(rx_clock_hrdrst_rx_osc_clk),
        .clk(rx_clock_rx_osc_clk_mux1),
        .en(rx_hrdrst_rx_osc_clk_en)
    );

hdpldadapt_cmn_clkand2 hdpldadapt_cmn_clkand2_rx_async_rx_osc_clk_scg
    (
        .clkout(rx_clock_async_rx_osc_clk),
        .clk(rx_clock_rx_osc_clk_mux1),
        .en(rx_osc_clk_en)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_rx_rx_osc_clk_mux1
    (
        .clk_o(rx_clock_rx_osc_clk_mux1),
        .clk_0(rx_clock_rx_osc_clk_occ),
        .clk_1(aib_fabric_rx_sr_clk_in),
        .clk_sel(rx_clock_dft_clk_sel_n)
    );

hdpldadapt_cmn_dft_clock_controller 
    #(
        .CONTROL_REGISTER_PRESENT(1)
    ) hdpldadapt_cmn_dft_clock_controller_rx_rx_osc_clk_occ9
    (
        .user_clk(adapter_scan_user_clk3),              //User clock
        .test_clk(adapter_scan_shift_clk),              //Test clock
        .rst_n(1'b0),                                   //Reset (active low)
        .clk_sel_n(adapter_clk_sel_n),                  //Mux sel between user or test clock, Active low
        .scan_enable(adapter_scan_shift),               //Scan enable control signal, Active high in IP, Active low in top level
        .occ_enable(adapter_occ_enable),                //Control signal to enable OCC, Active high in IP, Active low in top level
        .atpg_mode(rx_clock_dft_occ_atpg_mode),		//Control signal for test mode, Active high in IP, Active low in top level
        .out_clk(rx_clock_rx_osc_clk_occ)               //Output clock
    );

////////// Tx Oscillator Clock //////////

assign rx_clock_reset_async_tx_osc_clk = rx_clock_tx_osc_clk_mux1;

hdpldadapt_cmn_clkand2 hdpldadapt_cmn_clkand2_rx_async_tx_osc_clk_scg
    (
        .clkout(rx_clock_async_tx_osc_clk),
        .clk(rx_clock_tx_osc_clk_mux1),
        .en(rx_osc_clk_en)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_rx_tx_osc_clk_mux1
    (
        .clk_o(rx_clock_tx_osc_clk_mux1),
        .clk_0(rx_clock_tx_osc_clk_occ),
        .clk_1(aib_fabric_tx_sr_clk_in),
        .clk_sel(rx_clock_dft_clk_sel_n)
    );

hdpldadapt_cmn_dft_clock_controller 
    #(
        .CONTROL_REGISTER_PRESENT(1)
    ) hdpldadapt_cmn_dft_clock_controller_rx_tx_osc_clk_occ10
    (
        .user_clk(adapter_scan_user_clk3),              //User clock
        .test_clk(adapter_scan_shift_clk),              //Test clock
        .rst_n(1'b0),                                   //Reset (active low)
        .clk_sel_n(adapter_clk_sel_n),                  //Mux sel between user or test clock, Active low
        .scan_enable(adapter_scan_shift),               //Scan enable control signal, Active high in IP, Active low in top level
        .occ_enable(adapter_occ_enable),                //Control signal to enable OCC, Active high in IP, Active low in top level
        .atpg_mode(rx_clock_dft_occ_atpg_mode),		//Control signal for test mode, Active high in IP, Active low in top level
        .out_clk(rx_clock_tx_osc_clk_occ)               //Output clock
    );

////////// PMA HCLK Clock //////////

hdpldadapt_cmn_clkor2 hdpldadapt_cmn_clkor2_pld_pma_hclk_hioint_frz
    (
        .clkout(pld_pma_hclk_hioint),
        .clk(aib_fabric_pld_pma_hclk),
        .en(frz_2one_by_nfrzdrv_or_pr_channel_freeze_n)
    );

assign rx_clock_reset_asn_pma_hclk = rx_clock_asn_pma_hclk_mux1;

assign rx_pma_hclk_en = rx_clock_dft_scg_bypass | ~r_rx_pma_hclk_scg_en;

hdpldadapt_cmn_clkand2 hdpldadapt_cmn_clkand2_rx_asn_pma_hclk_scg
    (
        .clkout(rx_clock_asn_pma_hclk),
        .clk(rx_clock_asn_pma_hclk_mux1),
        .en(rx_pma_hclk_en)
    );

// Divided Clock
hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_rx_asn_pma_hclk_mux1
    (
        .clk_o(rx_clock_asn_pma_hclk_mux1),
        .clk_0(rx_clock_pld_pma_hclk_occ),
        .clk_1(rx_clock_asn_pma_hclk_div2),
        .clk_sel(rx_clock_dft_clk_sel_n)
    );

assign rx_clock_pld_pma_hclk = rx_clock_pld_pma_hclk_mux1;

// Non Divided Clock
hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_rx_pld_pma_hclk_mux1
    (
        .clk_o(rx_clock_pld_pma_hclk_mux1),
        .clk_0(rx_clock_pld_pma_hclk_occ),
        .clk_1(aib_fabric_pld_pma_hclk),
        .clk_sel(rx_clock_dft_clk_sel_n)
    );

hdpldadapt_cmn_dft_clock_controller 
    #(
        .CONTROL_REGISTER_PRESENT(1)
    ) hdpldadapt_cmn_dft_clock_controller_rx_pld_pma_hclk_occ11
    (
        .user_clk(adapter_scan_user_clk1),              //User clock
        .test_clk(adapter_scan_shift_clk),              //Test clock
        .rst_n(1'b0),                                   //Reset (active low)
        .clk_sel_n(adapter_clk_sel_n),                  //Mux sel between user or test clock, Active low
        .scan_enable(adapter_scan_shift),               //Scan enable control signal, Active high in IP, Active low in top level
        .occ_enable(adapter_occ_enable),                //Control signal to enable OCC, Active high in IP, Active low in top level
        .atpg_mode(rx_clock_dft_occ_atpg_mode),		//Control signal for test mode, Active high in IP, Active low in top level
        .out_clk(rx_clock_pld_pma_hclk_occ)           //Output clock
    );

// Clock Divider

	always @(negedge rx_reset_pld_pma_hclk_rst_n or posedge rx_clock_pld_pma_hclk)
	begin
		if (~rx_reset_pld_pma_hclk_rst_n)
		begin
			rx_clock_asn_pma_hclk_div2 <= 1'b1;
		end
		else
		begin
			rx_clock_asn_pma_hclk_div2 <= ~rx_clock_asn_pma_hclk_div2;
		end
	end
	
endmodule // hdpldadapt_rxclk_ctl
