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

module io_min_inter (
input    [7:0] phy_clk_phs,      // 8 phase 1.6GHz local clock
input    [1:0] rb_filter_code,   // 00 = 1.6 GHz, 01 = 1.2 GHz, 10 = 1.0 GHz, 11 = 0.8 GHz
input          test_enable,      // Active high test enable    1: avoid tristate on output of interp_mux during testing
input          rb_couple_enable, // Active high cross couple enable
input          nfrzdrv,          // for power domain crossing protection
input          pdn,              // Active low power down
output         c_out             // 
);

`ifdef TIMESCALE_EN
                timeunit 1ps;
                timeprecision 1ps;
`endif

wire  [7:0]  phy_clk_phs_gated;      // 8 phase 1.6GHz local clock
wire  [1:0]  interp_clk_x;
wire  [1:0]  c_out_x;
wire  [3:1]  scp;
wire  [3:1]  scn;
wire	     svcc;
wire	     c_out_nc;

//=================================================================================================================================================================================
// 
//=================================================================================================================================================================================

io_min_pdn xphs_gated (
.pdn               ( pdn                        ), // power down active low
.phy_clk_phs       ( phy_clk_phs[7:0]           ), // 8 phase 1.6GHz local clock
.phy_clk_phs_gated ( phy_clk_phs_gated[7:0]     )  // gated 8 phase 1.6GHz local clock
);

io_min_interp_mux ximp ( .phy_clk_phs(phy_clk_phs_gated[3:0]), .c_out(clk_p), .svcc(svcc) );
io_min_interp_mux ximn ( .phy_clk_phs(phy_clk_phs_gated[7:4]), .c_out(clk_n), .svcc(svcc) );

io_min_ip16phs xip16p (
 .c_in        ( clk_p                ),
 .scp         ( scp[3:1]             ),
 .scn         ( scn[3:1]             ),
 .c_out       ( interp_clk_x[0]      )
);

io_min_ip16phs xip16n (
 .c_in        ( clk_n                ),
 .scp         ( scp[3:1]             ),
 .scn         ( scn[3:1]             ),
 .c_out       ( interp_clk_x[1]      )
);

io_min_misc xminmisc	(
.filter_code		(rb_filter_code[1:0]	),           // 00 = 1.6 GHz, 01 = 1.2 GHz, 10 = 1.0 GHz, 11 = 0.8 GHz
.c_out_x		(c_out_x[1:0]		),           // interpolator clock for pnr/dpa
.couple_enable		(rb_couple_enable	),           // cross coupling enable
.nfrzdrv		(nfrzdrv		),           // for power domain crossing protection
.test_enable		(test_enable		),           // Active high test enable    1: avoid tristate on output of interp_mux during testing
.c_out			({c_out_nc,c_out}	),           // interpolator clock for pnr/dpa
.pon			(pon			),           // cross couple control for p fingers
.non			(non			),           // cross couple control for n fingers
.scp			(scp[3:1]		),           // filter capacitance selection
.scn			(scn[3:1]		),           // filter capacitance selection
.svcc			(svcc			),           // for test
.test_enable_n		(test_enable_n		)   
);

io_min_output xminoutput (
.interp_clk_x	(interp_clk_x[1:0]	),     // clock generated from min_ip16phs
.test_enable_n	(test_enable_n		),     // Active low test enable
.pon		(pon			),     // cross coupling enable p finger
.non		(non			),     // cross coupling enable n finger
.enable		(nfrzdrv		),     // latch enable
.svcc		(svcc			),     // soft tie vcc
.int_clk_out	(c_out_x[1:0]		)      //
);

endmodule


