// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.


module rx_offset_cal_fsm #(parameter DATAWIDTH = 44)
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
		     output wire cal_done,
		     output wire [(2*DATAWIDTH)-1:0][4:0]offs_cal_code,
		     output wire rxoffset_clk_div_ld_ack_ff
		    );

wire [(2*DATAWIDTH)-1:0]      cal_done_int;
wire                          sys_div_clk;
wire [(2*DATAWIDTH)-1:0][4:0] offs_cal_code_intr;
wire [(2*DATAWIDTH)-1:0][4:0] offs_cal_code_pre;

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
      assign offs_cal_code[i][4:0] = scan_mode ? 5'h0 : offs_cal_code_pre[i];
    end // block: offs_cal_code_gen
endgenerate

assign cal_done = rx_offset_ovrd_sel ? rx_offset_cal_done_ovrd : (&cal_done_int);

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
.clk_out(sys_div_clk),
.clk_div_ld_ack_ff(rxoffset_clk_div_ld_ack_ff)
);

/*======================================
==========Instantiation of Offset_cal===
========================================*/

generate
 for(i=0;i<88;i=i+1)
  begin: offset_cal_inst_gen
   offset_cal i_offset_cal(
		.sys_clk(sys_div_clk),
		.rst_n(rst_n),
		.start_cal(start_cal),
		.cal_data(ana_rxdata[i]),
		.cal_done(cal_done_int[i]),
		.offs_cal_code(offs_cal_code_intr[i][4:0])
   );
  end // block: offset_cal_inst_gen
endgenerate

endmodule

module offset_cal(
		  input sys_clk,
		  input rst_n,
		  input start_cal,
		  input cal_data,
		  output reg cal_done,
		  output reg [4:0]offs_cal_code 
		);

parameter START      = 3'b000,
          UP_COUNT   = 3'b001,
          COUNT_ROLL = 3'b010,
          DOWN_COUNT = 3'b011,
	  STOP       = 3'b100;

reg [2:0] offset_curst, offset_nxst;
reg [4:0] edge_detect_up_value, edge_detect_down_value;
reg [1:0] comp_data;
reg [5:0] sum;

always@(posedge sys_clk or negedge rst_n)
 begin
  if(!rst_n)
   offset_curst[2:0] <= 3'b000;
  else
   offset_curst[2:0] <= offset_nxst[2:0];
 end

always@(posedge sys_clk or negedge rst_n)
  if(!rst_n)
   begin
    edge_detect_up_value   <= 5'b0_0000;
    edge_detect_down_value <= 5'b0_0000;
    cal_done               <= 1'b0;
    offs_cal_code          <= 4'b0000;
   end
  else
   begin
    case(offset_curst)
     START      : begin
		   offs_cal_code <= 5'b0_0000;
		   comp_data     <= 2'b00;
		   sum           <= 5'b0_0000;
	          end
     UP_COUNT   : begin
		   comp_data <= {comp_data[0], cal_data};
     		   if(comp_data[0] != comp_data[1])
		    edge_detect_up_value[4:0] <= offs_cal_code[4:0]-1'b1;
		   else
		    edge_detect_up_value[4:0] <= edge_detect_up_value[4:0];

		    offs_cal_code <= offs_cal_code + 1'b1;
		  end
     COUNT_ROLL : begin
		   offs_cal_code <= 5'd31;
 		  end
     DOWN_COUNT : begin
		   comp_data <= {comp_data[0], cal_data};
     		   if(comp_data[0] != comp_data[1])
		    edge_detect_down_value[4:0] <= offs_cal_code[4:0]+1'b1;
		   else
		    edge_detect_down_value[4:0] <= edge_detect_down_value[4:0];
		   if(offs_cal_code == 5'b0_0000)
		    offs_cal_code <= 5'b0_0000;
		   else
		    offs_cal_code <= offs_cal_code - 1'b1;
		  end
     STOP       : begin
		   sum           <= edge_detect_up_value + edge_detect_down_value;
		   offs_cal_code <= sum >> 1;
		   cal_done      <= 1'b1;
		  end
     default    : begin
		   offs_cal_code <= 5'b0_0000;
		   comp_data     <= 2'b00;
		   sum           <= 5'b0_0000;
   	          end
    endcase
   end

 always@(*)
  begin
   offset_nxst = 3'b000;
    case(offset_curst)
     START      : begin
		   if(start_cal)
		    offset_nxst = UP_COUNT;
		   else
		    offset_nxst = START;
   	          end
     UP_COUNT   : begin
		   if(offs_cal_code == 5'd31)
		    offset_nxst = COUNT_ROLL;
		   else
		    offset_nxst = UP_COUNT;
	          end
     COUNT_ROLL : begin
		   if(offs_cal_code == 5'd31)
		    offset_nxst = DOWN_COUNT;
		   else
		    offset_nxst = COUNT_ROLL;
 		  end
     DOWN_COUNT : begin
		   if(offs_cal_code == 5'd0)
		    offset_nxst  = STOP;
		   else
		    offset_nxst  = DOWN_COUNT;
		  end
     STOP       : begin
		   if(!start_cal)
		    offset_nxst  = START;
		   else
		    offset_nxst  = STOP;
		   end
     default    : begin
		   if(start_cal)
		    offset_nxst = UP_COUNT;
		   else
		    offset_nxst = START;
   	          end
    endcase
  end

endmodule
