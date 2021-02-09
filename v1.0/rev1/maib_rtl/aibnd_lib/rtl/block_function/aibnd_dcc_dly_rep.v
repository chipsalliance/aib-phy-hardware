// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_dcc_dly_rep, View - schematic
// LAST TIME SAVED: Jun 10 18:02:11 2015
// NETLIST TIME: Jun 16 14:57:46 2015
//`timescale 1ns / 1ns 

module aibnd_dcc_dly_rep ( clkrep0, clkrep1, idat0, idat1, rb_dcc_byp,
     vcc_aibnd, vss_aibnd );

output  clkrep0, clkrep1;

input  idat0, idat1, rb_dcc_byp, vcc_aibnd, vss_aibnd;

/*
specify 
    specparam CDS_LIBNAME  = "aibnd_lib";
    specparam CDS_CELLNAME = "aibnd_dcc_dly_rep";
    specparam CDS_VIEWNAME = "schematic";
endspecify
*/

/*
d04gbf00nd0b0 xbuf2 ( .vss(vss_aibnd), .vcc(vcc_aibnd),
     .clk(rb_dcc_byp), .clkout(dcc_byp_buf));
d04inn00ld0o7 xinv3 ( .o1(clkrep1), .a(net22), .vcc(vcc_aibnd),
     .vss(vss_aibnd));
d04inn00ld0o7 xinv1 ( .o1(clkrep0), .a(net050), .vcc(vcc_aibnd),
     .vss(vss_aibnd));
*/
wire dcc_byp_buf , idat0_buf , idat1_buf,net22 , net050; 
assign dcc_byp_buf = rb_dcc_byp;
assign clkrep1 = ~net22;
assign clkrep0 = ~net050;

aibnd_io_nand_delay_line_min_rep xdelay_min (
     .out_n(idat0_dly), .out_p(idat1_dly), .in_n(idat0_buf),
     .in_p(idat1_buf), .nfrzdrv(vcc_aibnd));
aibnd_dcc_mux xmux4 ( .clk0(idat1_mux0), .s(vss_aibnd),
     .vcc_aibnd(vcc_aibnd), .vss_aibnd(vss_aibnd), .clkout(idat1_mux1),
     .clk1(vss_aibnd));
aibnd_dcc_mux xmux3 ( .clk0(idat1_dly), .s(vss_aibnd),
     .vcc_aibnd(vcc_aibnd), .vss_aibnd(vss_aibnd), .clkout(idat1_mux0),
     .clk1(vss_aibnd));
aibnd_dcc_mux xmux1 ( .clk0(idat0_mux0), .s(vss_aibnd),
     .vcc_aibnd(vcc_aibnd), .vss_aibnd(vss_aibnd), .clkout(idat0_mux1),
     .clk1(vss_aibnd));
aibnd_dcc_mux xmux0 ( .clk0(idat0_dly), .s(vss_aibnd),
     .vcc_aibnd(vcc_aibnd), .vss_aibnd(vss_aibnd), .clkout(idat0_mux0),
     .clk1(vss_aibnd));
aibnd_dcc_mux xmux5 ( .clk0(idat1_mux1), .s(dcc_byp_buf),
     .vcc_aibnd(vcc_aibnd), .vss_aibnd(vss_aibnd), .clkout(idat1_mux2),
     .clk1(idat1));
aibnd_dcc_mux xmux2 ( .clk0(idat0_mux1), .s(dcc_byp_buf),
     .vcc_aibnd(vcc_aibnd), .vss_aibnd(vss_aibnd), .clkout(idat0_mux2),
     .clk1(idat0));
/*
d04gbf00ld0d0 xbuf0 ( .vss(vss_aibnd), .vcc(vcc_aibnd), .clk(idat0),
     .clkout(idat0_buf));
d04gbf00ld0d0 xbuf1 ( .vss(vss_aibnd), .vcc(vcc_aibnd), .clk(idat1),
     .clkout(idat1_buf));
d04inn00ld0c5 xinv2 ( .o1(net22), .a(idat1_mux2), .vcc(vcc_aibnd),
     .vss(vss_aibnd));
d04inn00ld0c5 xinv0 ( .o1(net050), .a(idat0_mux2), .vcc(vcc_aibnd),
     .vss(vss_aibnd));
*/
assign idat0_buf = idat0 ;
assign idat1_buf = idat1 ;
assign net22 = ~idat1_mux2;
assign net050 = ~idat0_mux2;


endmodule
