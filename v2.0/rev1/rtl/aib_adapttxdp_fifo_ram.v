// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module aib_adapttxdp_fifo_ram
  #(
    parameter DWIDTH = 'd80,             // FIFO Input data width 
    parameter DEPTH  = 'd16              // FIFO Depth 
    )
(
    input  wire                wr_clk,     // Write Domain Clock
    input  wire                wr_en,      // write enable
    input  wire		       wr_rst_n,   // Write Domain Reset 
    input  wire [DEPTH-1:0]    wr_ptr,     // Write Pointer
    input  wire [DWIDTH*4-1:0] wr_data,    // Write Data In
    input  wire [DEPTH-1:0]    rd_ptr,     // Read Pointer
    output reg  [DWIDTH*4-1:0] rd_data   // Read Data

);

   //********************************************************************
   // Infer Memory or use Dual Port Memory from Quartus/ASIC Memory
   //********************************************************************
   
   integer		m;
   integer		i;
   reg [DWIDTH*4-1:0]   fifo_mem [DEPTH-1:0];
   
   always @(negedge wr_rst_n or posedge wr_clk) begin
      if (~wr_rst_n) begin
         for (m='d0; m<=(DEPTH-1'b1); m=m+1'b1)
            fifo_mem[m] <= 'd0;	
      end 
      else if (wr_en) begin
         for (m='d0; m<=(DEPTH-1'b1); m=m+1'b1) begin
           if (wr_ptr[m]) begin
             fifo_mem[m] <= wr_data;
           end  
         end   
      end
   end
   
//assign rd_data = fifo_mem[rd_ptr];

  always @ *
    begin: data_out 
      rd_data = fifo_mem[0];
      for (i='d0; i<=(DEPTH-1'b1); i=i+1'b1) begin
        if (rd_ptr[i]) begin
          rd_data = fifo_mem[i];
      end       
    end   
  end 


endmodule
