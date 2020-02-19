// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3_lib, Cell - aibcr3_avmm1, View - schematic
// LAST TIME SAVED: Jul  8 14:51:50 2015
// NETLIST TIME: Jul  9 10:52:18 2015
// `timescale 1ns / 1ns 

module aibcr3_avmm1 ( avmm1_odat0, avmm1_odat1, avmm2_rx_distclk_l0,
     avmm2_rx_distclk_l1, avmm2_tx_launch_clk_l6, iclkin_dist_ssrdin,
     iclkin_dist_ssrldin, iclkin_dist_vinp00, iclkin_dist_vinp01,
     idata0_srcclkoutn, idata0_voutp0, idata1_srcclkoutn,
     idata1_voutp0, idataselb_srcclkoutn, idataselb_voutp0,
     ilaunch_clk_voutp0, ilaunch_clk_voutp1, irxen_ssrdin,
     irxen_ssrldin, irxen_vinp00, irxen_vinp01, istrbclk_ssrdin,
     istrbclk_ssrldin, istrbclk_vinp00, istrbclk_vinp01,
     itxen_srcclkoutn, itxen_voutp0, jtag_clkdr_srcclkoutn,
     jtag_clkdr_ssrdin, jtag_clkdr_ssrldin, jtag_clkdr_vinp00,
     jtag_clkdr_vinp01, jtag_clkdr_voutp0, jtag_rx_scan_srcclkoutn,
     jtag_rx_scan_ssrdin, jtag_rx_scan_ssrldin, jtag_rx_scan_vinp00,
     jtag_rx_scan_vinp01, jtag_rx_scan_voutp0, odat0_aib_vinp00,
     odat0_aib_vinp01, odat1_aib_vinp00, odat1_aib_vinp01,
     odat_async_fsrldout, osdrin_odat0, osdrin_odat1, pcs_clk,
     pcs_clkb, shift_en_srcclkoutn, shift_en_ssrdin, shift_en_ssrldin,
     shift_en_vinp00, shift_en_vinp01, shift_en_voutp0, iopad_avmm1_in,
     iopad_avmm1_out, iopad_clkn, iopad_clkp, iopad_inclkn,
     iopad_inclkp, iopad_sdr_in, iopad_sdr_out, vcc, vccl, vssl,
     async_dat_oshared4, avmm1_idat0, avmm1_idat1, avmm1_rstb,
     avmm_tx_clk_in, clkdr_xr5l, clkdr_xr5r, clkdr_xr6l, clkdr_xr6r,
     clkdr_xr7l, clkdr_xr7r, clkdr_xr8l, clkdr_xr8r, idat0_clkn,
     idat0_clkp, idat1_clkn, idat1_clkp, idata0_ptxclkout,
     idata0_ptxclkoutn, idata1_ptxclkout, idata1_ptxclkoutn, idataselb,
     idataselb_oshared4, idataselb_ptxclkout, idataselb_ptxclkoutn,
     ilaunch_clk_ptxclkout, ilaunch_clk_ptxclkoutn, indrv_ptxclkout,
     indrv_ptxclkoutn, indrv_r78, ipdrv_ptxclkout, ipdrv_ptxclkoutn,
     ipdrv_r78, irxen_inpshared2, irxen_r0, irxen_r1, irxen_r2,
     irxen_vinp10, irxen_vinp11, isdrin_idat0, isdrin_idat1, itxen,
     itxen_oshared4, itxen_ptxclkout, itxen_ptxclkoutn,
     jtag_clkdr_inpshared2, jtag_clkdr_oshared4, jtag_clkdr_ptxclkout,
     jtag_clkdr_ptxclkoutn, jtag_clkdr_vinp10, jtag_clkdr_vinp11,
     jtag_clksel, jtag_intest, jtag_mode_in, jtag_rstb, jtag_rstb_en,
     jtag_rx_scan_inpshared2, jtag_rx_scan_oshared4,
     jtag_rx_scan_ptxclkout, jtag_rx_scan_ptxclkoutn,
     jtag_rx_scan_vinp10, jtag_rx_scan_vinp11, jtag_tx_scanen_in,
     jtag_weakpdn, jtag_weakpu, odat0_oshared2, odat0_oshared3,
     odat0_ptxclkout, odat0_ptxclkoutn, odat1_oshared2, odat1_oshared3,
     odat1_ptxclkout, odat1_ptxclkoutn, por_aib_vcchssi, por_aib_vccl,
     rx_shift_en, shift_en_inpshared2, shift_en_oshared4,
     shift_en_ptxclkout, shift_en_ptxclkoutn, shift_en_vinp10,
     shift_en_vinp11 );

output  avmm2_rx_distclk_l0, avmm2_rx_distclk_l1,
     avmm2_tx_launch_clk_l6, iclkin_dist_ssrdin, iclkin_dist_ssrldin,
     iclkin_dist_vinp00, iclkin_dist_vinp01, idata0_srcclkoutn,
     idata0_voutp0, idata1_srcclkoutn, idata1_voutp0,
     idataselb_srcclkoutn, idataselb_voutp0, ilaunch_clk_voutp0,
     ilaunch_clk_voutp1, istrbclk_ssrdin, istrbclk_ssrldin,
     istrbclk_vinp00, istrbclk_vinp01, itxen_srcclkoutn, itxen_voutp0,
     jtag_clkdr_srcclkoutn, jtag_clkdr_ssrdin, jtag_clkdr_ssrldin,
     jtag_clkdr_vinp00, jtag_clkdr_vinp01, jtag_clkdr_voutp0,
     jtag_rx_scan_srcclkoutn, jtag_rx_scan_ssrdin,
     jtag_rx_scan_ssrldin, jtag_rx_scan_vinp00, jtag_rx_scan_vinp01,
     jtag_rx_scan_voutp0, odat0_aib_vinp00, odat0_aib_vinp01,
     odat1_aib_vinp00, odat1_aib_vinp01, odat_async_fsrldout, pcs_clk,
     pcs_clkb, shift_en_srcclkoutn, shift_en_ssrdin, shift_en_ssrldin,
     shift_en_vinp00, shift_en_vinp01, shift_en_voutp0;

inout  iopad_avmm1_out, iopad_clkn, iopad_clkp, iopad_inclkn,
     iopad_inclkp, vcc, vccl, vssl;

input  async_dat_oshared4, avmm1_idat0, avmm1_idat1, avmm1_rstb,
     avmm_tx_clk_in, clkdr_xr5l, clkdr_xr5r, clkdr_xr6l, clkdr_xr6r,
     clkdr_xr7l, clkdr_xr7r, clkdr_xr8l, clkdr_xr8r, idat0_clkn,
     idat0_clkp, idat1_clkn, idat1_clkp, idata0_ptxclkout,
     idata0_ptxclkoutn, idata1_ptxclkout, idata1_ptxclkoutn,
     idataselb_oshared4, idataselb_ptxclkout, idataselb_ptxclkoutn,
     ilaunch_clk_ptxclkout, ilaunch_clk_ptxclkoutn, itxen_oshared4,
     itxen_ptxclkout, itxen_ptxclkoutn, jtag_clkdr_inpshared2,
     jtag_clkdr_oshared4, jtag_clkdr_ptxclkout, jtag_clkdr_ptxclkoutn,
     jtag_clkdr_vinp10, jtag_clkdr_vinp11, jtag_clksel, jtag_intest,
     jtag_mode_in, jtag_rstb, jtag_rstb_en, jtag_rx_scan_inpshared2,
     jtag_rx_scan_oshared4, jtag_rx_scan_ptxclkout,
     jtag_rx_scan_ptxclkoutn, jtag_rx_scan_vinp10, jtag_rx_scan_vinp11,
     jtag_tx_scanen_in, jtag_weakpdn, jtag_weakpu, odat0_oshared2,
     odat0_oshared3, odat0_ptxclkout, odat0_ptxclkoutn, odat1_oshared2,
     odat1_oshared3, odat1_ptxclkout, odat1_ptxclkoutn,
     por_aib_vcchssi, por_aib_vccl, shift_en_inpshared2,
     shift_en_oshared4, shift_en_ptxclkout, shift_en_ptxclkoutn,
     shift_en_vinp10, shift_en_vinp11;

output [2:0]  irxen_vinp00;
output [2:0]  irxen_ssrldin;
output [2:0]  irxen_ssrdin;
output [2:0]  irxen_vinp01;
output [3:0]  osdrin_odat0;
output [1:0]  avmm1_odat0;
output [3:0]  osdrin_odat1;
output [1:0]  avmm1_odat1;

inout [1:0]  iopad_avmm1_in;
inout [3:0]  iopad_sdr_out;
inout [3:0]  iopad_sdr_in;

input [1:0]  ipdrv_ptxclkoutn;
input [1:0]  indrv_ptxclkout;
input [2:0]  irxen_r1;
input [2:0]  irxen_r0;
input [2:0]  irxen_inpshared2;
input [1:0]  ipdrv_r78;
input [1:0]  indrv_r78;
input [1:0]  ipdrv_ptxclkout;
input [2:0]  irxen_vinp11;
input [2:0]  irxen_r2;
input [1:0]  indrv_ptxclkoutn;
input [2:0]  irxen_vinp10;
input [2:0]  itxen;
input [14:0]  rx_shift_en;
input [2:0]  idataselb;
input [3:0]  isdrin_idat1;
input [3:0]  isdrin_idat0;

wire pcs_clkb, pcs_clk;
wire pcs_clk_clktree;
// Buses in the design

wire  [0:7]  tx_launch_clk_l;

wire  [0:7]  tx_launch_clk_r;

wire  [0:7]  rx_distclk_l;

wire  [0:7]  rx_distclk_r;

wire jtag_clkdr_outn_srcclkinn;
wire ncdrx_pd_data_out0_txclkn;
wire ncdrx_oclk_rxclkn;
wire ncdrx_oclkb_rxclkn;
wire ncdrx_odat0_rxclkn;
wire ncdrx_odat1_rxclkn;
wire ncdrx_odat_async_rxclkn;
wire ncdrx_pd_data_rxclkn;
wire ncdrx_odat_async_out0_txclkn;
wire jtag_clkdr_srcclkinn;
wire ncdrx_odat1_out0_txclkn;
wire jtag_rx_scan_srcclkinn;
wire ncdrx_odat0_out0_txclkn;
wire ncdrx_oclk_out0_txclkn;
wire last_bs_out_dirout3;
wire ncdrx_oclkb_out0_txclkn;
wire oclkn_inclkn;
wire jtag_clkdr_outn_vinp01;
wire nc_pd_data_avmout01;
wire nc_oclk_avmin1;
wire nc_oclkb_avmin1;
wire nc_odat_async_avmin1;
wire nc_pd_data_avmin1;
wire nc_odat_async_avmout01;
wire nc_oclk_avmout01;
wire nc_last_bs_out_vinp01;
wire nc_oclkb_avmout01;
wire nc_oclkn_avmout01;
wire jtag_clkdr_outn_fsrldin;
wire nc_pd0_data_fsdrin;
wire nc_oclk_fsrldin;
wire nc_oclkb_fsrldin;
wire nc_odat_async_fsrldin;
wire nc_pd_data_fsrldin;
wire nc_odat_async_aib_fsrldin;
wire ossrldin_odat0;
wire ossrldin_odat1;
wire jtag_clkdr_out_fsrldin;
wire nc_odat1_aib_fsrldin;
wire jtag_rx_scan_out_fsrldin;
wire nc_odat0_aib_fsrldin;
wire nc_oclk_out0_fsrldin;
wire last_bs_out_fsrldin;
wire nc_oclkb_out0_fsrldin;
wire oclkn_fsrldin;
wire jtag_clkdr_outn_ssrldin;
wire nc_pd_data_out0_ssrldin;
wire nc_oclk_ssrldin;
wire nc_oclkb_ssrldin;
wire nc_odat_async_ssrldin;
wire nc_pd_data_ssrldin;
wire nc_odat_async_out0_ssrldin;
wire nc_oclk_out0_ssrldin;
wire last_bs_out_ssrldin;
wire nc_oclkb_out0_ssrldin;
wire nc_oclkn_out0_ssrldin;
wire jtag_clkdr_outn_srcclkoutn;
wire pd_data_srcclkoutn;
wire oclk_outclkn;
wire oclk_outclknb;
wire ncdrx_odat0_outclkn;
wire ncdrx_odat1_outclkn;
wire odirectin_data_outclkn;
wire pd_data_outclkn;
wire odirectin_data_srcclkoutn;
wire ncdrx_odat1_srcclkoutn;
wire ncdrx_odat0_srcclkoutn;
wire nc_oclk_srcclkoutn;
wire nc;
wire nc_oclkb_srcclkoutn;
wire jtag_rx_scan_ssrldout;
wire nc_oclkn_srcclkoutn;
wire jtag_clkdr_outn_srcclkin;
wire ncdrx_pd_data_out0_txclkp;
wire oclk_inclkp;
wire oclk_inclkpb;
wire ncdrx_odat0_rxclkp1;
wire ncdrx_odat1_rxclkp1;
wire ncdrx_odat_async_rxclkp1;
wire ncdrx_pd_data_rxclkp1;
wire oclk_aib_fsdrin;
wire ncdrx_odat_async_out0_txclkp;
wire oclkb_aib_fsdrin;
wire jtag_clkdr_srcclkin;
wire ncdrx_odat1_out0_txclkp;
wire jtag_rx_scan_srcclkin;
wire ncdrx_odat0_out0_txclkp;
wire ncdrx_oclk_out0_txclkp;
wire last_bs_out_directin0;
wire ncdrx_oclkb_out0_txclkp;
wire ncdrx_oclkn_txclkp;
wire jtag_clkdr_outn_fsrldout;
wire nc_pd_data_aib_fsrldout;
wire nc_oclk_fsrldout;
wire nc_oclkb_fsrldout;
wire nc_odat0_fsrldout;
wire nc_odat1_fsrldout;
wire nc_odat_async_fsrldout;
wire nc_pd_data_fsrldout;
wire jtag_clkdr_out_fsrldout;
wire nc_odat1_aib_fsrldout;
wire jtag_rx_scan_out_fsrldout;
wire nc_odat0_aib_fsrldout;
wire nc_oclk_aib_fsrldout;
wire last_bs_out_fsrldout;
wire nc_oclkb_aib_fsrldout;
wire nc_oclkn_fsrldout;
wire jtag_clkdr_outn_ssrldout;
wire nc_pd_data_out0_ssrldrout;
wire nc_oclk_ssrldout;
wire nc_oclkb_ssrldout;
wire nc_odat0_ssrldout;
wire nc_odat1_ssrldout;
wire nc_odat_async_ssrldout;
wire nc_pd_data_ssrldout;
wire nc_odat_async_out0_ssrldrout;
wire jtag_clkdr_ssrldout;
wire nc_odat1_out0_ssrldrout;
wire nc_odat0_out0_ssrldrout;
wire nc_oclk_out0_ssrldrout;
wire last_bs_out_ssrldout;
wire nc_oclkb_out0_ssrldrout;
wire nc_oclkn_out0_ssrldrout;
wire jtag_clkdr_outn_fsrdin;
wire nc_pd_data_aib_fsdrin;
wire nc_oclk_fsdrin;
wire nc_oclkb_fsdrin;
wire nc_odat_async_fsdrin;
wire nc_pd_data_fsdrin;
wire nc_odat_async_aib_fsrdin;
wire ossrdin_odat0;
wire ossrdin_odat1;
wire jtag_clkdr_out_fsrdin;
wire nc_odat1_aib_fsdrin;
wire jtag_rx_scan_out_fsrdin;
wire nc_odat0_aib_fsdrin;
wire last_bs_out_fsrdin;
wire nc_oclkn_aib_fsdrin;
wire jtag_clkdr_outn_srcclkout;
wire nc_pd_data_srcclkout;
wire nc_oclk_outclkp;
wire nc_oclk_outclkpb;
wire ncdtx_odat0_outclkp;
wire ncdtx_odat1_outclkp;
wire odirectin_data_outclkp;
wire pd_data_outclkp;
wire odirectin_data_srcclkout;
wire jtag_clkdr_srcclkout;
wire nc_odat1_srcclkout;
wire jtag_rx_scan_srcclkout;
wire nc_odat0_srcclkout;
wire nc_oclk_srcclkout;
wire last_bs_out_srcclkin;
wire nc_oclkb_srcclkout;
wire jtag_rx_scan_ssrdout;
wire nc_oclkn_srcclkout;
wire jtag_clkdr_outn_vinp00;
wire nc_pd_data_avmout0;
wire nc_oclk_avmin011;
wire nc_oclkb_avmin011;
wire nc_odat_async_avmin011;
wire nc_pd_data_avmin011;
wire nc_odat_async_avmout0;
wire nc_oclk_avmout0;
wire last_bs_out_vinp00;
wire nc_oclkb_avmout0;
wire nc_oclkn_avmout0;
wire jtag_clkdr_outn_fsrdout;
wire nc_pd_data_out0_fsrout;
wire nc_oclk_fsrdout;
wire nc_oclkb_fsrdout;
wire nc_odat0_fsrdout;
wire nc_odat1_fsrdout;
wire nc_odat_async_fsrdout;
wire nc_pd_data_fsrdout;
wire nc_odat_async_out0_fsrout;
wire jtag_clkdr_fsrdout;
wire nc_odat1_out0_fsrout;
wire jtag_rx_scan_fsrdout;
wire nc_odat0_out0_fsrout;
wire nc_oclk_out0_fsrout;
wire last_bs_out_fsrdout;
wire nc_oclkb_out0_fsrout;
wire nc_oclkn_out0_fsrout;
wire jtag_clkdr_outn_ssrdin;
wire nc_pd_data_out0_ssrdin;
wire nc_oclk_out0_ssrdin1;
wire nc_oclkb_out0_ssrdin1;
wire nc_odat_async_out0_ssrdin1;
wire nc_pd_data_out0_ssrdin1;
wire nc_odat_async_out0_ssrdin;
wire nc_oclk_out0_ssrdin;
wire last_bs_out_ssrdin;
wire nc_oclkb_out0_ssrdin;
wire nc_oclkn_out0_ssrdin;
wire jtag_clkdr_outn_voutp0;
wire nc_pd_data_out0_rx;
wire nc_oclk_tx;
wire nc_oclkb_tx;
wire nc_odat0_tx;
wire nc_odat1_tx;
wire nc_odat_async_tx;
wire nc_pd_data_tx;
wire nc_odat_async_out0_rx;
wire nc_odat1_out0_tx;
wire nc_odat0_out0_tx;
wire nc_oclk_out0_tx;
wire last_bs_out_voutp0;
wire nc_oclkb_out0_tx;
wire nc_oclkn_out0_tx;
wire jtag_clkdr_outn_ssrdout;
wire nc_pd_data_out0_sdrout;
wire nc_oclk_ssrdout;
wire nc_oclkb_ssrdout;
wire nc_odat0_ssrdout;
wire nc_odat1_ssrdout;
wire nc_odat_async_ssrdout;
wire nc_pd_data_ssrdout;
wire nc_odat_async_out0_sdrout;
wire jtag_clkdr_ssrdout;
wire nc_odat1_out0_ssdrout;
wire nc_odat0_out0_sdrout;
wire nc_oclk_out0_sdrout;
wire last_bs_out_ssrdout;
wire nc_oclkb_out0_ssdrout;
wire nc_oclkn_out0_ssdrout;
wire clk_distclk;
wire nc_clk_mimic11;
wire nc_clk_mimic01;
wire nc_clk_mimic;
wire nc_clk_mimic1;
wire nc_clk_mimic0;
wire nc_clk_rep;
wire pcs_clk_int;
wire nc_idat1_srcclkinn;
wire nc_idat0_srcclkinn;
wire nc_async_dat_srcclkinn;
wire nc_idat1_vinp01;
wire nc_idat0_vinp01;
wire nc_async_dat_vinp01;
wire nc_idat1_fsrldin;
wire nc_idat0_fsrldin;
wire nc_async_dat_fsrldin;
wire nc_idat1_ssrldin;
wire nc_idat0_ssrldin;
wire nc_async_dat_ssrldin;
wire nc_async_dat_srcclkoutn;
wire idat0_ssrldout;
wire idat1_ssrldout;
wire nc_idat1_srcclkin;
wire nc_idat0_srcclkin;
wire nc_async_dat_srcclkin;
wire idat1_fsrldout;
wire idat0_fsrldout;
wire nc_async_dat_fsrldout;
wire nc_async_dat_ssrldout;
wire nc_idat1_fsrdin;
wire nc_idat0_fsrdin;
wire nc_async_dat_fsrdin;
wire idat1_srcclkout;
wire idat0_srcclkout;
wire nc_async_dat_srcclkout;
wire idat0_ssrdout;
wire idat1_ssrdout;
wire nc_idat1_vinp00;
wire nc_idat0_vinp00;
wire nc_async_dat_vinp00;
wire nc_idat1_fsrdout;
wire nc_idat0_fsrdout;
wire nc_async_dat_fsrdout;
wire nc_idat1_ssrdin;
wire nc_idat0_ssrdin;
wire nc_async_dat_ssrdin;
wire nc_async_dat_voutp0;
wire nc_async_dat_ssrdout;
wire avmm_tx_clk_in_dly;

// specify 
//     specparam CDS_LIBNAME  = "aibcr3_lib";
//     specparam CDS_CELLNAME = "aibcr3_avmm1";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

assign pcs_clk_int = pcs_clk_clktree;
aibcr3_aliasd  r8 ( .rb(iclkin_dist_ssrldin), .ra(rx_distclk_r[6]));
aibcr3_aliasd  r6 ( .rb(istrbclk_ssrdin), .ra(rx_distclk_r[7]));
aibcr3_aliasd  r33 ( .rb(shift_en_vinp01), .ra(rx_shift_en[11]));
aibcr3_aliasd  r5[2:0] ( .ra(irxen_r2[2:0]), .rb(irxen_ssrdin[2:0]));
aibcr3_aliasd  r34 ( .rb(shift_en_ssrdin), .ra(rx_shift_en[7]));
aibcr3_aliasd  r10 ( .rb(istrbclk_ssrldin), .ra(rx_distclk_r[6]));
aibcr3_aliasd  r35 ( .rb(shift_en_ssrldin), .ra(rx_shift_en[14]));
aibcr3_aliasd  r19 ( .rb(itxen_srcclkoutn), .ra(itxen[1]));
aibcr3_aliasd  r36 ( .rb(shift_en_srcclkoutn), .ra(rx_shift_en[4]));
aibcr3_aliasd  r32 ( .rb(shift_en_vinp00), .ra(rx_shift_en[10]));
aibcr3_aliasd  r28 ( .rb(istrbclk_vinp00), .ra(rx_distclk_l[7]));
aibcr3_aliasd  r27[2:0] ( .ra(irxen_r0[2:0]), .rb(irxen_vinp00[2:0]));
aibcr3_aliasd  r21 ( .rb(avmm2_rx_distclk_l1), .ra(rx_distclk_l[1]));
aibcr3_aliasd  r9[2:0] ( .ra(irxen_r2[2:0]), .rb(irxen_ssrldin[2:0]));
aibcr3_aliasd  r4 ( .rb(itxen_voutp0), .ra(itxen[0]));
aibcr3_aliasd  r7 ( .rb(iclkin_dist_ssrdin), .ra(rx_distclk_r[7]));
aibcr3_aliasd  r26 ( .rb(iclkin_dist_vinp00), .ra(rx_distclk_l[7]));
aibcr3_aliasd  r25 ( .rb(idataselb_voutp0), .ra(idataselb[0]));
aibcr3_aliasd  r22 ( .rb(avmm2_tx_launch_clk_l6), .ra(tx_launch_clk_l[6]));
aibcr3_aliasd  r37 ( .rb(shift_en_voutp0), .ra(rx_shift_en[3]));
aibcr3_aliasd  r24 ( .rb(idataselb_srcclkoutn), .ra(idataselb[1]));
aibcr3_aliasd  r3 ( .rb(ilaunch_clk_voutp0), .ra(tx_launch_clk_l[3]));
aibcr3_aliasd  r31 ( .rb(iclkin_dist_vinp01), .ra(rx_distclk_l[6]));
aibcr3_aliasd  r30[2:0] ( .ra(irxen_r0[2:0]), .rb(irxen_vinp01[2:0]));
aibcr3_aliasd  r29 ( .rb(istrbclk_vinp01), .ra(rx_distclk_l[6]));
aibcr3_aliasd  r20 ( .rb(avmm2_rx_distclk_l0), .ra(rx_distclk_l[0]));
aibcr3_aliasd  r38 ( .rb(ilaunch_clk_voutp1), .ra(tx_launch_clk_l[2]));
aibcr3_buffx1_top xrx_clkn ( .idata1_in1_jtag_out(nc_idat1_srcclkinn),
     .idata0_in1_jtag_out(nc_idat0_srcclkinn),
     .async_dat_in1_jtag_out(nc_async_dat_srcclkinn),
     .prev_io_shift_en(shift_en_ptxclkoutn),
     .jtag_clkdr_outn(jtag_clkdr_outn_srcclkinn),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .vcc(vcc), .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(avmm1_rstb),
     .pd_data_aib(ncdrx_pd_data_out0_txclkn),
     .oclk_out(ncdrx_oclk_rxclkn), .oclkb_out(ncdrx_oclkb_rxclkn),
     .odat0_out(ncdrx_odat0_rxclkn), .odat1_out(ncdrx_odat1_rxclkn),
     .odat_async_out(ncdrx_odat_async_rxclkn),
     .pd_data_out(ncdrx_pd_data_rxclkn), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(vssl),
     .iclkin_dist_in1(vssl), .idata0_in0(vcc),
     .idata0_in1(idata0_ptxclkoutn), .idata1_in0(vssl),
     .idata1_in1(idata1_ptxclkoutn), .idataselb_in0(vcc),
     .idataselb_in1(idataselb_ptxclkoutn), .iddren_in0(vcc),
     .iddren_in1(vcc), .ilaunch_clk_in0(vssl),
     .ilaunch_clk_in1(ilaunch_clk_ptxclkoutn), .ilpbk_dat_in0(vssl),
     .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl), .ilpbk_en_in1(vssl),
     .indrv_in0({vssl, vssl}), .indrv_in1(indrv_ptxclkoutn[1:0]),
     .ipdrv_in0({vssl, vssl}), .ipdrv_in1(ipdrv_ptxclkoutn[1:0]),
     .irxen_in0({vssl, vcc, vssl}), .irxen_in1({vssl, vcc, vssl}),
     .istrbclk_in0(vssl), .istrbclk_in1(vssl), .itxen_in0(vssl),
     .itxen_in1(itxen_ptxclkoutn), .oclk_in1(vssl),
     .odat_async_aib(ncdrx_odat_async_out0_txclkn), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(vssl), .vccl(vccl), .odat1_in1(vssl),
     .odat_async_in1(vssl), .shift_en(rx_shift_en[12]),
     .pd_data_in1(vssl), .dig_rstb(avmm1_rstb),
     .jtag_clkdr_out(jtag_clkdr_srcclkinn),
     .odat1_aib(ncdrx_odat1_out0_txclkn),
     .jtag_rx_scan_out(jtag_rx_scan_srcclkinn),
     .odat0_aib(ncdrx_odat0_out0_txclkn),
     .oclk_aib(ncdrx_oclk_out0_txclkn),
     .last_bs_out(last_bs_out_dirout3),
     .oclkb_aib(ncdrx_oclkb_out0_txclkn), .jtag_clkdr_in(clkdr_xr6r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_ptxclkoutn),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_inclkn), .oclkn(oclkn_inclkn), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xavmm1_in1 ( .idata1_in1_jtag_out(nc_idat1_vinp01),
     .idata0_in1_jtag_out(nc_idat0_vinp01),
     .async_dat_in1_jtag_out(nc_async_dat_vinp01),
     .prev_io_shift_en(shift_en_vinp11),
     .jtag_clkdr_outn(jtag_clkdr_outn_vinp01),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .vcc(vcc), .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(avmm1_rstb),
     .pd_data_aib(nc_pd_data_avmout01), .oclk_out(nc_oclk_avmin1),
     .oclkb_out(nc_oclkb_avmin1), .odat0_out(avmm1_odat0[1]),
     .odat1_out(avmm1_odat1[1]), .odat_async_out(nc_odat_async_avmin1),
     .pd_data_out(nc_pd_data_avmin1), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(rx_distclk_l[2]),
     .iclkin_dist_in1(rx_distclk_l[2]), .idata0_in0(vssl),
     .idata0_in1(vssl), .idata1_in0(vssl), .idata1_in1(vssl),
     .idataselb_in0(vcc), .idataselb_in1(vssl), .iddren_in0(vssl),
     .iddren_in1(vssl), .ilaunch_clk_in0(vssl), .ilaunch_clk_in1(vssl),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0({vssl, vssl}), .indrv_in1({vssl,
     vssl}), .ipdrv_in0({vssl, vssl}), .ipdrv_in1({vssl, vssl}),
     .irxen_in0(irxen_r0[2:0]), .irxen_in1(irxen_vinp11[2:0]),
     .istrbclk_in0(rx_distclk_l[2]), .istrbclk_in1(rx_distclk_l[2]),
     .itxen_in0(vssl), .itxen_in1(vssl), .oclk_in1(vssl),
     .odat_async_aib(nc_odat_async_avmout01), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(odat0_ptxclkoutn), .vccl(vccl),
     .odat1_in1(odat1_ptxclkoutn), .odat_async_in1(vssl),
     .shift_en(rx_shift_en[11]), .pd_data_in1(vssl),
     .dig_rstb(avmm1_rstb), .jtag_clkdr_out(jtag_clkdr_vinp01),
     .odat1_aib(odat1_aib_vinp01),
     .jtag_rx_scan_out(jtag_rx_scan_vinp01),
     .odat0_aib(odat0_aib_vinp01), .oclk_aib(nc_oclk_avmout01),
     .last_bs_out(nc_last_bs_out_vinp01),
     .oclkb_aib(nc_oclkb_avmout01), .jtag_clkdr_in(clkdr_xr6l),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_vinp11),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_avmm1_in[1]), .oclkn(nc_oclkn_avmout01),
     .iclkn(vssl), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xsdr_in1 ( .idata1_in1_jtag_out(nc_idat1_fsrldin),
     .idata0_in1_jtag_out(nc_idat0_fsrldin),
     .async_dat_in1_jtag_out(nc_async_dat_fsrldin),
     .prev_io_shift_en(rx_shift_en[12]),
     .jtag_clkdr_outn(jtag_clkdr_outn_fsrldin),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .vcc(vcc), .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(avmm1_rstb),
     .pd_data_aib(nc_pd0_data_fsdrin), .oclk_out(nc_oclk_fsrldin),
     .oclkb_out(nc_oclkb_fsrldin), .odat0_out(osdrin_odat0[1]),
     .odat1_out(osdrin_odat1[1]),
     .odat_async_out(nc_odat_async_fsrldin),
     .pd_data_out(nc_pd_data_fsrldin), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(rx_distclk_r[0]),
     .iclkin_dist_in1(vssl), .idata0_in0(vssl), .idata0_in1(vssl),
     .idata1_in0(vssl), .idata1_in1(vssl), .idataselb_in0(vcc),
     .idataselb_in1(vssl), .iddren_in0(vssl), .iddren_in1(vssl),
     .ilaunch_clk_in0(vssl), .ilaunch_clk_in1(vssl),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0({vssl, vssl}), .indrv_in1({vssl,
     vssl}), .ipdrv_in0({vssl, vssl}), .ipdrv_in1({vssl, vssl}),
     .irxen_in0(irxen_r2[2:0]), .irxen_in1({vssl, vcc, vssl}),
     .istrbclk_in0(rx_distclk_r[0]), .istrbclk_in1(vssl),
     .itxen_in0(vssl), .itxen_in1(vssl), .oclk_in1(vssl),
     .odat_async_aib(nc_odat_async_aib_fsrldin), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(ossrldin_odat0), .vccl(vccl),
     .odat1_in1(ossrldin_odat1), .odat_async_in1(vssl),
     .shift_en(rx_shift_en[13]), .pd_data_in1(vssl),
     .dig_rstb(avmm1_rstb), .jtag_clkdr_out(jtag_clkdr_out_fsrldin),
     .odat1_aib(nc_odat1_aib_fsrldin),
     .jtag_rx_scan_out(jtag_rx_scan_out_fsrldin),
     .odat0_aib(nc_odat0_aib_fsrldin), .oclk_aib(nc_oclk_out0_fsrldin),
     .last_bs_out(last_bs_out_fsrldin),
     .oclkb_aib(nc_oclkb_out0_fsrldin), .jtag_clkdr_in(clkdr_xr6r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_srcclkinn),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_sdr_in[1]), .oclkn(oclkn_fsrldin), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xsdr_in0 ( .idata1_in1_jtag_out(nc_idat1_ssrldin),
     .idata0_in1_jtag_out(nc_idat0_ssrldin),
     .async_dat_in1_jtag_out(nc_async_dat_ssrldin),
     .prev_io_shift_en(rx_shift_en[13]),
     .jtag_clkdr_outn(jtag_clkdr_outn_ssrldin),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .vcc(vcc), .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(avmm1_rstb),
     .pd_data_aib(nc_pd_data_out0_ssrldin), .oclk_out(nc_oclk_ssrldin),
     .oclkb_out(nc_oclkb_ssrldin), .odat0_out(osdrin_odat0[0]),
     .odat1_out(osdrin_odat1[0]),
     .odat_async_out(nc_odat_async_ssrldin),
     .pd_data_out(nc_pd_data_ssrldin), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(rx_distclk_r[2]),
     .iclkin_dist_in1(rx_distclk_r[2]), .idata0_in0(vssl),
     .idata0_in1(vssl), .idata1_in0(vssl), .idata1_in1(vssl),
     .idataselb_in0(vcc), .idataselb_in1(vssl), .iddren_in0(vssl),
     .iddren_in1(vssl), .ilaunch_clk_in0(vssl), .ilaunch_clk_in1(vssl),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0({vssl, vssl}), .indrv_in1({vssl,
     vssl}), .ipdrv_in0({vssl, vssl}), .ipdrv_in1({vssl, vssl}),
     .irxen_in0(irxen_r2[2:0]), .irxen_in1(irxen_r2[2:0]),
     .istrbclk_in0(rx_distclk_r[2]), .istrbclk_in1(rx_distclk_r[2]),
     .itxen_in0(vssl), .itxen_in1(vssl), .oclk_in1(vssl),
     .odat_async_aib(nc_odat_async_out0_ssrldin), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(odat0_oshared3), .vccl(vccl),
     .odat1_in1(odat1_oshared3), .odat_async_in1(vssl),
     .shift_en(rx_shift_en[14]), .pd_data_in1(vssl),
     .dig_rstb(avmm1_rstb), .jtag_clkdr_out(jtag_clkdr_ssrldin),
     .odat1_aib(ossrldin_odat1),
     .jtag_rx_scan_out(jtag_rx_scan_ssrldin),
     .odat0_aib(ossrldin_odat0), .oclk_aib(nc_oclk_out0_ssrldin),
     .last_bs_out(last_bs_out_ssrldin),
     .oclkb_aib(nc_oclkb_out0_ssrldin), .jtag_clkdr_in(clkdr_xr6r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_out_fsrldin),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_sdr_in[0]), .oclkn(nc_oclkn_out0_ssrldin),
     .iclkn(vssl), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xtx_clkn ( .idata1_in1_jtag_out(idata1_srcclkoutn),
     .idata0_in1_jtag_out(idata0_srcclkoutn),
     .async_dat_in1_jtag_out(nc_async_dat_srcclkoutn),
     .prev_io_shift_en(rx_shift_en[5]),
     .jtag_clkdr_outn(jtag_clkdr_outn_srcclkoutn),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .vcc(vcc), .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(avmm1_rstb),
     .pd_data_aib(pd_data_srcclkoutn), .oclk_out(oclk_outclkn),
     .oclkb_out(oclk_outclknb), .odat0_out(ncdrx_odat0_outclkn),
     .odat1_out(ncdrx_odat1_outclkn),
     .odat_async_out(odirectin_data_outclkn),
     .pd_data_out(pd_data_outclkn), .async_dat_in0(vssl),
     .async_dat_in1(vssl),
     .iclkin_dist_in0(jtag_clkdr_outn_srcclkoutn),
     .iclkin_dist_in1(vssl), .idata0_in0(idat0_clkn),
     .idata0_in1(idat0_ssrldout), .idata1_in0(idat1_clkn),
     .idata1_in1(idat1_ssrldout), .idataselb_in0(idataselb[1]),
     .idataselb_in1(idataselb[2]), .iddren_in0(vcc), .iddren_in1(vssl),
     .ilaunch_clk_in0(tx_launch_clk_r[4]),
     .ilaunch_clk_in1(tx_launch_clk_r[4]), .ilpbk_dat_in0(vssl),
     .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl), .ilpbk_en_in1(vssl),
     .indrv_in0(indrv_r78[1:0]), .indrv_in1(indrv_r78[1:0]),
     .ipdrv_in0(ipdrv_r78[1:0]), .ipdrv_in1(ipdrv_r78[1:0]),
     .irxen_in0({vssl, vcc, vssl}), .irxen_in1({vssl, vcc, vssl}),
     .istrbclk_in0(jtag_clkdr_outn_srcclkoutn), .istrbclk_in1(vssl),
     .itxen_in0(itxen[1]), .itxen_in1(itxen[2]), .oclk_in1(vssl),
     .odat_async_aib(odirectin_data_srcclkoutn), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(vssl), .vccl(vccl), .odat1_in1(vssl),
     .odat_async_in1(vssl), .shift_en(rx_shift_en[4]),
     .pd_data_in1(vssl), .dig_rstb(avmm1_rstb),
     .jtag_clkdr_out(jtag_clkdr_srcclkoutn),
     .odat1_aib(ncdrx_odat1_srcclkoutn),
     .jtag_rx_scan_out(jtag_rx_scan_srcclkoutn),
     .odat0_aib(ncdrx_odat0_srcclkoutn), .oclk_aib(nc_oclk_srcclkoutn),
     .last_bs_out(nc), .oclkb_aib(nc_oclkb_srcclkoutn),
     .jtag_clkdr_in(clkdr_xr8r), .jtag_mode_in(jtag_mode_in),
     .jtag_rstb(jtag_rstb), .jtag_tx_scan_in(jtag_rx_scan_ssrldout),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_clkn), .oclkn(nc_oclkn_srcclkoutn), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xrx_clkp ( .idata1_in1_jtag_out(nc_idat1_srcclkin),
     .idata0_in1_jtag_out(nc_idat0_srcclkin),
     .async_dat_in1_jtag_out(nc_async_dat_srcclkin),
     .prev_io_shift_en(shift_en_ptxclkout),
     .jtag_clkdr_outn(jtag_clkdr_outn_srcclkin),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .vcc(vcc), .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(avmm1_rstb),
     .pd_data_aib(ncdrx_pd_data_out0_txclkp), .oclk_out(oclk_inclkp),
     .oclkb_out(oclk_inclkpb), .odat0_out(ncdrx_odat0_rxclkp1),
     .odat1_out(ncdrx_odat1_rxclkp1),
     .odat_async_out(ncdrx_odat_async_rxclkp1),
     .pd_data_out(ncdrx_pd_data_rxclkp1), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(vssl),
     .iclkin_dist_in1(vssl), .idata0_in0(vssl),
     .idata0_in1(idata0_ptxclkout), .idata1_in0(vcc),
     .idata1_in1(idata1_ptxclkout), .idataselb_in0(vcc),
     .idataselb_in1(idataselb_ptxclkout), .iddren_in0(vcc),
     .iddren_in1(vcc), .ilaunch_clk_in0(vssl),
     .ilaunch_clk_in1(ilaunch_clk_ptxclkout), .ilpbk_dat_in0(vssl),
     .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl), .ilpbk_en_in1(vssl),
     .indrv_in0({vssl, vssl}), .indrv_in1(indrv_ptxclkout[1:0]),
     .ipdrv_in0({vssl, vssl}), .ipdrv_in1(ipdrv_ptxclkout[1:0]),
     .irxen_in0(irxen_r1[2:0]), .irxen_in1({vssl, vcc, vssl}),
     .istrbclk_in0(vssl), .istrbclk_in1(vssl), .itxen_in0(vssl),
     .itxen_in1(itxen_ptxclkout), .oclk_in1(oclk_aib_fsdrin),
     .odat_async_aib(ncdrx_odat_async_out0_txclkp),
     .oclkb_in1(oclkb_aib_fsdrin), .vssl(vssl), .odat0_in1(vssl),
     .vccl(vccl), .odat1_in1(vssl), .odat_async_in1(vssl),
     .shift_en(rx_shift_en[9]), .pd_data_in1(vssl),
     .dig_rstb(avmm1_rstb), .jtag_clkdr_out(jtag_clkdr_srcclkin),
     .odat1_aib(ncdrx_odat1_out0_txclkp),
     .jtag_rx_scan_out(jtag_rx_scan_srcclkin),
     .odat0_aib(ncdrx_odat0_out0_txclkp),
     .oclk_aib(ncdrx_oclk_out0_txclkp),
     .last_bs_out(last_bs_out_directin0),
     .oclkb_aib(ncdrx_oclkb_out0_txclkp), .jtag_clkdr_in(clkdr_xr5r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_ptxclkout),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_inclkp), .oclkn(ncdrx_oclkn_txclkp),
     .iclkn(oclkn_inclkn), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xsdr_out1 ( .idata1_in1_jtag_out(idat1_fsrldout),
     .idata0_in1_jtag_out(idat0_fsrldout),
     .async_dat_in1_jtag_out(nc_async_dat_fsrldout),
     .prev_io_shift_en(shift_en_inpshared2),
     .jtag_clkdr_outn(jtag_clkdr_outn_fsrldout),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .vcc(vcc), .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(avmm1_rstb),
     .pd_data_aib(nc_pd_data_aib_fsrldout),
     .oclk_out(nc_oclk_fsrldout), .oclkb_out(nc_oclkb_fsrldout),
     .odat0_out(nc_odat0_fsrldout), .odat1_out(nc_odat1_fsrldout),
     .odat_async_out(nc_odat_async_fsrldout),
     .pd_data_out(nc_pd_data_fsrldout), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(jtag_clkdr_outn_fsrldout),
     .iclkin_dist_in1(vssl), .idata0_in0(isdrin_idat0[1]),
     .idata0_in1(vssl), .idata1_in0(isdrin_idat1[1]),
     .idata1_in1(vssl), .idataselb_in0(idataselb[2]),
     .idataselb_in1(vssl), .iddren_in0(vssl), .iddren_in1(vssl),
     .ilaunch_clk_in0(tx_launch_clk_r[2]), .ilaunch_clk_in1(vssl),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0(indrv_r78[1:0]), .indrv_in1({vssl,
     vssl}), .ipdrv_in0(ipdrv_r78[1:0]), .ipdrv_in1({vssl, vssl}),
     .irxen_in0({vssl, vcc, vssl}), .irxen_in1(irxen_inpshared2[2:0]),
     .istrbclk_in0(jtag_clkdr_outn_fsrldout), .istrbclk_in1(vssl),
     .itxen_in0(itxen[2]), .itxen_in1(vssl), .oclk_in1(vssl),
     .odat_async_aib(odat_async_fsrldout), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(vssl), .vccl(vccl), .odat1_in1(vssl),
     .odat_async_in1(vssl), .shift_en(rx_shift_en[6]),
     .pd_data_in1(vssl), .dig_rstb(avmm1_rstb),
     .jtag_clkdr_out(jtag_clkdr_out_fsrldout),
     .odat1_aib(nc_odat1_aib_fsrldout),
     .jtag_rx_scan_out(jtag_rx_scan_out_fsrldout),
     .odat0_aib(nc_odat0_aib_fsrldout),
     .oclk_aib(nc_oclk_aib_fsrldout),
     .last_bs_out(last_bs_out_fsrldout),
     .oclkb_aib(nc_oclkb_aib_fsrldout), .jtag_clkdr_in(clkdr_xr8r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_inpshared2),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_sdr_out[1]), .oclkn(nc_oclkn_fsrldout), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xsdr_out0 ( .idata1_in1_jtag_out(idat1_ssrldout),
     .idata0_in1_jtag_out(idat0_ssrldout),
     .async_dat_in1_jtag_out(nc_async_dat_ssrldout),
     .prev_io_shift_en(rx_shift_en[6]),
     .jtag_clkdr_outn(jtag_clkdr_outn_ssrldout),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .vcc(vcc), .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(avmm1_rstb),
     .pd_data_aib(nc_pd_data_out0_ssrldrout),
     .oclk_out(nc_oclk_ssrldout), .oclkb_out(nc_oclkb_ssrldout),
     .odat0_out(nc_odat0_ssrldout), .odat1_out(nc_odat1_ssrldout),
     .odat_async_out(nc_odat_async_ssrldout),
     .pd_data_out(nc_pd_data_ssrldout), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(jtag_clkdr_outn_ssrldout),
     .iclkin_dist_in1(vssl), .idata0_in0(isdrin_idat0[0]),
     .idata0_in1(idat0_fsrldout), .idata1_in0(isdrin_idat1[0]),
     .idata1_in1(idat1_fsrldout), .idataselb_in0(idataselb[2]),
     .idataselb_in1(idataselb[2]), .iddren_in0(vssl),
     .iddren_in1(vssl), .ilaunch_clk_in0(tx_launch_clk_r[0]),
     .ilaunch_clk_in1(tx_launch_clk_r[0]), .ilpbk_dat_in0(vssl),
     .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl), .ilpbk_en_in1(vssl),
     .indrv_in0(indrv_r78[1:0]), .indrv_in1(indrv_r78[1:0]),
     .ipdrv_in0(ipdrv_r78[1:0]), .ipdrv_in1(ipdrv_r78[1:0]),
     .irxen_in0({vssl, vcc, vssl}), .irxen_in1({vssl, vcc, vssl}),
     .istrbclk_in0(jtag_clkdr_outn_ssrldout), .istrbclk_in1(vssl),
     .itxen_in0(itxen[2]), .itxen_in1(itxen[2]), .oclk_in1(vssl),
     .odat_async_aib(nc_odat_async_out0_ssrldrout), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(vssl), .vccl(vccl), .odat1_in1(vssl),
     .odat_async_in1(vssl), .shift_en(rx_shift_en[5]),
     .pd_data_in1(vssl), .dig_rstb(avmm1_rstb),
     .jtag_clkdr_out(jtag_clkdr_ssrldout),
     .odat1_aib(nc_odat1_out0_ssrldrout),
     .jtag_rx_scan_out(jtag_rx_scan_ssrldout),
     .odat0_aib(nc_odat0_out0_ssrldrout),
     .oclk_aib(nc_oclk_out0_ssrldrout),
     .last_bs_out(last_bs_out_ssrldout),
     .oclkb_aib(nc_oclkb_out0_ssrldrout), .jtag_clkdr_in(clkdr_xr8r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_out_fsrldout),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_sdr_out[0]), .oclkn(nc_oclkn_out0_ssrldrout),
     .iclkn(vssl), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xsdr_in3 ( .idata1_in1_jtag_out(nc_idat1_fsrdin),
     .idata0_in1_jtag_out(nc_idat0_fsrdin),
     .async_dat_in1_jtag_out(nc_async_dat_fsrdin),
     .prev_io_shift_en(rx_shift_en[9]),
     .jtag_clkdr_outn(jtag_clkdr_outn_fsrdin),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .vcc(vcc), .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(avmm1_rstb),
     .pd_data_aib(nc_pd_data_aib_fsdrin), .oclk_out(nc_oclk_fsdrin),
     .oclkb_out(nc_oclkb_fsdrin), .odat0_out(osdrin_odat0[3]),
     .odat1_out(osdrin_odat1[3]),
     .odat_async_out(nc_odat_async_fsdrin),
     .pd_data_out(nc_pd_data_fsdrin), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(rx_distclk_r[1]),
     .iclkin_dist_in1(vssl), .idata0_in0(vssl), .idata0_in1(vssl),
     .idata1_in0(vssl), .idata1_in1(vssl), .idataselb_in0(vcc),
     .idataselb_in1(vssl), .iddren_in0(vssl), .iddren_in1(vssl),
     .ilaunch_clk_in0(vssl), .ilaunch_clk_in1(vssl),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0({vssl, vssl}), .indrv_in1({vssl,
     vssl}), .ipdrv_in0({vssl, vssl}), .ipdrv_in1({vssl, vssl}),
     .irxen_in0(irxen_r2[2:0]), .irxen_in1(irxen_r1[2:0]),
     .istrbclk_in0(rx_distclk_r[1]), .istrbclk_in1(vssl),
     .itxen_in0(vssl), .itxen_in1(vssl), .oclk_in1(vssl),
     .odat_async_aib(nc_odat_async_aib_fsrdin), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(ossrdin_odat0), .vccl(vccl),
     .odat1_in1(ossrdin_odat1), .odat_async_in1(vssl),
     .shift_en(rx_shift_en[8]), .pd_data_in1(vssl),
     .dig_rstb(avmm1_rstb), .jtag_clkdr_out(jtag_clkdr_out_fsrdin),
     .odat1_aib(nc_odat1_aib_fsdrin),
     .jtag_rx_scan_out(jtag_rx_scan_out_fsrdin),
     .odat0_aib(nc_odat0_aib_fsdrin), .oclk_aib(oclk_aib_fsdrin),
     .last_bs_out(last_bs_out_fsrdin), .oclkb_aib(oclkb_aib_fsdrin),
     .jtag_clkdr_in(clkdr_xr5r), .jtag_mode_in(jtag_mode_in),
     .jtag_rstb(jtag_rstb), .jtag_tx_scan_in(jtag_rx_scan_srcclkin),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_sdr_in[3]), .oclkn(nc_oclkn_aib_fsdrin),
     .iclkn(oclkn_fsrldin), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xtx_clkp ( .idata1_in1_jtag_out(idat1_srcclkout),
     .idata0_in1_jtag_out(idat0_srcclkout),
     .async_dat_in1_jtag_out(nc_async_dat_srcclkout),
     .prev_io_shift_en(rx_shift_en[1]),
     .jtag_clkdr_outn(jtag_clkdr_outn_srcclkout),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .vcc(vcc), .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(avmm1_rstb),
     .pd_data_aib(nc_pd_data_srcclkout), .oclk_out(nc_oclk_outclkp),
     .oclkb_out(nc_oclk_outclkpb), .odat0_out(ncdtx_odat0_outclkp),
     .odat1_out(ncdtx_odat1_outclkp),
     .odat_async_out(odirectin_data_outclkp),
     .pd_data_out(pd_data_outclkp), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(jtag_clkdr_outn_srcclkout),
     .iclkin_dist_in1(vssl), .idata0_in0(idat0_clkp),
     .idata0_in1(idat0_ssrdout), .idata1_in0(idat1_clkp),
     .idata1_in1(idat1_ssrdout), .idataselb_in0(idataselb[1]),
     .idataselb_in1(idataselb[2]), .iddren_in0(vcc), .iddren_in1(vssl),
     .ilaunch_clk_in0(tx_launch_clk_r[5]),
     .ilaunch_clk_in1(tx_launch_clk_r[1]), .ilpbk_dat_in0(vssl),
     .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl), .ilpbk_en_in1(vssl),
     .indrv_in0(indrv_r78[1:0]), .indrv_in1(indrv_r78[1:0]),
     .ipdrv_in0(ipdrv_r78[1:0]), .ipdrv_in1(ipdrv_r78[1:0]),
     .irxen_in0({vssl, vcc, vssl}), .irxen_in1({vssl, vcc, vssl}),
     .istrbclk_in0(jtag_clkdr_outn_srcclkout), .istrbclk_in1(vssl),
     .itxen_in0(itxen[1]), .itxen_in1(itxen[2]), .oclk_in1(vssl),
     .odat_async_aib(odirectin_data_srcclkout), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(vssl), .vccl(vccl), .odat1_in1(vssl),
     .odat_async_in1(vssl), .shift_en(rx_shift_en[2]),
     .pd_data_in1(vssl), .dig_rstb(avmm1_rstb),
     .jtag_clkdr_out(jtag_clkdr_srcclkout),
     .odat1_aib(nc_odat1_srcclkout),
     .jtag_rx_scan_out(jtag_rx_scan_srcclkout),
     .odat0_aib(nc_odat0_srcclkout), .oclk_aib(nc_oclk_srcclkout),
     .last_bs_out(last_bs_out_srcclkin),
     .oclkb_aib(nc_oclkb_srcclkout), .jtag_clkdr_in(clkdr_xr7r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_ssrdout),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_clkp), .oclkn(nc_oclkn_srcclkout), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xavmm1_in0 ( .idata1_in1_jtag_out(nc_idat1_vinp00),
     .idata0_in1_jtag_out(nc_idat0_vinp00),
     .async_dat_in1_jtag_out(nc_async_dat_vinp00),
     .prev_io_shift_en(shift_en_vinp10),
     .jtag_clkdr_outn(jtag_clkdr_outn_vinp00),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .vcc(vcc), .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(avmm1_rstb),
     .pd_data_aib(nc_pd_data_avmout0), .oclk_out(nc_oclk_avmin011),
     .oclkb_out(nc_oclkb_avmin011), .odat0_out(avmm1_odat0[0]),
     .odat1_out(avmm1_odat1[0]),
     .odat_async_out(nc_odat_async_avmin011),
     .pd_data_out(nc_pd_data_avmin011), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(rx_distclk_l[3]),
     .iclkin_dist_in1(rx_distclk_l[3]), .idata0_in0(vssl),
     .idata0_in1(vssl), .idata1_in0(vssl), .idata1_in1(vssl),
     .idataselb_in0(vcc), .idataselb_in1(vssl), .iddren_in0(vssl),
     .iddren_in1(vssl), .ilaunch_clk_in0(vssl), .ilaunch_clk_in1(vssl),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0({vssl, vssl}), .indrv_in1({vssl,
     vssl}), .ipdrv_in0({vssl, vssl}), .ipdrv_in1({vssl, vssl}),
     .irxen_in0(irxen_r0[2:0]), .irxen_in1(irxen_vinp10[2:0]),
     .istrbclk_in0(rx_distclk_l[3]), .istrbclk_in1(rx_distclk_l[3]),
     .itxen_in0(vssl), .itxen_in1(vssl), .oclk_in1(vssl),
     .odat_async_aib(nc_odat_async_avmout0), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(odat0_ptxclkout), .vccl(vccl),
     .odat1_in1(odat1_ptxclkout), .odat_async_in1(vssl),
     .shift_en(rx_shift_en[10]), .pd_data_in1(vssl),
     .dig_rstb(avmm1_rstb), .jtag_clkdr_out(jtag_clkdr_vinp00),
     .odat1_aib(odat1_aib_vinp00),
     .jtag_rx_scan_out(jtag_rx_scan_vinp00),
     .odat0_aib(odat0_aib_vinp00), .oclk_aib(nc_oclk_avmout0),
     .last_bs_out(last_bs_out_vinp00), .oclkb_aib(nc_oclkb_avmout0),
     .jtag_clkdr_in(clkdr_xr5l), .jtag_mode_in(jtag_mode_in),
     .jtag_rstb(jtag_rstb), .jtag_tx_scan_in(jtag_rx_scan_vinp10),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_avmm1_in[0]), .oclkn(nc_oclkn_avmout0), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xsdr_out3 ( .idata1_in1_jtag_out(nc_idat1_fsrdout),
     .idata0_in1_jtag_out(nc_idat0_fsrdout),
     .async_dat_in1_jtag_out(nc_async_dat_fsrdout),
     .prev_io_shift_en(shift_en_oshared4),
     .jtag_clkdr_outn(jtag_clkdr_outn_fsrdout),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .vcc(vcc), .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(avmm1_rstb),
     .pd_data_aib(nc_pd_data_out0_fsrout), .oclk_out(nc_oclk_fsrdout),
     .oclkb_out(nc_oclkb_fsrdout), .odat0_out(nc_odat0_fsrdout),
     .odat1_out(nc_odat1_fsrdout),
     .odat_async_out(nc_odat_async_fsrdout),
     .pd_data_out(nc_pd_data_fsrdout), .async_dat_in0(vssl),
     .async_dat_in1(async_dat_oshared4),
     .iclkin_dist_in0(jtag_clkdr_outn_fsrdout), .iclkin_dist_in1(vssl),
     .idata0_in0(isdrin_idat0[3]), .idata0_in1(vssl),
     .idata1_in0(isdrin_idat1[3]), .idata1_in1(vssl),
     .idataselb_in0(idataselb[2]), .idataselb_in1(idataselb_oshared4),
     .iddren_in0(vssl), .iddren_in1(vssl),
     .ilaunch_clk_in0(tx_launch_clk_r[3]), .ilaunch_clk_in1(vssl),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0(indrv_r78[1:0]),
     .indrv_in1(indrv_r78[1:0]), .ipdrv_in0(ipdrv_r78[1:0]),
     .ipdrv_in1(ipdrv_r78[1:0]), .irxen_in0({vssl, vcc, vssl}),
     .irxen_in1({vssl, vcc, vssl}),
     .istrbclk_in0(jtag_clkdr_outn_fsrdout), .istrbclk_in1(vssl),
     .itxen_in0(itxen[2]), .itxen_in1(itxen_oshared4), .oclk_in1(vssl),
     .odat_async_aib(nc_odat_async_out0_fsrout), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(vssl), .vccl(vccl), .odat1_in1(vssl),
     .odat_async_in1(vssl), .shift_en(rx_shift_en[0]),
     .pd_data_in1(vssl), .dig_rstb(avmm1_rstb),
     .jtag_clkdr_out(jtag_clkdr_fsrdout),
     .odat1_aib(nc_odat1_out0_fsrout),
     .jtag_rx_scan_out(jtag_rx_scan_fsrdout),
     .odat0_aib(nc_odat0_out0_fsrout), .oclk_aib(nc_oclk_out0_fsrout),
     .last_bs_out(last_bs_out_fsrdout),
     .oclkb_aib(nc_oclkb_out0_fsrout), .jtag_clkdr_in(clkdr_xr7r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_oshared4),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_sdr_out[3]), .oclkn(nc_oclkn_out0_fsrout),
     .iclkn(vssl), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xsdr_in2 ( .idata1_in1_jtag_out(nc_idat1_ssrdin),
     .idata0_in1_jtag_out(nc_idat0_ssrdin),
     .async_dat_in1_jtag_out(nc_async_dat_ssrdin),
     .prev_io_shift_en(rx_shift_en[8]),
     .jtag_clkdr_outn(jtag_clkdr_outn_ssrdin),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .vcc(vcc), .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(avmm1_rstb),
     .pd_data_aib(nc_pd_data_out0_ssrdin),
     .oclk_out(nc_oclk_out0_ssrdin1),
     .oclkb_out(nc_oclkb_out0_ssrdin1), .odat0_out(osdrin_odat0[2]),
     .odat1_out(osdrin_odat1[2]),
     .odat_async_out(nc_odat_async_out0_ssrdin1),
     .pd_data_out(nc_pd_data_out0_ssrdin1), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(rx_distclk_r[3]),
     .iclkin_dist_in1(rx_distclk_r[3]), .idata0_in0(vssl),
     .idata0_in1(vssl), .idata1_in0(vssl), .idata1_in1(vssl),
     .idataselb_in0(vcc), .idataselb_in1(vssl), .iddren_in0(vssl),
     .iddren_in1(vssl), .ilaunch_clk_in0(vssl), .ilaunch_clk_in1(vssl),
     .ilpbk_dat_in0(vssl), .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl),
     .ilpbk_en_in1(vssl), .indrv_in0({vssl, vssl}), .indrv_in1({vssl,
     vssl}), .ipdrv_in0({vssl, vssl}), .ipdrv_in1({vssl, vssl}),
     .irxen_in0(irxen_r2[2:0]), .irxen_in1(irxen_r2[2:0]),
     .istrbclk_in0(rx_distclk_r[3]), .istrbclk_in1(rx_distclk_r[3]),
     .itxen_in0(vssl), .itxen_in1(vssl), .oclk_in1(vssl),
     .odat_async_aib(nc_odat_async_out0_ssrdin), .oclkb_in1(vssl),
     .odat0_in1(odat0_oshared2), .odat1_in1(odat1_oshared2),
     .odat_async_in1(vssl), .shift_en(rx_shift_en[7]),
     .pd_data_in1(vssl), .dig_rstb(avmm1_rstb),
     .jtag_clkdr_out(jtag_clkdr_ssrdin), .odat1_aib(ossrdin_odat1),
     .jtag_rx_scan_out(jtag_rx_scan_ssrdin), .odat0_aib(ossrdin_odat0),
     .oclk_aib(nc_oclk_out0_ssrdin), .last_bs_out(last_bs_out_ssrdin),
     .oclkb_aib(nc_oclkb_out0_ssrdin), .jtag_clkdr_in(clkdr_xr5r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_out_fsrdin),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .vssl(vssl), .iopad(iopad_sdr_in[2]), .vccl(vccl),
     .oclkn(nc_oclkn_out0_ssrdin), .test_weakpd(jtag_weakpdn),
     .iclkn(vssl), .test_weakpu(jtag_weakpu));
aibcr3_buffx1_top xrx ( .idata1_in1_jtag_out(idata1_voutp0),
     .idata0_in1_jtag_out(idata0_voutp0),
     .async_dat_in1_jtag_out(nc_async_dat_voutp0),
     .prev_io_shift_en(rx_shift_en[2]),
     .jtag_clkdr_outn(jtag_clkdr_outn_voutp0),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .vcc(vcc), .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(avmm1_rstb),
     .pd_data_aib(nc_pd_data_out0_rx), .oclk_out(nc_oclk_tx),
     .oclkb_out(nc_oclkb_tx), .odat0_out(nc_odat0_tx),
     .odat1_out(nc_odat1_tx), .odat_async_out(nc_odat_async_tx),
     .pd_data_out(nc_pd_data_tx), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(jtag_clkdr_outn_voutp0),
     .iclkin_dist_in1(vssl), .idata0_in0(avmm1_idat0),
     .idata0_in1(idat0_srcclkout), .idata1_in0(avmm1_idat1),
     .idata1_in1(idat1_srcclkout), .idataselb_in0(idataselb[0]),
     .idataselb_in1(idataselb[1]), .iddren_in0(vssl), .iddren_in1(vcc),
     .ilaunch_clk_in0(tx_launch_clk_l[7]),
     .ilaunch_clk_in1(tx_launch_clk_l[7]), .ilpbk_dat_in0(vssl),
     .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl), .ilpbk_en_in1(vssl),
     .indrv_in0(indrv_r78[1:0]), .indrv_in1(indrv_r78[1:0]),
     .ipdrv_in0(ipdrv_r78[1:0]), .ipdrv_in1(ipdrv_r78[1:0]),
     .irxen_in0({vssl, vcc, vssl}), .irxen_in1({vssl, vcc, vssl}),
     .istrbclk_in0(jtag_clkdr_outn_voutp0), .istrbclk_in1(vssl),
     .itxen_in0(itxen[0]), .itxen_in1(itxen[1]), .oclk_in1(vssl),
     .odat_async_aib(nc_odat_async_out0_rx), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(vssl), .vccl(vccl), .odat1_in1(vssl),
     .odat_async_in1(vssl), .shift_en(rx_shift_en[3]),
     .pd_data_in1(vssl), .dig_rstb(avmm1_rstb),
     .jtag_clkdr_out(jtag_clkdr_voutp0), .odat1_aib(nc_odat1_out0_tx),
     .jtag_rx_scan_out(jtag_rx_scan_voutp0),
     .odat0_aib(nc_odat0_out0_tx), .oclk_aib(nc_oclk_out0_tx),
     .last_bs_out(last_bs_out_voutp0), .oclkb_aib(nc_oclkb_out0_tx),
     .jtag_clkdr_in(clkdr_xr7l), .jtag_mode_in(jtag_mode_in),
     .jtag_rstb(jtag_rstb), .jtag_tx_scan_in(jtag_rx_scan_srcclkout),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_avmm1_out), .oclkn(nc_oclkn_out0_tx), .iclkn(vssl),
     .test_weakpu(jtag_weakpu), .test_weakpd(jtag_weakpdn));
aibcr3_buffx1_top xsdr_out2 ( .idata1_in1_jtag_out(idat1_ssrdout),
     .idata0_in1_jtag_out(idat0_ssrdout),
     .async_dat_in1_jtag_out(nc_async_dat_ssrdout),
     .prev_io_shift_en(rx_shift_en[0]),
     .jtag_clkdr_outn(jtag_clkdr_outn_ssrdout),
     .jtag_rstb_en(jtag_rstb_en), .jtag_clksel(jtag_clksel),
     .jtag_intest(jtag_intest), .vcc(vcc), .por_aib_vccl(por_aib_vccl),
     .por_aib_vcchssi(por_aib_vcchssi), .anlg_rstb(avmm1_rstb),
     .pd_data_aib(nc_pd_data_out0_sdrout), .oclk_out(nc_oclk_ssrdout),
     .oclkb_out(nc_oclkb_ssrdout), .odat0_out(nc_odat0_ssrdout),
     .odat1_out(nc_odat1_ssrdout),
     .odat_async_out(nc_odat_async_ssrdout),
     .pd_data_out(nc_pd_data_ssrdout), .async_dat_in0(vssl),
     .async_dat_in1(vssl), .iclkin_dist_in0(jtag_clkdr_outn_ssrdout),
     .iclkin_dist_in1(vssl), .idata0_in0(isdrin_idat0[2]),
     .idata0_in1(nc_idat0_fsrdout), .idata1_in0(isdrin_idat1[2]),
     .idata1_in1(nc_idat1_fsrdout), .idataselb_in0(idataselb[2]),
     .idataselb_in1(idataselb[2]), .iddren_in0(vssl),
     .iddren_in1(vssl), .ilaunch_clk_in0(tx_launch_clk_r[1]),
     .ilaunch_clk_in1(tx_launch_clk_r[3]), .ilpbk_dat_in0(vssl),
     .ilpbk_dat_in1(vssl), .ilpbk_en_in0(vssl), .ilpbk_en_in1(vssl),
     .indrv_in0(indrv_r78[1:0]), .indrv_in1(indrv_r78[1:0]),
     .ipdrv_in0(ipdrv_r78[1:0]), .ipdrv_in1(ipdrv_r78[1:0]),
     .irxen_in0({vssl, vcc, vssl}), .irxen_in1({vssl, vcc, vssl}),
     .istrbclk_in0(jtag_clkdr_outn_ssrdout), .istrbclk_in1(vssl),
     .itxen_in0(itxen[2]), .itxen_in1(itxen[2]), .oclk_in1(vssl),
     .odat_async_aib(nc_odat_async_out0_sdrout), .oclkb_in1(vssl),
     .vssl(vssl), .odat0_in1(vssl), .vccl(vccl), .odat1_in1(vssl),
     .odat_async_in1(vssl), .shift_en(rx_shift_en[1]),
     .pd_data_in1(vssl), .dig_rstb(avmm1_rstb),
     .jtag_clkdr_out(jtag_clkdr_ssrdout),
     .odat1_aib(nc_odat1_out0_ssdrout),
     .jtag_rx_scan_out(jtag_rx_scan_ssrdout),
     .odat0_aib(nc_odat0_out0_sdrout), .oclk_aib(nc_oclk_out0_sdrout),
     .last_bs_out(last_bs_out_ssrdout),
     .oclkb_aib(nc_oclkb_out0_ssdrout), .jtag_clkdr_in(clkdr_xr7r),
     .jtag_mode_in(jtag_mode_in), .jtag_rstb(jtag_rstb),
     .jtag_tx_scan_in(jtag_rx_scan_fsrdout),
     .jtag_tx_scanen_in(jtag_tx_scanen_in), .last_bs_in(vssl),
     .iopad(iopad_sdr_out[2]), .oclkn(nc_oclkn_out0_ssdrout),
     .iclkn(vssl), .test_weakpu(jtag_weakpu),
     .test_weakpd(jtag_weakpdn));
aibcr3_txdat_mimic x587 ( .vss_aibcr(vssl), .vcc_aibcr(vcc),
     .idat_in(avmm_tx_clk_in), .idat_out(avmm_tx_clk_in_dly));
aibcr3_clktree_avmm_pcs  xin_clktree ( //.vcc_aibcr(vcc),
   //.vss_aibcr(vssl), 
     .lstrbclk_mimic2(clk_distclk),
     .lstrbclk_r_7(rx_distclk_r[7]), .lstrbclk_r_6(rx_distclk_r[6]),
     .lstrbclk_r_5(rx_distclk_r[5]), .lstrbclk_r_4(rx_distclk_r[4]),
     .lstrbclk_r_3(rx_distclk_r[3]), .lstrbclk_r_2(rx_distclk_r[2]),
     .lstrbclk_r_1(rx_distclk_r[1]), .lstrbclk_r_0(rx_distclk_r[0]),
     .lstrbclk_mimic1(nc_clk_mimic11),
     .lstrbclk_mimic0(nc_clk_mimic01), .lstrbclk_l_0(rx_distclk_l[0]),
     .lstrbclk_l_1(rx_distclk_l[1]), .lstrbclk_l_2(rx_distclk_l[2]),
     .lstrbclk_l_3(rx_distclk_l[3]), .lstrbclk_l_4(rx_distclk_l[4]),
     .lstrbclk_l_5(rx_distclk_l[5]), .lstrbclk_l_6(rx_distclk_l[6]),
     .lstrbclk_l_7(rx_distclk_l[7]), .lstrbclk_rep(pcs_clk_clktree),
     .clkin(oclk_inclkpb));
aibcr3_clktree_avmm  xout_clktree ( //.vcc_aibcr(vcc), .vss_aibcr(vssl),
     .lstrbclk_mimic2(nc_clk_mimic), .lstrbclk_r_7(tx_launch_clk_r[7]),
     .lstrbclk_r_6(tx_launch_clk_r[6]),
     .lstrbclk_r_5(tx_launch_clk_r[5]),
     .lstrbclk_r_4(tx_launch_clk_r[4]),
     .lstrbclk_r_3(tx_launch_clk_r[3]),
     .lstrbclk_r_2(tx_launch_clk_r[2]),
     .lstrbclk_r_1(tx_launch_clk_r[1]),
     .lstrbclk_r_0(tx_launch_clk_r[0]),
     .lstrbclk_mimic1(nc_clk_mimic1), .lstrbclk_mimic0(nc_clk_mimic0),
     .lstrbclk_l_0(tx_launch_clk_l[0]),
     .lstrbclk_l_1(tx_launch_clk_l[1]),
     .lstrbclk_l_2(tx_launch_clk_l[2]),
     .lstrbclk_l_3(tx_launch_clk_l[3]),
     .lstrbclk_l_4(tx_launch_clk_l[4]),
     .lstrbclk_l_5(tx_launch_clk_l[5]),
     .lstrbclk_l_6(tx_launch_clk_l[6]),
     .lstrbclk_l_7(tx_launch_clk_l[7]), .lstrbclk_rep(nc_clk_rep),
     .clkin(avmm_tx_clk_in_dly));

//assign pcs_clkb = !pcs_clk_clktree;
assign pcs_clkb = 1'b1;

aibcr3_rxdat_mimic x588 ( .odat_out(pcs_clk), .odat_in(pcs_clk_int),
     .vss_aibcr(vssl), .vcc_aibcr(vcc));

endmodule

