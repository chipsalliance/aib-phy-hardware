// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_cmos_nand_x6, View - schematic
// LAST TIME SAVED: Mar 26 07:33:49 2015
// NETLIST TIME: Apr  3 13:57:16 2015
// `timescale 1ns / 1ns 

module aibnd_cmos_nand_x6 ( co_p, out_p, so, bk0, bk1, bk2,
     bk3, bk4, bk5, ci_p, ck, code_valid, in_p, nrst, se_n, si,
     vcc_aibnd, vss_aibnd );

output  co_p, out_p, so;

input  bk0, bk1, bk2, bk3, bk4, bk5, ci_p, ck, code_valid, in_p, nrst,
     se_n, si, vcc_aibnd, vss_aibnd;


// specify 
//     specparam CDS_LIBNAME  = "aibnd_lib";
//     specparam CDS_CELLNAME = "aibnd_cmos_nand_x6";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

aibnd_cmos_nand_x1  xd00 ( .code_valid(code_valid), .ck(ck), .so(so0),
     .si(si), .se_n(se_n), .nrst(nrst), //.vcc_io(vcc_aibnd),
     .in_p(in_p), .bk(bk0), //.vss_io(vss_aibnd), 
     .co_p(a0), .ci_p(b0),
     .out_p(out_p));
aibnd_cmos_nand_x1  xd01 ( .code_valid(code_valid), .ck(ck), .so(so1),
     .si(so0), .se_n(se_n), .nrst(nrst), //.vcc_io(vcc_aibnd), 
     .in_p(a0), .bk(bk1), //.vss_io(vss_aibnd), 
     .co_p(a1), .ci_p(b1), .out_p(b0));
aibnd_cmos_nand_x1  xd02 ( .code_valid(code_valid), .ck(ck), .so(so2),
     .si(so1), .se_n(se_n), .nrst(nrst), //.vcc_io(vcc_aibnd), 
     .in_p(a1), .bk(bk2), //.vss_io(vss_aibnd), 
     .co_p(a2), .ci_p(b2), .out_p(b1));
aibnd_cmos_nand_x1  xd03 ( .code_valid(code_valid), .ck(ck), .so(so3),
     .si(so2), .se_n(se_n), .nrst(nrst), //.vcc_io(vcc_aibnd), 
     .in_p(a2), .bk(bk3), //.vss_io(vss_aibnd), 
     .co_p(a3), .ci_p(b3), .out_p(b2));
aibnd_cmos_nand_x1  xd04 ( .code_valid(code_valid), .ck(ck), .so(so4),
     .si(so3), .se_n(se_n), .nrst(nrst), //.vcc_io(vcc_aibnd), 
     .in_p(a3), .bk(bk4), //.vss_io(vss_aibnd), 
     .co_p(a4), .ci_p(b4), .out_p(b3));
aibnd_cmos_nand_x1  xd05 ( .code_valid(code_valid), .ck(ck), .so(so),
     .si(so4), .se_n(se_n), .nrst(nrst), //.vcc_io(vcc_aibnd), 
     .in_p(a4), .bk(bk5), //.vss_io(vss_aibnd), 
     .co_p(co_p), .ci_p(ci_p), .out_p(b4));

endmodule

