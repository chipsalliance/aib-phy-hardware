// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3_lib, Cell - aibcr3_red_custom_dig2, View -
//schematic
// LAST TIME SAVED: Sep  5 22:37:21 2016
// NETLIST TIME: Sep  8 13:11:44 2016
`timescale 1ns / 1ns 

module aibcr3_red_custom_dig2 ( iclkin_dist_aib, ilaunch_clk_aib,
     istrbclk_aib, oclk_out, oclkb_out, clkdr_in,
     iclkin_dist_in0, iclkin_dist_in1, ilaunch_clk_in0,
     ilaunch_clk_in1, istrbclk_in0, istrbclk_in1, jtag_clksel,
     oclk_aib, oclk_in1, oclkb_aib, oclkb_in1, shift_en );

output  iclkin_dist_aib, ilaunch_clk_aib, istrbclk_aib, oclk_out,
     oclkb_out;


input  clkdr_in, iclkin_dist_in0, iclkin_dist_in1, ilaunch_clk_in0,
     ilaunch_clk_in1, istrbclk_in0, istrbclk_in1, jtag_clksel,
     oclk_aib, oclk_in1, oclkb_aib, oclkb_in1, shift_en;

wire jtag_clksel_buf;
wire ilaunch_clk_mux;
wire iclkin_dist_muxb;
wire net190;
wire jtag_clksel_b;

assign shift_enbuf = shift_en;
assign lclk_s0     = ~ (shift_enbuf | jtag_clksel_buf);
assign oclkb_mux   = shift_enbuf ? oclkb_in1 : oclkb_aib;
assign oclk_mux    = shift_enbuf ? oclk_in1  : oclk_aib ;  
assign istrbclk_mux = shift_enbuf ? istrbclk_in1 : istrbclk_in0;
assign iclkin_dist_mux = shift_enbuf ? iclkin_dist_in1 : iclkin_dist_in0;
assign oclk_muxb = ~ oclk_mux;
assign oclk_out  = ~ oclk_muxb;
assign oclkb_muxb= ~ oclkb_mux;
assign oclkb_out = ~ oclkb_muxb;
assign istrbclk_muxb = ~ istrbclk_mux;
assign ilaunch_clk_muxb = ~ ilaunch_clk_mux;
assign ilaunch_clk_aib  = ~ ilaunch_clk_muxb;
assign iclkin_dist_aib  = ~ iclkin_dist_muxb;
assign iclkin_dist_muxb = ~ iclkin_dist_mux;
assign istrbclk_aib = ~ istrbclk_muxb;
assign lclk_s1 = ~ net190;
assign jtag_clksel_buf = ~ jtag_clksel_b ;
assign jtag_clksel_b   = ~ jtag_clksel ;
assign net184 = ~ ( clkdr_in & jtag_clksel_buf );
assign net183 = ~ ( ilaunch_clk_in1 & lclk_s1 );
assign net189 = ~ ( ilaunch_clk_in0 & lclk_s0 );
assign net190 = ~ ( shift_enbuf     & jtag_clksel_b );
assign ilaunch_clk_mux = ~ ( net189 & net183 & net184 );


endmodule
