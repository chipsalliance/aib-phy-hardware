// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
//
// Revision:    $Revision: #1 $
// Date:        $DateTime: 2014/11/15 16:17:29 $
//------------------------------------------------------------------------
// Description: smaller size dq/dqs driver
//
//------------------------------------------------------------------------

module io_dq_clkdrv (
input          din_p,           	// 
input          din_n,           	//
output         dout_p,                  //
output         dout_n                  //
);

`ifdef TIMESCALE_EN
                timeunit 1ps;
                timeprecision 1ps;
`endif

parameter  INV_DELAY      = 15;  // 15ps

assign #(4 * INV_DELAY) dout_p = din_p;
assign #(4 * INV_DELAY) dout_n = din_n;

endmodule


