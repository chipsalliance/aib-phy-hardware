// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 

//---------------------------------------------------------------------------------------------------------------------------------------------
//  io_cmos_nand_x4
//---------------------------------------------------------------------------------------------------------------------------------------------

module io_cmos_nand_x4 (
input         ci_p,
input         ci_n,
input         in_p,
input         in_n,
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

wire [2:0]  a;
wire [2:0]  b;
wire [2:0]  c;
wire [2:0]  d;

parameter   NAND_DELAY = 20;

io_cmos_nand_x1 UD00 [3:0] (
.in_p       ( {a[2:0],in_p}     	),
.in_n       ( {c[2:0],in_n}     	),
.bk         ( {bk3,bk2,bk1,bk0} 	),
.ci_p       ( {ci_p,b[2:0]}      	),
.ci_n       ( {ci_n,d[2:0]}      	),
.out_p      ( {b[2:0],out_p}    	),
.out_n      ( {d[2:0],out_n}    	),
.co_p       ( {co_p,a[2:0]}      	),
.co_n       ( {co_n,c[2:0]}      	)
);

endmodule



