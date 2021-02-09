// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2021 Intel Corporation. All rights reserved
// ==========================================================================
//
// Module name    : aib_channel
// Description    : Behavioral model of AIB2.0 channel
//                  Based on Behavioral model of AIB1.0
//                  
// Revision       : 1.0
// ============================================================================
module aib_channel 
 #(
    parameter DATAWIDTH = 40
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
inout wire     iopad_spare1, 
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

input  [DATAWIDTH*8-1:0] data_in_f,
output [DATAWIDTH*8-1:0] data_out_f,

input  [DATAWIDTH*2-1:0] data_in,
output [DATAWIDTH*2-1:0] data_out,

input          m_ns_fwd_clk,
input          m_ns_rcv_clk,
output         m_fs_rcv_clk,
output         m_fs_fwd_clk,
input          m_wr_clk,
input          m_rd_clk,

input          ns_adapter_rstn,  //The name is the same as spec, but not consistent 
input          ns_mac_rdy,       //with other m_* name convention.
output         fs_mac_rdy,       //


input          i_conf_done,
input          ms_rx_dcc_dll_lock_req,
input          ms_tx_dcc_dll_lock_req,
input          sl_tx_dcc_dll_lock_req,
input          sl_rx_dcc_dll_lock_req,
output         ms_tx_transfer_en,
output         ms_rx_transfer_en,
output         sl_tx_transfer_en,
output         sl_rx_transfer_en,
output         m_rxfifo_align_done,
output [80:0]  sr_ms_tomac,
output [72:0]  sr_sl_tomac,

//Sideband user input
input [26:0]   sl_external_cntl_26_0,  //user defined bits 26:0 for slave shift register
input [2:0]    sl_external_cntl_30_28, //user defined bits 30:28 for slave shift register
input [25:0]   sl_external_cntl_57_32, //user defined bits 57:32 for slave shift register

input [4:0]    ms_external_cntl_4_0,   //user defined bits 4:0 for master shift register
input [57:0]   ms_external_cntl_65_8,  //user defined bits 65:8 for master shift register


output         wa_error,
output [3:0]   wa_error_cnt,

input          dual_mode_select, //Mater or Slave
input          m_gen2_mode,  //If 1, it is aib2.0

//Interface with aux channel
input          por, //from aux channel
input          i_osc_clk, //from aux channel

//JTAG interface
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

input [5:0]    i_channel_id, // channel ID to program
input          i_cfg_avmm_clk,
input          i_cfg_avmm_rst_n,
input [16:0]   i_cfg_avmm_addr, // address to be programmed
input [3:0]    i_cfg_avmm_byte_en, // byte enable
input          i_cfg_avmm_read, // Asserted to indicate the Cfg read access
input          i_cfg_avmm_write, // Asserted to indicate the Cfg write access
input [31:0]   i_cfg_avmm_wdata, // data to be programmed

output         o_cfg_avmm_rdatavld,// Assert to indicate data available for Cfg read access
output [31:0]  o_cfg_avmm_rdata, // data returned for Cfg read access
output         o_cfg_avmm_waitreq, // asserted to indicate not ready for Cfg access

input          vccl_aib,
input          vssl_aib );



wire        dig_rstb;
wire        ms_rx_dll_lock_req;
wire        ms_rx_dll_lock;
wire        ms_tx_async_rst;
wire        ms_tx_dcc_cal_req;
wire        ms_tx_dcc_cal_doneint;
wire        ms_rx_dll_lockint;
wire        sl_osc_transfer_en;
wire        sl_fifo_tx_async_rst;
wire        sl_tx_dcc_cal_done;
wire        sl_tx_dcc_cal_req;
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
wire [31:0] rx_adapt_0, rx_adapt_1;
wire [31:0] tx_adapt_0, tx_adapt_1;

wire [79:0] aibio_din, aibio_dout;


aib_avmm avmm_config (
    .cfg_avmm_addr_id(i_channel_id),
    .cfg_avmm_clk(i_cfg_avmm_clk),
    .cfg_avmm_rst_n(i_cfg_avmm_rst_n),
    .cfg_avmm_write(i_cfg_avmm_write),
    .cfg_avmm_read(i_cfg_avmm_read),
    .cfg_avmm_addr(i_cfg_avmm_addr),
    .cfg_avmm_wdata(i_cfg_avmm_wdata),
    .cfg_avmm_byte_en(i_cfg_avmm_byte_en),
    .cfg_avmm_rdata(o_cfg_avmm_rdata),
    .cfg_avmm_rdatavld(o_cfg_avmm_rdatavld),
    .cfg_avmm_waitreq(o_cfg_avmm_waitreq),

//Adapt control CSR
    .rx_adapt_0(rx_adapt_0),
    .rx_adapt_1(rx_adapt_1),
    .tx_adapt_0(tx_adapt_0),
    .tx_adapt_1(tx_adapt_1)

//AIB IO control CSR
);

//////////////////////////////////////////////////////////////////////
//CSR for IO  redundancy
////////////////////////////////////////////////////////////////////////
wire  [DATAWIDTH-1:0]   csr_shift_en_tx = 40'h0; //tx red. shift enable
wire  [DATAWIDTH-1:0]   csr_shift_en_rx = 40'h0; //rx red. shift enable
wire           csr_shift_en_txclkb = 1'b0;
wire           csr_shift_en_txfckb = 1'b0;
wire           csr_shift_en_stckb = 1'b0;
wire           csr_shift_en_stl = 1'b0;
wire           csr_shift_en_arstno = 1'b0;
wire           csr_shift_en_txclk = 1'b0;
wire           csr_shift_en_std = 1'b0;
wire           csr_shift_en_stck = 1'b0;
wire           csr_shift_en_txfck = 1'b0;
wire           csr_shift_en_rstno = 1'b0;
wire           csr_shift_en_rxclkb = 1'b0;
wire           csr_shift_en_rxfckb = 1'b0;
wire           csr_shift_en_srckb = 1'b0;
wire           csr_shift_en_srl = 1'b0;
wire           csr_shift_en_arstni = 1'b0;
wire           csr_shift_en_rxclk = 1'b0;
wire           csr_shift_en_rxfck = 1'b0;
wire           csr_shift_en_srck = 1'b0;
wire           csr_shift_en_srd = 1'b0;
wire           csr_shift_en_rstni = 1'b0;

wire           csr_iddren = 1'b1;        //csr for turn on DDR bumps
wire           csr_idataselb = 1'b0;     //csr for turn on async buffer
wire           csr_itxen = 1'b1;         //csr for turn on transmit buffer
wire   [2:0]   csr_irxen = 3'b111;         //csr for turn on receiver buffer

///////////////////////////////////////////////////////////////////////////////////////////
//CSR for Adapter
///////////////////////////////////////////////////////////////////////////////////////////
wire   [1:0]   csr_rx_fifo_mode=rx_adapt_1[2:1]; //2'b00 1xfifo, 2'b01 2xfifo, 2'b10 4xfifo, 2'b11 reg mode
wire   [1:0]   csr_tx_fifo_mode=tx_adapt_0[22:21]; //2'b00 1xfifo, 2'b01 2xfifo, 2'b10 4xfifo, 2'b11 reg mode
wire           csr_rx_wa_en=rx_adapt_1[0];      // RX word alignment detection enable
wire           csr_tx_wm_en=tx_adapt_0[23];      // TX word marker insertion enable
wire   [3:0]   csr_tx_phcomp_rd_delay=tx_adapt_0[31:28]; //TX phase compensation FIFO read enable delay
wire   [3:0]   csr_rx_phcomp_rd_delay={1'b0,rx_adapt_0[26:24]}; //RX phase compensation FIFO read enable delay
wire           csr_tx_dbi_en=tx_adapt_0[1];          //TX DBI enable
wire           csr_rx_dbi_en=rx_adapt_0[1];          //RX DBI enable
wire   [1:0]   csr_lpbk_mode=tx_adapt_1[15:14];   //2'b00 no loopback. 2'b01 farside loopback. 2'b10 nearside loopback




assign adpt_rstn =  i_conf_done & adapter_rstni;
assign dig_rstb =   i_conf_done;


aib_adapt_2doto aib_adapt (
      .atpg_mode(1'b0),
      .dual_mode_select(dual_mode_select),
      .data_out_f(data_out_f), //to mac
      .data_out(data_out), //to mac
      .data_in(data_in),  //from mac
      .data_in_f(data_in_f),  //from mac

      .aibio_dout(aibio_dout[79:0]),   //to IO buffer
      .aibio_din(aibio_din[79:0]),      //from IO buffer

      .m_ns_fwd_clk(m_ns_fwd_clk),
      .m_ns_rcv_clk(m_ns_rcv_clk),
      .m_wr_clk(m_wr_clk),
      .m_rd_clk(m_rd_clk),
      .m_fs_fwd_clk(m_fs_fwd_clk),
      .m_fs_rcv_clk(m_fs_rcv_clk),

      .fs_fwd_clk(fs_fwd_clk_tomac),
      .fs_rcv_clk(fs_rvc_clk_tomac),
      .ns_fwd_clk(ns_fwd_clk_frmac),
      .ns_rcv_clk(ns_rvc_clk_frmac),

      .m_ns_adapter_rstn(ns_adapter_rstn),   //Name is the same as AIB spec
      .m_ns_mac_rdy(ns_mac_rdy),               //But not consistent with 
      .m_fs_mac_rdy(fs_mac_rdy),             //Other m_* name convention.

      .ns_mac_rdyo(rstn_out),
      .fs_mac_rdyi(rstn_in),
      .ns_adapter_rstno(adapter_rstno),
      .adapter_rstni(adapter_rstni),

      .conf_done(i_conf_done),
      .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req),
      .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req),
      .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req),
      .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req),
      .ms_tx_dcc_cal_doneint(ms_tx_dcc_cal_doneint),
      .sl_tx_dcc_cal_doneint(sl_tx_dcc_cal_doneint),
      .ms_rx_dll_lockint(ms_rx_dll_lockint),
      .sl_rx_dll_lockint(sl_rx_dll_lockint),
      .ms_tx_transfer_en(ms_tx_transfer_en),
      .ms_rx_transfer_en(ms_rx_transfer_en),
      .sl_tx_transfer_en(sl_tx_transfer_en),
      .sl_rx_transfer_en(sl_rx_transfer_en),
      .ms_sideband(sr_ms_tomac),
      .sl_sideband(sr_sl_tomac),

      .ms_rx_dll_lock_req(ms_rx_dll_lock_req),
      .sl_rx_dll_lock_req(sl_rx_dll_lock_req),
      .ms_tx_dcc_cal_req(ms_tx_dcc_cal_req),
      .sl_tx_dcc_cal_req(sl_tx_dcc_cal_req),

      .m_rxfifo_align_done(m_rxfifo_align_done),
      .wa_error(wa_error),
      .wa_error_cnt(wa_error_cnt),

      .i_osc_clk(i_osc_clk), //from aux channel

      .sl_external_cntl_26_0(sl_external_cntl_26_0),  //user defined bits 26:0 for slave shift register
      .sl_external_cntl_30_28(sl_external_cntl_30_28), //user defined bits 30:28 for slave shift register
      .sl_external_cntl_57_32(sl_external_cntl_57_32), //user defined bits 57:32 for slave shift register

      .ms_external_cntl_4_0(ms_external_cntl_4_0),   //user defined bits 4:0 for master shift register
      .ms_external_cntl_65_8(ms_external_cntl_65_8),  //user defined bits 65:8 for master shift register

  // AIB
      .sr_clk_in(sr_clk_in),      //SR clock in for master and slave from AIBIO
      .srd_in(srd_in),
      .srl_in(srl_in),
      .sr_clk_out(sr_clk_out),
      .std_out(std_out),
      .stl_out(stl_out),


  // CSR bit
     .csr_rx_fifo_mode(csr_rx_fifo_mode),
     .csr_tx_fifo_mode(csr_tx_fifo_mode),
     .csr_rx_wa_en(csr_rx_wa_en),
     .csr_tx_wm_en(csr_tx_wm_en),
     .csr_tx_phcomp_rd_delay(csr_tx_phcomp_rd_delay),
     .csr_rx_phcomp_rd_delay(csr_rx_phcomp_rd_delay),
     .csr_tx_dbi_en(csr_tx_dbi_en),
     .csr_rx_dbi_en(csr_rx_dbi_en),
     .csr_lpbk_mode(csr_lpbk_mode)
);


aib_ioring #(.DATAWIDTH(DATAWIDTH)) aib_ioring ( 
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

     .tx_launch_clk(dcc_clk_out),
//   .tx_launch_div2_clk(tx_launch_div2_clk),
     .fs_rvc_clk_tomac(fs_rvc_clk_tomac),
     .fs_fwd_clk_tomac(fs_fwd_clk_tomac),
     .ns_rvc_clk_frmac(ns_rvc_clk_frmac),
//   .ns_rvc_div2_clk_frmac(ns_rvc_div2_clk_frmac),
     .dig_rstb(dig_rstb), //reset for io
     .iddren(csr_iddren),
     .idataselb(csr_idataselb),
     .itxen(csr_itxen),
     .irxen(csr_irxen),
     .idat0(aibio_dout[39:0]),
     .idat1(aibio_dout[79:40]),
     .data_out0(aibio_din[39:0]),
     .data_out1(aibio_din[79:40]),
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

     .tx_shift_en(csr_shift_en_tx),
     .rx_shift_en(csr_shift_en_rx),
     .shift_en_txclkb(csr_shift_en_txclkb),
     .shift_en_txfckb(csr_shift_en_txfckb),
     .shift_en_stckb(csr_shift_en_stckb),
     .shift_en_stl(csr_shift_en_stl),
     .shift_en_arstno(csr_shift_en_arstno),
     .shift_en_txclk(csr_shift_en_txclk),
     .shift_en_std(csr_shift_en_std),
     .shift_en_stck(csr_shift_en_stck),
     .shift_en_txfck(csr_shift_en_txfck),
     .shift_en_rstno(csr_shift_en_rstno),
     .shift_en_rxclkb(csr_shift_en_rxclkb),
     .shift_en_rxfckb(csr_shift_en_rxfckb),
     .shift_en_srckb(csr_shift_en_srckb),
     .shift_en_srl(csr_shift_en_srl),
     .shift_en_arstni(csr_shift_en_arstni),
     .shift_en_rxclk(csr_shift_en_rxclk),
     .shift_en_rxfck(csr_shift_en_rxfck),
     .shift_en_srck(csr_shift_en_srck),
     .shift_en_srd(csr_shift_en_srd),
     .shift_en_rstni(csr_shift_en_rstni),
     .idataselb_stck(1'b1),
     .idataselb_std(1'b1),
     .idataselb_stl(1'b1),
     .idataselb_arstno(1'b1),
     .idataselb_rstno(1'b1),
     .vccl_aib(vccl_aib),
     .vssl_aib(vssl_aib) );

aib_dcc aib_dcc

   (
    .clk_in(ns_fwd_clk_frmac),    
    .ms_dcc_cal_req(ms_tx_dcc_cal_req), 
    .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req), 
    .sl_dcc_cal_req(sl_tx_dcc_cal_req), 
    .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req), 
    .ms_dcc_cal_done(ms_tx_dcc_cal_doneint),
    .sl_dcc_cal_done(sl_tx_dcc_cal_doneint),
    .clk_out(dcc_clk_out),
    .ms_nsl(dual_mode_select),
    .atpg_mode(1'b0),
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
     .ms_nsl(dual_mode_select),
     .atpg_mode(1'b0)
      );

endmodule // aib_channel
