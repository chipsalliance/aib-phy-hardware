// SPDX-License-Identifier: Apache-2.0
// Copyright (c) 2019 Blue Cheetah Analog Design, Inc.
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3_lib, Cell - aibcr3_analog, View - schematic
// LAST TIME SAVED: Sep  5 22:18:58 2016
// NETLIST TIME: Sep  8 13:11:45 2016

// Ayar modified:
//  1.  Replacing positional definitions with port mapped (for all .libs)
//  2.  Changing instance names for leaf instances to make them easier to place
//  3.  Added the iopad_out port to separate the buffx1_top oclkn port from iopad
//      port. The oclk_route block is used to bridge the connection between iopad and
//      iopad_out and the rxanlg block now gets its input from the iopad_out port
//      so that it can still be auto-routed without it trying to connect directly
//      to iopad, TODO
//  4.  Switched the odat/odat_maxout to a explicit mux / buffer so it can be preserved
//
// BCA modified:
//  1.  New aibcr3_frontend module that contains the por_vccl level shifter/buffer, ESD,
//      aibcr3_rxanlg, and aibcr3_txanlg
//  2.  Delay cells are now generic modules that can instantiate process-specifc cells at a lower
//      level.

`timescale 1ns / 1ns

`default_nettype none
module aibcr3_analog ( oclkn, oclkp, odat, odat_async,
     iopad, iopad_out, clk_en, data_en, iclkn, indrv_buf, ipdrv_buf,
     itx_en_buf, por_aib_vcc1, por_aib_vcchssi, txdin, weak_pulldownen,
     weak_pullupenb
);

output wire oclkn, oclkp, odat, odat_async;


inout wire iopad, iopad_out;

input wire clk_en, data_en, iclkn, itx_en_buf, por_aib_vcc1,
     por_aib_vcchssi, txdin, weak_pulldownen, weak_pullupenb;

input wire [1:0]  indrv_buf;
input wire [1:0]  ipdrv_buf;

wire net14;
wire tielo;
wire odat_maxout;
wire odat_mid;

assign tielo = 1'b0;

`ifdef BEHAVIORAL
    assign odat_maxout = tielo? tielo : net14;
    assign odat = odat_maxout;
`else
    // Dummy loading / delays, these need to be preserved
    aibcr3_bypmux_x4 delay_mux  (.out(odat_maxout), .byp(tielo), .in1(tielo), .in0(net14));
    buffer delay_buf     (.out(odat_mid), .in(odat_maxout));
    // BCA: delay_buf_2 is the additional delay buffer that Ayar put in aibcr3_rxdig on this same
    // timing path. We moved it here because we are using Intel's aibcr3_rxdig, but still wanted
    // the matching delay of the additional buffer.
    buffer delay_buf_2   (.out(odat), .in(odat_mid));
`endif

aibcr3_frontend u_aibcr3_frontend (
    .clk_en(clk_en),
    .data_en(data_en),
    .din(txdin),
    .iclkn(iclkn),
    .indrv_buf(indrv_buf[1:0]),
    .ipdrv_buf(ipdrv_buf[1:0]),
    .itx_en_buf(itx_en_buf),
    .por(por_aib_vcchssi),
    .weak_pulldownen(weak_pulldownen),
    .weak_pullupenb(weak_pullupenb),
    .iopad_out(iopad_out),
    .oclkn(oclkn),
    .oclkp(oclkp),
    .odat(net14),
    .odat_async(odat_async),
    .iopad(iopad)
);

endmodule
`default_nettype wire

