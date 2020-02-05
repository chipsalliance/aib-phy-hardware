// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//-----------------------------------------------------------------------------
//  Clock inverter macro
//-----------------------------------------------------------------------------

module altr_hps_ckinv (
  clk,
  clk_inv
);

// -------------------
// Port declarations
// -------------------

input clk;
output clk_inv;

// -----
// RTL
// -----

`ifdef ALTR_HPS_INTEL_MACROS_OFF
assign clk_inv = !clk;

`else



`endif

endmodule
