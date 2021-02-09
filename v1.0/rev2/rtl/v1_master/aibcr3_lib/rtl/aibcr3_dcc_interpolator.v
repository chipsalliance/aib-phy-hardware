// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3_lib, Cell - aibcr3_dcc_interpolator, View -
//schematic
// LAST TIME SAVED: Aug 16 11:20:05 2016
// NETLIST TIME: Aug 17 15:46:58 2016
`timescale 1ps / 1ps 

module aibcr3_dcc_interpolator ( intout, a_in, sn, sp );

`ifdef TIMESCALE_EN
                timeunit 1ps;
                timeprecision 1ps;
`endif

output  intout;

input   a_in;

input [6:0]  sn;
input [6:0]  sp;

integer     message_flag;
time        intrinsic;
time        a_time, b_time;
time        c_a_time, c_b_time;
time        calc_delay;
time        del_2x, rem_2x, del_1x, del_0x;
wire  [2:0] c_sig;
reg         pmx_2, pmx_1, pmx_0;

parameter   BUF_DELAY = 20;

wire         b_in;
wire         c_in;

assign #(1 * BUF_DELAY) b_in = a_in;
assign #(2 * BUF_DELAY) c_in = a_in;


//--------------------------------------------------------------------------------------------------------------------------------------------
////--- Calculate the delay of the interpolator
////--------------------------------------------------------------------------------------------------------------------------------------------

initial intrinsic =  120;  // Supports 80 ps step size

always @(a_in)  a_time = $time;
always @(b_in)  b_time = $time;
always @(c_in)
  begin
    c_a_time = $time - a_time;
    c_b_time = $time - b_time;

    if ((2 * intrinsic) < (c_a_time + c_b_time))
     begin
       if (message_flag == 1)
       begin
          $display("Warning : The Nand Delay chain step size is larger than  80 ps, measured step size = %t and/or %t",(c_a_time / 2),c_b_time);
          $display("Warning : At time = %t\n %m",$time);
       end
       calc_delay = 0;
       message_flag = 0;  // Don't repeat the message
     end
    else
     begin
       case (sp[6:0])
        7'b000_0000 :  calc_delay = intrinsic - (c_b_time/2) - (16 * (c_a_time/32));
        7'b000_0001 :  calc_delay = intrinsic - (c_b_time/2) - (14 * (c_a_time/32));
        7'b000_0011 :  calc_delay = intrinsic - (c_b_time/2) - (12 * (c_a_time/32));
        7'b000_0111 :  calc_delay = intrinsic - (c_b_time/2) - (10 * (c_a_time/32));
        7'b000_1111 :  calc_delay = intrinsic - (c_b_time/2) - (8  * (c_a_time/32));
        7'b001_1111 :  calc_delay = intrinsic - (c_b_time/2) - (6  * (c_a_time/32));
        7'b011_1111 :  calc_delay = intrinsic - (c_b_time/2) - (4  * (c_a_time/32));
        7'b111_1111 :  calc_delay = intrinsic - (c_b_time/2) - (2  * (c_a_time/32));
        default     :  calc_delay = intrinsic - (c_b_time/2) - (2  * (c_a_time/32));
       endcase
       message_flag = 1;
     end

    del_2x = calc_delay / 100;          // 100 ps
    rem_2x = calc_delay - (del_2x * 100);
    del_1x = rem_2x / 10;               // 10 ps
    del_0x = rem_2x - (del_1x * 10);    // 1  ps

  end

//--------------------------------------------------------------------------------------------------------------------------------------------
////---  Delay the signal
////--------------------------------------------------------------------------------------------------------------------------------------------
//

assign #10  c_sig[0] = c_in;
assign #100 c_sig[1] = c_sig[0];
assign #100 c_sig[2] = c_sig[1];

always @(*)
  case (del_2x)
    0  : pmx_2 =  c_sig[0];
    1  : pmx_2 =  c_sig[1];
    2  : pmx_2 =  c_sig[2];
    default : pmx_2 =  c_sig[2];
  endcase

always @(*)
  case (del_1x)
    0 : pmx_1 <= #0  pmx_2;
    1 : pmx_1 <= #10 pmx_2;
    2 : pmx_1 <= #20 pmx_2;
    3 : pmx_1 <= #30 pmx_2;
    4 : pmx_1 <= #40 pmx_2;
    5 : pmx_1 <= #50 pmx_2;
    6 : pmx_1 <= #60 pmx_2;
    7 : pmx_1 <= #70 pmx_2;
    8 : pmx_1 <= #80 pmx_2;
    9 : pmx_1 <= #90 pmx_2;
    default : pmx_1 <= #90 pmx_2;
  endcase

always @(*)
  case (del_0x)
    0 : pmx_0 <= #0 pmx_1;
    1 : pmx_0 <= #1 pmx_1;
    2 : pmx_0 <= #2 pmx_1;
    3 : pmx_0 <= #3 pmx_1;
    4 : pmx_0 <= #4 pmx_1;
    5 : pmx_0 <= #5 pmx_1;
    6 : pmx_0 <= #6 pmx_1;
    7 : pmx_0 <= #7 pmx_1;
    8 : pmx_0 <= #8 pmx_1;
    9 : pmx_0 <= #9 pmx_1;
    default : pmx_0 <= #9 pmx_1;
  endcase

assign intout = pmx_0;

endmodule
