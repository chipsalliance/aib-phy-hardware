// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module cfg_cmn_latch (
  input      din,
  input      clk,
  output reg dout
);

  always @(*)
    if (clk)
      dout <= din;

endmodule
