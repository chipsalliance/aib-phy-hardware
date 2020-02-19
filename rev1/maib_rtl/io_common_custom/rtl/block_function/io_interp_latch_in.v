// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// io_interp_latch_in :   mux_sel latches
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

module io_interp_latch_in (
input             l_reset_n,        	// Active low reset
input             clk,      	 	// clock for latch
input       [2:0] mux_sel_in,       	// The gray code to control (even) of the 8 to 1 phase multiplexer
output reg  [2:0] mux_sel_latch,    	// latched gray code to control (even) of the 8 to 1 phase multiplexer
output 	    [2:0] mux_sel_buf,    	// buffered gray code to control (even) of the 8 to 1 phase multiplexer
output 	    [2:0] mux_sel_inv    	// inverted gray code to control (even) of the 8 to 1 phase multiplexer
);

`ifdef TIMESCALE_EN
                timeunit 1ps;
                timeprecision 1ps;
`endif

parameter  INV_DELAY      = 15;  // 15ps
parameter  LATCH_DELAY    = 50;  // 50ps
parameter  BUF_DELAY      = 25;  // 25ps
parameter  MUX_DELAY      = 50;  // 50ps

//=========================================================================================================================================================================
// io_interpolator_mux selects 3 of the 8 input clock phases (A complimentary set) 
//=========================================================================================================================================================================

always @(*) 
  if (~l_reset_n)         mux_sel_latch[2:0] <= #LATCH_DELAY 3'h0;
  else if (clk) mux_sel_latch[2:0] <= #LATCH_DELAY mux_sel_in[2:0];

assign mux_sel_buf = mux_sel_latch[2:0];
assign mux_sel_inv = ~mux_sel_latch[2:0];

endmodule


