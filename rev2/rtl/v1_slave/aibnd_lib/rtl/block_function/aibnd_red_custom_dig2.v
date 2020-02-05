// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_red_custom_dig2, View - schematic
// LAST TIME SAVED: Apr 22 17:47:49 2015
// NETLIST TIME: May 12 17:53:10 2015
// `timescale 1ns / 1ns 

module aibnd_red_custom_dig2 ( iclkin_dist_aib, ilaunch_clk_aib,
     istrbclk_aib, oclk_out, oclkb_out, clkdr_in, iclkin_dist_in0,
     iclkin_dist_in1, ilaunch_clk_in0, ilaunch_clk_in1, istrbclk_in0,
     istrbclk_in1, jtag_clksel, oclk_aib, oclk_in1, oclkb_aib,
     oclkb_in1, shift_en, vccl_aibnd, vssl_aibnd );

output  iclkin_dist_aib, ilaunch_clk_aib, istrbclk_aib, oclk_out,
     oclkb_out;

input  clkdr_in, iclkin_dist_in0, iclkin_dist_in1, ilaunch_clk_in0,
     ilaunch_clk_in1, istrbclk_in0, istrbclk_in1, jtag_clksel,
     oclk_aib, oclk_in1, oclkb_aib, oclkb_in1, shift_en, vccl_aibnd,
     vssl_aibnd;


// specify 
//     specparam CDS_LIBNAME  = "aibnd_lib";
//     specparam CDS_CELLNAME = "aibnd_red_custom_dig2";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

aibnd_red_clkmux2  gmx4 ( .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd), .s(shift_enbuf), .clk2(iclkin_dist_in0),
     .clkout(iclkin_dist_mux), .clk1(iclkin_dist_in1));
aibnd_red_clkmux2  gmx2 ( .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd), .s(shift_enbuf), .clk2(istrbclk_in0),
     .clkout(istrbclk_mux), .clk1(istrbclk_in1));
aibnd_red_clkmux2  gmx1 ( .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd), .s(shift_enbuf), .clk2(oclk_aib),
     .clkout(oclk_mux), .clk1(oclk_in1));
aibnd_red_clkmux2  gmx0 ( .vccl_aibnd(vccl_aibnd),
     .vssl_aibnd(vssl_aibnd), .s(shift_enbuf), .clk2(oclkb_aib),
     .clkout(oclkb_mux), .clk1(oclkb_in1));
aibnd_inv  gin10 ( .clkout(oclk_out), .clk(oclk_mux_inv),
     .vccl_aibnd(vccl_aibnd), .vssl_aibnd(vssl_aibnd));
aibnd_inv  gin6 ( .vssl_aibnd(vssl_aibnd), .clk(istrbclk_mux),
     .vccl_aibnd(vccl_aibnd), .clkout(istrbclk_mux_inv));
aibnd_inv  gin13 ( .vssl_aibnd(vssl_aibnd), .clk(shift_en_b),
     .vccl_aibnd(vccl_aibnd), .clkout(shift_enbuf));
aibnd_inv  gin11 ( .vssl_aibnd(vssl_aibnd), .clk(oclk_mux),
     .vccl_aibnd(vccl_aibnd), .clkout(oclk_mux_inv));
aibnd_inv  gin8 ( .vssl_aibnd(vssl_aibnd), .clk(oclkb_mux),
     .vccl_aibnd(vccl_aibnd), .clkout(oclkb_mux_inv));
aibnd_inv  gin0 ( .vssl_aibnd(vssl_aibnd), .clk(jtag_clksel_b),
     .vccl_aibnd(vccl_aibnd), .clkout(jtag_clksel_buf));
aibnd_inv  gin9 ( .clkout(oclkb_out), .clk(oclkb_mux_inv),
     .vccl_aibnd(vccl_aibnd), .vssl_aibnd(vssl_aibnd));
aibnd_inv  gin3 ( .vssl_aibnd(vssl_aibnd), .clk(iclkin_dist_mux_inv),
     .vccl_aibnd(vccl_aibnd), .clkout(iclkin_dist_aib));
aibnd_inv  gna1 ( .vssl_aibnd(vssl_aibnd), .clk(lclk_s1b),
     .vccl_aibnd(vccl_aibnd), .clkout(lclk_s1));
aibnd_inv  gin5 ( .vssl_aibnd(vssl_aibnd), .clk(ilaunch_clk_mux_inv),
     .vccl_aibnd(vccl_aibnd), .clkout(ilaunch_clk_aib));
aibnd_inv  gin2 ( .vssl_aibnd(vssl_aibnd), .clk(iclkin_dist_mux),
     .vccl_aibnd(vccl_aibnd), .clkout(iclkin_dist_mux_inv));
aibnd_inv  gin4 ( .vssl_aibnd(vssl_aibnd), .clk(ilaunch_clk_mux),
     .vccl_aibnd(vccl_aibnd), .clkout(ilaunch_clk_mux_inv));
aibnd_inv  gin12 ( .vssl_aibnd(vssl_aibnd), .clk(shift_en),
     .vccl_aibnd(vccl_aibnd), .clkout(shift_en_b));
aibnd_inv  gin1 ( .vssl_aibnd(vssl_aibnd), .clk(jtag_clksel),
     .vccl_aibnd(vccl_aibnd), .clkout(jtag_clksel_b));
aibnd_inv  gin7 ( .vssl_aibnd(vssl_aibnd), .clk(istrbclk_mux_inv),
     .vccl_aibnd(vccl_aibnd), .clkout(istrbclk_aib));
aibnd_nand2  gna0 ( .clk(shift_enbuf), .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .en(jtag_clksel_b), .clkout(lclk_s1b));
aibnd_red_clkmux3  gmx3 ( .clk3(clkdr_in), .s1(lclk_s1),
     .vccl_aibnd(vccl_aibnd), .vssl_aibnd(vssl_aibnd),
     .s3(jtag_clksel_buf), .s2(lclk_s2), .clk2(ilaunch_clk_in0),
     .clkout(ilaunch_clk_mux), .clk1(ilaunch_clk_in1));
aibnd_nor2  gna2 ( .vccl_aibnd(vccl_aibnd), .vssl_aibnd(vssl_aibnd),
     .en(jtag_clksel_buf), .clk(shift_enbuf), .clkout(lclk_s2));

endmodule

