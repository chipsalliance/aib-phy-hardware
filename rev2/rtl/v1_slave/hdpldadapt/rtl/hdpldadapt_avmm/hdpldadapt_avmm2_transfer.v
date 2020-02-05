// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module hdpldadapt_avmm2_transfer
(
	input	wire		avmm_clock_rx_osc_clk,
	input	wire		avmm_clock_tx_osc_clk,
	input	wire		avmm_clock_avmm_clk,
	input	wire		avmm_reset_rx_osc_clk_rst_n,
	input	wire		avmm_reset_tx_osc_clk_rst_n,
	input	wire		avmm_reset_avmm_rst_n,
	input	wire 		aib_fabric_avmm_data_in,
	input	wire		pld_avmm_read,
	input	wire [8:0]	pld_avmm_reg_addr,
	input	wire		pld_avmm_request,
	input	wire		pld_avmm_write,
	input	wire [7:0]	pld_avmm_writedata,
	input   wire [9:0]      pld_avmm_reserved_in,
	input	wire		hip_avmm_read,
	input	wire [20:0]	hip_avmm_reg_addr,
	input	wire		hip_avmm_write,
	input	wire [7:0]	hip_avmm_writedata,
	input   wire            nfrzdrv_in,
	input   wire            usermode_in,
	input	wire		sr_hssi_avmm_busy,
	//input   wire [55:0]	avmm2_csr_ctrl,
	//input	wire [5:0]      r_avmm2_cmdfifo_pempty,
	input	wire [5:0]      r_avmm2_cmdfifo_pfull,
	input	wire [5:0]      r_avmm2_cmdfifo_empty,
	input	wire [5:0]      r_avmm2_cmdfifo_full,
	input	wire            r_avmm2_cmdfifo_stop_read,
	input	wire            r_avmm2_cmdfifo_stop_write,
	//input	wire [5:0]      r_avmm2_rdfifo_pempty,
	//input	wire [5:0]      r_avmm2_rdfifo_pfull,
	input	wire [5:0]      r_avmm2_rdfifo_empty,
	input	wire [5:0]      r_avmm2_rdfifo_full,
	input	wire            r_avmm2_rdfifo_stop_read,
	input	wire            r_avmm2_rdfifo_stop_write,
	input	wire            r_avmm2_hip_sel,
	input	wire		r_avmm2_gate_dis,
	output	reg [1:0]	aib_fabric_avmm_data_out,
	output	wire		pld_avmm_busy,
	output	wire [7:0]	pld_avmm_readdata,
	output	wire		pld_avmm_readdatavalid,
	output  wire [2:0]      pld_avmm_reserved_out,
	output	wire		hip_avmm_writedone,
	output	wire [7:0]	hip_avmm_readdata,
	output	wire		hip_avmm_readdatavalid,
	output	wire [4:0]      hip_avmm_reserved_out,
	output	wire		pld_avmm_cmdfifo_wr_full,
	output	wire		pld_avmm_cmdfifo_wr_pfull,
	output  wire            avmm_transfer_error,
	output	wire [10:0]	avmm_transfer_testbus
);

	wire		sync_usermode_in;
	wire		int_pld_avmm_request;
	wire		int_pld_avmm_write;
	wire		int_pld_avmm_read;
	reg		int_pld_avmm_request_reg;
	wire		int_pld_avmm_request_chg;
	wire		avmm_cmdfifo_valid;
	wire		avmm_cmdfifo_wr_en;
	wire		avmm_cmdfifo_wr_data0_bit1;
	wire		avmm_cmdfifo_wr_data0_bit2;
	wire [3:0]	avmm_cmdfifo_wr_data0;
	wire [3:0]	avmm_cmdfifo_wr_data1;
	wire [3:0]	avmm_cmdfifo_wr_data2;
	wire [3:0]	avmm_cmdfifo_wr_data3;
	wire [3:0]	avmm_cmdfifo_wr_data4;
	wire [3:0]	avmm_cmdfifo_wr_data5;
	wire [3:0]	avmm_cmdfifo_wr_data6;
	wire [3:0]	avmm_cmdfifo_wr_data7;
	wire [30:0]     avmm_cmdfifo_parity_data;
        wire            avmm_cmdfifo_parity;
	wire		int_pld_avmm_cmdfifo_wr_full;
	wire		int_pld_avmm_cmdfifo_wr_pfull;
	wire		avmm_cmdfifo_rd_en;
	reg		avmm_cmdfifo_rd_en_reg;
	wire		avmm_cmdfifo_rd_empty_raw;
	wire		avmm_cmdfifo_rd_empty;
	wire [3:0]	avmm_cmdfifo_rd_data;
	reg [1:0]	avmm_cmdfifo_rd_data_reg;
	wire [1:0]	aib_fabric_avmm_data_out_pre;

	reg 		aib_fabric_avmm_data_in_reg;
	reg 		aib_fabric_avmm_data_in_reg2;
	reg [3:0]	avmm_rdfifo_wr_cnt;
	wire		avmm_rdfifo_valid;
	wire		avmm_rdfifo_wr_en;
	wire [1:0]	avmm_rdfifo_wr_data;
	wire		avmm_rdfifo_wr_full_raw;
	wire		avmm_rdfifo_wr_full;
	wire		avmm_rdfifo_rd_en;
	wire		avmm_rdfifo_rd_empty;
	wire [1:0]	avmm_rdfifo_rd_data0;
	wire [1:0]	avmm_rdfifo_rd_data1;
	wire [1:0]	avmm_rdfifo_rd_data2;
	wire [1:0]	avmm_rdfifo_rd_data3;
	wire [1:0]	avmm_rdfifo_rd_data4;
	wire [1:0]	avmm_rdfifo_rd_data5;
	wire [1:0]	avmm_rdfifo_rd_data6;
	wire [1:0]	avmm_rdfifo_rd_data7;
	wire [15:0]     avmm_rdfifo_rd_data;
	wire [14:0]     avmm_rdfifo_parity_data;
	wire		avmm_rdfifo_parity_received;
        wire            avmm_rdfifo_parity_error;
	wire		avmm_rdfifo_pld_avmm_valid_error;
	wire		avmm_rdfifo_hip_avmm_valid_error;
        reg		avmm_rdfifo_valid_error;
	reg		int_pld_avmm_busy;
	wire		sync_sr_hssi_avmm_busy;
	reg		avmm_busy_select;
	reg		int_pld_avmm_busy_mux;
	reg [7:0]	int_pld_avmm_readdata;
	reg		int_pld_avmm_readdatavalid;
	reg [2:0]	int_pld_avmm_reserved_out;
	reg		int_hip_avmm_writedone;
	reg [7:0]	int_hip_avmm_readdata;
	reg		int_hip_avmm_readdatavalid;
	reg [4:0]	int_hip_avmm_reserved_out;	


	// AVMM Command FIFO Write 

cdclib_bitsync2
    #(
        .DWIDTH      (1),       // Sync Data input
        .RESET_VAL   (0),       // Reset value
        .CLK_FREQ_MHZ(200),
        .TOGGLE_TYPE (2),
        .VID         (1)
    ) cdclib_bitsync2_usermode_in
    (
      .clk      (avmm_clock_avmm_clk),
      .rst_n    (avmm_reset_avmm_rst_n),
      .data_in  (usermode_in),
      .data_out (sync_usermode_in)
    );

	assign int_pld_avmm_request = (~r_avmm2_gate_dis && ~sync_usermode_in) ? 1'b0 :
				      r_avmm2_hip_sel ? 1'b0 : pld_avmm_request;	  
	assign int_pld_avmm_write = (~r_avmm2_gate_dis && ~sync_usermode_in) ? 1'b0 :
				    r_avmm2_hip_sel ? hip_avmm_write : pld_avmm_write;
	assign int_pld_avmm_read = (~r_avmm2_gate_dis && ~sync_usermode_in) ? 1'b0 :
				   r_avmm2_hip_sel ? hip_avmm_read : pld_avmm_read;
	
	assign pld_avmm_busy = nfrzdrv_in ? int_pld_avmm_busy_mux : 1'b1;
	assign pld_avmm_readdatavalid = nfrzdrv_in ? int_pld_avmm_readdatavalid : 1'b1;
	assign pld_avmm_readdata[7:0] = nfrzdrv_in ? int_pld_avmm_readdata[7:0] : 8'hFF;
	assign pld_avmm_reserved_out[2:0] = nfrzdrv_in ? int_pld_avmm_reserved_out[2:0] : 3'b111;
	assign hip_avmm_writedone = nfrzdrv_in ? int_hip_avmm_writedone : 1'b1;
	assign hip_avmm_readdata[7:0] = nfrzdrv_in ? int_hip_avmm_readdata[7:0] : 8'hFF;
	assign hip_avmm_readdatavalid = nfrzdrv_in ? int_hip_avmm_readdatavalid : 1'b1;
	assign hip_avmm_reserved_out[4:0] = nfrzdrv_in ? int_hip_avmm_reserved_out[4:0] : 5'b11111;

	assign pld_avmm_cmdfifo_wr_full = nfrzdrv_in ? int_pld_avmm_cmdfifo_wr_full : 1'b1;
	assign pld_avmm_cmdfifo_wr_pfull = nfrzdrv_in ? int_pld_avmm_cmdfifo_wr_pfull : 1'b1;

	assign avmm_transfer_error = avmm_rdfifo_valid_error | avmm_rdfifo_parity_error;

	assign avmm_transfer_testbus[10:0] = {avmm_rdfifo_wr_full,avmm_rdfifo_rd_empty,avmm_rdfifo_wr_cnt[3:0],avmm_rdfifo_wr_en,avmm_rdfifo_valid,avmm_cmdfifo_rd_en,avmm_cmdfifo_rd_empty,avmm_cmdfifo_valid};

   	always @(negedge avmm_reset_avmm_rst_n or posedge avmm_clock_avmm_clk)
	begin
        	if (~avmm_reset_avmm_rst_n)
         	begin
             		int_pld_avmm_request_reg <= 1'b0;
          	end
        	else
          	begin
             		int_pld_avmm_request_reg <= int_pld_avmm_request;
          	end
     	end 

	assign int_pld_avmm_request_chg = (int_pld_avmm_request_reg != int_pld_avmm_request);

	assign avmm_cmdfifo_valid = int_pld_avmm_read | int_pld_avmm_write | int_pld_avmm_request_chg; 
	assign avmm_cmdfifo_wr_en = avmm_cmdfifo_valid;

	assign avmm_cmdfifo_wr_data0_bit1 = r_avmm2_hip_sel ? hip_avmm_reg_addr[20] : pld_avmm_write;
	assign avmm_cmdfifo_wr_data0_bit2 = r_avmm2_hip_sel ? hip_avmm_write : pld_avmm_request;
	assign avmm_cmdfifo_wr_data0[3:0] = {int_pld_avmm_read,avmm_cmdfifo_wr_data0_bit2,avmm_cmdfifo_wr_data0_bit1,avmm_cmdfifo_valid};
	assign avmm_cmdfifo_wr_data1[3:0] = r_avmm2_hip_sel ? {hip_avmm_reg_addr[3:0]} : {pld_avmm_reg_addr[3:0]};
	assign avmm_cmdfifo_wr_data2[3:0] = r_avmm2_hip_sel ? {hip_avmm_reg_addr[7:4]} : {pld_avmm_reg_addr[7:4]};
	assign avmm_cmdfifo_wr_data3[3:0] = r_avmm2_hip_sel ? {hip_avmm_reg_addr[11:8]} : {pld_avmm_reserved_in[2:0],pld_avmm_reg_addr[8]};
	assign avmm_cmdfifo_wr_data4[3:0] = r_avmm2_hip_sel ? {hip_avmm_reg_addr[15:12]} : {pld_avmm_reserved_in[6:3]};
	assign avmm_cmdfifo_wr_data5[3:0] = r_avmm2_hip_sel ? {hip_avmm_reg_addr[19:16]} : {avmm_cmdfifo_parity,pld_avmm_reserved_in[9:7]};
	assign avmm_cmdfifo_wr_data6[3:0] = r_avmm2_hip_sel ? {hip_avmm_writedata[3:0]} : {pld_avmm_writedata[3:0]};
	assign avmm_cmdfifo_wr_data7[3:0] = r_avmm2_hip_sel ? {hip_avmm_writedata[7:4]} : {pld_avmm_writedata[7:4]};

        assign avmm_cmdfifo_parity_data[30:0] = {avmm_cmdfifo_wr_data7[3:0],avmm_cmdfifo_wr_data6[3:0],avmm_cmdfifo_wr_data5[2:0],avmm_cmdfifo_wr_data4[3:0],avmm_cmdfifo_wr_data3[3:0],avmm_cmdfifo_wr_data2[3:0],avmm_cmdfifo_wr_data1[3:0],avmm_cmdfifo_wr_data0[3:0]};

        assign avmm_cmdfifo_rd_en = ~avmm_cmdfifo_rd_empty_raw & ~avmm_cmdfifo_rd_en_reg;
        assign aib_fabric_avmm_data_out_pre[1:0] = avmm_cmdfifo_rd_en           ? {avmm_cmdfifo_rd_data[1:0]}           :
                                                   avmm_cmdfifo_rd_en_reg       ? {avmm_cmdfifo_rd_data_reg[1:0]}       :
                                                                                  {2'b00}				;

	// AVMM Command FIFO Read 
   	always @(negedge avmm_reset_tx_osc_clk_rst_n or posedge avmm_clock_tx_osc_clk)
	begin
        	if (~avmm_reset_tx_osc_clk_rst_n)
         	begin
                        avmm_cmdfifo_rd_en_reg <= 1'b0;
                        avmm_cmdfifo_rd_data_reg[1:0] <= 2'b00;
                        aib_fabric_avmm_data_out[1:0] <= 2'b00;
          	end
        	else
          	begin
                        avmm_cmdfifo_rd_en_reg <= avmm_cmdfifo_rd_en;
                        avmm_cmdfifo_rd_data_reg[1:0] <= avmm_cmdfifo_rd_en ? avmm_cmdfifo_rd_data[3:2] : 2'b00;
                        aib_fabric_avmm_data_out[1:0] <= aib_fabric_avmm_data_out_pre[1:0];
          	end
     	end 

hdpldadapt_cmn_parity_gen
    #(
        .WIDTH(31)
    ) hdpldadapt_cmn_parity_gen_avmm_cmdfifo
    (
        .data(avmm_cmdfifo_parity_data[30:0]),
        .parity(avmm_cmdfifo_parity)
    );

hdpldadapt_avmm_cmdfifo
    #(  
    	.DWIDTH(4),   	// FIFO Input Data Width
    	.AWIDTH(6)   	// FIFO Depth (Address Width)
    ) hdpldadapt_avmm_cmdfifo
    (
	.wr_rst_n(avmm_reset_avmm_rst_n),	// Write Domain Active low Reset
	.wr_srst_n(1'b1),			// Write Domain Active low Reset Synchronous
	.wr_clk(avmm_clock_avmm_clk),		// Write Domain Clock
	.wr_en(avmm_cmdfifo_wr_en),		// Write Data Enable
	.wr_data(avmm_cmdfifo_wr_data0),	// Write Data In
	.wr_data1(avmm_cmdfifo_wr_data1),	// Write Data In1
	.wr_data2(avmm_cmdfifo_wr_data2),	// Write Data In2
	.wr_data3(avmm_cmdfifo_wr_data3),	// Write Data In3
	.wr_data4(avmm_cmdfifo_wr_data4),	// Write Data In4
	.wr_data5(avmm_cmdfifo_wr_data5),	// Write Data In5
	.wr_data6(avmm_cmdfifo_wr_data6),	// Write Data In6
	.wr_data7(avmm_cmdfifo_wr_data7),	// Write Data In7
	.rd_rst_n(avmm_reset_tx_osc_clk_rst_n),	// Read Domain Active low Reset
	.rd_srst_n(1'b1),			// Read Domain Active low Reset Synchronous
	.rd_clk(avmm_clock_tx_osc_clk),		// Read Domain Clock
	.rd_en(avmm_cmdfifo_rd_en),		// Read Data Enable
	.r_pempty(6'b000000),			// FIFO partially empty threshold
	//.r_pfull(6'b111111),			// FIFO partially full threshold
	//.r_empty(6'b000000),			// FIFO empty threshold
	//.r_full(6'b111111),			// FIFO full threshold
	//.r_stop_read(1'b1),			// Disable/enable reading when FIFO is empty
	//.r_stop_write(1'b1),			// Disable/enable writing when FIFO is full
	//.r_pempty(r_avmm2_cmdfifo_pempty),		// FIFO partially empty threshold
	.r_pfull(r_avmm2_cmdfifo_pfull),              // FIFO partially full threshold
	.r_empty(r_avmm2_cmdfifo_empty),              // FIFO empty threshold
	.r_full(r_avmm2_cmdfifo_full),                // FIFO full threshold
	.r_stop_read(r_avmm2_cmdfifo_stop_read),	// Disable/enable reading when FIFO is empty
	.r_stop_write(r_avmm2_cmdfifo_stop_write),	// Disable/enable writing when FIFO is full
	.rd_data(avmm_cmdfifo_rd_data),		// Read Data Out
	.wr_empty(),				// FIFO Empty
	.wr_pempty(),				// FIFO Partial Empty
	.wr_full(int_pld_avmm_cmdfifo_wr_full),		// FIFO Full
	.wr_pfull(int_pld_avmm_cmdfifo_wr_pfull),	// FIFO Partial Full
	.rd_empty(avmm_cmdfifo_rd_empty_raw),	// FIFO Empty
	.rd_pempty(),				// FIFO Partial Empty
	.rd_full(),				// FIFO Full 
	.rd_pfull()				// FIFO Partial Full 
    );

hdpldadapt_cmn_pulse_stretch
    #(
	.RESET_VAL(1)   // Reset Value
    ) hdpldadapt_cmn_pulse_stretch_cmdfifo_rd_empty
    (
	.clk            (avmm_clock_tx_osc_clk),
	.rst_n          (avmm_reset_tx_osc_clk_rst_n),
	.num_stages     (3'b011),
	.data_in        (avmm_cmdfifo_rd_empty_raw),
	.data_out       (avmm_cmdfifo_rd_empty)
    );

	// AVMM Read FIFO Write 

	// Flop for incoming AVMM data from AIB 
   	always @(negedge avmm_reset_rx_osc_clk_rst_n or posedge avmm_clock_rx_osc_clk)
	begin
        	if (~avmm_reset_rx_osc_clk_rst_n)
         	begin
             		aib_fabric_avmm_data_in_reg <= 1'b0;
             		aib_fabric_avmm_data_in_reg2 <= 1'b0;
          	end
        	else
          	begin
			aib_fabric_avmm_data_in_reg <= aib_fabric_avmm_data_in; 
			aib_fabric_avmm_data_in_reg2 <= aib_fabric_avmm_data_in_reg;
          	end
     	end 

	// Counter to track FIFO write operation
   	always @(negedge avmm_reset_rx_osc_clk_rst_n or posedge avmm_clock_rx_osc_clk)
	begin
        	if (~avmm_reset_rx_osc_clk_rst_n)
         	begin
             		avmm_rdfifo_wr_cnt[3:0] <= 4'b0000;
          	end
        	else
		begin
			if (avmm_rdfifo_valid)
			begin
				avmm_rdfifo_wr_cnt[3:0] <= avmm_rdfifo_wr_cnt[3:0] + 4'b0001;
			end
			else
			begin
				avmm_rdfifo_wr_cnt[3:0] <= 4'b0000;
			end
		end				
     	end 

	assign avmm_rdfifo_valid = (aib_fabric_avmm_data_in_reg == 1'b1) && (avmm_rdfifo_wr_cnt[3:0] == 4'b0000) || (avmm_rdfifo_wr_cnt[3:0] != 4'b0000);
	assign avmm_rdfifo_wr_en = (avmm_rdfifo_wr_cnt[0] == 1'b1);
	assign avmm_rdfifo_wr_data[1:0] = {aib_fabric_avmm_data_in_reg,aib_fabric_avmm_data_in_reg2};

        // AVMM Read FIFO Read
        assign avmm_rdfifo_rd_en = ~avmm_rdfifo_rd_empty;
        assign avmm_rdfifo_rd_data[15:0] = {avmm_rdfifo_rd_data7[1:0],avmm_rdfifo_rd_data6[1:0],avmm_rdfifo_rd_data5[1:0],avmm_rdfifo_rd_data4[1:0],avmm_rdfifo_rd_data3[1:0],avmm_rdfifo_rd_data2[1:0],avmm_rdfifo_rd_data1[1:0],avmm_rdfifo_rd_data0[1:0]};

	//assign avmm_rdfifo_parity_data[14:0] = avmm_rdfifo_rd_en ? {avmm_rdfifo_rd_data[15],avmm_rdfifo_rd_data[13:0]} : 15'h0000;
	//assign avmm_rdfifo_parity_received = avmm_rdfifo_rd_en ? avmm_rdfifo_rd_data[14] : 1'b0;
	assign avmm_rdfifo_parity_data[14:0] = {avmm_rdfifo_rd_data[15],avmm_rdfifo_rd_data[13:0]};
	assign avmm_rdfifo_parity_received = avmm_rdfifo_rd_data[14];

hdpldadapt_cmn_parity_checker
    #(
        .WIDTH(15)
    ) hdpldadapt_cmn_parity_checker_avmm_rdfifo
    (
        .clk(avmm_clock_avmm_clk),
        .rst_n(avmm_reset_avmm_rst_n),
        .data(avmm_rdfifo_parity_data[14:0]),
	.parity_checker_ena(avmm_rdfifo_rd_en),
        .parity_received(avmm_rdfifo_parity_received),
        .parity_error(avmm_rdfifo_parity_error)
    );

	assign avmm_rdfifo_pld_avmm_valid_error = ~r_avmm2_hip_sel & (avmm_rdfifo_rd_data[0] != avmm_rdfifo_rd_data[15]);

	// If valid bit is asserted, bit 15 must be asserted.
	// If valid bit is asserted, writedone OR readdatavalid must be asserted. 
	assign avmm_rdfifo_hip_avmm_valid_error = r_avmm2_hip_sel & ((avmm_rdfifo_rd_data[0] != avmm_rdfifo_rd_data[15]) | (avmm_rdfifo_rd_data[0] & ~avmm_rdfifo_rd_data[1] & ~avmm_rdfifo_rd_data[10]));

        always @(negedge avmm_reset_avmm_rst_n or posedge avmm_clock_avmm_clk)
        begin
                if (~avmm_reset_avmm_rst_n)
                begin
                        avmm_rdfifo_valid_error <= 1'b0;
                end
                else
                begin
			avmm_rdfifo_valid_error <= avmm_rdfifo_valid_error || ( (avmm_rdfifo_pld_avmm_valid_error | avmm_rdfifo_hip_avmm_valid_error) && avmm_rdfifo_rd_en ) ;
                end
        end

   	always @(negedge avmm_reset_avmm_rst_n or posedge avmm_clock_avmm_clk)
	begin
        	if (~avmm_reset_avmm_rst_n)
         	begin
             		int_pld_avmm_busy <= 1'b0;
          	end
        	else
          	begin
			if (~r_avmm2_hip_sel & avmm_rdfifo_rd_en)
			begin
             			int_pld_avmm_busy <= avmm_rdfifo_rd_data[1];
			end
          	end
     	end 

cdclib_bitsync2
    #(
        .DWIDTH      (1),       // Sync Data input
        .RESET_VAL   (1),       // Reset value
        .CLK_FREQ_MHZ(200),
        .TOGGLE_TYPE (2),
        .VID         (1)
    ) cdclib_bitsync2_sr_hssi_avmm_busy
    (
      .clk      (avmm_clock_avmm_clk),
      .rst_n    (avmm_reset_avmm_rst_n),
      .data_in  (sr_hssi_avmm_busy),
      .data_out (sync_sr_hssi_avmm_busy)
    );

   	always @(negedge avmm_reset_avmm_rst_n or posedge avmm_clock_avmm_clk)
	begin
        	if (~avmm_reset_avmm_rst_n)
         	begin
             		avmm_busy_select <= 1'b1;
          	end
        	else
          	begin
			if (avmm_busy_select)
			begin
             			avmm_busy_select <= sync_sr_hssi_avmm_busy;
			end
          	end
     	end 

   	always @(negedge avmm_reset_avmm_rst_n or posedge avmm_clock_avmm_clk)
	begin
        	if (~avmm_reset_avmm_rst_n)
         	begin
             		int_pld_avmm_busy_mux <= 1'b1;
          	end
        	else
          	begin
			if (avmm_busy_select)
			begin
             			int_pld_avmm_busy_mux <= sync_sr_hssi_avmm_busy;
			end
			else
			begin
             			int_pld_avmm_busy_mux <= int_pld_avmm_busy;
			end
          	end
     	end 

   	always @(negedge avmm_reset_avmm_rst_n or posedge avmm_clock_avmm_clk)
	begin
        	if (~avmm_reset_avmm_rst_n)
         	begin
             		int_pld_avmm_readdata[7:0] <= 8'b00000000;
             		int_pld_avmm_readdatavalid <= 1'b0;
			int_pld_avmm_reserved_out[2:0] <= 3'b000;
          	end
        	else
          	begin
			if (~r_avmm2_hip_sel & avmm_rdfifo_rd_en & ~avmm_rdfifo_rd_data[1] & ~int_pld_avmm_busy) // De-assertion of AVMM busy bit and assertion of readdatavalid are mutually exclusive
			//if (~r_avmm2_hip_sel & avmm_rdfifo_rd_en & ~avmm_rdfifo_rd_data[1]) // De-assertion of AVMM busy bit and assertion of readdatavalid can happen concurrently
			begin
             			int_pld_avmm_readdata[7:0] <= avmm_rdfifo_rd_data[9:2];
             			int_pld_avmm_readdatavalid <= avmm_rdfifo_rd_data[10];
				int_pld_avmm_reserved_out[2:0] <= avmm_rdfifo_rd_data[13:11];
			end
			else
			begin
             			int_pld_avmm_readdata[7:0] <= 8'b00000000;
             			int_pld_avmm_readdatavalid <= 1'b0;
				int_pld_avmm_reserved_out[2:0] <= 3'b000;
			end
          	end
     	end 

   	always @(negedge avmm_reset_avmm_rst_n or posedge avmm_clock_avmm_clk)
	begin
        	if (~avmm_reset_avmm_rst_n)
         	begin
             		int_hip_avmm_writedone <= 1'b0;
             		int_hip_avmm_readdata[7:0] <= 8'b00000000;
             		int_hip_avmm_readdatavalid <= 1'b0;
			int_hip_avmm_reserved_out[4:0] <= 5'b00000;
          	end
        	else
          	begin
			if (r_avmm2_hip_sel & avmm_rdfifo_rd_en)
			begin	
             			int_hip_avmm_writedone <= avmm_rdfifo_rd_data[1];
             			//int_hip_avmm_readdata[7:0] <= ~avmm_rdfifo_rd_data[1] ? avmm_rdfifo_rd_data[9:2] : 8'b00000000;
             			//int_hip_avmm_readdatavalid <= ~avmm_rdfifo_rd_data[1];
				int_hip_avmm_readdata[7:0] <= avmm_rdfifo_rd_data[10] ? avmm_rdfifo_rd_data[9:2] : 8'b00000000;
				int_hip_avmm_readdatavalid <= avmm_rdfifo_rd_data[10];
				int_hip_avmm_reserved_out[4:0] <= avmm_rdfifo_rd_data[15:11];	// bit 15 is valid bit, bit 14 is parity bit.
			end
			else
			begin
             			int_hip_avmm_writedone <= 1'b0;
             			int_hip_avmm_readdata[7:0] <= 8'b00000000;
             			int_hip_avmm_readdatavalid <= 1'b0;
				int_hip_avmm_reserved_out[4:0] <= 5'b00000;
			end
          	end
     	end 

hdpldadapt_avmm_rdfifo
    #(  
    	.DWIDTH(2),   	// FIFO Input Data Width
    	.AWIDTH(6)   	// FIFO Depth (Address Width)
    ) hdpldadapt_avmm_rdfifo
    (
	.wr_rst_n(avmm_reset_rx_osc_clk_rst_n),	// Write Domain Active low Reset
	.wr_srst_n(1'b1),			// Write Domain Active low Reset Synchronous
	.wr_clk(avmm_clock_rx_osc_clk),		// Write Domain Clock
	.wr_en(avmm_rdfifo_wr_en),		// Write Data Enable
	.wr_data(avmm_rdfifo_wr_data),		// Write Data In
	.rd_rst_n(avmm_reset_avmm_rst_n),	// Read Domain Active low Reset
	.rd_srst_n(1'b1),			// Read Domain Active low Reset Synchronous
	.rd_clk(avmm_clock_avmm_clk),		// Read Domain Clock
	.rd_en(avmm_rdfifo_rd_en),		// Read Data Enable
	.r_pempty(6'b000000),			// FIFO partially empty threshold
	.r_pfull(6'b111111),			// FIFO partially full threshold
	//.r_empty(6'b000000),			// FIFO empty threshold
	//.r_full(6'b111111),			// FIFO full threshold
	//.r_stop_read(1'b1),			// Disable/enable reading when FIFO is empty
	//.r_stop_write(1'b1),			// Disable/enable writing when FIFO is full
	//.r_pempty(r_avmm2_rdfifo_pempty),		// FIFO partially empty threshold
	//.r_pfull(r_avmm2_rdfifo_pfull),		// FIFO partially full threshold
	.r_empty(r_avmm2_rdfifo_empty),		// FIFO empty threshold
	.r_full(r_avmm2_rdfifo_full),                 // FIFO full threshold
	.r_stop_read(r_avmm2_rdfifo_stop_read),	// Disable/enable reading when FIFO is empty
	.r_stop_write(r_avmm2_rdfifo_stop_write),	// Disable/enable writing when FIFO is full
	.rd_data(avmm_rdfifo_rd_data0),		// Read Data Out
	.rd_data1(avmm_rdfifo_rd_data1),	// Read Data Out
	.rd_data2(avmm_rdfifo_rd_data2),	// Read Data Out
	.rd_data3(avmm_rdfifo_rd_data3),	// Read Data Out
	.rd_data4(avmm_rdfifo_rd_data4),	// Read Data Out
	.rd_data5(avmm_rdfifo_rd_data5),	// Read Data Out
	.rd_data6(avmm_rdfifo_rd_data6),	// Read Data Out
	.rd_data7(avmm_rdfifo_rd_data7),	// Read Data Out
	.wr_empty(),				// FIFO Empty
	.wr_pempty(),				// FIFO Partial Empty
	.wr_full(avmm_rdfifo_wr_full_raw),	// FIFO Full
	.wr_pfull(),				// FIFO Partial Full
	.rd_empty(avmm_rdfifo_rd_empty),	// FIFO Empty
	.rd_pempty(),				// FIFO Partial Empty
	.rd_full(),				// FIFO Full 
	.rd_pfull()				// FIFO Partial Full 
    );

hdpldadapt_cmn_pulse_stretch
    #(
	.RESET_VAL(0)   // Reset Value
    ) hdpldadapt_cmn_pulse_stretch_rdfifo_wr_full
    (
	.clk            (avmm_clock_rx_osc_clk),
	.rst_n          (avmm_reset_rx_osc_clk_rst_n),
	.num_stages     (3'b011),
	.data_in        (avmm_rdfifo_wr_full_raw),
	.data_out       (avmm_rdfifo_wr_full)
    );

endmodule // hdpldadapt_avmm2_transfer
