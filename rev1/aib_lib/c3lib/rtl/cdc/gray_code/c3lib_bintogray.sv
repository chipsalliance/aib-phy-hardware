// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//----------------------------------------------------------------------------- 
//----------------------------------------------------------------------------- 
// Copyright © 2016 Altera Corporation.                                           
//----------------------------------------------------------------------------- 
//  Module Name :  c3lib_bintogray                                  
//  Date        :  Thu Mar 24 15:40:57 2016                                 
//  Description :  Ported over from MAIB
//-----------------------------------------------------------------------------  

module  c3lib_bintogray #(

  parameter	WIDTH = 2 // Data width 

) (

   // Inputs
   input  wire [WIDTH-1:0]	data_in,

   // Outputs
   output wire  [WIDTH-1:0]	data_out

);


assign data_out = (data_in>>1) ^ data_in;

endmodule 

