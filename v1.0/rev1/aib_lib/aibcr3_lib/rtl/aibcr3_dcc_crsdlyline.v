// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3_lib, Cell - aibcr3_dcc_crsdlyline, View - schematic
// LAST TIME SAVED: Aug  1 14:55:33 2016
// NETLIST TIME: Aug 17 15:46:58 2016
`timescale 1ns / 1ns 

module aibcr3_dcc_crsdlyline ( SOOUT, bk, crsDLY, CLK,
     CLKIN, PDb, SE, SI, gry );

output  SOOUT, crsDLY;

input  CLK, CLKIN, PDb, SE, SI;

output [255:0]  bk;

input [10:3]  gry;

// Buses in the design

wire  [0:4]  net0118;

wire  [0:5]  net0119;

wire  [0:4]  net0120;

wire  [6:0]  cgry;

wire  [6:0]  bgry;

wire  [6:0]  dgry;

wire  [6:0]  agry;

wire         gry9b;
wire         gry10b;
wire	     SO_crc;
wire         net082;
wire         net096;
wire         net0108;

// scan out pin
assign SOOUT = SO_crc;

// 4x delay line, each containing 64 delay cells
aibcr3_dcc_dlyline64 I10 ( net14, net18, net14,
     bk[255:192], net15);
aibcr3_dcc_dlyline64 I9 ( net15, net17, net18,
     bk[191:128], net16);
aibcr3_dcc_dlyline64 I1 ( net16, dly64, net17, bk[127:64],
     clk64);
aibcr3_dcc_dlyline64 I8 ( clk64, crsDLY, dly64, bk[63:0],
     CLK);

// 4x gray to thermometer code conversion
aibcr3_dcc_gry2thm64 I6 ( net097, bk[63:0], net0128, RSTb,
     agry[6:0], SE, SI);
aibcr3_dcc_gry2thm64 I5 ( net0101, bk[127:64], net0126,
     RSTb, bgry[6:0], SE, net097);
aibcr3_dcc_gry2thm64 I3 ( net0103, bk[191:128], net0124,
     RSTb, cgry[6:0], SE, net0101);
aibcr3_dcc_gry2thm64 I15 ( SO_crc, bk[255:192], net0122,
     RSTb, dgry[6:0], SE, net0103);

// combinatorial logic
assign agry[5:0] = gry[8:3];
assign ENDbar = ~cgry[6];
assign ENCbar = ~bgry[6];
assign agry[6] = ~(gry9b & gry10b);
assign ENBbar = ~agry[6];
//assign tie_HI = 1'b1;
assign net0122 = CLKIN;
assign net0124 = CLKIN;
assign net0128 = CLKIN;
assign net0126 = CLKIN;
assign RSTb    = PDb;
assign bgry[5] = ~(gry[8] | ENBbar);
assign dgry[4:0] = ~(net0120[0:4] | {ENDbar,ENDbar,ENDbar,ENDbar,ENDbar} );
assign dgry[5] = ~(gry[8] | ENDbar);
assign cgry[5:0] = ~(net0119[0:5] | {ENCbar,ENCbar,ENCbar,ENCbar,ENCbar,ENCbar});
assign bgry[4:0] = ~(net0118[0:4] | {ENBbar,ENBbar,ENBbar,ENBbar,ENBbar});
assign gry9b = ~gry[9];
assign gry10b = ~gry[10];
assign net0120[0:4] = ~gry[7:3];
assign net082 = ~( gry[3] | gry[4] | gry[5] );
assign net0108 = ~( gry[6] | gry[7] | gry[8] );
assign net096 = ~( net082 & net0108 );
assign dgry[6] = ~( net096 | gry[9] | gry10b );
assign net0119[0:5] = ~gry[8:3];
assign bgry[6] = gry[10];
assign cgry[6] = ~ ( gry[9] | gry10b );
assign net0118[0:4] = ~gry[7:3];


endmodule
