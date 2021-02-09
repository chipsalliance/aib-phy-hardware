// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
// Copyright (c) 2012 Altera Corporation. .
//
//------------------------------------------------------------------------
// File:        aibcr3pnr_half_cycle_code_gen.v
// Date:        2016/07/4 
//------------------------------------------------------------------------
// Description: half cycle delay code generation logics
//------------------------------------------------------------------------

//------------------------------------------------------------------------
// To be considered :
// 1. any potential glitch between code switching?
//------------------------------------------------------------------------

`timescale 1ps/1ps
module aibcr3pnr_half_cycle_code_gen 
#(
parameter FF_DELAY     = 200
)
(
   input  wire          clk,                     //reference clock from pll
   input  wire          reset_n,                 //output for dll reset
   input  wire  [10:0]  pvt_ref_binary,          //output binary pvt value for delay chain; changed from [9:0] to [10:0]
   input  wire          rb_half_code,   	 //select between original or half cycle codes
   output reg   [10:0]  pvt_ref_half_binary 	 //half cycle code (binary) for delay chain; change from [9:0] to [10:0]
);

`ifdef TIMESCALE_EN
  timeunit 1ps;
  timeprecision 1ps;
`endif

wire [7:0]  coarse_bin;                           // change from [6:0] to [7:0]
wire [2:0]  fint_bin, fint_bin_inc;
wire [2:0]  fine_bin;
wire [8:0]  coarse_divided_bin;                   // change from [7:0] to [8:0]
wire [3:0]  fine_divided_bin, coarse_frac_bin;

                        assign  coarse_divided_bin[8:0] = {1'b0,pvt_ref_binary[10:3]}; // changed from pvt_ref_binary[9:3] to [10:3]
                        assign  fine_divided_bin[3:0] = {1'b0,pvt_ref_binary[2:0]};
                        assign  coarse_frac_bin[3:0] = {coarse_divided_bin[0],3'b000};
                        assign  fint_bin[2:0] = coarse_frac_bin[3:1] + fine_divided_bin[3:1];
                        assign  fint_bin_inc[2:0] = ((fine_divided_bin[0] >= 1'd1) && (fint_bin < 3'd7)) ? fint_bin[2:0] + 3'b001 : fint_bin[2:0];

        assign coarse_bin = coarse_divided_bin[8:1]; // change from [7:1] to [8:1]
        assign fine_bin = fint_bin_inc;

        always @(posedge clk or negedge reset_n)
                begin
                        if(~reset_n) begin
				pvt_ref_half_binary <= #FF_DELAY 11'b000_0000_0000;
			end
			else case (rb_half_code)
				1'b0 : pvt_ref_half_binary <= #FF_DELAY pvt_ref_binary;
				1'b1 : pvt_ref_half_binary <= #FF_DELAY {coarse_bin,fine_bin};
				default : pvt_ref_half_binary <= #FF_DELAY {coarse_bin,fine_bin};
			endcase
		end 

endmodule // aibcr3pnr_half_cycle_code_gen
