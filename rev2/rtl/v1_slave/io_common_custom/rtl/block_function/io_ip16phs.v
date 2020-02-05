// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 

//---------------------------------------------------------------------------------------------------------------------------------------------
//  io_ip16phs
//  The model supports a range from 1.6GHz to 0.8GHz for the phy's clock frequency
//  The models intrinsic delay could be as large as 312 ps, the actual delay is smaller
//---------------------------------------------------------------------------------------------------------------------------------------------

module io_ip16phs (
input  [2:0] c_in,        // c_in[0] = First clock phase, c_in[1] = Second clock phase, c_in[2] = Third clock phase,
input  [7:0] sp,          // Thermometer code select
input  [7:0] sn,          // complimentary Thermometer code select
input  [3:1] scp, 	  // filter_cap selection: 111 = 1.6 GHz, 110 = 1.2 GHz, 100 = 1.0 GHz, 000 = 0.8 GHz
input  [3:1] scn, 	  // filter_cap selection: 000 = 1.6 GHz, 001 = 1.2 GHz, 011 = 1.0 GHz, 111 = 0.8 GHz
input  [6:0] selp,        // code for 2 phase interpolator (including decode for test)
input  [6:0] seln,        // complimentary code for 2 phase interpolator (including decode for test)
`ifndef SYN
output reg   c_out        // Clock out
`else
output       c_out        // Clock out
`endif
);

`ifdef TIMESCALE_EN
                timeunit 1ps;
                timeprecision 1ps;
`endif

`ifndef SYN
integer     message_flag;
time        intrinsic;
time        a_time, b_time;
time        c_a_time, c_b_time;
time        calc_delay;
time        del_2x, rem_2x, del_1x, del_0x;
wire  [4:0] c_sig;
reg         pmx_2, pmx_1, pmx_0;

//--------------------------------------------------------------------------------------------------------------------------------------------
//--- Calculate the delay of the interpolator
//--------------------------------------------------------------------------------------------------------------------------------------------

initial  message_flag = 1;

always @(*)
  case (scn[3:1])
    3'b000 : intrinsic = 200;  // Supports 0.95 GHz - 1.9 GHz
    3'b001 : intrinsic = 260;  // Supports 0.75 GHz - 1.5 GHz
    3'b011 : intrinsic = 320;  // Supports 0.60 GHz - 1.2 GHz
    3'b111 : intrinsic = 400;  // Supports 0.50 GHz - 1.0 GHz
    default : intrinsic = 400;  // Supports 0.50 GHz - 1.0 GHz
  endcase

always @(c_in[0])  a_time = $time;
always @(c_in[1])  b_time = $time;
always @(c_in[2])
  begin
    c_a_time = $time - a_time;
    c_b_time = $time - b_time;
  
    if ((2 * intrinsic) < (c_a_time + c_b_time))
     begin
       if (message_flag == 1)
       begin
          case (scn[3:1])
           3'b000 : $display("Warning : The 8 phase phy clock frequency is lower than 0.95 GHz, measured phase period = %t and/or %t",(c_a_time / 2),c_b_time);
           3'b001 : $display("Warning : The 8 phase phy clock frequency is lower than 0.75 GHz, measured phase period = %t and/or %t",(c_a_time / 2),c_b_time);
           3'b011 : $display("Warning : The 8 phase phy clock frequency is lower than 0.60 GHz, measured phase period = %t and/or %t",(c_a_time / 2),c_b_time);
           3'b111 : $display("Warning : The 8 phase phy clock frequency is lower than 0.50 GHz, measured phase period = %t and/or %t",(c_a_time / 2),c_b_time);
          endcase
          $display("Warning : At time = %t\n %m",$time);
       end
       calc_delay = 0;
       message_flag = 0;  // Don't repeat the message
     end
    else
     begin
       case ({seln[3],sp[7:0]})
        9'b0_0000_0000 :  calc_delay = intrinsic - ((c_b_time + (16 * c_a_time)/16)/2);
        9'b0_0000_0001 :  calc_delay = intrinsic - ((c_b_time + (15 * c_a_time)/16)/2);
        9'b0_0000_0011 :  calc_delay = intrinsic - ((c_b_time + (14 * c_a_time)/16)/2);
        9'b0_0000_0111 :  calc_delay = intrinsic - ((c_b_time + (13 * c_a_time)/16)/2);
        9'b0_0000_1111 :  calc_delay = intrinsic - ((c_b_time + (12 * c_a_time)/16)/2);
        9'b0_0001_1111 :  calc_delay = intrinsic - ((c_b_time + (11 * c_a_time)/16)/2);
        9'b0_0011_1111 :  calc_delay = intrinsic - ((c_b_time + (10 * c_a_time)/16)/2);
        9'b0_0111_1111 :  calc_delay = intrinsic - ((c_b_time + ( 9 * c_a_time)/16)/2);
        9'b1_1111_1111 :  calc_delay = intrinsic - ((c_b_time + ( 8 * c_a_time)/16)/2);
        9'b1_0111_1111 :  calc_delay = intrinsic - ((c_b_time + ( 7 * c_a_time)/16)/2);
        9'b1_0011_1111 :  calc_delay = intrinsic - ((c_b_time + ( 6 * c_a_time)/16)/2);
        9'b1_0001_1111 :  calc_delay = intrinsic - ((c_b_time + ( 5 * c_a_time)/16)/2);
        9'b1_0000_1111 :  calc_delay = intrinsic - ((c_b_time + ( 4 * c_a_time)/16)/2);
        9'b1_0000_0111 :  calc_delay = intrinsic - ((c_b_time + ( 3 * c_a_time)/16)/2);
        9'b1_0000_0011 :  calc_delay = intrinsic - ((c_b_time + ( 2 * c_a_time)/16)/2);
        9'b1_0000_0001 :  calc_delay = intrinsic - ((c_b_time + ( 1 * c_a_time)/16)/2);
        default      :  calc_delay = intrinsic - ((c_b_time + ( 1 * c_a_time)/16)/2);
       endcase
       message_flag = 1;
     end

    del_2x = calc_delay / 100;          // 100 ps
    rem_2x = calc_delay - (del_2x * 100);
    del_1x = rem_2x / 10;               // 10 ps
    del_0x = rem_2x - (del_1x * 10);    // 1 ps

  end

//--------------------------------------------------------------------------------------------------------------------------------------------
//---  Delay the signal
//--------------------------------------------------------------------------------------------------------------------------------------------

assign #10  c_sig[0]  = c_in[2];
assign #100 c_sig[1]  = c_sig[0];
assign #100 c_sig[2]  = c_sig[1];
assign #100 c_sig[3]  = c_sig[2];
assign #100 c_sig[4]  = c_sig[3];

always @(*)
  case (del_2x)
    0 : pmx_2 =  c_sig[0];
    1 : pmx_2 =  c_sig[1];
    2 : pmx_2 =  c_sig[2];
    3 : pmx_2 =  c_sig[3];
    4 : pmx_2 =  c_sig[4];
    default : pmx_2 =  c_sig[4];
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

//assign c_out = pmx_0;

always @(*)
  casez (seln[6:0])
    7'b101_0011 : c_out = pmx_0;        //int_a=(clk_in_a+clk_in_b)/2; int_c=clk_in_b;
    7'b101_1010 : c_out = pmx_0;        //int_c=clk_in_b; int_a=(clk_in_b+clk_in_c)/2;
    7'b000_0011 : c_out = c_in[0];      //int_a=int_c=clk_in_a;
    7'b001_0000 : c_out = c_in[1];      //int_a=int_c=clk_in_b;
    7'b100_1000 : c_out = c_in[2];      //int_a=int_c=clk_in_c;
    default	: c_out = pmx_0;	//default will not happen with io_cmos_16ph_decode
  endcase

`else
assign c_out = c_in[2];
`endif

endmodule
