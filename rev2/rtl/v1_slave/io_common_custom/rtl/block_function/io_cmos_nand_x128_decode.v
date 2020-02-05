// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 

//---------------------------------------------------------------------------------------------------------------------------------------------
//  io_cmos_nand_x128_decode
//---------------------------------------------------------------------------------------------------------------------------------------------

module io_cmos_nand_x128_decode (
input   [6:0]   gray,
output  [127:0]  bk
);

wire [5:0]  b_gray;

assign b_gray[5] = ~gray[5] & gray[6];
assign b_gray[4:0] = gray[4:0] & {5{gray[6]}};

io_cmos_nand_x64_decode xdec_0 (
.gray	    ( gray[6:0]		),
.bk	    ( bk[63:0]		)
);

io_cmos_nand_x64_decode xdec_1 (
.gray	    ( {1'b0, b_gray[5:0]}	),
.bk	    ( bk[127:64]		)
);

endmodule



