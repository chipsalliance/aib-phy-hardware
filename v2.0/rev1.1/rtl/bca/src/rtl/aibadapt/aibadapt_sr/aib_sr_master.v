// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.
// Copyright (C) 2021 Intel Corporation. 

module aib_sr_master #(
                   parameter MS_LENGTH = 7'd81
  ) 

   (
    // AIB IO Bidirectional 
    input                  osc_clk,    //free running osc clock
    input       [MS_LENGTH-1:0] ms_data_fr_core, //Data from Core
    output wire [MS_LENGTH-1:0] ms_data_to_core, //Data to Core
    output reg             sr_ms_data_out, //master serial data out
    output reg             sr_ms_load_out, //master load out
    input                  sr_ms_data_in, //master serial data out
    input                  sr_ms_load_in, //master serial data load inupt
    input                  sr_ms_clk_in, //from input por
    input                  osc_fsm_ms_rstn,
    input                  osc_fsm_sl_rstn

    );

localparam [MS_LENGTH-1:0] MS_BUS_RST_VAL = { 1'b0,  //  ms_osc_transfer_en
                                              1'b1,
                                              1'b0,  // ms_tx_transfer_en_m
                                              2'b11,
                                              1'b0,  // ms_rx_transfer_en_m
                                              1'b0,  // ms_rx_dll_lock
                                              5'b11111,
                                              1'b0,  // ms_tx_dcc_cal_done
                                              1'b0,
                                              1'b1,
                                              58'h0,  // ms_external_cntl_65_8[57:0]
                                              1'b1,
                                              1'b0,
                                              1'b1,
                                              5'h0 }; // ms_external_cntl_4_0[4:0] 

reg [6:0] ms_count;
reg       ms_load;

reg        [MS_LENGTH-1:0] ms_data_syncr; //master shift output register
reg        [MS_LENGTH-1:0] ms_data_revr;  //shift receive register
reg        [MS_LENGTH-1:0] ms_data_capr;  //captured master serial data register
reg                        ms_shift_en;
wire       [MS_LENGTH-1:0] ms_data_sync, ms_data_syncrw, ms_data_revrw, ms_data_caprw;
wire            sr_ms_data_outw; //master serial data out
wire            sr_ms_load_outw; //master load out

assign ms_data_to_core[MS_LENGTH-1:0] = ms_data_capr[MS_LENGTH-1:0];

aib_bit_sync #(
.DWIDTH     (MS_LENGTH),
.RESET_VAL  (MS_BUS_RST_VAL)
)
i_ms_data_sync(
.clk     (osc_clk),
.rst_n   (osc_fsm_ms_rstn),
.data_in (ms_data_fr_core[MS_LENGTH-1:0]),
.data_out(ms_data_sync[MS_LENGTH-1:0])
);

always @(negedge osc_clk or negedge osc_fsm_ms_rstn) begin
  if (!osc_fsm_ms_rstn)
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

always @(posedge osc_clk or negedge osc_fsm_ms_rstn) begin
  if (!osc_fsm_ms_rstn)
   begin
    ms_count[6:0] <= 7'h0;
    ms_load       <= 1'b0;
    ms_shift_en   <= 1'b0;
   end
  else
   begin
    if (ms_count[6:0]==(MS_LENGTH))
      begin     
       ms_count[6:0] <= 7'h0;
       ms_load       <= 1'b1;
       ms_shift_en   <= 1'b0;
      end
    else
      begin // increment counter
       ms_count[6:0] <= ms_count[6:0] + 7'h01;
       ms_load       <= 1'b0;
       ms_shift_en   <= 1'b1;
      end
   end
end

assign sr_ms_data_outw = ms_data_syncr[MS_LENGTH-1];
assign sr_ms_load_outw = ms_load;

assign ms_data_syncrw[MS_LENGTH-1:0] =  ms_load                     ? 
				        ms_data_sync[MS_LENGTH-1:0] : 
                                        ms_shift_en                 ? 
				       {ms_data_syncr[MS_LENGTH-2:0], ms_data_syncr[0]} : 
					ms_data_syncr[MS_LENGTH-1:0];

always @(posedge osc_clk or negedge osc_fsm_ms_rstn) begin
  if (!osc_fsm_ms_rstn)
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

always @(posedge sr_ms_clk_in or negedge osc_fsm_sl_rstn) begin
  if (!osc_fsm_sl_rstn)
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


endmodule // aib_sr_master
