// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//****************************************************************************************
// Copyright (C) 2011 Altera Corporation. .
//
//****************************************************************************************

//------------------------------------------------------------------------
// Description: altr_hps_latch:
//       Active low transparent latch.
//------------------------------------------------------------------------

module altr_hps_latch(
  d,        // Latch input
  q,        // Latch output
  e_n);     // Enable

input d,
      e_n;
output q;

`ifdef ALTR_HPS_INTEL_MACROS_OFF
  reg q;

  always @(e_n or d)
    begin
      if(~e_n)
        q <= d;
    end
`else
`endif

endmodule // altr_hps_latch



