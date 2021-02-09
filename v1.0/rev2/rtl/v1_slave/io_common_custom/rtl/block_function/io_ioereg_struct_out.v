// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 

module io_ioereg_struct_out (
input  [1:0] interpolator_clk,   // Complimentary Clock output sent to io_ioereg_struct
input  [1:0] d_out_p_mux,        // I/O  : Output P transistor before the final output mux
input  [1:0] d_out_n_mux,        // I/O  : Output N transistor before the final output mux
output reg   codin_p,            // I/O  : The high speed data output sent to the P type transistor +
output reg   codin_pb,           // I/O  : The high speed data output sent to the P type transistor -
output reg   codin_n,            // I/O  : The high speed data output sent to the N type transistor +
output reg   codin_nb,           // I/O  : The high speed data output sent to the N type transistor -
input        latch_open_n,       // Static : 0 = force the latches open (GPIO & ATPG),  1 = clock the latches, Memory IF
input        nfrzdrv,            //  freez signal
input        loopback_p,         // I/O  : P-tran loopback
input        loopback_n,         // I/O  : N-tran loopback
input        loopback_en_n       // I/O  : Active low loopback enable
);

`ifdef TIMESCALE_EN
                timeunit 1ps;
                timeprecision 1ps;
`endif

parameter FF_DELAY    = 80;
parameter LATCH_DELAY = 70;
parameter MUX_DELAY   = 60;

wire [1:0] clk_bf;
reg  [1:0] latch_p;
reg  [1:0] latch_n;

//-----------------------------------------------------
// Output Mux
//-----------------------------------------------------
assign clk_bf[1:0] = nfrzdrv ? interpolator_clk[1:0] : 2'b10;

//always @(*)
always @(*)
  casez ({loopback_en_n,nfrzdrv,latch_open_n,clk_bf[1:0]})
   5'b0_?_?_?? : {latch_p[1:0],latch_n[1:0]} <= #LATCH_DELAY {loopback_p,loopback_p,loopback_n,loopback_n};
   5'b1_0_?_?? : {latch_p[1:0],latch_n[1:0]} <= #LATCH_DELAY {d_out_p_mux[1],d_out_p_mux[1],d_out_n_mux[1],d_out_n_mux[1]};
   5'b1_1_0_?? : {latch_p[1:0],latch_n[1:0]} <= #LATCH_DELAY {d_out_p_mux[1],d_out_p_mux[0],d_out_n_mux[1],d_out_n_mux[0]};
   5'b1_1_1_00 : {latch_p[1:0],latch_n[1:0]} <= #LATCH_DELAY {d_out_p_mux[1],d_out_p_mux[0],d_out_n_mux[1],d_out_n_mux[0]};
//   5'b1_1_1_01 : {latch_p[1:0],latch_n[1:0]} <= #LATCH_DELAY {d_out_p_mux[1],latch_p[0],d_out_n_mux[1],latch_n[0]};
//   5'b1_1_1_10 : {latch_p[1:0],latch_n[1:0]} <= #LATCH_DELAY {latch_p[1],d_out_p_mux[0],latch_n[1],d_out_n_mux[0]};
//   5'b1_1_1_11 : {latch_p[1:0],latch_n[1:0]} <= #LATCH_DELAY {latch_p[1],latch_p[0],latch_n[1],latch_n[0]};
   5'b1_1_1_01 : {latch_p[1],latch_n[1]} <= #LATCH_DELAY {d_out_p_mux[1],d_out_n_mux[1]};
   5'b1_1_1_10 : {latch_p[0],latch_n[0]} <= #LATCH_DELAY {d_out_p_mux[0],d_out_n_mux[0]};
   5'b1_1_1_11 : ;
  endcase

always @(*)
  casez ({nfrzdrv,interpolator_clk[1:0]})
   3'b0_?? : {codin_p,codin_pb,codin_n,codin_nb} = {latch_p[0],~latch_p[1],latch_n[0],~latch_n[1]};
   3'b1_00 : {codin_p,codin_pb,codin_n,codin_nb} = {latch_p[0],~latch_p[0],latch_n[0],~latch_n[0]};
   3'b1_01 : {codin_p,codin_pb,codin_n,codin_nb} = {latch_p[0],~latch_p[0],latch_n[0],~latch_n[0]};
   3'b1_10 : {codin_p,codin_pb,codin_n,codin_nb} = {latch_p[1],~latch_p[1],latch_n[1],~latch_n[1]};
   3'b1_11 : {codin_p,codin_pb,codin_n,codin_nb} = {latch_p[1],~latch_p[1],latch_n[1],~latch_n[1]};
  endcase

endmodule
