// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3_lib, Cell - aibcr3_dll_lock_dly, View - schematic
// LAST TIME SAVED: Aug 17 16:02:21 2016
// NETLIST TIME: Aug 18 17:31:16 2016
`timescale 1ns / 1ns 

module aibcr3_dll_lock_dly ( SOoutd, dcc_done, dll_lock_reg, 
      RSTb, clk_dcd, dll_lock_mux, rb_cont_cal, scan_in,
     scan_shift_n );

output  SOoutd, dcc_done, dll_lock_reg;


input  RSTb, clk_dcd, dll_lock_mux, rb_cont_cal, scan_in, scan_shift_n;

wire net50; 

assign tieHI = 1'b1;
assign tieLO = 1'b0;
assign net079 = net50;
assign SE = !scan_shift_n;
assign dll_lock_reg = rb_cont_cal? tieLO : net079;


aibcr3_svt16_scdffcdn_cust I17 ( net53, net50,   RSTb,
     dll_lock_mux, tieHI, SE, scan_in);
aibcr3_svt16_scdffcdn_cust I13 ( net61, net60,   RSTb,
     clk_dcd, net53, SE, net50);
aibcr3_svt16_scdffcdn_cust I14 ( net69, net68,   RSTb,
     clk_dcd, net61, SE, net60);
aibcr3_svt16_scdffcdn_cust I4 ( net59, net54,   RSTb,
     clk_dcd, net42, SE, net45);
aibcr3_svt16_scdffcdn_cust I2 ( net67, net64,   RSTb,
     clk_dcd, net59, SE, net54);
aibcr3_svt16_scdffcdn_cust I1 ( net77, net74,   RSTb,
     clk_dcd, net67, SE, net64);
aibcr3_svt16_scdffcdn_cust I316 ( dcc_done, SOoutd,   RSTb,
     clk_dcd, net77, SE, net74);
aibcr3_svt16_scdffcdn_cust I15 ( net76, net75,   RSTb,
     clk_dcd, net69, SE, net68);
aibcr3_svt16_scdffcdn_cust I16 ( net42, net45,   RSTb,
     clk_dcd, net76, SE, net75);

endmodule
