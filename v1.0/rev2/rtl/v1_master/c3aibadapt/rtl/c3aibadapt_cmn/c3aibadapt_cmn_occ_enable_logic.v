// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//On chip clock controller enable logic

module c3aibadapt_cmn_occ_enable_logic(

     user_clk,
     scan_enable,
     occ_enable,
     atpg_mode,
     burst_cnt,
     occ_user_clken
);

input user_clk;
input scan_enable;
input atpg_mode;
input occ_enable;
input [1:0] burst_cnt;
output occ_user_clken;

wire [1:0] gc_counter;
wire cmp;
wire reset;
reg occ_user_clk_en_reg;
wire occ_user_clk_en_buf;
wire sync_out;
wire scan_enable;
wire atpg_mode;
wire occ_enable;
wire occ_clken;
wire gc_counter_en;
reg  enable_reg;

//Inversion for all the control signal
//assign scan_enable = ~scan_enable_n;
//assign atpg_mode = ~atpg_mode_n;
//assign occ_enable = ~occ_enable_n;

assign reset = ~scan_enable;                
assign cmp = |(gc_counter ^ burst_cnt);     //comparison of the gc counter versus the burst cnt
assign gc_counter_en = sync_out & cmp;      //enabling the gc counter
assign occ_user_clken = (atpg_mode == 1'b1)?  occ_user_clk_en_reg : 1'b1;



always @(posedge occ_enable or negedge reset)
begin
  if(~reset)
    enable_reg <= 1'b0;
  else
    enable_reg <= 1'b1;
end


always @(posedge user_clk or negedge reset )
begin
  if(~reset)
    occ_user_clk_en_reg <= 1'b0;
  else
    occ_user_clk_en_reg <= gc_counter_en;
end


//sycnronization register
// hd_dpcmn_bitsync3 altr_bitsync3_inst(
c3lib_sync3_ulvt_bitsync altr_bitsync3_inst(
  .clk      (user_clk),
  .rst_n    (reset),
  .data_in  (enable_reg),
  .data_out (sync_out)
);

//gray code counter
c3aibadapt_cmn_occ_gray_cntr counter_inst (
  .clk   (user_clk),
  .rst_n (reset),
  .en    (gc_counter_en),
  .cout   (gc_counter)
);

endmodule
