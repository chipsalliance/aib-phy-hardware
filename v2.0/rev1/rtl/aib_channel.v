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
    parameter MAX_SCAN_LEN = 200,
    parameter DATAWIDTH = 40
    )
 ( 
inout wire [101:0] iopad_aib,
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
output         tclk_phy,

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
output         m_rx_align_done,
output [80:0]  sr_ms_tomac,
output [72:0]  sr_sl_tomac,

//Sideband user input
input [26:0]   sl_external_cntl_26_0,  //user defined bits 26:0 for slave shift register
input [2:0]    sl_external_cntl_30_28, //user defined bits 30:28 for slave shift register
input [25:0]   sl_external_cntl_57_32, //user defined bits 57:32 for slave shift register

input [4:0]    ms_external_cntl_4_0,   //user defined bits 4:0 for master shift register
input [57:0]   ms_external_cntl_65_8,  //user defined bits 65:8 for master shift register


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

//Scan IO ports
input          i_scan_clk,
input          i_scan_clk_500m,
input          i_scan_clk_1000m,
input          i_scan_en,
input          i_scan_mode,
input  [MAX_SCAN_LEN-1:0] i_scan_din,         
output [MAX_SCAN_LEN-1:0] i_scan_dout,         

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
output         o_cfg_avmm_waitreq // asserted to indicate not ready for Cfg access

 );

wire [DATAWIDTH-1:0]    iopad_tx;
wire [DATAWIDTH-1:0]    iopad_rx;

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
wire        clkp;

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
wire [31:0] redund_0, redund_1, redund_2, redund_3;

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
    .tx_adapt_1(tx_adapt_1),
    .redund_0(redund_0),
    .redund_1(redund_1),
    .redund_2(redund_2),
    .redund_3(redund_3)

//AIB IO control CSR
);

wire vccl_aib = 1'b1;
wire vssl_aib = 1'b0;
//////////////////////////////////////////////////////////////////////
//CSR for IO  redundancy. See Table 50. Example Bump Table of AIB 2.0
////////////////////////////////////////////////////////////////////////
wire [101:0] AIB = {redund_3[5:0], redund_2[31:0], redund_1[31:0], redund_0[31:0]};
wire [39:0] csr_shift_rxdat = {AIB[100],AIB[101],AIB[98],AIB[99],AIB[96],AIB[97],AIB[94],AIB[95],AIB[92],AIB[93], 
                               AIB[90], AIB[91], AIB[88],AIB[89],AIB[86],AIB[87],AIB[84],AIB[85],AIB[82],AIB[83],
                               AIB[80], AIB[81], AIB[78],AIB[79],AIB[76],AIB[77],AIB[74],AIB[75],AIB[72],AIB[73],
                               AIB[68], AIB[69], AIB[66],AIB[67],AIB[64],AIB[65],AIB[62],AIB[63],AIB[60],AIB[61]};
wire        csr_shift_fs_fwd_clk = AIB[71];
wire        csr_shift_fs_fwd_clkb = AIB[70];
wire        csr_shift_fs_rcv_clk = AIB[59];
wire        csr_shift_fs_rcv_clkb = AIB[58];
wire        csr_shift_fs_sr_clk = AIB[57];
wire        csr_shift_fs_sr_clkb = AIB[56];
wire        csr_shift_fs_sr_data = AIB[55];
wire        csr_shift_fs_sr_load = AIB[54];
wire        csr_shift_fs_mac_rdy = AIB[53];
wire        csr_shift_fs_adapter_rstn = AIB[52];
wire [1:0]  csr_shift_spare = AIB[51:50];
wire        csr_shift_ns_adapter_rstn = AIB[49];
wire        csr_shift_ns_mac_rdy = AIB[48];
wire        csr_shift_ns_sr_load = AIB[47];
wire        csr_shift_ns_sr_data = AIB[46];
wire        csr_shift_ns_sr_clkb = AIB[45];
wire        csr_shift_ns_sr_clk  = AIB[44];
wire        csr_shift_ns_rcv_clkb = AIB[43];
wire        csr_shift_ns_rcv_clk  = AIB[42];
wire        csr_shift_ns_fwd_clkb = AIB[31];
wire        csr_shift_ns_fwd_clk  = AIB[30];
wire [39:0] csr_shift_txdat = {AIB[1], AIB[0], AIB[3], AIB[2], AIB[5], AIB[4], AIB[7], AIB[6], AIB[9], AIB[8],
                               AIB[11],AIB[10],AIB[13],AIB[12],AIB[15],AIB[14],AIB[17],AIB[16],AIB[19],AIB[18],
                               AIB[21],AIB[20],AIB[23],AIB[22],AIB[25],AIB[24],AIB[27],AIB[26],AIB[29],AIB[28],
                               AIB[33],AIB[32],AIB[35],AIB[34],AIB[37],AIB[36],AIB[39],AIB[38],AIB[41],AIB[40]};

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
wire           csr_rxswap_en=rx_adapt_0[0];       //Switch Upper/Lower 39 bit in FIFO2x mode in Gen1 mode
wire           csr_txswap_en=tx_adapt_0[0];       //Switch Upper/Lower 39 bit in FIFO2x mode in Gen1 mode
wire   [4:0]   csr_rx_mkbit=rx_adapt_1[7:3];      //Marker bit position of 79:76
wire   [4:0]   csr_tx_mkbit=tx_adapt_0[20:16];    //Marker bit position of 79:76




assign adpt_rstn =  i_conf_done & adapter_rstni;
assign dig_rstb =   i_conf_done & (~por);
wire tx_fifo_rstn = (dual_mode_select) ?  ms_tx_transfer_en : sl_tx_transfer_en;
wire rx_fifo_rstn = (dual_mode_select) ?  ms_rx_transfer_en : sl_rx_transfer_en;

wire [39:0] idat0, idat1, data_out0, data_out1;
genvar i;
generate
   for (i=1; i<(DATAWIDTH+1); i=i+1) begin:data_in_gen
      assign idat0[i-1] = aibio_dout[2*i-2];
      assign idat1[i-1] = aibio_dout[2*i-1];
   end
endgenerate

generate
   for (i=1; i<(DATAWIDTH+1); i=i+1) begin:data_out_gen
      assign aibio_din[2*i-2] = data_out0[i-1];
      assign aibio_din[2*i-1] = data_out1[i-1];
   end
endgenerate

aib_adapt_2doto aib_adapt (
      .atpg_mode(1'b0),
      .dual_mode_select(dual_mode_select),
      .m_gen2_mode(m_gen2_mode),
      .adapt_rstn(adpt_rstn),
      .tx_fifo_rstn(tx_fifo_rstn),
      .rx_fifo_rstn(rx_fifo_rstn),
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

      .m_rx_align_done(m_rx_align_done),

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
     .csr_rx_mkbit(csr_rx_mkbit),
     .csr_tx_mkbit(csr_tx_mkbit),
     .csr_rxswap_en(csr_rxswap_en),
     .csr_txswap_en(csr_txswap_en),
     .csr_tx_phcomp_rd_delay(csr_tx_phcomp_rd_delay),
     .csr_rx_phcomp_rd_delay(csr_rx_phcomp_rd_delay),
     .csr_tx_dbi_en(csr_tx_dbi_en),
     .csr_rx_dbi_en(csr_rx_dbi_en),
     .csr_lpbk_mode(csr_lpbk_mode)
);


aib_ioring #(.DATAWIDTH(DATAWIDTH)) aib_ioring ( 
     .iopad_txdat({     iopad_aib[1:0],  iopad_aib[3:2],  iopad_aib[5:4],  iopad_aib[7:6],  iopad_aib[9:8],
                        iopad_aib[11:10],iopad_aib[13:12],iopad_aib[15:14],iopad_aib[17:16],iopad_aib[19:18], 
                        iopad_aib[21:20],iopad_aib[23:22],iopad_aib[25:24],iopad_aib[27:26],iopad_aib[29:28], 
                        iopad_aib[33:32],iopad_aib[35:34],iopad_aib[37:36],iopad_aib[39:38],iopad_aib[41:40]}), 
//   .iopad_txdat(iopad_tx), 
//   .iopad_rxdat(iopad_rx), 
     .iopad_rxdat({     iopad_aib[100],iopad_aib[101],iopad_aib[98],iopad_aib[99],iopad_aib[96],iopad_aib[97],
                        iopad_aib[94], iopad_aib[95], iopad_aib[92],iopad_aib[93],iopad_aib[90],iopad_aib[91],  
                        iopad_aib[88], iopad_aib[89], iopad_aib[86],iopad_aib[87],iopad_aib[84],iopad_aib[85],
                        iopad_aib[82], iopad_aib[83], iopad_aib[80],iopad_aib[81],iopad_aib[78],iopad_aib[79],
                        iopad_aib[76], iopad_aib[77], iopad_aib[74],iopad_aib[75],iopad_aib[72],iopad_aib[73],
                        iopad_aib[68], iopad_aib[69], iopad_aib[66],iopad_aib[67],iopad_aib[64],iopad_aib[65],
                        iopad_aib[62], iopad_aib[63], iopad_aib[60],iopad_aib[61]}), 
     .iopad_txclkb(iopad_aib[43]), //iopad_ns_rcv_clkb), 
     .iopad_txclk(iopad_aib[42]), //iopad_ns_rcv_clk),
     .iopad_txfck(iopad_aib[30]), //iopad_ns_fwd_clk), 
     .iopad_txfckb(iopad_aib[31]), //iopad_ns_fwd_clkb),
     .iopad_stck(iopad_aib[44]), //iopad_ns_sr_clk), 
     .iopad_stckb(iopad_aib[45]), //iopad_ns_sr_clkb),
     .iopad_stl(iopad_aib[47]), //iopad_ns_sr_load), 
     .iopad_std(iopad_aib[46]), //iopad_ns_sr_data),
     .iopad_rstno(iopad_aib[48]), //iopad_ns_mac_rdy), 
     .iopad_arstno(iopad_aib[49]), //iopad_ns_adapter_rstn),
     .iopad_spareo(iopad_aib[51]), //iopad_spare1), 
     .iopad_sparee(iopad_aib[50]), //iopad_spare0),
     .iopad_rxclkb(iopad_aib[58]), //iopad_fs_rcv_clkb), 
     .iopad_rxclk(iopad_aib[59]), //iopad_fs_rcv_clk),
     .iopad_rxfckb(iopad_aib[70]), //iopad_fs_fwd_clkb), 
     .iopad_rxfck(iopad_aib[71]), //iopad_fs_fwd_clk),
     .iopad_srckb(iopad_aib[56]), //iopad_fs_sr_clkb), 
     .iopad_srck(iopad_aib[57]), //iopad_fs_sr_clk),
     .iopad_srl(iopad_aib[54]), //iopad_fs_sr_load), 
     .iopad_srd(iopad_aib[55]), //iopad_fs_sr_data),
     .iopad_rstni(iopad_aib[53]), //iopad_fs_mac_rdy), 
     .iopad_arstni(iopad_aib[52]), //iopad_fs_adapter_rstn),

     .tx_launch_clk(dcc_clk_out),
//   .tx_launch_div2_clk(tx_launch_div2_clk),
     .fs_rvc_clk_tomac(fs_rvc_clk_tomac),
     .ns_rvc_clk_frmac(ns_rvc_clk_frmac),
//   .ns_rvc_div2_clk_frmac(ns_rvc_div2_clk_frmac),
     .dig_rstb(dig_rstb), //reset for io
     .iddren(csr_iddren),
     .idataselb(csr_idataselb),
     .itxen(csr_itxen),
     .irxen(csr_irxen),
     .idat0(idat0[39:0]),
     .idat1(idat1[39:0]),
     .data_out0(data_out0[39:0]),
     .data_out1(data_out1[39:0]),
     .clk_dll_out(clk_dll_out),
     .clkp(clkp),
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

     .tx_shift_en(csr_shift_txdat),
     .rx_shift_en(csr_shift_rxdat),
     .shift_en_txclkb(csr_shift_ns_rcv_clkb),
     .shift_en_txfckb(csr_shift_ns_fwd_clkb),
     .shift_en_stckb(csr_shift_ns_sr_clkb),
     .shift_en_stl(csr_shift_ns_sr_load),
     .shift_en_arstno(csr_shift_ns_adapter_rstn),
     .shift_en_txclk(csr_shift_ns_rcv_clk),
     .shift_en_std(csr_shift_ns_sr_data),
     .shift_en_stck(csr_shift_ns_sr_clk),
     .shift_en_txfck(csr_shift_ns_fwd_clk),
     .shift_en_rstno(csr_shift_ns_mac_rdy),
     .shift_en_rxclkb(csr_shift_fs_rcv_clkb),
     .shift_en_rxfckb(csr_shift_fs_fwd_clkb),
     .shift_en_srckb(csr_shift_fs_sr_clkb),
     .shift_en_srl(csr_shift_fs_sr_load),
     .shift_en_arstni(csr_shift_fs_adapter_rstn),
     .shift_en_rxclk(csr_shift_fs_rcv_clk),
     .shift_en_rxfck(csr_shift_fs_fwd_clk),
     .shift_en_srck(csr_shift_fs_sr_clk),
     .shift_en_srd(csr_shift_fs_sr_data),
     .shift_en_rstni(csr_shift_fs_mac_rdy),
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
     .clkp(clkp),
     .clkn(~clkp),
     .rstb(adpt_rstn), // Hold DDR in reset if SDR Mode
     .rx_clk_tree_in(clk_dll_out),
     .ms_rx_dll_lock_req(ms_rx_dll_lock_req),
     .ms_rx_dll_lock(ms_rx_dll_lockint),
     .sl_rx_dll_lock_req(sl_rx_dll_lock_req),
     .sl_rx_dll_lock(sl_rx_dll_lockint),
     .ms_nsl(dual_mode_select),
     .atpg_mode(1'b0)
      );
assign fs_fwd_clk_tomac = clk_dll_out;

endmodule // aib_channel
