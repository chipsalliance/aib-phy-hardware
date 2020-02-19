// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//-----------------------------------------------------------------------------
//  Clock gate using OR.
//-----------------------------------------------------------------------------
//Gates output clock to 1'b1 when clk_gate=1
//Allows clk --> clk_o when clk_gate=0

module altr_hps_clkgate_or (
  clk,
  clk_gate,
  clk_o
);

// -------------------
// Port declarations
// -------------------

input clk;
input clk_gate;
output clk_o;

// -----
// RTL
// -----

`ifdef ALTR_HPS_INTEL_MACROS_OFF
//assign clk_o = clk | clk_gate;
//fixed behavioral model to match cgc81
reg clk_enable_lat;
 
always @ (clk or clk_gate)
  begin
    if (clk)
      clk_enable_lat <= clk_gate;
  end
 
assign clk_o = clk | clk_enable_lat;

`else

`endif

endmodule
