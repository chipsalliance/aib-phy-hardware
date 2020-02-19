// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcraux_lib, Cell - aibcraux_top_wrp, View - schematic
// LAST TIME SAVED: Apr 17 16:46:56 2015
// NETLIST TIME: Jun  3 17:00:06 2015
`timescale 1ps / 1ps 

module aibcr3aux_top_wrp ( jtag_clkdr_out, jtag_clksel_out,
     jtag_intest_out, jtag_mode_out, jtag_rstb_en_out, jtag_rstb_out,
     jtag_rx_scan_out, jtag_tx_scanen_out, jtag_weakpdn_out,
     jtag_weakpu_out, last_bs_out, o_cnocdn, o_cnocdn_clkp, o_dn_por,
     o_dn_rst_n, o_io_in, o_io_oe, o_jt_tck, o_jt_tdi, o_jt_tms,
     o_por_vcchssi, o_por_vccl, o_por_vccl_1p8, oatpg_scan_out,
     odft_in_async, oosc_aibdft2osc, oosc_atb0, oosc_atb1, oosc_clkout_dup, oosc_clkout,
     oosc_monitor, oosc_reserved, aib_aux0, aib_aux1, aib_aux2,
     aib_aux3, aib_aux4, aib_aux5, aib_aux6, aib_aux7, aib_aux8,
     aib_aux9, aib_aux10, aib_aux11, aib_aux12, aib_aux13, aib_aux14,
     aib_aux15, aib_aux16, aib_aux17, aib_aux18, aib_aux19, aib_aux20,
     aib_aux21, aib_aux22, aib_aux23, aib_aux24, aib_aux25, aib_aux26,
     aib_aux27, aib_aux28, aib_aux29, aib_aux30, aib_aux31, aib_aux32,
     aib_aux33, aib_aux34, aib_aux35, aib_aux36, aib_aux37, aib_aux38,
     aib_aux39, aib_aux40, aib_aux41, aib_aux42, aib_aux43, aib_aux44,
     aib_aux45, aib_aux46, aib_aux47, aib_aux48, aib_aux49, aib_aux50,
     aib_aux51, aib_aux52, aib_aux53, aib_aux54, aib_aux55, aib_aux56,
     aib_aux57, aib_aux58, aib_aux59, aib_aux60, aib_aux61, aib_aux62,
     aib_aux63, aib_aux64, aib_aux65, aib_aux66, aib_aux67, aib_aux68,
     aib_aux69, aib_aux70, aib_aux71, aib_aux72, aib_aux73, aib_aux74,
     aib_aux75, aib_aux76, aib_aux77, aib_aux78, aib_aux79, aib_aux80,
     aib_aux81, aib_aux82, aib_aux83, aib_aux84, aib_aux85, aib_aux86,
     aib_aux87, aib_aux88, aib_aux89, aib_aux90, aib_aux91, aib_aux92,
     aib_aux93, aib_aux94, aib_aux95, aib_aux_ctrl_bus0,
     aib_aux_ctrl_bus1, aib_aux_ctrl_bus2, c4por_vccl_ovrd, i_actred1,
     i_actred2, i_cnocup, i_cnocup_clkp, i_io_out, i_jtr_tck,
     i_jtr_tdo, i_jtr_tms, i_tstmx, iactred_txen1, iactred_txen2,
     iaib_aibdll2dft, iatpg_mode_n, iatpg_pipeline_global_en,
     iatpg_rst_n, iatpg_scan_clk, iatpg_scan_in, iatpg_scan_shift_n,
     idft_bypass_en, idft_out_async, iosc_aibdft2osc, iosc_bypclk,
     iosc_fuse_trim, iosc_ic50u, iosc_it50u, ired_idataselb_in_chain1,
     ired_idataselb_in_chain2, ired_shift_en_in_chain1,
     ired_shift_en_in_chain2, irstb, jtag_clkdr_in, jtag_clksel_in,
     jtag_intest_in, jtag_mode_in, jtag_rstb_en_in, jtag_rstb_in,
     jtag_tx_scan_in, jtag_tx_scanen_in, jtag_weakpdn_in,
     jtag_weakpu_in, last_bs_in, osc_extrref); //vcc_aibcraux, vcca_aibcraux,
     //vccl_aibcraux, vccr_aibcraux, vssl_aibcraux );

wire vcc_aibcraux, vcca_aibcraux, vccl_aibcraux, vccr_aibcraux, vssl_aibcraux;

output  jtag_clkdr_out, jtag_clksel_out, jtag_intest_out,
     jtag_mode_out, jtag_rstb_en_out, jtag_rstb_out, jtag_rx_scan_out,
     jtag_tx_scanen_out, jtag_weakpdn_out, jtag_weakpu_out,
     last_bs_out, o_cnocdn_clkp, o_dn_por, o_dn_rst_n, o_jt_tck,
     o_jt_tdi, o_jt_tms, o_por_vcchssi, o_por_vccl, o_por_vccl_1p8,
     oatpg_scan_out, oosc_atb0, oosc_atb1, oosc_clkout_dup, oosc_clkout, oosc_monitor;

inout  aib_aux0, aib_aux1, aib_aux2, aib_aux3, aib_aux4, aib_aux5,
     aib_aux6, aib_aux7, aib_aux8, aib_aux9, aib_aux10, aib_aux11,
     aib_aux12, aib_aux13, aib_aux14, aib_aux15, aib_aux16, aib_aux17,
     aib_aux18, aib_aux19, aib_aux20, aib_aux21, aib_aux22, aib_aux23,
     aib_aux24, aib_aux25, aib_aux26, aib_aux27, aib_aux28, aib_aux29,
     aib_aux30, aib_aux31, aib_aux32, aib_aux33, aib_aux34, aib_aux35,
     aib_aux36, aib_aux37, aib_aux38, aib_aux39, aib_aux40, aib_aux41,
     aib_aux42, aib_aux43, aib_aux44, aib_aux45, aib_aux46, aib_aux47,
     aib_aux48, aib_aux49, aib_aux50, aib_aux51, aib_aux52, aib_aux53,
     aib_aux54, aib_aux55, aib_aux56, aib_aux57, aib_aux58, aib_aux59,
     aib_aux60, aib_aux61, aib_aux62, aib_aux63, aib_aux64, aib_aux65,
     aib_aux66, aib_aux67, aib_aux68, aib_aux69, aib_aux70, aib_aux71,
     aib_aux72, aib_aux73, aib_aux74, aib_aux75, aib_aux76, aib_aux77,
     aib_aux78, aib_aux79, aib_aux80, aib_aux81, aib_aux82, aib_aux83,
     aib_aux84, aib_aux85, aib_aux86, aib_aux87, aib_aux88, aib_aux89,
     aib_aux90, aib_aux91, aib_aux92, aib_aux93, aib_aux94, aib_aux95;

inout osc_extrref;

input  c4por_vccl_ovrd, i_actred1, i_actred2, i_cnocup_clkp, i_jtr_tck,
     i_jtr_tdo, i_jtr_tms, iactred_txen1, iactred_txen2, iatpg_mode_n,
     iatpg_pipeline_global_en, iatpg_rst_n, iatpg_scan_clk,
     iatpg_scan_in, iatpg_scan_shift_n, idft_bypass_en, iosc_bypclk,
     iosc_ic50u, iosc_it50u, ired_idataselb_in_chain1,
     ired_idataselb_in_chain2, ired_shift_en_in_chain1,
     ired_shift_en_in_chain2, irstb, jtag_clkdr_in, jtag_clksel_in,
     jtag_intest_in, jtag_mode_in, jtag_rstb_en_in, jtag_rstb_in,
     jtag_tx_scan_in, jtag_tx_scanen_in, jtag_weakpdn_in,
     jtag_weakpu_in, last_bs_in; //vcc_aibcraux, vcca_aibcraux,
     //vccl_aibcraux, vccr_aibcraux, vssl_aibcraux;
     //

assign vcc_aibcraux = 1'b1;
assign vcca_aibcraux = 1'b1;
assign vccl_aibcraux = 1'b1;
assign vccr_aibcraux = 1'b1;
assign vssl_aibcraux =1'b0;

assign aib_aux24 =1'b0;
assign aib_aux89 =1'b0;
assign aib_aux91 =1'b0;

output [9:0]  odft_in_async;
output [31:0]  o_cnocdn;
output [7:0]  o_io_in;
output [1:0]  o_io_oe;
output [12:0]  oosc_aibdft2osc;
output [3:0]  oosc_reserved;

input [12:0]  iaib_aibdll2dft;
input [31:0]  aib_aux_ctrl_bus0;
input [31:0]  aib_aux_ctrl_bus1;
input [31:0]  aib_aux_ctrl_bus2;
input [49:0]  i_cnocup;
input [7:0]  i_io_out;
input [7:0]  i_tstmx;
input [7:0]  idft_out_async;
input [2:0]  iosc_aibdft2osc;
input [9:0]  iosc_fuse_trim;

                                        /////////////////////////////////
                                        // for VCS and ICC compatibility
                                        /////////////////////////////////
`ifdef WREAL
    real oosc_atb0, oosc_atb1;
`endif

// specify 
//     specparam CDS_LIBNAME  = "aibcraux_lib";
//     specparam CDS_CELLNAME = "aibcraux_top_wrp";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

aibcr3aux_top xaibcraux_top ( .vccr_aibcraux(vccr_aibcraux),
     .iactred_shiften_chain2(ired_shift_en_in_chain2),
     .iactred_shiften_chain1(ired_shift_en_in_chain1),
     .jtag_rstb_en_in(jtag_rstb_en_in),
     .jtag_rstb_en_out(jtag_rstb_en_out), .u_crdet_r(aib_aux75),
     .u_crdet(aib_aux74), .iatpg_scan_shift_n(iatpg_scan_shift_n),
     .oatpg_scan_out(oatpg_scan_out),
     .odft_in_async(odft_in_async[9:0]), .iatpg_mode_n(iatpg_mode_n),
     .iatpg_pipeline_global_en(iatpg_pipeline_global_en),
     .iatpg_rst_n(iatpg_rst_n), .iatpg_scan_clk(iatpg_scan_clk),
     .iatpg_scan_in(iatpg_scan_in), .idft_bypass_en(idft_bypass_en),
     .o_jt_tck(o_jt_tck), .vssl_aibcr3aux(vssl_aibcraux),
     .vccl_aibcr3aux(vccl_aibcraux), .vcca_aibcr3aux(vcca_aibcraux),
     .vcc_aibcr3aux(vcc_aibcraux), .o_jt_tms(o_jt_tms),
     .iaib_aibdll2dft(iaib_aibdll2dft[12:0]),
     .jtag_clkdr_out(jtag_clkdr_out),
     .jtag_clksel_out(jtag_clksel_out),
     .jtag_intest_out(jtag_intest_out), .jtag_mode_out(jtag_mode_out),
     .jtag_rstb_out(jtag_rstb_out),
     .jtag_rx_scan_out(jtag_rx_scan_out),
     .jtag_tx_scanen_out(jtag_tx_scanen_out),
     .jtag_weakpdn_out(jtag_weakpdn_out),
     .jtag_weakpu_out(jtag_weakpu_out), .last_bs_out(last_bs_out),
     .o_cnocdn(o_cnocdn[31:0]), .o_cnocdn_clkp(o_cnocdn_clkp),
     .o_dn_por(o_dn_por), .o_dn_rst_n(o_dn_rst_n),
     .o_io_in(o_io_in[7:0]), .o_io_oe(o_io_oe[1:0]),
     .o_jt_tdi(o_jt_tdi), .o_por_vcchssi(o_por_vcchssi),
     .o_por_vccl(o_por_vccl), .o_por_vccl_1p8(o_por_vccl_1p8),
     .oosc_aibdft2osc(oosc_aibdft2osc[12:0]), .oosc_atb0(oosc_atb0),
     .oosc_atb1(oosc_atb1), .oosc_clkout_dup(oosc_clkout_dup), .oosc_clkout(oosc_clkout),
     .oosc_monitor(oosc_monitor), .oosc_reserved(oosc_reserved[3:0]),
     .u_actred1(aib_aux20), .u_actred2(aib_aux18),
     .u_auxactred1(aib_aux94), .u_auxactred2(aib_aux93),
     .u_cnocup({aib_aux26, aib_aux42, aib_aux44, aib_aux43, aib_aux41,
     aib_aux16, aib_aux22, aib_aux23, aib_aux21, aib_aux14, aib_aux12,
     aib_aux13, aib_aux15, aib_aux8, aib_aux10, aib_aux6, aib_aux4,
     aib_aux5, aib_aux7, aib_aux0, aib_aux2, aib_aux3, aib_aux1,
     aib_aux19, aib_aux17}), .u_cnocup_clkn(aib_aux11),
     .u_cnocup_clkp(aib_aux9), .u_io_out({aib_aux65, aib_aux67,
     aib_aux60, aib_aux62, aib_aux63, aib_aux61, aib_aux58,
     aib_aux56}), .u_jtr_tck(aib_aux77), .u_jtr_tck_r(aib_aux76),
     .u_jtr_tdo(aib_aux78), .u_jtr_tdo_r(aib_aux79),
     .u_jtr_tms(aib_aux73), .u_jtr_tms_r(aib_aux72),
     .u_tstmx({aib_aux95, aib_aux92, aib_aux68, aib_aux70, aib_aux71,
     aib_aux69, aib_aux66, aib_aux64}),
     .aib_aux_ctrl_bus0(aib_aux_ctrl_bus0[31:0]),
     .aib_aux_ctrl_bus1(aib_aux_ctrl_bus1[31:0]),
     .aib_aux_ctrl_bus2(aib_aux_ctrl_bus2[31:0]),
     .c4por_vccl_ovrd(c4por_vccl_ovrd), .i_actred1(i_actred1),
     .i_actred2(i_actred2), .i_cnocup(i_cnocup[49:0]),
     .i_cnocup_clkp(i_cnocup_clkp), .i_io_out(i_io_out[7:0]),
     .i_jtr_tck(i_jtr_tck), .i_jtr_tdo(i_jtr_tdo),
     .i_jtr_tms(i_jtr_tms), .i_tstmx(i_tstmx[7:0]),
     .iactred_txen(iactred_txen1),
     .idft_out_async(idft_out_async[7:0]),
     .iosc_aibdft2osc(iosc_aibdft2osc[2:0]), .iosc_bypclk(iosc_bypclk),
     .iosc_fuse_trim(iosc_fuse_trim[9:0]), .iosc_ic50u(iosc_ic50u),
     .iosc_it50u(iosc_it50u), .irstb(irstb),
     .jtag_clkdr_in(jtag_clkdr_in), .jtag_clksel_in(jtag_clksel_in),
     .jtag_intest_in(jtag_intest_in), .jtag_mode_in(jtag_mode_in),
     .jtag_rstb_in(jtag_rstb_in), .jtag_tx_scan_in(jtag_tx_scan_in),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .jtag_weakpdn_in(jtag_weakpdn_in),
     .jtag_weakpu_in(jtag_weakpu_in), .last_bs_in(last_bs_in),
     .u_cnocdn({aib_aux47, aib_aux45, aib_aux40, aib_aux46, aib_aux37,
     aib_aux39, aib_aux38, aib_aux36, aib_aux35, aib_aux33, aib_aux29,
     aib_aux31, aib_aux30, aib_aux28, aib_aux27, aib_aux25}),
     .u_cnocdn_clkn(aib_aux32), .u_cnocdn_clkp(aib_aux34),
     .u_dn_por(aib_aux85), .u_dn_por_r(aib_aux87),
     .u_dn_rst_n(aib_aux90), .u_dn_rst_n_r(aib_aux88),
     .u_io_in({aib_aux52, aib_aux54, aib_aux55, aib_aux53, aib_aux50,
     aib_aux48, aib_aux49, aib_aux51}), .u_io_oe({aib_aux57,
     aib_aux59}), .u_jt_tck(aib_aux83), .u_jt_tck_r(aib_aux81),
     .u_jt_tdi(aib_aux86), .u_jt_tdi_r(aib_aux84),
     .u_jt_tms(aib_aux80), .u_jt_tms_r(aib_aux82), .osc_extrref(osc_extrref));

endmodule

