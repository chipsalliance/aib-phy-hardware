// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3_lib, Cell - aibcr3_dcc_8ph_intp, View - schematic
// LAST TIME SAVED: Aug 17 15:37:14 2016
// NETLIST TIME: Aug 17 15:46:58 2016
`timescale 1ns / 1ns 

module aibcr3_dcc_8ph_intp ( SOOUT, intout, CLKIN, PDb,
     fanout, gray, iSE, iSI );

output  SOOUT, intout;

input  CLKIN, PDb, fanout, iSE, iSI;

input [2:0]  gray;

// Buses in the design

reg  [6:0]  sp_int;
reg  [6:0]  sp;
wire [6:0]  sn;

wire CK;
wire RSTb;
wire SE;

assign CK = CLKIN;
assign RSTb = PDb;
assign SE = iSE;

always @(*)
  case (gray[2:0])
    3'b000 :  sp_int[6:0] = 7'b000_0000;
    3'b001 :  sp_int[6:0] = 7'b000_0001;
    3'b011 :  sp_int[6:0] = 7'b000_0011;
    3'b010 :  sp_int[6:0] = 7'b000_0111;
    3'b110 :  sp_int[6:0] = 7'b000_1111;
    3'b111 :  sp_int[6:0] = 7'b001_1111;
    3'b101 :  sp_int[6:0] = 7'b011_1111;
    3'b100 :  sp_int[6:0] = 7'b111_1111;
  endcase

// assign sn_int[6:0] = ~sp_int[6:0];

/*
assign net0154 = sn_int[0];
assign net0271 = sn_int[1];
assign net0265 = sn_int[2];
assign g2b     = sn_int[3];
assign net0374 = sn_int[4];
assign net0372 = sn_int[5];
assign net057  = sn_int[6];

assign net058  = sp_int[0];
assign net0337 = sp_int[1];
assign net0331 = sp_int[2];
assign net0268 = sp_int[3];
assign net0324 = sp_int[4];
assign net0338 = sp_int[5];
assign net0153 = sp_int[6];
*/
/*
aibcr3_svt16_scdffsdn_cust x144 ( sn[0], SO0,   CK, sn_int[0],
     RSTb, SE, iSI);
aibcr3_svt16_scdffsdn_cust I99 ( sn[3], SO8,   CK, sn_int[3],
     RSTb, SE, SO7);
aibcr3_svt16_scdffsdn_cust I97 ( sn[5], SO10,   CK, sn_int[5],
     RSTb, SE, SO9);
aibcr3_svt16_scdffsdn_cust I96 ( sn[1], SO12,   CK, sn_int[1],
     RSTb, SE, SO11);
aibcr3_svt16_scdffsdn_cust x147 ( sn[6], SO2,   CK, sn_int[6],
     RSTb, SE, SO1);
aibcr3_svt16_scdffsdn_cust I102 ( sn[2], SO4,   CK, sn_int[2],
     RSTb, SE, SO3);
aibcr3_svt16_scdffsdn_cust I100 ( sn[4], SO6,   CK, sn_int[4],
     RSTb, SE, SO5);
*/

aibcr3_svt16_scdffcdn_cust x146 ( sp[0], SO1,   RSTb, CK,
     sp_int[0], SE, iSI);
aibcr3_svt16_scdffcdn_cust I51 ( sp[2], SO3,   RSTb, CK,
     sp_int[2], SE, SO2);
aibcr3_svt16_scdffcdn_cust I50 ( sp[4], SO4,   RSTb, CK,
     sp_int[4], SE, SO3);
aibcr3_svt16_scdffcdn_cust x151 ( sp[6], SO2,   RSTb, CK,
     sp_int[6], SE, SO1);
aibcr3_svt16_scdffcdn_cust I43 ( sp[1], SOOUT,   RSTb, CK,
     sp_int[1], SE, SO6);
aibcr3_svt16_scdffcdn_cust I49 ( sp[3], SO5,   RSTb, CK,
     sp_int[3], SE, SO4);
aibcr3_svt16_scdffcdn_cust I46 ( sp[5], SO6,   RSTb, CK,
     sp_int[5], SE, SO5);

assign sn = ~sp;

aibcr3_dcc_interpolator x142 ( intout, fanout, sn[6:0],
     sp[6:0]);

endmodule
