// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3_lib, Cell - aibcr3_avmm2, View - schematic
// LAST TIME SAVED: Jul  8 11:29:14 2015
// NETLIST TIME: Jul  9 10:52:19 2015
// `timescale 1ns / 1ns 

module aibcr3_avmm2 ( avmm2_odat0, avmm2_odat1, idata0_voutp1,
     idata1_voutp1, idataselb_voutp1, irxen_vinp10, irxen_vinp11,
     itxen_voutp1, jtag_clkdr_vinp10, jtag_clkdr_vinp11,
     jtag_clkdr_voutp1, jtag_rx_scan_vinp10, jtag_rx_scan_vinp11,
     jtag_rx_scan_voutp1, odat_async_aib_vinp10, odat_async_aib_vinp11,
     shift_en_vinp10, shift_en_vinp11, shift_en_voutp1, iopad_avmm2_in,
     iopad_avmm2_out, vcc, vccl, vssl, avmm2_idat0, avmm2_idat1,
     avmm2_rstb, avmm_rx_distclk_l0, avmm_rx_distclk_l1,
     avmm_rx_strbclk_l0, avmm_rx_strbclk_l1, clkdr_xr5l, clkdr_xr5r,
     clkdr_xr6l, clkdr_xr6r, clkdr_xr7l, clkdr_xr7r, clkdr_xr8l,
     clkdr_xr8r, idata0_srcclkoutn, idata1_srcclkoutn, idataselb,
     idataselb_srcclkoutn, indrv_r78, ipdrv_r78, irxen_inpdir1_1,
     irxen_inpdir2_1, irxen_r0, itxen, itxen_srcclkoutn,
     jtag_clkdr_inpdir1_1, jtag_clkdr_inpdir2_1, jtag_clkdr_srcclkoutn,
     jtag_clksel, jtag_intest, jtag_mode_in, jtag_rstb, jtag_rstb_en,
     jtag_rx_scan_inpdir1_1, jtag_rx_scan_inpdir2_1,
     jtag_rx_scan_srcclkoutn, jtag_tx_scanen_in, jtag_weakpdn,
     jtag_weakpu, odat0_aib_vinp00, odat0_aib_vinp01, odat1_aib_vinp00,
     odat1_aib_vinp01, por_aib_vcchssi, por_aib_vccl, rshift_en_rx,
     rshift_en_tx, shift_en_inpdir1_1, shift_en_inpdir2_1,
     shift_en_srcclkoutn, tx_launch_clk_l6 );

output  idata0_voutp1, idata1_voutp1, idataselb_voutp1, itxen_voutp1,
     jtag_clkdr_vinp10, jtag_clkdr_vinp11, jtag_clkdr_voutp1,
     jtag_rx_scan_vinp10, jtag_rx_scan_vinp11, jtag_rx_scan_voutp1,
     odat_async_aib_vinp10, odat_async_aib_vinp11, shift_en_vinp10,
     shift_en_vinp11, shift_en_voutp1;

inout  iopad_avmm2_out, vcc, vccl, vssl;

input  avmm2_idat0, avmm2_idat1, avmm2_rstb, avmm_rx_distclk_l0,
     avmm_rx_distclk_l1, avmm_rx_strbclk_l0, avmm_rx_strbclk_l1,
     clkdr_xr5l, clkdr_xr5r, clkdr_xr6l, clkdr_xr6r, clkdr_xr7l,
     clkdr_xr7r, clkdr_xr8l, clkdr_xr8r, idata0_srcclkoutn,
     idata1_srcclkoutn, idataselb, idataselb_srcclkoutn, itxen,
     itxen_srcclkoutn, jtag_clkdr_inpdir1_1, jtag_clkdr_inpdir2_1,
     jtag_clkdr_srcclkoutn, jtag_clksel, jtag_intest, jtag_mode_in,
     jtag_rstb, jtag_rstb_en, jtag_rx_scan_inpdir1_1,
     jtag_rx_scan_inpdir2_1, jtag_rx_scan_srcclkoutn,
     jtag_tx_scanen_in, jtag_weakpdn, jtag_weakpu, odat0_aib_vinp00,
     odat0_aib_vinp01, odat1_aib_vinp00, odat1_aib_vinp01,
     por_aib_vcchssi, por_aib_vccl, rshift_en_tx, shift_en_inpdir1_1,
     shift_en_inpdir2_1, shift_en_srcclkoutn, tx_launch_clk_l6;

output [2:0]  irxen_vinp11;
output [1:0]  avmm2_odat0;
output [1:0]  avmm2_odat1;
output [2:0]  irxen_vinp10;

inout [1:0]  iopad_avmm2_in;

input [2:0]  irxen_r0;
input [2:0]  irxen_inpdir1_1;
input [1:0]  rshift_en_rx;
input [1:0]  indrv_r78;
input [1:0]  ipdrv_r78;
input [2:0]  irxen_inpdir2_1;

// Buses in the design

wire  [0:1]  ncrxp_oclk;

wire  [0:1]  ncrxp_oclkb;

wire  [0:1]  ncrxp_odat_async;

wire  [0:1]  ncrxp_pd_data;

wire  [0:1]  ncrxp_oclkn;

wire  [0:1]  ncrxp_oclk_aib;

wire  [0:1]  ncrxp_oclkb_aib;

wire  [0:1]  ncrxp_odat0_aib;

wire  [0:1]  ncrxp_odat1_aib;

wire  [0:1]  ncrxp_pd_data_aib;

wire jtag_clkdr_outn_vinp10;
wire nc_last_bs_out_vinp10;
wire jtag_clkdr_outn_vinp11;
wire nc_last_bs_out_vinp11;
wire jtag_clkdr_outn_voutp1;
wire nctx_pd_data_aib;
wire nctx_oclk;
wire nctx_oclkb;
wire nctx_odat0;
wire nctx_odat1;
wire nctx_odat_async;
wire nctx_pd_data;
wire nctx_odat_async_aib;
wire nctx_odat1_aib;
wire nctx_odat0_aib;
wire nctx_oclk_aib;
wire nc_last_bs_out_avmm2out;
wire nctx_oclkb_aib;
wire nctx_oclkn_aib;
wire nc_idat1_vinp10;
wire nc_idat0_vinp10;
wire nc_async_dat_vinp10;
wire nc_idat1_vinp11;
wire nc_idat0_vinp11;
wire nc_async_dat_vinp11;
wire nc_async_dat_voutp1;

// specify 
//     specparam CDS_LIBNAME  = "aibcr3_lib";
//     specparam CDS_CELLNAME = "aibcr3_avmm2";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

aibcr3_aliasd  r3 ( .rb(idataselb_voutp1), .ra(idataselb));
aibcr3_aliasd  r10[2:0] ( .ra(irxen_r0[2:0]), .rb(irxen_vinp10[2:0]));
aibcr3_aliasd  r2 ( .rb(itxen_voutp1), .ra(itxen));
aibcr3_aliasd  r12[2:0] ( .ra(irxen_r0[2:0]), .rb(irxen_vinp11[2:0]));
aibcr3_aliasd  r14 ( .rb(shift_en_vinp10), .ra(rshift_en_rx[0]));
aibcr3_aliasd  r16 ( .rb(shift_en_voutp1), .ra(rshift_en_tx));
aibcr3_aliasd  r15 ( .rb(shift_en_vinp11), .ra(rshift_en_rx[1]));
aibcr3_buffx1_top xvinp10 ( .idata1_in1_jtag_out(nc_idat1_vinp10),
     .idata0_in1_jtag_out(nc_idat0_vinp10),
     .async_dat_in1_jtag_out(nc_async_dat_vinp10),
     .prev_io_shift_en(shift_en_inpdir1_1),
     .jtag_clkdr_outn(jtag_clkdr_outn_vinp10),
     .jtag_clksel(jtag_clksel), .jtag_rstb_en(jtag_rstb_en),
     .jtag_intest(jtag_intest), .vcc(vcc), .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(avmm2_rstb),
     .pd_data_aib(ncrxp_pd_data_aib[0]), .oclk_out(ncrxp_oclk[0]),
     .oclkb_out(ncrxp_oclkb[0]), .odat0_out(avmm2_odat0[0]),
     .odat1_out(avmm2_odat1[0]), .odat_async_out(ncrxp_odat_async[0]),
     .pd_data_out(ncrxp_pd_data[0]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(avmm_rx_distclk_l1),
     .iclkin_dist_in1(vssl), .idata0_in0(vssl), .idata0_in1(vssl),
     .idata1_in0(vssl), .idata1_in1(vssl), .idataselb_in0(vcc),
     .idataselb_in1(vssl), .iddren_in0(vssl), .iddren_in1(vssl),
     .ilaunch_clk_in0(vssl), .ilaunch_clk_in1(vssl),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0({vssl, vssl}), .indrv_in1({vssl,
     vssl}), .ipdrv_in0({vssl, vssl}), .ipdrv_in1({vssl, vssl}),
     .irxen_in0(irxen_r0[2:0]), .irxen_in1(irxen_inpdir1_1[2:0]),
     .istrbclk_in0(avmm_rx_strbclk_l1), .istrbclk_in1(vssl),
     .itxen_in0(vssl), .itxen_in1(vssl), .oclk_in1(vssl),
     .odat_async_aib(odat_async_aib_vinp10), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(odat0_aib_vinp00), .vccl(vccl),
     .odat1_in1(odat1_aib_vinp00), .odat_async_in1(vssl),
     .shift_en(rshift_en_rx[0]), .pd_data_in1(vssl),
     .dig_rstb(avmm2_rstb), .jtag_clkdr_out(jtag_clkdr_vinp10),
     .odat1_aib(ncrxp_odat1_aib[0]),
     .jtag_rx_scan_out(jtag_rx_scan_vinp10),
     .odat0_aib(ncrxp_odat0_aib[0]), .oclk_aib(ncrxp_oclk_aib[0]),
     .last_bs_out(nc_last_bs_out_vinp10),
     .oclkb_aib(ncrxp_oclkb_aib[0]), .jtag_clkdr_in(clkdr_xr5l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_inpdir1_1),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_avmm2_in[0]), .oclkn(ncrxp_oclkn[0]), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xvinp11 ( .idata1_in1_jtag_out(nc_idat1_vinp11),
     .idata0_in1_jtag_out(nc_idat0_vinp11),
     .async_dat_in1_jtag_out(nc_async_dat_vinp11),
     .prev_io_shift_en(shift_en_inpdir2_1),
     .jtag_clkdr_outn(jtag_clkdr_outn_vinp11),
     .jtag_clksel(jtag_clksel), .jtag_rstb_en(jtag_rstb_en),
     .jtag_intest(jtag_intest), .vcc(vcc), .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(avmm2_rstb),
     .pd_data_aib(ncrxp_pd_data_aib[1]), .oclk_out(ncrxp_oclk[1]),
     .oclkb_out(ncrxp_oclkb[1]), .odat0_out(avmm2_odat0[1]),
     .odat1_out(avmm2_odat1[1]), .odat_async_out(ncrxp_odat_async[1]),
     .pd_data_out(ncrxp_pd_data[1]), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(avmm_rx_distclk_l0),
     .iclkin_dist_in1(vssl), .idata0_in0(vssl), .idata0_in1(vssl),
     .idata1_in0(vssl), .idata1_in1(vssl), .idataselb_in0(vcc),
     .idataselb_in1(vssl), .iddren_in0(vssl), .iddren_in1(vssl),
     .ilaunch_clk_in0(vssl), .ilaunch_clk_in1(vssl),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0({vssl, vssl}), .indrv_in1({vssl,
     vssl}), .ipdrv_in0({vssl, vssl}), .ipdrv_in1({vssl, vssl}),
     .irxen_in0(irxen_r0[2:0]), .irxen_in1(irxen_inpdir2_1[2:0]),
     .istrbclk_in0(avmm_rx_strbclk_l0), .istrbclk_in1(vssl),
     .itxen_in0(vssl), .itxen_in1(vssl), .oclk_in1(vssl),
     .odat_async_aib(odat_async_aib_vinp11), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(odat0_aib_vinp01), .vccl(vccl),
     .odat1_in1(odat1_aib_vinp01), .odat_async_in1(vssl),
     .shift_en(rshift_en_rx[1]), .pd_data_in1(vssl),
     .dig_rstb(avmm2_rstb), .jtag_clkdr_out(jtag_clkdr_vinp11),
     .odat1_aib(ncrxp_odat1_aib[1]),
     .jtag_rx_scan_out(jtag_rx_scan_vinp11),
     .odat0_aib(ncrxp_odat0_aib[1]), .oclk_aib(ncrxp_oclk_aib[1]),
     .last_bs_out(nc_last_bs_out_vinp11),
     .oclkb_aib(ncrxp_oclkb_aib[1]), .jtag_clkdr_in(clkdr_xr6l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_inpdir2_1),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_avmm2_in[1]), .oclkn(ncrxp_oclkn[1]), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xvoutp1 ( .idata1_in1_jtag_out(idata1_voutp1),
     .idata0_in1_jtag_out(idata0_voutp1),
     .async_dat_in1_jtag_out(nc_async_dat_voutp1),
     .prev_io_shift_en(shift_en_srcclkoutn),
     .jtag_clkdr_outn(jtag_clkdr_outn_voutp1),
     .jtag_clksel(jtag_clksel), .jtag_rstb_en(jtag_rstb_en),
     .jtag_intest(jtag_intest), .vcc(vcc), .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(avmm2_rstb),
     .pd_data_aib(nctx_pd_data_aib), .oclk_out(nctx_oclk),
     .oclkb_out(nctx_oclkb), .odat0_out(nctx_odat0),
     .odat1_out(nctx_odat1), .odat_async_out(nctx_odat_async),
     .pd_data_out(nctx_pd_data), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(jtag_clkdr_outn_voutp1),
     .iclkin_dist_in1(vssl), .idata0_in0(avmm2_idat0),
     .idata0_in1(idata0_srcclkoutn), .idata1_in0(avmm2_idat1),
     .idata1_in1(idata1_srcclkoutn), .idataselb_in0(idataselb),
     .idataselb_in1(idataselb_srcclkoutn), .iddren_in0(vssl),
     .iddren_in1(vcc), .ilaunch_clk_in0(tx_launch_clk_l6),
     .ilaunch_clk_in1(tx_launch_clk_l6), .ilpbk_dat_in0(vssl),
     .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl), .ilpbk_en_in1(vssl),
     .indrv_in0(indrv_r78[1:0]), .indrv_in1(indrv_r78[1:0]),
     .ipdrv_in0(ipdrv_r78[1:0]), .ipdrv_in1(ipdrv_r78[1:0]),
     .irxen_in0({vssl, vcc, vssl}), .irxen_in1({vssl, vcc, vssl}),
     .istrbclk_in0(jtag_clkdr_outn_voutp1), .istrbclk_in1(vssl),
     .itxen_in0(itxen), .itxen_in1(itxen_srcclkoutn), .oclk_in1(vssl),
     .odat_async_aib(nctx_odat_async_aib), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(vssl), .vccl(vccl), .odat1_in1(vssl),
     .odat_async_in1(vssl), .shift_en(rshift_en_tx),
     .pd_data_in1(vssl), .dig_rstb(avmm2_rstb),
     .jtag_clkdr_out(jtag_clkdr_voutp1), .odat1_aib(nctx_odat1_aib),
     .jtag_rx_scan_out(jtag_rx_scan_voutp1),
     .odat0_aib(nctx_odat0_aib), .oclk_aib(nctx_oclk_aib),
     .last_bs_out(nc_last_bs_out_avmm2out), .oclkb_aib(nctx_oclkb_aib),
     .jtag_clkdr_in(clkdr_xr8l), .jtag_mode_in(jtag_mode_in),
     .jtag_rstb(jtag_rstb), .jtag_tx_scan_in(jtag_rx_scan_srcclkoutn),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_avmm2_out), .oclkn(nctx_oclkn_aib), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));

endmodule

