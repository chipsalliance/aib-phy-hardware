// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
//
// Revision:    $Revision: #3 $
// Date:        $Date: 2015/03/20 $
//-----------------------------------------------------------------------------
// Description : Parameterizable Level Sync Module
// PULSE MODE OFF : Generate a signal when ever the input changes
// PULSE MODE ON  : Generate a ONE clock pulse o/p for every multicycle wide pulse
// on input
//-----------------------------------------------------------------------------
module cdclib_lvlsync 
   #(
      parameter EN_PULSE_MODE    = 0, // Enable Pulse mode i.e O/P data pulses for change in I/P
      parameter DWIDTH           = 1, // Sync Data input 
      parameter SYNCSTAGE        = 2, // Sync stages
      parameter ACTIVE_LEVEL     = 1, // 1: Active high; 0: Active low
      parameter WR_CLK_FREQ_MHZ     = 250,   // Clock frequency (in MHz)    
      parameter RD_CLK_FREQ_MHZ     = 250,   // Clock frequency (in MHz)    
      parameter VID          = 1     // 1: VID, 0: preVID
    )
   (
   // Inputs
   input  wire               wr_clk,      // write clock
   input  wire               rd_clk,      // read clock
   input  wire               wr_rst_n,    // async reset for write clock domain
   input  wire               rd_rst_n,    // async reset for read clock domain
   input  wire  [DWIDTH-1:0] data_in,     // data in
   // Outputs
   output reg   [DWIDTH-1:0] data_out     // data out
   );

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
   .data_in  (ack_rd_clk[i]),
   .data_out (ack_wr_clk[i])
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
   .data_in  (req_wr_clk[i]),
   .data_out (req_rd_clk[i])
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
   .data_in  (ack_rd_clk[i]),
   .data_out (ack_wr_clk[i])
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
   .data_in  (req_wr_clk[i]),
   .data_out (req_rd_clk[i])
);
end

   assign ack_rd_clk[i] = req_rd_clk_d0[i];

//******************************************************************************
// READ CLOCK DOMAIN:  
//******************************************************************************
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

