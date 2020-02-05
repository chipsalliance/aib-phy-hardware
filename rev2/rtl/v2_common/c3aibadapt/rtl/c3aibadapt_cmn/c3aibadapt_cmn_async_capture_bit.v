// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
// Copyright (c) 2009 Altera Corporation. .
//
//-----------------------------------------------------------------------------
// Description : Adpater async bit sampling
//-----------------------------------------------------------------------------
module c3aibadapt_cmn_async_capture_bit 
   #(
      parameter RESET_VAL     = 0,  // 1: Active high; 0: Active low
      parameter SYNC_STAGE    = 2
    )
   (
   // Inputs
   input  wire               clk,      	  // clock
   input  wire               rst_n,       // async reset
   input  wire  	     data_in,     // data in
   input  wire		     unload,      // unload data out
   // Outputs
   output wire   	     data_in_sync_out, // data out
   output reg   	     data_out     // data out
   );

//******************************************************************************
// Define regs
//******************************************************************************
wire  				data_in_sync;
reg				sample;

localparam reset_value = (RESET_VAL == 1) ? 1'b1 : 1'b0;  // To eliminate truncating warning

generate
if (SYNC_STAGE == 3) begin
// hd_dpcmn_bitsync3
c3lib_sync3_ulvt_bitsync
  #(
  .DWIDTH      (1'b1),         // Sync Data input
  .RESET_VAL   (reset_value)   // Reset value
  )
  ulvt_bitsync3
    (
    .clk      (clk),
    .rst_n    (rst_n),
    .data_in  (data_in),
    .data_out (data_in_sync)
    );
end
else begin
// hd_dpcmn_bitsync2
c3lib_bitsync
  #(
  .SRC_DATA_FREQ_MHZ  (500),         // Source clock frequency
  .DST_CLK_FREQ_MHZ   (1000),        // Destination clock frequency
  .DWIDTH             (1'b1),      // Sync Data input
  .RESET_VAL          (reset_value)  //  Reset value
  )
  lvt_bitsync2
    (
    .clk      (clk),
    .rst_n    (rst_n),
    .data_in  (data_in),
    .data_out (data_in_sync)
    );
end
endgenerate

assign data_in_sync_out = data_in_sync;

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
      else if (sample == 1'b0 && data_in_sync != data_out) begin
        sample   <= 1'b1;
        data_out 		<= data_in_sync;
      end  
  end
end

endmodule

