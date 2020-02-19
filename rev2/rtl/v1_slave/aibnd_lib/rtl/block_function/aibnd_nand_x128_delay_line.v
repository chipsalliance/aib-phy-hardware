// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_nand_x128_delay_line, View -
//schematic
// LAST TIME SAVED: Nov 11 07:23:04 2014
// NETLIST TIME: Dec 17 10:24:03 2014

module aibnd_nand_x128_delay_line ( out_p, vcc_io, vcc_regphy, vss_io,
     f_gray, i_gray, in_p );

output  out_p;

inout  vcc_io, vcc_regphy, vss_io;

input  in_p;

input [2:0]  i_gray;
input [6:0]  f_gray;



aibnd_cmos_nand_x128 xnand128 ( .vcc_io(vcc_io),
     .vcc_regphy(vcc_regphy), .vss_io(vss_io), .out_p(fout_p),
     .in_p(in_p), .gray(f_gray[6:0]));
aibnd_cmos_fine_dly  xfine ( //.vcc_io(vcc_io), .vss_io(vss_io),
     .gray(i_gray[2:0]), .out_p(out_p), .fout_p(fout_p)
     //.vcc_regphy(vcc_regphy)
     );

endmodule

