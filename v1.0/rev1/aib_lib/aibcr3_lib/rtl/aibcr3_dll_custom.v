// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3_lib, Cell - aibcr3_dll_custom, View - schematic
// LAST TIME SAVED: Aug  1 01:14:35 2016
// NETLIST TIME: Aug 17 15:46:59 2016
`timescale 1ns / 1ns 

module aibcr3_dll_custom ( clk_dcc, dcc_done, scan_out, t_down, t_up,
       clk_dcd, dll_lock, dll_reset_n, f_gray, i_gray,
     launch, measure, nfrzdrv, nrst, pvt_ref_half_gry, rb_cont_cal,
     rb_dcc_byp, scan_clk_in, scan_in, scan_mode_n, scan_rst_n,
     scan_shift_n );

output  clk_dcc, dcc_done, scan_out, t_down, t_up;


input  clk_dcd, dll_lock, dll_reset_n, launch, measure, nfrzdrv, nrst,
     rb_cont_cal, rb_dcc_byp, scan_clk_in, scan_in, scan_mode_n,
     scan_rst_n, scan_shift_n;

input [2:0]  i_gray;
input [7:0]  f_gray;
input [10:0]  pvt_ref_half_gry;
wire [10:0]  lpvt_ref_half_gry;

// Buses in the design

wire  [10:0]  gray;
wire net057;
wire net052;
wire clk_mindly_cont;
wire clk_mindly_1time;
wire net054;
wire clk_dly_cont;
wire clk_dly_1time;
wire dll_lock_reg;
wire sout_lat;
wire dll_mx_reset_n;

assign clk_dcd_buf = clk_dcd;
assign SMCLK = net057;
assign dll_reset_n_mux = net052;
assign SE = !scan_shift_n;
assign clk_mindly = rb_cont_cal ? clk_mindly_cont : clk_mindly_1time;
assign net058 = rb_cont_cal ? clk_dcd : dll_lock;
assign net052 = scan_mode_n ? net054 : scan_rst_n;
assign clk_dly = rb_cont_cal ? clk_dly_cont : clk_dly_1time;
assign net057 = scan_mode_n ? net058 : scan_clk_in;
assign net054 = rb_cont_cal ? dll_lock : dll_reset_n;
assign tieLO = 1'b0;
assign dll_mx_reset_n = scan_mode_n ? dll_reset_n : scan_rst_n;

/*
always@(posedge SMCLK or negedge dll_reset_n_mux) begin
  if (!dll_reset_n_mux) begin
           pvt_ref_half_gry_ff <= 11'b0;
  end
  else begin
           pvt_ref_half_gry_ff <= pvt_ref_half_gry;
  end
end        
*/

aibcr3_svt16_scdffcdn_cust x50 (.D(pvt_ref_half_gry[0]), .SI(scan_in), .CK(SMCLK), .SE(SE), .scQ(s0), .Q(lpvt_ref_half_gry[0]), .CDN(dll_reset_n_mux));
aibcr3_svt16_scdffcdn_cust x48 (.D(pvt_ref_half_gry[1]), .SI(s0), .CK(SMCLK), .SE(SE), .scQ(s1), .Q(lpvt_ref_half_gry[1]), .CDN(dll_reset_n_mux));
aibcr3_svt16_scdffcdn_cust x49 (.D(pvt_ref_half_gry[2]), .SI(s1), .CK(SMCLK), .SE(SE), .scQ(s2), .Q(lpvt_ref_half_gry[2]), .CDN(dll_reset_n_mux));
aibcr3_svt16_scdffcdn_cust x42 (.D(pvt_ref_half_gry[3]), .SI(s2), .CK(SMCLK), .SE(SE), .scQ(s3), .Q(lpvt_ref_half_gry[3]), .CDN(dll_reset_n_mux));
aibcr3_svt16_scdffcdn_cust x43 (.D(pvt_ref_half_gry[4]), .SI(s3), .CK(SMCLK), .SE(SE), .scQ(s4), .Q(lpvt_ref_half_gry[4]), .CDN(dll_reset_n_mux));
aibcr3_svt16_scdffcdn_cust x41 (.D(pvt_ref_half_gry[5]), .SI(s4), .CK(SMCLK), .SE(SE), .scQ(s5), .Q(lpvt_ref_half_gry[5]), .CDN(dll_reset_n_mux));
aibcr3_svt16_scdffcdn_cust x40 (.D(pvt_ref_half_gry[6]), .SI(s5), .CK(SMCLK), .SE(SE), .scQ(s6), .Q(lpvt_ref_half_gry[6]), .CDN(dll_reset_n_mux));
aibcr3_svt16_scdffcdn_cust x47 (.D(pvt_ref_half_gry[7]), .SI(s6), .CK(SMCLK), .SE(SE), .scQ(s7), .Q(lpvt_ref_half_gry[7]), .CDN(dll_reset_n_mux));
aibcr3_svt16_scdffcdn_cust x46 (.D(pvt_ref_half_gry[8]), .SI(s7), .CK(SMCLK), .SE(SE), .scQ(s8), .Q(lpvt_ref_half_gry[8]), .CDN(dll_reset_n_mux));
aibcr3_svt16_scdffcdn_cust x44 (.D(pvt_ref_half_gry[9]), .SI(s8), .CK(SMCLK), .SE(SE), .scQ(s9), .Q(lpvt_ref_half_gry[9]), .CDN(dll_reset_n_mux));
aibcr3_svt16_scdffcdn_cust x45 (.D(pvt_ref_half_gry[10]), .SI(s9), .CK(SMCLK), .SE(SE), .scQ(sout_lat), .Q(lpvt_ref_half_gry[10]), .CDN(dll_reset_n_mux));

assign gray[10] = dll_lock_reg ? lpvt_ref_half_gry[10] : f_gray[7];
assign gray[9] = dll_lock_reg ? lpvt_ref_half_gry[9] : f_gray[6];
assign gray[8] = dll_lock_reg ? lpvt_ref_half_gry[8] : f_gray[5];
assign gray[7] = dll_lock_reg ? lpvt_ref_half_gry[7] : f_gray[4];
assign gray[6] = dll_lock_reg ? lpvt_ref_half_gry[6] : f_gray[3];
assign gray[5] = dll_lock_reg ? lpvt_ref_half_gry[5] : f_gray[2];
assign gray[4] = dll_lock_reg ? lpvt_ref_half_gry[4] : f_gray[1];
assign gray[3] = dll_lock_reg ? lpvt_ref_half_gry[3] : f_gray[0];
assign gray[2] = dll_lock_reg ? lpvt_ref_half_gry[2] : i_gray[2];
assign gray[1] = dll_lock_reg ? lpvt_ref_half_gry[1] : i_gray[1];
assign gray[0] = dll_lock_reg ? lpvt_ref_half_gry[0] : i_gray[0];

aibcr3_dcc_dly I1 ( SO_outb, clk_dly_cont, clk_mindly_cont, 
      dll_mx_reset_n, SE, SOoutd, SMCLK, clk_dcd_buf, rb_cont_cal,
     lpvt_ref_half_gry[10:0], tieLO, tieLO);

aibcr3_dcc_dly I0 ( scan_out, clk_dly_1time, clk_mindly_1time, 
      dll_mx_reset_n, SE, SO_outb, clk_dcd_buf, clk_dcd_buf, dll_lock_reg,
     gray[10:0], launch, measure);

aibcr3_dll_lock_dly I16 ( SOoutd, dcc_done, dll_lock_reg,  
     dll_reset_n_mux, clk_dcd, SMCLK, rb_cont_cal, sout_lat,
     scan_shift_n);

aibcr3_dcc_helper I37 ( clk_dcc, clk_dcd_buf, rb_dcc_byp,
     clk_mindly, clk_dly, nrst);

aibcr3_dcc_phasedet I21 ( t_down, t_up, clk_dly_1time,
     clk_mindly_1time, dll_reset_n);

aibcr3_dcc_phasedet I25 ( net0117, net0118, clk_dly_cont,
     clk_mindly_cont, dll_reset_n);

endmodule
