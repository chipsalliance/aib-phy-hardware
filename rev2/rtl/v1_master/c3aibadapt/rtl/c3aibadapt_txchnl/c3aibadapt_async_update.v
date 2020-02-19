// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3aibadapt_async_update  
 #(
    parameter AWIDTH    = 1,    // Async input width
    parameter RESET_VAL = 0     // Reset value
  )
(
input  wire              clk,     
input  wire              rst_n,   
input  wire              sr_load,
input  wire [AWIDTH-1:0] async_data_in, 
output reg  [AWIDTH-1:0] async_data_out 
);

localparam reset_value = (RESET_VAL == 1) ? 1'b1 : 1'b0;

always @(negedge rst_n or posedge clk)
  if (rst_n == 1'b0)
    begin
      async_data_out[AWIDTH-1:0] <= {(AWIDTH){reset_value}};
    end
  else
    begin
      async_data_out[AWIDTH-1:0] <= sr_load ? async_data_in[AWIDTH-1:0] : async_data_out[AWIDTH-1:0];
    end


endmodule

