// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_cmos_nand_x64, View - schematic
// LAST TIME SAVED: Mar 26 07:33:49 2015
// NETLIST TIME: May 12 17:53:10 2015
// `timescale 1ns / 1ns 

module aibnd_cmos_nand_x64 ( out_p, so, ck, code_valid, gray, in_p,
     nrst, se_n, si, vcc_aibnd, vcc_io, vss_aibnd );

output  out_p, so;

input  ck, code_valid, in_p, nrst, se_n, si, vcc_aibnd, vcc_io,
     vss_aibnd;

input [6:0]  gray;

wire svcc, vss_aibnd; // Conversion Sript Generated

// Buses in the design

wire  [127:0]  bk;


// specify 
//     specparam CDS_LIBNAME  = "aibnd_lib";
//     specparam CDS_CELLNAME = "aibnd_cmos_nand_x64";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

assign svcc = !vss_aibnd;
io_cmos_nand_x128_decode  xdec ( //.vcc_io(vcc_aibnd),
     //.vss_io(vss_aibnd), 
     .bk(bk[127:0]), .gray(gray[6:0]));
aibnd_cmos_nand_x6  xnand_x6_0 ( .vcc_aibnd(vcc_aibnd),
     .vss_aibnd(vss_aibnd), .code_valid(code_valid), .ck(ck),
     .nrst(nrst), .se_n(se_n), .si(si), .so(so5), .bk5(bk[5]),
     .bk4(bk[4]), .bk3(bk[3]), .bk2(bk[2]), .bk1(bk[1]), .bk0(bk[0]),
     .co_p(a5), .ci_p(b5), .in_p(in_p), .out_p(out_p));
aibnd_cmos_nand_x6  xnand_x6_10 ( .vcc_aibnd(vcc_aibnd),
     .vss_aibnd(vss_aibnd), .code_valid(code_valid), .ck(ck),
     .nrst(nrst), .se_n(se_n), .si(so59), .so(so), .bk5(vss_aibnd),
     .bk4(bk[64]), .bk3(bk[63]), .bk2(bk[62]), .bk1(bk[61]),
     .bk0(bk[60]), .co_p(a65), .ci_p(svcc), .in_p(a59), .out_p(b59));
aibnd_cmos_nand_x6  xnand_x6_9 ( .vcc_aibnd(vcc_aibnd),
     .vss_aibnd(vss_aibnd), .code_valid(code_valid), .ck(ck),
     .nrst(nrst), .se_n(se_n), .si(so53), .so(so59), .bk5(bk[59]),
     .bk4(bk[58]), .bk3(bk[57]), .bk2(bk[56]), .bk1(bk[55]),
     .bk0(bk[54]), .co_p(a59), .ci_p(b59), .in_p(a53), .out_p(b53));
aibnd_cmos_nand_x6  xnand_x6_8 ( .vcc_aibnd(vcc_aibnd),
     .vss_aibnd(vss_aibnd), .code_valid(code_valid), .ck(ck),
     .nrst(nrst), .se_n(se_n), .si(so47), .so(so53), .bk5(bk[53]),
     .bk4(bk[52]), .bk3(bk[51]), .bk2(bk[50]), .bk1(bk[49]),
     .bk0(bk[48]), .co_p(a53), .ci_p(b53), .in_p(a47), .out_p(b47));
aibnd_cmos_nand_x6  xnand_x6_7 ( .vcc_aibnd(vcc_aibnd),
     .vss_aibnd(vss_aibnd), .code_valid(code_valid), .ck(ck),
     .nrst(nrst), .se_n(se_n), .si(so41), .so(so47), .bk5(bk[47]),
     .bk4(bk[46]), .bk3(bk[45]), .bk2(bk[44]), .bk1(bk[43]),
     .bk0(bk[42]), .co_p(a47), .ci_p(b47), .in_p(a41), .out_p(b41));
aibnd_cmos_nand_x6  xnand_x6_6 ( .vcc_aibnd(vcc_aibnd),
     .vss_aibnd(vss_aibnd), .code_valid(code_valid), .ck(ck),
     .nrst(nrst), .se_n(se_n), .si(so35), .so(so41), .bk5(bk[41]),
     .bk4(bk[40]), .bk3(bk[39]), .bk2(bk[38]), .bk1(bk[37]),
     .bk0(bk[36]), .co_p(a41), .ci_p(b41), .in_p(a35), .out_p(b35));
aibnd_cmos_nand_x6  xnand_x6_5 ( .vcc_aibnd(vcc_aibnd),
     .vss_aibnd(vss_aibnd), .code_valid(code_valid), .ck(ck),
     .nrst(nrst), .se_n(se_n), .si(so29), .so(so35), .bk5(bk[35]),
     .bk4(bk[34]), .bk3(bk[33]), .bk2(bk[32]), .bk1(bk[31]),
     .bk0(bk[30]), .co_p(a35), .ci_p(b35), .in_p(a29), .out_p(b29));
aibnd_cmos_nand_x6  xnand_x6_4 ( .vcc_aibnd(vcc_aibnd),
     .vss_aibnd(vss_aibnd), .code_valid(code_valid), .ck(ck),
     .nrst(nrst), .se_n(se_n), .si(so23), .so(so29), .bk5(bk[29]),
     .bk4(bk[28]), .bk3(bk[27]), .bk2(bk[26]), .bk1(bk[25]),
     .bk0(bk[24]), .co_p(a29), .ci_p(b29), .in_p(a23), .out_p(b23));
aibnd_cmos_nand_x6  xnand_x6_3 ( .vcc_aibnd(vcc_aibnd),
     .vss_aibnd(vss_aibnd), .code_valid(code_valid), .ck(ck),
     .nrst(nrst), .se_n(se_n), .si(so17), .so(so23), .bk5(bk[23]),
     .bk4(bk[22]), .bk3(bk[21]), .bk2(bk[20]), .bk1(bk[19]),
     .bk0(bk[18]), .co_p(a23), .ci_p(b23), .in_p(a17), .out_p(b17));
aibnd_cmos_nand_x6  xnand_x6_2 ( .vcc_aibnd(vcc_aibnd),
     .vss_aibnd(vss_aibnd), .code_valid(code_valid), .ck(ck),
     .nrst(nrst), .se_n(se_n), .si(so11), .so(so17), .bk5(bk[17]),
     .bk4(bk[16]), .bk3(bk[15]), .bk2(bk[14]), .bk1(bk[13]),
     .bk0(bk[12]), .co_p(a17), .ci_p(b17), .in_p(a11), .out_p(b11));
aibnd_cmos_nand_x6  xnand_x6_1 ( .vcc_aibnd(vcc_aibnd),
     .vss_aibnd(vss_aibnd), .code_valid(code_valid), .ck(ck),
     .nrst(nrst), .se_n(se_n), .si(so5), .so(so11), .bk5(bk[11]),
     .bk4(bk[10]), .bk3(bk[9]), .bk2(bk[8]), .bk1(bk[7]), .bk0(bk[6]),
     .co_p(a11), .ci_p(b11), .in_p(a5), .out_p(b5));

endmodule

