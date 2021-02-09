// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3_lib, Cell - aibcr3_scan_iomux, View - schematic
// LAST TIME SAVED: Aug 16 11:25:57 2016
// NETLIST TIME: Sep 13 21:47:07 2016
`timescale 1ns / 1ns 

module aibcr3_scan_iomux ( iatpg_scan_shift_clk_seg0,
     iatpg_scan_shift_clk_seg1, iatpg_scan_shift_clk_seg2,
     iatpg_scan_shift_clk_seg3, init_oatpg_bsr0_scan_out,
     init_oatpg_bsr1_scan_out, init_oatpg_bsr2_scan_out,
     init_oatpg_bsr3_scan_out, jtag_tx_scanen_out,
     ojtag_clkdr_out_chain, ojtag_rx_scan_out_chain, scan_in_seg0,
     scan_in_seg1, scan_in_seg2, scan_in_seg3, buf_iatpg_bsr0_scan_in,
     buf_iatpg_bsr0_scan_shift_clk, buf_iatpg_bsr1_scan_in,
     buf_iatpg_bsr1_scan_shift_clk, buf_iatpg_bsr2_scan_in,
     buf_iatpg_bsr2_scan_shift_clk, buf_iatpg_bsr3_scan_in,
     buf_iatpg_bsr3_scan_shift_clk, buf_iatpg_bsr_scan_shift_n,
     iatpg_scan_mode_n, jtag_tx_scanen_out_in,
     ojtag_clkdr_out_chain_in, ojtag_rx_scan_out_chain_in,
     scan_out_seg0, scan_out_seg1, scan_out_seg2, scan_out_seg3, vcc,
     vss );

output  iatpg_scan_shift_clk_seg0, iatpg_scan_shift_clk_seg1,
     iatpg_scan_shift_clk_seg2, iatpg_scan_shift_clk_seg3,
     init_oatpg_bsr0_scan_out, init_oatpg_bsr1_scan_out,
     init_oatpg_bsr2_scan_out, init_oatpg_bsr3_scan_out,
     jtag_tx_scanen_out, ojtag_clkdr_out_chain,
     ojtag_rx_scan_out_chain, scan_in_seg0, scan_in_seg1, scan_in_seg2,
     scan_in_seg3;

input  buf_iatpg_bsr0_scan_in, buf_iatpg_bsr0_scan_shift_clk,
     buf_iatpg_bsr1_scan_in, buf_iatpg_bsr1_scan_shift_clk,
     buf_iatpg_bsr2_scan_in, buf_iatpg_bsr2_scan_shift_clk,
     buf_iatpg_bsr3_scan_in, buf_iatpg_bsr3_scan_shift_clk,
     buf_iatpg_bsr_scan_shift_n, iatpg_scan_mode_n,
     jtag_tx_scanen_out_in, ojtag_clkdr_out_chain_in,
     ojtag_rx_scan_out_chain_in, scan_out_seg0, scan_out_seg1,
     scan_out_seg2, scan_out_seg3, vcc, vss;

wire net056;
wire net111;
wire net053;
wire net093;
wire net063;
wire net068;
wire net082;
wire net121;
wire net054;

// scan in
assign scan_in_seg3 = net093;
assign scan_in_seg2 = net082;
assign scan_in_seg1 = net068;
assign scan_in_seg0 = net063;

assign net063 = iatpg_scan_mode_n ? ojtag_rx_scan_out_chain_in : buf_iatpg_bsr0_scan_in ; 
assign net068 = iatpg_scan_mode_n ? init_oatpg_bsr0_scan_out : buf_iatpg_bsr1_scan_in ;
assign net082 = iatpg_scan_mode_n ? init_oatpg_bsr1_scan_out : buf_iatpg_bsr2_scan_in ;
assign net093 = iatpg_scan_mode_n ? init_oatpg_bsr2_scan_out : buf_iatpg_bsr3_scan_in ;

// scan_en
assign jtag_tx_scanen_out = iatpg_scan_mode_n ? jtag_tx_scanen_out_in : net121;
assign net121 = !buf_iatpg_bsr_scan_shift_n ;

// jtag clock propagation
assign net053 = iatpg_scan_mode_n ? ojtag_clkdr_out_chain_in: buf_iatpg_bsr0_scan_shift_clk;
assign net054 = iatpg_scan_mode_n ? net053 : buf_iatpg_bsr1_scan_shift_clk;
assign net111 = iatpg_scan_mode_n ? net054 : buf_iatpg_bsr2_scan_shift_clk;
assign net056 = iatpg_scan_mode_n ? net111 : buf_iatpg_bsr3_scan_shift_clk;
assign ojtag_clkdr_out_chain = net056 ;

// scan shift clock
assign iatpg_scan_shift_clk_seg0 = net053 ;
assign iatpg_scan_shift_clk_seg1 = net054 ;
assign iatpg_scan_shift_clk_seg2 = net111 ;
assign iatpg_scan_shift_clk_seg3 = net056 ;

// scan_out
assign init_oatpg_bsr0_scan_out = scan_out_seg0;
assign init_oatpg_bsr1_scan_out = scan_out_seg1;
assign init_oatpg_bsr2_scan_out = scan_out_seg2;
assign init_oatpg_bsr3_scan_out = scan_out_seg3;
assign ojtag_rx_scan_out_chain = scan_out_seg3;

endmodule
