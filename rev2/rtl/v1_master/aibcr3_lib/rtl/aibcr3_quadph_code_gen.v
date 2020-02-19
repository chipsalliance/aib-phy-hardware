// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
// Copyright (c) 2012 Altera Corporation. .
//
//------------------------------------------------------------------------
// File:        $RCSfile: aibcr3_quadph_code_gen.v $
// Date:        $DateTime: 2018/03/12 15:24:07 $
//------------------------------------------------------------------------
// Description: quadrature phase delay code generation logics
//------------------------------------------------------------------------

//------------------------------------------------------------------------
// To be considered :
// 1. any potential glitch between code switching?
//------------------------------------------------------------------------
module aibcr3_quadph_code_gen 
#(
parameter FF_DELAY     = 200
)
(
   input  wire         clk,                     //reference clock from pll
   input  wire         reset_n,                 //output for dll reset
   input  wire  [9:0]  pvt_ref_binary,          //output binary pvt value for delay chain
   input  wire         rb_quad_code,   		//select between original or quadrature codes
   output reg   [9:0]  pvt_ref_quad_binary 	//quadrature code (binary) for delay chain
);

`ifdef TIMESCALE_EN
  timeunit 1ps;
  timeprecision 1ps;
`endif

wire [6:0]  coarse_bin;
reg [2:0]  fint_bin;
wire [2:0]  fine_bin;
reg [8:0]  coarse_divided_bin;
reg [4:0]  fine_divided_bin, coarse_frac_bin;

          always @(*)
                begin
                        if(~reset_n) begin
                                coarse_divided_bin = 9'b0_0000_0000;
                                fine_divided_bin = 5'b0_0000;
                                coarse_frac_bin = 5'b0_0000;
                                fint_bin = 3'b000;
                        end
                        else  begin
                                coarse_divided_bin = {2'b00,pvt_ref_binary[9:3]};
                                fine_divided_bin = {2'b00,pvt_ref_binary[2:0]};
//                                coarse_frac_bin = {1'b0,coarse_divided_bin[1:0],2'b00};  //****need to finalize what's the ratio between coarse/fine steps. current coding assumes 20ps/5ps=4
                                coarse_frac_bin = {coarse_divided_bin[1:0],3'b000};
                                fint_bin = coarse_frac_bin[4:2] + fine_divided_bin[4:2];
                                         if ((fine_divided_bin[1:0] >= 2'd2)) begin
                                                fint_bin = fint_bin + 3'b001;
                                         end
                                         else begin
                                                fint_bin = fint_bin;
                                         end
                         end
                end

        assign coarse_bin = coarse_divided_bin[8:2];
 	assign fine_bin = fint_bin;

        always @(posedge clk or negedge reset_n)
                begin
                        if(~reset_n) begin
				pvt_ref_quad_binary <= #FF_DELAY 10'b00_0000_0000;
			end
			else case (rb_quad_code)
				1'b0 : pvt_ref_quad_binary <= #FF_DELAY pvt_ref_binary;
				1'b1 : pvt_ref_quad_binary <= #FF_DELAY {coarse_bin,fine_bin};
				default : pvt_ref_quad_binary <= #FF_DELAY {coarse_bin,fine_bin};
			endcase
		end 

endmodule // aibcr_quadph_code_gen

