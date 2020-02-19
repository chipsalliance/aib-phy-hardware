// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_avmm2, View - schematic
// LAST TIME SAVED: Jul  6 22:07:17 2015
// NETLIST TIME: Jul  8 13:09:51 2015
// `timescale 1ns / 1ns 

module aibnd_avmm2 ( avmm2_odat0, avmm2_odat1, idat0_voutp10,
     idat0_voutp11, idat1_voutp10, idat1_voutp11, idataselb_voutp10,
     idataselb_voutp11, irxen_vinp1, itxen_voutp10, itxen_voutp11,
     jtag_clkdr_in_dirin5, jtag_clkdr_in_voutp10, jtag_clkdr_vinp1,
     jtag_rx_scan_in_dirin5, jtag_rx_scan_in_voutp10,
     jtag_rx_scan_vinp1, oclkn_vinp1, shift_en_vinp1, shift_en_voutp10,
     shift_en_voutp11, iopad_avmm2_in, iopad_avmm2_out,
     async_dat_outpdir1_1, avmm2_idat0, avmm2_idat1, avmm2_rstb,
     avmm_sync_rstb, clkdr_xr2l, clkdr_xr3l, clkdr_xr4l, idataselb,
     idataselb_in0_directout2, idataselb_outpdir1_1,
     idirectout_data_outpdir2_1, indrv_r34, ipdrv_r34, irxen_r0, itxen,
     itxen_in0_directout2, itxen_outpdir1_1, jtag_clkdr_out_dirout2,
     jtag_clkdr_out_outpdir1_1, jtag_clkdr_srcclkinn, jtag_clksel,
     jtag_intest, jtag_mode_in, jtag_rstb, jtag_rstb_en,
     jtag_rx_scan_out_dirout2, jtag_rx_scan_out_outpdir1_1,
     jtag_rx_scan_srcclkinn, jtag_tx_scanen_in, jtag_weakpdn,
     jtag_weakpu, odat0_outpdir0_1, odat1_outpdir0_1, rshift_en_rx,
     rshift_en_tx, rx_distclk_vinp1, rx_strbclk_vinp1,
     shift_en_directout2, shift_en_outpdir1_1, shift_en_srcclkinn,
     tx_launch_clk_l0, tx_launch_clk_l1, vccl_aibnd, vssl_aibnd );

output  avmm2_odat0, avmm2_odat1, idat0_voutp10, idat0_voutp11,
     idat1_voutp10, idat1_voutp11, idataselb_voutp10,
     idataselb_voutp11, itxen_voutp10, itxen_voutp11,
     jtag_clkdr_in_dirin5, jtag_clkdr_in_voutp10, jtag_clkdr_vinp1,
     jtag_rx_scan_in_dirin5, jtag_rx_scan_in_voutp10,
     jtag_rx_scan_vinp1, oclkn_vinp1, shift_en_vinp1, shift_en_voutp10,
     shift_en_voutp11;

inout  iopad_avmm2_in;

input  async_dat_outpdir1_1, avmm2_rstb, avmm_sync_rstb, clkdr_xr2l,
     clkdr_xr3l, clkdr_xr4l, idataselb, idataselb_in0_directout2,
     idataselb_outpdir1_1, idirectout_data_outpdir2_1, itxen,
     itxen_in0_directout2, itxen_outpdir1_1, jtag_clkdr_out_dirout2,
     jtag_clkdr_out_outpdir1_1, jtag_clkdr_srcclkinn, jtag_clksel,
     jtag_intest, jtag_mode_in, jtag_rstb, jtag_rstb_en,
     jtag_rx_scan_out_dirout2, jtag_rx_scan_out_outpdir1_1,
     jtag_rx_scan_srcclkinn, jtag_tx_scanen_in, jtag_weakpdn,
     jtag_weakpu, odat0_outpdir0_1, odat1_outpdir0_1, rshift_en_rx,
     rx_distclk_vinp1, rx_strbclk_vinp1, shift_en_directout2,
     shift_en_outpdir1_1, shift_en_srcclkinn, tx_launch_clk_l0,
     tx_launch_clk_l1, vccl_aibnd, vssl_aibnd;

output [2:0]  irxen_vinp1;

inout [1:0]  iopad_avmm2_out;

input [1:0]  indrv_r34;
input [1:0]  ipdrv_r34;
input [2:0]  irxen_r0;
input [1:0]  avmm2_idat0;
input [1:0]  rshift_en_tx;
input [1:0]  avmm2_idat1;

// Buses in the design

wire  [0:1]  nctx_oclkn;

wire  [0:1]  nctx_odat_async_aib;

wire  [0:1]  nctx_oclk;

wire  [0:1]  nctx_odat0;

wire  [0:1]  nctx_oclkb;

wire  [0:1]  nctx_oclk_aib;

wire  [0:1]  nctx_odat1;

wire  [0:1]  nctx_pd_data_aib;

wire  [0:1]  nctx_oclkb_aib;

wire  [0:1]  nctx_odat1_aib;

wire  [0:1]  nctx_odat_async;

wire  [0:1]  nctx_odat0_aib;

wire  [0:1]  nctx_pd_data;


// specify 
//     specparam CDS_LIBNAME  = "aibnd_lib";
//     specparam CDS_CELLNAME = "aibnd_avmm2";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

aibnd_buffx1_top xtx0 ( .idata1_in1_jtag_out(idat1_voutp10),
     .async_dat_in1_jtag_out(nc_async_dat_voutp10),
     .idata0_in1_jtag_out(idat0_voutp10),
     .jtag_clkdr_outn(jtag_clkdr_outn_voutp10),
     .prev_io_shift_en(shift_en_outpdir1_1),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .vssl_aibnd(vssl_aibnd), .vccl_aibnd(vccl_aibnd),
     .jtag_intest(jtag_intest), .anlg_rstb(avmm2_rstb),
     .pd_data_aib(nctx_pd_data_aib[0]), .oclk_out(nctx_oclk[0]),
     .oclkb_out(nctx_oclkb[0]), .odat0_out(nctx_odat0[0]),
     .odat1_out(nctx_odat1[0]), .odat_async_out(nctx_odat_async[0]),
     .pd_data_out(nctx_pd_data[0]), .async_dat_in0(vssl_aibnd),
     .async_dat_in1(async_dat_outpdir1_1),
     .iclkin_dist_in0(jtag_clkdr_outn_voutp10),
     .iclkin_dist_in1(vssl_aibnd), .idata0_in0(avmm2_idat0[0]),
     .idata0_in1(vssl_aibnd), .idata1_in0(avmm2_idat1[0]),
     .idata1_in1(vssl_aibnd), .idataselb_in0(idataselb),
     .idataselb_in1(idataselb_outpdir1_1), .iddren_in0(vssl_aibnd),
     .iddren_in1(vssl_aibnd), .ilaunch_clk_in0(tx_launch_clk_l1),
     .ilaunch_clk_in1(vssl_aibnd), .ilpbk_dat_in0(vssl_aibnd),
     .ilpbk_dat_in1(vssl_aibnd), .ilpbk_en_in0(vssl_aibnd),
     .ilpbk_en_in1(vssl_aibnd), .indrv_in0(indrv_r34[1:0]),
     .indrv_in1(indrv_r34[1:0]), .ipdrv_in0(ipdrv_r34[1:0]),
     .ipdrv_in1(ipdrv_r34[1:0]), .irxen_in0({vssl_aibnd, vccl_aibnd,
     vssl_aibnd}), .irxen_in1({vssl_aibnd, vccl_aibnd, vssl_aibnd}),
     .istrbclk_in0(jtag_clkdr_outn_voutp10), .istrbclk_in1(vssl_aibnd),
     .itxen_in0(itxen), .itxen_in1(itxen_outpdir1_1),
     .oclk_in1(vssl_aibnd), .odat_async_aib(nctx_odat_async_aib[0]),
     .oclkb_in1(vssl_aibnd), .odat0_in1(vssl_aibnd),
     .odat1_in1(vssl_aibnd), .odat_async_in1(vssl_aibnd),
     .shift_en(rshift_en_tx[0]), .pd_data_in1(vssl_aibnd),
     .dig_rstb(avmm_sync_rstb), .jtag_clkdr_out(jtag_clkdr_in_voutp10),
     .odat1_aib(nctx_odat1_aib[0]),
     .jtag_rx_scan_out(jtag_rx_scan_in_voutp10),
     .odat0_aib(nctx_odat0_aib[0]), .oclk_aib(nctx_oclk_aib[0]),
     .last_bs_out(nc_last_bs_out_voutp10),
     .oclkb_aib(nctx_oclkb_aib[0]), .jtag_clkdr_in(clkdr_xr3l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_out_outpdir1_1),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl_aibnd),
     .iopad(iopad_avmm2_out[0]), .oclkn(nctx_oclkn[0]),
     .iclkn(vssl_aibnd), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibnd_buffx1_top xtx1 ( .idata1_in1_jtag_out(idat1_voutp11),
     .async_dat_in1_jtag_out(nc_async_dat_voutp11),
     .idata0_in1_jtag_out(idat0_voutp11),
     .jtag_clkdr_outn(jtag_clkdr_outn_voutp11),
     .prev_io_shift_en(shift_en_directout2),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .vssl_aibnd(vssl_aibnd), .vccl_aibnd(vccl_aibnd),
     .jtag_intest(jtag_intest), .anlg_rstb(avmm2_rstb),
     .pd_data_aib(nctx_pd_data_aib[1]), .oclk_out(nctx_oclk[1]),
     .oclkb_out(nctx_oclkb[1]), .odat0_out(nctx_odat0[1]),
     .odat1_out(nctx_odat1[1]), .odat_async_out(nctx_odat_async[1]),
     .pd_data_out(nctx_pd_data[1]), .async_dat_in0(vssl_aibnd),
     .async_dat_in1(idirectout_data_outpdir2_1),
     .iclkin_dist_in0(jtag_clkdr_outn_voutp11),
     .iclkin_dist_in1(vssl_aibnd), .idata0_in0(avmm2_idat0[1]),
     .idata0_in1(vssl_aibnd), .idata1_in0(avmm2_idat1[1]),
     .idata1_in1(vssl_aibnd), .idataselb_in0(idataselb),
     .idataselb_in1(idataselb_in0_directout2), .iddren_in0(vssl_aibnd),
     .iddren_in1(vssl_aibnd), .ilaunch_clk_in0(tx_launch_clk_l0),
     .ilaunch_clk_in1(vssl_aibnd), .ilpbk_dat_in0(vssl_aibnd),
     .ilpbk_dat_in1(vssl_aibnd), .ilpbk_en_in0(vssl_aibnd),
     .ilpbk_en_in1(vssl_aibnd), .indrv_in0(indrv_r34[1:0]),
     .indrv_in1(indrv_r34[1:0]), .ipdrv_in0(ipdrv_r34[1:0]),
     .ipdrv_in1(ipdrv_r34[1:0]), .irxen_in0({vssl_aibnd, vccl_aibnd,
     vssl_aibnd}), .irxen_in1({vssl_aibnd, vccl_aibnd, vssl_aibnd}),
     .istrbclk_in0(jtag_clkdr_outn_voutp11), .istrbclk_in1(vssl_aibnd),
     .itxen_in0(itxen), .itxen_in1(itxen_in0_directout2),
     .oclk_in1(vssl_aibnd), .odat_async_aib(nctx_odat_async_aib[1]),
     .oclkb_in1(vssl_aibnd), .odat0_in1(vssl_aibnd),
     .odat1_in1(vssl_aibnd), .odat_async_in1(vssl_aibnd),
     .shift_en(rshift_en_tx[1]), .pd_data_in1(vssl_aibnd),
     .dig_rstb(avmm_sync_rstb), .jtag_clkdr_out(jtag_clkdr_in_dirin5),
     .odat1_aib(nctx_odat1_aib[1]),
     .jtag_rx_scan_out(jtag_rx_scan_in_dirin5),
     .odat0_aib(nctx_odat0_aib[1]), .oclk_aib(nctx_oclk_aib[1]),
     .last_bs_out(nc_last_bs_out_voutp11),
     .oclkb_aib(nctx_oclkb_aib[1]), .jtag_clkdr_in(clkdr_xr4l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_out_dirout2),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl_aibnd),
     .iopad(iopad_avmm2_out[1]), .oclkn(nctx_oclkn[1]),
     .iclkn(vssl_aibnd), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibnd_buffx1_top x96 ( .idata1_in1_jtag_out(nc_idata1_vinp1),
     .async_dat_in1_jtag_out(nc_async_dat_vinp1),
     .idata0_in1_jtag_out(nc_idata0_vinp1),
     .jtag_clkdr_outn(jtag_clkdr_outn_clkdr),
     .prev_io_shift_en(shift_en_srcclkinn),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .vssl_aibnd(vssl_aibnd), .vccl_aibnd(vccl_aibnd),
     .jtag_intest(jtag_intest), .anlg_rstb(avmm2_rstb),
     .pd_data_aib(ncrx_pd_data_aib), .oclk_out(ncrx_oclk),
     .oclkb_out(ncrx_oclkb), .odat0_out(avmm2_odat0),
     .odat1_out(avmm2_odat1), .odat_async_out(ncrx_odat_async),
     .pd_data_out(ncrx_pd_data), .async_dat_in0(vssl_aibnd),
     .async_dat_in1(vssl_aibnd), .iclkin_dist_in0(rx_distclk_vinp1),
     .iclkin_dist_in1(vssl_aibnd), .idata0_in0(vssl_aibnd),
     .idata0_in1(vssl_aibnd), .idata1_in0(vssl_aibnd),
     .idata1_in1(vssl_aibnd), .idataselb_in0(vccl_aibnd),
     .idataselb_in1(vssl_aibnd), .iddren_in0(vssl_aibnd),
     .iddren_in1(vssl_aibnd), .ilaunch_clk_in0(vssl_aibnd),
     .ilaunch_clk_in1(vssl_aibnd), .ilpbk_dat_in0(vssl_aibnd),
     .ilpbk_dat_in1(vssl_aibnd), .ilpbk_en_in0(vssl_aibnd),
     .ilpbk_en_in1(vssl_aibnd), .indrv_in0({vssl_aibnd, vssl_aibnd}),
     .indrv_in1({vssl_aibnd, vssl_aibnd}), .ipdrv_in0({vssl_aibnd,
     vssl_aibnd}), .ipdrv_in1({vssl_aibnd, vssl_aibnd}),
     .irxen_in0(irxen_r0[2:0]), .irxen_in1({vssl_aibnd, vccl_aibnd,
     vssl_aibnd}), .istrbclk_in0(rx_strbclk_vinp1),
     .istrbclk_in1(vssl_aibnd), .itxen_in0(vssl_aibnd),
     .itxen_in1(vssl_aibnd), .oclk_in1(vssl_aibnd),
     .odat_async_aib(ncrx_odat_async_aib), .oclkb_in1(vssl_aibnd),
     .odat0_in1(odat0_outpdir0_1), .odat1_in1(odat1_outpdir0_1),
     .odat_async_in1(vssl_aibnd), .shift_en(rshift_en_rx),
     .pd_data_in1(vssl_aibnd), .dig_rstb(avmm_sync_rstb),
     .jtag_clkdr_out(jtag_clkdr_vinp1), .odat1_aib(ncrx_odat1_aib),
     .jtag_rx_scan_out(jtag_rx_scan_vinp1), .odat0_aib(ncrx_odat0_aib),
     .oclk_aib(ncrx_oclk_aib), .last_bs_out(nc_last_bs_out_avmm2in),
     .oclkb_aib(ncrx_oclkb_aib), .jtag_clkdr_in(clkdr_xr2l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_srcclkinn),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl_aibnd),
     .iopad(iopad_avmm2_in), .oclkn(oclkn_vinp1), .iclkn(vssl_aibnd),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibnd_aliasd  aliasv7 ( .MINUS(itxen_voutp10), .PLUS(itxen));
aibnd_aliasd  aliasv16 ( .MINUS(idataselb_voutp10), .PLUS(idataselb));
aibnd_aliasd  aliasv14 ( .MINUS(idataselb_voutp11), .PLUS(idataselb));
aibnd_aliasd  aliasv19[2:0] ( .MINUS(irxen_vinp1[2:0]),      .PLUS(irxen_r0[2:0]));
aibnd_aliasd  aliasv8 ( .MINUS(itxen_voutp11), .PLUS(itxen));
aibnd_aliasd  aliasd1 ( .MINUS(shift_en_voutp11), .PLUS(rshift_en_tx[1]));
aibnd_aliasd  aliasd2 ( .MINUS(shift_en_vinp1), .PLUS(rshift_en_rx));
aibnd_aliasd  aliasd0 ( .MINUS(shift_en_voutp10), .PLUS(rshift_en_tx[0]));

endmodule

