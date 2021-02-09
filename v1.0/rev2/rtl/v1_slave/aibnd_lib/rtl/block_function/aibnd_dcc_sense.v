// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_dcc_sense, View - schematic
// LAST TIME SAVED: Nov 27 11:09:50 2014
// NETLIST TIME: Dec  8 13:43:49 2014

module aibnd_dcc_sense ( up, vcc_io, vcc_regphy, vss_io, clk_dcc,
     dll_reset_n, nfrzdrv, pvt_ref_half_gry );

output  up;

inout  vcc_io, vcc_regphy, vss_io;

input  clk_dcc, dll_reset_n, nfrzdrv;

input [9:0]  pvt_ref_half_gry;

wire up, net018, net022, net025; // Conversion Sript Generated



io_split_align  xsplit_align_0 ( 
     //.vcc_io(vcc_regphy), .vss_io(vss_io),
     .dout_n(clk_dcd_split_n), .dout_p(clk_dcd_split_p),
     .din(clk_dcc));
assign up = !net018;
assign net022 = !net025;
io_nand_delay_line_min  xdelay_line_match ( .nfrzdrv(nfrzdrv),
     //.vcc_regphy(vcc_regphy), .vcc_io(vcc_io), .vss_io(vss_io),
     .out_n(clkn_mindly), .out_p(clkp_mindly), .in_n(clk_dcd_split_n),
     .in_p(clk_dcd_split_p));
an_io_phdet_ff  xsampling ( /*`ifndef INTCNOPWR .vcc(vcc_io), .vss(vss_io), `endif*/ 
     .q(net018),
     .clk_p(clkp_dly), .dn(clkn_mindly), .dp(clkp_mindly),
     .rst_n(dll_reset_n));
an_io_phdet_ff  xload_match ( /*`ifndef INTCNOPWR .vcc(vcc_io), .vss(vss_io), `endif*/ 
    .q(net025),
     .clk_p(clkp_mindly), .dn(clkn_dly), .dp(clkp_dly),
     .rst_n(dll_reset_n));
io_nand_x128_delay_line  xdelay_line ( 
     //.vcc_io(vcc_io),
     //.vcc_regphy(vcc_regphy), .vss_io(vss_io),
     .i_gray(pvt_ref_half_gry[2:0]), .f_gray(pvt_ref_half_gry[9:3]),
     .out_n(clkn_dly), .out_p(clkp_dly), .osc_out_n(net014),
     .osc_out_p(net015), .osc_in_n(vcc_io), .osc_in_p(vss_io),
     .osc_mode(vss_io), .in_n(clk_dcd_split_n), .in_p(clk_dcd_split_p),
     .nfrzdrv(nfrzdrv));

endmodule

