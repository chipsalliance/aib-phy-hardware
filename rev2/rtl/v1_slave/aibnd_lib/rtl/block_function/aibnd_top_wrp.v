// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibnd_lib, Cell - aibnd_top_wrp, View - schematic
// LAST TIME SAVED: Apr  8 09:44:04 2015
// NETLIST TIME: May 12 19:29:56 2015
`timescale 1ps / 1ps 

module aibnd_top_wrp ( aib65, aib66, aib76, aib79, aib77, aib81, aib91,
     aib89, aib90, aib88, aib63, aib64, aib61, aib49, aib56, aib48,
     aib55, aib50, aib51, aib57, aib59, aib54, aib52, aib53, aib60,
     aib47, aib44, aib67, aib45, aib46, aib58, aib62, aib87, aib86,
     aib19, aib41, aib40, aib85, aib84, aib82, aib83, aib95, aib93,
     aib94, aib92, aib39, aib43, aib42, aib74,
     aib_fabric_adapter_rx_pld_rst_n, aib_fabric_adapter_tx_pld_rst_n,
     aib_fabric_avmm1_data_in, aib_fabric_avmm1_data_out,
     aib_fabric_avmm2_data_in, aib_fabric_avmm2_data_out,
     aib_fabric_fsr_data_in, aib_fabric_fsr_data_out,
     aib_fabric_fsr_load_in, aib_fabric_fsr_load_out,
     aib_fabric_pcs_rx_pld_rst_n, aib_fabric_pcs_tx_pld_rst_n,
     aib_fabric_pld_8g_rxelecidle, aib_fabric_pld_pcs_rx_clk_out,
     aib_fabric_pld_pcs_tx_clk_out, aib_fabric_pld_pma_clkdiv_rx_user,
     aib_fabric_pld_pma_clkdiv_tx_user, aib_fabric_pld_pma_coreclkin,
     aib_fabric_pld_pma_hclk, aib_fabric_pld_pma_internal_clk1,
     aib_fabric_pld_pma_internal_clk2, aib_fabric_pld_pma_pfdmode_lock,
     aib_fabric_pld_pma_rxpll_lock, aib_fabric_pld_pma_rxpma_rstb,
     aib_fabric_pld_pma_txdetectrx, aib_fabric_pld_pma_txpma_rstb,
     aib_fabric_pld_rx_hssi_fifo_latency_pulse, aib_fabric_pld_sclk,
     aib_fabric_pld_tx_hssi_fifo_latency_pulse,
     aib_fabric_pma_aib_tx_clk, aib_fabric_rx_data_in,
     aib_fabric_rx_transfer_clk, aib_fabric_tx_sr_clk_out,
     aib_fabric_rx_sr_clk_in, aib_fabric_tx_sr_clk_in,
     aib_fabric_ssr_data_in, aib_fabric_ssr_load_out,
     aib_fabric_tx_data_out, aib_fabric_tx_transfer_clk,
     aib_fabric_fpll_shared_direct_async_in,
     aib_fabric_fpll_shared_direct_async_out,
     aib_fabric_tx_dcd_cal_req, aib_fabric_rx_dll_lock_req,
     aib_fabric_rx_dll_lock, aib_fabric_tx_dcd_cal_done,
     aib_fabric_csr_rdy_dly_in, r_aib_csr_ctrl_0, r_aib_csr_ctrl_1,
     r_aib_csr_ctrl_2, r_aib_csr_ctrl_3, r_aib_csr_ctrl_4,
     r_aib_csr_ctrl_5, r_aib_csr_ctrl_6, r_aib_csr_ctrl_7,
     r_aib_csr_ctrl_8, r_aib_csr_ctrl_9, r_aib_csr_ctrl_10,
     r_aib_csr_ctrl_11, r_aib_csr_ctrl_12, r_aib_csr_ctrl_13,
     r_aib_csr_ctrl_14, r_aib_csr_ctrl_15, r_aib_csr_ctrl_16,
     r_aib_csr_ctrl_17, r_aib_csr_ctrl_18, r_aib_csr_ctrl_19,
     r_aib_csr_ctrl_20, r_aib_csr_ctrl_21, r_aib_csr_ctrl_22,
     r_aib_csr_ctrl_23, r_aib_csr_ctrl_24, r_aib_csr_ctrl_25,
     r_aib_csr_ctrl_26, r_aib_csr_ctrl_27, r_aib_csr_ctrl_28,
     r_aib_csr_ctrl_29, r_aib_csr_ctrl_30, r_aib_csr_ctrl_31,
     r_aib_csr_ctrl_32, r_aib_csr_ctrl_33, r_aib_csr_ctrl_34,
     r_aib_csr_ctrl_35, r_aib_csr_ctrl_36, r_aib_csr_ctrl_37,
     r_aib_csr_ctrl_38, r_aib_csr_ctrl_39, r_aib_csr_ctrl_40,
     r_aib_csr_ctrl_41, r_aib_csr_ctrl_42, r_aib_csr_ctrl_43,
     r_aib_csr_ctrl_44, r_aib_csr_ctrl_45, r_aib_csr_ctrl_46,
     r_aib_csr_ctrl_47, r_aib_csr_ctrl_48, r_aib_csr_ctrl_49,
     r_aib_csr_ctrl_50, r_aib_csr_ctrl_51, r_aib_csr_ctrl_52,
     r_aib_csr_ctrl_53, r_aib_csr_ctrl_54, r_aib_csr_ctrl_55,
     r_aib_csr_ctrl_56, r_aib_csr_ctrl_57, r_aib_dprio_ctrl_0,
     r_aib_dprio_ctrl_1, r_aib_dprio_ctrl_2, r_aib_dprio_ctrl_3,
     r_aib_dprio_ctrl_4, ired_directin_data_in_chain1,
     ired_directin_data_in_chain2, ired_irxen_in_chain1,
     ired_irxen_in_chain2, ored_directin_data_out0_chain1,
     ored_directin_data_out0_chain2, ored_rxen_out_chain1,
     ored_rxen_out_chain2, // vccl_aibnd, vssl_aibnd,
     aib_fabric_ssr_data_out, aib_fabric_ssr_load_in, oaibdftdll2core,
     ojtag_clkdr_out_chain, ojtag_last_bs_out_chain,
     ojtag_rx_scan_out_chain, ijtag_clkdr_in_chain,
     ijtag_last_bs_in_chain, ijtag_tx_scan_in_chain, iaibdftcore2dll,
     jtag_mode_in, jtag_rstb_en, jtag_rstb, jtag_tx_scanen_in,
     jtag_weakpdn, jtag_weakpu, jtag_intest, jtag_clksel,
     jtag_mode_out, jtag_rstb_en_out, jtag_rstb_out,
     jtag_tx_scanen_out, jtag_weakpdn_out, jtag_weakpu_out,
     jtag_intest_out, jtag_clksel_out, iatpg_scan_rst_n,
     iatpg_pipeline_global_en, iatpg_scan_mode_n, iatpg_scan_shift_n,
     iatpg_scan_clk_in0, iatpg_scan_clk_in1, iatpg_scan_in0,
     iatpg_scan_in1, oatpg_scan_out0, oatpg_scan_out1, aib73, aib72,
     aib75, aib70, aib71, aib69, aib68, aib18, aib17, aib16, aib15,
     aib14, aib13, aib12, aib11, aib10, aib9, aib8, aib7, aib6, aib5,
     aib4, aib3, aib2, aib1, aib0, aib78, aib80, aib38, aib37, aib36,
     aib35, aib34, aib33, aib32, aib31, aib30, aib29, aib28, aib27,
     aib26, aib25, aib24, aib23, aib22, aib21, aib20,
     ired_shift_en_in_chain2, ired_shift_en_in_chain1,
     ored_shift_en_out_chain1, ored_shift_en_out_chain2 );

output  aib_fabric_avmm1_data_in, aib_fabric_avmm2_data_in,
     aib_fabric_fsr_data_in, aib_fabric_fsr_load_in,
     aib_fabric_pld_8g_rxelecidle, aib_fabric_pld_pcs_rx_clk_out,
     aib_fabric_pld_pcs_tx_clk_out, aib_fabric_pld_pma_clkdiv_rx_user,
     aib_fabric_pld_pma_clkdiv_tx_user, aib_fabric_pld_pma_hclk,
     aib_fabric_pld_pma_internal_clk1,
     aib_fabric_pld_pma_internal_clk2, aib_fabric_pld_pma_pfdmode_lock,
     aib_fabric_pld_pma_rxpll_lock,
     aib_fabric_pld_rx_hssi_fifo_latency_pulse,
     aib_fabric_pld_tx_hssi_fifo_latency_pulse,
     aib_fabric_pma_aib_tx_clk, aib_fabric_rx_dll_lock,
     aib_fabric_rx_sr_clk_in, aib_fabric_rx_transfer_clk,
     aib_fabric_ssr_data_in, aib_fabric_ssr_load_in,
     aib_fabric_tx_dcd_cal_done, aib_fabric_tx_sr_clk_in,
     jtag_clksel_out, jtag_intest_out, jtag_mode_out, jtag_rstb_en_out,
     jtag_rstb_out, jtag_tx_scanen_out, jtag_weakpdn_out,
     jtag_weakpu_out, oatpg_scan_out0, oatpg_scan_out1,
     ojtag_clkdr_out_chain, ojtag_last_bs_out_chain,
     ojtag_rx_scan_out_chain, ored_directin_data_out0_chain1,
     ored_directin_data_out0_chain2, ored_shift_en_out_chain1,
     ored_shift_en_out_chain2;

inout  aib0, aib1, aib2, aib3, aib4, aib5, aib6, aib7, aib8, aib9,
     aib10, aib11, aib12, aib13, aib14, aib15, aib16, aib17, aib18,
     aib19, aib20, aib21, aib22, aib23, aib24, aib25, aib26, aib27,
     aib28, aib29, aib30, aib31, aib32, aib33, aib34, aib35, aib36,
     aib37, aib38, aib39, aib40, aib41, aib42, aib43, aib44, aib45,
     aib46, aib47, aib48, aib49, aib50, aib51, aib52, aib53, aib54,
     aib55, aib56, aib57, aib58, aib59, aib60, aib61, aib62, aib63,
     aib64, aib65, aib66, aib67, aib68, aib69, aib70, aib71, aib72,
     aib73, aib74, aib75, aib76, aib77, aib78, aib79, aib80, aib81,
     aib82, aib83, aib84, aib85, aib86, aib87, aib88, aib89, aib90,
     aib91, aib92, aib93, aib94, aib95;

input  aib_fabric_adapter_rx_pld_rst_n,
     aib_fabric_adapter_tx_pld_rst_n, aib_fabric_csr_rdy_dly_in,
     aib_fabric_fsr_data_out, aib_fabric_fsr_load_out,
     aib_fabric_pcs_rx_pld_rst_n, aib_fabric_pcs_tx_pld_rst_n,
     aib_fabric_pld_pma_coreclkin, aib_fabric_pld_pma_rxpma_rstb,
     aib_fabric_pld_pma_txdetectrx, aib_fabric_pld_pma_txpma_rstb,
     aib_fabric_pld_sclk, aib_fabric_rx_dll_lock_req,
     aib_fabric_ssr_data_out, aib_fabric_ssr_load_out,
     aib_fabric_tx_dcd_cal_req, aib_fabric_tx_sr_clk_out,
     aib_fabric_tx_transfer_clk, iatpg_pipeline_global_en,
     iatpg_scan_clk_in0, iatpg_scan_clk_in1, iatpg_scan_in0,
     iatpg_scan_in1, iatpg_scan_mode_n, iatpg_scan_rst_n,
     iatpg_scan_shift_n, ijtag_clkdr_in_chain, ijtag_last_bs_in_chain,
     ijtag_tx_scan_in_chain, ired_directin_data_in_chain1,
     ired_directin_data_in_chain2, ired_shift_en_in_chain1,
     ired_shift_en_in_chain2, jtag_clksel, jtag_intest, jtag_mode_in,
     jtag_rstb, jtag_rstb_en, jtag_tx_scanen_in, jtag_weakpdn,
     jtag_weakpu; 
     //vccl_aibnd, vssl_aibnd;

assign vccl_aibnd = 1'b1;
assign vssl_aibnd = 1'b0;

output [2:0]  ored_rxen_out_chain1;
output [2:0]  ored_rxen_out_chain2;
output [12:0]  oaibdftdll2core;
output [39:0]  aib_fabric_rx_data_in;
output [4:0]  aib_fabric_fpll_shared_direct_async_in;

input [7:0]  r_aib_csr_ctrl_57;
input [7:0]  r_aib_csr_ctrl_51;
input [7:0]  r_aib_csr_ctrl_40;
input [7:0]  r_aib_csr_ctrl_46;
input [2:0]  ired_irxen_in_chain2;
input [7:0]  r_aib_csr_ctrl_36;
input [7:0]  r_aib_csr_ctrl_42;
input [7:0]  r_aib_csr_ctrl_48;
input [7:0]  r_aib_csr_ctrl_49;
input [7:0]  r_aib_csr_ctrl_44;
input [7:0]  r_aib_csr_ctrl_39;
input [7:0]  r_aib_csr_ctrl_43;
input [7:0]  r_aib_csr_ctrl_38;
input [7:0]  r_aib_csr_ctrl_55;
input [7:0]  r_aib_csr_ctrl_41;
input [1:0]  aib_fabric_avmm2_data_out;
input [7:0]  r_aib_csr_ctrl_56;
input [7:0]  r_aib_dprio_ctrl_4;
input [7:0]  r_aib_csr_ctrl_52;
input [7:0]  r_aib_csr_ctrl_54;
input [7:0]  r_aib_csr_ctrl_47;
input [2:0]  ired_irxen_in_chain1;
input [7:0]  r_aib_csr_ctrl_45;
input [39:0]  aib_fabric_tx_data_out;
input [7:0]  r_aib_csr_ctrl_50;
input [7:0]  r_aib_csr_ctrl_53;
input [1:0]  aib_fabric_avmm1_data_out;
input [2:0]  iaibdftcore2dll;
input [2:0]  aib_fabric_fpll_shared_direct_async_out;
input [7:0]  r_aib_csr_ctrl_16;
input [7:0]  r_aib_dprio_ctrl_0;
input [7:0]  r_aib_dprio_ctrl_1;
input [7:0]  r_aib_csr_ctrl_33;
input [7:0]  r_aib_csr_ctrl_35;
input [7:0]  r_aib_csr_ctrl_34;
input [7:0]  r_aib_csr_ctrl_26;
input [7:0]  r_aib_csr_ctrl_27;
input [7:0]  r_aib_dprio_ctrl_2;
input [7:0]  r_aib_dprio_ctrl_3;
input [7:0]  r_aib_csr_ctrl_30;
input [7:0]  r_aib_csr_ctrl_25;
input [7:0]  r_aib_csr_ctrl_37;
input [7:0]  r_aib_csr_ctrl_28;
input [7:0]  r_aib_csr_ctrl_29;
input [7:0]  r_aib_csr_ctrl_31;
input [7:0]  r_aib_csr_ctrl_23;
input [7:0]  r_aib_csr_ctrl_24;
input [7:0]  r_aib_csr_ctrl_18;
input [7:0]  r_aib_csr_ctrl_15;
input [7:0]  r_aib_csr_ctrl_14;
input [7:0]  r_aib_csr_ctrl_13;
input [7:0]  r_aib_csr_ctrl_12;
input [7:0]  r_aib_csr_ctrl_32;
input [7:0]  r_aib_csr_ctrl_20;
input [7:0]  r_aib_csr_ctrl_21;
input [7:0]  r_aib_csr_ctrl_19;
input [7:0]  r_aib_csr_ctrl_17;
input [7:0]  r_aib_csr_ctrl_22;
input [7:0]  r_aib_csr_ctrl_10;
input [7:0]  r_aib_csr_ctrl_9;
input [7:0]  r_aib_csr_ctrl_1;
input [7:0]  r_aib_csr_ctrl_6;
input [7:0]  r_aib_csr_ctrl_7;
input [7:0]  r_aib_csr_ctrl_8;
input [7:0]  r_aib_csr_ctrl_5;
input [7:0]  r_aib_csr_ctrl_0;
input [7:0]  r_aib_csr_ctrl_3;
input [7:0]  r_aib_csr_ctrl_11;
input [7:0]  r_aib_csr_ctrl_4;
input [7:0]  r_aib_csr_ctrl_2;


// specify 
//     specparam CDS_LIBNAME  = "aibnd_lib";
//     specparam CDS_CELLNAME = "aibnd_top_wrp";
//     specparam CDS_VIEWNAME = "schematic";
// endspecify

aibnd_top xaibnd_top ( .ihssirx_out_ddren(r_aib_csr_ctrl_24[6]),
     .ijtag_tx_scan_in_chain(ijtag_tx_scan_in_chain),
     .ojtag_rx_scan_out_chain(ojtag_rx_scan_out_chain),
     .iatpg_scan_shift_n(iatpg_scan_shift_n),
     .ired_shift_en_in_chain2(ired_shift_en_in_chain2),
     .ired_shift_en_in_chain1(ired_shift_en_in_chain1),
     .ored_shift_en_out_chain1(ored_shift_en_out_chain1),
     .ihssitxdll_rb_clkdiv_str({r_aib_csr_ctrl_22[4],
     r_aib_csr_ctrl_18[7:6]}),
     .ored_shift_en_out_chain2(ored_shift_en_out_chain2),
     .ihssi_rb_clkdiv({r_aib_csr_ctrl_22[3], r_aib_csr_ctrl_25[7:6]}),
     .iatpg_scan_in1(iatpg_scan_in1), .iatpg_scan_in0(iatpg_scan_in0),
     .iatpg_scan_clk_in1(iatpg_scan_clk_in1),
     .oatpg_scan_out0(oatpg_scan_out0),
     .oatpg_scan_out1(oatpg_scan_out1),
     .iatpg_scan_clk_in0(iatpg_scan_clk_in0),
     .jtag_tx_scanen_out(jtag_tx_scanen_out),
     .jtag_weakpdn_out(jtag_weakpdn_out),
     .jtag_weakpu_out(jtag_weakpu_out), .jtag_rstb_en(jtag_rstb_en),
     .jtag_intest_out(jtag_intest_out), .jtag_mode_out(jtag_mode_out),
     .jtag_rstb_en_out(jtag_rstb_en_out),
     .jtag_rstb_out(jtag_rstb_out), .jtag_clksel_out(jtag_clksel_out),
     .jtag_intest(jtag_intest), .jtag_clksel(jtag_clksel),
     .ihssi_rb_dcc_manual_dn(r_aib_csr_ctrl_33[4:0]),
     .ihssi_rb_dcc_manual_up(r_aib_csr_ctrl_32[4:0]),
     .ihssi_rb_dcc_test_clk_pll_en_n(r_aib_csr_ctrl_28[2]),
     .ihssi_rb_dll_test_clk_pll_en_n(r_aib_csr_ctrl_21[7]),
     .ihssi_rb_dcc_dll_dft_sel(r_aib_csr_ctrl_28[3]),
     .iatpg_scan_rst_n(iatpg_scan_rst_n),
     .ohssi_sr_clk_n_in(aib_fabric_tx_sr_clk_in),
     .aib_shared_direct_async({aib75, aib70, aib71, aib69, aib68,
     aib74, aib73, aib72}),
     .oshared_direct_async({aib_fabric_fpll_shared_direct_async_in[4:0],
     aib_fabric_fpll_shared_direct_async_out[2:0]}),
     .aib_hssi_adapter_rx_pld_rst_n(aib65),
     .aib_hssi_adapter_tx_pld_rst_n(aib61),
     .aib_hssi_avmm1_data_out({aib79, aib78}),
     .aib_hssi_avmm2_data_out({aib81, aib80}),
     .aib_hssi_fsr_data_out(aib89), .aib_hssi_fsr_load_out(aib88),
     .aib_hssi_pcs_rx_pld_rst_n(aib63),
     .aib_hssi_pcs_tx_pld_rst_n(aib64),
     .aib_hssi_pld_pma_coreclkin(aib57),
     .aib_hssi_pld_pma_coreclkin_n(aib59),
     .aib_hssi_pld_pma_rxpma_rstb(aib44),
     .aib_hssi_pld_pma_txdetectrx(aib67),
     .aib_hssi_pld_pma_txpma_rstb(aib45), .aib_hssi_pld_sclk(aib58),
     .aib_hssi_rx_transfer_clk(aib41),
     .aib_hssi_rx_transfer_clk_n(aib40), .aib_hssi_sr_clk_n_out(aib82),
     .aib_hssi_sr_clk_out(aib83), .aib_hssi_ssr_data_out(aib93),
     .aib_hssi_ssr_load_out(aib92), .aib_hssi_tx_data_in({aib39, aib38,
     aib37, aib36, aib35, aib34, aib33, aib32, aib31, aib30, aib29,
     aib28, aib27, aib26, aib25, aib24, aib23, aib22, aib21, aib20}),
     .aib_hssi_tx_transfer_clk(aib43),
     .aib_hssi_tx_transfer_clk_n(aib42),
     .ohssi_avmm1_data_in(aib_fabric_avmm1_data_in),
     .ohssi_avmm2_data_in(aib_fabric_avmm2_data_in),
     .ohssi_fsr_data_in(aib_fabric_fsr_data_in),
     .ohssi_fsr_load_in(aib_fabric_fsr_load_in),
     .ohssi_pld_8g_rxelecidle(aib_fabric_pld_8g_rxelecidle),
     .ohssi_pld_pcs_rx_clk_out(aib_fabric_pld_pcs_rx_clk_out),
     .ohssi_pld_pcs_tx_clk_out(aib_fabric_pld_pcs_tx_clk_out),
     .ohssi_pld_pma_clkdiv_rx_user(aib_fabric_pld_pma_clkdiv_rx_user),
     .ohssi_pld_pma_clkdiv_tx_user(aib_fabric_pld_pma_clkdiv_tx_user),
     .ohssi_pld_pma_hclk(aib_fabric_pld_pma_hclk),
     .ohssi_pld_pma_internal_clk1(aib_fabric_pld_pma_internal_clk1),
     .ohssi_pld_pma_internal_clk2(aib_fabric_pld_pma_internal_clk2),
     .ohssi_pld_pma_pfdmode_lock(aib_fabric_pld_pma_pfdmode_lock),
     .ohssi_pld_pma_rxpll_lock(aib_fabric_pld_pma_rxpll_lock),
     .ohssi_pld_rx_hssi_fifo_latency_pulse(aib_fabric_pld_rx_hssi_fifo_latency_pulse),
     .ohssi_pld_tx_hssi_fifo_latency_pulse(aib_fabric_pld_tx_hssi_fifo_latency_pulse),
     .ohssi_pma_aib_tx_clk(aib_fabric_pma_aib_tx_clk),
     .ohssi_rx_data_out(aib_fabric_rx_data_in[39:0]),
     .ohssi_rx_transfer_clk(aib_fabric_rx_transfer_clk),
     .ohssi_sr_clk_in(aib_fabric_rx_sr_clk_in),
     .ohssi_ssr_data_in(aib_fabric_ssr_data_in),
     .ohssi_ssr_load_in(aib_fabric_ssr_load_in),
     .ohssi_tx_dll_lock(aib_fabric_rx_dll_lock),
     .ohssitx_dcc_done(aib_fabric_tx_dcd_cal_done),
     .ohssitx_odcc_dll2core(oaibdftdll2core[12:0]),
     .ojtag_clkdr_out_chain(ojtag_clkdr_out_chain),
     .ojtag_last_bs_out_chain(ojtag_last_bs_out_chain),
     .ored_directin_data_out0_chain1(ored_directin_data_out0_chain1),
     .ored_directin_data_out0_chain2(ored_directin_data_out0_chain2),
     .ored_rxen_out_chain1(ored_rxen_out_chain1[2:0]),
     .ored_rxen_out_chain2(ored_rxen_out_chain2[2:0]),
     .aib_hssi_avmm1_data_in(aib76), .aib_hssi_avmm2_data_in(aib77),
     .aib_hssi_fsr_data_in(aib91), .aib_hssi_fsr_load_in(aib90),
     .aib_hssi_pld_8g_rxelecidle(aib66),
     .aib_hssi_pld_pcs_rx_clk_out(aib53),
     .aib_hssi_pld_pcs_rx_clk_out_n(aib54),
     .aib_hssi_pld_pcs_tx_clk_out(aib48),
     .aib_hssi_pld_pcs_tx_clk_out_n(aib55),
     .aib_hssi_pld_pma_clkdiv_rx_user(aib49),
     .aib_hssi_pld_pma_clkdiv_tx_user(aib56),
     .aib_hssi_pld_pma_hclk(aib50),
     .aib_hssi_pld_pma_internal_clk1(aib52),
     .aib_hssi_pld_pma_internal_clk2(aib51),
     .aib_hssi_pld_pma_pfdmode_lock(aib46),
     .aib_hssi_pld_pma_rxpll_lock(aib47),
     .aib_hssi_pld_rx_hssi_fifo_latency_pulse(aib60),
     .aib_hssi_pld_tx_hssi_fifo_latency_pulse(aib62),
     .aib_hssi_pma_aib_tx_clk(aib87),
     .aib_hssi_pma_aib_tx_clk_n(aib86), .aib_hssi_rx_data_out({aib19,
     aib18, aib17, aib16, aib15, aib14, aib13, aib12, aib11, aib10,
     aib9, aib8, aib7, aib6, aib5, aib4, aib3, aib2, aib1, aib0}),
     .aib_hssi_sr_clk_in(aib85), .aib_hssi_sr_clk_n_in(aib84),
     .aib_hssi_ssr_data_in(aib95), .aib_hssi_ssr_load_in(aib94),
     .iatpg_pipeline_global_en(iatpg_pipeline_global_en),
     .iatpg_scan_mode_n(iatpg_scan_mode_n),
     .iavm1_sr_clk_out(aib_fabric_tx_sr_clk_out),
     .iavm1in_en0(r_aib_csr_ctrl_34[2:0]),
     .iavm1in_en1(r_aib_csr_ctrl_34[5:3]),
     .iavm1in_en2({r_aib_csr_ctrl_34[7:6], r_aib_csr_ctrl_35[0]}),
     .iavm1out_dataselb(r_aib_csr_ctrl_35[6:4]),
     .iavm1out_en(r_aib_csr_ctrl_35[3:1]),
     .iavm2in_en0(r_aib_csr_ctrl_37[2:0]),
     .iavm2out_dataselb(r_aib_csr_ctrl_37[4]),
     .iavm2out_en(r_aib_csr_ctrl_37[3]),
     .ihssi_adapter_rx_pld_rst_n(aib_fabric_adapter_rx_pld_rst_n),
     .ihssi_adapter_tx_pld_rst_n(aib_fabric_adapter_tx_pld_rst_n),
     .ihssi_avmm1_data_out(aib_fabric_avmm1_data_out[1:0]),
     .ihssi_avmm2_data_out(aib_fabric_avmm2_data_out[1:0]),
     .ihssi_dcc_dft_nrst(vssl_aibnd),
     .ihssi_dcc_dft_nrst_coding(vssl_aibnd),
     .ihssi_dcc_dft_up(vssl_aibnd),
     .ihssi_dcc_dll_core2dll_str(iaibdftcore2dll[2:0]),
     .ihssi_dcc_dll_csr_reg({r_aib_csr_ctrl_31[3:0],
     r_aib_csr_ctrl_30[7:0], r_aib_csr_ctrl_29[7:0],
     r_aib_csr_ctrl_28[7:4], r_aib_dprio_ctrl_3[2:0],
     r_aib_dprio_ctrl_2[7:0], r_aib_csr_ctrl_28[0],
     r_aib_csr_ctrl_27[7:0], r_aib_csr_ctrl_26[7:0]}),
     .ihssi_dcc_dll_entest(r_aib_csr_ctrl_31[4]),
     .ihssi_dcc_req(aib_fabric_tx_dcd_cal_req),
     .ihssi_fsr_data_out(aib_fabric_fsr_data_out),
     .ihssi_fsr_load_out(aib_fabric_fsr_load_out),
     .ihssi_pcs_rx_pld_rst_n(aib_fabric_pcs_rx_pld_rst_n),
     .ihssi_pcs_tx_pld_rst_n(aib_fabric_pcs_tx_pld_rst_n),
     .ihssi_pld_pma_coreclkin(aib_fabric_pld_pma_coreclkin),
     .ihssi_pld_pma_rxpma_rstb(aib_fabric_pld_pma_rxpma_rstb),
     .ihssi_pld_pma_txdetectrx(aib_fabric_pld_pma_txdetectrx),
     .ihssi_pld_pma_txpma_rstb(aib_fabric_pld_pma_txpma_rstb),
     .ihssi_pld_sclk(aib_fabric_pld_sclk),
     .ihssi_rb_dcc_byp(r_aib_csr_ctrl_25[5]),
     .ihssi_rb_dcc_byp_dprio(r_aib_dprio_ctrl_3[3]),
     .ihssi_rb_dcc_dft(r_aib_csr_ctrl_25[4]),
     .ihssi_rb_dcc_dft_sel(r_aib_csr_ctrl_25[3]),
     .ihssi_rb_dcc_en(r_aib_csr_ctrl_25[2]),
     .ihssi_rb_dcc_en_dprio(r_aib_dprio_ctrl_3[4]),
     .ihssi_rb_dcc_manual_mode(r_aib_csr_ctrl_25[1]),
     .ihssi_rb_dcc_manual_mode_dprio(r_aib_dprio_ctrl_3[5]),
     .ihssi_rb_half_code(r_aib_csr_ctrl_25[0]),
     .ihssi_rb_selflock(r_aib_csr_ctrl_24[7]),
     .ihssi_ssr_data_out(aib_fabric_ssr_data_out),
     .ihssi_ssr_load_out(aib_fabric_ssr_load_out),
     .ihssi_tx_data_in(aib_fabric_tx_data_out[39:0]),
     .ihssi_tx_dll_lock_req(aib_fabric_rx_dll_lock_req),
     .ihssi_tx_transfer_clk(aib_fabric_tx_transfer_clk),
     .ihssirx_async_en(r_aib_csr_ctrl_24[5:3]),
     .ihssirx_clk_en(r_aib_csr_ctrl_24[2:0]),
     .ihssirx_out_dataselb(r_aib_csr_ctrl_23[7:4]),
     .ihssirx_out_en(r_aib_csr_ctrl_23[3:0]),
     .ihssitx_in_en0(r_aib_csr_ctrl_12[2:0]),
     .ihssitx_in_en1(r_aib_csr_ctrl_12[5:3]),
     .ihssitx_in_en2({r_aib_csr_ctrl_12[7:6], r_aib_csr_ctrl_13[0]}),
     .ihssitx_in_en3(r_aib_csr_ctrl_13[3:1]),
     .ihssitx_out_dataselb(r_aib_csr_ctrl_13[7:5]),
     .ihssitx_out_en(r_aib_csr_ctrl_22[2:0]),
     .ihssitxdll_rb_half_code_str(r_aib_csr_ctrl_21[5]),
     .ihssitxdll_rb_selflock_str(r_aib_csr_ctrl_21[4]),
     .ihssitxdll_str_align_dly_pst({r_aib_csr_ctrl_18[1:0],
     r_aib_csr_ctrl_17[7:0]}),
     .ihssitxdll_str_align_dyconfig_ctl_static({r_aib_dprio_ctrl_1[1:0],
     r_aib_dprio_ctrl_0[7:0]}),
     .ihssitxdll_str_align_dyconfig_ctlsel(r_aib_dprio_ctrl_1[2]),
     .ihssitxdll_str_align_entest(r_aib_csr_ctrl_21[6]),
     .ihssitxdll_str_align_stconfig_core_dn_prgmnvrt(r_aib_csr_ctrl_16[4]),
     .ihssitxdll_str_align_stconfig_core_up_prgmnvrt(r_aib_csr_ctrl_16[3]),
     .ihssitxdll_str_align_stconfig_core_updnen(r_aib_csr_ctrl_16[5]),
     .ihssitxdll_str_align_stconfig_dftmuxsel({r_aib_csr_ctrl_21[3:0],
     r_aib_csr_ctrl_20[7:0], r_aib_csr_ctrl_19[7:0]}),
     .ihssitxdll_str_align_stconfig_dll_en(r_aib_csr_ctrl_16[1]),
     .ihssitxdll_str_align_stconfig_dll_rst_en(r_aib_csr_ctrl_16[0]),
     .ihssitxdll_str_align_stconfig_hps_ctrl_en(r_aib_csr_ctrl_16[6]),
     .ihssitxdll_str_align_stconfig_ndllrst_prgmnvrt(r_aib_csr_ctrl_16[2]),
     .ihssitxdll_str_align_stconfig_new_dll(r_aib_csr_ctrl_18[5:3]),
     .ihssitxdll_str_align_stconfig_spare(r_aib_csr_ctrl_18[2]),
     .ijtag_clkdr_in_chain(ijtag_clkdr_in_chain),
     .ijtag_last_bs_in_chain(ijtag_last_bs_in_chain),
     .indrv_r12(r_aib_csr_ctrl_14[1:0]),
     .indrv_r34(r_aib_csr_ctrl_14[3:2]),
     .indrv_r56(r_aib_csr_ctrl_14[5:4]),
     .indrv_r78(r_aib_csr_ctrl_14[7:6]),
     .ipdrv_r12(r_aib_csr_ctrl_15[1:0]),
     .ipdrv_r34(r_aib_csr_ctrl_15[3:2]),
     .ipdrv_r56(r_aib_csr_ctrl_15[5:4]),
     .ipdrv_r78(r_aib_csr_ctrl_15[7:6]),
     .ired_avm1_shift_en({r_aib_csr_ctrl_5[1], r_aib_csr_ctrl_4[7],
     r_aib_csr_ctrl_4[5], r_aib_csr_ctrl_4[1], r_aib_csr_ctrl_4[0],
     r_aib_csr_ctrl_4[4], r_aib_csr_ctrl_4[6], r_aib_csr_ctrl_5[0],
     r_aib_csr_ctrl_0[7], r_aib_csr_ctrl_1[1], r_aib_csr_ctrl_1[3],
     r_aib_csr_ctrl_1[4], r_aib_csr_ctrl_1[2], r_aib_csr_ctrl_1[0],
     r_aib_csr_ctrl_0[6]}),
     .ired_directin_data_in_chain1(ired_directin_data_in_chain1),
     .ired_directin_data_in_chain2(ired_directin_data_in_chain2),
     .ired_irxen_in_chain1(ired_irxen_in_chain1[2:0]),
     .ired_irxen_in_chain2(ired_irxen_in_chain2[2:0]),
     .ired_rshift_en_dirclkn({r_aib_csr_ctrl_2[1],
     r_aib_csr_ctrl_4[3]}),
     .ired_rshift_en_dirclkp({r_aib_csr_ctrl_2[0],
     r_aib_csr_ctrl_4[2]}), .ired_rshift_en_drx({r_aib_csr_ctrl_2[7],
     r_aib_csr_ctrl_11[6], r_aib_csr_ctrl_2[2]}),
     .ired_rshift_en_dtx({r_aib_csr_ctrl_3[4], r_aib_csr_ctrl_0[0],
     r_aib_csr_ctrl_5[7], r_aib_csr_ctrl_8[7]}),
     .ired_rshift_en_poutp({r_aib_csr_ctrl_8[5:0],
     r_aib_csr_ctrl_7[7:4], r_aib_csr_ctrl_7[1:0],
     r_aib_csr_ctrl_6[7:0]}),
     .ired_rshift_en_rx(r_aib_csr_ctrl_0[5:2]),
     .ired_rshift_en_rx_avmm2(r_aib_csr_ctrl_1[5]),
     .ired_rshift_en_tx({r_aib_csr_ctrl_5[3], r_aib_csr_ctrl_5[2],
     r_aib_csr_ctrl_5[5], r_aib_csr_ctrl_5[4]}),
     .ired_rshift_en_tx_avmm2(r_aib_csr_ctrl_3[7:6]),
     .ired_rshift_en_txferclkout(r_aib_csr_ctrl_7[2]),
     .ired_rshift_en_txferclkoutn(r_aib_csr_ctrl_7[3]),
     .ired_rx_shift_en({r_aib_csr_ctrl_11[7], r_aib_csr_ctrl_2[3],
     r_aib_csr_ctrl_11[5:0], r_aib_csr_ctrl_10[7:0],
     r_aib_csr_ctrl_9[7:0], r_aib_csr_ctrl_8[6], r_aib_csr_ctrl_1[7:6],
     r_aib_csr_ctrl_3[5], r_aib_csr_ctrl_2[5:4], r_aib_csr_ctrl_3[1],
     r_aib_csr_ctrl_3[3:2], r_aib_csr_ctrl_0[1], r_aib_csr_ctrl_3[0],
     r_aib_csr_ctrl_2[6], r_aib_csr_ctrl_5[6]}),
     .irstb(aib_fabric_csr_rdy_dly_in), .jtag_mode_in(jtag_mode_in),
     .jtag_rstb(jtag_rstb), .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .jtag_weakpdn(jtag_weakpdn), .jtag_weakpu(jtag_weakpu),
     .vccl_aibnd(vccl_aibnd), .vssl_aibnd(vssl_aibnd));

endmodule

