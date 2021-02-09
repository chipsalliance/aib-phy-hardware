// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_digital, View - schematic
// LAST TIME SAVED: Dec  1 16:31:14 2014
// NETLIST TIME: Dec 17 10:24:02 2014

module aibnd_digital ( clkbuf_en, datbuf_en, ndrv_sel0, ndrv_sel1,
     ndrv_sel2, ndrv_sel3, odat0, odat1, pd_dataout, pdrv_sel0,
     pdrv_sel1, pdrv_sel2, pdrv_sel3, rx_disable, sync_datbuf_en0,
     sync_datbuf_en1, tx_dat, weak_pulld_en, weak_pullu_enb,
     async_data, clkdr, iclkin_dist, idat0, idat1, idataselb, iddrctrl,
     ilaunch_clk, ilpbk_dat, ilpbk_en, indrv, ipadrstb, ipdrv, irstb,
     irxen, istrbclk, itx_en, rx_idat, test_weakpd, test_weakpu,
     testmode_en, vccl_aibnd, vssl_aibnd );

output  clkbuf_en, datbuf_en, ndrv_sel0, ndrv_sel1, ndrv_sel2,
     ndrv_sel3, odat0, odat1, pd_dataout, pdrv_sel0, pdrv_sel1,
     pdrv_sel2, pdrv_sel3, rx_disable, sync_datbuf_en0,
     sync_datbuf_en1, tx_dat, weak_pulld_en, weak_pullu_enb;

input  async_data, clkdr, iclkin_dist, idat0, idat1, idataselb,
     iddrctrl, ilaunch_clk, ilpbk_dat, ilpbk_en, ipadrstb, irstb,
     istrbclk, itx_en, rx_idat, test_weakpd, test_weakpu, testmode_en,
     vccl_aibnd, vssl_aibnd;

input [1:0]  indrv;
input [1:0]  ipdrv;
input [2:0]  irxen;



aibnd_txdig xtxdig ( .vssl_aibnd(vssl_aibnd), .vccl_aibnd(vccl_aibnd),
     .ipadrstb(ipadrstb), .testmode_en(testmode_en), .clkdr(clkdr),
     .ndrv_sel0b(ndrv_sel0), .test_weakpd(test_weakpd),
     .test_weakpu(test_weakpu), .ndrv_sel1b(ndrv_sel1),
     .ndrv_sel2b(ndrv_sel2), .ndrv_sel3b(ndrv_sel3),
     .weak_pullu_enb(weak_pullu_enb), .async_data(async_data),
     .weak_pulld_en(weak_pulld_en), .rx_enb(rx_disable),
     .idataselb(idataselb), .iddrctrl(iddrctrl), .itx_en(itx_en),
     .irstb(irstb), .ilpbk_en(ilpbk_en), .pdrv_sel0(pdrv_sel0),
     .pdrv_sel1(pdrv_sel1), .pdrv_sel2(pdrv_sel2),
     .pdrv_sel3(pdrv_sel3), .tx_dat_out(tx_dat), .idat0(idat0),
     .idat1(idat1), .ilaunch_clk(ilaunch_clk), .ilpbk_dat(ilpbk_dat),
     .indrv(indrv[1:0]), .ipdrv(ipdrv[1:0]));
aibnd_rxdig xrxdig ( .ipadrstb(ipadrstb), .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd), .datbuf_en(datbuf_en),
     .rx_idat_buf(pd_dataout), .rx_idat(rx_idat),
     .clkbuf_en(clkbuf_en), .rx_disable(rx_disable),
     .sync_datbuf_en0(sync_datbuf_en0),
     .sync_datbuf_en1(sync_datbuf_en1), .irxen(irxen[2:0]),
     .odat0(odat0), .odat1(odat1), .iclkin_dist(iclkin_dist),
     .irstb(irstb), .istrbclk(istrbclk));

endmodule

