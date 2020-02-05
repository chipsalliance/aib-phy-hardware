// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3_lib, Cell - aibcri3_dcc_phasedet, View - schematic

`timescale 1ps/1ps
module aibcr3_dcc_phasedet
#(
parameter FF_DELAY     = 200
)
( 
output wire 	  t_down, 
output reg 	  t_up, 
input  wire 	  CLKA, 
input  wire	  CLKB,
input  wire	  RSTb);

`ifdef TIMESCALE_EN
                timeunit 100fs;
                timeprecision 100fs;
`endif

always @(posedge CLKB or negedge RSTb)
  if (~RSTb)           t_up <= #FF_DELAY 1'b1;
  else                 t_up <= #FF_DELAY CLKA;

assign t_down = !t_up;


endmodule

