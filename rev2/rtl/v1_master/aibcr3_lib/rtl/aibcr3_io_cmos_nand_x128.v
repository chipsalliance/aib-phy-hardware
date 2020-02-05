// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 

//---------------------------------------------------------------------------------------------------------------------------------------------
//  aibcr_io_cmos_nand_x128
//---------------------------------------------------------------------------------------------------------------------------------------------

module aibcr3_io_cmos_nand_x128 (
input         in_p,
input         in_n,
input   [6:0] gray,
output        out_p,
output        out_n 
);

`ifdef TIMESCALE_EN
                timeunit 1ps;
                timeprecision 1ps;
`endif

parameter   NAND_DELAY = 20;

wire   [5:0]  b_gray;
wire          a63;
wire          b63;
wire          c63;
wire          d63;
wire          a63dum;
wire          c63dum;


assign b_gray[5] =  ~gray[5] & gray[6];
assign b_gray[4] =   gray[4] & gray[6];
assign b_gray[3] =   gray[3] & gray[6];
assign b_gray[2] =   gray[2] & gray[6];
assign b_gray[1] =   gray[1] & gray[6];
assign b_gray[0] =   gray[0] & gray[6];

aibcr3_io_cmos_nand_x64 xnand64a (
.b63        ( b63                 ),
.d63        ( d63                 ),
.in_p       ( in_p                ),
.in_n       ( in_n                ),
.gray       ( gray[6:0]           ),
.a63        ( a63                 ),
.c63        ( c63                 ),
.out_p      ( out_p               ),
.out_n      ( out_n               )
);

aibcr3_io_cmos_nand_x64 xnand64b (
.b63        ( 1'b1                ),
.d63        ( 1'b1                ),
.in_p       ( a63                 ),
.in_n       ( c63                 ),
.gray       ( {1'b0, b_gray[5:0]} ),
.a63        ( a63dum              ),
.c63        ( c63dum              ),
.out_p      ( b63                 ),
.out_n      ( d63                 )
);

endmodule


