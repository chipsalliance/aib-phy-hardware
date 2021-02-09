// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// ==========================================================================
//
// Module name    : aib
// Description    : Behavioral model of AIB IO buffer top level wrapper
// Revision       : 1.0
// ============================================================================
module aib_buffx1_top ( async_dat_in1_jtag_out, idata0_in1_jtag_out,
     idata1_in1_jtag_out, jtag_clkdr_outn,
     jtag_rx_scan_out, oclk_aib, oclk_out, oclkb_aib,
     oclkb_out, oclkn, odat0_aib, odat0_out, odat1_aib, odat1_out,
     odat_async_aib, odat_async_out, iopad,
     async_dat_in0, async_dat_in1,
     dig_rstb, iclkin_dist_in0, iclkin_dist_in1, iclkn, idata0_in0,
     idata0_in1, idata1_in0, idata1_in1, idataselb_in0, idataselb_in1,
     iddren_in0, iddren_in1, ilaunch_clk_in0, ilaunch_clk_in1,
     irxen_in0, irxen_in1,
     istrbclk_in0, istrbclk_in1, itxen_in0, itxen_in1, jtag_clkdr_in,
     jtag_intest, jtag_mode_in, jtag_rstb, jtag_rstb_en,
     jtag_tx_scan_in, jtag_tx_scanen_in, oclk_in1,
     oclkb_in1, odat0_in1, odat1_in1, odat_async_in1, 
     shift_en,
     test_weakpd, test_weakpu );

output  async_dat_in1_jtag_out, idata0_in1_jtag_out,
     idata1_in1_jtag_out, jtag_clkdr_outn,
     jtag_rx_scan_out, oclk_aib, oclk_out, oclkb_aib,
     oclkb_out, oclkn, odat0_aib, odat0_out, odat1_aib, odat1_out,
     odat_async_aib, odat_async_out;

input  async_dat_in0, async_dat_in1, dig_rstb,
     iclkin_dist_in0, iclkin_dist_in1, iclkn, idata0_in0, idata0_in1,
     idata1_in0, idata1_in1, idataselb_in0, idataselb_in1, iddren_in0,
     iddren_in1, ilaunch_clk_in0, ilaunch_clk_in1, 
     istrbclk_in0,
     istrbclk_in1, itxen_in0, itxen_in1, jtag_clkdr_in, 
     jtag_intest, jtag_mode_in, jtag_rstb, jtag_rstb_en,
     jtag_tx_scan_in, jtag_tx_scanen_in, oclk_in1,
     oclkb_in1, odat0_in1, odat1_in1, odat_async_in1, 
     shift_en,
     test_weakpd, test_weakpu;

inout iopad;

input [2:0]  irxen_in1;
input [2:0]  irxen_in0;

wire odat1_out, odat1_out_pnr, odat_async_out, odat_async_out_pnr, odat0_out, odat0_out_pnr;
// Buses in the design


wire  [2:0]  irxen_aib;


wire idat1_aib;
wire idat0_aib;
wire itxen_aib;
wire async_data_aib;
wire dig_rstb_aib;
wire idataselb_aib;
wire iddren_aib;
wire iclkin_dist_aib;
wire istrbclk_aib;

wire weak_drvr_en, weak_drvr_dir; 

assign weak_drvr_en = test_weakpd | test_weakpu;
assign weak_drvr_dir = test_weakpu ? 1'b1 : 1'b0;

aib_bsr_red_wrap  aib_bsr_red_wrap ( .async_dat_red(async_dat_in1_jtag_out),
     .idata0_red(idata0_in1_jtag_out),
     .idata1_red(idata1_in1_jtag_out),
     .jtag_clkdr_outn(jtag_clkdr_outn), .idata1_out(idat1_aib),
     .idata0_out(idat0_aib), .oclk_in(oclk_out), .oclkb_in(oclkb_out),
     .itxen_out(itxen_aib), .async_data_out(async_data_aib),
     .irxen_out(irxen_aib[2:0]), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .dig_rstb_aib(dig_rstb_aib),
     .dig_rstb_adap(dig_rstb),
     .odat_async_in0(odat_async_aib),
     .odat1_in0(odat1_aib), .odat0_in0(odat0_aib), .shift_en(shift_en),
     .idataselb_out(idataselb_aib),
     .iddren_out(iddren_aib), .odat0_out(odat0_out_pnr),
     .odat1_out(odat1_out_pnr), .odat_async_out(odat_async_out_pnr),
     .async_dat_in0(async_dat_in0), .async_dat_in1(async_dat_in1),
     .idata0_in0(idata0_in0), .idata0_in1(idata0_in1),
     .idata1_in0(idata1_in0), .idata1_in1(idata1_in1),
     .idataselb_in0(idataselb_in0), .idataselb_in1(idataselb_in1),
     .iddren_in0(iddren_in0), .iddren_in1(iddren_in1),
     .irxen_in0(irxen_in0[2:0]), .irxen_in1(irxen_in1[2:0]),
     .itxen_in0(itxen_in0), .itxen_in1(itxen_in1),
     .odat0_in1(odat0_in1), .odat1_in1(odat1_in1),
     .odat_async_in1(odat_async_in1), .jtag_clkdr_out(),
     .jtag_rx_scan_out(jtag_rx_scan_out),
     .jtag_clkdr_in(jtag_clkdr_in), .jtag_mode_in(jtag_mode_in),
     .jtag_rstb(jtag_rstb), .jtag_tx_scan_in(jtag_tx_scan_in),
     .jtag_tx_scanen_in(jtag_tx_scanen_in));

	   aib_io_buffer aib_io_buffer 
	     (
	      // Tx Path
	      .ilaunch_clk (ilaunch_clk_in0),
	      .irstb       (dig_rstb_aib),
	      .idat0       (idat0_aib),
	      .idat1       (idat1_aib),
	      .async_data  (async_data_aib),
	      .oclkn       (oclkn),

	      // Rx Path
	      .iclkn       (iclkn),
	      .inclk       (istrbclk_in0), 
	      .inclk_dist  (iclkin_dist_in0),
	      .oclk        (oclk_aib),
	      .oclk_b      (oclkb_aib),
	      .odat0       (odat0_aib),
	      .odat1       (odat1_aib),
	      .odat_async  (odat_async_aib),

	      // Bidirectional Data 
	      .io_pad      (iopad),

	      // I/O configuration
	      .async       (idataselb_aib), 
	      .ddren       (iddren_aib),
	      .txen        (itxen_aib),
	      .rxen        (irxen_aib[0]),
	      .weaken      (weak_drvr_en),
	      .weakdir     (weak_drvr_dir)
	      );

assign odat1_out = odat1_out_pnr;
assign odat_async_out = odat_async_out_pnr;
assign odat0_out = odat0_out_pnr;

endmodule

