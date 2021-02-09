// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//****************************************************************************************
// (C) 2011 Altera Corporation. .
//
//****************************************************************************************

//------------------------------------------------------------------------
// Description: standard nor2 gate
//
//------------------------------------------------------------------------

module altr_hps_nor2
    (
    input  wire              nor_in1,     // and input 1
    input  wire              nor_in2,     // and input 2
    output  wire             nor_out      // and output
     );

`ifdef ALTR_HPS_INTEL_MACROS_OFF
    assign nor_out = ~(nor_in1 | nor_in2);
`else
`endif

endmodule // altr_hps_nor2
