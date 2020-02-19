// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
// Copyright (c) 2012 Altera Corporation. .
// Library - aibndaux_lib, Cell - aibndaux_actred, View - schematic
// LAST TIME SAVED: Jul  8 17:24:01 2015
// NETLIST TIME: Jul  9 10:28:17 2015
// `timescale 1ns / 1ns 

module aibndaux_actred ( actred_chain1, actred_chain2,
     jtag_rx_scan_out_01x1, jtag_rx_scan_out_01x2, last_bs_out_01x1,
     last_bs_out_01x2, iopad_actred_chain1, iopad_actred_chain2,
     actred_rxen_chain1, actred_rxen_chain2, actred_shiften_chain1,
     actred_shiften_chain2, anlg_rstb, dig_rstb, jtag_clkdr_in1l,
     jtag_clkdr_in2l, jtag_clksel, jtag_intest, jtag_mode_in,
     jtag_rstb, jtag_rstb_en, jtag_tx_scan_in_01x1,
     jtag_tx_scan_in_01x2, jtag_tx_scanen_in, jtag_weakpdn,
     jtag_weakpu, last_bs_in_01x1, last_bs_in_01x2, vccl_aibndaux,
     vssl_aibndaux );

output  actred_chain1, actred_chain2, jtag_rx_scan_out_01x1,
     jtag_rx_scan_out_01x2, last_bs_out_01x1, last_bs_out_01x2;

inout  iopad_actred_chain1, iopad_actred_chain2;

input  actred_shiften_chain1, actred_shiften_chain2, anlg_rstb,
     dig_rstb, jtag_clkdr_in1l, jtag_clkdr_in2l, jtag_clksel,
     jtag_intest, jtag_mode_in, jtag_rstb, jtag_rstb_en,
     jtag_tx_scan_in_01x1, jtag_tx_scan_in_01x2, jtag_tx_scanen_in,
     jtag_weakpdn, jtag_weakpu, last_bs_in_01x1, last_bs_in_01x2,
     vccl_aibndaux, vssl_aibndaux;

input [2:0]  actred_rxen_chain1;
input [2:0]  actred_rxen_chain2;


// specify 
//     specparam CDS_LIBNAME  = "aibndaux_lib";
//     specparam CDS_CELLNAME = "aibndaux_actred";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

aibnd_buffx1_top  xio_in0 ( .idata1_in1_jtag_out(net036),
     .async_dat_in1_jtag_out(net035), .idata0_in1_jtag_out(net034),
     .prev_io_shift_en(actred_shiften_chain1),
     .jtag_clkdr_outn(net024), .jtag_clksel(jtag_clksel),
     .vssl_aibnd(vssl_aibndaux), .jtag_intest(jtag_intest),
     .vccl_aibnd(vccl_aibndaux), .jtag_rstb_en(jtag_rstb_en),
     .anlg_rstb(anlg_rstb), .pd_data_aib(net089), .oclk_out(net072),
     .oclkb_out(net073), .odat0_out(net074), .odat1_out(net075),
     .odat_async_out(net026), .pd_data_out(net076),
     .async_dat_in0(vssl_aibndaux), .async_dat_in1(vssl_aibndaux),
     .iclkin_dist_in0(vssl_aibndaux), .iclkin_dist_in1(vssl_aibndaux),
     .idata0_in0(vssl_aibndaux), .idata0_in1(vssl_aibndaux),
     .idata1_in0(vssl_aibndaux), .idata1_in1(vssl_aibndaux),
     .idataselb_in0(vssl_aibndaux), .idataselb_in1(vssl_aibndaux),
     .iddren_in0(vssl_aibndaux), .iddren_in1(vssl_aibndaux),
     .ilaunch_clk_in0(vssl_aibndaux), .ilaunch_clk_in1(vssl_aibndaux),
     .ilpbk_dat_in0(vssl_aibndaux), .ilpbk_dat_in1(vssl_aibndaux),
     .ilpbk_en_in0(vssl_aibndaux), .ilpbk_en_in1(vssl_aibndaux),
     .indrv_in0({vssl_aibndaux, vssl_aibndaux}),
     .indrv_in1({vssl_aibndaux, vssl_aibndaux}),
     .ipdrv_in0({vssl_aibndaux, vssl_aibndaux}),
     .ipdrv_in1({vssl_aibndaux, vssl_aibndaux}),
     .irxen_in0({vssl_aibndaux, vssl_aibndaux, vssl_aibndaux}),
     .irxen_in1(actred_rxen_chain1[2:0]), .istrbclk_in0(vssl_aibndaux),
     .istrbclk_in1(vssl_aibndaux), .itxen_in0(vssl_aibndaux),
     .itxen_in1(vssl_aibndaux), .oclk_in1(vssl_aibndaux),
     .odat_async_aib(actred_chain1), .oclkb_in1(vssl_aibndaux),
     .odat0_in1(vssl_aibndaux), .odat1_in1(vssl_aibndaux),
     .odat_async_in1(vssl_aibndaux), .shift_en(actred_shiften_chain1),
     .pd_data_in1(vssl_aibndaux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net023), .odat1_aib(net087),
     .jtag_rx_scan_out(jtag_rx_scan_out_01x2), .odat0_aib(net086),
     .oclk_aib(net084), .last_bs_out(last_bs_out_01x2),
     .oclkb_aib(net085), .jtag_clkdr_in(jtag_clkdr_in2l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_tx_scan_in_01x2),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_01x2), .iopad(iopad_actred_chain1),
     .oclkn(net083), .iclkn(vssl_aibndaux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibnd_buffx1_top  xio_in1 ( .idata1_in1_jtag_out(net031),
     .async_dat_in1_jtag_out(net032), .idata0_in1_jtag_out(net033),
     .prev_io_shift_en(actred_shiften_chain2),
     .jtag_clkdr_outn(net022), .jtag_clksel(jtag_clksel),
     .vssl_aibnd(vssl_aibndaux), .jtag_intest(jtag_intest),
     .vccl_aibnd(vccl_aibndaux), .jtag_rstb_en(jtag_rstb_en),
     .anlg_rstb(anlg_rstb), .pd_data_aib(net096), .oclk_out(net078),
     .oclkb_out(net079), .odat0_out(net080), .odat1_out(net081),
     .odat_async_out(net025), .pd_data_out(net082),
     .async_dat_in0(vssl_aibndaux), .async_dat_in1(vssl_aibndaux),
     .iclkin_dist_in0(vssl_aibndaux), .iclkin_dist_in1(vssl_aibndaux),
     .idata0_in0(vssl_aibndaux), .idata0_in1(vssl_aibndaux),
     .idata1_in0(vssl_aibndaux), .idata1_in1(vssl_aibndaux),
     .idataselb_in0(vssl_aibndaux), .idataselb_in1(vssl_aibndaux),
     .iddren_in0(vssl_aibndaux), .iddren_in1(vssl_aibndaux),
     .ilaunch_clk_in0(vssl_aibndaux), .ilaunch_clk_in1(vssl_aibndaux),
     .ilpbk_dat_in0(vssl_aibndaux), .ilpbk_dat_in1(vssl_aibndaux),
     .ilpbk_en_in0(vssl_aibndaux), .ilpbk_en_in1(vssl_aibndaux),
     .indrv_in0({vssl_aibndaux, vssl_aibndaux}),
     .indrv_in1({vssl_aibndaux, vssl_aibndaux}),
     .ipdrv_in0({vssl_aibndaux, vssl_aibndaux}),
     .ipdrv_in1({vssl_aibndaux, vssl_aibndaux}),
     .irxen_in0(actred_rxen_chain1[2:0]),
     .irxen_in1(actred_rxen_chain2[2:0]), .istrbclk_in0(vssl_aibndaux),
     .istrbclk_in1(vssl_aibndaux), .itxen_in0(vssl_aibndaux),
     .itxen_in1(vssl_aibndaux), .oclk_in1(vssl_aibndaux),
     .odat_async_aib(actred_chain2), .oclkb_in1(vssl_aibndaux),
     .odat0_in1(vssl_aibndaux), .odat1_in1(vssl_aibndaux),
     .odat_async_in1(vssl_aibndaux), .shift_en(actred_shiften_chain2),
     .pd_data_in1(vssl_aibndaux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net021), .odat1_aib(net094),
     .jtag_rx_scan_out(jtag_rx_scan_out_01x1), .odat0_aib(net093),
     .oclk_aib(net091), .last_bs_out(last_bs_out_01x1),
     .oclkb_aib(net092), .jtag_clkdr_in(jtag_clkdr_in1l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_tx_scan_in_01x1),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_01x1), .iopad(iopad_actred_chain2),
     .oclkn(net090), .iclkn(vssl_aibndaux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));

endmodule

