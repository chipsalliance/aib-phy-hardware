// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module hdpldadapt_tx_async 
(

	// AIB_IF
//	input	wire		aib_fabric_pld_pma_fpll_lc_lock,
        input   wire   [4:4]    aib_fabric_fpll_shared_direct_async_in,

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
        input   wire    [3:0]   r_tx_hip_aib_ssr_in_polling_bypass,
        input  wire             r_tx_pld_8g_tx_boundary_sel_polling_bypass,
        input  wire             r_tx_pld_10g_tx_bitslip_polling_bypass,
        input  wire             r_tx_pld_pma_fpll_cnt_sel_polling_bypass,
        input  wire             r_tx_pld_pma_fpll_num_phase_shifts_polling_bypass,

        // SSM
        input   wire            nfrzdrv_in,
        input   wire            usermode_in,

	// PLD_IF
	input	wire	[6:0]	pld_10g_tx_bitslip,
	input	wire	[4:0]	pld_8g_tx_boundary_sel,
	input	wire		pld_pma_csr_test_dis,
	input	wire	[3:0]	pld_pma_fpll_cnt_sel,
	input	wire		pld_pma_fpll_extswitch,
	input	wire		pld_pma_fpll_lc_csr_test_dis,
	input	wire	[2:0]	pld_pma_fpll_num_phase_shifts,
	input	wire		pld_pma_fpll_pfden,
	input	wire		pld_pma_nrpi_freeze,
	input	wire		pld_pma_tx_bitslip,
	input	wire		pld_pma_txdetectrx,
	input	wire		pld_polinv_tx,
	input	wire		pld_txelecidle,
	input	wire		pld_pma_fpll_up_dn_lc_lf_rstn,
        input   wire    [3:0]   hip_aib_fsr_in,
        input   wire    [39:0]  hip_aib_ssr_in,
	input	wire		pr_channel_freeze_n,
        input   wire            pld_tx_dll_lock_req,
        input   wire            pld_tx_fifo_latency_adj_en,
        input   wire            pld_aib_hssi_tx_dcd_cal_req,
        input   wire            pld_aib_hssi_tx_dll_lock_req,
        input   wire    [2:0]   pld_tx_ssr_reserved_in,   
        input   wire            pld_pma_tx_qpi_pulldn,
        input   wire            pld_pma_tx_qpi_pullup,
        input   wire            pld_pma_rx_qpi_pullup,

        // Reset SM
        input   wire            tx_hrdrst_fabric_tx_dcd_cal_done,
        input   wire            tx_hrdrst_fabric_tx_transfer_en,

	// SR
	input	wire		tx_async_hssi_fabric_fsr_data,
        input   wire            tx_async_hssi_fabric_fsr_load,
	input	wire	[12:0]  tx_async_hssi_fabric_ssr_data,	
        input   wire            tx_async_hssi_fabric_ssr_load,
        input   wire            tx_async_fabric_hssi_fsr_load,
        input   wire            tx_async_fabric_hssi_ssr_load,
        input   wire    [3:0]   hip_aib_async_fsr_out,
        input   wire    [7:0]   hip_aib_async_ssr_out,
        input   wire    [2:0]   tx_async_hssi_fabric_ssr_reserved,  

        // TXCLK_CTL
        input   wire            tx_clock_async_rx_osc_clk,
        input   wire            tx_clock_async_tx_osc_clk,
        input   wire            tx_clock_hip_async_rx_osc_clk,
        input   wire            tx_clock_hip_async_tx_osc_clk,

        // TXRST_CTL
        input   wire            tx_reset_async_rx_osc_clk_rst_n, 
        input   wire            tx_reset_async_tx_osc_clk_rst_n, 

        // Reset SM 
        output  wire            sr_hssi_tx_dcd_cal_done,
        output  wire            sr_hssi_tx_dll_lock,
        output  wire            sr_hssi_tx_transfer_en,

	// AIB_IF
	output	wire		aib_fabric_pld_pma_txdetectrx,

	// PLD_IF
	output	wire		pld_krfec_tx_alignment,
	output	wire		pld_pma_fpll_clk0bad,
	output	wire		pld_pma_fpll_clk1bad,
	output	wire		pld_pma_fpll_clksel,
//	output	wire		pld_pma_fpll_lc_lock,
	output	wire		pld_pma_fpll_phase_done,
	output	wire		pld_pmaif_mask_tx_pll,
        output  wire            pld_tx_hssi_align_done,
        output  wire            pld_tx_hssi_fifo_full,
        output  wire            pld_tx_hssi_fifo_empty,
        output  wire            pld_aib_hssi_tx_dcd_cal_done,
        output  wire            pld_aib_hssi_tx_dll_lock,
        output  wire    [3:0]   hip_aib_fsr_out,
        output  wire    [7:0]   hip_aib_ssr_out,
        output  wire    [4:4]   pld_fpll_shared_direct_async_out,
        output  wire    [2:0]   pld_tx_ssr_reserved_out,  

        // ASN
        output  wire            rx_fsr_mask_tx_pll,

	// SR
        output  wire            hip_fsr_parity_checker_in,            
        output  wire    [5:0]   hip_ssr_parity_checker_in,     
        output  wire            tx_fsr_parity_checker_in,
        output  wire    [15:0]  tx_ssr_parity_checker_in,      

        output  wire    [3:0]   hip_aib_async_fsr_in,
        output  wire    [39:0]  hip_aib_async_ssr_in,
	output	wire		tx_async_fabric_hssi_fsr_data,
	output	wire    [35:0]  tx_async_fabric_hssi_ssr_data,
        output  wire    [2:0]   tx_async_fabric_hssi_ssr_reserved 

);

//capture
//assign r_tx_async_pld_txelecidle_rst_val = avmm_tx_user_datain[0];
//assign r_tx_async_hip_aib_fsr_in_bit0_rst_val = avmm_tx_user_datain[1];
//assign r_tx_async_hip_aib_fsr_in_bit1_rst_val = avmm_tx_user_datain[2];
//assign r_tx_async_hip_aib_fsr_in_bit2_rst_val = avmm_tx_user_datain[3];
//assign r_tx_async_hip_aib_fsr_in_bit3_rst_val = avmm_tx_user_datain[4];
//update
//assign r_tx_async_pld_pmaif_mask_tx_pll_rst_val = avmm_tx_user_datain[5];
//assign r_tx_async_hip_aib_fsr_out_bit0_rst_val = avmm_tx_user_datain[6];
//assign r_tx_async_hip_aib_fsr_out_bit1_rst_val = avmm_tx_user_datain[7];
//assign r_tx_async_hip_aib_fsr_out_bit2_rst_val = avmm_tx_user_datain[8];
//assign r_tx_async_hip_aib_fsr_out_bit3_rst_val = avmm_tx_user_datain[9];

wire            pld_krfec_tx_alignment_int;
wire            pld_pma_fpll_clk0bad_int;
wire            pld_pma_fpll_clk1bad_int;
wire            pld_pma_fpll_clksel_int;
wire            pld_pma_fpll_phase_done_int;
wire            pld_pmaif_mask_tx_pll_int;
wire            pld_tx_hssi_align_done_int;
wire            pld_tx_hssi_fifo_full_int;
wire            pld_tx_hssi_fifo_empty_int;
wire    [3:0]   hip_aib_fsr_out_int;
wire    [7:0]   hip_aib_ssr_out_int;
wire    [4:4]   pld_fpll_shared_direct_async_out_int;
wire            pld_aib_hssi_tx_dcd_cal_done_int;
wire            pld_aib_hssi_tx_dll_lock_int;
wire    [2:0]   pld_tx_ssr_reserved_out_int;

wire            nfrz_output_2one;
wire    [12:0]  tx_ssr_parity_checker_in_int;
wire            pld_tx_dll_lock_req_int;
wire            pld_aib_hssi_tx_dcd_cal_req_int;
wire            pld_aib_hssi_tx_dll_lock_req_int;

assign nfrz_output_2one  = nfrzdrv_in & pr_channel_freeze_n;  

assign pld_krfec_tx_alignment  = nfrz_output_2one ? pld_krfec_tx_alignment_int  : 1'b1;
assign pld_pma_fpll_clk0bad    = nfrzdrv_in ? pld_pma_fpll_clk0bad_int    : 1'b1;
assign pld_pma_fpll_clk1bad    = nfrzdrv_in ? pld_pma_fpll_clk1bad_int    : 1'b1;
assign pld_pma_fpll_clksel     = nfrzdrv_in ? pld_pma_fpll_clksel_int     : 1'b1;
assign pld_pma_fpll_phase_done = nfrzdrv_in ? pld_pma_fpll_phase_done_int : 1'b1;
assign pld_pmaif_mask_tx_pll   = nfrz_output_2one ? pld_pmaif_mask_tx_pll_int   : 1'b1;
assign pld_tx_hssi_align_done  = nfrz_output_2one ? pld_tx_hssi_align_done_int  : 1'b1;
assign pld_tx_hssi_fifo_full   = nfrz_output_2one ? pld_tx_hssi_fifo_full_int   : 1'b1;
assign pld_tx_hssi_fifo_empty  = nfrz_output_2one ? pld_tx_hssi_fifo_empty_int  : 1'b1;
assign hip_aib_fsr_out         = nfrz_output_2one ? hip_aib_fsr_out_int         : 4'b1111;
assign hip_aib_ssr_out         = nfrz_output_2one ? hip_aib_ssr_out_int         : 8'hFF;
assign pld_fpll_shared_direct_async_out = nfrzdrv_in ? pld_fpll_shared_direct_async_out_int : 1'b1;
assign pld_aib_hssi_tx_dcd_cal_done = nfrz_output_2one ? pld_aib_hssi_tx_dcd_cal_done_int : 1'b1;
assign pld_aib_hssi_tx_dll_lock     = nfrz_output_2one ? pld_aib_hssi_tx_dll_lock_int     : 1'b1;
assign pld_tx_ssr_reserved_out   = nfrz_output_2one ? pld_tx_ssr_reserved_out_int : 3'b111;

assign tx_ssr_parity_checker_in = {pld_tx_ssr_reserved_out_int, tx_ssr_parity_checker_in_int}; 

assign pld_tx_dll_lock_req_int          =  usermode_in & pld_tx_dll_lock_req; 
assign pld_aib_hssi_tx_dcd_cal_req_int  =  usermode_in & pld_aib_hssi_tx_dcd_cal_req;
assign pld_aib_hssi_tx_dll_lock_req_int =  usermode_in & pld_aib_hssi_tx_dll_lock_req;

hdpldadapt_tx_async_reserved_capture hdpldadapt_tx_async_reserved_capture (
      // input
      .tx_async_fabric_hssi_ssr_load     (tx_async_fabric_hssi_ssr_load),
      .tx_clock_async_tx_osc_clk         (tx_clock_async_tx_osc_clk),
      .tx_reset_async_tx_osc_clk_rst_n   (tx_reset_async_tx_osc_clk_rst_n),
      .pld_tx_ssr_reserved_in            (pld_tx_ssr_reserved_in), 
       // output
      .tx_async_fabric_hssi_ssr_reserved (tx_async_fabric_hssi_ssr_reserved)
);

hdpldadapt_tx_async_reserved_update hdpldadapt_tx_async_reserved_update (
       // input
      .tx_clock_async_rx_osc_clk           (tx_clock_async_rx_osc_clk),
      .tx_reset_async_rx_osc_clk_rst_n     (tx_reset_async_rx_osc_clk_rst_n),
      .tx_async_hssi_fabric_ssr_reserved   (tx_async_hssi_fabric_ssr_reserved),
      .tx_async_hssi_fabric_ssr_load       (tx_async_hssi_fabric_ssr_load),
      // output
      .pld_tx_ssr_reserved_out             (pld_tx_ssr_reserved_out_int)
);

hdpldadapt_hip_async_capture hdpldadapt_hip_async_capture (
      // input
      .r_tx_async_hip_aib_fsr_in_bit0_rst_val(r_tx_async_hip_aib_fsr_in_bit0_rst_val),
      .r_tx_async_hip_aib_fsr_in_bit1_rst_val(r_tx_async_hip_aib_fsr_in_bit1_rst_val),
      .r_tx_async_hip_aib_fsr_in_bit2_rst_val(r_tx_async_hip_aib_fsr_in_bit2_rst_val),
      .r_tx_async_hip_aib_fsr_in_bit3_rst_val(r_tx_async_hip_aib_fsr_in_bit3_rst_val),
      .tx_async_fabric_hssi_fsr_load     (tx_async_fabric_hssi_fsr_load),
      .tx_async_fabric_hssi_ssr_load     (tx_async_fabric_hssi_ssr_load),
      .tx_clock_async_tx_osc_clk         (tx_clock_hip_async_tx_osc_clk),
      .tx_reset_async_tx_osc_clk_rst_n   (tx_reset_async_tx_osc_clk_rst_n),
      .hip_aib_fsr_in                    (hip_aib_fsr_in),
      .hip_aib_ssr_in                    (hip_aib_ssr_in),
      .r_tx_hip_aib_ssr_in_polling_bypass (r_tx_hip_aib_ssr_in_polling_bypass),
       // output
      .hip_aib_async_fsr_in              (hip_aib_async_fsr_in),
      .hip_aib_async_ssr_in              (hip_aib_async_ssr_in)
);

hdpldadapt_hip_async_update hdpldadapt_hip_async_update (
       // input
      .r_tx_async_hip_aib_fsr_out_bit0_rst_val(r_tx_async_hip_aib_fsr_out_bit0_rst_val),
      .r_tx_async_hip_aib_fsr_out_bit1_rst_val(r_tx_async_hip_aib_fsr_out_bit1_rst_val),
      .r_tx_async_hip_aib_fsr_out_bit2_rst_val(r_tx_async_hip_aib_fsr_out_bit2_rst_val),
      .r_tx_async_hip_aib_fsr_out_bit3_rst_val(r_tx_async_hip_aib_fsr_out_bit3_rst_val),
      .tx_clock_async_rx_osc_clk           (tx_clock_hip_async_rx_osc_clk),
      .tx_reset_async_rx_osc_clk_rst_n     (tx_reset_async_rx_osc_clk_rst_n),
      .hip_aib_async_fsr_out               (hip_aib_async_fsr_out),
      .hip_aib_async_ssr_out               (hip_aib_async_ssr_out),
      .tx_async_hssi_fabric_fsr_load       (tx_async_hssi_fabric_fsr_load),
      .tx_async_hssi_fabric_ssr_load       (tx_async_hssi_fabric_ssr_load),
      // output
      .hip_fsr_parity_checker_in           (hip_fsr_parity_checker_in),
      .hip_ssr_parity_checker_in           (hip_ssr_parity_checker_in),
      .hip_aib_fsr_out                     (hip_aib_fsr_out_int),
      .hip_aib_ssr_out                     (hip_aib_ssr_out_int)
);

hdpldadapt_tx_async_capture hdpldadapt_tx_async_capture (
       // input
       .tx_async_fabric_hssi_fsr_load   (tx_async_fabric_hssi_fsr_load),
       .tx_async_fabric_hssi_ssr_load   (tx_async_fabric_hssi_ssr_load),
       .tx_clock_async_tx_osc_clk       (tx_clock_async_tx_osc_clk),
       .tx_reset_async_tx_osc_clk_rst_n (tx_reset_async_tx_osc_clk_rst_n),
       .pld_8g_tx_boundary_sel          (pld_8g_tx_boundary_sel),
       .pld_10g_tx_bitslip              (pld_10g_tx_bitslip),
       .pld_pma_csr_test_dis            (pld_pma_csr_test_dis),
       .pld_pma_fpll_cnt_sel            (pld_pma_fpll_cnt_sel),
       .pld_pma_fpll_extswitch          (pld_pma_fpll_extswitch),
       .pld_pma_fpll_num_phase_shifts   (pld_pma_fpll_num_phase_shifts),
       .pld_pma_fpll_pfden              (pld_pma_fpll_pfden),
       .pld_pma_fpll_up_dn_lc_lf_rstn   (pld_pma_fpll_up_dn_lc_lf_rstn),
       .pld_pma_fpll_lc_csr_test_dis    (pld_pma_fpll_lc_csr_test_dis),
       .pld_pma_nrpi_freeze             (pld_pma_nrpi_freeze),
       .pld_pma_tx_bitslip              (pld_pma_tx_bitslip),
       .pld_polinv_tx                   (pld_polinv_tx),
       .pld_txelecidle                  (pld_txelecidle),
       .pld_tx_fifo_latency_adj_en      (pld_tx_fifo_latency_adj_en),
       .pld_aib_hssi_tx_dcd_cal_req     (pld_aib_hssi_tx_dcd_cal_req_int),
       .pld_aib_hssi_tx_dll_lock_req    (pld_aib_hssi_tx_dll_lock_req_int),
       .tx_hrdrst_fabric_tx_dcd_cal_done(tx_hrdrst_fabric_tx_dcd_cal_done),
       .pld_tx_dll_lock_req             (pld_tx_dll_lock_req_int),
       .tx_hrdrst_fabric_tx_transfer_en (tx_hrdrst_fabric_tx_transfer_en),
       .pld_pma_tx_qpi_pulldn           (pld_pma_tx_qpi_pulldn),
       .pld_pma_tx_qpi_pullup           (pld_pma_tx_qpi_pullup),
       .pld_pma_rx_qpi_pullup           (pld_pma_rx_qpi_pullup),
       .r_tx_async_pld_txelecidle_rst_val (r_tx_async_pld_txelecidle_rst_val),
       .r_tx_pld_8g_tx_boundary_sel_polling_bypass          (r_tx_pld_8g_tx_boundary_sel_polling_bypass),
       .r_tx_pld_10g_tx_bitslip_polling_bypass              (r_tx_pld_10g_tx_bitslip_polling_bypass),
       .r_tx_pld_pma_fpll_cnt_sel_polling_bypass            (r_tx_pld_pma_fpll_cnt_sel_polling_bypass),
       .r_tx_pld_pma_fpll_num_phase_shifts_polling_bypass   (r_tx_pld_pma_fpll_num_phase_shifts_polling_bypass),
       // output
       .tx_async_fabric_hssi_fsr_data   (tx_async_fabric_hssi_fsr_data),
       .tx_async_fabric_hssi_ssr_data   (tx_async_fabric_hssi_ssr_data)
);

hdpldadapt_tx_async_update hdpldadapt_tx_async_update (
       // input
       .tx_clock_async_rx_osc_clk       (tx_clock_async_rx_osc_clk),
       .tx_reset_async_rx_osc_clk_rst_n (tx_reset_async_rx_osc_clk_rst_n),
       .tx_async_hssi_fabric_fsr_data   (tx_async_hssi_fabric_fsr_data),
       .tx_async_hssi_fabric_fsr_load   (tx_async_hssi_fabric_fsr_load),
       .tx_async_hssi_fabric_ssr_data   (tx_async_hssi_fabric_ssr_data),
       .tx_async_hssi_fabric_ssr_load   (tx_async_hssi_fabric_ssr_load),
       .r_tx_async_pld_pmaif_mask_tx_pll_rst_val (r_tx_async_pld_pmaif_mask_tx_pll_rst_val),
       // output
       .tx_ssr_parity_checker_in        (tx_ssr_parity_checker_in_int),
       .tx_fsr_parity_checker_in        (tx_fsr_parity_checker_in),
       .pld_krfec_tx_alignment          (pld_krfec_tx_alignment_int),
       .pld_pma_fpll_clk0bad            (pld_pma_fpll_clk0bad_int),
       .pld_pma_fpll_clk1bad            (pld_pma_fpll_clk1bad_int),
       .pld_pma_fpll_clksel             (pld_pma_fpll_clksel_int),
       .pld_pma_fpll_phase_done         (pld_pma_fpll_phase_done_int),
       .pld_pmaif_mask_tx_pll           (pld_pmaif_mask_tx_pll_int),
       .pld_tx_hssi_align_done          (pld_tx_hssi_align_done_int),
       .pld_tx_hssi_fifo_full           (pld_tx_hssi_fifo_full_int),
       .pld_tx_hssi_fifo_empty          (pld_tx_hssi_fifo_empty_int),
       .rx_fsr_mask_tx_pll              (rx_fsr_mask_tx_pll),
       .sr_hssi_tx_dcd_cal_done         (sr_hssi_tx_dcd_cal_done),
       .sr_hssi_tx_dll_lock             (sr_hssi_tx_dll_lock),
       .sr_hssi_tx_transfer_en          (sr_hssi_tx_transfer_en),
       .pld_aib_hssi_tx_dcd_cal_done    (pld_aib_hssi_tx_dcd_cal_done_int),
       .pld_aib_hssi_tx_dll_lock        (pld_aib_hssi_tx_dll_lock_int)
);

hdpldadapt_tx_async_direct hdpldadapt_tx_async_direct (
       // input
       .pld_pma_txdetectrx             (pld_pma_txdetectrx),
       .aib_fabric_pld_pma_fpll_lc_lock(aib_fabric_fpll_shared_direct_async_in[4]),
       // output
       .pld_pma_fpll_lc_lock           (pld_fpll_shared_direct_async_out_int[4]),
       .aib_fabric_pld_pma_txdetectrx  (aib_fabric_pld_pma_txdetectrx)
);

endmodule
