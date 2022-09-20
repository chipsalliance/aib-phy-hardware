// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.

module rcomp_calibration_fsm #(parameter RCOMP_WIDTH = 7) 
		             (
		             input sys_clk,
		             input rst_n,
		             input rcomp_cal_ovrd_sel,
		             input rcomp_cal_done_ovrd,
		             input [RCOMP_WIDTH-1:0]rcomp_cal_code_ovrd,
		             input start_cal,
		             input pad_data,
		             input gen1mode_en,
   			     input scan_mode,         // Scan mode
   			     input clk_div_ld,        // Clock divider enable from avalon interface
   			     input clk_div_1_onehot,  // Onehot enable for clock divided by 1
   			     input clk_div_2_onehot,  // Onehot enable for clock divided by 2
   			     input clk_div_4_onehot,  // Onehot enable for clock divided by 4
   			     input clk_div_8_onehot,  // Onehot enable for clock divided by 8
   			     input clk_div_16_onehot, // Onehot enable for clock divided by 16
   			     input clk_div_32_onehot, // Onehot enable for clock divided by 32
		             output wire rcomp_cal_done,
		             output reg  rcomp_cal_en,
		             output wire [RCOMP_WIDTH-1:0]rcomp_cal_code, //6-bits for Gen1 and 7-bits for Gen2
		             output wire rcomp_clk_div_ld_ack_ff
		        );

parameter START  = 2'b00,
          COUNT  = 2'b01,
	  STOP   = 2'b10;

reg [1:0] rcomp_curst, rcomp_nxst;
reg [RCOMP_WIDTH-1:0] edge_detect_value;
reg [RCOMP_WIDTH-1:0] rcomp_cal_code_cnt;
reg [1:0] comp_data;
wire sys_div_clk;
wire rcomp_max_value;
reg rcomp_cal_done_intr;
wire [RCOMP_WIDTH-1:0]rcomp_cal_code_intr; 
wire                  pad_data_sync;

// PAD data from replica synchronized
aib_bit_sync pad_data_sync_i
(
.clk      (sys_clk),      // Clock of destination domain
.rst_n    (1'b1),         // Reset of destination domain
.data_in  (pad_data),     // Input to be synchronized
.data_out (pad_data_sync) // Synchronized output
);

//===================================
//Clock Divider for Div-1,2,4,8,16,32
//====================================
aib_clk_div_rcomp i_aib_clk_div_rcomp(
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
.clk_out(sys_div_clk),
.clk_div_ld_ack_ff(rcomp_clk_div_ld_ack_ff)
);

//Comparing Gen1 or Gen2 Modes
assign rcomp_cal_code_intr  = gen1mode_en ? rcomp_cal_code_cnt : ~rcomp_cal_code_cnt;
assign rcomp_max_value      = gen1mode_en ? (rcomp_cal_code_cnt == 7'd63) : (rcomp_cal_code_cnt == 7'd127);

//Data Muxing b/w Register Data and internal logic data
assign rcomp_cal_code[RCOMP_WIDTH-1:0] =
               scan_mode                                                     ?
              {RCOMP_WIDTH{1'b0}}                                            :
              (rcomp_cal_ovrd_sel ? rcomp_cal_code_ovrd : rcomp_cal_code_intr);

assign rcomp_cal_done = rcomp_cal_ovrd_sel ? rcomp_cal_done_ovrd : rcomp_cal_done_intr;

always@(posedge sys_div_clk or negedge rst_n)
 begin
  if(!rst_n)
   rcomp_curst[1:0] <= 2'b00;
  else
   rcomp_curst[1:0] <= rcomp_nxst[1:0];
 end

always@(posedge sys_div_clk or negedge rst_n)
  if(!rst_n)
   begin
    edge_detect_value   <= {RCOMP_WIDTH{1'b0}};
    rcomp_cal_code_cnt  <= {RCOMP_WIDTH{1'b0}};
    rcomp_cal_done_intr <= 1'b0;
    rcomp_cal_en        <= 1'b0;
    comp_data           <= 2'b00;
   end
  else
   begin
    case(rcomp_curst)
     START      : begin
		   rcomp_cal_code_cnt <= {RCOMP_WIDTH{1'b0}}; 
		   comp_data          <= 2'b00;
    		   rcomp_cal_en       <= 1'b1;
	          end
     COUNT      : begin
		   comp_data <= {comp_data[0], pad_data_sync};
		   rcomp_cal_en   <= 1'b1;
     		   if(comp_data[0] != comp_data[1])
  		    begin
		       edge_detect_value  <= rcomp_cal_code_cnt-1'b1; //Previous value
		       rcomp_cal_code_cnt <= {RCOMP_WIDTH{1'b0}}; 
		      end
		   else
		    begin
		      rcomp_cal_code_cnt <= rcomp_cal_code_cnt + 1'b1;
		      edge_detect_value  <= edge_detect_value;
		    end
		  end
     STOP       : begin
		   rcomp_cal_code_cnt  <= edge_detect_value;
		   rcomp_cal_done_intr <= 1'b1;
		   rcomp_cal_en        <= 1'b0;
		  end
     default    : begin
		   edge_detect_value <= {RCOMP_WIDTH{1'b0}};
		   comp_data         <= 2'b00;
    		   rcomp_cal_en       <= 1'b1;
   	          end
    endcase
   end

 always@(*)
  begin
   rcomp_nxst = 2'b00;
    case(rcomp_curst)
     START      : begin
		   if(start_cal)
		    rcomp_nxst = COUNT;
		   else
		    rcomp_nxst = START;
   	          end
     COUNT      : begin
     		   if(comp_data[0] != comp_data[1] || rcomp_max_value)
		    rcomp_nxst = STOP;
		   else
		    rcomp_nxst = COUNT;
	          end
     STOP       : begin
		   if(!start_cal)
		    rcomp_nxst  = START;
		   else
		    rcomp_nxst  = STOP;
		   end
     default    : begin
		   if(start_cal)
		    rcomp_nxst = COUNT;
		   else
		    rcomp_nxst = START;
   	          end
    endcase
  end

endmodule
