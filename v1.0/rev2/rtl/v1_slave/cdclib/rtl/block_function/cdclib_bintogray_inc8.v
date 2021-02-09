// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
//
// Revision:    $Revision: #1 $
// Date:        $DateTime: 2014/08/24 20:43:27 $
//------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// Description : Binary to Gray conversion when binary count is expected to increment by 8
//-----------------------------------------------------------------------------

module cdclib_bintogray_inc8
   #(
      parameter WIDTH           = 6 // Data width 
    )
   (
   // Inputs
   input  wire [WIDTH-1:0]  data_in,       // data in
   // Outputs
   output wire  [WIDTH-1:0]  data_out       // data out
   );


assign data_out = {(data_in[WIDTH-1:3]>>1) ^ data_in[WIDTH-1:3], 3'b0};


endmodule
