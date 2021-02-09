// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module hdpldadapt_avmm2(/*AUTOARG*/
   // Outputs
   pld_pll_cal_done, pld_avmm2_readdatavalid, pld_avmm2_readdata,
   pld_avmm2_reserved_out,
   pld_avmm2_cmdfifo_wr_pfull, pld_avmm2_cmdfifo_wr_full,
   pld_avmm2_busy, hip_avmm_writedone, hip_avmm_readdatavalid,
   hip_avmm_readdata, hip_avmm_reserved_out, avmm2_ssr_parity_checker_in, 
   //avmm_clock_csr_clk, 
   aib_fabric_avmm2_data_out,
   // Inputs
   dft_adpt_aibiobsr_fastclkn,
   adapter_scan_rst_n, adapter_scan_mode_n,
   adapter_scan_shift_n, adapter_scan_shift_clk,
   adapter_scan_user_clk0, adapter_scan_user_clk3,
   adapter_clk_sel_n, adapter_occ_enable,
   r_avmm2_osc_clk_scg_en, r_avmm2_gate_dis,
   r_avmm2_rdfifo_stop_write, r_avmm2_rdfifo_stop_read, nfrzdrv_in, usermode_in,
   r_avmm2_rdfifo_full, r_avmm2_rdfifo_empty, r_avmm2_hip_sel, //pr_channel_freeze,
   r_avmm2_cmdfifo_stop_write, r_avmm2_cmdfifo_stop_read,
   r_avmm2_cmdfifo_pfull, r_avmm2_cmdfifo_full, r_avmm2_cmdfifo_empty,
   r_avmm2_avmm_clk_scg_en, pld_avmm2_writedata,
   pld_avmm2_write, pld_avmm2_request, pld_avmm2_reg_addr,
   pld_avmm2_read, pld_avmm2_clk_rowclk, 
   pld_avmm2_reserved_in,
   hip_avmm_writedata, hip_avmm_write, hip_avmm_reg_addr,
   hip_avmm_read, csr_rdy_in, csr_rdy_dly_in, csr_clk_in,
   avmm2_hssi_fabric_ssr_load, avmm2_hssi_fabric_ssr_data,
   aib_fabric_tx_sr_clk_in, aib_fabric_rx_sr_clk_in, 
   avmm2_transfer_error, avmm2_transfer_testbus,
   aib_fabric_avmm2_data_in
   );


/*AUTOINPUT*/
// Beginning of automatic inputs (from unused autoinst inputs)
input			dft_adpt_aibiobsr_fastclkn;
input                   adapter_scan_rst_n;
input                   adapter_scan_mode_n;
input                   adapter_scan_shift_n;
input                   adapter_scan_shift_clk;
input                   adapter_scan_user_clk0;         // 125MHz
input                   adapter_scan_user_clk3;         // 1GHz
input                   adapter_clk_sel_n;
input                   adapter_occ_enable;
input 		aib_fabric_avmm2_data_in;// To hdpldadapt_avmm2_transfer of hdpldadapt_avmm2_transfer.v
input			aib_fabric_rx_sr_clk_in;// To hdpldadapt_avmmclk_ctl of hdpldadapt_avmmclk_ctl.v
input			aib_fabric_tx_sr_clk_in;// To hdpldadapt_avmmclk_ctl of hdpldadapt_avmmclk_ctl.v
input [1:0]     	avmm2_hssi_fabric_ssr_data;// To hdpldadapt_avmm2_async of hdpldadapt_avmm2_async.v
input			avmm2_hssi_fabric_ssr_load;// To hdpldadapt_avmm2_async of hdpldadapt_avmm2_async.v
input			csr_clk_in;		// To hdpldadapt_avmmclk_ctl of hdpldadapt_avmmclk_ctl.v
input			csr_rdy_dly_in;		// To hdpldadapt_avmmrst_ctl of hdpldadapt_avmmrst_ctl.v
input			csr_rdy_in;		// To hdpldadapt_avmmclk_ctl of hdpldadapt_avmmclk_ctl.v
input			hip_avmm_read;		// To hdpldadapt_avmm2_transfer of hdpldadapt_avmm2_transfer.v
input [20:0]		hip_avmm_reg_addr;	// To hdpldadapt_avmm2_transfer of hdpldadapt_avmm2_transfer.v
input			hip_avmm_write;		// To hdpldadapt_avmm2_transfer of hdpldadapt_avmm2_transfer.v
input [7:0]		hip_avmm_writedata;	// To hdpldadapt_avmm2_transfer of hdpldadapt_avmm2_transfer.v
input			pld_avmm2_clk_rowclk;	// To hdpldadapt_avmmclk_ctl of hdpldadapt_avmmclk_ctl.v
input			pld_avmm2_read;		// To hdpldadapt_avmm2_transfer of hdpldadapt_avmm2_transfer.v
input [8:0]		pld_avmm2_reg_addr;	// To hdpldadapt_avmm2_transfer of hdpldadapt_avmm2_transfer.v
input			pld_avmm2_request;	// To hdpldadapt_avmm2_transfer of hdpldadapt_avmm2_transfer.v
input			pld_avmm2_write;	// To hdpldadapt_avmm2_transfer of hdpldadapt_avmm2_transfer.v
input [7:0]		pld_avmm2_writedata;	// To hdpldadapt_avmm2_transfer of hdpldadapt_avmm2_transfer.v
input [9:0]		pld_avmm2_reserved_in;
input			r_avmm2_avmm_clk_scg_en;// To hdpldadapt_avmmclk_ctl of hdpldadapt_avmmclk_ctl.v
input [5:0]		r_avmm2_cmdfifo_empty;	// To hdpldadapt_avmm2_transfer of hdpldadapt_avmm2_transfer.v
input [5:0]		r_avmm2_cmdfifo_full;	// To hdpldadapt_avmm2_transfer of hdpldadapt_avmm2_transfer.v
input [5:0]		r_avmm2_cmdfifo_pfull;	// To hdpldadapt_avmm2_transfer of hdpldadapt_avmm2_transfer.v
input			r_avmm2_cmdfifo_stop_read;// To hdpldadapt_avmm2_transfer of hdpldadapt_avmm2_transfer.v
input			r_avmm2_cmdfifo_stop_write;// To hdpldadapt_avmm2_transfer of hdpldadapt_avmm2_transfer.v
input			r_avmm2_hip_sel;	// To hdpldadapt_avmm2_transfer of hdpldadapt_avmm2_transfer.v
input [5:0]		r_avmm2_rdfifo_empty;	// To hdpldadapt_avmm2_transfer of hdpldadapt_avmm2_transfer.v
input [5:0]		r_avmm2_rdfifo_full;	// To hdpldadapt_avmm2_transfer of hdpldadapt_avmm2_transfer.v
input			r_avmm2_rdfifo_stop_read;// To hdpldadapt_avmm2_transfer of hdpldadapt_avmm2_transfer.v
input			r_avmm2_rdfifo_stop_write;// To hdpldadapt_avmm2_transfer of hdpldadapt_avmm2_transfer.v
input			r_avmm2_osc_clk_scg_en;// To hdpldadapt_avmmclk_ctl of hdpldadapt_avmmclk_ctl.v
input                   r_avmm2_gate_dis;
input                   nfrzdrv_in;
//input                   pr_channel_freeze;
input                   usermode_in;
// End of automatics
/*AUTOOUTPUT*/
// Beginning of automatic outputs (from unused autoinst outputs)
output			avmm2_transfer_error;
output [10:0]           avmm2_transfer_testbus;
output [1:0]		aib_fabric_avmm2_data_out;// From hdpldadapt_avmm2_transfer of hdpldadapt_avmm2_transfer.v
//output			avmm_clock_csr_clk;	// From hdpldadapt_avmmclk_ctl of hdpldadapt_avmmclk_ctl.v
//output			avmm_clock_csr_clk_n;	// From hdpldadapt_avmmclk_ctl of hdpldadapt_avmmclk_ctl.v
output [7:0]		hip_avmm_readdata;	// From hdpldadapt_avmm2_transfer of hdpldadapt_avmm2_transfer.v
output			hip_avmm_readdatavalid;	// From hdpldadapt_avmm2_transfer of hdpldadapt_avmm2_transfer.v
output			hip_avmm_writedone;	// From hdpldadapt_avmm2_transfer of hdpldadapt_avmm2_transfer.v
output [4:0]		hip_avmm_reserved_out;
output			pld_avmm2_busy;		// From hdpldadapt_avmm2_transfer of hdpldadapt_avmm2_transfer.v
output			pld_avmm2_cmdfifo_wr_full;// From hdpldadapt_avmm2_transfer of hdpldadapt_avmm2_transfer.v
output			pld_avmm2_cmdfifo_wr_pfull;// From hdpldadapt_avmm2_transfer of hdpldadapt_avmm2_transfer.v
output [7:0]		pld_avmm2_readdata;	// From hdpldadapt_avmm2_transfer of hdpldadapt_avmm2_transfer.v
output			pld_avmm2_readdatavalid;// From hdpldadapt_avmm2_transfer of hdpldadapt_avmm2_transfer.v
output [2:0]		pld_avmm2_reserved_out;
output			pld_pll_cal_done;	// From hdpldadapt_avmm2_async of hdpldadapt_avmm2_async.v
output [1:0]            avmm2_ssr_parity_checker_in;
// End of automatics
/*AUTOWIRE*/
// Beginning of automatic wires (for undeclared instantiated-module outputs)
wire			avmm_clock_avmm_clk;	// From hdpldadapt_avmmclk_ctl of hdpldadapt_avmmclk_ctl.v
wire                    avmm_clock_reset_tx_osc_clk;
wire                    avmm_clock_reset_rx_osc_clk;
wire                    avmm_clock_reset_avmm_clk;
wire			avmm_clock_rx_osc_clk;	// From hdpldadapt_avmmclk_ctl of hdpldadapt_avmmclk_ctl.v
wire			avmm_clock_tx_osc_clk;	// From hdpldadapt_avmmclk_ctl of hdpldadapt_avmmclk_ctl.v
wire			avmm_reset_avmm_rst_n;	// From hdpldadapt_avmmrst_ctl of hdpldadapt_avmmrst_ctl.v
wire			avmm_reset_rx_osc_clk_rst_n;// From hdpldadapt_avmmrst_ctl of hdpldadapt_avmmrst_ctl.v
wire			avmm_reset_tx_osc_clk_rst_n;// From hdpldadapt_avmmrst_ctl of hdpldadapt_avmmrst_ctl.v
// End of automatics

/* hdpldadapt_avmm2_transfer AUTO_TEMPLATE (
.aib_fabric_avmm_data_in(aib_fabric_avmm2_data_in[1:0]),
.aib_fabric_avmm_data_out(aib_fabric_avmm2_data_out[3:0]),
.pld_avmm_readdata(pld_avmm2_readdata[7:0]),
.pld_avmm_readdatavalid(pld_avmm2_readdatavalid),
.pld_avmm_read(pld_avmm2_read),
.pld_avmm_reg_addr(pld_avmm2_reg_addr[8:0]),
.pld_avmm_request(pld_avmm2_request),
.pld_avmm_write(pld_avmm2_write),
.pld_avmm_writedata(pld_avmm2_writedata[7:0]),
.avmm_transfer_testbus(),
.pld_avmm_busy(pld_avmm2_busy),
.pld_avmm_cmdfifo_wr_full (pld_avmm2_cmdfifo_wr_full),
.pld_avmm_cmdfifo_wr_pfull (pld_avmm2_cmdfifo_wr_pfull),
);
*/
wire			pld_avmm_clk_out;
wire [2:0]              int_pld_avmm2_reserved_out;
wire               	nc_pld_avmm2_reserved_out;

assign pld_avmm2_reserved_out[2] = pld_avmm_clk_out; 
assign pld_avmm2_reserved_out[1:0] = int_pld_avmm2_reserved_out[1:0];
assign nc_pld_avmm2_reserved_out = int_pld_avmm2_reserved_out[2];

hdpldadapt_avmm2_transfer hdpldadapt_avmm2_transfer(/*AUTOINST*/
						    // Outputs
						    .aib_fabric_avmm_data_out(aib_fabric_avmm2_data_out[1:0]), // Templated
						    .pld_avmm_busy	(pld_avmm2_busy), // Templated
						    .pld_avmm_readdata	(pld_avmm2_readdata[7:0]), // Templated
						    .pld_avmm_readdatavalid(pld_avmm2_readdatavalid), // Templated
						    .pld_avmm_reserved_out(int_pld_avmm2_reserved_out[2:0]),
						    .hip_avmm_writedone	(hip_avmm_writedone),
						    .hip_avmm_readdata	(hip_avmm_readdata[7:0]),
						    .hip_avmm_readdatavalid(hip_avmm_readdatavalid),
						    .hip_avmm_reserved_out(hip_avmm_reserved_out[4:0]),
						    .pld_avmm_cmdfifo_wr_full(pld_avmm2_cmdfifo_wr_full), // Templated
						    .pld_avmm_cmdfifo_wr_pfull(pld_avmm2_cmdfifo_wr_pfull), // Templated
						    .avmm_transfer_error(avmm2_transfer_error),
						    .avmm_transfer_testbus(avmm2_transfer_testbus),		 // Templated
						    // Inputs
						    .avmm_clock_rx_osc_clk(avmm_clock_rx_osc_clk),
						    .avmm_clock_tx_osc_clk(avmm_clock_tx_osc_clk),
						    .avmm_clock_avmm_clk(avmm_clock_avmm_clk),
						    .avmm_reset_rx_osc_clk_rst_n(avmm_reset_rx_osc_clk_rst_n),
						    .avmm_reset_tx_osc_clk_rst_n(avmm_reset_tx_osc_clk_rst_n),
						    .avmm_reset_avmm_rst_n(avmm_reset_avmm_rst_n),
						    .aib_fabric_avmm_data_in(aib_fabric_avmm2_data_in), // Templated
						    .pld_avmm_read	(pld_avmm2_read), // Templated
						    .pld_avmm_reg_addr	(pld_avmm2_reg_addr[8:0]), // Templated
						    .pld_avmm_request	(pld_avmm2_request), // Templated
						    .pld_avmm_write	(pld_avmm2_write), // Templated
						    .pld_avmm_writedata	(pld_avmm2_writedata[7:0]), // Templated
						    .pld_avmm_reserved_in(pld_avmm2_reserved_in[9:0]), 
						    .hip_avmm_read	(hip_avmm_read),
						    .hip_avmm_reg_addr	(hip_avmm_reg_addr[20:0]),
						    .hip_avmm_write	(hip_avmm_write),
						    .hip_avmm_writedata	(hip_avmm_writedata[7:0]),
                                                    .nfrzdrv_in         (nfrzdrv_in),
                                                    .usermode_in        (usermode_in),
                                                    .sr_hssi_avmm_busy  (sr_hssi_avmm2_busy),
						    .r_avmm2_cmdfifo_pfull(r_avmm2_cmdfifo_pfull[5:0]),
						    .r_avmm2_cmdfifo_empty(r_avmm2_cmdfifo_empty[5:0]),
						    .r_avmm2_cmdfifo_full(r_avmm2_cmdfifo_full[5:0]),
						    .r_avmm2_cmdfifo_stop_read(r_avmm2_cmdfifo_stop_read),
						    .r_avmm2_cmdfifo_stop_write(r_avmm2_cmdfifo_stop_write),
						    .r_avmm2_rdfifo_empty(r_avmm2_rdfifo_empty[5:0]),
						    .r_avmm2_rdfifo_full(r_avmm2_rdfifo_full[5:0]),
						    .r_avmm2_rdfifo_stop_read(r_avmm2_rdfifo_stop_read),
						    .r_avmm2_rdfifo_stop_write(r_avmm2_rdfifo_stop_write),
                                                    .r_avmm2_gate_dis   (r_avmm2_gate_dis),
						    .r_avmm2_hip_sel	(r_avmm2_hip_sel));
hdpldadapt_avmmclk_ctl hdpldadapt_avmmclk_ctl(/*AUTOINST*/
					      // Outputs
                                              .avmm_clock_reset_rx_osc_clk(avmm_clock_reset_rx_osc_clk),
                                              .avmm_clock_reset_tx_osc_clk(avmm_clock_reset_tx_osc_clk),
                                              .avmm_clock_reset_avmm_clk(avmm_clock_reset_avmm_clk),
					      .avmm_clock_rx_osc_clk(avmm_clock_rx_osc_clk),
					      .avmm_clock_tx_osc_clk(avmm_clock_tx_osc_clk),
					      .avmm_clock_avmm_clk(avmm_clock_avmm_clk),
					      //.avmm_clock_csr_clk(avmm_clock_csr_clk),
					      //.avmm_clock_csr_clk_n(avmm_clock_csr_clk_n),
					      .avmm_clock_dprio_clk(),
				              .pld_avmm_clk_out(pld_avmm_clk_out),
					      // Inputs
                                                .dft_adpt_aibiobsr_fastclkn(dft_adpt_aibiobsr_fastclkn),
                                                .adapter_scan_mode_n(adapter_scan_mode_n),
                                                .adapter_scan_shift_n(adapter_scan_shift_n),
                                                .adapter_scan_shift_clk(adapter_scan_shift_clk),
                                                .adapter_scan_user_clk0(adapter_scan_user_clk0),         // 125MHz
                                                .adapter_scan_user_clk3(adapter_scan_user_clk3),         // 1GHz
                                                .adapter_clk_sel_n(adapter_clk_sel_n),
                                                .adapter_occ_enable(adapter_occ_enable),
					      .csr_rdy_in	(csr_rdy_in),
					      .csr_rdy_dly_in	(csr_rdy_dly_in),
					      .csr_clk_in	(csr_clk_in),
					      .aib_fabric_rx_sr_clk_in(aib_fabric_rx_sr_clk_in),
					      .aib_fabric_tx_sr_clk_in(aib_fabric_tx_sr_clk_in),
					      .pld_avmm_clk_rowclk(pld_avmm2_clk_rowclk), // Templated
					      .nfrzdrv_in(nfrzdrv_in),
					      .avmm_reset_avmm_rst_n(avmm_reset_avmm_rst_n),
					      .r_avmm_osc_clk_scg_en(r_avmm2_osc_clk_scg_en), // Templated
					      .r_avmm_avmm_clk_scg_en(r_avmm2_avmm_clk_scg_en)); // Templated
hdpldadapt_avmmrst_ctl hdpldadapt_avmmrst_ctl(/*AUTOINST*/
					      // Outputs
					      .avmm_reset_rx_osc_clk_rst_n(avmm_reset_rx_osc_clk_rst_n),
					      .avmm_reset_tx_osc_clk_rst_n(avmm_reset_tx_osc_clk_rst_n),
					      .avmm_reset_avmm_rst_n(avmm_reset_avmm_rst_n),
					      // Inputs
                                                .adapter_scan_rst_n(adapter_scan_rst_n),
                                                .adapter_scan_mode_n(adapter_scan_mode_n),
					      .csr_rdy_dly_in	(csr_rdy_dly_in),
                                              .avmm_clock_reset_rx_osc_clk(avmm_clock_reset_rx_osc_clk),
                                              .avmm_clock_reset_tx_osc_clk(avmm_clock_reset_tx_osc_clk),
					      .avmm_clock_reset_avmm_clk(avmm_clock_reset_avmm_clk));
hdpldadapt_avmm2_async hdpldadapt_avmm2_async(/*AUTOINST*/
					      // Outputs
					      .pld_pll_cal_done	(pld_pll_cal_done),
					      .sr_hssi_avmm2_busy (sr_hssi_avmm2_busy),
					      .avmm2_ssr_parity_checker_in (avmm2_ssr_parity_checker_in),
					      // Inputs
                                              .nfrzdrv_in(nfrzdrv_in),
                                              //.pr_channel_freeze (pr_channel_freeze),
					      .avmm_clock_rx_osc_clk(avmm_clock_rx_osc_clk),
					      .avmm_reset_rx_osc_clk_rst_n(avmm_reset_rx_osc_clk_rst_n),
					      .avmm2_hssi_fabric_ssr_data(avmm2_hssi_fabric_ssr_data),
					      .avmm2_hssi_fabric_ssr_load(avmm2_hssi_fabric_ssr_load));

endmodule
