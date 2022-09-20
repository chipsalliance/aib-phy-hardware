// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.

module rx_offset_cal(
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

`ifdef CAL_CODE_CNT
   localparam CAL_CODE_CNT = `CAL_CODE_CNT;
`else
   localparam CAL_CODE_CNT = 5'd31;// Calibration count
`endif

//1,2,4,8,(Need to insatntiate clock divider)
//00-DIV1
//01-DIV2
//10-DIV4
//11-DIV8
reg [2:0] offset_curst, offset_nxst;
reg [4:0] edge_detect_up_value, edge_detect_down_value;
reg [1:0] comp_data;
reg [5:0] sum;
wire      cal_data_sync;

// Calibration data synchronized
aib_bit_sync cal_data_sync_i
(
.clk      (sys_clk),      // Clock of destination domain
.rst_n    (1'b1),         // Reset of destination domain
.data_in  (cal_data),     // Input to be synchronized
.data_out (cal_data_sync) // Synchronized output
);



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
    comp_data              <= 2'b00;
    sum                    <= 5'b0_0000;
   end
  else
   begin
    case(offset_curst)
     START      : begin
		   offs_cal_code <= 5'b0_0000;
		   comp_data     <= 2'b00;
    		   cal_done      <= 1'b0;
		   sum           <= 5'b0_0000;
	          end
     UP_COUNT   : begin
		   comp_data <= {comp_data[0], cal_data_sync};
     		   if(comp_data[0] != comp_data[1])
		    edge_detect_up_value[4:0] <= offs_cal_code[4:0]-1'b1;
		   else
		    edge_detect_up_value[4:0] <= edge_detect_up_value[4:0];

		    offs_cal_code <= offs_cal_code + 1'b1;
		  end
     COUNT_ROLL : begin
		   offs_cal_code[4:0] <= CAL_CODE_CNT[4:0];
 		  end
     DOWN_COUNT : begin
		   comp_data <= {comp_data[0], cal_data_sync};
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
		   if(offs_cal_code[4:0] == CAL_CODE_CNT[4:0])
		    offset_nxst = COUNT_ROLL;
		   else
		    offset_nxst = UP_COUNT;
	          end
     COUNT_ROLL : begin
		   if(offs_cal_code[4:0] == CAL_CODE_CNT[4:0])
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
