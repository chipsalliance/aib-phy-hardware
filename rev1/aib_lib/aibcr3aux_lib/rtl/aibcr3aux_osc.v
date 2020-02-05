// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcraux_lib, Cell - aibcraux_osc, View - schematic
// LAST TIME SAVED: Mar 20 08:51:28 2015
// NETLIST TIME: Jun  3 17:00:06 2015
// `timescale 1ns / 1ns 

module aibcr3aux_osc ( ib50u1, ib50u2, ib50u3, ib50u4, oaib_dft2osc,
     oosc_atb0, oosc_atb1, oosc_clkout, oosc_monitor, oosc_reserved,
     scan_out, vcca_aibcraux, vcc_aibcraux, vss_aibcraux, iaib_dft2osc, iosc_atbmuxsel,
     iosc_bypclk, iosc_bypclken, iosc_cr_dftcounter, iosc_cr_ld_cntr,
     iosc_cr_pdb, iosc_cr_rdy_dly, iosc_cr_trim, iosc_cr_vccdreg_vsel,
     iosc_cr_vreg_rdy, iosc_fuse_trim, iosc_ic50u, iosc_it50u,
     iosc_monitoren, iosc_reserved, pipeline_global_en, scan_clk,
     scan_in, scan_mode_n, scan_rst_n, scan_shift_n, osc_extrref );

output  ib50u1, ib50u2, ib50u3, ib50u4, oosc_atb0, oosc_atb1,
     oosc_clkout, oosc_monitor, scan_out;

input  vcca_aibcraux, vcc_aibcraux, vss_aibcraux, iosc_bypclk, iosc_bypclken, iosc_cr_pdb,
     iosc_cr_rdy_dly, iosc_ic50u, iosc_it50u, iosc_monitoren,
     pipeline_global_en, scan_clk, scan_in, scan_mode_n, scan_rst_n,
     scan_shift_n;

inout osc_extrref;

output [12:0]  oaib_dft2osc;
output [3:0]  oosc_reserved;

input [2:0]  iosc_cr_vreg_rdy;
input [4:0]  iosc_cr_vccdreg_vsel;
input [3:0]  iosc_atbmuxsel;
input [2:0]  iaib_dft2osc;
input [2:0]  iosc_cr_dftcounter;
input [8:0]  iosc_cr_trim;
input [2:0]  iosc_cr_ld_cntr;
input [7:0]  iosc_reserved;
input [9:0]  iosc_fuse_trim;

wire chicken_bit;
wire comparator_out;
wire osc_2x;

			/////////////////////////////////
			// for VCS and ICC compatibility
			/////////////////////////////////

aibcr3aux_osc_ana  ana ( // .ib50u({ib50u3,ib50u1}), .ib100u({ib50u4,ib50u2}),
     .ib50u_1(ib50u1), .ib50u_2(ib50u3), .ib100u_1(ib50u2), .ib100u_2(ib50u4), .chicken_bit(chicken_bit),
     .comp_out(comparator_out), .osc_atb1(oosc_atb1),
     .osc_atb0(oosc_atb0), .vcca_aibcr3aux(vcca_aibcraux), .vcc_aibcr3aux(vcc_aibcraux),
     .vss_aibcr3aux(vss_aibcraux), .iosc_atbmuxsel(iosc_atbmuxsel[3:0]),
     .osc_out(osc_2x), .iosc_cr_pdb(iosc_cr_pdb),
     .iosc_cr_trim(iosc_cr_trim[8:0]),
     .iosc_cr_vccdreg_vsel(iosc_cr_vccdreg_vsel[4:0]),
     .iosc_cr_vreg_rdy(iosc_cr_vreg_rdy[2:0]),
     .iosc_fuse_trim(iosc_fuse_trim[9:0]), .iosc_ic50u(iosc_ic50u),
     .iosc_it50u(iosc_it50u), .osc_extrref(osc_extrref));
aibcr3aux_osc_dig dig ( .scan_shift_n(scan_shift_n),
     .pipeline_global_en(pipeline_global_en), .scan_out(scan_out),
     .scan_clk(scan_clk), .scan_in(scan_in), .scan_mode_n(scan_mode_n),
     .scan_rst_n(scan_rst_n), .chicken_bit(chicken_bit),
     .vss_aibcr3aux(vss_aibcraux), .vcc_aibcr3aux(vcc_aibcraux),
     .comp_in(comparator_out), .iosc_cr_ld_cntr(iosc_cr_ld_cntr[2:0]),
     .oosc_monitor(oosc_monitor), .oaib_dft2osc(oaib_dft2osc[12:0]),
     .oosc_clkout(oosc_clkout), .iaib_dft2osc(iaib_dft2osc[2:0]),
     .iosc_bypclk(iosc_bypclk), .iosc_bypclken(iosc_bypclken),
     .iosc_cr_dftcounter(iosc_cr_dftcounter[2:0]),
     .iosc_monitoren(iosc_monitoren), .irstb(iosc_cr_rdy_dly),
     .oscin_2x(osc_2x));

endmodule

