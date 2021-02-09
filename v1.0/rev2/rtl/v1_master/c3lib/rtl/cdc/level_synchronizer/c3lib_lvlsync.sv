// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// ****************************************************************************
// ****************************************************************************
// Copyright © 2016 Altera Corporation.                                            
// ****************************************************************************
//  Module Name :  c3lib_lvlsync                                  
//  Date        :  Fri Mar 18 14:31:42 2016                                 
//  Description :  Level Synchronizer 
// ****************************************************************************

module  c3lib_lvlsync #(

  parameter	EN_PULSE_MODE	= 0,	// Enable Pulse mode i.e O/P data pulses for change in I/P
  parameter	DWIDTH		= 1,	// Sync Data input 
  parameter	ACTIVE_LEVEL	= 1,	// 1: Active high; 0: Active low
  parameter	DST_CLK_FREQ_MHZ= 500,	// Clock frequency for destination domain in MHz
  parameter	SRC_CLK_FREQ_MHZ= 500	// Clock frequency for source domain in MHz

) (

   // Inputs
   input  wire               wr_clk,      // write clock
   input  wire               rd_clk,      // read clock
   input  wire               wr_rst_n,    // async reset for write clock domain
   input  wire               rd_rst_n,    // async reset for read clock domain
   input  wire  [DWIDTH-1:0] data_in,     // data in

   // Outputs
   output reg   [DWIDTH-1:0] data_out     // data out

);

localparam	DATA_RATE = ( DST_CLK_FREQ_MHZ * SRC_CLK_FREQ_MHZ ) / ( 2*DST_CLK_FREQ_MHZ + 2*SRC_CLK_FREQ_MHZ );




//******************************************************************************
// Define regs
//******************************************************************************
reg  [DWIDTH-1:0]  data_in_d0;
reg  [DWIDTH-1:0]  req_wr_clk;
wire [DWIDTH-1:0]  req_rd_clk;
wire [DWIDTH-1:0]  ack_wr_clk;
wire [DWIDTH-1:0]  ack_rd_clk;
reg  [DWIDTH-1:0]  req_rd_clk_d0;



//******************************************************************************
// Generate for multi bits
//******************************************************************************

genvar i;
generate
for (i=0; i < DWIDTH; i=i+1) begin : LVLSYNC



//******************************************************************************
// WRITE CLOCK DOMAIN: Generate req & Store data when synchroniztion is not
// already in progress 
//******************************************************************************

   always @(negedge wr_rst_n or posedge wr_clk) begin
      if (wr_rst_n == 1'b0) begin
         if (ACTIVE_LEVEL == 1) 
           begin
             data_in_d0[i] <= 1'b0;
           end
         else  // ACTIVE_LEVEL==0
           begin
             data_in_d0[i] <= 1'b1;
           end         
         req_wr_clk[i] <= 1'b0;
      end
      else begin
         // Store data when Write Req equals Write Ack
         if (req_wr_clk[i] == ack_wr_clk[i]) begin
            data_in_d0[i] <= data_in[i];
         end
         
         // Generate a Req when there is change in data 
         if (EN_PULSE_MODE == 0) begin
            if ((req_wr_clk[i] == ack_wr_clk[i]) & (data_in_d0[i] != data_in[i])) begin
               req_wr_clk[i] <= ~req_wr_clk[i];
            end
         end
         else begin
            if (ACTIVE_LEVEL == 1) begin 
               if ((req_wr_clk[i] == ack_wr_clk[i]) & (data_in_d0[i] != data_in[i]) & data_in[i] == 1'b1) begin
                  req_wr_clk[i] <= ~req_wr_clk[i];
               end
            end
            else begin
               if ((req_wr_clk[i] == ack_wr_clk[i]) & (data_in_d0[i] != data_in[i]) & data_in[i] == 1'b0) begin
                  req_wr_clk[i] <= ~req_wr_clk[i];
               end
            end
         end
      end
   end



//******************************************************************************
// WRITE CLOCK DOMAIN:  
//******************************************************************************

  c3lib_bitsync #(

    .DWIDTH		( 1 ),
    .RESET_VAL		( 0 ),
    .DST_CLK_FREQ_MHZ	( SRC_CLK_FREQ_MHZ ),
    .SRC_DATA_FREQ_MHZ	( DATA_RATE )

  ) bitsync_u_ack_wr_clk (

     .clk      (wr_clk),
     .rst_n    (wr_rst_n),
     .data_in  (ack_rd_clk[i]),
     .data_out (ack_wr_clk[i])

  ); 



//******************************************************************************
// READ CLOCK DOMAIN:  
//******************************************************************************

  c3lib_bitsync #(

    .DWIDTH		( 1 ),
    .RESET_VAL		( 0 ),
    .DST_CLK_FREQ_MHZ	( DST_CLK_FREQ_MHZ ),
    .SRC_DATA_FREQ_MHZ	( DATA_RATE )

  ) bitsync_u_req_rd_clk (

     .clk      (rd_clk),
     .rst_n    (rd_rst_n),
     .data_in  (req_wr_clk[i]),
     .data_out (req_rd_clk[i])

  ); 



//******************************************************************************
// READ CLOCK DOMAIN:  
//******************************************************************************

   assign ack_rd_clk[i] = req_rd_clk_d0[i];

   always @(negedge rd_rst_n or posedge rd_clk) begin
      if (rd_rst_n == 1'b0) begin
         if (ACTIVE_LEVEL == 1) 
           begin
             data_out[i]      <= 1'b0;
           end
         else
           begin
             data_out[i]      <= 1'b1;
           end
         req_rd_clk_d0[i] <= 1'b0; 
      end
      else begin 
         req_rd_clk_d0[i] <= req_rd_clk[i];
         if (EN_PULSE_MODE == 0) begin
            if (req_rd_clk_d0[i] != req_rd_clk[i]) begin
               data_out[i] <= ~data_out[i];
            end
         end
         else if (EN_PULSE_MODE == 1) begin
            if (req_rd_clk_d0[i] != req_rd_clk[i]) begin
              if (ACTIVE_LEVEL == 1) 
                begin
                  data_out[i] <= 1'b1;
                end
              else // ACTIVE_LEVEL==0
                begin
                  data_out[i] <= 1'b0;
                end              
            end
            else begin // EN_PULSE_MODE==0
              if (ACTIVE_LEVEL == 1)
                begin
                  data_out[i] <= 1'b0;
                end
              else  // ACTIVE_LEVEL==0
                begin
                  data_out[i] <= 1'b1;
                end              
            end
         end
      end
   end
end



endgenerate



endmodule // cdclib_lvlsync

