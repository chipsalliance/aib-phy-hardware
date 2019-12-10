// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved
// *****************************************************************************
// *****************************************************************************
// Copyright © 2016 Altera Corporation. All rights reserved.  Altera products are 
// protected under numerous U.S. and foreign patents, maskwork rights, copyrights and 
// other intellectual property laws.                                                  
// *****************************************************************************
//  Module Name :  c3lib_dff0_scan_reset_svt_2x                                  
//  Date        :  Wed Aug 31 14:51:28 2016                                 
//  Description :                                                    
// *****************************************************************************

module c3lib_dff0_scan_reset_svt_2x( 

  clk, 
  rst_n, 
  data_in,
  data_out,

  scan_in,
  scan_en

  ); 

input		clk; 
input		rst_n; 
input		data_in;
output		data_out;

input		scan_in;
input		scan_en;

`ifdef USER_MACROS_ON
 //replace this section with user technology cell
 //for the purpose of cell hardening, synthesis don't touch
`else

  var	logic	dff_reg;

  always @(negedge rst_n or posedge clk) begin
    dff_reg <= (rst_n == 1'b0)? 1'b0 : (scan_en? scan_in : data_in);
  end

  assign data_out = dff_reg;
`endif
endmodule 

