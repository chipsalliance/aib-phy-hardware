// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//****************************************************************************************
// (C) 2009 Altera Corporation. .
//
//****************************************************************************************

//------------------------------------------------------------------------
// File:        $RCSfile: cdclib_bitsync.v.rca $
// Revision:    $Revision: #2 $
// Date:        $Date: 2015/01/23 $
//------------------------------------------------------------------------
// Description:
//
//------------------------------------------------------------------------
module cdclib_bitsync
  #(
    parameter DWIDTH = 1,    // Sync Data input
    parameter SYNCSTAGE = 2, // Sync stages
    parameter RESET_VAL = 0,  // Reset value
    parameter CLK_FREQ_MHZ = 250   // Clock frequency (in MHz)    
    )
    (
    input  wire              clk,     // clock
    input  wire              rst_n,   // async reset
    input  wire [DWIDTH-1:0] data_in, // data in
    output wire [DWIDTH-1:0] data_out // data out
     );

   // Define wires/regs
   reg [(DWIDTH*SYNCSTAGE)-1:0] sync_regs;
   //wire                         reset_value;
   
   localparam reset_value = (RESET_VAL == 1) ? 1'b1 : 1'b0;  // To eliminate truncating warning

   // Sync Always block
   always @(negedge rst_n or posedge clk) begin
      if (rst_n == 1'b0) begin
         sync_regs[(DWIDTH*SYNCSTAGE)-1:DWIDTH] <= {(DWIDTH*(SYNCSTAGE-1)){reset_value}};
      end
      else begin
         sync_regs[(DWIDTH*SYNCSTAGE)-1:DWIDTH] <= sync_regs[((DWIDTH*(SYNCSTAGE-1))-1):0];
      end
   end
   
   // NF: both FF stages have reset
   always @(negedge rst_n or posedge clk) begin
      if (rst_n == 1'b0) begin
         sync_regs[DWIDTH-1:0] <= {(DWIDTH){reset_value}};
      end
      else begin
         sync_regs[DWIDTH-1:0] <= data_in;
      end
   end

   assign data_out = sync_regs[((DWIDTH*SYNCSTAGE)-1):(DWIDTH*(SYNCSTAGE-1))];

endmodule // cdclib_bitsync

