// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_analog, View - schematic
// LAST TIME SAVED: Dec 11 16:48:20 2014
// NETLIST TIME: Dec 17 10:24:02 2014

module aibnd_analog ( oclkn, oclkp, odat, odat_async, iopad, clk_en,
     data_en, iclkn, ndrv_enb, pdrv_en, txdin, vccl_aibnd, vssl_aibnd,
     weak_pulldownen, weak_pullupenb );

output  oclkn, oclkp, odat, odat_async;

inout  iopad;

input  clk_en, data_en, iclkn, txdin, vccl_aibnd, vssl_aibnd,
     weak_pulldownen, weak_pullupenb;

input [15:0]  pdrv_en;
input [15:0]  ndrv_enb;



aibnd_txanlg  xtxbuf ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .ndrv_enb(ndrv_enb[15:0]),
     .weak_pullupenb(weak_pullupenb), .txpadout(iopad), .din(txdin),
     .pdrv_en(pdrv_en[15:0]), .weak_pulldownen(weak_pulldownen));
aibnd_rxanlg  xrxbuf ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .odat_async(odat_async),
     .data_en(data_en), .clk_en(clk_en), .odat(odat), .oclkn(oclkn),
     .oclkp(oclkp), .iopad(iopad), .iclkn(iclkn));
aibnd_d8xsesdd1  xesd1 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .iopad(iopad));
aibnd_d8xsesdd2  xesd2 ( .vssl_aibnd(vssl_aibnd),
     .vccl_aibnd(vccl_aibnd), .iopad(iopad));

endmodule

