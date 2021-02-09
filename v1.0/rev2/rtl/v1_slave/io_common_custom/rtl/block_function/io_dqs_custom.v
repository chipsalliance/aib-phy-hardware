// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//====================================================================
// Module     : io_dqs_lgc_top
// Filename   : io_dqs_lgc_top.v
// Description: DQS Logic Block
// Note       :
//
//====================================================================

module io_dqs_custom (
   input   [7:0] phy_clk_phs,          // PLL      : full rate 8 phase clock
   input   [1:0] dqs_clean_a,          // DQS   : DQS complimentary output after the clean up gate
   input   [1:0] dqs_clean_b,          // DQS   : DQS complimentary output after the clean up gate
   input         x128_osc_in_p,        // DLL    : input for the x64 ring oscillator
   input         x128_osc_in_n,        // DLL    : input for the x64 ring oscillator
   output        x128_osc_out_p,       // IOEREG : output for the x64 ring oscillator
   output        x128_osc_out_n,       // IOEREG : output for the x64 ring oscillator
   output        x128_osc_lca_p,       // x128 ring oscillator A
   output        x128_osc_lca_n,       // x128 ring oscillator A
   input         x128_osc_lcb_p,       // x128 ring oscillator B
   input         x128_osc_lcb_n,       // x128 ring oscillator B
   input   [6:0] dqs_f_gray_a,         // delay control of "a" delay chain ( NAND chain )
   input   [2:0] dqs_i_gray_a,         // delay control of "a" delay chain ( Interpolator )
   input   [3:0] dqs_rise_gray_a,      // Delay : Gray code rising edge dcc setting
   input   [3:0] dqs_fall_gray_a,      // Delay : Gray code falling edge dcc setting
   input   [6:0] dqs_f_gray_b,         // delay control of "b" delay chain ( NAND chain )
   input   [2:0] dqs_i_gray_b,         // delay control of "b" delay chain ( Interpolator )
   input   [3:0] dqs_rise_gray_b,      // Delay : Gray code rising edge dcc setting
   input   [3:0] dqs_fall_gray_b,      // Delay : Gray code falling edge dcc setting
   input         osc_mode,             // Mux control for the x64 ring oscillator, 1 = osc test, 0 = normal
   output  [1:0] dqs_out_a,            // DQS tree : DQS complimentary clock to the DQS clock tree   -- dqs_clk_a[1] = dqs+,  dqs_clk_a[0] = dqs-
   output  [1:0] dqs_out_b,            // DQS tree : DQS complimentary clock to the DQS clock tree   -- dqs_clk_a[1] = dqs+,  dqs_clk_a[0] = dqs-
   input         nfrzdrv,
   input         reset_n,              // Reset block : System reset active low
   input   [2:0] power_down_n,         // 0 = power down, 1 = power up
   input   [1:0] rb_filter_code,       // 00 = 1.6 GHz, 01 = 1.2 GHz, 10 = 1.0 GHz, 11 = 0.8 GHz ( Interpolator filter setting )
   input   [2:0] mux_sel_a_a,          // The gray code to control (even) of the 8 to 1 phase multiplexer
   input   [2:0] mux_sel_b_a,          // The gray code to control (odd ) of the 8 to 1 phase multiplexer
   input   [3:0] interp_sel_a_a,       // The gray code output to control the interpolator
   input   [3:0] interp_sel_b_a,       // The gray code output to control the interpolator
   input   [1:0] dirty_clk_out_a,      // pass through code is 2'b01, disable code is 2'b00, divider is dynamic
   output        int_clk_a,            // Clocks from the output of the 3 (8 to 1 phase select multiplexers)  clk_p[0] arrives first, clk_p[2] arrives last
   output  [1:0] interp_clk_out_a,     // Complimentary Clock output
   input   [2:0] mux_sel_a_b,          // The gray code to control (even) of the 8 to 1 phase multiplexer
   input   [2:0] mux_sel_b_b,          // The gray code to control (odd ) of the 8 to 1 phase multiplexer
   input   [3:0] interp_sel_a_b,       // The gray code output to control the interpolator
   input   [3:0] interp_sel_b_b,       // The gray code output to control the interpolator
   input   [1:0] dirty_clk_out_b,      // pass through code is 2'b01, disable code is 2'b00, divider is dynamic
   output        int_clk_b,            // Clocks from the output of the 3 (8 to 1 phase select multiplexers)  clk_p[0] arrives first, clk_p[2] arrives last
   output  [1:0] interp_clk_out_b,     // Complimentary Clock output
   input         test_enable,          // Active high test enable    1: avoid tristate on output of interp_mux during testing
   input         rb_couple_enable,     // Active high cross couple enable
   output  [7:0] phy_clk_phs_lane_out, // domain crossed and buffered phy_clk_phs
   output        clk_ph_1_buf,         // min-delayed phy_clk_phs[0], used by the io_dqs_en_path and ioereg write fifo for clock domain crossing
   output        clk_ph_3_buf          // min-delayed phy_clk_phs[2], used by the io_dqs_en_path and ioereg write fifo for clock domain crossing
);

`ifdef TIMESCALE_EN
  timeunit 1ps;
  timeprecision 1ps;
`endif

//================================================================================================================================================================
//  wire & reg
//================================================================================================================================================================

   wire    [1:0] dqs_out_a_int;        // DQS tree before dcc: DQS complimentary clock to the DQS clock tree   -- dqs_clk_a[1] = dqs+,  dqs_clk_a[0] = dqs-
   wire    [1:0] dqs_out_b_int;        // DQS tree before dcc: DQS complimentary clock to the DQS clock tree   -- dqs_clk_a[1] = dqs+,  dqs_clk_a[0] = dqs-

//=========================================================================================================================================================================
//  Delay chain
//=========================================================================================================================================================================

io_nand_x128_delay_line xio_nand_x128_delay_line_a (
.nfrzdrv       ( nfrzdrv             ),
.in_p          ( dqs_clean_a[1]      ),
.in_n          ( dqs_clean_a[0]      ),
.osc_mode      ( osc_mode            ),
.osc_in_p      ( x128_osc_in_p       ),
.osc_in_n      ( x128_osc_in_n       ),
.osc_out_p     ( x128_osc_lca_p      ),
.osc_out_n     ( x128_osc_lca_n      ),
.f_gray        ( dqs_f_gray_a[6:0]   ),
.i_gray        ( dqs_i_gray_a[2:0]   ),
.out_p         ( dqs_out_a_int[0]    ),     // Swap, invert the output here
.out_n         ( dqs_out_a_int[1]    )      // Swap, invert the output here
);

io_nand_x128_delay_line xio_nand_x128_delay_line_b (
.nfrzdrv       ( nfrzdrv             ),
.in_p          ( dqs_clean_b[1]      ),
.in_n          ( dqs_clean_b[0]      ),
.osc_mode      ( osc_mode            ),
.osc_in_p      ( x128_osc_lcb_p      ),
.osc_in_n      ( x128_osc_lcb_n      ),
.osc_out_p     ( x128_osc_out_p      ),
.osc_out_n     ( x128_osc_out_n      ),
.f_gray        ( dqs_f_gray_b[6:0]   ),
.i_gray        ( dqs_i_gray_b[2:0]   ),
.out_p         ( dqs_out_b_int[0]    ),     // Swap, invert the output here
.out_n         ( dqs_out_b_int[1]    )      // Swap, invert the output here
);

//=========================================================================================================================================================================
//  Phase interpolator
//=========================================================================================================================================================================

io_phs_gated xio_phs_gated (
.nfrzdrv           ( nfrzdrv                    ), // active low
.phy_clk_phs       ( phy_clk_phs[7:0]        	), // 8 phase 1.6GHz local clock
.phy_clk_phs_gated ( phy_clk_phs_lane_out[7:0]	)  // gated 8 phase 1.6GHz local clock
);

io_interpolator xio_interpolator_a (
.reset_n          ( reset_n                  ),
.nfrzdrv          ( nfrzdrv                  ),
.pdn              ( power_down_n[0]          ), // power down active low
.phy_clk_phs      ( phy_clk_phs_lane_out[7:0]), // 8 phase 1.6GHz local clock
.rb_filter_code   ( rb_filter_code[1:0]      ), // LANE CSR : 00 = 1.6 GHz, 01 = 1.2 GHz, 10 = 1.0 GHz, 11 = 0.8 GHz ( Interpolator filter setting )
.mux_sel_a        ( mux_sel_a_a[2:0]         ), // The gray code to control (even) of the 8 to 1 phase multiplexer
.mux_sel_b        ( mux_sel_b_a[2:0]         ), // The gray code to control (odd ) of the 8 to 1 phase multiplexer
.interp_sel_a     ( interp_sel_a_a[3:0]      ), // The gray code output to control the interpolator
.interp_sel_b     ( interp_sel_b_a[3:0]      ), // The gray code output to control the interpolator
.dirty_clk        ( dirty_clk_out_a[1:0]     ), // pass through code is 2'b01, disable code is 2'b00, divider is dynamic
.enable           ( nfrzdrv                  ), // Active high enable    0 = Force interpolator_clk[1:0] to 2'b10
.test_enable      ( test_enable              ), //
.rb_couple_enable ( rb_couple_enable         ), //
.int_clk          ( int_clk_a                ), // Clock for the counter
.clk_out          ( interp_clk_out_a[1:0]    ), // Complimentary Clock output sent to the dqs_lgc_pnr
.interpolator_clk ( 			     )  // Complimentary Clock output sent to the pstamble_reg, not used any more since pstabmle in pnr now
);

io_interpolator xio_interpolator_b (
.reset_n          ( reset_n                  ),
.nfrzdrv          ( nfrzdrv                  ),
.pdn              ( power_down_n[1]          ), // power down active low
.phy_clk_phs      ( phy_clk_phs_lane_out[7:0]), // 8 phase 1.6GHz local clock
.rb_filter_code   ( rb_filter_code[1:0]      ), // LANE CSR : 00 = 1.6 GHz, 01 = 1.2 GHz, 10 = 1.0 GHz, 11 = 0.8 GHz ( Interpolator filter setting )
.mux_sel_a        ( mux_sel_a_b[2:0]         ), // The gray code to control (even) of the 8 to 1 phase multiplexer
.mux_sel_b        ( mux_sel_b_b[2:0]         ), // The gray code to control (odd ) of the 8 to 1 phase multiplexer
.interp_sel_a     ( interp_sel_a_b[3:0]      ), // The gray code output to control the interpolator
.interp_sel_b     ( interp_sel_b_b[3:0]      ), // The gray code output to control the interpolator
.dirty_clk        ( dirty_clk_out_b[1:0]     ), // pass through code is 2'b01, disable code is 2'b00, divider is dynamic
.enable           ( nfrzdrv                  ), // Active high enable    0 = Force interpolator_clk[1:0] to 2'b10
.test_enable      ( test_enable              ), //
.rb_couple_enable ( rb_couple_enable         ), //
.int_clk          ( int_clk_b                ), // Clock for the counter
.clk_out          ( interp_clk_out_b[1:0]    ), // Complimentary Clock output sent to the dqs_lgc_pnr
.interpolator_clk ( 			     )  // Complimentary Clock output sent to the pstamble_reg, not used any more since pstabmle in pnr now
);

io_min_inter xio_min_inter_1 (
.phy_clk_phs      ( phy_clk_phs_lane_out[7:0]),
.rb_filter_code   ( rb_filter_code[1:0]      ),
.test_enable      ( test_enable              ), 
.rb_couple_enable ( rb_couple_enable         ), 
.nfrzdrv          ( nfrzdrv                  ), 
.pdn              ( power_down_n[2]          ), 
.c_out            ( clk_ph_1_buf 	     )
);

io_min_inter xio_min_inter_3 (
.phy_clk_phs      ( {phy_clk_phs_lane_out[1:0], phy_clk_phs_lane_out[7:2]}   ),
.rb_filter_code   ( rb_filter_code[1:0]      ),
.test_enable      ( test_enable              ), 
.rb_couple_enable ( rb_couple_enable         ), 
.nfrzdrv          ( nfrzdrv                  ), 
.pdn              ( power_down_n[2]          ), 
.c_out            ( clk_ph_3_buf 	     )
);

io_delay_line_dcc xio_delay_line_dcc_a (
.c_in_p           ( dqs_out_a_int[0]   	     ),
.c_in_n        	  ( dqs_out_a_int[1]         ),
.f_gray        	  ( dqs_fall_gray_a[3:0]     ),
.r_gray        	  ( dqs_rise_gray_a[3:0]     ),
.c_out_p       	  ( dqs_out_a[0]       	     ),
.c_out_n       	  ( dqs_out_a[1]             )
);

io_delay_line_dcc xio_delay_line_dcc_b (
.c_in_p           ( dqs_out_b_int[0]   	     ),
.c_in_n        	  ( dqs_out_b_int[1]         ),
.f_gray        	  ( dqs_fall_gray_b[3:0]     ),
.r_gray        	  ( dqs_rise_gray_b[3:0]     ),
.c_out_p       	  ( dqs_out_b[0]       	     ),
.c_out_n       	  ( dqs_out_b[1]             )
);

endmodule
