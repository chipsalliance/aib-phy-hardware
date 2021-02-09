// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// io_interp_mux_pair :   mux_sel latch and 8to1 mux
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

module io_interp_mux_pair (
input    [7:0] phy_clk_phs_gated,	// 8 phase 1.6GHz local clock
input          l_reset_n,        	// Active low reset
input    [2:0] mux_sel_a,        	// The gray code to control (even) of the 8 to 1 phase multiplexer
input    [2:0] mux_sel_b,        	// The gray code to control (odd ) of the 8 to 1 phase multiplexer
input    [7:0] slow_clk_ph_p,
input    [7:0] slow_clk_ph_n,
input	       test_enable_n,
input	       test_enable_frz,
input	       dft_mux_sel_p,
input	       dft_mux_sel_n,
output   [2:0] mux_sel_x_a,        	// The latched gray code to control (even) of the 8 to 1 phase multiplexer
output   [2:0] mux_sel_x_b,        	// The latched gray code to control (odd ) of the 8 to 1 phase multiplexer
output	       c_out_n,
output 	       c_out_n_buf,
output         c_out_p,
output         c_out_p_buf
);

`ifdef TIMESCALE_EN
                timeunit 1ps;
                timeprecision 1ps;
`endif

parameter  INV_DELAY      = 12;  // 10ps

wire   [2:0] mux_sel_x_a_buf;        	// The buffered gray code to control (even) of the 8 to 1 phase multiplexer
wire   [2:0] mux_sel_x_a_inv;        	// The inverted gray code to control (even) of the 8 to 1 phase multiplexer
wire   [2:0] mux_sel_x_b_buf;        	// The buffered gray code to control (even) of the 8 to 1 phase multiplexer
wire   [2:0] mux_sel_x_b_inv;        	// The inverted gray code to control (even) of the 8 to 1 phase multiplexer
wire	     clk_p_buf2;
wire	     clk_n_buf2;

io_interp_latch_in xlatch_in_x_a (
.l_reset_n	(l_reset_n		),	// Active low reset
.clk		(clk_p_buf2		),	// clock for latch
.mux_sel_in	(mux_sel_a[2:0]		),	// The gray code to control (even) of the 8 to 1 phase multiplexer
.mux_sel_latch	(mux_sel_x_a[2:0]	),	// latched gray code to control (even) of the 8 to 1 phase multiplexer
.mux_sel_buf	(mux_sel_x_a_buf[2:0]	),	// buffered gray code to control (even) of the 8 to 1 phase multiplexer
.mux_sel_inv	(mux_sel_x_a_inv[2:0]	)   
);

io_interp_latch_in xlatch_in_x_b (
.l_reset_n	(l_reset_n		),	// Active low reset
.clk		(clk_n_buf2		),	// clock for latch
.mux_sel_in	(mux_sel_b[2:0]		),	// The gray code to control (even) of the 8 to 1 phase multiplexer
.mux_sel_latch	(mux_sel_x_b[2:0]	),	// latched gray code to control (even) of the 8 to 1 phase multiplexer
.mux_sel_buf	(mux_sel_x_b_buf[2:0]	),	// buffered gray code to control (even) of the 8 to 1 phase multiplexer
.mux_sel_inv	(mux_sel_x_b_inv[2:0]	)   
);

io_interp_mux ximp0 ( 
.slow_clk_ph_p	(slow_clk_ph_p[7:0]		), 
.slow_clk_ph_n	(slow_clk_ph_n[7:0]		), 
.phy_clk_phs	(phy_clk_phs_gated[7:0]		), 
.gray_a_buf	(mux_sel_x_a_buf[2:0]		), 
.gray_b_buf	(mux_sel_x_b_buf[2:0]		), 
.gray_a_inv	(mux_sel_x_a_inv[2:0]		), 
.gray_b_inv	(mux_sel_x_b_inv[2:0]		), 
.c_out		(c_out_p			), 
.mux_out_b	(mux_out_b_p			), 
.test_enable_n	(test_enable_n			),	
.dft_mux_sel	(dft_mux_sel_p			)
);

io_interp_mux ximn0 (
.slow_clk_ph_p  ({slow_clk_ph_p[3:0],slow_clk_ph_p[7:4]}	),
.slow_clk_ph_n  ({slow_clk_ph_n[3:0],slow_clk_ph_n[7:4]}	),
.phy_clk_phs    ({phy_clk_phs_gated[3:0],phy_clk_phs_gated[7:4]}),
.gray_a_buf     (mux_sel_x_b_buf[2:0]           ),
.gray_b_buf     (mux_sel_x_a_buf[2:0]           ),
.gray_a_inv     (mux_sel_x_b_inv[2:0]           ),
.gray_b_inv     (mux_sel_x_a_inv[2:0]           ),
.c_out          (c_out_n                        ),
.mux_out_b	(mux_out_b_n			), 
.test_enable_n  (test_enable_n                  ),
.dft_mux_sel    (dft_mux_sel_n                  )
);

assign #(2 * INV_DELAY) c_out_p_buf   = mux_out_b_p | test_enable_frz;
assign #(2 * INV_DELAY) clk_p_buf2    = mux_out_b_p | test_enable_frz;
assign #(2 * INV_DELAY) c_out_n_buf   = mux_out_b_n | test_enable_frz;
assign #(2 * INV_DELAY) clk_n_buf2    = mux_out_b_n | test_enable_frz;

endmodule


