// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3aibadapt_avmm2(/*AUTOARG*/
   // Outputs
   ehip_usr_wdata, ehip_usr_write, 
   ehip_usr_addr, ehip_usr_read, ehip_usr_clk, 
   avmm_transfer_error, avmm_transfer_testbus,
   avmm2_clock_avmm_clk_scg, avmm2_clock_avmm_clk_dcg,
   avmm2_hssi_fabric_ssr_data, avmm2_clock_dcg_testbus,
   aib_hssi_avmm2_data_out,
   // Inputs
   // tst_tcm_ctrl,
   // test_clk,
   // scan_clk,
   dft_adpt_rst, adapter_scan_rst_n, adapter_scan_mode_n,
   r_avmm2_rdfifo_stop_write, r_avmm2_rdfifo_stop_read,
   r_avmm2_rdfifo_full, r_avmm2_rdfifo_empty,
   r_avmm2_osc_clk_scg_en,
   r_avmm2_hip_sel, r_avmm2_avmm_clk_scg_en, r_avmm2_avmm_clk_dcg_en, r_avmm2_free_run_div_clk,
   pld_pll_cal_done, 
   csr_rdy_dly_in, 
   avmm2_async_hssi_fabric_ssr_load, sr_clock_aib_rx_sr_clk, aib_hssi_avmm2_data_in,
   sr_clock_tx_osc_clk_or_clkdiv, avmm_clock_reset_avmm2_clk, 
   ehip_usr_wrdone,
   ehip_usr_rdata,
   ehip_usr_rdatavld
   );

// input  [`TCM_WRAP_CTRL_RNG] tst_tcm_ctrl;
// input                       test_clk;
// input                       scan_clk;
input                       dft_adpt_rst;
input                       adapter_scan_rst_n;
input                       adapter_scan_mode_n;
input [1:0]		    aib_hssi_avmm2_data_in;	// To c3adapt_avmm2_transfer of c3adapt_avmm2_transfer.v
input			    sr_clock_aib_rx_sr_clk;	// To c3adapt_avmmclk_ctl of c3adapt_avmmclk_ctl.v
input			    sr_clock_tx_osc_clk_or_clkdiv;	// To c3adapt_avmmclk_ctl of c3adapt_avmmclk_ctl.v
input			    avmm_clock_reset_avmm2_clk;
input			    avmm2_async_hssi_fabric_ssr_load;// To c3adapt_avmm1_async of c3adapt_avmm2_async.v
input			    csr_rdy_dly_in;		// To c3adapt_avmmrst_ctl of c3adapt_avmmrst_ctl.v
input			    pld_pll_cal_done;	// To c3adapt_avmm1_async of c3adapt_avmm2_async.v
input			    r_avmm2_avmm_clk_dcg_en;// To c3adapt_avmmclk_ctl of c3adapt_avmmclk_ctl.v
input			    r_avmm2_avmm_clk_scg_en;// To c3adapt_avmmclk_ctl of c3adapt_avmmclk_ctl.v
input			    r_avmm2_free_run_div_clk;
input			    r_avmm2_hip_sel;	// To c3adapt_avmm2_transfer of c3adapt_avmm2_transfer.v
input			    r_avmm2_osc_clk_scg_en;// To c3adapt_avmmclk_ctl of c3adapt_avmmclk_ctl.v
input [5:0]		    r_avmm2_rdfifo_empty;	// To c3adapt_avmm2_transfer of c3adapt_avmm2_transfer.v
input [5:0]		    r_avmm2_rdfifo_full;	// To c3adapt_avmm2_transfer of c3adapt_avmm2_transfer.v
input			    r_avmm2_rdfifo_stop_read;// To c3adapt_avmm2_transfer of c3adapt_avmm2_transfer.v
input			    r_avmm2_rdfifo_stop_write;// To c3adapt_avmm2_transfer of c3adapt_avmm2_transfer.v
input                       ehip_usr_wrdone;
input [7:0]                 ehip_usr_rdata;
input                       ehip_usr_rdatavld;

// Beginning of automatic outputs (from unused autoinst outputs)
output 		aib_hssi_avmm2_data_out;// From c3adapt_avmm2_transfer of c3adapt_avmm2_transfer.v
output		avmm2_clock_avmm_clk_scg;
output		avmm2_clock_avmm_clk_dcg;
output [1:0]	avmm2_hssi_fabric_ssr_data;// From c3adapt_avmm1_async of c3adapt_avmm2_async.v
output		avmm_transfer_error;
output [14:0]	avmm_transfer_testbus;	// From c3adapt_avmm2_transfer of c3adapt_avmm2_transfer.v
output [7:0]	avmm2_clock_dcg_testbus;	// From c3adapt_avmm2_transfer of c3adapt_avmm2_transfer.v
output		ehip_usr_clk;		// From c3adapt_avmmclk_ctl of c3adapt_avmmclk_ctl.v
output		ehip_usr_read;		// From c3adapt_avmm1_config of c3adapt_avmm2_config.v
output [20:0]	ehip_usr_addr;	        // From c3adapt_avmm1_config of c3adapt_avmm2_config.v
output [7:0]    ehip_usr_wdata;
// output		pld_avmm2_request;	// From c3adapt_avmm1_config of c3adapt_avmm2_config.v
output		ehip_usr_write;	        // From c3adapt_avmm1_config of c3adapt_avmm2_config.v
wire		avmm_clock_avmm_clk;	// From c3adapt_avmmclk_ctl of c3adapt_avmmclk_ctl.v
wire		avmm_clock_dprio_clk;	// From c3adapt_avmmclk_ctl of c3adapt_avmmclk_ctl.v
wire            avmm_clock_reset_tx_osc_clk;
wire            avmm_clock_reset_rx_osc_clk;
wire            avmm_clock_reset_avmm_clk;
wire		avmm_clock_rx_osc_clk;	// From c3adapt_avmmclk_ctl of c3adapt_avmmclk_ctl.v
wire		avmm_clock_tx_osc_clk;	// From c3adapt_avmmclk_ctl of c3adapt_avmmclk_ctl.v
wire		avmm_reset_avmm_rst_n;	// From c3adapt_avmmrst_ctl of c3adapt_avmmrst_ctl.v
wire		avmm_reset_rx_osc_clk_for_clkdiv_rst_n;
wire		avmm_reset_rx_osc_clk_rst_n;// From c3adapt_avmmrst_ctl of c3adapt_avmmrst_ctl.v
wire		avmm_reset_tx_osc_clk_rst_n;// From c3adapt_avmmrst_ctl of c3adapt_avmmrst_ctl.v
wire		remote_pld_avmm_busy;	// From c3adapt_avmm1_config of c3adapt_avmm2_config.v
wire		remote_pld_avmm_read;	// From c3adapt_avmm2_transfer of c3adapt_avmm2_transfer.v
wire [7:0]	remote_pld_avmm_readdata;// From c3adapt_avmm1_config of c3adapt_avmm2_config.v
wire		remote_pld_avmm_readdatavalid;// From c3adapt_avmm1_config of c3adapt_avmm2_config.v
wire [8:0]	remote_pld_avmm_reg_addr;// From c3adapt_avmm2_transfer of c3adapt_avmm2_transfer.v
wire		remote_pld_avmm_request;// From c3adapt_avmm2_transfer of c3adapt_avmm2_transfer.v
wire		remote_pld_avmm_write;	// From c3adapt_avmm2_transfer of c3adapt_avmm2_transfer.v
wire [7:0]	remote_pld_avmm_writedata;// From c3adapt_avmm2_transfer of c3adapt_avmm2_transfer.v
wire		avmm_transfer_dcg_ungate;
wire		avmm_transfer_dcg_gate;


c3aibadapt_avmm2_transfer adapt_avmm2_transfer (/*AUTOINST*/
							// Outputs
							.aib_hssi_avmm_data_out        (aib_hssi_avmm2_data_out), // Templated
							.remote_pld_avmm_read          (remote_pld_avmm_read),
							.remote_pld_avmm_reg_addr      (remote_pld_avmm_reg_addr[8:0]),
							.remote_pld_avmm_request       (remote_pld_avmm_request),
							.remote_pld_avmm_write         (remote_pld_avmm_write),
							.remote_pld_avmm_writedata     (remote_pld_avmm_writedata[7:0]),
                                                        .avmm_transfer_dcg_ungate      (avmm_transfer_dcg_ungate),
                                                        .avmm_transfer_dcg_gate        (avmm_transfer_dcg_gate),
							.avmm_transfer_error           (avmm_transfer_error),
							.avmm_transfer_testbus         (avmm_transfer_testbus[14:0]),
                                                        .ehip_usr_read                 (ehip_usr_read),
                                                        .ehip_usr_addr                 (ehip_usr_addr),
                                                        .ehip_usr_wdata                (ehip_usr_wdata),
                                                        .ehip_usr_write                (ehip_usr_write),
							// Inputs
							.dft_adpt_rst                  (dft_adpt_rst),
							.avmm_clock_tx_osc_clk         (avmm_clock_tx_osc_clk),
							.avmm_clock_rx_osc_clk         (avmm_clock_rx_osc_clk),
							.avmm_clock_avmm_clk           (avmm_clock_avmm_clk),
							.avmm_reset_tx_osc_clk_rst_n   (avmm_reset_tx_osc_clk_rst_n),
							.avmm_reset_rx_osc_clk_rst_n   (avmm_reset_rx_osc_clk_rst_n),
							.avmm_reset_avmm_rst_n         (avmm_reset_avmm_rst_n),
							.aib_hssi_avmm_data_in         (aib_hssi_avmm2_data_in[1:0]),
							.remote_pld_avmm_busy          (remote_pld_avmm_busy),
							.remote_pld_avmm_readdata      (remote_pld_avmm_readdata[7:0]),
							.remote_pld_avmm_readdatavalid (remote_pld_avmm_readdatavalid),
							.remote_pld_avmm_reserved_in   (3'b000),
                                                        .ehip_usr_wrdone               (ehip_usr_wrdone),
                                                        .ehip_usr_rdata                (ehip_usr_rdata),
                                                        .ehip_usr_rdatavld             (ehip_usr_rdatavld),
							.r_avmm2_rdfifo_empty          (r_avmm2_rdfifo_empty[5:0]),
							.r_avmm2_rdfifo_full           (r_avmm2_rdfifo_full[5:0]),
							.r_avmm2_rdfifo_stop_read      (r_avmm2_rdfifo_stop_read),
							.r_avmm2_rdfifo_stop_write     (r_avmm2_rdfifo_stop_write),
							.r_avmm2_hip_sel               (r_avmm2_hip_sel));
c3aibadapt_avmm2clk_ctl adapt_avmm2clk_ctl (/*AUTOINST*/
						// Outputs
						.hip_avmm_clk		                (ehip_usr_clk),
                                                .avmm_clock_reset_tx_osc_clk            (avmm_clock_reset_tx_osc_clk),
                                                .avmm_clock_reset_rx_osc_clk            (avmm_clock_reset_rx_osc_clk),
                                                .avmm_clock_reset_avmm_clk              (avmm_clock_reset_avmm_clk),
						.avmm_clock_tx_osc_clk                  (avmm_clock_tx_osc_clk),
						.avmm_clock_rx_osc_clk                  (avmm_clock_rx_osc_clk),
						.avmm_clock_avmm_clk	                (avmm_clock_avmm_clk),
						.avmm_clock_avmm_clk_scg                (avmm2_clock_avmm_clk_scg),
						.avmm_clock_avmm_clk_dcg                (avmm2_clock_avmm_clk_dcg),
						.avmm_clock_dprio_clk	                (avmm_clock_dprio_clk),
						.avmm_clock_dcg_testbus                 (avmm2_clock_dcg_testbus[7:0]),
						// Inputs
                                                // .tst_tcm_ctrl                           (tst_tcm_ctrl),
                                                // .test_clk                               (test_clk),
                                                // .scan_clk                               (scan_clk),
                                                .scan_mode_n                            (adapter_scan_mode_n),
						.sr_clock_aib_rx_sr_clk	                (sr_clock_aib_rx_sr_clk),
						.sr_clock_tx_osc_clk_or_clkdiv          (sr_clock_tx_osc_clk_or_clkdiv),
                                                .avmm_clock_reset_avmm2_clk             (avmm_clock_reset_avmm2_clk),
                                                .avmm_reset_avmm_rst_n                  (avmm_reset_avmm_rst_n),
                                                .avmm_reset_rx_osc_clk_for_clkdiv_rst_n (avmm_reset_rx_osc_clk_for_clkdiv_rst_n),
                                                .avmm_transfer_dcg_ungate               (avmm_transfer_dcg_ungate),
                                                .avmm_transfer_dcg_gate                 (avmm_transfer_dcg_gate),
						.r_avmm_osc_clk_scg_en                  (r_avmm2_osc_clk_scg_en),
						.r_avmm_avmm_clk_scg_en                 (r_avmm2_avmm_clk_scg_en),
						.r_avmm_avmm_clk_dcg_en                 (r_avmm2_avmm_clk_dcg_en));
c3aibadapt_avmmrst_ctl adapt_avmmrst_ctl(/*AUTOINST*/
                                                  // Outputs
                                                  .avmm_reset_rx_osc_clk_for_clkdiv_rst_n (avmm_reset_rx_osc_clk_for_clkdiv_rst_n),
                                                  .avmm_reset_rx_osc_clk_rst_n            (avmm_reset_rx_osc_clk_rst_n),
                                                  .avmm_reset_tx_osc_clk_rst_n            (avmm_reset_tx_osc_clk_rst_n),
                                                  .avmm_reset_avmm_rst_n                  (avmm_reset_avmm_rst_n),
                                                  // Inputs
						  .dft_adpt_rst                           (dft_adpt_rst),
                                                  .scan_rst_n                             (adapter_scan_rst_n),
                                                  .scan_mode_n                            (adapter_scan_mode_n),
                                                  .csr_rdy_dly_in                         (csr_rdy_dly_in),
                                                  .r_avmm_free_run_div_clk                (r_avmm2_free_run_div_clk),
                                                  .avmm_clock_reset_tx_osc_clk            (avmm_clock_reset_tx_osc_clk),
                                                  .avmm_clock_reset_rx_osc_clk            (avmm_clock_reset_rx_osc_clk),
                                                  .avmm_clock_reset_avmm_clk              (avmm_clock_reset_avmm_clk));
c3aibadapt_avmm2_config adapt_avmm2_config(/*AUTOINST*/
						    // Outputs
						    .remote_pld_avmm_busy          (remote_pld_avmm_busy),
						    .remote_pld_avmm_readdata      (remote_pld_avmm_readdata[7:0]),
						    .remote_pld_avmm_readdatavalid (remote_pld_avmm_readdatavalid),
						    .pld_avmm2_read	           (),
						    .pld_avmm2_reg_addr	           (),                              
						    .pld_avmm2_request	           (),                              
						    .pld_avmm2_write	           (),
						    .pld_avmm2_writedata           (),
						    // Inputs
						    .avmm_clock_dprio_clk          (avmm_clock_dprio_clk),
						    .avmm_reset_avmm_rst_n         (avmm_reset_avmm_rst_n),
						    .remote_pld_avmm_read          (remote_pld_avmm_read),
						    .remote_pld_avmm_reg_addr      (remote_pld_avmm_reg_addr[8:0]),
						    .remote_pld_avmm_request       (remote_pld_avmm_request),
						    .remote_pld_avmm_write         (remote_pld_avmm_write),
						    .remote_pld_avmm_writedata     (remote_pld_avmm_writedata[7:0]),
						    .pld_avmm2_busy	           (1'b0),
						    .pld_avmm2_readdata	           (8'h00));
c3aibadapt_avmm2_async adapt_avmm2_async(/*AUTOINST*/
						  // Outputs
						  .avmm2_hssi_fabric_ssr_data(avmm2_hssi_fabric_ssr_data),
						  // Inputs
						  .avmm_clock_tx_osc_clk(avmm_clock_tx_osc_clk),
						  .avmm_reset_tx_osc_clk_rst_n(avmm_reset_tx_osc_clk_rst_n),
						  .pld_pll_cal_done	(pld_pll_cal_done),
						  .pld_avmm2_busy	(1'b0),
						  .avmm2_async_hssi_fabric_ssr_load(avmm2_async_hssi_fabric_ssr_load));

endmodule
