// SPDX-License-Identifier: Apache-2.0
// Copyright (c) 2019  Ayar Labs, Inc.
// Copyright (C) 2019 Intel Corporation. 

// Library - aibcr3_lib, Cell - aibcr3_digital, View - schematic
// LAST TIME SAVED: Aug  4 22:27:45 2016
// NETLIST TIME: Sep  8 13:11:45 2016
`timescale 1ns / 1ns 

// Ayar: disconnected rx_idat_buf pin of aibcr3_rxdig from pd_dataout since
// pd_dataout is loading a critical net and is never used

module aibcr3_digital ( clkbuf_en, datbuf_en, indrv_buf, ipdrv_buf,
     itx_en_buf, odat0, odat1, pd_dataout, rx_disable, sync_datbuf_en0,
     sync_datbuf_en1, tx_dat, weak_pulldownen, weak_pullupenb, 
      async_data, clkdr, iclkin_dist, idat0, idat1,
     idataselb, iddrctrl, ilaunch_clk, ilpbk_dat, ilpbk_en, indrv,
     ipadrstb, ipdrv, irstb, irxen, istrbclk, itx_en, rx_idat,
     test_weakpd, test_weakpu, testmode_en 
);

output  clkbuf_en, datbuf_en, itx_en_buf, odat0, odat1, pd_dataout,
     rx_disable, sync_datbuf_en0, sync_datbuf_en1, tx_dat,
     weak_pulldownen, weak_pullupenb;


input  async_data, clkdr, iclkin_dist, idat0, idat1, idataselb,
     iddrctrl, ilaunch_clk, ilpbk_dat, ilpbk_en, ipadrstb, irstb,
     istrbclk, itx_en, rx_idat, test_weakpd, test_weakpu, testmode_en;


output [1:0]  ipdrv_buf;
output [1:0]  indrv_buf;

input [1:0]  ipdrv;
input [1:0]  indrv;
input [2:0]  irxen;

wire rx_idat_buf_nc;

assign pd_dataout = 1'b0;

aibcr3_rxdig x3 ( clkbuf_en, datbuf_en, odat0, odat1, rx_disable,
     rx_idat_buf_nc, sync_datbuf_en0, sync_datbuf_en1,
     iclkin_dist, ipadrstb, irstb, irxen[2:0], istrbclk, rx_idat);
aibcr3_txdig x1 ( indrv_buf[1:0], ipdrv_buf[1:0], itx_en_buf, tx_dat,
     weak_pulldownen, weak_pullupenb, async_data, clkdr,
     idat0, idat1, idataselb, iddrctrl, ilaunch_clk, ilpbk_dat,
     ilpbk_en, indrv[1:0], ipadrstb, ipdrv[1:0], irstb, itx_en,
     rx_disable, test_weakpd, test_weakpu, testmode_en);

endmodule

