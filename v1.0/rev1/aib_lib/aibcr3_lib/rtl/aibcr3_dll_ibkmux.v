// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3_lib, Cell - aibcr3_dll_ibkmux, View - schematic
// LAST TIME SAVED: Aug 22 11:46:45 2016
// NETLIST TIME: Aug 31 08:45:53 2016
`timescale 1ns / 1ns 

module aibcr3_dll_ibkmux ( SO_OUT, grey, igray, CK, RSTb,
     SE, code_valid, si, sm_grey, sm_igray );

output  SO_OUT;

input  CK, RSTb, SE, code_valid, si;

output [2:0]  igray;
output [6:0]  grey;

input [6:0]  sm_grey;
input [2:0]  sm_igray;

wire code_valid_buf;
wire code_valid_sync;

assign tieHi = 1'b1;

assign net0101 = code_valid_buf? sm_grey[6]  : grey[6];
assign net0100 = code_valid_buf? sm_grey[5]  : grey[5];
assign net104  = code_valid_buf? sm_grey[4]  : grey[4];
assign net107  = code_valid_buf? sm_grey[3]  : grey[3];
assign net106  = code_valid_buf? sm_grey[2]  : grey[2];
assign net108  = code_valid_buf? sm_grey[1]  : grey[1];
assign net109  = code_valid_buf? sm_grey[0]  : grey[0];
assign net0104 = code_valid_buf? sm_igray[2] : igray[2];
assign net0103 = code_valid_buf? sm_igray[1] : igray[1];
assign net0102 = code_valid_buf? sm_igray[0] : igray[0];

assign code_valid_buf = code_valid_sync;
assign SO0            = code_valid_sync;

aibcr3_svt16_scdffcdn_cust x25 ( igray[2], SO_OUT, RSTb,
     CK, net0104, SE, SO9);
aibcr3_svt16_scdffcdn_cust x23 ( igray[1], SO9, RSTb, CK,
     net0103, SE, SO8);
aibcr3_svt16_scdffcdn_cust x21 ( igray[0], SO8, RSTb, CK,
     net0102, SE, SO7);
aibcr3_svt16_scdffcdn_cust x19 ( grey[6], SO7, RSTb, CK,
     net0101, SE, SO6);
aibcr3_svt16_scdffcdn_cust x17 ( grey[5], SO6, RSTb, CK,
     net0100, SE, SO5);
aibcr3_svt16_scdffcdn_cust x7 ( grey[4], SO5, RSTb, CK,
     net104, SE, SO4);
aibcr3_svt16_scdffcdn_cust x6 ( grey[2], SO3, RSTb, CK,
     net106, SE, SO2);
aibcr3_svt16_scdffcdn_cust x4 ( grey[3], SO4, RSTb, CK,
     net107, SE, SO3);
aibcr3_svt16_scdffcdn_cust x2 ( grey[1], SO2, RSTb, CK,
     net108, SE, SO1);
aibcr3_svt16_scdffcdn_cust I316 ( grey[0], SO1, RSTb, CK,
     net109, SE, SO0);

aibcr3_ulvt16_2xarstsyncdff1_b2  I99 ( 
     .Q(code_valid_sync), .CLR_N(RSTb), .CK(CK), 
     .SE(SE), .D(code_valid), .SI(si));

endmodule
