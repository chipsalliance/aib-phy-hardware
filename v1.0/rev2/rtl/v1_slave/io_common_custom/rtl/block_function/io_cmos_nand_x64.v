// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 

//---------------------------------------------------------------------------------------------------------------------------------------------
//  io_cmos_nand_x64
//---------------------------------------------------------------------------------------------------------------------------------------------

module io_cmos_nand_x64 (
input         b63,
input         d63,
input         in_p,
input         in_n,
input   [6:0] gray,
output        a63,
output        c63,
output        out_p,
output        out_n
);

`ifdef TIMESCALE_EN
                timeunit 1ps;
                timeprecision 1ps;
`endif

parameter   NAND_DELAY = 20;

wire [63:0]  bk;
wire [62:0]  a;
wire [62:0]  b;
wire [62:0]  c;
wire [62:0]  d;

io_cmos_nand_x64_decode xdec (
.gray	    ( gray[6:0]		),
.bk	    ( bk[63:0]		)
);

io_cmos_nand_x6 xnand_x6 [9:0] (
.in_p       ( {a[53],a[47],a[41],a[35],a[29],a[23],a[17],a[11],a[5],in_p}     	),
.in_n       ( {c[53],c[47],c[41],c[35],c[29],c[23],c[17],c[11],c[5],in_n}     	),
.bk5        ( {bk[59],bk[53],bk[47],bk[41],bk[35],bk[29],bk[23],bk[17],bk[11],bk[5]} ),
.bk4        ( {bk[58],bk[52],bk[46],bk[40],bk[34],bk[28],bk[22],bk[16],bk[10],bk[4]} ),
.bk3        ( {bk[57],bk[51],bk[45],bk[39],bk[33],bk[27],bk[21],bk[15],bk[9],bk[3]}  ),
.bk2        ( {bk[56],bk[50],bk[44],bk[38],bk[32],bk[26],bk[20],bk[14],bk[8],bk[2]}  ),
.bk1        ( {bk[55],bk[49],bk[43],bk[37],bk[31],bk[25],bk[19],bk[13],bk[7],bk[1]}  ),
.bk0        ( {bk[54],bk[48],bk[42],bk[36],bk[30],bk[24],bk[18],bk[12],bk[6],bk[0]}  ),
.ci_p       ( {b[59],b[53],b[47],b[41],b[35],b[29],b[23],b[17],b[11],b[5]}    	),
.ci_n       ( {d[59],d[53],d[47],d[41],d[35],d[29],d[23],d[17],d[11],d[5]}     	),
.out_p      ( {b[53],b[47],b[41],b[35],b[29],b[23],b[17],b[11],b[5],out_p}    	),
.out_n      ( {d[53],d[47],d[41],d[35],d[29],d[23],d[17],d[11],d[5],out_n}    	),
.co_p       ( {a[59],a[53],a[47],a[41],a[35],a[29],a[23],a[17],a[11],a[5]}     	),
.co_n       ( {c[59],c[53],c[47],c[41],c[35],c[29],c[23],c[17],c[11],c[5]}     	)
);

io_cmos_nand_x4 xnand_x4 (
.in_p       ( a[59]	),
.in_n       ( c[59]	),
.bk3        ( bk[63]	),
.bk2        ( bk[62]	),
.bk1        ( bk[61]	),
.bk0        ( bk[60]	),
.ci_p       ( b63	),
.ci_n       ( d63	),
.out_p      ( b[59]	),
.out_n      ( d[59]	),
.co_p       ( a63	),
.co_n       ( c63	)
);

endmodule



