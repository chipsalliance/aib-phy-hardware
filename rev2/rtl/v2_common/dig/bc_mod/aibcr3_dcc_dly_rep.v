// SPDX-License-Identifier: Apache-2.0
// Copyright (c) 2019 Blue Cheetah Analog Design, Inc.
//
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3_lib, Cell - aibcr3_dcc_dly_rep, View - schematic
// LAST TIME SAVED: Sep  6 00:13:19 2016
// NETLIST TIME: Sep 13 21:47:07 2016
//
// On 10/14/19 modified the line:
//   aibcr3_dlycell_dcc_rep x17 ( net030, net014, tielo, tielo,
// to:
//   aibcr3_dlycell_dcc_rep x17 ( net030, net014, tielo, tiehi,
// This changes the ci_p input to aibcr3_dlycell_dcc from 0 to 1.
// Previously with Intel's aibcr3_dlycell_dcc model, this input was a
// don't care as there was an actual 2-to-1 MUX to select between the
// 2 inputs in_p and ci_p.  In BC's aibcr3_dlycell_dcc model, this
// input (for the one delay cell which is selected to loop the clock
// back) must be 1 since the MUX is replaced by a 2-input NAND gate.
//
// This should have also been a problem that was found and fixed by
// Ayar.  However in their implementation, they dispensed with the
// delay cell (and interpolator) altogether.
`timescale 1ns / 1ns

module aibcr3_dcc_dly_rep ( clkrep, idat, rb_dcc_byp );

output  clkrep;

input  idat, rb_dcc_byp;

wire tielo;
wire buf_idat;
wire dcc_byp_n;
wire dcc_byp_p;
wire idat_mux0;
wire idat_mux2;


assign tielo = 1'b0;
assign tiehi = 1'b1;
aibcr3_dcc_interpolator x12 (
    .intout(idat_mux0),
    .a_in(net014),
    .sn({tiehi, tiehi, tiehi, tiehi, tiehi, tiehi, tiehi}),
    .sp({tielo, tielo, tielo, tielo, tielo, tielo, tielo}));

assign buf_idat = idat;
assign idat_mux2 = idat_mux0;
assign dcc_byp_p = rb_dcc_byp ;
assign clkrep = dcc_byp_p ? buf_idat : idat_mux2;


aibcr3_dlycell_dcc_rep x17 ( net030, net014, tielo, tiehi,
     buf_idat);

endmodule
