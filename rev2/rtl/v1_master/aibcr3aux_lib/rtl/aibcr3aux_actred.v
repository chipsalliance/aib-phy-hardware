// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3aux_lib, Cell - aibcr3aux_actred, View - schematic
// LAST TIME SAVED: Aug 21 17:06:33 2015
// NETLIST TIME: Aug 26 15:05:13 2015
// `timescale 1ns / 1ns 

module aibcr3aux_actred ( jtag_rx_scan_out_01x1, jtag_rx_scan_out_01x2,
     last_bs_out_01x1, last_bs_out_01x2, iopad_actred_chain1,
     iopad_actred_chain2, actred_chain1, actred_chain2,
     actred_shiften_chain1, actred_shiften_chain2, anlg_rstb,
     csr_actred_dataselb, csr_actred_ndrv, csr_actred_pdrv,
     csr_actred_txen, dig_rstb, jtag_clkdr5l, jtag_clkdr6l,
     jtag_clksel, jtag_intest, jtag_mode_in, jtag_rstb, jtag_rstb_en,
     jtag_tx_scan_in_01x1, jtag_tx_scan_in_01x2, jtag_tx_scanen_in,
     jtag_weakpdn, jtag_weakpu, last_bs_in_01x1, last_bs_in_01x2,
     por_vcchssi, por_vccl, vcc_aibcr3aux, vccl_aibcr3aux, vssl_aibcr3aux
     );

output  jtag_rx_scan_out_01x1, jtag_rx_scan_out_01x2, last_bs_out_01x1,
     last_bs_out_01x2;

inout  iopad_actred_chain1, iopad_actred_chain2;

input  actred_chain1, actred_chain2, actred_shiften_chain1,
     actred_shiften_chain2, anlg_rstb, csr_actred_dataselb,
     csr_actred_txen, dig_rstb, jtag_clkdr5l, jtag_clkdr6l,
     jtag_clksel, jtag_intest, jtag_mode_in, jtag_rstb, jtag_rstb_en,
     jtag_tx_scan_in_01x1, jtag_tx_scan_in_01x2, jtag_tx_scanen_in,
     jtag_weakpdn, jtag_weakpu, last_bs_in_01x1, last_bs_in_01x2,
     por_vcchssi, por_vccl, vcc_aibcr3aux, vccl_aibcr3aux, vssl_aibcr3aux;

input [1:0]  csr_actred_ndrv;
input [1:0]  csr_actred_pdrv;

wire net026;
wire net089;
wire net072;
wire net073;
wire net074;
wire net075;
wire net053;
wire net076;
wire net088;
wire net025;
wire net087;
wire net086;
wire net084;
wire net085;
wire net083;
wire net024;
wire net096;
wire net078;
wire net079;
wire net080;
wire net081;
wire net097;
wire net082;
wire net095;
wire net023;
wire net094;
wire net093;
wire net091;
wire net092;
wire net090;
wire net031;
wire net032;
wire net033;
wire net030;
wire net029;
wire net028;

// specify 
//     specparam CDS_LIBNAME  = "aibcr3aux_lib";
//     specparam CDS_CELLNAME = "aibcr3aux_actred";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

aibcr3_buffx1_top  xio_in0 ( .idata1_in1_jtag_out(net031),
     .idata0_in1_jtag_out(net032), .async_dat_in1_jtag_out(net033),
     .prev_io_shift_en(actred_shiften_chain1),
     .jtag_clkdr_outn(net026), .vssl(vssl_aibcr3aux),
     .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux), .por_aib_vccl(por_vccl),
     .por_aib_vcchssi(por_vcchssi), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .jtag_rstb_en(jtag_rstb_en),
     .anlg_rstb(anlg_rstb), .pd_data_aib(net089), .oclk_out(net072),
     .oclkb_out(net073), .odat0_out(net074), .odat1_out(net075),
     .odat_async_out(net053), .pd_data_out(net076),
     //.async_dat_in0(vssl_aibcr3aux), .async_dat_in1(actred_chain2),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(actred_chain1),
     .iclkin_dist_in0(vssl_aibcr3aux), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(vssl_aibcr3aux), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(vssl_aibcr3aux), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(vssl_aibcr3aux),
     .idataselb_in1(csr_actred_dataselb), .iddren_in0(vssl_aibcr3aux),
     .iddren_in1(vssl_aibcr3aux), .ilaunch_clk_in0(vssl_aibcr3aux),
     .ilaunch_clk_in1(vssl_aibcr3aux), .ilpbk_dat_in0(vssl_aibcr3aux),
     .ilpbk_dat_in1(vssl_aibcr3aux), .ilpbk_en_in0(vssl_aibcr3aux),
     .ilpbk_en_in1(vssl_aibcr3aux), .indrv_in0({vssl_aibcr3aux,
     vssl_aibcr3aux}), .indrv_in1(csr_actred_ndrv[1:0]),
     .ipdrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in1(csr_actred_pdrv[1:0]), .irxen_in0({vssl_aibcr3aux,
     vcc_aibcr3aux, vssl_aibcr3aux}), .irxen_in1({vssl_aibcr3aux,
     vcc_aibcr3aux, vssl_aibcr3aux}), .istrbclk_in0(vssl_aibcr3aux),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(vssl_aibcr3aux),
     .itxen_in1(csr_actred_txen), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net088), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(actred_shiften_chain1),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net025), .odat1_aib(net087),
     .jtag_rx_scan_out(jtag_rx_scan_out_01x2), .odat0_aib(net086),
     .oclk_aib(net084), .last_bs_out(last_bs_out_01x2),
     .oclkb_aib(net085), .jtag_clkdr_in(jtag_clkdr5l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_tx_scan_in_01x2),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_01x2), .iopad(iopad_actred_chain2),
     .oclkn(net083), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xio_in1 ( .idata1_in1_jtag_out(net030),
     .idata0_in1_jtag_out(net029), .async_dat_in1_jtag_out(net028),
     .prev_io_shift_en(actred_shiften_chain2),
     .jtag_clkdr_outn(net024), .vssl(vssl_aibcr3aux),
     .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux), .por_aib_vccl(por_vccl),
     .por_aib_vcchssi(por_vcchssi), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .jtag_rstb_en(jtag_rstb_en),
     .anlg_rstb(anlg_rstb), .pd_data_aib(net096), .oclk_out(net078),
     .oclkb_out(net079), .odat0_out(net080), .odat1_out(net081),
     .odat_async_out(net097), .pd_data_out(net082),
     //.async_dat_in0(vssl_aibcr3aux), .async_dat_in1(actred_chain1),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(actred_chain2),
     .iclkin_dist_in0(vssl_aibcr3aux), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(vssl_aibcr3aux), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(vssl_aibcr3aux), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(vssl_aibcr3aux),
     .idataselb_in1(csr_actred_dataselb), .iddren_in0(vssl_aibcr3aux),
     .iddren_in1(vssl_aibcr3aux), .ilaunch_clk_in0(vssl_aibcr3aux),
     .ilaunch_clk_in1(vssl_aibcr3aux), .ilpbk_dat_in0(vssl_aibcr3aux),
     .ilpbk_dat_in1(vssl_aibcr3aux), .ilpbk_en_in0(vssl_aibcr3aux),
     .ilpbk_en_in1(vssl_aibcr3aux), .indrv_in0({vssl_aibcr3aux,
     vssl_aibcr3aux}), .indrv_in1(csr_actred_ndrv[1:0]),
     .ipdrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in1(csr_actred_pdrv[1:0]), .irxen_in0({vssl_aibcr3aux,
     vcc_aibcr3aux, vssl_aibcr3aux}), .irxen_in1({vssl_aibcr3aux,
     vcc_aibcr3aux, vssl_aibcr3aux}), .istrbclk_in0(vssl_aibcr3aux),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(vssl_aibcr3aux),
     .itxen_in1(csr_actred_txen), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net095), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(actred_shiften_chain2),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net023), .odat1_aib(net094),
     .jtag_rx_scan_out(jtag_rx_scan_out_01x1), .odat0_aib(net093),
     .oclk_aib(net091), .last_bs_out(last_bs_out_01x1),
     .oclkb_aib(net092), .jtag_clkdr_in(jtag_clkdr6l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_tx_scan_in_01x1),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_01x1), .iopad(iopad_actred_chain1),
     .oclkn(net090), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));

endmodule
