// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3aibadapt_avmm_cmdbuilder
(
	input	wire		avmm_clock_rx_osc_clk,
	input	wire		avmm_clock_avmm_clk,
	input	wire		avmm_reset_rx_osc_clk_rst_n,
	input	wire		avmm_reset_avmm_rst_n,
	input	wire [1:0]	aib_hssi_avmm_data_in,
	input	wire		r_avmm_hip_sel,
	output	reg		pld_avmm_read,
	output	reg [9:0]	pld_avmm_reg_addr,
	output	reg		pld_avmm_request,
	output	reg		pld_avmm_write,
	output	reg [7:0]	pld_avmm_writedata,
	output	reg [8:0]	pld_avmm_reserved_out,
	output	reg [30:0]	hip_aib_avmm_in,
	output	reg 		avmm_cmdbuilder_dcg_ungate,
	output	wire		avmm_cmdbuilder_error,
	output	wire [8:0]	avmm_cmdbuilder_testbus
);
        timeunit 100ps;
        timeprecision 1ps;

	reg [1:0]	aib_hssi_avmm_data_in_reg;
	wire		avmm_cmd_cnt_en;
	reg [3:0]	avmm_cmd_cnt;
	reg [1:0]	avmm_cmd_shift_reg1;
	reg [1:0]	avmm_cmd_shift_reg2;
	reg [1:0]	avmm_cmd_shift_reg3;
	reg [1:0]	avmm_cmd_shift_reg4;
	reg [1:0]	avmm_cmd_shift_reg5;
	reg [1:0]	avmm_cmd_shift_reg6;
	reg [1:0]	avmm_cmd_shift_reg7;
	reg [1:0]	avmm_cmd_shift_reg8;
	reg [1:0]	avmm_cmd_shift_reg9;
	reg [1:0]	avmm_cmd_shift_reg10;
	reg [1:0]	avmm_cmd_shift_reg11;
	reg [1:0]	avmm_cmd_shift_reg12;
	reg [1:0]	avmm_cmd_shift_reg13;
	reg [1:0]	avmm_cmd_shift_reg14;
	reg [1:0]	avmm_cmd_shift_reg15;
	reg [31:0]	avmm_cmd_32bit_data;
	wire [30:0]	avmm_cmdbuilder_parity_data;
	wire		avmm_cmdbuilder_parity_error;
	reg		avmm_cmdbuilder_pld_avmm_valid_error;
        reg		avmm_cmdbuilder_hip_avmm_valid_error;
	reg		avmm_cmd_load_en;
	reg [2:0]	avmm_cmd_load_cnt;

	assign avmm_cmdbuilder_testbus[8:0] = {avmm_cmd_load_cnt[2:0],avmm_cmd_load_en,avmm_cmd_cnt[3:0],avmm_cmd_cnt_en};

	//assign avmm_cmdbuilder_dcg_ungate = avmm_cmd_cnt_en | avmm_cmd_load_en;
	assign avmm_cmdbuilder_error = avmm_cmdbuilder_pld_avmm_valid_error | avmm_cmdbuilder_hip_avmm_valid_error | (~r_avmm_hip_sel & avmm_cmdbuilder_parity_error);

	// Flop for incoming AVMM data from AIB 
   	always @(negedge avmm_reset_rx_osc_clk_rst_n or posedge avmm_clock_rx_osc_clk)
	begin
        	if (~avmm_reset_rx_osc_clk_rst_n)
         	begin
             		aib_hssi_avmm_data_in_reg[1:0] <= 2'b00;
          	end
        	else
          	begin
			aib_hssi_avmm_data_in_reg[1:0] <= aib_hssi_avmm_data_in[1:0]; 
          	end
     	end 

   	always @(negedge avmm_reset_rx_osc_clk_rst_n or posedge avmm_clock_rx_osc_clk)
	begin
        	if (~avmm_reset_rx_osc_clk_rst_n)
         	begin
             		avmm_cmdbuilder_pld_avmm_valid_error <= 1'b0;
          	end
        	else
          	begin
			avmm_cmdbuilder_pld_avmm_valid_error <= avmm_cmdbuilder_pld_avmm_valid_error || ((~r_avmm_hip_sel & aib_hssi_avmm_data_in_reg[1] & ~aib_hssi_avmm_data_in_reg[0]) && (avmm_cmd_cnt[3:0] == 4'b0000));
          	end
     	end 

	assign avmm_cmd_cnt_en = (aib_hssi_avmm_data_in_reg[0] == 1'b1) && (avmm_cmd_cnt[3:0] == 4'b0000) || (avmm_cmd_cnt[3:0] != 4'b0000); 

	// Counter to track AVMM command 
   	always @(negedge avmm_reset_rx_osc_clk_rst_n or posedge avmm_clock_rx_osc_clk)
	begin
        	if (~avmm_reset_rx_osc_clk_rst_n)
         	begin
             		avmm_cmd_cnt[3:0] <= 4'b0000;
          	end
        	else
		begin
			if (avmm_cmd_cnt_en)
			begin
				avmm_cmd_cnt[3:0] <= avmm_cmd_cnt[3:0] + 4'b0001;
			end
			else
			begin
				avmm_cmd_cnt[3:0] <= 4'b0000;
			end
		end				
     	end 

   	always @(negedge avmm_reset_rx_osc_clk_rst_n or posedge avmm_clock_rx_osc_clk)
	begin
        	if (~avmm_reset_rx_osc_clk_rst_n)
         	begin
             		avmm_cmd_shift_reg1[1:0] <= 2'b00;
             		avmm_cmd_shift_reg2[1:0] <= 2'b00;
             		avmm_cmd_shift_reg3[1:0] <= 2'b00;
             		avmm_cmd_shift_reg4[1:0] <= 2'b00;
             		avmm_cmd_shift_reg5[1:0] <= 2'b00;
             		avmm_cmd_shift_reg6[1:0] <= 2'b00;
             		avmm_cmd_shift_reg7[1:0] <= 2'b00;
             		avmm_cmd_shift_reg8[1:0] <= 2'b00;
             		avmm_cmd_shift_reg9[1:0] <= 2'b00;
             		avmm_cmd_shift_reg10[1:0] <= 2'b00;
             		avmm_cmd_shift_reg11[1:0] <= 2'b00;
             		avmm_cmd_shift_reg12[1:0] <= 2'b00;
             		avmm_cmd_shift_reg13[1:0] <= 2'b00;
             		avmm_cmd_shift_reg14[1:0] <= 2'b00;
             		avmm_cmd_shift_reg15[1:0] <= 2'b00;
          	end
        	else
		begin
             		avmm_cmd_shift_reg1[1:0] <= aib_hssi_avmm_data_in_reg[1:0];
             		avmm_cmd_shift_reg2[1:0] <= avmm_cmd_shift_reg1[1:0];
             		avmm_cmd_shift_reg3[1:0] <= avmm_cmd_shift_reg2[1:0];
             		avmm_cmd_shift_reg4[1:0] <= avmm_cmd_shift_reg3[1:0];
             		avmm_cmd_shift_reg5[1:0] <= avmm_cmd_shift_reg4[1:0];
             		avmm_cmd_shift_reg6[1:0] <= avmm_cmd_shift_reg5[1:0];
             		avmm_cmd_shift_reg7[1:0] <= avmm_cmd_shift_reg6[1:0];
             		avmm_cmd_shift_reg8[1:0] <= avmm_cmd_shift_reg7[1:0];
             		avmm_cmd_shift_reg9[1:0] <= avmm_cmd_shift_reg8[1:0];
             		avmm_cmd_shift_reg10[1:0] <= avmm_cmd_shift_reg9[1:0];
             		avmm_cmd_shift_reg11[1:0] <= avmm_cmd_shift_reg10[1:0];
             		avmm_cmd_shift_reg12[1:0] <= avmm_cmd_shift_reg11[1:0];
             		avmm_cmd_shift_reg13[1:0] <= avmm_cmd_shift_reg12[1:0];
             		avmm_cmd_shift_reg14[1:0] <= avmm_cmd_shift_reg13[1:0];
             		avmm_cmd_shift_reg15[1:0] <= avmm_cmd_shift_reg14[1:0];
		end
	end

   	always @(negedge avmm_reset_rx_osc_clk_rst_n or posedge avmm_clock_rx_osc_clk)
	begin
        	if (~avmm_reset_rx_osc_clk_rst_n)
         	begin
             		avmm_cmd_32bit_data[31:0] <= #1 32'h00000000;
		end
		else
		begin
			if (avmm_cmd_cnt[3:0] ==4'b1111)
			begin
				avmm_cmd_32bit_data[31:0] <= #1 {aib_hssi_avmm_data_in_reg[1:0],avmm_cmd_shift_reg1[1:0],avmm_cmd_shift_reg2[1:0],avmm_cmd_shift_reg3[1:0],avmm_cmd_shift_reg4[1:0],avmm_cmd_shift_reg5[1:0],avmm_cmd_shift_reg6[1:0],avmm_cmd_shift_reg7[1:0],avmm_cmd_shift_reg8[1:0],avmm_cmd_shift_reg9[1:0],avmm_cmd_shift_reg10[1:0],avmm_cmd_shift_reg11[1:0],avmm_cmd_shift_reg12[1:0],avmm_cmd_shift_reg13[1:0],avmm_cmd_shift_reg14[1:0],avmm_cmd_shift_reg15[1:0]};
			end
		end
	end

   	always @(negedge avmm_reset_rx_osc_clk_rst_n or posedge avmm_clock_rx_osc_clk)
	begin
        	if (~avmm_reset_rx_osc_clk_rst_n)
         	begin
             		avmm_cmd_load_en <= #1 1'b0;
		end
		else
		begin
			avmm_cmd_load_en <= #1 (avmm_cmd_cnt[3:0] == 4'b1111) || (avmm_cmd_load_en && (avmm_cmd_load_cnt[2:0] != 3'b111));
		end
	end

	// Counter to hold AVMM command load pulse before clearing
   	always @(negedge avmm_reset_rx_osc_clk_rst_n or posedge avmm_clock_rx_osc_clk)
	begin
        	if (~avmm_reset_rx_osc_clk_rst_n)
         	begin
             		avmm_cmd_load_cnt[2:0] <= 3'b000;
          	end
        	else
		begin
			if (avmm_cmd_load_en)
			begin
				avmm_cmd_load_cnt[2:0] <= avmm_cmd_load_cnt[2:0] + 3'b001;
			end
			else
			begin
				avmm_cmd_load_cnt[2:0] <= 3'b000;
			end
		end				
     	end 

   	always @(negedge avmm_reset_avmm_rst_n or posedge avmm_clock_avmm_clk)
	begin
        	if (~avmm_reset_avmm_rst_n)
         	begin
             		avmm_cmdbuilder_dcg_ungate <= 1'b0;
          	end
        	else
          	begin
             		avmm_cmdbuilder_dcg_ungate <= avmm_cmd_load_en;
          	end
     	end 

   	always @(negedge avmm_reset_avmm_rst_n or posedge avmm_clock_avmm_clk)
	begin
        	if (~avmm_reset_avmm_rst_n)
         	begin
             		pld_avmm_request <= 1'b0;
          	end
        	else
          	begin
			if (~r_avmm_hip_sel & avmm_cmd_load_en)
			begin
             			pld_avmm_request <= avmm_cmd_32bit_data[2];
			end
          	end
     	end 

   	always @(negedge avmm_reset_avmm_rst_n or posedge avmm_clock_avmm_clk)
	begin
        	if (~avmm_reset_avmm_rst_n)
         	begin
             		pld_avmm_write <= 1'b0;
             		pld_avmm_read <= 1'b0;
			pld_avmm_reg_addr[9:0] <= 10'b1111111111;
			pld_avmm_reserved_out[8:0] <= 9'b111111111;
             		pld_avmm_writedata[7:0] <= 8'b11111111;
          	end
        	else
          	begin
			if (~r_avmm_hip_sel & avmm_cmd_load_en)
			begin
				pld_avmm_write <= avmm_cmd_32bit_data[1];
				pld_avmm_read <= avmm_cmd_32bit_data[3];
				pld_avmm_reg_addr[9:0] <= avmm_cmd_32bit_data[13:4];
             			pld_avmm_reserved_out[8:0] <= avmm_cmd_32bit_data[22:14];
             			pld_avmm_writedata[7:0] <= avmm_cmd_32bit_data[31:24];
			end
			else
			begin
             			pld_avmm_write <= 1'b0;
             			pld_avmm_read <= 1'b0;
				pld_avmm_reg_addr[9:0] <= 10'b0000000000;
				pld_avmm_reserved_out[8:0] <= 9'b000000000;
             			pld_avmm_writedata[7:0] <= 8'b00000000;
			end
          	end
     	end 

   	always @(negedge avmm_reset_avmm_rst_n or posedge avmm_clock_avmm_clk)
	begin
        	if (~avmm_reset_avmm_rst_n)
         	begin
             		hip_aib_avmm_in[30:0] <= 31'b0;
          	end
        	else
          	begin
			if (r_avmm_hip_sel & avmm_cmd_load_en)
			begin
             			hip_aib_avmm_in[28] <= avmm_cmd_32bit_data[1];
             			hip_aib_avmm_in[29] <= avmm_cmd_32bit_data[2];
             			hip_aib_avmm_in[30] <= avmm_cmd_32bit_data[3];
             			hip_aib_avmm_in[27:8] <= avmm_cmd_32bit_data[23:4];
             			hip_aib_avmm_in[7:0] <= avmm_cmd_32bit_data[31:24];
			end
			else
			begin
             			hip_aib_avmm_in[30:0] <= 31'b0;
			end
          	end
     	end 

   	always @(negedge avmm_reset_avmm_rst_n or posedge avmm_clock_avmm_clk)
	begin
        	if (~avmm_reset_avmm_rst_n)
         	begin
             		avmm_cmdbuilder_hip_avmm_valid_error <= 1'b0;
          	end
        	else
          	begin
			avmm_cmdbuilder_hip_avmm_valid_error <= avmm_cmdbuilder_hip_avmm_valid_error | (r_avmm_hip_sel & avmm_cmd_32bit_data[0] & ~avmm_cmd_32bit_data[2] & ~avmm_cmd_32bit_data[3]);
          	end
     	end 

	assign avmm_cmdbuilder_parity_data[30:0] = {avmm_cmd_32bit_data[31:24],avmm_cmd_32bit_data[22:0]};

c3aibadapt_cmn_parity_checker
    #(
        .WIDTH(31)
    ) adapt_cmn_parity_checker_avmm_cmdbuilder
    (
	.clk(avmm_clock_rx_osc_clk),
	.rst_n(avmm_reset_rx_osc_clk_rst_n),
	.data(avmm_cmdbuilder_parity_data[30:0]),
	.parity_checker_ena(1'b1),
	.parity_received(avmm_cmd_32bit_data[23]),
	.parity_error(avmm_cmdbuilder_parity_error)
    );

endmodule // c3aibadapt_avmm_cmdbuilder
