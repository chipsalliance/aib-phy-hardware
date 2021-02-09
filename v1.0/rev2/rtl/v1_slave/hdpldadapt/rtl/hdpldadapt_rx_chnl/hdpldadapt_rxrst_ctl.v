// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module hdpldadapt_rxrst_ctl
(
	input	wire		csr_rdy_dly_in,
	input	wire		nfrzdrv_in,
	input	wire		pr_channel_freeze_n,
	input	wire		usermode_in,
	input	wire		pld_pcs_rx_pld_rst_n,
	input	wire		pld_adapter_rx_pld_rst_n,
	input	wire		pld_pma_rxpma_rstb,
	input	wire		rx_fabric_align_done,
	input	wire		pld_aib_fabric_rx_dll_lock_req,
	input	wire		pld_fabric_rx_fifo_srst,
	input   wire            aib_fabric_rx_dll_lock,
        input   wire            bond_rx_hrdrst_ds_in_fabric_rx_dll_lock,
        input   wire            bond_rx_hrdrst_us_in_fabric_rx_dll_lock,
        input   wire            bond_rx_hrdrst_ds_in_fabric_rx_dll_lock_req,
        input   wire            bond_rx_hrdrst_us_in_fabric_rx_dll_lock_req,
	input	wire		avmm_hrdrst_fabric_osc_transfer_en,
	input	wire		sr_hssi_rx_dcd_cal_done,
	input	wire		sr_hssi_rx_transfer_en,
	input	wire		tx_hrdrst_fabric_tx_transfer_en,
	input	wire		rx_asn_rate_change_in_progress,
	input	wire		rx_asn_dll_lock_en,
	input	wire		rx_asn_fifo_hold,
	input	wire		rx_fifo_ready,
	input	wire		rx_clock_reset_hrdrst_rx_osc_clk,
	input	wire		rx_clock_reset_fifo_wr_clk,
	input	wire		rx_clock_reset_fifo_rd_clk,
	input	wire		rx_clock_fifo_sclk,
	input	wire		rx_clock_reset_asn_pma_hclk,
	input	wire		rx_clock_reset_async_rx_osc_clk,
	input	wire		rx_clock_reset_async_tx_osc_clk,
	input	wire		rx_clock_pld_pma_hclk,
	input	wire		rx_clock_hrdrst_rx_osc_clk,		// Static clock gated
	input	wire		r_rx_free_run_div_clk,
	input	wire		r_rx_hrdrst_rst_sm_dis,
	input	wire		r_rx_hrdrst_dll_lock_bypass,
	input	wire		r_rx_hrdrst_align_bypass,
	input	wire		r_rx_hrdrst_user_ctl_en,
	input	wire [1:0]	r_rx_master_sel,
	input	wire		r_rx_dist_master_sel,
	input	wire		r_rx_ds_last_chnl,
	input	wire		r_rx_us_last_chnl,
	input	wire		r_rx_bonding_dft_in_en,
	input	wire		r_rx_bonding_dft_in_value,
	input 	wire            adapter_scan_rst_n,
	input 	wire            adapter_scan_mode_n,
	output	wire		pld_hssi_rx_transfer_en,
	output	wire		pld_aib_fabric_rx_dll_lock,
	output	wire		pld_hssi_asn_dll_lock_en,
	output	wire		aib_fabric_pcs_rx_pld_rst_n,
	output	wire		aib_fabric_adapter_rx_pld_rst_n,
	output	wire		aib_fabric_pld_pma_rxpma_rstb,
	output  wire		aib_fabric_rx_dll_lock_req,
        output  wire            bond_rx_hrdrst_ds_out_fabric_rx_dll_lock,
        output  wire            bond_rx_hrdrst_us_out_fabric_rx_dll_lock,
        output  wire            bond_rx_hrdrst_ds_out_fabric_rx_dll_lock_req,
        output  wire            bond_rx_hrdrst_us_out_fabric_rx_dll_lock_req,
	output	wire		rx_hrdrst_rx_fifo_srst,
	output	reg		rx_hrdrst_fabric_rx_dll_lock,
	output	reg		rx_hrdrst_fabric_rx_transfer_en,
	output	reg		rx_hrdrst_asn_data_transfer_en,
	output  wire [19:0]	rx_hrdrst_testbus,
	output	wire		rx_reset_fifo_wr_rst_n,
	output	wire		rx_reset_fifo_rd_rst_n,
	output	wire		rx_reset_fifo_sclk_rst_n,
	output	wire		rx_reset_pld_pma_hclk_rst_n,
	output	wire		rx_reset_asn_pma_hclk_rst_n,
	output	wire		rx_reset_async_rx_osc_clk_rst_n,
	output	wire		rx_reset_async_tx_osc_clk_rst_n
);

//********************************************************************
// Define Parameters 
//********************************************************************

	localparam  WAIT_RX_TRANSFER_REQ	= 3'b000;
	localparam  SEND_RX_DLL_LOCK_REQ	= 3'b001;
	localparam  WAIT_RX_ALIGN_DONE		= 3'b010;
	localparam  RX_TRANSFER_EN		= 3'b011;
	localparam  RX_TRANSFER_ALIVE		= 3'b100;

//********************************************************************
//********************************************************************

	wire		frz_2one_by_nfrzdrv_or_pr_channel_freeze_n;

	wire		int_pld_pcs_rx_pld_rst_n;
	wire		int_pld_adapter_rx_pld_rst_n;
	wire		int_pld_pma_rxpma_rstb;
	wire		int_pld_aib_fabric_rx_dll_lock_req;

	wire		int_rx_rst_n;
	//wire		int_rx_datapath_rst_n;
	wire		int_rx_hrd_rst_n;
	wire		int_clkdiv_rst_n_bypass;
	wire		int_clkdiv_scan_mode_n;
	wire		rx_reset_hrdrst_rx_osc_clk_rst_n;

	reg [2:0]   	rx_rst_sm_cs;
	reg [2:0]   	rx_rst_sm_ns;

	reg		rx_hrdrst_fabric_rx_dll_lock_req;
	wire		rx_hrdrst_fabric_rx_dll_lock_req_pre;
	reg		rx_hrdrst_fabric_rx_dll_lock_req_comb;

	//reg             rx_hrdrst_fabric_rx_async_rst;
	//wire            rx_hrdrst_fabric_rx_async_rst_pre;
	wire            rx_hrdrst_fabric_rx_fifo_srst_final;
	reg             rx_hrdrst_fabric_rx_fifo_srst;
	wire            rx_hrdrst_fabric_rx_fifo_srst_pre;
	reg             rx_hrdrst_fabric_rx_rst_comb;

	wire		rx_hrdrst_fabric_rx_dll_lock_pre;
	reg		rx_hrdrst_fabric_rx_dll_lock_comb;

	wire		rx_hrdrst_fabric_rx_transfer_en_pre;
	reg		rx_hrdrst_fabric_rx_transfer_en_comb;

	wire		sync_rx_asn_rate_change_in_progress;
	wire		sync_rx_asn_dll_lock_en;
	wire		sync_rx_asn_fifo_hold;
	reg		sync_rx_asn_fifo_hold_reg;
	reg [4:0]       rx_hrdrst_speed_chg_srst_cnt;
        reg             rx_hrdrst_speed_chg_srst;

	wire		aib_fabric_rx_dll_lock_req_int;
	wire		aib_fabric_rx_dll_lock_int;
	wire		sync_aib_fabric_rx_dll_lock;
	wire		sync_rx_align_done;
	wire		sync_rx_fifo_ready;

	wire            bond_rx_hrdrst_ds_in_fabric_rx_dll_lock_int;
	wire            bond_rx_hrdrst_us_in_fabric_rx_dll_lock_int;
	wire            bond_rx_hrdrst_ds_in_fabric_rx_dll_lock_req_int;
	wire		bond_rx_hrdrst_us_in_fabric_rx_dll_lock_req_int;

	wire            rx_hrdrst_fabric_rx_dll_lock_chnl_down;	
	wire            rx_hrdrst_fabric_rx_dll_lock_chnl_up;
	wire		rx_hrdrst_fabric_rx_dll_lock_req_final;
	wire            rx_hrdrst_fabric_rx_dll_lock_req_chnl_down;	
	wire            rx_hrdrst_fabric_rx_dll_lock_req_chnl_up;

//********************************************************************
// Gate with User Mode
//********************************************************************
	assign int_pld_pcs_rx_pld_rst_n = usermode_in & pld_pcs_rx_pld_rst_n;
	assign int_pld_adapter_rx_pld_rst_n = usermode_in & pld_adapter_rx_pld_rst_n;
	assign int_pld_pma_rxpma_rstb = usermode_in & pld_pma_rxpma_rstb;

	assign int_pld_aib_fabric_rx_dll_lock_req = usermode_in & pld_aib_fabric_rx_dll_lock_req;

//********************************************************************
// Feedthrough from PLD to AIB
//********************************************************************

	assign aib_fabric_pcs_rx_pld_rst_n = int_pld_pcs_rx_pld_rst_n;
	assign aib_fabric_adapter_rx_pld_rst_n = int_pld_adapter_rx_pld_rst_n;
	assign aib_fabric_pld_pma_rxpma_rstb = int_pld_pma_rxpma_rstb;

//********************************************************************
// PLD 
//********************************************************************
	assign frz_2one_by_nfrzdrv_or_pr_channel_freeze_n = ~(nfrzdrv_in & pr_channel_freeze_n);

	assign pld_hssi_rx_transfer_en = frz_2one_by_nfrzdrv_or_pr_channel_freeze_n | sr_hssi_rx_transfer_en;
	assign pld_aib_fabric_rx_dll_lock = frz_2one_by_nfrzdrv_or_pr_channel_freeze_n | aib_fabric_rx_dll_lock;
	//assign pld_hssi_asn_dll_lock_en = frz_2one_by_nfrzdrv_or_pr_channel_freeze_n | (r_rx_hrdrst_rst_sm_dis & ~sr_hssi_rx_dcd_cal_done);
	assign pld_hssi_asn_dll_lock_en = frz_2one_by_nfrzdrv_or_pr_channel_freeze_n | (r_rx_hrdrst_user_ctl_en & ~sr_hssi_rx_dcd_cal_done);

	//assign pld_hssi_rx_transfer_en = nfrzdrv_in ? sr_hssi_rx_transfer_en : 1'b1;
	//assign pld_aib_fabric_rx_dll_lock = nfrzdrv_in ? aib_fabric_rx_dll_lock : 1'b1;
	//assign pld_hssi_asn_dll_lock_en = nfrzdrv_in ? (r_rx_hrdrst_rst_sm_dis & ~sr_hssi_rx_dcd_cal_done) : 1'b1; 

//********************************************************************
// Reset Synchronizers
//********************************************************************

	assign int_rx_rst_n = (adapter_scan_mode_n & csr_rdy_dly_in & int_pld_adapter_rx_pld_rst_n) | (~adapter_scan_mode_n & adapter_scan_rst_n); 

cdclib_rst_n_sync cdclib_rst_n_sync_rx_hrdrst_rx_osc_clk
        (
        .rst_n(int_rx_rst_n),
        .rst_n_bypass(adapter_scan_rst_n),
        .clk (rx_clock_reset_hrdrst_rx_osc_clk),
        .scan_mode_n(adapter_scan_mode_n),
        .rst_n_sync(rx_reset_hrdrst_rx_osc_clk_rst_n)
        );

//********************************************************************

        //assign int_rx_datapath_rst_n = (adapter_scan_mode_n & csr_rdy_dly_in & int_pld_adapter_rx_pld_rst_n & ~rx_hrdrst_fabric_rx_async_rst) | (~adapter_scan_mode_n & adapter_scan_rst_n);

cdclib_rst_n_sync cdclib_rst_n_sync_fifo_wr_clk
	(
	//.rst_n(int_rx_datapath_rst_n),
        .rst_n(int_rx_rst_n),
	.rst_n_bypass(adapter_scan_rst_n),
	.clk (rx_clock_reset_fifo_wr_clk),
	.scan_mode_n(adapter_scan_mode_n),
	.rst_n_sync(rx_reset_fifo_wr_rst_n)
	);
	
cdclib_rst_n_sync cdclib_rst_n_sync_fifo_rd_clk
	(
	//.rst_n(int_rx_datapath_rst_n),
        .rst_n(int_rx_rst_n),
	.rst_n_bypass(adapter_scan_rst_n),
	.clk (rx_clock_reset_fifo_rd_clk),
	.scan_mode_n(adapter_scan_mode_n),
	.rst_n_sync(rx_reset_fifo_rd_rst_n)
	);
	
cdclib_rst_n_sync cdclib_rst_n_sync_fifo_sclk
	(
	//.rst_n(int_rx_datapath_rst_n),
	.rst_n(int_rx_rst_n),
	.rst_n_bypass(adapter_scan_rst_n),
	.clk (rx_clock_fifo_sclk),
	.scan_mode_n(adapter_scan_mode_n),
	.rst_n_sync(rx_reset_fifo_sclk_rst_n)
	);
	
cdclib_rst_n_sync cdclib_rst_n_sync_asn_pma_hclk
	(
	//.rst_n(int_rx_datapath_rst_n),
        .rst_n(int_rx_rst_n),
	.rst_n_bypass(adapter_scan_rst_n),
	.clk (rx_clock_reset_asn_pma_hclk),
	.scan_mode_n(adapter_scan_mode_n),
	.rst_n_sync(rx_reset_asn_pma_hclk_rst_n)
	);
	
//********************************************************************

        assign int_rx_hrd_rst_n = (adapter_scan_mode_n & csr_rdy_dly_in) | (~adapter_scan_mode_n & adapter_scan_rst_n);

cdclib_rst_n_sync cdclib_rst_n_sync_rx_osc_clk
        (
        .rst_n(int_rx_hrd_rst_n),
        .rst_n_bypass(adapter_scan_rst_n),
        .clk (rx_clock_reset_async_rx_osc_clk),
        .scan_mode_n(adapter_scan_mode_n),
        .rst_n_sync(rx_reset_async_rx_osc_clk_rst_n)
        );

cdclib_rst_n_sync cdclib_rst_n_sync_tx_osc_clk
        (
        .rst_n(int_rx_hrd_rst_n),
        .rst_n_bypass(adapter_scan_rst_n),
        .clk (rx_clock_reset_async_tx_osc_clk),
        .scan_mode_n(adapter_scan_mode_n),
        .rst_n_sync(rx_reset_async_tx_osc_clk_rst_n)
        );

	assign int_clkdiv_rst_n_bypass = (adapter_scan_mode_n | adapter_scan_rst_n);
	assign int_clkdiv_scan_mode_n = (adapter_scan_mode_n & ~r_rx_free_run_div_clk);

cdclib_rst_n_sync cdclib_rst_n_sync_pld_pma_hclk
	(
	.rst_n(int_rx_hrd_rst_n),
	.rst_n_bypass(int_clkdiv_rst_n_bypass),
	.clk (rx_clock_pld_pma_hclk),
	.scan_mode_n(int_clkdiv_scan_mode_n),
	.rst_n_sync(rx_reset_pld_pma_hclk_rst_n)
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
      .clk      (rx_clock_hrdrst_rx_osc_clk),
      .rst_n    (rx_reset_hrdrst_rx_osc_clk_rst_n),
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
      .clk      (rx_clock_hrdrst_rx_osc_clk),
      .rst_n    (rx_reset_hrdrst_rx_osc_clk_rst_n),
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
      .clk      (rx_clock_hrdrst_rx_osc_clk),
      .rst_n    (rx_reset_hrdrst_rx_osc_clk_rst_n),
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
    ) cdclib_bitsync4_aib_fabric_rx_dll_lock_req
    (
      .clk      (rx_clock_hrdrst_rx_osc_clk),
      .rst_n    (rx_reset_hrdrst_rx_osc_clk_rst_n),
      .data_in  (aib_fabric_rx_dll_lock_req_int),
      .data_out (aib_fabric_rx_dll_lock_req)
    );

cdclib_bitsync4
    #(
        .DWIDTH      (1),       // Sync Data input
        .RESET_VAL   (0),       // Reset value
	.CLK_FREQ_MHZ(1200),
        .TOGGLE_TYPE (2),
        .VID         (1)
    ) cdclib_bitsync4_aib_fabric_rx_dll_lock_int
    (
      .clk      (rx_clock_hrdrst_rx_osc_clk),
      .rst_n    (rx_reset_hrdrst_rx_osc_clk_rst_n),
      .data_in  (aib_fabric_rx_dll_lock_int),
      .data_out (sync_aib_fabric_rx_dll_lock)
    );

cdclib_bitsync4
    #(
        .DWIDTH      (1),       // Sync Data input
        .RESET_VAL   (0),       // Reset value
	.CLK_FREQ_MHZ(1200),
        .TOGGLE_TYPE (2),
        .VID         (1)
    ) cdclib_bitsync4_rx_fabric_align_done
    (
      .clk      (rx_clock_hrdrst_rx_osc_clk),
      .rst_n    (rx_reset_hrdrst_rx_osc_clk_rst_n),
      .data_in  (rx_fabric_align_done),
      .data_out (sync_rx_align_done)
    );

cdclib_bitsync4
    #(
        .DWIDTH      (1),       // Sync Data input
        .RESET_VAL   (0),       // Reset value
	.CLK_FREQ_MHZ(1200),
        .TOGGLE_TYPE (2),
        .VID         (1)
    ) cdclib_bitsync4_rx_fifo_ready
    (
      .clk      (rx_clock_hrdrst_rx_osc_clk),
      .rst_n    (rx_reset_hrdrst_rx_osc_clk_rst_n),
      .data_in  (rx_fifo_ready),
      .data_out (sync_rx_fifo_ready)
    );

//********************************************************************
// Test bus
//********************************************************************
assign rx_hrdrst_testbus[19:0] = {2'b00,rx_hrdrst_asn_data_transfer_en, aib_fabric_rx_dll_lock,aib_fabric_rx_dll_lock_req,
				  rx_hrdrst_fabric_rx_transfer_en,rx_hrdrst_fabric_rx_dll_lock,rx_hrdrst_fabric_rx_fifo_srst,rx_hrdrst_speed_chg_srst,sync_rx_asn_fifo_hold,rx_hrdrst_fabric_rx_dll_lock_req,
				  sr_hssi_rx_transfer_en,sync_rx_align_done,sync_aib_fabric_rx_dll_lock,sr_hssi_rx_dcd_cal_done,sync_rx_asn_dll_lock_en,
				  sync_rx_asn_rate_change_in_progress,rx_rst_sm_cs[2:0]};

//********************************************************************
// To ASN SM when Reset SM is enabled
//********************************************************************
//assign rx_hrdrst_asn_data_transfer_en = tx_hrdrst_fabric_tx_transfer_en & sr_hssi_rx_transfer_en;

always @ (negedge rx_reset_hrdrst_rx_osc_clk_rst_n or posedge rx_clock_hrdrst_rx_osc_clk)
begin
	if (~rx_reset_hrdrst_rx_osc_clk_rst_n)
	begin
		rx_hrdrst_asn_data_transfer_en <= 1'b0;
	end
	else
	begin
		rx_hrdrst_asn_data_transfer_en <= tx_hrdrst_fabric_tx_transfer_en & sr_hssi_rx_transfer_en;
      end
  end

always @ (negedge rx_reset_hrdrst_rx_osc_clk_rst_n or posedge rx_clock_hrdrst_rx_osc_clk)
begin
        if (~rx_reset_hrdrst_rx_osc_clk_rst_n)
        begin
                sync_rx_asn_fifo_hold_reg <= 1'b0;
                rx_hrdrst_speed_chg_srst <= 1'b0;
        end
        else
        begin
                sync_rx_asn_fifo_hold_reg <= sync_rx_asn_fifo_hold;
                rx_hrdrst_speed_chg_srst <= (sync_rx_asn_fifo_hold && ~sync_rx_asn_fifo_hold_reg) || (rx_hrdrst_speed_chg_srst && (rx_hrdrst_speed_chg_srst_cnt[4:0] != 5'b11111));
      end
  end


// The rx_hrdrst_speed_chg_srst pulse must be long enough to be sampled by FIFO clock domain during PIPE mode, i.e. slowest is 125MHz.
always @ (negedge rx_reset_hrdrst_rx_osc_clk_rst_n or posedge rx_clock_hrdrst_rx_osc_clk)
begin
        if (~rx_reset_hrdrst_rx_osc_clk_rst_n)
        begin
                rx_hrdrst_speed_chg_srst_cnt[4:0] <= 5'b00000;
        end
        else
        begin
                if (rx_hrdrst_speed_chg_srst)
                begin
                        rx_hrdrst_speed_chg_srst_cnt[4:0] <= rx_hrdrst_speed_chg_srst_cnt[4:0] + 5'b00001;
                end
                else
                begin
                        rx_hrdrst_speed_chg_srst_cnt[4:0] <= 5'b00000;
                end
      end
  end

//********************************************************************
// FIFO Reset
//********************************************************************
assign rx_hrdrst_rx_fifo_srst = r_rx_hrdrst_user_ctl_en ? pld_fabric_rx_fifo_srst : rx_hrdrst_fabric_rx_fifo_srst_final;
// FIFO Reset when Reset SM is enabled
// From master Reset SM when current channel is master channel
// From master ASN SM when current channel is slave channel
assign rx_hrdrst_fabric_rx_fifo_srst_final = (r_rx_master_sel == 2'b00) ? rx_hrdrst_fabric_rx_fifo_srst : rx_hrdrst_speed_chg_srst;

//********************************************************************
// Rx Reset State Machine Bonding Input Output
//********************************************************************
assign bond_rx_hrdrst_ds_in_fabric_rx_dll_lock_int = r_rx_bonding_dft_in_en ? r_rx_bonding_dft_in_value : bond_rx_hrdrst_ds_in_fabric_rx_dll_lock;
assign bond_rx_hrdrst_us_in_fabric_rx_dll_lock_int = r_rx_bonding_dft_in_en ? r_rx_bonding_dft_in_value : bond_rx_hrdrst_us_in_fabric_rx_dll_lock;
assign bond_rx_hrdrst_ds_in_fabric_rx_dll_lock_req_int = r_rx_bonding_dft_in_en ? r_rx_bonding_dft_in_value : bond_rx_hrdrst_ds_in_fabric_rx_dll_lock_req;
assign bond_rx_hrdrst_us_in_fabric_rx_dll_lock_req_int = r_rx_bonding_dft_in_en ? r_rx_bonding_dft_in_value : bond_rx_hrdrst_us_in_fabric_rx_dll_lock_req;

hdpldadapt_cmn_cp_dist_pair
    #(
        .ASYNC_RESET_VAL(0),
        .WIDTH(1)               // Control width
    ) hdpldadapt_cmn_cp_dist_pair_fabric_rx_dll_lock_req
    (
        .clk(1'b0),                                             // clock
        .rst_n(1'b1),                                           // async reset
        .srst_n(1'b1),                                          // sync reset
        .data_enable(1'b1),                                     // data enable / data valid
        .master_in(rx_hrdrst_fabric_rx_dll_lock_req),                       // master control signal
        .us_in(bond_rx_hrdrst_us_in_fabric_rx_dll_lock_req_int),                // CP distributed signal in up
        .ds_in(bond_rx_hrdrst_ds_in_fabric_rx_dll_lock_req_int),                // CP distributed signal in dwn
        .r_us_master(r_rx_dist_master_sel),                 // CRAM to control master or distributed up
        .r_ds_master(r_rx_dist_master_sel),                 // CRAM to control master or distributed dwn
        .r_us_bypass_pipeln(1'b1),                              // CRAM combo or registered up
        .r_ds_bypass_pipeln(1'b1),                              // CRAM combo or registered dwn
        .us_out(bond_rx_hrdrst_us_out_fabric_rx_dll_lock_req),                  // CP distributed signal out up
        .ds_out(bond_rx_hrdrst_ds_out_fabric_rx_dll_lock_req),                  // CP distributed signal out dwn
        .ds_tap(rx_hrdrst_fabric_rx_dll_lock_req_chnl_down),    // CP output for this channel dwn
        .us_tap(rx_hrdrst_fabric_rx_dll_lock_req_chnl_up)       // CP output for this channel up
    );

	//assign aib_fabric_rx_dll_lock_req = r_rx_hrdrst_rst_sm_dis ? int_pld_aib_fabric_rx_dll_lock_req : rx_hrdrst_fabric_rx_dll_lock_req_final;
	assign aib_fabric_rx_dll_lock_req_int = r_rx_hrdrst_user_ctl_en ? int_pld_aib_fabric_rx_dll_lock_req : rx_hrdrst_fabric_rx_dll_lock_req_final;
	assign rx_hrdrst_fabric_rx_dll_lock_req_final = (r_rx_master_sel == 2'b00) ? rx_hrdrst_fabric_rx_dll_lock_req		:
							(r_rx_master_sel == 2'b01) ? rx_hrdrst_fabric_rx_dll_lock_req_chnl_up	:
							(r_rx_master_sel == 2'b10) ? rx_hrdrst_fabric_rx_dll_lock_req_chnl_down	:
										     rx_hrdrst_fabric_rx_dll_lock_req		;

	assign rx_hrdrst_fabric_rx_dll_lock_chnl_down = r_rx_ds_last_chnl ? 1'b1 : bond_rx_hrdrst_ds_in_fabric_rx_dll_lock_int;
	assign rx_hrdrst_fabric_rx_dll_lock_chnl_up = r_rx_us_last_chnl ? 1'b1 : bond_rx_hrdrst_us_in_fabric_rx_dll_lock_int;
	assign aib_fabric_rx_dll_lock_int = (aib_fabric_rx_dll_lock & rx_hrdrst_fabric_rx_dll_lock_chnl_up & rx_hrdrst_fabric_rx_dll_lock_chnl_down);
	assign bond_rx_hrdrst_us_out_fabric_rx_dll_lock = aib_fabric_rx_dll_lock & rx_hrdrst_fabric_rx_dll_lock_chnl_down;
	assign bond_rx_hrdrst_ds_out_fabric_rx_dll_lock = aib_fabric_rx_dll_lock & rx_hrdrst_fabric_rx_dll_lock_chnl_up;

//********************************************************************
// Rx Reset State Machine Output
//********************************************************************

assign rx_hrdrst_fabric_rx_dll_lock_req_pre = rx_hrdrst_fabric_rx_dll_lock_req_comb;

// Generate asynchronous reset during non PCIe rate change.
// Bypass Rx Reset State Machine if Reset State Machine is diabled.
//assign rx_hrdrst_fabric_rx_async_rst_pre = r_rx_hrdrst_rst_sm_dis ? (~sync_rx_asn_rate_change_in_progress & ~sync_aib_fabric_rx_dll_lock && ~r_rx_hrdrst_dll_lock_bypass) :
//								    (~sync_rx_asn_rate_change_in_progress & rx_hrdrst_fabric_rx_rst_comb);
// Generate synchronous reset to FIFO during PCIe rate change.
// Bypass Rx Reset State Machine if Reset State Machine is diabled.
//assign rx_hrdrst_fabric_rx_fifo_srst_pre = r_rx_hrdrst_rst_sm_dis ? (sync_rx_asn_rate_change_in_progress & ~sync_aib_fabric_rx_dll_lock && ~r_rx_hrdrst_dll_lock_bypass) :
//								    (sync_rx_asn_rate_change_in_progress & rx_hrdrst_fabric_rx_rst_comb);
//assign rx_hrdrst_fabric_rx_fifo_srst_pre = r_rx_hrdrst_user_ctl_en ? (~sync_aib_fabric_rx_dll_lock && ~r_rx_hrdrst_dll_lock_bypass) : rx_hrdrst_fabric_rx_rst_comb;
assign rx_hrdrst_fabric_rx_fifo_srst_pre = rx_hrdrst_fabric_rx_rst_comb;

// Bypass Rx Reset State Machine if Reset State Machine is diabled.
//assign rx_hrdrst_fabric_rx_dll_lock_pre = r_rx_hrdrst_rst_sm_dis ? (sync_aib_fabric_rx_dll_lock || r_rx_hrdrst_dll_lock_bypass) : rx_hrdrst_fabric_rx_dll_lock_comb;
//assign rx_hrdrst_fabric_rx_dll_lock_pre = r_rx_hrdrst_user_ctl_en ? (sync_aib_fabric_rx_dll_lock || r_rx_hrdrst_dll_lock_bypass) : rx_hrdrst_fabric_rx_dll_lock_comb;
assign rx_hrdrst_fabric_rx_dll_lock_pre = rx_hrdrst_fabric_rx_dll_lock_comb;

// Bypass Rx Reset State Machine if Reset State Machine is diabled.
//assign rx_hrdrst_fabric_rx_transfer_en_pre = r_rx_hrdrst_rst_sm_dis ? ((sync_aib_fabric_rx_dll_lock || r_rx_hrdrst_dll_lock_bypass) && (sync_rx_align_done || r_rx_hrdrst_align_bypass)) : rx_hrdrst_fabric_rx_transfer_en_comb;
//assign rx_hrdrst_fabric_rx_transfer_en_pre = r_rx_hrdrst_user_ctl_en ? ((sync_aib_fabric_rx_dll_lock || r_rx_hrdrst_dll_lock_bypass) && (sync_rx_align_done || r_rx_hrdrst_align_bypass)) : rx_hrdrst_fabric_rx_transfer_en_comb;
assign rx_hrdrst_fabric_rx_transfer_en_pre = rx_hrdrst_fabric_rx_transfer_en_comb;



always @ (negedge rx_reset_hrdrst_rx_osc_clk_rst_n or posedge rx_clock_hrdrst_rx_osc_clk)
begin
	if (~rx_reset_hrdrst_rx_osc_clk_rst_n)
	begin
		rx_hrdrst_fabric_rx_dll_lock_req <= 1'b0;
		//rx_hrdrst_fabric_rx_async_rst <= 1'b1;
		//rx_hrdrst_fabric_rx_fifo_srst <= 1'b0;
		rx_hrdrst_fabric_rx_fifo_srst <= 1'b1;
		rx_hrdrst_fabric_rx_dll_lock <= 1'b0;
		rx_hrdrst_fabric_rx_transfer_en <= 1'b0;
	end
	else
	begin
		rx_hrdrst_fabric_rx_dll_lock_req <= rx_hrdrst_fabric_rx_dll_lock_req_pre; 
		//rx_hrdrst_fabric_rx_async_rst <= rx_hrdrst_fabric_rx_async_rst_pre;
		rx_hrdrst_fabric_rx_fifo_srst <= rx_hrdrst_fabric_rx_fifo_srst_pre; 
		rx_hrdrst_fabric_rx_dll_lock <= rx_hrdrst_fabric_rx_dll_lock_pre; 
		rx_hrdrst_fabric_rx_transfer_en <= rx_hrdrst_fabric_rx_transfer_en_pre;
      end
  end

//********************************************************************
// Rx Reset State Machine 
//********************************************************************
always @(negedge rx_reset_hrdrst_rx_osc_clk_rst_n or posedge rx_clock_hrdrst_rx_osc_clk) 
begin
	if (~rx_reset_hrdrst_rx_osc_clk_rst_n) 
	begin
		rx_rst_sm_cs <= WAIT_RX_TRANSFER_REQ;
	end
	else if (~avmm_hrdrst_fabric_osc_transfer_en  || r_rx_hrdrst_rst_sm_dis || r_rx_hrdrst_user_ctl_en)
	begin
		rx_rst_sm_cs <= WAIT_RX_TRANSFER_REQ;
	end
	else 
	begin
		rx_rst_sm_cs <= rx_rst_sm_ns;
	end
end


always @ (*)
begin
	rx_rst_sm_ns = rx_rst_sm_cs;
	rx_hrdrst_fabric_rx_dll_lock_req_comb = 1'b0;
	rx_hrdrst_fabric_rx_dll_lock_comb = 1'b0;
	rx_hrdrst_fabric_rx_rst_comb = 1'b1;
	rx_hrdrst_fabric_rx_transfer_en_comb = 1'b0;
    
	case(rx_rst_sm_cs)
	WAIT_RX_TRANSFER_REQ: 
	begin
		if(sr_hssi_rx_dcd_cal_done && sync_rx_asn_dll_lock_en && ~sync_aib_fabric_rx_dll_lock)
		begin
                	rx_rst_sm_ns  = SEND_RX_DLL_LOCK_REQ;
		end
        end
        
	SEND_RX_DLL_LOCK_REQ:
        begin
		rx_hrdrst_fabric_rx_dll_lock_req_comb = 1'b1;
		if(sync_aib_fabric_rx_dll_lock || r_rx_hrdrst_dll_lock_bypass)
		begin
			rx_rst_sm_ns = WAIT_RX_ALIGN_DONE;
		end
        end
      
	WAIT_RX_ALIGN_DONE:
        begin
		rx_hrdrst_fabric_rx_dll_lock_req_comb = 1'b1;
		rx_hrdrst_fabric_rx_dll_lock_comb = 1'b1;
		rx_hrdrst_fabric_rx_rst_comb = 1'b0;
              	if ((sync_rx_align_done || r_rx_hrdrst_align_bypass) && sync_rx_fifo_ready)
                begin
                	rx_rst_sm_ns = RX_TRANSFER_EN;
            	end
        end

      	RX_TRANSFER_EN:
        begin
		rx_hrdrst_fabric_rx_dll_lock_req_comb = 1'b1;
		rx_hrdrst_fabric_rx_dll_lock_comb = 1'b1;
		rx_hrdrst_fabric_rx_rst_comb = 1'b0;
		rx_hrdrst_fabric_rx_transfer_en_comb = 1'b1;
              	if (sr_hssi_rx_transfer_en)
                begin
                	rx_rst_sm_ns = RX_TRANSFER_ALIVE;
            	end
        end

      	RX_TRANSFER_ALIVE:
        begin
		rx_hrdrst_fabric_rx_dll_lock_req_comb = 1'b1;
		rx_hrdrst_fabric_rx_dll_lock_comb = 1'b1;
		rx_hrdrst_fabric_rx_rst_comb = 1'b0;
		rx_hrdrst_fabric_rx_transfer_en_comb = 1'b1;
              	if (~sr_hssi_rx_transfer_en || ~sync_rx_asn_dll_lock_en)
                begin
                	rx_rst_sm_ns = WAIT_RX_TRANSFER_REQ;
            	end
        end

	default: 
        begin
		rx_rst_sm_ns = WAIT_RX_TRANSFER_REQ;
		rx_hrdrst_fabric_rx_dll_lock_req_comb = 1'b0;
		rx_hrdrst_fabric_rx_dll_lock_comb = 1'b0;
		rx_hrdrst_fabric_rx_rst_comb = 1'b1;
		rx_hrdrst_fabric_rx_transfer_en_comb = 1'b0;
        end
      endcase
  end


endmodule // hdpldadapt_rxrst_ctl
