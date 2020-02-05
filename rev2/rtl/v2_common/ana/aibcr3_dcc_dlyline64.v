// SPDX-License-Identifier: Apache-2.0
// Copyright (c) 2019 Blue Cheetah Analog Design, Inc.

`timescale 1ps/1ps 


module aib_dcc_dlyline64_inv_1__w_sup(
    input  wire in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;

assign #DELAY out = VSS ? 1'bx : (~VDD ? 1'b0 : ~in );

endmodule


module aib_dcc_dlyline64_nand_2__w_sup(
    input  wire [1:0] in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 20;

assign #DELAY out = VSS ? 1'bx : (~VDD ? 1'b0 : ~&in );

endmodule


module aib_dcc_dlyline64_nand_3__w_sup(
    input  wire [1:0] in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 20;

assign #DELAY out = VSS ? 1'bx : (~VDD ? 1'b0 : ~&in );

endmodule


module aib_dcc_dlyline64_aib_dlycell_core_1__w_sup(
    input  wire bk1,
    input  wire ci_p,
    input  wire in_p,
    output wire co_p,
    output wire out_p,
    inout  wire VDD,
    inout  wire VSS
);

wire sr0_o;
wire sr1_o;

aib_dcc_dlyline64_nand_2__w_sup XNAND_SR0 (
    .in( {sr1_o,bk1} ),
    .out( sr0_o ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_nand_2__w_sup XNAND_SR1 (
    .in( {sr0_o,in_p} ),
    .out( sr1_o ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_nand_3__w_sup XNAND_in (
    .in( {bk1,in_p} ),
    .out( co_p ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_nand_3__w_sup XNAND_out (
    .in( {sr1_o,ci_p} ),
    .out( out_p ),
    .VDD( VDD ),
    .VSS( VSS )
);

endmodule


module aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup(
    input  wire bk,
    input  wire ci_p,
    input  wire in_p,
    output wire co_p,
    output wire out_p,
    inout  wire VDD,
    inout  wire VSS
);

wire bk1;
wire bk_mid;

aib_dcc_dlyline64_inv_1__w_sup XBKInv0 (
    .in( bk ),
    .out( bk_mid ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_inv_1__w_sup XBKInv1 (
    .in( bk_mid ),
    .out( bk1 ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_core_1__w_sup XCore (
    .bk1( bk1 ),
    .ci_p( ci_p ),
    .in_p( in_p ),
    .co_p( co_p ),
    .out_p( out_p ),
    .VDD( VDD ),
    .VSS( VSS )
);

endmodule


module aib_dcc_dlyline64_aib_dlycell_no_flop_3__w_sup(
    input  wire bk,
    input  wire ci_p,
    input  wire in_p,
    output wire co_p,
    output wire out_p,
    inout  wire VDD,
    inout  wire VSS
);

wire bk1;
wire bk_mid;

aib_dcc_dlyline64_inv_1__w_sup XBKInv0 (
    .in( bk ),
    .out( bk_mid ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_inv_1__w_sup XBKInv1 (
    .in( bk_mid ),
    .out( bk1 ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_core_1__w_sup XCore (
    .bk1( bk1 ),
    .ci_p( ci_p ),
    .in_p( in_p ),
    .co_p( co_p ),
    .out_p( out_p ),
    .VDD( VDD ),
    .VSS( VSS )
);

endmodule


module aibcr3_dcc_dlyline64__w_sup(
    input  wire b63,
    input  wire [63:0] bk,
    input  wire dlyin,
    output wire a63,
    output wire dlyout,
    inout  wire VDD,
    inout  wire VSS
);

wire NC_co;
wire NC_out;
wire NC_so;
wire [62:0] a;
wire [62:0] b;

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_63 (
    .bk( bk[63] ),
    .ci_p( b63 ),
    .in_p( a[62] ),
    .co_p( a63 ),
    .out_p( b[62] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_62 (
    .bk( bk[62] ),
    .ci_p( b[62] ),
    .in_p( a[61] ),
    .co_p( a[62] ),
    .out_p( b[61] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_61 (
    .bk( bk[61] ),
    .ci_p( b[61] ),
    .in_p( a[60] ),
    .co_p( a[61] ),
    .out_p( b[60] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_60 (
    .bk( bk[60] ),
    .ci_p( b[60] ),
    .in_p( a[59] ),
    .co_p( a[60] ),
    .out_p( b[59] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_59 (
    .bk( bk[59] ),
    .ci_p( b[59] ),
    .in_p( a[58] ),
    .co_p( a[59] ),
    .out_p( b[58] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_58 (
    .bk( bk[58] ),
    .ci_p( b[58] ),
    .in_p( a[57] ),
    .co_p( a[58] ),
    .out_p( b[57] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_57 (
    .bk( bk[57] ),
    .ci_p( b[57] ),
    .in_p( a[56] ),
    .co_p( a[57] ),
    .out_p( b[56] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_56 (
    .bk( bk[56] ),
    .ci_p( b[56] ),
    .in_p( a[55] ),
    .co_p( a[56] ),
    .out_p( b[55] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_55 (
    .bk( bk[55] ),
    .ci_p( b[55] ),
    .in_p( a[54] ),
    .co_p( a[55] ),
    .out_p( b[54] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_54 (
    .bk( bk[54] ),
    .ci_p( b[54] ),
    .in_p( a[53] ),
    .co_p( a[54] ),
    .out_p( b[53] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_53 (
    .bk( bk[53] ),
    .ci_p( b[53] ),
    .in_p( a[52] ),
    .co_p( a[53] ),
    .out_p( b[52] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_52 (
    .bk( bk[52] ),
    .ci_p( b[52] ),
    .in_p( a[51] ),
    .co_p( a[52] ),
    .out_p( b[51] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_51 (
    .bk( bk[51] ),
    .ci_p( b[51] ),
    .in_p( a[50] ),
    .co_p( a[51] ),
    .out_p( b[50] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_50 (
    .bk( bk[50] ),
    .ci_p( b[50] ),
    .in_p( a[49] ),
    .co_p( a[50] ),
    .out_p( b[49] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_49 (
    .bk( bk[49] ),
    .ci_p( b[49] ),
    .in_p( a[48] ),
    .co_p( a[49] ),
    .out_p( b[48] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_48 (
    .bk( bk[48] ),
    .ci_p( b[48] ),
    .in_p( a[47] ),
    .co_p( a[48] ),
    .out_p( b[47] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_47 (
    .bk( bk[47] ),
    .ci_p( b[47] ),
    .in_p( a[46] ),
    .co_p( a[47] ),
    .out_p( b[46] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_46 (
    .bk( bk[46] ),
    .ci_p( b[46] ),
    .in_p( a[45] ),
    .co_p( a[46] ),
    .out_p( b[45] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_45 (
    .bk( bk[45] ),
    .ci_p( b[45] ),
    .in_p( a[44] ),
    .co_p( a[45] ),
    .out_p( b[44] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_44 (
    .bk( bk[44] ),
    .ci_p( b[44] ),
    .in_p( a[43] ),
    .co_p( a[44] ),
    .out_p( b[43] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_43 (
    .bk( bk[43] ),
    .ci_p( b[43] ),
    .in_p( a[42] ),
    .co_p( a[43] ),
    .out_p( b[42] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_42 (
    .bk( bk[42] ),
    .ci_p( b[42] ),
    .in_p( a[41] ),
    .co_p( a[42] ),
    .out_p( b[41] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_41 (
    .bk( bk[41] ),
    .ci_p( b[41] ),
    .in_p( a[40] ),
    .co_p( a[41] ),
    .out_p( b[40] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_40 (
    .bk( bk[40] ),
    .ci_p( b[40] ),
    .in_p( a[39] ),
    .co_p( a[40] ),
    .out_p( b[39] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_39 (
    .bk( bk[39] ),
    .ci_p( b[39] ),
    .in_p( a[38] ),
    .co_p( a[39] ),
    .out_p( b[38] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_38 (
    .bk( bk[38] ),
    .ci_p( b[38] ),
    .in_p( a[37] ),
    .co_p( a[38] ),
    .out_p( b[37] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_37 (
    .bk( bk[37] ),
    .ci_p( b[37] ),
    .in_p( a[36] ),
    .co_p( a[37] ),
    .out_p( b[36] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_36 (
    .bk( bk[36] ),
    .ci_p( b[36] ),
    .in_p( a[35] ),
    .co_p( a[36] ),
    .out_p( b[35] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_35 (
    .bk( bk[35] ),
    .ci_p( b[35] ),
    .in_p( a[34] ),
    .co_p( a[35] ),
    .out_p( b[34] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_34 (
    .bk( bk[34] ),
    .ci_p( b[34] ),
    .in_p( a[33] ),
    .co_p( a[34] ),
    .out_p( b[33] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_33 (
    .bk( bk[33] ),
    .ci_p( b[33] ),
    .in_p( a[32] ),
    .co_p( a[33] ),
    .out_p( b[32] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_32 (
    .bk( bk[32] ),
    .ci_p( b[32] ),
    .in_p( a[31] ),
    .co_p( a[32] ),
    .out_p( b[31] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_31 (
    .bk( bk[31] ),
    .ci_p( b[31] ),
    .in_p( a[30] ),
    .co_p( a[31] ),
    .out_p( b[30] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_30 (
    .bk( bk[30] ),
    .ci_p( b[30] ),
    .in_p( a[29] ),
    .co_p( a[30] ),
    .out_p( b[29] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_29 (
    .bk( bk[29] ),
    .ci_p( b[29] ),
    .in_p( a[28] ),
    .co_p( a[29] ),
    .out_p( b[28] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_28 (
    .bk( bk[28] ),
    .ci_p( b[28] ),
    .in_p( a[27] ),
    .co_p( a[28] ),
    .out_p( b[27] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_27 (
    .bk( bk[27] ),
    .ci_p( b[27] ),
    .in_p( a[26] ),
    .co_p( a[27] ),
    .out_p( b[26] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_26 (
    .bk( bk[26] ),
    .ci_p( b[26] ),
    .in_p( a[25] ),
    .co_p( a[26] ),
    .out_p( b[25] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_25 (
    .bk( bk[25] ),
    .ci_p( b[25] ),
    .in_p( a[24] ),
    .co_p( a[25] ),
    .out_p( b[24] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_24 (
    .bk( bk[24] ),
    .ci_p( b[24] ),
    .in_p( a[23] ),
    .co_p( a[24] ),
    .out_p( b[23] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_23 (
    .bk( bk[23] ),
    .ci_p( b[23] ),
    .in_p( a[22] ),
    .co_p( a[23] ),
    .out_p( b[22] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_22 (
    .bk( bk[22] ),
    .ci_p( b[22] ),
    .in_p( a[21] ),
    .co_p( a[22] ),
    .out_p( b[21] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_21 (
    .bk( bk[21] ),
    .ci_p( b[21] ),
    .in_p( a[20] ),
    .co_p( a[21] ),
    .out_p( b[20] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_20 (
    .bk( bk[20] ),
    .ci_p( b[20] ),
    .in_p( a[19] ),
    .co_p( a[20] ),
    .out_p( b[19] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_19 (
    .bk( bk[19] ),
    .ci_p( b[19] ),
    .in_p( a[18] ),
    .co_p( a[19] ),
    .out_p( b[18] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_18 (
    .bk( bk[18] ),
    .ci_p( b[18] ),
    .in_p( a[17] ),
    .co_p( a[18] ),
    .out_p( b[17] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_17 (
    .bk( bk[17] ),
    .ci_p( b[17] ),
    .in_p( a[16] ),
    .co_p( a[17] ),
    .out_p( b[16] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_16 (
    .bk( bk[16] ),
    .ci_p( b[16] ),
    .in_p( a[15] ),
    .co_p( a[16] ),
    .out_p( b[15] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_15 (
    .bk( bk[15] ),
    .ci_p( b[15] ),
    .in_p( a[14] ),
    .co_p( a[15] ),
    .out_p( b[14] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_14 (
    .bk( bk[14] ),
    .ci_p( b[14] ),
    .in_p( a[13] ),
    .co_p( a[14] ),
    .out_p( b[13] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_13 (
    .bk( bk[13] ),
    .ci_p( b[13] ),
    .in_p( a[12] ),
    .co_p( a[13] ),
    .out_p( b[12] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_12 (
    .bk( bk[12] ),
    .ci_p( b[12] ),
    .in_p( a[11] ),
    .co_p( a[12] ),
    .out_p( b[11] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_11 (
    .bk( bk[11] ),
    .ci_p( b[11] ),
    .in_p( a[10] ),
    .co_p( a[11] ),
    .out_p( b[10] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_10 (
    .bk( bk[10] ),
    .ci_p( b[10] ),
    .in_p( a[9] ),
    .co_p( a[10] ),
    .out_p( b[9] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_9 (
    .bk( bk[9] ),
    .ci_p( b[9] ),
    .in_p( a[8] ),
    .co_p( a[9] ),
    .out_p( b[8] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_8 (
    .bk( bk[8] ),
    .ci_p( b[8] ),
    .in_p( a[7] ),
    .co_p( a[8] ),
    .out_p( b[7] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_7 (
    .bk( bk[7] ),
    .ci_p( b[7] ),
    .in_p( a[6] ),
    .co_p( a[7] ),
    .out_p( b[6] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_6 (
    .bk( bk[6] ),
    .ci_p( b[6] ),
    .in_p( a[5] ),
    .co_p( a[6] ),
    .out_p( b[5] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_5 (
    .bk( bk[5] ),
    .ci_p( b[5] ),
    .in_p( a[4] ),
    .co_p( a[5] ),
    .out_p( b[4] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_4 (
    .bk( bk[4] ),
    .ci_p( b[4] ),
    .in_p( a[3] ),
    .co_p( a[4] ),
    .out_p( b[3] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_3 (
    .bk( bk[3] ),
    .ci_p( b[3] ),
    .in_p( a[2] ),
    .co_p( a[3] ),
    .out_p( b[2] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_2 (
    .bk( bk[2] ),
    .ci_p( b[2] ),
    .in_p( a[1] ),
    .co_p( a[2] ),
    .out_p( b[1] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_1 (
    .bk( bk[1] ),
    .ci_p( b[1] ),
    .in_p( a[0] ),
    .co_p( a[1] ),
    .out_p( b[0] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_2__w_sup XCELL_0 (
    .bk( bk[0] ),
    .ci_p( b[0] ),
    .in_p( dlyin ),
    .co_p( a[0] ),
    .out_p( dlyout ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dcc_dlyline64_aib_dlycell_no_flop_3__w_sup XDUM (
    .bk( VSS ),
    .ci_p( VSS ),
    .in_p( VSS ),
    .co_p( NC_co ),
    .out_p( NC_out ),
    .VDD( VDD ),
    .VSS( VSS )
);

endmodule


module aibcr3_dcc_dlyline64(
    input  wire b63,
    input  wire [63:0] bk,
    input  wire dlyin,
    output wire a63,
    output wire dlyout
);

wire VDD_val;
wire VSS_val;

assign VDD_val = 1'b1;
assign VSS_val = 1'b0;

aibcr3_dcc_dlyline64__w_sup XDUT (
    .b63( b63 ),
    .bk( bk ),
    .dlyin( dlyin ),
    .a63( a63 ),
    .dlyout( dlyout ),
    .VDD( VDD_val ),
    .VSS( VSS_val )
);

endmodule
