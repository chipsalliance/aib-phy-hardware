// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 

//---------------------------------------------------------------------------------------------------------------------------------------------
//  io_min_ip16phs
//  The model supports a range from 1.6GHz to 0.8GHz for the phy's clock frequency
//  The models intrinsic delay could be as large as 312 ps, the actual delay is smaller
//---------------------------------------------------------------------------------------------------------------------------------------------

module io_min_ip16phs (
input        c_in,        // Clock in
input  [3:1] scp,         // filter_cap selection: 111 = 1.6 GHz, 110 = 1.2 GHz, 100 = 1.0 GHz, 000 = 0.8 GHz
input  [3:1] scn,         // filter_cap selection: 000 = 1.6 GHz, 001 = 1.2 GHz, 011 = 1.0 GHz, 111 = 0.8 GHz
output       c_out        // Clock out
);

`ifdef TIMESCALE_EN
                timeunit 1ps;
                timeprecision 1ps;
`endif

`ifndef SYN
time        intrinsic;
time        c_time;
time        c_c_time;
time        calc_delay;
time        del_2x, rem_2x, del_1x, del_0x;
wire  [4:0] c_sig;
reg         pmx_2, pmx_1, pmx_0;

//--------------------------------------------------------------------------------------------------------------------------------------------
//--- Calculate the delay of the interpolator
//--------------------------------------------------------------------------------------------------------------------------------------------

always @(*)
  case (scn[3:1])
    3'b000 : intrinsic = 200;  // Supports 0.95 GHz - 1.9 GHz
    3'b001 : intrinsic = 260;  // Supports 0.75 GHz - 1.5 GHz
    3'b011 : intrinsic = 320;  // Supports 0.60 GHz - 1.2 GHz
    3'b111 : intrinsic = 400;  // Supports 0.50 GHz - 1.0 GHz
    default : intrinsic = 400;  // Supports 0.50 GHz - 1.0 GHz
  endcase

always @(posedge c_in)  c_time = $time;
always @(negedge c_in)
  begin
    #100                                 ;
    c_c_time = $time - c_time            ;
    calc_delay = intrinsic - (c_c_time/4);

    del_2x = calc_delay / 100;          // 100 ps
    rem_2x = calc_delay - (del_2x * 100);
    del_1x = rem_2x / 10;               // 10  ps
    del_0x = rem_2x - (del_1x * 10);    // 1   ps

  end

//--------------------------------------------------------------------------------------------------------------------------------------------
//---  Delay the signal
//--------------------------------------------------------------------------------------------------------------------------------------------

assign #10  c_sig[0] = c_in;
assign #100 c_sig[1] = c_sig[0];
assign #100 c_sig[2] = c_sig[1];
assign #100 c_sig[3] = c_sig[2];
assign #100 c_sig[4] = c_sig[3];

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
    0 : pmx_1 = #0  pmx_2;
    1 : pmx_1 = #10 pmx_2;
    2 : pmx_1 = #20 pmx_2;
    3 : pmx_1 = #30 pmx_2;
    4 : pmx_1 = #40 pmx_2;
    5 : pmx_1 = #50 pmx_2;
    6 : pmx_1 = #60 pmx_2;
    7 : pmx_1 = #70 pmx_2;
    8 : pmx_1 = #80 pmx_2;
    9 : pmx_1 = #90 pmx_2;
    default : pmx_1 = #90 pmx_2;
  endcase

always @(*)
  case (del_0x)
    0 : pmx_0 = #0 pmx_1;
    1 : pmx_0 = #1 pmx_1;
    2 : pmx_0 = #2 pmx_1;
    3 : pmx_0 = #3 pmx_1;
    4 : pmx_0 = #4 pmx_1;
    5 : pmx_0 = #5 pmx_1;
    6 : pmx_0 = #6 pmx_1;
    7 : pmx_0 = #7 pmx_1;
    8 : pmx_0 = #8 pmx_1;
    9 : pmx_0 = #9 pmx_1;
    default : pmx_0 = #9 pmx_1;
  endcase

assign c_out = pmx_0;

`else
assign c_out = c_in;
`endif

endmodule




