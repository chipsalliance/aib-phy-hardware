// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved
// *****************************************************************************
// *****************************************************************************
// Copyright © 2016 Altera Corporation. All rights reserved.  Altera products are 
// protected under numerous U.S. and foreign patents, maskwork rights, copyrights and 
// other intellectual property laws.                                                  
// *****************************************************************************
//  Module Name :  c3lib_ckdiv2_ctn                                  
//  Date        :  Thu Jun  2 18:03:08 2016                                 
//  Description :  DIV2 clock divider
// *****************************************************************************

module c3lib_ckdiv2_ctn #(

  parameter		RESET_VAL = 0		// Reset value is LOW if set to 0, otherwise HIGH

) (

  input  logic		clk_in,
  input  logic		rst_n,
  output logic		clk_out

); 

  var	logic	int_clk_out;
  var	logic	int_clk_in;

  // assign int_clk_in = !int_clk_out;

  generate
    if (RESET_VAL == 0) begin : RESET_VAL_0
      always @(negedge rst_n or posedge clk_in) begin
        if (!rst_n) begin
          int_clk_out = 1'b0;
        end
        else begin
          int_clk_in = !int_clk_out;
          int_clk_out = int_clk_in;
          // c3lib_dff0_reset_lvt_2x #( .BLOCKING( 1 ) ) u_c3lib_dff0_reset_lvt_2x( .clk( clk_in ), .rst_n( rst_n ), .data_in( int_clk_in ), .data_out( int_clk_out ) );
        end
      end
    end
    else begin : RESET_VAL_1
      always @(negedge rst_n or posedge clk_in) begin
        if (!rst_n) begin
          int_clk_out = 1'b1;
        end
        else begin
          int_clk_in = !int_clk_out;
          int_clk_out = int_clk_in;
          // c3lib_dff0_set_lvt_2x   #( .BLOCKING( 1 ) ) u_c3lib_dff0_set_lvt_2x  ( .clk( clk_in ), .rst_n( rst_n ), .data_in( int_clk_in ), .data_out( int_clk_out ) );
        end
      end
    end
  endgenerate

  assign clk_out = int_clk_out;

endmodule 


