// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 

module io_ioereg_custom (
   input   [1:0] data_dq_in,           // I/O  : DQ complimentary inputs from the I/O cell sent to delay chain  -- dq_in[1] = dq+
   input   [1:0] data_dqb_in,          // I/O  : DQ complimentary inputs from the I/O cell sent to delay chain  -- dq_in[0] = dq-
   input         x64_osc_in_p,         // input for the x64 ring oscillator
   input         x64_osc_in_n,         // input for the x64 ring oscillator
   output        x64_osc_out_p,        // output for the x64 ring oscillator
   output        x64_osc_out_n,        // output for the x64 ring oscillator
   input         x64_osc_mode,         // Mux control for the x64 ring oscillator, 1 = osc test, 0 = normal
   input         nfrzdrv,
   input  [11:0] dq_f_gray,            // Delay : Gray code DQ delay setting used by the NAND delay line
   input   [5:0] dq_i_gray,            // Delay : Gray code DQ delay setting used by the NAND delay line (interpolator)
   input   [7:0] dq_rise_gray,         // Delay : Gray code rising edge dcc setting
   input   [7:0] dq_fall_gray,         // Delay : Gray code falling edge dcc setting
   output  [3:0] dq_in_del,            // dq input path, the output of the delay chain going to the DQ dummy tree, to match DQS tree delays
   input   [7:0] phy_clk_phs,          // PLL      : full rate 8 phase clock
   input   [1:0] rb_filter_code,       // DQS LGC  : 00 = 1.6 GHz, 01 = 1.2 GHz, 10 = 1.0 GHz, 11 = 0.8 GHz ( Interpolator filter setting )
   input         test_enable,          // Active high test enable    1: avoid tristate on output of interp_mux during testing
   input         rb_couple_enable,     // Active high cross couple enable
   input   [1:0] power_down_n,         // 0 = power down, 1 = power up
   input   [5:0] mux_sel_a,            // The gray code to control (even) of the 8 to 1 phase multiplexer
   input   [5:0] mux_sel_b,            // The gray code to control (odd ) of the 8 to 1 phase multiplexer
   input   [7:0] interp_sel_a,         // The gray code output to control (even) the interpolator
   input   [7:0] interp_sel_b,         // The gray code output to control (odd ) the interpolator
   input   [3:0] dirty_clk,            // pass through code is 2'b01, disable code is 2'b00, divider is dynamic
   input   [1:0] interp_enable,        // 0 = GPIO mode,  1 = DDR mode
   output  [1:0] int_clk,              // Clocks from the output of the 3 (8 to 1 phase select multiplexers)  clk_p[0] arrives first, clk_p[2] arrives last
   output  [3:0] interp_clk_out,       // Complimentary Clock output sent to io_ioereg_pnr & DPA
   output  [3:0] interpolator_clk      // Complimentary Clock output sent to io_ioereg_struct 
);

`ifdef TIMESCALE_EN
                timeunit 1ps;
                timeprecision 1ps;
`endif

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// reg & wire
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

   wire    [3:0] dq_in_del_int;        // output of delay line before dcc
   wire          x64_osc_p;            // input for the x64 ring oscillator
   wire          x64_osc_n;            // input for the x64 ring oscillator

//================================================================================================================================================================
//  Delay chain & phase interpolator
//   assign dirty_clk[1:0] = phy_mode_out ? 2'b00 : 2'b01;
//================================================================================================================================================================

io_interpolator xio_interpolator_0 (
.reset_n          ( nfrzdrv		      ),
.pdn              ( power_down_n[0]           ), // power down active low
.nfrzdrv          ( nfrzdrv	              ), // active low
.phy_clk_phs      ( phy_clk_phs[7:0]          ), // PLL  : 8 phase 1.6GHz local clock
.rb_filter_code   ( rb_filter_code[1:0]       ), // LANE CSR : 00 = 1.6 GHz, 01 = 1.2 GHz, 10 = 1.0 GHz, 11 = 0.8 GHz ( Interpolator filter setting )
.mux_sel_a        ( mux_sel_a[2:0]            ), // The gray code to control (even) of the 8 to 1 phase multiplexer
.mux_sel_b        ( mux_sel_b[2:0]            ), // The gray code to control (odd ) of the 8 to 1 phase multiplexer
.interp_sel_a     ( interp_sel_a[3:0]         ), // The gray code output to control (even) the interpolator
.interp_sel_b     ( interp_sel_b[3:0]         ), // The gray code output to control (odd ) the interpolator
.dirty_clk        ( dirty_clk[1:0]            ), // pass through code is 2'b01, disable code is 2'b00, divider is dynamic
.enable           ( interp_enable[0]          ), // Active high enable    0 = Force interpolator_clk[1:0] to 2'b10
.test_enable      ( test_enable               ), // Active high test enable    1: avoid tristate on output of interp_mux during testing
.rb_couple_enable ( rb_couple_enable          ), // Active high cross couple enable
.int_clk          ( int_clk[0]                ), // Clocks for the counter
.clk_out          ( interp_clk_out[1:0]       ), // Complimentary Clock output sent to io_ioereg_pnr
.interpolator_clk ( interpolator_clk[1:0]     )  // Complimentary Clock output sent to io_ioereg_struct
);

io_interpolator xio_interpolator_1 (
.reset_n          ( nfrzdrv		      ),
.pdn              ( power_down_n[1]           ), // power down active low
.nfrzdrv          ( nfrzdrv	              ), // active low
.phy_clk_phs      ( phy_clk_phs[7:0]          ), // PLL  : 8 phase 1.6GHz local clock
.rb_filter_code   ( rb_filter_code[1:0]       ), // LANE CSR : 00 = 1.6 GHz, 01 = 1.2 GHz, 10 = 1.0 GHz, 11 = 0.8 GHz ( Interpolator filter setting )
.mux_sel_a        ( mux_sel_a[5:3]            ), // The gray code to control (even) of the 8 to 1 phase multiplexer
.mux_sel_b        ( mux_sel_b[5:3]            ), // The gray code to control (odd ) of the 8 to 1 phase multiplexer
.interp_sel_a     ( interp_sel_a[7:4]         ), // The gray code output to control (even) the interpolator
.interp_sel_b     ( interp_sel_b[7:4]         ), // The gray code output to control (odd ) the interpolator
.dirty_clk        ( dirty_clk[3:2]            ), // pass through code is 2'b01, disable code is 2'b00, divider is dynamic
.enable           ( interp_enable[1]          ), // Active high enable    0 = Force interpolator_clk[1:0] to 2'b10
.test_enable      ( test_enable               ), // Active high test enable    1: avoid tristate on output of interp_mux during testing
.rb_couple_enable ( rb_couple_enable          ), // Active high cross couple enable
.int_clk          ( int_clk[1]                ), // Clocks for the counter
.clk_out          ( interp_clk_out[3:2]       ), // Complimentary Clock output sent to io_ioereg_pnr
.interpolator_clk ( interpolator_clk[3:2]     )  // Complimentary Clock output sent to io_ioereg_struct
);

io_nand_x64_delay_line xio_nand_x64_delay_line_0 (
.nfrzdrv       ( nfrzdrv	     ),
.in_p          ( data_dq_in[0]       ),
.in_n          ( data_dqb_in[0]      ),
.osc_mode      ( x64_osc_mode        ),
.osc_in_p      ( x64_osc_in_p        ),
.osc_in_n      ( x64_osc_in_n        ),
.osc_out_p     ( x64_osc_p           ),
.osc_out_n     ( x64_osc_n           ),
.f_gray        ( dq_f_gray[5:0]      ),
.i_gray        ( dq_i_gray[2:0]      ),
.out_p         ( dq_in_del_int[0]    ),   // Swap and invert the output here
.out_n         ( dq_in_del_int[1]    )    // Swap and invert the output here
);

io_nand_x64_delay_line xio_nand_x64_delay_line_1 (
.nfrzdrv       ( nfrzdrv	     ),
.in_p          ( data_dq_in[1]       ),
.in_n          ( data_dqb_in[1]      ),
.osc_mode      ( x64_osc_mode        ),
.osc_in_p      ( x64_osc_p           ),
.osc_in_n      ( x64_osc_n           ),
.osc_out_p     ( x64_osc_out_p       ),
.osc_out_n     ( x64_osc_out_n       ),
.f_gray        ( dq_f_gray[11:6]     ),
.i_gray        ( dq_i_gray[5:3]      ),
.out_p         ( dq_in_del_int[2]    ),   // Swap and invert the output here
.out_n         ( dq_in_del_int[3]    )    // Swap and invert the output here
);


io_delay_line_dcc xio_delay_line_dcc_0 (
.c_in_p        ( dq_in_del_int[0]    ),
.c_in_n        ( dq_in_del_int[1]    ),
.f_gray        ( dq_fall_gray[3:0]   ),
.r_gray        ( dq_rise_gray[3:0]   ),
.c_out_p       ( dq_in_del[0]        ),
.c_out_n       ( dq_in_del[1]        )
);

io_delay_line_dcc xio_delay_line_dcc_1 (
.c_in_p        ( dq_in_del_int[2]    ),
.c_in_n        ( dq_in_del_int[3]    ),
.f_gray        ( dq_fall_gray[7:4]   ),
.r_gray        ( dq_rise_gray[7:4]   ),
.c_out_p       ( dq_in_del[2]        ),
.c_out_n       ( dq_in_del[3]        )
);

endmodule

