// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.

module rx_offset_cal_fsm_top #(parameter DATAWIDTH = 45)
		    (
		     input sys_clk,
		     input rst_n,
		     input rx_offset_ovrd_sel,
		     input rx_offset_cal_done_ovrd,
		     input [4:0]rx_offset_cal_code_ovrd,
		     input start_cal,
		     input [(2*DATAWIDTH)-1:0]ana_rxdata,
   		     input       scan_mode,         // Scan mode
   		     input       clk_div_ld,        // Clock divider enable from avalon interface
   		     input       clk_div_1_onehot,  // Onehot enable for clock divided by 1
   		     input       clk_div_2_onehot,  // Onehot enable for clock divided by 2
   		     input       clk_div_4_onehot,  // Onehot enable for clock divided by 4
   		     input       clk_div_8_onehot,  // Onehot enable for clock divided by 8
   		     input       clk_div_16_onehot, // Onehot enable for clock divided by 16
   		     input       clk_div_32_onehot, // Onehot enable for clock divided by 32
   		     input       clk_div_64_onehot, // Onehot enable for clock divided by 64
		     output wire rxoffset_cal_done,
                     output wire rx_offset_cal_run,
		     output wire [(2*DATAWIDTH)-1:0][4:0]rxoffset_cal_code,
		     output wire rxoffset_clk_div_ld_ack_ff
		    );


wire 			      rxoffset_cal_done_int;
wire                          sys_div_clk;
wire [(2*DATAWIDTH)-1:0][4:0] offs_cal_code_intr;
wire [(2*DATAWIDTH)-1:0][4:0] offs_cal_code_pre;
wire cal_done_single;
wire rx_cal_data;
wire start_cal_intr;
wire [4:0]offs_cal_code;
genvar i;
//Data Muxing b/w Register Data and internal logic data

generate
  for(i=0;i<(2*DATAWIDTH);i=i+1)
    begin: offs_cal_code_pre_gen
      assign offs_cal_code_pre[i] = rx_offset_ovrd_sel ? rx_offset_cal_code_ovrd[4:0] : offs_cal_code_intr[i];
    end
endgenerate // block: offs_cal_code_pre_gen

generate
  for(i=0;i<(2*DATAWIDTH);i=i+1)
    begin: offs_cal_code_gen
      assign rxoffset_cal_code[i][4:0] = scan_mode ? 5'h0 : offs_cal_code_pre[i];
    end // block: offs_cal_code_gen
endgenerate

assign rxoffset_cal_done = rx_offset_ovrd_sel ? rx_offset_cal_done_ovrd : rxoffset_cal_done_int;

//==============================
//Clock Divider for Div-1,2,4,8
//==============================
aib_clk_div_roffcal i_aib_clk_div_roffcal(
.rst_n(rst_n),
.clk(sys_clk),
.scan_mode(scan_mode),
.clk_div_ld(clk_div_ld),
.clk_div_1_onehot(clk_div_1_onehot),
.clk_div_2_onehot(clk_div_2_onehot),
.clk_div_4_onehot(clk_div_4_onehot),
.clk_div_8_onehot(clk_div_8_onehot),
.clk_div_16_onehot(clk_div_16_onehot),
.clk_div_32_onehot(clk_div_32_onehot),
.clk_div_64_onehot(clk_div_64_onehot),
.clk_out(sys_div_clk),
.clk_div_ld_ack_ff(rxoffset_clk_div_ld_ack_ff)
);


//========================================
//rxoffset calibration for rxdata 88-bits
//========================================
rxoffset_top i_rxoffset_top(.sys_clk(sys_div_clk),
			    .rst_n(rst_n),
			    .ana_rxdata(ana_rxdata),
			    .start_cal(start_cal),
			    .cal_done(cal_done_single),
			    .offs_cal_code(offs_cal_code),
			    .rx_cal_data(rx_cal_data),
			    .start_cal_sub(start_cal_intr),
			    .rxoffset_cal_done(rxoffset_cal_done_int),
                            .rx_offset_cal_run (rx_offset_cal_run),
			    .rx_offs_cal_code(offs_cal_code_intr)
			);

//==========================================
//rxoffset calibration for single bit stage 
//==========================================
rx_offset_cal i_rx_offset_cal(.sys_clk(sys_div_clk),
			          .rst_n(rst_n),
			          .start_cal(start_cal_intr),
			          .cal_data(rx_cal_data),
			          .cal_done(cal_done_single),
			          .offs_cal_code(offs_cal_code)
				  );
endmodule
