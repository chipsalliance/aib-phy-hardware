// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 

//---------------------------------------------------------------------------------------------------------------------------------------------
//  io_dly_interpolator
//---------------------------------------------------------------------------------------------------------------------------------------------

module aibnd_io_dly_interpolator_rep (
input         nfrzdrv,
input         fout_p,
input         fout_n,
input   [2:0] gray,
output        out_p,
output        out_n,
output        osc_out_p,
output        osc_out_n
);

`ifdef TIMESCALE_EN
		timeunit 1ps; 
		timeprecision 1ps; 
`endif

parameter   NAND_DELAY = 20;

wire         a_in_p;
wire         b_in_p;
wire         c_in_p;
wire         a_in_n;
wire         b_in_n;
wire         c_in_n;
wire         out_pb;
wire         out_nb;
wire         x_p;
wire         x_n;
wire         x_pb;
wire         x_nb;
wire  [6:0]  sn;
reg   [6:0]  sp;

io_dly_interpclk xio_dly_interpclk (
.nfrzdrv	(nfrzdrv	),
.fout_p		(fout_p		),
.fout_n		(fout_n		),
.a_in_p		(a_in_p		),
.b_in_p		(b_in_p		),
.c_in_p		(c_in_p		),
.a_in_n		(a_in_n		),
.b_in_n		(b_in_n		),
.c_in_n		(c_in_n		)
);

always @(*)
  case (gray[2:0])
    3'b000 :  sp[6:0] = 7'b000_0000;
    3'b001 :  sp[6:0] = 7'b000_0001;
    3'b011 :  sp[6:0] = 7'b000_0011;
    3'b010 :  sp[6:0] = 7'b000_0111;
    3'b110 :  sp[6:0] = 7'b000_1111;
    3'b111 :  sp[6:0] = 7'b001_1111;
    3'b101 :  sp[6:0] = 7'b011_1111;
    3'b100 :  sp[6:0] = 7'b111_1111;
  endcase

assign sn[6:0] = ~sp[6:0];

io_ip8phs_3in xio_ip8phs_3in_n (
.a_in     ( a_in_n 		   ),
.b_in     ( b_in_n		   ),
.c_in     ( c_in_n		   ),
.svcc     ( 1'b1		   ),
.sp       ( sp[6:0]                ),
.sn       ( sn[6:0]                ),
.clk_outb ( out_nb                 )
);

io_ip8phs_3in xio_ip8phs_3in_p (
.a_in     ( a_in_p 		   ),
.b_in     ( b_in_p		   ),
.c_in     ( c_in_p		   ),
.svcc     ( 1'b1		   ),
.sp       ( sp[6:0]                ),
.sn       ( sn[6:0]                ),
.clk_outb ( out_pb                 )
);

assign x_p = ~out_pb;
assign x_n = ~out_nb;
//cross couple
assign x_pb = ~x_p;
assign x_nb = ~x_n;
assign out_p = ~x_pb;
assign out_n = ~x_nb;
assign osc_out_p = ~x_pb;
assign osc_out_n = ~x_nb;

/*
`ifdef LEC
assign x_p = ~x_n;
assign x_n = ~x_p;
`endif
*/

endmodule



