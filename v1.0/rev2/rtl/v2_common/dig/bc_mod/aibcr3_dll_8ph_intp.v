// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Blue Cheetah Analog Design, Inc.
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3_lib, Cell - aibcr3_dll_8ph_intp, View - schematic
// LAST TIME SAVED: Aug 17 15:37:14 2016
// NETLIST TIME: Aug 17 15:46:58 2016
//`timescale 1ns / 1ns 
// Interpolator hierarchy : 
// Summary Of changes
// 1. Commented the non synthesizable constructs
// 2. Made it an instantiation block of the aibcr3_dll_interpolator block and the
// flip-flops aibcr3_svt16_scdffcdn_cust
// 3. PE: Added back correct timescale directive.
// 
`timescale 1ps/1ps

module aibcr3_dll_8ph_intp ( SOOUT, intout, CLKIN, PDb,
     fanout, gray, iSE, iSI );

//`ifdef TIMESCALE_EN
//                timeunit 1ps;
//                timeprecision 1ps;
//`endif


output  SOOUT, intout;

input  CLKIN, PDb, fanout, iSE, iSI;

input [2:0]  gray;

// Buses in the design

reg  [6:0]  sp_int;
reg  [6:0]  sp;
reg  [6:0]  sn;
//integer     calc_delay;
//integer     intrinsic;
//integer     step;
//integer     total_delay;

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
//assign sn_int[6:0] = ~sp_int[6:0];

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
aibcr3_svt16_scdffcdn_cust x146 (.Q(sp[0]), .scQ(SO1),  .CK(CK), .D(sp_int[0]),.CDN(RSTb), .SE(SE), .SI(iSI));
aibcr3_svt16_scdffcdn_cust I51 ( .Q(sp[2]), .scQ(SO3),  .CK(CK), .D(sp_int[2]),.CDN(RSTb), .SE(SE), .SI(SO2));
aibcr3_svt16_scdffcdn_cust I50 ( .Q(sp[4]), .scQ(SO4),  .CK(CK), .D(sp_int[4]),.CDN(RSTb), .SE(SE), .SI(SO3));
aibcr3_svt16_scdffcdn_cust x151 (.Q(sp[6]), .scQ(SO2),  .CK(CK), .D(sp_int[6]),.CDN(RSTb), .SE(SE), .SI(SO1));
aibcr3_svt16_scdffcdn_cust I43 ( .Q(sp[1]), .scQ(SOOUT),.CK(CK), .D(sp_int[1]),.CDN(RSTb), .SE(SE), .SI(SO6));
aibcr3_svt16_scdffcdn_cust I49 ( .Q(sp[3]), .scQ(SO5),  .CK(CK), .D(sp_int[3]),.CDN(RSTb), .SE(SE), .SI(SO4));
aibcr3_svt16_scdffcdn_cust I46 ( .Q(sp[5]), .scQ(SO6),  .CK(CK), .D(sp_int[5]),.CDN(RSTb), .SE(SE), .SI(SO5));

assign sn = ~sp;
/* Initially used aibcr3_dcc_interpolator but since we need 8*FD=1CD the dcc
 * and dll interpolators cannot be shared*/
aibcr3_dll_interpolator x142 ( .intout(intout), .a_in(fanout), .sn(sn[6:0]),
     .sp(sp[6:0]));

//initial step = 2;  //min:1.5ps; typ:2ps; max:4ps
//initial intrinsic = 50;  //min:10ps; typ:50ps; max:80ps
//
//initial step = 10;  //min:1.5ps; typ:2ps; max:4ps
//
//always @(*)
//        if      (sp[6] == 1'b1) calc_delay = (7 * step);
//        else if (sp[5] == 1'b1) calc_delay = (6 * step);
//        else if (sp[4] == 1'b1) calc_delay = (5 * step);
//        else if (sp[3] == 1'b1) calc_delay = (4 * step);
//        else if (sp[2] == 1'b1) calc_delay = (3 * step);
//        else if (sp[1] == 1'b1) calc_delay = (2 * step);
//        else if (sp[0] == 1'b1) calc_delay = (1 * step);
//        else                  calc_delay = (0 * step);
//
//initial intrinsic = 50;  //min:10ps; typ:50ps; max:80ps
////        assign delay = intrinsic  + calc_delay;
//                always @(*) total_delay = intrinsic  + calc_delay;
////                assign #total_delay intout = fanout;



endmodule
