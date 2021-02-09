// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3_lib, Cell - aibcr3_dcc_dly_rep, View - schematic
// LAST TIME SAVED: Sep  6 00:13:19 2016
// NETLIST TIME: Sep 13 21:47:07 2016
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
aibcr3_dcc_interpolator x12 ( idat_mux0, net014, {tiehi,
     tiehi, tiehi, tiehi, tiehi, tiehi, tiehi}, {tielo, tielo, tielo,
     tielo, tielo, tielo, tielo});

assign buf_idat = idat;
assign idat_mux2 = idat_mux0;
assign dcc_byp_p = rb_dcc_byp ; 
assign clkrep = dcc_byp_p ? buf_idat : idat_mux2;


aibcr3_dlycell_dcc_rep x17 ( net030, net014, tielo, tielo,
     buf_idat);

endmodule
