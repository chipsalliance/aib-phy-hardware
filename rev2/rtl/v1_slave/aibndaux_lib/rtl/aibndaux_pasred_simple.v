// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
// Copyright (c) 2012 Altera Corporation. .
// Library - aibndaux_lib, Cell - aibndaux_pasred, View - schematic
// LAST TIME SAVED: Jul  8 18:04:04 2015
// NETLIST TIME: Jul  9 10:28:17 2015
// `timescale 1ns / 1ns 

module aibndaux_pasred_simple ( crete_detect, iopad_crdet,
     iopad_dn_por, dn_por, vccl_aibndaux, vssl_aibndaux );

output  crete_detect;

inout  iopad_crdet, iopad_dn_por;

input  dn_por, vccl_aibndaux, vssl_aibndaux;


aibnd_buffx1_top  xcrdet ( .idata1_in1_jtag_out(),
     .async_dat_in1_jtag_out(), .idata0_in1_jtag_out(),
     .prev_io_shift_en(vssl_aibndaux), .jtag_clkdr_outn(),
     .anlg_rstb(vccl_aibndaux), .pd_data_aib(),
     .oclk_out(), .oclkb_out(), .odat0_out(),
     .odat1_out(), .odat_async_out(crete_detect),
     .pd_data_out(), .async_dat_in0(vssl_aibndaux),
     .async_dat_in1(vssl_aibndaux), .iclkin_dist_in0(vssl_aibndaux),
     .iclkin_dist_in1(vssl_aibndaux), .idata0_in0(vssl_aibndaux),
     .idata0_in1(vssl_aibndaux), .idata1_in0(vssl_aibndaux),
     .idata1_in1(vssl_aibndaux), .idataselb_in0(vssl_aibndaux),
     .idataselb_in1(vssl_aibndaux), .iddren_in0(vssl_aibndaux),
     .iddren_in1(vssl_aibndaux), .ilaunch_clk_in0(vssl_aibndaux),
     .ilaunch_clk_in1(vssl_aibndaux), .ilpbk_dat_in0(vssl_aibndaux),
     .ilpbk_dat_in1(vssl_aibndaux), .ilpbk_en_in0(vssl_aibndaux),
     .ilpbk_en_in1(vssl_aibndaux), .indrv_in0({vssl_aibndaux,
     vssl_aibndaux}), .indrv_in1({vssl_aibndaux, vssl_aibndaux}),
     .ipdrv_in0({vssl_aibndaux, vssl_aibndaux}),
     .ipdrv_in1({vssl_aibndaux, vssl_aibndaux}),
     .irxen_in0({vssl_aibndaux,vssl_aibndaux,vssl_aibndaux}),
     .irxen_in1({vssl_aibndaux,vssl_aibndaux,vssl_aibndaux}), .istrbclk_in0(vssl_aibndaux),
     .istrbclk_in1(vssl_aibndaux), .itxen_in0(vssl_aibndaux),
     .itxen_in1(vssl_aibndaux), .oclk_in1(vssl_aibndaux),
     .odat_async_aib(), .oclkb_in1(vssl_aibndaux),
     .jtag_clksel(vssl_aibndaux), .odat0_in1(vssl_aibndaux),
     .vssl_aibnd(vssl_aibndaux), .odat1_in1(vssl_aibndaux),
     .odat_async_in1(vssl_aibndaux), .shift_en(vssl_aibndaux),
     .pd_data_in1(vssl_aibndaux), .dig_rstb(vccl_aibndaux),
     .jtag_clkdr_out(), .jtag_intest(vssl_aibndaux),
     .odat1_aib(), .jtag_rx_scan_out(), .odat0_aib(),
     .oclk_aib(), .last_bs_out(),
     .vccl_aibnd(vccl_aibndaux), .oclkb_aib(),
     .jtag_clkdr_in(vssl_aibndaux), .jtag_rstb_en(vssl_aibndaux),
     .jtag_mode_in(vssl_aibndaux), .jtag_rstb(vssl_aibndaux),
     .jtag_tx_scan_in(vssl_aibndaux),
     .jtag_tx_scanen_in(vssl_aibndaux), .last_bs_in(vssl_aibndaux),
     .iopad(iopad_crdet), .oclkn(), .iclkn(vssl_aibndaux),
     .test_weakpu(vssl_aibndaux), .test_weakpd(vccl_aibndaux));

aibnd_buffx1_top  xdn_por ( .idata1_in1_jtag_out(),
     .async_dat_in1_jtag_out(), .idata0_in1_jtag_out(),
     .prev_io_shift_en(vssl_aibndaux), .jtag_clkdr_outn(),
     .jtag_clksel(vssl_aibndaux), .vssl_aibnd(vssl_aibndaux),
     .jtag_intest(vssl_aibndaux), .vccl_aibnd(vccl_aibndaux),
     .jtag_rstb_en(vssl_aibndaux), .anlg_rstb(vccl_aibndaux),
     .pd_data_aib(), .oclk_out(), .oclkb_out(),
     .odat0_out(), .odat1_out(),
     .odat_async_out(), .pd_data_out(),
     .async_dat_in0(dn_por), .async_dat_in1(vssl_aibndaux),
     .iclkin_dist_in0(vssl_aibndaux), .iclkin_dist_in1(vssl_aibndaux),
     .idata0_in0(vssl_aibndaux), .idata0_in1(vssl_aibndaux),
     .idata1_in0(vssl_aibndaux), .idata1_in1(vssl_aibndaux),
     .idataselb_in0(vssl_aibndaux), .idataselb_in1(vssl_aibndaux),
     .iddren_in0(vssl_aibndaux), .iddren_in1(vssl_aibndaux),
     .ilaunch_clk_in0(vssl_aibndaux), .ilaunch_clk_in1(vssl_aibndaux),
     .ilpbk_dat_in0(vssl_aibndaux), .ilpbk_dat_in1(vssl_aibndaux),
     .ilpbk_en_in0(vssl_aibndaux), .ilpbk_en_in1(vssl_aibndaux),
     .indrv_in0({vccl_aibndaux, vssl_aibndaux}),
     .indrv_in1({vccl_aibndaux, vssl_aibndaux}),
     .ipdrv_in0({vccl_aibndaux, vssl_aibndaux}),
     .ipdrv_in1({vccl_aibndaux, vssl_aibndaux}), .irxen_in0({vssl_aibndaux,
     vccl_aibndaux, vssl_aibndaux}), .irxen_in1({vssl_aibndaux,
     vccl_aibndaux, vssl_aibndaux}), .istrbclk_in0(vssl_aibndaux),
     .istrbclk_in1(vssl_aibndaux), .itxen_in0(vccl_aibndaux),
     .itxen_in1(vccl_aibndaux), .oclk_in1(vssl_aibndaux),
     .odat_async_aib(), .oclkb_in1(vssl_aibndaux),
     .odat0_in1(vssl_aibndaux), .odat1_in1(vssl_aibndaux),
     .odat_async_in1(vssl_aibndaux), .shift_en(vssl_aibndaux),
     .pd_data_in1(vssl_aibndaux), .dig_rstb(vccl_aibndaux),
     .jtag_clkdr_out(), .odat1_aib(),
     .jtag_rx_scan_out(), .odat0_aib(),
     .oclk_aib(), .last_bs_out(), .oclkb_aib(),
     .jtag_clkdr_in(vssl_aibndaux), .jtag_mode_in(vssl_aibndaux),
     .jtag_rstb(vssl_aibndaux), .jtag_tx_scan_in(vssl_aibndaux),
     .jtag_tx_scanen_in(vssl_aibndaux), .last_bs_in(vssl_aibndaux),
     .iopad(iopad_dn_por), .oclkn(), .iclkn(vssl_aibndaux),
     .test_weakpu(vssl_aibndaux), .test_weakpd(vssl_aibndaux));

endmodule

