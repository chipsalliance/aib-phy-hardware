// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcraux_lib, Cell - aibcraux_top_wrp, View - schematic
// LAST TIME SAVED: Apr 17 16:46:56 2015
// NETLIST TIME: Jun  3 17:00:06 2015
// Optimized for master AUX used along with 24 channel. 10/28/2019
// 1. Reduced aibcr3aux_top layer.
// 2. Changed name of VCCL to VCCIO. VCC_HSSI to VCCD
// 3. Removed all JTAG port. Removed DFT/ATPG.
// 4. Redundancy is not supported
// 5. Removed Xosc block
// 6. Removed level shifter for por to 1.8v since it is not used.
`timescale 1ps / 1ps 

module aibcr3aux_top_master ( 
     o_por_vcchssi, o_por_vccl, 
     oosc_clkout_dup, oosc_clkout,
     aib_aux74,
     aib_aux75, 
     aib_aux85, 
     aib_aux87, 
     c4por_vccl_ovrd, 
     iosc_bypclk
     ); //vcc_aibcraux, vcca_aibcraux,
     //vccl_aibcraux, vccr_aibcraux, vssl_aibcraux );

wire vcc_aibcraux, vcca_aibcraux, vccl_aibcraux, vccr_aibcraux, vssl_aibcraux;

output  o_por_vcchssi, o_por_vccl, oosc_clkout_dup, oosc_clkout;

inout  aib_aux74, aib_aux75, aib_aux85, aib_aux87;


input  c4por_vccl_ovrd, iosc_bypclk; 

assign vccl_aibcr3aux = 1'b1;
assign vcc_aibcr3aux  = 1'b1;
assign vssl_aibcr3aux =1'b0;

//Changed instantiation to match with the schematic, Jennifer 05/04/18
wire dn_por_in;
aibcr3aux_pasred_baldwin xpasred (
     .iopad_crdet(aib_aux74),
     .vssl_aibcr3aux(vssl_aibcr3aux),
     .vccl_aibcr3aux(vccl_aibcr3aux),
     .iopad_dn_por(aib_aux85),
     .dn_por(dn_por_in));
//assign o_por_vccl = ((~c4por_vccl_ovrd) | dn_por_in); The open source rev1 implementation.
assign  o_por_vccl = (c4por_vccl_ovrd & dn_por_in); //Note, same polarity with dn_por_in; 12/9/2019
//aibcr_aliasd aliasd_xrtl1 ( .rb(aib_aux85), .ra(aib_aux87));       //Reviewed by Designer
aibcr3_aliasd aliasd4 ( .rb(aib_aux75), .ra(aib_aux74));
assign osc_clkout = iosc_bypclk;
assign oosc_clkout_dup = osc_clkout;
assign oosc_clkout = osc_clkout;


aibcr3aux_lvshift  xlvlshf1 ( .vssl_aibcr3aux(vssl_aibcr3aux),
     .vccl_aibcr3aux(vccl_aibcr3aux), .vcc_aibcr3aux(vcc_aibcr3aux),
     .out(o_por_vcchssi), .in(o_por_vccl));

endmodule

