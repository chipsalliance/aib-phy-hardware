// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//****************************************************************************************
// (C) 2009 Altera Corporation. .
//
//****************************************************************************************

//------------------------------------------------------------------------
// File:        $RCSfile: cdclib_bitsync2.v.rca $
// Revision:    $Revision: #3 $
// Date:        $Date: 2015/03/20 $
//------------------------------------------------------------------------
// Description: 2-stage synchronizer
//
//------------------------------------------------------------------------
module cdclib_bitsync2
  #(
    parameter DWIDTH = 1,    // Sync Data input
    parameter RESET_VAL = 0,  // Reset value
    parameter CLK_FREQ_MHZ = 250,  // Clock frequency (in MHz)
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
if (VID == 1) begin  
// Reset synchronizer  
if (RESET_VAL == 0) begin
  if (CLK_FREQ_MHZ <= 175) begin
    begin
    for (i=0; i < DWIDTH; i=i+1)
      begin: bit_sync_i
        cdclib_sync2_reset_type_w_gate bit_sync2_reset_type_w_inst
         (
          .clk		(clk),
          .rst_n	(rst_n),
          .data_in	(data_in[i]),
          .data_out	(data_out[i])
         );
      end
    end
  end
  else if (CLK_FREQ_MHZ <= 350 ) begin
    if (TOGGLE_TYPE == 1 || TOGGLE_TYPE == 2) 
    begin
    for (i=0; i < DWIDTH; i=i+1)
      begin: bit_sync_i
        cdclib_sync2_reset_type_l_gate bit_sync2_reset_type_l_inst
         (
          .clk		(clk),
          .rst_n	(rst_n),
          .data_in	(data_in[i]),
          .data_out	(data_out[i])
         );
      end
    end
    else
    begin
    for (i=0; i < DWIDTH; i=i+1)
      begin: bit_sync_i
        cdclib_sync2_reset_type_w_gate bit_sync2_reset_type_w_inst
         (
          .clk		(clk),
          .rst_n	(rst_n),
          .data_in	(data_in[i]),
          .data_out	(data_out[i])
         );
      end
    end
  end
  else if (CLK_FREQ_MHZ <= 850) begin
    begin
    for (i=0; i < DWIDTH; i=i+1)
      begin: bit_sync_i
        cdclib_sync2_reset_type_l_gate bit_sync2_reset_type_l_inst
         (
          .clk		(clk),
          .rst_n	(rst_n),
          .data_in	(data_in[i]),
          .data_out	(data_out[i])
         );
      end
    end
  end
  else if (CLK_FREQ_MHZ <= 1200 ) begin
    if (TOGGLE_TYPE == 1 || TOGGLE_TYPE == 2) 
    begin
    for (i=0; i < DWIDTH; i=i+1)
      begin: bit_sync_i
        cdclib_sync2_reset_type_n_gate bit_sync2_reset_type_n_inst
         (
          .clk		(clk),
          .rst_n	(rst_n),
          .data_in	(data_in[i]),
          .data_out	(data_out[i])
         );
      end
    end
    else 
    begin
    for (i=0; i < DWIDTH; i=i+1)
      begin: bit_sync_i
        cdclib_sync2_reset_type_l_gate bit_sync2_reset_type_l_inst
         (
          .clk		(clk),
          .rst_n	(rst_n),
          .data_in	(data_in[i]),
          .data_out	(data_out[i])
         );
      end
    end
  end  
  else if (CLK_FREQ_MHZ <= 1500 ) begin
    if (TOGGLE_TYPE == 1 || TOGGLE_TYPE == 2 || TOGGLE_TYPE == 3) 
    begin
    for (i=0; i < DWIDTH; i=i+1)
      begin: bit_sync_i
        cdclib_sync2_reset_type_n_gate bit_sync2_reset_type_n_inst
         (
          .clk		(clk),
          .rst_n	(rst_n),
          .data_in	(data_in[i]),
          .data_out	(data_out[i])
         );
      end
    end
    else 
    begin
    for (i=0; i < DWIDTH; i=i+1)
      begin: bit_sync_i
        cdclib_sync2_reset_type_l_gate bit_sync2_reset_type_l_inst
         (
          .clk		(clk),
          .rst_n	(rst_n),
          .data_in	(data_in[i]),
          .data_out	(data_out[i])
         );
      end
    end
  end  
  else if (CLK_FREQ_MHZ <= 1700 ) begin
    if (TOGGLE_TYPE == 1 || TOGGLE_TYPE == 2 || TOGGLE_TYPE == 3 || TOGGLE_TYPE == 4) 
    begin
    for (i=0; i < DWIDTH; i=i+1)
      begin: bit_sync_i
        cdclib_sync2_reset_type_n_gate bit_sync2_reset_type_n_inst
         (
          .clk		(clk),
          .rst_n	(rst_n),
          .data_in	(data_in[i]),
          .data_out	(data_out[i])
         );
      end
    end
    else 
    begin
    for (i=0; i < DWIDTH; i=i+1)
      begin: bit_sync_i
        cdclib_sync2_reset_type_l_gate bit_sync2_reset_type_l_inst
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
        cdclib_sync2_reset_type_n_gate bit_sync2_reset_type_n_inst
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
  if (CLK_FREQ_MHZ <= 175) begin
    begin
    for (i=0; i < DWIDTH; i=i+1)
      begin: bit_sync_i
        cdclib_sync2_set_type_w_gate bit_sync2_set_type_w_inst
         (
          .clk		(clk),
          .rst_n	(rst_n),
          .data_in	(data_in[i]),
          .data_out	(data_out[i])
         );
      end
    end
  end
  else if (CLK_FREQ_MHZ <= 350 ) begin
    if (TOGGLE_TYPE == 1 || TOGGLE_TYPE == 2) 
    begin
    for (i=0; i < DWIDTH; i=i+1)
      begin: bit_sync_i
        cdclib_sync2_set_type_l_gate bit_sync2_set_type_l_inst
         (
          .clk		(clk),
          .rst_n	(rst_n),
          .data_in	(data_in[i]),
          .data_out	(data_out[i])
         );
      end
    end
    else
    begin
    for (i=0; i < DWIDTH; i=i+1)
      begin: bit_sync_i
        cdclib_sync2_set_type_w_gate bit_sync2_set_type_w_inst
         (
          .clk		(clk),
          .rst_n	(rst_n),
          .data_in	(data_in[i]),
          .data_out	(data_out[i])
         );
      end
    end
  end
  else if (CLK_FREQ_MHZ <= 850) begin
    begin
    for (i=0; i < DWIDTH; i=i+1)
      begin: bit_sync_i
        cdclib_sync2_set_type_l_gate bit_sync2_set_type_l_inst
         (
          .clk		(clk),
          .rst_n	(rst_n),
          .data_in	(data_in[i]),
          .data_out	(data_out[i])
         );
      end
    end
  end
  else if (CLK_FREQ_MHZ <= 1200 ) begin
    if (TOGGLE_TYPE == 1 || TOGGLE_TYPE == 2) 
    begin
    for (i=0; i < DWIDTH; i=i+1)
      begin: bit_sync_i
        cdclib_sync2_set_type_n_gate bit_sync2_set_type_n_inst
         (
          .clk		(clk),
          .rst_n	(rst_n),
          .data_in	(data_in[i]),
          .data_out	(data_out[i])
         );
      end
    end
    else 
    begin
    for (i=0; i < DWIDTH; i=i+1)
      begin: bit_sync_i
        cdclib_sync2_set_type_l_gate bit_sync2_set_type_l_inst
         (
          .clk		(clk),
          .rst_n	(rst_n),
          .data_in	(data_in[i]),
          .data_out	(data_out[i])
         );
      end
    end
  end  
  else if (CLK_FREQ_MHZ <= 1500 ) begin
    if (TOGGLE_TYPE == 1 || TOGGLE_TYPE == 2 || TOGGLE_TYPE == 3) 
    begin
    for (i=0; i < DWIDTH; i=i+1)
      begin: bit_sync_i
        cdclib_sync2_set_type_n_gate bit_sync2_set_type_n_inst
         (
          .clk		(clk),
          .rst_n	(rst_n),
          .data_in	(data_in[i]),
          .data_out	(data_out[i])
         );
      end
    end
    else 
    begin
    for (i=0; i < DWIDTH; i=i+1)
      begin: bit_sync_i
        cdclib_sync2_set_type_l_gate bit_sync2_set_type_l_inst
         (
          .clk		(clk),
          .rst_n	(rst_n),
          .data_in	(data_in[i]),
          .data_out	(data_out[i])
         );
      end
    end
  end  
  else if (CLK_FREQ_MHZ <= 1700 ) begin
    if (TOGGLE_TYPE == 1 || TOGGLE_TYPE == 2 || TOGGLE_TYPE == 3 || TOGGLE_TYPE == 4) 
    begin
    for (i=0; i < DWIDTH; i=i+1)
      begin: bit_sync_i
        cdclib_sync2_set_type_n_gate bit_sync2_set_type_n_inst
         (
          .clk		(clk),
          .rst_n	(rst_n),
          .data_in	(data_in[i]),
          .data_out	(data_out[i])
         );
      end
    end
    else 
    begin
    for (i=0; i < DWIDTH; i=i+1)
      begin: bit_sync_i
        cdclib_sync2_set_type_l_gate bit_sync2_set_type_l_inst
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
        cdclib_sync2_set_type_n_gate bit_sync2_set_type_n_inst
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
end
else begin	// Pre-VID
if (RESET_VAL == 0) begin	// sync with reset
  if (CLK_FREQ_MHZ <= 300) begin
    begin
    for (i=0; i < DWIDTH; i=i+1)
      begin: bit_sync_i
        cdclib_sync2_reset_type_l_gate bit_sync2_reset_type_l_inst
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
    if (TOGGLE_TYPE == 1 || TOGGLE_TYPE == 2) 
    begin
    for (i=0; i < DWIDTH; i=i+1)
      begin: bit_sync_i
        cdclib_sync2_reset_type_n_gate bit_sync2_reset_type_n_inst
         (
          .clk		(clk),
          .rst_n	(rst_n),
          .data_in	(data_in[i]),
          .data_out	(data_out[i])
         );
      end
    end
    else 
    begin
    for (i=0; i < DWIDTH; i=i+1)
      begin: bit_sync_i
        cdclib_sync2_reset_type_l_gate bit_sync2_reset_type_l_inst
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
else begin  // sync with pre-set
  if (CLK_FREQ_MHZ <= 300) begin
    begin
    for (i=0; i < DWIDTH; i=i+1)
      begin: bit_sync_i
        cdclib_sync2_set_type_l_gate bit_sync2_set_type_l_inst
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
    if (TOGGLE_TYPE == 1 || TOGGLE_TYPE == 2) 
    begin
    for (i=0; i < DWIDTH; i=i+1)
      begin: bit_sync_i
        cdclib_sync2_set_type_n_gate bit_sync2_set_type_n_inst
         (
          .clk		(clk),
          .rst_n	(rst_n),
          .data_in	(data_in[i]),
          .data_out	(data_out[i])
         );
      end
    end
    else 
    begin
    for (i=0; i < DWIDTH; i=i+1)
      begin: bit_sync_i
        cdclib_sync2_set_type_l_gate bit_sync2_set_type_l_inst
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

end // pre-VID

endgenerate

endmodule // cdclib_bitsync2

