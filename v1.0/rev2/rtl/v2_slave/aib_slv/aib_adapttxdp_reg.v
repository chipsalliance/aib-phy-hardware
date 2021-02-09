// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module aib_adapttxdp_reg (
  input wire         tx_clock_fifo_rd_clk,
  input wire         tx_reset_fifo_rd_rst_n,
  input wire [1:0]   r_tx_fifo_mode,
  input wire [39:0]  data_in,
  
  output reg [39:0] reg_dout
);

always @(posedge tx_clock_fifo_rd_clk or negedge tx_reset_fifo_rd_rst_n) begin
   if (!tx_reset_fifo_rd_rst_n) 
     reg_dout <= {40{1'b0}};
   else if (r_tx_fifo_mode[1:0] == 2'b11) begin
       reg_dout[39:0] <= data_in[39:0];
   end
end

endmodule
