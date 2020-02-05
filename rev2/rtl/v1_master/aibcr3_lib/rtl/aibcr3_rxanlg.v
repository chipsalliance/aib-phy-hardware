// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Verilog HDL and netlist files of
// "aibnd_lib aibcr3_rxanlg schematic"


// alias module. For internal use only.
//hdlFilesDir/cds_alias.v

// Netlisted models

// Library - aibnd_lib, Cell - aibnd_rxinv, View - schematic
// LAST TIME SAVED: Oct  1 14:27:50 2014
// NETLIST TIME: Oct 27 17:27:56 2014

module aibcr3_rxanlg (  oclkn, oclkp, odat, odat_async, iopad, 
     clk_en, data_en, iclkn, por, por_vccl );

output  oclkn, oclkp, odat, odat_async;

inout  iopad;


input  clk_en, data_en, iclkn, por, por_vccl ;

wire clk_enb, clk_en_buf, preoclkpb, preoclkp, oclkpb;
wire clk_en_vccl, data_en_vccl, nc_clk_enb_vccl, nc_data_enb_vccl;
wire preoclknb, preoclkn, oclknb;
wire data_enb, data_en_buf, preodatb, preodat, odatb, preodatn, odat_inv_b, odat_inv;
wire oclkn_vccl, oclkp_vccl, odat_vccl, odat_async_vccl;
wire por_buf;
wire por_vccl_buf;


aibcr3_lvshift I4 ( .por_low(por_vccl_buf),.por_high(1'b0) , 
      .out(clk_en_vccl), .outb(nc_clk_enb_vccl),
     .in(clk_en));

aibcr3_lvshift I3 ( .por_low(por_vccl_buf),.por_high(1'b0), 
      .out(data_en_vccl), .outb(nc_data_enb_vccl),
     .in(data_en));


assign por_vccl_buf = por_vccl;
assign por_buf = por;
//wire nc1, nc2, nc3, nc4;
wire oclkp_lvlshift, oclkn_lvlshift;
wire preodatnb, odat_inv_lvlshift, odat_async_lvlshift, odat_lvlshift ;

assign clk_enb = ~clk_en_vccl;
assign clk_en_buf = ~clk_enb;

assign oclkp_vccl = (iopad & clk_en_buf);
assign oclkp = oclkp_lvlshift;

assign oclkn_vccl = ~oclkp_vccl;
assign oclkn = oclkn_lvlshift;

assign data_enb = ~data_en_vccl;
assign data_en_buf = ~data_enb;

assign odat_vccl = (iopad & data_en_buf);
assign odat = odat_lvlshift;

assign odat_async_vccl = ~odat_vccl;
assign odat_async = ~odat_inv_lvlshift;

aibcr3_lvshift_diff x15 ( .inb(oclkn_vccl), .por(por_buf), 
      .out(oclkp_lvlshift),
     .outb(oclkn_lvlshift), .in(oclkp_vccl));
aibcr3_lvshift_diff x14 ( .inb(odat_async_vccl), .por(por_buf),
     .out(odat_lvlshift), .outb(odat_inv_lvlshift), .in(odat_vccl));
endmodule


// End HDL models

