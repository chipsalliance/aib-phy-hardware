// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3aibadapt_txrst_ctl (
  input	 wire		csr_rdy_dly_in,
  input	 wire		aib_hssi_pcs_tx_pld_rst_n,
  input	 wire		aib_hssi_adapter_tx_pld_rst_n,
  input	 wire [2:1]	aib_hssi_fpll_shared_direct_async_in,
  input	 wire		aib_hssi_pld_pma_txpma_rstb,
  input	 wire		aib_hssi_tx_dcd_cal_done,
  input	 wire		aib_hssi_tx_dll_lock,
  input  wire           bond_tx_hrdrst_ds_in_hssi_tx_dcd_cal_done,
  input  wire           bond_tx_hrdrst_us_in_hssi_tx_dcd_cal_done,
  input  wire           bond_tx_hrdrst_ds_in_hssi_tx_dcd_cal_req,
  input  wire           bond_tx_hrdrst_us_in_hssi_tx_dcd_cal_req,
  input  wire           bond_tx_hrdrst_ds_in_hssi_tx_dll_lock,
  input  wire           bond_tx_hrdrst_us_in_hssi_tx_dll_lock,
  input  wire           bond_tx_hrdrst_ds_in_hssi_tx_dll_lock_req,
  input  wire           bond_tx_hrdrst_us_in_hssi_tx_dll_lock_req,
  input	 wire		avmm_hrdrst_hssi_osc_transfer_alive,
  input	 wire		sr_pld_hssi_tx_fifo_srst,
  input	 wire		sr_pld_tx_dll_lock_req,
  input	 wire		sr_fabric_tx_dcd_cal_done,
  input	 wire		sr_fabric_tx_transfer_en,
  input	 wire		rx_asn_rate_change_in_progress,
  input	 wire		rx_asn_dll_lock_en,
  input	 wire		rx_asn_fifo_hold,
  input	 wire		tx_fifo_ready,
  input	 wire		align_done,
  input	 wire		sr_aib_hssi_tx_dcd_cal_req,
  input	 wire		sr_aib_hssi_tx_dll_lock_req,
  input  wire           tx_ehip_clk,
  input  wire           tx_rsfec_clk,
  input  wire           tx_elane_clk,
  input	 wire		tx_clock_reset_hrdrst_rx_osc_clk,
  input	 wire		tx_clock_reset_fifo_wr_clk,
  input	 wire		tx_clock_reset_fifo_rd_clk,
  input	 wire		tx_clock_fifo_sclk,
  input	 wire		tx_clock_reset_async_rx_osc_clk,
  input	 wire		tx_clock_reset_async_tx_osc_clk,
  input	 wire		tx_clock_pma_aib_tx_clk,
  input  wire           tx_aib_transfer_clk,
  input	 wire		tx_clock_pma_aib_tx_div2_clk,
  input	 wire		tx_clock_hrdrst_rx_osc_clk,		// Static clock gated
  input	 wire		r_tx_free_run_div_clk,
  input	 wire		r_tx_hrdrst_rst_sm_dis,
  input	 wire		r_tx_hrdrst_dcd_cal_done_bypass,
  input	 wire		r_tx_hrdrst_dll_lock_bypass,
  input	 wire		r_tx_hrdrst_align_bypass,
  input	 wire		r_tx_hrdrst_user_ctl_en,
  input	 wire		r_tx_indv,
  input  wire [1:0]     r_tx_master_sel,
  input  wire           r_tx_dist_master_sel,
  input  wire           r_tx_ds_last_chnl,
  input  wire           r_tx_us_last_chnl,
  input  wire           r_tx_bonding_dft_in_en,
  input  wire           r_tx_bonding_dft_in_value,
  input  wire           r_rstctl_tx_pld_div2_rst_opt,
  input	 wire		dft_adpt_rst,
  input  wire           adapter_scan_rst_n,
  input  wire           adapter_scan_mode_n,
  output wire           tx_ehip_rst_n,
  output wire           tx_elane_rst_n,
  output wire           tx_rsfec_rst_n,
  // output wire           tx_pma_rst_n,
  output wire		pld_10g_krfec_tx_pld_rst_n,
  output wire		pld_8g_g3_tx_pld_rst_n,
  output wire		pld_pma_tx_bonding_rstb,
  output wire [2:1]	pcs_fpll_shared_direct_async_out,
  output wire		pld_pma_txpma_rstb,
  output wire		aib_hssi_tx_dcd_cal_req,
  output wire		aib_hssi_tx_dll_lock_req,
  output wire		tx_hrdrst_tx_fifo_srst,
  output reg		tx_hrdrst_hssi_tx_dcd_cal_done,
  output reg		tx_hrdrst_hssi_tx_dll_lock,
  output reg		tx_hrdrst_hssi_tx_transfer_en,
  output wire [19:0]	tx_hrdrst_testbus,
  output wire [3:0]     tx_hrdrst_tb_direct,
  output wire		tx_reset_fifo_wr_rst_n,
  output wire		tx_reset_fifo_rd_rst_n,
  output wire		tx_reset_fifo_sclk_rst_n,
  output wire		tx_reset_pma_aib_tx_clk_rst_n,
  output wire           tx_reset_tx_transfer_clk_rst_n,
  output wire		tx_reset_pma_aib_tx_clkdiv2_rst_n,
  output wire		tx_reset_async_rx_osc_clk_rst_n,
  output wire		tx_reset_async_tx_osc_clk_rst_n
);

//********************************************************************
// Define Parameters 
//********************************************************************

localparam  WAIT_TX_TRANSFER_REQ	= 3'b000;
localparam  SEND_TX_DCD_CAL_REQ		= 3'b001;
localparam  WAIT_REMOTE_TX_DCD_CAL_DONE	= 3'b010;
localparam  SEND_TX_DLL_LOCK_REQ	= 3'b011;
localparam  WAIT_TX_ALIGN_DONE		= 3'b100;
localparam  TX_TRANSFER_EN		= 3'b101;

//********************************************************************
//********************************************************************

wire            int_tx_rst_n;
wire            int_tx_hrd_rst_n;
wire		int_clkdiv_rst_n_bypass;
wire		int_clkdiv_scan_mode_n;
wire		tx_reset_hrdrst_rx_osc_clk_rst_n;
wire            pld_tx_opt_rst_n;

reg [2:0]       tx_rst_sm_cs;
reg [2:0]       tx_rst_sm_ns;
reg [2:0]       tx_rst_sm_cs_reg;
reg		tx_rst_sm_cs_chg;

wire		sync_rx_asn_rate_change_in_progress;	
wire		sync_rx_asn_dll_lock_en;
wire		sync_rx_asn_fifo_hold;
reg             sync_rx_asn_fifo_hold_reg;
reg [4:0]       tx_hrdrst_speed_chg_srst_cnt;
reg             tx_hrdrst_speed_chg_srst;

wire		aib_hssi_tx_dcd_cal_req_int;
wire		aib_hssi_tx_dcd_cal_done_int;
wire		sync_aib_hssi_tx_dcd_cal_done;
wire		aib_hssi_tx_dll_lock_req_int;
wire		aib_hssi_tx_dll_lock_int;
wire		sync_aib_hssi_tx_dll_lock;
wire		sync_tx_align_done;
wire		sync_tx_fifo_ready;

reg             tx_hrdrst_hssi_tx_dcd_cal_req;
wire            tx_hrdrst_hssi_tx_dcd_cal_req_pre;
reg             tx_hrdrst_hssi_tx_dcd_cal_req_comb;

wire            tx_hrdrst_hssi_tx_dcd_cal_done_pre;
reg		tx_hrdrst_hssi_tx_dcd_cal_done_comb;

reg		tx_hrdrst_hssi_tx_dll_lock_req;
wire		tx_hrdrst_hssi_tx_dll_lock_req_pre;
reg		tx_hrdrst_hssi_tx_dll_lock_req_comb;

wire		tx_hrdrst_hssi_tx_dll_lock_pre;
reg		tx_hrdrst_hssi_tx_dll_lock_comb;

//reg             tx_hrdrst_hssi_tx_async_rst;
//wire            tx_hrdrst_hssi_tx_async_rst_pre;
wire            tx_hrdrst_hssi_tx_fifo_srst_final;
reg             tx_hrdrst_hssi_tx_fifo_srst;
wire            tx_hrdrst_hssi_tx_fifo_srst_pre;
reg             tx_hrdrst_hssi_tx_rst_comb;

wire            tx_hrdrst_hssi_tx_transfer_en_pre;
reg             tx_hrdrst_hssi_tx_transfer_en_comb;

wire            bond_tx_hrdrst_ds_in_hssi_tx_dcd_cal_done_int;
wire            bond_tx_hrdrst_us_in_hssi_tx_dcd_cal_done_int;
wire            bond_tx_hrdrst_ds_in_hssi_tx_dcd_cal_req_int;
wire            bond_tx_hrdrst_us_in_hssi_tx_dcd_cal_req_int;
wire            bond_tx_hrdrst_ds_in_hssi_tx_dll_lock_int;
wire            bond_tx_hrdrst_us_in_hssi_tx_dll_lock_int;
wire            bond_tx_hrdrst_ds_in_hssi_tx_dll_lock_req_int;
wire            bond_tx_hrdrst_us_in_hssi_tx_dll_lock_req_int;

wire            tx_hrdrst_hssi_tx_dcd_cal_done_chnl_down;
wire            tx_hrdrst_hssi_tx_dcd_cal_done_chnl_up;
wire		tx_hrdrst_hssi_tx_dcd_cal_req_final;
// wire            tx_hrdrst_hssi_tx_dcd_cal_req_chnl_down;
// wire            tx_hrdrst_hssi_tx_dcd_cal_req_chnl_up;

wire            tx_hrdrst_hssi_tx_dll_lock_chnl_down;
wire            tx_hrdrst_hssi_tx_dll_lock_chnl_up;
wire		tx_hrdrst_hssi_tx_dll_lock_req_final;
// wire            tx_hrdrst_hssi_tx_dll_lock_req_chnl_down;
// wire            tx_hrdrst_hssi_tx_dll_lock_req_chnl_up;

// No-connects
// wire           bond_tx_hrdrst_ds_out_hssi_tx_dcd_cal_done;
// wire           bond_tx_hrdrst_us_out_hssi_tx_dcd_cal_done;
// wire           bond_tx_hrdrst_ds_out_hssi_tx_dcd_cal_req;
// wire           bond_tx_hrdrst_us_out_hssi_tx_dcd_cal_req;
// wire           bond_tx_hrdrst_ds_out_hssi_tx_dll_lock;
// wire           bond_tx_hrdrst_us_out_hssi_tx_dll_lock;
// wire           bond_tx_hrdrst_ds_out_hssi_tx_dll_lock_req;
// wire           bond_tx_hrdrst_us_out_hssi_tx_dll_lock_req;

//********************************************************************
// Feedthrough from PCS to AIB
//********************************************************************

//********************************************************************
// Feedthrough from AIB to PCS
//********************************************************************
assign pld_10g_krfec_tx_pld_rst_n = dft_adpt_rst | aib_hssi_pcs_tx_pld_rst_n;
assign pld_8g_g3_tx_pld_rst_n     = dft_adpt_rst | aib_hssi_pcs_tx_pld_rst_n;
assign pld_pma_txpma_rstb         = dft_adpt_rst | aib_hssi_pld_pma_txpma_rstb;
assign pcs_fpll_shared_direct_async_out[2:1] = dft_adpt_rst ? 2'b11 : aib_hssi_fpll_shared_direct_async_in[2:1];

//********************************************************************
// Tie off
//********************************************************************
assign pld_pma_tx_bonding_rstb = 1'b1;

//********************************************************************
// Reset muxing
//********************************************************************

//********************************************************************
// Reset Synchronizers
//********************************************************************

assign int_tx_rst_n = (adapter_scan_mode_n & ~dft_adpt_rst & csr_rdy_dly_in & aib_hssi_adapter_tx_pld_rst_n) | (~adapter_scan_mode_n & adapter_scan_rst_n);

c3lib_rstsync #(.RESET_VAL (0), .DST_CLK_FREQ_MHZ (500))
  rstsync_tx_hrdrst_rsfec_clk (
    .rst_n         (int_tx_rst_n),
    .rst_n_bypass  (adapter_scan_rst_n),
    .clk           (tx_rsfec_clk),
    .scan_mode_n   (adapter_scan_mode_n),
    .rst_n_sync    (tx_rsfec_rst_n));

c3lib_rstsync #(.RESET_VAL (0), .DST_CLK_FREQ_MHZ (500))
  rstsync_tx_hrdrst_elane_clk (
    .rst_n         (int_tx_rst_n),
    .rst_n_bypass  (adapter_scan_rst_n),
    .clk           (tx_elane_clk),
    .scan_mode_n   (adapter_scan_mode_n),
    .rst_n_sync    (tx_elane_rst_n));

c3lib_rstsync #(.RESET_VAL (0), .DST_CLK_FREQ_MHZ (500))
  rstsync_tx_hrdrst_ehip_clk (
    .rst_n         (int_tx_rst_n),
    .rst_n_bypass  (adapter_scan_rst_n),
    .clk           (tx_ehip_clk),
    .scan_mode_n   (adapter_scan_mode_n),
    .rst_n_sync    (tx_ehip_rst_n));

// hd_dpcmn_rst_n_sync hd_dpcmn_rst_n_sync_tx_hrdrst_rx_osc_clk
c3lib_rstsync #(.RESET_VAL (0), .DST_CLK_FREQ_MHZ (1000))
  rstsync_tx_hrdrst_rx_osc_clk (
    .rst_n         (int_tx_rst_n),
    .rst_n_bypass  (adapter_scan_rst_n),
    .clk           (tx_clock_reset_hrdrst_rx_osc_clk),
    .scan_mode_n   (adapter_scan_mode_n),
    .rst_n_sync    (tx_reset_hrdrst_rx_osc_clk_rst_n));

//********************************************************************

// hd_dpcmn_rst_n_sync hd_dpcmn_rst_n_sync_fifo_wr_clk
c3lib_rstsync #(.RESET_VAL (0), .DST_CLK_FREQ_MHZ (1000))
  rstsync_tx_fifo_wr_clk (
    .rst_n         (int_tx_rst_n),
    .rst_n_bypass  (adapter_scan_rst_n),
    .clk           (tx_clock_reset_fifo_wr_clk),
    .scan_mode_n   (adapter_scan_mode_n),
    .rst_n_sync    (tx_reset_fifo_wr_rst_n));

// hd_dpcmn_rst_n_sync hd_dpcmn_rst_n_sync_fifo_rd_clk
c3lib_rstsync #(.RESET_VAL (0), .DST_CLK_FREQ_MHZ (500))
  rstsync_tx_fifo_rd_clk (
    .rst_n         (int_tx_rst_n),
    .rst_n_bypass  (adapter_scan_rst_n),
    .clk           (tx_clock_reset_fifo_rd_clk),
    .scan_mode_n   (adapter_scan_mode_n),
    .rst_n_sync    (tx_reset_fifo_rd_rst_n));

// hd_dpcmn_rst_n_sync hd_dpcmn_rst_n_sync_fifo_sclk
c3lib_rstsync #(.RESET_VAL (0), .DST_CLK_FREQ_MHZ (500))
  rstsync_tx_fifo_sclk (
    .rst_n         (int_tx_rst_n),
    .rst_n_bypass  (adapter_scan_rst_n),
    .clk           (tx_clock_fifo_sclk),
    .scan_mode_n   (adapter_scan_mode_n),
    .rst_n_sync    (tx_reset_fifo_sclk_rst_n));

// hd_dpcmn_rst_n_sync hd_dpcmn_rst_n_sync_pma_aib_tx_clkdiv2
c3lib_rstsync #(.RESET_VAL (0), .DST_CLK_FREQ_MHZ (500))
  rstsync_pma_aib_tx_clkdiv2 (
    .rst_n         (int_tx_rst_n),
    .rst_n_bypass  (adapter_scan_rst_n),
    .clk           (tx_clock_pma_aib_tx_div2_clk),
    .scan_mode_n   (adapter_scan_mode_n),
    .rst_n_sync    (tx_reset_pma_aib_tx_clkdiv2_rst_n));

//********************************************************************

// assign int_tx_hrd_rst_n = (adapter_scan_mode_n & ~dft_adpt_rst & csr_rdy_dly_in) | (~adapter_scan_mode_n & adapter_scan_rst_n);

assign pld_tx_opt_rst_n = r_rstctl_tx_pld_div2_rst_opt ? aib_hssi_adapter_tx_pld_rst_n : 1'b1;
assign int_tx_hrd_rst_n = (adapter_scan_mode_n & ~dft_adpt_rst & csr_rdy_dly_in & pld_tx_opt_rst_n) | (~adapter_scan_mode_n & adapter_scan_rst_n);

c3lib_rstsync #(.RESET_VAL (0), .DST_CLK_FREQ_MHZ (1000))
  rstsync_rx_osc_clk (
    .rst_n         (int_tx_hrd_rst_n),
    .rst_n_bypass  (adapter_scan_rst_n),
    .clk           (tx_clock_reset_async_rx_osc_clk),
    .scan_mode_n   (adapter_scan_mode_n),
    .rst_n_sync    (tx_reset_async_rx_osc_clk_rst_n));

c3lib_rstsync #(.RESET_VAL (0), .DST_CLK_FREQ_MHZ (1000))
  rstsync_tx_osc_clk (
    .rst_n         (int_tx_hrd_rst_n),
    .rst_n_bypass  (adapter_scan_rst_n),
    .clk           (tx_clock_reset_async_tx_osc_clk),
    .scan_mode_n   (adapter_scan_mode_n),
    .rst_n_sync    (tx_reset_async_tx_osc_clk_rst_n));

assign int_clkdiv_rst_n_bypass = (adapter_scan_mode_n | adapter_scan_rst_n);
assign int_clkdiv_scan_mode_n  = (adapter_scan_mode_n & ~r_tx_free_run_div_clk);

c3lib_rstsync #(.RESET_VAL (0), .DST_CLK_FREQ_MHZ (1000))
  rstsync_pma_aib_tx_clk (
    .rst_n         (int_tx_hrd_rst_n),
    .rst_n_bypass  (int_clkdiv_rst_n_bypass),
    .clk           (tx_clock_pma_aib_tx_clk),
    .scan_mode_n   (int_clkdiv_scan_mode_n),
    .rst_n_sync    (tx_reset_pma_aib_tx_clk_rst_n));

c3lib_rstsync #(.RESET_VAL (0), .DST_CLK_FREQ_MHZ (1000))
  rstsync_tx_transfer_clk (
    .rst_n         (int_tx_hrd_rst_n),
    .rst_n_bypass  (int_clkdiv_rst_n_bypass),
    .clk           (tx_aib_transfer_clk),
    .scan_mode_n   (int_clkdiv_scan_mode_n),
    .rst_n_sync    (tx_reset_tx_transfer_clk_rst_n));

//********************************************************************
// Double Synchronizers
//********************************************************************
assign sync_rx_asn_rate_change_in_progress = 1'b0;
assign sync_rx_asn_dll_lock_en = 1'b0;
assign sync_rx_asn_fifo_hold = 1'b0;

// SRC data frequency... SR clock ~ 900, data should be less: 900/(9 SR signals minimum)
c3lib_bitsync #( .DWIDTH (1), .RESET_VAL (0), .DST_CLK_FREQ_MHZ (1000), .SRC_DATA_FREQ_MHZ (100))
  bitsync_aib_hssi_tx_dcd_cal_req (
    .clk      (tx_clock_hrdrst_rx_osc_clk),
    .rst_n    (tx_reset_hrdrst_rx_osc_clk_rst_n),
    .data_in  (aib_hssi_tx_dcd_cal_req_int),
    .data_out (aib_hssi_tx_dcd_cal_req));

c3lib_bitsync #( .DWIDTH (1), .RESET_VAL (0), .DST_CLK_FREQ_MHZ (1000), .SRC_DATA_FREQ_MHZ (200))
  bitsync_aib_hssi_tx_dcd_cal_done (
    .clk      (tx_clock_hrdrst_rx_osc_clk),
    .rst_n    (tx_reset_hrdrst_rx_osc_clk_rst_n),
    .data_in  (aib_hssi_tx_dcd_cal_done_int),
    .data_out (sync_aib_hssi_tx_dcd_cal_done));

c3lib_bitsync #( .DWIDTH (1), .RESET_VAL (0), .DST_CLK_FREQ_MHZ (1000), .SRC_DATA_FREQ_MHZ (200))
  bitsync_aib_hssi_tx_dll_lock_req (
    .clk      (tx_clock_hrdrst_rx_osc_clk),
    .rst_n    (tx_reset_hrdrst_rx_osc_clk_rst_n),
    .data_in  (aib_hssi_tx_dll_lock_req_int),
    .data_out (aib_hssi_tx_dll_lock_req));

c3lib_bitsync #( .DWIDTH (1), .RESET_VAL (0), .DST_CLK_FREQ_MHZ (1000), .SRC_DATA_FREQ_MHZ (200))
  bitsync_aib_hssi_tx_dll_lock (
      .clk      (tx_clock_hrdrst_rx_osc_clk),
      .rst_n    (tx_reset_hrdrst_rx_osc_clk_rst_n),
      .data_in  (aib_hssi_tx_dll_lock_int),
      .data_out (sync_aib_hssi_tx_dll_lock));

c3lib_bitsync #( .DWIDTH (1), .RESET_VAL (0), .DST_CLK_FREQ_MHZ (1000), .SRC_DATA_FREQ_MHZ (200))
  bitsync_tx_align_done
    (
      .clk      (tx_clock_hrdrst_rx_osc_clk),
      .rst_n    (tx_reset_hrdrst_rx_osc_clk_rst_n),
      .data_in  (align_done),
      .data_out (sync_tx_align_done)
    );

c3lib_bitsync #( .DWIDTH (1), .RESET_VAL (0), .DST_CLK_FREQ_MHZ (1000), .SRC_DATA_FREQ_MHZ (200))
  bitsync_tx_fifo_ready
    (
      .clk      (tx_clock_hrdrst_rx_osc_clk),
      .rst_n    (tx_reset_hrdrst_rx_osc_clk_rst_n),
      .data_in  (tx_fifo_ready),
      .data_out (sync_tx_fifo_ready)
    );

//********************************************************************
// Test bus
//********************************************************************
assign tx_hrdrst_tb_direct     = {tx_fifo_ready, tx_rst_sm_cs[2:0]};

assign tx_hrdrst_testbus[19:0] = {aib_hssi_tx_dll_lock_req,aib_hssi_tx_dcd_cal_req,
				  tx_hrdrst_hssi_tx_transfer_en,tx_hrdrst_hssi_tx_dll_lock,tx_hrdrst_hssi_tx_dcd_cal_done,tx_hrdrst_hssi_tx_fifo_srst,tx_hrdrst_speed_chg_srst,tx_hrdrst_hssi_tx_dll_lock_req,tx_hrdrst_hssi_tx_dcd_cal_req,
				  sr_fabric_tx_transfer_en,sync_tx_align_done,sync_aib_hssi_tx_dll_lock,sr_fabric_tx_dcd_cal_done,sync_aib_hssi_tx_dcd_cal_done,sr_pld_tx_dll_lock_req,sync_rx_asn_dll_lock_en,
				  //sync_rx_asn_rate_change_in_progress,
				  tx_rst_sm_cs[2:0],tx_rst_sm_cs_chg};

//********************************************************************
// ASN
//********************************************************************
always @ (negedge tx_reset_hrdrst_rx_osc_clk_rst_n or posedge tx_clock_hrdrst_rx_osc_clk)
begin
        if (~tx_reset_hrdrst_rx_osc_clk_rst_n)
        begin
                sync_rx_asn_fifo_hold_reg <= 1'b0;
                tx_hrdrst_speed_chg_srst <= 1'b0;
        end
        else
        begin
                sync_rx_asn_fifo_hold_reg <= sync_rx_asn_fifo_hold;
                tx_hrdrst_speed_chg_srst <= (sync_rx_asn_fifo_hold && ~sync_rx_asn_fifo_hold_reg) || (tx_hrdrst_speed_chg_srst && (tx_hrdrst_speed_chg_srst_cnt[4:0] != 5'b11111));
      end
  end


// The tx_hrdrst_speed_chg_srst pulse must be long enough to be sampled by FIFO clock domain during PIPE mode, i.e. slowest is 125MHz.
always @ (negedge tx_reset_hrdrst_rx_osc_clk_rst_n or posedge tx_clock_hrdrst_rx_osc_clk)
begin
        if (~tx_reset_hrdrst_rx_osc_clk_rst_n)
        begin
                tx_hrdrst_speed_chg_srst_cnt[4:0] <= 5'b00000;
        end
        else
        begin
                if (tx_hrdrst_speed_chg_srst)
                begin
                        tx_hrdrst_speed_chg_srst_cnt[4:0] <= tx_hrdrst_speed_chg_srst_cnt[4:0] + 5'b00001;
                end
                else
                begin
                        tx_hrdrst_speed_chg_srst_cnt[4:0] <= 5'b00000;
                end
      end
  end

//********************************************************************
// FIFO Reset
//********************************************************************
assign tx_hrdrst_tx_fifo_srst = r_tx_hrdrst_user_ctl_en ? sr_pld_hssi_tx_fifo_srst : tx_hrdrst_hssi_tx_fifo_srst_final;

// FIFO Reset when Reset SM is enabled
// From master Reset SM when current channel is master channel
// From master ASN SM when current channel is slave channel
//assign tx_hrdrst_hssi_tx_fifo_srst_final = (r_tx_master_sel == 2'b00) ? tx_hrdrst_hssi_tx_fifo_srst : tx_hrdrst_speed_chg_srst;

// FIFO Reset when Reset SM is enabled
// From master Reset SM when current channel Reset SM & FIFO logic are configured as individual channel.
// From master Reset SM when current channel Reset SM is configured as master channel. FIFO logic can be individual or master channel.
// From AIB DLL lock when current channel Reset SM is configured as slave channel & FIFO logic is configured as individual channel.
// From master ASN SM when current channel Reset SM & FIFO logic are configured as slave channel.
//assign tx_hrdrst_hssi_tx_fifo_srst_final = ((r_tx_master_sel == 2'b00) || (r_tx_indv == 1'b1)) ? tx_hrdrst_hssi_tx_fifo_srst : tx_hrdrst_speed_chg_srst;
assign tx_hrdrst_hssi_tx_fifo_srst_final = ((r_tx_master_sel != 2'b00) && (r_tx_indv == 1'b1)) ? (~sync_aib_hssi_tx_dll_lock && ~r_tx_hrdrst_dll_lock_bypass) : 
					   ((r_tx_master_sel == 2'b00) ? tx_hrdrst_hssi_tx_fifo_srst : tx_hrdrst_speed_chg_srst);

//********************************************************************
// Tx Reset State Machine Bonding Input Output - Tx DCD Cal
//********************************************************************
assign bond_tx_hrdrst_ds_in_hssi_tx_dcd_cal_done_int = r_tx_bonding_dft_in_en ? r_tx_bonding_dft_in_value : bond_tx_hrdrst_ds_in_hssi_tx_dcd_cal_done;
assign bond_tx_hrdrst_us_in_hssi_tx_dcd_cal_done_int = r_tx_bonding_dft_in_en ? r_tx_bonding_dft_in_value : bond_tx_hrdrst_us_in_hssi_tx_dcd_cal_done;
assign bond_tx_hrdrst_ds_in_hssi_tx_dcd_cal_req_int = r_tx_bonding_dft_in_en ? r_tx_bonding_dft_in_value : bond_tx_hrdrst_ds_in_hssi_tx_dcd_cal_req;
assign bond_tx_hrdrst_us_in_hssi_tx_dcd_cal_req_int = r_tx_bonding_dft_in_en ? r_tx_bonding_dft_in_value : bond_tx_hrdrst_us_in_hssi_tx_dcd_cal_req;

// c3aibadapt_cmn_cp_dist_pair
//     #(
//         .ASYNC_RESET_VAL(0),
//         .WIDTH(1)               // Control width
//     ) cmn_cp_dist_pair_hssi_tx_dcd_cal_req
//     (
//         .clk(1'b0),                                             // clock
//         .rst_n(1'b1),                                           // async reset
//         .srst_n(1'b1),                                          // sync reset
//         .data_enable(1'b1),                                     // data enable / data valid
//         .master_in(tx_hrdrst_hssi_tx_dcd_cal_req),              // master control signal
//         .us_in(bond_tx_hrdrst_us_in_hssi_tx_dcd_cal_req_int),   // CP distributed signal in up
//         .ds_in(bond_tx_hrdrst_ds_in_hssi_tx_dcd_cal_req_int),   // CP distributed signal in dwn
//         .r_us_master(r_tx_dist_master_sel),                     // CRAM to control master or distributed up
//         .r_ds_master(r_tx_dist_master_sel),                     // CRAM to control master or distributed dwn
//         .r_us_bypass_pipeln(1'b1),                              // CRAM combo or registered up
//         .r_ds_bypass_pipeln(1'b1),                              // CRAM combo or registered dwn
//         .us_out(bond_tx_hrdrst_us_out_hssi_tx_dcd_cal_req),     // CP distributed signal out up
//         .ds_out(bond_tx_hrdrst_ds_out_hssi_tx_dcd_cal_req),     // CP distributed signal out dwn
//         .ds_tap(tx_hrdrst_hssi_tx_dcd_cal_req_chnl_down),       // CP output for this channel dwn
//         .us_tap(tx_hrdrst_hssi_tx_dcd_cal_req_chnl_up)          // CP output for this channel up
//     );
// 
//assign aib_hssi_tx_dcd_cal_req = r_tx_hrdrst_rst_sm_dis ? sr_aib_hssi_tx_dcd_cal_req : tx_hrdrst_hssi_tx_dcd_cal_req_final;
assign aib_hssi_tx_dcd_cal_req_int = r_tx_hrdrst_user_ctl_en ? sr_aib_hssi_tx_dcd_cal_req : tx_hrdrst_hssi_tx_dcd_cal_req_final;
assign tx_hrdrst_hssi_tx_dcd_cal_req_final = tx_hrdrst_hssi_tx_dcd_cal_req;


assign tx_hrdrst_hssi_tx_dcd_cal_done_chnl_down = r_tx_ds_last_chnl ? 1'b1 : bond_tx_hrdrst_ds_in_hssi_tx_dcd_cal_done_int;
assign tx_hrdrst_hssi_tx_dcd_cal_done_chnl_up   = r_tx_us_last_chnl ? 1'b1 : bond_tx_hrdrst_us_in_hssi_tx_dcd_cal_done_int;

// assign bond_tx_hrdrst_us_out_hssi_tx_dcd_cal_done = aib_hssi_tx_dcd_cal_done & tx_hrdrst_hssi_tx_dcd_cal_done_chnl_down;
// assign bond_tx_hrdrst_ds_out_hssi_tx_dcd_cal_done = aib_hssi_tx_dcd_cal_done & tx_hrdrst_hssi_tx_dcd_cal_done_chnl_up;

assign aib_hssi_tx_dcd_cal_done_int = (aib_hssi_tx_dcd_cal_done & tx_hrdrst_hssi_tx_dcd_cal_done_chnl_up & tx_hrdrst_hssi_tx_dcd_cal_done_chnl_down);
//********************************************************************
// Tx Reset State Machine Bonding Input Output - Tx DLL Lock
//********************************************************************
assign bond_tx_hrdrst_ds_in_hssi_tx_dll_lock_int = r_tx_bonding_dft_in_en ? r_tx_bonding_dft_in_value : bond_tx_hrdrst_ds_in_hssi_tx_dll_lock;
assign bond_tx_hrdrst_us_in_hssi_tx_dll_lock_int = r_tx_bonding_dft_in_en ? r_tx_bonding_dft_in_value : bond_tx_hrdrst_us_in_hssi_tx_dll_lock;

assign bond_tx_hrdrst_ds_in_hssi_tx_dll_lock_req_int = r_tx_bonding_dft_in_en ? r_tx_bonding_dft_in_value : bond_tx_hrdrst_ds_in_hssi_tx_dll_lock_req;
assign bond_tx_hrdrst_us_in_hssi_tx_dll_lock_req_int = r_tx_bonding_dft_in_en ? r_tx_bonding_dft_in_value : bond_tx_hrdrst_us_in_hssi_tx_dll_lock_req;

// c3aibadapt_cmn_cp_dist_pair
//     #(
//         .ASYNC_RESET_VAL(0),
//         .WIDTH(1)               // Control width
//     ) cmn_cp_dist_pair_hssi_tx_dll_lock_req
//     (
//         .clk(1'b0),                                             // clock
//         .rst_n(1'b1),                                           // async reset
//         .srst_n(1'b1),                                          // sync reset
//         .data_enable(1'b1),                                     // data enable / data valid
//         .master_in(tx_hrdrst_hssi_tx_dll_lock_req),                       // master control signal
//         .us_in(bond_tx_hrdrst_us_in_hssi_tx_dll_lock_req_int),                // CP distributed signal in up
//         .ds_in(bond_tx_hrdrst_ds_in_hssi_tx_dll_lock_req_int),                // CP distributed signal in dwn
//         .r_us_master(r_tx_dist_master_sel),                 // CRAM to control master or distributed up
//         .r_ds_master(r_tx_dist_master_sel),                 // CRAM to control master or distributed dwn
//         .r_us_bypass_pipeln(1'b1),                              // CRAM combo or registered up
//         .r_ds_bypass_pipeln(1'b1),                              // CRAM combo or registered dwn
//         .us_out(bond_tx_hrdrst_us_out_hssi_tx_dll_lock_req),                  // CP distributed signal out up
//         .ds_out(bond_tx_hrdrst_ds_out_hssi_tx_dll_lock_req),                  // CP distributed signal out dwn
//         .ds_tap(tx_hrdrst_hssi_tx_dll_lock_req_chnl_down),    // CP output for this channel dwn
//         .us_tap(tx_hrdrst_hssi_tx_dll_lock_req_chnl_up)       // CP output for this channel up
//     );
// 
//assign aib_hssi_tx_dll_lock_req = r_tx_hrdrst_rst_sm_dis ? sr_aib_hssi_tx_dll_lock_req : tx_hrdrst_hssi_tx_dll_lock_req_final;
assign aib_hssi_tx_dll_lock_req_int = r_tx_hrdrst_user_ctl_en ? sr_aib_hssi_tx_dll_lock_req : tx_hrdrst_hssi_tx_dll_lock_req_final;
assign tx_hrdrst_hssi_tx_dll_lock_req_final = tx_hrdrst_hssi_tx_dll_lock_req;

assign tx_hrdrst_hssi_tx_dll_lock_chnl_down = r_tx_ds_last_chnl ? 1'b1 : bond_tx_hrdrst_ds_in_hssi_tx_dll_lock_int;
assign tx_hrdrst_hssi_tx_dll_lock_chnl_up   = r_tx_us_last_chnl ? 1'b1 : bond_tx_hrdrst_us_in_hssi_tx_dll_lock_int;

// Poll for the AIB lock status from current channel when current channel Reset SM & FIFO logic are configured as individual channel.
// Consolidate the AIB lock status from bonded channels when current channel Reset SM is configured as master channel. FIFO logic can be individual or master channel.
// Poll for the AIB lock status from current channel when current channel Reset SM is configured as slave channel & FIFO logic is configured as individual channel.
assign aib_hssi_tx_dll_lock_int = ((r_tx_master_sel != 2'b00) && (r_tx_indv == 1'b1)) ? aib_hssi_tx_dll_lock 
                                                                                      : (aib_hssi_tx_dll_lock & tx_hrdrst_hssi_tx_dll_lock_chnl_up & tx_hrdrst_hssi_tx_dll_lock_chnl_down);

// assign bond_tx_hrdrst_us_out_hssi_tx_dll_lock = aib_hssi_tx_dll_lock & tx_hrdrst_hssi_tx_dll_lock_chnl_down;
// assign bond_tx_hrdrst_ds_out_hssi_tx_dll_lock = aib_hssi_tx_dll_lock & tx_hrdrst_hssi_tx_dll_lock_chnl_up;

//********************************************************************
// Tx Reset State Machine Output
//********************************************************************

assign tx_hrdrst_hssi_tx_dcd_cal_req_pre = tx_hrdrst_hssi_tx_dcd_cal_req_comb;

assign tx_hrdrst_hssi_tx_dll_lock_req_pre = tx_hrdrst_hssi_tx_dll_lock_req_comb;

// Generate asynchronous reset during non PCIe rate change.
// Bypass Tx Reset State Machine if Reset State Machine is diabled.
//assign tx_hrdrst_hssi_tx_async_rst_pre = r_tx_hrdrst_rst_sm_dis ? (~sync_rx_asn_rate_change_in_progress & ~sync_aib_hssi_tx_dll_lock && ~r_tx_hrdrst_dll_lock_bypass) :
//                                                                  (~sync_rx_asn_rate_change_in_progress & tx_hrdrst_hssi_tx_rst_comb);

// Generate synchronous reset to FIFO during PCIe rate change.
// Bypass Tx Reset State Machine if Reset State Machine is diabled.
//assign tx_hrdrst_hssi_tx_fifo_srst_pre = r_tx_hrdrst_rst_sm_dis ? (sync_rx_asn_rate_change_in_progress & ~sync_aib_hssi_tx_dll_lock && ~r_tx_hrdrst_dll_lock_bypass) :
//                                                                  (sync_rx_asn_rate_change_in_progress & tx_hrdrst_hssi_tx_rst_comb);
//assign tx_hrdrst_hssi_tx_fifo_srst_pre = r_tx_hrdrst_user_ctl_en ? (~sync_aib_hssi_tx_dll_lock && ~r_tx_hrdrst_dll_lock_bypass): tx_hrdrst_hssi_tx_rst_comb; 

// From master Reset SM when current channel Reset SM & FIFO logic are configured as individual channel.
// From master Reset SM when current channel Reset SM is configured as master channel. FIFO logic can be individual or master channel.
// From AIB DLL lock when current channel Reset SM is configured as slave channel & FIFO logic is configured as individual channel.
assign tx_hrdrst_hssi_tx_fifo_srst_pre = tx_hrdrst_hssi_tx_rst_comb; 
//assign tx_hrdrst_hssi_tx_fifo_srst_pre = ((r_tx_master_sel != 2'b00) && (r_tx_indv == 1'b1)) ? (~sync_aib_hssi_tx_dll_lock && ~r_tx_hrdrst_dll_lock_bypass) : tx_hrdrst_hssi_tx_rst_comb; 

assign tx_hrdrst_hssi_tx_dcd_cal_done_pre = tx_hrdrst_hssi_tx_dcd_cal_done_comb;

// Bypass Tx Reset State Machine if Reset State Machine is diabled.
//assign tx_hrdrst_hssi_tx_dll_lock_pre = r_tx_hrdrst_rst_sm_dis ? (sync_aib_hssi_tx_dll_lock || r_tx_hrdrst_dll_lock_bypass) : tx_hrdrst_hssi_tx_dll_lock_comb;
//assign tx_hrdrst_hssi_tx_dll_lock_pre = r_tx_hrdrst_user_ctl_en ? (sync_aib_hssi_tx_dll_lock || r_tx_hrdrst_dll_lock_bypass) : tx_hrdrst_hssi_tx_dll_lock_comb;
assign tx_hrdrst_hssi_tx_dll_lock_pre = tx_hrdrst_hssi_tx_dll_lock_comb;

// Bypass Tx Reset State Machine if Reset State Machine is diabled.
//assign tx_hrdrst_hssi_tx_transfer_en_pre = r_tx_hrdrst_rst_sm_dis ? ((sync_aib_hssi_tx_dll_lock || r_tx_hrdrst_dll_lock_bypass) && (sync_tx_align_done || r_tx_hrdrst_align_bypass)) : 
//assign tx_hrdrst_hssi_tx_transfer_en_pre = r_tx_hrdrst_user_ctl_en ? ((sync_aib_hssi_tx_dll_lock || r_tx_hrdrst_dll_lock_bypass) && (sync_tx_align_done || r_tx_hrdrst_align_bypass)) : 
//								    tx_hrdrst_hssi_tx_transfer_en_comb;
assign tx_hrdrst_hssi_tx_transfer_en_pre = tx_hrdrst_hssi_tx_transfer_en_comb;


always @ (negedge tx_reset_hrdrst_rx_osc_clk_rst_n or posedge tx_clock_hrdrst_rx_osc_clk)
begin
	if (~tx_reset_hrdrst_rx_osc_clk_rst_n)
	begin
		tx_hrdrst_hssi_tx_dcd_cal_req <= 1'b0;
		tx_hrdrst_hssi_tx_dll_lock_req <= 1'b0;
		//tx_hrdrst_hssi_tx_async_rst <= 1'b1;
		//tx_hrdrst_hssi_tx_fifo_srst <= 1'b0;
		tx_hrdrst_hssi_tx_fifo_srst <= 1'b1;
		tx_hrdrst_hssi_tx_dcd_cal_done <= 1'b0;
		tx_hrdrst_hssi_tx_dll_lock <= 1'b0;	
		tx_hrdrst_hssi_tx_transfer_en <= 1'b0;
	end
	else
	begin
		tx_hrdrst_hssi_tx_dcd_cal_req <= tx_hrdrst_hssi_tx_dcd_cal_req_pre; 
		tx_hrdrst_hssi_tx_dll_lock_req <= tx_hrdrst_hssi_tx_dll_lock_req_pre;
		//tx_hrdrst_hssi_tx_async_rst <= tx_hrdrst_hssi_tx_async_rst_pre;
		tx_hrdrst_hssi_tx_fifo_srst <= tx_hrdrst_hssi_tx_fifo_srst_pre;
		tx_hrdrst_hssi_tx_dcd_cal_done <= tx_hrdrst_hssi_tx_dcd_cal_done_pre;
		tx_hrdrst_hssi_tx_dll_lock <= tx_hrdrst_hssi_tx_dll_lock_pre; 
		tx_hrdrst_hssi_tx_transfer_en <= tx_hrdrst_hssi_tx_transfer_en_pre; 
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
		tx_rst_sm_cs_reg <= WAIT_TX_TRANSFER_REQ;
	end
	else if (~avmm_hrdrst_hssi_osc_transfer_alive  || r_tx_hrdrst_rst_sm_dis || r_tx_hrdrst_user_ctl_en)
	begin
		tx_rst_sm_cs <= WAIT_TX_TRANSFER_REQ;
		tx_rst_sm_cs_reg <= WAIT_TX_TRANSFER_REQ;
	end
	else 
	begin
		tx_rst_sm_cs <= tx_rst_sm_ns;
		tx_rst_sm_cs_reg <= tx_rst_sm_cs;
	end
end

always @(negedge tx_reset_hrdrst_rx_osc_clk_rst_n or posedge tx_clock_hrdrst_rx_osc_clk) 
begin
	if (~tx_reset_hrdrst_rx_osc_clk_rst_n) 
	begin
		tx_rst_sm_cs_chg <= 1'b0;
	end
	else if (~avmm_hrdrst_hssi_osc_transfer_alive  || r_tx_hrdrst_rst_sm_dis || r_tx_hrdrst_user_ctl_en)
	begin
		tx_rst_sm_cs_chg <= 1'b0;
	end
	else if (tx_rst_sm_cs != tx_rst_sm_cs_reg)
	begin
		tx_rst_sm_cs_chg <= ~tx_rst_sm_cs_chg;
	end
end


always @ (*)
begin
	tx_rst_sm_ns = tx_rst_sm_cs;
	tx_hrdrst_hssi_tx_dcd_cal_req_comb = 1'b0;
	tx_hrdrst_hssi_tx_dll_lock_req_comb = 1'b0;
	tx_hrdrst_hssi_tx_dcd_cal_done_comb = 1'b0;
	tx_hrdrst_hssi_tx_dll_lock_comb = 1'b0;
	tx_hrdrst_hssi_tx_rst_comb = 1'b1;
	tx_hrdrst_hssi_tx_transfer_en_comb = 1'b0;
    
	case(tx_rst_sm_cs)
	WAIT_TX_TRANSFER_REQ: 
	begin
		if(sr_pld_tx_dll_lock_req && ~sync_aib_hssi_tx_dcd_cal_done && ~sync_aib_hssi_tx_dll_lock)
		begin
                	tx_rst_sm_ns  = SEND_TX_DCD_CAL_REQ;
		end
        end
        
	SEND_TX_DCD_CAL_REQ:
        begin
		tx_hrdrst_hssi_tx_dcd_cal_req_comb = 1'b1;
		if(sync_aib_hssi_tx_dcd_cal_done || r_tx_hrdrst_dcd_cal_done_bypass)
		begin
			tx_rst_sm_ns = WAIT_REMOTE_TX_DCD_CAL_DONE;
		end
        end
      
	WAIT_REMOTE_TX_DCD_CAL_DONE:
        begin
		tx_hrdrst_hssi_tx_dcd_cal_req_comb = 1'b1;
		tx_hrdrst_hssi_tx_dcd_cal_done_comb = 1'b1;
              	if (sr_fabric_tx_dcd_cal_done)
                begin
                	tx_rst_sm_ns = SEND_TX_DLL_LOCK_REQ;
            	end
        end

	SEND_TX_DLL_LOCK_REQ:
        begin
		tx_hrdrst_hssi_tx_dcd_cal_req_comb = 1'b1;
		tx_hrdrst_hssi_tx_dll_lock_req_comb = 1'b1;
		if(sync_aib_hssi_tx_dll_lock || r_tx_hrdrst_dll_lock_bypass)
		begin
			tx_rst_sm_ns = WAIT_TX_ALIGN_DONE;
		end
        end
      
	WAIT_TX_ALIGN_DONE:
        begin
		tx_hrdrst_hssi_tx_dcd_cal_req_comb = 1'b1;
		tx_hrdrst_hssi_tx_dll_lock_req_comb = 1'b1;
		tx_hrdrst_hssi_tx_dll_lock_comb = 1'b1;
		tx_hrdrst_hssi_tx_rst_comb = 1'b0;
              	if ((sync_tx_align_done || r_tx_hrdrst_align_bypass) && sync_tx_fifo_ready)
                begin
                	tx_rst_sm_ns = TX_TRANSFER_EN;
            	end
        end

      	TX_TRANSFER_EN:
        begin
		tx_hrdrst_hssi_tx_dcd_cal_req_comb = 1'b1;
		tx_hrdrst_hssi_tx_dll_lock_req_comb = 1'b1;
		tx_hrdrst_hssi_tx_dll_lock_comb = 1'b1;
		tx_hrdrst_hssi_tx_rst_comb = 1'b0;
		tx_hrdrst_hssi_tx_transfer_en_comb = 1'b1;
              	if (~sr_pld_tx_dll_lock_req)
                begin
                	tx_rst_sm_ns = WAIT_TX_TRANSFER_REQ;
            	end
        end

	default: 
        begin
		tx_rst_sm_ns = WAIT_TX_TRANSFER_REQ;
		tx_hrdrst_hssi_tx_dcd_cal_req_comb = 1'b0;
		tx_hrdrst_hssi_tx_dll_lock_req_comb = 1'b0;
		tx_hrdrst_hssi_tx_dcd_cal_done_comb = 1'b0;
		tx_hrdrst_hssi_tx_dll_lock_comb = 1'b0;
		tx_hrdrst_hssi_tx_rst_comb = 1'b1;
		tx_hrdrst_hssi_tx_transfer_en_comb = 1'b0;
        end
      endcase
  end

endmodule // c3aibadapt_txrst_ctl

