// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
//
// Revision:    $Revision: #2 $
// Date:        $DateTime: 2014/10/18 21:47:06 $
//------------------------------------------------------------------------
// Description: Delay cell used to match the delay of the interpolator
//
//------------------------------------------------------------------------

module io_min_output (
input    [1:0] interp_clk_x,     // clock generated from min_ip16phs
input          test_enable_n,    // Active low test enable
input          pon,              // cross coupling enable p finger
input          non,              // cross coupling enable n finger
input          enable,           // latch enable
input          svcc,             // soft tie vcc
output   [1:0] int_clk_out       // 
);

`ifdef TIMESCALE_EN
                timeunit 1ps;
                timeprecision 1ps;
`endif

wire  [1:0]  interp_clk;

//=================================================================================================================================================================================
// 
//=================================================================================================================================================================================

assign interp_clk = interp_clk_x[1:0];

an_io_double_edge_ff xdouble_edge_ff (
.clk_in     	( interp_clk[1:0]	),
.test_enable_n  ( test_enable_n   	),
.reset_n    	( enable         	),
.data_in    	( 2'b01          	),  // pass through
.data_out   	( int_clk_out[1:0]   	)
);

endmodule


