// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3_lib, Cell - aibcr3_txanlg, View - schematic
// LAST TIME SAVED: Sep  3 00:18:03 2016
// NETLIST TIME: Sep  8 13:11:45 2016
`timescale 1ns / 1ns 

module aibcr3_txanlg ( txpadout, din, indrv_buf,
     ipdrv_buf, itx_en_buf, por, weak_pulldownen, weak_pullupenb );

inout  txpadout;

input  din, itx_en_buf, por, weak_pulldownen, weak_pullupenb;

input [1:0]  ipdrv_buf;
input [1:0]  indrv_buf;

// Buses in the design

wire  [1:0]  nc2;

wire  [1:0]  ndrv_enb_shift;

wire  [1:0]  pdrv_en_buf;

wire  [1:0]  ipdrv_in;

wire  [1:0]  ndrv_enb_buf;

wire  [1:0]  pgin;

wire  [1:0]  indrv_in;

wire  [1:0]  ngin;

wire  [1:0]  pdrv_en_shift;

wire  [1:0]  nc0;

wire din_buf;
wire por_buf;

assign tieLO = 1'b0;
assign en_buf = itx_en_buf;
assign weak_pullupenbb = !weak_pullupenb;
assign por_buf = por;

aibcr3_lvshift I41 ( .out(tristateb), .outb(tristate), .in(en_buf),
     .por_high(tieLO), .por_low(por_buf));
aibcr3_lvshift I4 ( .out(nc4), .outb(weak_pullupenbb_shift), 
     .in(weak_pullupenbb), .por_high(tieLO), .por_low(por_buf));
aibcr3_lvshift I19 ( .out(weak_pden_shift), .outb(nc3), 
     .in(weak_pulldownen), .por_high(por_buf), .por_low(tieLO));
aibcr3_lvshift I29 ( .out(din_shift), .outb(nc1), .in(din), .por_high(tieLO),
     .por_low(por_buf));


assign net071 = ~ ( din_buf | tristate ) ; 
assign net072 = ~ ( din_buf & tristateb ); 
assign net074 = weak_pullupenbb_shift;
assign weak_pden_buf = weak_pden_shift;

/*
aibcr3_ulvt16_nand2_a8 I21[1:0] ( pgin[1:0], GNDC, VCCL, din_buf,
     pdrv_en_buf[1:0]);
aibcr3_lvlshift I40[1:0] ( ndrv_enb_shift[1:0], nc2[1:0], GNDC, VCCL,
     VCORE, indrv_in[1:0], tieLO, por_buf);
aibcr3_lvlshift I8[1:0] ( nc0[1:0], pdrv_en_shift[1:0], GNDC, VCCL,
     VCORE, ipdrv_in[1:0], por_buf, tieLO);
aibcr3_tx_driver_pulldown I24 ( GNDC, txpadout, ngin[1:0], net071,
     weak_pden_buf);
aibcr3_svt16_nand2_a1 I38[1:0] ( indrv_in[1:0], GNDC, VCORE,
     indrv_buf[1:0], en_buf);
aibcr3_svt16_nand2_a1 I37[1:0] ( ipdrv_in[1:0], GNDC, VCORE,
     ipdrv_buf[1:0], en_buf);
aibcr3_ulvt16_nor2_a8 I22[1:0] ( ngin[1:0], GNDC, VCCL, din_buf,
     ndrv_enb_buf[1:0]);
aibcr3_TIEHI I15 ( tieHI, GNDC, VCORE);
aibcr3_ulvt16_buf_a4 I16 ( din_buf, GNDC, VCCL, din_shift);
aibcr3_ulvt16_buf_a4 I7 ( por_buf, GNDC, VCORE, por);
aibcr3_svt16_buf_a4 I35[1:0] ( pdrv_en_buf[1:0], GNDC, VCCL,
     pdrv_en_shift[1:0]);
aibcr3_svt16_buf_a4 I13[1:0] ( ndrv_enb_buf[1:0], GNDC, VCCL,
     ndrv_enb_shift[1:0]);
aibcr3_tx_driver_pullup I23 ( VCCL, txpadout, pgin[1:0], net072,
     net074);
*/

assign (weak0, weak1) txpadout = ((weak_pden_buf & net074) == 1'b1) ? 1'b0: (((weak_pden_buf | net074) == 1'b0)? 1'b1: 1'bz);
assign txpadout = ( tristateb & din) ? 1'b1: 1'bz;
assign txpadout = ( tristateb & ~din)? 1'b0: 1'bz;


endmodule
