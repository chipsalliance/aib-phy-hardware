// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module aib_adaptrxdp_map (

input wire  [39:0]  din,
input wire  [79:0]  rx_fifo_data_out,      // Data from rx fifo

input wire         rx_aib_transfer_clk,
input wire         rx_aib_transfer_rst_n,
input wire         rx_clock_fifo_rd_clk,
input wire         rx_reset_fifo_rd_rst_n,

output reg  [79:0]   r_fifo_dout,
output reg  [39:0]   reg_dout

);


always @(posedge rx_clock_fifo_rd_clk or negedge rx_reset_fifo_rd_rst_n) begin
   if (!rx_reset_fifo_rd_rst_n) 
     begin
      r_fifo_dout[79:0] <= {80{1'b0}};
     end
   else begin
       r_fifo_dout[79:0] <= rx_fifo_data_out[79:0];
   end
end


always @(posedge rx_aib_transfer_clk or negedge rx_aib_transfer_rst_n) begin
   if (!rx_aib_transfer_rst_n) 
    begin
     reg_dout[39:0] <= {40{1'b0}};
    end
   else begin
       reg_dout[39:0] <= din[39:0];
   end
end


endmodule
