// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3_lib, Cell - aibcr3_dcc_dlyline, View - schematic
// LAST TIME SAVED: Aug  1 02:00:10 2016
// NETLIST TIME: Aug 17 15:46:58 2016
`timescale 1ns / 1ns 

module aibcr3_dcc_dlyline ( SOOUT, bk_TP, crsDLY, dlyline_out, 
      CLK, PDb, SE, SI, SMCLK, gry );

output  SOOUT, crsDLY, dlyline_out;

input  CLK, PDb, SE, SI, SMCLK;

output [255:0]  bk_TP;

input [10:0]  gry;

// Buses in the design

wire  [2:0]  bufgry;

assign bufgry[2:0] = gry[2:0];
assign CLKIN = SMCLK;
assign net0113 = CLKIN;

aibcr3_dcc_8ph_intp I57 ( SOOUT, dlyline_out, net0113,
     PDb, crsDLY, bufgry[2:0], SE, SO_crc);
aibcr3_dcc_crsdlyline I58 ( SO_crc, bk_TP[255:0], crsDLY,  
     CLK, CLKIN, PDb, SE, SI, gry[10:3]);

endmodule
