// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.

module aib_bus_sync
  #(
    parameter                 DWIDTH =  1'b1,          // Data bus width
    parameter [DWIDTH-1:0] RESET_VAL = {DWIDTH{1'h0}}  // Reset value
    )
    (
    // Inputs
    input               src_clk,    // source clock
    input               dest_clk,   // destination clock
    input               src_rst_n,  // source async reset
    input               dest_rst_n, // destination async reset
    input  [DWIDTH-1:0] src_data,   // Source data input
    // Outputs
    output  reg[DWIDTH-1:0] dest_data_ff // destination data output
     );

wire src_req_sync;  // Data request in destination domain
wire if_ready;      // Indicates CDC interface ready
wire dest_ack_sync; // Destination acknowledge
wire dest_sample;   // Destination signal to sample source data

reg              src_req_ff;  // Source data request register
reg [DWIDTH-1:0] src_data_ff; // Source data register
reg              dest_ack_ff; // Destination acknowledge register

//------------------------------------------------------------------------------
//                             Source Domain Logic 
//------------------------------------------------------------------------------

// Data sample request
always @(posedge src_clk or negedge src_rst_n)
  begin: src_req_register
    if(!src_rst_n)
      src_req_ff <= 1'b0;
    else if(if_ready)
      src_req_ff <= ~src_req_ff;
  end // block: src_req_register

// Source data register
always @(posedge src_clk or negedge src_rst_n)
  begin: src_data_register
    if(!src_rst_n)
      src_data_ff[DWIDTH-1:0] <= RESET_VAL;
    else if(if_ready)
      src_data_ff[DWIDTH-1:0] <= src_data[DWIDTH-1:0];
  end // block: src_data_register

// Interace ready indication
assign if_ready = ~(src_req_ff ^ dest_ack_sync);

// Destination acknowledge synchronization
aib_bit_sync sync_ack_i(
// Inputs
.clk     (src_clk),     // clock
.rst_n   (src_rst_n),   // async reset
.data_in (dest_ack_ff), // data in
// Outputs
.data_out (dest_ack_sync) // data out
);

//------------------------------------------------------------------------------
//                             Source Domain Logic 
//------------------------------------------------------------------------------

// Source request synchronization
aib_bit_sync sync_req_i(
// Inputs
.clk     (dest_clk),   // clock
.rst_n   (dest_rst_n), // async reset
.data_in (src_req_ff), // data in
// Outputs
.data_out (src_req_sync)// data out
);

// Source acknowledge
always @(posedge dest_clk or negedge dest_rst_n)
  begin: dest_ack_register
    if(!dest_rst_n)
      dest_ack_ff <= 1'b0;
    else
      dest_ack_ff <= src_req_sync;
  end // block: dest_ack_register

// samples data in destination domain
assign dest_sample = src_req_sync ^ dest_ack_ff;


// Destination data
always @(posedge dest_clk or negedge dest_rst_n)
  begin: dest_data_register
    if(!dest_rst_n)
      dest_data_ff[DWIDTH-1:0] <= RESET_VAL;
    else if(dest_sample)
      dest_data_ff[DWIDTH-1:0] <= src_data_ff[DWIDTH-1:0];
  end // block: dest_data_register


endmodule // aib_bus_sync

