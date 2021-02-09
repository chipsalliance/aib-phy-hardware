// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved
// ==========================================================================
//
// Module name    : aib
// Description    : Behavioral model of AIB top level
// Revision       : 1.0
// Revision       : 1.1 Added ports for user define bits in shift register
// Revision       : 1.2 Added ports ns_fwd_div2_clk and ns_rcv_div2_clk
// ============================================================================
module aib_model_top #(
    parameter DATAWIDTH = 20,
    parameter TOTAL_CHNL_NUM = 16
    )
 ( 
inout  [95:0]                  m0_ch0_aib,
inout  [95:0]                  m0_ch1_aib,
inout  [95:0]                  m0_ch2_aib,
inout  [95:0]                  m0_ch3_aib,
inout  [95:0]                  m0_ch4_aib,
inout  [95:0]                  m0_ch5_aib,
inout  [95:0]                  m1_ch0_aib,
inout  [95:0]                  m1_ch1_aib,
inout  [95:0]                  m1_ch2_aib,
inout  [95:0]                  m1_ch3_aib,
inout  [95:0]                  m1_ch4_aib,
inout  [95:0]                  m1_ch5_aib,
inout  [95:0]                  m2_ch0_aib,
inout  [95:0]                  m2_ch1_aib,
inout  [95:0]                  m2_ch2_aib,
inout  [95:0]                  m2_ch3_aib,

inout                          iopad_device_detect,
inout                          iopad_device_detect_copy,
inout                          iopad_por,
inout                          iopad_por_copy,

input  [DATAWIDTH*2*TOTAL_CHNL_NUM-1 :0]   data_in, //output data to pad
output [DATAWIDTH*2*TOTAL_CHNL_NUM-1 :0]   data_out, //input data from pad
input  [TOTAL_CHNL_NUM-1:0]    m_ns_fwd_clk, //output data clock
input  [TOTAL_CHNL_NUM-1:0]    m_ns_fwd_div2_clk, //Newly added 11/09/20
output [TOTAL_CHNL_NUM-1:0]    m_fs_rvc_clk, 
output [TOTAL_CHNL_NUM-1:0]    m_fs_fwd_clk,
input  [TOTAL_CHNL_NUM-1:0]    m_ns_rvc_clk,
input [TOTAL_CHNL_NUM-1:0]     m_ns_rvc_div2_clk, //Newly added 11/09/20

input  [TOTAL_CHNL_NUM-1:0]    ms_ns_adapter_rstn,
input  [TOTAL_CHNL_NUM-1:0]    sl_ns_adapter_rstn,
input  [TOTAL_CHNL_NUM-1:0]    ms_ns_mac_rdy,
input  [TOTAL_CHNL_NUM-1:0]    sl_ns_mac_rdy,
output [TOTAL_CHNL_NUM-1:0]    fs_mac_rdy,

input                          ms_config_done,
input  [TOTAL_CHNL_NUM-1:0]    ms_rx_dcc_dll_lock_req,
input  [TOTAL_CHNL_NUM-1:0]    ms_tx_dcc_dll_lock_req,
input                          sl_config_done,
input  [TOTAL_CHNL_NUM-1:0]    sl_tx_dcc_dll_lock_req,
input  [TOTAL_CHNL_NUM-1:0]    sl_rx_dcc_dll_lock_req,
output [TOTAL_CHNL_NUM-1:0]    ms_tx_transfer_en,
output [TOTAL_CHNL_NUM-1:0]    ms_rx_transfer_en,
output [TOTAL_CHNL_NUM-1:0]    sl_tx_transfer_en,
output [TOTAL_CHNL_NUM-1:0]    sl_rx_transfer_en,
output [81*TOTAL_CHNL_NUM-1:0] sr_ms_tomac,
output [73*TOTAL_CHNL_NUM-1:0] sr_sl_tomac,
input                          ms_nsl,

input  [TOTAL_CHNL_NUM-1:0]    iddren,
input  [TOTAL_CHNL_NUM-1:0]    idataselb, //output async data selection
input  [TOTAL_CHNL_NUM-1:0]    itxen, //data tx enable
input  [3*TOTAL_CHNL_NUM-1:0]  irxen,//data input enable

//Aux channel
//input          ms_device_detect,
input                          m_por_ovrd,
input                          m_device_detect_ovrd,
input                          m_power_on_reset_i,
output                         m_device_detect,
output                         m_power_on_reset,
//JTAG signals
input                          jtag_clkdr_in,
output                         scan_out,
input                          jtag_intest,
input                          jtag_mode_in,
input                          jtag_rstb,
input                          jtag_rstb_en,
input                          jtag_weakpdn,
input                          jtag_weakpu,
input                          jtag_tx_scanen_in,
input                          scan_in,
//Redundancy control signals for IO buffers
`include "redundancy_ctrl.vh"

input [27*TOTAL_CHNL_NUM-1:0]  sl_external_cntl_26_0,  //user defined bits 26:0 for slave shift register
input [3*TOTAL_CHNL_NUM-1:0]   sl_external_cntl_30_28, //user defined bits 30:28 for slave shift register
input [26*TOTAL_CHNL_NUM-1:0]  sl_external_cntl_57_32, //user defined bits 57:32 for slave shift register

input [5*TOTAL_CHNL_NUM-1:0]   ms_external_cntl_4_0,   //user defined bits 4:0 for master shift register
input [58*TOTAL_CHNL_NUM-1:0]  ms_external_cntl_65_8,  //user defined bits 65:8 for master shift register

input          vccl_aib,
input          vssl_aib );

wire por_ms, osc_clk;
wire [TOTAL_CHNL_NUM-1:0][DATAWIDTH*2-1:0] data_in_ch, data_out_ch;
wire [TOTAL_CHNL_NUM-1:0][DATAWIDTH-1:0] data_in0_ch, data_in1_ch;
wire [TOTAL_CHNL_NUM-1:0][DATAWIDTH-1:0] data_out0_ch, data_out1_ch;
wire [DATAWIDTH-1:0] data_in0, data_in1;
assign m_power_on_reset = por_ms;
assign data_in_ch = data_in;

   genvar i, j;
   generate
     for (j=0; j<TOTAL_CHNL_NUM; j=j+1) begin
        for (i=1; i<(DATAWIDTH+1); i=i+1) begin:data_in_gen
           assign data_in0_ch[j][i-1] = data_in_ch[j][2*i-2];
           assign data_in1_ch[j][i-1] = data_in_ch[j][2*i-1];
         end
     end
   endgenerate

   generate
     for (j=0; j<TOTAL_CHNL_NUM; j=j+1) begin
        for (i=1; i<(DATAWIDTH+1); i=i+1) begin:data_out_gen
           assign data_out_ch[j][2*i-2] = data_out0_ch[j][i-1];
           assign data_out_ch[j][2*i-1] = data_out1_ch[j][i-1];
        end
        assign data_out[(j+1)*2*DATAWIDTH-1: j*2*DATAWIDTH] = data_out_ch[j];
     end
   endgenerate

wire LOW = 1'b0;
wire m0_ch0_aib_45_nc;
wire m0_ch0_aib_58_nc;
wire m0_ch0_aib_61_nc;
wire m0_ch0_aib_63_nc;
wire m0_ch0_aib_64_nc;
wire m0_ch0_aib_67_nc;
wire m0_ch0_aib_72_nc;
wire m0_ch0_aib_73_nc;
wire m0_ch0_aib_74_nc;
wire m0_ch0_aib_78_nc;
wire m0_ch0_aib_79_nc;
wire m0_ch0_aib_80_nc;
wire m0_ch0_aib_81_nc;
wire m0_ch0_aib_88_nc;
wire m0_ch0_aib_89_nc;
wire m0_ch1_aib_45_nc;
wire m0_ch1_aib_58_nc;
wire m0_ch1_aib_61_nc;
wire m0_ch1_aib_63_nc;
wire m0_ch1_aib_64_nc;
wire m0_ch1_aib_67_nc;
wire m0_ch1_aib_72_nc;
wire m0_ch1_aib_73_nc;
wire m0_ch1_aib_74_nc;
wire m0_ch1_aib_78_nc;
wire m0_ch1_aib_79_nc;
wire m0_ch1_aib_80_nc;
wire m0_ch1_aib_81_nc;
wire m0_ch1_aib_88_nc;
wire m0_ch1_aib_89_nc;
wire m0_ch2_aib_45_nc;
wire m0_ch2_aib_58_nc;
wire m0_ch2_aib_61_nc;
wire m0_ch2_aib_63_nc;
wire m0_ch2_aib_64_nc;
wire m0_ch2_aib_67_nc;
wire m0_ch2_aib_72_nc;
wire m0_ch2_aib_73_nc;
wire m0_ch2_aib_74_nc;
wire m0_ch2_aib_78_nc;
wire m0_ch2_aib_79_nc;
wire m0_ch2_aib_80_nc;
wire m0_ch2_aib_81_nc;
wire m0_ch2_aib_88_nc;
wire m0_ch2_aib_89_nc;
wire m0_ch3_aib_45_nc;
wire m0_ch3_aib_58_nc;
wire m0_ch3_aib_61_nc;
wire m0_ch3_aib_63_nc;
wire m0_ch3_aib_64_nc;
wire m0_ch3_aib_67_nc;
wire m0_ch3_aib_72_nc;
wire m0_ch3_aib_73_nc;
wire m0_ch3_aib_74_nc;
wire m0_ch3_aib_78_nc;
wire m0_ch3_aib_79_nc;
wire m0_ch3_aib_80_nc;
wire m0_ch3_aib_81_nc;
wire m0_ch3_aib_88_nc;
wire m0_ch3_aib_89_nc;
wire m0_ch4_aib_45_nc;
wire m0_ch4_aib_58_nc;
wire m0_ch4_aib_61_nc;
wire m0_ch4_aib_63_nc;
wire m0_ch4_aib_64_nc;
wire m0_ch4_aib_67_nc;
wire m0_ch4_aib_72_nc;
wire m0_ch4_aib_73_nc;
wire m0_ch4_aib_74_nc;
wire m0_ch4_aib_78_nc;
wire m0_ch4_aib_79_nc;
wire m0_ch4_aib_80_nc;
wire m0_ch4_aib_81_nc;
wire m0_ch4_aib_88_nc;
wire m0_ch4_aib_89_nc;
wire m0_ch5_aib_45_nc;
wire m0_ch5_aib_58_nc;
wire m0_ch5_aib_61_nc;
wire m0_ch5_aib_63_nc;
wire m0_ch5_aib_64_nc;
wire m0_ch5_aib_67_nc;
wire m0_ch5_aib_72_nc;
wire m0_ch5_aib_73_nc;
wire m0_ch5_aib_74_nc;
wire m0_ch5_aib_78_nc;
wire m0_ch5_aib_79_nc;
wire m0_ch5_aib_80_nc;
wire m0_ch5_aib_81_nc;
wire m0_ch5_aib_88_nc;
wire m0_ch5_aib_89_nc;
wire m1_ch0_aib_45_nc;
wire m1_ch0_aib_58_nc;
wire m1_ch0_aib_61_nc;
wire m1_ch0_aib_63_nc;
wire m1_ch0_aib_64_nc;
wire m1_ch0_aib_67_nc;
wire m1_ch0_aib_72_nc;
wire m1_ch0_aib_73_nc;
wire m1_ch0_aib_74_nc;
wire m1_ch0_aib_78_nc;
wire m1_ch0_aib_79_nc;
wire m1_ch0_aib_80_nc;
wire m1_ch0_aib_81_nc;
wire m1_ch0_aib_88_nc;
wire m1_ch0_aib_89_nc;
wire m1_ch1_aib_45_nc;
wire m1_ch1_aib_58_nc;
wire m1_ch1_aib_61_nc;
wire m1_ch1_aib_63_nc;
wire m1_ch1_aib_64_nc;
wire m1_ch1_aib_67_nc;
wire m1_ch1_aib_72_nc;
wire m1_ch1_aib_73_nc;
wire m1_ch1_aib_74_nc;
wire m1_ch1_aib_78_nc;
wire m1_ch1_aib_79_nc;
wire m1_ch1_aib_80_nc;
wire m1_ch1_aib_81_nc;
wire m1_ch1_aib_88_nc;
wire m1_ch1_aib_89_nc;
wire m1_ch2_aib_45_nc;
wire m1_ch2_aib_58_nc;
wire m1_ch2_aib_61_nc;
wire m1_ch2_aib_63_nc;
wire m1_ch2_aib_64_nc;
wire m1_ch2_aib_67_nc;
wire m1_ch2_aib_72_nc;
wire m1_ch2_aib_73_nc;
wire m1_ch2_aib_74_nc;
wire m1_ch2_aib_78_nc;
wire m1_ch2_aib_79_nc;
wire m1_ch2_aib_80_nc;
wire m1_ch2_aib_81_nc;
wire m1_ch2_aib_88_nc;
wire m1_ch2_aib_89_nc;
wire m1_ch3_aib_45_nc;
wire m1_ch3_aib_58_nc;
wire m1_ch3_aib_61_nc;
wire m1_ch3_aib_63_nc;
wire m1_ch3_aib_64_nc;
wire m1_ch3_aib_67_nc;
wire m1_ch3_aib_72_nc;
wire m1_ch3_aib_73_nc;
wire m1_ch3_aib_74_nc;
wire m1_ch3_aib_78_nc;
wire m1_ch3_aib_79_nc;
wire m1_ch3_aib_80_nc;
wire m1_ch3_aib_81_nc;
wire m1_ch3_aib_88_nc;
wire m1_ch3_aib_89_nc;
wire m1_ch4_aib_45_nc;
wire m1_ch4_aib_58_nc;
wire m1_ch4_aib_61_nc;
wire m1_ch4_aib_63_nc;
wire m1_ch4_aib_64_nc;
wire m1_ch4_aib_67_nc;
wire m1_ch4_aib_72_nc;
wire m1_ch4_aib_73_nc;
wire m1_ch4_aib_74_nc;
wire m1_ch4_aib_78_nc;
wire m1_ch4_aib_79_nc;
wire m1_ch4_aib_80_nc;
wire m1_ch4_aib_81_nc;
wire m1_ch4_aib_88_nc;
wire m1_ch4_aib_89_nc;
wire m1_ch5_aib_45_nc;
wire m1_ch5_aib_58_nc;
wire m1_ch5_aib_61_nc;
wire m1_ch5_aib_63_nc;
wire m1_ch5_aib_64_nc;
wire m1_ch5_aib_67_nc;
wire m1_ch5_aib_72_nc;
wire m1_ch5_aib_73_nc;
wire m1_ch5_aib_74_nc;
wire m1_ch5_aib_78_nc;
wire m1_ch5_aib_79_nc;
wire m1_ch5_aib_80_nc;
wire m1_ch5_aib_81_nc;
wire m1_ch5_aib_88_nc;
wire m1_ch5_aib_89_nc;
wire m2_ch0_aib_45_nc;
wire m2_ch0_aib_58_nc;
wire m2_ch0_aib_61_nc;
wire m2_ch0_aib_63_nc;
wire m2_ch0_aib_64_nc;
wire m2_ch0_aib_67_nc;
wire m2_ch0_aib_72_nc;
wire m2_ch0_aib_73_nc;
wire m2_ch0_aib_74_nc;
wire m2_ch0_aib_78_nc;
wire m2_ch0_aib_79_nc;
wire m2_ch0_aib_80_nc;
wire m2_ch0_aib_81_nc;
wire m2_ch0_aib_88_nc;
wire m2_ch0_aib_89_nc;
wire m2_ch1_aib_45_nc;
wire m2_ch1_aib_58_nc;
wire m2_ch1_aib_61_nc;
wire m2_ch1_aib_63_nc;
wire m2_ch1_aib_64_nc;
wire m2_ch1_aib_67_nc;
wire m2_ch1_aib_72_nc;
wire m2_ch1_aib_73_nc;
wire m2_ch1_aib_74_nc;
wire m2_ch1_aib_78_nc;
wire m2_ch1_aib_79_nc;
wire m2_ch1_aib_80_nc;
wire m2_ch1_aib_81_nc;
wire m2_ch1_aib_88_nc;
wire m2_ch1_aib_89_nc;
wire m2_ch2_aib_45_nc;
wire m2_ch2_aib_58_nc;
wire m2_ch2_aib_61_nc;
wire m2_ch2_aib_63_nc;
wire m2_ch2_aib_64_nc;
wire m2_ch2_aib_67_nc;
wire m2_ch2_aib_72_nc;
wire m2_ch2_aib_73_nc;
wire m2_ch2_aib_74_nc;
wire m2_ch2_aib_78_nc;
wire m2_ch2_aib_79_nc;
wire m2_ch2_aib_80_nc;
wire m2_ch2_aib_81_nc;
wire m2_ch2_aib_88_nc;
wire m2_ch2_aib_89_nc;
wire m2_ch3_aib_45_nc;
wire m2_ch3_aib_58_nc;
wire m2_ch3_aib_61_nc;
wire m2_ch3_aib_63_nc;
wire m2_ch3_aib_64_nc;
wire m2_ch3_aib_67_nc;
wire m2_ch3_aib_72_nc;
wire m2_ch3_aib_73_nc;
wire m2_ch3_aib_74_nc;
wire m2_ch3_aib_78_nc;
wire m2_ch3_aib_79_nc;
wire m2_ch3_aib_80_nc;
wire m2_ch3_aib_81_nc;
wire m2_ch3_aib_88_nc;
wire m2_ch3_aib_89_nc;
alias m0_ch0_aib_45_nc = m0_ch0_aib[45];
alias m0_ch0_aib_58_nc = m0_ch0_aib[58];
alias m0_ch0_aib_61_nc = m0_ch0_aib[61];
alias m0_ch0_aib_63_nc = m0_ch0_aib[63];
alias m0_ch0_aib_64_nc = m0_ch0_aib[64];
alias m0_ch0_aib_67_nc = m0_ch0_aib[67];
alias m0_ch0_aib_72_nc = m0_ch0_aib[72];
alias m0_ch0_aib_73_nc = m0_ch0_aib[73];
alias m0_ch0_aib_74_nc = m0_ch0_aib[74];
alias m0_ch0_aib_78_nc = m0_ch0_aib[78];
alias m0_ch0_aib_79_nc = m0_ch0_aib[79];
alias m0_ch0_aib_80_nc = m0_ch0_aib[80];
alias m0_ch0_aib_81_nc = m0_ch0_aib[81];
alias m0_ch0_aib_88_nc = m0_ch0_aib[88];
alias m0_ch0_aib_89_nc = m0_ch0_aib[89];
alias m0_ch1_aib_45_nc = m0_ch1_aib[45];
alias m0_ch1_aib_58_nc = m0_ch1_aib[58];
alias m0_ch1_aib_61_nc = m0_ch1_aib[61];
alias m0_ch1_aib_63_nc = m0_ch1_aib[63];
alias m0_ch1_aib_64_nc = m0_ch1_aib[64];
alias m0_ch1_aib_67_nc = m0_ch1_aib[67];
alias m0_ch1_aib_72_nc = m0_ch1_aib[72];
alias m0_ch1_aib_73_nc = m0_ch1_aib[73];
alias m0_ch1_aib_74_nc = m0_ch1_aib[74];
alias m0_ch1_aib_78_nc = m0_ch1_aib[78];
alias m0_ch1_aib_79_nc = m0_ch1_aib[79];
alias m0_ch1_aib_80_nc = m0_ch1_aib[80];
alias m0_ch1_aib_81_nc = m0_ch1_aib[81];
alias m0_ch1_aib_88_nc = m0_ch1_aib[88];
alias m0_ch1_aib_89_nc = m0_ch1_aib[89];
alias m0_ch2_aib_45_nc = m0_ch2_aib[45];
alias m0_ch2_aib_58_nc = m0_ch2_aib[58];
alias m0_ch2_aib_61_nc = m0_ch2_aib[61];
alias m0_ch2_aib_63_nc = m0_ch2_aib[63];
alias m0_ch2_aib_64_nc = m0_ch2_aib[64];
alias m0_ch2_aib_67_nc = m0_ch2_aib[67];
alias m0_ch2_aib_72_nc = m0_ch2_aib[72];
alias m0_ch2_aib_73_nc = m0_ch2_aib[73];
alias m0_ch2_aib_74_nc = m0_ch2_aib[74];
alias m0_ch2_aib_78_nc = m0_ch2_aib[78];
alias m0_ch2_aib_79_nc = m0_ch2_aib[79];
alias m0_ch2_aib_80_nc = m0_ch2_aib[80];
alias m0_ch2_aib_81_nc = m0_ch2_aib[81];
alias m0_ch2_aib_88_nc = m0_ch2_aib[88];
alias m0_ch2_aib_89_nc = m0_ch2_aib[89];
alias m0_ch3_aib_45_nc = m0_ch3_aib[45];
alias m0_ch3_aib_58_nc = m0_ch3_aib[58];
alias m0_ch3_aib_61_nc = m0_ch3_aib[61];
alias m0_ch3_aib_63_nc = m0_ch3_aib[63];
alias m0_ch3_aib_64_nc = m0_ch3_aib[64];
alias m0_ch3_aib_67_nc = m0_ch3_aib[67];
alias m0_ch3_aib_72_nc = m0_ch3_aib[72];
alias m0_ch3_aib_73_nc = m0_ch3_aib[73];
alias m0_ch3_aib_74_nc = m0_ch3_aib[74];
alias m0_ch3_aib_78_nc = m0_ch3_aib[78];
alias m0_ch3_aib_79_nc = m0_ch3_aib[79];
alias m0_ch3_aib_80_nc = m0_ch3_aib[80];
alias m0_ch3_aib_81_nc = m0_ch3_aib[81];
alias m0_ch3_aib_88_nc = m0_ch3_aib[88];
alias m0_ch3_aib_89_nc = m0_ch3_aib[89];
alias m0_ch4_aib_45_nc = m0_ch4_aib[45];
alias m0_ch4_aib_58_nc = m0_ch4_aib[58];
alias m0_ch4_aib_61_nc = m0_ch4_aib[61];
alias m0_ch4_aib_63_nc = m0_ch4_aib[63];
alias m0_ch4_aib_64_nc = m0_ch4_aib[64];
alias m0_ch4_aib_67_nc = m0_ch4_aib[67];
alias m0_ch4_aib_72_nc = m0_ch4_aib[72];
alias m0_ch4_aib_73_nc = m0_ch4_aib[73];
alias m0_ch4_aib_74_nc = m0_ch4_aib[74];
alias m0_ch4_aib_78_nc = m0_ch4_aib[78];
alias m0_ch4_aib_79_nc = m0_ch4_aib[79];
alias m0_ch4_aib_80_nc = m0_ch4_aib[80];
alias m0_ch4_aib_81_nc = m0_ch4_aib[81];
alias m0_ch4_aib_88_nc = m0_ch4_aib[88];
alias m0_ch4_aib_89_nc = m0_ch4_aib[89];
alias m0_ch5_aib_45_nc = m0_ch5_aib[45];
alias m0_ch5_aib_58_nc = m0_ch5_aib[58];
alias m0_ch5_aib_61_nc = m0_ch5_aib[61];
alias m0_ch5_aib_63_nc = m0_ch5_aib[63];
alias m0_ch5_aib_64_nc = m0_ch5_aib[64];
alias m0_ch5_aib_67_nc = m0_ch5_aib[67];
alias m0_ch5_aib_72_nc = m0_ch5_aib[72];
alias m0_ch5_aib_73_nc = m0_ch5_aib[73];
alias m0_ch5_aib_74_nc = m0_ch5_aib[74];
alias m0_ch5_aib_78_nc = m0_ch5_aib[78];
alias m0_ch5_aib_79_nc = m0_ch5_aib[79];
alias m0_ch5_aib_80_nc = m0_ch5_aib[80];
alias m0_ch5_aib_81_nc = m0_ch5_aib[81];
alias m0_ch5_aib_88_nc = m0_ch5_aib[88];
alias m0_ch5_aib_89_nc = m0_ch5_aib[89];
alias m1_ch0_aib_45_nc = m1_ch0_aib[45];
alias m1_ch0_aib_58_nc = m1_ch0_aib[58];
alias m1_ch0_aib_61_nc = m1_ch0_aib[61];
alias m1_ch0_aib_63_nc = m1_ch0_aib[63];
alias m1_ch0_aib_64_nc = m1_ch0_aib[64];
alias m1_ch0_aib_67_nc = m1_ch0_aib[67];
alias m1_ch0_aib_72_nc = m1_ch0_aib[72];
alias m1_ch0_aib_73_nc = m1_ch0_aib[73];
alias m1_ch0_aib_74_nc = m1_ch0_aib[74];
alias m1_ch0_aib_78_nc = m1_ch0_aib[78];
alias m1_ch0_aib_79_nc = m1_ch0_aib[79];
alias m1_ch0_aib_80_nc = m1_ch0_aib[80];
alias m1_ch0_aib_81_nc = m1_ch0_aib[81];
alias m1_ch0_aib_88_nc = m1_ch0_aib[88];
alias m1_ch0_aib_89_nc = m1_ch0_aib[89];
alias m1_ch1_aib_45_nc = m1_ch1_aib[45];
alias m1_ch1_aib_58_nc = m1_ch1_aib[58];
alias m1_ch1_aib_61_nc = m1_ch1_aib[61];
alias m1_ch1_aib_63_nc = m1_ch1_aib[63];
alias m1_ch1_aib_64_nc = m1_ch1_aib[64];
alias m1_ch1_aib_67_nc = m1_ch1_aib[67];
alias m1_ch1_aib_72_nc = m1_ch1_aib[72];
alias m1_ch1_aib_73_nc = m1_ch1_aib[73];
alias m1_ch1_aib_74_nc = m1_ch1_aib[74];
alias m1_ch1_aib_78_nc = m1_ch1_aib[78];
alias m1_ch1_aib_79_nc = m1_ch1_aib[79];
alias m1_ch1_aib_80_nc = m1_ch1_aib[80];
alias m1_ch1_aib_81_nc = m1_ch1_aib[81];
alias m1_ch1_aib_88_nc = m1_ch1_aib[88];
alias m1_ch1_aib_89_nc = m1_ch1_aib[89];
alias m1_ch2_aib_45_nc = m1_ch2_aib[45];
alias m1_ch2_aib_58_nc = m1_ch2_aib[58];
alias m1_ch2_aib_61_nc = m1_ch2_aib[61];
alias m1_ch2_aib_63_nc = m1_ch2_aib[63];
alias m1_ch2_aib_64_nc = m1_ch2_aib[64];
alias m1_ch2_aib_67_nc = m1_ch2_aib[67];
alias m1_ch2_aib_72_nc = m1_ch2_aib[72];
alias m1_ch2_aib_73_nc = m1_ch2_aib[73];
alias m1_ch2_aib_74_nc = m1_ch2_aib[74];
alias m1_ch2_aib_78_nc = m1_ch2_aib[78];
alias m1_ch2_aib_79_nc = m1_ch2_aib[79];
alias m1_ch2_aib_80_nc = m1_ch2_aib[80];
alias m1_ch2_aib_81_nc = m1_ch2_aib[81];
alias m1_ch2_aib_88_nc = m1_ch2_aib[88];
alias m1_ch2_aib_89_nc = m1_ch2_aib[89];
alias m1_ch3_aib_45_nc = m1_ch3_aib[45];
alias m1_ch3_aib_58_nc = m1_ch3_aib[58];
alias m1_ch3_aib_61_nc = m1_ch3_aib[61];
alias m1_ch3_aib_63_nc = m1_ch3_aib[63];
alias m1_ch3_aib_64_nc = m1_ch3_aib[64];
alias m1_ch3_aib_67_nc = m1_ch3_aib[67];
alias m1_ch3_aib_72_nc = m1_ch3_aib[72];
alias m1_ch3_aib_73_nc = m1_ch3_aib[73];
alias m1_ch3_aib_74_nc = m1_ch3_aib[74];
alias m1_ch3_aib_78_nc = m1_ch3_aib[78];
alias m1_ch3_aib_79_nc = m1_ch3_aib[79];
alias m1_ch3_aib_80_nc = m1_ch3_aib[80];
alias m1_ch3_aib_81_nc = m1_ch3_aib[81];
alias m1_ch3_aib_88_nc = m1_ch3_aib[88];
alias m1_ch3_aib_89_nc = m1_ch3_aib[89];
alias m1_ch4_aib_45_nc = m1_ch4_aib[45];
alias m1_ch4_aib_58_nc = m1_ch4_aib[58];
alias m1_ch4_aib_61_nc = m1_ch4_aib[61];
alias m1_ch4_aib_63_nc = m1_ch4_aib[63];
alias m1_ch4_aib_64_nc = m1_ch4_aib[64];
alias m1_ch4_aib_67_nc = m1_ch4_aib[67];
alias m1_ch4_aib_72_nc = m1_ch4_aib[72];
alias m1_ch4_aib_73_nc = m1_ch4_aib[73];
alias m1_ch4_aib_74_nc = m1_ch4_aib[74];
alias m1_ch4_aib_78_nc = m1_ch4_aib[78];
alias m1_ch4_aib_79_nc = m1_ch4_aib[79];
alias m1_ch4_aib_80_nc = m1_ch4_aib[80];
alias m1_ch4_aib_81_nc = m1_ch4_aib[81];
alias m1_ch4_aib_88_nc = m1_ch4_aib[88];
alias m1_ch4_aib_89_nc = m1_ch4_aib[89];
alias m1_ch5_aib_45_nc = m1_ch5_aib[45];
alias m1_ch5_aib_58_nc = m1_ch5_aib[58];
alias m1_ch5_aib_61_nc = m1_ch5_aib[61];
alias m1_ch5_aib_63_nc = m1_ch5_aib[63];
alias m1_ch5_aib_64_nc = m1_ch5_aib[64];
alias m1_ch5_aib_67_nc = m1_ch5_aib[67];
alias m1_ch5_aib_72_nc = m1_ch5_aib[72];
alias m1_ch5_aib_73_nc = m1_ch5_aib[73];
alias m1_ch5_aib_74_nc = m1_ch5_aib[74];
alias m1_ch5_aib_78_nc = m1_ch5_aib[78];
alias m1_ch5_aib_79_nc = m1_ch5_aib[79];
alias m1_ch5_aib_80_nc = m1_ch5_aib[80];
alias m1_ch5_aib_81_nc = m1_ch5_aib[81];
alias m1_ch5_aib_88_nc = m1_ch5_aib[88];
alias m1_ch5_aib_89_nc = m1_ch5_aib[89];
alias m2_ch0_aib_45_nc = m2_ch0_aib[45];
alias m2_ch0_aib_58_nc = m2_ch0_aib[58];
alias m2_ch0_aib_61_nc = m2_ch0_aib[61];
alias m2_ch0_aib_63_nc = m2_ch0_aib[63];
alias m2_ch0_aib_64_nc = m2_ch0_aib[64];
alias m2_ch0_aib_67_nc = m2_ch0_aib[67];
alias m2_ch0_aib_72_nc = m2_ch0_aib[72];
alias m2_ch0_aib_73_nc = m2_ch0_aib[73];
alias m2_ch0_aib_74_nc = m2_ch0_aib[74];
alias m2_ch0_aib_78_nc = m2_ch0_aib[78];
alias m2_ch0_aib_79_nc = m2_ch0_aib[79];
alias m2_ch0_aib_80_nc = m2_ch0_aib[80];
alias m2_ch0_aib_81_nc = m2_ch0_aib[81];
alias m2_ch0_aib_88_nc = m2_ch0_aib[88];
alias m2_ch0_aib_89_nc = m2_ch0_aib[89];
alias m2_ch1_aib_45_nc = m2_ch1_aib[45];
alias m2_ch1_aib_58_nc = m2_ch1_aib[58];
alias m2_ch1_aib_61_nc = m2_ch1_aib[61];
alias m2_ch1_aib_63_nc = m2_ch1_aib[63];
alias m2_ch1_aib_64_nc = m2_ch1_aib[64];
alias m2_ch1_aib_67_nc = m2_ch1_aib[67];
alias m2_ch1_aib_72_nc = m2_ch1_aib[72];
alias m2_ch1_aib_73_nc = m2_ch1_aib[73];
alias m2_ch1_aib_74_nc = m2_ch1_aib[74];
alias m2_ch1_aib_78_nc = m2_ch1_aib[78];
alias m2_ch1_aib_79_nc = m2_ch1_aib[79];
alias m2_ch1_aib_80_nc = m2_ch1_aib[80];
alias m2_ch1_aib_81_nc = m2_ch1_aib[81];
alias m2_ch1_aib_88_nc = m2_ch1_aib[88];
alias m2_ch1_aib_89_nc = m2_ch1_aib[89];
alias m2_ch2_aib_45_nc = m2_ch2_aib[45];
alias m2_ch2_aib_58_nc = m2_ch2_aib[58];
alias m2_ch2_aib_61_nc = m2_ch2_aib[61];
alias m2_ch2_aib_63_nc = m2_ch2_aib[63];
alias m2_ch2_aib_64_nc = m2_ch2_aib[64];
alias m2_ch2_aib_67_nc = m2_ch2_aib[67];
alias m2_ch2_aib_72_nc = m2_ch2_aib[72];
alias m2_ch2_aib_73_nc = m2_ch2_aib[73];
alias m2_ch2_aib_74_nc = m2_ch2_aib[74];
alias m2_ch2_aib_78_nc = m2_ch2_aib[78];
alias m2_ch2_aib_79_nc = m2_ch2_aib[79];
alias m2_ch2_aib_80_nc = m2_ch2_aib[80];
alias m2_ch2_aib_81_nc = m2_ch2_aib[81];
alias m2_ch2_aib_88_nc = m2_ch2_aib[88];
alias m2_ch2_aib_89_nc = m2_ch2_aib[89];
alias m2_ch3_aib_45_nc = m2_ch3_aib[45];
alias m2_ch3_aib_58_nc = m2_ch3_aib[58];
alias m2_ch3_aib_61_nc = m2_ch3_aib[61];
alias m2_ch3_aib_63_nc = m2_ch3_aib[63];
alias m2_ch3_aib_64_nc = m2_ch3_aib[64];
alias m2_ch3_aib_67_nc = m2_ch3_aib[67];
alias m2_ch3_aib_72_nc = m2_ch3_aib[72];
alias m2_ch3_aib_73_nc = m2_ch3_aib[73];
alias m2_ch3_aib_74_nc = m2_ch3_aib[74];
alias m2_ch3_aib_78_nc = m2_ch3_aib[78];
alias m2_ch3_aib_79_nc = m2_ch3_aib[79];
alias m2_ch3_aib_80_nc = m2_ch3_aib[80];
alias m2_ch3_aib_81_nc = m2_ch3_aib[81];
alias m2_ch3_aib_88_nc = m2_ch3_aib[88];
alias m2_ch3_aib_89_nc = m2_ch3_aib[89];
alias m0_ch0_aib[46] = LOW;
alias m0_ch0_aib[47] = LOW;
alias m0_ch0_aib[50] = LOW;
alias m0_ch0_aib[51] = LOW;
alias m0_ch0_aib[52] = LOW;
alias m0_ch0_aib[60] = LOW;
alias m0_ch0_aib[62] = LOW;
alias m0_ch0_aib[66] = LOW;
alias m0_ch0_aib[68] = LOW;
alias m0_ch0_aib[69] = LOW;
alias m0_ch0_aib[70] = LOW;
alias m0_ch0_aib[71] = LOW;
alias m0_ch0_aib[75] = LOW;
alias m0_ch0_aib[76] = LOW;
alias m0_ch0_aib[77] = LOW;
alias m0_ch0_aib[90] = LOW;
alias m0_ch0_aib[91] = LOW;
alias m0_ch1_aib[46] = LOW;
alias m0_ch1_aib[47] = LOW;
alias m0_ch1_aib[50] = LOW;
alias m0_ch1_aib[51] = LOW;
alias m0_ch1_aib[52] = LOW;
alias m0_ch1_aib[60] = LOW;
alias m0_ch1_aib[62] = LOW;
alias m0_ch1_aib[66] = LOW;
alias m0_ch1_aib[68] = LOW;
alias m0_ch1_aib[69] = LOW;
alias m0_ch1_aib[70] = LOW;
alias m0_ch1_aib[71] = LOW;
alias m0_ch1_aib[75] = LOW;
alias m0_ch1_aib[76] = LOW;
alias m0_ch1_aib[77] = LOW;
alias m0_ch1_aib[90] = LOW;
alias m0_ch1_aib[91] = LOW;
alias m0_ch2_aib[46] = LOW;
alias m0_ch2_aib[47] = LOW;
alias m0_ch2_aib[50] = LOW;
alias m0_ch2_aib[51] = LOW;
alias m0_ch2_aib[52] = LOW;
alias m0_ch2_aib[60] = LOW;
alias m0_ch2_aib[62] = LOW;
alias m0_ch2_aib[66] = LOW;
alias m0_ch2_aib[68] = LOW;
alias m0_ch2_aib[69] = LOW;
alias m0_ch2_aib[70] = LOW;
alias m0_ch2_aib[71] = LOW;
alias m0_ch2_aib[75] = LOW;
alias m0_ch2_aib[76] = LOW;
alias m0_ch2_aib[77] = LOW;
alias m0_ch2_aib[90] = LOW;
alias m0_ch2_aib[91] = LOW;
alias m0_ch3_aib[46] = LOW;
alias m0_ch3_aib[47] = LOW;
alias m0_ch3_aib[50] = LOW;
alias m0_ch3_aib[51] = LOW;
alias m0_ch3_aib[52] = LOW;
alias m0_ch3_aib[60] = LOW;
alias m0_ch3_aib[62] = LOW;
alias m0_ch3_aib[66] = LOW;
alias m0_ch3_aib[68] = LOW;
alias m0_ch3_aib[69] = LOW;
alias m0_ch3_aib[70] = LOW;
alias m0_ch3_aib[71] = LOW;
alias m0_ch3_aib[75] = LOW;
alias m0_ch3_aib[76] = LOW;
alias m0_ch3_aib[77] = LOW;
alias m0_ch3_aib[90] = LOW;
alias m0_ch3_aib[91] = LOW;
alias m0_ch4_aib[46] = LOW;
alias m0_ch4_aib[47] = LOW;
alias m0_ch4_aib[50] = LOW;
alias m0_ch4_aib[51] = LOW;
alias m0_ch4_aib[52] = LOW;
alias m0_ch4_aib[60] = LOW;
alias m0_ch4_aib[62] = LOW;
alias m0_ch4_aib[66] = LOW;
alias m0_ch4_aib[68] = LOW;
alias m0_ch4_aib[69] = LOW;
alias m0_ch4_aib[70] = LOW;
alias m0_ch4_aib[71] = LOW;
alias m0_ch4_aib[75] = LOW;
alias m0_ch4_aib[76] = LOW;
alias m0_ch4_aib[77] = LOW;
alias m0_ch4_aib[90] = LOW;
alias m0_ch4_aib[91] = LOW;
alias m0_ch5_aib[46] = LOW;
alias m0_ch5_aib[47] = LOW;
alias m0_ch5_aib[50] = LOW;
alias m0_ch5_aib[51] = LOW;
alias m0_ch5_aib[52] = LOW;
alias m0_ch5_aib[60] = LOW;
alias m0_ch5_aib[62] = LOW;
alias m0_ch5_aib[66] = LOW;
alias m0_ch5_aib[68] = LOW;
alias m0_ch5_aib[69] = LOW;
alias m0_ch5_aib[70] = LOW;
alias m0_ch5_aib[71] = LOW;
alias m0_ch5_aib[75] = LOW;
alias m0_ch5_aib[76] = LOW;
alias m0_ch5_aib[77] = LOW;
alias m0_ch5_aib[90] = LOW;
alias m0_ch5_aib[91] = LOW;
alias m1_ch0_aib[46] = LOW;
alias m1_ch0_aib[47] = LOW;
alias m1_ch0_aib[50] = LOW;
alias m1_ch0_aib[51] = LOW;
alias m1_ch0_aib[52] = LOW;
alias m1_ch0_aib[60] = LOW;
alias m1_ch0_aib[62] = LOW;
alias m1_ch0_aib[66] = LOW;
alias m1_ch0_aib[68] = LOW;
alias m1_ch0_aib[69] = LOW;
alias m1_ch0_aib[70] = LOW;
alias m1_ch0_aib[71] = LOW;
alias m1_ch0_aib[75] = LOW;
alias m1_ch0_aib[76] = LOW;
alias m1_ch0_aib[77] = LOW;
alias m1_ch0_aib[90] = LOW;
alias m1_ch0_aib[91] = LOW;
alias m1_ch1_aib[46] = LOW;
alias m1_ch1_aib[47] = LOW;
alias m1_ch1_aib[50] = LOW;
alias m1_ch1_aib[51] = LOW;
alias m1_ch1_aib[52] = LOW;
alias m1_ch1_aib[60] = LOW;
alias m1_ch1_aib[62] = LOW;
alias m1_ch1_aib[66] = LOW;
alias m1_ch1_aib[68] = LOW;
alias m1_ch1_aib[69] = LOW;
alias m1_ch1_aib[70] = LOW;
alias m1_ch1_aib[71] = LOW;
alias m1_ch1_aib[75] = LOW;
alias m1_ch1_aib[76] = LOW;
alias m1_ch1_aib[77] = LOW;
alias m1_ch1_aib[90] = LOW;
alias m1_ch1_aib[91] = LOW;
alias m1_ch2_aib[46] = LOW;
alias m1_ch2_aib[47] = LOW;
alias m1_ch2_aib[50] = LOW;
alias m1_ch2_aib[51] = LOW;
alias m1_ch2_aib[52] = LOW;
alias m1_ch2_aib[60] = LOW;
alias m1_ch2_aib[62] = LOW;
alias m1_ch2_aib[66] = LOW;
alias m1_ch2_aib[68] = LOW;
alias m1_ch2_aib[69] = LOW;
alias m1_ch2_aib[70] = LOW;
alias m1_ch2_aib[71] = LOW;
alias m1_ch2_aib[75] = LOW;
alias m1_ch2_aib[76] = LOW;
alias m1_ch2_aib[77] = LOW;
alias m1_ch2_aib[90] = LOW;
alias m1_ch2_aib[91] = LOW;
alias m1_ch3_aib[46] = LOW;
alias m1_ch3_aib[47] = LOW;
alias m1_ch3_aib[50] = LOW;
alias m1_ch3_aib[51] = LOW;
alias m1_ch3_aib[52] = LOW;
alias m1_ch3_aib[60] = LOW;
alias m1_ch3_aib[62] = LOW;
alias m1_ch3_aib[66] = LOW;
alias m1_ch3_aib[68] = LOW;
alias m1_ch3_aib[69] = LOW;
alias m1_ch3_aib[70] = LOW;
alias m1_ch3_aib[71] = LOW;
alias m1_ch3_aib[75] = LOW;
alias m1_ch3_aib[76] = LOW;
alias m1_ch3_aib[77] = LOW;
alias m1_ch3_aib[90] = LOW;
alias m1_ch3_aib[91] = LOW;
alias m1_ch4_aib[46] = LOW;
alias m1_ch4_aib[47] = LOW;
alias m1_ch4_aib[50] = LOW;
alias m1_ch4_aib[51] = LOW;
alias m1_ch4_aib[52] = LOW;
alias m1_ch4_aib[60] = LOW;
alias m1_ch4_aib[62] = LOW;
alias m1_ch4_aib[66] = LOW;
alias m1_ch4_aib[68] = LOW;
alias m1_ch4_aib[69] = LOW;
alias m1_ch4_aib[70] = LOW;
alias m1_ch4_aib[71] = LOW;
alias m1_ch4_aib[75] = LOW;
alias m1_ch4_aib[76] = LOW;
alias m1_ch4_aib[77] = LOW;
alias m1_ch4_aib[90] = LOW;
alias m1_ch4_aib[91] = LOW;
alias m1_ch5_aib[46] = LOW;
alias m1_ch5_aib[47] = LOW;
alias m1_ch5_aib[50] = LOW;
alias m1_ch5_aib[51] = LOW;
alias m1_ch5_aib[52] = LOW;
alias m1_ch5_aib[60] = LOW;
alias m1_ch5_aib[62] = LOW;
alias m1_ch5_aib[66] = LOW;
alias m1_ch5_aib[68] = LOW;
alias m1_ch5_aib[69] = LOW;
alias m1_ch5_aib[70] = LOW;
alias m1_ch5_aib[71] = LOW;
alias m1_ch5_aib[75] = LOW;
alias m1_ch5_aib[76] = LOW;
alias m1_ch5_aib[77] = LOW;
alias m1_ch5_aib[90] = LOW;
alias m1_ch5_aib[91] = LOW;
alias m2_ch0_aib[46] = LOW;
alias m2_ch0_aib[47] = LOW;
alias m2_ch0_aib[50] = LOW;
alias m2_ch0_aib[51] = LOW;
alias m2_ch0_aib[52] = LOW;
alias m2_ch0_aib[60] = LOW;
alias m2_ch0_aib[62] = LOW;
alias m2_ch0_aib[66] = LOW;
alias m2_ch0_aib[68] = LOW;
alias m2_ch0_aib[69] = LOW;
alias m2_ch0_aib[70] = LOW;
alias m2_ch0_aib[71] = LOW;
alias m2_ch0_aib[75] = LOW;
alias m2_ch0_aib[76] = LOW;
alias m2_ch0_aib[77] = LOW;
alias m2_ch0_aib[90] = LOW;
alias m2_ch0_aib[91] = LOW;
alias m2_ch1_aib[46] = LOW;
alias m2_ch1_aib[47] = LOW;
alias m2_ch1_aib[50] = LOW;
alias m2_ch1_aib[51] = LOW;
alias m2_ch1_aib[52] = LOW;
alias m2_ch1_aib[60] = LOW;
alias m2_ch1_aib[62] = LOW;
alias m2_ch1_aib[66] = LOW;
alias m2_ch1_aib[68] = LOW;
alias m2_ch1_aib[69] = LOW;
alias m2_ch1_aib[70] = LOW;
alias m2_ch1_aib[71] = LOW;
alias m2_ch1_aib[75] = LOW;
alias m2_ch1_aib[76] = LOW;
alias m2_ch1_aib[77] = LOW;
alias m2_ch1_aib[90] = LOW;
alias m2_ch1_aib[91] = LOW;
alias m2_ch2_aib[46] = LOW;
alias m2_ch2_aib[47] = LOW;
alias m2_ch2_aib[50] = LOW;
alias m2_ch2_aib[51] = LOW;
alias m2_ch2_aib[52] = LOW;
alias m2_ch2_aib[60] = LOW;
alias m2_ch2_aib[62] = LOW;
alias m2_ch2_aib[66] = LOW;
alias m2_ch2_aib[68] = LOW;
alias m2_ch2_aib[69] = LOW;
alias m2_ch2_aib[70] = LOW;
alias m2_ch2_aib[71] = LOW;
alias m2_ch2_aib[75] = LOW;
alias m2_ch2_aib[76] = LOW;
alias m2_ch2_aib[77] = LOW;
alias m2_ch2_aib[90] = LOW;
alias m2_ch2_aib[91] = LOW;
alias m2_ch3_aib[46] = LOW;
alias m2_ch3_aib[47] = LOW;
alias m2_ch3_aib[50] = LOW;
alias m2_ch3_aib[51] = LOW;
alias m2_ch3_aib[52] = LOW;
alias m2_ch3_aib[60] = LOW;
alias m2_ch3_aib[62] = LOW;
alias m2_ch3_aib[66] = LOW;
alias m2_ch3_aib[68] = LOW;
alias m2_ch3_aib[69] = LOW;
alias m2_ch3_aib[70] = LOW;
alias m2_ch3_aib[71] = LOW;
alias m2_ch3_aib[75] = LOW;
alias m2_ch3_aib[76] = LOW;
alias m2_ch3_aib[77] = LOW;
alias m2_ch3_aib[90] = LOW;
alias m2_ch3_aib[91] = LOW;


aib_channel #(.DATAWIDTH(DATAWIDTH)) aib_channel0
 ( 
     .iopad_txdat(m0_ch0_aib[19:0]),
     .iopad_rxdat(m0_ch0_aib[39:20]),
     .iopad_txclkb(m0_ch0_aib[86]), 
     .iopad_txclk(m0_ch0_aib[87]),
     .iopad_tx_div2_clkb(m0_ch0_aib[55]),
     .iopad_tx_div2_clk(m0_ch0_aib[48]),
     .iopad_tx_div2_fck(m0_ch0_aib[53]),
     .iopad_tx_div2_fckb(m0_ch0_aib[54]),
     .iopad_txfck(m0_ch0_aib[41]), 
     .iopad_txfckb(m0_ch0_aib[40]),
     .iopad_stck(m0_ch0_aib[85]), 
     .iopad_stckb(m0_ch0_aib[84]),
     .iopad_stl(m0_ch0_aib[94]), 
     .iopad_std(m0_ch0_aib[95]),
     .iopad_rstno(m0_ch0_aib[49]), 
     .iopad_arstno(m0_ch0_aib[56]),
     .iopad_spareo(m0_ch0_aib[47]), 
     .iopad_sparee(m0_ch0_aib[46]),
     .iopad_rxclkb(m0_ch0_aib[59]), 
     .iopad_rxclk(m0_ch0_aib[57]),
     .iopad_rxfckb(m0_ch0_aib[42]), 
     .iopad_rxfck(m0_ch0_aib[43]),
     .iopad_srckb(m0_ch0_aib[82]), 
     .iopad_srck(m0_ch0_aib[83]),
     .iopad_srl(m0_ch0_aib[92]), 
     .iopad_srd(m0_ch0_aib[93]),
     .iopad_rstni(m0_ch0_aib[44]), 
     .iopad_arstni(m0_ch0_aib[65]),

     .tx_launch_clk(m_ns_fwd_clk[0]), //output data clock
     .tx_launch_div2_clk(m_ns_fwd_div2_clk[0]), //Newly added 11/09/20
     .ns_rvc_div2_clk_frmac(m_ns_rvc_div2_clk[0]), //Newly added 11/09/20
     .fs_rvc_clk_tomac(m_fs_rvc_clk[0]), 
     .fs_fwd_clk_tomac(m_fs_fwd_clk[0]), 
     .ns_rvc_clk_frmac(m_ns_rvc_clk[0]), 
     .iddren(iddren[0]),
     .idataselb(idataselb[0]), //output async data selection
     .itxen(itxen[0]), //data tx enable
     .irxen(irxen[3*1-1:3*0]),//data input enable
     .idat0(data_in0_ch[0]), //output data to pad
     .idat1(data_in1_ch[0]), //output data to pad
     .data_out0(data_out0_ch[0]), //input data from pad
     .data_out1(data_out1_ch[0]), //input data from pad

     .ms_config_done(ms_config_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[0]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[0]),
     .sl_config_done(sl_config_done),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[0]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[0]),
     .ms_tx_transfer_en(ms_tx_transfer_en[0]),
     .ms_rx_transfer_en(ms_rx_transfer_en[0]),
     .sl_tx_transfer_en(sl_tx_transfer_en[0]),
     .sl_rx_transfer_en(sl_rx_transfer_en[0]),
     .sr_ms_tomac(sr_ms_tomac[81*1-1:81*0]),
     .sr_sl_tomac(sr_sl_tomac[73*1-1:73*0]),

     .ms_adapter_rstn(ms_ns_adapter_rstn[0]),
     .sl_adapter_rstn(sl_ns_adapter_rstn[0]),
     .ms_rstn(ms_ns_mac_rdy[0]),
     .sl_rstn(sl_ns_mac_rdy[0]),
     .fs_mac_rdy_tomac(fs_mac_rdy[0]),
     .por_sl(m_power_on_reset_i),
     .ms_nsl(ms_nsl),
     .por_ms(por_ms),
     .osc_clk(osc_clk),

 `include "redundancy_inst.vh"
     .sl_external_cntl_26_0(sl_external_cntl_26_0[27*1-1:27*0]),
     .sl_external_cntl_30_28(sl_external_cntl_30_28[3*1-1:3*0]),
     .sl_external_cntl_57_32(sl_external_cntl_57_32[26*1-1:26*0]),

     .ms_external_cntl_4_0(ms_external_cntl_4_0[5*1-1:5*0]),
     .ms_external_cntl_65_8(ms_external_cntl_65_8[58*1-1:58*0]),

     .vccl_aib(vccl_aib),
     .vssl_aib(vssl_aib) );


aib_channel #(.DATAWIDTH(DATAWIDTH)) aib_channel1
 ( 
     .iopad_txdat(m0_ch1_aib[19:0]),
     .iopad_rxdat(m0_ch1_aib[39:20]),
     .iopad_txclkb(m0_ch1_aib[86]), 
     .iopad_txclk(m0_ch1_aib[87]),
     .iopad_tx_div2_clkb(m0_ch1_aib[55]),
     .iopad_tx_div2_clk(m0_ch1_aib[48]),
     .iopad_tx_div2_fck(m0_ch1_aib[53]), 
     .iopad_tx_div2_fckb(m0_ch1_aib[54]),
     .iopad_txfck(m0_ch1_aib[41]), 
     .iopad_txfckb(m0_ch1_aib[40]),
     .iopad_stck(m0_ch1_aib[85]), 
     .iopad_stckb(m0_ch1_aib[84]),
     .iopad_stl(m0_ch1_aib[94]), 
     .iopad_std(m0_ch1_aib[95]),
     .iopad_rstno(m0_ch1_aib[49]), 
     .iopad_arstno(m0_ch1_aib[56]),
     .iopad_spareo(m0_ch1_aib[47]), 
     .iopad_sparee(m0_ch1_aib[46]),
     .iopad_rxclkb(m0_ch1_aib[59]), 
     .iopad_rxclk(m0_ch1_aib[57]),
     .iopad_rxfckb(m0_ch1_aib[42]), 
     .iopad_rxfck(m0_ch1_aib[43]),
     .iopad_srckb(m0_ch1_aib[82]), 
     .iopad_srck(m0_ch1_aib[83]),
     .iopad_srl(m0_ch1_aib[92]), 
     .iopad_srd(m0_ch1_aib[93]),
     .iopad_rstni(m0_ch1_aib[44]), 
     .iopad_arstni(m0_ch1_aib[65]),

     .tx_launch_clk(m_ns_fwd_clk[1]), //output data clock
     .tx_launch_div2_clk(m_ns_fwd_div2_clk[1]), //Newly added 11/09/20
     .ns_rvc_div2_clk_frmac(m_ns_rvc_div2_clk[1]), //Newly added 11/09/20
     .fs_rvc_clk_tomac(m_fs_rvc_clk[1]), 
     .fs_fwd_clk_tomac(m_fs_fwd_clk[1]), 
     .ns_rvc_clk_frmac(m_ns_rvc_clk[1]), 
     .iddren(iddren[1]),
     .idataselb(idataselb[1]), //output async data selection
     .itxen(itxen[1]), //data tx enable
     .irxen(irxen[3*2-1:3*1]),//data input enable
     .idat0(data_in0_ch[1]), //output data to pad
     .idat1(data_in1_ch[1]), //output data to pad
     .data_out0(data_out0_ch[1]), //input data from pad
     .data_out1(data_out1_ch[1]), //input data from pad

     .ms_config_done(ms_config_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[1]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[1]),
     .sl_config_done(sl_config_done),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[1]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[1]),
     .ms_tx_transfer_en(ms_tx_transfer_en[1]),
     .ms_rx_transfer_en(ms_rx_transfer_en[1]),
     .sl_tx_transfer_en(sl_tx_transfer_en[1]),
     .sl_rx_transfer_en(sl_rx_transfer_en[1]),
     .sr_ms_tomac(sr_ms_tomac[81*2-1:81*1]),
     .sr_sl_tomac(sr_sl_tomac[73*2-1:73*1]),

     .ms_adapter_rstn(ms_ns_adapter_rstn[1]),
     .sl_adapter_rstn(sl_ns_adapter_rstn[1]),
     .ms_rstn(ms_ns_mac_rdy[1]),
     .sl_rstn(sl_ns_mac_rdy[1]),
     .fs_mac_rdy_tomac(fs_mac_rdy[1]),
     .por_sl(m_power_on_reset_i),
     .ms_nsl(ms_nsl),
     .por_ms(por_ms),
     .osc_clk(osc_clk),

 `include "redundancy_inst.vh"
     .sl_external_cntl_26_0(sl_external_cntl_26_0[27*2-1:27*1]),
     .sl_external_cntl_30_28(sl_external_cntl_30_28[3*2-1:3*1]),
     .sl_external_cntl_57_32(sl_external_cntl_57_32[26*2-1:26*1]),

     .ms_external_cntl_4_0(ms_external_cntl_4_0[5*2-1:5*1]),
     .ms_external_cntl_65_8(ms_external_cntl_65_8[58*2-1:58*1]),

     .vccl_aib(vccl_aib),
     .vssl_aib(vssl_aib) );


aib_channel #(.DATAWIDTH(DATAWIDTH)) aib_channel2
 ( 
     .iopad_txdat(m0_ch2_aib[19:0]),
     .iopad_rxdat(m0_ch2_aib[39:20]),
     .iopad_txclkb(m0_ch2_aib[86]), 
     .iopad_txclk(m0_ch2_aib[87]),
     .iopad_tx_div2_clkb(m0_ch2_aib[55]),
     .iopad_tx_div2_clk(m0_ch2_aib[48]),
     .iopad_tx_div2_fck(m0_ch2_aib[53]),
     .iopad_tx_div2_fckb(m0_ch2_aib[54]),

     .iopad_txfck(m0_ch2_aib[41]), 
     .iopad_txfckb(m0_ch2_aib[40]),
     .iopad_stck(m0_ch2_aib[85]), 
     .iopad_stckb(m0_ch2_aib[84]),
     .iopad_stl(m0_ch2_aib[94]), 
     .iopad_std(m0_ch2_aib[95]),
     .iopad_rstno(m0_ch2_aib[49]), 
     .iopad_arstno(m0_ch2_aib[56]),
     .iopad_spareo(m0_ch2_aib[47]), 
     .iopad_sparee(m0_ch2_aib[46]),
     .iopad_rxclkb(m0_ch2_aib[59]), 
     .iopad_rxclk(m0_ch2_aib[57]),
     .iopad_rxfckb(m0_ch2_aib[42]), 
     .iopad_rxfck(m0_ch2_aib[43]),
     .iopad_srckb(m0_ch2_aib[82]), 
     .iopad_srck(m0_ch2_aib[83]),
     .iopad_srl(m0_ch2_aib[92]), 
     .iopad_srd(m0_ch2_aib[93]),
     .iopad_rstni(m0_ch2_aib[44]), 
     .iopad_arstni(m0_ch2_aib[65]),

     .tx_launch_clk(m_ns_fwd_clk[2]), //output data clock
     .tx_launch_div2_clk(m_ns_fwd_div2_clk[2]), //Newly added 11/09/20
     .ns_rvc_div2_clk_frmac(m_ns_rvc_div2_clk[2]), //Newly added 11/09/20
     .fs_rvc_clk_tomac(m_fs_rvc_clk[2]), 
     .fs_fwd_clk_tomac(m_fs_fwd_clk[2]), 
     .ns_rvc_clk_frmac(m_ns_rvc_clk[2]), 
     .iddren(iddren[2]),
     .idataselb(idataselb[2]), //output async data selection
     .itxen(itxen[2]), //data tx enable
     .irxen(irxen[3*3-1:3*2]),//data input enable
     .idat0(data_in0_ch[2]), //output data to pad
     .idat1(data_in1_ch[2]), //output data to pad
     .data_out0(data_out0_ch[2]), //input data from pad
     .data_out1(data_out1_ch[2]), //input data from pad

     .ms_config_done(ms_config_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[2]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[2]),
     .sl_config_done(sl_config_done),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[2]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[2]),
     .ms_tx_transfer_en(ms_tx_transfer_en[2]),
     .ms_rx_transfer_en(ms_rx_transfer_en[2]),
     .sl_tx_transfer_en(sl_tx_transfer_en[2]),
     .sl_rx_transfer_en(sl_rx_transfer_en[2]),
     .sr_ms_tomac(sr_ms_tomac[81*3-1:81*2]),
     .sr_sl_tomac(sr_sl_tomac[73*3-1:73*2]),

     .ms_adapter_rstn(ms_ns_adapter_rstn[2]),
     .sl_adapter_rstn(sl_ns_adapter_rstn[2]),
     .ms_rstn(ms_ns_mac_rdy[2]),
     .sl_rstn(sl_ns_mac_rdy[2]),
     .fs_mac_rdy_tomac(fs_mac_rdy[2]),
     .por_sl(m_power_on_reset_i),
     .ms_nsl(ms_nsl),
     .por_ms(por_ms),
     .osc_clk(osc_clk),

 `include "redundancy_inst.vh"
     .sl_external_cntl_26_0(sl_external_cntl_26_0[27*3-1:27*2]),
     .sl_external_cntl_30_28(sl_external_cntl_30_28[3*3-1:3*2]),
     .sl_external_cntl_57_32(sl_external_cntl_57_32[26*3-1:26*2]),

     .ms_external_cntl_4_0(ms_external_cntl_4_0[5*3-1:5*2]),
     .ms_external_cntl_65_8(ms_external_cntl_65_8[58*3-1:58*2]),

     .vccl_aib(vccl_aib),
     .vssl_aib(vssl_aib) );


aib_channel #(.DATAWIDTH(DATAWIDTH)) aib_channel3
 ( 
     .iopad_txdat(m0_ch3_aib[19:0]),
     .iopad_rxdat(m0_ch3_aib[39:20]),
     .iopad_txclkb(m0_ch3_aib[86]), 
     .iopad_txclk(m0_ch3_aib[87]),
     .iopad_tx_div2_clkb(m0_ch3_aib[55]),
     .iopad_tx_div2_clk(m0_ch3_aib[48]),
     .iopad_tx_div2_fck(m0_ch3_aib[53]),
     .iopad_tx_div2_fckb(m0_ch3_aib[54]),

     .iopad_txfck(m0_ch3_aib[41]), 
     .iopad_txfckb(m0_ch3_aib[40]),
     .iopad_stck(m0_ch3_aib[85]), 
     .iopad_stckb(m0_ch3_aib[84]),
     .iopad_stl(m0_ch3_aib[94]), 
     .iopad_std(m0_ch3_aib[95]),
     .iopad_rstno(m0_ch3_aib[49]), 
     .iopad_arstno(m0_ch3_aib[56]),
     .iopad_spareo(m0_ch3_aib[47]), 
     .iopad_sparee(m0_ch3_aib[46]),
     .iopad_rxclkb(m0_ch3_aib[59]), 
     .iopad_rxclk(m0_ch3_aib[57]),
     .iopad_rxfckb(m0_ch3_aib[42]), 
     .iopad_rxfck(m0_ch3_aib[43]),
     .iopad_srckb(m0_ch3_aib[82]), 
     .iopad_srck(m0_ch3_aib[83]),
     .iopad_srl(m0_ch3_aib[92]), 
     .iopad_srd(m0_ch3_aib[93]),
     .iopad_rstni(m0_ch3_aib[44]), 
     .iopad_arstni(m0_ch3_aib[65]),

     .tx_launch_clk(m_ns_fwd_clk[3]), //output data clock
     .tx_launch_div2_clk(m_ns_fwd_div2_clk[3]), //Newly added 11/09/20
     .ns_rvc_div2_clk_frmac(m_ns_rvc_div2_clk[3]), //Newly added 11/09/20
     .fs_rvc_clk_tomac(m_fs_rvc_clk[3]), 
     .fs_fwd_clk_tomac(m_fs_fwd_clk[3]), 
     .ns_rvc_clk_frmac(m_ns_rvc_clk[3]), 
     .iddren(iddren[3]),
     .idataselb(idataselb[3]), //output async data selection
     .itxen(itxen[3]), //data tx enable
     .irxen(irxen[3*4-1:3*3]),//data input enable
     .idat0(data_in0_ch[3]), //output data to pad
     .idat1(data_in1_ch[3]), //output data to pad
     .data_out0(data_out0_ch[3]), //input data from pad
     .data_out1(data_out1_ch[3]), //input data from pad

     .ms_config_done(ms_config_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[3]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[3]),
     .sl_config_done(sl_config_done),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[3]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[3]),
     .ms_tx_transfer_en(ms_tx_transfer_en[3]),
     .ms_rx_transfer_en(ms_rx_transfer_en[3]),
     .sl_tx_transfer_en(sl_tx_transfer_en[3]),
     .sl_rx_transfer_en(sl_rx_transfer_en[3]),
     .sr_ms_tomac(sr_ms_tomac[81*4-1:81*3]),
     .sr_sl_tomac(sr_sl_tomac[73*4-1:73*3]),

     .ms_adapter_rstn(ms_ns_adapter_rstn[3]),
     .sl_adapter_rstn(sl_ns_adapter_rstn[3]),
     .ms_rstn(ms_ns_mac_rdy[3]),
     .sl_rstn(sl_ns_mac_rdy[3]),
     .fs_mac_rdy_tomac(fs_mac_rdy[3]),
     .por_sl(m_power_on_reset_i),
     .ms_nsl(ms_nsl),
     .por_ms(por_ms),
     .osc_clk(osc_clk),

 `include "redundancy_inst.vh"
     .sl_external_cntl_26_0(sl_external_cntl_26_0[27*4-1:27*3]),
     .sl_external_cntl_30_28(sl_external_cntl_30_28[3*4-1:3*3]),
     .sl_external_cntl_57_32(sl_external_cntl_57_32[26*4-1:26*3]),

     .ms_external_cntl_4_0(ms_external_cntl_4_0[5*4-1:5*3]),
     .ms_external_cntl_65_8(ms_external_cntl_65_8[58*4-1:58*3]),

     .vccl_aib(vccl_aib),
     .vssl_aib(vssl_aib) );


aib_channel #(.DATAWIDTH(DATAWIDTH)) aib_channel4
 ( 
     .iopad_txdat(m0_ch4_aib[19:0]),
     .iopad_rxdat(m0_ch4_aib[39:20]),
     .iopad_txclkb(m0_ch4_aib[86]), 
     .iopad_txclk(m0_ch4_aib[87]),
     .iopad_tx_div2_clkb(m0_ch4_aib[55]),
     .iopad_tx_div2_clk(m0_ch4_aib[48]),
     .iopad_tx_div2_fck(m0_ch4_aib[53]),
     .iopad_tx_div2_fckb(m0_ch4_aib[54]),

     .iopad_txfck(m0_ch4_aib[41]), 
     .iopad_txfckb(m0_ch4_aib[40]),
     .iopad_stck(m0_ch4_aib[85]), 
     .iopad_stckb(m0_ch4_aib[84]),
     .iopad_stl(m0_ch4_aib[94]), 
     .iopad_std(m0_ch4_aib[95]),
     .iopad_rstno(m0_ch4_aib[49]), 
     .iopad_arstno(m0_ch4_aib[56]),
     .iopad_spareo(m0_ch4_aib[47]), 
     .iopad_sparee(m0_ch4_aib[46]),
     .iopad_rxclkb(m0_ch4_aib[59]), 
     .iopad_rxclk(m0_ch4_aib[57]),
     .iopad_rxfckb(m0_ch4_aib[42]), 
     .iopad_rxfck(m0_ch4_aib[43]),
     .iopad_srckb(m0_ch4_aib[82]), 
     .iopad_srck(m0_ch4_aib[83]),
     .iopad_srl(m0_ch4_aib[92]), 
     .iopad_srd(m0_ch4_aib[93]),
     .iopad_rstni(m0_ch4_aib[44]), 
     .iopad_arstni(m0_ch4_aib[65]),

     .tx_launch_clk(m_ns_fwd_clk[4]), //output data clock
     .tx_launch_div2_clk(m_ns_fwd_div2_clk[4]), //Newly added 11/09/20
     .ns_rvc_div2_clk_frmac(m_ns_rvc_div2_clk[4]), //Newly added 11/09/20
     .fs_rvc_clk_tomac(m_fs_rvc_clk[4]), 
     .fs_fwd_clk_tomac(m_fs_fwd_clk[4]), 
     .ns_rvc_clk_frmac(m_ns_rvc_clk[4]), 
     .iddren(iddren[4]),
     .idataselb(idataselb[4]), //output async data selection
     .itxen(itxen[4]), //data tx enable
     .irxen(irxen[3*5-1:3*4]),//data input enable
     .idat0(data_in0_ch[4]), //output data to pad
     .idat1(data_in1_ch[4]), //output data to pad
     .data_out0(data_out0_ch[4]), //input data from pad
     .data_out1(data_out1_ch[4]), //input data from pad

     .ms_config_done(ms_config_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[4]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[4]),
     .sl_config_done(sl_config_done),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[4]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[4]),
     .ms_tx_transfer_en(ms_tx_transfer_en[4]),
     .ms_rx_transfer_en(ms_rx_transfer_en[4]),
     .sl_tx_transfer_en(sl_tx_transfer_en[4]),
     .sl_rx_transfer_en(sl_rx_transfer_en[4]),
     .sr_ms_tomac(sr_ms_tomac[81*5-1:81*4]),
     .sr_sl_tomac(sr_sl_tomac[73*5-1:73*4]),

     .ms_adapter_rstn(ms_ns_adapter_rstn[4]),
     .sl_adapter_rstn(sl_ns_adapter_rstn[4]),
     .ms_rstn(ms_ns_mac_rdy[4]),
     .sl_rstn(sl_ns_mac_rdy[4]),
     .fs_mac_rdy_tomac(fs_mac_rdy[4]),
     .por_sl(m_power_on_reset_i),
     .ms_nsl(ms_nsl),
     .por_ms(por_ms),
     .osc_clk(osc_clk),

 `include "redundancy_inst.vh"
     .sl_external_cntl_26_0(sl_external_cntl_26_0[27*5-1:27*4]),
     .sl_external_cntl_30_28(sl_external_cntl_30_28[3*5-1:3*4]),
     .sl_external_cntl_57_32(sl_external_cntl_57_32[26*5-1:26*4]),

     .ms_external_cntl_4_0(ms_external_cntl_4_0[5*5-1:5*4]),
     .ms_external_cntl_65_8(ms_external_cntl_65_8[58*5-1:58*4]),

     .vccl_aib(vccl_aib),
     .vssl_aib(vssl_aib) );


aib_channel #(.DATAWIDTH(DATAWIDTH)) aib_channel5
 ( 
     .iopad_txdat(m0_ch5_aib[19:0]),
     .iopad_rxdat(m0_ch5_aib[39:20]),
     .iopad_txclkb(m0_ch5_aib[86]), 
     .iopad_txclk(m0_ch5_aib[87]),
     .iopad_tx_div2_clkb(m0_ch5_aib[55]),
     .iopad_tx_div2_clk(m0_ch5_aib[48]),
     .iopad_tx_div2_fck(m0_ch5_aib[53]),
     .iopad_tx_div2_fckb(m0_ch5_aib[54]),

     .iopad_txfck(m0_ch5_aib[41]), 
     .iopad_txfckb(m0_ch5_aib[40]),
     .iopad_stck(m0_ch5_aib[85]), 
     .iopad_stckb(m0_ch5_aib[84]),
     .iopad_stl(m0_ch5_aib[94]), 
     .iopad_std(m0_ch5_aib[95]),
     .iopad_rstno(m0_ch5_aib[49]), 
     .iopad_arstno(m0_ch5_aib[56]),
     .iopad_spareo(m0_ch5_aib[47]), 
     .iopad_sparee(m0_ch5_aib[46]),
     .iopad_rxclkb(m0_ch5_aib[59]), 
     .iopad_rxclk(m0_ch5_aib[57]),
     .iopad_rxfckb(m0_ch5_aib[42]), 
     .iopad_rxfck(m0_ch5_aib[43]),
     .iopad_srckb(m0_ch5_aib[82]), 
     .iopad_srck(m0_ch5_aib[83]),
     .iopad_srl(m0_ch5_aib[92]), 
     .iopad_srd(m0_ch5_aib[93]),
     .iopad_rstni(m0_ch5_aib[44]), 
     .iopad_arstni(m0_ch5_aib[65]),

     .tx_launch_clk(m_ns_fwd_clk[5]), //output data clock
     .tx_launch_div2_clk(m_ns_fwd_div2_clk[5]), //Newly added 11/09/20
     .ns_rvc_div2_clk_frmac(m_ns_rvc_div2_clk[5]), //Newly added 11/09/20
     .fs_rvc_clk_tomac(m_fs_rvc_clk[5]), 
     .fs_fwd_clk_tomac(m_fs_fwd_clk[5]), 
     .ns_rvc_clk_frmac(m_ns_rvc_clk[5]), 
     .iddren(iddren[5]),
     .idataselb(idataselb[5]), //output async data selection
     .itxen(itxen[5]), //data tx enable
     .irxen(irxen[3*6-1:3*5]),//data input enable
     .idat0(data_in0_ch[5]), //output data to pad
     .idat1(data_in1_ch[5]), //output data to pad
     .data_out0(data_out0_ch[5]), //input data from pad
     .data_out1(data_out1_ch[5]), //input data from pad

     .ms_config_done(ms_config_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[5]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[5]),
     .sl_config_done(sl_config_done),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[5]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[5]),
     .ms_tx_transfer_en(ms_tx_transfer_en[5]),
     .ms_rx_transfer_en(ms_rx_transfer_en[5]),
     .sl_tx_transfer_en(sl_tx_transfer_en[5]),
     .sl_rx_transfer_en(sl_rx_transfer_en[5]),
     .sr_ms_tomac(sr_ms_tomac[81*6-1:81*5]),
     .sr_sl_tomac(sr_sl_tomac[73*6-1:73*5]),

     .ms_adapter_rstn(ms_ns_adapter_rstn[5]),
     .sl_adapter_rstn(sl_ns_adapter_rstn[5]),
     .ms_rstn(ms_ns_mac_rdy[5]),
     .sl_rstn(sl_ns_mac_rdy[5]),
     .fs_mac_rdy_tomac(fs_mac_rdy[5]),
     .por_sl(m_power_on_reset_i),
     .ms_nsl(ms_nsl),
     .por_ms(por_ms),
     .osc_clk(osc_clk),

 `include "redundancy_inst.vh"
     .sl_external_cntl_26_0(sl_external_cntl_26_0[27*6-1:27*5]),
     .sl_external_cntl_30_28(sl_external_cntl_30_28[3*6-1:3*5]),
     .sl_external_cntl_57_32(sl_external_cntl_57_32[26*6-1:26*5]),

     .ms_external_cntl_4_0(ms_external_cntl_4_0[5*6-1:5*5]),
     .ms_external_cntl_65_8(ms_external_cntl_65_8[58*6-1:58*5]),

     .vccl_aib(vccl_aib),
     .vssl_aib(vssl_aib) );


aib_channel #(.DATAWIDTH(DATAWIDTH)) aib_channel6
 ( 
     .iopad_txdat(m1_ch0_aib[19:0]),
     .iopad_rxdat(m1_ch0_aib[39:20]),
     .iopad_txclkb(m1_ch0_aib[86]), 
     .iopad_txclk(m1_ch0_aib[87]),
     .iopad_tx_div2_clkb(m1_ch0_aib[55]),
     .iopad_tx_div2_clk(m1_ch0_aib[48]),
     .iopad_tx_div2_fck(m1_ch0_aib[53]),
     .iopad_tx_div2_fckb(m1_ch0_aib[54]),

     .iopad_txfck(m1_ch0_aib[41]), 
     .iopad_txfckb(m1_ch0_aib[40]),
     .iopad_stck(m1_ch0_aib[85]), 
     .iopad_stckb(m1_ch0_aib[84]),
     .iopad_stl(m1_ch0_aib[94]), 
     .iopad_std(m1_ch0_aib[95]),
     .iopad_rstno(m1_ch0_aib[49]), 
     .iopad_arstno(m1_ch0_aib[56]),
     .iopad_spareo(m1_ch0_aib[47]), 
     .iopad_sparee(m1_ch0_aib[46]),
     .iopad_rxclkb(m1_ch0_aib[59]), 
     .iopad_rxclk(m1_ch0_aib[57]),
     .iopad_rxfckb(m1_ch0_aib[42]), 
     .iopad_rxfck(m1_ch0_aib[43]),
     .iopad_srckb(m1_ch0_aib[82]), 
     .iopad_srck(m1_ch0_aib[83]),
     .iopad_srl(m1_ch0_aib[92]), 
     .iopad_srd(m1_ch0_aib[93]),
     .iopad_rstni(m1_ch0_aib[44]), 
     .iopad_arstni(m1_ch0_aib[65]),

     .tx_launch_clk(m_ns_fwd_clk[6]), //output data clock
     .tx_launch_div2_clk(m_ns_fwd_div2_clk[6]), //Newly added 11/09/20
     .ns_rvc_div2_clk_frmac(m_ns_rvc_div2_clk[6]), //Newly added 11/09/20
     .fs_rvc_clk_tomac(m_fs_rvc_clk[6]), 
     .fs_fwd_clk_tomac(m_fs_fwd_clk[6]), 
     .ns_rvc_clk_frmac(m_ns_rvc_clk[6]), 
     .iddren(iddren[6]),
     .idataselb(idataselb[6]), //output async data selection
     .itxen(itxen[6]), //data tx enable
     .irxen(irxen[3*7-1:3*6]),//data input enable
     .idat0(data_in0_ch[6]), //output data to pad
     .idat1(data_in1_ch[6]), //output data to pad
     .data_out0(data_out0_ch[6]), //input data from pad
     .data_out1(data_out1_ch[6]), //input data from pad

     .ms_config_done(ms_config_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[6]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[6]),
     .sl_config_done(sl_config_done),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[6]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[6]),
     .ms_tx_transfer_en(ms_tx_transfer_en[6]),
     .ms_rx_transfer_en(ms_rx_transfer_en[6]),
     .sl_tx_transfer_en(sl_tx_transfer_en[6]),
     .sl_rx_transfer_en(sl_rx_transfer_en[6]),
     .sr_ms_tomac(sr_ms_tomac[81*7-1:81*6]),
     .sr_sl_tomac(sr_sl_tomac[73*7-1:73*6]),

     .ms_adapter_rstn(ms_ns_adapter_rstn[6]),
     .sl_adapter_rstn(sl_ns_adapter_rstn[6]),
     .ms_rstn(ms_ns_mac_rdy[6]),
     .sl_rstn(sl_ns_mac_rdy[6]),
     .fs_mac_rdy_tomac(fs_mac_rdy[6]),
     .por_sl(m_power_on_reset_i),
     .ms_nsl(ms_nsl),
     .por_ms(por_ms),
     .osc_clk(osc_clk),

 `include "redundancy_inst.vh"
     .sl_external_cntl_26_0(sl_external_cntl_26_0[27*7-1:27*6]),
     .sl_external_cntl_30_28(sl_external_cntl_30_28[3*7-1:3*6]),
     .sl_external_cntl_57_32(sl_external_cntl_57_32[26*7-1:26*6]),

     .ms_external_cntl_4_0(ms_external_cntl_4_0[5*7-1:5*6]),
     .ms_external_cntl_65_8(ms_external_cntl_65_8[58*7-1:58*6]),

     .vccl_aib(vccl_aib),
     .vssl_aib(vssl_aib) );


aib_channel #(.DATAWIDTH(DATAWIDTH)) aib_channel7
 ( 
     .iopad_txdat(m1_ch1_aib[19:0]),
     .iopad_rxdat(m1_ch1_aib[39:20]),
     .iopad_txclkb(m1_ch1_aib[86]), 
     .iopad_txclk(m1_ch1_aib[87]),
     .iopad_tx_div2_clkb(m1_ch1_aib[55]),
     .iopad_tx_div2_clk(m1_ch1_aib[48]),
     .iopad_tx_div2_fck(m1_ch1_aib[53]),
     .iopad_tx_div2_fckb(m1_ch1_aib[54]),

     .iopad_txfck(m1_ch1_aib[41]), 
     .iopad_txfckb(m1_ch1_aib[40]),
     .iopad_stck(m1_ch1_aib[85]), 
     .iopad_stckb(m1_ch1_aib[84]),
     .iopad_stl(m1_ch1_aib[94]), 
     .iopad_std(m1_ch1_aib[95]),
     .iopad_rstno(m1_ch1_aib[49]), 
     .iopad_arstno(m1_ch1_aib[56]),
     .iopad_spareo(m1_ch1_aib[47]), 
     .iopad_sparee(m1_ch1_aib[46]),
     .iopad_rxclkb(m1_ch1_aib[59]), 
     .iopad_rxclk(m1_ch1_aib[57]),
     .iopad_rxfckb(m1_ch1_aib[42]), 
     .iopad_rxfck(m1_ch1_aib[43]),
     .iopad_srckb(m1_ch1_aib[82]), 
     .iopad_srck(m1_ch1_aib[83]),
     .iopad_srl(m1_ch1_aib[92]), 
     .iopad_srd(m1_ch1_aib[93]),
     .iopad_rstni(m1_ch1_aib[44]), 
     .iopad_arstni(m1_ch1_aib[65]),

     .tx_launch_clk(m_ns_fwd_clk[7]), //output data clock
     .tx_launch_div2_clk(m_ns_fwd_div2_clk[7]), //Newly added 11/09/20
     .ns_rvc_div2_clk_frmac(m_ns_rvc_div2_clk[7]), //Newly added 11/09/20
     .fs_rvc_clk_tomac(m_fs_rvc_clk[7]), 
     .fs_fwd_clk_tomac(m_fs_fwd_clk[7]), 
     .ns_rvc_clk_frmac(m_ns_rvc_clk[7]), 
     .iddren(iddren[7]),
     .idataselb(idataselb[7]), //output async data selection
     .itxen(itxen[7]), //data tx enable
     .irxen(irxen[3*8-1:3*7]),//data input enable
     .idat0(data_in0_ch[7]), //output data to pad
     .idat1(data_in1_ch[7]), //output data to pad
     .data_out0(data_out0_ch[7]), //input data from pad
     .data_out1(data_out1_ch[7]), //input data from pad

     .ms_config_done(ms_config_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[7]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[7]),
     .sl_config_done(sl_config_done),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[7]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[7]),
     .ms_tx_transfer_en(ms_tx_transfer_en[7]),
     .ms_rx_transfer_en(ms_rx_transfer_en[7]),
     .sl_tx_transfer_en(sl_tx_transfer_en[7]),
     .sl_rx_transfer_en(sl_rx_transfer_en[7]),
     .sr_ms_tomac(sr_ms_tomac[81*8-1:81*7]),
     .sr_sl_tomac(sr_sl_tomac[73*8-1:73*7]),

     .ms_adapter_rstn(ms_ns_adapter_rstn[7]),
     .sl_adapter_rstn(sl_ns_adapter_rstn[7]),
     .ms_rstn(ms_ns_mac_rdy[7]),
     .sl_rstn(sl_ns_mac_rdy[7]),
     .fs_mac_rdy_tomac(fs_mac_rdy[7]),
     .por_sl(m_power_on_reset_i),
     .ms_nsl(ms_nsl),
     .por_ms(por_ms),
     .osc_clk(osc_clk),

 `include "redundancy_inst.vh"
     .sl_external_cntl_26_0(sl_external_cntl_26_0[27*8-1:27*7]),
     .sl_external_cntl_30_28(sl_external_cntl_30_28[3*8-1:3*7]),
     .sl_external_cntl_57_32(sl_external_cntl_57_32[26*8-1:26*7]),

     .ms_external_cntl_4_0(ms_external_cntl_4_0[5*8-1:5*7]),
     .ms_external_cntl_65_8(ms_external_cntl_65_8[58*8-1:58*7]),

     .vccl_aib(vccl_aib),
     .vssl_aib(vssl_aib) );


aib_channel #(.DATAWIDTH(DATAWIDTH)) aib_channel8
 ( 
     .iopad_txdat(m1_ch2_aib[19:0]),
     .iopad_rxdat(m1_ch2_aib[39:20]),
     .iopad_txclkb(m1_ch2_aib[86]), 
     .iopad_txclk(m1_ch2_aib[87]),
     .iopad_tx_div2_clkb(m1_ch2_aib[55]),
     .iopad_tx_div2_clk(m1_ch2_aib[48]),
     .iopad_tx_div2_fck(m1_ch2_aib[53]),
     .iopad_tx_div2_fckb(m1_ch2_aib[54]),

     .iopad_txfck(m1_ch2_aib[41]), 
     .iopad_txfckb(m1_ch2_aib[40]),
     .iopad_stck(m1_ch2_aib[85]), 
     .iopad_stckb(m1_ch2_aib[84]),
     .iopad_stl(m1_ch2_aib[94]), 
     .iopad_std(m1_ch2_aib[95]),
     .iopad_rstno(m1_ch2_aib[49]), 
     .iopad_arstno(m1_ch2_aib[56]),
     .iopad_spareo(m1_ch2_aib[47]), 
     .iopad_sparee(m1_ch2_aib[46]),
     .iopad_rxclkb(m1_ch2_aib[59]), 
     .iopad_rxclk(m1_ch2_aib[57]),
     .iopad_rxfckb(m1_ch2_aib[42]), 
     .iopad_rxfck(m1_ch2_aib[43]),
     .iopad_srckb(m1_ch2_aib[82]), 
     .iopad_srck(m1_ch2_aib[83]),
     .iopad_srl(m1_ch2_aib[92]), 
     .iopad_srd(m1_ch2_aib[93]),
     .iopad_rstni(m1_ch2_aib[44]), 
     .iopad_arstni(m1_ch2_aib[65]),

     .tx_launch_clk(m_ns_fwd_clk[8]), //output data clock
     .tx_launch_div2_clk(m_ns_fwd_div2_clk[8]), //Newly added 11/09/20
     .ns_rvc_div2_clk_frmac(m_ns_rvc_div2_clk[8]), //Newly added 11/09/20
     .fs_rvc_clk_tomac(m_fs_rvc_clk[8]), 
     .fs_fwd_clk_tomac(m_fs_fwd_clk[8]), 
     .ns_rvc_clk_frmac(m_ns_rvc_clk[8]), 
     .iddren(iddren[8]),
     .idataselb(idataselb[8]), //output async data selection
     .itxen(itxen[8]), //data tx enable
     .irxen(irxen[3*9-1:3*8]),//data input enable
     .idat0(data_in0_ch[8]), //output data to pad
     .idat1(data_in1_ch[8]), //output data to pad
     .data_out0(data_out0_ch[8]), //input data from pad
     .data_out1(data_out1_ch[8]), //input data from pad

     .ms_config_done(ms_config_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[8]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[8]),
     .sl_config_done(sl_config_done),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[8]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[8]),
     .ms_tx_transfer_en(ms_tx_transfer_en[8]),
     .ms_rx_transfer_en(ms_rx_transfer_en[8]),
     .sl_tx_transfer_en(sl_tx_transfer_en[8]),
     .sl_rx_transfer_en(sl_rx_transfer_en[8]),
     .sr_ms_tomac(sr_ms_tomac[81*9-1:81*8]),
     .sr_sl_tomac(sr_sl_tomac[73*9-1:73*8]),

     .ms_adapter_rstn(ms_ns_adapter_rstn[8]),
     .sl_adapter_rstn(sl_ns_adapter_rstn[8]),
     .ms_rstn(ms_ns_mac_rdy[8]),
     .sl_rstn(sl_ns_mac_rdy[8]),
     .fs_mac_rdy_tomac(fs_mac_rdy[8]),
     .por_sl(m_power_on_reset_i),
     .ms_nsl(ms_nsl),
     .por_ms(por_ms),
     .osc_clk(osc_clk),

 `include "redundancy_inst.vh"
     .sl_external_cntl_26_0(sl_external_cntl_26_0[27*9-1:27*8]),
     .sl_external_cntl_30_28(sl_external_cntl_30_28[3*9-1:3*8]),
     .sl_external_cntl_57_32(sl_external_cntl_57_32[26*9-1:26*8]),

     .ms_external_cntl_4_0(ms_external_cntl_4_0[5*9-1:5*8]),
     .ms_external_cntl_65_8(ms_external_cntl_65_8[58*9-1:58*8]),

     .vccl_aib(vccl_aib),
     .vssl_aib(vssl_aib) );


aib_channel #(.DATAWIDTH(DATAWIDTH)) aib_channel9
 ( 
     .iopad_txdat(m1_ch3_aib[19:0]),
     .iopad_rxdat(m1_ch3_aib[39:20]),
     .iopad_txclkb(m1_ch3_aib[86]), 
     .iopad_txclk(m1_ch3_aib[87]),
     .iopad_tx_div2_clkb(m1_ch3_aib[55]),
     .iopad_tx_div2_clk(m1_ch3_aib[48]),
     .iopad_tx_div2_fck(m1_ch3_aib[53]),
     .iopad_tx_div2_fckb(m1_ch3_aib[54]),

     .iopad_txfck(m1_ch3_aib[41]), 
     .iopad_txfckb(m1_ch3_aib[40]),
     .iopad_stck(m1_ch3_aib[85]), 
     .iopad_stckb(m1_ch3_aib[84]),
     .iopad_stl(m1_ch3_aib[94]), 
     .iopad_std(m1_ch3_aib[95]),
     .iopad_rstno(m1_ch3_aib[49]), 
     .iopad_arstno(m1_ch3_aib[56]),
     .iopad_spareo(m1_ch3_aib[47]), 
     .iopad_sparee(m1_ch3_aib[46]),
     .iopad_rxclkb(m1_ch3_aib[59]), 
     .iopad_rxclk(m1_ch3_aib[57]),
     .iopad_rxfckb(m1_ch3_aib[42]), 
     .iopad_rxfck(m1_ch3_aib[43]),
     .iopad_srckb(m1_ch3_aib[82]), 
     .iopad_srck(m1_ch3_aib[83]),
     .iopad_srl(m1_ch3_aib[92]), 
     .iopad_srd(m1_ch3_aib[93]),
     .iopad_rstni(m1_ch3_aib[44]), 
     .iopad_arstni(m1_ch3_aib[65]),

     .tx_launch_clk(m_ns_fwd_clk[9]), //output data clock
     .tx_launch_div2_clk(m_ns_fwd_div2_clk[9]), //Newly added 11/09/20
     .ns_rvc_div2_clk_frmac(m_ns_rvc_div2_clk[9]), //Newly added 11/09/20
     .fs_rvc_clk_tomac(m_fs_rvc_clk[9]), 
     .fs_fwd_clk_tomac(m_fs_fwd_clk[9]), 
     .ns_rvc_clk_frmac(m_ns_rvc_clk[9]), 
     .iddren(iddren[9]),
     .idataselb(idataselb[9]), //output async data selection
     .itxen(itxen[9]), //data tx enable
     .irxen(irxen[3*10-1:3*9]),//data input enable
     .idat0(data_in0_ch[9]), //output data to pad
     .idat1(data_in1_ch[9]), //output data to pad
     .data_out0(data_out0_ch[9]), //input data from pad
     .data_out1(data_out1_ch[9]), //input data from pad

     .ms_config_done(ms_config_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[9]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[9]),
     .sl_config_done(sl_config_done),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[9]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[9]),
     .ms_tx_transfer_en(ms_tx_transfer_en[9]),
     .ms_rx_transfer_en(ms_rx_transfer_en[9]),
     .sl_tx_transfer_en(sl_tx_transfer_en[9]),
     .sl_rx_transfer_en(sl_rx_transfer_en[9]),
     .sr_ms_tomac(sr_ms_tomac[81*10-1:81*9]),
     .sr_sl_tomac(sr_sl_tomac[73*10-1:73*9]),

     .ms_adapter_rstn(ms_ns_adapter_rstn[9]),
     .sl_adapter_rstn(sl_ns_adapter_rstn[9]),
     .ms_rstn(ms_ns_mac_rdy[9]),
     .sl_rstn(sl_ns_mac_rdy[9]),
     .fs_mac_rdy_tomac(fs_mac_rdy[9]),
     .por_sl(m_power_on_reset_i),
     .ms_nsl(ms_nsl),
     .por_ms(por_ms),
     .osc_clk(osc_clk),

 `include "redundancy_inst.vh"
     .sl_external_cntl_26_0(sl_external_cntl_26_0[27*10-1:27*9]),
     .sl_external_cntl_30_28(sl_external_cntl_30_28[3*10-1:3*9]),
     .sl_external_cntl_57_32(sl_external_cntl_57_32[26*10-1:26*9]),

     .ms_external_cntl_4_0(ms_external_cntl_4_0[5*10-1:5*9]),
     .ms_external_cntl_65_8(ms_external_cntl_65_8[58*10-1:58*9]),

     .vccl_aib(vccl_aib),
     .vssl_aib(vssl_aib) );


aib_channel #(.DATAWIDTH(DATAWIDTH)) aib_channel10
 ( 
     .iopad_txdat(m1_ch4_aib[19:0]),
     .iopad_rxdat(m1_ch4_aib[39:20]),
     .iopad_txclkb(m1_ch4_aib[86]), 
     .iopad_txclk(m1_ch4_aib[87]),
     .iopad_tx_div2_clkb(m1_ch4_aib[55]),
     .iopad_tx_div2_clk(m1_ch4_aib[48]),
     .iopad_tx_div2_fck(m1_ch4_aib[53]),
     .iopad_tx_div2_fckb(m1_ch4_aib[54]),

     .iopad_txfck(m1_ch4_aib[41]), 
     .iopad_txfckb(m1_ch4_aib[40]),
     .iopad_stck(m1_ch4_aib[85]), 
     .iopad_stckb(m1_ch4_aib[84]),
     .iopad_stl(m1_ch4_aib[94]), 
     .iopad_std(m1_ch4_aib[95]),
     .iopad_rstno(m1_ch4_aib[49]), 
     .iopad_arstno(m1_ch4_aib[56]),
     .iopad_spareo(m1_ch4_aib[47]), 
     .iopad_sparee(m1_ch4_aib[46]),
     .iopad_rxclkb(m1_ch4_aib[59]), 
     .iopad_rxclk(m1_ch4_aib[57]),
     .iopad_rxfckb(m1_ch4_aib[42]), 
     .iopad_rxfck(m1_ch4_aib[43]),
     .iopad_srckb(m1_ch4_aib[82]), 
     .iopad_srck(m1_ch4_aib[83]),
     .iopad_srl(m1_ch4_aib[92]), 
     .iopad_srd(m1_ch4_aib[93]),
     .iopad_rstni(m1_ch4_aib[44]), 
     .iopad_arstni(m1_ch4_aib[65]),

     .tx_launch_clk(m_ns_fwd_clk[10]), //output data clock
     .tx_launch_div2_clk(m_ns_fwd_div2_clk[10]), //Newly added 11/09/20
     .ns_rvc_div2_clk_frmac(m_ns_rvc_div2_clk[10]), //Newly added 11/09/20
     .fs_rvc_clk_tomac(m_fs_rvc_clk[10]), 
     .fs_fwd_clk_tomac(m_fs_fwd_clk[10]), 
     .ns_rvc_clk_frmac(m_ns_rvc_clk[10]), 
     .iddren(iddren[10]),
     .idataselb(idataselb[10]), //output async data selection
     .itxen(itxen[10]), //data tx enable
     .irxen(irxen[3*11-1:3*10]),//data input enable
     .idat0(data_in0_ch[10]), //output data to pad
     .idat1(data_in1_ch[10]), //output data to pad
     .data_out0(data_out0_ch[10]), //input data from pad
     .data_out1(data_out1_ch[10]), //input data from pad

     .ms_config_done(ms_config_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[10]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[10]),
     .sl_config_done(sl_config_done),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[10]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[10]),
     .ms_tx_transfer_en(ms_tx_transfer_en[10]),
     .ms_rx_transfer_en(ms_rx_transfer_en[10]),
     .sl_tx_transfer_en(sl_tx_transfer_en[10]),
     .sl_rx_transfer_en(sl_rx_transfer_en[10]),
     .sr_ms_tomac(sr_ms_tomac[81*11-1:81*10]),
     .sr_sl_tomac(sr_sl_tomac[73*11-1:73*10]),

     .ms_adapter_rstn(ms_ns_adapter_rstn[10]),
     .sl_adapter_rstn(sl_ns_adapter_rstn[10]),
     .ms_rstn(ms_ns_mac_rdy[10]),
     .sl_rstn(sl_ns_mac_rdy[10]),
     .fs_mac_rdy_tomac(fs_mac_rdy[10]),
     .por_sl(m_power_on_reset_i),
     .ms_nsl(ms_nsl),
     .por_ms(por_ms),
     .osc_clk(osc_clk),

 `include "redundancy_inst.vh"
     .sl_external_cntl_26_0(sl_external_cntl_26_0[27*11-1:27*10]),
     .sl_external_cntl_30_28(sl_external_cntl_30_28[3*11-1:3*10]),
     .sl_external_cntl_57_32(sl_external_cntl_57_32[26*11-1:26*10]),

     .ms_external_cntl_4_0(ms_external_cntl_4_0[5*11-1:5*10]),
     .ms_external_cntl_65_8(ms_external_cntl_65_8[58*11-1:58*10]),

     .vccl_aib(vccl_aib),
     .vssl_aib(vssl_aib) );


aib_channel #(.DATAWIDTH(DATAWIDTH)) aib_channel11
 ( 
     .iopad_txdat(m1_ch5_aib[19:0]),
     .iopad_rxdat(m1_ch5_aib[39:20]),
     .iopad_txclkb(m1_ch5_aib[86]), 
     .iopad_txclk(m1_ch5_aib[87]),
     .iopad_tx_div2_clkb(m1_ch5_aib[55]),
     .iopad_tx_div2_clk(m1_ch5_aib[48]),
     .iopad_tx_div2_fck(m1_ch5_aib[53]),
     .iopad_tx_div2_fckb(m1_ch5_aib[54]),

     .iopad_txfck(m1_ch5_aib[41]), 
     .iopad_txfckb(m1_ch5_aib[40]),
     .iopad_stck(m1_ch5_aib[85]), 
     .iopad_stckb(m1_ch5_aib[84]),
     .iopad_stl(m1_ch5_aib[94]), 
     .iopad_std(m1_ch5_aib[95]),
     .iopad_rstno(m1_ch5_aib[49]), 
     .iopad_arstno(m1_ch5_aib[56]),
     .iopad_spareo(m1_ch5_aib[47]), 
     .iopad_sparee(m1_ch5_aib[46]),
     .iopad_rxclkb(m1_ch5_aib[59]), 
     .iopad_rxclk(m1_ch5_aib[57]),
     .iopad_rxfckb(m1_ch5_aib[42]), 
     .iopad_rxfck(m1_ch5_aib[43]),
     .iopad_srckb(m1_ch5_aib[82]), 
     .iopad_srck(m1_ch5_aib[83]),
     .iopad_srl(m1_ch5_aib[92]), 
     .iopad_srd(m1_ch5_aib[93]),
     .iopad_rstni(m1_ch5_aib[44]), 
     .iopad_arstni(m1_ch5_aib[65]),

     .tx_launch_clk(m_ns_fwd_clk[11]), //output data clock
     .tx_launch_div2_clk(m_ns_fwd_div2_clk[11]), //Newly added 11/09/20
     .ns_rvc_div2_clk_frmac(m_ns_rvc_div2_clk[11]), //Newly added 11/09/20
     .fs_rvc_clk_tomac(m_fs_rvc_clk[11]), 
     .fs_fwd_clk_tomac(m_fs_fwd_clk[11]), 
     .ns_rvc_clk_frmac(m_ns_rvc_clk[11]), 
     .iddren(iddren[11]),
     .idataselb(idataselb[11]), //output async data selection
     .itxen(itxen[11]), //data tx enable
     .irxen(irxen[3*12-1:3*11]),//data input enable
     .idat0(data_in0_ch[11]), //output data to pad
     .idat1(data_in1_ch[11]), //output data to pad
     .data_out0(data_out0_ch[11]), //input data from pad
     .data_out1(data_out1_ch[11]), //input data from pad

     .ms_config_done(ms_config_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[11]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[11]),
     .sl_config_done(sl_config_done),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[11]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[11]),
     .ms_tx_transfer_en(ms_tx_transfer_en[11]),
     .ms_rx_transfer_en(ms_rx_transfer_en[11]),
     .sl_tx_transfer_en(sl_tx_transfer_en[11]),
     .sl_rx_transfer_en(sl_rx_transfer_en[11]),
     .sr_ms_tomac(sr_ms_tomac[81*12-1:81*11]),
     .sr_sl_tomac(sr_sl_tomac[73*12-1:73*11]),

     .ms_adapter_rstn(ms_ns_adapter_rstn[11]),
     .sl_adapter_rstn(sl_ns_adapter_rstn[11]),
     .ms_rstn(ms_ns_mac_rdy[11]),
     .sl_rstn(sl_ns_mac_rdy[11]),
     .fs_mac_rdy_tomac(fs_mac_rdy[11]),
     .por_sl(m_power_on_reset_i),
     .ms_nsl(ms_nsl),
     .por_ms(por_ms),
     .osc_clk(osc_clk),

 `include "redundancy_inst.vh"
     .sl_external_cntl_26_0(sl_external_cntl_26_0[27*12-1:27*11]),
     .sl_external_cntl_30_28(sl_external_cntl_30_28[3*12-1:3*11]),
     .sl_external_cntl_57_32(sl_external_cntl_57_32[26*12-1:26*11]),

     .ms_external_cntl_4_0(ms_external_cntl_4_0[5*12-1:5*11]),
     .ms_external_cntl_65_8(ms_external_cntl_65_8[58*12-1:58*11]),

     .vccl_aib(vccl_aib),
     .vssl_aib(vssl_aib) );


aib_channel #(.DATAWIDTH(DATAWIDTH)) aib_channel12
 ( 
     .iopad_txdat(m2_ch0_aib[19:0]),
     .iopad_rxdat(m2_ch0_aib[39:20]),
     .iopad_txclkb(m2_ch0_aib[86]), 
     .iopad_txclk(m2_ch0_aib[87]),
     .iopad_tx_div2_clkb(m2_ch0_aib[55]),
     .iopad_tx_div2_clk(m2_ch0_aib[48]),
     .iopad_tx_div2_fck(m2_ch0_aib[53]),
     .iopad_tx_div2_fckb(m2_ch0_aib[54]),

     .iopad_txfck(m2_ch0_aib[41]), 
     .iopad_txfckb(m2_ch0_aib[40]),
     .iopad_stck(m2_ch0_aib[85]), 
     .iopad_stckb(m2_ch0_aib[84]),
     .iopad_stl(m2_ch0_aib[94]), 
     .iopad_std(m2_ch0_aib[95]),
     .iopad_rstno(m2_ch0_aib[49]), 
     .iopad_arstno(m2_ch0_aib[56]),
     .iopad_spareo(m2_ch0_aib[47]), 
     .iopad_sparee(m2_ch0_aib[46]),
     .iopad_rxclkb(m2_ch0_aib[59]), 
     .iopad_rxclk(m2_ch0_aib[57]),
     .iopad_rxfckb(m2_ch0_aib[42]), 
     .iopad_rxfck(m2_ch0_aib[43]),
     .iopad_srckb(m2_ch0_aib[82]), 
     .iopad_srck(m2_ch0_aib[83]),
     .iopad_srl(m2_ch0_aib[92]), 
     .iopad_srd(m2_ch0_aib[93]),
     .iopad_rstni(m2_ch0_aib[44]), 
     .iopad_arstni(m2_ch0_aib[65]),

     .tx_launch_clk(m_ns_fwd_clk[12]), //output data clock
     .tx_launch_div2_clk(m_ns_fwd_div2_clk[12]), //Newly added 11/09/20
     .ns_rvc_div2_clk_frmac(m_ns_rvc_div2_clk[12]), //Newly added 11/09/20
     .fs_rvc_clk_tomac(m_fs_rvc_clk[12]), 
     .fs_fwd_clk_tomac(m_fs_fwd_clk[12]), 
     .ns_rvc_clk_frmac(m_ns_rvc_clk[12]), 
     .iddren(iddren[12]),
     .idataselb(idataselb[12]), //output async data selection
     .itxen(itxen[12]), //data tx enable
     .irxen(irxen[3*13-1:3*12]),//data input enable
     .idat0(data_in0_ch[12]), //output data to pad
     .idat1(data_in1_ch[12]), //output data to pad
     .data_out0(data_out0_ch[12]), //input data from pad
     .data_out1(data_out1_ch[12]), //input data from pad

     .ms_config_done(ms_config_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[12]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[12]),
     .sl_config_done(sl_config_done),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[12]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[12]),
     .ms_tx_transfer_en(ms_tx_transfer_en[12]),
     .ms_rx_transfer_en(ms_rx_transfer_en[12]),
     .sl_tx_transfer_en(sl_tx_transfer_en[12]),
     .sl_rx_transfer_en(sl_rx_transfer_en[12]),
     .sr_ms_tomac(sr_ms_tomac[81*13-1:81*12]),
     .sr_sl_tomac(sr_sl_tomac[73*13-1:73*12]),

     .ms_adapter_rstn(ms_ns_adapter_rstn[12]),
     .sl_adapter_rstn(sl_ns_adapter_rstn[12]),
     .ms_rstn(ms_ns_mac_rdy[12]),
     .sl_rstn(sl_ns_mac_rdy[12]),
     .fs_mac_rdy_tomac(fs_mac_rdy[12]),
     .por_sl(m_power_on_reset_i),
     .ms_nsl(ms_nsl),
     .por_ms(por_ms),
     .osc_clk(osc_clk),

 `include "redundancy_inst.vh"
     .sl_external_cntl_26_0(sl_external_cntl_26_0[27*13-1:27*12]),
     .sl_external_cntl_30_28(sl_external_cntl_30_28[3*13-1:3*12]),
     .sl_external_cntl_57_32(sl_external_cntl_57_32[26*13-1:26*12]),

     .ms_external_cntl_4_0(ms_external_cntl_4_0[5*13-1:5*12]),
     .ms_external_cntl_65_8(ms_external_cntl_65_8[58*13-1:58*12]),

     .vccl_aib(vccl_aib),
     .vssl_aib(vssl_aib) );


aib_channel #(.DATAWIDTH(DATAWIDTH)) aib_channel13
 ( 
     .iopad_txdat(m2_ch1_aib[19:0]),
     .iopad_rxdat(m2_ch1_aib[39:20]),
     .iopad_txclkb(m2_ch1_aib[86]), 
     .iopad_txclk(m2_ch1_aib[87]),
     .iopad_tx_div2_clkb(m2_ch1_aib[55]),
     .iopad_tx_div2_clk(m2_ch1_aib[48]),
     .iopad_tx_div2_fck(m2_ch1_aib[53]),
     .iopad_tx_div2_fckb(m2_ch1_aib[54]),

     .iopad_txfck(m2_ch1_aib[41]), 
     .iopad_txfckb(m2_ch1_aib[40]),
     .iopad_stck(m2_ch1_aib[85]), 
     .iopad_stckb(m2_ch1_aib[84]),
     .iopad_stl(m2_ch1_aib[94]), 
     .iopad_std(m2_ch1_aib[95]),
     .iopad_rstno(m2_ch1_aib[49]), 
     .iopad_arstno(m2_ch1_aib[56]),
     .iopad_spareo(m2_ch1_aib[47]), 
     .iopad_sparee(m2_ch1_aib[46]),
     .iopad_rxclkb(m2_ch1_aib[59]), 
     .iopad_rxclk(m2_ch1_aib[57]),
     .iopad_rxfckb(m2_ch1_aib[42]), 
     .iopad_rxfck(m2_ch1_aib[43]),
     .iopad_srckb(m2_ch1_aib[82]), 
     .iopad_srck(m2_ch1_aib[83]),
     .iopad_srl(m2_ch1_aib[92]), 
     .iopad_srd(m2_ch1_aib[93]),
     .iopad_rstni(m2_ch1_aib[44]), 
     .iopad_arstni(m2_ch1_aib[65]),

     .tx_launch_clk(m_ns_fwd_clk[13]), //output data clock
     .tx_launch_div2_clk(m_ns_fwd_div2_clk[13]), //Newly added 11/09/20
     .ns_rvc_div2_clk_frmac(m_ns_rvc_div2_clk[13]), //Newly added 11/09/20
     .fs_rvc_clk_tomac(m_fs_rvc_clk[13]), 
     .fs_fwd_clk_tomac(m_fs_fwd_clk[13]), 
     .ns_rvc_clk_frmac(m_ns_rvc_clk[13]), 
     .iddren(iddren[13]),
     .idataselb(idataselb[13]), //output async data selection
     .itxen(itxen[13]), //data tx enable
     .irxen(irxen[3*14-1:3*13]),//data input enable
     .idat0(data_in0_ch[13]), //output data to pad
     .idat1(data_in1_ch[13]), //output data to pad
     .data_out0(data_out0_ch[13]), //input data from pad
     .data_out1(data_out1_ch[13]), //input data from pad

     .ms_config_done(ms_config_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[13]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[13]),
     .sl_config_done(sl_config_done),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[13]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[13]),
     .ms_tx_transfer_en(ms_tx_transfer_en[13]),
     .ms_rx_transfer_en(ms_rx_transfer_en[13]),
     .sl_tx_transfer_en(sl_tx_transfer_en[13]),
     .sl_rx_transfer_en(sl_rx_transfer_en[13]),
     .sr_ms_tomac(sr_ms_tomac[81*14-1:81*13]),
     .sr_sl_tomac(sr_sl_tomac[73*14-1:73*13]),

     .ms_adapter_rstn(ms_ns_adapter_rstn[13]),
     .sl_adapter_rstn(sl_ns_adapter_rstn[13]),
     .ms_rstn(ms_ns_mac_rdy[13]),
     .sl_rstn(sl_ns_mac_rdy[13]),
     .fs_mac_rdy_tomac(fs_mac_rdy[13]),
     .por_sl(m_power_on_reset_i),
     .ms_nsl(ms_nsl),
     .por_ms(por_ms),
     .osc_clk(osc_clk),

 `include "redundancy_inst.vh"
     .sl_external_cntl_26_0(sl_external_cntl_26_0[27*14-1:27*13]),
     .sl_external_cntl_30_28(sl_external_cntl_30_28[3*14-1:3*13]),
     .sl_external_cntl_57_32(sl_external_cntl_57_32[26*14-1:26*13]),

     .ms_external_cntl_4_0(ms_external_cntl_4_0[5*14-1:5*13]),
     .ms_external_cntl_65_8(ms_external_cntl_65_8[58*14-1:58*13]),

     .vccl_aib(vccl_aib),
     .vssl_aib(vssl_aib) );


aib_channel #(.DATAWIDTH(DATAWIDTH)) aib_channel14
 ( 
     .iopad_txdat(m2_ch2_aib[19:0]),
     .iopad_rxdat(m2_ch2_aib[39:20]),
     .iopad_txclkb(m2_ch2_aib[86]), 
     .iopad_txclk(m2_ch2_aib[87]),
     .iopad_tx_div2_clkb(m2_ch2_aib[55]),
     .iopad_tx_div2_clk(m2_ch2_aib[48]),
     .iopad_tx_div2_fck(m2_ch2_aib[53]),
     .iopad_tx_div2_fckb(m2_ch2_aib[54]),

     .iopad_txfck(m2_ch2_aib[41]), 
     .iopad_txfckb(m2_ch2_aib[40]),
     .iopad_stck(m2_ch2_aib[85]), 
     .iopad_stckb(m2_ch2_aib[84]),
     .iopad_stl(m2_ch2_aib[94]), 
     .iopad_std(m2_ch2_aib[95]),
     .iopad_rstno(m2_ch2_aib[49]), 
     .iopad_arstno(m2_ch2_aib[56]),
     .iopad_spareo(m2_ch2_aib[47]), 
     .iopad_sparee(m2_ch2_aib[46]),
     .iopad_rxclkb(m2_ch2_aib[59]), 
     .iopad_rxclk(m2_ch2_aib[57]),
     .iopad_rxfckb(m2_ch2_aib[42]), 
     .iopad_rxfck(m2_ch2_aib[43]),
     .iopad_srckb(m2_ch2_aib[82]), 
     .iopad_srck(m2_ch2_aib[83]),
     .iopad_srl(m2_ch2_aib[92]), 
     .iopad_srd(m2_ch2_aib[93]),
     .iopad_rstni(m2_ch2_aib[44]), 
     .iopad_arstni(m2_ch2_aib[65]),

     .tx_launch_clk(m_ns_fwd_clk[14]), //output data clock
     .tx_launch_div2_clk(m_ns_fwd_div2_clk[14]), //Newly added 11/09/20
     .ns_rvc_div2_clk_frmac(m_ns_rvc_div2_clk[14]), //Newly added 11/09/20
     .fs_rvc_clk_tomac(m_fs_rvc_clk[14]), 
     .fs_fwd_clk_tomac(m_fs_fwd_clk[14]), 
     .ns_rvc_clk_frmac(m_ns_rvc_clk[14]), 
     .iddren(iddren[14]),
     .idataselb(idataselb[14]), //output async data selection
     .itxen(itxen[14]), //data tx enable
     .irxen(irxen[3*15-1:3*14]),//data input enable
     .idat0(data_in0_ch[14]), //output data to pad
     .idat1(data_in1_ch[14]), //output data to pad
     .data_out0(data_out0_ch[14]), //input data from pad
     .data_out1(data_out1_ch[14]), //input data from pad

     .ms_config_done(ms_config_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[14]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[14]),
     .sl_config_done(sl_config_done),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[14]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[14]),
     .ms_tx_transfer_en(ms_tx_transfer_en[14]),
     .ms_rx_transfer_en(ms_rx_transfer_en[14]),
     .sl_tx_transfer_en(sl_tx_transfer_en[14]),
     .sl_rx_transfer_en(sl_rx_transfer_en[14]),
     .sr_ms_tomac(sr_ms_tomac[81*15-1:81*14]),
     .sr_sl_tomac(sr_sl_tomac[73*15-1:73*14]),

     .ms_adapter_rstn(ms_ns_adapter_rstn[14]),
     .sl_adapter_rstn(sl_ns_adapter_rstn[14]),
     .ms_rstn(ms_ns_mac_rdy[14]),
     .sl_rstn(sl_ns_mac_rdy[14]),
     .fs_mac_rdy_tomac(fs_mac_rdy[14]),
     .por_sl(m_power_on_reset_i),
     .ms_nsl(ms_nsl),
     .por_ms(por_ms),
     .osc_clk(osc_clk),

 `include "redundancy_inst.vh"
     .sl_external_cntl_26_0(sl_external_cntl_26_0[27*15-1:27*14]),
     .sl_external_cntl_30_28(sl_external_cntl_30_28[3*15-1:3*14]),
     .sl_external_cntl_57_32(sl_external_cntl_57_32[26*15-1:26*14]),

     .ms_external_cntl_4_0(ms_external_cntl_4_0[5*15-1:5*14]),
     .ms_external_cntl_65_8(ms_external_cntl_65_8[58*15-1:58*14]),

     .vccl_aib(vccl_aib),
     .vssl_aib(vssl_aib) );


aib_channel #(.DATAWIDTH(DATAWIDTH)) aib_channel15
 ( 
     .iopad_txdat(m2_ch3_aib[19:0]),
     .iopad_rxdat(m2_ch3_aib[39:20]),
     .iopad_txclkb(m2_ch3_aib[86]), 
     .iopad_txclk(m2_ch3_aib[87]),
     .iopad_tx_div2_clkb(m2_ch3_aib[55]),
     .iopad_tx_div2_clk(m2_ch3_aib[48]),
     .iopad_tx_div2_fck(m2_ch3_aib[53]),
     .iopad_tx_div2_fckb(m2_ch3_aib[54]),
     .iopad_txfck(m2_ch3_aib[41]), 
     .iopad_txfckb(m2_ch3_aib[40]),
     .iopad_stck(m2_ch3_aib[85]), 
     .iopad_stckb(m2_ch3_aib[84]),
     .iopad_stl(m2_ch3_aib[94]), 
     .iopad_std(m2_ch3_aib[95]),
     .iopad_rstno(m2_ch3_aib[49]), 
     .iopad_arstno(m2_ch3_aib[56]),
     .iopad_spareo(m2_ch3_aib[47]), 
     .iopad_sparee(m2_ch3_aib[46]),
     .iopad_rxclkb(m2_ch3_aib[59]), 
     .iopad_rxclk(m2_ch3_aib[57]),
     .iopad_rxfckb(m2_ch3_aib[42]), 
     .iopad_rxfck(m2_ch3_aib[43]),
     .iopad_srckb(m2_ch3_aib[82]), 
     .iopad_srck(m2_ch3_aib[83]),
     .iopad_srl(m2_ch3_aib[92]), 
     .iopad_srd(m2_ch3_aib[93]),
     .iopad_rstni(m2_ch3_aib[44]), 
     .iopad_arstni(m2_ch3_aib[65]),

     .tx_launch_clk(m_ns_fwd_clk[15]), //output data clock
     .tx_launch_div2_clk(m_ns_fwd_div2_clk[15]), //Newly added 11/09/20
     .ns_rvc_div2_clk_frmac(m_ns_rvc_div2_clk[15]), //Newly added 11/09/20
     .fs_rvc_clk_tomac(m_fs_rvc_clk[15]), 
     .fs_fwd_clk_tomac(m_fs_fwd_clk[15]), 
     .ns_rvc_clk_frmac(m_ns_rvc_clk[15]), 
     .iddren(iddren[15]),
     .idataselb(idataselb[15]), //output async data selection
     .itxen(itxen[15]), //data tx enable
     .irxen(irxen[3*16-1:3*15]),//data input enable
     .idat0(data_in0_ch[15]), //output data to pad
     .idat1(data_in1_ch[15]), //output data to pad
     .data_out0(data_out0_ch[15]), //input data from pad
     .data_out1(data_out1_ch[15]), //input data from pad

     .ms_config_done(ms_config_done),
     .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req[15]),
     .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req[15]),
     .sl_config_done(sl_config_done),
     .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[15]),
     .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[15]),
     .ms_tx_transfer_en(ms_tx_transfer_en[15]),
     .ms_rx_transfer_en(ms_rx_transfer_en[15]),
     .sl_tx_transfer_en(sl_tx_transfer_en[15]),
     .sl_rx_transfer_en(sl_rx_transfer_en[15]),
     .sr_ms_tomac(sr_ms_tomac[81*16-1:81*15]),
     .sr_sl_tomac(sr_sl_tomac[73*16-1:73*15]),

     .ms_adapter_rstn(ms_ns_adapter_rstn[15]),
     .sl_adapter_rstn(sl_ns_adapter_rstn[15]),
     .ms_rstn(ms_ns_mac_rdy[15]),
     .sl_rstn(sl_ns_mac_rdy[15]),
     .fs_mac_rdy_tomac(fs_mac_rdy[15]),
     .por_sl(m_power_on_reset_i),
     .ms_nsl(ms_nsl),
     .por_ms(por_ms),
     .osc_clk(osc_clk),

 `include "redundancy_inst.vh"
     .sl_external_cntl_26_0(sl_external_cntl_26_0[27*16-1:27*15]),
     .sl_external_cntl_30_28(sl_external_cntl_30_28[3*16-1:3*15]),
     .sl_external_cntl_57_32(sl_external_cntl_57_32[26*16-1:26*15]),

     .ms_external_cntl_4_0(ms_external_cntl_4_0[5*16-1:5*15]),
     .ms_external_cntl_65_8(ms_external_cntl_65_8[58*16-1:58*15]),

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
