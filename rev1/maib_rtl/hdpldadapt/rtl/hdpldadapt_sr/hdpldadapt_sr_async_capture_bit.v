// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
//
// Revision:    $Revision: #1 $
// Date:        $Date: 2014/09/10 $
//-----------------------------------------------------------------------------
// Description : Adpater async bit sampling
//-----------------------------------------------------------------------------
module hdpldadapt_sr_async_capture_bit 
   #(
      parameter RESET_VAL     = 0  // 1: Active high; 0: Active low
    )
   (
   // Inputs
   input  wire               clk,      	  // clock
   input  wire               rst_n,       // async reset
   input  wire  	     data_in,     // data in
   input  wire		     unload,      // unload data out
   // Outputs
   output reg   	     data_out     // data out
   );

//******************************************************************************
// Define regs
//******************************************************************************
reg  				data_in_sync_d0;
wire  				data_in_sync;
reg				sample;

localparam reset_value = (RESET_VAL == 1) ? 1'b1 : 1'b0;  // To eliminate truncating warning


cdclib_bitsync2
#(
.DWIDTH      (1'b1),         // Sync Data input
.RESET_VAL   (reset_value)   // Reset value
)
cdclib_bitsync2
   (
   .clk      (clk),
   .rst_n    (rst_n),
   .data_in  (data_in),
   .data_out (data_in_sync)
   );
      
      
always @(negedge rst_n or posedge clk) begin
   if (rst_n == 1'b0) begin
     begin
       sample 		<= 1'b0;
       data_out 	<= reset_value;
     end
  end
  else begin
  // No sample during unload
      if (unload) begin
        sample <= 1'b0;
      end
  // Sample on the first data change after unload      
      else if (sample == 1'b0 && data_in_sync !== data_out) begin
        sample   <= 1'b1;
        data_out 		<= data_in_sync;
      end  
  end
end

endmodule

