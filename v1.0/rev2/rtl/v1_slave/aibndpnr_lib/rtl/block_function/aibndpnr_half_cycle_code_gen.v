// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
//
// Revision:    $Revision: #3 $
// Date:        $DateTime: 2015/06/17 03:55:49 $
//------------------------------------------------------------------------
// Description: half cycle delay code generation logics
//------------------------------------------------------------------------

//------------------------------------------------------------------------
// To be considered :
// 1. any potential glitch between code switching?
//------------------------------------------------------------------------
module aibndpnr_half_cycle_code_gen 
#(
parameter FF_DELAY     = 200
)
(
   input  wire         clk,                     //reference clock from pll
   input  wire         reset_n,                 //output for dll reset
   input  wire  [9:0]  pvt_ref_binary,          //output binary pvt value for delay chain
   input  wire         rb_half_code,   		//select between original or half cycle codes
   output reg   [9:0]  pvt_ref_half_binary 	//half cycle code (binary) for delay chain
);

`ifdef TIMESCALE_EN
  timeunit 1ps;
  timeprecision 1ps;
`endif

wire [6:0]  coarse_bin;
wire [2:0]  fint_bin, fint_bin_inc;
wire [2:0]  fine_bin;
wire [7:0]  coarse_divided_bin;
wire [3:0]  fine_divided_bin, coarse_frac_bin;

                        assign  coarse_divided_bin[7:0] = {1'b0,pvt_ref_binary[9:3]};
                        assign  fine_divided_bin[3:0] = {1'b0,pvt_ref_binary[2:0]};
                        assign  coarse_frac_bin[3:0] = {coarse_divided_bin[0],3'b000};
                        assign  fint_bin[2:0] = coarse_frac_bin[3:1] + fine_divided_bin[3:1];
                        assign  fint_bin_inc[2:0] = ((fine_divided_bin[0] >= 1'd1) && (fint_bin < 3'd7)) ? fint_bin[2:0] + 3'b001 : fint_bin[2:0];

        assign coarse_bin = coarse_divided_bin[7:1];
        assign fine_bin = fint_bin_inc;

        always @(posedge clk or negedge reset_n)
                begin
                        if(~reset_n) begin
				pvt_ref_half_binary <= #FF_DELAY 10'b00_0000_0000;
			end
			else case (rb_half_code)
				1'b0 : pvt_ref_half_binary <= #FF_DELAY pvt_ref_binary;
				1'b1 : pvt_ref_half_binary <= #FF_DELAY {coarse_bin,fine_bin};
				default : pvt_ref_half_binary <= #FF_DELAY {coarse_bin,fine_bin};
			endcase
		end 

endmodule // aibndpnr_half_cycle_code_gen
