// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3aux_lib, Cell - aibcr3aux_cnocup, View - schematic
// LAST TIME SAVED: Aug 21 17:03:12 2015
// NETLIST TIME: Aug 26 15:05:12 2015
// `timescale 1ns / 1ns 

module aibcr3aux_cnocup ( jtag_rx_scan_out_10x3, jtag_rx_scan_out_10x4,
     last_bs_in_12x4, last_bs_out_10x3, last_bs_out_10x4, iopad_cnup,
     iopad_cnup_clkn, iopad_cnup_clkp, anlg_rstb, cnup,
     csr_cnup_dataselb, csr_cnup_ddren, csr_cnup_ndrv, csr_cnup_pdrv,
     csr_cnup_txen, csr_dly_ovrd, csr_dly_ovrden, csr_iocsr_sel,
     dig_rstb, ib50u_ring, ib50uc, idata0_ckp_cnoc, idata1_ckp_cnoc,
     iosc_fuse_trim, itx_clktree_cnoc, jtag_clkdr3r, jtag_clkdr4r,
     jtag_clkdr5l, jtag_clkdr5r, jtag_clkdr6l, jtag_clkdr6r,
     jtag_clksel, jtag_intest, jtag_mode_in, jtag_rstb, jtag_rstb_en,
     jtag_tx_scan_in_02x1, jtag_tx_scan_in_02x2, jtag_tx_scanen_in,
     jtag_weakpdn, jtag_weakpu, last_bs_in_02x1, last_bs_in_02x2,
     por_vcchssi, por_vccl, vcc_aibcr3aux, vccl_aibcr3aux, vssl_aibcr3aux
     );

output  jtag_rx_scan_out_10x3, jtag_rx_scan_out_10x4, last_bs_in_12x4,
     last_bs_out_10x3, last_bs_out_10x4;

inout  iopad_cnup_clkn, iopad_cnup_clkp;

input  anlg_rstb, csr_cnup_dataselb, csr_cnup_ddren, csr_cnup_txen,
     csr_dly_ovrden, csr_iocsr_sel, dig_rstb, ib50u_ring, ib50uc,
     idata0_ckp_cnoc, idata1_ckp_cnoc, itx_clktree_cnoc, jtag_clkdr3r,
     jtag_clkdr4r, jtag_clkdr5l, jtag_clkdr5r, jtag_clkdr6l,
     jtag_clkdr6r, jtag_clksel, jtag_intest, jtag_mode_in, jtag_rstb,
     jtag_rstb_en, jtag_tx_scan_in_02x1, jtag_tx_scan_in_02x2,
     jtag_tx_scanen_in, jtag_weakpdn, jtag_weakpu, last_bs_in_02x1,
     last_bs_in_02x2, por_vcchssi, por_vccl, vcc_aibcr3aux,
     vccl_aibcr3aux, vssl_aibcr3aux;

inout [24:0]  iopad_cnup;

input [1:0]  csr_cnup_pdrv;

// Shao Yang Hack ww35.3
input [1:0]  csr_cnup_ndrv;

input [9:0]  iosc_fuse_trim;
input [3:0]  csr_dly_ovrd;
input [49:0]  cnup;
wire itxb_clktree_cnoc, itx_clktree_cnoc, csr_cnup_txen_int, csr_iocsr_sel, vcc_aibcr3aux, csr_cnup_txen, vssl_aibcr3aux;

// Buses in the design

wire  [1:0]  csr_cnup_pdrv_int;

wire  [3:0]  csr_dly_ovrd_int;

wire  [1:0]  csr_cnup_ndrv_int;

wire  [0:25]  tx_launch_clk;

wire net0754;
wire net0599;
wire net0576;
wire net0616;
wire net0964;
wire net0946;
wire net0546;
wire net0618;
wire net0550;
wire net0715;
wire net0575;
wire net0597;
wire net0595;
wire net0615;
wire jtag_rx_scan_in_10x4;
wire last_bs_in_10x4;
wire net0940;
wire net0610;
wire net089;
wire net0600;
wire net0619;
wire net0602;
wire net0551;
wire net0143;
wire net0578;
wire net0562;
wire net0577;
wire net0728;
wire net0606;
wire net0611;
wire net0620;
wire net0601;
wire jtag_rx_scan_in_10x3;
wire last_bs_in_10x3;
wire net0614;
wire net0748;
wire net0206;
wire net0196;
wire net0197;
wire net0957;
wire net0962;
wire net0198;
wire net0199;
wire net0205;
wire net0682;
wire net0204;
wire net0203;
wire net0201;
wire net0202;
wire jtag_rx_scan_in_11x4;
wire last_bs_in_11x4;
wire net0200;
wire net0753;
wire net0593;
wire net0207;
wire net0208;
wire net0954;
wire net0944;
wire net0209;
wire net0210;
wire net0582;
wire net0716;
wire net0570;
wire net0556;
wire net0592;
wire net0541;
wire jtag_rx_scan_in_11x3;
wire last_bs_in_11x3;
wire net0569;
wire net0740;
wire net0554;
wire net0543;
wire net0580;
wire net0598;
wire net0952;
wire net0566;
wire net0548;
wire net0259;
wire net0763;
wire net0258;
wire net0559;
wire net0553;
wire net0571;
wire jtag_rx_scan_in_12x4;
wire net0579;
wire net0739;
wire net0271;
wire net0581;
wire net0262;
wire net0604;
wire net0605;
wire net0263;
wire net0264;
wire net0585;
wire net0686;
wire net0552;
wire net0557;
wire net0266;
wire net0267;
wire jtag_rx_scan_in_12x3;
wire last_bs_in_12x3;
wire net0265;
wire net0767;
wire net0282;
wire net0560;
wire net0273;
wire net0387;
wire net0388;
wire net0587;
wire net0573;
wire net0281;
wire net0724;
wire net0280;
wire net0279;
wire net0277;
wire net0278;
wire jtag_rx_scan_in_12x2;
wire last_bs_in_12x2;
wire net0276;
wire net0750;
wire net0293;
wire net0283;
wire net0284;
wire net0359;
wire net0360;
wire net0285;
wire net0286;
wire net0586;
wire net0730;
wire net0291;
wire net0290;
wire net0565;
wire net0289;
wire jtag_rx_scan_in_12x1;
wire last_bs_in_12x1;
wire net0287;
wire net0761;
wire net0479;
wire net0480;
wire net0403;
wire net0444;
wire net0445;
wire net0448;
wire net0476;
wire net0466;
wire net0701;
wire net0469;
wire net0412;
wire net0475;
wire net0463;
wire jtag_rx_scan_in_11x2;
wire last_bs_in_11x2;
wire net0447;
wire net0727;
wire net0462;
wire net0457;
wire net0178;
wire net0926;
wire net0897;
wire net0453;
wire net0180;
wire net0467;
wire net0768;
wire net0470;
wire net0471;
wire net0464;
wire net0414;
wire jtag_rx_scan_in_11x1;
wire last_bs_in_11x1;
wire net0458;
wire net0756;
wire net0177;
wire net0167;
wire net0168;
wire net0473;
wire net0474;
wire net0169;
wire net0170;
wire net0176;
wire net0745;
wire net0175;
wire net0174;
wire net0172;
wire net0173;
wire jtag_rx_scan_in_10x1;
wire last_bs_in_10x1;
wire net0171;
wire net0681;
wire net0166;
wire net0156;
wire net0157;
wire net0502;
wire net0503;
wire net0158;
wire net0159;
wire net0165;
wire net0757;
wire net0164;
wire net0163;
wire net0161;
wire net0162;
wire jtag_rx_scan_in_10x2;
wire last_bs_in_10x2;
wire net0160;
wire net087;
wire net0429;
wire net0223;
wire net0434;
wire net0531;
wire net0532;
wire net0432;
wire net0226;
wire net0436;
wire net0735;
wire net0231;
wire net0417;
wire net0406;
wire net0407;
wire jtag_rx_scan_in_09x1;
wire last_bs_in_09x1;
wire net0430;
wire net088;
wire net0427;
wire net0212;
wire net0213;
wire net0984;
wire net0561;
wire net0424;
wire net0410;
wire net0221;
wire net0752;
wire net0415;
wire net0219;
wire net0439;
wire net0218;
wire jtag_rx_scan_in_09x2;
wire last_bs_in_09x2;
wire net0216;
wire net084;
wire net0422;
wire net0420;
wire net0235;
wire net0933;
wire net01036;
wire net0440;
wire net0428;
wire net0243;
wire net0676;
wire net0242;
wire net0241;
wire net0239;
wire net0240;
wire jtag_rx_scan_in_08x2;
wire last_bs_in_08x2;
wire net0431;
wire net083;
wire net0255;
wire net0245;
wire net0246;
wire net0589;
wire net0590;
wire net0426;
wire net0441;
wire net0254;
wire net0755;
wire net0253;
wire net0425;
wire net0250;
wire net0251;
wire jtag_rx_scan_in_08x1;
wire last_bs_in_08x1;
wire net0249;
wire net0722;
wire net0322;
wire net0818;
wire net0819;
wire net065;
wire net066;
wire net0288;
wire net0315;
wire net0320;
wire net0747;
wire net0309;
wire net0319;
wire net0292;
wire net0324;
wire jtag_rx_scan_in_07x2;
wire last_bs_in_07x2;
wire iopad_clkn_nocon;
wire net0302;
wire net0725;
wire net0149;
wire net0312;
wire net0140;
wire net0256;
wire net0433;
wire net0141;
wire net0142;
wire net0148;
wire net0690;
wire net0147;
wire net0146;
wire net0144;
wire net0145;
wire jtag_rx_scan_in_07x1;
wire last_bs_in_07x1;
wire net0947;
wire net076;
wire net0257;
wire net0272;
wire net0270;
wire net0678;
wire net0679;
wire net0247;
wire net0261;
wire net0275;
wire net0746;
wire net0274;
wire net0260;
wire net0248;
wire net0252;
wire jtag_rx_scan_in_06x2;
wire last_bs_in_06x2;
wire net0244;
wire net075;
wire net0139;
wire net0268;
wire net0269;
wire net0647;
wire net0648;
wire net0131;
wire net0132;
wire net0138;
wire net0751;
wire net0137;
wire net0136;
wire net0134;
wire net0135;
wire jtag_rx_scan_in_06x1;
wire last_bs_in_06x1;
wire net0133;
wire net071;
wire net0228;
wire net0229;
wire net0120;
wire net0707;
wire net0708;
wire net0121;
wire net0122;
wire net0220;
wire net0700;
wire net0237;
wire net0236;
wire net0214;
wire net0222;
wire jtag_rx_scan_in_05x1;
wire last_bs_in_05x1;
wire net0123;
wire net068;
wire net0181;
wire net0191;
wire net0190;
wire net0794;
wire net0795;
wire net0184;
wire net0195;
wire net0185;
wire net0705;
wire net0183;
wire jtag_rx_scan_in_05x2;
wire net0182;
wire net0193;
wire last_bs_in_05x2;
wire net0187;
wire jtag_rx_scan_in_04x2;
wire last_bs_in_04x2;
wire net0186;
wire net060;
wire net0130;
wire net0442;
wire net0416;
wire net0594;
wire net0535;
wire net0385;
wire net0402;
wire net0129;
wire net0764;
wire net0128;
wire jtag_rx_scan_in_03x2;
wire net0127;
wire net0125;
wire last_bs_in_03x2;
wire net0126;
wire net0124;
wire net059;
wire net051;
wire net041;
wire net042;
wire net0980;
wire net01064;
wire net043;
wire net044;
wire net050;
wire net0758;
wire net049;
wire jtag_rx_scan_in_03x1;
wire net048;
wire net046;
wire last_bs_in_03x1;
wire net047;
wire net045;
wire net072;
wire net0232;
wire net0215;
wire net0227;
wire net0736;
wire net0737;
wire net0211;
wire net0230;
wire net0238;
wire net0759;
wire net0233;
wire net0217;
wire net0224;
wire net0225;
wire net0234;
wire net067;
wire net0119;
wire net0192;
wire net0179;
wire net0765;
wire net0766;
wire net0194;
wire net0112;
wire net0118;
wire net0731;
wire net0117;
wire net0116;
wire net0114;
wire net0115;
wire jtag_rx_scan_in_04x1;
wire last_bs_in_04x1;
wire net0113;
wire net064;
wire net0100;
wire net090;
wire net091;
wire net0852;
wire net0853;
wire net092;
wire net093;
wire net099;
wire net0699;
wire net098;
wire net097;
wire net095;
wire net096;
wire net094;
wire net063;
wire net0111;
wire net0101;
wire net0102;
wire net0823;
wire net0824;
wire net0103;
wire net0104;
wire net0110;
wire net0712;
wire net0109;
wire net0108;
wire net0106;
wire net0107;
wire net0105;
wire clkout_r;
wire lvl0_out;
wire clkout_l;
wire net57;
wire clkb25;
wire net0341;
wire net0342;
wire net0343;
wire net0327;
wire net0326;
wire net0328;
wire net0339;
wire net0338;
wire net0340;
wire net0330;
wire net0331;
wire net0329;
wire net0336;
wire net0337;
wire net0335;
wire net0333;
wire net0332;
wire net0334;
wire net0380;
wire net0381;
wire net0382;
wire net0373;
wire net0372;
wire net0371;
wire net0874;
wire net0384;
wire net0383;
wire net0368;
wire net0369;
wire net0370;
wire net0367;
wire net0365;
wire net0362;
wire net0901;
wire net0896;
wire net0386;
wire net0366;
wire net0364;
wire net0363;
wire net0389;
wire net0390;
wire net0391;
wire net0394;
wire net0393;
wire net0392;
wire net0379;
wire net0377;
wire net0375;
wire net0395;
wire net0396;
wire net0397;
wire net0378;
wire net0376;
wire net0374;
wire net0398;
wire net0399;
wire net0400;
wire net0355;
wire net0354;
wire net0353;
wire net0356;
wire net0358;
wire net0361;
wire net0404;
wire net0405;
wire net0900;
wire net0857;
wire net0411;
wire net0893;
wire net0345;
wire net0347;
wire net0349;
wire net0904;
wire net0846;
wire net0401;
wire net0357;
wire net0885;
wire net0860;
wire net0409;
wire net0408;
wire net0884;
wire net0344;
wire net0346;
wire net0348;

// specify 
//     specparam CDS_LIBNAME  = "aibcr3aux_lib";
//     specparam CDS_CELLNAME = "aibcr3aux_cnocup";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

assign itxb_clktree_cnoc = ~vssl_aibcr3aux;
aibcr3aux_cnup_clktree xcnupclktree ( .clkinb(itxb_clktree_cnoc),
     .ib50u_ring(ib50u_ring), .ib50uc(ib50uc),
     .csr_dly_ovrden(csr_dly_ovrden),
     .csr_dly_ovrd(csr_dly_ovrd_int[3:0]),
     .iosc_fuse_trim(iosc_fuse_trim[9:0]),
     .vss_aibcr3aux(vssl_aibcr3aux), .vcc_aibcr3aux(vcc_aibcr3aux),
     .strbclk0(tx_launch_clk[0]), .strbclk1(tx_launch_clk[1]),
     .strbclk25(tx_launch_clk[25]), .strbclk24(tx_launch_clk[24]),
     .strbclk23(tx_launch_clk[23]), .strbclk22(tx_launch_clk[22]),
     .strbclk21(tx_launch_clk[21]), .strbclk20(tx_launch_clk[20]),
     .strbclk19(tx_launch_clk[19]), .strbclk18(tx_launch_clk[18]),
     .strbclk17(tx_launch_clk[17]), .strbclk16(tx_launch_clk[16]),
     .strbclk15(tx_launch_clk[15]), .strbclk14(tx_launch_clk[14]),
     .strbclk13(tx_launch_clk[13]), .strbclk12(tx_launch_clk[12]),
     .strbclk11(tx_launch_clk[11]), .strbclk10(tx_launch_clk[10]),
     .strbclk9(tx_launch_clk[9]), .strbclk8(tx_launch_clk[8]),
     .strbclk7(tx_launch_clk[7]), .strbclk6(tx_launch_clk[6]),
     .strbclk5(tx_launch_clk[5]), .strbclk4(tx_launch_clk[4]),
     .strbclk3(tx_launch_clk[3]), .strbclk2(tx_launch_clk[2]),
     .clkin(itx_clktree_cnoc));
aibcr3_buffx1_top  xup_sop_eop ( .idata1_in1_jtag_out(net0341),
     .idata0_in1_jtag_out(net0342), .async_dat_in1_jtag_out(net0343),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net0754),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0599), .oclk_out(net0576), .oclkb_out(net0616),
     .odat0_out(net0964), .odat1_out(net0946),
     .odat_async_out(net0546), .pd_data_out(net0618),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(net0754), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(vssl_aibcr3aux), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(vssl_aibcr3aux), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(csr_cnup_dataselb), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(csr_cnup_ddren), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(vssl_aibcr3aux), .ilaunch_clk_in1(vssl_aibcr3aux),
     .ilpbk_dat_in0(vssl_aibcr3aux), .ilpbk_dat_in1(vssl_aibcr3aux),
     .ilpbk_en_in0(vssl_aibcr3aux), .ilpbk_en_in1(vssl_aibcr3aux),
     .indrv_in0(csr_cnup_ndrv_int[1:0]), .indrv_in1({vssl_aibcr3aux,
     vssl_aibcr3aux}), .ipdrv_in0(csr_cnup_pdrv_int[1:0]),
     .ipdrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .irxen_in0({vssl_aibcr3aux, vcc_aibcr3aux, vssl_aibcr3aux}),
     .irxen_in1({vssl_aibcr3aux, vcc_aibcr3aux, vssl_aibcr3aux}),
     .istrbclk_in0(net0754), .istrbclk_in1(vssl_aibcr3aux),
     .itxen_in0(csr_cnup_txen_int), .itxen_in1(vssl_aibcr3aux),
     .oclk_in1(vssl_aibcr3aux), .odat_async_aib(net0550),
     .oclkb_in1(vssl_aibcr3aux), .odat0_in1(vssl_aibcr3aux),
     .odat1_in1(vssl_aibcr3aux), .odat_async_in1(vssl_aibcr3aux),
     .shift_en(vssl_aibcr3aux), .pd_data_in1(vssl_aibcr3aux),
     .dig_rstb(dig_rstb), .jtag_clkdr_out(net0715),
     .odat1_aib(net0575), .jtag_rx_scan_out(jtag_rx_scan_out_10x4),
     .odat0_aib(net0597), .oclk_aib(net0595),
     .last_bs_out(last_bs_out_10x4), .oclkb_aib(net0615),
     .jtag_clkdr_in(jtag_clkdr3r), .jtag_mode_in(jtag_mode_in),
     .jtag_rstb(jtag_rstb), .jtag_tx_scan_in(jtag_rx_scan_in_10x4),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_10x4), .iopad(net0940), .oclkn(net0610),
     .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xup_valid_intrup ( .idata1_in1_jtag_out(net0327),
     .idata0_in1_jtag_out(net0326), .async_dat_in1_jtag_out(net0328),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net089),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0600), .oclk_out(net0619), .oclkb_out(net0602),
     .odat0_out(net0551), .odat1_out(net0143),
     .odat_async_out(net0578), .pd_data_out(net0562),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(net089), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(cnup[48]), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(cnup[49]), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(csr_cnup_dataselb), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(csr_cnup_ddren), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(tx_launch_clk[24]),
     .ilaunch_clk_in1(vssl_aibcr3aux), .ilpbk_dat_in0(vssl_aibcr3aux),
     .ilpbk_dat_in1(vssl_aibcr3aux), .ilpbk_en_in0(vssl_aibcr3aux),
     .ilpbk_en_in1(vssl_aibcr3aux), .indrv_in0(csr_cnup_ndrv_int[1:0]),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0(csr_cnup_pdrv_int[1:0]), .ipdrv_in1({vssl_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in0({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in1({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .istrbclk_in0(net089),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(csr_cnup_txen_int),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0577), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(vssl_aibcr3aux),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0728), .odat1_aib(net0606),
     .jtag_rx_scan_out(jtag_rx_scan_out_10x3), .odat0_aib(net0611),
     .oclk_aib(net0620), .last_bs_out(last_bs_out_10x3),
     .oclkb_aib(net0601), .jtag_clkdr_in(jtag_clkdr4r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_10x3),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_10x3), .iopad(iopad_cnup[24]),
     .oclkn(net0614), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xupe_10_11 ( .idata1_in1_jtag_out(net0339),
     .idata0_in1_jtag_out(net0338), .async_dat_in1_jtag_out(net0340),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net0748),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0206), .oclk_out(net0196), .oclkb_out(net0197),
     .odat0_out(net0957), .odat1_out(net0962),
     .odat_async_out(net0198), .pd_data_out(net0199),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(net0748), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(cnup[46]), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(cnup[47]), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(csr_cnup_dataselb), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(csr_cnup_ddren), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(tx_launch_clk[22]),
     .ilaunch_clk_in1(vssl_aibcr3aux), .ilpbk_dat_in0(vssl_aibcr3aux),
     .ilpbk_dat_in1(vssl_aibcr3aux), .ilpbk_en_in0(vssl_aibcr3aux),
     .ilpbk_en_in1(vssl_aibcr3aux), .indrv_in0(csr_cnup_ndrv_int[1:0]),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0(csr_cnup_pdrv_int[1:0]), .ipdrv_in1({vssl_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in0({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in1({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .istrbclk_in0(net0748),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(csr_cnup_txen_int),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0205), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(vssl_aibcr3aux),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0682), .odat1_aib(net0204),
     .jtag_rx_scan_out(jtag_rx_scan_in_10x4), .odat0_aib(net0203),
     .oclk_aib(net0201), .last_bs_out(last_bs_in_10x4),
     .oclkb_aib(net0202), .jtag_clkdr_in(jtag_clkdr3r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_11x4),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_11x4), .iopad(iopad_cnup[23]),
     .oclkn(net0200), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xupe_12_13 ( .idata1_in1_jtag_out(net0330),
     .idata0_in1_jtag_out(net0331), .async_dat_in1_jtag_out(net0329),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net0753),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0593), .oclk_out(net0207), .oclkb_out(net0208),
     .odat0_out(net0954), .odat1_out(net0944),
     .odat_async_out(net0209), .pd_data_out(net0210),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(net0753), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(cnup[44]), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(cnup[45]), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(csr_cnup_dataselb), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(csr_cnup_ddren), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(tx_launch_clk[23]),
     .ilaunch_clk_in1(vssl_aibcr3aux), .ilpbk_dat_in0(vssl_aibcr3aux),
     .ilpbk_dat_in1(vssl_aibcr3aux), .ilpbk_en_in0(vssl_aibcr3aux),
     .ilpbk_en_in1(vssl_aibcr3aux), .indrv_in0(csr_cnup_ndrv_int[1:0]),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0(csr_cnup_pdrv_int[1:0]), .ipdrv_in1({vssl_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in0({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in1({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .istrbclk_in0(net0753),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(csr_cnup_txen_int),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0582), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(vssl_aibcr3aux),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0716), .odat1_aib(net0570),
     .jtag_rx_scan_out(jtag_rx_scan_in_10x3), .odat0_aib(net0556),
     .oclk_aib(net0592), .last_bs_out(last_bs_in_10x3),
     .oclkb_aib(net0541), .jtag_clkdr_in(jtag_clkdr4r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_11x3),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_11x3), .iopad(iopad_cnup[22]),
     .oclkn(net0569), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xupe_06_07 ( .idata1_in1_jtag_out(net0336),
     .idata0_in1_jtag_out(net0337), .async_dat_in1_jtag_out(net0335),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net0740),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0554), .oclk_out(net0543), .oclkb_out(net0580),
     .odat0_out(net0598), .odat1_out(net0952),
     .odat_async_out(net0566), .pd_data_out(net0548),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(net0740), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(cnup[42]), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(cnup[43]), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(csr_cnup_dataselb), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(csr_cnup_ddren), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(tx_launch_clk[20]),
     .ilaunch_clk_in1(vssl_aibcr3aux), .ilpbk_dat_in0(vssl_aibcr3aux),
     .ilpbk_dat_in1(vssl_aibcr3aux), .ilpbk_en_in0(vssl_aibcr3aux),
     .ilpbk_en_in1(vssl_aibcr3aux), .indrv_in0(csr_cnup_ndrv_int[1:0]),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0(csr_cnup_pdrv_int[1:0]), .ipdrv_in1({vssl_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in0({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in1({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .istrbclk_in0(net0740),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(csr_cnup_txen_int),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0259), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(vssl_aibcr3aux),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0763), .odat1_aib(net0258),
     .jtag_rx_scan_out(jtag_rx_scan_in_11x4), .odat0_aib(net0559),
     .oclk_aib(net0553), .last_bs_out(last_bs_in_11x4),
     .oclkb_aib(net0571), .jtag_clkdr_in(jtag_clkdr3r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_12x4),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl_aibcr3aux),
     .iopad(iopad_cnup[21]), .oclkn(net0579), .iclkn(vssl_aibcr3aux),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xupe_08_09 ( .idata1_in1_jtag_out(net0333),
     .idata0_in1_jtag_out(net0332), .async_dat_in1_jtag_out(net0334),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net0739),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0271), .oclk_out(net0581), .oclkb_out(net0262),
     .odat0_out(net0604), .odat1_out(net0605),
     .odat_async_out(net0263), .pd_data_out(net0264),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(net0739), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(cnup[40]), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(cnup[41]), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(csr_cnup_dataselb), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(csr_cnup_ddren), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(tx_launch_clk[21]),
     .ilaunch_clk_in1(vssl_aibcr3aux), .ilpbk_dat_in0(vssl_aibcr3aux),
     .ilpbk_dat_in1(vssl_aibcr3aux), .ilpbk_en_in0(vssl_aibcr3aux),
     .ilpbk_en_in1(vssl_aibcr3aux), .indrv_in0(csr_cnup_ndrv_int[1:0]),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0(csr_cnup_pdrv_int[1:0]), .ipdrv_in1({vssl_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in0({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in1({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .istrbclk_in0(net0739),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(csr_cnup_txen_int),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0585), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(vssl_aibcr3aux),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0686), .odat1_aib(net0552),
     .jtag_rx_scan_out(jtag_rx_scan_in_11x3), .odat0_aib(net0557),
     .oclk_aib(net0266), .last_bs_out(last_bs_in_11x3),
     .oclkb_aib(net0267), .jtag_clkdr_in(jtag_clkdr4r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_12x3),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_12x3), .iopad(iopad_cnup[20]),
     .oclkn(net0265), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xupe_02_03 ( .idata1_in1_jtag_out(net0380),
     .idata0_in1_jtag_out(net0381), .async_dat_in1_jtag_out(net0382),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net0767),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0282), .oclk_out(net0560), .oclkb_out(net0273),
     .odat0_out(net0387), .odat1_out(net0388),
     .odat_async_out(net0587), .pd_data_out(net0573),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(net0767), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(cnup[38]), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(cnup[39]), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(csr_cnup_dataselb), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(csr_cnup_ddren), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(tx_launch_clk[18]),
     .ilaunch_clk_in1(vssl_aibcr3aux), .ilpbk_dat_in0(vssl_aibcr3aux),
     .ilpbk_dat_in1(vssl_aibcr3aux), .ilpbk_en_in0(vssl_aibcr3aux),
     .ilpbk_en_in1(vssl_aibcr3aux), .indrv_in0(csr_cnup_ndrv_int[1:0]),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0(csr_cnup_pdrv_int[1:0]), .ipdrv_in1({vssl_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in0({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in1({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .istrbclk_in0(net0767),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(csr_cnup_txen_int),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0281), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(vssl_aibcr3aux),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0724), .odat1_aib(net0280),
     .jtag_rx_scan_out(jtag_rx_scan_in_12x4), .odat0_aib(net0279),
     .oclk_aib(net0277), .last_bs_out(last_bs_in_12x4),
     .oclkb_aib(net0278), .jtag_clkdr_in(jtag_clkdr5r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_12x2),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_12x2), .iopad(iopad_cnup[19]),
     .oclkn(net0276), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xupe_04_05 ( .idata1_in1_jtag_out(net0373),
     .idata0_in1_jtag_out(net0372), .async_dat_in1_jtag_out(net0371),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net0750),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0293), .oclk_out(net0283), .oclkb_out(net0284),
     .odat0_out(net0359), .odat1_out(net0360),
     .odat_async_out(net0285), .pd_data_out(net0286),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(net0750), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(cnup[36]), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(cnup[37]), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(csr_cnup_dataselb), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(csr_cnup_ddren), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(tx_launch_clk[19]),
     .ilaunch_clk_in1(vssl_aibcr3aux), .ilpbk_dat_in0(vssl_aibcr3aux),
     .ilpbk_dat_in1(vssl_aibcr3aux), .ilpbk_en_in0(vssl_aibcr3aux),
     .ilpbk_en_in1(vssl_aibcr3aux), .indrv_in0(csr_cnup_ndrv_int[1:0]),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0(csr_cnup_pdrv_int[1:0]), .ipdrv_in1({vssl_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in0({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in1({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .istrbclk_in0(net0750),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(csr_cnup_txen_int),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0586), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(vssl_aibcr3aux),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0730), .odat1_aib(net0291),
     .jtag_rx_scan_out(jtag_rx_scan_in_12x3), .odat0_aib(net0290),
     .oclk_aib(net0565), .last_bs_out(last_bs_in_12x3),
     .oclkb_aib(net0289), .jtag_clkdr_in(jtag_clkdr6r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_12x1),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_12x1), .iopad(iopad_cnup[18]),
     .oclkn(net0287), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xup_32_abort ( .idata1_in1_jtag_out(net0874),
     .idata0_in1_jtag_out(net0384), .async_dat_in1_jtag_out(net0383),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net0761),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0479), .oclk_out(net0480), .oclkb_out(net0403),
     .odat0_out(net0444), .odat1_out(net0445),
     .odat_async_out(net0448), .pd_data_out(net0476),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(net0761), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(cnup[34]), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(cnup[35]), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(csr_cnup_dataselb), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(csr_cnup_ddren), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(tx_launch_clk[16]),
     .ilaunch_clk_in1(vssl_aibcr3aux), .ilpbk_dat_in0(vssl_aibcr3aux),
     .ilpbk_dat_in1(vssl_aibcr3aux), .ilpbk_en_in0(vssl_aibcr3aux),
     .ilpbk_en_in1(vssl_aibcr3aux), .indrv_in0(csr_cnup_ndrv_int[1:0]),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0(csr_cnup_pdrv_int[1:0]), .ipdrv_in1({vssl_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in0({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in1({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .istrbclk_in0(net0761),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(csr_cnup_txen_int),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0466), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(vssl_aibcr3aux),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0701), .odat1_aib(net0469),
     .jtag_rx_scan_out(jtag_rx_scan_in_12x2), .odat0_aib(net0412),
     .oclk_aib(net0475), .last_bs_out(last_bs_in_12x2),
     .oclkb_aib(net0463), .jtag_clkdr_in(jtag_clkdr5r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_11x2),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_11x2), .iopad(iopad_cnup[17]),
     .oclkn(net0447), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xupe_00_01 ( .idata1_in1_jtag_out(net0368),
     .idata0_in1_jtag_out(net0369), .async_dat_in1_jtag_out(net0370),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net0727),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0462), .oclk_out(net0457), .oclkb_out(net0178),
     .odat0_out(net0926), .odat1_out(net0897),
     .odat_async_out(net0453), .pd_data_out(net0180),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(net0727), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(cnup[32]), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(cnup[33]), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(csr_cnup_dataselb), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(csr_cnup_ddren), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(tx_launch_clk[17]),
     .ilaunch_clk_in1(vssl_aibcr3aux), .ilpbk_dat_in0(vssl_aibcr3aux),
     .ilpbk_dat_in1(vssl_aibcr3aux), .ilpbk_en_in0(vssl_aibcr3aux),
     .ilpbk_en_in1(vssl_aibcr3aux), .indrv_in0(csr_cnup_ndrv_int[1:0]),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0(csr_cnup_pdrv_int[1:0]), .ipdrv_in1({vssl_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in0({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in1({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .istrbclk_in0(net0727),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(csr_cnup_txen_int),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0467), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(vssl_aibcr3aux),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0768), .odat1_aib(net0470),
     .jtag_rx_scan_out(jtag_rx_scan_in_12x1), .odat0_aib(net0471),
     .oclk_aib(net0464), .last_bs_out(last_bs_in_12x1),
     .oclkb_aib(net0414), .jtag_clkdr_in(jtag_clkdr6r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_11x1),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_11x1), .iopad(iopad_cnup[16]),
     .oclkn(net0458), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xup_30_31 ( .idata1_in1_jtag_out(net0367),
     .idata0_in1_jtag_out(net0365), .async_dat_in1_jtag_out(net0362),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net0756),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0177), .oclk_out(net0167), .oclkb_out(net0168),
     .odat0_out(net0473), .odat1_out(net0474),
     .odat_async_out(net0169), .pd_data_out(net0170),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(net0756), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(cnup[28]), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(cnup[29]), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(csr_cnup_dataselb), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(csr_cnup_ddren), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(tx_launch_clk[15]),
     .ilaunch_clk_in1(vssl_aibcr3aux), .ilpbk_dat_in0(vssl_aibcr3aux),
     .ilpbk_dat_in1(vssl_aibcr3aux), .ilpbk_en_in0(vssl_aibcr3aux),
     .ilpbk_en_in1(vssl_aibcr3aux), .indrv_in0(csr_cnup_ndrv_int[1:0]),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0(csr_cnup_pdrv_int[1:0]), .ipdrv_in1({vssl_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in0({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in1({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .istrbclk_in0(net0756),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(csr_cnup_txen_int),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0176), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(vssl_aibcr3aux),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0745), .odat1_aib(net0175),
     .jtag_rx_scan_out(jtag_rx_scan_in_11x1), .odat0_aib(net0174),
     .oclk_aib(net0172), .last_bs_out(last_bs_in_11x1),
     .oclkb_aib(net0173), .jtag_clkdr_in(jtag_clkdr6r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_10x1),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_10x1), .iopad(iopad_cnup[14]),
     .oclkn(net0171), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xup_28_29 ( .idata1_in1_jtag_out(net0901),
     .idata0_in1_jtag_out(net0896), .async_dat_in1_jtag_out(net0386),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net0681),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0166), .oclk_out(net0156), .oclkb_out(net0157),
     .odat0_out(net0502), .odat1_out(net0503),
     .odat_async_out(net0158), .pd_data_out(net0159),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(net0681), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(cnup[30]), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(cnup[31]), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(csr_cnup_dataselb), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(csr_cnup_ddren), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(tx_launch_clk[14]),
     .ilaunch_clk_in1(vssl_aibcr3aux), .ilpbk_dat_in0(vssl_aibcr3aux),
     .ilpbk_dat_in1(vssl_aibcr3aux), .ilpbk_en_in0(vssl_aibcr3aux),
     .ilpbk_en_in1(vssl_aibcr3aux), .indrv_in0(csr_cnup_ndrv_int[1:0]),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0(csr_cnup_pdrv_int[1:0]), .ipdrv_in1({vssl_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in0({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in1({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .istrbclk_in0(net0681),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(csr_cnup_txen_int),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0165), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(vssl_aibcr3aux),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0757), .odat1_aib(net0164),
     .jtag_rx_scan_out(jtag_rx_scan_in_11x2), .odat0_aib(net0163),
     .oclk_aib(net0161), .last_bs_out(last_bs_in_11x2),
     .oclkb_aib(net0162), .jtag_clkdr_in(jtag_clkdr5r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_10x2),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_10x2), .iopad(iopad_cnup[15]),
     .oclkn(net0160), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xup_26_27 ( .idata1_in1_jtag_out(net0366),
     .idata0_in1_jtag_out(net0364), .async_dat_in1_jtag_out(net0363),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net087),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0429), .oclk_out(net0223), .oclkb_out(net0434),
     .odat0_out(net0531), .odat1_out(net0532),
     .odat_async_out(net0432), .pd_data_out(net0226),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(net087), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(cnup[24]), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(cnup[25]), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(csr_cnup_dataselb), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(csr_cnup_ddren), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(tx_launch_clk[13]),
     .ilaunch_clk_in1(vssl_aibcr3aux), .ilpbk_dat_in0(vssl_aibcr3aux),
     .ilpbk_dat_in1(vssl_aibcr3aux), .ilpbk_en_in0(vssl_aibcr3aux),
     .ilpbk_en_in1(vssl_aibcr3aux), .indrv_in0(csr_cnup_ndrv_int[1:0]),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0(csr_cnup_pdrv_int[1:0]), .ipdrv_in1({vssl_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in0({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in1({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .istrbclk_in0(net087),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(csr_cnup_txen_int),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0436), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(vssl_aibcr3aux),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0735), .odat1_aib(net0231),
     .jtag_rx_scan_out(jtag_rx_scan_in_10x1), .odat0_aib(net0417),
     .oclk_aib(net0406), .last_bs_out(last_bs_in_10x1),
     .oclkb_aib(net0407), .jtag_clkdr_in(jtag_clkdr6r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_09x1),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_09x1), .iopad(iopad_cnup[12]),
     .oclkn(net0430), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xup_24_25 ( .idata1_in1_jtag_out(net0389),
     .idata0_in1_jtag_out(net0390), .async_dat_in1_jtag_out(net0391),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net088),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0427), .oclk_out(net0212), .oclkb_out(net0213),
     .odat0_out(net0984), .odat1_out(net0561),
     .odat_async_out(net0424), .pd_data_out(net0410),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(net088), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(cnup[26]), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(cnup[27]), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(csr_cnup_dataselb), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(csr_cnup_ddren), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(tx_launch_clk[12]),
     .ilaunch_clk_in1(vssl_aibcr3aux), .ilpbk_dat_in0(vssl_aibcr3aux),
     .ilpbk_dat_in1(vssl_aibcr3aux), .ilpbk_en_in0(vssl_aibcr3aux),
     .ilpbk_en_in1(vssl_aibcr3aux), .indrv_in0(csr_cnup_ndrv_int[1:0]),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0(csr_cnup_pdrv_int[1:0]), .ipdrv_in1({vssl_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in0({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in1({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .istrbclk_in0(net088),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(csr_cnup_txen_int),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0221), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(vssl_aibcr3aux),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0752), .odat1_aib(net0415),
     .jtag_rx_scan_out(jtag_rx_scan_in_10x2), .odat0_aib(net0219),
     .oclk_aib(net0439), .last_bs_out(last_bs_in_10x2),
     .oclkb_aib(net0218), .jtag_clkdr_in(jtag_clkdr5r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_09x2),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_09x2), .iopad(iopad_cnup[13]),
     .oclkn(net0216), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xup_20_21 ( .idata1_in1_jtag_out(net0394),
     .idata0_in1_jtag_out(net0393), .async_dat_in1_jtag_out(net0392),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net084),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0422), .oclk_out(net0420), .oclkb_out(net0235),
     .odat0_out(net0933), .odat1_out(net01036),
     .odat_async_out(net0440), .pd_data_out(net0428),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(net084), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(cnup[22]), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(cnup[23]), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(csr_cnup_dataselb), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(csr_cnup_ddren), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(tx_launch_clk[10]),
     .ilaunch_clk_in1(vssl_aibcr3aux), .ilpbk_dat_in0(vssl_aibcr3aux),
     .ilpbk_dat_in1(vssl_aibcr3aux), .ilpbk_en_in0(vssl_aibcr3aux),
     .ilpbk_en_in1(vssl_aibcr3aux), .indrv_in0(csr_cnup_ndrv_int[1:0]),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0(csr_cnup_pdrv_int[1:0]), .ipdrv_in1({vssl_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in0({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in1({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .istrbclk_in0(net084),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(csr_cnup_txen_int),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0243), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(vssl_aibcr3aux),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0676), .odat1_aib(net0242),
     .jtag_rx_scan_out(jtag_rx_scan_in_09x2), .odat0_aib(net0241),
     .oclk_aib(net0239), .last_bs_out(last_bs_in_09x2),
     .oclkb_aib(net0240), .jtag_clkdr_in(jtag_clkdr5r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_08x2),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_08x2), .iopad(iopad_cnup[11]),
     .oclkn(net0431), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xup_22_23 ( .idata1_in1_jtag_out(net0379),
     .idata0_in1_jtag_out(net0377), .async_dat_in1_jtag_out(net0375),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net083),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0255), .oclk_out(net0245), .oclkb_out(net0246),
     .odat0_out(net0589), .odat1_out(net0590),
     .odat_async_out(net0426), .pd_data_out(net0441),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(net083), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(cnup[20]), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(cnup[21]), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(csr_cnup_dataselb), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(csr_cnup_ddren), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(tx_launch_clk[11]),
     .ilaunch_clk_in1(vssl_aibcr3aux), .ilpbk_dat_in0(vssl_aibcr3aux),
     .ilpbk_dat_in1(vssl_aibcr3aux), .ilpbk_en_in0(vssl_aibcr3aux),
     .ilpbk_en_in1(vssl_aibcr3aux), .indrv_in0(csr_cnup_ndrv_int[1:0]),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0(csr_cnup_pdrv_int[1:0]), .ipdrv_in1({vssl_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in0({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in1({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .istrbclk_in0(net083),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(csr_cnup_txen_int),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0254), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(vssl_aibcr3aux),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0755), .odat1_aib(net0253),
     .jtag_rx_scan_out(jtag_rx_scan_in_09x1), .odat0_aib(net0425),
     .oclk_aib(net0250), .last_bs_out(last_bs_in_09x1),
     .oclkb_aib(net0251), .jtag_clkdr_in(jtag_clkdr6r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_08x1),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_08x1), .iopad(iopad_cnup[10]),
     .oclkn(net0249), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xup_clkp ( .idata1_in1_jtag_out(net0395),
     .idata0_in1_jtag_out(net0396), .async_dat_in1_jtag_out(net0397),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net0722),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0322), .oclk_out(net0818), .oclkb_out(net0819),
     .odat0_out(net065), .odat1_out(net066), .odat_async_out(net0288),
     .pd_data_out(net0315), .async_dat_in0(vssl_aibcr3aux),
     .async_dat_in1(vssl_aibcr3aux), .iclkin_dist_in0(net0722),
     .iclkin_dist_in1(vssl_aibcr3aux), .idata0_in0(idata1_ckp_cnoc),
     .idata0_in1(vssl_aibcr3aux), .idata1_in0(idata0_ckp_cnoc),
     .idata1_in1(vssl_aibcr3aux), .idataselb_in0(csr_cnup_dataselb),
     .idataselb_in1(vssl_aibcr3aux), .iddren_in0(csr_cnup_ddren),
     .iddren_in1(vssl_aibcr3aux), .ilaunch_clk_in0(tx_launch_clk[25]),
     .ilaunch_clk_in1(vssl_aibcr3aux), .ilpbk_dat_in0(vssl_aibcr3aux),
     .ilpbk_dat_in1(vssl_aibcr3aux), .ilpbk_en_in0(vssl_aibcr3aux),
     .ilpbk_en_in1(vssl_aibcr3aux), .indrv_in0(csr_cnup_ndrv_int[1:0]),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0(csr_cnup_pdrv_int[1:0]), .ipdrv_in1({vssl_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in0({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in1({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .istrbclk_in0(net0722),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(csr_cnup_txen_int),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0320), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(vssl_aibcr3aux),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0747), .odat1_aib(net0309),
     .jtag_rx_scan_out(jtag_rx_scan_in_08x2), .odat0_aib(net0319),
     .oclk_aib(net0292), .last_bs_out(last_bs_in_08x2),
     .oclkb_aib(net0324), .jtag_clkdr_in(jtag_clkdr5r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_07x2),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_07x2), .iopad(iopad_clkn_nocon),
     .oclkn(net0302), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xup_clkn ( .idata1_in1_jtag_out(net0378),
     .idata0_in1_jtag_out(net0376), .async_dat_in1_jtag_out(net0374),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net0725),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0149), .oclk_out(net0312), .oclkb_out(net0140),
     .odat0_out(net0256), .odat1_out(net0433),
     .odat_async_out(net0141), .pd_data_out(net0142),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(net0725), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(idata0_ckp_cnoc), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(idata1_ckp_cnoc), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(csr_cnup_dataselb), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(csr_cnup_ddren), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(tx_launch_clk[25]),
     .ilaunch_clk_in1(vssl_aibcr3aux), .ilpbk_dat_in0(vssl_aibcr3aux),
     .ilpbk_dat_in1(vssl_aibcr3aux), .ilpbk_en_in0(vssl_aibcr3aux),
     .ilpbk_en_in1(vssl_aibcr3aux), .indrv_in0({vssl_aibcr3aux,
     vcc_aibcr3aux}), .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0({vssl_aibcr3aux, vcc_aibcr3aux}),
     .ipdrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .irxen_in0({vssl_aibcr3aux, vcc_aibcr3aux, vssl_aibcr3aux}),
     .irxen_in1({vssl_aibcr3aux, vcc_aibcr3aux, vssl_aibcr3aux}),
     .istrbclk_in0(net0725), .istrbclk_in1(vssl_aibcr3aux),
     .itxen_in0(csr_cnup_txen_int), .itxen_in1(vssl_aibcr3aux),
     .oclk_in1(vssl_aibcr3aux), .odat_async_aib(net0148),
     .oclkb_in1(vssl_aibcr3aux), .odat0_in1(vssl_aibcr3aux),
     .odat1_in1(vssl_aibcr3aux), .odat_async_in1(vssl_aibcr3aux),
     .shift_en(vssl_aibcr3aux), .pd_data_in1(vssl_aibcr3aux),
     .dig_rstb(dig_rstb), .jtag_clkdr_out(net0690),
     .odat1_aib(net0147), .jtag_rx_scan_out(jtag_rx_scan_in_08x1),
     .odat0_aib(net0146), .oclk_aib(net0144),
     .last_bs_out(last_bs_in_08x1), .oclkb_aib(net0145),
     .jtag_clkdr_in(jtag_clkdr6r), .jtag_mode_in(jtag_mode_in),
     .jtag_rstb(jtag_rstb), .jtag_tx_scan_in(jtag_rx_scan_in_07x1),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_07x1), .iopad(iopad_cnup_clkp),
     .oclkn(net0947), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xup_16_17 ( .idata1_in1_jtag_out(net0398),
     .idata0_in1_jtag_out(net0399), .async_dat_in1_jtag_out(net0400),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net076),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0257), .oclk_out(net0272), .oclkb_out(net0270),
     .odat0_out(net0678), .odat1_out(net0679),
     .odat_async_out(net0247), .pd_data_out(net0261),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(net076), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(cnup[18]), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(cnup[19]), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(csr_cnup_dataselb), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(csr_cnup_ddren), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(tx_launch_clk[8]),
     .ilaunch_clk_in1(vssl_aibcr3aux), .ilpbk_dat_in0(vssl_aibcr3aux),
     .ilpbk_dat_in1(vssl_aibcr3aux), .ilpbk_en_in0(vssl_aibcr3aux),
     .ilpbk_en_in1(vssl_aibcr3aux), .indrv_in0(csr_cnup_ndrv_int[1:0]),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0(csr_cnup_pdrv_int[1:0]), .ipdrv_in1({vssl_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in0({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in1({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .istrbclk_in0(net076),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(csr_cnup_txen_int),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0275), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(vssl_aibcr3aux),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0746), .odat1_aib(net0274),
     .jtag_rx_scan_out(jtag_rx_scan_in_07x2), .odat0_aib(net0260),
     .oclk_aib(net0248), .last_bs_out(last_bs_in_07x2),
     .oclkb_aib(net0252), .jtag_clkdr_in(jtag_clkdr5l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_06x2),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_06x2), .iopad(iopad_cnup[9]),
     .oclkn(net0244), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xup_18_19 ( .idata1_in1_jtag_out(net0355),
     .idata0_in1_jtag_out(net0354), .async_dat_in1_jtag_out(net0353),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net075),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0139), .oclk_out(net0268), .oclkb_out(net0269),
     .odat0_out(net0647), .odat1_out(net0648),
     .odat_async_out(net0131), .pd_data_out(net0132),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(net075), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(cnup[16]), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(cnup[17]), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(csr_cnup_dataselb), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(csr_cnup_ddren), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(tx_launch_clk[9]),
     .ilaunch_clk_in1(vssl_aibcr3aux), .ilpbk_dat_in0(vssl_aibcr3aux),
     .ilpbk_dat_in1(vssl_aibcr3aux), .ilpbk_en_in0(vssl_aibcr3aux),
     .ilpbk_en_in1(vssl_aibcr3aux), .indrv_in0(csr_cnup_ndrv_int[1:0]),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0(csr_cnup_pdrv_int[1:0]), .ipdrv_in1({vssl_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in0({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in1({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .istrbclk_in0(net075),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(csr_cnup_txen_int),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0138), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(vssl_aibcr3aux),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0751), .odat1_aib(net0137),
     .jtag_rx_scan_out(jtag_rx_scan_in_07x1), .odat0_aib(net0136),
     .oclk_aib(net0134), .last_bs_out(last_bs_in_07x1),
     .oclkb_aib(net0135), .jtag_clkdr_in(jtag_clkdr6l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_06x1),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_06x1), .iopad(iopad_cnup[8]),
     .oclkn(net0133), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xup_14_15 ( .idata1_in1_jtag_out(net0356),
     .idata0_in1_jtag_out(net0358), .async_dat_in1_jtag_out(net0361),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net071),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0228), .oclk_out(net0229), .oclkb_out(net0120),
     .odat0_out(net0707), .odat1_out(net0708),
     .odat_async_out(net0121), .pd_data_out(net0122),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(net071), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(cnup[12]), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(cnup[13]), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(csr_cnup_dataselb), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(csr_cnup_ddren), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(tx_launch_clk[7]),
     .ilaunch_clk_in1(vssl_aibcr3aux), .ilpbk_dat_in0(vssl_aibcr3aux),
     .ilpbk_dat_in1(vssl_aibcr3aux), .ilpbk_en_in0(vssl_aibcr3aux),
     .ilpbk_en_in1(vssl_aibcr3aux), .indrv_in0(csr_cnup_ndrv_int[1:0]),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0(csr_cnup_pdrv_int[1:0]), .ipdrv_in1({vssl_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in0({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in1({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .istrbclk_in0(net071),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(csr_cnup_txen_int),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0220), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(vssl_aibcr3aux),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0700), .odat1_aib(net0237),
     .jtag_rx_scan_out(jtag_rx_scan_in_06x1), .odat0_aib(net0236),
     .oclk_aib(net0214), .last_bs_out(last_bs_in_06x1),
     .oclkb_aib(net0222), .jtag_clkdr_in(jtag_clkdr6l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_05x1),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_05x1), .iopad(iopad_cnup[6]),
     .oclkn(net0123), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xup_08_09 ( .idata1_in1_jtag_out(net0404),
     .idata0_in1_jtag_out(net0405), .async_dat_in1_jtag_out(net0900),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net068),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0181), .oclk_out(net0191), .oclkb_out(net0190),
     .odat0_out(net0794), .odat1_out(net0795),
     .odat_async_out(net0184), .pd_data_out(net0195),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(net068), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(cnup[10]), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(cnup[11]), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(csr_cnup_dataselb), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(csr_cnup_ddren), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(tx_launch_clk[4]),
     .ilaunch_clk_in1(vssl_aibcr3aux), .ilpbk_dat_in0(vssl_aibcr3aux),
     .ilpbk_dat_in1(vssl_aibcr3aux), .ilpbk_en_in0(vssl_aibcr3aux),
     .ilpbk_en_in1(vssl_aibcr3aux), .indrv_in0(csr_cnup_ndrv_int[1:0]),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0(csr_cnup_pdrv_int[1:0]), .ipdrv_in1({vssl_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in0({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in1({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .istrbclk_in0(net068),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(csr_cnup_txen_int),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0185), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(vssl_aibcr3aux),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0705), .odat1_aib(net0183),
     .jtag_rx_scan_out(jtag_rx_scan_in_05x2), .odat0_aib(net0182),
     .oclk_aib(net0193), .last_bs_out(last_bs_in_05x2),
     .oclkb_aib(net0187), .jtag_clkdr_in(jtag_clkdr5l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_04x2),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_04x2), .iopad(iopad_cnup[5]),
     .oclkn(net0186), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xup_00_01 ( .idata1_in1_jtag_out(net0857),
     .idata0_in1_jtag_out(net0411), .async_dat_in1_jtag_out(net0893),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net060),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0130), .oclk_out(net0442), .oclkb_out(net0416),
     .odat0_out(net0594), .odat1_out(net0535),
     .odat_async_out(net0385), .pd_data_out(net0402),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(net060), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(cnup[2]), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(cnup[3]), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(csr_cnup_dataselb), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(csr_cnup_ddren), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(tx_launch_clk[0]),
     .ilaunch_clk_in1(vssl_aibcr3aux), .ilpbk_dat_in0(vssl_aibcr3aux),
     .ilpbk_dat_in1(vssl_aibcr3aux), .ilpbk_en_in0(vssl_aibcr3aux),
     .ilpbk_en_in1(vssl_aibcr3aux), .indrv_in0(csr_cnup_ndrv_int[1:0]),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0(csr_cnup_pdrv_int[1:0]), .ipdrv_in1({vssl_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in0({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in1({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .istrbclk_in0(net060),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(csr_cnup_txen_int),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0129), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(vssl_aibcr3aux),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0764), .odat1_aib(net0128),
     .jtag_rx_scan_out(jtag_rx_scan_in_03x2), .odat0_aib(net0127),
     .oclk_aib(net0125), .last_bs_out(last_bs_in_03x2),
     .oclkb_aib(net0126), .jtag_clkdr_in(jtag_clkdr5l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_tx_scan_in_02x2),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_02x2), .iopad(iopad_cnup[1]),
     .oclkn(net0124), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xup_02_03 ( .idata1_in1_jtag_out(net0345),
     .idata0_in1_jtag_out(net0347), .async_dat_in1_jtag_out(net0349),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net059),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net051), .oclk_out(net041), .oclkb_out(net042),
     .odat0_out(net0980), .odat1_out(net01064),
     .odat_async_out(net043), .pd_data_out(net044),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(net059), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(cnup[0]), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(cnup[1]), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(csr_cnup_dataselb), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(csr_cnup_ddren), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(tx_launch_clk[1]),
     .ilaunch_clk_in1(vssl_aibcr3aux), .ilpbk_dat_in0(vssl_aibcr3aux),
     .ilpbk_dat_in1(vssl_aibcr3aux), .ilpbk_en_in0(vssl_aibcr3aux),
     .ilpbk_en_in1(vssl_aibcr3aux), .indrv_in0(csr_cnup_ndrv_int[1:0]),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0(csr_cnup_pdrv_int[1:0]), .ipdrv_in1({vssl_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in0({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in1({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .istrbclk_in0(net059),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(csr_cnup_txen_int),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net050), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(vssl_aibcr3aux),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0758), .odat1_aib(net049),
     .jtag_rx_scan_out(jtag_rx_scan_in_03x1), .odat0_aib(net048),
     .oclk_aib(net046), .last_bs_out(last_bs_in_03x1),
     .oclkb_aib(net047), .jtag_clkdr_in(jtag_clkdr6l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_tx_scan_in_02x1),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_02x1), .iopad(iopad_cnup[0]),
     .oclkn(net045), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xup_12_13 ( .idata1_in1_jtag_out(net0904),
     .idata0_in1_jtag_out(net0846), .async_dat_in1_jtag_out(net0401),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net072),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0232), .oclk_out(net0215), .oclkb_out(net0227),
     .odat0_out(net0736), .odat1_out(net0737),
     .odat_async_out(net0211), .pd_data_out(net0230),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(net072), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(cnup[14]), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(cnup[15]), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(csr_cnup_dataselb), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(csr_cnup_ddren), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(tx_launch_clk[6]),
     .ilaunch_clk_in1(vssl_aibcr3aux), .ilpbk_dat_in0(vssl_aibcr3aux),
     .ilpbk_dat_in1(vssl_aibcr3aux), .ilpbk_en_in0(vssl_aibcr3aux),
     .ilpbk_en_in1(vssl_aibcr3aux), .indrv_in0(csr_cnup_ndrv_int[1:0]),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0(csr_cnup_pdrv_int[1:0]), .ipdrv_in1({vssl_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in0({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in1({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .istrbclk_in0(net072),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(csr_cnup_txen_int),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0238), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(vssl_aibcr3aux),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0759), .odat1_aib(net0233),
     .jtag_rx_scan_out(jtag_rx_scan_in_06x2), .odat0_aib(net0217),
     .oclk_aib(net0224), .last_bs_out(last_bs_in_06x2),
     .oclkb_aib(net0225), .jtag_clkdr_in(jtag_clkdr5l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_05x2),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_05x2), .iopad(iopad_cnup[7]),
     .oclkn(net0234), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xup_10_11 ( .idata1_in1_jtag_out(net0357),
     .idata0_in1_jtag_out(net0885), .async_dat_in1_jtag_out(net0860),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net067),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0119), .oclk_out(net0192), .oclkb_out(net0179),
     .odat0_out(net0765), .odat1_out(net0766),
     .odat_async_out(net0194), .pd_data_out(net0112),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(net067), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(cnup[8]), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(cnup[9]), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(csr_cnup_dataselb), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(csr_cnup_ddren), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(tx_launch_clk[5]),
     .ilaunch_clk_in1(vssl_aibcr3aux), .ilpbk_dat_in0(vssl_aibcr3aux),
     .ilpbk_dat_in1(vssl_aibcr3aux), .ilpbk_en_in0(vssl_aibcr3aux),
     .ilpbk_en_in1(vssl_aibcr3aux), .indrv_in0(csr_cnup_ndrv_int[1:0]),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0(csr_cnup_pdrv_int[1:0]), .ipdrv_in1({vssl_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in0({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in1({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .istrbclk_in0(net067),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(csr_cnup_txen_int),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0118), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(vssl_aibcr3aux),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0731), .odat1_aib(net0117),
     .jtag_rx_scan_out(jtag_rx_scan_in_05x1), .odat0_aib(net0116),
     .oclk_aib(net0114), .last_bs_out(last_bs_in_05x1),
     .oclkb_aib(net0115), .jtag_clkdr_in(jtag_clkdr6l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_04x1),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_04x1), .iopad(iopad_cnup[4]),
     .oclkn(net0113), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xup_04_05 ( .idata1_in1_jtag_out(net0409),
     .idata0_in1_jtag_out(net0408), .async_dat_in1_jtag_out(net0884),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net064),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0100), .oclk_out(net090), .oclkb_out(net091),
     .odat0_out(net0852), .odat1_out(net0853), .odat_async_out(net092),
     .pd_data_out(net093), .async_dat_in0(vssl_aibcr3aux),
     .async_dat_in1(vssl_aibcr3aux), .iclkin_dist_in0(net064),
     .iclkin_dist_in1(vssl_aibcr3aux), .idata0_in0(cnup[6]),
     .idata0_in1(vssl_aibcr3aux), .idata1_in0(cnup[7]),
     .idata1_in1(vssl_aibcr3aux), .idataselb_in0(csr_cnup_dataselb),
     .idataselb_in1(vssl_aibcr3aux), .iddren_in0(csr_cnup_ddren),
     .iddren_in1(vssl_aibcr3aux), .ilaunch_clk_in0(tx_launch_clk[2]),
     .ilaunch_clk_in1(vssl_aibcr3aux), .ilpbk_dat_in0(vssl_aibcr3aux),
     .ilpbk_dat_in1(vssl_aibcr3aux), .ilpbk_en_in0(vssl_aibcr3aux),
     .ilpbk_en_in1(vssl_aibcr3aux), .indrv_in0(csr_cnup_ndrv_int[1:0]),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0(csr_cnup_pdrv_int[1:0]), .ipdrv_in1({vssl_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in0({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in1({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .istrbclk_in0(net064),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(csr_cnup_txen_int),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net099), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(vssl_aibcr3aux),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0699), .odat1_aib(net098),
     .jtag_rx_scan_out(jtag_rx_scan_in_04x2), .odat0_aib(net097),
     .oclk_aib(net095), .last_bs_out(last_bs_in_04x2),
     .oclkb_aib(net096), .jtag_clkdr_in(jtag_clkdr5l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_03x2),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_03x2), .iopad(iopad_cnup[3]),
     .oclkn(net094), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xup_06_07 ( .idata1_in1_jtag_out(net0344),
     .idata0_in1_jtag_out(net0346), .async_dat_in1_jtag_out(net0348),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net063),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0111), .oclk_out(net0101), .oclkb_out(net0102),
     .odat0_out(net0823), .odat1_out(net0824),
     .odat_async_out(net0103), .pd_data_out(net0104),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(net063), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(cnup[4]), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(cnup[5]), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(csr_cnup_dataselb), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(csr_cnup_ddren), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(tx_launch_clk[3]),
     .ilaunch_clk_in1(vssl_aibcr3aux), .ilpbk_dat_in0(vssl_aibcr3aux),
     .ilpbk_dat_in1(vssl_aibcr3aux), .ilpbk_en_in0(vssl_aibcr3aux),
     .ilpbk_en_in1(vssl_aibcr3aux), .indrv_in0(csr_cnup_ndrv_int[1:0]),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0(csr_cnup_pdrv_int[1:0]), .ipdrv_in1({vssl_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in0({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .irxen_in1({vssl_aibcr3aux, vcc_aibcr3aux,
     vssl_aibcr3aux}), .istrbclk_in0(net063),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(csr_cnup_txen_int),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0110), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(vssl_aibcr3aux),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0712), .odat1_aib(net0109),
     .jtag_rx_scan_out(jtag_rx_scan_in_04x1), .odat0_aib(net0108),
     .oclk_aib(net0106), .last_bs_out(last_bs_in_04x1),
     .oclkb_aib(net0107), .jtag_clkdr_in(jtag_clkdr6l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_03x1),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_03x1), .iopad(iopad_cnup[2]),
     .oclkn(net0105), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
assign csr_cnup_txen_int = csr_iocsr_sel ? csr_cnup_txen : vcc_aibcr3aux;
assign csr_cnup_pdrv_int[1:0] = csr_iocsr_sel ? csr_cnup_pdrv[1:0] : {vcc_aibcr3aux, vssl_aibcr3aux};
assign csr_dly_ovrd_int[3:0] = csr_iocsr_sel ? csr_dly_ovrd[3:0] : {vssl_aibcr3aux,     vssl_aibcr3aux, vssl_aibcr3aux, vssl_aibcr3aux};
assign csr_cnup_ndrv_int[1:0] = csr_iocsr_sel ? csr_cnup_ndrv[1:0] : {vcc_aibcr3aux, vssl_aibcr3aux};
aibcr3_aliasd aliasd0 ( .rb(iopad_cnup_clkn), .ra(iopad_cnup_clkp));

endmodule
