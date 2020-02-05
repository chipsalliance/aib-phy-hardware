// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_cmos_nand_x128, View - schematic
// LAST TIME SAVED: Nov 27 15:06:31 2014
// NETLIST TIME: Dec 17 10:24:03 2014

module aibnd_cmos_nand_x128 ( out_p, vcc_io, vcc_regphy, vss_io, gray,
     in_p );

output  out_p;

inout  vcc_io, vcc_regphy, vss_io;

input  in_p;

input [6:0]  gray;

wire svcc, vss_io; // Conversion Sript Generated

// Buses in the design

wire  [127:0]  bk;



assign svcc = !vss_io;
io_cmos_nand_x128_decode  xdec ( //.vcc_io(vcc_io), .vss_io(vss_io),
     .bk(bk[127:0]), .gray(gray[6:0]));
aibnd_cmos_nand_x6  xnand_x6_20 ( //.vcc_regphy(vcc_regphy),
     //.vss_io(vss_io), 
     .bk5(vss_io), .bk4(bk[124]), .bk3(bk[123]),
     .bk2(bk[122]), .bk1(bk[121]), .bk0(bk[120]), .co_p(a125),
     .ci_p(svcc), .in_p(a119), .out_p(b119));
aibnd_cmos_nand_x6  xnand_x6_16 ( //.vcc_regphy(vcc_regphy),
     //.vss_io(vss_io), 
     .bk5(bk[101]), .bk4(bk[100]), .bk3(bk[99]),
     .bk2(bk[98]), .bk1(bk[97]), .bk0(bk[96]), .co_p(a101),
     .ci_p(b101), .in_p(a95), .out_p(b95));
aibnd_cmos_nand_x6  xnand_x6_15 ( //.vcc_regphy(vcc_regphy),
     //.vss_io(vss_io), 
     .bk5(bk[95]), .bk4(bk[94]), .bk3(bk[93]),
     .bk2(bk[92]), .bk1(bk[91]), .bk0(bk[90]), .co_p(a95), .ci_p(b95),
     .in_p(a89), .out_p(b89));
aibnd_cmos_nand_x6  xnand_x6_14 ( //.vcc_regphy(vcc_regphy),
     //.vss_io(vss_io), 
     .bk5(bk[89]), .bk4(bk[88]), .bk3(bk[87]),
     .bk2(bk[86]), .bk1(bk[85]), .bk0(bk[84]), .co_p(a89), .ci_p(b89),
     .in_p(a83), .out_p(b83));
aibnd_cmos_nand_x6  xnand_x6_13 ( //.vcc_regphy(vcc_regphy),
     //.vss_io(vss_io), 
     .bk5(bk[83]), .bk4(bk[82]), .bk3(bk[81]),
     .bk2(bk[80]), .bk1(bk[79]), .bk0(bk[78]), .co_p(a83), .ci_p(b83),
     .in_p(a77), .out_p(b77));
aibnd_cmos_nand_x6  xnand_x6_0 ( //.vcc_regphy(vcc_regphy),
     //.vss_io(vss_io), 
     .bk5(bk[5]), .bk4(bk[4]), .bk3(bk[3]),
     .bk2(bk[2]), .bk1(bk[1]), .bk0(bk[0]), .co_p(a5), .ci_p(b5),
     .in_p(in_p), .out_p(out_p));
aibnd_cmos_nand_x6  xnand_x6_11 ( //.vcc_regphy(vcc_regphy),
     //.vss_io(vss_io), 
     .bk5(bk[71]), .bk4(bk[70]), .bk3(bk[69]),
     .bk2(bk[68]), .bk1(bk[67]), .bk0(bk[66]), .co_p(a71), .ci_p(b71),
     .in_p(a65), .out_p(b65));
aibnd_cmos_nand_x6  xnand_x6_18 ( //.vcc_regphy(vcc_regphy),
     //.vss_io(vss_io), 
     .bk5(bk[113]), .bk4(bk[112]), .bk3(bk[111]),
     .bk2(bk[110]), .bk1(bk[109]), .bk0(bk[108]), .co_p(a113),
     .ci_p(b113), .in_p(a107), .out_p(b107));
aibnd_cmos_nand_x6  xnand_x6_10 ( //.vcc_regphy(vcc_regphy),
     //.vss_io(vss_io), 
     .bk5(bk[65]), .bk4(bk[64]), .bk3(bk[63]),
     .bk2(bk[62]), .bk1(bk[61]), .bk0(bk[60]), .co_p(a65), .ci_p(b65),
     .in_p(a59), .out_p(b59));
aibnd_cmos_nand_x6  xnand_x6_9 ( //.vcc_regphy(vcc_regphy),
     //.vss_io(vss_io), 
     .bk5(bk[59]), .bk4(bk[58]), .bk3(bk[57]),
     .bk2(bk[56]), .bk1(bk[55]), .bk0(bk[54]), .co_p(a59), .ci_p(b59),
     .in_p(a53), .out_p(b53));
aibnd_cmos_nand_x6  xnand_x6_8 ( //.vcc_regphy(vcc_regphy),
     //.vss_io(vss_io), 
     .bk5(bk[53]), .bk4(bk[52]), .bk3(bk[51]),
     .bk2(bk[50]), .bk1(bk[49]), .bk0(bk[48]), .co_p(a53), .ci_p(b53),
     .in_p(a47), .out_p(b47));
aibnd_cmos_nand_x6  xnand_x6_7 ( //.vcc_regphy(vcc_regphy),
     //.vss_io(vss_io), 
     .bk5(bk[47]), .bk4(bk[46]), .bk3(bk[45]),
     .bk2(bk[44]), .bk1(bk[43]), .bk0(bk[42]), .co_p(a47), .ci_p(b47),
     .in_p(a41), .out_p(b41));
aibnd_cmos_nand_x6  xnand_x6_6 ( //.vcc_regphy(vcc_regphy),
     //.vss_io(vss_io), 
     .bk5(bk[41]), .bk4(bk[40]), .bk3(bk[39]),
     .bk2(bk[38]), .bk1(bk[37]), .bk0(bk[36]), .co_p(a41), .ci_p(b41),
     .in_p(a35), .out_p(b35));
aibnd_cmos_nand_x6  xnand_x6_19 ( //.vcc_regphy(vcc_regphy),
     //.vss_io(vss_io), 
     .bk5(bk[119]), .bk4(bk[118]), .bk3(bk[117]),
     .bk2(bk[116]), .bk1(bk[115]), .bk0(bk[114]), .co_p(a119),
     .ci_p(b119), .in_p(a113), .out_p(b113));
aibnd_cmos_nand_x6  xnand_x6_5 ( //.vcc_regphy(vcc_regphy),
     //.vss_io(vss_io), 
     .bk5(bk[35]), .bk4(bk[34]), .bk3(bk[33]),
     .bk2(bk[32]), .bk1(bk[31]), .bk0(bk[30]), .co_p(a35), .ci_p(b35),
     .in_p(a29), .out_p(b29));
aibnd_cmos_nand_x6  xnand_x6_4 ( //.vcc_regphy(vcc_regphy),
     //.vss_io(vss_io), 
     .bk5(bk[29]), .bk4(bk[28]), .bk3(bk[27]),
     .bk2(bk[26]), .bk1(bk[25]), .bk0(bk[24]), .co_p(a29), .ci_p(b29),
     .in_p(a23), .out_p(b23));
aibnd_cmos_nand_x6  xnand_x6_3 ( //.vcc_regphy(vcc_regphy),
     //.vss_io(vss_io), 
     .bk5(bk[23]), .bk4(bk[22]), .bk3(bk[21]),
     .bk2(bk[20]), .bk1(bk[19]), .bk0(bk[18]), .co_p(a23), .ci_p(b23),
     .in_p(a17), .out_p(b17));
aibnd_cmos_nand_x6  xnand_x6_2 ( //.vcc_regphy(vcc_regphy),
     //.vss_io(vss_io), 
     .bk5(bk[17]), .bk4(bk[16]), .bk3(bk[15]),
     .bk2(bk[14]), .bk1(bk[13]), .bk0(bk[12]), .co_p(a17), .ci_p(b17),
     .in_p(a11), .out_p(b11));
aibnd_cmos_nand_x6  xnand_x6_1 ( //.vcc_regphy(vcc_regphy),
     //.vss_io(vss_io), 
     .bk5(bk[11]), .bk4(bk[10]), .bk3(bk[9]),
     .bk2(bk[8]), .bk1(bk[7]), .bk0(bk[6]), .co_p(a11), .ci_p(b11),
     .in_p(a5), .out_p(b5));
aibnd_cmos_nand_x6  xnand_x6_17 ( //.vcc_regphy(vcc_regphy),
     //.vss_io(vss_io), 
     .bk5(bk[107]), .bk4(bk[106]), .bk3(bk[105]),
     .bk2(bk[104]), .bk1(bk[103]), .bk0(bk[102]), .co_p(a107),
     .ci_p(b107), .in_p(a101), .out_p(b101));
aibnd_cmos_nand_x6  xnand_x64_12 ( //.vcc_regphy(vcc_regphy),
     //.vss_io(vss_io), 
     .bk5(bk[77]), .bk4(bk[76]), .bk3(bk[75]),
     .bk2(bk[74]), .bk1(bk[73]), .bk0(bk[72]), .co_p(a77), .ci_p(b77),
     .in_p(a71), .out_p(b71));

endmodule

