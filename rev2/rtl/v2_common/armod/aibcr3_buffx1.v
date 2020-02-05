// SPDX-License-Identifier: Apache-2.0
// Copyright (c) 2019  Ayar Labs, Inc.
// Copyright (C) 2019 Intel Corporation. 

// Library - aibcr3_lib, Cell - aibcr3_buffx1, View - schematic
// LAST TIME SAVED: Sep  5 22:35:02 2016
// NETLIST TIME: Sep  8 13:11:45 2016

// Ayar modified: changed assign statement between oclkn and iopad to use a
// a custom cell and also use that custom cell to fix connections to rx_digital

`timescale 1ns / 1ns 

module aibcr3_buffx1 ( oclk, oclkb, oclkn, odat0, odat1, odat_async,
     pd_data, iopad, async_dat, clkdr, iclkin_dist,
     iclkn, idat0, idat1, idataselb, iddren, ilaunch_clk, ilpbk_dat,
     ilpbk_en, indrv, ipadrstb, ipdrv, irstb, irxen, istrbclk, itxen,
     por_aib_vcc1, por_aib_vcchssi, test_weakpd, test_weakpu,
     testmode_en);

output  oclk, oclkb, oclkn, odat0, odat1, odat_async, pd_data;

inout  iopad;

input  async_dat, clkdr, iclkin_dist, iclkn, idat0, idat1, idataselb,
     iddren, ilaunch_clk, ilpbk_dat, ilpbk_en, ipadrstb, irstb,
     istrbclk, itxen, por_aib_vcc1, por_aib_vcchssi, test_weakpd,
     test_weakpu, testmode_en;

input [1:0]  ipdrv;
input [1:0]  indrv;
input [2:0]  irxen;

// Buses in the design

wire  [1:0]  ipdrv_buf;

wire  [1:0]  indrv_buf;


aibcr3_analog x0 ( oclkb, oclk, rx_idat, odat_async, 
     iopad, oclkn, clkbuf_en, datbuf_en, iclkn, indrv_buf[1:0],
     ipdrv_buf[1:0], itx_en_buf, por_aib_vcc1, por_aib_vcchssi, tx_dat,
     weak_pulldownen, weak_pullupenb);
aibcr3_digital x1 ( clkbuf_en, datbuf_en, indrv_buf[1:0],
     ipdrv_buf[1:0], itx_en_buf, odat0, odat1, pd_data, net18, net17,
     net16, tx_dat, weak_pulldownen, weak_pullupenb, 
     async_dat, clkdr, iclkin_dist, idat0, idat1, idataselb, iddren,
     ilaunch_clk, ilpbk_dat, ilpbk_en, indrv[1:0], ipadrstb,
     ipdrv[1:0], irstb, irxen[2:0], istrbclk, itxen, rx_idat,
     test_weakpd, test_weakpu, testmode_en);


endmodule

