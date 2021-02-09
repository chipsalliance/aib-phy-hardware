// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3_lib, Cell - aibcr3_top_wrp, View - schematic
// LAST TIME SAVED: Sep  8 01:32:53 2016
// NETLIST TIME: Sep 13 21:47:08 2016
`timescale 1ns / 1ns 

module aibcr3_top_wrp ( jtag_clksel_out, jtag_intest_out,
     jtag_mode_out, jtag_rstb_en_out, jtag_rstb_out,
     jtag_tx_scanen_out, jtag_weakpdn_out, jtag_weakpu_out,
     oaibdftdll2adjch, oaibdftdll2core, oatpg_bsr0_scan_out,
     oatpg_bsr1_scan_out, oatpg_bsr2_scan_out, oatpg_bsr3_scan_out,
     oatpg_scan_out0, oatpg_scan_out1, odirectout_data_out_chain1,
     odirectout_data_out_chain2, ohssi_adapter_rx_pld_rst_n,
     ohssi_adapter_tx_pld_rst_n, ohssi_avmm1_data_in,
     ohssi_avmm2_data_in, ohssi_fsr_data_in, ohssi_fsr_load_in,
     ohssi_pcs_rx_pld_rst_n, ohssi_pcs_tx_pld_rst_n,
     ohssi_pld_pma_coreclkin, ohssi_pld_pma_coreclkin_n,
     ohssi_pld_pma_rxpma_rstb, ohssi_pld_pma_txdetectrx,
     ohssi_pld_pma_txpma_rstb, ohssi_pld_sclk, ohssi_sr_clk_in,
     ohssi_ssr_data_in, ohssi_ssr_load_in, ohssi_tx_data_in,
     ohssi_tx_dcd_cal_done, ohssi_tx_dll_lock, ohssi_tx_sr_clk_in,
     ohssi_tx_transfer_clk, ohssirx_dcc_done, ojtag_clkdr_out_chain,
     ojtag_last_bs_out_chain, ojtag_rx_scan_out_chain,
     ored_idataselb_out_chain1, ored_idataselb_out_chain2,
     ored_shift_en_out_chain1, ored_shift_en_out_chain2, osc_clkout,
     oshared_direct_async_out, otxen_out_chain1, otxen_out_chain2,
     por_aib_vcchssi_out, por_aib_vccl_out, aib0, aib1, aib2, aib3,
     aib4, aib5, aib6, aib7, aib8, aib9, aib10, aib11, aib12, aib13,
     aib14, aib15, aib16, aib17, aib18, aib19, aib20, aib21, aib22,
     aib23, aib24, aib25, aib26, aib27, aib28, aib29, aib30, aib31,
     aib32, aib33, aib34, aib35, aib36, aib37, aib38, aib39, aib40,
     aib41, aib42, aib43, aib44, aib45, aib46, aib47, aib48, aib49,
     aib50, aib51, aib52, aib53, aib54, aib55, aib56, aib57, aib58,
     aib59, aib60, aib61, aib62, aib63, aib64, aib65, aib66, aib67,
     aib68, aib69, aib70, aib71, aib72, aib73, aib74, aib75, aib76,
     aib77, aib78, aib79, aib80, aib81, aib82, aib83, aib84, aib85,
     aib86, aib87, aib88, aib89, aib90, aib91, aib92, aib93, aib94,
     aib95, iaibdftcore2dll, iaibdftdll2adjch, iatpg_bsr0_scan_in,
     iatpg_bsr0_scan_shift_clk, iatpg_bsr1_scan_in,
     iatpg_bsr1_scan_shift_clk, iatpg_bsr2_scan_in,
     iatpg_bsr2_scan_shift_clk, iatpg_bsr3_scan_in,
     iatpg_bsr3_scan_shift_clk, iatpg_bsr_scan_shift_n,
     iatpg_pipeline_global_en, iatpg_scan_clk_in0, iatpg_scan_clk_in1,
     iatpg_scan_in0, iatpg_scan_in1, iatpg_scan_mode_n,
     iatpg_scan_rst_n, iatpg_scan_shift_n, idirectout_data_in_chain1,
     idirectout_data_in_chain2, ihssi_avmm1_data_out,
     ihssi_avmm2_data_out, ihssi_dcc_req, ihssi_fsr_data_out,
     ihssi_fsr_load_out, ihssi_pld_8g_rxelecidle,
     ihssi_pld_pcs_rx_clk_out, ihssi_pld_pcs_tx_clk_out,
     ihssi_pld_pma_clkdiv_rx_user, ihssi_pld_pma_clkdiv_tx_user,
     ihssi_pld_pma_hclk, ihssi_pld_pma_internal_clk1,
     ihssi_pld_pma_internal_clk2, ihssi_pld_pma_pfdmode_lock,
     ihssi_pld_pma_rxpll_lock, ihssi_pld_rx_hssi_fifo_latency_pulse,
     ihssi_pld_tx_hssi_fifo_latency_pulse, ihssi_pma_aib_tx_clk,
     ihssi_rx_data_out, ihssi_rx_transfer_clk, ihssi_sr_clk_out,
     ihssi_ssr_data_out, ihssi_ssr_load_out, ihssi_tx_dcd_cal_req,
     ihssi_tx_dll_lock_req, ijtag_clkdr_in_chain,
     ijtag_last_bs_in_chain, ijtag_tx_scan_in_chain,
     ired_idataselb_in_chain1, ired_idataselb_in_chain2,
     ired_shift_en_in_chain1, ired_shift_en_in_chain2, irstb,
     ishared_direct_async_in, itxen_in_chain1, itxen_in_chain2,
     jtag_clksel, jtag_intest, jtag_mode_in, jtag_rstb, jtag_rstb_en,
     jtag_tx_scanen_in, jtag_weakpdn, jtag_weakpu, osc_clkin,
     por_aib_vcchssi, por_aib_vccl, r_aib_csr_ctrl_0, r_aib_csr_ctrl_1,
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
     r_aib_csr_ctrl_53, r_aib_dprio_ctrl_0, r_aib_dprio_ctrl_1,
     r_aib_dprio_ctrl_2, r_aib_dprio_ctrl_3, r_aib_dprio_ctrl_4 
     );

output  jtag_clksel_out, jtag_intest_out, jtag_mode_out,
     jtag_rstb_en_out, jtag_rstb_out, jtag_tx_scanen_out,
     jtag_weakpdn_out, jtag_weakpu_out, oatpg_bsr0_scan_out,
     oatpg_bsr1_scan_out, oatpg_bsr2_scan_out, oatpg_bsr3_scan_out,
     oatpg_scan_out0, oatpg_scan_out1, odirectout_data_out_chain1,
     odirectout_data_out_chain2, ohssi_adapter_rx_pld_rst_n,
     ohssi_adapter_tx_pld_rst_n, ohssi_fsr_data_in, ohssi_fsr_load_in,
     ohssi_pcs_rx_pld_rst_n, ohssi_pcs_tx_pld_rst_n,
     ohssi_pld_pma_coreclkin, ohssi_pld_pma_coreclkin_n,
     ohssi_pld_pma_rxpma_rstb, ohssi_pld_pma_txdetectrx,
     ohssi_pld_pma_txpma_rstb, ohssi_pld_sclk, ohssi_sr_clk_in,
     ohssi_ssr_data_in, ohssi_ssr_load_in, ohssi_tx_dcd_cal_done,
     ohssi_tx_dll_lock, ohssi_tx_sr_clk_in, ohssi_tx_transfer_clk,
     ohssirx_dcc_done, ojtag_clkdr_out_chain, ojtag_last_bs_out_chain,
     ojtag_rx_scan_out_chain, ored_idataselb_out_chain1,
     ored_idataselb_out_chain2, ored_shift_en_out_chain1,
     ored_shift_en_out_chain2, osc_clkout, otxen_out_chain1,
     otxen_out_chain2, por_aib_vcchssi_out, por_aib_vccl_out;

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

input  iatpg_bsr0_scan_in, iatpg_bsr0_scan_shift_clk,
     iatpg_bsr1_scan_in, iatpg_bsr1_scan_shift_clk, iatpg_bsr2_scan_in,
     iatpg_bsr2_scan_shift_clk, iatpg_bsr3_scan_in,
     iatpg_bsr3_scan_shift_clk, iatpg_bsr_scan_shift_n,
     iatpg_pipeline_global_en, iatpg_scan_clk_in0, iatpg_scan_clk_in1,
     iatpg_scan_in0, iatpg_scan_in1, iatpg_scan_mode_n,
     iatpg_scan_rst_n, iatpg_scan_shift_n, idirectout_data_in_chain1,
     idirectout_data_in_chain2, ihssi_avmm1_data_out,
     ihssi_avmm2_data_out, ihssi_dcc_req, ihssi_fsr_data_out,
     ihssi_fsr_load_out, ihssi_pld_8g_rxelecidle,
     ihssi_pld_pcs_rx_clk_out, ihssi_pld_pcs_tx_clk_out,
     ihssi_pld_pma_clkdiv_rx_user, ihssi_pld_pma_clkdiv_tx_user,
     ihssi_pld_pma_hclk, ihssi_pld_pma_internal_clk1,
     ihssi_pld_pma_internal_clk2, ihssi_pld_pma_pfdmode_lock,
     ihssi_pld_pma_rxpll_lock, ihssi_pld_rx_hssi_fifo_latency_pulse,
     ihssi_pld_tx_hssi_fifo_latency_pulse, ihssi_pma_aib_tx_clk,
     ihssi_rx_transfer_clk, ihssi_sr_clk_out, ihssi_ssr_data_out,
     ihssi_ssr_load_out, ihssi_tx_dcd_cal_req, ihssi_tx_dll_lock_req,
     ijtag_clkdr_in_chain, ijtag_last_bs_in_chain,
     ijtag_tx_scan_in_chain, ired_idataselb_in_chain1,
     ired_idataselb_in_chain2, ired_shift_en_in_chain1,
     ired_shift_en_in_chain2, irstb, itxen_in_chain1, itxen_in_chain2,
     jtag_clksel, jtag_intest, jtag_mode_in, jtag_rstb, jtag_rstb_en,
     jtag_tx_scanen_in, jtag_weakpdn, jtag_weakpu, osc_clkin,
     por_aib_vcchssi, por_aib_vccl;

output [12:0]  oaibdftdll2adjch;
output [12:0]  oaibdftdll2core;
output [2:0]  oshared_direct_async_out;
output [1:0]  ohssi_avmm1_data_in;
output [1:0]  ohssi_avmm2_data_in;
output [39:0]  ohssi_tx_data_in;

input [7:0]  r_aib_csr_ctrl_42;
input [12:0]  iaibdftdll2adjch;
input [7:0]  r_aib_csr_ctrl_40;
input [7:0]  r_aib_csr_ctrl_36;
input [7:0]  r_aib_csr_ctrl_43;
input [7:0]  r_aib_csr_ctrl_52;
input [7:0]  r_aib_csr_ctrl_49;
input [7:0]  r_aib_csr_ctrl_45;
input [7:0]  r_aib_csr_ctrl_48;
input [7:0]  r_aib_csr_ctrl_44;
input [7:0]  r_aib_csr_ctrl_47;
input [39:0]  ihssi_rx_data_out;
input [7:0]  r_aib_csr_ctrl_34;
input [7:0]  r_aib_csr_ctrl_35;
input [7:0]  r_aib_dprio_ctrl_4;
input [2:1]  iaibdftcore2dll;
input [7:0]  r_aib_dprio_ctrl_1;
input [7:0]  r_aib_dprio_ctrl_0;
input [7:0]  r_aib_csr_ctrl_20;
input [7:0]  r_aib_csr_ctrl_19;
input [7:0]  r_aib_csr_ctrl_50;
input [7:0]  r_aib_csr_ctrl_53;
input [7:0]  r_aib_csr_ctrl_13;
input [7:0]  r_aib_csr_ctrl_17;
input [7:0]  r_aib_csr_ctrl_23;
input [7:0]  r_aib_csr_ctrl_12;
input [7:0]  r_aib_csr_ctrl_26;
input [7:0]  r_aib_dprio_ctrl_2;
input [7:0]  r_aib_csr_ctrl_29;
input [7:0]  r_aib_csr_ctrl_30;
input [7:0]  r_aib_csr_ctrl_24;
input [7:0]  r_aib_csr_ctrl_46;
input [7:0]  r_aib_csr_ctrl_39;
input [7:0]  r_aib_csr_ctrl_37;
input [7:0]  r_aib_csr_ctrl_38;
input [4:0]  ishared_direct_async_in;
input [7:0]  r_aib_csr_ctrl_31;
input [7:0]  r_aib_csr_ctrl_18;
input [7:0]  r_aib_dprio_ctrl_3;
input [7:0]  r_aib_csr_ctrl_27;
input [7:0]  r_aib_csr_ctrl_41;
input [7:0]  r_aib_csr_ctrl_22;
input [7:0]  r_aib_csr_ctrl_51;
input [7:0]  r_aib_csr_ctrl_33;
input [7:0]  r_aib_csr_ctrl_32;
input [7:0]  r_aib_csr_ctrl_28;
input [7:0]  r_aib_csr_ctrl_21;
input [7:0]  r_aib_csr_ctrl_16;
input [7:0]  r_aib_csr_ctrl_15;
input [7:0]  r_aib_csr_ctrl_14;
input [7:0]  r_aib_csr_ctrl_11;
input [7:0]  r_aib_csr_ctrl_10;
input [7:0]  r_aib_csr_ctrl_9;
input [7:0]  r_aib_csr_ctrl_8;
input [7:0]  r_aib_csr_ctrl_7;
input [7:0]  r_aib_csr_ctrl_6;
input [7:0]  r_aib_csr_ctrl_5;
input [7:0]  r_aib_csr_ctrl_4;
input [7:0]  r_aib_csr_ctrl_3;
input [7:0]  r_aib_csr_ctrl_2;
input [7:0]  r_aib_csr_ctrl_1;
input [7:0]  r_aib_csr_ctrl_0;
input [7:0]  r_aib_csr_ctrl_25;

assign vcc = 1'b1;
assign vccl = 1'b1;
assign vssl = 1'b0;


aibcr3_top xaibcr3_top ( jtag_clksel_out, jtag_intest_out, jtag_mode_out,
     jtag_rstb_en_out, jtag_rstb_out, jtag_tx_scanen_out,
     jtag_weakpdn_out, jtag_weakpu_out, oaibdftdll2adjch[12:0],
     oaibdftdll2core[12:0], oatpg_bsr0_scan_out, oatpg_bsr1_scan_out,
     oatpg_bsr2_scan_out, oatpg_bsr3_scan_out, oatpg_scan_out0,
     oatpg_scan_out1, odirectout_data_out_chain1,
     odirectout_data_out_chain2, ohssi_adapter_rx_pld_rst_n,
     ohssi_adapter_tx_pld_rst_n, ohssi_avmm1_data_in[1:0],
     ohssi_avmm2_data_in[1:0], ohssi_fsr_data_in, ohssi_fsr_load_in,
     ohssi_pcs_rx_pld_rst_n, ohssi_pcs_tx_pld_rst_n,
     ohssi_pld_pma_coreclkin, ohssi_pld_pma_coreclkin_n,
     ohssi_pld_pma_rxpma_rstb, ohssi_pld_pma_txdetectrx,
     ohssi_pld_pma_txpma_rstb, ohssi_pld_sclk, ohssi_sr_clk_in,
     ohssi_ssr_data_in, ohssi_ssr_load_in, ohssi_tx_data_in[39:0],
     ohssi_tx_dcd_cal_done, ohssi_tx_dll_lock, ohssi_tx_sr_clk_in,
     ohssi_tx_transfer_clk, ohssirx_dcc_done, ojtag_clkdr_out_chain,
     ojtag_last_bs_out_chain, ojtag_rx_scan_out_chain,
     ored_idataselb_out_chain1, ored_idataselb_out_chain2,
     ored_shift_en_out_chain1, ored_shift_en_out_chain2, osc_clkout,
     oshared_direct_async_out[2:0], otxen_out_chain1, otxen_out_chain2,
     por_aib_vcchssi_out, por_aib_vccl_out, aib65, aib61, {aib79,
     aib78}, aib76, {aib81, aib80}, aib77, {aib74, aib73, aib72},
     {aib75, aib70, aib71, aib69, aib68}, aib89, aib91, aib88, aib90,
     aib63, aib64, aib66, aib53, aib54, aib48, aib55, aib49, aib56,
     aib57, aib59, aib50, aib52, aib51, aib46, aib47, aib44, aib67,
     aib45, aib60, aib58, aib62, aib87, aib86, {aib19, aib18, aib17,
     aib16, aib15, aib14, aib13, aib12, aib11, aib10, aib9, aib8, aib7,
     aib6, aib5, aib4, aib3, aib2, aib1, aib0}, aib41, aib40, aib83,
     aib82, aib84, aib85, aib93, aib95, aib92, aib94, {aib39, aib38,
     aib37, aib36, aib35, aib34, aib33, aib32, aib31, aib30, aib29,
     aib28, aib27, aib26, aib25, aib24, aib23, aib22, aib21, aib20},
     aib43, aib42, vcc, vccl, vssl, {iaibdftcore2dll[2:1], vssl},
     iaibdftdll2adjch[12:0], iatpg_bsr0_scan_in,
     iatpg_bsr0_scan_shift_clk, iatpg_bsr1_scan_in,
     iatpg_bsr1_scan_shift_clk, iatpg_bsr2_scan_in,
     iatpg_bsr2_scan_shift_clk, iatpg_bsr3_scan_in,
     iatpg_bsr3_scan_shift_clk, iatpg_bsr_scan_shift_n,
     iatpg_pipeline_global_en, iatpg_scan_clk_in0, iatpg_scan_clk_in1,
     iatpg_scan_in0, iatpg_scan_in1, iatpg_scan_mode_n,
     iatpg_scan_rst_n, iatpg_scan_shift_n, r_aib_csr_ctrl_34[2:0],
     r_aib_csr_ctrl_34[5:3], {r_aib_csr_ctrl_35[0],
     r_aib_csr_ctrl_34[7:6]}, r_aib_csr_ctrl_35[6:4],
     r_aib_csr_ctrl_35[3:1], r_aib_csr_ctrl_37[2:0],
     r_aib_csr_ctrl_37[4], r_aib_csr_ctrl_37[3], r_aib_csr_ctrl_21[7],
     idirectout_data_in_chain1, idirectout_data_in_chain2,
     ihssi_avmm1_data_out, ihssi_avmm2_data_out, vssl, vssl, vssl,
     {r_aib_csr_ctrl_31[3:0], r_aib_csr_ctrl_30[7:0],
     r_aib_csr_ctrl_29[7:0], r_aib_csr_ctrl_28[7:4],
     r_aib_dprio_ctrl_3[2:0], r_aib_dprio_ctrl_2[7:0],
     r_aib_csr_ctrl_28[0], r_aib_csr_ctrl_27[7:0],
     r_aib_csr_ctrl_26[7:0]}, r_aib_csr_ctrl_31[4], ihssi_dcc_req,
     ihssi_fsr_data_out, ihssi_fsr_load_out, ihssi_pld_8g_rxelecidle,
     ihssi_pld_pcs_rx_clk_out, vssl, ihssi_pld_pcs_tx_clk_out,
     ihssi_pld_pma_clkdiv_rx_user, ihssi_pld_pma_clkdiv_tx_user,
     ihssi_pld_pma_hclk, ihssi_pld_pma_internal_clk1,
     ihssi_pld_pma_internal_clk2, ihssi_pld_pma_pfdmode_lock,
     ihssi_pld_pma_rxpll_lock, ihssi_pld_rx_hssi_fifo_latency_pulse,
     ihssi_pld_tx_hssi_fifo_latency_pulse, ihssi_pma_aib_tx_clk,
     {r_aib_csr_ctrl_22[4], r_aib_csr_ctrl_25[6],
     r_aib_csr_ctrl_25[5]}, r_aib_csr_ctrl_25[7],
     r_aib_dprio_ctrl_3[3], r_aib_csr_ctrl_25[4], r_aib_csr_ctrl_25[3],
     r_aib_csr_ctrl_25[2], r_aib_dprio_ctrl_3[4],
     r_aib_csr_ctrl_33[4:0], r_aib_csr_ctrl_25[1],
     r_aib_dprio_ctrl_3[5], r_aib_csr_ctrl_32[4:0],
     r_aib_csr_ctrl_25[0], r_aib_csr_ctrl_24[7],
     ihssi_rx_data_out[39:0], ihssi_rx_transfer_clk, ihssi_sr_clk_out,
     ihssi_ssr_data_out, ihssi_ssr_load_out, ihssi_tx_dcd_cal_req,
     ihssi_tx_dll_lock_req, r_aib_csr_ctrl_24[4:2],
     {r_aib_csr_ctrl_24[1:0], r_aib_csr_ctrl_23[7]},
     r_aib_csr_ctrl_23[6:4], r_aib_csr_ctrl_24[6:5],
     r_aib_csr_ctrl_23[3:0], r_aib_csr_ctrl_12[2:0],
     r_aib_csr_ctrl_12[5:3], {r_aib_csr_ctrl_13[0],
     r_aib_csr_ctrl_12[7:6]}, r_aib_csr_ctrl_13[3:1],
     r_aib_csr_ctrl_13[7:5], r_aib_csr_ctrl_22[2:0],
     {r_aib_csr_ctrl_22[5], r_aib_csr_ctrl_18[7:6]},
     r_aib_csr_ctrl_21[5], r_aib_csr_ctrl_21[4],
     {r_aib_csr_ctrl_18[1:0], r_aib_csr_ctrl_17[7:0]},
     {r_aib_dprio_ctrl_1[1:0], r_aib_dprio_ctrl_0[7:0]},
     r_aib_dprio_ctrl_1[2], r_aib_csr_ctrl_21[6], r_aib_csr_ctrl_16[4],
     r_aib_csr_ctrl_16[3], r_aib_csr_ctrl_16[5],
     {r_aib_csr_ctrl_21[3:0], r_aib_csr_ctrl_20[7:0],
     r_aib_csr_ctrl_19[7:0]}, r_aib_csr_ctrl_16[1],
     r_aib_csr_ctrl_16[0], r_aib_csr_ctrl_16[6], r_aib_csr_ctrl_16[2],
     r_aib_csr_ctrl_18[5:3], r_aib_csr_ctrl_18[2],
     ijtag_clkdr_in_chain, ijtag_last_bs_in_chain,
     ijtag_tx_scan_in_chain, r_aib_csr_ctrl_14[1:0],
     r_aib_csr_ctrl_14[3:2], r_aib_csr_ctrl_14[5:4],
     r_aib_csr_ctrl_14[7:6], r_aib_csr_ctrl_15[1:0],
     r_aib_csr_ctrl_15[3:2], r_aib_csr_ctrl_15[5:4],
     r_aib_csr_ctrl_15[7:6], {r_aib_csr_ctrl_5[1], r_aib_csr_ctrl_4[7],
     r_aib_csr_ctrl_4[5], r_aib_csr_ctrl_4[1], r_aib_csr_ctrl_4[0],
     r_aib_csr_ctrl_4[4], r_aib_csr_ctrl_4[6], r_aib_csr_ctrl_5[0],
     r_aib_csr_ctrl_0[7], r_aib_csr_ctrl_1[1], r_aib_csr_ctrl_1[3],
     r_aib_csr_ctrl_1[4], r_aib_csr_ctrl_1[2], r_aib_csr_ctrl_1[0],
     r_aib_csr_ctrl_0[6]}, ired_idataselb_in_chain1,
     ired_idataselb_in_chain2, {r_aib_csr_ctrl_2[1],
     r_aib_csr_ctrl_4[3]}, {r_aib_csr_ctrl_2[0], r_aib_csr_ctrl_4[2]},
     {r_aib_csr_ctrl_3[4], r_aib_csr_ctrl_0[0], r_aib_csr_ctrl_5[7],
     r_aib_csr_ctrl_8[7]}, {r_aib_csr_ctrl_2[7], r_aib_csr_ctrl_11[6],
     r_aib_csr_ctrl_2[2]}, {r_aib_csr_ctrl_8[5:0],
     r_aib_csr_ctrl_7[7:4], r_aib_csr_ctrl_7[1:0],
     r_aib_csr_ctrl_6[7:0]}, {r_aib_csr_ctrl_5[3:2],
     r_aib_csr_ctrl_5[5:4]}, r_aib_csr_ctrl_3[7:6],
     r_aib_csr_ctrl_0[5:2], r_aib_csr_ctrl_1[5], r_aib_csr_ctrl_7[2],
     r_aib_csr_ctrl_7[3], {r_aib_csr_ctrl_2[6], r_aib_csr_ctrl_5[6],
     r_aib_csr_ctrl_0[1], r_aib_csr_ctrl_3[0], r_aib_csr_ctrl_2[5],
     r_aib_csr_ctrl_2[4], r_aib_csr_ctrl_3[1], r_aib_csr_ctrl_3[3],
     r_aib_csr_ctrl_3[2], r_aib_csr_ctrl_3[5], r_aib_csr_ctrl_1[6],
     r_aib_csr_ctrl_1[7], r_aib_csr_ctrl_8[6], r_aib_csr_ctrl_9[1],
     r_aib_csr_ctrl_9[0], r_aib_csr_ctrl_9[3], r_aib_csr_ctrl_9[2],
     r_aib_csr_ctrl_9[5], r_aib_csr_ctrl_9[4], r_aib_csr_ctrl_9[7],
     r_aib_csr_ctrl_9[6], r_aib_csr_ctrl_10[1], r_aib_csr_ctrl_10[0],
     r_aib_csr_ctrl_10[3], r_aib_csr_ctrl_10[2], r_aib_csr_ctrl_10[5],
     r_aib_csr_ctrl_10[4], r_aib_csr_ctrl_10[7], r_aib_csr_ctrl_10[6],
     r_aib_csr_ctrl_11[1], r_aib_csr_ctrl_11[0], r_aib_csr_ctrl_11[3],
     r_aib_csr_ctrl_11[2], r_aib_csr_ctrl_11[5], r_aib_csr_ctrl_11[4],
     r_aib_csr_ctrl_11[7], r_aib_csr_ctrl_2[3]},
     ired_shift_en_in_chain1, ired_shift_en_in_chain2, irstb,
     ishared_direct_async_in[4:0], itxen_in_chain1, itxen_in_chain2,
     jtag_clksel, jtag_intest, jtag_mode_in, jtag_rstb, jtag_rstb_en,
     jtag_tx_scanen_in, jtag_weakpdn, jtag_weakpu, osc_clkin,
     por_aib_vcchssi, por_aib_vccl, r_aib_csr_ctrl_22[3],
     r_aib_csr_ctrl_16[7], r_aib_csr_ctrl_28[2]);

endmodule
