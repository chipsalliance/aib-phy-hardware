// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3_lib, Cell - aibcr3_txdig, View - schematic
// LAST TIME SAVED: Sep  5 22:18:17 2016
// NETLIST TIME: Sep  8 13:11:45 2016
`timescale 1ns / 1ns 

module aibcr3_txdig ( indrv_buf, ipdrv_buf, itx_en_buf, tx_dat_out,
     weak_pulldownen, weak_pullupenb, async_data, clkdr,
     idat0, idat1, idataselb, iddrctrl, ilaunch_clk, ilpbk_dat,
     ilpbk_en, indrv, ipadrstb, ipdrv, irstb, itx_en, rx_enb,
     test_weakpd, test_weakpu, testmode_en );

output  itx_en_buf, tx_dat_out, weak_pulldownen, weak_pullupenb;


input  async_data, clkdr, idat0, idat1, idataselb, iddrctrl,
     ilaunch_clk, ilpbk_dat, ilpbk_en, ipadrstb, irstb, itx_en, rx_enb,
     test_weakpd, test_weakpu, testmode_en;

output [1:0]  indrv_buf;
output [1:0]  ipdrv_buf;

input [1:0]  indrv;
input [1:0]  ipdrv;

wire net036;
wire itx_enb;
wire ff1_dout;
wire ff0_dout;
wire clk;
wire ff1_latch_dout_buf2;
wire ff0_dout_buf2;
wire async_dat_buf;
wire ipadrstb_buf;
wire weak_pulld_enb;
wire test_weakpu_buf;
wire test_weakpd_buf;
wire ff1_latch_buf1;
wire ff1_latch_dout;
wire anlg_rst_nd_out;
wire io_disable_b;

assign txenb_rxenb = ~net036;
assign itx_en_buf = ~itx_enb;
assign ff1_hold_buf0 = iddrctrl ? ff1_dout : ff0_dout;
assign mux_out = clk ? ff1_latch_dout_buf2 : ff0_dout_buf2;
assign mux_din = idataselb ? mux_out : async_dat_buf;
assign net036 = ~(rx_enb & itx_enb);
assign weak_pulldownen = ~(ipadrstb_buf & weak_pulld_enb);
assign weak_pullupenb = ~ (ipadrstb_buf & test_weakpu_buf);
assign itx_enb = ~(itx_en & ipadrstb);
assign weak_pulld_enb = ~(test_weakpd_buf | txenb_rxenb);
assign test_weakpu_buf = test_weakpu;
assign test_weakpd_buf = test_weakpd;
assign ipadrstb_buf = ipadrstb;
assign ipdrv_buf[1] = ipdrv[1];
assign ipdrv_buf[0] = ipdrv[0];
assign indrv_buf[1] = indrv[1];
assign indrv_buf[0] = indrv[0];
assign ff1_hold_buf1 = ff1_hold_buf0;
assign ff0_dout_buf1 = ff0_dout;
assign ff0_dout_buf2 = ff0_dout_buf1;
assign irstb_buf = irstb;
assign async_dat_buf = async_data;
assign tx_dat_out = mux_din;
assign din0 = idat0;
assign din1 = idat1;
assign clkb = ~clk;
assign clk = ilaunch_clk;
assign ff1_latch_dout_buf2 = ff1_latch_buf1;
assign ff1_latch_buf1 = ff1_latch_dout;
assign ff1_latch_input = ff1_hold_buf1;

/* replaced by latch
aibcr3_ulvt16_dffcdn_cust x29 ( ff1_latch_dout, irstb_buf,
     clkb, ff1_latch_input); 
*/
aibcr3_latch x29 (.Q(ff1_latch_dout), .E(clkb), .CDN(irstb_buf), .D(ff1_latch_input));

aibcr3_ulvt16_dffcdn_cust x25 ( .Q(ff1_dout), .CDN(irstb_buf), .CK(clk),
     .D(din1));
aibcr3_ulvt16_dffcdn_cust x18 ( .Q(ff0_dout), .CDN(irstb_buf), .CK(clk),
     .D(din0));


endmodule
