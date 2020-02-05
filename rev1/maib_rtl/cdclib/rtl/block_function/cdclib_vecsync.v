// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//****************************************************************************************
// (C) 2009 Altera Corporation. .
//
//****************************************************************************************

//------------------------------------------------------------------------
// File:        $RCSfile: cdclib_vecsync.v.rca $
// Revision:    $Revision: #3 $
// Date:        $Date: 2015/03/20 $
//-----------------------------------------------------------------------------
// Description : Parameterizable Vector Sync Module, This can only be used
// for SLOW changing vector, i.e vector should be stable at least for the
// synchronization latency.
//-----------------------------------------------------------------------------
module cdclib_vecsync 
   #(
      parameter DWIDTH           = 2, // Sync Data input 
      parameter SYNCSTAGE        = 2, // Sync stages
      parameter WR_CLK_FREQ_MHZ     = 250,   // Clock frequency (in MHz)    
      parameter RD_CLK_FREQ_MHZ     = 250,   // Clock frequency (in MHz)    
      parameter VID          = 1     // 1: VID, 0: preVID
    )
   (
   // Inputs
   input  wire               wr_clk,        // write clock
   input  wire               rd_clk,        // read clock
   input  wire               wr_rst_n,      // async write reset
   input  wire               rd_rst_n,      // async read reset
   input  wire [DWIDTH-1:0]  data_in,       // data in
   // Outputs
   output reg  [DWIDTH-1:0]  data_out       // data out
   );

//******************************************************************************
// Define regs
//******************************************************************************
reg  [DWIDTH-1:0]  data_in_d0;
reg                req_wr_clk;
wire               req_rd_clk;
wire               ack_wr_clk;
wire               ack_rd_clk;
reg                req_rd_clk_d0;

//******************************************************************************
// WRITE CLOCK DOMAIN: Generate req & Store data when synchroniztion is not
// already in progress 
//******************************************************************************
always @(negedge wr_rst_n or posedge wr_clk) begin
   if (wr_rst_n == 1'b0) begin
      data_in_d0 <= {DWIDTH{1'b0}};
      req_wr_clk <= 1'b0; 
   end
   else begin
      // Store data when Write Req equals Write Ack
      if (req_wr_clk == ack_wr_clk) begin
         data_in_d0 <= data_in;
      end
      
      // Generate a Req when there is change in data 
      if ((req_wr_clk == ack_wr_clk) & (data_in_d0 != data_in)) begin
         req_wr_clk <= ~req_wr_clk;
      end
   end
end

generate 

if (SYNCSTAGE == 4) begin
//******************************************************************************
// WRITE CLOCK DOMAIN:  
//******************************************************************************
cdclib_bitsync4
#(
.DWIDTH      (1),         // Sync Data input
.RESET_VAL   (0),         // Reset value
.CLK_FREQ_MHZ(WR_CLK_FREQ_MHZ),
.TOGGLE_TYPE	(2),
.VID		(VID)
)
bitsync4_u_ack_wr_clk
   (
   .clk      (wr_clk),
   .rst_n    (wr_rst_n),
   .data_in  (ack_rd_clk),
   .data_out (ack_wr_clk)
   );

//******************************************************************************
// READ CLOCK DOMAIN:  
//******************************************************************************
cdclib_bitsync4
#(
.DWIDTH      (1),         // Sync Data input
.RESET_VAL   (0),         // Reset value
.CLK_FREQ_MHZ(RD_CLK_FREQ_MHZ),
.TOGGLE_TYPE	(2),
.VID		(VID)
)
bitsync4_u_req_rd_clk
(
   .clk      (rd_clk),
   .rst_n    (rd_rst_n),
   .data_in  (req_wr_clk),
   .data_out (req_rd_clk)
);
end
else  begin
//******************************************************************************
// WRITE CLOCK DOMAIN:  
//******************************************************************************
cdclib_bitsync2
#(
.DWIDTH      (1),         // Sync Data input
.RESET_VAL   (0),         // Reset value
.CLK_FREQ_MHZ(WR_CLK_FREQ_MHZ),
.TOGGLE_TYPE	(2),
.VID		(VID)
)
bitsync2_u_ack_wr_clk
   (
   .clk      (wr_clk),
   .rst_n    (wr_rst_n),
   .data_in  (ack_rd_clk),
   .data_out (ack_wr_clk)
   );

//******************************************************************************
// READ CLOCK DOMAIN:  
//******************************************************************************
cdclib_bitsync2
#(
.DWIDTH      (1),         // Sync Data input
.RESET_VAL   (0),         // Reset value
.CLK_FREQ_MHZ(RD_CLK_FREQ_MHZ),
.TOGGLE_TYPE	(2),
.VID		(VID)
)
bitsync2_u_req_rd_clk
(
   .clk      (rd_clk),
   .rst_n    (rd_rst_n),
   .data_in  (req_wr_clk),
   .data_out (req_rd_clk)
);
end

endgenerate

assign ack_rd_clk = req_rd_clk_d0;

//******************************************************************************
// READ CLOCK DOMAIN:  
//******************************************************************************
always @(negedge rd_rst_n or posedge rd_clk) begin
   if (rd_rst_n == 1'b0) begin
      data_out      <= {DWIDTH{1'b0}};
      req_rd_clk_d0 <= 1'b0;
   end
   else begin 
      req_rd_clk_d0 <= req_rd_clk;
      if (req_rd_clk_d0 != req_rd_clk) begin
         data_out <= data_in_d0;
      end
   end
end


endmodule // cdclib_vecsync

