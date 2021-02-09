// SPDX-License-Identifier: Apache-2.0
// Copyright (c) 2019 Blue Cheetah Analog Design, Inc.

`timescale 1ps/1ps 


module aib_dlycell_dcc_inv_1__w_sup(
    input  wire in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;

assign #DELAY out = VSS ? 1'bx : (~VDD ? 1'b0 : ~in );

endmodule


module aib_dlycell_dcc_nand_2__w_sup(
    input  wire [1:0] in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;

assign #DELAY out = VSS ? 1'bx : (~VDD ? 1'b0 : ~&in );

endmodule


module aib_dlycell_dcc_nand_3__w_sup(
    input  wire [1:0] in,
    output wire out,
    inout  wire VDD,
    inout  wire VSS
);

parameter DELAY = 0;

assign #DELAY out = VSS ? 1'bx : (~VDD ? 1'b0 : ~&in );

endmodule


module aib_dlycell_dcc_aib_dlycell_core_1__w_sup(
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

aib_dlycell_dcc_nand_2__w_sup XNAND_SR0 (
    .in( {sr1_o,bk1} ),
    .out( sr0_o ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dlycell_dcc_nand_2__w_sup XNAND_SR1 (
    .in( {sr0_o,in_p} ),
    .out( sr1_o ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dlycell_dcc_nand_3__w_sup XNAND_in (
    .in( {bk1,in_p} ),
    .out( co_p ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dlycell_dcc_nand_3__w_sup XNAND_out (
    .in( {sr1_o,ci_p} ),
    .out( out_p ),
    .VDD( VDD ),
    .VSS( VSS )
);

endmodule


module aibcr3_dlycell_dcc__w_sup(
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

aib_dlycell_dcc_inv_1__w_sup XBKInv0 (
    .in( bk ),
    .out( bk_mid ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dlycell_dcc_inv_1__w_sup XBKInv1 (
    .in( bk_mid ),
    .out( bk1 ),
    .VDD( VDD ),
    .VSS( VSS )
);

aib_dlycell_dcc_aib_dlycell_core_1__w_sup XCore (
    .bk1( bk1 ),
    .ci_p( ci_p ),
    .in_p( in_p ),
    .co_p( co_p ),
    .out_p( out_p ),
    .VDD( VDD ),
    .VSS( VSS )
);

endmodule


module aibcr3_dlycell_dcc(
    input  wire bk,
    input  wire ci_p,
    input  wire in_p,
    output wire co_p,
    output wire out_p
);

wire VDD_val;
wire VSS_val;

wire out_p_int;

assign VDD_val = 1'b1;
assign VSS_val = 1'b0;

aibcr3_dlycell_dcc__w_sup XDUT (
    .bk( bk ),
    .ci_p( ci_p ),
    .in_p( in_p ),
    .co_p( co_p ),
    .out_p( out_p_int ),
    .VDD( VDD_val ),
    .VSS( VSS_val )
);

// from tttt_25_0p850_0p970
assign #(20, 24) out_p = out_p_int;

endmodule
