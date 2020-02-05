// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
//
// Revision:    $Revision: #1 $
// Date:        $DateTime: 2014/09/20 12:06:43 $
//------------------------------------------------------------------------
// Description: 16 phase interpolator min
//
//------------------------------------------------------------------------

module io_filter_dec (
input	   [1:0] filter_code,      // 00 = 1.6 GHz, 01 = 1.2 GHz, 10 = 1.0 GHz, 11 = 0.8 GHz
output	   [3:1] scp,     
output reg [3:1] scn     
);

//filter code decode

always @(*)
  case (filter_code[1:0])
    2'b00 :  scn[3:1] = 3'b000;
    2'b01 :  scn[3:1] = 3'b001;
    2'b10 :  scn[3:1] = 3'b011;
    2'b11 :  scn[3:1] = 3'b111;
  endcase
assign scp[3:1] = ~scn[3:1];

endmodule


