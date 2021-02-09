// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_txdig, View - schematic
// LAST TIME SAVED: Dec 12 16:40:31 2014
// NETLIST TIME: Dec 17 10:24:02 2014

module aibnd_txdig ( ndrv_sel0b, ndrv_sel1b, ndrv_sel2b, ndrv_sel3b,
     pdrv_sel0, pdrv_sel1, pdrv_sel2, pdrv_sel3, tx_dat_out,
     weak_pulld_en, weak_pullu_enb, async_data, clkdr, idat0, idat1,
     idataselb, iddrctrl, ilaunch_clk, ilpbk_dat, ilpbk_en, indrv,
     ipadrstb, ipdrv, irstb, itx_en, rx_enb, test_weakpd, test_weakpu,
     testmode_en, vccl_aibnd, vssl_aibnd );

output  ndrv_sel0b, ndrv_sel1b, ndrv_sel2b, ndrv_sel3b, pdrv_sel0,
     pdrv_sel1, pdrv_sel2, pdrv_sel3, tx_dat_out, weak_pulld_en,
     weak_pullu_enb;

input  async_data, clkdr, idat0, idat1, idataselb, iddrctrl,
     ilaunch_clk, ilpbk_dat, ilpbk_en, ipadrstb, irstb, itx_en, rx_enb,
     test_weakpd, test_weakpu, testmode_en, vccl_aibnd, vssl_aibnd;

input [1:0]  indrv;
input [1:0]  ipdrv;

wire mux_clk, testmode_en, clkdr, ilaunch_clk, ff1_latch_input, iddrctrl, ff1_dout, ff0_dout, mux_out, clk, ff1_latch_dout, lpb_or_clk, ilpbk_en_buf, ilpbk_dat, async_data_buf, mux_din, idataselb, tx_dat_out, clkb, idat1, din1, idat0, din0, itx_enb, itx_en_buf, weak_pullu_enb, ipadrstb_buf, test_weakpu_buf, weak_pulld_en, weak_pulld_enb, itx_en, ipadrstb, test_weakpd_buf, txenb_rxenb, ilpbk_en, async_data, irstb_buf, irstb, rx_enb, test_weakpu, test_weakpd; // Conversion Sript Generated

// Buses in the design

wire  [1:0]  indrv_buf;

wire  [1:0]  ipdrv_buf;


//Bypass by KSCHIA ww21.
//assign mux_clk = testmode_en ? clkdr : ilaunch_clk;
assign ff1_latch_input = iddrctrl ? ff1_dout : ff0_dout;
assign mux_out = clk ? ff1_latch_dout : ff0_dout;

//Bypass by KSCHIA ww21.
//assign lpb_or_clk = ilpbk_en_buf ? ilpbk_dat : async_data_buf;
//assign mux_din = idataselb ? mux_out : lpb_or_clk;
//assign mux_din = idataselb ? mux_out : async_data_buf;
//assign tx_dat_out = mux_din;
assign tx_dat_out = idataselb ? mux_out : async_data_buf;
aibnd_latch  lyn0 ( .clk(clkb), .rb(irstb_buf) /*`ifndef INTCNOPWR , .vcc(vccl_aibnd) , .vss(vssl_aibnd) `endif*/ , .d(ff1_latch_input), .o(ff1_latch_dout));
assign clkb = !clk;
aibnd_2to4dec xpredriver_decoder ( .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd), .nsel_out3b(ndrv_sel3b),
     .nsel_out2b(ndrv_sel2b), .nsel_out1b(ndrv_sel1b),
     .nsel_out0b(ndrv_sel0b), .psel_out0(pdrv_sel0),
     .psel_in(ipdrv_buf[1:0]), .psel_out1(pdrv_sel1),
     .psel_out2(pdrv_sel2), .psel_out3(pdrv_sel3),
     .nsel_in(indrv_buf[1:0]), .enable(itx_en_buf));
assign indrv_buf[1:0] = indrv[1:0];
assign ipdrv_buf[1:0] = ipdrv[1:0];
//assign clk = mux_clk;
assign clk = ilaunch_clk;
assign din1 = idat1;
assign din0 = idat0;
assign itx_en_buf = !itx_enb;
aibnd_ff_r  fyn1 ( .o(ff0_dout), .d(din0), .clk(clk) /*`ifndef INTCNOPWR , .vss(vssl_aibnd) , .vcc(vccl_aibnd) `endif*/ , .rb(irstb_buf));
aibnd_ff_r  fyn0 ( .o(ff1_dout), .d(din1), .clk(clk) /*`ifndef INTCNOPWR , .vss(vssl_aibnd) , .vcc(vccl_aibnd) `endif*/ , .rb(irstb_buf));
assign weak_pullu_enb = !(ipadrstb_buf & test_weakpu_buf);
assign weak_pulld_en = !(ipadrstb_buf & weak_pulld_enb);
wire test_weakpdb_por;
wire txen_an_weakpdb;
assign test_weakpdb_por = !test_weakpd ;
assign txen_an_weakpdb = itx_en & test_weakpdb_por ;

assign itx_enb = !(txen_an_weakpdb & ipadrstb);
assign weak_pulld_enb = !(test_weakpd_buf | txenb_rxenb);
assign ilpbk_en_buf = ilpbk_en;
assign async_data_buf = async_data;
assign irstb_buf = irstb;
assign txenb_rxenb = rx_enb & itx_enb;
assign ipadrstb_buf = ipadrstb;
assign test_weakpu_buf = test_weakpu;
assign test_weakpd_buf = test_weakpd;

endmodule

