// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3aibadapt_avmm1_transfer
(
	input	wire		avmm_clock_tx_osc_clk,
	input	wire		avmm_clock_rx_osc_clk,
	input	wire		avmm_clock_avmm_clk,
	input	wire		avmm_reset_tx_osc_clk_rst_n,
	input	wire		avmm_reset_rx_osc_clk_rst_n,
	input	wire		avmm_reset_avmm_rst_n,
	input	wire [1:0]	aib_hssi_avmm_data_in,
	input	wire		remote_pld_avmm_writedone,
	input	wire		remote_pld_avmm_busy,
	input	wire [7:0]	remote_pld_avmm_readdata,
	input	wire		remote_pld_avmm_readdatavalid,
	input	wire [2:0]	remote_pld_avmm_reserved_in,
	input	wire [5:0]      r_avmm1_rdfifo_empty,
        input   wire            r_avmm1_use_rsvd_bit1,
	input	wire [5:0]      r_avmm1_rdfifo_full,
	input	wire            r_avmm1_rdfifo_stop_read,
	input	wire            r_avmm1_rdfifo_stop_write,
	output	reg 		aib_hssi_avmm_data_out,
	output	wire		remote_pld_avmm_read,
	output	wire [9:0]	remote_pld_avmm_reg_addr,
	output	wire		remote_pld_avmm_request,
	output	wire		remote_pld_avmm_write,
	output	wire [7:0]	remote_pld_avmm_writedata,
	output	wire [8:0]	remote_pld_avmm_reserved_out,
        output  wire            avmm_transfer_dcg_ungate,
        output  wire            avmm_transfer_dcg_gate,
	output	wire		avmm_transfer_error,
	output	wire [14:0]	avmm_transfer_testbus
);

        wire            r_avmm1_hip_sel;
	wire [14:0]	hip_aib_avmm_out;
	wire [30:0]	nc_hip_aib_avmm_in;

	wire		pld_avmm_busy;
	wire [7:0]	pld_avmm_readdata;
	wire		pld_avmm_readdatavalid;
	wire [2:0]	pld_avmm_reserved_in;

	wire		pld_avmm_read;
	wire [9:0]	pld_avmm_reg_addr;
	wire		pld_avmm_request;
	wire		pld_avmm_write;
	wire [7:0]	pld_avmm_writedata;
	wire [8:0]	pld_avmm_reserved_out;

	wire		avmm_cmdbuilder_dcg_ungate;
	wire		avmm_cmdbuilder_error;
	wire [8:0]	avmm_cmdbuilder_testbus;

	wire		int_hip_avmm_writedone;
	wire		int_pld_avmm_busy;
	wire		int_pld_avmm_readdatavalid;
	reg		int_pld_avmm_busy_reg;
	wire		int_pld_avmm_busy_chg;
	wire		avmm_rdfifo_valid;
	wire		avmm_rdfifo_wr_en;
	wire		avmm_rdfifo_wr_data0_bit1;
	wire [1:0]	avmm_rdfifo_wr_data0;
	wire [1:0]	avmm_rdfifo_wr_data1;
	wire [1:0]	avmm_rdfifo_wr_data2;
	wire [1:0]	avmm_rdfifo_wr_data3;
	wire [1:0]	avmm_rdfifo_wr_data4;
	wire [1:0]	avmm_rdfifo_wr_data5;
	wire [1:0]	avmm_rdfifo_wr_data6;
	wire [1:0]	avmm_rdfifo_wr_data7;
	wire [14:0]	avmm_rdfifo_parity_data;
	wire		avmm_rdfifo_parity;
	wire		avmm_rdfifo_wr_full;
	wire		avmm_rdfifo_rd_en;
	reg		avmm_rdfifo_rd_en_reg;
	wire		avmm_rdfifo_rd_empty_raw;
	wire		avmm_rdfifo_rd_empty;
	wire [1:0]	avmm_rdfifo_rd_data;
	reg 		avmm_rdfifo_rd_data_reg;
	wire		aib_hssi_avmm_data_out_pre;
	wire [1:0]	nc_hip_aib_avmm_out;

        assign r_avmm1_hip_sel  = 1'b0;
	assign hip_aib_avmm_out = 15'o00000;
	assign pld_avmm_busy    = remote_pld_avmm_busy;
	assign pld_avmm_readdata[7:0] = remote_pld_avmm_readdata[7:0];
	assign pld_avmm_readdatavalid = remote_pld_avmm_readdatavalid;
	// assign pld_avmm_reserved_in[2:0] = remote_pld_avmm_reserved_in[2:0];
	assign pld_avmm_reserved_in[2:0] = {remote_pld_avmm_reserved_in[2],(r_avmm1_use_rsvd_bit1 & remote_pld_avmm_writedone),remote_pld_avmm_reserved_in[0]};
	assign remote_pld_avmm_read = pld_avmm_read;
	assign remote_pld_avmm_reg_addr[9:0] = pld_avmm_reg_addr[9:0];
	assign remote_pld_avmm_request = pld_avmm_request;
	assign remote_pld_avmm_write = pld_avmm_write;
	assign remote_pld_avmm_writedata[7:0] = pld_avmm_writedata[7:0];
	assign remote_pld_avmm_reserved_out[8:0] = pld_avmm_reserved_out[8:0];

	assign avmm_transfer_testbus[14:0] = {avmm_transfer_dcg_gate,avmm_transfer_dcg_ungate,avmm_rdfifo_wr_full,avmm_rdfifo_rd_empty,avmm_rdfifo_rd_en,avmm_rdfifo_valid,avmm_cmdbuilder_testbus};

        assign avmm_transfer_dcg_ungate = avmm_cmdbuilder_dcg_ungate;
        assign avmm_transfer_dcg_gate = ~int_pld_avmm_busy;
	assign avmm_transfer_error = avmm_cmdbuilder_error;

c3aibadapt_avmm_cmdbuilder adapt_avmm1_cmdbuilder
    (
        .avmm_clock_rx_osc_clk(avmm_clock_rx_osc_clk),
        .avmm_clock_avmm_clk(avmm_clock_avmm_clk),
        .avmm_reset_rx_osc_clk_rst_n(avmm_reset_rx_osc_clk_rst_n),
        .avmm_reset_avmm_rst_n(avmm_reset_avmm_rst_n),
        .aib_hssi_avmm_data_in(aib_hssi_avmm_data_in),
        .r_avmm_hip_sel(r_avmm1_hip_sel),
        .pld_avmm_read(pld_avmm_read),
        .pld_avmm_reg_addr(pld_avmm_reg_addr),
        .pld_avmm_request(pld_avmm_request),
        .pld_avmm_write(pld_avmm_write),
        .pld_avmm_writedata(pld_avmm_writedata),
	.pld_avmm_reserved_out(pld_avmm_reserved_out),
        .hip_aib_avmm_in(nc_hip_aib_avmm_in),
	.avmm_cmdbuilder_dcg_ungate(avmm_cmdbuilder_dcg_ungate),
	.avmm_cmdbuilder_error(avmm_cmdbuilder_error),
	.avmm_cmdbuilder_testbus(avmm_cmdbuilder_testbus)
    );

	// AVMM Read FIFO Write 
	assign int_hip_avmm_writedone = r_avmm1_hip_sel ? hip_aib_avmm_out[9] : 1'b0;
	assign int_pld_avmm_busy = r_avmm1_hip_sel ? 1'b0 : pld_avmm_busy | (r_avmm1_use_rsvd_bit1 & remote_pld_avmm_writedone);
	assign int_pld_avmm_readdatavalid = r_avmm1_hip_sel ? hip_aib_avmm_out[8] : pld_avmm_readdatavalid;

   	always @(negedge avmm_reset_avmm_rst_n or posedge avmm_clock_avmm_clk)
	begin
        	if (~avmm_reset_avmm_rst_n)
         	begin
             		int_pld_avmm_busy_reg <= 1'b0;
          	end
        	else
          	begin
             		int_pld_avmm_busy_reg <= int_pld_avmm_busy;
          	end
     	end 

	assign int_pld_avmm_busy_chg = (int_pld_avmm_busy_reg != int_pld_avmm_busy);

	assign avmm_rdfifo_valid = int_pld_avmm_readdatavalid | int_pld_avmm_busy_chg; 
	assign avmm_rdfifo_wr_en = avmm_rdfifo_valid;

	assign avmm_rdfifo_wr_data0_bit1 = r_avmm1_hip_sel ? hip_aib_avmm_out[9] : pld_avmm_busy;
	assign avmm_rdfifo_wr_data0[1:0] = {avmm_rdfifo_wr_data0_bit1,avmm_rdfifo_valid};
	assign avmm_rdfifo_wr_data1[1:0] = r_avmm1_hip_sel ? {hip_aib_avmm_out[1:0]} : {pld_avmm_readdata[1:0]};
	assign avmm_rdfifo_wr_data2[1:0] = r_avmm1_hip_sel ? {hip_aib_avmm_out[3:2]} : {pld_avmm_readdata[3:2]};
	assign avmm_rdfifo_wr_data3[1:0] = r_avmm1_hip_sel ? {hip_aib_avmm_out[5:4]} : {pld_avmm_readdata[5:4]};
	assign avmm_rdfifo_wr_data4[1:0] = r_avmm1_hip_sel ? {hip_aib_avmm_out[7:6]} : {pld_avmm_readdata[7:6]};
	assign avmm_rdfifo_wr_data5[1:0] = r_avmm1_hip_sel ? {hip_aib_avmm_out[10],hip_aib_avmm_out[8]} : {pld_avmm_reserved_in[0],pld_avmm_readdatavalid};
	assign avmm_rdfifo_wr_data6[1:0] = r_avmm1_hip_sel ? {hip_aib_avmm_out[12:11]} : {pld_avmm_reserved_in[2:1]};
	//assign avmm_rdfifo_wr_data7[1:0] = r_avmm1_hip_sel ? {hip_aib_avmm_out[14:13]} : {avmm_rdfifo_valid,avmm_rdfifo_parity};
	assign avmm_rdfifo_wr_data7[1:0] = {avmm_rdfifo_valid,avmm_rdfifo_parity};
	assign nc_hip_aib_avmm_out[1:0] = hip_aib_avmm_out[14:13];

	assign avmm_rdfifo_parity_data[14:0] = {avmm_rdfifo_wr_data7[1],avmm_rdfifo_wr_data6[1:0],avmm_rdfifo_wr_data5[1:0],avmm_rdfifo_wr_data4[1:0],avmm_rdfifo_wr_data3[1:0],avmm_rdfifo_wr_data2[1:0],avmm_rdfifo_wr_data1[1:0],avmm_rdfifo_wr_data0[1:0]};

	assign avmm_rdfifo_rd_en = ~avmm_rdfifo_rd_empty_raw & ~avmm_rdfifo_rd_en_reg; 
	assign aib_hssi_avmm_data_out_pre = avmm_rdfifo_rd_en		? avmm_rdfifo_rd_data[0]	:
					    avmm_rdfifo_rd_en_reg	? avmm_rdfifo_rd_data_reg	:
									  1'b0				;

	// AVMM Read FIFO Read 
   	always @(negedge avmm_reset_tx_osc_clk_rst_n or posedge avmm_clock_tx_osc_clk)
	begin
        	if (~avmm_reset_tx_osc_clk_rst_n)
         	begin
			avmm_rdfifo_rd_en_reg <= 1'b0;
			avmm_rdfifo_rd_data_reg <= 1'b0;
             		aib_hssi_avmm_data_out <= 1'b0;
          	end
        	else
          	begin
			avmm_rdfifo_rd_en_reg <= avmm_rdfifo_rd_en;
			avmm_rdfifo_rd_data_reg <= avmm_rdfifo_rd_en ? avmm_rdfifo_rd_data[1] : 1'b0;
			aib_hssi_avmm_data_out <= aib_hssi_avmm_data_out_pre; 
          	end
     	end 

c3aibadapt_cmn_parity_gen
    #(
        .WIDTH(15)
    ) adapt_cmn_parity_gen_avmm_rdfifo
    (
        .data(avmm_rdfifo_parity_data[14:0]),
        .parity(avmm_rdfifo_parity)
    );

c3aibadapt_avmm_rdfifo
    #(  
    	.DWIDTH(2),   	// FIFO Input Data Width
    	.AWIDTH(6)   	// FIFO Depth (Address Width)
    ) adapt_avmm1_rdfifo
    (
	.wr_rst_n(avmm_reset_avmm_rst_n),	// Write Domain Active low Reset
	.wr_srst_n(1'b1),			// Write Domain Active low Reset Synchronous
	.wr_clk(avmm_clock_avmm_clk),		// Write Domain Clock
	.wr_en(avmm_rdfifo_wr_en),		// Write Data Enable
	.wr_data(avmm_rdfifo_wr_data0),		// Write Data In
	.wr_data1(avmm_rdfifo_wr_data1),       // Write Data In1
	.wr_data2(avmm_rdfifo_wr_data2),       // Write Data In2
	.wr_data3(avmm_rdfifo_wr_data3),       // Write Data In3
	.wr_data4(avmm_rdfifo_wr_data4),       // Write Data In4
	.wr_data5(avmm_rdfifo_wr_data5),       // Write Data In5
	.wr_data6(avmm_rdfifo_wr_data6),       // Write Data In6
	.wr_data7(avmm_rdfifo_wr_data7),       // Write Data In7
	.rd_rst_n(avmm_reset_tx_osc_clk_rst_n),	// Read Domain Active low Reset
	.rd_srst_n(1'b1),			// Read Domain Active low Reset Synchronous
	.rd_clk(avmm_clock_tx_osc_clk),	// Read Domain Clock
	.rd_en(avmm_rdfifo_rd_en),		// Read Data Enable
	.r_pempty(6'b000000),			// FIFO partially empty threshold
	.r_pfull(6'b111111),			// FIFO partially full threshold
	//.r_empty(6'b000000),			// FIFO empty threshold
	//.r_full(6'b111111),			// FIFO full threshold
	//.r_stop_read(1'b1),			// Disable/enable reading when FIFO is empty
	//.r_stop_write(1'b1),			// Disable/enable writing when FIFO is full
	//.r_pempty(r_avmm1_rdfifo_pempty),           // FIFO partially empty threshold
	//.r_pfull(r_avmm1_rdfifo_pfull),             // FIFO partially full threshold
	.r_empty(r_avmm1_rdfifo_empty),		// FIFO empty threshold
	.r_full(r_avmm1_rdfifo_full),			// FIFO full threshold
	.r_stop_read(r_avmm1_rdfifo_stop_read),	// Disable/enable reading when FIFO is empty
	.r_stop_write(r_avmm1_rdfifo_stop_write),	// Disable/enable writing when FIFO is full
	.rd_data(avmm_rdfifo_rd_data),		// Read Data Out
	.wr_empty(),				// FIFO Empty
	.wr_pempty(),				// FIFO Partial Empty
	.wr_full(avmm_rdfifo_wr_full),		// FIFO Full
	.wr_pfull(),				// FIFO Partial Full
	.rd_empty(avmm_rdfifo_rd_empty_raw),	// FIFO Empty
	.rd_pempty(),				// FIFO Partial Empty
	.rd_full(),				// FIFO Full 
	.rd_pfull()				// FIFO Partial Full 
    );

c3aibadapt_cmn_pulse_stretch
    #(
        .RESET_VAL(1)   // Reset Value
    ) adapt_cmn_pulse_stretch_rdfifo_rd_empty
    (
        .clk            (avmm_clock_tx_osc_clk),
        .rst_n          (avmm_reset_tx_osc_clk_rst_n),
        .num_stages     (3'b011),
        .data_in        (avmm_rdfifo_rd_empty_raw),
        .data_out       (avmm_rdfifo_rd_empty)
    );

endmodule // c3aibadapt_avmm1_transfer
