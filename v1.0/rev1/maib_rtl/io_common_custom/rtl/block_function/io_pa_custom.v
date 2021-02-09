// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
//
// Revision:    $Revision: #4 $
// Date:        $DateTime: 2014/11/15 16:17:29 $
//------------------------------------------------------------------------
// Description: IO PHASE ALIGNMENT TOP
//
//------------------------------------------------------------------------


module io_pa_custom #(
parameter NAND_DELAY   = 15,
parameter FF_DELAY     = 100
)
(
   input  wire        pa_reset_n,	       // reset for phase alignment, come from core
   input  wire        nfrzdrv,                 // core control signal
   input  wire [7:0]  phy_clk_phs,             // 8 clock phase from PLL
   input  wire        pdn,                     // Active low power down control from pnr for 8 phases
   input  wire        test_enable,             // Active high test enable    1: avoid tristate on output of interp_mux during testing
   input  wire [2:0]  mux_sel_a_master_0,       // The gray code to control the first of the 8 to 1 phase multiplexer
   input  wire [2:0]  mux_sel_b_master_0,       // The gray code to control the second of the 8 to 1 phase multiplexer
   input  wire [2:0]  mux_sel_a_master_1,       // The gray code to control the first of the 8 to 1 phase multiplexer
   input  wire [2:0]  mux_sel_b_master_1,       // The gray code to control the second of the 8 to 1 phase multiplexer
   input  wire [2:0]  mux_sel_a_slave_0,        // The gray code to control the first of the 8 to 1 phase multiplexer
   input  wire [2:0]  mux_sel_b_slave_0,        // The gray code to control the second of the 8 to 1 phase multiplexer
   input  wire [2:0]  mux_sel_a_slave_1,        // The gray code to control the first of the 8 to 1 phase multiplexer
   input  wire [2:0]  mux_sel_b_slave_1,        // The gray code to control the second of the 8 to 1 phase multiplexer
   input  wire [3:0]  interp_sel_a_master_0,    // The gray code output to control the interpolator
   input  wire [3:0]  interp_sel_b_master_0,    // The gray code output to control the interpolator
   input  wire [3:0]  interp_sel_a_master_1,    // The gray code output to control the interpolator
   input  wire [3:0]  interp_sel_b_master_1,    // The gray code output to control the interpolator
   input  wire [3:0]  interp_sel_a_slave_0,     // The gray code output to control the interpolator
   input  wire [3:0]  interp_sel_b_slave_0,     // The gray code output to control the interpolator
   input  wire [3:0]  interp_sel_a_slave_1,     // The gray code output to control the interpolator
   input  wire [3:0]  interp_sel_b_slave_1,     // The gray code output to control the interpolator
   input  wire [1:0]  rbpa_filter_code,         // 00 = 1.6 GHz, 01 = 1.2 GHz, 10 = 1.0 GHz, 11 = 0.8 GHz
   input  wire        rbpa_couple_enable,       // cross couple enable
   input  wire [1:0]  dirty_clk_master_0,       // The clock outputs with a duty cycle that is not 50%, The Interpolator will modify this clock to 50% duty cycle
   input  wire [1:0]  dirty_clk_master_1,       // The clock outputs with a duty cycle that is not 50%, The Interpolator will modify this clock to 50% duty cycle
   input  wire [1:0]  dirty_clk_slave_0,        // The clock outputs with a duty cycle that is not 50%, The Interpolator will modify this clock to 50% duty cycle
   input  wire [1:0]  dirty_clk_slave_1,        // The clock outputs with a duty cycle that is not 50%, The Interpolator will modify this clock to 50% duty cycle
   input  wire [2:0]  phx_sel_master_0,         // The gray code output to control the clk_accum phase from of the 8 to 1 phase multiplexer
   input  wire [2:0]  phx_sel_master_1,         // The gray code output to control the clk_accum phase from of the 8 to 1 phase multiplexer

   output wire        clk_ph_0_buf,
   output wire        phx_clk_master_0,
   output wire        phx_clk_master_1,
   output wire        int_clk_master_0,         // Clocks from the output of the 3 (8 to 1 phase select multiplexers)  clk_p[0] arrives first, clk_p[2] arrives last
   output wire        int_clk_master_1,         // Clocks from the output of the 3 (8 to 1 phase select multiplexers)  clk_p[0] arrives first, clk_p[2] arrives last
   output wire        int_clk_slave_0,          // Clocks from the output of the 3 (8 to 1 phase select multiplexers)  clk_p[0] arrives first, clk_p[2] arrives last
   output wire        int_clk_slave_1,          // Clocks from the output of the 3 (8 to 1 phase select multiplexers)  clk_p[0] arrives first, clk_p[2] arrives last
   output wire  [1:0] clk_hps,                  // clock sent to the HPS
   output wire  [1:0] core_clk_out,             // Clock output sent to the core
   output wire  [1:0] periphery_clk_out         // Periphery Clock output sent to the phy_clk tree
);

`ifdef TIMESCALE_EN
                timeunit 1ps;
                timeprecision 1ps;
`endif

//----------------------------------------------------------------------------------------------------------------------------------------------------------------
//   wire & reg
//----------------------------------------------------------------------------------------------------------------------------------------------------------------

   wire [7:0]  phy_clk_phs_gated;        // gated 8 phases
   wire [7:0]  slow_clk_ph_p;       	 // buffered 8 phase 1.6GHz local clock combined with reset
   wire [7:0]  slow_clk_ph_n;       	 // buffered 8 phase 1.6GHz local clock combined with reset
   wire [2:0]  phx_master_0_buf;         // buffered gray code for interp_mux
   wire [2:0]  phx_master_1_buf;         // buffered gray code for interp_mux
   wire [2:0]  phx_slave_0_buf;          // buffered gray code for interp_mux
   wire [2:0]  phx_slave_1_buf;          // buffered gray code for interp_mux
   wire [2:0]  phx_master_0_inv;         // Inverted gray code for interp_mux
   wire [2:0]  phx_master_1_inv;         // Inverted gray code for interp_mux
   wire [2:0]  phx_slave_0_inv;          // Inverted gray code for interp_mux
   wire [2:0]  phx_slave_1_inv;          // Inverted gray code for interp_mux
   wire        test_enable_n;
   wire        dft_mux_sel;
   wire [1:0]  periphery_clk_x;	 	 // periphery_clk from io_interpolator
   wire [1:0]  core_clk_x;	 	 // core_clk from io_interpolator
   wire [5:0]  dummy;	 	  	 // ports not used

//-----------------------------------------------------------------------------------------------------------------------
//  custom design portion
//-----------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------
//  phx clock  io_interp_muxes :
//-----------------------------------------------------------------------------------------------------------------------

io_pa_phs_gated xio_phs_gated (
.nfrzdrv           ( pdn                        ), // active low
.phy_clk_phs       ( phy_clk_phs[7:0]           ), // 8 phase 1.6GHz local clock
.phy_clk_phs_gated ( phy_clk_phs_gated[7:0]     )  // gated 8 phase 1.6GHz local clock
);

io_pa_phs_buf xio_pa_phs_buf(
.reset_n		(pa_reset_n		),
.nfrzdrv		(nfrzdrv		),
.test_enable		(test_enable		),
.phy_clk_phs		(phy_clk_phs_gated[7:0]	),
.phx_sel_master_0	(phx_sel_master_0[2:0]	),
.phx_sel_master_1	(phx_sel_master_1[2:0]	),
.periphery_clk_x	(periphery_clk_x[1:0]	),      // periphery_clk from io_interpolator
.core_clk_x		(core_clk_x[1:0]	),      // core_clk from io_interpolator
.periphery_clk_out	(periphery_clk_out[1:0]	),      // Clock feedback to the periphery
.core_clk_out		(core_clk_out[1:0]	),      // Clock feedback to the core
.phx_master_0_buf	(phx_master_0_buf[2:0]	),
.phx_master_1_buf	(phx_master_1_buf[2:0]	),
.phx_master_0_inv	(phx_master_0_inv[2:0]	),
.phx_master_1_inv	(phx_master_1_inv[2:0]	),
.slow_clk_ph_p		(slow_clk_ph_p[7:0]	),
.slow_clk_ph_n		(slow_clk_ph_n[7:0]	),
.test_enable_n		(test_enable_n		),
.dft_mux_sel		(dft_mux_sel		)
);

io_interp_mux_match xinterp_mux_0 ( 
.slow_clk_ph_p		(slow_clk_ph_p[7:0] 	), 
.slow_clk_ph_n		(slow_clk_ph_n[7:0] 	), 
.phy_clk_phs		(phy_clk_phs_gated[7:0] ), 
.gray_a_buf		(3'b000			),                
.gray_b_buf		(3'b000			),                
.gray_a_inv		(3'b111			),                
.gray_b_inv		(3'b111			),                
.int_clk_out		(clk_ph_0_buf		),     
.nfrzdrv		(nfrzdrv		),  
.test_enable_n		(test_enable_n		),  
.dft_mux_sel		(dft_mux_sel		)
);

io_interp_mux_match xinterp_mux_1 ( 
.slow_clk_ph_p		(slow_clk_ph_p[7:0] 	), 
.slow_clk_ph_n		(slow_clk_ph_n[7:0] 	), 
.phy_clk_phs		(phy_clk_phs_gated[7:0] ), 
.gray_a_buf		(phx_master_0_buf[2:0]	), 
.gray_b_buf		(phx_master_0_buf[2:0]	), 
.gray_a_inv		(phx_master_0_inv[2:0]	), 
.gray_b_inv		(phx_master_0_inv[2:0]	), 
.int_clk_out		(phx_clk_master_0	), 
.nfrzdrv		(nfrzdrv		),  
.test_enable_n		(test_enable_n		),  
.dft_mux_sel		(dft_mux_sel		)
);

io_interp_mux_match xinterp_mux_2 ( 
.slow_clk_ph_p		(slow_clk_ph_p[7:0] 	), 
.slow_clk_ph_n		(slow_clk_ph_n[7:0] 	), 
.phy_clk_phs		(phy_clk_phs_gated[7:0] ), 
.gray_a_buf		(phx_master_1_buf[2:0]	), 
.gray_b_buf		(phx_master_1_buf[2:0]	), 
.gray_a_inv		(phx_master_1_inv[2:0]	), 
.gray_b_inv		(phx_master_1_inv[2:0]	), 
.int_clk_out		(phx_clk_master_1	), 
.nfrzdrv		(nfrzdrv		),  
.test_enable_n		(test_enable_n		),  
.dft_mux_sel		(dft_mux_sel		)
);

//-----------------------------------------------------------------------------------------------------------------------
//  phase alignment io_interpolator :
//-----------------------------------------------------------------------------------------------------------------------

io_interpolator master_interpolator_0 (
.reset_n          ( pa_reset_n	                    ),
.pdn              ( pdn                             ),
.nfrzdrv          ( nfrzdrv              	    ), //local control signal
.phy_clk_phs      ( phy_clk_phs_gated[7:0] 	    ), // 8 phase 1.6GHz local clock
.rb_filter_code   ( rbpa_filter_code[1:0]           ), // 00 = 1.6 GHz, 01 = 1.2 GHz, 10 = 1.0 GHz, 11 = 0.8 GHz
.rb_couple_enable ( rbpa_couple_enable              ), // cross couple enable
.mux_sel_a        ( mux_sel_a_master_0[2:0]         ), // The gray code output to control the first of the 8 to 1 phase multiplexer(3 MSB bits), and the interpolator (4 LSB bits)
.mux_sel_b        ( mux_sel_b_master_0[2:0]         ), // The gray code output to control the second of the 8 to 1 phase multiplexer(3 MSB bits), and the interpolator (4 LSB bits)
.interp_sel_a     ( interp_sel_a_master_0[3:0]      ), // The gray code output to control the interpolator (4 LSB bits)
.interp_sel_b     ( interp_sel_b_master_0[3:0]      ), // The gray code output to control the interpolator (4 LSB bits)
.dirty_clk        ( dirty_clk_master_0[1:0]         ), // The clock outputs with a duty cycle that is not 50%, The Interpolator will modify this clock to 50% duty cycle
.enable           ( nfrzdrv                         ), // Active high enable    0 = Force interpolator_clk[1:0] to 2'b10
.test_enable      ( test_enable                     ), // Active high enable    1: avoid tristate on output of interp_mux during testing
.int_clk          ( int_clk_master_0                ), // Clocks from the output of the 3 (8 to 1 phase select multiplexers)  clk_p[0] arrives first, clk_p[2] arrives last
.clk_out          (                                 ), // not used
.interpolator_clk ( {dummy[0],periphery_clk_x[0]}   )  // Periphery Clock output sent to the phy_clk tree
);

io_interpolator master_interpolator_1 (
.reset_n          ( pa_reset_n                      ),
.pdn              ( pdn                             ),
.nfrzdrv          ( nfrzdrv              	    ), //local control signal
.phy_clk_phs      ( phy_clk_phs_gated[7:0]	    ), // 8 phase 1.6GHz local clock
.rb_filter_code   ( rbpa_filter_code[1:0]           ), // 00 = 1.6 GHz, 01 = 1.2 GHz, 10 = 1.0 GHz, 11 = 0.8 GHz
.rb_couple_enable ( rbpa_couple_enable              ), // cross couple enable
.mux_sel_a        ( mux_sel_a_master_1[2:0]         ), // The gray code output to control the first of the 8 to 1 phase multiplexer(3 MSB bits), and the interpolator (4 LSB bits)
.mux_sel_b        ( mux_sel_b_master_1[2:0]         ), // The gray code output to control the second of the 8 to 1 phase multiplexer(3 MSB bits), and the interpolator (4 LSB bits)
.interp_sel_a     ( interp_sel_a_master_1[3:0]      ), // The gray code output to control the interpolator (4 LSB bits)
.interp_sel_b     ( interp_sel_b_master_1[3:0]      ), // The gray code output to control the interpolator (4 LSB bits)
.dirty_clk        ( dirty_clk_master_1[1:0]         ), // The clock outputs with a duty cycle that is not 50%, The Interpolator will modify this clock to 50% duty cycle
.enable           ( nfrzdrv                         ), // Active high enable    0 = Force interpolator_clk[1:0] to 2'b10
.test_enable      ( test_enable                     ), // Active high enable    1: avoid tristate on output of interp_mux during testing
.int_clk          ( int_clk_master_1                ), // Clocks from the output of the 3 (8 to 1 phase select multiplexers)  clk_p[0] arrives first, clk_p[2] arrives last
.clk_out          (                                 ), // not used
.interpolator_clk ( {dummy[1],periphery_clk_x[1]}   )  // Periphery Clock output sent to the phy_clk tree
);

io_interpolator slave_interpolator_0 (
.reset_n          ( pa_reset_n                      ),
.pdn              ( pdn                             ),
.nfrzdrv          ( nfrzdrv              	    ), //local control signal
.phy_clk_phs      ( phy_clk_phs_gated[7:0]	    ), // 8 phase 1.6GHz local clock
.rb_filter_code   ( rbpa_filter_code[1:0]           ), // 00 = 1.6 GHz, 01 = 1.2 GHz, 10 = 1.0 GHz, 11 = 0.8 GHz
.rb_couple_enable ( rbpa_couple_enable              ), // cross couple enable
.mux_sel_a        ( mux_sel_a_slave_0[2:0]          ), // The gray code output to control the first of the 8 to 1 phase multiplexer(3 MSB bits), and the interpolator (4 LSB bits)
.mux_sel_b        ( mux_sel_b_slave_0[2:0]          ), // The gray code output to control the second of the 8 to 1 phase multiplexer(3 MSB bits), and the interpolator (4 LSB bits)
.interp_sel_a     ( interp_sel_a_slave_0[3:0]       ), // The gray code output to control the interpolator (4 LSB bits)
.interp_sel_b     ( interp_sel_b_slave_0[3:0]       ), // The gray code output to control the interpolator (4 LSB bits)
.dirty_clk        ( dirty_clk_slave_0[1:0]          ), // The clock outputs with a duty cycle that is not 50%, The Interpolator will modify this clock to 50% duty cycle
.enable           ( nfrzdrv                         ), // Active high enable    0 = Force interpolator_clk[1:0] to 2'b10
.test_enable      ( test_enable                     ), // Active high enable    1: avoid tristate on output of interp_mux during testing
.int_clk          ( int_clk_slave_0                 ), // Clocks from the output of the 3 (8 to 1 phase select multiplexers)  clk_p[0] arrives first, clk_p[2] arrives last
.clk_out          ( {dummy[4],clk_hps[0]}           ), // sent to the hps
.interpolator_clk ( {dummy[2],core_clk_x[0]}        )  // Clock output sent to the core
);

io_interpolator slave_interpolator_1 (
.reset_n          ( pa_reset_n                      ),
.pdn              ( pdn                             ),
.nfrzdrv          ( nfrzdrv              	    ), //local control signal
.phy_clk_phs      ( phy_clk_phs_gated[7:0]	    ), // 8 phase 1.6GHz local clock
.rb_filter_code   ( rbpa_filter_code[1:0]           ), // 00 = 1.6 GHz, 01 = 1.2 GHz, 10 = 1.0 GHz, 11 = 0.8 GHz
.rb_couple_enable ( rbpa_couple_enable              ), // cross couple enable
.mux_sel_a        ( mux_sel_a_slave_1[2:0]          ), // The gray code output to control the first of the 8 to 1 phase multiplexer(3 MSB bits), and the interpolator (4 LSB bits)
.mux_sel_b        ( mux_sel_b_slave_1[2:0]          ), // The gray code output to control the second of the 8 to 1 phase multiplexer(3 MSB bits), and the interpolator (4 LSB bits)
.interp_sel_b     ( interp_sel_b_slave_1[3:0]       ), // The gray code output to control the interpolator (4 LSB bits)
.interp_sel_a     ( interp_sel_a_slave_1[3:0]       ), // The gray code output to control the interpolator (4 LSB bits)
.dirty_clk        ( dirty_clk_slave_1[1:0]          ), // The clock outputs with a duty cycle that is not 50%, The Interpolator will modify this clock to 50% duty cycle
.enable           ( nfrzdrv                         ), // Active high enable    0 = Force interpolator_clk[1:0] to 2'b10
.test_enable      ( test_enable                     ), // Active high enable    1: avoid tristate on output of interp_mux during testing
.int_clk          ( int_clk_slave_1                 ), // Clocks from the output of the 3 (8 to 1 phase select multiplexers)  clk_p[0] arrives first, clk_p[2] arrives last
.clk_out          ( {dummy[5],clk_hps[1]}    	    ), // sent to the hps
.interpolator_clk ( {dummy[3],core_clk_x[1]}        )  // Clock output sent to the core
);

endmodule // io_pa_custom
