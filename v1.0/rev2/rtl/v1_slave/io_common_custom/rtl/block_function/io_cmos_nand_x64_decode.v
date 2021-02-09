// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 

//---------------------------------------------------------------------------------------------------------------------------------------------
//  io_cmos_nand_x64_decode
//---------------------------------------------------------------------------------------------------------------------------------------------

module io_cmos_nand_x64_decode (
input   [6:0]   gray,
output  [63:0]  bk
);

`ifdef TIMESCALE_EN
                timeunit 1ps;
                timeprecision 1ps;
`endif

parameter   NAND_DELAY = 20;

wire  [6:0]  col;
wire  [6:0]  row;
wire  [6:0]  newcol;

assign col[0] =  gray[5] | gray[4] | gray[3];
assign col[1] =  gray[5] | gray[4];
assign col[2] =  gray[5] | ~(~gray[4] | gray[3]);
assign col[3] =  gray[5];
assign col[4] = ~gray[5] | ~(~gray[4] | gray[3]);
assign col[5] = ~gray[5] | gray[4];
assign col[6] = ~gray[5] | gray[4] | gray[3];

assign row[0] = ~gray[2] & ~gray[1] & ~gray[0];
assign row[1] = ~gray[2] & ~gray[1];
assign row[2] = ~gray[2] & ~(gray[1] & ~gray[0]);
assign row[3] = ~gray[2];
assign row[4] = ~(gray[2] & ~(gray[1] & ~gray[0]));
assign row[5] = ~(gray[2] & ~gray[1]);
assign row[6] = ~(gray[2] & ~gray[1] & ~gray[0]);

assign newcol[0] =  ~(col[0] | gray[6]);
assign newcol[1] =  ~(col[1] | gray[6]);
assign newcol[2] =  ~(col[2] | gray[6]);
assign newcol[3] =  ~(col[3] | gray[6]);
assign newcol[4] =  ~(~col[4] | gray[6]);
assign newcol[5] =  ~(~col[5] | gray[6]);
assign newcol[6] =  ~(~col[6] | gray[6]);

assign  bk[0] = ~(newcol[0] & row[0]);
assign  bk[1] = ~(newcol[0] & row[1]);
assign  bk[2] = ~(newcol[0] & row[2]);
assign  bk[3] = ~(newcol[0] & row[3]);
assign  bk[4] = ~(newcol[0] & row[4]);
assign  bk[5] = ~(newcol[0] & row[5]);
assign  bk[6] = ~(newcol[0] & row[6]);
assign  bk[7] =  ~newcol[0];
assign  bk[8] = ~(newcol[1] & ~(col[0] & row[6]));
assign  bk[9] = ~(newcol[1] & ~(col[0] & row[5]));
assign bk[10] = ~(newcol[1] & ~(col[0] & row[4]));
assign bk[11] = ~(newcol[1] & ~(col[0] & row[3]));
assign bk[12] = ~(newcol[1] & ~(col[0] & row[2]));
assign bk[13] = ~(newcol[1] & ~(col[0] & row[1]));
assign bk[14] = ~(newcol[1] & ~(col[0] & row[0]));
assign bk[15] =  ~newcol[1];
assign bk[16] = ~(newcol[2] & (~col[1] | row[0]));
assign bk[17] = ~(newcol[2] & (~col[1] | row[1]));
assign bk[18] = ~(newcol[2] & (~col[1] | row[2]));
assign bk[19] = ~(newcol[2] & (~col[1] | row[3]));
assign bk[20] = ~(newcol[2] & (~col[1] | row[4]));
assign bk[21] = ~(newcol[2] & (~col[1] | row[5]));
assign bk[22] = ~(newcol[2] & (~col[1] | row[6]));
assign bk[23] =  ~newcol[2];
assign bk[24] = ~(newcol[3] & ~(col[2] & row[6]));
assign bk[25] = ~(newcol[3] & ~(col[2] & row[5]));
assign bk[26] = ~(newcol[3] & ~(col[2] & row[4]));
assign bk[27] = ~(newcol[3] & ~(col[2] & row[3]));
assign bk[28] = ~(newcol[3] & ~(col[2] & row[2]));
assign bk[29] = ~(newcol[3] & ~(col[2] & row[1]));
assign bk[30] = ~(newcol[3] & ~(col[2] & row[0]));
assign bk[31] =  ~newcol[3];
assign bk[32] = ~(newcol[4] & (~col[3] | row[0]));
assign bk[33] = ~(newcol[4] & (~col[3] | row[1]));
assign bk[34] = ~(newcol[4] & (~col[3] | row[2]));
assign bk[35] = ~(newcol[4] & (~col[3] | row[3]));
assign bk[36] = ~(newcol[4] & (~col[3] | row[4]));
assign bk[37] = ~(newcol[4] & (~col[3] | row[5]));
assign bk[38] = ~(newcol[4] & (~col[3] | row[6]));
assign bk[39] =  ~newcol[4];
assign bk[40] = ~(newcol[5] & ~(~col[4] & row[6]));
assign bk[41] = ~(newcol[5] & ~(~col[4] & row[5]));
assign bk[42] = ~(newcol[5] & ~(~col[4] & row[4]));
assign bk[43] = ~(newcol[5] & ~(~col[4] & row[3]));
assign bk[44] = ~(newcol[5] & ~(~col[4] & row[2]));
assign bk[45] = ~(newcol[5] & ~(~col[4] & row[1]));
assign bk[46] = ~(newcol[5] & ~(~col[4] & row[0]));
assign bk[47] =  ~newcol[5];
assign bk[48] = ~(newcol[6] & ( col[5] | row[0]));
assign bk[49] = ~(newcol[6] & ( col[5] | row[1]));
assign bk[50] = ~(newcol[6] & ( col[5] | row[2]));
assign bk[51] = ~(newcol[6] & ( col[5] | row[3]));
assign bk[52] = ~(newcol[6] & ( col[5] | row[4]));
assign bk[53] = ~(newcol[6] & ( col[5] | row[5]));
assign bk[54] = ~(newcol[6] & ( col[5] | row[6]));
assign bk[55] =  ~newcol[6];
assign bk[56] =  gray[6] | (~col[6] & row[6]);
assign bk[57] =  gray[6] | (~col[6] & row[5]);
assign bk[58] =  gray[6] | (~col[6] & row[4]);
assign bk[59] =  gray[6] | (~col[6] & row[3]);
assign bk[60] =  gray[6] | (~col[6] & row[2]);
assign bk[61] =  gray[6] | (~col[6] & row[1]);
assign bk[62] =  gray[6] | (~col[6] & row[0]);
assign bk[63] =  gray[6];

endmodule



