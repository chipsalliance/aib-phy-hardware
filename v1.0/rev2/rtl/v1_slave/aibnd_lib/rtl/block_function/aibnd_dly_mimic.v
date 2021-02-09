// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_dly_mimic, View - schematic
// LAST TIME SAVED: Jun 16 14:16:32 2015
// NETLIST TIME: Jun 16 14:57:46 2015
//`timescale 1ns / 1ns 

module aibnd_dly_mimic ( ihssi_tx_data_out_dly, csr_reg6,
     idll_core2dll_1, ihssi_tx_data_out, rb_dcc_byp, rb_dcc_byp_dprio, vcc_aibnd,
     vss_aibnd );


input  csr_reg6, idll_core2dll_1, rb_dcc_byp, rb_dcc_byp_dprio, vcc_aibnd, vss_aibnd;

output [39:0]  ihssi_tx_data_out_dly;

input [39:0]  ihssi_tx_data_out;

wire csr_reg6_buf , idll_core2dll_1_buf, dcc_byp_mux_buf, dcc_byp_mux;

wire rb_dcc_byp_inv, rb_dcc_byp_inv_buf;
assign rb_dcc_byp_inv = ~rb_dcc_byp_dprio;

assign csr_reg6_buf = csr_reg6;
assign rb_dcc_byp_inv_buf = rb_dcc_byp_inv;
assign idll_core2dll_1_buf = idll_core2dll_1 ;
assign dcc_byp_mux = csr_reg6_buf ? idll_core2dll_1_buf : rb_dcc_byp_inv_buf;
assign dcc_byp_mux_buf = dcc_byp_mux;




/*
specify 
    specparam CDS_LIBNAME  = "aibnd_lib";
    specparam CDS_CELLNAME = "aibnd_dly_mimic";
    specparam CDS_VIEWNAME = "schematic";
endspecify
*/

aibnd_dcc_dly_rep x19 ( .idat0(ihssi_tx_data_out[38]),
     .vss_aibnd(vss_aibnd), .vcc_aibnd(vcc_aibnd),
     .clkrep1(ihssi_tx_data_out_dly[39]),
     .idat1(ihssi_tx_data_out[39]), .rb_dcc_byp(dcc_byp_mux_buf),
     .clkrep0(ihssi_tx_data_out_dly[38]));
aibnd_dcc_dly_rep x18 ( .idat0(ihssi_tx_data_out[36]),
     .vss_aibnd(vss_aibnd), .vcc_aibnd(vcc_aibnd),
     .clkrep1(ihssi_tx_data_out_dly[37]),
     .idat1(ihssi_tx_data_out[37]), .rb_dcc_byp(dcc_byp_mux_buf),
     .clkrep0(ihssi_tx_data_out_dly[36]));
aibnd_dcc_dly_rep x17 ( .idat0(ihssi_tx_data_out[34]),
     .vss_aibnd(vss_aibnd), .vcc_aibnd(vcc_aibnd),
     .clkrep1(ihssi_tx_data_out_dly[35]),
     .idat1(ihssi_tx_data_out[35]), .rb_dcc_byp(dcc_byp_mux_buf),
     .clkrep0(ihssi_tx_data_out_dly[34]));
aibnd_dcc_dly_rep x16 ( .idat0(ihssi_tx_data_out[32]),
     .vss_aibnd(vss_aibnd), .vcc_aibnd(vcc_aibnd),
     .clkrep1(ihssi_tx_data_out_dly[33]),
     .idat1(ihssi_tx_data_out[33]), .rb_dcc_byp(dcc_byp_mux_buf),
     .clkrep0(ihssi_tx_data_out_dly[32]));
aibnd_dcc_dly_rep x15 ( .idat0(ihssi_tx_data_out[30]),
     .vss_aibnd(vss_aibnd), .vcc_aibnd(vcc_aibnd),
     .clkrep1(ihssi_tx_data_out_dly[31]),
     .idat1(ihssi_tx_data_out[31]), .rb_dcc_byp(dcc_byp_mux_buf),
     .clkrep0(ihssi_tx_data_out_dly[30]));
aibnd_dcc_dly_rep x14 ( .idat0(ihssi_tx_data_out[28]),
     .vss_aibnd(vss_aibnd), .vcc_aibnd(vcc_aibnd),
     .clkrep1(ihssi_tx_data_out_dly[29]),
     .idat1(ihssi_tx_data_out[29]), .rb_dcc_byp(dcc_byp_mux_buf),
     .clkrep0(ihssi_tx_data_out_dly[28]));
aibnd_dcc_dly_rep x13 ( .idat0(ihssi_tx_data_out[26]),
     .vss_aibnd(vss_aibnd), .vcc_aibnd(vcc_aibnd),
     .clkrep1(ihssi_tx_data_out_dly[27]),
     .idat1(ihssi_tx_data_out[27]), .rb_dcc_byp(dcc_byp_mux_buf),
     .clkrep0(ihssi_tx_data_out_dly[26]));
aibnd_dcc_dly_rep x12 ( .idat0(ihssi_tx_data_out[24]),
     .vss_aibnd(vss_aibnd), .vcc_aibnd(vcc_aibnd),
     .clkrep1(ihssi_tx_data_out_dly[25]),
     .idat1(ihssi_tx_data_out[25]), .rb_dcc_byp(dcc_byp_mux_buf),
     .clkrep0(ihssi_tx_data_out_dly[24]));
aibnd_dcc_dly_rep x11 ( .idat0(ihssi_tx_data_out[22]),
     .vss_aibnd(vss_aibnd), .vcc_aibnd(vcc_aibnd),
     .clkrep1(ihssi_tx_data_out_dly[23]),
     .idat1(ihssi_tx_data_out[23]), .rb_dcc_byp(dcc_byp_mux_buf),
     .clkrep0(ihssi_tx_data_out_dly[22]));
aibnd_dcc_dly_rep x10 ( .idat0(ihssi_tx_data_out[20]),
     .vss_aibnd(vss_aibnd), .vcc_aibnd(vcc_aibnd),
     .clkrep1(ihssi_tx_data_out_dly[21]),
     .idat1(ihssi_tx_data_out[21]), .rb_dcc_byp(dcc_byp_mux_buf),
     .clkrep0(ihssi_tx_data_out_dly[20]));
aibnd_dcc_dly_rep x9 ( .idat0(ihssi_tx_data_out[18]),
     .vss_aibnd(vss_aibnd), .vcc_aibnd(vcc_aibnd),
     .clkrep1(ihssi_tx_data_out_dly[19]),
     .idat1(ihssi_tx_data_out[19]), .rb_dcc_byp(dcc_byp_mux_buf),
     .clkrep0(ihssi_tx_data_out_dly[18]));
aibnd_dcc_dly_rep x8 ( .idat0(ihssi_tx_data_out[16]),
     .vss_aibnd(vss_aibnd), .vcc_aibnd(vcc_aibnd),
     .clkrep1(ihssi_tx_data_out_dly[17]),
     .idat1(ihssi_tx_data_out[17]), .rb_dcc_byp(dcc_byp_mux_buf),
     .clkrep0(ihssi_tx_data_out_dly[16]));
aibnd_dcc_dly_rep x7 ( .idat0(ihssi_tx_data_out[14]),
     .vss_aibnd(vss_aibnd), .vcc_aibnd(vcc_aibnd),
     .clkrep1(ihssi_tx_data_out_dly[15]),
     .idat1(ihssi_tx_data_out[15]), .rb_dcc_byp(dcc_byp_mux_buf),
     .clkrep0(ihssi_tx_data_out_dly[14]));
aibnd_dcc_dly_rep x6 ( .idat0(ihssi_tx_data_out[12]),
     .vss_aibnd(vss_aibnd), .vcc_aibnd(vcc_aibnd),
     .clkrep1(ihssi_tx_data_out_dly[13]),
     .idat1(ihssi_tx_data_out[13]), .rb_dcc_byp(dcc_byp_mux_buf),
     .clkrep0(ihssi_tx_data_out_dly[12]));
aibnd_dcc_dly_rep x5 ( .idat0(ihssi_tx_data_out[10]),
     .vss_aibnd(vss_aibnd), .vcc_aibnd(vcc_aibnd),
     .clkrep1(ihssi_tx_data_out_dly[11]),
     .idat1(ihssi_tx_data_out[11]), .rb_dcc_byp(dcc_byp_mux_buf),
     .clkrep0(ihssi_tx_data_out_dly[10]));
aibnd_dcc_dly_rep x4 ( .idat0(ihssi_tx_data_out[8]),
     .vss_aibnd(vss_aibnd), .vcc_aibnd(vcc_aibnd),
     .clkrep1(ihssi_tx_data_out_dly[9]), .idat1(ihssi_tx_data_out[9]),
     .rb_dcc_byp(dcc_byp_mux_buf), .clkrep0(ihssi_tx_data_out_dly[8]));
aibnd_dcc_dly_rep x3 ( .idat0(ihssi_tx_data_out[6]),
     .vss_aibnd(vss_aibnd), .vcc_aibnd(vcc_aibnd),
     .clkrep1(ihssi_tx_data_out_dly[7]), .idat1(ihssi_tx_data_out[7]),
     .rb_dcc_byp(dcc_byp_mux_buf), .clkrep0(ihssi_tx_data_out_dly[6]));
aibnd_dcc_dly_rep x2 ( .idat0(ihssi_tx_data_out[4]),
     .vss_aibnd(vss_aibnd), .vcc_aibnd(vcc_aibnd),
     .clkrep1(ihssi_tx_data_out_dly[5]), .idat1(ihssi_tx_data_out[5]),
     .rb_dcc_byp(dcc_byp_mux_buf), .clkrep0(ihssi_tx_data_out_dly[4]));
aibnd_dcc_dly_rep x1 ( .idat0(ihssi_tx_data_out[2]),
     .vss_aibnd(vss_aibnd), .vcc_aibnd(vcc_aibnd),
     .clkrep1(ihssi_tx_data_out_dly[3]), .idat1(ihssi_tx_data_out[3]),
     .rb_dcc_byp(dcc_byp_mux_buf), .clkrep0(ihssi_tx_data_out_dly[2]));
aibnd_dcc_dly_rep x0 ( .idat0(ihssi_tx_data_out[0]),
     .vss_aibnd(vss_aibnd), .vcc_aibnd(vcc_aibnd),
     .clkrep1(ihssi_tx_data_out_dly[1]), .idat1(ihssi_tx_data_out[1]),
     .rb_dcc_byp(dcc_byp_mux_buf), .clkrep0(ihssi_tx_data_out_dly[0]));
/*
d04mbn22ld0i0 mbn17 ( .s(csr_reg6_buf), .vss(vss_aibnd),
     .d2(rb_dcc_byp_buf), .o(dcc_byp_mux), .vcc(vcc_aibnd),
     .d1(idll_core2dll_1_buf));
d04bfn00wn0d5 bfn2 ( .a(csr_reg6), .o(csr_reg6_buf), .vcc(vcc_aibnd),
     .vss(vss_aibnd));
d04bfn00wn0d5 bfn1 ( .a(rb_dcc_byp), .o(rb_dcc_byp_buf),
     .vcc(vcc_aibnd), .vss(vss_aibnd));
d04bfn00wn0d5 bfn0 ( .a(idll_core2dll_1), .o(idll_core2dll_1_buf),
     .vcc(vcc_aibnd), .vss(vss_aibnd));
d04bfn00wn0d5 bf1 ( .a(dcc_byp_mux), .o(dcc_byp_mux_buf),
     .vcc(vcc_aibnd), .vss(vss_aibnd));
*/


endmodule
