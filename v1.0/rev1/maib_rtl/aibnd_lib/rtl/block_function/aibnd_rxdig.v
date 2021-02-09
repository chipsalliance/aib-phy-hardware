// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_rxdig, View - schematic
// LAST TIME SAVED: Dec  1 16:18:35 2014
// NETLIST TIME: Dec 17 10:24:02 2014

module aibnd_rxdig ( clkbuf_en, datbuf_en, odat0, odat1, rx_disable,
     rx_idat_buf, sync_datbuf_en0, sync_datbuf_en1, iclkin_dist,
     ipadrstb, irstb, irxen, istrbclk, rx_idat, vccl_aibnd, vssl_aibnd
     );

output  clkbuf_en, datbuf_en, odat0, odat1, rx_disable, rx_idat_buf,
     sync_datbuf_en0, sync_datbuf_en1;

input  iclkin_dist, ipadrstb, irstb, istrbclk, rx_idat, vccl_aibnd,
     vssl_aibnd;

input [2:0]  irxen;

wire irxen1_b, rst, iclkin_dist, iclkin_distb, iclkin_dist_buf, istrbclkb, istrbclk_buf, istrbclk, ipadrstb, irxen0, irxen0_b, irxen1, irxen2, irxen2_b, sdr_mode, clkbuf_en, sync_datbuf_en1, asyn_data_en, rx_disable, sync_datbuf_en0, pre_databuf_en_out, pre_databuf_en, datbuf_en, odat1_int, odat1, odat0_int, odat0, gt_sync_datbuf_en1, irstb, gt_sync_datbuf_en0, rx_idat, rx_idat_buf; // Conversion Sript Generated



assign irxen1_b = !(irxen[1] | rst);
assign iclkin_distb = !iclkin_dist;
assign iclkin_dist_buf = !iclkin_distb;
assign istrbclk_buf = !istrbclkb;
assign istrbclkb = !istrbclk;
aibnd_latch  lyn0 ( .clk(istrbclk_buf), .rb(gt_sync_datbuf_en0) /*`ifndef INTCNOPWR , .vcc(vccl_aibnd) , .vss(vssl_aibnd) `endif*/ , .d(idat0_sync1),     .o(idat0_latch));
aibnd_ff_r  fyn0 ( .o(odat0_int), .d(idat0_latch),     .clk(iclkin_dist_buf) /*`ifndef INTCNOPWR , .vss(vssl_aibnd) , .vcc(vccl_aibnd) `endif*/ ,     .rb(gt_sync_datbuf_en0));
aibnd_ff_r  fyn1 ( .o(odat1_int), .d(idat1_sync),     .clk(iclkin_dist_buf) /*`ifndef INTCNOPWR , .vss(vssl_aibnd) , .vcc(vccl_aibnd) `endif*/ ,     .rb(gt_sync_datbuf_en1));
assign rst = !ipadrstb;
assign irxen0 = !irxen0_b;
assign irxen1 = !irxen1_b;
assign irxen2 = !irxen2_b;
assign sdr_mode = irxen0_b & irxen1_b & irxen2;
assign clkbuf_en = irxen0 & irxen1 & irxen2_b;
assign sync_datbuf_en1 = irxen0 & irxen1_b & irxen2_b;
assign asyn_data_en = irxen0_b & irxen1_b & irxen2_b;
assign rx_disable = irxen0_b & irxen1 & irxen2_b;
assign sync_datbuf_en0 = sync_datbuf_en1 | sdr_mode;
//KSCHIA hack. WW21. Disconnect clkbuf_en to vss.
//assign pre_databuf_en_out = pre_databuf_en | clkbuf_en;
assign pre_databuf_en_out = pre_databuf_en | 1'b0;
assign pre_databuf_en = sync_datbuf_en1 | asyn_data_en;
assign datbuf_en = pre_databuf_en_out | sdr_mode;
assign odat1 = odat1_int;
assign odat0 = odat0_int;
assign gt_sync_datbuf_en1 = irstb & sync_datbuf_en1;
assign gt_sync_datbuf_en0 = irstb & sync_datbuf_en0;
assign irxen2_b = !(irxen[2] & ipadrstb);
assign irxen0_b = !(irxen[0] & ipadrstb);

//TWTAN : Update the RTL to match with the timing fix , adding inverter before , after fyn3 datapath .
//TWTAN : revert the change to invert the data before/after fyn3 . No invertion before/after fyn3 now
//wire idat_sync1_inv, rx_idat_buf_inv;
//assign idat1_sync = !idat_sync1_inv;
//assign rx_idat_buf_inv = !rx_idat_buf;

aibnd_ff_r  fyn3 ( .o(idat1_sync), .d(rx_idat_buf),     .clk(istrbclk_buf) /*`ifndef INTCNOPWR , .vss(vssl_aibnd) , .vcc(vccl_aibnd) `endif*/ ,     .rb(gt_sync_datbuf_en1));
aibnd_ff_r  fyn2 ( .o(idat0_sync1), .d(rx_idat_buf),     .clk(istrbclkb) /*`ifndef INTCNOPWR , .vss(vssl_aibnd) , .vcc(vccl_aibnd) `endif*/ ,     .rb(gt_sync_datbuf_en0));
assign rx_idat_buf = rx_idat;

endmodule

