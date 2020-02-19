// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//****************************************************************************************
// (C) 2011 Altera Corporation. .
//
//****************************************************************************************

//------------------------------------------------------------------------
// Description: standard clock buf
// 
// A simple clock buffer. 
// Use this as a convenient point for clock definition for internally generated clocks
// All "create_clock" commands can then refer to this buffer
//
//------------------------------------------------------------------------

module altr_hps_ckbuf (
    input  wire         ck_in,     // clock input
    output wire         ck_out     // clock output
);

`ifdef ALTR_HPS_INTEL_MACROS_OFF
   assign ck_out = ck_in;
`else
   

`endif

endmodule // altr_hps_ckbuf
