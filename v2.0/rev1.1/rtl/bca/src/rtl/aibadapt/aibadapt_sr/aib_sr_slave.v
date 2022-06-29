// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.
// Copyright (C) 2021 Intel Corporation.

module aib_sr_slave #(
                   parameter SL_LENGTH = 7'd73
  ) 

   (
    input                  sr_sl_clk_in,    //From input
    output                 sr_sl_clk_out,    //to output
    input       [SL_LENGTH-1:0] sl_data_fr_core, //Data from Core
    output wire [SL_LENGTH-1:0] sl_data_to_core, //Data to Core
    output reg            sr_sl_data_out, //slave serial data out
    output reg            sr_sl_load_out, //slave load out
    input                  sr_sl_data_in, //slave serial data out
    input                  sr_sl_load_in, //slave serial data load inupt
    input                  sr_ms_clk_in, //input ms clock
    input                  osc_fsm_sl_rstn // Indicates the configuration is done.      

    );

localparam [SL_LENGTH-1:0] MS_BUS_RST_VAL = { 1'b0, // sl_osc_transfer_en,
                                              1'b0,
                                              1'b0, // sl_rx_transfer_en_s,
                                              1'b0, // sl_rx_dcc_dll_lock_req,
                                              1'b0, // sl_rx_dll_lock,
                                              3'b0,
                                              1'b0, // sl_tx_transfer_en_s,
                                              1'b0, // sl_tx_dcc_dll_lock_req,
                                              1'b0,
                                              1'b0,
                                              1'b1,
                                              1'b0,
                                              1'b1,
                                              26'b0, // sl_external_cntl_57_32[25:0],
                                              1'b0, // sl_tx_dcc_cal_done,
                                              3'b0, // sl_external_cntl_30_28[2:0],
                                              1'b0,
                                              27'b0 }; // sl_external_cntl_26_0[26:0]

reg [6:0] sl_count;
reg       sl_load;

reg        [SL_LENGTH-1:0] sl_data_syncr; //master shift output register
reg        [SL_LENGTH-1:0] sl_data_revr;  //shift receive register
reg        [SL_LENGTH-1:0] sl_data_capr;  //captured master serial data register
reg                        sl_shift_en;
wire       [SL_LENGTH-1:0] sl_data_sync, sl_data_syncrw, sl_data_revrw, sl_data_caprw;
wire            sr_sl_data_outw; //slave serial data out
wire            sr_sl_load_outw; //slave load out

assign  sl_data_to_core[SL_LENGTH-1:0] = sl_data_capr[SL_LENGTH-1:0];
assign  sr_sl_clk_out = sr_ms_clk_in;

aib_bit_sync #(
.DWIDTH     (SL_LENGTH),
.RESET_VAL  (MS_BUS_RST_VAL)
)
i_ms_data_sync(
.clk     (sr_sl_clk_out),
.rst_n   (osc_fsm_sl_rstn),
.data_in (sl_data_fr_core[SL_LENGTH-1:0]),
.data_out(sl_data_sync[SL_LENGTH-1:0])
);

always @(posedge sr_sl_clk_out or negedge osc_fsm_sl_rstn) begin
  if (!osc_fsm_sl_rstn)
   begin
    sl_count[6:0] <= 7'h0;
    sl_load       <= 1'b0;
    sl_shift_en   <= 1'b0;
   end
  else
   begin
    if (sl_count[6:0]==(SL_LENGTH))
      begin     
       sl_count[6:0] <= 7'h0;
       sl_load       <= 1'b1;
       sl_shift_en   <= 1'b0;
      end
    else
      begin // increment counter
       sl_count[6:0] <= sl_count[6:0] + 7'h01;
       sl_load       <= 1'b0;
       sl_shift_en   <= 1'b1;
      end
   end
end

assign sr_sl_data_outw = sl_data_syncr[SL_LENGTH-1];
assign sr_sl_load_outw = sl_load;

assign sl_data_syncrw[SL_LENGTH-1:0] = sl_load ? sl_data_sync[SL_LENGTH-1:0] : 
                                       sl_shift_en ? {sl_data_syncr[SL_LENGTH-2:0], sl_data_syncr[0]} : sl_data_syncr[SL_LENGTH-1:0];

always @(negedge sr_sl_clk_out or negedge osc_fsm_sl_rstn) begin
  if (!osc_fsm_sl_rstn)
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

always @(posedge sr_sl_clk_out or negedge osc_fsm_sl_rstn) begin
  if (!osc_fsm_sl_rstn)
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

always @(posedge sr_sl_clk_in or negedge osc_fsm_sl_rstn) begin
  if (!osc_fsm_sl_rstn)
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


endmodule // aib_sr_slave
