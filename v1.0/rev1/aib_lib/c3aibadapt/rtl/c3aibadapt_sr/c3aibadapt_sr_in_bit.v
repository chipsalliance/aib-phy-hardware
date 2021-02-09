// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3aibadapt_sr_in_bit
 #(
    parameter RESET_VAL    = 0     // Reset value
  )
(
input wire  sr_load_in,
input wire  sr_shift_in,
input wire  sr_load,
input wire  clk,
input wire  rst_n,

output reg  sr_dataout
);

localparam reset_value = (RESET_VAL == 1) ? 1'b1 : 1'b0;

always @(negedge rst_n or posedge clk)
  if (rst_n == 1'b0)
    begin
      sr_dataout <= reset_value;
    end
  else
    begin
      sr_dataout <= sr_load ? sr_load_in : sr_shift_in;
    end


endmodule
