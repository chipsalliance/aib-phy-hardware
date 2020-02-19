// SPDX-License-Identifier: Apache-2.0
// Copyright (c) 2019 Blue Cheetah Analog Design, Inc.
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3_lib, Cell - aibcr3_buffx1_top, View - schematic
// LAST TIME SAVED: Jul  8 16:11:15 2015
// NETLIST TIME: Jul  9 10:52:16 2015
// `timescale 1ns / 1ns

// Ayar modifications:
//  1. Removed vcc, vccl, vssl pins, replaced them with 1'b0 and 1'b1 as appropriate.
//  2. Changed iclkn from input port to an inout port, changed por_aib_vccl to inout port
//  3. Added dedicated buffer for VCCL
//  4. Added VCCL decap custom cell
// BCA modifications:
//  1. Moved VCCL buffer into custom analog cells.

module aibcr3_buffx1_top ( async_dat_in1_jtag_out, idata0_in1_jtag_out,
     idata1_in1_jtag_out, jtag_clkdr_out, jtag_clkdr_outn,
     jtag_rx_scan_out, last_bs_out, oclk_aib, oclk_out, oclkb_aib,
     oclkb_out, oclkn, odat0_aib, odat0_out, odat1_aib, odat1_out,
     odat_async_aib, odat_async_out, pd_data_aib, pd_data_out, iopad,
     anlg_rstb, async_dat_in0, async_dat_in1,
     dig_rstb, iclkin_dist_in0, iclkin_dist_in1, iclkn, idata0_in0,
     idata0_in1, idata1_in0, idata1_in1, idataselb_in0, idataselb_in1,
     iddren_in0, iddren_in1, ilaunch_clk_in0, ilaunch_clk_in1,
     ilpbk_dat_in0, ilpbk_dat_in1, ilpbk_en_in0, ilpbk_en_in1,
     indrv_in0, indrv_in1, ipdrv_in0, ipdrv_in1, irxen_in0, irxen_in1,
     istrbclk_in0, istrbclk_in1, itxen_in0, itxen_in1, jtag_clkdr_in,
     jtag_clksel, jtag_intest, jtag_mode_in, jtag_rstb, jtag_rstb_en,
     jtag_tx_scan_in, jtag_tx_scanen_in, last_bs_in, oclk_in1,
     oclkb_in1, odat0_in1, odat1_in1, odat_async_in1, pd_data_in1,
     por_aib_vcchssi, por_aib_vccl, prev_io_shift_en, shift_en,
     test_weakpd, test_weakpu );

output  async_dat_in1_jtag_out, idata0_in1_jtag_out,
     idata1_in1_jtag_out, jtag_clkdr_out, jtag_clkdr_outn,
     jtag_rx_scan_out, last_bs_out, oclk_aib, oclk_out, oclkb_aib,
     oclkb_out, oclkn, odat0_aib, odat0_out, odat1_aib, odat1_out,
     odat_async_aib, odat_async_out, pd_data_aib, pd_data_out;

inout  iopad, iclkn, por_aib_vccl;

input  anlg_rstb, async_dat_in0, async_dat_in1, dig_rstb,
     iclkin_dist_in0, iclkin_dist_in1, /*iclkn,*/ idata0_in0, idata0_in1,
     idata1_in0, idata1_in1, idataselb_in0, idataselb_in1, iddren_in0,
     iddren_in1, ilaunch_clk_in0, ilaunch_clk_in1, ilpbk_dat_in0,
     ilpbk_dat_in1, ilpbk_en_in0, ilpbk_en_in1, istrbclk_in0,
     istrbclk_in1, itxen_in0, itxen_in1, jtag_clkdr_in, jtag_clksel,
     jtag_intest, jtag_mode_in, jtag_rstb, jtag_rstb_en,
     jtag_tx_scan_in, jtag_tx_scanen_in, last_bs_in, oclk_in1,
     oclkb_in1, odat0_in1, odat1_in1, odat_async_in1, pd_data_in1,
     por_aib_vcchssi, /*por_aib_vccl,*/ prev_io_shift_en, shift_en,
     test_weakpd, test_weakpu;

input [2:0]  irxen_in1;
input [1:0]  indrv_in0;
input [2:0]  irxen_in0;
input [1:0]  indrv_in1;
input [1:0]  ipdrv_in0;
input [1:0]  ipdrv_in1;

wire odat1_out, odat1_out_pnr, odat_async_out, odat_async_out_pnr, odat0_out, odat0_out_pnr;
// Buses in the design

wire  [1:0]  indrv_aib;

wire  [2:0]  irxen_aib;

wire  [1:0]  ipdrv_aib;

wire idat1_aib;
wire idat0_aib;
wire itxen_aib;
wire async_data_aib;
wire dig_rstb_aib;
wire anlg_rstb_aib;
wire idataselb_aib;
wire iddren_aib;
wire anlg_rstb_cus;
wire iclkin_dist_aib;
wire ilaunch_clk_aib;
wire istrbclk_aib;

wire por_aib_vccl_buf;

// VCCL domain buffer is inside analog custom cell. No need to specify it here.
assign por_aib_vccl_buf = por_aib_vccl;

// specify
//     specparam CDS_LIBNAME  = "aibcr3_lib";
//     specparam CDS_CELLNAME = "aibcr3_buffx1_top";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

aibcr3pnr_bsr_red_wrap  x1 ( .async_dat_red(async_dat_in1_jtag_out),
     .idata0_red(idata0_in1_jtag_out),
     .idata1_red(idata1_in1_jtag_out),
     .jtag_clkdr_outn(jtag_clkdr_outn), .idata1_out(idat1_aib),
     .idata0_out(idat0_aib), .oclk_in(oclk_out), .oclkb_in(oclkb_out),
     .itxen_out(itxen_aib), .async_data_out(async_data_aib),
     .irxen_out(irxen_aib[2:0]), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .dig_rstb_aib(dig_rstb_aib),
     .anlg_rstb_aib(anlg_rstb_aib), .dig_rstb_adap(dig_rstb),
     .anlg_rstb_adap(anlg_rstb), .odat_async_in0(odat_async_aib),
     .odat1_in0(odat1_aib), .odat0_in0(odat0_aib), .shift_en(shift_en),
     .indrv_out(indrv_aib[1:0]),
     .ipdrv_out(ipdrv_aib[1:0]), .idataselb_out(idataselb_aib),
     .iddren_out(iddren_aib), .odat0_out(odat0_out_pnr),
     .odat1_out(odat1_out_pnr), .odat_async_out(odat_async_out_pnr),
     .async_dat_in0(async_dat_in0), .async_dat_in1(async_dat_in1),
     .idata0_in0(idata0_in0), .idata0_in1(idata0_in1),
     .idata1_in0(idata1_in0), .idata1_in1(idata1_in1),
     .idataselb_in0(idataselb_in0), .idataselb_in1(idataselb_in1),
     .iddren_in0(iddren_in0), .iddren_in1(iddren_in1),
     .indrv_in0(indrv_in0[1:0]), .indrv_in1(indrv_in1[1:0]),
     .ipdrv_in0(ipdrv_in0[1:0]), .ipdrv_in1(ipdrv_in1[1:0]),
     .irxen_in0(irxen_in0[2:0]), .irxen_in1(irxen_in1[2:0]),
     .itxen_in0(itxen_in0), .itxen_in1(itxen_in1),
     .odat0_in1(odat0_in1), .odat1_in1(odat1_in1),
     .odat_async_in1(odat_async_in1), .jtag_clkdr_out(jtag_clkdr_out),
     .jtag_rx_scan_out(jtag_rx_scan_out),
     .jtag_clkdr_in(jtag_clkdr_in), .jtag_mode_in(jtag_mode_in),
     .jtag_rstb(jtag_rstb), .jtag_tx_scan_in(jtag_tx_scan_in),
     .jtag_tx_scanen_in(jtag_tx_scanen_in));
aibcr3_buffx1  x3 ( .ipadrstb(anlg_rstb_cus),
     .por_aib_vcchssi(por_aib_vcchssi), .por_aib_vcc1(por_aib_vccl_buf),
     .irxen(irxen_aib[2:0]), .pd_data(pd_data_aib),
     .oclk(oclk_aib), .iclkin_dist(iclkin_dist_in0),
     .iopad(iopad), .oclkb(oclkb_aib), .oclkn(oclkn),
     .odat0(odat0_aib), .odat1(odat1_aib), .test_weakpd(test_weakpd),
     .async_dat(async_data_aib), .iddren(iddren_aib), .iclkn(iclkn),
     .idat0(idat0_aib), .idat1(idat1_aib), .idataselb(idataselb_aib),
     .test_weakpu(test_weakpu), .testmode_en(1'b0),
     .ilaunch_clk(ilaunch_clk_aib), .ilpbk_dat(ilpbk_dat_in0),
     .ilpbk_en(ilpbk_en_in0), .indrv(indrv_aib[1:0]),
     .ipdrv(ipdrv_aib[1:0]), .irstb(dig_rstb_aib), .clkdr(1'b0),
     .odat_async(odat_async_aib), .istrbclk(istrbclk_in0),
     .itxen(itxen_aib));
aibcr3_red_custom_dig2 x29 ( .clkdr_in(jtag_clkdr_out),
     .iclkin_dist_aib(iclkin_dist_aib),
     .ilaunch_clk_aib(ilaunch_clk_aib), .istrbclk_aib(istrbclk_aib),
     .oclk_out(oclk_out), .oclkb_out(oclkb_out),
     .jtag_clksel(jtag_clksel), .iclkin_dist_in0(1'b0),
     .iclkin_dist_in1(1'b0), .ilaunch_clk_in0(ilaunch_clk_in0),
     .ilaunch_clk_in1(ilaunch_clk_in1), .istrbclk_in0(1'b0),
     .istrbclk_in1(1'b0), .oclk_aib(oclk_aib), .oclk_in1(oclk_in1),
     .oclkb_aib(oclkb_aib), .oclkb_in1(oclkb_in1),
     .shift_en(shift_en));
assign odat1_out = odat1_out_pnr;
assign odat_async_out = odat_async_out_pnr;
assign odat0_out = odat0_out_pnr;

aibcr3_red_custom_dig x22 (
     .anlg_rstb_out(anlg_rstb_cus), .anlg_rstb(anlg_rstb_aib),
     .prev_io_shift_en(prev_io_shift_en), .shift_en(shift_en));

endmodule


