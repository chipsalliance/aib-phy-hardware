// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3aux_lib, Cell - aibcr3aux_cnocdn, View - schematic
// LAST TIME SAVED: Aug 25 11:02:20 2015
// NETLIST TIME: Aug 26 15:05:12 2015
// `timescale 1ns / 1ns 

module aibcr3aux_cnocdn ( cndn, jtag_rx_scan_out_01x3,
     jtag_rx_scan_out_01x4, last_bs_out_01x3, last_bs_out_01x4,
     orx_clkp, iopad_cndn, iopad_cndn_clkn, iopad_cndn_clkp, anlg_rstb,
     csr_cndn_cken, csr_cndn_rxen, csr_dly_ovrd, csr_dly_ovrden,
     csr_iocsr_sel, dig_rstb, ib50u_ring, ib50uc, iosc_fuse_trim,
     jtag_clkdr3l, jtag_clkdr3r, jtag_clkdr4l, jtag_clkdr4r,
     jtag_clksel, jtag_intest, jtag_mode_in, jtag_rstb, jtag_rstb_en,
     jtag_tx_scan_in_09x3, jtag_tx_scan_in_09x4, jtag_tx_scanen_in,
     jtag_weakpdn, jtag_weakpu, last_bs_in_09x3, last_bs_in_09x4,
     por_vcchssi, por_vccl, vcc_aibcr3aux, vccl_aibcr3aux, vssl_aibcr3aux
     );

output  jtag_rx_scan_out_01x3, jtag_rx_scan_out_01x4, last_bs_out_01x3,
     last_bs_out_01x4, orx_clkp;

inout  iopad_cndn_clkn, iopad_cndn_clkp;

input  anlg_rstb, csr_dly_ovrden, csr_iocsr_sel, dig_rstb, ib50u_ring,
     ib50uc, jtag_clkdr3l, jtag_clkdr3r, jtag_clkdr4l, jtag_clkdr4r,
     jtag_clksel, jtag_intest, jtag_mode_in, jtag_rstb, jtag_rstb_en,
     jtag_tx_scan_in_09x3, jtag_tx_scan_in_09x4, jtag_tx_scanen_in,
     jtag_weakpdn, jtag_weakpu, last_bs_in_09x3, last_bs_in_09x4,
     por_vcchssi, por_vccl, vcc_aibcr3aux, vccl_aibcr3aux, vssl_aibcr3aux;

output [31:0]  cndn;

inout [15:0]  iopad_cndn;

input [2:0]  csr_cndn_rxen;
input [2:0]  csr_cndn_cken;
input [3:0]  csr_dly_ovrd;
input [9:0]  iosc_fuse_trim;

// Buses in the design

wire  [3:0]  csr_dly_ovrd_int;

wire  [2:0]  csr_cndn_cken_int;

wire  [2:0]  csr_cndn_rxen_int;

wire  [0:17]  strbclk;

wire oclk_clkn;
wire net0397;
wire net0398;
wire net0399;
wire net0396;
wire net0400;
wire net0401;
wire net0418;
wire orx_clkp0;
wire nc_clk_rep;
wire oclk_clkp;
wire net0157;
wire net0768;
wire net0763;
wire net0505;
wire net0508;
wire net0509;
wire net0515;
wire net0413;
wire net0514;
wire jtag_rx_scan_in_04x3;
wire net0764;
wire net0511;
wire last_bs_in_04x3;
wire net0512;
wire jtag_rx_scan_in_05x3;
wire last_bs_in_05x3;
wire net0510;
wire net0166;
wire net0233;
wire net0305;
wire net0307;
wire net0313;
wire net0315;
wire net0231;
wire net0165;
wire net0229;
wire jtag_rx_scan_in_08x3;
wire net0227;
wire net0223;
wire last_bs_in_08x3;
wire net0225;
wire net0221;
wire net0172;
wire net0756;
wire net0452;
wire net0453;
wire net0456;
wire net0457;
wire net0463;
wire net0171;
wire net0462;
wire jtag_rx_scan_in_02x4;
wire net0461;
wire net0459;
wire last_bs_in_02x4;
wire net0460;
wire jtag_rx_scan_in_03x4;
wire last_bs_in_03x4;
wire net0458;
wire net0181;
wire net0555;
wire net0543;
wire net0544;
wire net0547;
wire net0548;
wire net0554;
wire net0182;
wire net0553;
wire jtag_rx_scan_in_07x4;
wire net0552;
wire net0550;
wire last_bs_in_07x4;
wire net0551;
wire net0357;
wire net0353;
wire net0549;
wire net0168;
wire net0130;
wire net0442;
wire net0416;
wire net0385;
wire net0402;
wire net0129;
wire net0167;
wire net0128;
wire net0127;
wire net0125;
wire net0126;
wire jtag_rx_scan_in_01x4;
wire last_bs_in_01x4;
wire net0124;
wire net0160;
wire net0219;
wire net0266;
wire net0346;
wire net0308;
wire net0310;
wire net0314;
wire net0217;
wire net0159;
wire net0216;
wire net0214;
wire net0210;
wire net0212;
wire jtag_rx_scan_in_06x3;
wire last_bs_in_06x3;
wire net0208;
wire net0173;
wire net0758;
wire net0465;
wire net0466;
wire net0469;
wire net0470;
wire net0476;
wire net0174;
wire net0475;
wire net0474;
wire net0769;
wire net0473;
wire jtag_rx_scan_in_04x4;
wire last_bs_in_04x4;
wire net0471;
wire net0164;
wire net0568;
wire net0556;
wire net0557;
wire net0560;
wire net0561;
wire net0567;
wire net0163;
wire net0566;
wire jtag_rx_scan_in_07x3;
wire net0565;
wire net0753;
wire last_bs_in_07x3;
wire net0564;
wire net0562;
wire net0184;
wire net0158;
wire net0468;
wire net0587;
wire net0490;
wire net0592;
wire net0155;
wire net0183;
wire net0154;
wire net0152;
wire net0148;
wire net0150;
wire net0146;
wire net0156;
wire net0752;
wire net0478;
wire net0479;
wire net0482;
wire net0754;
wire net0489;
wire net0403;
wire net0765;
wire jtag_rx_scan_in_03x3;
wire net0487;
wire net0485;
wire last_bs_in_03x3;
wire net0486;
wire net0484;
wire net0177;
wire net0143;
wire net0240;
wire net0242;
wire net0495;
wire net0540;
wire net0513;
wire net0141;
wire net0178;
wire net0139;
wire jtag_rx_scan_in_05x4;
wire net0137;
wire net0133;
wire last_bs_in_05x4;
wire net0135;
wire jtag_rx_scan_in_06x4;
wire last_bs_in_06x4;
wire net0131;
wire net0161;
wire net0542;
wire net0530;
wire net0531;
wire net0534;
wire net0535;
wire net0541;
wire net0162;
wire net0770;
wire net0539;
wire net0537;
wire net0538;
wire net0536;
wire net0153;
wire net0451;
wire net0439;
wire net0767;
wire net0443;
wire net0444;
wire net0450;
wire net0409;
wire net0449;
wire jtag_rx_scan_in_02x3;
wire net0448;
wire net0446;
wire last_bs_in_02x3;
wire net0447;
wire net0445;
wire net0149;
wire net0123;
wire net0477;
wire net0472;
wire net0415;
wire net0464;
wire net0122;
wire net0408;
wire net0121;
wire net0120;
wire net0118;
wire net0119;
wire jtag_rx_scan_in_01x3;
wire last_bs_in_01x3;
wire net0117;
wire net0407;
wire net0576;
wire net0204;
wire net0205;
wire net0215;
wire net0580;
wire net0211;
wire net0151;
wire net0563;
wire net0209;
wire net0207;
wire net0582;
wire net0206;
wire net0169;
wire net0583;
wire net0585;
wire net0218;
wire net0574;
wire net0222;
wire net0228;
wire net0170;
wire net0590;
wire net0226;
wire net0224;
wire net0581;
wire net0577;
wire net0180;
wire net0529;
wire net0517;
wire net0518;
wire net0521;
wire net0761;
wire net0528;
wire net0179;
wire net0527;
wire net0526;
wire net0524;
wire net0525;
wire net0523;
wire net0176;
wire net0503;
wire net0491;
wire net0492;
wire net0757;
wire net0496;
wire net0766;
wire net0175;
wire net0501;
wire net0500;
wire net0498;
wire net0499;
wire net0497;
wire net0198;
wire net0199;
wire net0197;
wire net0186;
wire net0187;
wire net0185;
wire net0232;
wire net0588;
wire net0230;
wire net0504;
wire net0604;
wire net0608;
wire net0238;
wire net0237;
wire net0236;
wire net0195;
wire net0194;
wire net0196;
wire net0569;
wire net0516;
wire net0494;
wire net0189;
wire net0188;
wire net0190;
wire net0522;
wire net0213;
wire net0601;
wire net0201;
wire net0200;
wire net0202;
wire net0600;
wire net0611;
wire net0571;
wire net0192;
wire net0193;
wire net0191;
wire net0502;
wire net0591;
wire net0203;
wire net0607;
wire net0593;
wire net0546;
wire net0602;
wire net0605;
wire net0613;
wire net0606;
wire net0234;
wire net0235;
wire net0220;
wire net0575;
wire net0507;
wire net0612;
wire net0609;
wire net0610;
wire oclk_clknb;
wire oclk_clkp_passgate;

// specify 
//     specparam CDS_LIBNAME  = "aibcr3aux_lib";
//     specparam CDS_CELLNAME = "aibcr3aux_cnocdn";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

assign oclk_clknb = ~oclk_clkp;
assign oclk_clkp_passgate = oclk_clkp;

aibcr3aux_cndn_clktree xcndnclktree ( .clkinb(oclk_clknb),
     .ib50u_ring(ib50u_ring), .ib50uc(ib50uc),
     .vcc_aibcr3aux(vcc_aibcr3aux), .csr_dly_ovrden(csr_dly_ovrden),
     .csr_dly_ovrd(csr_dly_ovrd_int[3:0]),
     .vss_aibcr3aux(vssl_aibcr3aux),
     .iosc_fuse_trim(iosc_fuse_trim[9:0]), .lstrbclk_mimic2(net0397),
     .lstrbclk_r_11(net0398), .lstrbclk_r_10(net0399),
     .lstrbclk_r_9(strbclk[4]), .lstrbclk_r_8(strbclk[5]),
     .lstrbclk_r_7(net0396), .lstrbclk_r_6(net0400),
     .lstrbclk_r_5(strbclk[2]), .lstrbclk_r_4(strbclk[3]),
     .lstrbclk_r_3(strbclk[16]), .lstrbclk_r_2(strbclk[17]),
     .lstrbclk_r_1(strbclk[0]), .lstrbclk_r_0(strbclk[1]),
     .lstrbclk_mimic1(net0401), .lstrbclk_mimic0(net0418),
     .lstrbclk_l_0(strbclk[11]), .lstrbclk_l_1(strbclk[10]),
     .lstrbclk_l_2(strbclk[9]), .lstrbclk_l_3(strbclk[8]),
     .lstrbclk_l_4(strbclk[13]), .lstrbclk_l_5(strbclk[12]),
     .lstrbclk_l_6(strbclk[7]), .lstrbclk_l_7(strbclk[6]),
     .lstrbclk_l_8(strbclk[15]), .lstrbclk_l_9(strbclk[14]),
     .lstrbclk_l_10(orx_clkp0), .lstrbclk_l_11(orx_clkp),
     .lstrbclk_rep(nc_clk_rep), .clkin(oclk_clkp_passgate));
aibcr3_buffx1_top  xdn_14_15 ( .idata1_in1_jtag_out(net0198),
     .idata0_in1_jtag_out(net0199), .async_dat_in1_jtag_out(net0197),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net0157),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0768), .oclk_out(net0763), .oclkb_out(net0505),
     .odat0_out(cndn[12]), .odat1_out(cndn[13]),
     .odat_async_out(net0508), .pd_data_out(net0509),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(strbclk[7]), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(vssl_aibcr3aux), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(vssl_aibcr3aux), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(vcc_aibcr3aux), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(vcc_aibcr3aux), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(vssl_aibcr3aux), .ilaunch_clk_in1(vssl_aibcr3aux),
     .ilpbk_dat_in0(vssl_aibcr3aux), .ilpbk_dat_in1(vssl_aibcr3aux),
     .ilpbk_en_in0(vssl_aibcr3aux), .ilpbk_en_in1(vssl_aibcr3aux),
     .indrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .irxen_in0(csr_cndn_rxen_int[2:0]), .irxen_in1({vssl_aibcr3aux,
     vssl_aibcr3aux, vssl_aibcr3aux}), .istrbclk_in0(strbclk[7]),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(vssl_aibcr3aux),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0515), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(vssl_aibcr3aux),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0413), .odat1_aib(net0514),
     .jtag_rx_scan_out(jtag_rx_scan_in_04x3), .odat0_aib(net0764),
     .oclk_aib(net0511), .last_bs_out(last_bs_in_04x3),
     .oclkb_aib(net0512), .jtag_clkdr_in(jtag_clkdr4l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_05x3),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_05x3), .iopad(iopad_cndn[6]),
     .oclkn(net0510), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xdn_02_03 ( .idata1_in1_jtag_out(net0186),
     .idata0_in1_jtag_out(net0187), .async_dat_in1_jtag_out(net0185),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net0166),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0233), .oclk_out(net0305), .oclkb_out(net0307),
     .odat0_out(cndn[0]), .odat1_out(cndn[1]),
     .odat_async_out(net0313), .pd_data_out(net0315),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(strbclk[1]), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(vssl_aibcr3aux), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(vssl_aibcr3aux), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(vcc_aibcr3aux), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(vcc_aibcr3aux), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(vssl_aibcr3aux), .ilaunch_clk_in1(vssl_aibcr3aux),
     .ilpbk_dat_in0(vssl_aibcr3aux), .ilpbk_dat_in1(vssl_aibcr3aux),
     .ilpbk_en_in0(vssl_aibcr3aux), .ilpbk_en_in1(vssl_aibcr3aux),
     .indrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .irxen_in0(csr_cndn_rxen_int[2:0]), .irxen_in1({vssl_aibcr3aux,
     vssl_aibcr3aux, vssl_aibcr3aux}), .istrbclk_in0(strbclk[1]),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(vssl_aibcr3aux),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0231), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(vssl_aibcr3aux),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0165), .odat1_aib(net0229),
     .jtag_rx_scan_out(jtag_rx_scan_in_08x3), .odat0_aib(net0227),
     .oclk_aib(net0223), .last_bs_out(last_bs_in_08x3),
     .oclkb_aib(net0225), .jtag_clkdr_in(jtag_clkdr4r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_tx_scan_in_09x3),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_09x3), .iopad(iopad_cndn[0]),
     .oclkn(net0221), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xdn_20_21 ( .idata1_in1_jtag_out(net0232),
     .idata0_in1_jtag_out(net0588), .async_dat_in1_jtag_out(net0230),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net0172),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0756), .oclk_out(net0452), .oclkb_out(net0453),
     .odat0_out(cndn[22]), .odat1_out(cndn[23]),
     .odat_async_out(net0456), .pd_data_out(net0457),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(strbclk[10]), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(vssl_aibcr3aux), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(vssl_aibcr3aux), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(vcc_aibcr3aux), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(vcc_aibcr3aux), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(vssl_aibcr3aux), .ilaunch_clk_in1(vssl_aibcr3aux),
     .ilpbk_dat_in0(vssl_aibcr3aux), .ilpbk_dat_in1(vssl_aibcr3aux),
     .ilpbk_en_in0(vssl_aibcr3aux), .ilpbk_en_in1(vssl_aibcr3aux),
     .indrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .irxen_in0(csr_cndn_rxen_int[2:0]), .irxen_in1({vssl_aibcr3aux,
     vssl_aibcr3aux, vssl_aibcr3aux}), .istrbclk_in0(strbclk[10]),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(vssl_aibcr3aux),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0463), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(vssl_aibcr3aux),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0171), .odat1_aib(net0462),
     .jtag_rx_scan_out(jtag_rx_scan_in_02x4), .odat0_aib(net0461),
     .oclk_aib(net0459), .last_bs_out(last_bs_in_02x4),
     .oclkb_aib(net0460), .jtag_clkdr_in(jtag_clkdr3l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_03x4),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_03x4), .iopad(iopad_cndn[11]),
     .oclkn(net0458), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xdn_04_05 ( .idata1_in1_jtag_out(net0504),
     .idata0_in1_jtag_out(net0604), .async_dat_in1_jtag_out(net0608),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net0181),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0555), .oclk_out(net0543), .oclkb_out(net0544),
     .odat0_out(cndn[6]), .odat1_out(cndn[7]),
     .odat_async_out(net0547), .pd_data_out(net0548),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(strbclk[2]), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(vssl_aibcr3aux), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(vssl_aibcr3aux), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(vcc_aibcr3aux), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(vcc_aibcr3aux), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(vssl_aibcr3aux), .ilaunch_clk_in1(vssl_aibcr3aux),
     .ilpbk_dat_in0(vssl_aibcr3aux), .ilpbk_dat_in1(vssl_aibcr3aux),
     .ilpbk_en_in0(vssl_aibcr3aux), .ilpbk_en_in1(vssl_aibcr3aux),
     .indrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .irxen_in0(csr_cndn_rxen_int[2:0]), .irxen_in1({vssl_aibcr3aux,
     vssl_aibcr3aux, vssl_aibcr3aux}), .istrbclk_in0(strbclk[2]),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(vssl_aibcr3aux),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0554), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(vssl_aibcr3aux),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0182), .odat1_aib(net0553),
     .jtag_rx_scan_out(jtag_rx_scan_in_07x4), .odat0_aib(net0552),
     .oclk_aib(net0550), .last_bs_out(last_bs_in_07x4),
     .oclkb_aib(net0551), .jtag_clkdr_in(jtag_clkdr3r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(net0357), .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(net0353), .iopad(iopad_cndn[3]), .oclkn(net0549),
     .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xdn_28_29 ( .idata1_in1_jtag_out(net0238),
     .idata0_in1_jtag_out(net0237), .async_dat_in1_jtag_out(net0236),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net0168),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0130), .oclk_out(net0442), .oclkb_out(net0416),
     .odat0_out(cndn[30]), .odat1_out(cndn[31]),
     .odat_async_out(net0385), .pd_data_out(net0402),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(strbclk[14]), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(vssl_aibcr3aux), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(vssl_aibcr3aux), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(vcc_aibcr3aux), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(vcc_aibcr3aux), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(vssl_aibcr3aux), .ilaunch_clk_in1(vssl_aibcr3aux),
     .ilpbk_dat_in0(vssl_aibcr3aux), .ilpbk_dat_in1(vssl_aibcr3aux),
     .ilpbk_en_in0(vssl_aibcr3aux), .ilpbk_en_in1(vssl_aibcr3aux),
     .indrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .irxen_in0(csr_cndn_rxen_int[2:0]), .irxen_in1({vssl_aibcr3aux,
     vssl_aibcr3aux, vssl_aibcr3aux}), .istrbclk_in0(strbclk[14]),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(vssl_aibcr3aux),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0129), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(vssl_aibcr3aux),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0167), .odat1_aib(net0128),
     .jtag_rx_scan_out(jtag_rx_scan_out_01x4), .odat0_aib(net0127),
     .oclk_aib(net0125), .last_bs_out(last_bs_out_01x4),
     .oclkb_aib(net0126), .jtag_clkdr_in(jtag_clkdr3l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_01x4),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_01x4), .iopad(iopad_cndn[15]),
     .oclkn(net0124), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xclkn ( .idata1_in1_jtag_out(net0195),
     .idata0_in1_jtag_out(net0194), .async_dat_in1_jtag_out(net0196),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net0160),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0219), .oclk_out(net0266), .oclkb_out(net0346),
     .odat0_out(net0308), .odat1_out(net0310),
     .odat_async_out(oclk_clkp), .pd_data_out(net0314),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(vssl_aibcr3aux), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(vssl_aibcr3aux), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(vssl_aibcr3aux), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(vcc_aibcr3aux), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(vcc_aibcr3aux), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(vssl_aibcr3aux), .ilaunch_clk_in1(vssl_aibcr3aux),
     .ilpbk_dat_in0(vssl_aibcr3aux), .ilpbk_dat_in1(vssl_aibcr3aux),
     .ilpbk_en_in0(vssl_aibcr3aux), .ilpbk_en_in1(vssl_aibcr3aux),
     .indrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .irxen_in0(csr_cndn_cken_int[2:0]), .irxen_in1({vssl_aibcr3aux,
     vssl_aibcr3aux, vssl_aibcr3aux}), .istrbclk_in0(vssl_aibcr3aux),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(vssl_aibcr3aux),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0217), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(vssl_aibcr3aux),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0159), .odat1_aib(net0216),
     .jtag_rx_scan_out(jtag_rx_scan_in_05x3), .odat0_aib(net0214),
     .oclk_aib(net0210), .last_bs_out(last_bs_in_05x3),
     .oclkb_aib(net0212), .jtag_clkdr_in(jtag_clkdr4l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_06x3),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_06x3), .iopad(iopad_cndn_clkp),
     .oclkn(net0208), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xdn_16_17 ( .idata1_in1_jtag_out(net0569),
     .idata0_in1_jtag_out(net0516), .async_dat_in1_jtag_out(net0494),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net0173),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0758), .oclk_out(net0465), .oclkb_out(net0466),
     .odat0_out(cndn[18]), .odat1_out(cndn[19]),
     .odat_async_out(net0469), .pd_data_out(net0470),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(strbclk[8]), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(vssl_aibcr3aux), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(vssl_aibcr3aux), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(vcc_aibcr3aux), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(vcc_aibcr3aux), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(vssl_aibcr3aux), .ilaunch_clk_in1(vssl_aibcr3aux),
     .ilpbk_dat_in0(vssl_aibcr3aux), .ilpbk_dat_in1(vssl_aibcr3aux),
     .ilpbk_en_in0(vssl_aibcr3aux), .ilpbk_en_in1(vssl_aibcr3aux),
     .indrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .irxen_in0(csr_cndn_rxen_int[2:0]), .irxen_in1({vssl_aibcr3aux,
     vssl_aibcr3aux, vssl_aibcr3aux}), .istrbclk_in0(strbclk[8]),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(vssl_aibcr3aux),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0476), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(vssl_aibcr3aux),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0174), .odat1_aib(net0475),
     .jtag_rx_scan_out(jtag_rx_scan_in_03x4), .odat0_aib(net0474),
     .oclk_aib(net0769), .last_bs_out(last_bs_in_03x4),
     .oclkb_aib(net0473), .jtag_clkdr_in(jtag_clkdr3l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_04x4),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_04x4), .iopad(iopad_cndn[9]),
     .oclkn(net0471), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xdn_06_07 ( .idata1_in1_jtag_out(net0189),
     .idata0_in1_jtag_out(net0188), .async_dat_in1_jtag_out(net0190),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net0164),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0568), .oclk_out(net0556), .oclkb_out(net0557),
     .odat0_out(cndn[4]), .odat1_out(cndn[5]),
     .odat_async_out(net0560), .pd_data_out(net0561),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(strbclk[3]), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(vssl_aibcr3aux), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(vssl_aibcr3aux), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(vcc_aibcr3aux), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(vcc_aibcr3aux), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(vssl_aibcr3aux), .ilaunch_clk_in1(vssl_aibcr3aux),
     .ilpbk_dat_in0(vssl_aibcr3aux), .ilpbk_dat_in1(vssl_aibcr3aux),
     .ilpbk_en_in0(vssl_aibcr3aux), .ilpbk_en_in1(vssl_aibcr3aux),
     .indrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .irxen_in0(csr_cndn_rxen_int[2:0]), .irxen_in1({vssl_aibcr3aux,
     vssl_aibcr3aux, vssl_aibcr3aux}), .istrbclk_in0(strbclk[3]),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(vssl_aibcr3aux),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0567), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(vssl_aibcr3aux),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0163), .odat1_aib(net0566),
     .jtag_rx_scan_out(jtag_rx_scan_in_07x3), .odat0_aib(net0565),
     .oclk_aib(net0753), .last_bs_out(last_bs_in_07x3),
     .oclkb_aib(net0564), .jtag_clkdr_in(jtag_clkdr4r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_08x3),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_08x3), .iopad(iopad_cndn[2]),
     .oclkn(net0562), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xdn_00_01 ( .idata1_in1_jtag_out(net0522),
     .idata0_in1_jtag_out(net0213), .async_dat_in1_jtag_out(net0601),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net0184),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0158), .oclk_out(net0468), .oclkb_out(net0587),
     .odat0_out(cndn[2]), .odat1_out(cndn[3]),
     .odat_async_out(net0490), .pd_data_out(net0592),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(strbclk[0]), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(vssl_aibcr3aux), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(vssl_aibcr3aux), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(vcc_aibcr3aux), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(vcc_aibcr3aux), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(vssl_aibcr3aux), .ilaunch_clk_in1(vssl_aibcr3aux),
     .ilpbk_dat_in0(vssl_aibcr3aux), .ilpbk_dat_in1(vssl_aibcr3aux),
     .ilpbk_en_in0(vssl_aibcr3aux), .ilpbk_en_in1(vssl_aibcr3aux),
     .indrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .irxen_in0(csr_cndn_rxen_int[2:0]), .irxen_in1({vssl_aibcr3aux,
     vssl_aibcr3aux, vssl_aibcr3aux}), .istrbclk_in0(strbclk[0]),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(vssl_aibcr3aux),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0155), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(vssl_aibcr3aux),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0183), .odat1_aib(net0154),
     .jtag_rx_scan_out(net0357), .odat0_aib(net0152),
     .oclk_aib(net0148), .last_bs_out(net0353), .oclkb_aib(net0150),
     .jtag_clkdr_in(jtag_clkdr3r), .jtag_mode_in(jtag_mode_in),
     .jtag_rstb(jtag_rstb), .jtag_tx_scan_in(jtag_tx_scan_in_09x4),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_09x4), .iopad(iopad_cndn[1]),
     .oclkn(net0146), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xdn_18_19 ( .idata1_in1_jtag_out(net0201),
     .idata0_in1_jtag_out(net0200), .async_dat_in1_jtag_out(net0202),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net0156),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0752), .oclk_out(net0478), .oclkb_out(net0479),
     .odat0_out(cndn[16]), .odat1_out(cndn[17]),
     .odat_async_out(net0482), .pd_data_out(net0754),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(strbclk[9]), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(vssl_aibcr3aux), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(vssl_aibcr3aux), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(vcc_aibcr3aux), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(vcc_aibcr3aux), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(vssl_aibcr3aux), .ilaunch_clk_in1(vssl_aibcr3aux),
     .ilpbk_dat_in0(vssl_aibcr3aux), .ilpbk_dat_in1(vssl_aibcr3aux),
     .ilpbk_en_in0(vssl_aibcr3aux), .ilpbk_en_in1(vssl_aibcr3aux),
     .indrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .irxen_in0(csr_cndn_rxen_int[2:0]), .irxen_in1({vssl_aibcr3aux,
     vssl_aibcr3aux, vssl_aibcr3aux}), .istrbclk_in0(strbclk[9]),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(vssl_aibcr3aux),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0489), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(vssl_aibcr3aux),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0403), .odat1_aib(net0765),
     .jtag_rx_scan_out(jtag_rx_scan_in_03x3), .odat0_aib(net0487),
     .oclk_aib(net0485), .last_bs_out(last_bs_in_03x3),
     .oclkb_aib(net0486), .jtag_clkdr_in(jtag_clkdr4l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_04x3),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_04x3), .iopad(iopad_cndn[8]),
     .oclkn(net0484), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xclkp ( .idata1_in1_jtag_out(net0600),
     .idata0_in1_jtag_out(net0611), .async_dat_in1_jtag_out(net0571),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net0177),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0143), .oclk_out(net0240), .oclkb_out(net0242),
     .odat0_out(net0495), .odat1_out(net0540),
     .odat_async_out(oclk_clkn), .pd_data_out(net0513),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(vssl_aibcr3aux), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(vssl_aibcr3aux), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(vssl_aibcr3aux), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(vcc_aibcr3aux), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(vcc_aibcr3aux), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(vssl_aibcr3aux), .ilaunch_clk_in1(vssl_aibcr3aux),
     .ilpbk_dat_in0(vssl_aibcr3aux), .ilpbk_dat_in1(vssl_aibcr3aux),
     .ilpbk_en_in0(vssl_aibcr3aux), .ilpbk_en_in1(vssl_aibcr3aux),
     .indrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .irxen_in0(csr_cndn_cken_int[2:0]), .irxen_in1({vssl_aibcr3aux,
     vssl_aibcr3aux, vssl_aibcr3aux}), .istrbclk_in0(vssl_aibcr3aux),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(vssl_aibcr3aux),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0141), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(vssl_aibcr3aux),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0178), .odat1_aib(net0139),
     .jtag_rx_scan_out(jtag_rx_scan_in_05x4), .odat0_aib(net0137),
     .oclk_aib(net0133), .last_bs_out(last_bs_in_05x4),
     .oclkb_aib(net0135), .jtag_clkdr_in(jtag_clkdr3l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_06x4),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_06x4), .iopad(iopad_cndn_clkn),
     .oclkn(net0131), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xdn_10_11 ( .idata1_in1_jtag_out(net0192),
     .idata0_in1_jtag_out(net0193), .async_dat_in1_jtag_out(net0191),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net0161),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0542), .oclk_out(net0530), .oclkb_out(net0531),
     .odat0_out(cndn[8]), .odat1_out(cndn[9]),
     .odat_async_out(net0534), .pd_data_out(net0535),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(strbclk[5]), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(vssl_aibcr3aux), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(vssl_aibcr3aux), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(vcc_aibcr3aux), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(vcc_aibcr3aux), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(vssl_aibcr3aux), .ilaunch_clk_in1(vssl_aibcr3aux),
     .ilpbk_dat_in0(vssl_aibcr3aux), .ilpbk_dat_in1(vssl_aibcr3aux),
     .ilpbk_en_in0(vssl_aibcr3aux), .ilpbk_en_in1(vssl_aibcr3aux),
     .indrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .irxen_in0(csr_cndn_rxen_int[2:0]), .irxen_in1({vssl_aibcr3aux,
     vssl_aibcr3aux, vssl_aibcr3aux}), .istrbclk_in0(strbclk[5]),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(vssl_aibcr3aux),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0541), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(vssl_aibcr3aux),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0162), .odat1_aib(net0770),
     .jtag_rx_scan_out(jtag_rx_scan_in_06x3), .odat0_aib(net0539),
     .oclk_aib(net0537), .last_bs_out(last_bs_in_06x3),
     .oclkb_aib(net0538), .jtag_clkdr_in(jtag_clkdr4r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_07x3),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_07x3), .iopad(iopad_cndn[4]),
     .oclkn(net0536), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xdn_22_23 ( .idata1_in1_jtag_out(net0502),
     .idata0_in1_jtag_out(net0591), .async_dat_in1_jtag_out(net0203),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net0153),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0451), .oclk_out(net0439), .oclkb_out(net0767),
     .odat0_out(cndn[20]), .odat1_out(cndn[21]),
     .odat_async_out(net0443), .pd_data_out(net0444),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(strbclk[11]), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(vssl_aibcr3aux), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(vssl_aibcr3aux), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(vcc_aibcr3aux), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(vcc_aibcr3aux), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(vssl_aibcr3aux), .ilaunch_clk_in1(vssl_aibcr3aux),
     .ilpbk_dat_in0(vssl_aibcr3aux), .ilpbk_dat_in1(vssl_aibcr3aux),
     .ilpbk_en_in0(vssl_aibcr3aux), .ilpbk_en_in1(vssl_aibcr3aux),
     .indrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .irxen_in0(csr_cndn_rxen_int[2:0]), .irxen_in1({vssl_aibcr3aux,
     vssl_aibcr3aux, vssl_aibcr3aux}), .istrbclk_in0(strbclk[11]),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(vssl_aibcr3aux),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0450), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(vssl_aibcr3aux),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0409), .odat1_aib(net0449),
     .jtag_rx_scan_out(jtag_rx_scan_in_02x3), .odat0_aib(net0448),
     .oclk_aib(net0446), .last_bs_out(last_bs_in_02x3),
     .oclkb_aib(net0447), .jtag_clkdr_in(jtag_clkdr4l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_03x3),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_03x3), .iopad(iopad_cndn[10]),
     .oclkn(net0445), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xdn_30_31 ( .idata1_in1_jtag_out(net0607),
     .idata0_in1_jtag_out(net0593), .async_dat_in1_jtag_out(net0546),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net0149),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0123), .oclk_out(net0477), .oclkb_out(net0472),
     .odat0_out(cndn[28]), .odat1_out(cndn[29]),
     .odat_async_out(net0415), .pd_data_out(net0464),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(strbclk[15]), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(vssl_aibcr3aux), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(vssl_aibcr3aux), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(vcc_aibcr3aux), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(vcc_aibcr3aux), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(vssl_aibcr3aux), .ilaunch_clk_in1(vssl_aibcr3aux),
     .ilpbk_dat_in0(vssl_aibcr3aux), .ilpbk_dat_in1(vssl_aibcr3aux),
     .ilpbk_en_in0(vssl_aibcr3aux), .ilpbk_en_in1(vssl_aibcr3aux),
     .indrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .irxen_in0(csr_cndn_rxen_int[2:0]), .irxen_in1({vssl_aibcr3aux,
     vssl_aibcr3aux, vssl_aibcr3aux}), .istrbclk_in0(strbclk[15]),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(vssl_aibcr3aux),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0122), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(vssl_aibcr3aux),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0408), .odat1_aib(net0121),
     .jtag_rx_scan_out(jtag_rx_scan_out_01x3), .odat0_aib(net0120),
     .oclk_aib(net0118), .last_bs_out(last_bs_out_01x3),
     .oclkb_aib(net0119), .jtag_clkdr_in(jtag_clkdr4l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_01x3),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_01x3), .iopad(iopad_cndn[14]),
     .oclkn(net0117), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xdn_26_27 ( .idata1_in1_jtag_out(net0602),
     .idata0_in1_jtag_out(net0605), .async_dat_in1_jtag_out(net0613),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net0407),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0576), .oclk_out(net0204), .oclkb_out(net0205),
     .odat0_out(cndn[24]), .odat1_out(cndn[25]),
     .odat_async_out(net0215), .pd_data_out(net0580),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(strbclk[13]), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(vssl_aibcr3aux), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(vssl_aibcr3aux), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(vcc_aibcr3aux), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(vcc_aibcr3aux), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(vssl_aibcr3aux), .ilaunch_clk_in1(vssl_aibcr3aux),
     .ilpbk_dat_in0(vssl_aibcr3aux), .ilpbk_dat_in1(vssl_aibcr3aux),
     .ilpbk_en_in0(vssl_aibcr3aux), .ilpbk_en_in1(vssl_aibcr3aux),
     .indrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .irxen_in0(csr_cndn_rxen_int[2:0]), .irxen_in1({vssl_aibcr3aux,
     vssl_aibcr3aux, vssl_aibcr3aux}), .istrbclk_in0(strbclk[13]),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(vssl_aibcr3aux),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0211), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(vssl_aibcr3aux),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0151), .odat1_aib(net0563),
     .jtag_rx_scan_out(jtag_rx_scan_in_01x3), .odat0_aib(net0209),
     .oclk_aib(net0207), .last_bs_out(last_bs_in_01x3),
     .oclkb_aib(net0582), .jtag_clkdr_in(jtag_clkdr4l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_02x3),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_02x3), .iopad(iopad_cndn[12]),
     .oclkn(net0206), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xdn_24_25 ( .idata1_in1_jtag_out(net0606),
     .idata0_in1_jtag_out(net0234), .async_dat_in1_jtag_out(net0235),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net0169),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0583), .oclk_out(net0585), .oclkb_out(net0218),
     .odat0_out(cndn[26]), .odat1_out(cndn[27]),
     .odat_async_out(net0574), .pd_data_out(net0222),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(strbclk[12]), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(vssl_aibcr3aux), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(vssl_aibcr3aux), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(vcc_aibcr3aux), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(vcc_aibcr3aux), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(vssl_aibcr3aux), .ilaunch_clk_in1(vssl_aibcr3aux),
     .ilpbk_dat_in0(vssl_aibcr3aux), .ilpbk_dat_in1(vssl_aibcr3aux),
     .ilpbk_en_in0(vssl_aibcr3aux), .ilpbk_en_in1(vssl_aibcr3aux),
     .indrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .irxen_in0(csr_cndn_rxen_int[2:0]), .irxen_in1({vssl_aibcr3aux,
     vssl_aibcr3aux, vssl_aibcr3aux}), .istrbclk_in0(strbclk[12]),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(vssl_aibcr3aux),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0228), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(vssl_aibcr3aux),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0170), .odat1_aib(net0590),
     .jtag_rx_scan_out(jtag_rx_scan_in_01x4), .odat0_aib(net0226),
     .oclk_aib(net0224), .last_bs_out(last_bs_in_01x4),
     .oclkb_aib(net0581), .jtag_clkdr_in(jtag_clkdr3l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_02x4),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_02x4), .iopad(iopad_cndn[13]),
     .oclkn(net0577), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xdn_08_09 ( .idata1_in1_jtag_out(net0220),
     .idata0_in1_jtag_out(net0575), .async_dat_in1_jtag_out(net0507),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net0180),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0529), .oclk_out(net0517), .oclkb_out(net0518),
     .odat0_out(cndn[10]), .odat1_out(cndn[11]),
     .odat_async_out(net0521), .pd_data_out(net0761),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(strbclk[4]), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(vssl_aibcr3aux), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(vssl_aibcr3aux), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(vcc_aibcr3aux), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(vcc_aibcr3aux), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(vssl_aibcr3aux), .ilaunch_clk_in1(vssl_aibcr3aux),
     .ilpbk_dat_in0(vssl_aibcr3aux), .ilpbk_dat_in1(vssl_aibcr3aux),
     .ilpbk_en_in0(vssl_aibcr3aux), .ilpbk_en_in1(vssl_aibcr3aux),
     .indrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .irxen_in0(csr_cndn_rxen_int[2:0]), .irxen_in1({vssl_aibcr3aux,
     vssl_aibcr3aux, vssl_aibcr3aux}), .istrbclk_in0(strbclk[4]),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(vssl_aibcr3aux),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0528), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(vssl_aibcr3aux),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0179), .odat1_aib(net0527),
     .jtag_rx_scan_out(jtag_rx_scan_in_06x4), .odat0_aib(net0526),
     .oclk_aib(net0524), .last_bs_out(last_bs_in_06x4),
     .oclkb_aib(net0525), .jtag_clkdr_in(jtag_clkdr3r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_07x4),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_07x4), .iopad(iopad_cndn[5]),
     .oclkn(net0523), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top  xdn_12_13 ( .idata1_in1_jtag_out(net0612),
     .idata0_in1_jtag_out(net0609), .async_dat_in1_jtag_out(net0610),
     .prev_io_shift_en(vssl_aibcr3aux), .jtag_clkdr_outn(net0176),
     .vssl(vssl_aibcr3aux), .vccl(vccl_aibcr3aux), .vcc(vcc_aibcr3aux),
     .por_aib_vccl(por_vccl), .por_aib_vcchssi(por_vcchssi),
     .jtag_clksel(jtag_clksel), .jtag_intest(jtag_intest),
     .jtag_rstb_en(jtag_rstb_en), .anlg_rstb(anlg_rstb),
     .pd_data_aib(net0503), .oclk_out(net0491), .oclkb_out(net0492),
     .odat0_out(cndn[14]), .odat1_out(cndn[15]),
     .odat_async_out(net0757), .pd_data_out(net0496),
     .async_dat_in0(vssl_aibcr3aux), .async_dat_in1(vssl_aibcr3aux),
     .iclkin_dist_in0(strbclk[6]), .iclkin_dist_in1(vssl_aibcr3aux),
     .idata0_in0(vssl_aibcr3aux), .idata0_in1(vssl_aibcr3aux),
     .idata1_in0(vssl_aibcr3aux), .idata1_in1(vssl_aibcr3aux),
     .idataselb_in0(vcc_aibcr3aux), .idataselb_in1(vssl_aibcr3aux),
     .iddren_in0(vcc_aibcr3aux), .iddren_in1(vssl_aibcr3aux),
     .ilaunch_clk_in0(vssl_aibcr3aux), .ilaunch_clk_in1(vssl_aibcr3aux),
     .ilpbk_dat_in0(vssl_aibcr3aux), .ilpbk_dat_in1(vssl_aibcr3aux),
     .ilpbk_en_in0(vssl_aibcr3aux), .ilpbk_en_in1(vssl_aibcr3aux),
     .indrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .indrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in0({vssl_aibcr3aux, vssl_aibcr3aux}),
     .ipdrv_in1({vssl_aibcr3aux, vssl_aibcr3aux}),
     .irxen_in0(csr_cndn_rxen_int[2:0]), .irxen_in1({vssl_aibcr3aux,
     vssl_aibcr3aux, vssl_aibcr3aux}), .istrbclk_in0(strbclk[6]),
     .istrbclk_in1(vssl_aibcr3aux), .itxen_in0(vssl_aibcr3aux),
     .itxen_in1(vssl_aibcr3aux), .oclk_in1(vssl_aibcr3aux),
     .odat_async_aib(net0766), .oclkb_in1(vssl_aibcr3aux),
     .odat0_in1(vssl_aibcr3aux), .odat1_in1(vssl_aibcr3aux),
     .odat_async_in1(vssl_aibcr3aux), .shift_en(vssl_aibcr3aux),
     .pd_data_in1(vssl_aibcr3aux), .dig_rstb(dig_rstb),
     .jtag_clkdr_out(net0175), .odat1_aib(net0501),
     .jtag_rx_scan_out(jtag_rx_scan_in_04x4), .odat0_aib(net0500),
     .oclk_aib(net0498), .last_bs_out(last_bs_in_04x4),
     .oclkb_aib(net0499), .jtag_clkdr_in(jtag_clkdr3l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_in_05x4),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .last_bs_in(last_bs_in_05x4), .iopad(iopad_cndn[7]),
     .oclkn(net0497), .iclkn(vssl_aibcr3aux), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
assign csr_dly_ovrd_int[3:0] = csr_iocsr_sel ? csr_dly_ovrd[3:0] : {vssl_aibcr3aux,     vssl_aibcr3aux, vssl_aibcr3aux, vcc_aibcr3aux};
assign csr_cndn_rxen_int[2:0] = csr_iocsr_sel ? csr_cndn_rxen[2:0] : {vssl_aibcr3aux, vssl_aibcr3aux, vcc_aibcr3aux};
assign csr_cndn_cken_int[2:0] = csr_iocsr_sel ? csr_cndn_cken[2:0] : vssl_aibcr3aux;

endmodule
