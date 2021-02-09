// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// io_interp_output :   Output Frequency = phy_clk_phs frequency
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

module io_interp_output (
input          clk_n_buf0,
input          clk_n_buf2,
input          clk_p_buf0,
input          clk_p_buf2,
input    [1:0] dirty_clk,        // The divided clock outputs with a duty cycle that is not 50%, The Interpolator will modify this clock to 50% duty cycle
input          enable,           // Active high enable    0 = Force interpolator_clk[1:0] to 2'b10
input    [1:0] interp_clk_x,     // interpolator clk after ip16phs
input          reset_n,          // Active low reset
input          test_enable_n,    // Active low test enable
input          pon,		 // cross coupling enable p finger
input          non,		 // cross coupling enable n finger
output   [1:0] int_clk_out,      // Complimentary Clock output sent to the dqs_lgc_pnr/ioereg_pnr
output   [1:0] interpolator_clk  // Complimentary Clock output sent to the ioereg
);

`ifdef TIMESCALE_EN
                timeunit 1ps;
                timeprecision 1ps;
`endif

parameter  INV_DELAY      = 15;  // 15ps
parameter  LATCH_DELAY    = 50;  // 50ps
parameter  BUF_DELAY      = 25;  // 25ps
parameter  MUX_DELAY      = 50;  // 50ps

reg  [1:0] dirty_clk_int;
reg  [1:0] dirty_clk_out;
wire [1:0] interp_clk;

//=========================================================================================================================================================================
// output merge, clock divider & interpolator
//=========================================================================================================================================================================

always @(*)
  if (~reset_n)          dirty_clk_int[0] <= #LATCH_DELAY 1'b0;
  else if (clk_n_buf0)   dirty_clk_int[0] <= #LATCH_DELAY ~dirty_clk[0];

always @(*)
  if (~reset_n)          dirty_clk_int[1] <= #LATCH_DELAY 1'b0;
  else if (clk_p_buf0)   dirty_clk_int[1] <= #LATCH_DELAY dirty_clk[1];

always @(*)
  if (~reset_n)          dirty_clk_out[0] <= #LATCH_DELAY 1'b0;
  else if (clk_n_buf2)   dirty_clk_out[0] <= #LATCH_DELAY dirty_clk_int[0];

always @(*)
  if (~reset_n)          dirty_clk_out[1] <= #LATCH_DELAY 1'b0;
  else if (clk_p_buf2)   dirty_clk_out[1] <= #LATCH_DELAY dirty_clk_int[1];

assign interp_clk = interp_clk_x[1:0];

an_io_double_edge_ff xdouble_edge_ff (
.clk_in      	( interp_clk[1:0]     ),
.reset_n     	( enable              ),
.test_enable_n  ( test_enable_n       ),
.data_in     	( {dirty_clk_out[1],~dirty_clk_out[0]} ),
.data_out    	( int_clk_out[1:0]    )
);

assign interpolator_clk[1:0] = int_clk_out[1:0];  // needs a balanced buffer to keep the matched timing for clk_out[1:0] signals

endmodule


