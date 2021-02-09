// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// io_interp_misc :   misc block for interpolator
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

module io_interp_misc (
input          reset_n,          	// Active low reset
input          test_enable,      	// Active high test enable    1: avoid tristate on output of interp_mux during testing
input          nfrzdrv,          	// for power domain crossing protection
input          couple_enable,    	// cross coupling enable
input          filter_code,      	// borrowed from filter_code[0] for test
input          clk_p_buf0,       	// Clock for pnr int_clk
input    [1:0] int_clk_out,      	// interpolator clock for pnr/dpa
input    [7:0] phy_clk_phs,      	// 8 phase 1.6GHz local clock
output   [7:0] slow_clk_ph_p,    	// 8 phase 1.6GHz local clock
output   [7:0] slow_clk_ph_n,    	// 8 phase 1.6GHz local clock
output         test_enable_buf,  	// Active high test enable    1: avoid tristate on output of interp_mux during testing
output         test_enable_frz,  	// Active high test enable    1: avoid tristate on output of interp_mux during testing
output         test_enable_n,    	// Active low test enable    0: avoid tristate on output of interp_mux during testing
output         l_reset_n,        	// Active low reset
output   [1:0] clk_out,			// interpolator clock for pnr/dpa
output         dft_mux_sel_n,        	// for test
output         dft_mux_sel_p,        	// for test
output         pon,        		// cross couple control for p fingers
output         non,        		// cross couple control for n fingers
output         int_clk	                // Clock for the counter
);

`ifdef TIMESCALE_EN
                timeunit 1ps;
                timeprecision 1ps;
`endif

parameter  INV_DELAY      = 15;  // 15ps
parameter  LATCH_DELAY    = 50;  // 50ps
parameter  BUF_DELAY      = 25;  // 25ps
parameter  MUX_DELAY      = 50;  // 50ps

wire	   test_rst_p;
wire	   test_rst_n;

assign #(2 * INV_DELAY) clk_out[1:0] = int_clk_out[1:0] & {2{nfrzdrv}};
assign #(2 * INV_DELAY) int_clk = clk_p_buf0 & nfrzdrv;
assign l_reset_n = reset_n;
assign test_enable_n        = ~test_enable;
assign test_enable_buf      = ~test_enable_n;
assign test_enable_frz      = ~(test_enable_n & nfrzdrv);
assign test_rst_n           = test_enable_n & reset_n;
assign test_rst_p           = ~test_rst_n;
assign #(3 * INV_DELAY) slow_clk_ph_p[7:0] = phy_clk_phs[7:0] | {8{test_rst_p}} | {8{~nfrzdrv}};
assign #(3 * INV_DELAY) slow_clk_ph_n[7:0] = phy_clk_phs[7:0] & {8{test_rst_n}} & {8{nfrzdrv}};
assign dft_mux_sel_p        = ~(~filter_code & test_enable_buf);
assign dft_mux_sel_n        = ~(filter_code & test_enable_buf);
assign non	    	    = couple_enable & test_enable_n;
assign pon	    	    = ~non;

endmodule


