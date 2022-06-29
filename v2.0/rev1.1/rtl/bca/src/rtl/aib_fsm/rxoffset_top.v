// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.

module rxoffset_top #(parameter DATAWIDTH = 45)
	(
	input sys_clk,
	input rst_n,
	input [(2*DATAWIDTH)-1:0]ana_rxdata, 
	input [4:0] offs_cal_code,
	input start_cal,
	input cal_done,
        output reg rx_cal_data,
        output reg start_cal_sub,
        output reg rxoffset_cal_done,
        output     rx_offset_cal_run,
        output reg [(2*DATAWIDTH)-1:0][4:0]rx_offs_cal_code
);
parameter START    = 2'b00, 
	  RUN      = 2'b01,
	  STOP     = 2'b10;

// Local param used to speed up RTL simulation for certain stimulus
`ifdef PAD_THRESHOLD
   localparam PAD_THRESHOLD = `PAD_THRESHOLD;
`else
   localparam PAD_THRESHOLD = DATAWIDTH*2;
`endif

reg [1:0] rx_offset_curst, rx_offset_nxst;
integer i;
reg [6:0] rx_offset_count;
reg  cal_done_delay;
wire cal_done_comb;
reg  cal_done_pulse;

always@(posedge sys_clk or negedge rst_n)
 begin
  if(!rst_n)
   cal_done_delay <= 1'b0;
  else
   cal_done_delay <= cal_done;
 end

assign cal_done_comb = ~cal_done_delay & cal_done;
always@(posedge sys_clk or negedge rst_n)
 begin
  if(!rst_n)
   cal_done_pulse <= 1'b0;
  else
   cal_done_pulse <= cal_done_comb;
 end

always@(posedge sys_clk or negedge rst_n)
 begin
  if(!rst_n)
   rx_offset_curst[1:0] <= 2'b00;
  else
   rx_offset_curst[1:0] <= rx_offset_nxst[1:0];
 end

always@(posedge sys_clk or negedge rst_n)
 if(!rst_n)
  begin
   for(i=0; i<(2*DATAWIDTH); i=i+1)
    rx_offs_cal_code[i] <= 5'b1_0000;
    rx_offset_count     <= 7'b000_0000;
    rx_cal_data         <= 1'b0;
    start_cal_sub       <= 1'b0;
    rxoffset_cal_done   <= 1'b0;
  end
 else
  begin
   case(rx_offset_curst)
    START : begin
   	     for(i=0; i<(2*DATAWIDTH); i=i+1)
              rx_offs_cal_code[i] <= 5'b1_0000;
    	      rx_cal_data         <= 1'b0;
              rxoffset_cal_done   <= 1'b0;
   	    end
    RUN   : begin
	     if(rx_offset_count == (2*DATAWIDTH))
	      rx_offset_count <= 7'b000_0000;
	     else if(cal_done_pulse)
	      begin
	       rx_offs_cal_code[rx_offset_count][4:0] <= offs_cal_code[4:0]; 
	       rx_offset_count <= rx_offset_count + 1'b1;
	       start_cal_sub   <= 1'b0;
	      end
	     else
	      begin
	       rx_offs_cal_code[rx_offset_count][4:0] <= offs_cal_code[4:0]; 
	       rx_offset_count <= rx_offset_count;
	       rx_cal_data     <= ana_rxdata[rx_offset_count];
	       start_cal_sub   <= 1'b1;
	      end
    	    end  
     STOP : begin
    	     rxoffset_cal_done <= 1'b1;
	     rx_offs_cal_code  <= rx_offs_cal_code; 
	    end
  default : begin
   	     for(i=0; i<(2*DATAWIDTH); i=i+1)
              rx_offs_cal_code[i] <= 5'b1_0000;
    	      rx_cal_data         <= 1'b0;
              rxoffset_cal_done   <= 1'b0;
   	    end
   endcase
  end

 always@(*)
  begin
   rx_offset_nxst = 3'b000;
   case(rx_offset_curst)
    START : begin
	     if(start_cal)
	      rx_offset_nxst = RUN;
	     else
	      rx_offset_nxst = START;
   	     end
    RUN   : begin
	     if(rx_offset_count == PAD_THRESHOLD)
	      rx_offset_nxst = STOP;
	     else
	      rx_offset_nxst = RUN;
   	    end
   STOP   : begin
             if(!start_cal)
	      rx_offset_nxst  = START;
	     else
	      rx_offset_nxst  = STOP;
            end
  default : begin
	     if(start_cal)
	      rx_offset_nxst = RUN;
	     else
	      rx_offset_nxst = START;
   	     end
   endcase
  end

// When bit 0 of fsm is 1, state machine is in RUN state 
assign rx_offset_cal_run = rx_offset_curst[0];

endmodule
