// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// ==========================================================================
//
// Module name    : aib_sr_ms
// Description    : serial chain(master)
// Revision       : 1.0
// ============================================================================
module aib_sr_ms #(
                   parameter MS_LENGTH = 7'd81
		  ) 

   (
    // AIB IO Bidirectional 
    input                  osc_clk,    //free running osc clock
    input       [MS_LENGTH-1:0] ms_data_fr_core,
    output wire [MS_LENGTH-1:0] ms_data_to_core,
    output reg             sr_ms_data_out, //master serial data out
    output reg             sr_ms_load_out, //master load out
    input                  sr_ms_data_in, //master serial data out
    input                  sr_ms_load_in, //master serial data load inupt
    input                  sr_ms_clk_in, //from input por
    input                  ms_nsl,
    input                  atpg_mode,
    input                  reset_n       

    );

reg [6:0] ms_count;
reg       ms_load;

reg        [MS_LENGTH-1:0] ms_data_syncr; //master shift output register
reg        [MS_LENGTH-1:0] ms_data_revr;  //shift receive register
reg        [MS_LENGTH-1:0] ms_data_capr;  //captured master serial data register
reg                        ms_shift_en;
wire       [MS_LENGTH-1:0] ms_data_sync, ms_data_syncrw, ms_data_revrw, ms_data_caprw;
wire                       reset_n_sync, reset_n_sync_rev;
wire            sr_ms_data_outw; //master serial data out
wire            sr_ms_load_outw; //master load out
wire            is_master, is_slave;

assign ms_data_to_core[MS_LENGTH-1:0] = ms_data_capr[MS_LENGTH-1:0];

aib_rstnsync aib_rstnsync
  (
    .clk(osc_clk),            // Destination clock of reset to be synced
    .i_rst_n(reset_n),        // Asynchronous reset input
    .scan_mode(atpg_mode),      // Scan bypass for reset
    .sync_rst_n(reset_n_sync)      // Synchronized reset output

   );

aib_rstnsync aib_rstnsync_rev
  (
    .clk(sr_ms_clk_in),            // Destination clock of reset to be synced
    .i_rst_n(reset_n),        // Asynchronous reset input
    .scan_mode(atpg_mode),      // Scan bypass for reset
    .sync_rst_n(reset_n_sync_rev)      // Synchronized reset output

   );

   genvar i;
   generate
     for (i=0; i<MS_LENGTH; i=i+1) begin:ms_data_sync_gen
       c3lib_bitsync
       #(
       .SRC_DATA_FREQ_MHZ (200),        
       .DST_CLK_FREQ_MHZ  (1000),        
       .DWIDTH            (1),   
       .RESET_VAL         (0)           
       )
       i_ms_data_sync
           (
           .clk(osc_clk),
           .rst_n(reset_n_sync),
           .data_in(ms_data_fr_core[i]),
           .data_out(ms_data_sync[i])
           );
     end
   endgenerate

always @(negedge osc_clk or negedge reset_n_sync) begin
  if (~reset_n_sync)
   begin
    sr_ms_data_out <= 1'b0;
    sr_ms_load_out <= 1'b0;
   end
  else
   begin
    sr_ms_data_out <= sr_ms_data_outw;
    sr_ms_load_out <= sr_ms_load_outw;
   end
end

always @(posedge osc_clk or negedge reset_n_sync) begin
  if (~reset_n_sync)
   begin
    ms_count[6:0] <= 7'h0;
    ms_load      <= 1'b0;
    ms_shift_en <= 1'b0;
   end
  else
   begin
    if (ms_count[6:0]==(MS_LENGTH))
      begin     
       ms_count[6:0] <= 7'h0;
       ms_load <= 1'b1;
       ms_shift_en <= 1'b0;
      end
    else
      begin // increment counter
       ms_count[6:0] <= ms_count[6:0] + 7'h01;
       ms_load <= 1'b0;
       ms_shift_en <= 1'b1;
      end
   end
end

assign sr_ms_data_outw = ms_data_syncr[MS_LENGTH-1];
assign sr_ms_load_outw = ms_load;

assign ms_data_syncrw[MS_LENGTH-1:0] = ms_load ? ms_data_sync[MS_LENGTH-1:0] : 
                                       ms_shift_en ? {ms_data_syncr[MS_LENGTH-2:0], ms_data_syncr[0]} : ms_data_syncr[MS_LENGTH-1:0];

always @(posedge osc_clk or negedge reset_n_sync) begin
  if (~reset_n_sync)
   begin
    ms_data_syncr[MS_LENGTH-1:0] <= 81'h0;
   end
  else
   begin
    ms_data_syncr[MS_LENGTH-1:0] <= ms_data_syncrw[MS_LENGTH-1:0];
   end
end

assign ms_data_revrw[MS_LENGTH-1:0] = sr_ms_load_in ? ms_data_revr[MS_LENGTH-1:0] : {ms_data_revr[MS_LENGTH-2:0], sr_ms_data_in};
assign ms_data_caprw[MS_LENGTH-1:0] = sr_ms_load_in ? ms_data_revr[MS_LENGTH-1:0] : ms_data_capr[MS_LENGTH-1:0];

always @(posedge sr_ms_clk_in or negedge reset_n_sync_rev) begin
  if (~reset_n_sync_rev)
   begin
    ms_data_revr[MS_LENGTH-1:0] <= 81'h0;
    ms_data_capr[MS_LENGTH-1:0] <= 81'h0;
   end
  else
   begin
    ms_data_revr[MS_LENGTH-1:0] <= ms_data_revrw[MS_LENGTH-1:0];
    ms_data_capr[MS_LENGTH-1:0] <= ms_data_caprw[MS_LENGTH-1:0];
   end
end

   assign is_master = (ms_nsl == 1'b1) ? 1'b1 : 1'b0;
   assign is_slave = !is_master;


endmodule // aib_sr_ms
