// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 

//---------------------------------------------------------------------------------------------------------------------------------------------
//  io_nand_x64_delay_line
//---------------------------------------------------------------------------------------------------------------------------------------------

module io_nand_x64_delay_line (
input         nfrzdrv,
input         in_p,
input         in_n,
input         osc_mode,           // Mux control for the x64 ring oscillator
input         osc_in_p,           // input for the x64 ring oscillator
input         osc_in_n,           // input for the x64 ring oscillator
output        osc_out_p,          // output for the x64 ring oscillator
output        osc_out_n,          // output for the x64 ring oscillator
input   [5:0] f_gray,
input   [2:0] i_gray,
output        out_p,
output        out_n
);

`ifdef TIMESCALE_EN
                timeunit 1ps;
                timeprecision 1ps;
`endif

parameter   NAND_DELAY = 20;

wire         x64_in_p;
wire         x64_in_n;
wire         fout_p;
wire         fout_n;
wire	     a63;
wire	     c63;


//---------------------------------------------------------------------------------------------------------------------------------------------
//  
//---------------------------------------------------------------------------------------------------------------------------------------------

assign x64_in_p   = osc_mode ? osc_in_p : in_p;
assign x64_in_n   = osc_mode ? osc_in_n : in_n;

io_cmos_nand_x64 xnand64 (
.b63        ( 1'b1         ),
.d63        ( 1'b1         ),
.in_p       ( x64_in_p         ),
.in_n       ( x64_in_n         ),
.gray       ( {1'b0, f_gray[5:0]}  ),
.a63        ( a63          ),
.c63        ( c63          ),
.out_p      ( fout_p       ),
.out_n      ( fout_n       )
);

io_dly_interpolator xinterp (
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



