// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3_lib, Cell - aibcr3_rxdig, View - schematic
// LAST TIME SAVED: Sep  5 22:18:31 2016
// NETLIST TIME: Sep  8 13:11:45 2016
`timescale 1ns / 1ns 

module aibcr3_rxdig ( clkbuf_en, datbuf_en, odat0, odat1, rx_disable,
     rx_idat_buf, sync_datbuf_en0, sync_datbuf_en1,  
     iclkin_dist, ipadrstb, irstb, irxen, istrbclk, rx_idat );

output  clkbuf_en, datbuf_en, odat0, odat1, rx_disable, rx_idat_buf,
     sync_datbuf_en0, sync_datbuf_en1;

input  iclkin_dist, ipadrstb, irstb, istrbclk, rx_idat;

input [2:0]  irxen;


wire pre_databuf_enb;
wire pre_databuf_en_outb;
wire irxen0_b;
wire irxen1;
wire irxen2_b;
wire irxen0;
wire irxen1_b;
wire irxen2;
wire datbuf_enb;
wire syncdat_en0b;
wire gt_sync_datbuf_en1b;
wire gt_sync_datbuf_en0b;
wire odat1_int_inv;
wire idat1_hold_buf1;
wire idat1_sync;
wire idat0_sync;
wire idat0_hold_buf3;
wire idat0_latch;
wire odat0_int;
wire istrbclkb;
wire rx_idatb;

assign tielo = 1'b0;
assign pre_databuf_en = !pre_databuf_enb;
assign pre_databuf_en_out = !pre_databuf_en_outb;
assign rx_disableb = !(irxen0_b & irxen1 & irxen2_b);
assign syncdat_en1b = !(irxen0 & irxen1_b & irxen2_b);
assign clk_modeb = !(irxen0 & irxen1 & irxen2_b);
assign pd_modeb = !(irxen0_b & irxen1_b & irxen2);
assign asyncdat_enb = !(irxen0_b & irxen1_b & irxen2_b);
assign datbuf_en = !datbuf_enb;
assign asyn_data_en = !asyncdat_enb;
assign sdr_mode = !pd_modeb;
assign clkbuf_en = !clk_modeb;
assign sync_datbuf_en0 = !syncdat_en0b;
assign sync_datbuf_en1 = !syncdat_en1b;
assign rx_disable = !rx_disableb;
assign net069 = !ipadrstb;
assign irxen2 = !irxen2_b;
assign irxen1 = !irxen1_b;
assign irxen0 = !irxen0_b;
assign gt_sync_datbuf_en1 = !gt_sync_datbuf_en1b;
assign gt_sync_datbuf_en0 = !gt_sync_datbuf_en0b;
assign odat1_int = !odat1_int_inv;
assign pre_databuf_en_outb = !(pre_databuf_en | tielo);
assign datbuf_enb = !(pre_databuf_en_out | sdr_mode);
assign pre_databuf_enb = !(sync_datbuf_en1 | asyn_data_en);
assign syncdat_en0b = !(sync_datbuf_en1 | sdr_mode);
assign irxen0_b = !(irxen[0] & ipadrstb);
assign irxen1_b = !(irxen[1] | net069);
assign irxen2_b = !(irxen[2] & ipadrstb);
assign gt_sync_datbuf_en1b = !(irstb & sync_datbuf_en1);
assign gt_sync_datbuf_en0b = !(irstb & sync_datbuf_en0);
assign idat0_latch_buf1 = idat1_hold_buf1;
assign idat1_hold_buf1 = idat1_sync;
assign idat0_hold_buf1 = idat0_sync;
assign idat0_latch_din = idat0_hold_buf3;
assign idat0_hold_buf4 = idat0_latch;
assign idat0_hold_buf5 = idat0_hold_buf4;
assign idat0_latch_buf0 = idat0_hold_buf5;
assign idat0_hold_buf2 = idat0_hold_buf1;
assign idat0_hold_buf3 = idat0_hold_buf2;
assign odat1 = odat1_int;
assign odat0 = odat0_int;
assign istrbclk_buf = !istrbclkb;
assign istrbclkb = !istrbclk;
assign rx_idat_buf_del_inv = !rx_idat_buf;
assign iclkin_distb = !iclkin_dist;
assign iclkin_dist_buf = !iclkin_distb;
assign rx_idat_buf = !rx_idatb;
assign rx_idatb = !rx_idat;


aibcr3_ulvt16_dffsdn_cust x35 ( .Q(odat1_int_inv), 
     .CK(iclkin_dist_buf), .D(idat0_latch_buf1), .SDN(gt_sync_datbuf_en1));
aibcr3_ulvt16_dffcdn_cust x56 ( .Q(idat1_sync), 
     .CDN(gt_sync_datbuf_en1), .CK(istrbclk_buf), .D(rx_idat_buf_del_inv));
aibcr3_ulvt16_dffcdn_cust x49 ( .Q(idat0_sync), 
     .CDN(gt_sync_datbuf_en0), .CK(istrbclkb), .D(rx_idat_buf));
aibcr3_latch x44 (.Q(idat0_latch), .CDN(gt_sync_datbuf_en0), .E(istrbclk_buf),
     .D(idat0_latch_din));
/* changed to latch
aibcr3_ulvt16_dffcdn_cust x44 ( .Q(idat0_latch), 
     .CDN(gt_sync_datbuf_en0), .CK(istrbclkb), .D(idat0_latch_din));
*/
aibcr3_ulvt16_dffcdn_cust x36 ( .Q(odat0_int), 
     .CDN(gt_sync_datbuf_en0), .CK(iclkin_dist_buf), .D(idat0_latch_buf0));

endmodule
