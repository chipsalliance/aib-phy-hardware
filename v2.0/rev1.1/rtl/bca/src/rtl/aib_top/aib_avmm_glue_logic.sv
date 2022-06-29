// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.

module aib_avmm_glue_logic( 
// Inputs
input [23:0] i_waitreq_ch,      // Wait request of each channel
input [23:0] i_rdatavld_ch,     // Read data valid of  each channel
input [31:0] o_rdata_ch_0,      // Channel 0 read data bus
input [31:0] o_rdata_ch_1,      // Channel 1 read data bus
input [31:0] o_rdata_ch_2,      // Channel 2 read data bus
input [31:0] o_rdata_ch_3,      // Channel 3 read data bus
input [31:0] o_rdata_ch_4,      // Channel 4 read data bus
input [31:0] o_rdata_ch_5,      // Channel 5 read data bus
input [31:0] o_rdata_ch_6,      // Channel 6 read data bus
input [31:0] o_rdata_ch_7,      // Channel 7 read data bus
input [31:0] o_rdata_ch_8,      // Channel 8 read data bus
input [31:0] o_rdata_ch_9,      // Channel 9 read data bus
input [31:0] o_rdata_ch_10,     // Channel 10 read data bus
input [31:0] o_rdata_ch_11,     // Channel 11 read data bus
input [31:0] o_rdata_ch_12,     // Channel 12 read data bus
input [31:0] o_rdata_ch_13,     // Channel 13 read data bus
input [31:0] o_rdata_ch_14,     // Channel 14 read data bus
input [31:0] o_rdata_ch_15,     // Channel 15 read data bus
input [31:0] o_rdata_ch_16,     // Channel 16 read data bus
input [31:0] o_rdata_ch_17,     // Channel 17 read data bus
input [31:0] o_rdata_ch_18,     // Channel 18 read data bus
input [31:0] o_rdata_ch_19,     // Channel 19 read data bus
input [31:0] o_rdata_ch_20,     // Channel 20 read data bus
input [31:0] o_rdata_ch_21,     // Channel 21 read data bus
input [31:0] o_rdata_ch_22,     // Channel 22 read data bus
input [31:0] o_rdata_ch_23,     // Channel 23 read data bus
input        avmm_rdatavld_top, // Top register valid read data
input [31:0] avmm_rdata_top,    // Top register read data bus
input        avmm_waitreq_top,  // Top register wait request
// Outputs
output        o_waitreq,  // Wait request
output        o_rdatavld, // Read data valid
output [31:0] o_rdata     // Read data bus
);

assign o_waitreq  = (&i_waitreq_ch)  & avmm_waitreq_top;
assign o_rdatavld = (|i_rdatavld_ch) | avmm_rdatavld_top;

assign o_rdata[31:0] = o_rdata_ch_0[31:0]   |
                       o_rdata_ch_1[31:0]   |
                       o_rdata_ch_2[31:0]   |
                       o_rdata_ch_3[31:0]   |
                       o_rdata_ch_4[31:0]   |
                       o_rdata_ch_5[31:0]   |
                       o_rdata_ch_6[31:0]   |
                       o_rdata_ch_7[31:0]   |
                       o_rdata_ch_8[31:0]   |
                       o_rdata_ch_9[31:0]   |
                       o_rdata_ch_10[31:0]  |
                       o_rdata_ch_11[31:0]  |
                       o_rdata_ch_12[31:0]  |
                       o_rdata_ch_13[31:0]  |
                       o_rdata_ch_14[31:0]  |
                       o_rdata_ch_15[31:0]  |
                       o_rdata_ch_16[31:0]  |
                       o_rdata_ch_17[31:0]  |
                       o_rdata_ch_18[31:0]  |
                       o_rdata_ch_19[31:0]  |
                       o_rdata_ch_20[31:0]  |
                       o_rdata_ch_21[31:0]  |
                       o_rdata_ch_22[31:0]  |
                       o_rdata_ch_23[31:0]  |
                       avmm_rdata_top[31:0];

endmodule // avalon_glue_logic
