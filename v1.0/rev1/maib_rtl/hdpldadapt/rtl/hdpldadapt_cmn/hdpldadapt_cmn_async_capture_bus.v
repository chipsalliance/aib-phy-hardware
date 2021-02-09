// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
//
// Revision:    $Revision: #5 $
// Date:        $Date: 2015/03/23 $
//-----------------------------------------------------------------------------
// Description : Adpater async bus capture
//-----------------------------------------------------------------------------
module hdpldadapt_cmn_async_capture_bus 
   #(
      parameter RESET_VAL     = 1, // 1: Active high; 0: Active low
      parameter DWIDTH           = 2,  // Sync Data input 
      parameter SYNC_STAGE    = 4,
      parameter CLK_FREQ_MHZ  = 1,
      parameter TOGGLE_TYPE  = 1    // Toggle type: 1 --> 5
    )
   (
   // Inputs
   input  wire               clk,      	  // clock
   input  wire               rst_n,       // async reset
   input  wire [DWIDTH-1:0]  data_in,     // data in
   input  wire		     unload,      // unload data out
   input  wire		     r_capt_mode,      // capture mode
   // Outputs
   output reg  [DWIDTH-1:0]  data_out     // data out
   );

//******************************************************************************
// Define regs
//******************************************************************************
reg  [DWIDTH-1:0]		data_in_sync_d0;
reg  [DWIDTH-1:0]		data_in_sync_d1;
wire [DWIDTH-1:0] 		data_in_sync;
reg				sample;

   localparam reset_value = (RESET_VAL == 1) ? 1'b1 : 1'b0;  // To eliminate truncating warning


generate
if (SYNC_STAGE == 2) begin  
cdclib_bitsync2
#(
.DWIDTH      (DWIDTH),         // Sync Data input
.RESET_VAL   (reset_value),  // Reset value
.CLK_FREQ_MHZ (CLK_FREQ_MHZ), // Freq in MHz 
.TOGGLE_TYPE (TOGGLE_TYPE),
.VID	     (1)
)
cdclib_bitsync2
   (
   .clk      (clk),
   .rst_n    (rst_n),
   .data_in  (data_in),
   .data_out (data_in_sync)
   );
end
else begin
cdclib_bitsync4
#(
.DWIDTH      (DWIDTH),         // Sync Data input
.RESET_VAL   (reset_value),  // Reset value
.CLK_FREQ_MHZ (CLK_FREQ_MHZ), // Freq in MHz 
.TOGGLE_TYPE (TOGGLE_TYPE),
.VID	     (1)
)
cdclib_bitsync4
   (
   .clk      (clk),
   .rst_n    (rst_n),
   .data_in  (data_in),
   .data_out (data_in_sync)
   );
end
endgenerate

   always @(negedge rst_n or posedge clk) begin
      if (rst_n == 1'b0) begin
        begin
          data_in_sync_d0 	<= {DWIDTH{reset_value}};
          data_in_sync_d1 	<= {DWIDTH{reset_value}};
        end
     end
     else begin
          data_in_sync_d0 	<= data_in_sync;
          data_in_sync_d1 	<= data_in_sync_d0;
        end
   end        
     
     
     
   always @(negedge rst_n or posedge clk) begin
      if (rst_n == 1'b0) begin
        begin
          sample 		<= 1'b0;
          data_out 		<= {DWIDTH{reset_value}};
        end
     end
     else begin
     // No sample during unload
         if (unload) begin
           sample <= 1'b0;
         end
     // Sample on the first data change after unload      
         else begin  
           if (r_capt_mode) begin
             if (~sample)   
               sample   <= 1'b1;
               data_out <= data_in_sync;
           end
           else begin
             if  (~sample && data_in_sync == data_in_sync_d0 && data_in_sync_d0 == data_in_sync_d1) begin
               sample   <= 1'b1;
               data_out <= data_in_sync_d1;
             end
           end
           
         end  
     end
   end

endmodule

