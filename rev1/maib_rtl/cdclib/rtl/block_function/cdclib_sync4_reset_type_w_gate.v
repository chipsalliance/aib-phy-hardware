// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//****************************************************************************************
// (C) 2009 Altera Corporation. .
//
//****************************************************************************************

//------------------------------------------------------------------------
// File:        $RCSfile: cdclib_sync4_reset_type_w_gate.v.rca $
// Revision:    $Revision: #1 $
// Date:        $Date: 2015/03/20 $
//------------------------------------------------------------------------
// Description:
//
//------------------------------------------------------------------------
module cdclib_sync4_reset_type_w_gate
    (
    input  wire              clk,     // clock
    input  wire              rst_n,   // async reset
    input  wire 	     data_in, // data in
    output wire 	     data_out // data out
     );


   reg		data_in_sync;
   reg		data_in_sync2;
   reg		data_in_sync3;
   reg		data_in_sync4;
   
   always @(negedge rst_n or posedge clk) begin
      if (rst_n == 1'b0) begin
        data_in_sync <= 	1'b0;
        data_in_sync2 <= 	1'b0;
        data_in_sync3 <= 	1'b0;
        data_in_sync4 <= 	1'b0;
      end
      else begin
        data_in_sync <= 	data_in;
        data_in_sync2 <= 	data_in_sync;
        data_in_sync3 <= 	data_in_sync2;
        data_in_sync4 <= 	data_in_sync3;
      end
   end    
     
   assign data_out = data_in_sync4;

endmodule // cdclib_sync4_reset_type_w_gate

