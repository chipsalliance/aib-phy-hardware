// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//test control register (clock chain)
module c3aibadapt_cmn_occ_test_ctlregs (
  clk,
  rst_n,
  ctrl
//  clken
);

input clk;
input rst_n;
output [1:0] ctrl;
//output clken;

// test clock enable
//reg clken /* synopsys preserve_sequential */;

//always @(posedge clk)
//begin
//  clken <= clken;
//end

// counter logic
reg [1:0] ctrl /* synopsys preserve_sequential */;

always @(posedge clk or negedge rst_n)
begin
  if(rst_n == 1'b0)
    ctrl <= 2'b00;
  else
    ctrl <= ctrl;
end

endmodule
