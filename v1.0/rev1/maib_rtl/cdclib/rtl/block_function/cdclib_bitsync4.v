// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//****************************************************************************************
// (C) 2009 Altera Corporation. .
//
//****************************************************************************************

//------------------------------------------------------------------------
// File:        $RCSfile: cdclib_bitsync4.v.rca $
// Revision:    $Revision: #3 $
// Date:        $Date: 2015/03/20 $
//------------------------------------------------------------------------
// Description: 4-stage synchonizer
//
//------------------------------------------------------------------------
module cdclib_bitsync4 
  #(
    parameter DWIDTH = 1,    // Sync Data input
    parameter RESET_VAL = 0,  // Reset value
    parameter CLK_FREQ_MHZ = 1000,  // Clock frequency (in MHz)
    parameter TOGGLE_TYPE  = 1,    // Toggle type: 1 --> 5
    parameter VID          = 1     // 1: VID, 0: preVID
    )
    (
    input  wire              clk,     // clock
    input  wire              rst_n,   // async reset
    input  wire [DWIDTH-1:0] data_in, // data in
    output wire [DWIDTH-1:0] data_out // data out
     );


// TOGGLE_TYPE  = 1: once every clock cycle
// TOGGLE_TYPE  = 2: once every 10 clock cycles
// TOGGLE_TYPE  = 3: once every min
// TOGGLE_TYPE  = 4: once every hour
// TOGGLE_TYPE  = 5: once every day
// TOGGLE_TYPE  = 0: never (default)


generate
  genvar i;
// Reset synchronizer  
if (RESET_VAL == 0) begin
  if (CLK_FREQ_MHZ <= 850) begin
    begin
    for (i=0; i < DWIDTH; i=i+1)
      begin: bit_sync_i
        cdclib_sync4_reset_type_w_gate bit_sync4_reset_type_w_inst
         (
          .clk		(clk),
          .rst_n	(rst_n),
          .data_in	(data_in[i]),
          .data_out	(data_out[i])
         );
      end
    end
  end
  else begin
    begin
    for (i=0; i < DWIDTH; i=i+1)
      begin: bit_sync_i
        cdclib_sync4_reset_type_l_gate bit_sync4_reset_type_l_inst
         (
          .clk		(clk),
          .rst_n	(rst_n),
          .data_in	(data_in[i]),
          .data_out	(data_out[i])
         );
      end
    end
  end  
end
// Preset synchronizer  
else begin
  if (CLK_FREQ_MHZ <= 850) begin
    begin
    for (i=0; i < DWIDTH; i=i+1)
      begin: bit_sync_i
        cdclib_sync4_set_type_w_gate bit_sync4_set_type_w_inst
         (
          .clk		(clk),
          .rst_n	(rst_n),
          .data_in	(data_in[i]),
          .data_out	(data_out[i])
         );
      end
    end
  end
  else begin
    begin
    for (i=0; i < DWIDTH; i=i+1)
      begin: bit_sync_i
        cdclib_sync4_set_type_l_gate bit_sync4_set_type_l_inst
         (
          .clk		(clk),
          .rst_n	(rst_n),
          .data_in	(data_in[i]),
          .data_out	(data_out[i])
         );
      end
    end
  end  
end

endgenerate

endmodule // cdclib_bitsync4

