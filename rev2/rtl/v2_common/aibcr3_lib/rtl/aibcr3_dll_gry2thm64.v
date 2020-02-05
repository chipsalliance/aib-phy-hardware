// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3_lib, Cell - aibcr3_dll_gry2thm64, View - schematic
// LAST TIME SAVED: Jul 25 03:08:04 2016
// NETLIST TIME: Aug 17 15:46:58 2016
`timescale 1ns / 1ns 

module aibcr3_dll_gry2thm64 ( bk, CLKIN, 
     grey, iSE );

input  CLKIN, iSE;

output [63:0]  bk;

input [6:0]  grey;

// Buses in the design

wire  [3:0]  col;
wire         icol4b;
wire         col4b;
wire         col5b;
wire         icol6b;
wire  [6:0]  row;
wire         row0b;
wire         row1b;
wire         row2b;
wire         row3b;
wire         row4b;
wire         row5b;
wire         row6b;
wire  [6:0]  row_combi;
wire  [6:0]  row_combi_invert;
wire [62:0]  a;
wire [62:0]  b;
wire  [6:0]  newcol;

assign CK    = CLKIN;
assign CK1   = CLKIN;
assign tieHI = 1'b1;
assign SE    = iSE;

// Column Combinatorial Logic
// ------------------------------
assign col0 =  grey[5] | grey[4] | grey[3];
assign col1 =  grey[5] | grey[4];
assign col2 =  grey[5] | ~(~grey[4] | grey[3]);
assign col3 =  grey[5];

assign col4b = ~(~grey[5] | ~(~grey[4] | grey[3]));
assign col5bc = ~(~grey[5] | grey[4]);
assign col6b = ~(~grey[5] | grey[4] | grey[3]);

/*  implementation
assign col[4] = ~grey[5] | ~(~grey[4] | grey[3]);
assign col[5] = ~grey[5] | grey[4];
assign col[6] = ~grey[5] | grey[4] | grey[3];
*/

/* 
aibcr3_svt16_scdffcdn_cust I356 ( col0, SO14, RSTb, CK1,
     col[0], SE, SO13);
aibcr3_svt16_scdffcdn_cust I360 ( col1, SO15, RSTb, CK1,
     col[1], SE, SO14);
aibcr3_svt16_scdffcdn_cust I363 ( col2, SO16, RSTb, CK1,
     col[2], SE, SO15);
aibcr3_svt16_scdffcdn_cust I374 ( col3, SO17, RSTb, CK1,
     col[3], SE, SO16);
aibcr3_svt16_scdffcdn_cust x458 ( col4b, SOOUT, RSTb, CK1,
     icol4b, SE, SO20);
aibcr3_svt16_scdffcdn_cust I375 ( col5bc, SO18, RSTb, CK1,
     col5b, SE, SO17);
aibcr3_svt16_scdffcdn_cust I376 ( col6b, SO19, RSTb, CK1,
     icol6b, SE, SO18);
*/
// Row Combinatorial Logic
// -------------------------
assign row[0] = ~grey[2] & ~grey[1] & ~grey[0];
assign row[1] = ~grey[2] & ~grey[1];
assign row[2] = ~grey[2] & ~(grey[1] & ~grey[0]);
assign row[3] = ~grey[2];
assign row[4] = ~(grey[2] & ~(grey[1] & ~grey[0]));
assign row[5] = ~(grey[2] & ~grey[1]);
assign row[6] = ~(grey[2] & ~grey[1] & ~grey[0]);
assign row0b = ~row[0];
assign row1b = ~row[1];
assign row2b = ~row[2];
assign row3b = ~row[3];
assign row4b = ~row[4];
assign row5b = ~row[5];
assign row6b = ~row[6];

// Row Code Register
/*
aibcr3_svt16_scdffcdn_cust I336 ( row[0], SO0, RSTb, CK,
     row_combi[0], SE, iSI);
aibcr3_svt16_scdffcdn_cust I337 ( row[1], SO2, RSTb, CK,
     row_combi[1], SE, SO1);
aibcr3_svt16_scdffcdn_cust I342 ( row[2], SO4, RSTb, CK,
     row_combi[2], SE, SO3);
aibcr3_svt16_scdffcdn_cust I345 ( row[3], SO6, RSTb, CK,
     row_combi[3], SE, SO5);
aibcr3_svt16_scdffcdn_cust I347 ( row[4], SO8, RSTb, CK,
     row_combi[4], SE, SO7);
aibcr3_svt16_scdffcdn_cust I348 ( row[5], SO10, RSTb, CK,
     row_combi[5], SE, SO9);
aibcr3_svt16_scdffcdn_cust I351 ( row[6], SO12, RSTb, CK,
     row_combi[6], SE, SO11);

aibcr3_svt16_scdffcdn_cust I334 ( row0b, SO1, RSTb, CK,
     row_combi_invert[0], SE, SO0);
aibcr3_svt16_scdffcdn_cust I339 ( row1b, SO3, RSTb, CK,
     row_combi_invert[1], SE, SO2);
aibcr3_svt16_scdffcdn_cust I343 ( row2b, SO5, RSTb, CK,
     row_combi_invert[2], SE, SO4);
aibcr3_svt16_scdffcdn_cust I319 ( row3b, SO7, RSTb, CK,
     row_combi_invert[3], SE, SO6);
aibcr3_svt16_scdffcdn_cust I318 ( row4b, SO9, RSTb, CK,
     row_combi_invert[4], SE, SO8);
aibcr3_svt16_scdffcdn_cust I317 ( row5b, SO11, RSTb, CK,
     row_combi_invert[5], SE, SO10);
aibcr3_svt16_scdffcdn_cust I316 ( row6b, SO13, RSTb, CK,
     row_combi_invert[6], SE, SO12);

aibcr3_svt16_scdffcdn_cust I377 ( bgrey6c, SO20, RSTb,
     CK, grey[6], SE, SO19);
*/
assign bgrey6c = grey[6];
assign bgrey6b = !bgrey6c;


assign newcol[0] =  ~(col0   | bgrey6c);
assign newcol[1] =  ~(col1   | bgrey6c);
assign newcol[2] =  ~(col2   | bgrey6c);
assign newcol[3] =  ~(col3   | bgrey6c);
assign newcol[4] =  ~(col4b  | bgrey6c);
assign newcol[5] =  ~(col5bc | bgrey6c);
assign newcol[6] =  ~(col6b  | bgrey6c);

// Thermometer code generation

// column 0
assign  bk[0] = ~(newcol[0] & ~row0b);
assign  bk[1] = ~(newcol[0] & ~row1b);
assign  bk[2] = ~(newcol[0] & ~row2b);
assign  bk[3] = ~(newcol[0] & ~row3b);
assign  bk[4] = ~(newcol[0] & ~row4b);
assign  bk[5] = ~(newcol[0] & ~row5b);
assign  bk[6] = ~(newcol[0] & ~row6b);
assign  bk[7] = ~(bgrey6b   & ~col0);

// column 1
assign  bk[8] = ~(newcol[1] & ~(col0 & row[6]));
assign  bk[9] = ~(newcol[1] & ~(col0 & row[5]));
assign bk[10] = ~(newcol[1] & ~(col0 & row[4]));
assign bk[11] = ~(newcol[1] & ~(col0 & row[3]));
assign bk[12] = ~(newcol[1] & ~(col0 & row[2]));
assign bk[13] = ~(newcol[1] & ~(col0 & row[1]));
assign bk[14] = ~(newcol[1] & ~(col0 & row[0]));
assign bk[15] = ~(bgrey6b   & ~col1);

// column 2
assign bk[16] = ~(newcol[2] & ~(~newcol[1] & row0b));
assign bk[17] = ~(newcol[2] & ~(~newcol[1] & row1b));
assign bk[18] = ~(newcol[2] & ~(~newcol[1] & row2b));
assign bk[19] = ~(newcol[2] & ~(~newcol[1] & row3b));
assign bk[20] = ~(newcol[2] & ~(~newcol[1] & row4b));
assign bk[21] = ~(newcol[2] & ~(~newcol[1] & row5b));
assign bk[22] = ~(newcol[2] & ~(~newcol[1] & row6b));
assign bk[23] = ~(bgrey6b   & ~col2);

// column 3
assign bk[24] = ~(newcol[3] & ~(col2 & row[6]));
assign bk[25] = ~(newcol[3] & ~(col2 & row[5]));
assign bk[26] = ~(newcol[3] & ~(col2 & row[4]));
assign bk[27] = ~(newcol[3] & ~(col2 & row[3]));
assign bk[28] = ~(newcol[3] & ~(col2 & row[2]));
assign bk[29] = ~(newcol[3] & ~(col2 & row[1]));
assign bk[30] = ~(newcol[3] & ~(col2 & row[0]));
assign bk[31] = ~(bgrey6b   & ~col3);

// column 4
assign bk[32] = ~(newcol[4] & ~(~newcol[3] & row0b));
assign bk[33] = ~(newcol[4] & ~(~newcol[3] & row1b));
assign bk[34] = ~(newcol[4] & ~(~newcol[3] & row2b));
assign bk[35] = ~(newcol[4] & ~(~newcol[3] & row3b));
assign bk[36] = ~(newcol[4] & ~(~newcol[3] & row4b));
assign bk[37] = ~(newcol[4] & ~(~newcol[3] & row5b));
assign bk[38] = ~(newcol[4] & ~(~newcol[3] & row6b));
assign bk[39] = ~(bgrey6b   & ~col4b);

// column 5
assign bk[40] = ~(newcol[5] & ~(col4b & row[6]));
assign bk[41] = ~(newcol[5] & ~(col4b & row[5]));
assign bk[42] = ~(newcol[5] & ~(col4b & row[4]));
assign bk[43] = ~(newcol[5] & ~(col4b & row[3]));
assign bk[44] = ~(newcol[5] & ~(col4b & row[2]));
assign bk[45] = ~(newcol[5] & ~(col4b & row[1]));
assign bk[46] = ~(newcol[5] & ~(col4b & row[0]));
assign bk[47] = ~(bgrey6b   & ~col5bc);

// column 6
assign bk[48] = ~(newcol[6] & ~(~newcol[5] & row0b));
assign bk[49] = ~(newcol[6] & ~(~newcol[5] & row1b));
assign bk[50] = ~(newcol[6] & ~(~newcol[5] & row2b));
assign bk[51] = ~(newcol[6] & ~(~newcol[5] & row3b));
assign bk[52] = ~(newcol[6] & ~(~newcol[5] & row4b));
assign bk[53] = ~(newcol[6] & ~(~newcol[5] & row5b));
assign bk[54] = ~(newcol[6] & ~(~newcol[5] & row6b));
assign bk[55] = ~(bgrey6b   & ~col6b);

// column 7
assign bk[56] =  ~(bgrey6b & ~(col6b & row[6]));
assign bk[57] =  ~(bgrey6b & ~(col6b & row[5]));
assign bk[58] =  ~(bgrey6b & ~(col6b & row[4]));
assign bk[59] =  ~(bgrey6b & ~(col6b & row[3]));
assign bk[60] =  ~(bgrey6b & ~(col6b & row[2]));
assign bk[61] =  ~(bgrey6b & ~(col6b & row[1]));
assign bk[62] =  ~(bgrey6b & ~(col6b & row[0]));
assign bk[63] =  ~bgrey6b;


endmodule
