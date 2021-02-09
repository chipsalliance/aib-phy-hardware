// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 

//---------------------------------------------------------------------------------------------------------------------------------------------
//  aibcr3_io_cmos_nand_delay_line
//---------------------------------------------------------------------------------------------------------------------------------------------

module aibcr3_io_nand_x128_delay_line (
input         nfrzdrv,
input         in_p,
input         in_n,
input         osc_mode,           // Mux control for the x64 ring oscillator
input         osc_in_p,           // input for the x64 ring oscillator
input         osc_in_n,           // input for the x64 ring oscillator
output        osc_out_p,          // output for the x64 ring oscillator
output        osc_out_n,          // output for the x64 ring oscillator
input   [6:0] f_gray,
input   [2:0] i_gray,
output        out_p,
output        out_n
);

`ifdef TIMESCALE_EN
                timeunit 1ps;
                timeprecision 1ps;
`endif

parameter   NAND_DELAY         = 20;

wire         fout_p;
wire         fout_n;
wire         x128_in_p;
wire         x128_in_n;

//---------------------------------------------------------------------------------------------------------------------------------------------
//  input mux
//---------------------------------------------------------------------------------------------------------------------------------------------

assign x128_in_p  = osc_mode ? osc_in_p : in_p;
assign x128_in_n  = osc_mode ? osc_in_n : in_n;

aibcr3_io_cmos_nand_x128 #(
.NAND_DELAY  ( NAND_DELAY   )
) xnand128 (
.in_p        ( x128_in_p    ),
.in_n        ( x128_in_n    ),
.gray        ( f_gray[6:0]  ),
.out_p       ( fout_p       ),
.out_n       ( fout_n       )
);

aibcr3_io_cmos_8ph_interpolator xinterp (
.nfrzdrv    ( nfrzdrv     ),
.fout_p     ( fout_p      ),
.fout_n     ( fout_n      ),
.gray       ( i_gray[2:0] ),
.out_p      ( out_p       ),
.out_n      ( out_n       ),
.osc_out_p  ( osc_out_p   ),
.osc_out_n  ( osc_out_n   )

);

endmodule


