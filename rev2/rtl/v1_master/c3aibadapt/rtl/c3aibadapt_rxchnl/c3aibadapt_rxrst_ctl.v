// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3aibadapt_rxrst_ctl
(
  input	 wire		csr_rdy_dly_in,
  input	 wire		hip_aib_txeq_rst_n,
  input	 wire		aib_hssi_pcs_rx_pld_rst_n,
  input	 wire		aib_hssi_adapter_rx_pld_rst_n,
  input	 wire		aib_hssi_pld_pma_rxpma_rstb,
  input	 wire		aib_hssi_rx_dcd_cal_done,
  input	 wire		avmm_hrdrst_hssi_osc_transfer_alive,
  input	 wire		sr_pld_hssi_rx_fifo_srst,
  input	 wire		sr_pld_rx_dll_lock_req,
  input	 wire		sr_fabric_rx_dll_lock,
  input	 wire		sr_fabric_rx_transfer_en,
  input	 wire		sr_fabric_tx_transfer_en,
  input	 wire		rx_asn_rate_change_in_progress,
  input	 wire		rx_asn_dll_lock_en,
  input	 wire		rx_asn_fifo_hold,			// For slave FIFO reset during rate change
  input	 wire		rx_fifo_ready,
  input  wire           rx_ehip_clk,
  input  wire           rx_rsfec_clk,
  input  wire           rx_elane_clk,
  input  wire           rx_pma_clk,
  input	 wire		sr_aib_hssi_rx_dcd_cal_req,
  input	 wire		rx_clock_reset_hrdrst_rx_osc_clk,
  input	 wire		rx_clock_reset_fifo_wr_clk,
  input	 wire		rx_clock_reset_fifo_rd_clk,
  input	 wire		rx_clock_fifo_sclk,
  input	 wire		rx_clock_reset_txeq_clk,
  input	 wire		rx_clock_reset_asn_pma_hclk,
  input	 wire		rx_clock_reset_async_rx_osc_clk,
  input	 wire		rx_clock_reset_async_tx_osc_clk,
  input	 wire		rx_clock_pld_pma_hclk,
  // input	 wire		rx_clock_pma_aib_tx_clk,
  // input	 wire		rx_clock_pma_aib_tx_clkdiv2,
  input	 wire		rx_clock_hrdrst_rx_osc_clk,		// Static clock gated
  input	 wire		r_rx_free_run_div_clk,
  input	 wire		r_rx_txeq_rst_sel,
  input	 wire		r_rx_hrdrst_rst_sm_dis,			// When current channel is slave channel
  input	 wire		r_rx_hrdrst_dcd_cal_done_bypass,
  input	 wire		r_rx_hrdrst_user_ctl_en,
  input  wire [1:0]     r_rx_master_sel,
  input  wire           r_rx_dist_master_sel,
  input  wire           r_rx_ds_last_chnl,
  input  wire           r_rx_us_last_chnl,
  input  wire           r_rx_bonding_dft_in_en,
  input  wire           r_rx_bonding_dft_in_value,
  input	 wire		dft_adpt_rst,
  input	 wire           adapter_scan_rst_n,
  input	 wire           adapter_scan_mode_n,
  output wire           rx_ehip_rst_n,
  output wire           rx_elane_rst_n,
  output wire           rx_rsfec_rst_n,
  output wire           rx_pma_rst_n,
  output wire		pld_10g_krfec_rx_pld_rst_n,
  output wire		pld_pma_rxpma_rstb,
  output wire		aib_hssi_rx_dcd_cal_req,
  output wire		rx_hrdrst_rx_fifo_srst,
  output reg		rx_hrdrst_hssi_rx_dcd_cal_done,
  output reg		rx_hrdrst_hssi_rx_transfer_en,
  output reg		rx_hrdrst_asn_data_transfer_en,
  output wire [2:0]	hip_init_status,
  output wire [19:0]	rx_hrdrst_testbus,
  output wire [3:0]     rx_hrdrst_tb_direct,
  output wire		rx_reset_fifo_wr_rst_n,
  output wire		rx_reset_fifo_rd_rst_n,
  output wire		rx_reset_fifo_sclk_rst_n,
  // output wire		rx_reset_pld_pma_hclk_rst_n,
  output wire		rx_reset_asn_pma_hclk_rst_n,
  // output wire		rx_reset_pma_aib_tx_clk_rst_n,
  // output wire		rx_reset_pma_aib_tx_clkdiv2_rst_n,
  output wire		rx_reset_async_rx_osc_clk_rst_n,
  output wire		rx_reset_async_tx_osc_clk_rst_n,
  output wire		rx_reset_txeq_clk_rst_n
);

//********************************************************************
// Define Parameters 
//********************************************************************

localparam  WAIT_RX_TRANSFER_REQ	= 3'b000;
localparam  SEND_RX_DCD_CAL_REQ		= 3'b001;
localparam  WAIT_REMOTE_RX_DLL_LOCK	= 3'b010;
localparam  WAIT_REMOTE_RX_ALIGN_DONE	= 3'b011;
localparam  RX_TRANSFER_EN		= 3'b100;

//********************************************************************
//********************************************************************
  wire           bond_rx_hrdrst_ds_in_hssi_rx_dcd_cal_done = 1'b0;
  wire           bond_rx_hrdrst_us_in_hssi_rx_dcd_cal_done = 1'b0;
  wire           bond_rx_hrdrst_ds_in_hssi_rx_dcd_cal_req  = 1'b0;
  wire           bond_rx_hrdrst_us_in_hssi_rx_dcd_cal_req  = 1'b0;

  // wire           bond_rx_hrdrst_ds_out_hssi_rx_dcd_cal_done;
  // wire           bond_rx_hrdrst_us_out_hssi_rx_dcd_cal_done;
  // wire           bond_rx_hrdrst_ds_out_hssi_rx_dcd_cal_req;
  // wire           bond_rx_hrdrst_us_out_hssi_rx_dcd_cal_req;

  wire          int_rx_rst_n;
  wire          int_rx_hrd_rst_n;
  wire		rx_reset_hrdrst_rx_osc_clk_rst_n;
  
  reg [2:0]     rx_rst_sm_cs;
  reg [2:0]     rx_rst_sm_ns;
  reg [2:0]     rx_rst_sm_cs_reg;
  reg		rx_rst_sm_cs_chg;
  
  wire		sync_rx_asn_rate_change_in_progress;
  wire		sync_rx_asn_dll_lock_en;
  wire		sync_rx_asn_fifo_hold;
  reg		sync_rx_asn_fifo_hold_reg;
  reg [4:0]	rx_hrdrst_speed_chg_srst_cnt;
  reg		rx_hrdrst_speed_chg_srst;
  
  wire		aib_hssi_rx_dcd_cal_req_int;
  wire		aib_hssi_rx_dcd_cal_done_int;
  wire		sync_aib_hssi_rx_dcd_cal_done;
  wire		sync_rx_fifo_ready;
  
  reg		rx_hrdrst_hssi_rx_dcd_cal_req;
  wire		rx_hrdrst_hssi_rx_dcd_cal_req_pre;
  reg		rx_hrdrst_hssi_rx_dcd_cal_req_comb; 
  
  //reg		rx_hrdrst_hssi_rx_async_rst;
  //wire		rx_hrdrst_hssi_rx_async_rst_pre;
  wire		rx_hrdrst_hssi_rx_fifo_srst_final;
  reg		rx_hrdrst_hssi_rx_fifo_srst;
  wire		rx_hrdrst_hssi_rx_fifo_srst_pre;
  reg		rx_hrdrst_hssi_rx_rst_comb;
  
  wire		rx_hrdrst_hssi_rx_dcd_cal_done_or_asn_dll_lock_pre;
  reg		rx_hrdrst_hssi_rx_dcd_cal_done_comb;
  
  wire		rx_hrdrst_hssi_rx_transfer_en_pre;
  reg		rx_hrdrst_hssi_rx_transfer_en_comb;
  
  wire          bond_rx_hrdrst_ds_in_hssi_rx_dcd_cal_done_int;
  wire          bond_rx_hrdrst_us_in_hssi_rx_dcd_cal_done_int;
  wire          bond_rx_hrdrst_ds_in_hssi_rx_dcd_cal_req_int;
  wire          bond_rx_hrdrst_us_in_hssi_rx_dcd_cal_req_int;
  
  wire          rx_hrdrst_hssi_rx_dcd_cal_done_chnl_down;
  wire          rx_hrdrst_hssi_rx_dcd_cal_done_chnl_up;
  wire		rx_hrdrst_hssi_rx_dcd_cal_req_final;
  // wire	rx_hrdrst_hssi_rx_dcd_cal_req_this_chnl;
  // wire       rx_hrdrst_hssi_rx_dcd_cal_req_chnl_down;
  // wire       rx_hrdrst_hssi_rx_dcd_cal_req_chnl_up;

//********************************************************************
// Feedthrough from AIB to PCS
//********************************************************************
assign pld_10g_krfec_rx_pld_rst_n = dft_adpt_rst | aib_hssi_pcs_rx_pld_rst_n;
assign pld_pma_rxpma_rstb         = dft_adpt_rst | aib_hssi_pld_pma_rxpma_rstb;

//********************************************************************
// HIP Status
//********************************************************************
assign hip_init_status[2] = avmm_hrdrst_hssi_osc_transfer_alive;
assign hip_init_status[1] = rx_hrdrst_hssi_rx_transfer_en;
assign hip_init_status[0] = sr_fabric_tx_transfer_en;

//********************************************************************
// Reset Synchronizers
//********************************************************************

assign int_rx_rst_n = (adapter_scan_mode_n & ~dft_adpt_rst & csr_rdy_dly_in & aib_hssi_adapter_rx_pld_rst_n) | (~adapter_scan_mode_n & adapter_scan_rst_n);

c3lib_rstsync #(.RESET_VAL (0), .DST_CLK_FREQ_MHZ (1000))
  rstsync_rx_hrdrst_pma_clk (
    .rst_n         (int_rx_rst_n),
    .rst_n_bypass  (adapter_scan_rst_n),
    .clk           (rx_pma_clk),
    .scan_mode_n   (adapter_scan_mode_n),
    .rst_n_sync    (rx_pma_rst_n)
    );


c3lib_rstsync #(.RESET_VAL (0), .DST_CLK_FREQ_MHZ (500))
  rstsync_rx_hrdrst_rsfec_clk (
    .rst_n         (int_rx_rst_n),
    .rst_n_bypass  (adapter_scan_rst_n),
    .clk           (rx_rsfec_clk),
    .scan_mode_n   (adapter_scan_mode_n),
    .rst_n_sync    (rx_rsfec_rst_n)
    );

c3lib_rstsync #(.RESET_VAL (0), .DST_CLK_FREQ_MHZ (500))
  rstsync_rx_hrdrst_elane_clk (
    .rst_n         (int_rx_rst_n),
    .rst_n_bypass  (adapter_scan_rst_n),
    .clk           (rx_elane_clk),
    .scan_mode_n   (adapter_scan_mode_n),
    .rst_n_sync    (rx_elane_rst_n)
    );

c3lib_rstsync #(.RESET_VAL (0), .DST_CLK_FREQ_MHZ (500))
  rstsync_rx_hrdrst_ehip_clk (
    .rst_n         (int_rx_rst_n),
    .rst_n_bypass  (adapter_scan_rst_n),
    .clk           (rx_ehip_clk),
    .scan_mode_n   (adapter_scan_mode_n),
    .rst_n_sync    (rx_ehip_rst_n)
    );

// hd_dpcmn_rst_n_sync hd_dpcmn_rst_n_sync_rx_hrdrst_rx_osc_clk
c3lib_rstsync #(.RESET_VAL (0), .DST_CLK_FREQ_MHZ (1000))
  rstsync_rx_hrdrst_rx_osc_clk (
    .rst_n(int_rx_rst_n),
    .rst_n_bypass(adapter_scan_rst_n),
    .clk (rx_clock_reset_hrdrst_rx_osc_clk),
    .scan_mode_n(adapter_scan_mode_n),
    .rst_n_sync(rx_reset_hrdrst_rx_osc_clk_rst_n)
    );

//********************************************************************

// hd_dpcmn_rst_n_sync hd_dpcmn_rst_n_sync_fifo_wr_clk
c3lib_rstsync #(.RESET_VAL (0), .DST_CLK_FREQ_MHZ (500))
  rstsync_fifo_wr_clk (
    .rst_n(int_rx_rst_n),
    .rst_n_bypass(adapter_scan_rst_n),
    .clk (rx_clock_reset_fifo_wr_clk),
    .scan_mode_n(adapter_scan_mode_n),
    .rst_n_sync(rx_reset_fifo_wr_rst_n)
    );

// hd_dpcmn_rst_n_sync hd_dpcmn_rst_n_sync_fifo_rd_clk
c3lib_rstsync #(.RESET_VAL (0), .DST_CLK_FREQ_MHZ (500))
  rstsync_fifo_rd_clk (
    .rst_n(int_rx_rst_n),
    .rst_n_bypass(adapter_scan_rst_n),
    .clk (rx_clock_reset_fifo_rd_clk),
    .scan_mode_n(adapter_scan_mode_n),
    .rst_n_sync(rx_reset_fifo_rd_rst_n)
    );

// hd_dpcmn_rst_n_sync hd_dpcmn_rst_n_sync_fifo_sclk
c3lib_rstsync #(.RESET_VAL (0), .DST_CLK_FREQ_MHZ (500))
  rstsync_fifo_sclk (
    .rst_n(int_rx_rst_n),
    .rst_n_bypass(adapter_scan_rst_n),
    .clk (rx_clock_fifo_sclk),
    .scan_mode_n(adapter_scan_mode_n),
    .rst_n_sync(rx_reset_fifo_sclk_rst_n)
    );

// hd_dpcmn_rst_n_sync hd_dpcmn_rst_n_sync_asn_pma_hclk
//         (
//         //.rst_n(int_rx_datapath_rst_n),
// 	.rst_n(int_rx_rst_n),
//         .rst_n_bypass(adapter_scan_rst_n),
//         .clk (rx_clock_reset_asn_pma_hclk),
//         .scan_mode_n(adapter_scan_mode_n),
//         .rst_n_sync(rx_reset_asn_pma_hclk_rst_n)
//         );

assign rx_reset_asn_pma_hclk_rst_n = 1'b0;

// hd_dpcmn_rst_n_sync hd_dpcmn_rst_n_sync_pma_aib_tx_clkdiv2
// c3lib_rstsync #(.RESET_VAL (0), .DST_CLK_FREQ_MHZ (500))
//   rstsync_pma_aib_tx_clkdiv2 (
//     .rst_n(int_rx_rst_n),
//     .rst_n_bypass(adapter_scan_rst_n),
//     .clk (rx_clock_pma_aib_tx_clkdiv2),
//     .scan_mode_n(adapter_scan_mode_n),
//     .rst_n_sync(rx_reset_pma_aib_tx_clkdiv2_rst_n)
//     );

//********************************************************************

assign int_rx_hrd_rst_n = (adapter_scan_mode_n & ~dft_adpt_rst & csr_rdy_dly_in) | (~adapter_scan_mode_n & adapter_scan_rst_n);

// hd_dpcmn_rst_n_sync hd_dpcmn_rst_n_sync_rx_osc_clk
c3lib_rstsync #(.RESET_VAL (0), .DST_CLK_FREQ_MHZ (1000))
  rstsync_rx_osc_clk (
    .rst_n(int_rx_hrd_rst_n),
    .rst_n_bypass(adapter_scan_rst_n),
    .clk (rx_clock_reset_async_rx_osc_clk),
    .scan_mode_n(adapter_scan_mode_n),
    .rst_n_sync(rx_reset_async_rx_osc_clk_rst_n)
    );

// hd_dpcmn_rst_n_sync hd_dpcmn_rst_n_sync_tx_osc_clk
c3lib_rstsync #(.RESET_VAL (0), .DST_CLK_FREQ_MHZ (1000))
  rstsync_tx_osc_clk (
    .rst_n(int_rx_hrd_rst_n),
    .rst_n_bypass(adapter_scan_rst_n),
    .clk (rx_clock_reset_async_tx_osc_clk),
    .scan_mode_n(adapter_scan_mode_n),
    .rst_n_sync(rx_reset_async_tx_osc_clk_rst_n)
    );

//********************************************************************

// TXEQ Not supported
// hd_dpcmn_rst_n_sync hd_dpcmn_rst_n_sync_txeq_clk
// 	(
// 	.rst_n(int_rx_txeq_rst_n),
// 	.rst_n_bypass(adapter_scan_rst_n),
// 	.clk (rx_clock_reset_txeq_clk),
// 	.scan_mode_n(adapter_scan_mode_n),
// 	.rst_n_sync(rx_reset_txeq_clk_rst_n)
// 	);
// 
assign rx_reset_txeq_clk_rst_n = 1'b0;

//********************************************************************
// Double Synchronizers
//********************************************************************

// hd_dpcmn_bitsync3
//     #(
//         .DWIDTH      (1),       // Sync Data input
//         .RESET_VAL   (0)        // Reset value
//     ) hd_dpcmn_bitsync3_rx_asn_rate_change_in_progress
//     (
//       .clk      (rx_clock_hrdrst_rx_osc_clk),
//       .rst_n    (rx_reset_hrdrst_rx_osc_clk_rst_n),
//       .data_in  (rx_asn_rate_change_in_progress),
//       .data_out (sync_rx_asn_rate_change_in_progress)
//     );
assign sync_rx_asn_rate_change_in_progress = 1'b0;

// hd_dpcmn_bitsync3
//     #(
//         .DWIDTH      (1),       // Sync Data input
//         .RESET_VAL   (1)        // Reset value
//     ) hd_dpcmn_bitsync3_rx_asn_dll_lock_en
//     (
//       .clk      (rx_clock_hrdrst_rx_osc_clk),
//       .rst_n    (rx_reset_hrdrst_rx_osc_clk_rst_n),
//       .data_in  (rx_asn_dll_lock_en),
//       .data_out (sync_rx_asn_dll_lock_en)
//     );

assign sync_rx_asn_dll_lock_en = 1'b0;

// hd_dpcmn_bitsync3
//     #(
//         .DWIDTH      (1),       // Sync Data input
//         .RESET_VAL   (0)        // Reset value
//     ) hd_dpcmn_bitsync3_rx_asn_fifo_hold
//     (
//       .clk      (rx_clock_hrdrst_rx_osc_clk),
//       .rst_n    (rx_reset_hrdrst_rx_osc_clk_rst_n),
//       .data_in  (rx_asn_fifo_hold),
//       .data_out (sync_rx_asn_fifo_hold)
//     );

assign sync_rx_asn_fifo_hold = 1'b0;

// hd_dpcmn_bitsync3
//     #(
//         .DWIDTH      (1),       // Sync Data input
//         .RESET_VAL   (0)        // Reset value
//     ) hd_dpcmn_bitsync3_aib_hssi_rx_dcd_cal_req
c3lib_bitsync #( .DWIDTH (1), .RESET_VAL (0), .DST_CLK_FREQ_MHZ (1000), .SRC_DATA_FREQ_MHZ (100))
  bitsync_aib_hssi_rx_dcd_cal_req
    (
      .clk      (rx_clock_hrdrst_rx_osc_clk),
      .rst_n    (rx_reset_hrdrst_rx_osc_clk_rst_n),
      .data_in  (aib_hssi_rx_dcd_cal_req_int),
      .data_out (aib_hssi_rx_dcd_cal_req)
    );

// hd_dpcmn_bitsync3
//     #(
//         .DWIDTH      (1),       // Sync Data input
//         .RESET_VAL   (0)        // Reset value
//     ) hd_dpcmn_bitsync3_aib_hssi_rx_dcd_cal_done
c3lib_bitsync #( .DWIDTH (1), .RESET_VAL (0), .DST_CLK_FREQ_MHZ (1000), .SRC_DATA_FREQ_MHZ (500))
  bitsync_aib_hssi_rx_dcd_cal_done
    (
      .clk      (rx_clock_hrdrst_rx_osc_clk),
      .rst_n    (rx_reset_hrdrst_rx_osc_clk_rst_n),
      .data_in  (aib_hssi_rx_dcd_cal_done_int),
      .data_out (sync_aib_hssi_rx_dcd_cal_done)
    );

// hd_dpcmn_bitsync3
//     #(
//         .DWIDTH      (1),       // Sync Data input
//         .RESET_VAL   (0)        // Reset value
//     ) hd_dpcmn_bitsync3_rx_fifo_ready
c3lib_bitsync #( .DWIDTH (1), .RESET_VAL (0), .DST_CLK_FREQ_MHZ (1000), .SRC_DATA_FREQ_MHZ (1000))
  bitsync_rx_fifo_ready
    (
      .clk      (rx_clock_hrdrst_rx_osc_clk),
      .rst_n    (rx_reset_hrdrst_rx_osc_clk_rst_n),
      .data_in  (rx_fifo_ready),
      .data_out (sync_rx_fifo_ready)
    );

//********************************************************************
// Test bus
//********************************************************************
assign rx_hrdrst_tb_direct = {rx_fifo_ready, rx_rst_sm_cs[2:0]};

assign rx_hrdrst_testbus[19:0] = {rx_hrdrst_asn_data_transfer_en,aib_hssi_rx_dcd_cal_done,aib_hssi_rx_dcd_cal_req,
				  rx_hrdrst_hssi_rx_transfer_en,rx_hrdrst_hssi_rx_dcd_cal_done,
				  sr_pld_hssi_rx_fifo_srst, rx_hrdrst_hssi_rx_fifo_srst,rx_hrdrst_speed_chg_srst,sync_rx_asn_fifo_hold,rx_hrdrst_hssi_rx_dcd_cal_req,
				  sr_fabric_rx_transfer_en,sr_fabric_rx_dll_lock,sync_aib_hssi_rx_dcd_cal_done,sr_pld_rx_dll_lock_req,sync_rx_asn_dll_lock_en,
				  sync_rx_asn_rate_change_in_progress,rx_rst_sm_cs[2:0],rx_rst_sm_cs_chg};

//********************************************************************
// To ASN SM when Reset SM is enabled 
//********************************************************************
//assign rx_hrdrst_asn_data_transfer_en = rx_hrdrst_hssi_rx_transfer_en & sr_fabric_tx_transfer_en;

always @ (negedge rx_reset_hrdrst_rx_osc_clk_rst_n or posedge rx_clock_hrdrst_rx_osc_clk)
begin
	if (~rx_reset_hrdrst_rx_osc_clk_rst_n)
	begin
		rx_hrdrst_asn_data_transfer_en <= 1'b0;
	end
	else
	begin
		rx_hrdrst_asn_data_transfer_en <= rx_hrdrst_hssi_rx_transfer_en & sr_fabric_tx_transfer_en;
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
assign rx_hrdrst_rx_fifo_srst = r_rx_hrdrst_user_ctl_en ? sr_pld_hssi_rx_fifo_srst :  rx_hrdrst_hssi_rx_fifo_srst_final;
// FIFO Reset when Reset SM is enabled
// From master Reset SM when current channel is master channel
// From master ASN SM when current channel is slave channel
assign rx_hrdrst_hssi_rx_fifo_srst_final = (r_rx_master_sel == 2'b00) ? rx_hrdrst_hssi_rx_fifo_srst : rx_hrdrst_speed_chg_srst;

//********************************************************************
// Rx Reset State Machine Bonding Input Output
//********************************************************************
assign bond_rx_hrdrst_ds_in_hssi_rx_dcd_cal_done_int = r_rx_bonding_dft_in_en ? r_rx_bonding_dft_in_value : bond_rx_hrdrst_ds_in_hssi_rx_dcd_cal_done;
assign bond_rx_hrdrst_us_in_hssi_rx_dcd_cal_done_int = r_rx_bonding_dft_in_en ? r_rx_bonding_dft_in_value : bond_rx_hrdrst_us_in_hssi_rx_dcd_cal_done;
assign bond_rx_hrdrst_ds_in_hssi_rx_dcd_cal_req_int = r_rx_bonding_dft_in_en ? r_rx_bonding_dft_in_value : bond_rx_hrdrst_ds_in_hssi_rx_dcd_cal_req;
assign bond_rx_hrdrst_us_in_hssi_rx_dcd_cal_req_int = r_rx_bonding_dft_in_en ? r_rx_bonding_dft_in_value : bond_rx_hrdrst_us_in_hssi_rx_dcd_cal_req;

// c3aibadapt_cmn_cp_dist_pair
//     #(
//         .ASYNC_RESET_VAL(0),
//         .WIDTH(1)               // Control width
//     ) cmn_cp_dist_pair_hssi_rx_dcd_cal_req
//     (
//         .clk(1'b0),                                             // clock
//         .rst_n(1'b1),                                           // async reset
//         .srst_n(1'b1),                                          // sync reset
//         .data_enable(1'b1),                                     // data enable / data valid
//         .master_in(rx_hrdrst_hssi_rx_dcd_cal_req),                       // master control signal
//         .us_in(bond_rx_hrdrst_us_in_hssi_rx_dcd_cal_req_int),                // CP distributed signal in up
//         .ds_in(bond_rx_hrdrst_ds_in_hssi_rx_dcd_cal_req_int),                // CP distributed signal in dwn
//         .r_us_master(r_rx_dist_master_sel),                 // CRAM to control master or distributed up
//         .r_ds_master(r_rx_dist_master_sel),                 // CRAM to control master or distributed dwn
//         .r_us_bypass_pipeln(1'b1),                              // CRAM combo or registered up
//         .r_ds_bypass_pipeln(1'b1),                              // CRAM combo or registered dwn
//         .us_out(bond_rx_hrdrst_us_out_hssi_rx_dcd_cal_req),                  // CP distributed signal out up
//         .ds_out(bond_rx_hrdrst_ds_out_hssi_rx_dcd_cal_req),                  // CP distributed signal out dwn
//         .ds_tap(rx_hrdrst_hssi_rx_dcd_cal_req_chnl_down),    // CP output for this channel dwn
//         .us_tap(rx_hrdrst_hssi_rx_dcd_cal_req_chnl_up)       // CP output for this channel up
//     );

	//assign aib_hssi_rx_dcd_cal_req = r_rx_hrdrst_rst_sm_dis ? sr_aib_hssi_rx_dcd_cal_req : rx_hrdrst_hssi_rx_dcd_cal_req_final;
	assign aib_hssi_rx_dcd_cal_req_int = r_rx_hrdrst_user_ctl_en ? sr_aib_hssi_rx_dcd_cal_req : rx_hrdrst_hssi_rx_dcd_cal_req_final;
	assign rx_hrdrst_hssi_rx_dcd_cal_req_final = rx_hrdrst_hssi_rx_dcd_cal_req;
	// assign rx_hrdrst_hssi_rx_dcd_cal_req_final = (r_rx_master_sel == 2'b00) ? rx_hrdrst_hssi_rx_dcd_cal_req			:
        // 					     (r_rx_master_sel == 2'b01) ? rx_hrdrst_hssi_rx_dcd_cal_req_chnl_up		:
	// 					     (r_rx_master_sel == 2'b10) ? rx_hrdrst_hssi_rx_dcd_cal_req_chnl_down	:
	// 									  rx_hrdrst_hssi_rx_dcd_cal_req			;

	/*
	assign rx_hrdrst_hssi_rx_dcd_cal_req_this_chnl = r_rx_hrdrst_rst_sm_dis ? sr_aib_hssi_rx_dcd_cal_req : rx_hrdrst_hssi_rx_dcd_cal_req;
	assign aib_hssi_rx_dcd_cal_req = (r_rx_master_sel == 2'b00) ? rx_hrdrst_hssi_rx_dcd_cal_req_this_chnl	:
        				 (r_rx_master_sel == 2'b01) ? rx_hrdrst_hssi_rx_dcd_cal_req_chnl_up	:
					 (r_rx_master_sel == 2'b10) ? rx_hrdrst_hssi_rx_dcd_cal_req_chnl_down	:
								      rx_hrdrst_hssi_rx_dcd_cal_req		;
	*/

        assign rx_hrdrst_hssi_rx_dcd_cal_done_chnl_down = r_rx_ds_last_chnl ? 1'b1 : bond_rx_hrdrst_ds_in_hssi_rx_dcd_cal_done_int;
        assign rx_hrdrst_hssi_rx_dcd_cal_done_chnl_up = r_rx_us_last_chnl ? 1'b1 : bond_rx_hrdrst_us_in_hssi_rx_dcd_cal_done_int;
	assign aib_hssi_rx_dcd_cal_done_int = (aib_hssi_rx_dcd_cal_done & rx_hrdrst_hssi_rx_dcd_cal_done_chnl_up & rx_hrdrst_hssi_rx_dcd_cal_done_chnl_down);
        // assign bond_rx_hrdrst_us_out_hssi_rx_dcd_cal_done = aib_hssi_rx_dcd_cal_done & rx_hrdrst_hssi_rx_dcd_cal_done_chnl_down;
        // assign bond_rx_hrdrst_ds_out_hssi_rx_dcd_cal_done = aib_hssi_rx_dcd_cal_done & rx_hrdrst_hssi_rx_dcd_cal_done_chnl_up;

//********************************************************************
// Rx Reset State Machine Output
//********************************************************************

assign rx_hrdrst_hssi_rx_dcd_cal_req_pre = rx_hrdrst_hssi_rx_dcd_cal_req_comb;

// Generate asynchronous reset during non PCIe rate change. 
// Bypass Rx Reset State Machine if Reset State Machine is diabled.
//assign rx_hrdrst_hssi_rx_async_rst_pre = r_rx_hrdrst_rst_sm_dis ? (~sync_rx_asn_rate_change_in_progress & ~sr_fabric_rx_dll_lock) : 
//								  (~sync_rx_asn_rate_change_in_progress & rx_hrdrst_hssi_rx_rst_comb);
// Generate synchronous reset to FIFO during PCIe rate change.
// Bypass Rx Reset State Machine if Reset State Machine is diabled.
//assign rx_hrdrst_hssi_rx_fifo_srst_pre = r_rx_hrdrst_rst_sm_dis ? (sync_rx_asn_rate_change_in_progress & ~sr_fabric_rx_dll_lock) :
//								  (sync_rx_asn_rate_change_in_progress & rx_hrdrst_hssi_rx_rst_comb); 
//assign rx_hrdrst_hssi_rx_fifo_srst_pre = r_rx_hrdrst_user_ctl_en ? (~sr_fabric_rx_dll_lock) : rx_hrdrst_hssi_rx_rst_comb;
assign rx_hrdrst_hssi_rx_fifo_srst_pre = rx_hrdrst_hssi_rx_rst_comb;

// Re-purpose for rx_asn_dll_lock_en signal to be transferred using SR if Reset State Machine is diabled.
//assign rx_hrdrst_hssi_rx_dcd_cal_done_or_asn_dll_lock_pre = r_rx_hrdrst_rst_sm_dis ? (~sync_rx_asn_dll_lock_en) : rx_hrdrst_hssi_rx_dcd_cal_done_comb;
assign rx_hrdrst_hssi_rx_dcd_cal_done_or_asn_dll_lock_pre = r_rx_hrdrst_user_ctl_en ? (~sync_rx_asn_dll_lock_en) : rx_hrdrst_hssi_rx_dcd_cal_done_comb;

// Bypass Rx Reset State Machine if Reset State Machine is diabled.
//assign rx_hrdrst_hssi_rx_transfer_en_pre = r_rx_hrdrst_rst_sm_dis ? sr_fabric_rx_transfer_en : rx_hrdrst_hssi_rx_transfer_en_comb;
//assign rx_hrdrst_hssi_rx_transfer_en_pre = r_rx_hrdrst_user_ctl_en ? sr_fabric_rx_transfer_en : rx_hrdrst_hssi_rx_transfer_en_comb;
assign rx_hrdrst_hssi_rx_transfer_en_pre = rx_hrdrst_hssi_rx_transfer_en_comb;

always @ (negedge rx_reset_hrdrst_rx_osc_clk_rst_n or posedge rx_clock_hrdrst_rx_osc_clk)
begin
	if (~rx_reset_hrdrst_rx_osc_clk_rst_n)
	begin
		rx_hrdrst_hssi_rx_dcd_cal_req <= 1'b0;
		//rx_hrdrst_hssi_rx_async_rst <= 1'b1;
		//rx_hrdrst_hssi_rx_fifo_srst <= 1'b0;
		rx_hrdrst_hssi_rx_fifo_srst <= 1'b1;
		rx_hrdrst_hssi_rx_dcd_cal_done <= 1'b0;
		rx_hrdrst_hssi_rx_transfer_en <= 1'b0;
	end
	else
	begin
		rx_hrdrst_hssi_rx_dcd_cal_req <= rx_hrdrst_hssi_rx_dcd_cal_req_pre; 
		//rx_hrdrst_hssi_rx_async_rst <= rx_hrdrst_hssi_rx_async_rst_pre;
		rx_hrdrst_hssi_rx_fifo_srst <= rx_hrdrst_hssi_rx_fifo_srst_pre;
		rx_hrdrst_hssi_rx_dcd_cal_done <= rx_hrdrst_hssi_rx_dcd_cal_done_or_asn_dll_lock_pre;
		rx_hrdrst_hssi_rx_transfer_en <= rx_hrdrst_hssi_rx_transfer_en_pre;
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
		rx_rst_sm_cs_reg <= WAIT_RX_TRANSFER_REQ;
	end
	else if (~avmm_hrdrst_hssi_osc_transfer_alive  || r_rx_hrdrst_rst_sm_dis || r_rx_hrdrst_user_ctl_en)
	begin
		rx_rst_sm_cs <= WAIT_RX_TRANSFER_REQ;
		rx_rst_sm_cs_reg <= WAIT_RX_TRANSFER_REQ;
	end
	else 
	begin
		rx_rst_sm_cs <= rx_rst_sm_ns;
		rx_rst_sm_cs_reg <= rx_rst_sm_cs;
	end
end

always @(negedge rx_reset_hrdrst_rx_osc_clk_rst_n or posedge rx_clock_hrdrst_rx_osc_clk) 
begin
	if (~rx_reset_hrdrst_rx_osc_clk_rst_n) 
	begin
		rx_rst_sm_cs_chg <= 1'b0;
	end
	else if (~avmm_hrdrst_hssi_osc_transfer_alive  || r_rx_hrdrst_rst_sm_dis || r_rx_hrdrst_user_ctl_en)
	begin
		rx_rst_sm_cs_chg <= 1'b0;
	end
	else if (rx_rst_sm_cs[2:0] != rx_rst_sm_cs_reg[2:0])
	begin
		rx_rst_sm_cs_chg <= ~rx_rst_sm_cs_chg;
	end
end


always @ (*)
begin
	rx_rst_sm_ns = rx_rst_sm_cs;
	rx_hrdrst_hssi_rx_dcd_cal_req_comb = 1'b0;
	rx_hrdrst_hssi_rx_dcd_cal_done_comb = 1'b0;
	rx_hrdrst_hssi_rx_rst_comb = 1'b1;
	rx_hrdrst_hssi_rx_transfer_en_comb = 1'b0;
    
	case(rx_rst_sm_cs)
	WAIT_RX_TRANSFER_REQ: 
	begin
		if(sr_pld_rx_dll_lock_req && ~sync_aib_hssi_rx_dcd_cal_done)
		begin
                	rx_rst_sm_ns  = SEND_RX_DCD_CAL_REQ;
		end
        end
        
	SEND_RX_DCD_CAL_REQ:
        begin
		rx_hrdrst_hssi_rx_dcd_cal_req_comb = 1'b1;
		if(sync_aib_hssi_rx_dcd_cal_done || r_rx_hrdrst_dcd_cal_done_bypass)
		begin
			rx_rst_sm_ns = WAIT_REMOTE_RX_DLL_LOCK;
		end
        end
      
	WAIT_REMOTE_RX_DLL_LOCK:
        begin
		rx_hrdrst_hssi_rx_dcd_cal_req_comb = 1'b1;
		rx_hrdrst_hssi_rx_dcd_cal_done_comb = 1'b1;
              	if (sr_fabric_rx_dll_lock)
                begin
                	rx_rst_sm_ns = WAIT_REMOTE_RX_ALIGN_DONE;
            	end
        end
	WAIT_REMOTE_RX_ALIGN_DONE:
        begin
		rx_hrdrst_hssi_rx_dcd_cal_req_comb = 1'b1;
		rx_hrdrst_hssi_rx_rst_comb = 1'b0;
              	if (sr_fabric_rx_transfer_en && sync_rx_fifo_ready)
                begin
                	rx_rst_sm_ns = RX_TRANSFER_EN;
            	end
        end

      	RX_TRANSFER_EN:
        begin
		rx_hrdrst_hssi_rx_dcd_cal_req_comb = 1'b1;
		rx_hrdrst_hssi_rx_rst_comb = 1'b0;
		rx_hrdrst_hssi_rx_transfer_en_comb = 1'b1;
              	if (~sr_pld_rx_dll_lock_req)
                begin
                	rx_rst_sm_ns = WAIT_RX_TRANSFER_REQ;
            	end
        end

	default: 
        begin
		rx_rst_sm_ns = WAIT_RX_TRANSFER_REQ;
		rx_hrdrst_hssi_rx_dcd_cal_req_comb = 1'b0;
		rx_hrdrst_hssi_rx_dcd_cal_done_comb = 1'b0;
		rx_hrdrst_hssi_rx_rst_comb = 1'b1;
		rx_hrdrst_hssi_rx_transfer_en_comb = 1'b0;
        end
      endcase
  end

endmodule // c3aibadapt_rxrst_ctl

