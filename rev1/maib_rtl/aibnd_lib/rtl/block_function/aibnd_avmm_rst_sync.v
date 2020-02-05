// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_avmm_rst_sync, View - schematic
// LAST TIME SAVED: Apr 22 09:42:47 2015
// NETLIST TIME: May 12 17:53:10 2015
// `timescale 1ns / 1ns 

module aibnd_avmm_rst_sync ( pcs_clk, pcs_clkb, resetb_sync_buf,
     avmm_clk, avmm_rstb, vccl_aibnd, vssl_aibnd );

output  pcs_clk, pcs_clkb, resetb_sync_buf;

input  avmm_clk, avmm_rstb, vccl_aibnd, vssl_aibnd;

wire gated_avmm_clk, pcs_clk, reset_b_sync, resetb_sync_buf, avmm_clk, avmm_clk_inv, pcs_clkb, clockgateb; // Conversion Sript Generated


// specify 
//     specparam CDS_LIBNAME  = "aibnd_lib";
//     specparam CDS_CELLNAME = "aibnd_avmm_rst_sync";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

assign pcs_clk = gated_avmm_clk;
assign resetb_sync_buf = reset_b_sync;
assign avmm_clk_inv = !avmm_clk;
assign pcs_clkb = !gated_avmm_clk;
aibnd_2ff_scan  xsync ( .d(vccl_aibnd), .clk(avmm_clk),     .o(reset_b_sync) /*`ifndef INTCNOPWR , .vcc(vccl_aibnd) `endif*/ , .rb(avmm_rstb),     .si(vssl_aibnd) /*`ifndef INTCNOPWR , .vss(vssl_aibnd) `endif*/ , .so(nc_so_sync),     .ssb(vccl_aibnd));
aibnd_ff_r  fyn0 ( .o(clockgateb), .d(vccl_aibnd),     .clk(avmm_clk_inv) /*`ifndef INTCNOPWR , .vss(vssl_aibnd) , .vcc(vccl_aibnd) `endif*/ ,     .rb(reset_b_sync));
assign gated_avmm_clk = avmm_clk & clockgateb;

endmodule

