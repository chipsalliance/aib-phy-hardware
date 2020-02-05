// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3aux_lib, Cell - aibcr3aux_async, View - schematic
// LAST TIME SAVED: Aug 24 11:14:41 2015
// NETLIST TIME: Aug 26 15:05:12 2015
// `timescale 1ns / 1ns 

module aibcr3aux_async ( io_in, io_oe, jtag_rx_scan_out_10x7,
     jtag_rx_scan_out_10x8, last_bs_out_10x7, last_bs_out_10x8,
     iopad_auxactred1, iopad_auxactred2, iopad_io_in, iopad_io_oe,
     iopad_io_out, iopad_tstmx, anlg_rstb, csr_actreden,
     csr_asyn_dataselb, csr_asyn_ndrv, csr_asyn_pdrv, csr_asyn_rxen,
     csr_asyn_txen, csr_iocsr_sel, dig_rstb, io_out, jtag_clkdr1l,
     jtag_clkdr1r, jtag_clkdr2l, jtag_clkdr2r, jtag_clkdr_int_buf,
     jtag_clksel, jtag_intest, jtag_mode_in, jtag_rstb, jtag_rstb_en,
     jtag_tx_scan_in_01x5, jtag_tx_scan_in_01x6, jtag_tx_scanen_in,
     jtag_weakpdn, jtag_weakpu, last_bs_in_01x5, last_bs_in_01x6,
     por_vcchssi, por_vccl, tstmx, vcc_aibcr3aux, vccl_aibcr3aux,
     vssl_aibcr3aux );

output  jtag_rx_scan_out_10x7, jtag_rx_scan_out_10x8, last_bs_out_10x7,
     last_bs_out_10x8;

inout  iopad_auxactred1, iopad_auxactred2;

input  anlg_rstb, csr_asyn_dataselb, csr_asyn_txen, csr_iocsr_sel,
     dig_rstb, jtag_clkdr1l, jtag_clkdr1r, jtag_clkdr2l, jtag_clkdr2r,
     jtag_clkdr_int_buf, jtag_clksel, jtag_intest, jtag_mode_in,
     jtag_rstb, jtag_rstb_en, jtag_tx_scan_in_01x5,
     jtag_tx_scan_in_01x6, jtag_tx_scanen_in, jtag_weakpdn,
     jtag_weakpu, last_bs_in_01x5, last_bs_in_01x6, por_vcchssi,
     por_vccl, vcc_aibcr3aux, vccl_aibcr3aux, vssl_aibcr3aux;

output [7:0]  io_in;
output [1:0]  io_oe;

inout [7:0]  iopad_io_out;
inout [1:0]  iopad_io_oe;
inout [7:0]  iopad_io_in;
inout [7:0]  iopad_tstmx;

input [2:0]  csr_asyn_rxen;
input [1:0]  csr_asyn_pdrv;
input [12:0]  csr_actreden;
input [7:0]  tstmx;
input [1:0]  csr_asyn_ndrv;
input [7:0]  io_out;

wire csr_asyn_txen_int, csr_iocsr_sel, vcc_aibcr3aux, csr_asyn_txen, vssl_aibcr3aux;

// Buses in the design

wire  [1:0]  csr_asyn_ndrv_int;

wire  [1:0]  csr_asyn_pdrv_int;

wire  [2:0]  csr_asyn_rxen_int;

wire net0719;
wire net0646;
wire net0633;
wire net0606;
wire net0677;
wire net0647;
wire net0694;
wire net0700;
wire net0624;
wire net0729;
wire net0699;
wire net0675;
wire net0701;
wire net0693;
wire jtag_rx_scan_in_11x8;
wire last_bs_in_11x8;
wire net0602;
wire net0705;
wire net0626;
wire net0614;
wire net0680;
wire net0702;
wire net0619;
wire net0618;
wire net0650;
wire net0689;
wire net0707;
wire net0692;
wire net0683;
wire net0698;
wire net0661;
wire jtag_rx_scan_in_11x7;
wire last_bs_in_11x7;
wire net0629;
wire net0789;
wire net0663;
wire net0639;
wire net0671;
wire net0649;
wire net0656;
wire net0717;
wire net0672;
wire net0655;
wire net0773;
wire net0673;
wire jtag_rx_scan_in_12x8;
wire net0654;
wire net0664;
wire last_bs_in_12x8;
wire net0670;
wire jtag_rx_scan_in_12x6;
wire last_bs_in_12x6;
wire net0660;
wire net0725;
wire net0645;
wire net0674;
wire net0637;
wire net0644;
wire net0651;
wire net0695;
wire net0667;
wire net0638;
wire net0748;
wire net0669;
wire jtag_rx_scan_in_12x7;
wire net0643;
wire net0635;
wire last_bs_in_12x7;
wire net0668;
wire jtag_rx_scan_in_12x5;
wire last_bs_in_12x5;
wire net0665;
wire net0764;
wire net0342;
wire net0652;
wire net0332;
wire net0333;
wire net0334;
wire net0754;
wire net0335;
wire net0341;
wire net0691;
wire net0340;
wire net0339;
wire net0337;
wire net0338;
wire jtag_rx_scan_in_11x6;
wire last_bs_in_11x6;
wire net0336;
wire net0779;
wire net0354;
wire net0343;
wire net0344;
wire net0345;
wire net0346;
wire net0728;
wire net0347;
wire net0353;
wire net0687;
wire net0352;
wire net0351;
wire net0349;
wire net0350;
wire jtag_rx_scan_in_11x5;
wire last_bs_in_11x5;
wire net0348;
wire net0771;
wire net0366;
wire net0355;
wire net0356;
wire net0357;
wire net0358;
wire net0690;
wire net0359;
wire net0365;
wire net0709;
wire net0364;
wire jtag_rx_scan_in_10x6;
wire net0363;
wire net0361;
wire last_bs_in_10x6;
wire net0362;
wire jtag_rx_scan_in_09x6;
wire last_bs_in_09x6;
wire net0360;
wire net0788;
wire net0378;
wire net0367;
wire net0368;
wire net0369;
wire net0370;
wire net0684;
wire net0371;
wire net0377;
wire net0734;
wire net0376;
wire jtag_rx_scan_in_10x5;
wire net0375;
wire net0373;
wire last_bs_in_10x5;
wire net0374;
wire jtag_rx_scan_in_09x5;
wire last_bs_in_09x5;
wire net0372;
wire net0784;
wire net0223;
wire net0488;
wire net0489;
wire net0474;
wire net0215;
wire net0737;
wire net0216;
wire net0222;
wire net0759;
wire net0221;
wire net0220;
wire net0218;
wire net0219;
wire net0217;
wire net0735;
wire net0235;
wire net0224;
wire net0225;
wire net0226;
wire net0227;
wire net0752;
wire net0228;
wire net0234;
wire net0776;
wire net0233;
wire net0487;
wire net0485;
wire net0231;
wire net0229;
wire net0685;
wire net0247;
wire net0236;
wire net0237;
wire net0238;
wire net0239;
wire net0676;
wire net0240;
wire net0246;
wire net0746;
wire net0245;
wire net0244;
wire net0242;
wire net0243;
wire net0241;
wire net0769;
wire net0259;
wire net0248;
wire net0249;
wire net0250;
wire net0251;
wire net0747;
wire net0252;
wire net0258;
wire net0770;
wire net0257;
wire net0256;
wire net0254;
wire net0255;
wire net0253;
wire net0766;
wire net0271;
wire net0260;
wire net0261;
wire net0262;
wire net0263;
wire net0758;
wire net0264;
wire net0270;
wire net0724;
wire net0269;
wire net0268;
wire net0266;
wire net0267;
wire jtag_rx_scan_in_08x6;
wire last_bs_in_08x6;
wire net0265;
wire net0785;
wire net0283;
wire net0272;
wire net0273;
wire net0274;
wire net0275;
wire net0742;
wire net0276;
wire net0282;
wire net0688;
wire net0281;
wire net0280;
wire net0278;
wire net0279;
wire jtag_rx_scan_in_08x5;
wire last_bs_in_08x5;
wire net0277;
wire net0760;
wire net0295;
wire net0284;
wire net0285;
wire net0286;
wire net0287;
wire net0744;
wire net0288;
wire net0294;
wire net0781;
wire net0293;
wire net0292;
wire net0290;
wire net0291;
wire jtag_rx_scan_in_07x6;
wire last_bs_in_07x6;
wire net0289;
wire net0730;
wire net0469;
wire net0296;
wire net0297;
wire net0298;
wire net0299;
wire net0761;
wire net0479;
wire net0475;
wire net0763;
wire net0305;
wire net0480;
wire net0477;
wire net0303;
wire jtag_rx_scan_in_07x5;
wire last_bs_in_07x5;
wire net0481;
wire net0732;
wire net0319;
wire net0482;
wire net0309;
wire net0473;
wire net0311;
wire net0767;
wire net0312;
wire io_out1_to_oe1;
wire net0749;
wire net0472;
wire net0483;
wire net0314;
wire net0471;
wire jtag_rx_scan_in_06x6;
wire last_bs_in_06x6;
wire net0478;
wire net0716;
wire net0331;
wire net0320;
wire net0321;
wire net0322;
wire net0323;
wire net0703;
wire net0324;
wire io_out0_to_oe0;
wire net0711;
wire net0329;
wire net0328;
wire net0326;
wire net0327;
wire jtag_rx_scan_in_06x5;
wire last_bs_in_06x5;
wire net0325;
wire net0648;
wire net0232;
wire net077;
wire net078;
wire net079;
wire net080;
wire net081;
wire io_oe0_to_in6;
wire net0696;
wire net086;
wire net085;
wire net083;
wire net084;
wire jtag_rx_scan_in_05x5;
wire last_bs_in_05x5;
wire net082;
wire net0772;
wire net0317;
wire net0166;
wire net0167;
wire net0214;
wire net0230;
wire net0169;
wire io_oe1_to_in7;
wire net0745;
wire net0304;
wire net0300;
wire net0315;
wire net0310;
wire jtag_rx_scan_in_05x6;
wire last_bs_in_05x6;
wire net0170;
wire net0678;
wire net0308;
wire net0301;
wire net0189;
wire net0190;
wire net0191;
wire net0307;
wire io_in7_to_in5;
wire net0733;
wire net0198;
wire net0306;
wire net0302;
wire net0196;
wire jtag_rx_scan_in_04x6;
wire last_bs_in_04x6;
wire net0194;
wire net0780;
wire net0213;
wire net0201;
wire net0202;
wire net0203;
wire net0204;
wire net0206;
wire io_in6_to_in4;
wire net0715;
wire net0211;
wire net0210;
wire net0208;
wire net0209;
wire jtag_rx_scan_in_04x5;
wire last_bs_in_04x5;
wire net0207;
wire net0783;
wire net0101;
wire net088;
wire net089;
wire net090;
wire net091;
wire net093;
wire io_in5_to_in3;
wire net0786;
wire net099;
wire net098;
wire net096;
wire net097;
wire jtag_rx_scan_in_03x6;
wire last_bs_in_03x6;
wire net095;
wire net0740;
wire net0188;
wire net094;
wire net0102;
wire net0195;
wire net0185;
wire net0182;
wire io_in4_to_in2;
wire net0791;
wire net0197;
wire net0199;
wire net0180;
wire net0193;
wire jtag_rx_scan_in_03x5;
wire last_bs_in_03x5;
wire net0184;
wire net0755;
wire net0115;
wire net0103;
wire net0104;
wire net0105;
wire net0106;
wire net0108;
wire io_in3_to_in1;
wire net0778;
wire net0113;
wire net0112;
wire net0110;
wire net0111;
wire jtag_rx_scan_in_02x6;
wire last_bs_in_02x6;
wire net0109;
wire net0787;
wire net0176;
wire net0116;
wire net0117;
wire net0172;
wire net0177;
wire net0119;
wire io_in2_to_in0;
wire net0765;
wire net0171;
wire net0123;
wire net0121;
wire net0122;
wire jtag_rx_scan_in_02x5;
wire last_bs_in_02x5;
wire net0120;
wire net0722;
wire net0130;
wire net0442;
wire net0416;
wire net028;
wire net029;
wire net0402;
wire net0129;
wire net0790;
wire net0128;
wire net0127;
wire net0125;
wire net0126;
wire net0124;
wire net0712;
wire net051;
wire net041;
wire net042;
wire net0174;
wire net0175;
wire net044;
wire net050;
wire net0713;
wire net049;
wire net048;
wire net046;
wire net047;
wire net045;
wire net0840;
wire net0860;
wire net0911;
wire tstmx7_to_auxactred2;
wire net0885;
wire net0864;
wire net0798;
wire tstmx6_to_auxactred1;
wire net0871;
wire net0774;
wire tstmx5_to_tstmx7;
wire tstmx3_to_tstmx5;
wire net0886;
wire net0881;
wire tstmx4_to_tstmx6;
wire tstmx2_to_tstmx4;
wire net0818;
wire net0869;
wire tstmx1_to_txtmx3;
wire net0843;
wire net0720;
wire tstmx0_to_tstmx2;
wire net818;
wire net817;
wire out7_to_tstmx1;
wire out5_to_out7;
wire net0832;
wire net0863;
wire out6_to_tstmx0;
wire out4_to_out6;
wire net0861;
wire net0855;
wire net0833;
wire net0814;
wire net0756;
wire net0836;
wire net0880;
wire net0876;
wire net813;
wire net814;
wire out3_to_out5;
wire net0870;
wire net0902;
wire out2_to_out4;
wire net809;
wire net810;
wire out1_to_out3;
wire net0736;
wire net0828;
wire out0_to_out2;
wire net0909;
wire net0837;
wire net0858;
wire net0741;
wire net0815;
wire net0890;
wire net0862;
wire net0892;
wire net0792;
wire net0873;
wire net0899;
wire net0884;
wire net0821;
wire net0912;
wire net0905;
wire net0901;
wire net0894;
wire net0904;
wire net0868;
wire net0910;
wire net0800;
wire net0802;
wire net0859;
wire net0898;
wire net0830;
wire net0839;
wire net0891;
wire net0887;
wire net0854;
wire net0866;
wire net0908;
wire net0907;
wire net0819;
wire net0743;

// specify 
//     specparam CDS_LIBNAME  = "aibcr3aux_lib";
//     specparam CDS_CELLNAME = "aibcr3aux_async";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

assign csr_asyn_txen_int = csr_iocsr_sel ? csr_asyn_txen : vcc_aibcr3aux;
assign csr_asyn_pdrv_int[1:0] = csr_iocsr_sel ? csr_asyn_pdrv[1:0] : {vcc_aibcr3aux, vssl_aibcr3aux};
assign csr_asyn_rxen_int[2:0] = csr_iocsr_sel ? csr_asyn_rxen[2:0] : vssl_aibcr3aux;
assign csr_asyn_ndrv_int[1:0] = csr_iocsr_sel ? csr_asyn_ndrv[1:0] : {vcc_aibcr3aux, vssl_aibcr3aux};

aibcr3_buffx1_top  xauxactred1 ( .idata1_in1_jtag_out(net0840),
     .idata0_in1_jtag_out(net0860), .async_dat_in1_jtag_out(net0911),
     .prev_io_shift_en(csr_actreden[12]), .jtag_clkdr_outn(net0719),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .anlg_rstb(anlg_rstb), .pd_data_aib(net0646), .oclk_out(net0633),
     .oclkb_out(net0606), .odat0_out(net0677), .odat1_out(net0647),
     .odat_async_out(net0694), .pd_data_out(net0700),
     .async_dat_in0(vssl_aibcr3aux),
     .async_dat_in1(tstmx7_to_auxactred2),
     .iclkin_dist_in0(vssl_aibcr3aux), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(vssl_aibcr3aux), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(vssl_aibcr3aux), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(vssl_aibcr3aux), .idataselb_in1(csr_asyn_dataselb),
     .iddren_in0(vssl_aibcr3aux), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(vssl_aibcr3aux), .ilaunch_clk_in1(vssl_aibcr3aux),
     .ilpbk_dat_in0(vssl_aibcr3aux), .ilpbk_dat_in1(vssl_aibcr3aux),
     .ilpbk_en_in0(vssl_aibcr3aux), .ilpbk_en_in1(vssl_aibcr3aux),
     .indrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .indrv_in1(csr_asyn_ndrv_int[1:0]), .ipdrv_in0({vssl_aibcr3aux,
     vssl_aibcr3aux}), .ipdrv_in1(csr_asyn_pdrv_int[1:0]),
     .irxen_in0({vssl_aibcr3aux, vssl_aibcr3aux, vssl_aibcr3aux}),
     .irxen_in1({vssl_aibcr3aux, vcc_aibcr3aux, vssl_aibcr3aux}),
     .istrbclk_in0(vssl_aibcr3aux), .istrbclk_in1(vssl_aibcr3aux),
     .itxen_in0(vssl_aibcr3aux), .itxen_in1(csr_asyn_txen_int),
     .oclk_in1(vssl_aibcr3aux), .odat_async_aib(net0624),
     .oclkb_in1(vssl_aibcr3aux), .jtag_clksel(jtag_clksel),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(csr_actreden[12]),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0729), .jtag_intest(jtag_intest),
     .odat1_aib(net0699), .jtag_rx_scan_out(jtag_rx_scan_out_10x8),
     .odat0_aib(net0675), .oclk_aib(net0701),
     .last_bs_out(last_bs_out_10x8), .oclkb_aib(net0693),
     .jtag_clkdr_in(jtag_clkdr_int_buf), .jtag_rstb_en(jtag_rstb_en),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_11x8),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_11x8), .iopad(iopad_auxactred2),
     .oclkn(net0602), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xauxactred2 ( .idata1_in1_jtag_out(net0885),
     .idata0_in1_jtag_out(net0864), .async_dat_in1_jtag_out(net0798),
     .prev_io_shift_en(csr_actreden[12]), .jtag_clkdr_outn(net0705),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .anlg_rstb(anlg_rstb), .pd_data_aib(net0626), .oclk_out(net0614),
     .oclkb_out(net0680), .odat0_out(net0702), .odat1_out(net0619),
     .odat_async_out(net0618), .pd_data_out(net0650),
     .async_dat_in0(vssl_aibcr3aux),
     .async_dat_in1(tstmx6_to_auxactred1),
     .iclkin_dist_in0(vssl_aibcr3aux), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(vssl_aibcr3aux), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(vssl_aibcr3aux), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(vssl_aibcr3aux), .idataselb_in1(csr_asyn_dataselb),
     .iddren_in0(vssl_aibcr3aux), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(vssl_aibcr3aux), .ilaunch_clk_in1(vssl_aibcr3aux),
     .ilpbk_dat_in0(vssl_aibcr3aux), .ilpbk_dat_in1(vssl_aibcr3aux),
     .ilpbk_en_in0(vssl_aibcr3aux), .ilpbk_en_in1(vssl_aibcr3aux),
     .indrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .indrv_in1(csr_asyn_ndrv_int[1:0]), .ipdrv_in0({vssl_aibcr3aux,
     vssl_aibcr3aux}), .ipdrv_in1(csr_asyn_pdrv_int[1:0]),
     .irxen_in0({vssl_aibcr3aux, vssl_aibcr3aux, vssl_aibcr3aux}),
     .irxen_in1({vssl_aibcr3aux, vcc_aibcr3aux, vssl_aibcr3aux}),
     .istrbclk_in0(vssl_aibcr3aux), .istrbclk_in1(vssl_aibcr3aux),
     .itxen_in0(vssl_aibcr3aux), .itxen_in1(csr_asyn_txen_int),
     .oclk_in1(vssl_aibcr3aux), .odat_async_aib(net0689),
     .oclkb_in1(vssl_aibcr3aux), .jtag_clksel(jtag_clksel),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(csr_actreden[12]),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0707), .jtag_intest(jtag_intest),
     .odat1_aib(net0692), .jtag_rx_scan_out(jtag_rx_scan_out_10x7),
     .odat0_aib(net0683), .oclk_aib(net0698),
     .last_bs_out(last_bs_out_10x7), .oclkb_aib(net0661),
     .jtag_clkdr_in(jtag_clkdr_int_buf), .jtag_rstb_en(jtag_rstb_en),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_11x7),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_11x7), .iopad(iopad_auxactred1),
     .oclkn(net0629), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xtstmx4 ( .idata1_in1_jtag_out(net0871),
     .idata0_in1_jtag_out(net0774),
     .async_dat_in1_jtag_out(tstmx5_to_tstmx7),
     .prev_io_shift_en(csr_actreden[10]), .jtag_clkdr_outn(net0789),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0663), .oclk_out(net0639), .oclkb_out(net0671),
     .odat0_out(net0649), .odat1_out(net0656),
     .odat_async_out(net0717), .pd_data_out(net0672),
     .async_dat_in0(tstmx[5]), .async_dat_in1(tstmx3_to_tstmx5),
     .iclkin_dist_in0(vssl_aibcr3aux), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(vssl_aibcr3aux), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(vssl_aibcr3aux), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(csr_asyn_dataselb),
     .idataselb_in1(csr_asyn_dataselb), .iddren_in0(vssl_aibcr3aux),
     .iddren_in1(vssl_aibcr3aux), .ilaunch_clk_in0(vssl_aibcr3aux),
     .ilaunch_clk_in1(vssl_aibcr3aux), .ilpbk_dat_in0(vssl_aibcr3aux),
     .ilpbk_dat_in1(vssl_aibcr3aux), .ilpbk_en_in0(vssl_aibcr3aux),
     .ilpbk_en_in1(vssl_aibcr3aux), .indrv_in0(csr_asyn_ndrv_int[1:0]),
     .indrv_in1(csr_asyn_ndrv_int[1:0]),
     .ipdrv_in0(csr_asyn_pdrv_int[1:0]),
     .ipdrv_in1(csr_asyn_pdrv_int[1:0]), .irxen_in0({vssl_aibcr3aux,
     vcc_aibcr3aux, vssl_aibcr3aux}), .irxen_in1({vssl_aibcr3aux,
     vcc_aibcr3aux, vssl_aibcr3aux}), .istrbclk_in0(vssl_aibcr3aux),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(csr_asyn_txen_int),
     .itxen_in1(csr_asyn_txen_int), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0655), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(csr_actreden[11]),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0773), .odat1_aib(net0673),
     .jtag_rx_scan_out(jtag_rx_scan_in_12x8), .odat0_aib(net0654),
     .oclk_aib(net0664), .last_bs_out(last_bs_in_12x8),
     .oclkb_aib(net0670), .jtag_clkdr_in(jtag_clkdr1r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_12x6),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_12x6), .iopad(iopad_tstmx[5]),
     .oclkn(net0660), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xtstmx5 ( .idata1_in1_jtag_out(net0886),
     .idata0_in1_jtag_out(net0881),
     .async_dat_in1_jtag_out(tstmx4_to_tstmx6),
     .prev_io_shift_en(csr_actreden[10]), .jtag_clkdr_outn(net0725),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0645), .oclk_out(net0674), .oclkb_out(net0637),
     .odat0_out(net0644), .odat1_out(net0651),
     .odat_async_out(net0695), .pd_data_out(net0667),
     .async_dat_in0(tstmx[4]), .async_dat_in1(tstmx2_to_tstmx4),
     .iclkin_dist_in0(vssl_aibcr3aux), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(vssl_aibcr3aux), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(vssl_aibcr3aux), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(csr_asyn_dataselb),
     .idataselb_in1(csr_asyn_dataselb), .iddren_in0(vssl_aibcr3aux),
     .iddren_in1(vssl_aibcr3aux), .ilaunch_clk_in0(vssl_aibcr3aux),
     .ilaunch_clk_in1(vssl_aibcr3aux), .ilpbk_dat_in0(vssl_aibcr3aux),
     .ilpbk_dat_in1(vssl_aibcr3aux), .ilpbk_en_in0(vssl_aibcr3aux),
     .ilpbk_en_in1(vssl_aibcr3aux), .indrv_in0(csr_asyn_ndrv_int[1:0]),
     .indrv_in1(csr_asyn_ndrv_int[1:0]),
     .ipdrv_in0(csr_asyn_pdrv_int[1:0]),
     .ipdrv_in1(csr_asyn_pdrv_int[1:0]), .irxen_in0({vssl_aibcr3aux,
     vcc_aibcr3aux, vssl_aibcr3aux}), .irxen_in1({vssl_aibcr3aux,
     vcc_aibcr3aux, vssl_aibcr3aux}), .istrbclk_in0(vssl_aibcr3aux),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(csr_asyn_txen_int),
     .itxen_in1(csr_asyn_txen_int), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0638), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(csr_actreden[11]),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0748), .odat1_aib(net0669),
     .jtag_rx_scan_out(jtag_rx_scan_in_12x7), .odat0_aib(net0643),
     .oclk_aib(net0635), .last_bs_out(last_bs_in_12x7),
     .oclkb_aib(net0668), .jtag_clkdr_in(jtag_clkdr2r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_12x5),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_12x5), .iopad(iopad_tstmx[4]),
     .oclkn(net0665), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xtstmx2 ( .idata1_in1_jtag_out(net0818),
     .idata0_in1_jtag_out(net0869),
     .async_dat_in1_jtag_out(tstmx3_to_tstmx5),
     .prev_io_shift_en(csr_actreden[9]), .jtag_clkdr_outn(net0764),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0342), .oclk_out(net0652), .oclkb_out(net0332),
     .odat0_out(net0333), .odat1_out(net0334),
     .odat_async_out(net0754), .pd_data_out(net0335),
     .async_dat_in0(tstmx[3]), .async_dat_in1(tstmx1_to_txtmx3),
     .iclkin_dist_in0(vssl_aibcr3aux), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(vssl_aibcr3aux), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(vssl_aibcr3aux), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(csr_asyn_dataselb),
     .idataselb_in1(csr_asyn_dataselb), .iddren_in0(vssl_aibcr3aux),
     .iddren_in1(vssl_aibcr3aux), .ilaunch_clk_in0(vssl_aibcr3aux),
     .ilaunch_clk_in1(vssl_aibcr3aux), .ilpbk_dat_in0(vssl_aibcr3aux),
     .ilpbk_dat_in1(vssl_aibcr3aux), .ilpbk_en_in0(vssl_aibcr3aux),
     .ilpbk_en_in1(vssl_aibcr3aux), .indrv_in0(csr_asyn_ndrv_int[1:0]),
     .indrv_in1(csr_asyn_ndrv_int[1:0]),
     .ipdrv_in0(csr_asyn_pdrv_int[1:0]),
     .ipdrv_in1(csr_asyn_pdrv_int[1:0]), .irxen_in0({vssl_aibcr3aux,
     vcc_aibcr3aux, vssl_aibcr3aux}), .irxen_in1({vssl_aibcr3aux,
     vcc_aibcr3aux, vssl_aibcr3aux}), .istrbclk_in0(vssl_aibcr3aux),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(csr_asyn_txen_int),
     .itxen_in1(csr_asyn_txen_int), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0341), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(csr_actreden[10]),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0691), .odat1_aib(net0340),
     .jtag_rx_scan_out(jtag_rx_scan_in_12x6), .odat0_aib(net0339),
     .oclk_aib(net0337), .last_bs_out(last_bs_in_12x6),
     .oclkb_aib(net0338), .jtag_clkdr_in(jtag_clkdr1r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_11x6),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_11x6), .iopad(iopad_tstmx[3]),
     .oclkn(net0336), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xtstmx3 ( .idata1_in1_jtag_out(net0843),
     .idata0_in1_jtag_out(net0720),
     .async_dat_in1_jtag_out(tstmx2_to_tstmx4),
     .prev_io_shift_en(csr_actreden[9]), .jtag_clkdr_outn(net0779),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0354), .oclk_out(net0343), .oclkb_out(net0344),
     .odat0_out(net0345), .odat1_out(net0346),
     .odat_async_out(net0728), .pd_data_out(net0347),
     .async_dat_in0(tstmx[2]), .async_dat_in1(tstmx0_to_tstmx2),
     .iclkin_dist_in0(vssl_aibcr3aux), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(vssl_aibcr3aux), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(vssl_aibcr3aux), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(csr_asyn_dataselb),
     .idataselb_in1(csr_asyn_dataselb), .iddren_in0(vssl_aibcr3aux),
     .iddren_in1(vssl_aibcr3aux), .ilaunch_clk_in0(vssl_aibcr3aux),
     .ilaunch_clk_in1(vssl_aibcr3aux), .ilpbk_dat_in0(vssl_aibcr3aux),
     .ilpbk_dat_in1(vssl_aibcr3aux), .ilpbk_en_in0(vssl_aibcr3aux),
     .ilpbk_en_in1(vssl_aibcr3aux), .indrv_in0(csr_asyn_ndrv_int[1:0]),
     .indrv_in1(csr_asyn_ndrv_int[1:0]),
     .ipdrv_in0(csr_asyn_pdrv_int[1:0]),
     .ipdrv_in1(csr_asyn_pdrv_int[1:0]), .irxen_in0({vssl_aibcr3aux,
     vcc_aibcr3aux, vssl_aibcr3aux}), .irxen_in1({vssl_aibcr3aux,
     vcc_aibcr3aux, vssl_aibcr3aux}), .istrbclk_in0(vssl_aibcr3aux),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(csr_asyn_txen_int),
     .itxen_in1(csr_asyn_txen_int), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0353), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(csr_actreden[10]),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0687), .odat1_aib(net0352),
     .jtag_rx_scan_out(jtag_rx_scan_in_12x5), .odat0_aib(net0351),
     .oclk_aib(net0349), .last_bs_out(last_bs_in_12x5),
     .oclkb_aib(net0350), .jtag_clkdr_in(jtag_clkdr2r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_11x5),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_11x5), .iopad(iopad_tstmx[2]),
     .oclkn(net0348), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xio_oe0 ( .idata1_in1_jtag_out(net818),
     .idata0_in1_jtag_out(net817),
     .async_dat_in1_jtag_out(out7_to_tstmx1),
     .prev_io_shift_en(csr_actreden[7]), .jtag_clkdr_outn(net0771),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0366), .oclk_out(net0355), .oclkb_out(net0356),
     .odat0_out(net0357), .odat1_out(net0358),
     .odat_async_out(net0690), .pd_data_out(net0359),
     .async_dat_in0(io_out[7]), .async_dat_in1(out5_to_out7),
     .iclkin_dist_in0(vssl_aibcr3aux), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(vssl_aibcr3aux), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(vssl_aibcr3aux), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(csr_asyn_dataselb),
     .idataselb_in1(csr_asyn_dataselb), .iddren_in0(vssl_aibcr3aux),
     .iddren_in1(vssl_aibcr3aux), .ilaunch_clk_in0(vssl_aibcr3aux),
     .ilaunch_clk_in1(vssl_aibcr3aux), .ilpbk_dat_in0(vssl_aibcr3aux),
     .ilpbk_dat_in1(vssl_aibcr3aux), .ilpbk_en_in0(vssl_aibcr3aux),
     .ilpbk_en_in1(vssl_aibcr3aux), .indrv_in0(csr_asyn_ndrv_int[1:0]),
     .indrv_in1(csr_asyn_ndrv_int[1:0]),
     .ipdrv_in0(csr_asyn_pdrv_int[1:0]),
     .ipdrv_in1(csr_asyn_pdrv_int[1:0]), .irxen_in0({vssl_aibcr3aux,
     vcc_aibcr3aux, vssl_aibcr3aux}), .irxen_in1({vssl_aibcr3aux,
     vcc_aibcr3aux, vssl_aibcr3aux}), .istrbclk_in0(vssl_aibcr3aux),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(csr_asyn_txen_int),
     .itxen_in1(csr_asyn_txen_int), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0365), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(csr_actreden[8]),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0709), .odat1_aib(net0364),
     .jtag_rx_scan_out(jtag_rx_scan_in_10x6), .odat0_aib(net0363),
     .oclk_aib(net0361), .last_bs_out(last_bs_in_10x6),
     .oclkb_aib(net0362), .jtag_clkdr_in(jtag_clkdr1r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_09x6),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_09x6), .iopad(iopad_io_out[7]),
     .oclkn(net0360), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xio_oe1 ( .idata1_in1_jtag_out(net0832),
     .idata0_in1_jtag_out(net0863),
     .async_dat_in1_jtag_out(out6_to_tstmx0),
     .prev_io_shift_en(csr_actreden[7]), .jtag_clkdr_outn(net0788),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0378), .oclk_out(net0367), .oclkb_out(net0368),
     .odat0_out(net0369), .odat1_out(net0370),
     .odat_async_out(net0684), .pd_data_out(net0371),
     .async_dat_in0(io_out[6]), .async_dat_in1(out4_to_out6),
     .iclkin_dist_in0(vssl_aibcr3aux), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(vssl_aibcr3aux), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(vssl_aibcr3aux), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(csr_asyn_dataselb),
     .idataselb_in1(csr_asyn_dataselb), .iddren_in0(vssl_aibcr3aux),
     .iddren_in1(vssl_aibcr3aux), .ilaunch_clk_in0(vssl_aibcr3aux),
     .ilaunch_clk_in1(vssl_aibcr3aux), .ilpbk_dat_in0(vssl_aibcr3aux),
     .ilpbk_dat_in1(vssl_aibcr3aux), .ilpbk_en_in0(vssl_aibcr3aux),
     .ilpbk_en_in1(vssl_aibcr3aux), .indrv_in0(csr_asyn_ndrv_int[1:0]),
     .indrv_in1(csr_asyn_ndrv_int[1:0]),
     .ipdrv_in0(csr_asyn_pdrv_int[1:0]),
     .ipdrv_in1(csr_asyn_pdrv_int[1:0]), .irxen_in0({vssl_aibcr3aux,
     vcc_aibcr3aux, vssl_aibcr3aux}), .irxen_in1({vssl_aibcr3aux,
     vcc_aibcr3aux, vssl_aibcr3aux}), .istrbclk_in0(vssl_aibcr3aux),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(csr_asyn_txen_int),
     .itxen_in1(csr_asyn_txen_int), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0377), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(csr_actreden[8]),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0734), .odat1_aib(net0376),
     .jtag_rx_scan_out(jtag_rx_scan_in_10x5), .odat0_aib(net0375),
     .oclk_aib(net0373), .last_bs_out(last_bs_in_10x5),
     .oclkb_aib(net0374), .jtag_clkdr_in(jtag_clkdr2r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_09x5),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_09x5), .iopad(iopad_io_out[6]),
     .oclkn(net0372), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xtstmx0 ( .idata1_in1_jtag_out(net0861),
     .idata0_in1_jtag_out(net0855),
     .async_dat_in1_jtag_out(tstmx1_to_txtmx3),
     .prev_io_shift_en(csr_actreden[8]), .jtag_clkdr_outn(net0784),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0223), .oclk_out(net0488), .oclkb_out(net0489),
     .odat0_out(net0474), .odat1_out(net0215),
     .odat_async_out(net0737), .pd_data_out(net0216),
     .async_dat_in0(tstmx[1]), .async_dat_in1(out7_to_tstmx1),
     .iclkin_dist_in0(vssl_aibcr3aux), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(vssl_aibcr3aux), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(vssl_aibcr3aux), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(csr_asyn_dataselb),
     .idataselb_in1(csr_asyn_dataselb), .iddren_in0(vssl_aibcr3aux),
     .iddren_in1(vssl_aibcr3aux), .ilaunch_clk_in0(vssl_aibcr3aux),
     .ilaunch_clk_in1(vssl_aibcr3aux), .ilpbk_dat_in0(vssl_aibcr3aux),
     .ilpbk_dat_in1(vssl_aibcr3aux), .ilpbk_en_in0(vssl_aibcr3aux),
     .ilpbk_en_in1(vssl_aibcr3aux), .indrv_in0(csr_asyn_ndrv_int[1:0]),
     .indrv_in1(csr_asyn_ndrv_int[1:0]),
     .ipdrv_in0(csr_asyn_pdrv_int[1:0]),
     .ipdrv_in1(csr_asyn_pdrv_int[1:0]), .irxen_in0({vssl_aibcr3aux,
     vcc_aibcr3aux, vssl_aibcr3aux}), .irxen_in1({vssl_aibcr3aux,
     vcc_aibcr3aux, vssl_aibcr3aux}), .istrbclk_in0(vssl_aibcr3aux),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(csr_asyn_txen_int),
     .itxen_in1(csr_asyn_txen_int), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0222), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(csr_actreden[9]),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0759), .odat1_aib(net0221),
     .jtag_rx_scan_out(jtag_rx_scan_in_11x6), .odat0_aib(net0220),
     .oclk_aib(net0218), .last_bs_out(last_bs_in_11x6),
     .oclkb_aib(net0219), .jtag_clkdr_in(jtag_clkdr1r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_10x6),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_10x6), .iopad(iopad_tstmx[1]),
     .oclkn(net0217), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xtstmx1 ( .idata1_in1_jtag_out(net0833),
     .idata0_in1_jtag_out(net0814),
     .async_dat_in1_jtag_out(tstmx0_to_tstmx2),
     .prev_io_shift_en(csr_actreden[8]), .jtag_clkdr_outn(net0735),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0235), .oclk_out(net0224), .oclkb_out(net0225),
     .odat0_out(net0226), .odat1_out(net0227),
     .odat_async_out(net0752), .pd_data_out(net0228),
     .async_dat_in0(tstmx[0]), .async_dat_in1(out6_to_tstmx0),
     .iclkin_dist_in0(vssl_aibcr3aux), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(vssl_aibcr3aux), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(vssl_aibcr3aux), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(csr_asyn_dataselb),
     .idataselb_in1(csr_asyn_dataselb), .iddren_in0(vssl_aibcr3aux),
     .iddren_in1(vssl_aibcr3aux), .ilaunch_clk_in0(vssl_aibcr3aux),
     .ilaunch_clk_in1(vssl_aibcr3aux), .ilpbk_dat_in0(vssl_aibcr3aux),
     .ilpbk_dat_in1(vssl_aibcr3aux), .ilpbk_en_in0(vssl_aibcr3aux),
     .ilpbk_en_in1(vssl_aibcr3aux), .indrv_in0(csr_asyn_ndrv_int[1:0]),
     .indrv_in1(csr_asyn_ndrv_int[1:0]),
     .ipdrv_in0(csr_asyn_pdrv_int[1:0]),
     .ipdrv_in1(csr_asyn_pdrv_int[1:0]), .irxen_in0({vssl_aibcr3aux,
     vcc_aibcr3aux, vssl_aibcr3aux}), .irxen_in1({vssl_aibcr3aux,
     vcc_aibcr3aux, vssl_aibcr3aux}), .istrbclk_in0(vssl_aibcr3aux),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(csr_asyn_txen_int),
     .itxen_in1(csr_asyn_txen_int), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0234), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(csr_actreden[9]),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0776), .odat1_aib(net0233),
     .jtag_rx_scan_out(jtag_rx_scan_in_11x5), .odat0_aib(net0487),
     .oclk_aib(net0485), .last_bs_out(last_bs_in_11x5),
     .oclkb_aib(net0231), .jtag_clkdr_in(jtag_clkdr2r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_10x5),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_10x5), .iopad(iopad_tstmx[0]),
     .oclkn(net0229), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xtstmx6 ( .idata1_in1_jtag_out(net0756),
     .idata0_in1_jtag_out(net0836),
     .async_dat_in1_jtag_out(tstmx7_to_auxactred2),
     .prev_io_shift_en(csr_actreden[11]), .jtag_clkdr_outn(net0685),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0247), .oclk_out(net0236), .oclkb_out(net0237),
     .odat0_out(net0238), .odat1_out(net0239),
     .odat_async_out(net0676), .pd_data_out(net0240),
     .async_dat_in0(tstmx[7]), .async_dat_in1(tstmx5_to_tstmx7),
     .iclkin_dist_in0(vssl_aibcr3aux), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(vssl_aibcr3aux), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(vssl_aibcr3aux), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(csr_asyn_dataselb),
     .idataselb_in1(csr_asyn_dataselb), .iddren_in0(vssl_aibcr3aux),
     .iddren_in1(vssl_aibcr3aux), .ilaunch_clk_in0(vssl_aibcr3aux),
     .ilaunch_clk_in1(vssl_aibcr3aux), .ilpbk_dat_in0(vssl_aibcr3aux),
     .ilpbk_dat_in1(vssl_aibcr3aux), .ilpbk_en_in0(vssl_aibcr3aux),
     .ilpbk_en_in1(vssl_aibcr3aux), .indrv_in0(csr_asyn_ndrv_int[1:0]),
     .indrv_in1(csr_asyn_ndrv_int[1:0]),
     .ipdrv_in0(csr_asyn_pdrv_int[1:0]),
     .ipdrv_in1(csr_asyn_pdrv_int[1:0]), .irxen_in0({vssl_aibcr3aux,
     vcc_aibcr3aux, vssl_aibcr3aux}), .irxen_in1({vssl_aibcr3aux,
     vcc_aibcr3aux, vssl_aibcr3aux}), .istrbclk_in0(vssl_aibcr3aux),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(csr_asyn_txen_int),
     .itxen_in1(csr_asyn_txen_int), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0246), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(csr_actreden[12]),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0746), .odat1_aib(net0245),
     .jtag_rx_scan_out(jtag_rx_scan_in_11x8), .odat0_aib(net0244),
     .oclk_aib(net0242), .last_bs_out(last_bs_in_11x8),
     .oclkb_aib(net0243), .jtag_clkdr_in(jtag_clkdr_int_buf),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_12x8),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_12x8), .iopad(iopad_tstmx[7]),
     .oclkn(net0241), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xtstmx7 ( .idata1_in1_jtag_out(net0880),
     .idata0_in1_jtag_out(net0876),
     .async_dat_in1_jtag_out(tstmx6_to_auxactred1),
     .prev_io_shift_en(csr_actreden[11]), .jtag_clkdr_outn(net0769),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0259), .oclk_out(net0248), .oclkb_out(net0249),
     .odat0_out(net0250), .odat1_out(net0251),
     .odat_async_out(net0747), .pd_data_out(net0252),
     .async_dat_in0(tstmx[6]), .async_dat_in1(tstmx4_to_tstmx6),
     .iclkin_dist_in0(vssl_aibcr3aux), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(vssl_aibcr3aux), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(vssl_aibcr3aux), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(csr_asyn_dataselb),
     .idataselb_in1(csr_asyn_dataselb), .iddren_in0(vssl_aibcr3aux),
     .iddren_in1(vssl_aibcr3aux), .ilaunch_clk_in0(vssl_aibcr3aux),
     .ilaunch_clk_in1(vssl_aibcr3aux), .ilpbk_dat_in0(vssl_aibcr3aux),
     .ilpbk_dat_in1(vssl_aibcr3aux), .ilpbk_en_in0(vssl_aibcr3aux),
     .ilpbk_en_in1(vssl_aibcr3aux), .indrv_in0(csr_asyn_ndrv_int[1:0]),
     .indrv_in1(csr_asyn_ndrv_int[1:0]),
     .ipdrv_in0(csr_asyn_pdrv_int[1:0]),
     .ipdrv_in1(csr_asyn_pdrv_int[1:0]), .irxen_in0({vssl_aibcr3aux,
     vcc_aibcr3aux, vssl_aibcr3aux}), .irxen_in1({vssl_aibcr3aux,
     vcc_aibcr3aux, vssl_aibcr3aux}), .istrbclk_in0(vssl_aibcr3aux),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(csr_asyn_txen_int),
     .itxen_in1(csr_asyn_txen_int), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0258), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(csr_actreden[12]),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0770), .odat1_aib(net0257),
     .jtag_rx_scan_out(jtag_rx_scan_in_11x7), .odat0_aib(net0256),
     .oclk_aib(net0254), .last_bs_out(last_bs_in_11x7),
     .oclkb_aib(net0255), .jtag_clkdr_in(jtag_clkdr_int_buf),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_12x7),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_12x7), .iopad(iopad_tstmx[6]),
     .oclkn(net0253), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xio_in6 ( .idata1_in1_jtag_out(net813),
     .idata0_in1_jtag_out(net814),
     .async_dat_in1_jtag_out(out5_to_out7),
     .prev_io_shift_en(csr_actreden[6]), .jtag_clkdr_outn(net0766),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0271), .oclk_out(net0260), .oclkb_out(net0261),
     .odat0_out(net0262), .odat1_out(net0263),
     .odat_async_out(net0758), .pd_data_out(net0264),
     .async_dat_in0(io_out[5]), .async_dat_in1(out3_to_out5),
     .iclkin_dist_in0(vssl_aibcr3aux), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(vssl_aibcr3aux), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(vssl_aibcr3aux), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(csr_asyn_dataselb),
     .idataselb_in1(csr_asyn_dataselb), .iddren_in0(vssl_aibcr3aux),
     .iddren_in1(vssl_aibcr3aux), .ilaunch_clk_in0(vssl_aibcr3aux),
     .ilaunch_clk_in1(vssl_aibcr3aux), .ilpbk_dat_in0(vssl_aibcr3aux),
     .ilpbk_dat_in1(vssl_aibcr3aux), .ilpbk_en_in0(vssl_aibcr3aux),
     .ilpbk_en_in1(vssl_aibcr3aux), .indrv_in0(csr_asyn_ndrv_int[1:0]),
     .indrv_in1(csr_asyn_ndrv_int[1:0]),
     .ipdrv_in0(csr_asyn_pdrv_int[1:0]),
     .ipdrv_in1(csr_asyn_pdrv_int[1:0]), .irxen_in0({vssl_aibcr3aux,
     vcc_aibcr3aux, vssl_aibcr3aux}), .irxen_in1({vssl_aibcr3aux,
     vcc_aibcr3aux, vssl_aibcr3aux}), .istrbclk_in0(vssl_aibcr3aux),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(csr_asyn_txen_int),
     .itxen_in1(csr_asyn_txen_int), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0270), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(csr_actreden[7]),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0724), .odat1_aib(net0269),
     .jtag_rx_scan_out(jtag_rx_scan_in_09x6), .odat0_aib(net0268),
     .oclk_aib(net0266), .last_bs_out(last_bs_in_09x6),
     .oclkb_aib(net0267), .jtag_clkdr_in(jtag_clkdr1r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_08x6),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_08x6), .iopad(iopad_io_out[5]),
     .oclkn(net0265), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xio_in7 ( .idata1_in1_jtag_out(net0870),
     .idata0_in1_jtag_out(net0902),
     .async_dat_in1_jtag_out(out4_to_out6),
     .prev_io_shift_en(csr_actreden[6]), .jtag_clkdr_outn(net0785),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0283), .oclk_out(net0272), .oclkb_out(net0273),
     .odat0_out(net0274), .odat1_out(net0275),
     .odat_async_out(net0742), .pd_data_out(net0276),
     .async_dat_in0(io_out[4]), .async_dat_in1(out2_to_out4),
     .iclkin_dist_in0(vssl_aibcr3aux), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(vssl_aibcr3aux), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(vssl_aibcr3aux), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(csr_asyn_dataselb),
     .idataselb_in1(csr_asyn_dataselb), .iddren_in0(vssl_aibcr3aux),
     .iddren_in1(vssl_aibcr3aux), .ilaunch_clk_in0(vssl_aibcr3aux),
     .ilaunch_clk_in1(vssl_aibcr3aux), .ilpbk_dat_in0(vssl_aibcr3aux),
     .ilpbk_dat_in1(vssl_aibcr3aux), .ilpbk_en_in0(vssl_aibcr3aux),
     .ilpbk_en_in1(vssl_aibcr3aux), .indrv_in0(csr_asyn_ndrv_int[1:0]),
     .indrv_in1(csr_asyn_ndrv_int[1:0]),
     .ipdrv_in0(csr_asyn_pdrv_int[1:0]),
     .ipdrv_in1(csr_asyn_pdrv_int[1:0]), .irxen_in0({vssl_aibcr3aux,
     vcc_aibcr3aux, vssl_aibcr3aux}), .irxen_in1({vssl_aibcr3aux,
     vcc_aibcr3aux, vssl_aibcr3aux}), .istrbclk_in0(vssl_aibcr3aux),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(csr_asyn_txen_int),
     .itxen_in1(csr_asyn_txen_int), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0282), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(csr_actreden[7]),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0688), .odat1_aib(net0281),
     .jtag_rx_scan_out(jtag_rx_scan_in_09x5), .odat0_aib(net0280),
     .oclk_aib(net0278), .last_bs_out(last_bs_in_09x5),
     .oclkb_aib(net0279), .jtag_clkdr_in(jtag_clkdr2r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_08x5),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_08x5), .iopad(iopad_io_out[4]),
     .oclkn(net0277), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xio_in4 ( .idata1_in1_jtag_out(net809),
     .idata0_in1_jtag_out(net810),
     .async_dat_in1_jtag_out(out3_to_out5),
     .prev_io_shift_en(csr_actreden[5]), .jtag_clkdr_outn(net0760),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0295), .oclk_out(net0284), .oclkb_out(net0285),
     .odat0_out(net0286), .odat1_out(net0287),
     .odat_async_out(net0744), .pd_data_out(net0288),
     .async_dat_in0(io_out[3]), .async_dat_in1(out1_to_out3),
     .iclkin_dist_in0(vssl_aibcr3aux), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(vssl_aibcr3aux), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(vssl_aibcr3aux), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(csr_asyn_dataselb),
     .idataselb_in1(csr_asyn_dataselb), .iddren_in0(vssl_aibcr3aux),
     .iddren_in1(vssl_aibcr3aux), .ilaunch_clk_in0(vssl_aibcr3aux),
     .ilaunch_clk_in1(vssl_aibcr3aux), .ilpbk_dat_in0(vssl_aibcr3aux),
     .ilpbk_dat_in1(vssl_aibcr3aux), .ilpbk_en_in0(vssl_aibcr3aux),
     .ilpbk_en_in1(vssl_aibcr3aux), .indrv_in0(csr_asyn_ndrv_int[1:0]),
     .indrv_in1(csr_asyn_ndrv_int[1:0]),
     .ipdrv_in0(csr_asyn_pdrv_int[1:0]),
     .ipdrv_in1(csr_asyn_pdrv_int[1:0]), .irxen_in0({vssl_aibcr3aux,
     vcc_aibcr3aux, vssl_aibcr3aux}), .irxen_in1({vssl_aibcr3aux,
     vcc_aibcr3aux, vssl_aibcr3aux}), .istrbclk_in0(vssl_aibcr3aux),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(csr_asyn_txen_int),
     .itxen_in1(csr_asyn_txen_int), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0294), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(csr_actreden[6]),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0781), .odat1_aib(net0293),
     .jtag_rx_scan_out(jtag_rx_scan_in_08x6), .odat0_aib(net0292),
     .oclk_aib(net0290), .last_bs_out(last_bs_in_08x6),
     .oclkb_aib(net0291), .jtag_clkdr_in(jtag_clkdr1r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_07x6),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_07x6), .iopad(iopad_io_out[3]),
     .oclkn(net0289), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xio_in5 ( .idata1_in1_jtag_out(net0736),
     .idata0_in1_jtag_out(net0828),
     .async_dat_in1_jtag_out(out2_to_out4),
     .prev_io_shift_en(csr_actreden[5]), .jtag_clkdr_outn(net0730),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0469), .oclk_out(net0296), .oclkb_out(net0297),
     .odat0_out(net0298), .odat1_out(net0299),
     .odat_async_out(net0761), .pd_data_out(net0479),
     .async_dat_in0(io_out[2]), .async_dat_in1(out0_to_out2),
     .iclkin_dist_in0(vssl_aibcr3aux), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(vssl_aibcr3aux), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(vssl_aibcr3aux), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(csr_asyn_dataselb),
     .idataselb_in1(csr_asyn_dataselb), .iddren_in0(vssl_aibcr3aux),
     .iddren_in1(vssl_aibcr3aux), .ilaunch_clk_in0(vssl_aibcr3aux),
     .ilaunch_clk_in1(vssl_aibcr3aux), .ilpbk_dat_in0(vssl_aibcr3aux),
     .ilpbk_dat_in1(vssl_aibcr3aux), .ilpbk_en_in0(vssl_aibcr3aux),
     .ilpbk_en_in1(vssl_aibcr3aux), .indrv_in0(csr_asyn_ndrv_int[1:0]),
     .indrv_in1(csr_asyn_ndrv_int[1:0]),
     .ipdrv_in0(csr_asyn_pdrv_int[1:0]),
     .ipdrv_in1(csr_asyn_pdrv_int[1:0]), .irxen_in0({vssl_aibcr3aux,
     vcc_aibcr3aux, vssl_aibcr3aux}), .irxen_in1({vssl_aibcr3aux,
     vcc_aibcr3aux, vssl_aibcr3aux}), .istrbclk_in0(vssl_aibcr3aux),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(csr_asyn_txen_int),
     .itxen_in1(csr_asyn_txen_int), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0475), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(csr_actreden[6]),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0763), .odat1_aib(net0305),
     .jtag_rx_scan_out(jtag_rx_scan_in_08x5), .odat0_aib(net0480),
     .oclk_aib(net0477), .last_bs_out(last_bs_in_08x5),
     .oclkb_aib(net0303), .jtag_clkdr_in(jtag_clkdr2r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_07x5),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_07x5), .iopad(iopad_io_out[2]),
     .oclkn(net0481), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xio_in2 ( .idata1_in1_jtag_out(net0909),
     .idata0_in1_jtag_out(net0837),
     .async_dat_in1_jtag_out(out1_to_out3),
     .prev_io_shift_en(csr_actreden[4]), .jtag_clkdr_outn(net0732),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0319), .oclk_out(net0482), .oclkb_out(net0309),
     .odat0_out(net0473), .odat1_out(net0311),
     .odat_async_out(net0767), .pd_data_out(net0312),
     .async_dat_in0(io_out[1]), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(vssl_aibcr3aux), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(vssl_aibcr3aux), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(vssl_aibcr3aux), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(csr_asyn_dataselb), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(vssl_aibcr3aux), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(vssl_aibcr3aux), .ilaunch_clk_in1(vssl_aibcr3aux),
     .ilpbk_dat_in0(vssl_aibcr3aux), .ilpbk_dat_in1(vssl_aibcr3aux),
     .ilpbk_en_in0(vssl_aibcr3aux), .ilpbk_en_in1(vssl_aibcr3aux),
     .indrv_in0(csr_asyn_ndrv_int[1:0]), .indrv_in1({vssl_aibcr3aux,
     vssl_aibcr3aux}), .ipdrv_in0(csr_asyn_pdrv_int[1:0]),
     .ipdrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .irxen_in0({vssl_aibcr3aux, vcc_aibcr3aux, vssl_aibcr3aux}),
     .irxen_in1(csr_asyn_rxen_int[2:0]), .istrbclk_in0(vssl_aibcr3aux),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(csr_asyn_txen_int),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(io_out1_to_oe1), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(csr_actreden[5]),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0749), .odat1_aib(net0472),
     .jtag_rx_scan_out(jtag_rx_scan_in_07x6), .odat0_aib(net0483),
     .oclk_aib(net0314), .last_bs_out(last_bs_in_07x6),
     .oclkb_aib(net0471), .jtag_clkdr_in(jtag_clkdr1l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_06x6),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_06x6), .iopad(iopad_io_out[1]),
     .oclkn(net0478), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xio_in3 ( .idata1_in1_jtag_out(net0858),
     .idata0_in1_jtag_out(net0741),
     .async_dat_in1_jtag_out(out0_to_out2),
     .prev_io_shift_en(csr_actreden[4]), .jtag_clkdr_outn(net0716),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0331), .oclk_out(net0320), .oclkb_out(net0321),
     .odat0_out(net0322), .odat1_out(net0323),
     .odat_async_out(net0703), .pd_data_out(net0324),
     .async_dat_in0(io_out[0]), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(vssl_aibcr3aux), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(vssl_aibcr3aux), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(vssl_aibcr3aux), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(csr_asyn_dataselb), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(vssl_aibcr3aux), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(vssl_aibcr3aux), .ilaunch_clk_in1(vssl_aibcr3aux),
     .ilpbk_dat_in0(vssl_aibcr3aux), .ilpbk_dat_in1(vssl_aibcr3aux),
     .ilpbk_en_in0(vssl_aibcr3aux), .ilpbk_en_in1(vssl_aibcr3aux),
     .indrv_in0(csr_asyn_ndrv_int[1:0]), .indrv_in1({vssl_aibcr3aux,
     vssl_aibcr3aux}), .ipdrv_in0(csr_asyn_pdrv_int[1:0]),
     .ipdrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .irxen_in0({vssl_aibcr3aux, vcc_aibcr3aux, vssl_aibcr3aux}),
     .irxen_in1(csr_asyn_rxen_int[2:0]), .istrbclk_in0(vssl_aibcr3aux),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(csr_asyn_txen_int),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(io_out0_to_oe0), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(csr_actreden[5]),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0711), .odat1_aib(net0329),
     .jtag_rx_scan_out(jtag_rx_scan_in_07x5), .odat0_aib(net0328),
     .oclk_aib(net0326), .last_bs_out(last_bs_in_07x5),
     .oclkb_aib(net0327), .jtag_clkdr_in(jtag_clkdr2l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_06x5),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_06x5), .iopad(iopad_io_out[0]),
     .oclkn(net0325), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xio_in1 ( .idata1_in1_jtag_out(net0815),
     .idata0_in1_jtag_out(net0890), .async_dat_in1_jtag_out(net0862),
     .prev_io_shift_en(csr_actreden[3]), .jtag_clkdr_outn(net0648),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0232), .oclk_out(net077), .oclkb_out(net078),
     .odat0_out(net079), .odat1_out(net080), .odat_async_out(io_oe[0]),
     .pd_data_out(net081), .async_dat_in0(vssl_aibcr3aux),
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
     .irxen_in0(csr_asyn_rxen_int[2:0]),
     .irxen_in1(csr_asyn_rxen_int[2:0]), .istrbclk_in0(vssl_aibcr3aux),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(vssl_aibcr3aux),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(io_oe0_to_in6), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(io_out0_to_oe0), .shift_en(csr_actreden[4]),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0696), .odat1_aib(net086),
     .jtag_rx_scan_out(jtag_rx_scan_in_06x5), .odat0_aib(net085),
     .oclk_aib(net083), .last_bs_out(last_bs_in_06x5),
     .oclkb_aib(net084), .jtag_clkdr_in(jtag_clkdr2l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_05x5),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_05x5), .iopad(iopad_io_oe[0]),
     .oclkn(net082), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xio_in0 ( .idata1_in1_jtag_out(net0892),
     .idata0_in1_jtag_out(net0792), .async_dat_in1_jtag_out(net0873),
     .prev_io_shift_en(csr_actreden[3]), .jtag_clkdr_outn(net0772),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0317), .oclk_out(net0166), .oclkb_out(net0167),
     .odat0_out(net0214), .odat1_out(net0230),
     .odat_async_out(io_oe[1]), .pd_data_out(net0169),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(vssl_aibcr3aux), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(vssl_aibcr3aux), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(vssl_aibcr3aux), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(vssl_aibcr3aux), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(vssl_aibcr3aux), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(vssl_aibcr3aux), .ilaunch_clk_in1(vssl_aibcr3aux),
     .ilpbk_dat_in0(vssl_aibcr3aux), .ilpbk_dat_in1(vssl_aibcr3aux),
     .ilpbk_en_in0(vssl_aibcr3aux), .ilpbk_en_in1(vssl_aibcr3aux),
     .indrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .irxen_in0(csr_asyn_rxen_int[2:0]),
     .irxen_in1(csr_asyn_rxen_int[2:0]), .istrbclk_in0(vssl_aibcr3aux),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(vssl_aibcr3aux),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(io_oe1_to_in7), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(io_out1_to_oe1), .shift_en(csr_actreden[4]),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0745), .odat1_aib(net0304),
     .jtag_rx_scan_out(jtag_rx_scan_in_06x6), .odat0_aib(net0300),
     .oclk_aib(net0315), .last_bs_out(last_bs_in_06x6),
     .oclkb_aib(net0310), .jtag_clkdr_in(jtag_clkdr1l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_05x6),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_05x6), .iopad(iopad_io_oe[1]),
     .oclkn(net0170), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xio_out6 ( .idata1_in1_jtag_out(net0899),
     .idata0_in1_jtag_out(net0884), .async_dat_in1_jtag_out(net0821),
     .prev_io_shift_en(csr_actreden[2]), .jtag_clkdr_outn(net0678),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0308), .oclk_out(net0301), .oclkb_out(net0189),
     .odat0_out(net0190), .odat1_out(net0191),
     .odat_async_out(io_in[7]), .pd_data_out(net0307),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(vssl_aibcr3aux), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(vssl_aibcr3aux), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(vssl_aibcr3aux), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(vssl_aibcr3aux), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(vssl_aibcr3aux), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(vssl_aibcr3aux), .ilaunch_clk_in1(vssl_aibcr3aux),
     .ilpbk_dat_in0(vssl_aibcr3aux), .ilpbk_dat_in1(vssl_aibcr3aux),
     .ilpbk_en_in0(vssl_aibcr3aux), .ilpbk_en_in1(vssl_aibcr3aux),
     .indrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .irxen_in0(csr_asyn_rxen_int[2:0]),
     .irxen_in1(csr_asyn_rxen_int[2:0]), .istrbclk_in0(vssl_aibcr3aux),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(vssl_aibcr3aux),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(io_in7_to_in5), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(io_oe1_to_in7), .shift_en(csr_actreden[3]),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0733), .odat1_aib(net0198),
     .jtag_rx_scan_out(jtag_rx_scan_in_05x6), .odat0_aib(net0306),
     .oclk_aib(net0302), .last_bs_out(last_bs_in_05x6),
     .oclkb_aib(net0196), .jtag_clkdr_in(jtag_clkdr1l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_04x6),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_04x6), .iopad(iopad_io_in[7]),
     .oclkn(net0194), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xio_out7 ( .idata1_in1_jtag_out(net0912),
     .idata0_in1_jtag_out(net0905), .async_dat_in1_jtag_out(net0901),
     .prev_io_shift_en(csr_actreden[2]), .jtag_clkdr_outn(net0780),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0213), .oclk_out(net0201), .oclkb_out(net0202),
     .odat0_out(net0203), .odat1_out(net0204),
     .odat_async_out(io_in[6]), .pd_data_out(net0206),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(vssl_aibcr3aux), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(vssl_aibcr3aux), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(vssl_aibcr3aux), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(vssl_aibcr3aux), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(vssl_aibcr3aux), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(vssl_aibcr3aux), .ilaunch_clk_in1(vssl_aibcr3aux),
     .ilpbk_dat_in0(vssl_aibcr3aux), .ilpbk_dat_in1(vssl_aibcr3aux),
     .ilpbk_en_in0(vssl_aibcr3aux), .ilpbk_en_in1(vssl_aibcr3aux),
     .indrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .irxen_in0(csr_asyn_rxen_int[2:0]),
     .irxen_in1(csr_asyn_rxen_int[2:0]), .istrbclk_in0(vssl_aibcr3aux),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(vssl_aibcr3aux),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(io_in6_to_in4), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(io_oe0_to_in6), .shift_en(csr_actreden[3]),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0715), .odat1_aib(net0211),
     .jtag_rx_scan_out(jtag_rx_scan_in_05x5), .odat0_aib(net0210),
     .oclk_aib(net0208), .last_bs_out(last_bs_in_05x5),
     .oclkb_aib(net0209), .jtag_clkdr_in(jtag_clkdr2l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_04x5),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_04x5), .iopad(iopad_io_in[6]),
     .oclkn(net0207), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xio_out4 ( .idata1_in1_jtag_out(net0894),
     .idata0_in1_jtag_out(net0904), .async_dat_in1_jtag_out(net0868),
     .prev_io_shift_en(csr_actreden[1]), .jtag_clkdr_outn(net0783),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0101), .oclk_out(net088), .oclkb_out(net089),
     .odat0_out(net090), .odat1_out(net091), .odat_async_out(io_in[5]),
     .pd_data_out(net093), .async_dat_in0(vssl_aibcr3aux),
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
     .irxen_in0(csr_asyn_rxen_int[2:0]),
     .irxen_in1(csr_asyn_rxen_int[2:0]), .istrbclk_in0(vssl_aibcr3aux),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(vssl_aibcr3aux),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(io_in5_to_in3), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(io_in7_to_in5), .shift_en(csr_actreden[2]),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0786), .odat1_aib(net099),
     .jtag_rx_scan_out(jtag_rx_scan_in_04x6), .odat0_aib(net098),
     .oclk_aib(net096), .last_bs_out(last_bs_in_04x6),
     .oclkb_aib(net097), .jtag_clkdr_in(jtag_clkdr1l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_03x6),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_03x6), .iopad(iopad_io_in[5]),
     .oclkn(net095), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xio_out5 ( .idata1_in1_jtag_out(net0910),
     .idata0_in1_jtag_out(net0800), .async_dat_in1_jtag_out(net0802),
     .prev_io_shift_en(csr_actreden[1]), .jtag_clkdr_outn(net0740),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0188), .oclk_out(net094), .oclkb_out(net0102),
     .odat0_out(net0195), .odat1_out(net0185),
     .odat_async_out(io_in[4]), .pd_data_out(net0182),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(vssl_aibcr3aux), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(vssl_aibcr3aux), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(vssl_aibcr3aux), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(vssl_aibcr3aux), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(vssl_aibcr3aux), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(vssl_aibcr3aux), .ilaunch_clk_in1(vssl_aibcr3aux),
     .ilpbk_dat_in0(vssl_aibcr3aux), .ilpbk_dat_in1(vssl_aibcr3aux),
     .ilpbk_en_in0(vssl_aibcr3aux), .ilpbk_en_in1(vssl_aibcr3aux),
     .indrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .irxen_in0(csr_asyn_rxen_int[2:0]),
     .irxen_in1(csr_asyn_rxen_int[2:0]), .istrbclk_in0(vssl_aibcr3aux),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(vssl_aibcr3aux),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(io_in4_to_in2), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(io_in6_to_in4), .shift_en(csr_actreden[2]),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0791), .odat1_aib(net0197),
     .jtag_rx_scan_out(jtag_rx_scan_in_04x5), .odat0_aib(net0199),
     .oclk_aib(net0180), .last_bs_out(last_bs_in_04x5),
     .oclkb_aib(net0193), .jtag_clkdr_in(jtag_clkdr2l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_03x5),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_03x5), .iopad(iopad_io_in[4]),
     .oclkn(net0184), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xio_out2 ( .idata1_in1_jtag_out(net0859),
     .idata0_in1_jtag_out(net0898), .async_dat_in1_jtag_out(net0830),
     .prev_io_shift_en(csr_actreden[0]), .jtag_clkdr_outn(net0755),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0115), .oclk_out(net0103), .oclkb_out(net0104),
     .odat0_out(net0105), .odat1_out(net0106),
     .odat_async_out(io_in[3]), .pd_data_out(net0108),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(vssl_aibcr3aux), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(vssl_aibcr3aux), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(vssl_aibcr3aux), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(vssl_aibcr3aux), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(vssl_aibcr3aux), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(vssl_aibcr3aux), .ilaunch_clk_in1(vssl_aibcr3aux),
     .ilpbk_dat_in0(vssl_aibcr3aux), .ilpbk_dat_in1(vssl_aibcr3aux),
     .ilpbk_en_in0(vssl_aibcr3aux), .ilpbk_en_in1(vssl_aibcr3aux),
     .indrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .irxen_in0(csr_asyn_rxen_int[2:0]),
     .irxen_in1(csr_asyn_rxen_int[2:0]), .istrbclk_in0(vssl_aibcr3aux),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(vssl_aibcr3aux),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(io_in3_to_in1), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(io_in5_to_in3), .shift_en(csr_actreden[1]),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0778), .odat1_aib(net0113),
     .jtag_rx_scan_out(jtag_rx_scan_in_03x6), .odat0_aib(net0112),
     .oclk_aib(net0110), .last_bs_out(last_bs_in_03x6),
     .oclkb_aib(net0111), .jtag_clkdr_in(jtag_clkdr1l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_02x6),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_02x6), .iopad(iopad_io_in[3]),
     .oclkn(net0109), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xio_out3 ( .idata1_in1_jtag_out(net0839),
     .idata0_in1_jtag_out(net0891), .async_dat_in1_jtag_out(net0887),
     .prev_io_shift_en(csr_actreden[0]), .jtag_clkdr_outn(net0787),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0176), .oclk_out(net0116), .oclkb_out(net0117),
     .odat0_out(net0172), .odat1_out(net0177),
     .odat_async_out(io_in[2]), .pd_data_out(net0119),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(vssl_aibcr3aux), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(vssl_aibcr3aux), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(vssl_aibcr3aux), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(vssl_aibcr3aux), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(vssl_aibcr3aux), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(vssl_aibcr3aux), .ilaunch_clk_in1(vssl_aibcr3aux),
     .ilpbk_dat_in0(vssl_aibcr3aux), .ilpbk_dat_in1(vssl_aibcr3aux),
     .ilpbk_en_in0(vssl_aibcr3aux), .ilpbk_en_in1(vssl_aibcr3aux),
     .indrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .irxen_in0(csr_asyn_rxen_int[2:0]),
     .irxen_in1(csr_asyn_rxen_int[2:0]), .istrbclk_in0(vssl_aibcr3aux),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(vssl_aibcr3aux),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(io_in2_to_in0), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(io_in4_to_in2), .shift_en(csr_actreden[1]),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0765), .odat1_aib(net0171),
     .jtag_rx_scan_out(jtag_rx_scan_in_03x5), .odat0_aib(net0123),
     .oclk_aib(net0121), .last_bs_out(last_bs_in_03x5),
     .oclkb_aib(net0122), .jtag_clkdr_in(jtag_clkdr2l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_02x5),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_02x5), .iopad(iopad_io_in[2]),
     .oclkn(net0120), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xio_out0 ( .idata1_in1_jtag_out(net0854),
     .idata0_in1_jtag_out(net0866), .async_dat_in1_jtag_out(net0908),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net0722),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0130), .oclk_out(net0442), .oclkb_out(net0416),
     .odat0_out(net028), .odat1_out(net029), .odat_async_out(io_in[1]),
     .pd_data_out(net0402), .async_dat_in0(vssl_aibcr3aux),
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
     .irxen_in0(csr_asyn_rxen_int[2:0]), .irxen_in1({vssl_aibcr3aux,
     vcc_aibcr3aux, vssl_aibcr3aux}), .istrbclk_in0(vssl_aibcr3aux),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(vssl_aibcr3aux),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0129), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(io_in3_to_in1), .shift_en(csr_actreden[0]),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0790), .odat1_aib(net0128),
     .jtag_rx_scan_out(jtag_rx_scan_in_02x6), .odat0_aib(net0127),
     .oclk_aib(net0125), .last_bs_out(last_bs_in_02x6),
     .oclkb_aib(net0126), .jtag_clkdr_in(jtag_clkdr1l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_tx_scan_in_01x6),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_01x6), .iopad(iopad_io_in[1]),
     .oclkn(net0124), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xio_out1 ( .idata1_in1_jtag_out(net0907),
     .idata0_in1_jtag_out(net0819), .async_dat_in1_jtag_out(net0743),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net0712),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net051), .oclk_out(net041), .oclkb_out(net042),
     .odat0_out(net0174), .odat1_out(net0175),
     .odat_async_out(io_in[0]), .pd_data_out(net044),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(vssl_aibcr3aux), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(vssl_aibcr3aux), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(vssl_aibcr3aux), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(vssl_aibcr3aux), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(vssl_aibcr3aux), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(vssl_aibcr3aux), .ilaunch_clk_in1(vssl_aibcr3aux),
     .ilpbk_dat_in0(vssl_aibcr3aux), .ilpbk_dat_in1(vssl_aibcr3aux),
     .ilpbk_en_in0(vssl_aibcr3aux), .ilpbk_en_in1(vssl_aibcr3aux),
     .indrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .irxen_in0(csr_asyn_rxen_int[2:0]), .irxen_in1({vssl_aibcr3aux,
     vcc_aibcr3aux, vssl_aibcr3aux}), .istrbclk_in0(vssl_aibcr3aux),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(vssl_aibcr3aux),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net050), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(io_in2_to_in0), .shift_en(csr_actreden[0]),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0713), .odat1_aib(net049),
     .jtag_rx_scan_out(jtag_rx_scan_in_02x5), .odat0_aib(net048),
     .oclk_aib(net046), .last_bs_out(last_bs_in_02x5),
     .oclkb_aib(net047), .jtag_clkdr_in(jtag_clkdr2l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_tx_scan_in_01x5),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_01x5), .iopad(iopad_io_in[0]),
     .oclkn(net045), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));

endmodule
