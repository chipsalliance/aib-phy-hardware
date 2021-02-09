// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3_lib, Cell - aibcr3_analog, View - schematic
// LAST TIME SAVED: Sep  5 22:18:58 2016
// NETLIST TIME: Sep  8 13:11:45 2016
`timescale 1ns / 1ns 

module aibcr3_analog ( oclkn, oclkp, odat, odat_async, 
     iopad, clk_en, data_en, iclkn, indrv_buf, ipdrv_buf,
     itx_en_buf, por_aib_vcc1, por_aib_vcchssi, txdin, weak_pulldownen,
     weak_pullupenb  
);

output  oclkn, oclkp, odat, odat_async;


inout iopad;

input  clk_en, data_en, iclkn, itx_en_buf, por_aib_vcc1,
     por_aib_vcchssi, txdin, weak_pulldownen, weak_pullupenb;

input [1:0]  indrv_buf;
input [1:0]  ipdrv_buf;

wire net14;

assign tielo = 1'b0;
assign odat_maxout = tielo? tielo : net14;
assign odat = odat_maxout;

aibcr3_esd x5 ( iopad );

aibcr3_rxanlg x0 ( oclkn, oclkp, net14, odat_async, 
     iopad, 
     clk_en, data_en, iclkn, por_aib_vcchssi, por_aib_vcc1);

aibcr3_txanlg x1 ( iopad, txdin, indrv_buf[1:0],
     ipdrv_buf[1:0], itx_en_buf, por_aib_vcc1, weak_pulldownen,
     weak_pullupenb);


endmodule
