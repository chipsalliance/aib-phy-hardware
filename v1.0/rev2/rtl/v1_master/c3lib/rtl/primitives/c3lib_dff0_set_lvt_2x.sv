// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// *****************************************************************************
// *****************************************************************************
// Copyright (C) 2016 Altera Corporation.                                        
// *****************************************************************************
//  Module Name :  c3lib_dff0_set_lvt_2x                                  
//  Date        :  Thu Jun  2 17:36:42 2016                                 
//  Description :  D flip-flow w/ no scan, LVT, 2x drive strength
// *****************************************************************************

module c3lib_dff0_set_lvt_2x( 

  clk, 
  rst_n, 
  data_in,
  data_out

  ); 

input		clk; 
input		rst_n; 
input		data_in;
output		data_out;
`ifdef BEHAVIORAL

  var	logic	dff_reg;

  always @(negedge rst_n or posedge clk) begin
    dff_reg <= (rst_n == 1'b0)? 1'b1 : data_in;
  end

  assign data_out = dff_reg;
`else
 //replace this section with user technology cell 
 //for the purpose of cell hardening, synthesis don't touch 
 $display("ERROR : %m : replace this section with user technology cell");
 $finish;
`endif

endmodule 

