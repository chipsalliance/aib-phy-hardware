// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_nand_x64_delay_line, View -
//schematic
// LAST TIME SAVED: Mar 26 07:33:47 2015
// NETLIST TIME: May 12 17:53:10 2015
// `timescale 1ns / 1ns 

module aibnd_nand_x64_delay_line ( out_p, so, code_valid, dll_reset_n,
     f_gray, i_gray, in_p, scan_rst_n, sck_in, se_n, si, sm_n,
     vcc_aibnd, vcc_io, vss_aibnd );

output  out_p, so;

input  code_valid, dll_reset_n, in_p, scan_rst_n, sck_in, se_n, si,
     sm_n, vcc_aibnd, vcc_io, vss_aibnd;

input [2:0]  i_gray;
input [6:0]  f_gray;

wire clk_buf0, clk_buf1, clk_prebuf, sm_n_buf, out_p, sck_in, nrst_mux, dll_reset_n, scan_rst_n, code_valid_sync, code_valid_buf, nrst, ck, se_n, se_n_buf, sm_n; // Conversion Sript Generated


// specify 
//     specparam CDS_LIBNAME  = "aibnd_lib";
//     specparam CDS_CELLNAME = "aibnd_nand_x64_delay_line";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

assign clk_buf1 = clk_buf0;
assign clk_buf0 = clk_prebuf;
assign clk_prebuf = sm_n_buf ? out_p : sck_in;
assign nrst_mux = sm_n_buf ? dll_reset_n : scan_rst_n;
aibnd_sync_ff xsync ( .vss_aibnd(vss_aibnd), .vcc_aibnd(vcc_aibnd),
     .so(so_sync), .se_n(se_n_buf), .q(code_valid_sync), .rb(nrst),
     .clk(ck), .si(si), .d(code_valid));
aibnd_cmos_nand_x64 xcoarse ( .vss_aibnd(vss_aibnd),
     .vcc_aibnd(vcc_aibnd), .code_valid(code_valid_buf), .nrst(nrst),
     .ck(ck), .so(so_nand_x64), .se_n(se_n_buf), .si(so_sync),
     .vcc_io(vcc_io), .out_p(fout_p), .in_p(in_p), .gray(f_gray[6:0]));
assign code_valid_buf = code_valid_sync;
assign nrst = nrst_mux;
assign ck = clk_buf1;
assign se_n_buf = se_n;
assign sm_n_buf = sm_n;
aibnd_cmos_fine_dly xfine (.vss_aibnd(vss_aibnd), .vcc_aibnd(vcc_aibnd), .vcc_io(vcc_io),
     .code_valid(code_valid_buf), .so(so),
     .ck(ck), .nrst(nrst), .se_n(se_n_buf), .si(so_nand_x64),
     .gray(i_gray[2:0]), .out_p(out_p),
     .fout_p(fout_p));

endmodule

