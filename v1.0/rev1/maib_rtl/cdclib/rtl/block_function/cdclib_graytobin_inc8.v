// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
//
// Revision:    $Revision: #1 $
// Date:        $DateTime: 2014/08/24 20:43:27 $
//------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// Description : Gray to binary conversion when binary count is expected to increment by 8
//-----------------------------------------------------------------------------

module cdclib_graytobin_inc8
   #(
      parameter WIDTH           = 6 // Data width 
    )
   (
   // Inputs
   input  wire [WIDTH-1:0]  data_in,       // data in
   // Outputs
   output wire  [WIDTH-1:0]  data_out       // data out
   );


   genvar                      i;
   
   assign data_out[2:0] = 3'b000;
   generate
      for (i = 3; i <= WIDTH-1; i = i+1) begin: GREY_TO_BIN
        assign data_out[i] = ^(data_in >> i);            
         
      end // block: GRAY_TO_BIN
   endgenerate


endmodule
