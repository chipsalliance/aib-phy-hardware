// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//-----------------------------------------------------------------------------
// Copyright (C) 2018 Intel Corporation. .  Intel products are

//
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// Description: Top level MAIB wrapper which integrates 24 channels and aux
//
//
//---------------------------------------------------------------------------
module maib_top
  # (
     parameter TOTAL_CHNL_NUM = 24
     )
  (

//MAC data interface
input  wire [TOTAL_CHNL_NUM*80-1:0]  tx_parallel_data,     // This name mapped to quartus generated user interface signals. connect to pld_tx_fabric_data_in
output wire [TOTAL_CHNL_NUM*80-1:0]  rx_parallel_data,     // This name mapped to quartus generated user interface signals. connect to pld_rx_fabric_data_out
input  wire [TOTAL_CHNL_NUM-1:0]     tx_coreclkin, // This name mapped to quartus generated user interface signals.connect to pld_tx_clk1_dcm. Half of m_fs_fwd_clk 
output wire [TOTAL_CHNL_NUM-1:0]     tx_clkout, // This name mapped to quartus generated user interface signals.connect to pld_pcs_tx_clk_out1_dcm.
input  wire [TOTAL_CHNL_NUM-1:0]     rx_coreclkin, // This name mapped to quartus generated user interface signals.connect to pld_rx_clk1_dcm. 
                                  // Also connect to pld_pma_coreclkin_rowclk which go to iopad_ns_rcv_clk.
output wire [TOTAL_CHNL_NUM-1:0]     rx_clkout, // connect to pld_pcs_rx_clk_out1_dcm. 1GHz. Available to MAC. Half of m_fs_fwd_clk.
input  wire [TOTAL_CHNL_NUM-1:0]     m_ns_fwd_clk, // connect to pld_tx_clk2_dcm. This clock needs to be supplied if tx phase compensation fifo read clock
                                  // It is optional if FIFO read clock is from master.
output wire [TOTAL_CHNL_NUM-1:0]     m_fs_fwd_clk, // connect to pld_pcs_rx_clk_out2_dcm 

output wire [TOTAL_CHNL_NUM-1:0]     fs_mac_rdy,      //(use c3 pld_pma_clkdiv_rx_user pin). Drive by Master
input  wire [TOTAL_CHNL_NUM-1:0]     ns_mac_rdy,      //corresponding to nd pld_pma_rxpma_rstb. This signal should be high before ns_adapter_rstn go high.
input  wire [TOTAL_CHNL_NUM-1:0]     ns_adapter_rstn, //Reset Main adapter and pass over to the fs. 
input  wire                          config_done,     //This is csr_rdy_in

input  wire [TOTAL_CHNL_NUM-1:0]     sl_rx_dcc_dll_lock_req, //Drive reset statemachine at the farside
input  wire [TOTAL_CHNL_NUM-1:0]     sl_tx_dcc_dll_lock_req, //Drive reset statemachine at the farside


//**** ns ready status The following signals can be found from ms_sideband and sl_sideband. Listed explicitly for convinience***//
output wire [TOTAL_CHNL_NUM-1:0]     ms_osc_transfer_en,
output wire [TOTAL_CHNL_NUM-1:0]     ms_rx_transfer_en,
output wire [TOTAL_CHNL_NUM-1:0]     ms_tx_transfer_en,
output wire [TOTAL_CHNL_NUM-1:0]     sl_osc_transfer_en,
output wire [TOTAL_CHNL_NUM-1:0]     sl_rx_transfer_en,
output wire [TOTAL_CHNL_NUM-1:0]     sl_tx_transfer_en,

//Put MS to SL sideband signal and SL to MS sideband signal
output wire [TOTAL_CHNL_NUM*81-1:0]  ms_sideband,
output wire [TOTAL_CHNL_NUM*73-1:0]  sl_sideband,
//=================================================================================================
// AIB open source IP enhancement. The following ports are added to
// be compliance with AIB specification 1.1
//=================================================================================================
// Inout signals for AIB ubump
//
inout  [TOTAL_CHNL_NUM*20-1:0]       iopad_tx,
inout  [TOTAL_CHNL_NUM*20-1:0]       iopad_rx,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_ns_fwd_clkb,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_ns_fwd_clk,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_ns_fwd_div2_clkb,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_ns_fwd_div2_clk,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_fs_fwd_div2_clkb,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_fs_fwd_div2_clk,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_fs_fwd_clkb,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_fs_fwd_clk,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_fs_mac_rdy,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_ns_mac_rdy,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_ns_adapter_rstn,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_fs_rcv_clk,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_fs_rcv_clkb,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_fs_adapter_rstn,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_fs_sr_clkb,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_fs_sr_clk,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_ns_sr_clk,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_ns_sr_clkb,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_ns_rcv_clkb,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_ns_rcv_clk,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_fs_rcv_div2_clkb,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_fs_rcv_div2_clk,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_fs_sr_load,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_fs_sr_data,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_ns_sr_load,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_ns_sr_data,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_unused_aib45,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_unused_aib46,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_unused_aib47,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_unused_aib50,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_unused_aib51,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_unused_aib52,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_unused_aib58,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_unused_aib60,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_unused_aib61,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_unused_aib62,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_unused_aib63,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_unused_aib64,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_unused_aib66,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_unused_aib67,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_unused_aib68,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_unused_aib69,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_unused_aib70,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_unused_aib71,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_unused_aib72,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_unused_aib73,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_unused_aib74,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_unused_aib75,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_unused_aib76,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_unused_aib77,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_unused_aib78,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_unused_aib79,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_unused_aib80,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_unused_aib81,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_unused_aib88,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_unused_aib89,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_unused_aib90,
inout  [TOTAL_CHNL_NUM-1:0]          iopad_unused_aib91,

//Aux
inout  wire                          iopad_crdet,
inout  wire                          iopad_crdet_r,
inout  wire                          iopad_por,
inout  wire                          iopad_por_r,
input  wire                          m_power_on_reset,
input  wire                          m_device_detect_ovrd,
output wire                          m_device_detect 
);



     maib_ch u_maib_0 (
             .iopad_aib(           {  iopad_fs_sr_data[0],       iopad_fs_sr_load[0],       iopad_ns_sr_data[0],      iopad_ns_sr_load[0],   
                                    iopad_unused_aib91[0],     iopad_unused_aib90[0],     iopad_unused_aib89[0],    iopad_unused_aib88[0],   
                                      iopad_fs_rcv_clk[0],      iopad_fs_rcv_clkb[0],        iopad_fs_sr_clk[0],      iopad_fs_sr_clkb[0],   
                                       iopad_ns_sr_clk[0],       iopad_ns_sr_clkb[0],     iopad_unused_aib81[0],    iopad_unused_aib80[0],   
                                    iopad_unused_aib79[0],     iopad_unused_aib78[0],     iopad_unused_aib77[0],    iopad_unused_aib76[0],   
                                    iopad_unused_aib75[0],     iopad_unused_aib74[0],     iopad_unused_aib73[0],    iopad_unused_aib72[0],   
                                    iopad_unused_aib71[0],     iopad_unused_aib70[0],     iopad_unused_aib69[0],    iopad_unused_aib68[0],   
                                    iopad_unused_aib67[0],     iopad_unused_aib66[0],  iopad_ns_adapter_rstn[0],    iopad_unused_aib64[0],   
                                    iopad_unused_aib63[0],     iopad_unused_aib62[0],     iopad_unused_aib61[0],    iopad_unused_aib60[0],   
                                     iopad_ns_rcv_clkb[0],     iopad_unused_aib58[0],       iopad_ns_rcv_clk[0], iopad_fs_adapter_rstn[0],   
                                iopad_fs_rcv_div2_clkb[0], iopad_fs_fwd_div2_clkb[0],  iopad_fs_fwd_div2_clk[0],    iopad_unused_aib52[0],   
                                    iopad_unused_aib51[0],     iopad_unused_aib50[0],       iopad_fs_mac_rdy[0], iopad_fs_rcv_div2_clk[0],   
                                    iopad_unused_aib47[0],     iopad_unused_aib46[0],     iopad_unused_aib45[0],      iopad_ns_mac_rdy[0],   
                                      iopad_ns_fwd_clk[0],      iopad_ns_fwd_clkb[0],       iopad_fs_fwd_clk[0],     iopad_fs_fwd_clkb[0],   
                                           iopad_tx[19:0],         iopad_rx[19:0]}),
             .tx_parallel_data(tx_parallel_data[(80*(0+1)-1): 80*0]),     
             .rx_parallel_data(rx_parallel_data[(80*(0+1)-1): 80*0]),    
             .tx_coreclkin(tx_coreclkin[0]), 
             .tx_clkout(tx_clkout[0]), 
             .rx_coreclkin(rx_coreclkin[0]), 
                 
             .rx_clkout(rx_clkout[0]), 
             .m_ns_fwd_clk(m_ns_fwd_clk[0]), 
                  
             .m_fs_fwd_clk(m_fs_fwd_clk[0]),

             .fs_mac_rdy(fs_mac_rdy[0]),   
             .ns_mac_rdy(ns_mac_rdy[0]),  
             .ns_adapter_rstn(ns_adapter_rstn[0]),
             .config_done(config_done),   

             .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[0]), 
             .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[0]),

             .ms_osc_transfer_en(ms_osc_transfer_en[0]),
             .ms_rx_transfer_en(ms_rx_transfer_en[0]),
             .ms_tx_transfer_en(ms_tx_transfer_en[0]),
             .sl_osc_transfer_en(sl_osc_transfer_en[0]),
             .sl_rx_transfer_en(sl_rx_transfer_en[0]),
             .sl_tx_transfer_en(sl_tx_transfer_en[0]),

             .ms_sideband(ms_sideband[(81*(0+1)-1): 81*0]),
             .sl_sideband(sl_sideband[(73*(0+1)-1): 73*0])
             );

     maib_ch u_maib_1 (
             .iopad_aib(           {  iopad_fs_sr_data[1],       iopad_fs_sr_load[1],       iopad_ns_sr_data[1],      iopad_ns_sr_load[1],
                                    iopad_unused_aib91[1],     iopad_unused_aib90[1],     iopad_unused_aib89[1],    iopad_unused_aib88[1],
                                      iopad_fs_rcv_clk[1],      iopad_fs_rcv_clkb[1],        iopad_fs_sr_clk[1],      iopad_fs_sr_clkb[1],
                                       iopad_ns_sr_clk[1],       iopad_ns_sr_clkb[1],     iopad_unused_aib81[1],    iopad_unused_aib80[1],
                                    iopad_unused_aib79[1],     iopad_unused_aib78[1],     iopad_unused_aib77[1],    iopad_unused_aib76[1],
                                    iopad_unused_aib75[1],     iopad_unused_aib74[1],     iopad_unused_aib73[1],    iopad_unused_aib72[1],
                                    iopad_unused_aib71[1],     iopad_unused_aib70[1],     iopad_unused_aib69[1],    iopad_unused_aib68[1],
                                    iopad_unused_aib67[1],     iopad_unused_aib66[1],  iopad_ns_adapter_rstn[1],    iopad_unused_aib64[1],
                                    iopad_unused_aib63[1],     iopad_unused_aib62[1],     iopad_unused_aib61[1],    iopad_unused_aib60[1],
                                     iopad_ns_rcv_clkb[1],     iopad_unused_aib58[1],       iopad_ns_rcv_clk[1], iopad_fs_adapter_rstn[1],
                                iopad_fs_rcv_div2_clkb[1], iopad_fs_fwd_div2_clkb[1],  iopad_fs_fwd_div2_clk[1],    iopad_unused_aib52[1],
                                    iopad_unused_aib51[1],     iopad_unused_aib50[1],       iopad_fs_mac_rdy[1], iopad_fs_rcv_div2_clk[1],
                                    iopad_unused_aib47[1],     iopad_unused_aib46[1],     iopad_unused_aib45[1],      iopad_ns_mac_rdy[1],
                                      iopad_ns_fwd_clk[1],      iopad_ns_fwd_clkb[1],       iopad_fs_fwd_clk[1],     iopad_fs_fwd_clkb[1],
                                          iopad_tx[39:20],           iopad_rx[39:20]}),

             .tx_parallel_data(tx_parallel_data[(80*(1+1)-1): 80*1]),     
             .rx_parallel_data(rx_parallel_data[(80*(1+1)-1): 80*1]),    
             .tx_coreclkin(tx_coreclkin[1]), 
             .tx_clkout(tx_clkout[1]), 
             .rx_coreclkin(rx_coreclkin[1]), 
                 
             .rx_clkout(rx_clkout[1]), 
             .m_ns_fwd_clk(m_ns_fwd_clk[1]), 
                  
             .m_fs_fwd_clk(m_fs_fwd_clk[1]),

             .fs_mac_rdy(fs_mac_rdy[1]),   
             .ns_mac_rdy(ns_mac_rdy[1]),  
             .ns_adapter_rstn(ns_adapter_rstn[1]),
             .config_done(config_done),   

             .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[1]), 
             .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[1]),

             .ms_osc_transfer_en(ms_osc_transfer_en[1]),
             .ms_rx_transfer_en(ms_rx_transfer_en[1]),
             .ms_tx_transfer_en(ms_tx_transfer_en[1]),
             .sl_osc_transfer_en(sl_osc_transfer_en[1]),
             .sl_rx_transfer_en(sl_rx_transfer_en[1]),
             .sl_tx_transfer_en(sl_tx_transfer_en[1]),

             .ms_sideband(ms_sideband[(81*(1+1)-1): 81*1]),
             .sl_sideband(sl_sideband[(73*(1+1)-1): 73*1])
             );

     maib_ch u_maib_2 (
             .iopad_aib(           {  iopad_fs_sr_data[2],       iopad_fs_sr_load[2],       iopad_ns_sr_data[2],      iopad_ns_sr_load[2],
                                    iopad_unused_aib91[2],     iopad_unused_aib90[2],     iopad_unused_aib89[2],    iopad_unused_aib88[2],
                                      iopad_fs_rcv_clk[2],      iopad_fs_rcv_clkb[2],        iopad_fs_sr_clk[2],      iopad_fs_sr_clkb[2],
                                       iopad_ns_sr_clk[2],       iopad_ns_sr_clkb[2],     iopad_unused_aib81[2],    iopad_unused_aib80[2],
                                    iopad_unused_aib79[2],     iopad_unused_aib78[2],     iopad_unused_aib77[2],    iopad_unused_aib76[2],
                                    iopad_unused_aib75[2],     iopad_unused_aib74[2],     iopad_unused_aib73[2],    iopad_unused_aib72[2],
                                    iopad_unused_aib71[2],     iopad_unused_aib70[2],     iopad_unused_aib69[2],    iopad_unused_aib68[2],
                                    iopad_unused_aib67[2],     iopad_unused_aib66[2],  iopad_ns_adapter_rstn[2],    iopad_unused_aib64[2],
                                    iopad_unused_aib63[2],     iopad_unused_aib62[2],     iopad_unused_aib61[2],    iopad_unused_aib60[2],
                                     iopad_ns_rcv_clkb[2],     iopad_unused_aib58[2],       iopad_ns_rcv_clk[2], iopad_fs_adapter_rstn[2],
                                iopad_fs_rcv_div2_clkb[2], iopad_fs_fwd_div2_clkb[2],  iopad_fs_fwd_div2_clk[2],    iopad_unused_aib52[2],
                                    iopad_unused_aib51[2],     iopad_unused_aib50[2],       iopad_fs_mac_rdy[2], iopad_fs_rcv_div2_clk[2],
                                    iopad_unused_aib47[2],     iopad_unused_aib46[2],     iopad_unused_aib45[2],      iopad_ns_mac_rdy[2],
                                      iopad_ns_fwd_clk[2],      iopad_ns_fwd_clkb[2],       iopad_fs_fwd_clk[2],     iopad_fs_fwd_clkb[2],
                                          iopad_tx[59:40],           iopad_rx[59:40]}),
             .tx_parallel_data(tx_parallel_data[(80*(2+1)-1): 80*2]),     
             .rx_parallel_data(rx_parallel_data[(80*(2+1)-1): 80*2]),    
             .tx_coreclkin(tx_coreclkin[2]), 
             .tx_clkout(tx_clkout[2]), 
             .rx_coreclkin(rx_coreclkin[2]), 
                 
             .rx_clkout(rx_clkout[2]), 
             .m_ns_fwd_clk(m_ns_fwd_clk[2]), 
                  
             .m_fs_fwd_clk(m_fs_fwd_clk[2]),

             .fs_mac_rdy(fs_mac_rdy[2]),   
             .ns_mac_rdy(ns_mac_rdy[2]),  
             .ns_adapter_rstn(ns_adapter_rstn[2]),
             .config_done(config_done),   

             .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[2]), 
             .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[2]),

             .ms_osc_transfer_en(ms_osc_transfer_en[2]),
             .ms_rx_transfer_en(ms_rx_transfer_en[2]),
             .ms_tx_transfer_en(ms_tx_transfer_en[2]),
             .sl_osc_transfer_en(sl_osc_transfer_en[2]),
             .sl_rx_transfer_en(sl_rx_transfer_en[2]),
             .sl_tx_transfer_en(sl_tx_transfer_en[2]),

             .ms_sideband(ms_sideband[(81*(2+1)-1): 81*2]),
             .sl_sideband(sl_sideband[(73*(2+1)-1): 73*2])
             );

     maib_ch u_maib_3 (
             .iopad_aib(           {  iopad_fs_sr_data[3],       iopad_fs_sr_load[3],       iopad_ns_sr_data[3],      iopad_ns_sr_load[3],
                                    iopad_unused_aib91[3],     iopad_unused_aib90[3],     iopad_unused_aib89[3],    iopad_unused_aib88[3],
                                      iopad_fs_rcv_clk[3],      iopad_fs_rcv_clkb[3],        iopad_fs_sr_clk[3],      iopad_fs_sr_clkb[3],
                                       iopad_ns_sr_clk[3],       iopad_ns_sr_clkb[3],     iopad_unused_aib81[3],    iopad_unused_aib80[3],
                                    iopad_unused_aib79[3],     iopad_unused_aib78[3],     iopad_unused_aib77[3],    iopad_unused_aib76[3],
                                    iopad_unused_aib75[3],     iopad_unused_aib74[3],     iopad_unused_aib73[3],    iopad_unused_aib72[3],
                                    iopad_unused_aib71[3],     iopad_unused_aib70[3],     iopad_unused_aib69[3],    iopad_unused_aib68[3],
                                    iopad_unused_aib67[3],     iopad_unused_aib66[3],  iopad_ns_adapter_rstn[3],    iopad_unused_aib64[3],
                                    iopad_unused_aib63[3],     iopad_unused_aib62[3],     iopad_unused_aib61[3],    iopad_unused_aib60[3],
                                     iopad_ns_rcv_clkb[3],     iopad_unused_aib58[3],       iopad_ns_rcv_clk[3], iopad_fs_adapter_rstn[3],
                                iopad_fs_rcv_div2_clkb[3], iopad_fs_fwd_div2_clkb[3],  iopad_fs_fwd_div2_clk[3],    iopad_unused_aib52[3],
                                    iopad_unused_aib51[3],     iopad_unused_aib50[3],       iopad_fs_mac_rdy[3], iopad_fs_rcv_div2_clk[3],
                                    iopad_unused_aib47[3],     iopad_unused_aib46[3],     iopad_unused_aib45[3],      iopad_ns_mac_rdy[3],
                                      iopad_ns_fwd_clk[3],      iopad_ns_fwd_clkb[3],       iopad_fs_fwd_clk[3],     iopad_fs_fwd_clkb[3],
                                          iopad_tx[79:60],           iopad_rx[79:60]}),

             .tx_parallel_data(tx_parallel_data[(80*(3+1)-1): 80*3]),     
             .rx_parallel_data(rx_parallel_data[(80*(3+1)-1): 80*3]),    
             .tx_coreclkin(tx_coreclkin[3]), 
             .tx_clkout(tx_clkout[3]), 
             .rx_coreclkin(rx_coreclkin[3]), 
                 
             .rx_clkout(rx_clkout[3]), 
             .m_ns_fwd_clk(m_ns_fwd_clk[3]), 
                  
             .m_fs_fwd_clk(m_fs_fwd_clk[3]),

             .fs_mac_rdy(fs_mac_rdy[3]),   
             .ns_mac_rdy(ns_mac_rdy[3]),  
             .ns_adapter_rstn(ns_adapter_rstn[3]),
             .config_done(config_done),   

             .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[3]), 
             .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[3]),

             .ms_osc_transfer_en(ms_osc_transfer_en[3]),
             .ms_rx_transfer_en(ms_rx_transfer_en[3]),
             .ms_tx_transfer_en(ms_tx_transfer_en[3]),
             .sl_osc_transfer_en(sl_osc_transfer_en[3]),
             .sl_rx_transfer_en(sl_rx_transfer_en[3]),
             .sl_tx_transfer_en(sl_tx_transfer_en[3]),

             .ms_sideband(ms_sideband[(81*(3+1)-1): 81*3]),
             .sl_sideband(sl_sideband[(73*(3+1)-1): 73*3])
             );

     maib_ch u_maib_4 (
             .iopad_aib(           {  iopad_fs_sr_data[4],       iopad_fs_sr_load[4],       iopad_ns_sr_data[4],      iopad_ns_sr_load[4],
                                    iopad_unused_aib91[4],     iopad_unused_aib90[4],     iopad_unused_aib89[4],    iopad_unused_aib88[4],
                                      iopad_fs_rcv_clk[4],      iopad_fs_rcv_clkb[4],        iopad_fs_sr_clk[4],      iopad_fs_sr_clkb[4],
                                       iopad_ns_sr_clk[4],       iopad_ns_sr_clkb[4],     iopad_unused_aib81[4],    iopad_unused_aib80[4],
                                    iopad_unused_aib79[4],     iopad_unused_aib78[4],     iopad_unused_aib77[4],    iopad_unused_aib76[4],
                                    iopad_unused_aib75[4],     iopad_unused_aib74[4],     iopad_unused_aib73[4],    iopad_unused_aib72[4],
                                    iopad_unused_aib71[4],     iopad_unused_aib70[4],     iopad_unused_aib69[4],    iopad_unused_aib68[4],
                                    iopad_unused_aib67[4],     iopad_unused_aib66[4],  iopad_ns_adapter_rstn[4],    iopad_unused_aib64[4],
                                    iopad_unused_aib63[4],     iopad_unused_aib62[4],     iopad_unused_aib61[4],    iopad_unused_aib60[4],
                                     iopad_ns_rcv_clkb[4],     iopad_unused_aib58[4],       iopad_ns_rcv_clk[4], iopad_fs_adapter_rstn[4],
                                iopad_fs_rcv_div2_clkb[4], iopad_fs_fwd_div2_clkb[4],  iopad_fs_fwd_div2_clk[4],    iopad_unused_aib52[4],
                                    iopad_unused_aib51[4],     iopad_unused_aib50[4],       iopad_fs_mac_rdy[4], iopad_fs_rcv_div2_clk[4],
                                    iopad_unused_aib47[4],     iopad_unused_aib46[4],     iopad_unused_aib45[4],      iopad_ns_mac_rdy[4],
                                      iopad_ns_fwd_clk[4],      iopad_ns_fwd_clkb[4],       iopad_fs_fwd_clk[4],     iopad_fs_fwd_clkb[4],
                                          iopad_tx[99:80],           iopad_rx[99:80]}),
             .tx_parallel_data(tx_parallel_data[(80*(4+1)-1): 80*4]),     
             .rx_parallel_data(rx_parallel_data[(80*(4+1)-1): 80*4]),    
             .tx_coreclkin(tx_coreclkin[4]), 
             .tx_clkout(tx_clkout[4]), 
             .rx_coreclkin(rx_coreclkin[4]), 
                 
             .rx_clkout(rx_clkout[4]), 
             .m_ns_fwd_clk(m_ns_fwd_clk[4]), 
                  
             .m_fs_fwd_clk(m_fs_fwd_clk[4]),

             .fs_mac_rdy(fs_mac_rdy[4]),   
             .ns_mac_rdy(ns_mac_rdy[4]),  
             .ns_adapter_rstn(ns_adapter_rstn[4]),
             .config_done(config_done),   

             .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[4]), 
             .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[4]),

             .ms_osc_transfer_en(ms_osc_transfer_en[4]),
             .ms_rx_transfer_en(ms_rx_transfer_en[4]),
             .ms_tx_transfer_en(ms_tx_transfer_en[4]),
             .sl_osc_transfer_en(sl_osc_transfer_en[4]),
             .sl_rx_transfer_en(sl_rx_transfer_en[4]),
             .sl_tx_transfer_en(sl_tx_transfer_en[4]),

             .ms_sideband(ms_sideband[(81*(4+1)-1): 81*4]),
             .sl_sideband(sl_sideband[(73*(4+1)-1): 73*4])
             );

     maib_ch u_maib_5 (
             .iopad_aib(           {  iopad_fs_sr_data[5],       iopad_fs_sr_load[5],       iopad_ns_sr_data[5],      iopad_ns_sr_load[5],
                                    iopad_unused_aib91[5],     iopad_unused_aib90[5],     iopad_unused_aib89[5],    iopad_unused_aib88[5],
                                      iopad_fs_rcv_clk[5],      iopad_fs_rcv_clkb[5],        iopad_fs_sr_clk[5],      iopad_fs_sr_clkb[5],
                                       iopad_ns_sr_clk[5],       iopad_ns_sr_clkb[5],     iopad_unused_aib81[5],    iopad_unused_aib80[5],
                                    iopad_unused_aib79[5],     iopad_unused_aib78[5],     iopad_unused_aib77[5],    iopad_unused_aib76[5],
                                    iopad_unused_aib75[5],     iopad_unused_aib74[5],     iopad_unused_aib73[5],    iopad_unused_aib72[5],
                                    iopad_unused_aib71[5],     iopad_unused_aib70[5],     iopad_unused_aib69[5],    iopad_unused_aib68[5],
                                    iopad_unused_aib67[5],     iopad_unused_aib66[5],  iopad_ns_adapter_rstn[5],    iopad_unused_aib64[5],
                                    iopad_unused_aib63[5],     iopad_unused_aib62[5],     iopad_unused_aib61[5],    iopad_unused_aib60[5],
                                     iopad_ns_rcv_clkb[5],     iopad_unused_aib58[5],       iopad_ns_rcv_clk[5], iopad_fs_adapter_rstn[5],
                                iopad_fs_rcv_div2_clkb[5], iopad_fs_fwd_div2_clkb[5],  iopad_fs_fwd_div2_clk[5],    iopad_unused_aib52[5],
                                    iopad_unused_aib51[5],     iopad_unused_aib50[5],       iopad_fs_mac_rdy[5], iopad_fs_rcv_div2_clk[5],
                                    iopad_unused_aib47[5],     iopad_unused_aib46[5],     iopad_unused_aib45[5],      iopad_ns_mac_rdy[5],
                                      iopad_ns_fwd_clk[5],      iopad_ns_fwd_clkb[5],       iopad_fs_fwd_clk[5],     iopad_fs_fwd_clkb[5],
                                        iopad_tx[119:100],         iopad_rx[119:100]}),

             .tx_parallel_data(tx_parallel_data[(80*(5+1)-1): 80*5]),     
             .rx_parallel_data(rx_parallel_data[(80*(5+1)-1): 80*5]),    
             .tx_coreclkin(tx_coreclkin[5]), 
             .tx_clkout(tx_clkout[5]), 
             .rx_coreclkin(rx_coreclkin[5]), 
                 
             .rx_clkout(rx_clkout[5]), 
             .m_ns_fwd_clk(m_ns_fwd_clk[5]), 
                  
             .m_fs_fwd_clk(m_fs_fwd_clk[5]),

             .fs_mac_rdy(fs_mac_rdy[5]),   
             .ns_mac_rdy(ns_mac_rdy[5]),  
             .ns_adapter_rstn(ns_adapter_rstn[5]),
             .config_done(config_done),   

             .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[5]), 
             .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[5]),

             .ms_osc_transfer_en(ms_osc_transfer_en[5]),
             .ms_rx_transfer_en(ms_rx_transfer_en[5]),
             .ms_tx_transfer_en(ms_tx_transfer_en[5]),
             .sl_osc_transfer_en(sl_osc_transfer_en[5]),
             .sl_rx_transfer_en(sl_rx_transfer_en[5]),
             .sl_tx_transfer_en(sl_tx_transfer_en[5]),

             .ms_sideband(ms_sideband[(81*(5+1)-1): 81*5]),
             .sl_sideband(sl_sideband[(73*(5+1)-1): 73*5])
             );

     maib_ch u_maib_6 (
             .iopad_aib(           {  iopad_fs_sr_data[6],       iopad_fs_sr_load[6],       iopad_ns_sr_data[6],      iopad_ns_sr_load[6],   
                                    iopad_unused_aib91[6],     iopad_unused_aib90[6],     iopad_unused_aib89[6],    iopad_unused_aib88[6],  
                                      iopad_fs_rcv_clk[6],      iopad_fs_rcv_clkb[6],        iopad_fs_sr_clk[6],      iopad_fs_sr_clkb[6], 
                                       iopad_ns_sr_clk[6],       iopad_ns_sr_clkb[6],     iopad_unused_aib81[6],    iopad_unused_aib80[6], 
                                    iopad_unused_aib79[6],     iopad_unused_aib78[6],     iopad_unused_aib77[6],    iopad_unused_aib76[6], 
                                    iopad_unused_aib75[6],     iopad_unused_aib74[6],     iopad_unused_aib73[6],    iopad_unused_aib72[6], 
                                    iopad_unused_aib71[6],     iopad_unused_aib70[6],     iopad_unused_aib69[6],    iopad_unused_aib68[6], 
                                    iopad_unused_aib67[6],     iopad_unused_aib66[6],  iopad_ns_adapter_rstn[6],    iopad_unused_aib64[6], 
                                    iopad_unused_aib63[6],     iopad_unused_aib62[6],     iopad_unused_aib61[6],    iopad_unused_aib60[6], 
                                     iopad_ns_rcv_clkb[6],     iopad_unused_aib58[6],       iopad_ns_rcv_clk[6], iopad_fs_adapter_rstn[6], 
                                iopad_fs_rcv_div2_clkb[6], iopad_fs_fwd_div2_clkb[6],  iopad_fs_fwd_div2_clk[6],    iopad_unused_aib52[6], 
                                    iopad_unused_aib51[6],     iopad_unused_aib50[6],       iopad_fs_mac_rdy[6], iopad_fs_rcv_div2_clk[6], 
                                    iopad_unused_aib47[6],     iopad_unused_aib46[6],     iopad_unused_aib45[6],      iopad_ns_mac_rdy[6], 
                                      iopad_ns_fwd_clk[6],      iopad_ns_fwd_clkb[6],       iopad_fs_fwd_clk[6],     iopad_fs_fwd_clkb[6], 
                                        iopad_tx[139:120],         iopad_rx[139:120]}),

             .tx_parallel_data(tx_parallel_data[(80*(6+1)-1): 80*6]),     
             .rx_parallel_data(rx_parallel_data[(80*(6+1)-1): 80*6]),    
             .tx_coreclkin(tx_coreclkin[6]), 
             .tx_clkout(tx_clkout[6]), 
             .rx_coreclkin(rx_coreclkin[6]), 
                 
             .rx_clkout(rx_clkout[6]), 
             .m_ns_fwd_clk(m_ns_fwd_clk[6]), 
                  
             .m_fs_fwd_clk(m_fs_fwd_clk[6]),

             .fs_mac_rdy(fs_mac_rdy[6]),   
             .ns_mac_rdy(ns_mac_rdy[6]),  
             .ns_adapter_rstn(ns_adapter_rstn[6]),
             .config_done(config_done),   

             .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[6]), 
             .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[6]),

             .ms_osc_transfer_en(ms_osc_transfer_en[6]),
             .ms_rx_transfer_en(ms_rx_transfer_en[6]),
             .ms_tx_transfer_en(ms_tx_transfer_en[6]),
             .sl_osc_transfer_en(sl_osc_transfer_en[6]),
             .sl_rx_transfer_en(sl_rx_transfer_en[6]),
             .sl_tx_transfer_en(sl_tx_transfer_en[6]),

             .ms_sideband(ms_sideband[(81*(6+1)-1): 81*6]),
             .sl_sideband(sl_sideband[(73*(6+1)-1): 73*6])
             );

     maib_ch u_maib_7 (
             .iopad_aib(           {  iopad_fs_sr_data[7],       iopad_fs_sr_load[7],       iopad_ns_sr_data[7],      iopad_ns_sr_load[7],   
                                    iopad_unused_aib91[7],     iopad_unused_aib90[7],     iopad_unused_aib89[7],    iopad_unused_aib88[7],  
                                      iopad_fs_rcv_clk[7],      iopad_fs_rcv_clkb[7],        iopad_fs_sr_clk[7],      iopad_fs_sr_clkb[7], 
                                       iopad_ns_sr_clk[7],       iopad_ns_sr_clkb[7],     iopad_unused_aib81[7],    iopad_unused_aib80[7], 
                                    iopad_unused_aib79[7],     iopad_unused_aib78[7],     iopad_unused_aib77[7],    iopad_unused_aib76[7], 
                                    iopad_unused_aib75[7],     iopad_unused_aib74[7],     iopad_unused_aib73[7],    iopad_unused_aib72[7], 
                                    iopad_unused_aib71[7],     iopad_unused_aib70[7],     iopad_unused_aib69[7],    iopad_unused_aib68[7], 
                                    iopad_unused_aib67[7],     iopad_unused_aib66[7],  iopad_ns_adapter_rstn[7],    iopad_unused_aib64[7], 
                                    iopad_unused_aib63[7],     iopad_unused_aib62[7],     iopad_unused_aib61[7],    iopad_unused_aib60[7], 
                                     iopad_ns_rcv_clkb[7],     iopad_unused_aib58[7],       iopad_ns_rcv_clk[7], iopad_fs_adapter_rstn[7], 
                                iopad_fs_rcv_div2_clkb[7], iopad_fs_fwd_div2_clkb[7],  iopad_fs_fwd_div2_clk[7],    iopad_unused_aib52[7], 
                                    iopad_unused_aib51[7],     iopad_unused_aib50[7],       iopad_fs_mac_rdy[7], iopad_fs_rcv_div2_clk[7], 
                                    iopad_unused_aib47[7],     iopad_unused_aib46[7],     iopad_unused_aib45[7],      iopad_ns_mac_rdy[7], 
                                      iopad_ns_fwd_clk[7],      iopad_ns_fwd_clkb[7],       iopad_fs_fwd_clk[7],     iopad_fs_fwd_clkb[7], 
                                        iopad_tx[159:140],         iopad_rx[159:140]}),

             .tx_parallel_data(tx_parallel_data[(80*(7+1)-1): 80*7]),     
             .rx_parallel_data(rx_parallel_data[(80*(7+1)-1): 80*7]),    
             .tx_coreclkin(tx_coreclkin[7]), 
             .tx_clkout(tx_clkout[7]), 
             .rx_coreclkin(rx_coreclkin[7]), 
                 
             .rx_clkout(rx_clkout[7]), 
             .m_ns_fwd_clk(m_ns_fwd_clk[7]), 
                  
             .m_fs_fwd_clk(m_fs_fwd_clk[7]),

             .fs_mac_rdy(fs_mac_rdy[7]),   
             .ns_mac_rdy(ns_mac_rdy[7]),  
             .ns_adapter_rstn(ns_adapter_rstn[7]),
             .config_done(config_done),   

             .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[7]), 
             .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[7]),

             .ms_osc_transfer_en(ms_osc_transfer_en[7]),
             .ms_rx_transfer_en(ms_rx_transfer_en[7]),
             .ms_tx_transfer_en(ms_tx_transfer_en[7]),
             .sl_osc_transfer_en(sl_osc_transfer_en[7]),
             .sl_rx_transfer_en(sl_rx_transfer_en[7]),
             .sl_tx_transfer_en(sl_tx_transfer_en[7]),

             .ms_sideband(ms_sideband[(81*(7+1)-1): 81*7]),
             .sl_sideband(sl_sideband[(73*(7+1)-1): 73*7])
             );

     maib_ch u_maib_8 (
             .iopad_aib(           {  iopad_fs_sr_data[8],       iopad_fs_sr_load[8],       iopad_ns_sr_data[8],      iopad_ns_sr_load[8],   
                                    iopad_unused_aib91[8],     iopad_unused_aib90[8],     iopad_unused_aib89[8],    iopad_unused_aib88[8],  
                                      iopad_fs_rcv_clk[8],      iopad_fs_rcv_clkb[8],        iopad_fs_sr_clk[8],      iopad_fs_sr_clkb[8], 
                                       iopad_ns_sr_clk[8],       iopad_ns_sr_clkb[8],     iopad_unused_aib81[8],    iopad_unused_aib80[8], 
                                    iopad_unused_aib79[8],     iopad_unused_aib78[8],     iopad_unused_aib77[8],    iopad_unused_aib76[8], 
                                    iopad_unused_aib75[8],     iopad_unused_aib74[8],     iopad_unused_aib73[8],    iopad_unused_aib72[8], 
                                    iopad_unused_aib71[8],     iopad_unused_aib70[8],     iopad_unused_aib69[8],    iopad_unused_aib68[8], 
                                    iopad_unused_aib67[8],     iopad_unused_aib66[8],  iopad_ns_adapter_rstn[8],    iopad_unused_aib64[8], 
                                    iopad_unused_aib63[8],     iopad_unused_aib62[8],     iopad_unused_aib61[8],    iopad_unused_aib60[8], 
                                     iopad_ns_rcv_clkb[8],     iopad_unused_aib58[8],       iopad_ns_rcv_clk[8], iopad_fs_adapter_rstn[8], 
                                iopad_fs_rcv_div2_clkb[8], iopad_fs_fwd_div2_clkb[8],  iopad_fs_fwd_div2_clk[8],    iopad_unused_aib52[8], 
                                    iopad_unused_aib51[8],     iopad_unused_aib50[8],       iopad_fs_mac_rdy[8], iopad_fs_rcv_div2_clk[8], 
                                    iopad_unused_aib47[8],     iopad_unused_aib46[8],     iopad_unused_aib45[8],      iopad_ns_mac_rdy[8], 
                                      iopad_ns_fwd_clk[8],      iopad_ns_fwd_clkb[8],       iopad_fs_fwd_clk[8],     iopad_fs_fwd_clkb[8], 
                                        iopad_tx[179:160],         iopad_rx[179:160]}),

             .tx_parallel_data(tx_parallel_data[(80*(8+1)-1): 80*8]),     
             .rx_parallel_data(rx_parallel_data[(80*(8+1)-1): 80*8]),    
             .tx_coreclkin(tx_coreclkin[8]), 
             .tx_clkout(tx_clkout[8]), 
             .rx_coreclkin(rx_coreclkin[8]), 
                 
             .rx_clkout(rx_clkout[8]), 
             .m_ns_fwd_clk(m_ns_fwd_clk[8]), 
                  
             .m_fs_fwd_clk(m_fs_fwd_clk[8]),

             .fs_mac_rdy(fs_mac_rdy[8]),   
             .ns_mac_rdy(ns_mac_rdy[8]),  
             .ns_adapter_rstn(ns_adapter_rstn[8]),
             .config_done(config_done),   

             .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[8]), 
             .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[8]),

             .ms_osc_transfer_en(ms_osc_transfer_en[8]),
             .ms_rx_transfer_en(ms_rx_transfer_en[8]),
             .ms_tx_transfer_en(ms_tx_transfer_en[8]),
             .sl_osc_transfer_en(sl_osc_transfer_en[8]),
             .sl_rx_transfer_en(sl_rx_transfer_en[8]),
             .sl_tx_transfer_en(sl_tx_transfer_en[8]),

             .ms_sideband(ms_sideband[(81*(8+1)-1): 81*8]),
             .sl_sideband(sl_sideband[(73*(8+1)-1): 73*8])
             );

     maib_ch u_maib_9 (
             .iopad_aib(           {  iopad_fs_sr_data[9],       iopad_fs_sr_load[9],       iopad_ns_sr_data[9],      iopad_ns_sr_load[9],   
                                    iopad_unused_aib91[9],     iopad_unused_aib90[9],     iopad_unused_aib89[9],    iopad_unused_aib88[9],  
                                      iopad_fs_rcv_clk[9],      iopad_fs_rcv_clkb[9],        iopad_fs_sr_clk[9],      iopad_fs_sr_clkb[9], 
                                       iopad_ns_sr_clk[9],       iopad_ns_sr_clkb[9],     iopad_unused_aib81[9],    iopad_unused_aib80[9], 
                                    iopad_unused_aib79[9],     iopad_unused_aib78[9],     iopad_unused_aib77[9],    iopad_unused_aib76[9], 
                                    iopad_unused_aib75[9],     iopad_unused_aib74[9],     iopad_unused_aib73[9],    iopad_unused_aib72[9], 
                                    iopad_unused_aib71[9],     iopad_unused_aib70[9],     iopad_unused_aib69[9],    iopad_unused_aib68[9], 
                                    iopad_unused_aib67[9],     iopad_unused_aib66[9],  iopad_ns_adapter_rstn[9],    iopad_unused_aib64[9], 
                                    iopad_unused_aib63[9],     iopad_unused_aib62[9],     iopad_unused_aib61[9],    iopad_unused_aib60[9], 
                                     iopad_ns_rcv_clkb[9],     iopad_unused_aib58[9],       iopad_ns_rcv_clk[9], iopad_fs_adapter_rstn[9], 
                                iopad_fs_rcv_div2_clkb[9], iopad_fs_fwd_div2_clkb[9],  iopad_fs_fwd_div2_clk[9],    iopad_unused_aib52[9], 
                                    iopad_unused_aib51[9],     iopad_unused_aib50[9],       iopad_fs_mac_rdy[9], iopad_fs_rcv_div2_clk[9], 
                                    iopad_unused_aib47[9],     iopad_unused_aib46[9],     iopad_unused_aib45[9],      iopad_ns_mac_rdy[9], 
                                      iopad_ns_fwd_clk[9],      iopad_ns_fwd_clkb[9],       iopad_fs_fwd_clk[9],     iopad_fs_fwd_clkb[9], 
                                        iopad_tx[199:180],         iopad_rx[199:180]}), 

             .tx_parallel_data(tx_parallel_data[(80*(9+1)-1): 80*9]),     
             .rx_parallel_data(rx_parallel_data[(80*(9+1)-1): 80*9]),    
             .tx_coreclkin(tx_coreclkin[9]), 
             .tx_clkout(tx_clkout[9]), 
             .rx_coreclkin(rx_coreclkin[9]), 
                 
             .rx_clkout(rx_clkout[9]), 
             .m_ns_fwd_clk(m_ns_fwd_clk[9]), 
                  
             .m_fs_fwd_clk(m_fs_fwd_clk[9]),

             .fs_mac_rdy(fs_mac_rdy[9]),   
             .ns_mac_rdy(ns_mac_rdy[9]),  
             .ns_adapter_rstn(ns_adapter_rstn[9]),
             .config_done(config_done),   

             .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[9]), 
             .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[9]),

             .ms_osc_transfer_en(ms_osc_transfer_en[9]),
             .ms_rx_transfer_en(ms_rx_transfer_en[9]),
             .ms_tx_transfer_en(ms_tx_transfer_en[9]),
             .sl_osc_transfer_en(sl_osc_transfer_en[9]),
             .sl_rx_transfer_en(sl_rx_transfer_en[9]),
             .sl_tx_transfer_en(sl_tx_transfer_en[9]),

             .ms_sideband(ms_sideband[(81*(9+1)-1): 81*9]),
             .sl_sideband(sl_sideband[(73*(9+1)-1): 73*9])
             );

     maib_ch u_maib_10 (
             .iopad_aib(           {  iopad_fs_sr_data[10],       iopad_fs_sr_load[10],       iopad_ns_sr_data[10],      iopad_ns_sr_load[10],   
                                    iopad_unused_aib91[10],     iopad_unused_aib90[10],     iopad_unused_aib89[10],    iopad_unused_aib88[10],  
                                      iopad_fs_rcv_clk[10],      iopad_fs_rcv_clkb[10],        iopad_fs_sr_clk[10],      iopad_fs_sr_clkb[10], 
                                       iopad_ns_sr_clk[10],       iopad_ns_sr_clkb[10],     iopad_unused_aib81[10],    iopad_unused_aib80[10], 
                                    iopad_unused_aib79[10],     iopad_unused_aib78[10],     iopad_unused_aib77[10],    iopad_unused_aib76[10], 
                                    iopad_unused_aib75[10],     iopad_unused_aib74[10],     iopad_unused_aib73[10],    iopad_unused_aib72[10], 
                                    iopad_unused_aib71[10],     iopad_unused_aib70[10],     iopad_unused_aib69[10],    iopad_unused_aib68[10], 
                                    iopad_unused_aib67[10],     iopad_unused_aib66[10],  iopad_ns_adapter_rstn[10],    iopad_unused_aib64[10], 
                                    iopad_unused_aib63[10],     iopad_unused_aib62[10],     iopad_unused_aib61[10],    iopad_unused_aib60[10], 
                                     iopad_ns_rcv_clkb[10],     iopad_unused_aib58[10],       iopad_ns_rcv_clk[10], iopad_fs_adapter_rstn[10], 
                                iopad_fs_rcv_div2_clkb[10], iopad_fs_fwd_div2_clkb[10],  iopad_fs_fwd_div2_clk[10],    iopad_unused_aib52[10], 
                                    iopad_unused_aib51[10],     iopad_unused_aib50[10],       iopad_fs_mac_rdy[10], iopad_fs_rcv_div2_clk[10], 
                                    iopad_unused_aib47[10],     iopad_unused_aib46[10],     iopad_unused_aib45[10],      iopad_ns_mac_rdy[10], 
                                      iopad_ns_fwd_clk[10],      iopad_ns_fwd_clkb[10],       iopad_fs_fwd_clk[10],     iopad_fs_fwd_clkb[10], 
                                         iopad_tx[219:200],          iopad_rx[219:200]}), 

             .tx_parallel_data(tx_parallel_data[(80*(10+1)-1): 80*10]),     
             .rx_parallel_data(rx_parallel_data[(80*(10+1)-1): 80*10]),    
             .tx_coreclkin(tx_coreclkin[10]), 
             .tx_clkout(tx_clkout[10]), 
             .rx_coreclkin(rx_coreclkin[10]), 
                 
             .rx_clkout(rx_clkout[10]), 
             .m_ns_fwd_clk(m_ns_fwd_clk[10]), 
                  
             .m_fs_fwd_clk(m_fs_fwd_clk[10]),

             .fs_mac_rdy(fs_mac_rdy[10]),   
             .ns_mac_rdy(ns_mac_rdy[10]),  
             .ns_adapter_rstn(ns_adapter_rstn[10]),
             .config_done(config_done),   

             .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[10]), 
             .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[10]),

             .ms_osc_transfer_en(ms_osc_transfer_en[10]),
             .ms_rx_transfer_en(ms_rx_transfer_en[10]),
             .ms_tx_transfer_en(ms_tx_transfer_en[10]),
             .sl_osc_transfer_en(sl_osc_transfer_en[10]),
             .sl_rx_transfer_en(sl_rx_transfer_en[10]),
             .sl_tx_transfer_en(sl_tx_transfer_en[10]),

             .ms_sideband(ms_sideband[(81*(10+1)-1): 81*10]),
             .sl_sideband(sl_sideband[(73*(10+1)-1): 73*10])
             );

     maib_ch u_maib_11 (
             .iopad_aib(           {  iopad_fs_sr_data[11],       iopad_fs_sr_load[11],       iopad_ns_sr_data[11],      iopad_ns_sr_load[11],   
                                    iopad_unused_aib91[11],     iopad_unused_aib90[11],     iopad_unused_aib89[11],    iopad_unused_aib88[11],  
                                      iopad_fs_rcv_clk[11],      iopad_fs_rcv_clkb[11],        iopad_fs_sr_clk[11],      iopad_fs_sr_clkb[11], 
                                       iopad_ns_sr_clk[11],       iopad_ns_sr_clkb[11],     iopad_unused_aib81[11],    iopad_unused_aib80[11], 
                                    iopad_unused_aib79[11],     iopad_unused_aib78[11],     iopad_unused_aib77[11],    iopad_unused_aib76[11], 
                                    iopad_unused_aib75[11],     iopad_unused_aib74[11],     iopad_unused_aib73[11],    iopad_unused_aib72[11], 
                                    iopad_unused_aib71[11],     iopad_unused_aib70[11],     iopad_unused_aib69[11],    iopad_unused_aib68[11], 
                                    iopad_unused_aib67[11],     iopad_unused_aib66[11],  iopad_ns_adapter_rstn[11],    iopad_unused_aib64[11], 
                                    iopad_unused_aib63[11],     iopad_unused_aib62[11],     iopad_unused_aib61[11],    iopad_unused_aib60[11], 
                                     iopad_ns_rcv_clkb[11],     iopad_unused_aib58[11],       iopad_ns_rcv_clk[11], iopad_fs_adapter_rstn[11], 
                                iopad_fs_rcv_div2_clkb[11], iopad_fs_fwd_div2_clkb[11],  iopad_fs_fwd_div2_clk[11],    iopad_unused_aib52[11], 
                                    iopad_unused_aib51[11],     iopad_unused_aib50[11],       iopad_fs_mac_rdy[11], iopad_fs_rcv_div2_clk[11], 
                                    iopad_unused_aib47[11],     iopad_unused_aib46[11],     iopad_unused_aib45[11],      iopad_ns_mac_rdy[11], 
                                      iopad_ns_fwd_clk[11],      iopad_ns_fwd_clkb[11],       iopad_fs_fwd_clk[11],     iopad_fs_fwd_clkb[11], 
                                         iopad_tx[239:220],          iopad_rx[239:220]}), 

             .tx_parallel_data(tx_parallel_data[(80*(11+1)-1): 80*11]),     
             .rx_parallel_data(rx_parallel_data[(80*(11+1)-1): 80*11]),    
             .tx_coreclkin(tx_coreclkin[11]), 
             .tx_clkout(tx_clkout[11]), 
             .rx_coreclkin(rx_coreclkin[11]), 
                 
             .rx_clkout(rx_clkout[11]), 
             .m_ns_fwd_clk(m_ns_fwd_clk[11]), 
                  
             .m_fs_fwd_clk(m_fs_fwd_clk[11]),

             .fs_mac_rdy(fs_mac_rdy[11]),   
             .ns_mac_rdy(ns_mac_rdy[11]),  
             .ns_adapter_rstn(ns_adapter_rstn[11]),
             .config_done(config_done),   

             .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[11]), 
             .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[11]),

             .ms_osc_transfer_en(ms_osc_transfer_en[11]),
             .ms_rx_transfer_en(ms_rx_transfer_en[11]),
             .ms_tx_transfer_en(ms_tx_transfer_en[11]),
             .sl_osc_transfer_en(sl_osc_transfer_en[11]),
             .sl_rx_transfer_en(sl_rx_transfer_en[11]),
             .sl_tx_transfer_en(sl_tx_transfer_en[11]),

             .ms_sideband(ms_sideband[(81*(11+1)-1): 81*11]),
             .sl_sideband(sl_sideband[(73*(11+1)-1): 73*11])
             );

     maib_ch u_maib_12 (
             .iopad_aib(           {  iopad_fs_sr_data[12],       iopad_fs_sr_load[12],       iopad_ns_sr_data[12],      iopad_ns_sr_load[12],   
                                    iopad_unused_aib91[12],     iopad_unused_aib90[12],     iopad_unused_aib89[12],    iopad_unused_aib88[12],  
                                      iopad_fs_rcv_clk[12],      iopad_fs_rcv_clkb[12],        iopad_fs_sr_clk[12],      iopad_fs_sr_clkb[12], 
                                       iopad_ns_sr_clk[12],       iopad_ns_sr_clkb[12],     iopad_unused_aib81[12],    iopad_unused_aib80[12], 
                                    iopad_unused_aib79[12],     iopad_unused_aib78[12],     iopad_unused_aib77[12],    iopad_unused_aib76[12], 
                                    iopad_unused_aib75[12],     iopad_unused_aib74[12],     iopad_unused_aib73[12],    iopad_unused_aib72[12], 
                                    iopad_unused_aib71[12],     iopad_unused_aib70[12],     iopad_unused_aib69[12],    iopad_unused_aib68[12], 
                                    iopad_unused_aib67[12],     iopad_unused_aib66[12],  iopad_ns_adapter_rstn[12],    iopad_unused_aib64[12], 
                                    iopad_unused_aib63[12],     iopad_unused_aib62[12],     iopad_unused_aib61[12],    iopad_unused_aib60[12], 
                                     iopad_ns_rcv_clkb[12],     iopad_unused_aib58[12],       iopad_ns_rcv_clk[12], iopad_fs_adapter_rstn[12], 
                                iopad_fs_rcv_div2_clkb[12], iopad_fs_fwd_div2_clkb[12],  iopad_fs_fwd_div2_clk[12],    iopad_unused_aib52[12], 
                                    iopad_unused_aib51[12],     iopad_unused_aib50[12],       iopad_fs_mac_rdy[12], iopad_fs_rcv_div2_clk[12], 
                                    iopad_unused_aib47[12],     iopad_unused_aib46[12],     iopad_unused_aib45[12],      iopad_ns_mac_rdy[12], 
                                      iopad_ns_fwd_clk[12],      iopad_ns_fwd_clkb[12],       iopad_fs_fwd_clk[12],     iopad_fs_fwd_clkb[12], 
                                         iopad_tx[259:240],          iopad_rx[259:240]}), 

             .tx_parallel_data(tx_parallel_data[(80*(12+1)-1): 80*12]),     
             .rx_parallel_data(rx_parallel_data[(80*(12+1)-1): 80*12]),    
             .tx_coreclkin(tx_coreclkin[12]), 
             .tx_clkout(tx_clkout[12]), 
             .rx_coreclkin(rx_coreclkin[12]), 
                 
             .rx_clkout(rx_clkout[12]), 
             .m_ns_fwd_clk(m_ns_fwd_clk[12]), 
                  
             .m_fs_fwd_clk(m_fs_fwd_clk[12]),

             .fs_mac_rdy(fs_mac_rdy[12]),   
             .ns_mac_rdy(ns_mac_rdy[12]),  
             .ns_adapter_rstn(ns_adapter_rstn[12]),
             .config_done(config_done),   

             .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[12]), 
             .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[12]),

             .ms_osc_transfer_en(ms_osc_transfer_en[12]),
             .ms_rx_transfer_en(ms_rx_transfer_en[12]),
             .ms_tx_transfer_en(ms_tx_transfer_en[12]),
             .sl_osc_transfer_en(sl_osc_transfer_en[12]),
             .sl_rx_transfer_en(sl_rx_transfer_en[12]),
             .sl_tx_transfer_en(sl_tx_transfer_en[12]),

             .ms_sideband(ms_sideband[(81*(12+1)-1): 81*12]),
             .sl_sideband(sl_sideband[(73*(12+1)-1): 73*12])
             );

     maib_ch u_maib_13 (
             .iopad_aib(           {  iopad_fs_sr_data[13],       iopad_fs_sr_load[13],       iopad_ns_sr_data[13],      iopad_ns_sr_load[13],   
                                    iopad_unused_aib91[13],     iopad_unused_aib90[13],     iopad_unused_aib89[13],    iopad_unused_aib88[13],  
                                      iopad_fs_rcv_clk[13],      iopad_fs_rcv_clkb[13],        iopad_fs_sr_clk[13],      iopad_fs_sr_clkb[13], 
                                       iopad_ns_sr_clk[13],       iopad_ns_sr_clkb[13],     iopad_unused_aib81[13],    iopad_unused_aib80[13], 
                                    iopad_unused_aib79[13],     iopad_unused_aib78[13],     iopad_unused_aib77[13],    iopad_unused_aib76[13], 
                                    iopad_unused_aib75[13],     iopad_unused_aib74[13],     iopad_unused_aib73[13],    iopad_unused_aib72[13], 
                                    iopad_unused_aib71[13],     iopad_unused_aib70[13],     iopad_unused_aib69[13],    iopad_unused_aib68[13], 
                                    iopad_unused_aib67[13],     iopad_unused_aib66[13],  iopad_ns_adapter_rstn[13],    iopad_unused_aib64[13], 
                                    iopad_unused_aib63[13],     iopad_unused_aib62[13],     iopad_unused_aib61[13],    iopad_unused_aib60[13], 
                                     iopad_ns_rcv_clkb[13],     iopad_unused_aib58[13],       iopad_ns_rcv_clk[13], iopad_fs_adapter_rstn[13], 
                                iopad_fs_rcv_div2_clkb[13], iopad_fs_fwd_div2_clkb[13],  iopad_fs_fwd_div2_clk[13],    iopad_unused_aib52[13], 
                                    iopad_unused_aib51[13],     iopad_unused_aib50[13],       iopad_fs_mac_rdy[13], iopad_fs_rcv_div2_clk[13], 
                                    iopad_unused_aib47[13],     iopad_unused_aib46[13],     iopad_unused_aib45[13],      iopad_ns_mac_rdy[13], 
                                      iopad_ns_fwd_clk[13],      iopad_ns_fwd_clkb[13],       iopad_fs_fwd_clk[13],     iopad_fs_fwd_clkb[13], 
                                         iopad_tx[279:260],          iopad_rx[279:260]}), 

             .tx_parallel_data(tx_parallel_data[(80*(13+1)-1): 80*13]),     
             .rx_parallel_data(rx_parallel_data[(80*(13+1)-1): 80*13]),    
             .tx_coreclkin(tx_coreclkin[13]), 
             .tx_clkout(tx_clkout[13]), 
             .rx_coreclkin(rx_coreclkin[13]), 
                 
             .rx_clkout(rx_clkout[13]), 
             .m_ns_fwd_clk(m_ns_fwd_clk[13]), 
                  
             .m_fs_fwd_clk(m_fs_fwd_clk[13]),

             .fs_mac_rdy(fs_mac_rdy[13]),   
             .ns_mac_rdy(ns_mac_rdy[13]),  
             .ns_adapter_rstn(ns_adapter_rstn[13]),
             .config_done(config_done),   

             .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[13]), 
             .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[13]),

             .ms_osc_transfer_en(ms_osc_transfer_en[13]),
             .ms_rx_transfer_en(ms_rx_transfer_en[13]),
             .ms_tx_transfer_en(ms_tx_transfer_en[13]),
             .sl_osc_transfer_en(sl_osc_transfer_en[13]),
             .sl_rx_transfer_en(sl_rx_transfer_en[13]),
             .sl_tx_transfer_en(sl_tx_transfer_en[13]),

             .ms_sideband(ms_sideband[(81*(13+1)-1): 81*13]),
             .sl_sideband(sl_sideband[(73*(13+1)-1): 73*13])
             );

     maib_ch u_maib_14 (
             .iopad_aib(           {  iopad_fs_sr_data[14],       iopad_fs_sr_load[14],       iopad_ns_sr_data[14],      iopad_ns_sr_load[14],   
                                    iopad_unused_aib91[14],     iopad_unused_aib90[14],     iopad_unused_aib89[14],    iopad_unused_aib88[14],  
                                      iopad_fs_rcv_clk[14],      iopad_fs_rcv_clkb[14],        iopad_fs_sr_clk[14],      iopad_fs_sr_clkb[14], 
                                       iopad_ns_sr_clk[14],       iopad_ns_sr_clkb[14],     iopad_unused_aib81[14],    iopad_unused_aib80[14], 
                                    iopad_unused_aib79[14],     iopad_unused_aib78[14],     iopad_unused_aib77[14],    iopad_unused_aib76[14], 
                                    iopad_unused_aib75[14],     iopad_unused_aib74[14],     iopad_unused_aib73[14],    iopad_unused_aib72[14], 
                                    iopad_unused_aib71[14],     iopad_unused_aib70[14],     iopad_unused_aib69[14],    iopad_unused_aib68[14], 
                                    iopad_unused_aib67[14],     iopad_unused_aib66[14],  iopad_ns_adapter_rstn[14],    iopad_unused_aib64[14], 
                                    iopad_unused_aib63[14],     iopad_unused_aib62[14],     iopad_unused_aib61[14],    iopad_unused_aib60[14], 
                                     iopad_ns_rcv_clkb[14],     iopad_unused_aib58[14],       iopad_ns_rcv_clk[14], iopad_fs_adapter_rstn[14], 
                                iopad_fs_rcv_div2_clkb[14], iopad_fs_fwd_div2_clkb[14],  iopad_fs_fwd_div2_clk[14],    iopad_unused_aib52[14], 
                                    iopad_unused_aib51[14],     iopad_unused_aib50[14],       iopad_fs_mac_rdy[14], iopad_fs_rcv_div2_clk[14], 
                                    iopad_unused_aib47[14],     iopad_unused_aib46[14],     iopad_unused_aib45[14],      iopad_ns_mac_rdy[14], 
                                      iopad_ns_fwd_clk[14],      iopad_ns_fwd_clkb[14],       iopad_fs_fwd_clk[14],     iopad_fs_fwd_clkb[14], 
                                         iopad_tx[299:280],          iopad_rx[299:280]}), 

             .tx_parallel_data(tx_parallel_data[(80*(14+1)-1): 80*14]),     
             .rx_parallel_data(rx_parallel_data[(80*(14+1)-1): 80*14]),    
             .tx_coreclkin(tx_coreclkin[14]), 
             .tx_clkout(tx_clkout[14]), 
             .rx_coreclkin(rx_coreclkin[14]), 
                 
             .rx_clkout(rx_clkout[14]), 
             .m_ns_fwd_clk(m_ns_fwd_clk[14]), 
                  
             .m_fs_fwd_clk(m_fs_fwd_clk[14]),

             .fs_mac_rdy(fs_mac_rdy[14]),   
             .ns_mac_rdy(ns_mac_rdy[14]),  
             .ns_adapter_rstn(ns_adapter_rstn[14]),
             .config_done(config_done),   

             .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[14]), 
             .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[14]),

             .ms_osc_transfer_en(ms_osc_transfer_en[14]),
             .ms_rx_transfer_en(ms_rx_transfer_en[14]),
             .ms_tx_transfer_en(ms_tx_transfer_en[14]),
             .sl_osc_transfer_en(sl_osc_transfer_en[14]),
             .sl_rx_transfer_en(sl_rx_transfer_en[14]),
             .sl_tx_transfer_en(sl_tx_transfer_en[14]),

             .ms_sideband(ms_sideband[(81*(14+1)-1): 81*14]),
             .sl_sideband(sl_sideband[(73*(14+1)-1): 73*14])
             );

     maib_ch u_maib_15 (
             .iopad_aib(           {  iopad_fs_sr_data[15],       iopad_fs_sr_load[15],       iopad_ns_sr_data[15],      iopad_ns_sr_load[15],   
                                    iopad_unused_aib91[15],     iopad_unused_aib90[15],     iopad_unused_aib89[15],    iopad_unused_aib88[15],  
                                      iopad_fs_rcv_clk[15],      iopad_fs_rcv_clkb[15],        iopad_fs_sr_clk[15],      iopad_fs_sr_clkb[15], 
                                       iopad_ns_sr_clk[15],       iopad_ns_sr_clkb[15],     iopad_unused_aib81[15],    iopad_unused_aib80[15], 
                                    iopad_unused_aib79[15],     iopad_unused_aib78[15],     iopad_unused_aib77[15],    iopad_unused_aib76[15], 
                                    iopad_unused_aib75[15],     iopad_unused_aib74[15],     iopad_unused_aib73[15],    iopad_unused_aib72[15], 
                                    iopad_unused_aib71[15],     iopad_unused_aib70[15],     iopad_unused_aib69[15],    iopad_unused_aib68[15], 
                                    iopad_unused_aib67[15],     iopad_unused_aib66[15],  iopad_ns_adapter_rstn[15],    iopad_unused_aib64[15], 
                                    iopad_unused_aib63[15],     iopad_unused_aib62[15],     iopad_unused_aib61[15],    iopad_unused_aib60[15], 
                                     iopad_ns_rcv_clkb[15],     iopad_unused_aib58[15],       iopad_ns_rcv_clk[15], iopad_fs_adapter_rstn[15], 
                                iopad_fs_rcv_div2_clkb[15], iopad_fs_fwd_div2_clkb[15],  iopad_fs_fwd_div2_clk[15],    iopad_unused_aib52[15], 
                                    iopad_unused_aib51[15],     iopad_unused_aib50[15],       iopad_fs_mac_rdy[15], iopad_fs_rcv_div2_clk[15], 
                                    iopad_unused_aib47[15],     iopad_unused_aib46[15],     iopad_unused_aib45[15],      iopad_ns_mac_rdy[15], 
                                      iopad_ns_fwd_clk[15],      iopad_ns_fwd_clkb[15],       iopad_fs_fwd_clk[15],     iopad_fs_fwd_clkb[15], 
                                         iopad_tx[319:300],          iopad_rx[319:300]}), 

             .tx_parallel_data(tx_parallel_data[(80*(15+1)-1): 80*15]),     
             .rx_parallel_data(rx_parallel_data[(80*(15+1)-1): 80*15]),    
             .tx_coreclkin(tx_coreclkin[15]), 
             .tx_clkout(tx_clkout[15]), 
             .rx_coreclkin(rx_coreclkin[15]), 
                 
             .rx_clkout(rx_clkout[15]), 
             .m_ns_fwd_clk(m_ns_fwd_clk[15]), 
                  
             .m_fs_fwd_clk(m_fs_fwd_clk[15]),

             .fs_mac_rdy(fs_mac_rdy[15]),   
             .ns_mac_rdy(ns_mac_rdy[15]),  
             .ns_adapter_rstn(ns_adapter_rstn[15]),
             .config_done(config_done),   

             .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[15]), 
             .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[15]),

             .ms_osc_transfer_en(ms_osc_transfer_en[15]),
             .ms_rx_transfer_en(ms_rx_transfer_en[15]),
             .ms_tx_transfer_en(ms_tx_transfer_en[15]),
             .sl_osc_transfer_en(sl_osc_transfer_en[15]),
             .sl_rx_transfer_en(sl_rx_transfer_en[15]),
             .sl_tx_transfer_en(sl_tx_transfer_en[15]),

             .ms_sideband(ms_sideband[(81*(15+1)-1): 81*15]),
             .sl_sideband(sl_sideband[(73*(15+1)-1): 73*15])
             );

     maib_ch u_maib_16 (
             .iopad_aib(           {  iopad_fs_sr_data[16],       iopad_fs_sr_load[16],       iopad_ns_sr_data[16],      iopad_ns_sr_load[16],   
                                    iopad_unused_aib91[16],     iopad_unused_aib90[16],     iopad_unused_aib89[16],    iopad_unused_aib88[16],  
                                      iopad_fs_rcv_clk[16],      iopad_fs_rcv_clkb[16],        iopad_fs_sr_clk[16],      iopad_fs_sr_clkb[16], 
                                       iopad_ns_sr_clk[16],       iopad_ns_sr_clkb[16],     iopad_unused_aib81[16],    iopad_unused_aib80[16], 
                                    iopad_unused_aib79[16],     iopad_unused_aib78[16],     iopad_unused_aib77[16],    iopad_unused_aib76[16], 
                                    iopad_unused_aib75[16],     iopad_unused_aib74[16],     iopad_unused_aib73[16],    iopad_unused_aib72[16], 
                                    iopad_unused_aib71[16],     iopad_unused_aib70[16],     iopad_unused_aib69[16],    iopad_unused_aib68[16], 
                                    iopad_unused_aib67[16],     iopad_unused_aib66[16],  iopad_ns_adapter_rstn[16],    iopad_unused_aib64[16], 
                                    iopad_unused_aib63[16],     iopad_unused_aib62[16],     iopad_unused_aib61[16],    iopad_unused_aib60[16], 
                                     iopad_ns_rcv_clkb[16],     iopad_unused_aib58[16],       iopad_ns_rcv_clk[16], iopad_fs_adapter_rstn[16], 
                                iopad_fs_rcv_div2_clkb[16], iopad_fs_fwd_div2_clkb[16],  iopad_fs_fwd_div2_clk[16],    iopad_unused_aib52[16], 
                                    iopad_unused_aib51[16],     iopad_unused_aib50[16],       iopad_fs_mac_rdy[16], iopad_fs_rcv_div2_clk[16], 
                                    iopad_unused_aib47[16],     iopad_unused_aib46[16],     iopad_unused_aib45[16],      iopad_ns_mac_rdy[16], 
                                      iopad_ns_fwd_clk[16],      iopad_ns_fwd_clkb[16],       iopad_fs_fwd_clk[16],     iopad_fs_fwd_clkb[16], 
                                         iopad_tx[339:320],          iopad_rx[339:320]}), 

             .tx_parallel_data(tx_parallel_data[(80*(16+1)-1): 80*16]),     
             .rx_parallel_data(rx_parallel_data[(80*(16+1)-1): 80*16]),    
             .tx_coreclkin(tx_coreclkin[16]), 
             .tx_clkout(tx_clkout[16]), 
             .rx_coreclkin(rx_coreclkin[16]), 
                 
             .rx_clkout(rx_clkout[16]), 
             .m_ns_fwd_clk(m_ns_fwd_clk[16]), 
                  
             .m_fs_fwd_clk(m_fs_fwd_clk[16]),

             .fs_mac_rdy(fs_mac_rdy[16]),   
             .ns_mac_rdy(ns_mac_rdy[16]),  
             .ns_adapter_rstn(ns_adapter_rstn[16]),
             .config_done(config_done),   

             .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[16]), 
             .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[16]),

             .ms_osc_transfer_en(ms_osc_transfer_en[16]),
             .ms_rx_transfer_en(ms_rx_transfer_en[16]),
             .ms_tx_transfer_en(ms_tx_transfer_en[16]),
             .sl_osc_transfer_en(sl_osc_transfer_en[16]),
             .sl_rx_transfer_en(sl_rx_transfer_en[16]),
             .sl_tx_transfer_en(sl_tx_transfer_en[16]),

             .ms_sideband(ms_sideband[(81*(16+1)-1): 81*16]),
             .sl_sideband(sl_sideband[(73*(16+1)-1): 73*16])
             );

     maib_ch u_maib_17 (
             .iopad_aib(           {  iopad_fs_sr_data[17],       iopad_fs_sr_load[17],       iopad_ns_sr_data[17],      iopad_ns_sr_load[17],   
                                    iopad_unused_aib91[17],     iopad_unused_aib90[17],     iopad_unused_aib89[17],    iopad_unused_aib88[17],  
                                      iopad_fs_rcv_clk[17],      iopad_fs_rcv_clkb[17],        iopad_fs_sr_clk[17],      iopad_fs_sr_clkb[17], 
                                       iopad_ns_sr_clk[17],       iopad_ns_sr_clkb[17],     iopad_unused_aib81[17],    iopad_unused_aib80[17], 
                                    iopad_unused_aib79[17],     iopad_unused_aib78[17],     iopad_unused_aib77[17],    iopad_unused_aib76[17], 
                                    iopad_unused_aib75[17],     iopad_unused_aib74[17],     iopad_unused_aib73[17],    iopad_unused_aib72[17], 
                                    iopad_unused_aib71[17],     iopad_unused_aib70[17],     iopad_unused_aib69[17],    iopad_unused_aib68[17], 
                                    iopad_unused_aib67[17],     iopad_unused_aib66[17],  iopad_ns_adapter_rstn[17],    iopad_unused_aib64[17], 
                                    iopad_unused_aib63[17],     iopad_unused_aib62[17],     iopad_unused_aib61[17],    iopad_unused_aib60[17], 
                                     iopad_ns_rcv_clkb[17],     iopad_unused_aib58[17],       iopad_ns_rcv_clk[17], iopad_fs_adapter_rstn[17], 
                                iopad_fs_rcv_div2_clkb[17], iopad_fs_fwd_div2_clkb[17],  iopad_fs_fwd_div2_clk[17],    iopad_unused_aib52[17], 
                                    iopad_unused_aib51[17],     iopad_unused_aib50[17],       iopad_fs_mac_rdy[17], iopad_fs_rcv_div2_clk[17], 
                                    iopad_unused_aib47[17],     iopad_unused_aib46[17],     iopad_unused_aib45[17],      iopad_ns_mac_rdy[17], 
                                      iopad_ns_fwd_clk[17],      iopad_ns_fwd_clkb[17],       iopad_fs_fwd_clk[17],     iopad_fs_fwd_clkb[17], 
                                         iopad_tx[359:340],          iopad_rx[359:340]}), 

             .tx_parallel_data(tx_parallel_data[(80*(17+1)-1): 80*17]),     
             .rx_parallel_data(rx_parallel_data[(80*(17+1)-1): 80*17]),    
             .tx_coreclkin(tx_coreclkin[17]), 
             .tx_clkout(tx_clkout[17]), 
             .rx_coreclkin(rx_coreclkin[17]), 
                 
             .rx_clkout(rx_clkout[17]), 
             .m_ns_fwd_clk(m_ns_fwd_clk[17]), 
                  
             .m_fs_fwd_clk(m_fs_fwd_clk[17]),

             .fs_mac_rdy(fs_mac_rdy[17]),   
             .ns_mac_rdy(ns_mac_rdy[17]),  
             .ns_adapter_rstn(ns_adapter_rstn[17]),
             .config_done(config_done),   

             .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[17]), 
             .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[17]),

             .ms_osc_transfer_en(ms_osc_transfer_en[17]),
             .ms_rx_transfer_en(ms_rx_transfer_en[17]),
             .ms_tx_transfer_en(ms_tx_transfer_en[17]),
             .sl_osc_transfer_en(sl_osc_transfer_en[17]),
             .sl_rx_transfer_en(sl_rx_transfer_en[17]),
             .sl_tx_transfer_en(sl_tx_transfer_en[17]),

             .ms_sideband(ms_sideband[(81*(17+1)-1): 81*17]),
             .sl_sideband(sl_sideband[(73*(17+1)-1): 73*17])
             );

     maib_ch u_maib_18 (
             .iopad_aib(           {  iopad_fs_sr_data[18],       iopad_fs_sr_load[18],       iopad_ns_sr_data[18],      iopad_ns_sr_load[18],   
                                    iopad_unused_aib91[18],     iopad_unused_aib90[18],     iopad_unused_aib89[18],    iopad_unused_aib88[18],  
                                      iopad_fs_rcv_clk[18],      iopad_fs_rcv_clkb[18],        iopad_fs_sr_clk[18],      iopad_fs_sr_clkb[18], 
                                       iopad_ns_sr_clk[18],       iopad_ns_sr_clkb[18],     iopad_unused_aib81[18],    iopad_unused_aib80[18], 
                                    iopad_unused_aib79[18],     iopad_unused_aib78[18],     iopad_unused_aib77[18],    iopad_unused_aib76[18], 
                                    iopad_unused_aib75[18],     iopad_unused_aib74[18],     iopad_unused_aib73[18],    iopad_unused_aib72[18], 
                                    iopad_unused_aib71[18],     iopad_unused_aib70[18],     iopad_unused_aib69[18],    iopad_unused_aib68[18], 
                                    iopad_unused_aib67[18],     iopad_unused_aib66[18],  iopad_ns_adapter_rstn[18],    iopad_unused_aib64[18], 
                                    iopad_unused_aib63[18],     iopad_unused_aib62[18],     iopad_unused_aib61[18],    iopad_unused_aib60[18], 
                                     iopad_ns_rcv_clkb[18],     iopad_unused_aib58[18],       iopad_ns_rcv_clk[18], iopad_fs_adapter_rstn[18], 
                                iopad_fs_rcv_div2_clkb[18], iopad_fs_fwd_div2_clkb[18],  iopad_fs_fwd_div2_clk[18],    iopad_unused_aib52[18], 
                                    iopad_unused_aib51[18],     iopad_unused_aib50[18],       iopad_fs_mac_rdy[18], iopad_fs_rcv_div2_clk[18], 
                                    iopad_unused_aib47[18],     iopad_unused_aib46[18],     iopad_unused_aib45[18],      iopad_ns_mac_rdy[18], 
                                      iopad_ns_fwd_clk[18],      iopad_ns_fwd_clkb[18],       iopad_fs_fwd_clk[18],     iopad_fs_fwd_clkb[18], 
                                         iopad_tx[379:360],          iopad_rx[379:360]}), 

             .tx_parallel_data(tx_parallel_data[(80*(18+1)-1): 80*18]),     
             .rx_parallel_data(rx_parallel_data[(80*(18+1)-1): 80*18]),    
             .tx_coreclkin(tx_coreclkin[18]), 
             .tx_clkout(tx_clkout[18]), 
             .rx_coreclkin(rx_coreclkin[18]), 
                 
             .rx_clkout(rx_clkout[18]), 
             .m_ns_fwd_clk(m_ns_fwd_clk[18]), 
                  
             .m_fs_fwd_clk(m_fs_fwd_clk[18]),

             .fs_mac_rdy(fs_mac_rdy[18]),   
             .ns_mac_rdy(ns_mac_rdy[18]),  
             .ns_adapter_rstn(ns_adapter_rstn[18]),
             .config_done(config_done),   

             .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[18]), 
             .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[18]),

             .ms_osc_transfer_en(ms_osc_transfer_en[18]),
             .ms_rx_transfer_en(ms_rx_transfer_en[18]),
             .ms_tx_transfer_en(ms_tx_transfer_en[18]),
             .sl_osc_transfer_en(sl_osc_transfer_en[18]),
             .sl_rx_transfer_en(sl_rx_transfer_en[18]),
             .sl_tx_transfer_en(sl_tx_transfer_en[18]),

             .ms_sideband(ms_sideband[(81*(18+1)-1): 81*18]),
             .sl_sideband(sl_sideband[(73*(18+1)-1): 73*18])
             );

     maib_ch u_maib_19 (
             .iopad_aib(           {  iopad_fs_sr_data[19],       iopad_fs_sr_load[19],       iopad_ns_sr_data[19],      iopad_ns_sr_load[19],   
                                    iopad_unused_aib91[19],     iopad_unused_aib90[19],     iopad_unused_aib89[19],    iopad_unused_aib88[19],  
                                      iopad_fs_rcv_clk[19],      iopad_fs_rcv_clkb[19],        iopad_fs_sr_clk[19],      iopad_fs_sr_clkb[19], 
                                       iopad_ns_sr_clk[19],       iopad_ns_sr_clkb[19],     iopad_unused_aib81[19],    iopad_unused_aib80[19], 
                                    iopad_unused_aib79[19],     iopad_unused_aib78[19],     iopad_unused_aib77[19],    iopad_unused_aib76[19], 
                                    iopad_unused_aib75[19],     iopad_unused_aib74[19],     iopad_unused_aib73[19],    iopad_unused_aib72[19], 
                                    iopad_unused_aib71[19],     iopad_unused_aib70[19],     iopad_unused_aib69[19],    iopad_unused_aib68[19], 
                                    iopad_unused_aib67[19],     iopad_unused_aib66[19],  iopad_ns_adapter_rstn[19],    iopad_unused_aib64[19], 
                                    iopad_unused_aib63[19],     iopad_unused_aib62[19],     iopad_unused_aib61[19],    iopad_unused_aib60[19], 
                                     iopad_ns_rcv_clkb[19],     iopad_unused_aib58[19],       iopad_ns_rcv_clk[19], iopad_fs_adapter_rstn[19], 
                                iopad_fs_rcv_div2_clkb[19], iopad_fs_fwd_div2_clkb[19],  iopad_fs_fwd_div2_clk[19],    iopad_unused_aib52[19], 
                                    iopad_unused_aib51[19],     iopad_unused_aib50[19],       iopad_fs_mac_rdy[19], iopad_fs_rcv_div2_clk[19], 
                                    iopad_unused_aib47[19],     iopad_unused_aib46[19],     iopad_unused_aib45[19],      iopad_ns_mac_rdy[19], 
                                      iopad_ns_fwd_clk[19],      iopad_ns_fwd_clkb[19],       iopad_fs_fwd_clk[19],     iopad_fs_fwd_clkb[19], 
                                         iopad_tx[399:380],          iopad_rx[399:380]}), 

             .tx_parallel_data(tx_parallel_data[(80*(19+1)-1): 80*19]),     
             .rx_parallel_data(rx_parallel_data[(80*(19+1)-1): 80*19]),    
             .tx_coreclkin(tx_coreclkin[19]), 
             .tx_clkout(tx_clkout[19]), 
             .rx_coreclkin(rx_coreclkin[19]), 
                 
             .rx_clkout(rx_clkout[19]), 
             .m_ns_fwd_clk(m_ns_fwd_clk[19]), 
                  
             .m_fs_fwd_clk(m_fs_fwd_clk[19]),

             .fs_mac_rdy(fs_mac_rdy[19]),   
             .ns_mac_rdy(ns_mac_rdy[19]),  
             .ns_adapter_rstn(ns_adapter_rstn[19]),
             .config_done(config_done),   

             .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[19]), 
             .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[19]),

             .ms_osc_transfer_en(ms_osc_transfer_en[19]),
             .ms_rx_transfer_en(ms_rx_transfer_en[19]),
             .ms_tx_transfer_en(ms_tx_transfer_en[19]),
             .sl_osc_transfer_en(sl_osc_transfer_en[19]),
             .sl_rx_transfer_en(sl_rx_transfer_en[19]),
             .sl_tx_transfer_en(sl_tx_transfer_en[19]),

             .ms_sideband(ms_sideband[(81*(19+1)-1): 81*19]),
             .sl_sideband(sl_sideband[(73*(19+1)-1): 73*19])
             );

     maib_ch u_maib_20 (
             .iopad_aib(           {  iopad_fs_sr_data[20],       iopad_fs_sr_load[20],       iopad_ns_sr_data[20],      iopad_ns_sr_load[20],   
                                    iopad_unused_aib91[20],     iopad_unused_aib90[20],     iopad_unused_aib89[20],    iopad_unused_aib88[20],  
                                      iopad_fs_rcv_clk[20],      iopad_fs_rcv_clkb[20],        iopad_fs_sr_clk[20],      iopad_fs_sr_clkb[20], 
                                       iopad_ns_sr_clk[20],       iopad_ns_sr_clkb[20],     iopad_unused_aib81[20],    iopad_unused_aib80[20], 
                                    iopad_unused_aib79[20],     iopad_unused_aib78[20],     iopad_unused_aib77[20],    iopad_unused_aib76[20], 
                                    iopad_unused_aib75[20],     iopad_unused_aib74[20],     iopad_unused_aib73[20],    iopad_unused_aib72[20], 
                                    iopad_unused_aib71[20],     iopad_unused_aib70[20],     iopad_unused_aib69[20],    iopad_unused_aib68[20], 
                                    iopad_unused_aib67[20],     iopad_unused_aib66[20],  iopad_ns_adapter_rstn[20],    iopad_unused_aib64[20], 
                                    iopad_unused_aib63[20],     iopad_unused_aib62[20],     iopad_unused_aib61[20],    iopad_unused_aib60[20], 
                                     iopad_ns_rcv_clkb[20],     iopad_unused_aib58[20],       iopad_ns_rcv_clk[20], iopad_fs_adapter_rstn[20], 
                                iopad_fs_rcv_div2_clkb[20], iopad_fs_fwd_div2_clkb[20],  iopad_fs_fwd_div2_clk[20],    iopad_unused_aib52[20], 
                                    iopad_unused_aib51[20],     iopad_unused_aib50[20],       iopad_fs_mac_rdy[20], iopad_fs_rcv_div2_clk[20], 
                                    iopad_unused_aib47[20],     iopad_unused_aib46[20],     iopad_unused_aib45[20],      iopad_ns_mac_rdy[20], 
                                      iopad_ns_fwd_clk[20],      iopad_ns_fwd_clkb[20],       iopad_fs_fwd_clk[20],     iopad_fs_fwd_clkb[20], 
                                         iopad_tx[419:400],          iopad_rx[419:400]}), 

             .tx_parallel_data(tx_parallel_data[(80*(20+1)-1): 80*20]),     
             .rx_parallel_data(rx_parallel_data[(80*(20+1)-1): 80*20]),    
             .tx_coreclkin(tx_coreclkin[20]), 
             .tx_clkout(tx_clkout[20]), 
             .rx_coreclkin(rx_coreclkin[20]), 
                 
             .rx_clkout(rx_clkout[20]), 
             .m_ns_fwd_clk(m_ns_fwd_clk[20]), 
                  
             .m_fs_fwd_clk(m_fs_fwd_clk[20]),

             .fs_mac_rdy(fs_mac_rdy[20]),   
             .ns_mac_rdy(ns_mac_rdy[20]),  
             .ns_adapter_rstn(ns_adapter_rstn[20]),
             .config_done(config_done),   

             .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[20]), 
             .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[20]),

             .ms_osc_transfer_en(ms_osc_transfer_en[20]),
             .ms_rx_transfer_en(ms_rx_transfer_en[20]),
             .ms_tx_transfer_en(ms_tx_transfer_en[20]),
             .sl_osc_transfer_en(sl_osc_transfer_en[20]),
             .sl_rx_transfer_en(sl_rx_transfer_en[20]),
             .sl_tx_transfer_en(sl_tx_transfer_en[20]),

             .ms_sideband(ms_sideband[(81*(20+1)-1): 81*20]),
             .sl_sideband(sl_sideband[(73*(20+1)-1): 73*20])
             );

     maib_ch u_maib_21 (
             .iopad_aib(           {  iopad_fs_sr_data[21],       iopad_fs_sr_load[21],       iopad_ns_sr_data[21],      iopad_ns_sr_load[21],   
                                    iopad_unused_aib91[21],     iopad_unused_aib90[21],     iopad_unused_aib89[21],    iopad_unused_aib88[21],  
                                      iopad_fs_rcv_clk[21],      iopad_fs_rcv_clkb[21],        iopad_fs_sr_clk[21],      iopad_fs_sr_clkb[21], 
                                       iopad_ns_sr_clk[21],       iopad_ns_sr_clkb[21],     iopad_unused_aib81[21],    iopad_unused_aib80[21], 
                                    iopad_unused_aib79[21],     iopad_unused_aib78[21],     iopad_unused_aib77[21],    iopad_unused_aib76[21], 
                                    iopad_unused_aib75[21],     iopad_unused_aib74[21],     iopad_unused_aib73[21],    iopad_unused_aib72[21], 
                                    iopad_unused_aib71[21],     iopad_unused_aib70[21],     iopad_unused_aib69[21],    iopad_unused_aib68[21], 
                                    iopad_unused_aib67[21],     iopad_unused_aib66[21],  iopad_ns_adapter_rstn[21],    iopad_unused_aib64[21], 
                                    iopad_unused_aib63[21],     iopad_unused_aib62[21],     iopad_unused_aib61[21],    iopad_unused_aib60[21], 
                                     iopad_ns_rcv_clkb[21],     iopad_unused_aib58[21],       iopad_ns_rcv_clk[21], iopad_fs_adapter_rstn[21], 
                                iopad_fs_rcv_div2_clkb[21], iopad_fs_fwd_div2_clkb[21],  iopad_fs_fwd_div2_clk[21],    iopad_unused_aib52[21], 
                                    iopad_unused_aib51[21],     iopad_unused_aib50[21],       iopad_fs_mac_rdy[21], iopad_fs_rcv_div2_clk[21], 
                                    iopad_unused_aib47[21],     iopad_unused_aib46[21],     iopad_unused_aib45[21],      iopad_ns_mac_rdy[21], 
                                      iopad_ns_fwd_clk[21],      iopad_ns_fwd_clkb[21],       iopad_fs_fwd_clk[21],     iopad_fs_fwd_clkb[21], 
                                         iopad_tx[439:420],          iopad_rx[439:420]}), 

             .tx_parallel_data(tx_parallel_data[(80*(21+1)-1): 80*21]),     
             .rx_parallel_data(rx_parallel_data[(80*(21+1)-1): 80*21]),    
             .tx_coreclkin(tx_coreclkin[21]), 
             .tx_clkout(tx_clkout[21]), 
             .rx_coreclkin(rx_coreclkin[21]), 
                 
             .rx_clkout(rx_clkout[21]), 
             .m_ns_fwd_clk(m_ns_fwd_clk[21]), 
                  
             .m_fs_fwd_clk(m_fs_fwd_clk[21]),

             .fs_mac_rdy(fs_mac_rdy[21]),   
             .ns_mac_rdy(ns_mac_rdy[21]),  
             .ns_adapter_rstn(ns_adapter_rstn[21]),
             .config_done(config_done),   

             .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[21]), 
             .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[21]),

             .ms_osc_transfer_en(ms_osc_transfer_en[21]),
             .ms_rx_transfer_en(ms_rx_transfer_en[21]),
             .ms_tx_transfer_en(ms_tx_transfer_en[21]),
             .sl_osc_transfer_en(sl_osc_transfer_en[21]),
             .sl_rx_transfer_en(sl_rx_transfer_en[21]),
             .sl_tx_transfer_en(sl_tx_transfer_en[21]),

             .ms_sideband(ms_sideband[(81*(21+1)-1): 81*21]),
             .sl_sideband(sl_sideband[(73*(21+1)-1): 73*21])
             );

     maib_ch u_maib_22 (
             .iopad_aib(           {  iopad_fs_sr_data[22],       iopad_fs_sr_load[22],       iopad_ns_sr_data[22],      iopad_ns_sr_load[22],   
                                    iopad_unused_aib91[22],     iopad_unused_aib90[22],     iopad_unused_aib89[22],    iopad_unused_aib88[22],  
                                      iopad_fs_rcv_clk[22],      iopad_fs_rcv_clkb[22],        iopad_fs_sr_clk[22],      iopad_fs_sr_clkb[22], 
                                       iopad_ns_sr_clk[22],       iopad_ns_sr_clkb[22],     iopad_unused_aib81[22],    iopad_unused_aib80[22], 
                                    iopad_unused_aib79[22],     iopad_unused_aib78[22],     iopad_unused_aib77[22],    iopad_unused_aib76[22], 
                                    iopad_unused_aib75[22],     iopad_unused_aib74[22],     iopad_unused_aib73[22],    iopad_unused_aib72[22], 
                                    iopad_unused_aib71[22],     iopad_unused_aib70[22],     iopad_unused_aib69[22],    iopad_unused_aib68[22], 
                                    iopad_unused_aib67[22],     iopad_unused_aib66[22],  iopad_ns_adapter_rstn[22],    iopad_unused_aib64[22], 
                                    iopad_unused_aib63[22],     iopad_unused_aib62[22],     iopad_unused_aib61[22],    iopad_unused_aib60[22], 
                                     iopad_ns_rcv_clkb[22],     iopad_unused_aib58[22],       iopad_ns_rcv_clk[22], iopad_fs_adapter_rstn[22], 
                                iopad_fs_rcv_div2_clkb[22], iopad_fs_fwd_div2_clkb[22],  iopad_fs_fwd_div2_clk[22],    iopad_unused_aib52[22], 
                                    iopad_unused_aib51[22],     iopad_unused_aib50[22],       iopad_fs_mac_rdy[22], iopad_fs_rcv_div2_clk[22], 
                                    iopad_unused_aib47[22],     iopad_unused_aib46[22],     iopad_unused_aib45[22],      iopad_ns_mac_rdy[22], 
                                      iopad_ns_fwd_clk[22],      iopad_ns_fwd_clkb[22],       iopad_fs_fwd_clk[22],     iopad_fs_fwd_clkb[22], 
                                         iopad_tx[459:440],          iopad_rx[459:440]}), 

             .tx_parallel_data(tx_parallel_data[(80*(22+1)-1): 80*22]),     
             .rx_parallel_data(rx_parallel_data[(80*(22+1)-1): 80*22]),    
             .tx_coreclkin(tx_coreclkin[22]), 
             .tx_clkout(tx_clkout[22]), 
             .rx_coreclkin(rx_coreclkin[22]), 
                 
             .rx_clkout(rx_clkout[22]), 
             .m_ns_fwd_clk(m_ns_fwd_clk[22]), 
                  
             .m_fs_fwd_clk(m_fs_fwd_clk[22]),

             .fs_mac_rdy(fs_mac_rdy[22]),   
             .ns_mac_rdy(ns_mac_rdy[22]),  
             .ns_adapter_rstn(ns_adapter_rstn[22]),
             .config_done(config_done),   

             .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[22]), 
             .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[22]),

             .ms_osc_transfer_en(ms_osc_transfer_en[22]),
             .ms_rx_transfer_en(ms_rx_transfer_en[22]),
             .ms_tx_transfer_en(ms_tx_transfer_en[22]),
             .sl_osc_transfer_en(sl_osc_transfer_en[22]),
             .sl_rx_transfer_en(sl_rx_transfer_en[22]),
             .sl_tx_transfer_en(sl_tx_transfer_en[22]),

             .ms_sideband(ms_sideband[(81*(22+1)-1): 81*22]),
             .sl_sideband(sl_sideband[(73*(22+1)-1): 73*22])
             );

     maib_ch u_maib_23 (
             .iopad_aib(           {  iopad_fs_sr_data[23],       iopad_fs_sr_load[23],       iopad_ns_sr_data[23],      iopad_ns_sr_load[23],   
                                    iopad_unused_aib91[23],     iopad_unused_aib90[23],     iopad_unused_aib89[23],    iopad_unused_aib88[23],  
                                      iopad_fs_rcv_clk[23],      iopad_fs_rcv_clkb[23],        iopad_fs_sr_clk[23],      iopad_fs_sr_clkb[23], 
                                       iopad_ns_sr_clk[23],       iopad_ns_sr_clkb[23],     iopad_unused_aib81[23],    iopad_unused_aib80[23], 
                                    iopad_unused_aib79[23],     iopad_unused_aib78[23],     iopad_unused_aib77[23],    iopad_unused_aib76[23], 
                                    iopad_unused_aib75[23],     iopad_unused_aib74[23],     iopad_unused_aib73[23],    iopad_unused_aib72[23], 
                                    iopad_unused_aib71[23],     iopad_unused_aib70[23],     iopad_unused_aib69[23],    iopad_unused_aib68[23], 
                                    iopad_unused_aib67[23],     iopad_unused_aib66[23],  iopad_ns_adapter_rstn[23],    iopad_unused_aib64[23], 
                                    iopad_unused_aib63[23],     iopad_unused_aib62[23],     iopad_unused_aib61[23],    iopad_unused_aib60[23], 
                                     iopad_ns_rcv_clkb[23],     iopad_unused_aib58[23],       iopad_ns_rcv_clk[23], iopad_fs_adapter_rstn[23], 
                                iopad_fs_rcv_div2_clkb[23], iopad_fs_fwd_div2_clkb[23],  iopad_fs_fwd_div2_clk[23],    iopad_unused_aib52[23], 
                                    iopad_unused_aib51[23],     iopad_unused_aib50[23],       iopad_fs_mac_rdy[23], iopad_fs_rcv_div2_clk[23], 
                                    iopad_unused_aib47[23],     iopad_unused_aib46[23],     iopad_unused_aib45[23],      iopad_ns_mac_rdy[23], 
                                      iopad_ns_fwd_clk[23],      iopad_ns_fwd_clkb[23],       iopad_fs_fwd_clk[23],     iopad_fs_fwd_clkb[23], 
                                         iopad_tx[479:460],          iopad_rx[479:460]}), 

             .tx_parallel_data(tx_parallel_data[(80*(23+1)-1): 80*23]),     
             .rx_parallel_data(rx_parallel_data[(80*(23+1)-1): 80*23]),    
             .tx_coreclkin(tx_coreclkin[23]), 
             .tx_clkout(tx_clkout[23]), 
             .rx_coreclkin(rx_coreclkin[23]), 
                 
             .rx_clkout(rx_clkout[23]), 
             .m_ns_fwd_clk(m_ns_fwd_clk[23]), 
                  
             .m_fs_fwd_clk(m_fs_fwd_clk[23]),

             .fs_mac_rdy(fs_mac_rdy[23]),   
             .ns_mac_rdy(ns_mac_rdy[23]),  
             .ns_adapter_rstn(ns_adapter_rstn[23]),
             .config_done(config_done),   

             .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req[23]), 
             .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req[23]),

             .ms_osc_transfer_en(ms_osc_transfer_en[23]),
             .ms_rx_transfer_en(ms_rx_transfer_en[23]),
             .ms_tx_transfer_en(ms_tx_transfer_en[23]),
             .sl_osc_transfer_en(sl_osc_transfer_en[23]),
             .sl_rx_transfer_en(sl_rx_transfer_en[23]),
             .sl_tx_transfer_en(sl_tx_transfer_en[23]),

             .ms_sideband(ms_sideband[(81*(23+1)-1): 81*23]),
             .sl_sideband(sl_sideband[(73*(23+1)-1): 73*23])
             );

aibndaux_top_slave ndaux ( .o_crdet(m_device_detect), 
                           .u_crdet(iopad_crdet), 
                           .u_crdet_r(iopad_crdet_r), 
                           .u_dn_por(iopad_por), 
                           .u_dn_por_r(iopad_por_r), 
                           .i_dn_por(m_power_on_reset),
                           .i_crdet_ovrd(m_device_detect_ovrd));

endmodule
