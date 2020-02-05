// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 

module io_ioereg_struct (
input  [1:0] interpolator_clk,   // Complimentary Clock output sent to io_ioereg_struct
input  [1:0] d_out_p_mux,        // I/O  : Output P transistor before the final output mux
input  [1:0] d_out_n_mux,        // I/O  : Output N transistor before the final output mux
output 	     codin_p,            // I/O  : The high speed data output sent to the P type transistor +
output       codin_pb,           // I/O  : The high speed data output sent to the P type transistor -
output       codin_n,            // I/O  : The high speed data output sent to the N type transistor +
output       codin_nb,           // I/O  : The high speed data output sent to the N type transistor -
input  [2:0] rb_dq_select,       // CSR  : 000 = DQ input disabled, 1?? = Single ended DQ, 010 = loopback, 011 = xor loopback, 001 = differential DQ
input        latch_open_n,       // Static : 0 = force the latches open (GPIO & ATPG),  1 = clock the latches, Memory IF
input  [1:0] dq_diff_in,         // I/O  : differential DQ input
input  [1:0] dq_sstl_in,         // I/O  : single ended DQ input
input        nfrzdrv,            //  freez signal
input        loopback_p,         // I/O  : P-tran loopback
input        loopback_n,         // I/O  : N-tran loopback
input        loopback_en_n,      // I/O  : Active low loopback enable
output       datovr,             // I/O  : DQ complimentary inputs from the I/O cell sent to gpio  -- dq_in[1] = dq+
output       datovrb,            // I/O  : DQ complimentary inputs from the I/O cell sent to gpio  -- dq_in[0] = dq-
output       data_dq,            // I/O  : DQ complimentary inputs from the I/O cell sent to delay chain  -- dq_in[1] = dq+
output       data_dqb,           // I/O  : DQ complimentary inputs from the I/O cell sent to delay chain  -- dq_in[0] = dq-
output [1:0] dqs_loop_back,      //
input        scan_in,            // ATPG : Scan in
input        scan_shift_n,       // ATPG : Scan shift enable
input        test_clk,           // ATPG : Scan clock
input        sample_clk,         // sampling clock for dcc
input  [1:0] dcc_select,         // dcc sampling point selection
input        rb_gpio_or_ddr_sel, // used for ioereg_struct timing model generation only
input        rb_mode_ddr,        // used for ioereg_struct timing model generation only

output       dcc_sample,         // dcc sample value
output reg   scan_out            // ATPG : Scan out
);

`ifdef TIMESCALE_EN
                timeunit 1ps;
                timeprecision 1ps;
`endif

parameter FF_DELAY    = 80;
parameter LATCH_DELAY = 70;
parameter MUX_DELAY   = 60;

reg        dcc_sample_b;
reg        sample_value;
reg        sample_value_reg_1;
reg        sample_value_reg_2;
reg        sample_value_reg_3;
wire       sample_value_0;
wire       sample_value_1;
wire       sample_value_2;
wire       sample_value_3;
reg  [1:0] dq_in_mux;
reg  [3:0] scan_chain;

//-----------------------------------------------------
// Output Mux
//-----------------------------------------------------

io_ioereg_struct_out xstruct_out (
.interpolator_clk	(interpolator_clk[1:0]	),
.d_out_p_mux		(d_out_p_mux[1:0]	),
.d_out_n_mux		(d_out_n_mux[1:0]	),
.codin_p		(codin_p		),
.codin_pb		(codin_pb		),
.codin_n		(codin_n		),
.codin_nb		(codin_nb		),
.latch_open_n		(latch_open_n		),
.nfrzdrv		(nfrzdrv		),
.loopback_p		(loopback_p		),
.loopback_n		(loopback_n		),
.loopback_en_n		(loopback_en_n		)
);

assign dqs_loop_back = (rb_dq_select[2:0]==3'b001)? 2'b01 : {~codin_pb,~codin_p};

//-----------------------------------------------------
// Input Mux
//-----------------------------------------------------

always @(*)
  casez (rb_dq_select[2:0])
    3'b000  : dq_in_mux[1:0] = dq_sstl_in[1:0];
    3'b001  : dq_in_mux[1:0] = dq_sstl_in[1:0];
    3'b010  : dq_in_mux[1:0] = {codin_pb,codin_p};
    3'b011  : dq_in_mux[1:0] = {(codin_pb ^ codin_n),(codin_p ~^ codin_nb)};
    3'b1??  : dq_in_mux[1:0] = dq_diff_in[1:0];
  endcase

assign {datovr,datovrb}   = dq_in_mux[1:0];

assign {data_dq,data_dqb} = dq_in_mux[1:0];

//-----------------------------------------------------
// Scan Flops
//-----------------------------------------------------

always @(posedge test_clk)
  if (scan_shift_n) scan_chain[0] <= #FF_DELAY d_out_n_mux[0];
  else              scan_chain[0] <= #FF_DELAY scan_in;

always @(posedge test_clk)
  if (scan_shift_n) scan_chain[1] <= #FF_DELAY d_out_n_mux[1];
  else              scan_chain[1] <= #FF_DELAY scan_chain[0];

always @(posedge test_clk)
  if (scan_shift_n) scan_chain[2] <= #FF_DELAY d_out_p_mux[0];
  else              scan_chain[2] <= #FF_DELAY scan_chain[1];

always @(posedge test_clk)
  if (scan_shift_n) scan_chain[3] <= #FF_DELAY d_out_p_mux[1];
  else              scan_chain[3] <= #FF_DELAY scan_chain[2];

always @(*)
  if (!test_clk)  scan_out <= #LATCH_DELAY scan_chain[3];

//-----------------------------------------------------
// sampling for dcc
//-----------------------------------------------------

an_io_phdet_ff_ln sample_reg_0 (
.dp     ( datovr		),
.dn     ( datovrb		),
.clk_p  ( sample_clk		),
.rst_n  ( nfrzdrv		),
.q      ( sample_value_0	)
);

an_io_phdet_ff_ln sample_reg_1 (
.dp     ( codin_n		),
.dn     ( codin_nb		),
.clk_p  ( sample_clk		),
.rst_n  ( nfrzdrv		),
.q      ( sample_value_1	)
);

an_io_phdet_ff_ln sample_reg_2 (
.dp     ( codin_p		),
.dn     ( codin_pb		),
.clk_p  ( sample_clk		),
.rst_n  ( nfrzdrv		),
.q      ( sample_value_2	)
);

an_io_phdet_ff_ln sample_reg_3 (
.dp     ( interpolator_clk[0]   ),
.dn     ( interpolator_clk[1]   ),
.clk_p  ( sample_clk		),
.rst_n  ( nfrzdrv		),
.q      ( sample_value_3	)
);

always @(*)
  case (dcc_select[1:0])
    2'b00   : sample_value = sample_value_0;
    2'b01   : sample_value = sample_value_1;
    2'b10   : sample_value = sample_value_2;
    2'b11   : sample_value = sample_value_3;
    default : sample_value = sample_value_0;
  endcase

// synchronizer
/*
always @(posedge sample_clk or negedge nfrzdrv)
  if (~nfrzdrv)  sample_value_reg <= #FF_DELAY 1'b0;
  else           sample_value_reg <= #FF_DELAY sample_value;

always @(posedge sample_clk or negedge nfrzdrv)
  if (~nfrzdrv)  dcc_sample <= #FF_DELAY 1'b0;
  else           dcc_sample <= #FF_DELAY sample_value_reg;
*/

always @(*)
  if (~sample_clk) sample_value_reg_1 <= #LATCH_DELAY ~(sample_value & nfrzdrv);

always @(*)
  if (sample_clk) sample_value_reg_2 <= #LATCH_DELAY sample_value_reg_1;

always @(*)
  if (~sample_clk) sample_value_reg_3 <= #LATCH_DELAY ~sample_value_reg_2;

always @(*)
  if (sample_clk) dcc_sample_b <= #LATCH_DELAY ~sample_value_reg_3;

assign dcc_sample = ~dcc_sample_b;

endmodule
