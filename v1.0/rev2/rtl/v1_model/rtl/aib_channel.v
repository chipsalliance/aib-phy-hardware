// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved
// ==========================================================================
//
// Module name    : aib_channel
// Description    : Behavioral model of AIB channel
// Revision       : 1.0
// Revision       : 1.1 Added ports for user define bits in shift register(By Wei Zhu)
// ============================================================================
module aib_channel 
 #(
    parameter DATAWIDTH = 20
    )
 ( 
inout wire [DATAWIDTH-1:0]    iopad_txdat,
inout wire [DATAWIDTH-1:0]    iopad_rxdat,
inout wire     iopad_txclkb, 
inout wire     iopad_txclk,
inout wire     iopad_tx_div2_clk,
inout wire     iopad_tx_div2_clkb,
inout wire     iopad_txfck, 
inout wire     iopad_txfckb,
inout wire     iopad_tx_div2_fck,
inout wire     iopad_tx_div2_fckb,
inout wire     iopad_stck, 
inout wire     iopad_stckb,
inout wire     iopad_stl, 
inout wire     iopad_std,
inout wire     iopad_rstno, 
inout wire     iopad_arstno,
inout wire     iopad_spareo, 
inout wire     iopad_sparee,
inout wire     iopad_rxclkb, 
inout wire     iopad_rxclk,
inout wire     iopad_rxfckb, 
inout wire     iopad_rxfck,
inout wire     iopad_srckb, 
inout wire     iopad_srck,
inout wire     iopad_srl, 
inout wire     iopad_srd,
inout wire     iopad_rstni, 
inout wire     iopad_arstni,

input          tx_launch_clk, //output data clock
input          tx_launch_div2_clk, //output data clock
output wire    fs_rvc_clk_tomac,
output wire    fs_fwd_clk_tomac,
input          ns_rvc_clk_frmac,
input          ns_rvc_div2_clk_frmac,
input          iddren,
input          idataselb, //output async data selection
input          itxen, //data tx enable
input [2:0]    irxen,//data input enable
input [DATAWIDTH-1:0]   idat0, //output data to pad
input [DATAWIDTH-1:0]   idat1, //output data to pad
output wire [DATAWIDTH-1:0]     data_out0, //input data from pad
output wire [DATAWIDTH-1:0]     data_out1, //input data from pad

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

input          ms_adapter_rstn, //ns_adapter_rstn
input          sl_adapter_rstn, //ns_adapter_rstn
input          ms_rstn, //ns_mac_rdy 
input          sl_rstn, //ns_mac_rdy 
output wire    fs_mac_rdy_tomac,
input          por_sl,
input          ms_nsl,
input          por_ms, //from aux channel
input          osc_clk, //from aux channel

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

input [DATAWIDTH-1:0]   tx_shift_en, //tx red. shift enable
input [DATAWIDTH-1:0]   rx_shift_en, //rx red. shift enable
input          shift_en_txclkb,
input          shift_en_txfckb,
input          shift_en_stckb,
input          shift_en_stl,
input          shift_en_arstno,
input          shift_en_txclk,
input          shift_en_std,
input          shift_en_stck,
input          shift_en_txfck,
input          shift_en_rstno,
input          shift_en_rxclkb,
input          shift_en_rxfckb,
input          shift_en_srckb,
input          shift_en_srl,
input          shift_en_arstni,
input          shift_en_rxclk,
input          shift_en_rxfck,
input          shift_en_srck,
input          shift_en_srd,
input          shift_en_rstni,

input [26:0]   sl_external_cntl_26_0,  //user defined bits 26:0 for slave shift register
input [2:0]    sl_external_cntl_30_28, //user defined bits 30:28 for slave shift register
input [25:0]   sl_external_cntl_57_32, //user defined bits 57:32 for slave shift register

input [4:0]    ms_external_cntl_4_0,   //user defined bits 4:0 for master shift register
input [57:0]   ms_external_cntl_65_8,  //user defined bits 65:8 for master shift register

input         vccl_aib,
input         vssl_aib );



wire          is_master, is_slave;
wire        dig_rstb;
wire        ms_osc_transfer_en;
//wire        ms_rx_transfer_en;
wire        ms_osc_transfer_alive;
wire        ms_rx_async_rst;
wire        ms_rx_dll_lock_req;
wire        ms_rx_dll_lock;
wire        ms_tx_async_rst;
wire        ms_tx_dcc_cal_req;
wire        ms_tx_dcc_cal_done;
//wire        ms_tx_transfer_en;
wire        ms_tx_dcc_cal_doneint;
wire        ms_rx_dll_lockint;
wire        sl_osc_transfer_en;
//wire        sl_rx_transfer_en;
wire        sl_fifo_tx_async_rst;
wire        sl_tx_dcc_cal_done;
wire        sl_tx_dcc_cal_req;
//wire        sl_tx_transfer_en;
wire        sl_rx_async_rst;
wire        sl_rx_dll_lock_req;
wire        sl_rx_dll_lock;
wire        sl_tx_dcc_cal_doneint;
wire        sl_rx_dll_lockint;

wire        std_out;
wire        stl_out;
wire        srd_in;
wire        srl_in;
wire        sr_ms_load_out;
wire        sr_clk_in;
wire        sr_clk_out;


wire        adpt_rstn;
wire        rstn_out, adapter_rstno;

wire        sr_ms_data_out;
wire [80:0] ms_data_fr_core, ms_data_to_core;
wire        sr_sl_clk_out;
wire [72:0] sl_data_fr_core, sl_data_to_core;
wire        sr_sl_data_out;
wire        sr_sl_load_out;
wire        adapter_rstni;
wire        dcc_clk_out;
wire        rstn_in;

wire             ms_tx_transfer_en_m, ms_rx_transfer_en_m;
wire             sl_tx_transfer_en_s, sl_rx_transfer_en_s;

assign ms_tx_transfer_en = ms_nsl ? ms_tx_transfer_en_m : ms_data_to_core[78];
assign ms_rx_transfer_en = ms_nsl ? ms_rx_transfer_en_m : ms_data_to_core[75];
assign sl_tx_transfer_en = !ms_nsl ? sl_tx_transfer_en_s : sl_data_to_core[64];
assign sl_rx_transfer_en = !ms_nsl ? sl_rx_transfer_en_s : sl_data_to_core[70];

assign fs_mac_rdy_tomac = rstn_in;
assign sr_ms_tomac[80:0] = ms_data_to_core[80:0];
assign sr_sl_tomac[72:0] = sl_data_to_core[72:0];

assign is_master = (ms_nsl == 1'b1) ? 1'b1 : 1'b0;
assign is_slave = !is_master;

assign adpt_rstn =  is_master ? (ms_adapter_rstn & adapter_rstni) : (sl_adapter_rstn & adapter_rstni);

assign dig_rstb =  is_master ? (ms_config_done): (sl_config_done);
//assign dig_rstb =  is_master ? (ms_config_done & ms_rstn): (sl_config_done & sl_rstn);
//assign dig_rstb =  is_master ? ms_rstn : sl_rstn;

assign sr_clk_out = is_master ? osc_clk : sr_sl_clk_out; 
assign std_out = is_master ? sr_ms_data_out : sr_sl_data_out;
assign stl_out = is_master ? sr_ms_load_out : sr_sl_load_out;

assign adapter_rstno = is_master ? ms_adapter_rstn : sl_adapter_rstn;
assign rstn_out = is_master ? ms_rstn : sl_rstn;

assign ms_data_fr_core[80:0] = {ms_osc_transfer_en,1'b1,ms_tx_transfer_en_m,2'b11,ms_rx_transfer_en_m,ms_rx_dll_lock, 5'b11111,ms_tx_dcc_cal_done,1'b0,1'b1, ms_external_cntl_65_8[57:0], 1'b1, 1'b0, 1'b1, ms_external_cntl_4_0[4:0]}; 

assign sl_data_fr_core[72:0] = {sl_osc_transfer_en,1'b0,sl_rx_transfer_en_s,sl_rx_dcc_dll_lock_req, sl_rx_dll_lock,3'b0,sl_tx_transfer_en_s,sl_tx_dcc_dll_lock_req, 1'b0,1'b0,1'b1,1'b0, 1'b1, sl_external_cntl_57_32[25:0], sl_tx_dcc_cal_done, sl_external_cntl_30_28[2:0], 1'b0, sl_external_cntl_26_0[26:0]}; 

aib_ioring #(.DATAWIDTH(DATAWIDTH)) aib_ioring ( 
     .iopad_txdat(iopad_txdat), 
     .iopad_rxdat(iopad_rxdat), 
     .iopad_txclkb(iopad_txclkb), 
     .iopad_txclk(iopad_txclk),
     .iopad_tx_div2_clkb(iopad_tx_div2_clkb),
     .iopad_tx_div2_clk(iopad_tx_div2_clk),
     .iopad_txfck(iopad_txfck), 
     .iopad_txfckb(iopad_txfckb),
     .iopad_tx_div2_fckb(iopad_tx_div2_fckb),
     .iopad_tx_div2_fck(iopad_tx_div2_fck),
     .iopad_stck(iopad_stck), 
     .iopad_stckb(iopad_stckb),
     .iopad_stl(iopad_stl), 
     .iopad_std(iopad_std),
     .iopad_rstno(iopad_rstno), 
     .iopad_arstno(iopad_arstno),
     .iopad_spareo(iopad_spareo), 
     .iopad_sparee(iopad_sparee),
     .iopad_rxclkb(iopad_rxclkb), 
     .iopad_rxclk(iopad_rxclk),
     .iopad_rxfckb(iopad_rxfckb), 
     .iopad_rxfck(iopad_rxfck),
     .iopad_srckb(iopad_srckb), 
     .iopad_srck(iopad_srck),
     .iopad_srl(iopad_srl), 
     .iopad_srd(iopad_srd),
     .iopad_rstni(iopad_rstni), 
     .iopad_arstni(iopad_arstni),

     .tx_launch_clk(dcc_clk_out),
     .tx_launch_div2_clk(tx_launch_div2_clk),
     .fs_rvc_clk_tomac(fs_rvc_clk_tomac),
     .fs_fwd_clk_tomac(fs_fwd_clk_tomac),
     .ns_rvc_clk_frmac(ns_rvc_clk_frmac),
     .ns_rvc_div2_clk_frmac(ns_rvc_div2_clk_frmac),
     .dig_rstb(dig_rstb), //reset for io
     .iddren(iddren),
     .idataselb(idataselb),
     .itxen(itxen),
     .irxen(irxen),
     .idat0(idat0),
     .idat1(idat1),
     .data_out0(data_out0),
     .data_out1(data_out1),
     .std_out(std_out),
     .stl_out(stl_out),
     .srd_in(srd_in),
     .srl_in(srl_in),
     .sr_clk_in(sr_clk_in),
     .sr_clk_out(sr_clk_out),
     .adapter_rstno(adapter_rstno),
     .rstn_out(rstn_out),
     .adapter_rstni(adapter_rstni),
     .rstn_in(rstn_in),

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

     .tx_shift_en(tx_shift_en),
     .rx_shift_en(rx_shift_en),
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
     .idataselb_stck(1'b1),
     .idataselb_std(1'b1),
     .idataselb_stl(1'b1),
     .idataselb_arstno(1'b1),
     .idataselb_rstno(1'b1),
     .vccl_aib(vccl_aib),
     .vssl_aib(vssl_aib) );

aib_sm  aib_sm
   (
    .osc_clk(osc_clk),    //from aux 
    .sr_ms_clk_in(sr_clk_in), //input ms clock
    .ms_config_done(ms_config_done),   //master config done
    .ms_osc_transfer_en(ms_osc_transfer_en),
    .ms_rx_transfer_en(ms_rx_transfer_en_m),
    .ms_osc_transfer_alive(ms_osc_transfer_alive),
    .ms_rx_async_rst(ms_rx_async_rst),
    .ms_rx_dll_lock_req(ms_rx_dll_lock_req),
    .ms_rx_dll_lock(ms_rx_dll_lock),
    .ms_tx_async_rst(ms_tx_async_rst),
    .ms_tx_dcc_cal_req(ms_tx_dcc_cal_req),
    .sl_tx_dcc_cal_req(sl_tx_dcc_cal_req),
    .ms_tx_dcc_cal_done(ms_tx_dcc_cal_done),
    .ms_tx_transfer_en(ms_tx_transfer_en_m),
    .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req),
    .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req),
    .ms_rx_dll_lockint(ms_rx_dll_lockint),   
    .ms_tx_dcc_cal_doneint(ms_tx_dcc_cal_doneint),
    .ms_tx_dcc_cal_donei(ms_data_to_core[68]),
    .ms_rx_dll_locki(ms_data_to_core[74]),   
    .ms_rx_transfer_eni(ms_data_to_core[75]),
    .ms_tx_transfer_eni(ms_data_to_core[78]),
    .ms_osc_transfer_eni(ms_data_to_core[80]),
    .sl_config_done(sl_config_done),   //slave config done
    .sl_osc_transfer_en(sl_osc_transfer_en),
    .sl_rx_transfer_en(sl_rx_transfer_en_s),
    .sl_fifo_tx_async_rst(sl_fifo_tx_async_rst),
    .sl_tx_dcc_cal_done(sl_tx_dcc_cal_done),
    .sl_tx_transfer_en(sl_tx_transfer_en_s),
    .sl_rx_async_rst(sl_rx_async_rst),
    .sl_rx_dll_lock_req(sl_rx_dll_lock_req),
    .sl_rx_dll_lock(sl_rx_dll_lock),
    .sl_tx_dcc_dll_lock_req(sl_data_to_core[63]),
    .sl_rx_dcc_dll_lock_req(sl_data_to_core[69]),
    .sl_rx_dll_lockint(sl_rx_dll_lockint), //from slave internal
    .sl_rx_dll_locki(sl_data_to_core[68]),   //from sr interface
    .sl_tx_dcc_cal_donei(sl_data_to_core[31]), //from sr interface
    .sl_tx_dcc_cal_doneint(sl_tx_dcc_cal_doneint),  //from slave internal
    .sl_rx_transfer_eni(sl_data_to_core[70]),
    .sl_osc_transfer_eni(sl_data_to_core[72]),
    .ms_nsl(ms_nsl),       //ms_adapter_rstn & sl_adapter_rstn
    .atpg_mode(),
    .reset_n(adpt_rstn)       //ms_adapter_rstn & sl_adapter_rstn
    );

aib_sr_ms #(
            .MS_LENGTH(7'd81))
aib_sr_ms
   (
    .osc_clk(osc_clk),    //free running osc clock
    .ms_data_fr_core(ms_data_fr_core[80:0]),
    .ms_data_to_core(ms_data_to_core[80:0]),
    .sr_ms_data_out(sr_ms_data_out), //master serial data out
    .sr_ms_load_out(sr_ms_load_out), //master load out
    .sr_ms_data_in(srd_in), //master serial data out
    .sr_ms_load_in(srl_in), //master serial data load inupt
    .sr_ms_clk_in(sr_clk_in), //from input por
    .ms_nsl(ms_nsl), 
    .atpg_mode(),
    .reset_n(ms_config_done)       //Per email from Tim on 10/17/19. And confirmation from Julie, this is equivalent to HARD_RESET
    );

aib_sr_sl #(
            .SL_LENGTH(7'd73))
aib_sr_sl
   (
    .sr_sl_clk_in(sr_clk_in),    //From input
    .sr_sl_clk_out(sr_sl_clk_out),    //to output
    .sl_data_fr_core(sl_data_fr_core[72:0]),
    .sl_data_to_core(sl_data_to_core[72:0]),
    .sr_sl_data_out(sr_sl_data_out), //slave serial data out
    .sr_sl_load_out(sr_sl_load_out), //slave load out
    .sr_sl_data_in(srd_in), //slave serial data out
    .sr_sl_load_in(srl_in), //slave serial data load inupt
    .sr_ms_clk_in(sr_clk_in), //input ms clock
    .ms_nsl(ms_nsl), 
    .atpg_mode(),
    .reset_n(sl_config_done)       //Per email from Tim on 10/17/19. And confirmation from Julie, this is equivalent to HARD_RESET
    );

aib_dcc aib_dcc

   (
    .clk_in(tx_launch_clk),    
    .ms_dcc_cal_req(ms_tx_dcc_cal_req), 
    .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req), 
    .sl_dcc_cal_req(sl_tx_dcc_cal_req), 
    .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req), 
    .ms_dcc_cal_done(ms_tx_dcc_cal_doneint),
    .sl_dcc_cal_done(sl_tx_dcc_cal_doneint),
    .clk_out(dcc_clk_out),
    .ms_nsl(ms_nsl),
    .atpg_mode(),
    .reset_n(adpt_rstn)       
    );

   dll  u_dll
     (
     .clkp(fs_fwd_clk_tomac),
     .clkn(~fs_fwd_clk_tomac),
     .rstb(adpt_rstn), // Hold DDR in reset if SDR Mode
     .rx_clk_tree_in(clk_dll_out),
     .ms_rx_dll_lock_req(ms_rx_dll_lock_req),
     .ms_rx_dll_lock(ms_rx_dll_lockint),
     .sl_rx_dll_lock_req(sl_rx_dll_lock_req),
     .sl_rx_dll_lock(sl_rx_dll_lockint),
     .ms_nsl(ms_nsl),
     .atpg_mode()
      );

endmodule // aib_channel
