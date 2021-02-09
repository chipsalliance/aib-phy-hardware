// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 

//---------------------------------------------------------------------------------------------------------------------------------------------
//  io_nand_delay_line_min
//---------------------------------------------------------------------------------------------------------------------------------------------

module aibnd_io_nand_delay_line_min_rep(
input         nfrzdrv,
input         in_p,
input         in_n,
output        out_p,
output        out_n
);

`ifdef TIMESCALE_EN
                timeunit 1ps;
                timeprecision 1ps;
`endif

parameter   NAND_DELAY = 20;

wire         fout_p;
wire         fout_n;
wire         osc_out_p;
wire         osc_out_n;

//---------------------------------------------------------------------------------------------------------------------------------------------
//  
//---------------------------------------------------------------------------------------------------------------------------------------------

io_cmos_nand_x1 xnandx1 (
.in_p       ( in_p	),
.in_n       ( in_n	),
.bk         ( 1'b0	),
.ci_p       ( 1'b1	),
.ci_n       ( 1'b1	),
.out_p      ( fout_p	),
.out_n      ( fout_n	),
.co_p       ( 		),
.co_n       ( 		)
);

aibnd_io_dly_interpolator_rep xinterp (
.nfrzdrv    ( nfrzdrv     ),
.fout_p     ( fout_p      ),
.fout_n     ( fout_n      ),
.gray       ( 3'b000      ),
.out_p      ( out_p       ),
.out_n      ( out_n       ),
.osc_out_p  ( osc_out_p   ),
.osc_out_n  ( osc_out_n   )
);

endmodule



