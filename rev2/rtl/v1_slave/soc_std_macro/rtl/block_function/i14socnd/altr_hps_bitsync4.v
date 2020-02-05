// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//****************************************************************************************
// Copyright (C) 2011 Altera Corporation. .
//
//****************************************************************************************

//------------------------------------------------------------------------
// Description: 28-nm standard cell harden FF synchronizer.
// synchronizer with 4 flop stages.
//
// Note on RESET_VAL:
// if a "set" or "reset" type synchronizer should be used. If RESET_VAL evaluates
// to zero, a reset type synchronizer is chosen. All other values of RESET_VAL
// will lead to a set type synchronizer
// 
// when multi-bit crossing is required (note: async handshake macros are also available and is
// usually recommended for multi-bit CDC - ensure your use case is fine with double-synchronizers
// if you choose this macro)
// 
// However, choosing this method excludes 1 use case: There's is no mechanism to choose individual
// reset value for each bit of a multi-bit signal through this macro. e.g: RESET_VAL == 3'b101 is 
// not supported. It is assumed that this use case is not required for users of this macro
//
//------------------------------------------------------------------------

module altr_hps_bitsync4
  #(
    parameter DWIDTH = 1'b1,    // Sync Data input
    //parameter SYNCSTAGE = 4, // Sync stages
    parameter RESET_VAL = 1'b0  // Reset value
    )
    (
    input  wire              clk,     // clock
    input  wire              rst_n,   // async reset
    input  wire [DWIDTH-1:0] data_in, // data in
    output wire [DWIDTH-1:0] data_out // data out
     );

`ifdef ALTR_HPS_INTEL_MACROS_OFF

   // End users may pass in RESET_VAL with a width exceeding 1 bit
   // Evaluate the value first and use 1 bit value
   localparam RESET_VAL_1B = (RESET_VAL == 'd0) ? 1'b0 : 1'b1;

   reg [DWIDTH-1:0]  dff4;
   reg [DWIDTH-1:0]  dff3;
   reg [DWIDTH-1:0]  dff2;
   reg [DWIDTH-1:0]  dff1;

   always @(posedge clk or negedge rst_n)
      if (!rst_n) begin
         dff4     <= {DWIDTH{RESET_VAL_1B}}; 
         dff3     <= {DWIDTH{RESET_VAL_1B}}; 
         dff2     <= {DWIDTH{RESET_VAL_1B}}; 
         dff1     <= {DWIDTH{RESET_VAL_1B}}; 
      end
      else begin
         dff4     <= dff3;
         dff3     <= dff2;
         dff2     <= dff1;
         dff1     <= data_in;
      end

   // data_out has to be a wire since it needs to also hook up to the TSMC cell
   assign data_out = dff4;

`else
`endif

endmodule // altr_hps_bitsync4

