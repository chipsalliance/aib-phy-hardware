// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// ==========================================================================
//
// Module name    : aib
// Description    : Behavioral model of AIB top level
// Revision       : 1.0
// Revision       : 1.1 Added ports for user define bits in shift register
// ============================================================================
module aib #(
    parameter DATAWIDTH = 20
    )
 ( 
inout wire [DATAWIDTH-1:0]    iopad_tx,
inout wire [DATAWIDTH-1:0]    iopad_rx,
inout wire     iopad_ns_rcv_clkb, 
inout wire     iopad_ns_rcv_clk,
inout wire     iopad_ns_fwd_clk, 
inout wire     iopad_ns_fwd_clkb,
inout wire     iopad_ns_sr_clk, 
inout wire     iopad_ns_sr_clkb,
inout wire     iopad_ns_sr_load, 
inout wire     iopad_ns_sr_data,
inout wire     iopad_ns_mac_rdy, 
inout wire     iopad_ns_adapter_rstn,
inout wire     iopad_spare1,  //iopad_spareo
inout wire     iopad_spare0,
inout wire     iopad_fs_rcv_clkb, 
inout wire     iopad_fs_rcv_clk,
inout wire     iopad_fs_fwd_clkb, 
inout wire     iopad_fs_fwd_clk,
inout wire     iopad_fs_sr_clkb, 
inout wire     iopad_fs_sr_clk,
inout wire     iopad_fs_sr_load, 
inout wire     iopad_fs_sr_data,
inout wire     iopad_fs_mac_rdy, 
inout wire     iopad_fs_adapter_rstn,
inout wire     iopad_device_detect,
inout wire     iopad_device_detect_copy,
inout wire     iopad_por,
inout wire     iopad_por_copy,

input [DATAWIDTH*2 - 1 :0]   data_in, //output data to pad
output wire [DATAWIDTH*2 - 1:0]     data_out, //input data from pad
input          m_ns_fwd_clk, //output data clock
output wire    m_fs_rcv_clk,
output wire    m_fs_fwd_clk,
input          m_ns_rcv_clk,

input          ms_ns_adapter_rstn,
input          sl_ns_adapter_rstn,
input          ms_ns_mac_rdy,
input          sl_ns_mac_rdy,
output wire    fs_mac_rdy,

input          ms_config_done,
input          ms_rx_dcc_dll_lock_req,
input          ms_tx_dcc_dll_lock_req,
input          sl_config_done,
input          sl_tx_dcc_dll_lock_req,
input          sl_rx_dcc_dll_lock_req,
output wire    ms_tx_transfer_en,
output wire    ms_rx_transfer_en,
output wire    sl_tx_transfer_en,
output wire    sl_rx_transfer_en,
output wire [80:0] sr_ms_tomac,
output wire [72:0] sr_sl_tomac,
input          ms_nsl,

input          iddren,
input          idataselb, //output async data selection
input          itxen, //data tx enable
input [2:0]    irxen,//data input enable

//Aux channel
//input          ms_device_detect,
input          m_por_ovrd,
input          m_device_detect_ovrd,
input          m_power_on_reset_i,
output wire    m_device_detect,
output wire    m_power_on_reset,
//JTAG signals
input          jtag_clkdr_in,
output wire    scan_out,
input          jtag_intest,
input          jtag_mode_in,
input          jtag_rstb,
input          jtag_rstb_en,
input          jtag_weakpdn,
input          jtag_weakpu,
input          jtag_tx_scanen_in,
input          scan_in,
//Redundancy control signals for IO buffers
`include "redundancy_ctrl.vh"

input [26:0]   sl_external_cntl_26_0,  //user defined bits 26:0 for slave shift register
input [2:0]    sl_external_cntl_30_28, //user defined bits 30:28 for slave shift register
input [25:0]   sl_external_cntl_57_32, //user defined bits 57:32 for slave shift register

input [4:0]    ms_external_cntl_4_0,   //user defined bits 4:0 for master shift register
input [57:0]   ms_external_cntl_65_8,  //user defined bits 65:8 for master shift register

input         vccl_aib,
input         vssl_aib );

wire por_ms, osc_clk;

assign m_power_on_reset = por_ms;

aib_channel #(.DATAWIDTH(DATAWIDTH)) aib_channel 
 ( 
     .iopad_txdat(iopad_tx),
     .iopad_rxdat(iopad_rx),
     .iopad_txclkb(iopad_ns_rcv_clkb), 
     .iopad_txclk(iopad_ns_rcv_clk),
     .iopad_txfck(iopad_ns_fwd_clk), 
     .iopad_txfckb(iopad_ns_fwd_clkb),
     .iopad_stck(iopad_ns_sr_clk), 
     .iopad_stckb(iopad_ns_sr_clkb),
     .iopad_stl(iopad_ns_sr_load), 
     .iopad_std(iopad_ns_sr_data),
     .iopad_rstno(iopad_ns_mac_rdy), 
     .iopad_arstno(iopad_ns_adapter_rstn),
     .iopad_spareo(iopad_spare1), 
     .iopad_sparee(iopad_spare0),
     .iopad_rxclkb(iopad_fs_rcv_clkb), 
     .iopad_rxclk(iopad_fs_rcv_clk),
     .iopad_rxfckb(iopad_fs_fwd_clkb), 
     .iopad_rxfck(iopad_fs_fwd_clk),
     .iopad_srckb(iopad_fs_sr_clkb), 
     .iopad_srck(iopad_fs_sr_clk),
     .iopad_srl(iopad_fs_sr_load), 
     .iopad_srd(iopad_fs_sr_data),
     .iopad_rstni(iopad_fs_mac_rdy), 
     .iopad_arstni(iopad_fs_adapter_rstn),

     .tx_launch_clk(m_ns_fwd_clk), //output data clock
     .fs_rvc_clk_tomac(m_fs_rcv_clk), 
     .fs_fwd_clk_tomac(m_fs_fwd_clk), 
     .ns_rvc_clk_frmac(m_ns_rcv_clk), 
     .iddren(iddren),
     .idataselb(idataselb), //output async data selection
     .itxen(itxen), //data tx enable
     .irxen(irxen),//data input enable
     .idat0(data_in[DATAWIDTH-1:0]), //output data to pad
     .idat1(data_in[DATAWIDTH *2 -1 : DATAWIDTH]), //output data to pad
     .data_out0(data_out[DATAWIDTH-1:0]), //input data from pad
     .data_out1(data_out[DATAWIDTH *2 -1 : DATAWIDTH]), //input data from pad

     .ms_config_done(ms_config_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req),
     .sl_config_done(sl_config_done),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req),
     .ms_tx_transfer_en(ms_tx_transfer_en),
     .ms_rx_transfer_en(ms_rx_transfer_en),
     .sl_tx_transfer_en(sl_tx_transfer_en),
     .sl_rx_transfer_en(sl_rx_transfer_en),
     .sr_ms_tomac(sr_ms_tomac[80:0]),
     .sr_sl_tomac(sr_sl_tomac[72:0]),

     .ms_adapter_rstn(ms_ns_adapter_rstn),
     .sl_adapter_rstn(sl_ns_adapter_rstn),
     .ms_rstn(ms_ns_mac_rdy),
     .sl_rstn(sl_ns_mac_rdy),
     .fs_mac_rdy_tomac(fs_mac_rdy),
     .por_sl(m_power_on_reset_i),
     .ms_nsl(ms_nsl),
     .por_ms(por_ms),
     .osc_clk(osc_clk),
//JTAG interface
     .jtag_clkdr_in(jtag_clkdr_in),
     .scan_out(scan_out),
     .jtag_intest(jtag_intest),
     .jtag_mode_in(jtag_mode_in),
     .jtag_rstb(jtag_rstb),
     .jtag_rstb_en(jtag_rstb_en),
     .jtag_weakpdn(jtag_weakpdn),
     .jtag_weakpu(jtag_weakpu),
     .jtag_tx_scanen_in(jtag_tx_scanen_in),
     .scan_in(scan_in),

     .tx_shift_en(shift_en_tx), //tx red. shift enable
     .rx_shift_en(shift_en_rx), //rx red. shift enable
     .shift_en_txclkb(shift_en_txclkb),
     .shift_en_txfckb(shift_en_txfckb),
     .shift_en_stckb(shift_en_stckb),
     .shift_en_stl(shift_en_stl),
     .shift_en_arstno(shift_en_arstno),
     .shift_en_txclk(shift_en_txclk),
     .shift_en_std(shift_en_std),
     .shift_en_stck(shift_en_stck),
     .shift_en_txfck(shift_en_txfck),
     .shift_en_rstno(shift_en_rstno),
     .shift_en_rxclkb(shift_en_rxclkb),
     .shift_en_rxfckb(shift_en_rxfckb),
     .shift_en_srckb(shift_en_srckb),
     .shift_en_srl(shift_en_srl),
     .shift_en_arstni(shift_en_arstni),
     .shift_en_rxclk(shift_en_rxclk),
     .shift_en_rxfck(shift_en_rxfck),
     .shift_en_srck(shift_en_srck),
     .shift_en_srd(shift_en_srd),
     .shift_en_rstni(shift_en_rstni),

     .sl_external_cntl_26_0(sl_external_cntl_26_0[26:0]),
     .sl_external_cntl_30_28(sl_external_cntl_30_28[2:0]),
     .sl_external_cntl_57_32(sl_external_cntl_57_32[25:0]),

     .ms_external_cntl_4_0(ms_external_cntl_4_0[4:0]),
     .ms_external_cntl_65_8(ms_external_cntl_65_8[57:0]),

     .vccl_aib(vccl_aib),
     .vssl_aib(vssl_aib) );

aib_aux_channel  aib_aux_channel
   (
    // AIB IO Bidirectional 
    .iopad_dev_dect(iopad_device_detect),
    .iopad_dev_dectrdcy(iopad_device_detect_copy),
    .iopad_dev_por(iopad_por),
    .iopad_dev_porrdcy(iopad_por_copy),

//    .device_detect_ms(ms_device_detect),
    .m_por_ovrd(m_por_ovrd),
    .m_device_detect_ovrd(m_device_detect_ovrd),
    .por_ms(por_ms),
    .m_device_detect(m_device_detect),
    .por_sl(m_power_on_reset_i),
    .osc_clk(osc_clk),
    .ms_nsl(ms_nsl),
    .irstb(1'b1) // Output buffer tri-state enable
    );

endmodule // aib
