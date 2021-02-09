// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// ==========================================================================
//
// Module name    : aib_sr_sl
// Description    : Behavioral model of serial chain(slave)
// Revision       : 1.0
// ============================================================================
module aib_sr_sl #(
                   parameter SL_LENGTH = 7'd73
		  ) 

   (
    input                  sr_sl_clk_in,    //From input
    output                 sr_sl_clk_out,    //to output
    input       [SL_LENGTH-1:0] sl_data_fr_core,
    output wire [SL_LENGTH-1:0] sl_data_to_core,
    output reg            sr_sl_data_out, //slave serial data out
    output reg            sr_sl_load_out, //slave load out
    input                  sr_sl_data_in, //slave serial data out
    input                  sr_sl_load_in, //slave serial data load inupt
    input                  sr_ms_clk_in, //input ms clock
    input                  ms_nsl,
    input                  atpg_mode,
    input                  reset_n       

    );

reg [6:0] sl_count;
reg       sl_load;

reg        [SL_LENGTH-1:0] sl_data_syncr; //master shift output register
reg        [SL_LENGTH-1:0] sl_data_revr;  //shift receive register
reg        [SL_LENGTH-1:0] sl_data_capr;  //captured master serial data register
reg                        sl_shift_en;
wire       [SL_LENGTH-1:0] sl_data_sync, sl_data_syncrw, sl_data_revrw, sl_data_caprw;
wire                       reset_n_sync, reset_n_sync_rev;
wire            sr_sl_data_outw; //slave serial data out
wire            sr_sl_load_outw; //slave load out

assign  sl_data_to_core[SL_LENGTH-1:0] = sl_data_capr[SL_LENGTH-1:0];
assign  sr_sl_clk_out = sr_ms_clk_in;

aib_rstnsync aib_rstnsync
  (
    .clk(sr_sl_clk_out),            // Destination clock of reset to be synced
    .i_rst_n(reset_n),        // Asynchronous reset input
    .scan_mode(atpg_mode),      // Scan bypass for reset
    .sync_rst_n(reset_n_sync)      // Synchronized reset output

   );

aib_rstnsync aib_rstnsync_rev
  (
    .clk(sr_sl_clk_in),            // Destination clock of reset to be synced
    .i_rst_n(reset_n),        // Asynchronous reset input
    .scan_mode(atpg_mode),      // Scan bypass for reset
    .sync_rst_n(reset_n_sync_rev)      // Synchronized reset output

   );

   genvar i;
   generate
     for (i=0; i<SL_LENGTH; i=i+1) begin:sl_data_sync_gen
       aib_bitsync i_sl_data_sync
           (
           .clk(sr_sl_clk_out),
           .rst_n(reset_n_sync),
           .data_in(sl_data_fr_core[i]),
           .data_out(sl_data_sync[i])
           );
     end
   endgenerate

always @(posedge sr_sl_clk_out or negedge reset_n_sync) begin
  if (~reset_n_sync)
   begin
    sl_count[6:0] <= 7'h0;
    sl_load      <= 1'b0;
    sl_shift_en <= 1'b0;
   end
  else
   begin
    if (sl_count[6:0]==(SL_LENGTH))
      begin     
       sl_count[6:0] <= 7'h0;
       sl_load <= 1'b1;
       sl_shift_en <= 1'b0;
      end
    else
      begin // increment counter
       sl_count[6:0] <= sl_count[6:0] + 7'h01;
       sl_load <= 1'b0;
       sl_shift_en <= 1'b1;
      end
   end
end

assign sr_sl_data_outw = sl_data_syncr[SL_LENGTH-1];
assign sr_sl_load_outw = sl_load;

assign sl_data_syncrw[SL_LENGTH-1:0] = sl_load ? sl_data_sync[SL_LENGTH-1:0] : 
                                       sl_shift_en ? {sl_data_syncr[SL_LENGTH-2:0], sl_data_syncr[0]} : sl_data_syncr[SL_LENGTH-1:0];

always @(negedge sr_sl_clk_out or negedge reset_n_sync) begin
  if (~reset_n_sync)
   begin
    sr_sl_data_out <= 1'b0;
    sr_sl_load_out <= 1'b0;
   end
  else
   begin
    sr_sl_data_out <= sr_sl_data_outw;
    sr_sl_load_out <= sr_sl_load_outw;
   end
end

always @(posedge sr_sl_clk_out or negedge reset_n_sync) begin
  if (~reset_n_sync)
   begin
    sl_data_syncr[SL_LENGTH-1:0] <= 73'h0;
   end
  else
   begin
    sl_data_syncr[SL_LENGTH-1:0] <= sl_data_syncrw[SL_LENGTH-1:0];
   end
end

assign sl_data_revrw[SL_LENGTH-1:0] = sr_sl_load_in ? sl_data_revr[SL_LENGTH-1:0] : {sl_data_revr[SL_LENGTH-2:0], sr_sl_data_in};
assign sl_data_caprw[SL_LENGTH-1:0] = sr_sl_load_in ? sl_data_revr[SL_LENGTH-1:0] : sl_data_capr[SL_LENGTH-1:0];

always @(posedge sr_sl_clk_in or negedge reset_n_sync_rev) begin
  if (~reset_n_sync_rev)
   begin
    sl_data_revr[SL_LENGTH-1:0] <= 73'h0;
    sl_data_capr[SL_LENGTH-1:0] <= 73'h0;
   end
  else
   begin
    sl_data_revr[SL_LENGTH-1:0] <= sl_data_revrw[SL_LENGTH-1:0];
    sl_data_capr[SL_LENGTH-1:0] <= sl_data_caprw[SL_LENGTH-1:0];
   end
end

   assign is_master = (ms_nsl == 1'b1) ? 1'b1 : 1'b0;
   assign is_slave = !is_master;


endmodule // aib_sr_sl
