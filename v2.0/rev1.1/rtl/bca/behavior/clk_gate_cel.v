// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.

module clk_gate_cel(
output clkout, // Clock gated
input  clk,    // Clock input
input  en,     // Clock enable
input  te      // Test enable
);

wire clk_en;
reg  latch;
assign clk_en = te | en;

always @(clk or clk_en)
  begin
    if(!clk)
      latch = clk_en;
  end

assign clkout = latch & clk;

endmodule // clk_gate_cel
