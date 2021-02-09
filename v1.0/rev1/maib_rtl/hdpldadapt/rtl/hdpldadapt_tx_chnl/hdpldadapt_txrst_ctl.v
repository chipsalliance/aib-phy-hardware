// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module hdpldadapt_txrst_ctl
(
	input	wire		csr_rdy_dly_in,
	input	wire		nfrzdrv_in,
	input	wire		pr_channel_freeze_n,
	input	wire		usermode_in,
	input	wire		pld_pcs_tx_pld_rst_n,
	input	wire		pld_adapter_tx_pld_rst_n,
	//input	wire		pld_pma_fpll_dps_rst_n_lc_tx_bonding_rstb,
	//input	wire		pld_pma_fpll_phase_en_lc_master_cgb_rstn,
	//input	wire		pld_pma_fpll_lc_rstb,
	input	wire [1:0]	pld_fpll_shared_direct_async_in,
	input	wire		pld_pma_txpma_rstb,
	input	wire		pld_aib_fabric_tx_dcd_cal_req,
	input	wire		pld_fabric_tx_fifo_srst,
	//input	wire		pld_partial_reconfig,
	//input	wire [4:0]	aib_fabric_fpll_shared_direct_async_in,
	input   wire            aib_fabric_tx_dcd_cal_done,
	input   wire            bond_tx_hrdrst_ds_in_fabric_tx_dcd_cal_done,
	input   wire            bond_tx_hrdrst_us_in_fabric_tx_dcd_cal_done,
	input   wire            bond_tx_hrdrst_ds_in_fabric_tx_dcd_cal_req,
	input   wire            bond_tx_hrdrst_us_in_fabric_tx_dcd_cal_req,
	input	wire		avmm_hrdrst_fabric_osc_transfer_en,
	input	wire		sr_hssi_tx_dcd_cal_done,
	input	wire		sr_hssi_tx_dll_lock,
	input	wire		sr_hssi_tx_transfer_en,
	input	wire		rx_asn_rate_change_in_progress,
	input	wire		rx_asn_dll_lock_en,
	input	wire		rx_asn_fifo_hold,
	input	wire		tx_fifo_ready,
	input	wire		tx_clock_reset_hrdrst_rx_osc_clk,
	input	wire		tx_clock_reset_fifo_wr_clk,
	input	wire		tx_clock_reset_fifo_rd_clk,
	input	wire		tx_clock_fifo_sclk,
	input	wire		tx_clock_reset_async_rx_osc_clk,
	input	wire		tx_clock_reset_async_tx_osc_clk,
	input	wire		tx_clock_hrdrst_rx_osc_clk,		// Static clock gated
	input	wire		r_tx_hrdrst_rst_sm_dis,
	input	wire		r_tx_hrdrst_dcd_cal_done_bypass,
	input	wire		r_tx_hrdrst_user_ctl_en,
	input   wire [1:0]      r_tx_master_sel,
	input   wire            r_tx_dist_master_sel,
	input   wire            r_tx_ds_last_chnl,
	input   wire            r_tx_us_last_chnl,
	input   wire            r_tx_bonding_dft_in_en,
	input   wire            r_tx_bonding_dft_in_value,
	input 	wire            adapter_scan_rst_n,
	input	wire            adapter_scan_mode_n,
	//output	wire [4:0]	pld_fpll_shared_direct_async_out,
	output	wire		aib_fabric_pcs_tx_pld_rst_n,
	output	wire		aib_fabric_adapter_tx_pld_rst_n,
	//output	wire		aib_fabric_pld_pma_fpll_dps_rst_n_lc_tx_bonding_rstb,
	//output	wire		aib_fabric_pld_pma_fpll_phase_en_lc_master_cgb_rstn,
	//output	wire		aib_fabric_pld_pma_fpll_lc_rstb,
	output	wire		pld_fabric_tx_transfer_en,
	output	wire		pld_aib_fabric_tx_dcd_cal_done,
	output	wire [2:1]	aib_fabric_fpll_shared_direct_async_out,
	output	wire		aib_fabric_pld_pma_txpma_rstb,
	output  wire		aib_fabric_tx_dcd_cal_req,
        output  wire            bond_tx_hrdrst_ds_out_fabric_tx_dcd_cal_done,
        output  wire            bond_tx_hrdrst_us_out_fabric_tx_dcd_cal_done,
        output  wire            bond_tx_hrdrst_ds_out_fabric_tx_dcd_cal_req,
        output  wire            bond_tx_hrdrst_us_out_fabric_tx_dcd_cal_req,
	output	wire		tx_hrdrst_tx_fifo_srst,
	output	reg		tx_hrdrst_fabric_tx_dcd_cal_done,
	output	reg		tx_hrdrst_fabric_tx_transfer_en,
	output  wire [19:0]	tx_hrdrst_testbus,
	output	wire		tx_reset_fifo_wr_rst_n,
	output	wire		tx_reset_fifo_rd_rst_n,
	output	wire		tx_reset_fifo_sclk_rst_n,
	output	wire		tx_reset_async_rx_osc_clk_rst_n,
	output	wire		tx_reset_async_tx_osc_clk_rst_n
);

//********************************************************************
// Define Parameters 
//********************************************************************

	localparam  WAIT_TX_TRANSFER_REQ	= 3'b000;
	localparam  SEND_TX_DCD_CAL_REQ		= 3'b001;
	localparam  WAIT_REMOTE_TX_DLL_LOCK	= 3'b010;
	localparam  WAIT_REMOTE_TX_ALIGN_DONE	= 3'b011;
	localparam  TX_TRANSFER_EN		= 3'b100;

//********************************************************************
//********************************************************************

	wire		frz_2one_by_nfrzdrv_or_pr_channel_freeze_n;

	wire		int_pld_pcs_tx_pld_rst_n;
	wire		int_pld_adapter_tx_pld_rst_n;
	wire		int_pld_pma_txpma_rstb;
	wire		int_pld_aib_fabric_tx_dcd_cal_req;

	wire		int_tx_rst_n;
	//wire		int_tx_datapath_rst_n;
	wire		int_tx_hrd_rst_n;
	wire		tx_reset_hrdrst_rx_osc_clk_rst_n;

	reg [2:0]   	tx_rst_sm_cs;
	reg [2:0]   	tx_rst_sm_ns;

	reg		tx_hrdrst_fabric_tx_dcd_cal_req;
	wire		tx_hrdrst_fabric_tx_dcd_cal_req_pre;
	reg		tx_hrdrst_fabric_tx_dcd_cal_req_comb;

        //reg             tx_hrdrst_fabric_tx_async_rst;
        //wire            tx_hrdrst_fabric_tx_async_rst_pre;
	wire		tx_hrdrst_fabric_tx_fifo_srst_final;
        reg             tx_hrdrst_fabric_tx_fifo_srst;
        wire            tx_hrdrst_fabric_tx_fifo_srst_pre;
        reg             tx_hrdrst_fabric_tx_rst_comb;

	wire		tx_hrdrst_fabric_tx_dcd_cal_done_pre;
	reg		tx_hrdrst_fabric_tx_dcd_cal_done_comb;

	wire		tx_hrdrst_fabric_tx_transfer_en_pre;
	reg		tx_hrdrst_fabric_tx_transfer_en_comb;

	wire		sync_rx_asn_rate_change_in_progress;
	wire		sync_rx_asn_dll_lock_en;
	wire            sync_rx_asn_fifo_hold;
        reg             sync_rx_asn_fifo_hold_reg;
        reg [5:0]       tx_hrdrst_speed_chg_srst_cnt;
	reg		tx_hrdrst_speed_chg_srst_dly;
        reg             tx_hrdrst_speed_chg_srst;

	wire		aib_fabric_tx_dcd_cal_req_int;
	wire		aib_fabric_tx_dcd_cal_done_int;
	wire		sync_aib_fabric_tx_dcd_cal_done;
	wire		sync_tx_fifo_ready;

	wire            bond_tx_hrdrst_ds_in_fabric_tx_dcd_cal_done_int;
	wire            bond_tx_hrdrst_us_in_fabric_tx_dcd_cal_done_int;
	wire            bond_tx_hrdrst_ds_in_fabric_tx_dcd_cal_req_int;
	wire            bond_tx_hrdrst_us_in_fabric_tx_dcd_cal_req_int;
	
	wire            tx_hrdrst_fabric_tx_dcd_cal_done_chnl_down;
	wire            tx_hrdrst_fabric_tx_dcd_cal_done_chnl_up;
	wire		tx_hrdrst_fabric_tx_dcd_cal_req_final;
	wire            tx_hrdrst_fabric_tx_dcd_cal_req_chnl_down;
	wire            tx_hrdrst_fabric_tx_dcd_cal_req_chnl_up;

//********************************************************************
// Gate with User Mode
//********************************************************************
	assign int_pld_pcs_tx_pld_rst_n = usermode_in & pld_pcs_tx_pld_rst_n;
	assign int_pld_adapter_tx_pld_rst_n = usermode_in & pld_adapter_tx_pld_rst_n;
	assign int_pld_pma_txpma_rstb = usermode_in & pld_pma_txpma_rstb;

	assign int_pld_aib_fabric_tx_dcd_cal_req = usermode_in & pld_aib_fabric_tx_dcd_cal_req;

//********************************************************************
// Feedthrough from PLD to AIB
//********************************************************************
	assign aib_fabric_pcs_tx_pld_rst_n = int_pld_pcs_tx_pld_rst_n;
	assign aib_fabric_adapter_tx_pld_rst_n = int_pld_adapter_tx_pld_rst_n;
	//assign aib_fabric_pld_pma_fpll_dps_rst_n_lc_tx_bonding_rstb = pld_pma_fpll_dps_rst_n_lc_tx_bonding_rstb;
	//assign aib_fabric_pld_pma_fpll_phase_en_lc_master_cgb_rstn = pld_pma_fpll_phase_en_lc_master_cgb_rstn;
	//assign aib_fabric_pld_pma_fpll_lc_rstb = pld_pma_fpll_lc_rstb;
	assign aib_fabric_pld_pma_txpma_rstb = int_pld_pma_txpma_rstb;
	assign aib_fabric_fpll_shared_direct_async_out[2:1] = pld_fpll_shared_direct_async_in[1:0];

//********************************************************************
// Feedthrough from AIB to PLD
//********************************************************************
	// Freeze Control Logic
	//assign nfrz_output_2one = nfrzdrv_in & pld_partial_reconfig;
	//assign pld_fpll_shared_direct_async_out[4:0] = nfrz_output_2one ? aib_fabric_fpll_shared_direct_async_in[4:0] : 5'b11111;

//********************************************************************
// PLD
//********************************************************************
        assign frz_2one_by_nfrzdrv_or_pr_channel_freeze_n = ~(nfrzdrv_in & pr_channel_freeze_n);

        assign pld_fabric_tx_transfer_en = frz_2one_by_nfrzdrv_or_pr_channel_freeze_n | tx_hrdrst_fabric_tx_transfer_en;
        assign pld_aib_fabric_tx_dcd_cal_done = frz_2one_by_nfrzdrv_or_pr_channel_freeze_n | aib_fabric_tx_dcd_cal_done;

	//assign pld_fabric_tx_transfer_en = nfrzdrv_in ? tx_hrdrst_fabric_tx_transfer_en : 1'b1;
	//assign pld_aib_fabric_tx_dcd_cal_done = nfrzdrv_in ? aib_fabric_tx_dcd_cal_done : 1'b1;

//********************************************************************
// Reset Synchronizers
//********************************************************************

	assign int_tx_rst_n = (adapter_scan_mode_n & csr_rdy_dly_in & int_pld_adapter_tx_pld_rst_n) | (~adapter_scan_mode_n & adapter_scan_rst_n);

cdclib_rst_n_sync cdclib_rst_n_sync_tx_hrdrst_rx_osc_clk
        (
        .rst_n(int_tx_rst_n),
        .rst_n_bypass(adapter_scan_rst_n),
        .clk (tx_clock_reset_hrdrst_rx_osc_clk),
        .scan_mode_n(adapter_scan_mode_n),
        .rst_n_sync(tx_reset_hrdrst_rx_osc_clk_rst_n)
        );

//********************************************************************

        //assign int_tx_datapath_rst_n = (adapter_scan_mode_n & csr_rdy_dly_in & int_pld_adapter_tx_pld_rst_n & ~tx_hrdrst_fabric_tx_async_rst) | (~adapter_scan_mode_n & adapter_scan_rst_n);

cdclib_rst_n_sync cdclib_rst_n_sync_fifo_wr_clk
	(
	//.rst_n(int_tx_datapath_rst_n),
        .rst_n(int_tx_rst_n),
	.rst_n_bypass(adapter_scan_rst_n),
	.clk (tx_clock_reset_fifo_wr_clk),
	.scan_mode_n(adapter_scan_mode_n),
	.rst_n_sync(tx_reset_fifo_wr_rst_n)
	);
	
cdclib_rst_n_sync cdclib_rst_n_sync_fifo_rd_clk
	(
	//.rst_n(int_tx_datapath_rst_n),
        .rst_n(int_tx_rst_n),
	.rst_n_bypass(adapter_scan_rst_n),
	.clk (tx_clock_reset_fifo_rd_clk),
	.scan_mode_n(adapter_scan_mode_n),
	.rst_n_sync(tx_reset_fifo_rd_rst_n)
	);
	
cdclib_rst_n_sync cdclib_rst_n_sync_fifo_sclk
	(
	//.rst_n(int_tx_datapath_rst_n),
        .rst_n(int_tx_rst_n),
	.rst_n_bypass(adapter_scan_rst_n),
	.clk (tx_clock_fifo_sclk),
	.scan_mode_n(adapter_scan_mode_n),
	.rst_n_sync(tx_reset_fifo_sclk_rst_n)
	);
	
//********************************************************************

        assign int_tx_hrd_rst_n = (adapter_scan_mode_n & csr_rdy_dly_in) | (~adapter_scan_mode_n & adapter_scan_rst_n);

cdclib_rst_n_sync cdclib_rst_n_sync_rx_osc_clk
        (
        .rst_n(int_tx_hrd_rst_n),
        .rst_n_bypass(adapter_scan_rst_n),
        .clk (tx_clock_reset_async_rx_osc_clk),
        .scan_mode_n(adapter_scan_mode_n),
        .rst_n_sync(tx_reset_async_rx_osc_clk_rst_n)
        );

cdclib_rst_n_sync cdclib_rst_n_sync_tx_osc_clk
        (
        .rst_n(int_tx_hrd_rst_n),
        .rst_n_bypass(adapter_scan_rst_n),
        .clk (tx_clock_reset_async_tx_osc_clk),
        .scan_mode_n(adapter_scan_mode_n),
        .rst_n_sync(tx_reset_async_tx_osc_clk_rst_n)
        );

//********************************************************************
// Double Synchronizers
//********************************************************************

cdclib_bitsync4
    #(
        .DWIDTH      (1),       // Sync Data input
        .RESET_VAL   (0),       // Reset value
	.CLK_FREQ_MHZ(1200),
        .TOGGLE_TYPE (2),
        .VID         (1)
    ) cdclib_bitsync4_rx_asn_rate_change_in_progress
    (
      .clk      (tx_clock_hrdrst_rx_osc_clk),
      .rst_n    (tx_reset_hrdrst_rx_osc_clk_rst_n),
      .data_in  (rx_asn_rate_change_in_progress),
      .data_out (sync_rx_asn_rate_change_in_progress)
    );

cdclib_bitsync4
    #(
        .DWIDTH      (1),       // Sync Data input
        .RESET_VAL   (1),       // Reset value
	.CLK_FREQ_MHZ(1200),
        .TOGGLE_TYPE (2),
        .VID         (1)
    ) cdclib_bitsync4_rx_asn_dll_lock_en
    (
      .clk      (tx_clock_hrdrst_rx_osc_clk),
      .rst_n    (tx_reset_hrdrst_rx_osc_clk_rst_n),
      .data_in  (rx_asn_dll_lock_en),
      .data_out (sync_rx_asn_dll_lock_en)
    );

cdclib_bitsync4
    #(
        .DWIDTH      (1),       // Sync Data input
        .RESET_VAL   (0),       // Reset value
	.CLK_FREQ_MHZ(1200),
        .TOGGLE_TYPE (2),
        .VID         (1)
    ) cdclib_bitsync4_rx_asn_fifo_hold
    (
      .clk      (tx_clock_hrdrst_rx_osc_clk),
      .rst_n    (tx_reset_hrdrst_rx_osc_clk_rst_n),
      .data_in  (rx_asn_fifo_hold),
      .data_out (sync_rx_asn_fifo_hold)
    );

cdclib_bitsync4
    #(
        .DWIDTH      (1),       // Sync Data input
        .RESET_VAL   (0),       // Reset value
	.CLK_FREQ_MHZ(1200),
        .TOGGLE_TYPE (2),
        .VID         (1)
    ) cdclib_bitsync4_aib_fabric_tx_dcd_cal_req
    (
      .clk      (tx_clock_hrdrst_rx_osc_clk),
      .rst_n    (tx_reset_hrdrst_rx_osc_clk_rst_n),
      .data_in  (aib_fabric_tx_dcd_cal_req_int),
      .data_out (aib_fabric_tx_dcd_cal_req)
    );

cdclib_bitsync4
    #(
        .DWIDTH      (1),       // Sync Data input
        .RESET_VAL   (0),       // Reset value
	.CLK_FREQ_MHZ(1200),
        .TOGGLE_TYPE (2),
        .VID         (1)
    ) cdclib_bitsync4_aib_fabric_tx_dcd_cal_done_int
    (
      .clk      (tx_clock_hrdrst_rx_osc_clk),
      .rst_n    (tx_reset_hrdrst_rx_osc_clk_rst_n),
      .data_in  (aib_fabric_tx_dcd_cal_done_int),
      .data_out (sync_aib_fabric_tx_dcd_cal_done)
    );

cdclib_bitsync4
    #(
        .DWIDTH      (1),       // Sync Data input
        .RESET_VAL   (0),       // Reset value
        .CLK_FREQ_MHZ(1200),
        .TOGGLE_TYPE (2),
        .VID         (1)
    ) cdclib_bitsync4_tx_fifo_ready
    (
      .clk      (tx_clock_hrdrst_rx_osc_clk),
      .rst_n    (tx_reset_hrdrst_rx_osc_clk_rst_n),
      .data_in  (tx_fifo_ready),
      .data_out (sync_tx_fifo_ready)
    );

//********************************************************************
// Test bus
//********************************************************************
assign tx_hrdrst_testbus[19:0] = {3'b000,aib_fabric_tx_dcd_cal_done,aib_fabric_tx_dcd_cal_req,
				  tx_hrdrst_fabric_tx_transfer_en,tx_hrdrst_fabric_tx_dcd_cal_done,tx_hrdrst_fabric_tx_fifo_srst,tx_hrdrst_speed_chg_srst,sync_rx_asn_fifo_hold,tx_hrdrst_fabric_tx_dcd_cal_req,
				  sr_hssi_tx_transfer_en,sr_hssi_tx_dll_lock,sync_aib_fabric_tx_dcd_cal_done,sr_hssi_tx_dcd_cal_done,sync_rx_asn_dll_lock_en,
				  sync_rx_asn_rate_change_in_progress,tx_rst_sm_cs[2:0]};

//********************************************************************
// ASN
//********************************************************************
always @ (negedge tx_reset_hrdrst_rx_osc_clk_rst_n or posedge tx_clock_hrdrst_rx_osc_clk)
begin
        if (~tx_reset_hrdrst_rx_osc_clk_rst_n)
        begin
                sync_rx_asn_fifo_hold_reg <= 1'b0;
                tx_hrdrst_speed_chg_srst_dly <= 1'b0;
                tx_hrdrst_speed_chg_srst <= 1'b0;
        end
        else
        begin
                sync_rx_asn_fifo_hold_reg <= sync_rx_asn_fifo_hold;
                tx_hrdrst_speed_chg_srst_dly <= (sync_rx_asn_fifo_hold && ~sync_rx_asn_fifo_hold_reg) || tx_hrdrst_speed_chg_srst_dly && (tx_hrdrst_speed_chg_srst_cnt[5:0] != 6'b111111);
                //tx_hrdrst_speed_chg_srst <= (sync_rx_asn_fifo_hold && ~sync_rx_asn_fifo_hold_reg) || (tx_hrdrst_speed_chg_srst && (tx_hrdrst_speed_chg_srst_cnt[4:0] != 5'b11111));
                tx_hrdrst_speed_chg_srst <= (tx_hrdrst_speed_chg_srst_dly && (tx_hrdrst_speed_chg_srst_cnt[5:0] == 6'b111111)) || (tx_hrdrst_speed_chg_srst && (tx_hrdrst_speed_chg_srst_cnt[5:0] != 6'b111111));
      end
  end


// The tx_hrdrst_speed_chg_srst pulse must be long enough to be sampled by FIFO clock domain during PIPE mode, i.e. slowest is 125MHz.
always @ (negedge tx_reset_hrdrst_rx_osc_clk_rst_n or posedge tx_clock_hrdrst_rx_osc_clk)
begin
        if (~tx_reset_hrdrst_rx_osc_clk_rst_n)
        begin
                tx_hrdrst_speed_chg_srst_cnt[5:0] <= 6'b000000;
        end
        else
        begin
                //if (tx_hrdrst_speed_chg_srst)
                if (tx_hrdrst_speed_chg_srst_dly || tx_hrdrst_speed_chg_srst)
                begin
                        tx_hrdrst_speed_chg_srst_cnt[5:0] <= tx_hrdrst_speed_chg_srst_cnt[5:0] + 6'b000001;
                end
                else
                begin
                        tx_hrdrst_speed_chg_srst_cnt[5:0] <= 6'b000000;
                end
      end
  end

//********************************************************************
// FIFO Reset
//********************************************************************
assign tx_hrdrst_tx_fifo_srst = r_tx_hrdrst_user_ctl_en ? pld_fabric_tx_fifo_srst : tx_hrdrst_fabric_tx_fifo_srst_final;
// FIFO Reset when Reset SM is enabled
// From master Reset SM when current channel is master channel
// From master ASN SM when current channel is slave channel
assign tx_hrdrst_fabric_tx_fifo_srst_final = (r_tx_master_sel == 2'b00) ? tx_hrdrst_fabric_tx_fifo_srst : tx_hrdrst_speed_chg_srst;

//********************************************************************
// Tx Reset State Machine Bonding Input Output
//********************************************************************
assign bond_tx_hrdrst_ds_in_fabric_tx_dcd_cal_done_int = r_tx_bonding_dft_in_en ? r_tx_bonding_dft_in_value : bond_tx_hrdrst_ds_in_fabric_tx_dcd_cal_done;
assign bond_tx_hrdrst_us_in_fabric_tx_dcd_cal_done_int = r_tx_bonding_dft_in_en ? r_tx_bonding_dft_in_value : bond_tx_hrdrst_us_in_fabric_tx_dcd_cal_done;
assign bond_tx_hrdrst_ds_in_fabric_tx_dcd_cal_req_int = r_tx_bonding_dft_in_en ? r_tx_bonding_dft_in_value : bond_tx_hrdrst_ds_in_fabric_tx_dcd_cal_req;
assign bond_tx_hrdrst_us_in_fabric_tx_dcd_cal_req_int = r_tx_bonding_dft_in_en ? r_tx_bonding_dft_in_value : bond_tx_hrdrst_us_in_fabric_tx_dcd_cal_req;

hdpldadapt_cmn_cp_dist_pair
    #(
        .ASYNC_RESET_VAL(0),
        .WIDTH(1)               // Control width
    ) hdpldadapt_cmn_cp_dist_pair_fabric_tx_dcd_cal_req
    (
        .clk(1'b0),                                             // clock
        .rst_n(1'b1),                                           // async reset
        .srst_n(1'b1),                                          // sync reset
        .data_enable(1'b1),                                     // data enable / data valid
        .master_in(tx_hrdrst_fabric_tx_dcd_cal_req),                       // master control signal
        .us_in(bond_tx_hrdrst_us_in_fabric_tx_dcd_cal_req_int),                // CP distributed signal in up
        .ds_in(bond_tx_hrdrst_ds_in_fabric_tx_dcd_cal_req_int),                // CP distributed signal in dwn
        .r_us_master(r_tx_dist_master_sel),                 // CRAM to control master or distributed up
        .r_ds_master(r_tx_dist_master_sel),                 // CRAM to control master or distributed dwn
        .r_us_bypass_pipeln(1'b1),                              // CRAM combo or registered up
        .r_ds_bypass_pipeln(1'b1),                              // CRAM combo or registered dwn
        .us_out(bond_tx_hrdrst_us_out_fabric_tx_dcd_cal_req),                  // CP distributed signal out up
        .ds_out(bond_tx_hrdrst_ds_out_fabric_tx_dcd_cal_req),                  // CP distributed signal out dwn
        .ds_tap(tx_hrdrst_fabric_tx_dcd_cal_req_chnl_down),    // CP output for this channel dwn
        .us_tap(tx_hrdrst_fabric_tx_dcd_cal_req_chnl_up)       // CP output for this channel up
    );

	//assign aib_fabric_tx_dcd_cal_req = r_tx_hrdrst_rst_sm_dis ? int_pld_aib_fabric_tx_dcd_cal_req : tx_hrdrst_fabric_tx_dcd_cal_req_final;
	assign aib_fabric_tx_dcd_cal_req_int = r_tx_hrdrst_user_ctl_en ? int_pld_aib_fabric_tx_dcd_cal_req : tx_hrdrst_fabric_tx_dcd_cal_req_final;
	assign tx_hrdrst_fabric_tx_dcd_cal_req_final = (r_tx_master_sel == 2'b00) ? tx_hrdrst_fabric_tx_dcd_cal_req		:
						       (r_tx_master_sel == 2'b01) ? tx_hrdrst_fabric_tx_dcd_cal_req_chnl_up	:
						       (r_tx_master_sel == 2'b10) ? tx_hrdrst_fabric_tx_dcd_cal_req_chnl_down	:
										    tx_hrdrst_fabric_tx_dcd_cal_req		;

        assign tx_hrdrst_fabric_tx_dcd_cal_done_chnl_down = r_tx_ds_last_chnl ? 1'b1 : bond_tx_hrdrst_ds_in_fabric_tx_dcd_cal_done_int;
        assign tx_hrdrst_fabric_tx_dcd_cal_done_chnl_up = r_tx_us_last_chnl ? 1'b1 : bond_tx_hrdrst_us_in_fabric_tx_dcd_cal_done_int;
	assign aib_fabric_tx_dcd_cal_done_int = (aib_fabric_tx_dcd_cal_done & tx_hrdrst_fabric_tx_dcd_cal_done_chnl_up & tx_hrdrst_fabric_tx_dcd_cal_done_chnl_down);
        assign bond_tx_hrdrst_us_out_fabric_tx_dcd_cal_done = aib_fabric_tx_dcd_cal_done & tx_hrdrst_fabric_tx_dcd_cal_done_chnl_down;
        assign bond_tx_hrdrst_ds_out_fabric_tx_dcd_cal_done = aib_fabric_tx_dcd_cal_done & tx_hrdrst_fabric_tx_dcd_cal_done_chnl_up;

//********************************************************************
// Tx Reset State Machine Output
//********************************************************************

assign tx_hrdrst_fabric_tx_dcd_cal_req_pre = tx_hrdrst_fabric_tx_dcd_cal_req_comb;

// Generate asynchronous reset during non PCIe rate change.
// Bypass Tx Reset State Machine if Reset State Machine is diabled.
//assign tx_hrdrst_fabric_tx_async_rst_pre = r_tx_hrdrst_rst_sm_dis ? (~sync_rx_asn_rate_change_in_progress & ~sr_hssi_tx_dll_lock) :
//                                                                    (~sync_rx_asn_rate_change_in_progress & tx_hrdrst_fabric_tx_rst_comb);

// Generate synchronous reset to FIFO during PCIe rate change.
// Bypass Tx Reset State Machine if Reset State Machine is diabled.
//assign tx_hrdrst_fabric_tx_fifo_srst_pre = r_tx_hrdrst_rst_sm_dis ? (sync_rx_asn_rate_change_in_progress & ~sr_hssi_tx_dll_lock) :
//                                                                    (sync_rx_asn_rate_change_in_progress & tx_hrdrst_fabric_tx_rst_comb);
//assign tx_hrdrst_fabric_tx_fifo_srst_pre = r_tx_hrdrst_user_ctl_en ? (~sr_hssi_tx_dll_lock) : tx_hrdrst_fabric_tx_rst_comb;
assign tx_hrdrst_fabric_tx_fifo_srst_pre = tx_hrdrst_fabric_tx_rst_comb;

assign tx_hrdrst_fabric_tx_dcd_cal_done_pre = tx_hrdrst_fabric_tx_dcd_cal_done_comb;

// Bypass Tx Reset State Machine if Reset State Machine is diabled.
//assign tx_hrdrst_fabric_tx_transfer_en_pre = r_tx_hrdrst_rst_sm_dis ? sr_hssi_tx_transfer_en : tx_hrdrst_fabric_tx_transfer_en_comb;
//assign tx_hrdrst_fabric_tx_transfer_en_pre = r_tx_hrdrst_user_ctl_en ? sr_hssi_tx_transfer_en : tx_hrdrst_fabric_tx_transfer_en_comb;
assign tx_hrdrst_fabric_tx_transfer_en_pre = tx_hrdrst_fabric_tx_transfer_en_comb;

always @ (negedge tx_reset_hrdrst_rx_osc_clk_rst_n or posedge tx_clock_hrdrst_rx_osc_clk)
begin
	if (~tx_reset_hrdrst_rx_osc_clk_rst_n)
	begin
		tx_hrdrst_fabric_tx_dcd_cal_req <= 1'b0;
		//tx_hrdrst_fabric_tx_async_rst <= 1'b1;
		//tx_hrdrst_fabric_tx_fifo_srst <= 1'b0;
		tx_hrdrst_fabric_tx_fifo_srst <= 1'b1;
		tx_hrdrst_fabric_tx_dcd_cal_done <= 1'b0;
		tx_hrdrst_fabric_tx_transfer_en <= 1'b0;
	end
	else
	begin
		tx_hrdrst_fabric_tx_dcd_cal_req <= tx_hrdrst_fabric_tx_dcd_cal_req_pre; 
		//tx_hrdrst_fabric_tx_async_rst <= tx_hrdrst_fabric_tx_async_rst_pre;
		tx_hrdrst_fabric_tx_fifo_srst <= tx_hrdrst_fabric_tx_fifo_srst_pre;
		tx_hrdrst_fabric_tx_dcd_cal_done <= tx_hrdrst_fabric_tx_dcd_cal_done_pre;
		tx_hrdrst_fabric_tx_transfer_en <= tx_hrdrst_fabric_tx_transfer_en_pre;
      end
  end

//********************************************************************
// Tx Reset State Machine 
//********************************************************************
always @(negedge tx_reset_hrdrst_rx_osc_clk_rst_n or posedge tx_clock_hrdrst_rx_osc_clk) 
begin
	if (~tx_reset_hrdrst_rx_osc_clk_rst_n) 
	begin
		tx_rst_sm_cs <= WAIT_TX_TRANSFER_REQ;
	end
	else if ( ~avmm_hrdrst_fabric_osc_transfer_en  || r_tx_hrdrst_rst_sm_dis || r_tx_hrdrst_user_ctl_en)
	begin
		tx_rst_sm_cs <= WAIT_TX_TRANSFER_REQ;
	end
	else 
	begin
		tx_rst_sm_cs <= tx_rst_sm_ns;
	end
end


always @ (*)
begin
	tx_rst_sm_ns = tx_rst_sm_cs;
	tx_hrdrst_fabric_tx_dcd_cal_req_comb = 1'b0;
	tx_hrdrst_fabric_tx_rst_comb = 1'b1;
	tx_hrdrst_fabric_tx_dcd_cal_done_comb = 1'b0;
	tx_hrdrst_fabric_tx_transfer_en_comb = 1'b0;
    
	case(tx_rst_sm_cs)
	WAIT_TX_TRANSFER_REQ: 
	begin
		if(sr_hssi_tx_dcd_cal_done && sync_rx_asn_dll_lock_en && ~sync_aib_fabric_tx_dcd_cal_done)
		begin
                	tx_rst_sm_ns  = SEND_TX_DCD_CAL_REQ;
		end
        end
        
	SEND_TX_DCD_CAL_REQ:
        begin
		tx_hrdrst_fabric_tx_dcd_cal_req_comb = 1'b1;
		if(sync_aib_fabric_tx_dcd_cal_done || r_tx_hrdrst_dcd_cal_done_bypass)
		begin
			tx_rst_sm_ns = WAIT_REMOTE_TX_DLL_LOCK;
		end
        end
      
	WAIT_REMOTE_TX_DLL_LOCK:
        begin
		tx_hrdrst_fabric_tx_dcd_cal_req_comb = 1'b1;
		tx_hrdrst_fabric_tx_dcd_cal_done_comb = 1'b1;
              	if (sr_hssi_tx_dll_lock)
                begin
                	tx_rst_sm_ns = WAIT_REMOTE_TX_ALIGN_DONE;
            	end
        end

	WAIT_REMOTE_TX_ALIGN_DONE:
        begin
		tx_hrdrst_fabric_tx_dcd_cal_req_comb = 1'b1;
		tx_hrdrst_fabric_tx_rst_comb = 1'b0;
              	if (sr_hssi_tx_transfer_en && sync_tx_fifo_ready)
                begin
                	tx_rst_sm_ns = TX_TRANSFER_EN;
            	end
        end
      	TX_TRANSFER_EN:
        begin
		tx_hrdrst_fabric_tx_dcd_cal_req_comb = 1'b1;
		tx_hrdrst_fabric_tx_rst_comb = 1'b0;
		tx_hrdrst_fabric_tx_transfer_en_comb = 1'b1;
              	if (~sr_hssi_tx_transfer_en || ~sync_rx_asn_dll_lock_en)
                begin
                	tx_rst_sm_ns = WAIT_TX_TRANSFER_REQ;
            	end
        end

	default: 
        begin
		tx_rst_sm_ns = WAIT_TX_TRANSFER_REQ;
		tx_hrdrst_fabric_tx_dcd_cal_req_comb = 1'b0;
		tx_hrdrst_fabric_tx_dcd_cal_done_comb = 1'b0;
		tx_hrdrst_fabric_tx_rst_comb = 1'b1;
		tx_hrdrst_fabric_tx_transfer_en_comb = 1'b0;
        end
      endcase
  end


endmodule // hdpldadapt_txrst_ctl
