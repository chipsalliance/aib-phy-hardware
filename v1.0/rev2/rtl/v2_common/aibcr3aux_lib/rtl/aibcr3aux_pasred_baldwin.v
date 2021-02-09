// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3aux_lib, Cell - aibcr3aux_pasred, View - schematic
// LAST TIME SAVED: Jul  8 20:21:54 2015
// NETLIST TIME: Jul  9 10:21:58 2015
// `timescale 1ns / 1ns 

module aibcr3aux_pasred_baldwin 
  ( 
    dn_por,
    iopad_crdet, 
    iopad_dn_por,
    vccl_aibcr3aux, 
    vssl_aibcr3aux );

output  dn_por;

inout  iopad_crdet, 
       iopad_dn_por;

input  vccl_aibcr3aux, 
       vssl_aibcr3aux;

wire csr_iocsr_sel, vssl_aibcr3aux, vcc_aibcr3aux, csr_pred_txen_int, csr_pred_txen;

// Buses in the design

wire  [1:0]  csr_pred_pdrv_int;

wire  [2:0]  csr_pred_rxen_int;

wire  [1:0]  csr_pred_ndrv_int;

wire net0266;
wire net087;
wire net075;
wire net076;
wire net077;
wire net078;
wire net0276;
wire net080;
wire net086;
wire net051;
wire net085;
wire net052;
wire net084;
wire net082;
wire net050;
wire net083;
wire net081;
wire net0291;
wire net0255;
wire net0206;
wire net0210;
wire net0214;
wire net0218;
wire net0183;
wire net0222;
wire net0251;
wire net054;
wire net0247;
wire net053;
wire net0243;
wire net0235;
wire net055;
wire net0239;
wire net0231;
wire net0283;
wire net0253;
wire net0204;
wire net0208;
wire net0212;
wire net0216;
wire net0220;
wire net0249;
wire net062;
wire net0245;
wire net063;
wire net0241;
wire net0233;
wire net064;
wire net0237;
wire net0229;
wire net0282;
wire net0101;
wire net088;
wire net089;
wire net090;
wire net091;
wire net093;
wire net0100;
wire net068;
wire net099;
wire net070;
wire net098;
wire net096;
wire net069;
wire net097;
wire net095;
wire net0277;
wire net0263;
wire net0224;
wire net0225;
wire net0226;
wire net0227;
wire net0228;
wire net0262;
wire net067;
wire net0261;
wire net065;
wire net0260;
wire net0258;
wire net066;
wire net0259;
wire net0257;
wire net0285;
wire net0115;
wire net0103;
wire net0104;
wire net0105;
wire net0106;
wire net0108;
wire net0114;
wire net073;
wire net0113;
wire net071;
wire net0112;
wire net0110;
wire net072;
wire net0111;
wire net0109;
wire net0288;
wire net0130;
wire net0442;
wire net0416;
wire net028;
wire net029;
wire net0402;
wire net0129;
wire net0267;
wire net0128;
wire net0265;
wire net0127;
wire net0125;
wire net074;
wire net0126;
wire net0124;
wire net0281;
wire net0254;
wire net0205;
wire net0209;
wire net0213;
wire net0217;
wire net0184;
wire net0221;
wire net0250;
wire net056;
wire net0246;
wire net057;
wire net0242;
wire net0234;
wire net058;
wire net0238;
wire net0230;
wire net0286;
wire net0256;
wire net0207;
wire net0211;
wire net0215;
wire net0219;
wire net0185;
wire net0223;
wire net0252;
wire net061;
wire net0248;
wire net060;
wire net0244;
wire net0236;
wire net059;
wire net0240;
wire net0232;
wire net0307;
wire net0334;
wire net0336;
wire net0123;
wire net0122;
wire net0284;
wire net0314;
wire net0299;
wire net0312;
wire net0305;
wire net0320;
wire net0107;
wire net0327;
wire net0278;
wire net0333;
wire net0325;
wire net0297;
wire net0290;
wire net0102;
wire net0323;
wire net0335;
wire net0120;
wire net0121;
wire net0119;
wire net0117;
wire net0116;
wire net0118;



// specify 
//     specparam CDS_LIBNAME  = "aibcr3aux_lib";
//     specparam CDS_CELLNAME = "aibcr3aux_pasred";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

//assign csr_pred_rxen_int[2:0] = csr_iocsr_sel ? csr_pred_rxen[2:0] : vssl_aibcr3aux;
//assign csr_pred_pdrv_int[1:0] = csr_iocsr_sel ? csr_pred_pdrv[1:0] : {vcc_aibcr3aux, vssl_aibcr3aux};
//assign csr_pred_txen_int = csr_iocsr_sel ? csr_pred_txen : vcc_aibcr3aux;
//assign csr_pred_ndrv_int[1:0] = csr_iocsr_sel ? csr_pred_ndrv[1:0] : {vcc_aibcr3aux, vssl_aibcr3aux};

aibcr3_buffx1_top  xporvccl ( .idata1_in1_jtag_out(net0307),
     .idata0_in1_jtag_out(net0334), .async_dat_in1_jtag_out(net0336),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net0266),
     /*.vssl(vssl_aibcr3aux),*/ /*.vccl(vccl_aibcr3aux),*/ /*.vcc(vccl_aibcr3aux),*/
     .por_aib_vccl(vssl_aibcr3aux), .por_aib_vcchssi(vssl_aibcr3aux),
     .anlg_rstb(vccl_aibcr3aux), .pd_data_aib(net087), .oclk_out(net075),
     .oclkb_out(net076), .odat0_out(net077), .odat1_out(net078),
     .odat_async_out(net0276), .pd_data_out(net080),
     .async_dat_in0(vccl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(vssl_aibcr3aux), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(vssl_aibcr3aux), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(vssl_aibcr3aux), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(vssl_aibcr3aux), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(vssl_aibcr3aux), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(vssl_aibcr3aux), .ilaunch_clk_in1(vssl_aibcr3aux),
     .ilpbk_dat_in0(vssl_aibcr3aux), .ilpbk_dat_in1(vssl_aibcr3aux),
     .ilpbk_en_in0(vssl_aibcr3aux), .ilpbk_en_in1(vssl_aibcr3aux),
     .indrv_in0({vccl_aibcr3aux,vssl_aibcr3aux}), .indrv_in1({vssl_aibcr3aux,
     vssl_aibcr3aux}), .ipdrv_in0({vccl_aibcr3aux,vssl_aibcr3aux}),
     .ipdrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .irxen_in0({vssl_aibcr3aux, vccl_aibcr3aux, vssl_aibcr3aux}),
     .irxen_in1({vssl_aibcr3aux, vccl_aibcr3aux, vssl_aibcr3aux}),
     .istrbclk_in0(vssl_aibcr3aux), .istrbclk_in1(vssl_aibcr3aux),
     .itxen_in0(vccl_aibcr3aux), .itxen_in1(vssl_aibcr3aux),
     .oclk_in1(vssl_aibcr3aux), .odat_async_aib(net086),
     .oclkb_in1(vssl_aibcr3aux), .jtag_clksel(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(vssl_aibcr3aux),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(vccl_aibcr3aux),
     .jtag_clkdr_out(net051), .jtag_intest(vssl_aibcr3aux),
     .odat1_aib(net085), .jtag_rx_scan_out(net052), .odat0_aib(net084),
     .oclk_aib(net082), .last_bs_out(net050), .oclkb_aib(net083),
     .jtag_clkdr_in(vssl_aibcr3aux), .jtag_rstb_en(vssl_aibcr3aux),
     .jtag_mode_in(vssl_aibcr3aux), .jtag_rstb(vssl_aibcr3aux),
     .jtag_tx_scan_in(vssl_aibcr3aux),
     .jtag_tx_scanen_in(vssl_aibcr3aux), .last_bs_in(vssl_aibcr3aux),
     .iopad(iopad_crdet), .oclkn(net081), .iclkn(vssl_aibcr3aux),
     .test_weakpu(vssl_aibcr3aux), .test_weakpd(vssl_aibcr3aux));

aibcr3_buffx1_top  xdn_por ( .idata1_in1_jtag_out(net0325),
     .idata0_in1_jtag_out(net0297), .async_dat_in1_jtag_out(net0290),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net0285),
     /*.vssl(vssl_aibcr3aux),*/ /*.vccl(vccl_aibcr3aux),*/ /*.vcc(vccl_aibcr3aux),*/
     .por_aib_vccl(vssl_aibcr3aux), .por_aib_vcchssi(vssl_aibcr3aux),
     .jtag_clksel(vssl_aibcr3aux), .jtag_intest(vssl_aibcr3aux),
     .jtag_rstb_en(vssl_aibcr3aux), .anlg_rstb(vccl_aibcr3aux),
     .pd_data_aib(net0115), .oclk_out(net0103), .oclkb_out(net0104),
     .odat0_out(net0105), .odat1_out(net0106), .odat_async_out(net0269),
     .pd_data_out(net0108), .async_dat_in0(vssl_aibcr3aux),
     .async_dat_in1(vssl_aibcr3aux), .iclkin_dist_in0(vssl_aibcr3aux),
     .iclkin_dist_in1(vssl_aibcr3aux), .idata0_in0(vssl_aibcr3aux),
     .idata0_in1(vssl_aibcr3aux), .idata1_in0(vssl_aibcr3aux),
     .idata1_in1(vssl_aibcr3aux), .idataselb_in0(vssl_aibcr3aux),
     .idataselb_in1(vssl_aibcr3aux), .iddren_in0(vssl_aibcr3aux),
     .iddren_in1(vssl_aibcr3aux), .ilaunch_clk_in0(vssl_aibcr3aux),
     .ilaunch_clk_in1(vssl_aibcr3aux), .ilpbk_dat_in0(vssl_aibcr3aux),
     .ilpbk_dat_in1(vssl_aibcr3aux), .ilpbk_en_in0(vssl_aibcr3aux),
     .ilpbk_en_in1(vssl_aibcr3aux), .indrv_in0({vssl_aibcr3aux,
     vssl_aibcr3aux}), .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .irxen_in0({vssl_aibcr3aux, vssl_aibcr3aux, vssl_aibcr3aux}), .irxen_in1({vssl_aibcr3aux,
     vssl_aibcr3aux, vssl_aibcr3aux}), .istrbclk_in0(vssl_aibcr3aux),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(vssl_aibcr3aux),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(dn_por), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(vssl_aibcr3aux),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(vccl_aibcr3aux),
     .jtag_clkdr_out(net073), .odat1_aib(net0113),
     .jtag_rx_scan_out(net071), .odat0_aib(net0112),
     .oclk_aib(net0110), .last_bs_out(net072), .oclkb_aib(net0111),
     .jtag_clkdr_in(vssl_aibcr3aux), .jtag_mode_in(vssl_aibcr3aux),
     .jtag_rstb(vssl_aibcr3aux), .jtag_tx_scan_in(vssl_aibcr3aux),
     .jtag_tx_scanen_in(vssl_aibcr3aux), .last_bs_in(vssl_aibcr3aux),
     .iopad(iopad_dn_por), .oclkn(net0109), .iclkn(vssl_aibcr3aux),
//   .test_weakpu(vssl_aibcr3aux), .test_weakpd(vccl_aibcr3aux));
     .test_weakpu(vccl_aibcr3aux), .test_weakpd(vssl_aibcr3aux)); //Changed from pull down to pull up for Figure 6-16 AIB AUX
                                                                  //Design Implementation of AIB system spec. JZ 12/30/2019 
endmodule
