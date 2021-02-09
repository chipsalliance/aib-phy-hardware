// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 

//---------------------------------------------------------------------------------------------------------------------------------------------
//  io_cmos_nand_x6
//---------------------------------------------------------------------------------------------------------------------------------------------

module io_cmos_nand_x6 (
input         ci_p,
input         ci_n,
input         in_p,
input         in_n,
input         bk5,
input         bk4,
input         bk3,
input         bk2,
input         bk1,
input         bk0,
output        co_p,
output        co_n,
output        out_p,
output        out_n
);

`ifdef TIMESCALE_EN
                timeunit 1ps;
                timeprecision 1ps;
`endif

wire [4:0]  a;
wire [4:0]  b;
wire [4:0]  c;
wire [4:0]  d;

parameter   NAND_DELAY = 20;

io_cmos_nand_x1 UD00 [5:0] (
.in_p       ( {a[4:0],in_p}     	),
.in_n       ( {c[4:0],in_n}     	),
.bk         ( {bk5,bk4,bk3,bk2,bk1,bk0} ),
.ci_p       ( {ci_p,b[4:0]}      	),
.ci_n       ( {ci_n,d[4:0]}      	),
.out_p      ( {b[4:0],out_p}    	),
.out_n      ( {d[4:0],out_n}    	),
.co_p       ( {co_p,a[4:0]}      	),
.co_n       ( {co_n,c[4:0]}      	)
);

endmodule



