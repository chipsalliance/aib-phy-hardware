// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module hdpldadapt_txclk_ctl
(
	input	wire		aib_fabric_pld_pcs_tx_clk_out,
	input	wire		aib_fabric_pma_aib_tx_clk,
	input	wire		aib_fabric_pld_pma_clkdiv_tx_user,
	//input	wire		aib_fabric_pld_pma_fpll_fbclkout_lc_lvpecl_to_coreclk,
	//input	wire [3:0]	aib_fabric_pld_pma_fpll_pllcout,
	input	wire [3:0]	aib_fabric_fpll_shared_direct_async_in,
	input	wire		rx_clock_pld_sclk,
	input   wire            aib_fabric_rx_sr_clk_in,
	input   wire            aib_fabric_tx_sr_clk_in,
	//input	wire		pld_fpll_coreclkin_rowclk,
	//input	wire		pld_fpll_coreclkin_dcm,
	//input	wire		pld_fpll_fbclkin_rowclk,
	//input	wire		pld_fpll_fbclkin_dcm,
	input	wire 		pld_fpll_shared_direct_async_in_rowclk,
	input	wire 		pld_fpll_shared_direct_async_in_dcm,
	input	wire		pld_tx_clk1_rowclk,
	input	wire		pld_tx_clk1_dcm,
	input	wire		pld_tx_clk2_rowclk,
	input	wire		pld_tx_clk2_dcm,
	input   wire            nfrzdrv_in,
	input	wire		pr_channel_freeze_n,
	input	wire		pld_clk_dft_sel,
	//input	wire		r_tx_fpll_coreclkin_sel,
	//input	wire		r_tx_fpll_fbclkin_sel,
	input	wire		r_tx_fpll_shared_direct_async_in_sel,
	input	wire [1:0]	r_tx_aib_clk1_sel,
	input	wire [1:0]	r_tx_aib_clk2_sel,
	input	wire [1:0]	r_tx_fifo_rd_clk_sel,
	//input	wire		r_tx_fifo_wr_clk_sel,
	input	wire		r_tx_pld_clk1_sel,
	input	wire		r_tx_pld_clk2_sel,
	input	wire		r_tx_fifo_rd_clk_frm_gen_scg_en,
	input	wire		r_tx_fifo_rd_clk_scg_en,
	input	wire		r_tx_fifo_wr_clk_scg_en,
	input	wire		r_tx_osc_clk_scg_en,
	input	wire		r_tx_hrdrst_rx_osc_clk_scg_en,
	input	wire		r_tx_hip_osc_clk_scg_en,
	input	wire [2:0]	r_tx_fifo_power_mode,
	input	wire         	r_tx_pld_clk1_delay_en,
	input	wire [3:0]	r_tx_pld_clk1_delay_sel,
	input	wire		r_tx_pld_clk1_inv_en,
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
	//output	wire		aib_fabric_pld_fpll_coreclkin,
	//output	wire		aib_fabric_pld_fpll_fbclkin,
	output	wire [0:0]	aib_fabric_fpll_shared_direct_async_out,
	output	wire		aib_fabric_tx_transfer_clk,
	output	wire		pld_pcs_tx_clk_out1_hioint,
	output	wire		pld_pcs_tx_clk_out1_dcm,
	output	wire		pld_pcs_tx_clk_out2_hioint,
	output	wire		pld_pcs_tx_clk_out2_dcm,
	//output	wire		pld_pma_fpll_fbclkout_lc_lvpecl_to_coreclk_hioint,
	//output	wire		pld_pma_fpll_fbclkout_lc_lvpecl_to_coreclk_dcm,
	//output	wire [3:0]	pld_pma_fpll_pllcout_hioint,
	//output	wire [3:0]	pld_pma_fpll_pllcout_dcm,
	output	wire [3:0]	pld_fpll_shared_direct_async_out_hioint,
	output	wire [3:0]	pld_fpll_shared_direct_async_out_dcm,
	output	wire		tx_clock_reset_hrdrst_rx_osc_clk,
	output	wire		tx_clock_reset_fifo_wr_clk,
	output	wire		tx_clock_reset_fifo_rd_clk,
	output	wire		tx_clock_fifo_sclk,
	output	wire		tx_clock_reset_async_rx_osc_clk,
	output	wire		tx_clock_reset_async_tx_osc_clk,
	output	wire		tx_clock_fifo_wr_clk,		// Static clock gated
	output	wire		q1_tx_clock_fifo_wr_clk,	// Static clock gated
	output	wire		q2_tx_clock_fifo_wr_clk,	// Static clock gated
	output	wire		q3_tx_clock_fifo_wr_clk,	// Static clock gated
	output	wire		q4_tx_clock_fifo_wr_clk,	// Static clock gated
	output	wire		q5_tx_clock_fifo_wr_clk,	// Static clock gated
	output	wire		q6_tx_clock_fifo_wr_clk,	// Static clock gated
	output	wire		tx_clock_fifo_rd_clk_frm_gen,	// Static clock gated
	output	wire		tx_clock_fifo_rd_clk,		// Static clock gated
	output	wire		tx_clock_hrdrst_rx_osc_clk,	// Static clock gated
	output	wire		tx_clock_async_rx_osc_clk,	// Static clock gated
	output	wire		tx_clock_async_tx_osc_clk,	// Static clock gated
	output	wire		tx_clock_hip_async_rx_osc_clk,	// Static clock gated
	output	wire		tx_clock_hip_async_tx_osc_clk	// Static clock gated
);

        //wire            adapter_scan_mode;
        wire            adapter_scan_shift;
	wire            tx_clock_dft_scg_bypass;
	wire            tx_clock_dft_clk_sel_n;
	wire            tx_clock_dft_occ_atpg_mode;

	wire		frz_2one_by_nfrzdrv_or_pr_channel_freeze_n;
	wire		frz_2one_by_nfrzdrv;

	wire		tx_clock_fpll_shared_direct_async_in_mux1;
	
	wire [3:0]	pld_fpll_shared_direct_async_out;
	wire		pld_fpll_shared_direct_async_out_dcm_bit3_mux1;
	wire		pld_fpll_shared_direct_async_out_dcm_bit2_mux1;
	wire		pld_fpll_shared_direct_async_out_dcm_bit1_mux1;
	wire		pld_fpll_shared_direct_async_out_dcm_bit0_mux1;

	wire		tx_clock_aib_clk1_hioint_dft_mux1;
	wire		tx_clock_aib_clk1_hioint_dft_mux2;
	wire		tx_clock_aib_clk1_dcm_dft_mux1;
	wire		tx_clock_aib_clk1_mux1;
	wire		tx_clock_aib_clk1_mux2;
	wire		tx_aib_clk1_sel1;
	wire		tx_aib_clk1_sel2;

	wire		tx_clock_aib_clk2_hioint_dft_mux1;
	wire		tx_clock_aib_clk2_hioint_dft_mux2;
	wire		tx_clock_aib_clk2_dcm_dft_mux1;
	wire		tx_clock_aib_clk2_mux1;
	wire		tx_clock_aib_clk2_mux2;
	wire		tx_aib_clk2_sel1;
	wire		tx_aib_clk2_sel2;

        wire            tx_clock_fifo_rd_clk_mux1;
        wire            tx_clock_fifo_rd_clk_mux2;
        wire            tx_clock_fifo_rd_clk_mux3;
        wire            tx_clock_fifo_rd_clk_occ;
	wire		tx_fifo_rd_clk_frm_gen_clk_en;
        wire            tx_fifo_rd_clk_en;
        wire            tx_fifo_rd_clk_sel1;
        wire            tx_fifo_rd_clk_sel2;
        wire            tx_fifo_rd_clk_sel3;

        wire            tx_clock_fifo_wr_clk_mux1;
        wire            tx_clock_fifo_wr_clk_occ;
        wire            q1_tx_fifo_wr_clk_en;
        wire            q2_tx_fifo_wr_clk_en;
        wire            q3_tx_fifo_wr_clk_en;
        wire            q4_tx_fifo_wr_clk_en;
        wire            q5_tx_fifo_wr_clk_en;
        wire            q6_tx_fifo_wr_clk_en;

	wire		tx_clock_pld_clk1_delay_mux1;
	wire		tx_clock_pld_clk1_delay;
	wire		tx_clock_pld_clk1_inv_mux1;
	wire		tx_clock_pld_clk1_inv;
	wire		tx_clock_pld_clk1_mux1;
	wire		tx_clock_pld_clk2_mux1;

        wire            tx_clock_fifo_sclk_mux1;
        wire            tx_clock_fifo_sclk_occ;

        wire            tx_clock_rx_osc_clk_mux1;
        wire            tx_clock_rx_osc_clk_occ;
        wire            tx_hrdrst_rx_osc_clk_en;
	wire		tx_hip_osc_clk_en;
        wire            tx_osc_clk_en;

        wire            tx_clock_tx_osc_clk_mux1;
        wire            tx_clock_tx_osc_clk_occ;

        // DFX
        //assign adapter_scan_mode = ~adapter_scan_mode_n;
        assign adapter_scan_shift = ~adapter_scan_shift_n;
	assign tx_clock_dft_scg_bypass = ~dft_adpt_aibiobsr_fastclkn | ~adapter_scan_mode_n;
	assign tx_clock_dft_clk_sel_n = dft_adpt_aibiobsr_fastclkn & adapter_scan_mode_n;

	assign tx_clock_dft_occ_atpg_mode = ~adapter_scan_mode_n;
 
//////////////////
// Clock muxing //
//////////////////

assign frz_2one_by_nfrzdrv_or_pr_channel_freeze_n = ~(nfrzdrv_in & pr_channel_freeze_n);
assign frz_2one_by_nfrzdrv = ~(nfrzdrv_in);

assign aib_fabric_fpll_shared_direct_async_out[0:0] = tx_clock_fpll_shared_direct_async_in_mux1;

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_tx_fpll_shared_direct_async_in_mux1
    (
        .clk_o(tx_clock_fpll_shared_direct_async_in_mux1),
        .clk_0(pld_fpll_shared_direct_async_in_rowclk),
        .clk_1(pld_fpll_shared_direct_async_in_dcm),
        .clk_sel(r_tx_fpll_shared_direct_async_in_sel)
    );

assign pld_fpll_shared_direct_async_out_hioint[3:0] = pld_fpll_shared_direct_async_out[3:0];
// ECO assign pld_fpll_shared_direct_async_out_dcm[3:0] = pld_fpll_shared_direct_async_out[3:0];

hdpldadapt_cmn_clkor2 hdpldadapt_cmn_clkor2_pld_fpll_shared_direct_async_out_bit3_frz
    (
        .clkout(pld_fpll_shared_direct_async_out[3]),
        .clk(aib_fabric_fpll_shared_direct_async_in[3]),
        .en(frz_2one_by_nfrzdrv)
    );

hdpldadapt_cmn_clkor2 hdpldadapt_cmn_clkor2_pld_fpll_shared_direct_async_out_bit2_frz
    (
        .clkout(pld_fpll_shared_direct_async_out[2]),
        .clk(aib_fabric_fpll_shared_direct_async_in[2]),
        .en(frz_2one_by_nfrzdrv)
    );

hdpldadapt_cmn_clkor2 hdpldadapt_cmn_clkor2_pld_fpll_shared_direct_async_out_bit1_frz
    (
        .clkout(pld_fpll_shared_direct_async_out[1]),
        .clk(aib_fabric_fpll_shared_direct_async_in[1]),
        .en(frz_2one_by_nfrzdrv)
    );

hdpldadapt_cmn_clkor2 hdpldadapt_cmn_clkor2_pld_fpll_shared_direct_async_out_bit0_frz
    (
        .clkout(pld_fpll_shared_direct_async_out[0]),
        .clk(aib_fabric_fpll_shared_direct_async_in[0]),
        .en(frz_2one_by_nfrzdrv)
    );

// ECO Start //

hdpldadapt_cmn_clkor2 hdpldadapt_cmn_clkor2_pld_fpll_shared_direct_async_out_dcm_bit3_frz
    (
        .clkout(pld_fpll_shared_direct_async_out_dcm[3]),
        .clk(pld_fpll_shared_direct_async_out_dcm_bit3_mux1),
        .en(frz_2one_by_nfrzdrv)
    );

hdpldadapt_cmn_clkor2 hdpldadapt_cmn_clkor2_pld_fpll_shared_direct_async_out_dcm_bit2_frz
    (
        .clkout(pld_fpll_shared_direct_async_out_dcm[2]),
        .clk(pld_fpll_shared_direct_async_out_dcm_bit2_mux1),
        .en(frz_2one_by_nfrzdrv)
    );

hdpldadapt_cmn_clkor2 hdpldadapt_cmn_clkor2_pld_fpll_shared_direct_async_out_dcm_bit1_frz
    (
        .clkout(pld_fpll_shared_direct_async_out_dcm[1]),
        .clk(pld_fpll_shared_direct_async_out_dcm_bit1_mux1),
        .en(frz_2one_by_nfrzdrv)
    );

hdpldadapt_cmn_clkor2 hdpldadapt_cmn_clkor2_pld_fpll_shared_direct_async_out_dcm_bit0_frz
    (
        .clkout(pld_fpll_shared_direct_async_out_dcm[0]),
        .clk(pld_fpll_shared_direct_async_out_dcm_bit0_mux1),
        .en(frz_2one_by_nfrzdrv)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_pld_fpll_shared_direct_async_out_dcm_bit3_mux1
    (
        .clk_o(pld_fpll_shared_direct_async_out_dcm_bit3_mux1),
        .clk_0(adapter_scan_shift_clk),
        .clk_1(aib_fabric_fpll_shared_direct_async_in[3]),
        .clk_sel(adapter_scan_mode_n)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_pld_fpll_shared_direct_async_out_dcm_bit2_mux1
    (
        .clk_o(pld_fpll_shared_direct_async_out_dcm_bit2_mux1),
        .clk_0(adapter_scan_shift_clk),
        .clk_1(aib_fabric_fpll_shared_direct_async_in[2]),
        .clk_sel(adapter_scan_mode_n)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_pld_fpll_shared_direct_async_out_dcm_bit1_mux1
    (
        .clk_o(pld_fpll_shared_direct_async_out_dcm_bit1_mux1),
        .clk_0(adapter_scan_shift_clk),
        .clk_1(aib_fabric_fpll_shared_direct_async_in[1]),
        .clk_sel(adapter_scan_mode_n)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_pld_fpll_shared_direct_async_out_dcm_bit0_mux1
    (
        .clk_o(pld_fpll_shared_direct_async_out_dcm_bit0_mux1),
        .clk_0(adapter_scan_shift_clk),
        .clk_1(aib_fabric_fpll_shared_direct_async_in[0]),
        .clk_sel(adapter_scan_mode_n)
    );

// ECO End //

/*
hdpldadapt_cmn_clkor2 hdpldadapt_cmn_clkor2_pld_fpll_shared_direct_async_out_hioint_bit3_frz
    (
        .clkout(pld_fpll_shared_direct_async_out_hioint[3]),
        .clk(aib_fabric_fpll_shared_direct_async_in[3]),
        .en(frz_2one_by_nfrzdrv_or_pr_channel_freeze_n)
    );

hdpldadapt_cmn_clkor2 hdpldadapt_cmn_clkor2_pld_fpll_shared_direct_async_out_dcm_bit3_frz
    (
        .clkout(pld_fpll_shared_direct_async_out_dcm[3]),
        .clk(aib_fabric_fpll_shared_direct_async_in[3]),
        .en(frz_2one_by_nfrzdrv)
    );
*/

hdpldadapt_cmn_clkor2 hdpldadapt_cmn_clkor2_pld_pcs_tx_clk_out1_hioint_frz
    (
        .clkout(pld_pcs_tx_clk_out1_hioint),
        .clk(tx_clock_aib_clk1_hioint_dft_mux1),
        .en(frz_2one_by_nfrzdrv_or_pr_channel_freeze_n)
    );

hdpldadapt_cmn_clkor2 hdpldadapt_cmn_clkor2_pld_pcs_tx_clk_out1_dcm_frz
    (
        .clkout(pld_pcs_tx_clk_out1_dcm),
        .clk(tx_clock_aib_clk1_dcm_dft_mux1),
        .en(frz_2one_by_nfrzdrv)
    );

hdpldadapt_cmn_clkor2 hdpldadapt_cmn_clkor2_pld_pcs_tx_clk_out2_hioint_frz
    (
        .clkout(pld_pcs_tx_clk_out2_hioint),
        .clk(tx_clock_aib_clk2_hioint_dft_mux1),
        .en(frz_2one_by_nfrzdrv_or_pr_channel_freeze_n)
    );

hdpldadapt_cmn_clkor2 hdpldadapt_cmn_clkor2_pld_pcs_tx_clk_out2_dcm_frz
    (
        .clkout(pld_pcs_tx_clk_out2_dcm),
        .clk(tx_clock_aib_clk2_dcm_dft_mux1),
        .en(frz_2one_by_nfrzdrv)
    );

// ECO Start //

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_tx_clock_aib_clk1_hioint_dft_mux1
    (
        .clk_o(tx_clock_aib_clk1_hioint_dft_mux1),
        .clk_0(tx_clock_aib_clk1_hioint_dft_mux2),
        .clk_1(tx_clock_aib_clk1_mux1),
        .clk_sel(adapter_scan_mode_n)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_tx_clock_aib_clk1_hioint_dft_mux2
    (
        .clk_o(tx_clock_aib_clk1_hioint_dft_mux2),
        .clk_0(tx_clock_pld_clk1_delay_mux1),
        .clk_1(tx_clock_aib_clk1_mux1),
        .clk_sel(pld_clk_dft_sel)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_tx_clock_aib_clk1_dcm_dft_mux1
    (
        .clk_o(tx_clock_aib_clk1_dcm_dft_mux1),
        .clk_0(adapter_scan_shift_clk),
        .clk_1(tx_clock_aib_clk1_mux1),
        .clk_sel(adapter_scan_mode_n)
    );

// ECO End //

assign tx_aib_clk1_sel1 = (r_tx_aib_clk1_sel == 2'b10);
assign tx_aib_clk1_sel2 = (r_tx_aib_clk1_sel == 2'b01);

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_tx_aib_clk1_mux1
    (
        .clk_o(tx_clock_aib_clk1_mux1),
        .clk_0(tx_clock_aib_clk1_mux2),
        .clk_1(aib_fabric_pld_pma_clkdiv_tx_user),
        .clk_sel(tx_aib_clk1_sel1)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_tx_aib_clk1_mux2
    (
        .clk_o(tx_clock_aib_clk1_mux2),
        .clk_0(aib_fabric_pld_pcs_tx_clk_out),
        .clk_1(aib_fabric_pma_aib_tx_clk),
        .clk_sel(tx_aib_clk1_sel2)
    );

// ECO Start //

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_tx_clock_aib_clk2_hioint_dft_mux1
    (
        .clk_o(tx_clock_aib_clk2_hioint_dft_mux1),
        .clk_0(tx_clock_aib_clk2_hioint_dft_mux2),
        .clk_1(tx_clock_aib_clk2_mux1),
        .clk_sel(adapter_scan_mode_n)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_tx_clock_aib_clk2_hioint_dft_mux2
    (
        .clk_o(tx_clock_aib_clk2_hioint_dft_mux2),
        .clk_0(tx_clock_pld_clk2_mux1),
        .clk_1(tx_clock_aib_clk2_mux1),
        .clk_sel(pld_clk_dft_sel)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_tx_clock_aib_clk2_dcm_dft_mux1
    (
        .clk_o(tx_clock_aib_clk2_dcm_dft_mux1),
        .clk_0(adapter_scan_shift_clk),
        .clk_1(tx_clock_aib_clk2_mux1),
        .clk_sel(adapter_scan_mode_n)
    );

// ECO End //

assign tx_aib_clk2_sel1 = (r_tx_aib_clk2_sel == 2'b10);
assign tx_aib_clk2_sel2 = (r_tx_aib_clk2_sel == 2'b01);

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_tx_aib_clk2_mux1
    (
        .clk_o(tx_clock_aib_clk2_mux1),
        .clk_0(tx_clock_aib_clk2_mux2),
        .clk_1(aib_fabric_pld_pma_clkdiv_tx_user),
        .clk_sel(tx_aib_clk2_sel1)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_tx_aib_clk2_mux2
    (
        .clk_o(tx_clock_aib_clk2_mux2),
        .clk_0(aib_fabric_pld_pcs_tx_clk_out),
        .clk_1(aib_fabric_pma_aib_tx_clk),
        .clk_sel(tx_aib_clk2_sel2)
    );

////////// FIFO Read Clock //////////

assign aib_fabric_tx_transfer_clk = tx_clock_fifo_rd_clk_mux1;	// Should this be on separate clock source?

assign tx_clock_reset_fifo_rd_clk = tx_clock_fifo_rd_clk_mux1;

assign tx_fifo_rd_clk_frm_gen_clk_en = tx_clock_dft_scg_bypass | ~r_tx_fifo_rd_clk_frm_gen_scg_en;
assign tx_fifo_rd_clk_en = tx_clock_dft_scg_bypass | ~r_tx_fifo_rd_clk_scg_en;

hdpldadapt_cmn_clkand2 hdpldadapt_cmn_clkand2_tx_fifo_rd_clk_frm_gen_scg
    (
        .clkout(tx_clock_fifo_rd_clk_frm_gen),
        .clk(tx_clock_fifo_rd_clk_mux1),
        .en(tx_fifo_rd_clk_frm_gen_clk_en)
    );

hdpldadapt_cmn_clkand2 hdpldadapt_cmn_clkand2_tx_fifo_rd_clk_scg
    (
        .clkout(tx_clock_fifo_rd_clk),
        .clk(tx_clock_fifo_rd_clk_mux1),
        .en(tx_fifo_rd_clk_en)
    );

assign tx_fifo_rd_clk_sel1 = tx_clock_dft_clk_sel_n && (r_tx_fifo_rd_clk_sel == 2'b00);
assign tx_fifo_rd_clk_sel2 = tx_clock_dft_clk_sel_n && (r_tx_fifo_rd_clk_sel == 2'b01);
assign tx_fifo_rd_clk_sel3 = tx_clock_dft_clk_sel_n && (r_tx_fifo_rd_clk_sel == 2'b10);

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_tx_fifo_rd_clk_mux1
    (
        .clk_o(tx_clock_fifo_rd_clk_mux1),
        .clk_0(tx_clock_fifo_rd_clk_mux2),
        .clk_1(aib_fabric_pma_aib_tx_clk),
        .clk_sel(tx_fifo_rd_clk_sel1)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_tx_fifo_rd_clk_mux2
    (
        .clk_o(tx_clock_fifo_rd_clk_mux2),
        .clk_0(tx_clock_fifo_rd_clk_mux3),
        .clk_1(tx_clock_pld_clk1_delay_mux1),
        .clk_sel(tx_fifo_rd_clk_sel2)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_tx_fifo_rd_clk_mux3
    (
        .clk_o(tx_clock_fifo_rd_clk_mux3),
        .clk_0(tx_clock_fifo_rd_clk_occ),
        .clk_1(tx_clock_pld_clk2_mux1),
        .clk_sel(tx_fifo_rd_clk_sel3)
    );

hdpldadapt_cmn_dft_clock_controller 
    #(
        .CONTROL_REGISTER_PRESENT(1)
    ) hdpldadapt_cmn_dft_clock_controller_tx_fifo_rd_clk_occ1
    (
        .user_clk(adapter_scan_user_clk3),              //User clock
        .test_clk(adapter_scan_shift_clk),              //Test clock
        .rst_n(1'b0),                                   //Reset (active low)
        .clk_sel_n(adapter_clk_sel_n),                  //Mux sel between user or test clock, Active low
        .scan_enable(adapter_scan_shift),               //Scan enable control signal, Active high in IP, Active low in top level
        .occ_enable(adapter_occ_enable),                //Control signal to enable OCC, Active high in IP, Active low in top level
        .atpg_mode(tx_clock_dft_occ_atpg_mode),		//Control signal for test mode, Active high in IP, Active low in top level
        .out_clk(tx_clock_fifo_rd_clk_occ)              //Output clock
    );


////////// FIFO Write Clock //////////

assign tx_clock_fifo_wr_clk = q1_tx_clock_fifo_wr_clk;  // Should this be on separate clock source?
assign tx_clock_reset_fifo_wr_clk = tx_clock_fifo_wr_clk_mux1;

assign q1_tx_fifo_wr_clk_en = tx_clock_dft_scg_bypass | ~r_tx_fifo_wr_clk_scg_en;
assign q2_tx_fifo_wr_clk_en = tx_clock_dft_scg_bypass | (~r_tx_fifo_wr_clk_scg_en & r_tx_fifo_power_mode[0]);
assign q3_tx_fifo_wr_clk_en = tx_clock_dft_scg_bypass | (~r_tx_fifo_wr_clk_scg_en & r_tx_fifo_power_mode[1]);
assign q4_tx_fifo_wr_clk_en = tx_clock_dft_scg_bypass | (~r_tx_fifo_wr_clk_scg_en & r_tx_fifo_power_mode[1] & r_tx_fifo_power_mode[0]);
assign q5_tx_fifo_wr_clk_en = tx_clock_dft_scg_bypass | (~r_tx_fifo_wr_clk_scg_en & r_tx_fifo_power_mode[2] & r_tx_fifo_power_mode[1]);
assign q6_tx_fifo_wr_clk_en = tx_clock_dft_scg_bypass | (~r_tx_fifo_wr_clk_scg_en & r_tx_fifo_power_mode[2] & r_tx_fifo_power_mode[1] & r_tx_fifo_power_mode[0]);

hdpldadapt_cmn_clkand2 hdpldadapt_cmn_clkand2_q1_tx_fifo_wr_clk_scg
    (
        .clkout(q1_tx_clock_fifo_wr_clk),
        .clk(tx_clock_fifo_wr_clk_mux1),
        .en(q1_tx_fifo_wr_clk_en)
    );

hdpldadapt_cmn_clkand2 hdpldadapt_cmn_clkand2_q2_tx_fifo_wr_clk_scg
    (
        .clkout(q2_tx_clock_fifo_wr_clk),
        .clk(tx_clock_fifo_wr_clk_mux1),
        .en(q2_tx_fifo_wr_clk_en)
    );

hdpldadapt_cmn_clkand2 hdpldadapt_cmn_clkand2_q3_tx_fifo_wr_clk_scg
    (
        .clkout(q3_tx_clock_fifo_wr_clk),
        .clk(tx_clock_fifo_wr_clk_mux1),
        .en(q3_tx_fifo_wr_clk_en)
    );

hdpldadapt_cmn_clkand2 hdpldadapt_cmn_clkand2_q4_tx_fifo_wr_clk_scg
    (
        .clkout(q4_tx_clock_fifo_wr_clk),
        .clk(tx_clock_fifo_wr_clk_mux1),
        .en(q4_tx_fifo_wr_clk_en)
    );

hdpldadapt_cmn_clkand2 hdpldadapt_cmn_clkand2_q5_tx_fifo_wr_clk_scg
    (
        .clkout(q5_tx_clock_fifo_wr_clk),
        .clk(tx_clock_fifo_wr_clk_mux1),
        .en(q5_tx_fifo_wr_clk_en)
    );

hdpldadapt_cmn_clkand2 hdpldadapt_cmn_clkand2_q6_tx_fifo_wr_clk_scg
    (
        .clkout(q6_tx_clock_fifo_wr_clk),
        .clk(tx_clock_fifo_wr_clk_mux1),
        .en(q6_tx_fifo_wr_clk_en)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_tx_fifo_wr_clk_mux1
    (
        .clk_o(tx_clock_fifo_wr_clk_mux1),
        .clk_0(tx_clock_fifo_wr_clk_occ),
        .clk_1(tx_clock_pld_clk1_delay_mux1),
        .clk_sel(tx_clock_dft_clk_sel_n)
    );

hdpldadapt_cmn_dft_clock_controller 
    #(
        .CONTROL_REGISTER_PRESENT(1)
    ) hdpldadapt_cmn_dft_clock_controller_tx_fifo_wr_clk_occ2
    (
        .user_clk(adapter_scan_user_clk3),              //User clock
        .test_clk(adapter_scan_shift_clk),              //Test clock
        .rst_n(1'b0),                                   //Reset (active low)
        .clk_sel_n(adapter_clk_sel_n),                  //Mux sel between user or test clock, Active low
        .scan_enable(adapter_scan_shift),               //Scan enable control signal, Active high in IP, Active low in top level
        .occ_enable(adapter_occ_enable),                //Control signal to enable OCC, Active high in IP, Active low in top level
        .atpg_mode(tx_clock_dft_occ_atpg_mode),		//Control signal for test mode, Active high in IP, Active low in top level
        .out_clk(tx_clock_fifo_wr_clk_occ)              //Output clock
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_tx_pld_clk1_delay_mux1
    (
        .clk_o(tx_clock_pld_clk1_delay_mux1),
        .clk_0(tx_clock_pld_clk1_inv_mux1),
        .clk_1(tx_clock_pld_clk1_delay),
        .clk_sel(r_tx_pld_clk1_delay_en)
    );

hdpldadapt_cmn_clkdelay_map hdpldadapt_cmn_clkdelay_tx_pld_clk1
    (
        .clkout(tx_clock_pld_clk1_delay),
        .r_clk_delay_sel(r_tx_pld_clk1_delay_sel),
        .clk(tx_clock_pld_clk1_inv_mux1)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_tx_pld_clk1_inv_mux1
    (
        .clk_o(tx_clock_pld_clk1_inv_mux1),
        .clk_0(tx_clock_pld_clk1_mux1),
        .clk_1(tx_clock_pld_clk1_inv),
        .clk_sel(r_tx_pld_clk1_inv_en)
    );

hdpldadapt_cmn_clkinv hdpldadapt_cmn_clkinv_tx_pld_clk1_inv
    (
        .clkout(tx_clock_pld_clk1_inv),
        .clk(tx_clock_pld_clk1_mux1)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_tx_pld_clk1_mux1
    (
        .clk_o(tx_clock_pld_clk1_mux1),
        .clk_0(pld_tx_clk1_rowclk),
        .clk_1(pld_tx_clk1_dcm),
        .clk_sel(r_tx_pld_clk1_sel)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_tx_pld_clk2_mux1
    (
        .clk_o(tx_clock_pld_clk2_mux1),
        .clk_0(pld_tx_clk2_rowclk),
        .clk_1(pld_tx_clk2_dcm),
        .clk_sel(r_tx_pld_clk2_sel)
    );

////////// Sample Clock //////////

assign tx_clock_fifo_sclk = tx_clock_fifo_sclk_mux1;

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_tx_fifo_sclk_mux1
    (
        .clk_o(tx_clock_fifo_sclk_mux1),
        .clk_0(tx_clock_fifo_sclk_occ),
        .clk_1(rx_clock_pld_sclk),
        .clk_sel(tx_clock_dft_clk_sel_n)
    );

hdpldadapt_cmn_dft_clock_controller 
    #(
        .CONTROL_REGISTER_PRESENT(1)
    ) hdpldadapt_cmn_dft_clock_controller_tx_fifo_sclk_occ3
    (
        .user_clk(adapter_scan_user_clk1),              //User clock
        .test_clk(adapter_scan_shift_clk),              //Test clock
        .rst_n(1'b0),                                   //Reset (active low)
        .clk_sel_n(adapter_clk_sel_n),                  //Mux sel between user or test clock, Active low
        .scan_enable(adapter_scan_shift),               //Scan enable control signal, Active high in IP, Active low in top level
        .occ_enable(adapter_occ_enable),                //Control signal to enable OCC, Active high in IP, Active low in top level
        .atpg_mode(tx_clock_dft_occ_atpg_mode),		//Control signal for test mode, Active high in IP, Active low in top level
        .out_clk(tx_clock_fifo_sclk_occ)                //Output clock
    );

////////// Rx Oscillator Clock //////////

assign tx_clock_reset_hrdrst_rx_osc_clk = tx_clock_rx_osc_clk_mux1;
assign tx_clock_reset_async_rx_osc_clk = tx_clock_rx_osc_clk_mux1;

assign tx_hrdrst_rx_osc_clk_en = tx_clock_dft_scg_bypass | ~r_tx_hrdrst_rx_osc_clk_scg_en;
assign tx_hip_osc_clk_en = tx_clock_dft_scg_bypass | ~r_tx_hip_osc_clk_scg_en;
assign tx_osc_clk_en = tx_clock_dft_scg_bypass | ~r_tx_osc_clk_scg_en;

hdpldadapt_cmn_clkand2 hdpldadapt_cmn_clkand2_tx_hrdrst_rx_osc_clk_scg
    (
        .clkout(tx_clock_hrdrst_rx_osc_clk),
        .clk(tx_clock_rx_osc_clk_mux1),
        .en(tx_hrdrst_rx_osc_clk_en)
    );

hdpldadapt_cmn_clkand2 hdpldadapt_cmn_clkand2_tx_hip_async_rx_osc_clk_scg
    (
        .clkout(tx_clock_hip_async_rx_osc_clk),
        .clk(tx_clock_rx_osc_clk_mux1),
        .en(tx_hip_osc_clk_en)
    );

hdpldadapt_cmn_clkand2 hdpldadapt_cmn_clkand2_tx_async_rx_osc_clk_scg
    (
        .clkout(tx_clock_async_rx_osc_clk),
        .clk(tx_clock_rx_osc_clk_mux1),
        .en(tx_osc_clk_en)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_tx_rx_osc_clk_mux1
    (
        .clk_o(tx_clock_rx_osc_clk_mux1),
        .clk_0(tx_clock_rx_osc_clk_occ),
        .clk_1(aib_fabric_rx_sr_clk_in),
        .clk_sel(tx_clock_dft_clk_sel_n)
    );

hdpldadapt_cmn_dft_clock_controller 
    #(
        .CONTROL_REGISTER_PRESENT(1)
    ) hdpldadapt_cmn_dft_clock_controller_tx_rx_osc_clk_occ4
    (
        .user_clk(adapter_scan_user_clk3),              //User clock
        .test_clk(adapter_scan_shift_clk),              //Test clock
        .rst_n(1'b0),                                   //Reset (active low)
        .clk_sel_n(adapter_clk_sel_n),                  //Mux sel between user or test clock, Active low
        .scan_enable(adapter_scan_shift),               //Scan enable control signal, Active high in IP, Active low in top level
        .occ_enable(adapter_occ_enable),                //Control signal to enable OCC, Active high in IP, Active low in top level
        .atpg_mode(tx_clock_dft_occ_atpg_mode),		//Control signal for test mode, Active high in IP, Active low in top level
        .out_clk(tx_clock_rx_osc_clk_occ)               //Output clock
    );

////////// Tx Oscillator Clock //////////

assign tx_clock_reset_async_tx_osc_clk = tx_clock_tx_osc_clk_mux1;

hdpldadapt_cmn_clkand2 hdpldadapt_cmn_clkand2_tx_hip_async_tx_osc_clk_scg
    (
        .clkout(tx_clock_hip_async_tx_osc_clk),
        .clk(tx_clock_tx_osc_clk_mux1),
        .en(tx_hip_osc_clk_en)
    );

hdpldadapt_cmn_clkand2 hdpldadapt_cmn_clkand2_tx_async_tx_osc_clk_scg
    (
        .clkout(tx_clock_async_tx_osc_clk),
        .clk(tx_clock_tx_osc_clk_mux1),
        .en(tx_osc_clk_en)
    );

hdpldadapt_cmn_clkmux2 hdpldadapt_cmn_clkmux2_tx_tx_osc_clk_mux1
    (
        .clk_o(tx_clock_tx_osc_clk_mux1),
        .clk_0(tx_clock_tx_osc_clk_occ),
        .clk_1(aib_fabric_tx_sr_clk_in),
        .clk_sel(tx_clock_dft_clk_sel_n)
    );

hdpldadapt_cmn_dft_clock_controller 
    #(
        .CONTROL_REGISTER_PRESENT(1)
    ) hdpldadapt_cmn_dft_clock_controller_tx_tx_osc_clk_occ5
    (
        .user_clk(adapter_scan_user_clk3),              //User clock
        .test_clk(adapter_scan_shift_clk),              //Test clock
        .rst_n(1'b0),                                   //Reset (active low)
        .clk_sel_n(adapter_clk_sel_n),                  //Mux sel between user or test clock, Active low
        .scan_enable(adapter_scan_shift),               //Scan enable control signal, Active high in IP, Active low in top level
        .occ_enable(adapter_occ_enable),                //Control signal to enable OCC, Active high in IP, Active low in top level
        .atpg_mode(tx_clock_dft_occ_atpg_mode),		//Control signal for test mode, Active high in IP, Active low in top level
        .out_clk(tx_clock_tx_osc_clk_occ)               //Output clock
    );

endmodule // hdpldadapt_txclk_ctl
