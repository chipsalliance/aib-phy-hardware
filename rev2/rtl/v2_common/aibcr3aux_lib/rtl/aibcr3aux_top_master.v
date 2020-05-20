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
// 04/22/2020
// 1. Shrink aux74/75 and aux85/87 to device_detect and por. 
// 2. modify level shifter and power sequence for BC.
`timescale 1ps / 1ps 

module aibcr3aux_top_master  
   (
    output wire  o_por_vcchssi,
    output wire  o_por_vccl,
    output wire  osc_clkout,
    inout  wire  device_detect, //Shrink aux74/75 due to limit microbump/C4 bump pin
    inout  wire  por,   //Shrink aux85/87 pin due to limit microbump/C4 bump pin
    input        m_por_ovrd, 
    input        i_osc_clk 
     ); 
     
`ifdef LEVEL_SHIFTER_TEST
wire   vccl_aibcr3aux;
wire   vcc_aibcr3aux;
`else
wire   vccl_aibcr3aux = 1'b1;
wire   vcc_aibcr3aux  = 1'b1;
`endif
wire   vssl_aibcr3aux =1'b0;

//Changed instantiation to match with the schematic, Jennifer 05/04/18
wire por_out;     //After IO buffer
wire por_out_vcc; //After level shifter
aibcr3aux_pasred_baldwin xpasred (
     .iopad_crdet(device_detect),
     .vssl_aibcr3aux(vssl_aibcr3aux),
     .vccl_aibcr3aux(vccl_aibcr3aux),
     .iopad_dn_por(por),
     .dn_por(por_dummy));
assign o_por_vcc = (m_por_ovrd & por_out_vcc); 
assign osc_clkout = i_osc_clk;
assign o_por_vcchssi = o_por_vcc;
assign o_por_vccl = 1'b0;

aibcr3_lvshift_vcc xlvlshf1 (
     .vccl_aibcr3aux(vccl_aibcr3aux), .vcc_aibcr3aux(vcc_aibcr3aux),
     .out(por_out_vcc), .in(por));  //Output go to AND gate to produce o_por_vccl

endmodule

