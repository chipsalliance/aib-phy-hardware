// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
//
// Revision:    $Revision: #3 $
// Date:        $DateTime: 2015/06/30 10:09:02 $
//------------------------------------------------------------------------
// Description: IO DLL TOP
//
//------------------------------------------------------------------------


module io_dll_custom
#(
//-----------------------------------------------------------------------------------------------------------------------
//  delay chain parameters
//-----------------------------------------------------------------------------------------------------------------------
parameter NAND_DELAY         = 20,
parameter FF_DELAY     = 200
)
(
   input              launch,                // Decode from gate_shf, Used as the input to the delay line
   input              measure,               // Decode from gate_shf, Used as the clock for the phase detector
   input [6:0]        f_gray,                // gray code for nand delay chain
   input [2:0]        i_gray,                // gray code for phase interpolator
   input              dll_reset_n,
   input              nfrzdrv,
   input  wire        osc_mode,              // Mux control for the x64 ring oscillator
   input  wire        osc_in_p,              // input for the x64 ring oscillator
   input  wire        osc_in_n,              // input for the x64 ring oscillator
   output wire        osc_out_p,             // output for the x64 ring oscillator
   output wire        osc_out_n,             // output for the x64 ring oscillator
   output             t_up,                  // output of phase detector
   output             t_down                 // output of phase detector
);

`ifdef TIMESCALE_EN
                timeunit 1ps;
                timeprecision 1ps;
`endif

//----------------------------------------------------------------------------------------------------------------------------------------------------------------
//   wire & reg
//----------------------------------------------------------------------------------------------------------------------------------------------------------------

   wire        i_del_p;                  // delay chain output
   wire        i_del_n;                  // delay chain output
   wire        phase_clk;                // clock for phase detector
   wire        phase_clkb;               // complementary clock for phase detector
   wire        launch_p;                 // Decode from gate_shf, Used as the input to the delay line
   wire        launch_n;                 // Decode from gate_shf, Used as the complementary input to the delay line
   wire        measure_p;                // Decode from gate_shf, Used as the clock for the phase detector
   wire        measure_n;                // Decode from gate_shf, Used as the complementary clock for the phase detector

//-----------------------------------------------------------------------------------------------------------------------
//  custom design portion
//-----------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------
//  split and align:
//-----------------------------------------------------------------------------------------------------------------------

io_split_align xsplit_align_0 (
.din           ( launch      ),   // input
.dout_p        ( launch_p    ),   // splitted output positive
.dout_n        ( launch_n    )    // splitted output negative
);

io_split_align xsplit_align_1 (
.din           ( measure     ),   // input
.dout_p        ( measure_p   ),   // splitted output positive
.dout_n        ( measure_n   )    // splitted output negative
);

//-----------------------------------------------------------------------------------------------------------------------
//  delay line:
//-----------------------------------------------------------------------------------------------------------------------

io_nand_x128_delay_line xdelay_line (
 .nfrzdrv            ( nfrzdrv               ),
 .in_p               ( launch_p              ),
 .in_n               ( launch_n              ),
 .osc_mode           ( osc_mode              ),
 .osc_in_p           ( osc_in_p              ),
 .osc_in_n           ( osc_in_n              ),
 .osc_out_p          ( osc_out_p             ),
 .osc_out_n          ( osc_out_n             ),
 .f_gray             ( f_gray[6:0]           ),
 .i_gray             ( i_gray[2:0]           ),
 .out_p              ( i_del_p               ),
 .out_n              ( i_del_n               )
);

io_nand_delay_line_min xdelay_line_match (
 .nfrzdrv            ( nfrzdrv               ),
 .in_p               ( measure_p             ),
 .in_n               ( measure_n             ),
 .out_p              ( phase_clk             ),
 .out_n              ( phase_clkb            )
);

//-----------------------------------------------------------------------------------------------------------------------
//  phase_detector :
//-----------------------------------------------------------------------------------------------------------------------

//assign #INTRINSIC_DELAY phase_clk = measure;
//assign #INTRINSIC_DELAY phase_clkb = measureb;

io_dll_phdet xdll_phdet (
 .i_del_p            ( i_del_p               ),
 .i_del_n            ( i_del_n               ),
 .phase_clk          ( phase_clk             ),
 .phase_clkb         ( phase_clkb            ),
 .dll_reset_n        ( dll_reset_n           ),
 .t_up               ( t_up                  ),
 .t_down             ( t_down                )
);

endmodule // io_dll_custom
