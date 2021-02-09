// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//****************************************************************************************
// (C) 2012 Altera Corporation. .
//
//****************************************************************************************

//************************************************************
// Description:
//
// Shadow status registers used in user logic to send status
// to DPRIO
//************************************************************

module cfg_dprio_shadow_status_regs 
#(
   parameter DATA_WIDTH    = 16,      // Data width
   parameter CLK_FREQ_MHZ  = 250,      // Clock freq in MHz
   parameter TOGGLE_TYPE = 1,
   parameter VID = 1
 )
(
input  wire                                 rst_n,         // reset
input  wire                                 clk,           // clock
input  wire [DATA_WIDTH-1:0]                stat_data_in,  // status data input
input  wire                                 write_en,      // write data enable from DPRIO

output wire                                 write_en_ack,  // write data enable acknowlege to DPRIO
output reg  [DATA_WIDTH-1:0]                stat_data_out  // status data output

);

wire   write_en_sync;

// Bit sync for write_en
cdclib_bitsync2 
   #(
      .DWIDTH       (1), // Sync Data input 
      .RESET_VAL    (0), // Reset value
      .CLK_FREQ_MHZ (CLK_FREQ_MHZ),
      .TOGGLE_TYPE(TOGGLE_TYPE),
      .VID(VID)
    ) write_en_sync_1
   (
    .clk  (clk),              // read clock
    .rst_n(rst_n),            // async reset for read clock domain
    .data_in (write_en),      // data in
    .data_out(write_en_sync)  // data out
   );

// Write_en acknowlege
assign write_en_ack = write_en_sync;

// Registering data_in with write_en
always @(negedge rst_n or posedge clk)
  if (rst_n == 1'b0)
    begin
      stat_data_out   <= {DATA_WIDTH{1'b0}};
    end
  else if (write_en_sync == 1'b1)
    begin      
      stat_data_out <= stat_data_in;
    end


endmodule

