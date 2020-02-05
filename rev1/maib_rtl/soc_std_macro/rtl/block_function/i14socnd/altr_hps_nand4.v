// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//****************************************************************************************
// (C) 2011 Altera Corporation. .
//
//****************************************************************************************

//------------------------------------------------------------------------
// Description: standard nand4 gate
//
//------------------------------------------------------------------------

module altr_hps_nand4
    (
    input  wire              nand_in1,     // and input 1
    input  wire              nand_in2,     // and input 2
    input  wire              nand_in3,     // and input 3
    input  wire              nand_in4,     // and input 4
    output  wire             nand_out      // and output
     );

`ifdef ALTR_HPS_INTEL_MACROS_OFF
    assign nand_out = ~(nand_in1 & nand_in2 & nand_in3 & nand_in4);
`else

`endif

endmodule // altr_hps_nand2
