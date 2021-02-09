// SPDX-License-Identifier: Apache-2.0
// Copyright (c) 2019 Blue Cheetah Analog Design, Inc.

`timescale 1ps/1ps 


module aib_dll_dlyline64_nand_2__w_sup(
    input  wire [1:0] in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 20;

assign #DELAY out = VSS ? 1'bx : (~VDD ? 1'b0 : ~&in );

endmodule


module aib_dll_dlyline64_aib_dlycell_core_1__w_sup(
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

aib_dll_dlyline64_nand_2__w_sup XNAND_SR0 (
    .in( {sr1_o,bk1} ),
    .out( sr0_o ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_nand_2__w_sup XNAND_SR1 (
    .in( {sr0_o,in_p} ),
    .out( sr1_o ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_nand_2__w_sup XNAND_in (
    .in( {bk1,in_p} ),
    .out( co_p ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_nand_2__w_sup XNAND_out (
    .in( {sr1_o,ci_p} ),
    .out( out_p ),
    .VDD( VDD ),
    .VSS( VSS )
);

endmodule


module aib_dll_dlyline64_inv_2__w_sup(
    input  wire in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;

assign #DELAY out = VSS ? 1'bx : (~VDD ? 1'b0 : ~in );

endmodule


module aib_dll_dlyline64_inv_tristate_2__w_sup(
    input  wire en,
    input  wire enb,
    input  wire in,
    output trireg out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;
logic temp;

always_comb begin
    casez ({en, enb, VDD, VSS})
        4'b1010: temp = ~in;
        4'b0110: temp = 1'bz;
        4'b1110: temp = in ? 1'b0 : 1'bz;
        4'b0010: temp = in ? 1'bz : 1'b1;
        4'b??00: temp = 1'b0;
        default : temp = 1'bx;
    endcase
end

assign #DELAY out = temp;

endmodule


module aib_dll_dlyline64_nand_3__w_sup(
    input  wire [1:0] in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;

assign #DELAY out = VSS ? 1'bx : (~VDD ? 1'b0 : ~&in );

endmodule


module aib_dll_dlyline64_passgate_1__w_sup(
    input  wire en,
    input  wire enb,
    input  wire s,
    output trireg d,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;
wire tmp;

assign #DELAY tmp = VSS ? 1'bx : (~VDD ? 1'b0 : s);

tranif1 XTRN1 (d, tmp, en );
tranif0 XTRN0 (d, tmp, enb);

endmodule


module aib_dll_dlyline64_inv_tristate_3__w_sup(
    input  wire en,
    input  wire enb,
    input  wire in,
    input  wire rsthb,
    output trireg out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;
logic temp;

always_comb begin
    casez ({en, enb, rsthb, VDD, VSS})
        5'b??010: temp = 1'b1;
        5'b10110: temp = ~in;
        5'b01110: temp = 1'bz;
        5'b11110: temp = in ? 1'b0 : 1'bz;
        5'b00110: temp = in ? 1'bz : 1'b1;
        5'b???00: temp = 1'b0;
        default : temp = 1'bx;
    endcase
end

assign #DELAY out = temp;

endmodule


module aib_dll_dlyline64_current_summer_1__w_sup(
    input  wire [1:0] in,
    output wire out
);

    tran tr0(in[0], out);
    tran tr1(in[1], out);

endmodule


module aib_dll_dlyline64_flop_scan_rstlb_1__w_sup(
    input  wire clk,
    input  wire in,
    input  wire rstlb,
    input  wire scan_en,
    input  wire scan_in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

wire clkb;
wire o1;
wire [1:0] o1_s;
wire o2;
wire [1:0] o2_s;
wire o3;
wire o4;
wire [1:0] o4_s;
wire o5;
wire scan_enb;

aib_dll_dlyline64_inv_2__w_sup XCLK (
    .in( clk ),
    .out( clkb ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_inv_2__w_sup XFB (
    .in( o4 ),
    .out( o5 ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_inv_tristate_2__w_sup XIN (
    .en( scan_enb ),
    .enb( scan_en ),
    .in( in ),
    .out( o1_s[0] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_inv_tristate_2__w_sup XKEEP (
    .en( clk ),
    .enb( clkb ),
    .in( o3 ),
    .out( o2_s[1] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_inv_tristate_2__w_sup XMUX (
    .en( clkb ),
    .enb( clk ),
    .in( o1 ),
    .out( o2_s[0] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_nand_3__w_sup XNAND (
    .in( {o2,rstlb} ),
    .out( o3 ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_inv_2__w_sup XOUT (
    .in( o4 ),
    .out( out ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_passgate_1__w_sup XPASS (
    .en( clk ),
    .enb( clkb ),
    .s( o3 ),
    .d( o4_s[0] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_inv_tristate_3__w_sup XRST (
    .en( clkb ),
    .enb( clk ),
    .in( o5 ),
    .rsthb( rstlb ),
    .out( o4_s[1] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_inv_2__w_sup XSE (
    .in( scan_en ),
    .out( scan_enb ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_inv_tristate_2__w_sup XSI (
    .en( scan_en ),
    .enb( scan_enb ),
    .in( scan_in ),
    .out( o1_s[1] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_current_summer_1__w_sup XSUM0 (
    .in( o1_s[1:0] ),
    .out( o1 )
);

aib_dll_dlyline64_current_summer_1__w_sup XSUM1 (
    .in( o2_s[1:0] ),
    .out( o2 )
);

aib_dll_dlyline64_current_summer_1__w_sup XSUM2 (
    .in( o4_s[1:0] ),
    .out( o4 )
);

endmodule


module aib_dll_dlyline64_inv_3__w_sup(
    input  wire in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;

assign #DELAY out = VSS ? 1'bx : (~VDD ? 1'b0 : ~in );

endmodule


module aib_dll_dlyline64_aib_dlycell_2__w_sup(
    input  wire RSTb,
    input  wire SE,
    input  wire bk,
    input  wire ci_p,
    input  wire ck,
    input  wire in_p,
    input  wire si,
    output wire co_p,
    output wire out_p,
    output wire so,
    inout  wire VDD,
    inout  wire VSS
);

wire bk1;
wire mid_in;
wire mid_out;
wire so_mid;

aib_dll_dlyline64_aib_dlycell_core_1__w_sup XCore_1 (
    .bk1( bk1 ),
    .ci_p( mid_out ),
    .in_p( in_p ),
    .co_p( mid_in ),
    .out_p( out_p ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_core_1__w_sup XCore_0 (
    .bk1( bk1 ),
    .ci_p( ci_p ),
    .in_p( mid_in ),
    .co_p( co_p ),
    .out_p( mid_out ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_flop_scan_rstlb_1__w_sup XDFF (
    .clk( ck ),
    .in( bk ),
    .rstlb( RSTb ),
    .scan_en( SE ),
    .scan_in( si ),
    .out( bk1 ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_inv_3__w_sup XSoInv0 (
    .in( so_mid ),
    .out( so ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_inv_3__w_sup XSoInv1 (
    .in( bk1 ),
    .out( so_mid ),
    .VDD( VDD ),
    .VSS( VSS )
);

endmodule


module aib_dll_dlyline64_aib_dlycell_3__w_sup(
    input  wire RSTb,
    input  wire SE,
    input  wire bk,
    input  wire ci_p,
    input  wire ck,
    input  wire in_p,
    input  wire si,
    output wire co_p,
    output wire out_p,
    output wire so,
    inout  wire VDD,
    inout  wire VSS
);

wire NC_ci;
wire NC_co;
wire NC_in;
wire NC_out;
wire bk1;
wire so_mid;

aib_dll_dlyline64_aib_dlycell_core_1__w_sup XCore_1 (
    .bk1( bk1 ),
    .ci_p( NC_ci ),
    .in_p( in_p ),
    .co_p( NC_co ),
    .out_p( out_p ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_core_1__w_sup XCore_0 (
    .bk1( bk1 ),
    .ci_p( ci_p ),
    .in_p( NC_in ),
    .co_p( co_p ),
    .out_p( NC_out ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_flop_scan_rstlb_1__w_sup XDFF (
    .clk( ck ),
    .in( bk ),
    .rstlb( RSTb ),
    .scan_en( SE ),
    .scan_in( si ),
    .out( bk1 ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_inv_3__w_sup XSoInv0 (
    .in( so_mid ),
    .out( so ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_inv_3__w_sup XSoInv1 (
    .in( bk1 ),
    .out( so_mid ),
    .VDD( VDD ),
    .VSS( VSS )
);

endmodule


module aibcr3_dll_dlyline64__w_sup(
    input  wire CLKIN,
    input  wire RSTb,
    input  wire b63,
    input  wire [63:0] bk,
    input  wire dlyin,
    input  wire iSE,
    input  wire iSI,
    output wire SOOUT,
    output wire a63,
    output wire dlyout,
    inout  wire VDD,
    inout  wire VSS
);

wire [1:0] NC_co;
wire [1:0] NC_out;
wire [1:0] NC_so;
wire [62:0] a;
wire [62:0] b;
wire [62:0] so;

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_63 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[63] ),
    .ci_p( b63 ),
    .ck( CLKIN ),
    .in_p( a[62] ),
    .si( so[62] ),
    .co_p( a63 ),
    .out_p( b[62] ),
    .so( SOOUT ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_62 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[62] ),
    .ci_p( b[62] ),
    .ck( CLKIN ),
    .in_p( a[61] ),
    .si( so[61] ),
    .co_p( a[62] ),
    .out_p( b[61] ),
    .so( so[62] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_61 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[61] ),
    .ci_p( b[61] ),
    .ck( CLKIN ),
    .in_p( a[60] ),
    .si( so[60] ),
    .co_p( a[61] ),
    .out_p( b[60] ),
    .so( so[61] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_60 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[60] ),
    .ci_p( b[60] ),
    .ck( CLKIN ),
    .in_p( a[59] ),
    .si( so[59] ),
    .co_p( a[60] ),
    .out_p( b[59] ),
    .so( so[60] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_59 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[59] ),
    .ci_p( b[59] ),
    .ck( CLKIN ),
    .in_p( a[58] ),
    .si( so[58] ),
    .co_p( a[59] ),
    .out_p( b[58] ),
    .so( so[59] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_58 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[58] ),
    .ci_p( b[58] ),
    .ck( CLKIN ),
    .in_p( a[57] ),
    .si( so[57] ),
    .co_p( a[58] ),
    .out_p( b[57] ),
    .so( so[58] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_57 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[57] ),
    .ci_p( b[57] ),
    .ck( CLKIN ),
    .in_p( a[56] ),
    .si( so[56] ),
    .co_p( a[57] ),
    .out_p( b[56] ),
    .so( so[57] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_56 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[56] ),
    .ci_p( b[56] ),
    .ck( CLKIN ),
    .in_p( a[55] ),
    .si( so[55] ),
    .co_p( a[56] ),
    .out_p( b[55] ),
    .so( so[56] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_55 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[55] ),
    .ci_p( b[55] ),
    .ck( CLKIN ),
    .in_p( a[54] ),
    .si( so[54] ),
    .co_p( a[55] ),
    .out_p( b[54] ),
    .so( so[55] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_54 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[54] ),
    .ci_p( b[54] ),
    .ck( CLKIN ),
    .in_p( a[53] ),
    .si( so[53] ),
    .co_p( a[54] ),
    .out_p( b[53] ),
    .so( so[54] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_53 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[53] ),
    .ci_p( b[53] ),
    .ck( CLKIN ),
    .in_p( a[52] ),
    .si( so[52] ),
    .co_p( a[53] ),
    .out_p( b[52] ),
    .so( so[53] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_52 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[52] ),
    .ci_p( b[52] ),
    .ck( CLKIN ),
    .in_p( a[51] ),
    .si( so[51] ),
    .co_p( a[52] ),
    .out_p( b[51] ),
    .so( so[52] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_51 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[51] ),
    .ci_p( b[51] ),
    .ck( CLKIN ),
    .in_p( a[50] ),
    .si( so[50] ),
    .co_p( a[51] ),
    .out_p( b[50] ),
    .so( so[51] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_50 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[50] ),
    .ci_p( b[50] ),
    .ck( CLKIN ),
    .in_p( a[49] ),
    .si( so[49] ),
    .co_p( a[50] ),
    .out_p( b[49] ),
    .so( so[50] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_49 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[49] ),
    .ci_p( b[49] ),
    .ck( CLKIN ),
    .in_p( a[48] ),
    .si( so[48] ),
    .co_p( a[49] ),
    .out_p( b[48] ),
    .so( so[49] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_48 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[48] ),
    .ci_p( b[48] ),
    .ck( CLKIN ),
    .in_p( a[47] ),
    .si( so[47] ),
    .co_p( a[48] ),
    .out_p( b[47] ),
    .so( so[48] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_47 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[47] ),
    .ci_p( b[47] ),
    .ck( CLKIN ),
    .in_p( a[46] ),
    .si( so[46] ),
    .co_p( a[47] ),
    .out_p( b[46] ),
    .so( so[47] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_46 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[46] ),
    .ci_p( b[46] ),
    .ck( CLKIN ),
    .in_p( a[45] ),
    .si( so[45] ),
    .co_p( a[46] ),
    .out_p( b[45] ),
    .so( so[46] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_45 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[45] ),
    .ci_p( b[45] ),
    .ck( CLKIN ),
    .in_p( a[44] ),
    .si( so[44] ),
    .co_p( a[45] ),
    .out_p( b[44] ),
    .so( so[45] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_44 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[44] ),
    .ci_p( b[44] ),
    .ck( CLKIN ),
    .in_p( a[43] ),
    .si( so[43] ),
    .co_p( a[44] ),
    .out_p( b[43] ),
    .so( so[44] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_43 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[43] ),
    .ci_p( b[43] ),
    .ck( CLKIN ),
    .in_p( a[42] ),
    .si( so[42] ),
    .co_p( a[43] ),
    .out_p( b[42] ),
    .so( so[43] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_42 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[42] ),
    .ci_p( b[42] ),
    .ck( CLKIN ),
    .in_p( a[41] ),
    .si( so[41] ),
    .co_p( a[42] ),
    .out_p( b[41] ),
    .so( so[42] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_41 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[41] ),
    .ci_p( b[41] ),
    .ck( CLKIN ),
    .in_p( a[40] ),
    .si( so[40] ),
    .co_p( a[41] ),
    .out_p( b[40] ),
    .so( so[41] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_40 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[40] ),
    .ci_p( b[40] ),
    .ck( CLKIN ),
    .in_p( a[39] ),
    .si( so[39] ),
    .co_p( a[40] ),
    .out_p( b[39] ),
    .so( so[40] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_39 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[39] ),
    .ci_p( b[39] ),
    .ck( CLKIN ),
    .in_p( a[38] ),
    .si( so[38] ),
    .co_p( a[39] ),
    .out_p( b[38] ),
    .so( so[39] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_38 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[38] ),
    .ci_p( b[38] ),
    .ck( CLKIN ),
    .in_p( a[37] ),
    .si( so[37] ),
    .co_p( a[38] ),
    .out_p( b[37] ),
    .so( so[38] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_37 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[37] ),
    .ci_p( b[37] ),
    .ck( CLKIN ),
    .in_p( a[36] ),
    .si( so[36] ),
    .co_p( a[37] ),
    .out_p( b[36] ),
    .so( so[37] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_36 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[36] ),
    .ci_p( b[36] ),
    .ck( CLKIN ),
    .in_p( a[35] ),
    .si( so[35] ),
    .co_p( a[36] ),
    .out_p( b[35] ),
    .so( so[36] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_35 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[35] ),
    .ci_p( b[35] ),
    .ck( CLKIN ),
    .in_p( a[34] ),
    .si( so[34] ),
    .co_p( a[35] ),
    .out_p( b[34] ),
    .so( so[35] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_34 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[34] ),
    .ci_p( b[34] ),
    .ck( CLKIN ),
    .in_p( a[33] ),
    .si( so[33] ),
    .co_p( a[34] ),
    .out_p( b[33] ),
    .so( so[34] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_33 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[33] ),
    .ci_p( b[33] ),
    .ck( CLKIN ),
    .in_p( a[32] ),
    .si( so[32] ),
    .co_p( a[33] ),
    .out_p( b[32] ),
    .so( so[33] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_32 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[32] ),
    .ci_p( b[32] ),
    .ck( CLKIN ),
    .in_p( a[31] ),
    .si( so[31] ),
    .co_p( a[32] ),
    .out_p( b[31] ),
    .so( so[32] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_31 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[31] ),
    .ci_p( b[31] ),
    .ck( CLKIN ),
    .in_p( a[30] ),
    .si( so[30] ),
    .co_p( a[31] ),
    .out_p( b[30] ),
    .so( so[31] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_30 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[30] ),
    .ci_p( b[30] ),
    .ck( CLKIN ),
    .in_p( a[29] ),
    .si( so[29] ),
    .co_p( a[30] ),
    .out_p( b[29] ),
    .so( so[30] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_29 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[29] ),
    .ci_p( b[29] ),
    .ck( CLKIN ),
    .in_p( a[28] ),
    .si( so[28] ),
    .co_p( a[29] ),
    .out_p( b[28] ),
    .so( so[29] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_28 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[28] ),
    .ci_p( b[28] ),
    .ck( CLKIN ),
    .in_p( a[27] ),
    .si( so[27] ),
    .co_p( a[28] ),
    .out_p( b[27] ),
    .so( so[28] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_27 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[27] ),
    .ci_p( b[27] ),
    .ck( CLKIN ),
    .in_p( a[26] ),
    .si( so[26] ),
    .co_p( a[27] ),
    .out_p( b[26] ),
    .so( so[27] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_26 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[26] ),
    .ci_p( b[26] ),
    .ck( CLKIN ),
    .in_p( a[25] ),
    .si( so[25] ),
    .co_p( a[26] ),
    .out_p( b[25] ),
    .so( so[26] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_25 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[25] ),
    .ci_p( b[25] ),
    .ck( CLKIN ),
    .in_p( a[24] ),
    .si( so[24] ),
    .co_p( a[25] ),
    .out_p( b[24] ),
    .so( so[25] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_24 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[24] ),
    .ci_p( b[24] ),
    .ck( CLKIN ),
    .in_p( a[23] ),
    .si( so[23] ),
    .co_p( a[24] ),
    .out_p( b[23] ),
    .so( so[24] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_23 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[23] ),
    .ci_p( b[23] ),
    .ck( CLKIN ),
    .in_p( a[22] ),
    .si( so[22] ),
    .co_p( a[23] ),
    .out_p( b[22] ),
    .so( so[23] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_22 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[22] ),
    .ci_p( b[22] ),
    .ck( CLKIN ),
    .in_p( a[21] ),
    .si( so[21] ),
    .co_p( a[22] ),
    .out_p( b[21] ),
    .so( so[22] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_21 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[21] ),
    .ci_p( b[21] ),
    .ck( CLKIN ),
    .in_p( a[20] ),
    .si( so[20] ),
    .co_p( a[21] ),
    .out_p( b[20] ),
    .so( so[21] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_20 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[20] ),
    .ci_p( b[20] ),
    .ck( CLKIN ),
    .in_p( a[19] ),
    .si( so[19] ),
    .co_p( a[20] ),
    .out_p( b[19] ),
    .so( so[20] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_19 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[19] ),
    .ci_p( b[19] ),
    .ck( CLKIN ),
    .in_p( a[18] ),
    .si( so[18] ),
    .co_p( a[19] ),
    .out_p( b[18] ),
    .so( so[19] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_18 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[18] ),
    .ci_p( b[18] ),
    .ck( CLKIN ),
    .in_p( a[17] ),
    .si( so[17] ),
    .co_p( a[18] ),
    .out_p( b[17] ),
    .so( so[18] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_17 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[17] ),
    .ci_p( b[17] ),
    .ck( CLKIN ),
    .in_p( a[16] ),
    .si( so[16] ),
    .co_p( a[17] ),
    .out_p( b[16] ),
    .so( so[17] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_16 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[16] ),
    .ci_p( b[16] ),
    .ck( CLKIN ),
    .in_p( a[15] ),
    .si( so[15] ),
    .co_p( a[16] ),
    .out_p( b[15] ),
    .so( so[16] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_15 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[15] ),
    .ci_p( b[15] ),
    .ck( CLKIN ),
    .in_p( a[14] ),
    .si( so[14] ),
    .co_p( a[15] ),
    .out_p( b[14] ),
    .so( so[15] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_14 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[14] ),
    .ci_p( b[14] ),
    .ck( CLKIN ),
    .in_p( a[13] ),
    .si( so[13] ),
    .co_p( a[14] ),
    .out_p( b[13] ),
    .so( so[14] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_13 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[13] ),
    .ci_p( b[13] ),
    .ck( CLKIN ),
    .in_p( a[12] ),
    .si( so[12] ),
    .co_p( a[13] ),
    .out_p( b[12] ),
    .so( so[13] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_12 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[12] ),
    .ci_p( b[12] ),
    .ck( CLKIN ),
    .in_p( a[11] ),
    .si( so[11] ),
    .co_p( a[12] ),
    .out_p( b[11] ),
    .so( so[12] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_11 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[11] ),
    .ci_p( b[11] ),
    .ck( CLKIN ),
    .in_p( a[10] ),
    .si( so[10] ),
    .co_p( a[11] ),
    .out_p( b[10] ),
    .so( so[11] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_10 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[10] ),
    .ci_p( b[10] ),
    .ck( CLKIN ),
    .in_p( a[9] ),
    .si( so[9] ),
    .co_p( a[10] ),
    .out_p( b[9] ),
    .so( so[10] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_9 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[9] ),
    .ci_p( b[9] ),
    .ck( CLKIN ),
    .in_p( a[8] ),
    .si( so[8] ),
    .co_p( a[9] ),
    .out_p( b[8] ),
    .so( so[9] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_8 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[8] ),
    .ci_p( b[8] ),
    .ck( CLKIN ),
    .in_p( a[7] ),
    .si( so[7] ),
    .co_p( a[8] ),
    .out_p( b[7] ),
    .so( so[8] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_7 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[7] ),
    .ci_p( b[7] ),
    .ck( CLKIN ),
    .in_p( a[6] ),
    .si( so[6] ),
    .co_p( a[7] ),
    .out_p( b[6] ),
    .so( so[7] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_6 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[6] ),
    .ci_p( b[6] ),
    .ck( CLKIN ),
    .in_p( a[5] ),
    .si( so[5] ),
    .co_p( a[6] ),
    .out_p( b[5] ),
    .so( so[6] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_5 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[5] ),
    .ci_p( b[5] ),
    .ck( CLKIN ),
    .in_p( a[4] ),
    .si( so[4] ),
    .co_p( a[5] ),
    .out_p( b[4] ),
    .so( so[5] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_4 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[4] ),
    .ci_p( b[4] ),
    .ck( CLKIN ),
    .in_p( a[3] ),
    .si( so[3] ),
    .co_p( a[4] ),
    .out_p( b[3] ),
    .so( so[4] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_3 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[3] ),
    .ci_p( b[3] ),
    .ck( CLKIN ),
    .in_p( a[2] ),
    .si( so[2] ),
    .co_p( a[3] ),
    .out_p( b[2] ),
    .so( so[3] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_2 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[2] ),
    .ci_p( b[2] ),
    .ck( CLKIN ),
    .in_p( a[1] ),
    .si( so[1] ),
    .co_p( a[2] ),
    .out_p( b[1] ),
    .so( so[2] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_1 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[1] ),
    .ci_p( b[1] ),
    .ck( CLKIN ),
    .in_p( a[0] ),
    .si( so[0] ),
    .co_p( a[1] ),
    .out_p( b[0] ),
    .so( so[1] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_2__w_sup XCELL_0 (
    .RSTb( RSTb ),
    .SE( iSE ),
    .bk( bk[0] ),
    .ci_p( b[0] ),
    .ck( CLKIN ),
    .in_p( dlyin ),
    .si( iSI ),
    .co_p( a[0] ),
    .out_p( dlyout ),
    .so( so[0] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_3__w_sup XDUM_1 (
    .RSTb( VSS ),
    .SE( VSS ),
    .bk( VSS ),
    .ci_p( VSS ),
    .ck( VSS ),
    .in_p( VSS ),
    .si( VSS ),
    .co_p( NC_co[1] ),
    .out_p( NC_out[1] ),
    .so( NC_so[1] ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dll_dlyline64_aib_dlycell_3__w_sup XDUM_0 (
    .RSTb( VSS ),
    .SE( VSS ),
    .bk( VSS ),
    .ci_p( VSS ),
    .ck( VSS ),
    .in_p( VSS ),
    .si( VSS ),
    .co_p( NC_co[0] ),
    .out_p( NC_out[0] ),
    .so( NC_so[0] ),
    .VDD( VDD ),
    .VSS( VSS )
);

endmodule


module aibcr3_dll_dlyline64(
    input  wire CLKIN,
    input  wire RSTb,
    input  wire b63,
    input  wire [63:0] bk,
    input  wire dlyin,
    input  wire iSE,
    input  wire iSI,
    output wire SOOUT,
    output wire a63,
    output wire dlyout
);

wire VDD_val;
wire VSS_val;

assign VDD_val = 1'b1;
assign VSS_val = 1'b0;

aibcr3_dll_dlyline64__w_sup XDUT (
    .CLKIN( CLKIN ),
    .RSTb( RSTb ),
    .b63( b63 ),
    .bk( bk ),
    .dlyin( dlyin ),
    .iSE( iSE ),
    .iSI( iSI ),
    .SOOUT( SOOUT ),
    .a63( a63 ),
    .dlyout( dlyout ),
    .VDD( VDD_val ),
    .VSS( VSS_val )
);

endmodule
