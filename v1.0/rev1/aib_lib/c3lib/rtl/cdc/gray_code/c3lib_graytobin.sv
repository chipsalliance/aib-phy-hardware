// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//----------------------------------------------------------------------------- 
//----------------------------------------------------------------------------- 
// Copyright © 2016 Altera Corporation.                                          
//----------------------------------------------------------------------------- 
//  Module Name :  c3lib_graytobin                                  
//  Date        :  Thu Mar 24 15:40:46 2016                                 
//  Description :                                                    
//-----------------------------------------------------------------------------  

module  c3lib_graytobin #(

  parameter	WIDTH = 2	// Data width 

) (

   // Inputs
   input  wire [WIDTH-1:0]	data_in,

   // Outputs
   output wire  [WIDTH-1:0]	data_out

);

  genvar	i;
   
  generate

    for (i = 0; i <= WIDTH-1; i = i+1) begin: GRAY_TO_BIN
      assign data_out[i] = ^(data_in >> i);            
    end

  endgenerate

endmodule 

