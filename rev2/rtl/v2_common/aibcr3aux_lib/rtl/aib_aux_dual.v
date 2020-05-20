// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// ==========================================================================
//
// Module name    : aib_aux_channel
// Description    : aux channel
// Revision       : 1.0
// 04/22/2020       Current implementation is slave only
// ============================================================================
//
//
module aib_aux_dual 
   (
    // AIB IO Bidirectional 
    inout wire          device_detect, //Shrink aux74/75 due to limit microbump/C4 bump pin
    inout wire          por,           //Shrink aux85/87 pin due to limit microbump/C4 bump pin

    input               i_osc_clk,
    input               m_i_por_ovrd, //Master onlhy input, it overrides the por signal. For slave, it is tied to "0"
    input               m_i_device_detect_ovrd, //Slave only input, it overrides the device_detect signal. For Master, it is tied to "0"
    output wire         m_o_power_on_reset,
    output wire         m_o_device_detect,
    output wire         o_por_vcchssi,
    output wire         o_por_vccl,
    output wire         osc_clkout,
    input               m_i_power_on_reset,
    input               ms_nsl //"1", this is a Master. "0", this is a Slave
    );


wire device_detect_async_data_in = 1'b0;
wire device_detect_async_data_out;
wire device_detect_txen   = 1'b0;          //itxen 0: TX buffer 1: RX buffer
wire [2:0] device_detect_rxen   = 3'b000;  //000 is rx buffer receiving enable
wire device_detect_tx_sync_enable = 1'b0;  //idataselb_in0 0: async 1: sync
wire device_detect_ddren  = 1'b0;          //0: SDR  1: DDR pin
wire device_detect_weakpu = 1'b0;          //1: weak pull up 0: disable weak pull up
wire device_detect_weakpd = 1'b1;          //1: weak pull down 0: disable weak pull down

wire por_async_data_in = m_i_power_on_reset;  //Async data in
wire por_async_data_out;                      //Async data out
wire por_txen   = 1'b1;                       //itxen 0: TX buffer 1: RX buffer
wire [2:0] por_rxen   = 3'b010;               //000 is rx buffer receiving disable
wire por_tx_sync_enable = 1'b0;
wire por_ddren  = 1'b0;
wire por_weakpu = 1'b1;
wire por_weakpd = 1'b0;

assign m_o_device_detect = device_detect_async_data_out | m_i_device_detect_ovrd;

assign o_por_vcchssi = m_i_power_on_reset;
assign o_por_vccl = 1'b0;
assign osc_clkout = i_osc_clk;


wire v_hi = 1'b1;
wire v_lo = 1'b0;
aibcr3_buffx1_top  xdevice_detect ( .idata1_in1_jtag_out(),
     .idata0_in1_jtag_out(), .async_dat_in1_jtag_out(),
     .prev_io_shift_en(v_lo), .jtag_clkdr_outn(),
     .por_aib_vccl(v_lo), .por_aib_vcchssi(v_lo),
     .anlg_rstb(v_hi), .pd_data_aib(), .oclk_out(),
     .oclkb_out(), .odat0_out(), .odat1_out(),
     .odat_async_out(), .pd_data_out(),
     .async_dat_in0(device_detect_async_data_in), .async_dat_in1(v_lo),
     .iclkin_dist_in0(v_lo), .iclkin_dist_in1(v_lo),
     .idata0_in0(v_lo), .idata0_in1(v_lo),
     .idata1_in0(v_lo), .idata1_in1(v_lo),
     .idataselb_in0(device_detect_tx_sync_enable), .idataselb_in1(v_lo),
     .iddren_in0(device_detect_ddren), .iddren_in1(v_lo),
     .ilaunch_clk_in0(v_lo), .ilaunch_clk_in1(v_lo),
     .ilpbk_dat_in0(v_lo), .ilpbk_dat_in1(v_lo),
     .ilpbk_en_in0(v_lo), .ilpbk_en_in1(v_lo),
     .indrv_in0({v_lo,v_lo}), .indrv_in1({v_lo,
      v_lo}), .ipdrv_in0({v_lo,v_lo}),
     .ipdrv_in1({v_lo, v_lo}),
     .irxen_in0(device_detect_rxen),
     .irxen_in1(device_detect_rxen),
     .istrbclk_in0(v_lo), .istrbclk_in1(v_lo),
     .itxen_in0(device_detect_txen), .itxen_in1(v_lo),
     .oclk_in1(v_lo), .odat_async_aib(device_detect_async_data_out),
     .oclkb_in1(v_lo), .jtag_clksel(v_lo),
     .odat0_in1(v_lo), .odat1_in1(v_lo),
     .odat_async_in1(v_lo), .shift_en(v_lo),
     .pd_data_in1(v_lo), .dig_rstb(v_hi),
     .jtag_clkdr_out(), .jtag_intest(v_lo),
     .odat1_aib(), .jtag_rx_scan_out(), .odat0_aib(),
     .oclk_aib(), .last_bs_out(), .oclkb_aib(),
     .jtag_clkdr_in(v_lo), .jtag_rstb_en(v_lo),
     .jtag_mode_in(v_lo), .jtag_rstb(v_lo),
     .jtag_tx_scan_in(v_lo),
     .jtag_tx_scanen_in(v_lo), .last_bs_in(v_lo),
     .iopad(device_detect), .oclkn(), .iclkn(v_lo),
     .test_weakpu(device_detect_weakpu), .test_weakpd(device_detect_weakpd));


aibcr3_buffx1_top  xdn_por ( .idata1_in1_jtag_out(),
     .idata0_in1_jtag_out(), .async_dat_in1_jtag_out(),
     .prev_io_shift_en(v_lo), .jtag_clkdr_outn(),
     .por_aib_vccl(v_lo), .por_aib_vcchssi(v_lo),
     .jtag_clksel(v_lo), .jtag_intest(v_lo),
     .jtag_rstb_en(v_lo), .anlg_rstb(v_hi),
     .pd_data_aib(), .oclk_out(), .oclkb_out(),
     .odat0_out(), .odat1_out(), .odat_async_out(),
     .pd_data_out(), .async_dat_in0(por_async_data_in),
     .async_dat_in1(v_lo), .iclkin_dist_in0(v_lo),
     .iclkin_dist_in1(v_lo), .idata0_in0(v_lo),
     .idata0_in1(v_lo), .idata1_in0(v_lo),
     .idata1_in1(v_lo), .idataselb_in0(por_tx_sync_enable),
     .idataselb_in1(v_lo), .iddren_in0(por_ddren),
     .iddren_in1(v_lo), .ilaunch_clk_in0(v_lo),
     .ilaunch_clk_in1(v_lo), .ilpbk_dat_in0(v_lo),
     .ilpbk_dat_in1(v_lo), .ilpbk_en_in0(v_lo),
     .ilpbk_en_in1(v_lo), .indrv_in0({v_lo,
     v_lo}), .indrv_in1({v_lo, v_lo}),
     .ipdrv_in0({v_lo, v_lo}),
     .ipdrv_in1({v_lo, v_lo}),
     .irxen_in0(por_rxen), .irxen_in1({v_lo,
     v_lo, v_lo}), .istrbclk_in0(v_lo),
     .istrbclk_in1(v_lo), .itxen_in0(por_txen),
     .itxen_in1(v_lo), .oclk_in1(v_lo),
     .odat_async_aib(por_async_data_out), .oclkb_in1(v_lo),
     .odat0_in1(v_lo), .odat1_in1(v_lo),
     .odat_async_in1(v_lo), .shift_en(v_lo),
     .pd_data_in1(v_lo), .dig_rstb(v_hi),
     .jtag_clkdr_out(), .odat1_aib(),
     .jtag_rx_scan_out(), .odat0_aib(),
     .oclk_aib(), .last_bs_out(), .oclkb_aib(),
     .jtag_clkdr_in(v_lo), .jtag_mode_in(v_lo),
     .jtag_rstb(v_lo), .jtag_tx_scan_in(v_lo),
     .jtag_tx_scanen_in(v_lo), .last_bs_in(v_lo),
     .iopad(por), .oclkn(), .iclkn(v_lo),
     .test_weakpu(por_weakpu), .test_weakpd(por_weakpd));

endmodule // aib_aux_dual
