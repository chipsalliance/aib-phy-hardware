// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3aux_lib, Cell - aibcr3aux_top, View - schematic
// `timescale 1ns / 1ns 

module aibcr3aux_top ( jtag_clkdr_out, jtag_clksel_out, jtag_intest_out,
     jtag_mode_out, jtag_rstb_en_out, jtag_rstb_out, jtag_rx_scan_out,
     jtag_tx_scanen_out, jtag_weakpdn_out, jtag_weakpu_out,
     last_bs_out, o_cnocdn, o_cnocdn_clkp, o_dn_por, o_dn_rst_n,
     o_io_in, o_io_oe, o_jt_tck, o_jt_tdi, o_jt_tms, o_por_vcchssi,
     o_por_vccl, o_por_vccl_1p8, oatpg_scan_out, odft_in_async,
     oosc_aibdft2osc, oosc_atb0, oosc_atb1, oosc_clkout,
     oosc_clkout_dup, oosc_monitor, oosc_reserved, u_actred1,
     u_actred2, u_auxactred1, u_auxactred2, u_cnocdn, u_cnocdn_clkn,
     u_cnocdn_clkp, u_cnocup, u_cnocup_clkn, u_cnocup_clkp, u_crdet,
     u_crdet_r, u_dn_por, u_dn_por_r, u_dn_rst_n, u_dn_rst_n_r,
     u_io_in, u_io_oe, u_io_out, u_jt_tck, u_jt_tck_r, u_jt_tdi,
     u_jt_tdi_r, u_jt_tms, u_jt_tms_r, u_jtr_tck, u_jtr_tck_r,
     u_jtr_tdo, u_jtr_tdo_r, u_jtr_tms, u_jtr_tms_r, u_tstmx,
     aib_aux_ctrl_bus0, aib_aux_ctrl_bus1, aib_aux_ctrl_bus2,
     c4por_vccl_ovrd, i_actred1, i_actred2, i_cnocup, i_cnocup_clkp,
     i_io_out, i_jtr_tck, i_jtr_tdo, i_jtr_tms, i_tstmx,
     iactred_shiften_chain1, iactred_shiften_chain2, iactred_txen,
     iaib_aibdll2dft, iatpg_mode_n, iatpg_pipeline_global_en,
     iatpg_rst_n, iatpg_scan_clk, iatpg_scan_in, iatpg_scan_shift_n,
     idft_bypass_en, idft_out_async, iosc_aibdft2osc, iosc_bypclk,
     iosc_fuse_trim, iosc_ic50u, iosc_it50u, irstb, jtag_clkdr_in,
     jtag_clksel_in, jtag_intest_in, jtag_mode_in, jtag_rstb_en_in,
     jtag_rstb_in, jtag_tx_scan_in, jtag_tx_scanen_in, jtag_weakpdn_in,
     jtag_weakpu_in, last_bs_in, vcc_aibcr3aux, vcca_aibcr3aux,
     vccl_aibcr3aux, vccr_aibcraux, vssl_aibcr3aux, osc_extrref );

output  jtag_clkdr_out, jtag_clksel_out, jtag_intest_out,
     jtag_mode_out, jtag_rstb_en_out, jtag_rstb_out, jtag_rx_scan_out,
     jtag_tx_scanen_out, jtag_weakpdn_out, jtag_weakpu_out,
     last_bs_out, o_cnocdn_clkp, o_dn_por, o_dn_rst_n, o_jt_tck,
     o_jt_tdi, o_jt_tms, o_por_vcchssi, o_por_vccl, o_por_vccl_1p8,
     oatpg_scan_out, oosc_atb0, oosc_atb1, oosc_clkout,
     oosc_clkout_dup, oosc_monitor;

inout  u_actred1, u_actred2, u_auxactred1, u_auxactred2, u_cnocdn_clkn,
     u_cnocdn_clkp, u_cnocup_clkn, u_cnocup_clkp, u_crdet, u_crdet_r,
     u_dn_por, u_dn_por_r, u_dn_rst_n, u_dn_rst_n_r, u_jt_tck,
     u_jt_tck_r, u_jt_tdi, u_jt_tdi_r, u_jt_tms, u_jt_tms_r, u_jtr_tck,
     u_jtr_tck_r, u_jtr_tdo, u_jtr_tdo_r, u_jtr_tms, u_jtr_tms_r;

input  c4por_vccl_ovrd, i_actred1, i_actred2, i_cnocup_clkp, i_jtr_tck,
     i_jtr_tdo, i_jtr_tms, iactred_shiften_chain1,
     iactred_shiften_chain2, iactred_txen, iatpg_mode_n,
     iatpg_pipeline_global_en, iatpg_rst_n, iatpg_scan_clk,
     iatpg_scan_in, iatpg_scan_shift_n, idft_bypass_en, iosc_bypclk,
     iosc_ic50u, iosc_it50u, irstb, jtag_clkdr_in, jtag_clksel_in,
     jtag_intest_in, jtag_mode_in, jtag_rstb_en_in, jtag_rstb_in,
     jtag_tx_scan_in, jtag_tx_scanen_in, jtag_weakpdn_in,
     jtag_weakpu_in, last_bs_in, vcc_aibcr3aux, vcca_aibcr3aux,
     vccl_aibcr3aux, vccr_aibcraux, vssl_aibcr3aux, osc_extrref;

output [9:0]  odft_in_async;
output [12:0]  oosc_aibdft2osc;
output [7:0]  o_io_in;
output [1:0]  o_io_oe;
output [3:0]  oosc_reserved;
output [31:0]  o_cnocdn;

inout [24:0]  u_cnocup;
inout [15:0]  u_cnocdn;
inout [1:0]  u_io_oe;
inout [7:0]  u_tstmx;
inout [7:0]  u_io_out;
inout [7:0]  u_io_in;

input [9:0]  iosc_fuse_trim;
input [31:0]  aib_aux_ctrl_bus1;
input [31:0]  aib_aux_ctrl_bus2;
input [31:0]  aib_aux_ctrl_bus0;
input [7:0]  i_io_out;
input [49:0]  i_cnocup;
input [2:0]  iosc_aibdft2osc;
input [7:0]  i_tstmx;
input [7:0]  idft_out_async;
input [12:0]  iaib_aibdll2dft;

wire net0213, c4por_vccl_ovrdb, net0317, o_por_vcchssi, por_vcchssi_int, o_dn_por, jtag_clkdr_int_buf, jtag_clkdr_int, irstb_buf, irstb, jtag_clksel_out, jtag_clksel_out_buf, jtag_clksel_int, jtag_clksel_int_buf, jtag_clksel_in_buf, jtag_clksel_in, jtag_intest_int, jtag_intest_int_buf, jtag_intest_out, jtag_intest_out_buf, jtag_intest_in_buf, jtag_intest_in, jtag_tx_scanen_out, jtag_tx_scanen_buf, jtag_tx_scanen_int, jtag_tx_scanen_int_buf, jtag_tx_scanen_in_buf, jtag_tx_scanen_in, jtag_mode_out, jtag_mode_out_buf, jtag_mode_int, jtag_mode_int_buf, oosc_clkout_dup, osc_clkout, oosc_clkout, jtag_mode_buf, jtag_mode_in, o_por_vccl, c4por_vccl_ovrd, jtag_weakpdn_int, jtag_weakpdn_intb, jtag_tx_scanen_intb, jtag_tx_scanen_outb, jtag_rstb_out, jtag_rstb_outb, jtag_weakpdn_out, jtag_weakpdn_outb, jtag_clksel_outb, jtag_intest_outb, jtag_weakpu_out, jtag_weakpu_outb, jtag_clksel_intb, jtag_mode_outb, jtag_rstb_int, jtag_rstb_intb, jtag_intest_intb, jtag_mode_intb, intrstb, jtag_weakpu_int, jtag_weakpu_intb, jtag_rstb_en_out, jtag_rstb_en_outb, last_bs_outb, last_bs_in, jtag_rstb_en_int, jtag_rstb_en_intb, last_bs_out, vssl_aibcr3aux, vcc_aibcr3aux, jtag_rstb_in, jtag_weakpu_in, jtag_weakpdn_in, jtag_rstb_en_in, jtag_clkdr_intb, jtag_clkdr_in, jtag_clkdr_outb, o_cnocdn_clkp, cnocdn_clkp_inv3, cnocdn_clkp_inv2, cnocdn_clkp_inv1, cnocdn_clkp_inv0, cnocup_clkp_inv0, i_cnocup_clkp, cnocup_clkp_inv3, cnocup_clkp_inv2, cnocup_clkp_inv1, jtag_clkdr6r, jtag_clkdr5r, jtag_clkdr6l, jtag_clkdr5l, jtag_clkdr4l, jtag_clkdr4r, jtag_clkdr3r, jtag_clkdr3l, jtag_clkdr2r, jtag_clkdr2l, jtag_clkdr1r, jtag_clkdr1l, jtag_clkdr_out, jtag_clkdr_outb_buf;

// Buses in the design

wire  [31:0]  aib_aux_ctrl_bus1b;

wire  [12:12]  ctrl_bus0_intb;

wire  [31:0]  ctrl_bus2_int;

wire  [31:0]  ctrl_bus1_int;

wire  [12:0]  aibdft2osc_int;

wire  [0:12]  dft2osc_int;

wire  [31:0]  aib_aux_ctrl_bus2b;

wire  [49:0]  cnocup_inv0;

wire  [49:0]  cnocup_inv1;

wire  [49:0]  cnocup_inv2;

wire  [49:0]  cnocup_inv3;

wire  [31:0]  cnocdn_inv0;

wire  [31:0]  cnocdn_inv1;

wire  [31:0]  cnocdn_inv2;

wire  [31:0]  cnocdn_inv3;

wire  [31:0]  aib_aux_ctrl_bus0b;

wire  [31:0]  ctrl_bus0_int;

    //IO tie-off, Jennifer 05/04/18
    assign u_io_out = 8'h0;
    assign u_tstmx = 8'h0;
    assign u_auxactred1 = 1'b0;
    assign u_auxactred2 = 1'b0;
    assign u_actred1 = 1'b0;
    assign u_actred2 = 1'b0;
    assign u_cnocup = 25'h0;
    assign u_cnocup_clkp = 1'b0;
    assign u_cnocup_clkn = 1'b0;

                                        /////////////////////////////////
                                        // for VCS and ICC compatibility
                                        /////////////////////////////////

//ww35.5 - passive redundancy clk fix. 
// aibcr_aliasd aliasd00 ( .rb(u_cnocdn_clkp), .ra(u_cnocdn_clkn));		// Reviewed by Designer

//Modified by Jennifer 05/04/18, removed instance aibcr3aux_cnocdn to match schematic
//aibcr3aux_cnocdn xcnocdn ( .jtag_clkdr4r(jtag_clkdr4r),
//     .jtag_clkdr4l(jtag_clkdr4l), .jtag_clkdr3r(jtag_clkdr3r),
//     .jtag_clkdr3l(jtag_clkdr3l), .jtag_rstb_en(jtag_rstb_en_int),
//     .csr_iocsr_sel(ctrl_bus0_int[11]),
//     .ib50u_ring(osc2cnocdn_ib50u_ring), .ib50uc(osc2cnocdn_ib50uc),
//     .csr_cndn_cken({vssl_aibcr3aux, ctrl_bus0_int[5:4]}),
//     .iosc_fuse_trim(iosc_fuse_trim[9:0]),
//     .csr_dly_ovrd(ctrl_bus2_int[9:6]),
//     .csr_dly_ovrden(ctrl_bus2_int[5]), .csr_cndn_rxen({vssl_aibcr3aux,
//     ctrl_bus0_int[3:2]}), .orx_clkp(cnocdn_clkp_inv0),
//     .cndn(cnocdn_inv0[31:0]), .vcc_aibcr3aux(vcc_aibcr3aux),
//     .vssl_aibcr3aux(vssl_aibcr3aux), .por_vccl(o_por_vccl),
//     .por_vcchssi(por_vcchssi_int), .vccl_aibcr3aux(vccl_aibcr3aux),
//     .iopad_cndn(u_cnocdn[15:0]), .jtag_clksel(jtag_clksel_int),
//     .jtag_intest(jtag_intest_int), .iopad_cndn_clkn(u_cnocdn_clkp),
//     .iopad_cndn_clkp(u_cnocdn_clkp),
//     .jtag_rx_scan_out_01x3(jtag_rx_scan_in_01x5),
//     .jtag_rx_scan_out_01x4(jtag_rx_scan_in_01x6),
//     .last_bs_out_01x3(last_bs_in_01x5),
//     .last_bs_out_01x4(last_bs_in_01x6), .anlg_rstb(intrstb),
//     .dig_rstb(intrstb), .jtag_mode_in(jtag_mode_int),
//     .jtag_rstb(jtag_rstb_int),
//     .jtag_tx_scan_in_09x3(jtag_rx_scan_in_09x3),
//     .jtag_tx_scan_in_09x4(jtag_rx_scan_in_09x4),
//     .jtag_tx_scanen_in(jtag_tx_scanen_int),
//     .jtag_weakpdn(jtag_weakpdn_int), .jtag_weakpu(jtag_weakpu_int),
//     .last_bs_in_09x3(last_bs_in_09x3),
//     .last_bs_in_09x4(last_bs_in_09x4));
aibcr3aux_lvshift_1p8  xlvlshf0 ( .in(o_por_vccl),
     .vccl_aibcr3aux(vccl_aibcr3aux), .vssl_aibcr3aux(vssl_aibcr3aux),
     .vcca_aibcr3aux(vccr_aibcraux), .out1p8(o_por_vccl_1p8));

    //Changed instantiation to match with the schematic, Jennifer 05/04/18
aibcr3aux_pasred_baldwin xpasred ( 
     .iopad_crdet(u_crdet),
     .vssl_aibcr3aux(vssl_aibcr3aux), 
     .vccl_aibcr3aux(vccl_aibcr3aux), 
     .iopad_dn_por(u_dn_por), 
     .dn_por(net0317));
     //Removed instance below by Jennifer 05/04/18 to match with schematic changes
//aibcr3aux_async xasync ( .jtag_clkdr1l(jtag_clkdr1l),
//     .jtag_clkdr_int_buf(jtag_clkdr_int_buf),
//     .jtag_clkdr2r(jtag_clkdr2r), .jtag_clkdr2l(jtag_clkdr2l),
//     .jtag_clkdr1r(jtag_clkdr1r), .csr_actreden(ctrl_bus0_int[31:19]),
//     .jtag_rstb_en(jtag_rstb_en_int),
//     .csr_iocsr_sel(ctrl_bus0_int[11]), .vssl_aibcr3aux(vssl_aibcr3aux),
//     .por_vcchssi(por_vcchssi_int), .vcc_aibcr3aux(vcc_aibcr3aux),
//     .vccl_aibcr3aux(vccl_aibcr3aux), .por_vccl(o_por_vccl),
//     .iopad_auxactred2(u_auxactred2), .iopad_auxactred1(u_auxactred1),
//     .jtag_rx_scan_out_10x7(jtag_rx_scan_out),
//     .jtag_rx_scan_out_10x8(jtag_rx_scan_in_10x8),
//     .last_bs_out_10x7(last_bs_in_10x7),
//     .last_bs_out_10x8(last_bs_in_10x8), .jtag_clksel(jtag_clksel_int),
//     .jtag_intest(jtag_intest_int), .io_in(o_io_in[7:0]),
//     .io_oe(o_io_oe[1:0]), .iopad_io_out(u_io_out[7:0]),
//     .tstmx(i_tstmx[7:0]), .anlg_rstb(intrstb),
//     .csr_asyn_dataselb(vssl_aibcr3aux),
//     .csr_asyn_ndrv(ctrl_bus0_int[7:6]),
//     .csr_asyn_pdrv(ctrl_bus0_int[9:8]), .csr_asyn_rxen({vssl_aibcr3aux,
//     ctrl_bus0_int[13], vssl_aibcr3aux}),
//     .csr_asyn_txen(ctrl_bus0_int[14]), .dig_rstb(intrstb),
//     .io_out(i_io_out[7:0]), .iopad_io_in(u_io_in[7:0]),
//     .iopad_io_oe(u_io_oe[1:0]), .iopad_tstmx(u_tstmx[7:0]),
//     .jtag_mode_in(jtag_mode_int), .jtag_rstb(jtag_rstb_int),
//     .jtag_tx_scan_in_01x5(jtag_rx_scan_in_01x5),
//     .jtag_tx_scan_in_01x6(jtag_rx_scan_in_01x6),
//     .jtag_tx_scanen_in(jtag_tx_scanen_int),
//     .jtag_weakpdn(jtag_weakpdn_int), .jtag_weakpu(jtag_weakpu_int),
//     .last_bs_in_01x5(last_bs_in_01x5),
//     .last_bs_in_01x6(last_bs_in_01x6));
//
//Removed instance below by Jennifer 05/04/18 to match with schematic changes
//aibcr3aux_cnocup xcnocup ( .jtag_clkdr6r(jtag_clkdr6r),
//     .jtag_clkdr6l(jtag_clkdr6l), .jtag_clkdr5r(jtag_clkdr5r),
//     .jtag_clkdr5l(jtag_clkdr5l), .jtag_clkdr4r(jtag_clkdr4r),
//     .jtag_clkdr3r(jtag_clkdr3r), .jtag_rstb_en(jtag_rstb_en_int),
//     .last_bs_in_12x4(net0333), .csr_iocsr_sel(ctrl_bus0_int[11]),
//     .ib50u_ring(osc2cnocup_ib50u_ring), .ib50uc(osc2cnocup_ib50uc),
//     .csr_dly_ovrden(ctrl_bus2_int[0]),
//     .csr_dly_ovrd(ctrl_bus2_int[4:1]),
//     .iosc_fuse_trim(iosc_fuse_trim[9:0]),
//     .csr_cnup_txen(ctrl_bus0_int[1]),
//     .itx_clktree_cnoc(cnocup_clkp_inv3),
//     .idata1_ckp_cnoc(vcc_aibcr3aux), .idata0_ckp_cnoc(vssl_aibcr3aux),
//     .csr_cnup_ddren(vcc_aibcr3aux), .csr_cnup_dataselb(vcc_aibcr3aux),
//     .csr_cnup_pdrv(ctrl_bus0_int[9:8]),
//     .csr_cnup_ndrv(ctrl_bus0_int[7:6]), .vssl_aibcr3aux(vssl_aibcr3aux),
//     .vccl_aibcr3aux(vccl_aibcr3aux), .por_vccl(o_por_vccl),
//     .por_vcchssi(por_vcchssi_int), .vcc_aibcr3aux(vcc_aibcr3aux),
//     .cnup(cnocup_inv3[49:0]), .iopad_cnup(u_cnocup[24:0]),
//     .jtag_clksel(jtag_clksel_int), .jtag_intest(jtag_intest_int),
//     .jtag_rx_scan_out_10x3(jtag_rx_scan_in_09x3),
//     .jtag_rx_scan_out_10x4(jtag_rx_scan_in_09x4),
//     .last_bs_out_10x3(last_bs_in_09x3),
//     .last_bs_out_10x4(last_bs_in_09x4), .anlg_rstb(intrstb),
//     .dig_rstb(intrstb), .iopad_cnup_clkn(u_cnocup_clkn),
//     .iopad_cnup_clkp(u_cnocup_clkp), .jtag_mode_in(jtag_mode_int),
//     .jtag_rstb(jtag_rstb_int),
//     .jtag_tx_scan_in_02x1(jtag_rx_scan_in_02x1),
//     .jtag_tx_scan_in_02x2(jtag_rx_scan_in_02x2),
//     .jtag_tx_scanen_in(jtag_tx_scanen_int),
//     .jtag_weakpdn(jtag_weakpdn_int), .jtag_weakpu(jtag_weakpu_int),
//     .last_bs_in_02x1(last_bs_in_02x1),
//     .last_bs_in_02x2(last_bs_in_02x2));
assign net0213 = ~(c4por_vccl_ovrdb | net0317);

    //Tied-off by Jennifer 05/04/18
//aibcr3_aliasd aliasd0 ( .rb(u_jtr_tck_r), .ra(u_jtr_tck));
    assign u_jtr_tck_r = 0;
    assign u_jtr_tck = 0;
    
//aibcr_aliasd aliasd_xrtl4 ( .rb(u_jt_tdi), .ra(u_jt_tdi_r));			// Reviewed by Designer
//aibcr_aliasd aliasd_xrtl2 ( .rb(u_jt_tck), .ra(u_jt_tck_r));			// Reviewed by Designer
//aibcr_aliasd aliasd_xrtl3 ( .rb(u_jt_tms), .ra(u_jt_tms_r));			// Reviewed by Designer

    //Tied-off by Jennifer 05/04/18
//aibcr3_aliasd aliasd2 ( .rb(u_jtr_tdo_r), .ra(u_jtr_tdo));
    assign u_jtr_tdo = 0;
    assign u_jtr_tdo_r = 0;
 
//Tied-off by Jennifer 05/04/18   
//aibcr3_aliasd aliasd3 ( .rb(u_jtr_tms_r), .ra(u_jtr_tms));
    assign u_jtr_tms = 0;
    assign u_jtr_tms_r = 0;
    
//aibcr_aliasd aliasd_xrtl0 ( .rb(u_dn_rst_n), .ra(u_dn_rst_n_r));		// Reviewed by Designer
//aibcr_aliasd aliasd_xrtl1 ( .rb(u_dn_por), .ra(u_dn_por_r));			// Reviewed by Designer
aibcr3_aliasd aliasd4 ( .rb(u_crdet_r), .ra(u_crdet));
assign o_por_vcchssi = por_vcchssi_int;
assign por_vcchssi_int = o_dn_por;
aibcr3aux_osc Xosc ( .vcc_aibcraux(vcc_aibcr3aux), .vss_aibcraux(vssl_aibcr3aux),
     .vcca_aibcraux(vcca_aibcr3aux),
     .ib50u2(osc2cnocdn_ib50u_ring), .ib50u1(osc2cnocdn_ib50uc),
     .ib50u4(osc2cnocup_ib50u_ring), .ib50u3(osc2cnocup_ib50uc),
     .scan_shift_n(iatpg_scan_shift_n), .iosc_cr_rdy_dly(irstb_buf),
     .scan_out(oatpg_scan_out),
     .pipeline_global_en(iatpg_pipeline_global_en),
     .scan_clk(iatpg_scan_clk), .scan_in(iatpg_scan_in),
     .scan_mode_n(iatpg_mode_n), .scan_rst_n(iatpg_rst_n),
     .oaib_dft2osc(aibdft2osc_int[12:0]), .oosc_monitor(oosc_monitor),
     .oosc_reserved(oosc_reserved[3:0]), .oosc_atb1(oosc_atb1),
     .oosc_atb0(oosc_atb0), .oosc_clkout(osc_clkout),
     .iosc_cr_ld_cntr(ctrl_bus1_int[14:12]),
     .iosc_cr_vccdreg_vsel(ctrl_bus1_int[19:15]),
     .iosc_it50u(iosc_it50u), .iosc_cr_vreg_rdy(ctrl_bus1_int[11:9]),
     .iosc_cr_dftcounter(ctrl_bus1_int[8:6]),
     .iosc_bypclk(iosc_bypclk), .iosc_fuse_trim(iosc_fuse_trim[9:0]),
     .iaib_dft2osc(iosc_aibdft2osc[2:0]),
     .iosc_cr_trim(ctrl_bus1_int[29:21]),
     .iosc_cr_pdb(ctrl_bus1_int[20]),
     .iosc_atbmuxsel(ctrl_bus1_int[3:0]),
     .iosc_bypclken(ctrl_bus1_int[4]),
     .iosc_monitoren(ctrl_bus1_int[5]),
     .iosc_reserved(ctrl_bus2_int[23:16]), .iosc_ic50u(iosc_ic50u), .osc_extrref(osc_extrref));

     //Removed instance  below by Jennifer 05/04/18 to match schematic
//aibcr3aux_actred xactred ( .jtag_clkdr6l(jtag_clkdr6l),
//     .jtag_clkdr5l(jtag_clkdr5l),
//     .actred_shiften_chain2(iactred_shiften_chain2),
//     .actred_shiften_chain1(iactred_shiften_chain1),
//     .jtag_rstb_en(jtag_rstb_en_int), .csr_actred_txen(iactred_txen),
//     .csr_actred_pdrv(ctrl_bus0_int[9:8]),
//     .csr_actred_ndrv(ctrl_bus0_int[7:6]),
//     .csr_actred_dataselb(vssl_aibcr3aux),
//     .vccl_aibcr3aux(vccl_aibcr3aux), .por_vcchssi(por_vcchssi_int),
//     .por_vccl(o_por_vccl), .vcc_aibcr3aux(vcc_aibcr3aux),
//     .vssl_aibcr3aux(vssl_aibcr3aux), .jtag_clksel(jtag_clksel_int),
//     .jtag_intest(jtag_intest_int), .actred_chain1(i_actred1),
//     .actred_chain2(i_actred2),
//     .jtag_rx_scan_out_01x1(jtag_rx_scan_in_02x1),
//     .jtag_rx_scan_out_01x2(jtag_rx_scan_in_02x2),
//     .last_bs_out_01x1(last_bs_in_02x1),
//     .last_bs_out_01x2(last_bs_in_02x2), .anlg_rstb(intrstb),
//     .dig_rstb(intrstb), .iopad_actred_chain1(u_actred1),
//     .iopad_actred_chain2(u_actred2), .jtag_mode_in(jtag_mode_int),
//     .jtag_rstb(jtag_rstb_int),
//     .jtag_tx_scan_in_01x1(jtag_rx_scan_in_10x8),
//     .jtag_tx_scan_in_01x2(jtag_tx_scan_in),
//     .jtag_tx_scanen_in(jtag_tx_scanen_int),
//     .jtag_weakpdn(jtag_weakpdn_int), .jtag_weakpu(jtag_weakpu_int),
//     .last_bs_in_01x1(vssl_aibcr3aux), .last_bs_in_01x2(vssl_aibcr3aux));
aibcr3aux_lvshift  xlvlshf1 ( .vssl_aibcr3aux(vssl_aibcr3aux),
     .vccl_aibcr3aux(vccl_aibcr3aux), .vcc_aibcr3aux(vcc_aibcr3aux),
     .out(o_dn_por), .in(o_por_vccl));
assign jtag_clkdr_int_buf = jtag_clkdr_int;
assign irstb_buf = irstb;
assign jtag_clksel_out = jtag_clksel_out_buf;
assign jtag_clksel_int = jtag_clksel_int_buf;
assign jtag_clksel_in_buf = jtag_clksel_in;
assign jtag_intest_int = jtag_intest_int_buf;
assign jtag_intest_out = jtag_intest_out_buf;
assign jtag_intest_in_buf = jtag_intest_in;
assign jtag_tx_scanen_out = jtag_tx_scanen_buf;
assign jtag_tx_scanen_int = jtag_tx_scanen_int_buf;
assign jtag_tx_scanen_in_buf = jtag_tx_scanen_in;
assign jtag_mode_out = jtag_mode_out_buf;
assign jtag_mode_int = jtag_mode_int_buf;
assign oosc_clkout_dup = osc_clkout;
assign oosc_clkout = osc_clkout;
assign oosc_aibdft2osc[0] = dft2osc_int[0];
assign oosc_aibdft2osc[8] = dft2osc_int[8];
assign oosc_aibdft2osc[9] = dft2osc_int[9];
assign oosc_aibdft2osc[7] = dft2osc_int[7];
assign oosc_aibdft2osc[10] = dft2osc_int[10];
assign oosc_aibdft2osc[11] = dft2osc_int[11];
assign oosc_aibdft2osc[12] = dft2osc_int[12];
assign oosc_aibdft2osc[2] = dft2osc_int[2];
assign oosc_aibdft2osc[4] = dft2osc_int[4];
assign oosc_aibdft2osc[3] = dft2osc_int[3];
assign oosc_aibdft2osc[5] = dft2osc_int[5];
assign oosc_aibdft2osc[1] = dft2osc_int[1];
assign oosc_aibdft2osc[6] = dft2osc_int[6];
assign jtag_mode_buf = jtag_mode_in;
assign ctrl_bus0_int[31:0] = ~aib_aux_ctrl_bus0b[31:0];

assign ctrl_bus1_int[31:0] = ~aib_aux_ctrl_bus1b[31:0];
assign o_por_vccl = ~net0213;
assign c4por_vccl_ovrdb = ~c4por_vccl_ovrd;
assign jtag_weakpdn_int = ~jtag_weakpdn_intb;
assign jtag_tx_scanen_int_buf = ~jtag_tx_scanen_intb;
assign jtag_tx_scanen_buf = ~jtag_tx_scanen_outb;
assign jtag_rstb_out = ~jtag_rstb_outb;
assign jtag_weakpdn_out = ~jtag_weakpdn_outb;
assign jtag_clksel_out_buf = ~jtag_clksel_outb;
assign jtag_intest_out_buf = ~jtag_intest_outb;
assign jtag_weakpu_out = ~jtag_weakpu_outb;
assign ctrl_bus2_int[31:0] = ~aib_aux_ctrl_bus2b[31:0];
assign jtag_clksel_int_buf = ~jtag_clksel_intb;
assign jtag_mode_out_buf = ~jtag_mode_outb;
assign jtag_rstb_int = ~jtag_rstb_intb;
assign ctrl_bus0_intb[12] = ~ctrl_bus0_int[12];
assign jtag_intest_int_buf = ~jtag_intest_intb;
assign jtag_mode_int_buf = ~jtag_mode_intb;
assign intrstb = ~o_dn_por;
assign jtag_weakpu_int = ~jtag_weakpu_intb;
assign jtag_rstb_en_out = ~jtag_rstb_en_outb;
assign last_bs_outb = ~last_bs_in;
assign jtag_rstb_en_int = ~jtag_rstb_en_intb;
assign last_bs_out = ~last_bs_outb;
assign dft2osc_int[0] = ctrl_bus1_int[31] ? aibdft2osc_int[0] : iaib_aibdll2dft[0];
assign dft2osc_int[8] = ctrl_bus1_int[31] ? aibdft2osc_int[8] : iaib_aibdll2dft[8];
assign dft2osc_int[9] = ctrl_bus1_int[31] ? aibdft2osc_int[9] : iaib_aibdll2dft[9];
assign dft2osc_int[10] = ctrl_bus1_int[31] ? aibdft2osc_int[10] : iaib_aibdll2dft[10];
assign dft2osc_int[11] = ctrl_bus1_int[31] ? aibdft2osc_int[11] : iaib_aibdll2dft[11];
assign dft2osc_int[7] = ctrl_bus1_int[31] ? aibdft2osc_int[7] : iaib_aibdll2dft[7];
assign dft2osc_int[12] = ctrl_bus1_int[31] ? aibdft2osc_int[12] : iaib_aibdll2dft[12];
assign dft2osc_int[2] = ctrl_bus1_int[31] ? aibdft2osc_int[2] : iaib_aibdll2dft[2];
assign dft2osc_int[4] = ctrl_bus1_int[31] ? aibdft2osc_int[4] : iaib_aibdll2dft[4];
assign dft2osc_int[3] = ctrl_bus1_int[31] ? aibdft2osc_int[3] : iaib_aibdll2dft[3];
assign dft2osc_int[5] = ctrl_bus1_int[31] ? aibdft2osc_int[5] : iaib_aibdll2dft[5];
assign dft2osc_int[6] = ctrl_bus1_int[31] ? aibdft2osc_int[6] : iaib_aibdll2dft[6];
assign dft2osc_int[1] = ctrl_bus1_int[31] ? aibdft2osc_int[1] : iaib_aibdll2dft[1];
assign odft_in_async[9] = vssl_aibcr3aux;
assign odft_in_async[7] = vssl_aibcr3aux;
assign odft_in_async[6] = vssl_aibcr3aux;
assign odft_in_async[5] = vssl_aibcr3aux;
assign odft_in_async[8] = vssl_aibcr3aux;
assign odft_in_async[0] = vssl_aibcr3aux;
assign odft_in_async[1] = vssl_aibcr3aux;
assign odft_in_async[2] = vssl_aibcr3aux;
assign odft_in_async[3] = vssl_aibcr3aux;
assign odft_in_async[4] = vssl_aibcr3aux;
assign aib_aux_ctrl_bus0b[0] = ~(aib_aux_ctrl_bus0[0] & vcc_aibcr3aux);
assign aib_aux_ctrl_bus0b[1] = ~(aib_aux_ctrl_bus0[1] & vcc_aibcr3aux);
assign aib_aux_ctrl_bus0b[2] = ~(aib_aux_ctrl_bus0[2] & vcc_aibcr3aux);
assign aib_aux_ctrl_bus0b[3] = ~(aib_aux_ctrl_bus0[3] & vcc_aibcr3aux);
assign aib_aux_ctrl_bus0b[4] = ~(aib_aux_ctrl_bus0[4] & vcc_aibcr3aux);
assign aib_aux_ctrl_bus0b[5] = ~(aib_aux_ctrl_bus0[5] & vcc_aibcr3aux);
assign aib_aux_ctrl_bus0b[6] = ~(aib_aux_ctrl_bus0[6] & vcc_aibcr3aux);
assign aib_aux_ctrl_bus0b[7] = ~(aib_aux_ctrl_bus0[7] & vcc_aibcr3aux);
assign aib_aux_ctrl_bus0b[8] = ~(aib_aux_ctrl_bus0[8] & vcc_aibcr3aux);
assign aib_aux_ctrl_bus0b[9] = ~(aib_aux_ctrl_bus0[9] & vcc_aibcr3aux);
assign aib_aux_ctrl_bus0b[10] = ~(aib_aux_ctrl_bus0[10] & vcc_aibcr3aux);
assign aib_aux_ctrl_bus0b[11] = ~(aib_aux_ctrl_bus0[11] & irstb_buf);
assign aib_aux_ctrl_bus0b[12] = ~(aib_aux_ctrl_bus0[12] & vcc_aibcr3aux);
assign aib_aux_ctrl_bus0b[13] = ~(aib_aux_ctrl_bus0[13] & vcc_aibcr3aux);
assign aib_aux_ctrl_bus0b[14] = ~(aib_aux_ctrl_bus0[14] & vcc_aibcr3aux);
assign aib_aux_ctrl_bus0b[15] = ~(aib_aux_ctrl_bus0[15] & vcc_aibcr3aux);
assign aib_aux_ctrl_bus0b[16] = ~(aib_aux_ctrl_bus0[16] & vcc_aibcr3aux);
assign aib_aux_ctrl_bus0b[17] = ~(aib_aux_ctrl_bus0[17] & vcc_aibcr3aux);
assign aib_aux_ctrl_bus0b[18] = ~(aib_aux_ctrl_bus0[18] & vcc_aibcr3aux);
assign aib_aux_ctrl_bus0b[19] = ~(aib_aux_ctrl_bus0[19] & vcc_aibcr3aux);
assign aib_aux_ctrl_bus0b[20] = ~(aib_aux_ctrl_bus0[20] & vcc_aibcr3aux);
assign aib_aux_ctrl_bus0b[21] = ~(aib_aux_ctrl_bus0[21] & vcc_aibcr3aux);
assign aib_aux_ctrl_bus0b[22] = ~(aib_aux_ctrl_bus0[22] & vcc_aibcr3aux);
assign aib_aux_ctrl_bus0b[23] = ~(aib_aux_ctrl_bus0[23] & vcc_aibcr3aux);
assign aib_aux_ctrl_bus0b[24] = ~(aib_aux_ctrl_bus0[24] & vcc_aibcr3aux);
assign aib_aux_ctrl_bus0b[25] = ~(aib_aux_ctrl_bus0[25] & vcc_aibcr3aux);
assign aib_aux_ctrl_bus0b[26] = ~(aib_aux_ctrl_bus0[26] & vcc_aibcr3aux);
assign aib_aux_ctrl_bus0b[27] = ~(aib_aux_ctrl_bus0[27] & vcc_aibcr3aux);
assign aib_aux_ctrl_bus0b[28] = ~(aib_aux_ctrl_bus0[28] & vcc_aibcr3aux);
assign aib_aux_ctrl_bus0b[29] = ~(aib_aux_ctrl_bus0[29] & vcc_aibcr3aux);
assign aib_aux_ctrl_bus0b[30] = ~(aib_aux_ctrl_bus0[30] & vcc_aibcr3aux);
assign aib_aux_ctrl_bus0b[31] = ~(aib_aux_ctrl_bus0[31] & vcc_aibcr3aux);
assign jtag_rstb_outb = ~(jtag_rstb_in & vcc_aibcr3aux);
assign jtag_clksel_outb = ~(jtag_clksel_in_buf & vcc_aibcr3aux);
assign jtag_intest_intb = ~(jtag_intest_in_buf & ctrl_bus0_int[12]);
assign jtag_weakpu_outb = ~(jtag_weakpu_in & vcc_aibcr3aux);
assign jtag_intest_outb = ~(jtag_intest_in_buf & ctrl_bus0_intb[12]);
assign jtag_weakpu_intb = ~(jtag_weakpu_in & vcc_aibcr3aux);
assign aib_aux_ctrl_bus2b[31:0] = ~(aib_aux_ctrl_bus2[31:0] & {32{vcc_aibcr3aux}});
assign aib_aux_ctrl_bus1b[31:0] = ~(aib_aux_ctrl_bus1[31:0] & {32{vcc_aibcr3aux}});
assign jtag_tx_scanen_intb = ~(jtag_tx_scanen_in_buf & vcc_aibcr3aux);
assign jtag_weakpdn_outb = ~(jtag_weakpdn_in & vcc_aibcr3aux);
assign jtag_rstb_intb = ~(jtag_rstb_in & vcc_aibcr3aux);
assign jtag_tx_scanen_outb = ~(jtag_tx_scanen_in_buf & vcc_aibcr3aux);
assign jtag_mode_intb = ~(jtag_mode_buf & ctrl_bus0_intb[12]);
assign jtag_rstb_en_intb = ~(jtag_rstb_en_in & ctrl_bus0_intb[12]);
assign jtag_weakpdn_intb = ~(jtag_weakpdn_in & vcc_aibcr3aux);
assign jtag_rstb_en_outb = ~(jtag_rstb_en_in & vcc_aibcr3aux);
assign jtag_clksel_intb = ~(jtag_clksel_in_buf & vcc_aibcr3aux);
assign jtag_clkdr_intb = ~(jtag_clkdr_in & vcc_aibcr3aux);
assign jtag_clkdr_outb = ~(jtag_clkdr_in & vcc_aibcr3aux);
assign jtag_mode_outb = ~(jtag_mode_buf & vcc_aibcr3aux);
assign o_cnocdn[31:0] = ~cnocdn_inv3[31:0];
assign o_cnocdn_clkp = ~cnocdn_clkp_inv3;
assign cnocdn_clkp_inv3 = ~cnocdn_clkp_inv2;
assign cnocdn_clkp_inv2 = ~cnocdn_clkp_inv1;
assign cnocdn_clkp_inv1 = ~cnocdn_clkp_inv0;
assign cnocdn_inv2[31:0] = ~cnocdn_inv1[31:0];
assign cnocdn_inv3[31:0] = ~cnocdn_inv2[31:0];
assign cnocdn_inv1[31:0] = ~cnocdn_inv0[31:0];
assign cnocup_inv0[49:0] = ~i_cnocup[49:0];
assign cnocup_clkp_inv0 = ~i_cnocup_clkp;
assign cnocup_clkp_inv3 = ~cnocup_clkp_inv2;
assign cnocup_clkp_inv2 = ~cnocup_clkp_inv1;
assign cnocup_clkp_inv1 = ~cnocup_clkp_inv0;
assign cnocup_inv3[49:0] = ~cnocup_inv2[49:0];
assign cnocup_inv1[49:0] = ~cnocup_inv0[49:0];
assign cnocup_inv2[49:0] = ~cnocup_inv1[49:0];
assign jtag_clkdr6r = jtag_clkdr5r;
assign jtag_clkdr6l = jtag_clkdr5l;
assign jtag_clkdr5l = jtag_clkdr4l;
assign jtag_clkdr5r = jtag_clkdr4r;
assign jtag_clkdr4r = jtag_clkdr3r;
assign jtag_clkdr4l = jtag_clkdr3l;
assign jtag_clkdr3r = jtag_clkdr2r;
assign jtag_clkdr3l = jtag_clkdr2l;
assign jtag_clkdr2r = jtag_clkdr1r;
assign jtag_clkdr2l = jtag_clkdr1l;
assign jtag_clkdr1r = jtag_clkdr_int_buf;
assign jtag_clkdr1l = jtag_clkdr_int_buf;
assign jtag_clkdr_int = ~jtag_clkdr_intb;
assign jtag_clkdr_out = ~jtag_clkdr_outb_buf;
assign jtag_clkdr_outb_buf = jtag_clkdr_outb;

//Changed by Jennifer 05/04/18 to match with schematic changes
assign jtag_rx_scan_out = jtag_tx_scan_in;

endmodule

