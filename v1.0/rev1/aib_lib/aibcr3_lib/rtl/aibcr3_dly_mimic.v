// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3_lib, Cell - aibcr3_dly_mimic, View - schematic
// LAST TIME SAVED: Sep  5 23:53:09 2016
// NETLIST TIME: Sep 13 21:47:07 2016
`timescale 1ns / 1ns 

module aibcr3_dly_mimic ( ihssi_rx_data_out_dly, csr_reg6,
     idll_core2dll_1, ihssi_rx_data_out, rb_dcc_byp, rb_dcc_byp_dprio,
     vcc, vss );


input  csr_reg6, idll_core2dll_1, rb_dcc_byp, rb_dcc_byp_dprio, vcc,
     vss;

output [39:0]  ihssi_rx_data_out_dly;

input [39:0]  ihssi_rx_data_out;

wire dcc_byp_mux ;
wire rb_dcc_byp_inv ;
wire dcc_byp_mux_buf ;
wire rb_dcc_byp_inv_buf ;
wire idll_core2dll_1_buf ;
wire csr_reg6;
wire csr_reg6_buf;


aibcr3_dcc_dly_rep x82 ( ihssi_rx_data_out_dly[30],
     ihssi_rx_data_out[30], dcc_byp_mux_buf);
aibcr3_dcc_dly_rep x44 ( ihssi_rx_data_out_dly[19],
     ihssi_rx_data_out[19], dcc_byp_mux_buf);
aibcr3_dcc_dly_rep x43 ( ihssi_rx_data_out_dly[18],
     ihssi_rx_data_out[18], dcc_byp_mux_buf);
aibcr3_dcc_dly_rep x42 ( ihssi_rx_data_out_dly[17],
     ihssi_rx_data_out[17], dcc_byp_mux_buf);
aibcr3_dcc_dly_rep x41 ( ihssi_rx_data_out_dly[16],
     ihssi_rx_data_out[16], dcc_byp_mux_buf);
aibcr3_dcc_dly_rep x40 ( ihssi_rx_data_out_dly[9],
     ihssi_rx_data_out[9], dcc_byp_mux_buf);
aibcr3_dcc_dly_rep x39 ( ihssi_rx_data_out_dly[10],
     ihssi_rx_data_out[10], dcc_byp_mux_buf);
aibcr3_dcc_dly_rep x38 ( ihssi_rx_data_out_dly[11],
     ihssi_rx_data_out[11], dcc_byp_mux_buf);
aibcr3_dcc_dly_rep x37 ( ihssi_rx_data_out_dly[12],
     ihssi_rx_data_out[12], dcc_byp_mux_buf);
aibcr3_dcc_dly_rep x36 ( ihssi_rx_data_out_dly[15],
     ihssi_rx_data_out[15], dcc_byp_mux_buf);
aibcr3_dcc_dly_rep x35 ( ihssi_rx_data_out_dly[14],
     ihssi_rx_data_out[14], dcc_byp_mux_buf);
aibcr3_dcc_dly_rep x34 ( ihssi_rx_data_out_dly[13],
     ihssi_rx_data_out[13], dcc_byp_mux_buf);
aibcr3_dcc_dly_rep x33 ( ihssi_rx_data_out_dly[8],
     ihssi_rx_data_out[8], dcc_byp_mux_buf);
aibcr3_dcc_dly_rep x32 ( ihssi_rx_data_out_dly[5],
     ihssi_rx_data_out[5], dcc_byp_mux_buf);
aibcr3_dcc_dly_rep x31 ( ihssi_rx_data_out_dly[6],
     ihssi_rx_data_out[6], dcc_byp_mux_buf);
aibcr3_dcc_dly_rep x30 ( ihssi_rx_data_out_dly[7],
     ihssi_rx_data_out[7], dcc_byp_mux_buf);
aibcr3_dcc_dly_rep x29 ( ihssi_rx_data_out_dly[4],
     ihssi_rx_data_out[4], dcc_byp_mux_buf);
aibcr3_dcc_dly_rep x28 ( ihssi_rx_data_out_dly[3],
     ihssi_rx_data_out[3], dcc_byp_mux_buf);
aibcr3_dcc_dly_rep x27 ( ihssi_rx_data_out_dly[2],
     ihssi_rx_data_out[2], dcc_byp_mux_buf);
aibcr3_dcc_dly_rep x26 ( ihssi_rx_data_out_dly[1],
     ihssi_rx_data_out[1], dcc_byp_mux_buf);
aibcr3_dcc_dly_rep x25 ( ihssi_rx_data_out_dly[0],
     ihssi_rx_data_out[0], dcc_byp_mux_buf);
aibcr3_dcc_dly_rep x71 ( ihssi_rx_data_out_dly[20],
     ihssi_rx_data_out[20], dcc_byp_mux_buf);
aibcr3_dcc_dly_rep x81 ( ihssi_rx_data_out_dly[31],
     ihssi_rx_data_out[31], dcc_byp_mux_buf);
aibcr3_dcc_dly_rep x80 ( ihssi_rx_data_out_dly[32],
     ihssi_rx_data_out[32], dcc_byp_mux_buf);
aibcr3_dcc_dly_rep x59 ( ihssi_rx_data_out_dly[26],
     ihssi_rx_data_out[26], dcc_byp_mux_buf);
aibcr3_dcc_dly_rep x61 ( ihssi_rx_data_out_dly[25],
     ihssi_rx_data_out[25], dcc_byp_mux_buf);
aibcr3_dcc_dly_rep x79 ( ihssi_rx_data_out_dly[33],
     ihssi_rx_data_out[33], dcc_byp_mux_buf);
aibcr3_dcc_dly_rep x57 ( ihssi_rx_data_out_dly[27],
     ihssi_rx_data_out[27], dcc_byp_mux_buf);
aibcr3_dcc_dly_rep x56 ( ihssi_rx_data_out_dly[28],
     ihssi_rx_data_out[28], dcc_byp_mux_buf);
aibcr3_dcc_dly_rep x78 ( ihssi_rx_data_out_dly[34],
     ihssi_rx_data_out[34], dcc_byp_mux_buf);
aibcr3_dcc_dly_rep x54 ( ihssi_rx_data_out_dly[29],
     ihssi_rx_data_out[29], dcc_byp_mux_buf);
aibcr3_dcc_dly_rep x77 ( ihssi_rx_data_out_dly[35],
     ihssi_rx_data_out[35], dcc_byp_mux_buf);
aibcr3_dcc_dly_rep x69 ( ihssi_rx_data_out_dly[21],
     ihssi_rx_data_out[21], dcc_byp_mux_buf);
aibcr3_dcc_dly_rep x76 ( ihssi_rx_data_out_dly[36],
     ihssi_rx_data_out[36], dcc_byp_mux_buf);
aibcr3_dcc_dly_rep x67 ( ihssi_rx_data_out_dly[22],
     ihssi_rx_data_out[22], dcc_byp_mux_buf);
aibcr3_dcc_dly_rep x75 ( ihssi_rx_data_out_dly[37],
     ihssi_rx_data_out[37], dcc_byp_mux_buf);
aibcr3_dcc_dly_rep x65 ( ihssi_rx_data_out_dly[23],
     ihssi_rx_data_out[23], dcc_byp_mux_buf);
aibcr3_dcc_dly_rep x74 ( ihssi_rx_data_out_dly[38],
     ihssi_rx_data_out[38], dcc_byp_mux_buf);
aibcr3_dcc_dly_rep x63 ( ihssi_rx_data_out_dly[24],
     ihssi_rx_data_out[24], dcc_byp_mux_buf);
aibcr3_dcc_dly_rep x73 ( ihssi_rx_data_out_dly[39],
     ihssi_rx_data_out[39], dcc_byp_mux_buf);

assign dcc_byp_mux = csr_reg6_buf? idll_core2dll_1_buf : rb_dcc_byp_inv_buf;
assign rb_dcc_byp_inv = ! rb_dcc_byp_dprio;
assign dcc_byp_mux_buf = dcc_byp_mux;
assign rb_dcc_byp_inv_buf = rb_dcc_byp_inv;
assign idll_core2dll_1_buf = idll_core2dll_1;
assign csr_reg6_buf = csr_reg6;

endmodule
