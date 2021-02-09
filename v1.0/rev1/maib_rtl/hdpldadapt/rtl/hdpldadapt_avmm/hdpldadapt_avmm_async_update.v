// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module hdpldadapt_avmm_async_update (
input  wire  avmm_clock_osc_clk,
input  wire  avmm_reset_osc_clk_rst_n,
input  wire  async_data_in,
input  wire  sr_load,

output reg  async_data_out 
);


always @(negedge avmm_reset_osc_clk_rst_n or posedge avmm_clock_osc_clk)
  if (avmm_reset_osc_clk_rst_n == 1'b0)
    begin
      async_data_out <= 1'b0;
    end
  else
    begin
      async_data_out <= sr_load ? async_data_in : async_data_out;
    end



endmodule
