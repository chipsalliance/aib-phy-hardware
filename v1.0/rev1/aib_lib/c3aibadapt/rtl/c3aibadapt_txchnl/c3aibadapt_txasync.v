// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3aibadapt_txasync
(
        // DPRIO
        input   wire            r_tx_async_pld_txelecidle_rst_val,
        input   wire            r_tx_async_hip_aib_fsr_in_bit0_rst_val,
        input   wire            r_tx_async_hip_aib_fsr_in_bit1_rst_val,
        input   wire            r_tx_async_hip_aib_fsr_in_bit2_rst_val,
        input   wire            r_tx_async_hip_aib_fsr_in_bit3_rst_val,
        input   wire            r_tx_async_pld_pmaif_mask_tx_pll_rst_val,
        input   wire            r_tx_async_hip_aib_fsr_out_bit0_rst_val,
        input   wire            r_tx_async_hip_aib_fsr_out_bit1_rst_val,
        input   wire            r_tx_async_hip_aib_fsr_out_bit2_rst_val,
        input   wire            r_tx_async_hip_aib_fsr_out_bit3_rst_val,
        input   wire            r_txchnl_dp_map_rxqpi_pullup_init_val,

	// AIB_IF
	input	wire		aib_hssi_pld_pma_txdetectrx,

	// PCS_IF
	input	wire		pld_krfec_tx_alignment,
	input	wire		pld_pma_fpll_clk0bad,
	input	wire		pld_pma_fpll_clk1bad,
	input	wire		pld_pma_fpll_clksel,
//	input	wire		pld_pma_fpll_lc_lock,
	input	wire		pld_pma_fpll_phase_done,
	input	wire		pld_pmaif_mask_tx_pll,
 
        // FPLL 
        input   wire   [4:4]    pcs_fpll_shared_direct_async_in,

        // HIP IF
        input   wire   [3:0]    hip_aib_fsr_out,
        input   wire   [7:0]    hip_aib_ssr_out,

	// SR
	input	wire		tx_async_fabric_hssi_fsr_data,
	input	wire		tx_async_fabric_hssi_fsr_load,
	input	wire   [35:0]	tx_async_fabric_hssi_ssr_data,
	input	wire		tx_async_fabric_hssi_ssr_load,
        input   wire            tx_async_hssi_fabric_fsr_load,
        input   wire            tx_async_hssi_fabric_ssr_load,
        input   wire   [3:0]    hip_aib_async_fsr_in,
        input   wire   [39:0]   hip_aib_async_ssr_in,
        input   wire   [2:0]    tx_async_fabric_hssi_ssr_reserved, 
 
	// TXCLK_CTL
	input	wire		tx_clock_async_rx_osc_clk,
	input	wire		tx_clock_async_tx_osc_clk,
	input	wire		tx_clock_hip_async_tx_osc_clk,
	input	wire		tx_clock_hip_async_rx_osc_clk,

	// TXRST_CTL
	input	wire		tx_reset_async_rx_osc_clk_rst_n,
	input	wire		tx_reset_async_tx_osc_clk_rst_n,

	// TX_DATAPATH
	input	wire		align_done,
	input	wire		fifo_empty,
	input	wire		fifo_full,
	input	wire		tx_fifo_ready,

        // Reset SM
        input   wire            tx_hrdrst_hssi_tx_dcd_cal_done,
        input   wire            tx_hrdrst_hssi_tx_dll_lock,
        input   wire            tx_hrdrst_hssi_tx_transfer_en,
        input   wire            aib_hssi_tx_dcd_cal_done,
        input   wire            aib_hssi_tx_dll_lock,

        // DFT
        input   wire            dft_adpt_rst,

	// AIB_IF
//	output	wire		aib_hssi_pld_pma_fpll_lc_lock,
        output  wire    [4:4]   aib_hssi_fpll_shared_direct_async_out,

	// PCS_IF
	output	wire	[6:0]	pld_10g_tx_bitslip,
	output	wire	[4:0]	pld_8g_tx_boundary_sel,
	output	wire		pld_pma_csr_test_dis,
	output	wire	[3:0]	pld_pma_fpll_cnt_sel,
	output	wire		pld_pma_fpll_extswitch,
	output	wire		pld_pma_fpll_lc_csr_test_dis,
	output	wire	[2:0]	pld_pma_fpll_num_phase_shifts,
	output	wire		pld_pma_fpll_pfden,
	output	wire		pld_pma_nrpi_freeze,
	output	wire		pld_pma_tx_bitslip,
	output	wire		pld_pma_txdetectrx,
	output	wire		pld_polinv_tx,
	output	wire		pld_txelecidle,
	output	wire		pld_pma_fpll_up_dn_lc_lf_rstn,
        output  wire            pld_tx_fifo_latency_adj_en,

        // TX Data Mapping Block
        output wire             pld_pma_tx_qpi_pulldn_sr,
        output wire             pld_pma_tx_qpi_pullup_sr,
        output wire             pld_pma_rx_qpi_pullup_sr,

        // Reset SM
        output  wire            sr_fabric_tx_dcd_cal_done,
        output  wire            sr_pld_tx_dll_lock_req,
        output  wire            sr_fabric_tx_transfer_en,
        output  wire            sr_aib_hssi_tx_dcd_cal_req,
        output  wire            sr_aib_hssi_tx_dll_lock_req,
        output  wire            sr_pld_tx_fifo_srst,

        // HIP IF
        output  wire   [3:0]    hip_aib_fsr_in,
        output  wire   [39:0]   hip_aib_ssr_in,

	// SR
        output  wire            tx_fsr_parity_checker_in,
        output  wire   [38:0]   tx_ssr_parity_checker_in,
        output  wire            hip_fsr_parity_checker_in,
        output  wire   [4:0]    hip_ssr_parity_checker_in,

	output	wire		tx_async_hssi_fabric_fsr_data,
	output	wire   [12:0]   tx_async_hssi_fabric_ssr_data,
        output  wire   [3:0]    hip_aib_async_fsr_out,
        output  wire   [7:0]    hip_aib_async_ssr_out,
        output  wire   [2:0]    tx_async_hssi_fabric_ssr_reserved  
);

// update
//assign r_tx_async_pld_txelecidle_rst_val = avmm_tx_user_datain[0];
//assign r_tx_async_hip_aib_fsr_in_bit0_rst_val = avmm_tx_user_datain[1];
//assign r_tx_async_hip_aib_fsr_in_bit1_rst_val = avmm_tx_user_datain[2];
//assign r_tx_async_hip_aib_fsr_in_bit2_rst_val = avmm_tx_user_datain[3];
//assign r_tx_async_hip_aib_fsr_in_bit3_rst_val = avmm_tx_user_datain[4];
// capture
//assign r_tx_async_pld_pmaif_mask_tx_pll_rst_val = avmm_tx_user_datain[5];
//assign r_tx_async_hip_aib_fsr_out_bit0_rst_val = avmm_tx_user_datain[6];
//assign r_tx_async_hip_aib_fsr_out_bit1_rst_val = avmm_tx_user_datain[7];
//assign r_tx_async_hip_aib_fsr_out_bit2_rst_val = avmm_tx_user_datain[8];
//assign r_tx_async_hip_aib_fsr_out_bit3_rst_val = avmm_tx_user_datain[9];
wire [2:0]  pld_tx_ssr_reserved_in;
wire [2:0]  pld_tx_ssr_reserved_out;
wire        pld_pma_txdetectrx_int;
wire        pld_txelecidle_int;
wire [35:0] tx_ssr_parity_checker_in_int;

wire   align_done_int;
wire   fifo_empty_int;
wire   fifo_full_int;
wire   pld_krfec_tx_alignment_int;

// simply tied to 3 SSR inputs
assign pld_tx_ssr_reserved_in = {pld_pma_fpll_clk0bad, pld_pma_fpll_clk1bad, tx_fifo_ready}; 

assign pld_pma_txdetectrx = dft_adpt_rst ? 1'b1 : pld_pma_txdetectrx_int;
assign pld_txelecidle     = dft_adpt_rst ? 1'b1 : pld_txelecidle_int;

assign tx_ssr_parity_checker_in = {pld_tx_ssr_reserved_out,tx_ssr_parity_checker_in_int};

assign sr_pld_tx_fifo_srst = pld_tx_ssr_reserved_out[0];

assign pld_krfec_tx_alignment_int = r_txchnl_dp_map_rxqpi_pullup_init_val ? pld_tx_fifo_latency_adj_en  : pld_krfec_tx_alignment ;
assign align_done_int             = r_txchnl_dp_map_rxqpi_pullup_init_val ? pld_pma_rx_qpi_pullup_sr    : align_done;
assign fifo_empty_int             = r_txchnl_dp_map_rxqpi_pullup_init_val ? sr_aib_hssi_tx_dcd_cal_req  : fifo_empty;
assign fifo_full_int              = r_txchnl_dp_map_rxqpi_pullup_init_val ? sr_aib_hssi_tx_dll_lock_req : fifo_full;
 
c3aibadapt_txasync_rsvd_capture adapt_txasync_rsvd_capture (
       // input
       .pld_tx_ssr_reserved_in          (pld_tx_ssr_reserved_in),
       .tx_async_hssi_fabric_ssr_load   (tx_async_hssi_fabric_ssr_load),
       .tx_clock_async_tx_osc_clk       (tx_clock_async_tx_osc_clk),
       .tx_reset_async_tx_osc_clk_rst_n (tx_reset_async_tx_osc_clk_rst_n),
       // output
       .tx_async_hssi_fabric_ssr_reserved (tx_async_hssi_fabric_ssr_reserved)
);

c3aibadapt_txasync_rsvd_update adapt_txasync_rsvd_update (
       // input
      .tx_async_fabric_hssi_ssr_reserved (tx_async_fabric_hssi_ssr_reserved),
      .tx_async_fabric_hssi_ssr_load     (tx_async_fabric_hssi_ssr_load),
      .tx_clock_async_rx_osc_clk         (tx_clock_async_rx_osc_clk),
      .tx_reset_async_rx_osc_clk_rst_n   (tx_reset_async_rx_osc_clk_rst_n),
      // output
      .pld_tx_ssr_reserved_out           (pld_tx_ssr_reserved_out)
);

c3aibadapt_hip_async_capture adapt_hip_async_capture (
       // input
       .r_tx_async_hip_aib_fsr_out_bit0_rst_val(r_tx_async_hip_aib_fsr_out_bit0_rst_val),
       .r_tx_async_hip_aib_fsr_out_bit1_rst_val(r_tx_async_hip_aib_fsr_out_bit1_rst_val),
       .r_tx_async_hip_aib_fsr_out_bit2_rst_val(r_tx_async_hip_aib_fsr_out_bit2_rst_val),
       .r_tx_async_hip_aib_fsr_out_bit3_rst_val(r_tx_async_hip_aib_fsr_out_bit3_rst_val),
       .hip_aib_fsr_out                 (hip_aib_fsr_out),
       .hip_aib_ssr_out                 (hip_aib_ssr_out),
       .tx_async_hssi_fabric_fsr_load   (tx_async_hssi_fabric_fsr_load),
       .tx_async_hssi_fabric_ssr_load   (tx_async_hssi_fabric_ssr_load),
       .tx_clock_async_tx_osc_clk      (tx_clock_hip_async_tx_osc_clk),
       .tx_reset_async_tx_osc_clk_rst_n(tx_reset_async_tx_osc_clk_rst_n),
       // output
       .hip_aib_async_fsr_out           (hip_aib_async_fsr_out),
       .hip_aib_async_ssr_out           (hip_aib_async_ssr_out)
);

c3aibadapt_hip_async_update adapt_hip_async_update (
       // input
      .r_tx_async_hip_aib_fsr_in_bit0_rst_val(r_tx_async_hip_aib_fsr_in_bit0_rst_val),
      .r_tx_async_hip_aib_fsr_in_bit1_rst_val(r_tx_async_hip_aib_fsr_in_bit1_rst_val),
      .r_tx_async_hip_aib_fsr_in_bit2_rst_val(r_tx_async_hip_aib_fsr_in_bit2_rst_val),
      .r_tx_async_hip_aib_fsr_in_bit3_rst_val(r_tx_async_hip_aib_fsr_in_bit3_rst_val),
      .tx_async_fabric_hssi_fsr_load     (tx_async_fabric_hssi_fsr_load),
      .tx_async_fabric_hssi_ssr_load     (tx_async_fabric_hssi_ssr_load),
      .hip_aib_async_fsr_in              (hip_aib_async_fsr_in),
      .hip_aib_async_ssr_in              (hip_aib_async_ssr_in),
      .tx_clock_async_rx_osc_clk         (tx_clock_hip_async_rx_osc_clk),
      .tx_reset_async_rx_osc_clk_rst_n   (tx_reset_async_rx_osc_clk_rst_n),
      // output
      .hip_fsr_parity_checker_in         (hip_fsr_parity_checker_in),
      .hip_ssr_parity_checker_in         (hip_ssr_parity_checker_in),
      .hip_aib_fsr_in                    (hip_aib_fsr_in),
      .hip_aib_ssr_in                    (hip_aib_ssr_in)
);

c3aibadapt_txasync_capture adapt_txasync_capture (
        // input
        .pld_krfec_tx_alignment        (pld_krfec_tx_alignment_int),
        .pld_pma_fpll_clk0bad          (pld_pma_fpll_clk0bad),
        .pld_pma_fpll_clk1bad          (pld_pma_fpll_clk1bad),
        .pld_pma_fpll_clksel           (pld_pma_fpll_clksel),
        .pld_pma_fpll_phase_done       (pld_pma_fpll_phase_done),
        .pld_pmaif_mask_tx_pll         (pld_pmaif_mask_tx_pll),
        .tx_async_hssi_fabric_fsr_load (tx_async_hssi_fabric_fsr_load),
        .tx_async_hssi_fabric_ssr_load (tx_async_hssi_fabric_ssr_load),
        .tx_clock_async_tx_osc_clk    (tx_clock_async_tx_osc_clk),           
        .tx_reset_async_tx_osc_clk_rst_n (tx_reset_async_tx_osc_clk_rst_n),  
        .align_done                    (align_done_int),
        .fifo_empty                    (fifo_empty_int),
        .fifo_full                     (fifo_full_int),
        .tx_hrdrst_hssi_tx_dcd_cal_done(tx_hrdrst_hssi_tx_dcd_cal_done),
        .tx_hrdrst_hssi_tx_dll_lock    (tx_hrdrst_hssi_tx_dll_lock),
        .tx_hrdrst_hssi_tx_transfer_en (tx_hrdrst_hssi_tx_transfer_en),
        .aib_hssi_tx_dcd_cal_done      (aib_hssi_tx_dcd_cal_done),
        .aib_hssi_tx_dll_lock          (aib_hssi_tx_dll_lock),
        .r_tx_async_pld_pmaif_mask_tx_pll_rst_val (r_tx_async_pld_pmaif_mask_tx_pll_rst_val),
        // output 
        .tx_async_hssi_fabric_fsr_data (tx_async_hssi_fabric_fsr_data), 
        .tx_async_hssi_fabric_ssr_data (tx_async_hssi_fabric_ssr_data)  
);

c3aibadapt_txasync_update adapt_txasync_update(
        //input
       .tx_async_fabric_hssi_fsr_data  (tx_async_fabric_hssi_fsr_data),
       .tx_async_fabric_hssi_fsr_load  (tx_async_fabric_hssi_fsr_load),
       .tx_async_fabric_hssi_ssr_data  (tx_async_fabric_hssi_ssr_data),
       .tx_async_fabric_hssi_ssr_load  (tx_async_fabric_hssi_ssr_load),
       .tx_clock_async_rx_osc_clk      (tx_clock_async_rx_osc_clk),
       .tx_reset_async_rx_osc_clk_rst_n(tx_reset_async_rx_osc_clk_rst_n),
       .r_tx_async_pld_txelecidle_rst_val (r_tx_async_pld_txelecidle_rst_val),
       // output
       .tx_fsr_parity_checker_in       (tx_fsr_parity_checker_in),
       .tx_ssr_parity_checker_in       (tx_ssr_parity_checker_in_int),
       .pld_8g_tx_boundary_sel         (pld_8g_tx_boundary_sel),
       .pld_10g_tx_bitslip             (pld_10g_tx_bitslip),
       .pld_pma_csr_test_dis           (pld_pma_csr_test_dis),
       .pld_pma_fpll_cnt_sel           (pld_pma_fpll_cnt_sel),
       .pld_pma_fpll_extswitch         (pld_pma_fpll_extswitch),
       .pld_pma_fpll_num_phase_shifts  (pld_pma_fpll_num_phase_shifts),
       .pld_pma_fpll_pfden             (pld_pma_fpll_pfden),
       .pld_pma_fpll_up_dn_lc_lf_rstn  (pld_pma_fpll_up_dn_lc_lf_rstn),
       .pld_pma_fpll_lc_csr_test_dis   (pld_pma_fpll_lc_csr_test_dis),
       .pld_pma_nrpi_freeze            (pld_pma_nrpi_freeze),
       .pld_pma_tx_bitslip             (pld_pma_tx_bitslip),
       .pld_polinv_tx                  (pld_polinv_tx),
       .pld_txelecidle                 (pld_txelecidle_int),
       .pld_tx_fifo_latency_adj_en     (pld_tx_fifo_latency_adj_en),
       .pld_pma_tx_qpi_pulldn_sr       (pld_pma_tx_qpi_pulldn_sr),
       .pld_pma_tx_qpi_pullup_sr       (pld_pma_tx_qpi_pullup_sr),
       .pld_pma_rx_qpi_pullup_sr       (pld_pma_rx_qpi_pullup_sr),
       .sr_fabric_tx_dcd_cal_done      (sr_fabric_tx_dcd_cal_done),
       .sr_pld_tx_dll_lock_req         (sr_pld_tx_dll_lock_req),
       .sr_fabric_tx_transfer_en       (sr_fabric_tx_transfer_en),
       .sr_aib_hssi_tx_dcd_cal_req     (sr_aib_hssi_tx_dcd_cal_req),
       .sr_aib_hssi_tx_dll_lock_req    (sr_aib_hssi_tx_dll_lock_req)
);

c3aibadapt_txasync_direct adapt_txasync_direct (
       // input
       .pld_pma_fpll_lc_lock         (pcs_fpll_shared_direct_async_in[4]),
       .aib_hssi_pld_pma_txdetectrx  (aib_hssi_pld_pma_txdetectrx),
       // output
       .pld_pma_txdetectrx           (pld_pma_txdetectrx_int),
       .aib_hssi_pld_pma_fpll_lc_lock(aib_hssi_fpll_shared_direct_async_out[4])
);

endmodule
