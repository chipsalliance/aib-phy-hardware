// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
//
// Revision:    $Revision: #2 $
// Date:        $DateTime: 2014/10/18 21:47:06 $
//------------------------------------------------------------------------
// Description: interpolator mux match cell
//
//------------------------------------------------------------------------

module io_interp_mux_match (

input  [7:0] phy_clk_phs,   	// 8 phase 1.6GHz clock
input  [7:0] slow_clk_ph_p, 	// 8 phase 1.6GHz clock combined with reset
input  [7:0] slow_clk_ph_n, 	// 8 phase 1.6GHz clock combined with reset
input  [2:0] gray_a_buf,    	// Mux select A
input  [2:0] gray_a_inv,    	// inverted Mux select A
input  [2:0] gray_b_buf,    	// Mux select B
input  [2:0] gray_b_inv,    	// inverted Mux select B
input        nfrzdrv, 		// active low test enable
input        test_enable_n, 	// active low test enable
input        dft_mux_sel,   	// mux selection during test
output       int_clk_out     	// 1 of the 3 output phases, sent to the counter
);

wire	     int_clk_out_x;
wire	     mux_out_b;

io_interp_mux xinterp_mux ( 
.slow_clk_ph_p		(slow_clk_ph_p[7:0]	), 
.slow_clk_ph_n		(slow_clk_ph_n[7:0]	), 
.phy_clk_phs		(phy_clk_phs[7:0]	), 
.gray_a_buf		(gray_a_buf[2:0]	), 
.gray_b_buf		(gray_b_buf[2:0]	), 
.gray_a_inv		(gray_a_inv[2:0]	), 
.gray_b_inv		(gray_b_inv[2:0]	), 
.c_out			(			), 
.mux_out_b		(mux_out_b		), 
.test_enable_n		(test_enable_n		),  
.dft_mux_sel		(dft_mux_sel		)
);

assign int_clk_out_x = ~nfrzdrv | mux_out_b;
assign int_clk_out = int_clk_out_x;

endmodule

