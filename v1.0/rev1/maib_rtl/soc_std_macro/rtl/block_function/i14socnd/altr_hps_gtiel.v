// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//****************************************************************************************
// (C) 2011 Altera Corporation. .
//
//****************************************************************************************

//------------------------------------------------------------------------
// Description: GTIEL cell
// 
// GTIEH is a special "buffer" where the output polarity (1 or 0) can be changed 
// at M2 layer
// 
// GITEL will by default drive a constant "0"
//
//------------------------------------------------------------------------

module altr_hps_gtiel (
    output wire         z_out     // output
);

`ifdef ALTR_HPS_INTEL_MACROS_OFF
   assign z_out = 1'b0;
`else
`endif

endmodule // altr_hps_gtiel
