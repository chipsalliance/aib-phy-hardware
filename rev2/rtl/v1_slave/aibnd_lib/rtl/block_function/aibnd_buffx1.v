// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_buffx1, View - schematic
// LAST TIME SAVED: Dec 15 17:40:04 2014
// NETLIST TIME: Dec 17 10:24:02 2014

module aibnd_buffx1 ( oclk, oclkb, oclkn, odat0, odat1, odat_async,
     pd_data, iopad, async_dat, clkdr, iclkin_dist, iclkn, idat0,
     idat1, idataselb, iddren, ilaunch_clk, ilpbk_dat, ilpbk_en, indrv,
     ipadrstb, ipdrv, irstb, irxen, istrbclk, itxen, test_weakpd,
     test_weakpu, testmode_en, vccl_aibnd, vssl_aibnd );

output  oclk, oclkb, oclkn, odat0, odat1, odat_async, pd_data;

inout  iopad;

input  async_dat, clkdr, iclkin_dist, iclkn, idat0, idat1, idataselb,
     iddren, ilaunch_clk, ilpbk_dat, ilpbk_en, ipadrstb, irstb,
     istrbclk, itxen, test_weakpd, test_weakpu, testmode_en,
     vccl_aibnd, vssl_aibnd;

input [1:0]  ipdrv;
input [1:0]  indrv;
input [2:0]  irxen;


/* Updated by KS Chia. Update TX drive strength.
aibnd_analog xanlg ( .vssl_aibnd(vssl_aibnd), .vccl_aibnd(vccl_aibnd),
     .odat_async(odat_async), .clk_en(clkbuf_en), .data_en(datbuf_en),
     .weak_pullupenb(weak_pullu_enb), .ndrv_enb({ndrv_sel0, ndrv_sel0,
     ndrv_sel0, ndrv_sel0, ndrv_sel0, ndrv_sel0, ndrv_sel0, ndrv_sel0,
     ndrv_sel0, ndrv_sel0, ndrv_sel0, ndrv_sel0, ndrv_sel1, ndrv_sel2,
     ndrv_sel3, ndrv_sel3}), .odat(rx_idat), .oclkn(oclkb),
     .oclkp(oclk), .iopad(iopad), .iclkn(iclkn), .pdrv_en({pdrv_sel0,
     pdrv_sel0, pdrv_sel0, pdrv_sel0, pdrv_sel0, pdrv_sel0, pdrv_sel0,
     pdrv_sel0, pdrv_sel0, pdrv_sel0, pdrv_sel0, pdrv_sel0, pdrv_sel1,
     pdrv_sel2, pdrv_sel3, pdrv_sel3}), .txdin(tx_dat),
     .weak_pulldownen(weak_pulld_en)); */
aibnd_analog xanlg (  .vssl_aibnd(vssl_aibnd), .vccl_aibnd(vccl_aibnd),
     .odat_async(odat_async), .clk_en(clkbuf_en), .data_en(datbuf_en),
     .weak_pullupenb(weak_pullu_enb), .ndrv_enb({ndrv_sel3, ndrv_sel3,
     ndrv_sel2, ndrv_sel1, ndrv_sel0, ndrv_sel0, ndrv_sel0, ndrv_sel0,
     ndrv_sel0, ndrv_sel0, ndrv_sel0, ndrv_sel0, ndrv_sel1, ndrv_sel2,
     ndrv_sel2, ndrv_sel3}), .odat(rx_idat), .oclkn(oclkb),
     .oclkp(oclk), .iopad(iopad), .iclkn(iclkn), .pdrv_en({pdrv_sel3,
     pdrv_sel2, pdrv_sel1, pdrv_sel0, pdrv_sel0, pdrv_sel0, pdrv_sel0,
     pdrv_sel0, pdrv_sel0, pdrv_sel0, pdrv_sel0, pdrv_sel0, pdrv_sel0,
     pdrv_sel1, pdrv_sel2, pdrv_sel3}), .txdin(tx_dat),
     .weak_pulldownen(weak_pulld_en));


aibnd_digital xdig ( .vccl_aibnd(vccl_aibnd), .vssl_aibnd(vssl_aibnd),
     .ipadrstb(ipadrstb), .datbuf_en(datbuf_en), .clkdr(clkdr),
     .testmode_en(testmode_en), .test_weakpd(test_weakpd),
     .test_weakpu(test_weakpu), .weak_pullu_enb(weak_pullu_enb),
     .rx_idat(rx_idat), .async_data(async_dat), .pd_dataout(pd_data),
     .weak_pulld_en(weak_pulld_en), .clkbuf_en(clkbuf_en),
     .ndrv_sel0(ndrv_sel0), .ndrv_sel1(ndrv_sel1),
     .ndrv_sel2(ndrv_sel2), .ndrv_sel3(ndrv_sel3), .odat0(odat0),
     .odat1(odat1), .pdrv_sel0(pdrv_sel0), .pdrv_sel1(pdrv_sel1),
     .pdrv_sel2(pdrv_sel2), .pdrv_sel3(pdrv_sel3),
     .rx_disable(rx_disable), .sync_datbuf_en0(sync_datbuf_en0),
     .sync_datbuf_en1(sync_datbuf_en1), .tx_dat(tx_dat),
     .iclkin_dist(iclkin_dist), .idat0(idat0), .idat1(idat1),
     .idataselb(idataselb), .iddrctrl(iddren),
     .ilaunch_clk(ilaunch_clk), .ilpbk_dat(ilpbk_dat),
     .ilpbk_en(ilpbk_en), .indrv(indrv[1:0]), .ipdrv(ipdrv[1:0]),
     .irstb(irstb), .irxen(irxen[2:0]), .istrbclk(istrbclk),
     .itx_en(itxen));
aibnd_aliasd  aliasv0 ( .MINUS(oclkn), .PLUS(iopad));

endmodule

