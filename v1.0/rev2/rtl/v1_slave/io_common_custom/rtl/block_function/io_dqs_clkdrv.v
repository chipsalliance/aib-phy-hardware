// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
//
// Revision:    $Revision: #1 $
// Date:        $DateTime: 2014/11/15 16:17:29 $
//------------------------------------------------------------------------
// Description: big size dqs driver
//
//------------------------------------------------------------------------

module io_dqs_clkdrv (
input          cin_p,           	// 
input          cin_n,           	//
output         cout_p,                  //
output         cout_n                  //
);

`ifdef TIMESCALE_EN
                timeunit 1ps;
                timeprecision 1ps;
`endif

parameter  INV_DELAY      = 15;  // 15ps

assign #(4 * INV_DELAY) cout_p = cin_p;
assign #(4 * INV_DELAY) cout_n = cin_n;

endmodule


