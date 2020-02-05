// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// *****************************************************************************
// *****************************************************************************
// Copyright © 2016 Altera Corporation.                                            
// *****************************************************************************
//  Module Name :  c3lib_ckdiv8_ctn
//  Date        :  Thu Jun  2 18:03:08 2016                                 
//  Description :  DIV2 clock divider
// *****************************************************************************

module c3lib_ckdiv8_ctn #(

  parameter		RESET_VAL = 0		// Reset value is LOW if set to 0, otherwise HIGH

) (

  input  logic		clk_in,
  input  logic		rst_n,
  output logic		clk_out

); 

  var	logic	int_s0_clk_out;
  var	logic	int_s1_clk_out;
  var	logic	int_s2_clk_out;

  var	logic	int_s0_clk_in;
  var	logic	int_s1_clk_in;
  var	logic	int_s2_clk_in;

  // assign int_s0_clk_in = ~int_s0_clk_out;
  // assign int_s1_clk_in = int_s1_clk_out ^ int_s0_clk_out;
  // assign int_s2_clk_in = (int_s1_clk_out & int_s0_clk_out) ^ int_s2_clk_out;
  
  generate
    if (RESET_VAL == 0) begin : RESET_VAL_0
      always @(negedge rst_n or posedge clk_in) begin
        if (!rst_n) begin
          int_s0_clk_out = 1'b0;
          int_s1_clk_out = 1'b0;
          int_s2_clk_out = 1'b0;
        end
        else begin
          int_s0_clk_in = ~int_s0_clk_out;
          int_s1_clk_in = int_s1_clk_out ^ int_s0_clk_out;
          int_s2_clk_in = (int_s1_clk_out & int_s0_clk_out) ^ int_s2_clk_out;
          int_s0_clk_out = int_s0_clk_in;
          int_s1_clk_out = int_s1_clk_in;
          int_s2_clk_out = int_s2_clk_in;
          // c3lib_dff0_reset_lvt_2x u_c3lib_dff0_reset_lvt_2x_s0( .clk( clk_in ), .rst_n( rst_n ), .data_in( int_s0_clk_in ), .data_out( int_s0_clk_out ) );
          // c3lib_dff0_reset_lvt_2x u_c3lib_dff0_reset_lvt_2x_s1( .clk( clk_in ), .rst_n( rst_n ), .data_in( int_s1_clk_in ), .data_out( int_s1_clk_out ) );
          // c3lib_dff0_reset_lvt_2x u_c3lib_dff0_reset_lvt_2x_s2( .clk( clk_in ), .rst_n( rst_n ), .data_in( int_s2_clk_in ), .data_out( int_s2_clk_out ) );
        end
      end
    end
    else begin : RESET_VAL_1
      always @(negedge rst_n or posedge clk_in) begin
        if (!rst_n) begin
          int_s0_clk_out = 1'b0;
          int_s1_clk_out = 1'b0;
          int_s2_clk_out = 1'b1;
        end
        else begin
          int_s0_clk_in = ~int_s0_clk_out;
          int_s1_clk_in = int_s1_clk_out ^ int_s0_clk_out;
          int_s2_clk_in = (int_s1_clk_out & int_s0_clk_out) ^ int_s2_clk_out;
          int_s0_clk_out = int_s0_clk_in;
          int_s1_clk_out = int_s1_clk_in;
          int_s2_clk_out = int_s2_clk_in;
          // c3lib_dff0_reset_lvt_2x u_c3lib_dff0_reset_lvt_2x_s0( .clk( clk_in ), .rst_n( rst_n ), .data_in( int_s0_clk_in ), .data_out( int_s0_clk_out ) );
          // c3lib_dff0_reset_lvt_2x u_c3lib_dff0_reset_lvt_2x_s1( .clk( clk_in ), .rst_n( rst_n ), .data_in( int_s1_clk_in ), .data_out( int_s1_clk_out ) );
          // c3lib_dff0_set_lvt_2x   u_c3lib_dff0_set_lvt_2x_s2  ( .clk( clk_in ), .rst_n( rst_n ), .data_in( int_s2_clk_in ), .data_out( int_s2_clk_out ) );
        end
      end
    end
  endgenerate

  assign clk_out = int_s2_clk_out;

endmodule 

