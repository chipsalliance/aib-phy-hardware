// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3_lib, Cell - aibcr3_dcc_dly, View - schematic
// LAST TIME SAVED: Aug  1 14:57:18 2016
// NETLIST TIME: Aug 17 15:46:58 2016
`timescale 1ns / 1ns 

module aibcr3_dcc_dly ( SOOUT, clk_dly, clk_mindly, PDb,
     SE, SI, SMCLK, clk_dcd, dll_lock_reg, gray, launch, measure );

output  SOOUT, clk_dly, clk_mindly;


input  PDb, SE, SI, SMCLK, clk_dcd, dll_lock_reg, launch, measure;

input [10:0]  gray;

// Buses in the design

wire  [0:255]  net105;

assign tieLO = 1'b0;
assign tieHI = 1'b1;
//assign net102 = tieLO? measure : tieLO;
assign clkin_mindly = dll_lock_reg? clk_dcd : measure; 
assign clkin_dlyline = dll_lock_reg? clk_dcd : launch;


// Actual delay path
aibcr3_dcc_dlyline I0 ( SO_dlyline, net105[0:255], net029, clk_dly,
       clkin_dlyline, PDb, SE, SI, SMCLK, gray[10:0]);

// Intrinsic delay compensation path
aibcr3_dcc_8ph_intp I1 ( SOOUT, clk_mindly,   SMCLK, PDb,
     net104, {tieLO, tieLO, tieLO}, SE, SO_dlyline);
aibcr3_dlycell_dcc I7 ( net103, net104, tieLO, tieHI,
     clkin_mindly);

endmodule
