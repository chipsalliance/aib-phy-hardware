// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module cfg_cmn_non_scan_reg (
  input      din,
  input      clk,
  output reg dout
);

  always @(posedge clk)
    dout <= din;

endmodule
