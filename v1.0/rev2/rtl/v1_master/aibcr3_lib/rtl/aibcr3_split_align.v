// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
// Copyright (c) 2012 Altera Corporation. .
//
//------------------------------------------------------------------------
// File:        $RCSfile: aibcr3_split_align.v $
// Revision:    $Revision: 1 $
// Date:        $DateTime: 2018/03/12 15:24:07 $
//------------------------------------------------------------------------
// Description: gated 8 clock phases for powerdown and regulator power domain crossing
//
//------------------------------------------------------------------------

module aibcr3_split_align (
input          din,           		// input
output         dout_p,           	// splitted output positive
output         dout_n           	// splitted output negative
);

`ifdef TIMESCALE_EN
                timeunit 1ps;
                timeprecision 1ps;
`endif

parameter  INV_DELAY      = 15;  // 15ps

assign #(2 * INV_DELAY) dout_p = din;
assign #(2 * INV_DELAY) dout_n = ~din;

endmodule



