// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//-----------------------------------------------------------------------------------------------//
//   Generated with Magillem S.A. MRV generator.                                  
//   MRV generator version : 0.2
//   Protocol :  AVALON
//   Wait State : WS1_OUTPUT                                         
//-----------------------------------------------------------------------------------------------//


//-----------------------------------------------------------------------------------------------//
//   Verilog Register Bank
//   Component Name: c3aibadapt_usr_csr
//   Magillem Version :   5.10.0.7                                                                         
//-----------------------------------------------------------------------------------------------//
// 
module c3aibadapt_usr_csr (
// register offset : 0x00, field offset : 0, access : RW
output	reg [29:0] r_usr_outbox_usr_msg ,
// register offset : 0x00, field offset : 31, access : RW
output	reg  r_usr_outbox_send_msg ,
// register offset : 0x04, field offset : 0, access : RO
output	reg [29:0] r_usr_inbox_usr_msg ,
// register offset : 0x04, field offset : 30, access : RW
output	reg  r_usr_inbox_autoclear_dis ,
// register offset : 0x04, field offset : 31, access : RO
output	reg  r_usr_inbox_new_msg ,
// register offset : 0x08, field offset : 0, access : RW
output	reg [2:0] r_dprio0_tx_chnl_dp_map_mode ,
// register offset : 0x08, field offset : 9, access : RW
output	reg  r_dprio0_tx_usertest_sel ,
// register offset : 0x08, field offset : 11, access : RW
output	reg [4:0] r_dprio0_tx_fifo_empty ,
// register offset : 0x08, field offset : 19, access : RW
output	reg [4:0] r_dprio0_tx_fifo_full ,
// register offset : 0x08, field offset : 24, access : RW
output	reg [2:0] r_dprio0_tx_phcomp_rd_delay ,
// register offset : 0x08, field offset : 27, access : RW
output	reg  r_dprio0_tx_double_read ,
// register offset : 0x08, field offset : 28, access : RW
output	reg  r_dprio0_tx_stop_read ,
// register offset : 0x08, field offset : 29, access : RW
output	reg  r_dprio0_tx_stop_write ,
// register offset : 0x0c, field offset : 0, access : RW
output	reg [4:0] r_dprio1_tx_fifo_pempty ,
// register offset : 0x0c, field offset : 5, access : RW
output	reg  r_dprio1_tx_dv_gating_en ,
// register offset : 0x0c, field offset : 6, access : RW
output	reg  r_dprio1_tx_rev_lpbk ,
// register offset : 0x0c, field offset : 7, access : RW
output	reg [4:0] r_dprio1_tx_fifo_pfull ,
// register offset : 0x10, field offset : 0, access : RW
output	reg  r_dprio2_tx_wa_en ,
// register offset : 0x10, field offset : 1, access : RW
output	reg [1:0] r_dprio2_tx_fifo_power_mode ,
// register offset : 0x10, field offset : 8, access : RW
output	reg [2:0] r_dprio2_tx_stretch_num_stages ,
// register offset : 0x10, field offset : 11, access : RW
output	reg [2:0] r_dprio2_tx_datapath_tb_sel ,
// register offset : 0x10, field offset : 14, access : RW
output	reg  r_dprio2_tx_wr_adj_en ,
// register offset : 0x10, field offset : 15, access : RW
output	reg  r_dprio2_tx_rd_adj_en ,
// register offset : 0x10, field offset : 16, access : RW
output	reg  r_dprio2_tx_async_txelecidle_rstval ,
// register offset : 0x10, field offset : 17, access : RW
output	reg  r_dprio2_tx_async_hip_aib_fsr_in_bit0_rstval ,
// register offset : 0x10, field offset : 18, access : RW
output	reg  r_dprio2_tx_async_hip_aib_fsr_in_bit1_rstval ,
// register offset : 0x10, field offset : 19, access : RW
output	reg  r_dprio2_tx_async_hip_aib_fsr_in_bit2_rstval ,
// register offset : 0x10, field offset : 20, access : RW
output	reg  r_dprio2_tx_async_hip_aib_fsr_in_bit3_rstval ,
// register offset : 0x10, field offset : 21, access : RW
output	reg  r_dprio2_tx_async_pld_pmaif_mask_tx_pll_rstval ,
// register offset : 0x10, field offset : 22, access : RW
output	reg  r_dprio2_tx_async_hip_aib_fsr_out_bit0_rstval ,
// register offset : 0x10, field offset : 23, access : RW
output	reg  r_dprio2_tx_async_hip_aib_fsr_out_bit1_rstval ,
// register offset : 0x10, field offset : 24, access : RW
output	reg  r_dprio2_tx_async_hip_aib_fsr_out_bit2_rstval ,
// register offset : 0x10, field offset : 25, access : RW
output	reg  r_dprio2_tx_async_hip_aib_fsr_out_bit3_rstval ,
// register offset : 0x14, field offset : 0, access : RW
output	reg [1:0] r_dprio3_tx_fifo_rd_clk_sel ,
// register offset : 0x14, field offset : 6, access : RW
output	reg  r_dprio3_tx_fifo_wr_clk_scg_en ,
// register offset : 0x14, field offset : 7, access : RW
output	reg  r_dprio3_tx_fifo_rd_clk_scg_en ,
// register offset : 0x14, field offset : 8, access : RW
output	reg  r_dprio3_tx_osc_clk_scg_en ,
// register offset : 0x14, field offset : 9, access : RW
output	reg  r_dprio3_tx_hrdrst_rx_osc_clk_scg_en ,
// register offset : 0x14, field offset : 10, access : RW
output	reg  r_dprio3_tx_hip_osc_clk_scg_en ,
// register offset : 0x14, field offset : 11, access : RW
output	reg  r_dprio3_tx_free_run_div_clk ,
// register offset : 0x14, field offset : 12, access : RW
output	reg  r_dprio3_tx_hrdrst_rst_sm_dis ,
// register offset : 0x14, field offset : 13, access : RW
output	reg  r_dprio3_tx_hrdrst_dcd_caldone_byp ,
// register offset : 0x14, field offset : 14, access : RW
output	reg  r_dprio3_tx_hrdrst_dll_lock_byp ,
// register offset : 0x14, field offset : 15, access : RW
output	reg  r_dprio3_tx_hrdrst_align_byp ,
// register offset : 0x14, field offset : 17, access : RW
output	reg  r_dprio3_tx_hrdrst_user_ctl_en ,
// register offset : 0x18, field offset : 0, access : RW
output	reg [2:0] r_dprio0_rx_chnl_dp_map_mode ,
// register offset : 0x18, field offset : 5, access : RW
output	reg [2:0] r_dprio0_rx_pcs_testbus_sel ,
// register offset : 0x18, field offset : 8, access : RW
output	reg  r_dprio0_rx_pld_8g_a1a2_k1k2_flag_poll_byp ,
// register offset : 0x18, field offset : 9, access : RW
output	reg  r_dprio0_rx_pld_10g_krfec_rx_diag_data_stat_poll_byp ,
// register offset : 0x18, field offset : 10, access : RW
output	reg  r_dprio0_rx_pld_pma_pcie_sw_done_poll_byp ,
// register offset : 0x18, field offset : 11, access : RW
output	reg  r_dprio0_rx_pld_pma_reser_in_poll_byp ,
// register offset : 0x18, field offset : 12, access : RW
output	reg  r_dprio0_rx_pld_pma_testbus_poll_byp ,
// register offset : 0x18, field offset : 13, access : RW
output	reg  r_dprio0_rx_pld_test_data_poll_byp ,
// register offset : 0x18, field offset : 14, access : RW
output	reg  r_dprio0_rx_pld_8g_wa_boundary_poll_byp ,
// register offset : 0x18, field offset : 15, access : RW
output	reg  r_dprio0_rx_pcspma_testbus_sel ,
// register offset : 0x18, field offset : 16, access : RW
output	reg [4:0] r_dprio0_rx_fifo_empty ,
// register offset : 0x18, field offset : 21, access : RW
output	reg [1:0] r_dprio0_rx_fifo_mode ,
// register offset : 0x18, field offset : 23, access : RW
output	reg  r_dprio0_rx_wm_en ,
// register offset : 0x18, field offset : 24, access : RW
output	reg [4:0] r_dprio0_rx_fifo_full ,
// register offset : 0x18, field offset : 29, access : RW
output	reg [2:0] r_dprio0_rx_phcomp_rd_delay ,
// register offset : 0x1c, field offset : 0, access : RW
output	reg  r_dprio1_rx_double_write ,
// register offset : 0x1c, field offset : 1, access : RW
output	reg  r_dprio1_rx_stop_read ,
// register offset : 0x1c, field offset : 2, access : RW
output	reg  r_dprio1_rx_stop_write ,
// register offset : 0x1c, field offset : 4, access : RW
output	reg [4:0] r_dprio1_rx_fifo_pempty ,
// register offset : 0x1c, field offset : 14, access : RW
output	reg [1:0] r_dprio1_rx_adapter_lpbk_mode ,
// register offset : 0x1c, field offset : 24, access : RW
output	reg  r_dprio1_rx_aib_lpbk_en ,
// register offset : 0x20, field offset : 1, access : RW
output	reg [4:0] r_dprio2_rx_fifo_pfull ,
// register offset : 0x20, field offset : 6, access : RW
output	reg [1:0] r_dprio2_rx_fifo_power_mode ,
// register offset : 0x20, field offset : 14, access : RW
output	reg [1:0] r_dprio2_rx_usertest_sel ,
// register offset : 0x20, field offset : 16, access : RW
output	reg  r_dprio2_rx_hrdrst_user_ctl_en ,
// register offset : 0x20, field offset : 17, access : RW
output	reg  r_dprio2_rx_wr_adj_en ,
// register offset : 0x20, field offset : 18, access : RW
output	reg  r_dprio2_rx_rd_adj_en ,
// register offset : 0x20, field offset : 19, access : RW
output	reg  r_dprio2_rx_msb_rdptr_pipe_byp ,
// register offset : 0x20, field offset : 21, access : RW
output	reg  r_dprio2_rx_async_ltr_rstval ,
// register offset : 0x20, field offset : 22, access : RW
output	reg  r_dprio2_rx_async_ltd_b_rstval ,
// register offset : 0x20, field offset : 23, access : RW
output	reg  r_dprio2_rx_async_pld_8g_sig_det_out_rstval ,
// register offset : 0x20, field offset : 24, access : RW
output	reg  r_dprio2_rx_async_pld_10g_rx_crc32_err_rstval ,
// register offset : 0x20, field offset : 25, access : RW
output	reg  r_dprio2_rx_async_rx_fifo_align_clr_rstval ,
// register offset : 0x20, field offset : 26, access : RW
output	reg  r_dprio2_rx_async_hip_en ,
// register offset : 0x20, field offset : 27, access : RW
output	reg [1:0] r_dprio2_rx_parity_sel ,
// register offset : 0x20, field offset : 29, access : RW
output	reg [2:0] r_dprio2_rx_stretch_num_stages ,
// register offset : 0x24, field offset : 0, access : RW
output	reg [3:0] r_dprio3_rx_datapath_tb_sel ,
// register offset : 0x24, field offset : 4, access : RW
output	reg  r_dprio3_rx_internal_clk1_sel0 ,
// register offset : 0x24, field offset : 5, access : RW
output	reg  r_dprio3_rx_internal_clk1_sel1 ,
// register offset : 0x24, field offset : 6, access : RW
output	reg  r_dprio3_rx_internal_clk1_sel2 ,
// register offset : 0x24, field offset : 7, access : RW
output	reg  r_dprio3_rx_internal_clk1_sel3 ,
// register offset : 0x24, field offset : 8, access : RW
output	reg  r_dprio3_rx_txfiford_prect_sel ,
// register offset : 0x24, field offset : 9, access : RW
output	reg  r_dprio3_rx_txfiford_postct_sel ,
// register offset : 0x24, field offset : 10, access : RW
output	reg  r_dprio3_rx_txfifowr_postct_sel ,
// register offset : 0x24, field offset : 11, access : RW
output	reg  r_dprio3_rx_txfifowr_from_aib_sel ,
// register offset : 0x24, field offset : 12, access : RW
output	reg  r_dprio3_rx_rxfiford_to_aib_sel ,
// register offset : 0x24, field offset : 13, access : RW
output	reg [2:0] r_dprio3_rx_fifo_wr_clk_sel ,
// register offset : 0x24, field offset : 16, access : RW
output	reg [2:0] r_dprio3_rx_fifo_rd_clk_sel ,
// register offset : 0x24, field offset : 19, access : RW
output	reg  r_dprio3_rx_latency_src_sel ,
// register offset : 0x24, field offset : 20, access : RW
output	reg [3:0] r_dprio3_rx_internal_clk1_sel ,
// register offset : 0x24, field offset : 24, access : RW
output	reg [3:0] r_dprio3_rx_internal_clk2_sel ,
// register offset : 0x24, field offset : 28, access : RW
output	reg  r_dprio3_rx_fifo_wr_clk_scg_en ,
// register offset : 0x24, field offset : 29, access : RW
output	reg  r_dprio3_rx_fifo_rd_clk_scg_en ,
// register offset : 0x24, field offset : 30, access : RW
output	reg  r_dprio3_rx_osc_clk_scg_en ,
// register offset : 0x24, field offset : 31, access : RW
output	reg  r_dprio3_rx_hrdrst_rx_osc_clk_scg_en ,
// register offset : 0x28, field offset : 0, access : RW
output	reg  r_dprio4_rx_pma_coreclkin_sel ,
// register offset : 0x28, field offset : 1, access : RW
output	reg  r_dprio4_rx_free_run_div_clk ,
// register offset : 0x28, field offset : 2, access : RW
output	reg  r_dprio4_rx_hrdrst_rst_sm_dis ,
// register offset : 0x28, field offset : 3, access : RW
output	reg  r_dprio4_rx_hrdrst_dcd_caldone_byp ,
// register offset : 0x28, field offset : 4, access : RW
output	reg  r_dprio4_rx_rmfflag_stretch_en ,
// register offset : 0x28, field offset : 5, access : RW
output	reg [2:0] r_dprio4_rx_rmfflag_stretch_num_stages ,
// register offset : 0x28, field offset : 8, access : RW
output	reg  r_dprio4_rx_internal_clk2_sel0 ,
// register offset : 0x28, field offset : 9, access : RW
output	reg  r_dprio4_rx_internal_clk2_sel1 ,
// register offset : 0x28, field offset : 10, access : RW
output	reg  r_dprio4_rx_internal_clk2_sel2 ,
// register offset : 0x28, field offset : 11, access : RW
output	reg  r_dprio4_rx_internal_clk2_sel3 ,
// register offset : 0x28, field offset : 12, access : RW
output	reg  r_dprio4_rx_rxfifowr_prect_sel ,
// register offset : 0x28, field offset : 13, access : RW
output	reg  r_dprio4_rx_rxfifowr_postct_sel ,
// register offset : 0x28, field offset : 14, access : RW
output	reg  r_dprio4_rx_rxfiford_postct_sel ,
// register offset : 0x2c, field offset : 0, access : RO
output	reg [7:0] r_dprio_status_rx_chnl ,
// register offset : 0x2c, field offset : 8, access : RO
output	reg [7:0] r_dprio_status_tx_chnl ,
// register offset : 0x2c, field offset : 16, access : RO
output	reg [7:0] r_dprio_status_sr ,
// register offset : 0x30, field offset : 0, access : RW
output	reg [7:0] r_aibdprio0_aib_dprio0_ctrl_0 ,
// register offset : 0x30, field offset : 8, access : RW
output	reg [7:0] r_aibdprio0_aib_dprio0_ctrl_1 ,
// register offset : 0x30, field offset : 16, access : RW
output	reg [7:0] r_aibdprio0_aib_dprio0_ctrl_2 ,
// register offset : 0x30, field offset : 24, access : RW
output	reg [7:0] r_aibdprio0_aib_dprio0_ctrl_3 ,
// register offset : 0x34, field offset : 0, access : RW
output	reg [7:0] r_aibdprio1_aib_dprio1_ctrl_4 ,
// register offset : 0x38, field offset : 0, access : RW
output	reg [15:0] r_dprio_sr_reserved ,
// register offset : 0x3c, field offset : 0, access : RW
output	reg [7:0] r_dprio_avmm1_reserved ,
// register offset : 0x40, field offset : 0, access : RW
output	reg [7:0] r_dprio_avmm2_reserved ,
// register offset : 0xfc, field offset : 0, access : RW
output	reg [7:0] r_spare0_rsvd ,
// register offset : 0xfc, field offset : 16, access : RW
output	reg [3:0] r_spare0_rsvd_prst ,
input   crssm_cfg_active,
// register offset : r_usr_outbox, field offset : 31, access : RW
input    r_usr_outbox_send_msg_i,
// register offset : r_usr_inbox, field offset : 0, access : RO
input  [29:0]  r_usr_inbox_usr_msg_i,
// register offset : r_usr_inbox, field offset : 31, access : RO
input    r_usr_inbox_new_msg_i,
// register offset : r_dprio_status, field offset : 0, access : RO
input  [7:0]  r_dprio_status_rx_chnl_i,
// register offset : r_dprio_status, field offset : 8, access : RO
input  [7:0]  r_dprio_status_tx_chnl_i,
// register offset : r_dprio_status, field offset : 16, access : RO
input  [7:0]  r_dprio_status_sr_i,
// register offset : r_spare0, field offset : 0, access : RW
input  [7:0]  r_spare0_rsvd_i,
// register offset : r_spare0, field offset : 16, access : RW
input  [3:0]  r_spare0_rsvd_prst_i,
// Interrupt Ports
//Bus Interface
input clk,

input reset,
input [31:0] writedata,
input read,
input write,
input [3:0] byteenable,
output reg [31:0] readdata,
output reg readdatavalid,
input [7:0] address

);

wire reset_n = !reset;	

// Protocol management
// combinatorial read data signal declaration
reg [31:0] rdata_comb;

// synchronous process for the read
always @(negedge reset_n ,posedge clk)  
   if (!reset_n) readdata[31:0] <= 32'h0; else readdata[31:0] <= rdata_comb[31:0];

// read data is always returned on the next cycle
always @(negedge reset_n , posedge clk)
   if (!reset_n) readdatavalid <= 1'b0; else readdatavalid <= read;
//
//  Protocol specific assignment to inside signals
//
wire  we = write;
wire  re = read;
wire [7:0] addr = address[7:0];
wire [31:0] din  = writedata [31:0];
// A write byte enable for each register
// register r_usr_outbox with  writeType:  write
wire	[3:0]  we_r_usr_outbox		=	we  & (addr[7:0]  == 8'h00)	?	byteenable[3:0]	:	{4{1'b0}};
// register r_usr_inbox with  writeType:  write
wire	  we_r_usr_inbox		=	we  & (addr[7:0]  == 8'h04)	?	byteenable[3]	:	1'b0;
// register r_dprio0_tx with  writeType:  write
wire	[3:0]  we_r_dprio0_tx		=	we  & (addr[7:0]  == 8'h08)	?	byteenable[3:0]	:	{4{1'b0}};
// register r_dprio1_tx with  writeType:  write
wire	[1:0]  we_r_dprio1_tx		=	we  & (addr[7:0]  == 8'h0c)	?	byteenable[1:0]	:	{2{1'b0}};
// register r_dprio2_tx with  writeType:  write
wire	[3:0]  we_r_dprio2_tx		=	we  & (addr[7:0]  == 8'h10)	?	byteenable[3:0]	:	{4{1'b0}};
// register r_dprio3_tx with  writeType:  write
wire	[2:0]  we_r_dprio3_tx		=	we  & (addr[7:0]  == 8'h14)	?	byteenable[2:0]	:	{3{1'b0}};
// register r_dprio0_rx with  writeType:  write
wire	[3:0]  we_r_dprio0_rx		=	we  & (addr[7:0]  == 8'h18)	?	byteenable[3:0]	:	{4{1'b0}};
// register r_dprio1_rx with  writeType:  write
wire	[3:0]  we_r_dprio1_rx		=	we  & (addr[7:0]  == 8'h1c)	?	byteenable[3:0]	:	{4{1'b0}};
// register r_dprio2_rx with  writeType:  write
wire	[3:0]  we_r_dprio2_rx		=	we  & (addr[7:0]  == 8'h20)	?	byteenable[3:0]	:	{4{1'b0}};
// register r_dprio3_rx with  writeType:  write
wire	[3:0]  we_r_dprio3_rx		=	we  & (addr[7:0]  == 8'h24)	?	byteenable[3:0]	:	{4{1'b0}};
// register r_dprio4_rx with  writeType:  write
wire	[1:0]  we_r_dprio4_rx		=	we  & (addr[7:0]  == 8'h28)	?	byteenable[1:0]	:	{2{1'b0}};
// register r_aibdprio0 with  writeType:  write
wire	[3:0]  we_r_aibdprio0		=	we  & (addr[7:0]  == 8'h30)	?	byteenable[3:0]	:	{4{1'b0}};
// register r_aibdprio1 with  writeType:  write
wire	  we_r_aibdprio1		=	we  & (addr[7:0]  == 8'h34)	?	byteenable[0]	:	1'b0;
// register r_dprio_sr with  writeType:  write
wire	[1:0]  we_r_dprio_sr		=	we  & (addr[7:0]  == 8'h38)	?	byteenable[1:0]	:	{2{1'b0}};
// register r_dprio_avmm1 with  writeType:  write
wire	  we_r_dprio_avmm1		=	we  & (addr[7:0]  == 8'h3c)	?	byteenable[0]	:	1'b0;
// register r_dprio_avmm2 with  writeType:  write
wire	  we_r_dprio_avmm2		=	we  & (addr[7:0]  == 8'h40)	?	byteenable[0]	:	1'b0;
// register r_spare0 with  writeType:  write
wire	[2:0]  we_r_spare0		=	we  & (addr[7:0]  == 8'hfc)	?	byteenable[2:0]	:	{3{1'b0}};

// A read byte 	enable for each register


/* Definitions of REGISTER "r_usr_outbox" */

// r_usr_outbox_usr_msg
// bitfield description: Message to send
// customType  RW
// hwAccess: RO 
// reset value : 0x00000000 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_usr_outbox_usr_msg <= 30'h00000000;
   end
   else begin
      if (we_r_usr_outbox[0]) begin 
         r_usr_outbox_usr_msg[7:0]   <=  din[7:0];  //
      end
      if (we_r_usr_outbox[1]) begin 
         r_usr_outbox_usr_msg[15:8]   <=  din[15:8];  //
      end
      if (we_r_usr_outbox[2]) begin 
         r_usr_outbox_usr_msg[23:16]   <=  din[23:16];  //
      end
      if (we_r_usr_outbox[3]) begin 
         r_usr_outbox_usr_msg[29:24]   <=  din[29:24];  //
      end
end

// r_usr_outbox_send_msg
// bitfield description: 1: Initiate message transfer (auto-clear)
// customType  RW
// hwAccess: RW 
// reset value : 0x0 
// inputPort: "EMPTY" 
// outputPort:  "" 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_usr_outbox_send_msg <= 1'h0;
   end
   else begin
      if (we_r_usr_outbox[3]) begin 
         r_usr_outbox_send_msg   <=  din[31];  //
      end
      else begin 
         r_usr_outbox_send_msg   <=  r_usr_outbox_send_msg_i ;
      end
end

/* Definitions of REGISTER "r_usr_inbox" */

// r_usr_inbox_usr_msg
// bitfield description: Message received
// customType  RO
// hwAccess: RW 
// reset value : 0x00000000 
// inputPort: "EMPTY" 
// outputPort:  "" 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_usr_inbox_usr_msg <= 30'h00000000;
   end
   else begin
         r_usr_inbox_usr_msg[29:0]   <=  r_usr_inbox_usr_msg_i[29:0] ;
end

// r_usr_inbox_autoclear_dis
// bitfield description: Disable message status auto-clear. 
// 
// 1: Message status auto-clear disabled
// 
// 0: Message status auto-clear enabled mode
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_usr_inbox_autoclear_dis <= 1'h0;
   end
   else begin
      if (we_r_usr_inbox) begin 
         r_usr_inbox_autoclear_dis   <=  din[30];  //
      end
end

// r_usr_inbox_new_msg
// bitfield description: Message status 
// 
// 1: New message. (Clears on read)
// 
// 0: No new message
// customType  RO
// hwAccess: RW 
// reset value : 0x0 
// inputPort: "EMPTY" 
// outputPort:  "" 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_usr_inbox_new_msg <= 1'h0;
   end
   else begin
         r_usr_inbox_new_msg   <=  r_usr_inbox_new_msg_i ;
end

/* Definitions of REGISTER "r_dprio0_tx" */

// r_dprio0_tx_chnl_dp_map_mode
// bitfield description: Datapath Map Mode 
// 3'b000: disabled
// 
// 3'b001: EHIP mode
// 
// 3'b010: ELANE mode
// 
// 3'b011: RSFEC mode
// 
// 3'b100: PMA-DIRECT mode
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio0_tx_chnl_dp_map_mode <= 3'h0;
   end
   else begin
      if (we_r_dprio0_tx[0]) begin 
         r_dprio0_tx_chnl_dp_map_mode[2:0]   <=  din[2:0];  //
      end
end

// r_dprio0_tx_usertest_sel
// bitfield description: User Test Sel
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio0_tx_usertest_sel <= 1'h0;
   end
   else begin
      if (we_r_dprio0_tx[1]) begin 
         r_dprio0_tx_usertest_sel   <=  din[9];  //
      end
end

// r_dprio0_tx_fifo_empty
// bitfield description: TX FIFO Empty
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio0_tx_fifo_empty <= 5'h00;
   end
   else begin
      if (we_r_dprio0_tx[1]) begin 
         r_dprio0_tx_fifo_empty[4:0]   <=  din[15:11];  //
      end
end

// r_dprio0_tx_fifo_full
// bitfield description: FIFO Full
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio0_tx_fifo_full <= 5'h00;
   end
   else begin
      if (we_r_dprio0_tx[2]) begin 
         r_dprio0_tx_fifo_full[4:0]   <=  din[23:19];  //
      end
end

// r_dprio0_tx_phcomp_rd_delay
// bitfield description: TX FIFO Phase-comp Read Delay
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio0_tx_phcomp_rd_delay <= 3'h0;
   end
   else begin
      if (we_r_dprio0_tx[3]) begin 
         r_dprio0_tx_phcomp_rd_delay[2:0]   <=  din[26:24];  //
      end
end

// r_dprio0_tx_double_read
// bitfield description: TX Double Read
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio0_tx_double_read <= 1'h0;
   end
   else begin
      if (we_r_dprio0_tx[3]) begin 
         r_dprio0_tx_double_read   <=  din[27];  //
      end
end

// r_dprio0_tx_stop_read
// bitfield description: Stop Read
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio0_tx_stop_read <= 1'h0;
   end
   else begin
      if (we_r_dprio0_tx[3]) begin 
         r_dprio0_tx_stop_read   <=  din[28];  //
      end
end

// r_dprio0_tx_stop_write
// bitfield description: Stop Write
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio0_tx_stop_write <= 1'h0;
   end
   else begin
      if (we_r_dprio0_tx[3]) begin 
         r_dprio0_tx_stop_write   <=  din[29];  //
      end
end

/* Definitions of REGISTER "r_dprio1_tx" */

// r_dprio1_tx_fifo_pempty
// bitfield description: FIFO Almost Empty Threshold
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio1_tx_fifo_pempty <= 5'h00;
   end
   else begin
      if (we_r_dprio1_tx[0]) begin 
         r_dprio1_tx_fifo_pempty[4:0]   <=  din[4:0];  //
      end
end

// r_dprio1_tx_dv_gating_en
// bitfield description: DV Gating
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio1_tx_dv_gating_en <= 1'h0;
   end
   else begin
      if (we_r_dprio1_tx[0]) begin 
         r_dprio1_tx_dv_gating_en   <=  din[5];  //
      end
end

// r_dprio1_tx_rev_lpbk
// bitfield description: Reverse Loopback
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio1_tx_rev_lpbk <= 1'h0;
   end
   else begin
      if (we_r_dprio1_tx[0]) begin 
         r_dprio1_tx_rev_lpbk   <=  din[6];  //
      end
end

// r_dprio1_tx_fifo_pfull
// bitfield description: FIFO Almost Full Threshold
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio1_tx_fifo_pfull <= 5'h00;
   end
   else begin
      if (we_r_dprio1_tx[0]) begin 
         r_dprio1_tx_fifo_pfull[0]   <=  din[7];  //
      end
      if (we_r_dprio1_tx[1]) begin 
         r_dprio1_tx_fifo_pfull[4:1]   <=  din[11:8];  //
      end
end

/* Definitions of REGISTER "r_dprio2_tx" */

// r_dprio2_tx_wa_en
// bitfield description: Word Alignment Enable
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio2_tx_wa_en <= 1'h0;
   end
   else begin
      if (we_r_dprio2_tx[0]) begin 
         r_dprio2_tx_wa_en   <=  din[0];  //
      end
end

// r_dprio2_tx_fifo_power_mode
// bitfield description: TX FIFO Power-Saving Mode
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio2_tx_fifo_power_mode <= 2'h0;
   end
   else begin
      if (we_r_dprio2_tx[0]) begin 
         r_dprio2_tx_fifo_power_mode[1:0]   <=  din[2:1];  //
      end
end

// r_dprio2_tx_stretch_num_stages
// bitfield description: TX Signal Stretch Num Stages
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio2_tx_stretch_num_stages <= 3'h0;
   end
   else begin
      if (we_r_dprio2_tx[1]) begin 
         r_dprio2_tx_stretch_num_stages[2:0]   <=  din[10:8];  //
      end
end

// r_dprio2_tx_datapath_tb_sel
// bitfield description: TX Datapath Testbus Sel
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio2_tx_datapath_tb_sel <= 3'h0;
   end
   else begin
      if (we_r_dprio2_tx[1]) begin 
         r_dprio2_tx_datapath_tb_sel[2:0]   <=  din[13:11];  //
      end
end

// r_dprio2_tx_wr_adj_en
// bitfield description: TX FIFO Write-side Adjustment Enable
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio2_tx_wr_adj_en <= 1'h0;
   end
   else begin
      if (we_r_dprio2_tx[1]) begin 
         r_dprio2_tx_wr_adj_en   <=  din[14];  //
      end
end

// r_dprio2_tx_rd_adj_en
// bitfield description: TX FIFO Read-side Adjustment Enable
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio2_tx_rd_adj_en <= 1'h0;
   end
   else begin
      if (we_r_dprio2_tx[1]) begin 
         r_dprio2_tx_rd_adj_en   <=  din[15];  //
      end
end

// r_dprio2_tx_async_txelecidle_rstval
// bitfield description: TX Elec Idle Reset Val
// customType  RW
// hwAccess: RO 
// reset value : 0x0 
// software enable:  "crssm_cfg_active"  

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio2_tx_async_txelecidle_rstval <= 1'h0;
   end
   else begin
      if (we_r_dprio2_tx[2] && crssm_cfg_active) begin 
         r_dprio2_tx_async_txelecidle_rstval   <=  din[16];  //
      end
end

// r_dprio2_tx_async_hip_aib_fsr_in_bit0_rstval
// bitfield description: HIP AIB FSR-in Bit 0 Reset Val
// customType  RW
// hwAccess: RO 
// reset value : 0x0 
// software enable:  "crssm_cfg_active"  

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio2_tx_async_hip_aib_fsr_in_bit0_rstval <= 1'h0;
   end
   else begin
      if (we_r_dprio2_tx[2] && crssm_cfg_active) begin 
         r_dprio2_tx_async_hip_aib_fsr_in_bit0_rstval   <=  din[17];  //
      end
end

// r_dprio2_tx_async_hip_aib_fsr_in_bit1_rstval
// bitfield description: HIP AIB FSR-in Bit 1 Reset Val
// customType  RW
// hwAccess: RO 
// reset value : 0x0 
// software enable:  "crssm_cfg_active"  

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio2_tx_async_hip_aib_fsr_in_bit1_rstval <= 1'h0;
   end
   else begin
      if (we_r_dprio2_tx[2] && crssm_cfg_active) begin 
         r_dprio2_tx_async_hip_aib_fsr_in_bit1_rstval   <=  din[18];  //
      end
end

// r_dprio2_tx_async_hip_aib_fsr_in_bit2_rstval
// bitfield description: HIP AIB FSR-in Bit 2 Reset Val
// customType  RW
// hwAccess: RO 
// reset value : 0x0 
// software enable:  "crssm_cfg_active"  

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio2_tx_async_hip_aib_fsr_in_bit2_rstval <= 1'h0;
   end
   else begin
      if (we_r_dprio2_tx[2] && crssm_cfg_active) begin 
         r_dprio2_tx_async_hip_aib_fsr_in_bit2_rstval   <=  din[19];  //
      end
end

// r_dprio2_tx_async_hip_aib_fsr_in_bit3_rstval
// bitfield description: HIP AIB FSR-in Bit 3 Reset Val
// customType  RW
// hwAccess: RO 
// reset value : 0x0 
// software enable:  "crssm_cfg_active"  

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio2_tx_async_hip_aib_fsr_in_bit3_rstval <= 1'h0;
   end
   else begin
      if (we_r_dprio2_tx[2] && crssm_cfg_active) begin 
         r_dprio2_tx_async_hip_aib_fsr_in_bit3_rstval   <=  din[20];  //
      end
end

// r_dprio2_tx_async_pld_pmaif_mask_tx_pll_rstval
// bitfield description: PLD PMAIF Mask TX PLL Reset Val
// customType  RW
// hwAccess: RO 
// reset value : 0x0 
// software enable:  "crssm_cfg_active"  

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio2_tx_async_pld_pmaif_mask_tx_pll_rstval <= 1'h0;
   end
   else begin
      if (we_r_dprio2_tx[2] && crssm_cfg_active) begin 
         r_dprio2_tx_async_pld_pmaif_mask_tx_pll_rstval   <=  din[21];  //
      end
end

// r_dprio2_tx_async_hip_aib_fsr_out_bit0_rstval
// bitfield description: HIP AIB FSR-out Bit 0 Reset Val
// customType  RW
// hwAccess: RO 
// reset value : 0x0 
// software enable:  "crssm_cfg_active"  

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio2_tx_async_hip_aib_fsr_out_bit0_rstval <= 1'h0;
   end
   else begin
      if (we_r_dprio2_tx[2] && crssm_cfg_active) begin 
         r_dprio2_tx_async_hip_aib_fsr_out_bit0_rstval   <=  din[22];  //
      end
end

// r_dprio2_tx_async_hip_aib_fsr_out_bit1_rstval
// bitfield description: HIP AIB FSR-out Bit 1 Reset Val
// customType  RW
// hwAccess: RO 
// reset value : 0x0 
// software enable:  "crssm_cfg_active"  

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio2_tx_async_hip_aib_fsr_out_bit1_rstval <= 1'h0;
   end
   else begin
      if (we_r_dprio2_tx[2] && crssm_cfg_active) begin 
         r_dprio2_tx_async_hip_aib_fsr_out_bit1_rstval   <=  din[23];  //
      end
end

// r_dprio2_tx_async_hip_aib_fsr_out_bit2_rstval
// bitfield description: HIP AIB FSR-out Bit 2 Reset Val
// customType  RW
// hwAccess: RO 
// reset value : 0x0 
// software enable:  "crssm_cfg_active"  

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio2_tx_async_hip_aib_fsr_out_bit2_rstval <= 1'h0;
   end
   else begin
      if (we_r_dprio2_tx[3] && crssm_cfg_active) begin 
         r_dprio2_tx_async_hip_aib_fsr_out_bit2_rstval   <=  din[24];  //
      end
end

// r_dprio2_tx_async_hip_aib_fsr_out_bit3_rstval
// bitfield description: HIP AIB FSR-out Bit 3 Reset Val
// customType  RW
// hwAccess: RO 
// reset value : 0x0 
// software enable:  "crssm_cfg_active"  

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio2_tx_async_hip_aib_fsr_out_bit3_rstval <= 1'h0;
   end
   else begin
      if (we_r_dprio2_tx[3] && crssm_cfg_active) begin 
         r_dprio2_tx_async_hip_aib_fsr_out_bit3_rstval   <=  din[25];  //
      end
end

/* Definitions of REGISTER "r_dprio3_tx" */

// r_dprio3_tx_fifo_rd_clk_sel
// bitfield description: TX FIFO read-side clock sel
// 2'b01: scan_user_clk2
// 2'b01: tx_ehip_clk
// 2'b10: tx_rsfec_clk
// 2'b11: tx_elane_clk
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio3_tx_fifo_rd_clk_sel <= 2'h0;
   end
   else begin
      if (we_r_dprio3_tx[0]) begin 
         r_dprio3_tx_fifo_rd_clk_sel[1:0]   <=  din[1:0];  //
      end
end

// r_dprio3_tx_fifo_wr_clk_scg_en
// bitfield description: TX FIFO Write-side Static Clock Gating Enable
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio3_tx_fifo_wr_clk_scg_en <= 1'h0;
   end
   else begin
      if (we_r_dprio3_tx[0]) begin 
         r_dprio3_tx_fifo_wr_clk_scg_en   <=  din[6];  //
      end
end

// r_dprio3_tx_fifo_rd_clk_scg_en
// bitfield description: TX FIFO Read-side Static Clock Gating Enable
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio3_tx_fifo_rd_clk_scg_en <= 1'h0;
   end
   else begin
      if (we_r_dprio3_tx[0]) begin 
         r_dprio3_tx_fifo_rd_clk_scg_en   <=  din[7];  //
      end
end

// r_dprio3_tx_osc_clk_scg_en
// bitfield description: Oscillator Clock Clock Gating Enable
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio3_tx_osc_clk_scg_en <= 1'h0;
   end
   else begin
      if (we_r_dprio3_tx[1]) begin 
         r_dprio3_tx_osc_clk_scg_en   <=  din[8];  //
      end
end

// r_dprio3_tx_hrdrst_rx_osc_clk_scg_en
// bitfield description: TX Hard Reset Oscillator SCG Enable
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio3_tx_hrdrst_rx_osc_clk_scg_en <= 1'h0;
   end
   else begin
      if (we_r_dprio3_tx[1]) begin 
         r_dprio3_tx_hrdrst_rx_osc_clk_scg_en   <=  din[9];  //
      end
end

// r_dprio3_tx_hip_osc_clk_scg_en
// bitfield description: HIP Osc Clock SCG Enable
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio3_tx_hip_osc_clk_scg_en <= 1'h0;
   end
   else begin
      if (we_r_dprio3_tx[1]) begin 
         r_dprio3_tx_hip_osc_clk_scg_en   <=  din[10];  //
      end
end

// r_dprio3_tx_free_run_div_clk
// bitfield description: TX Free-run Div Clock
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio3_tx_free_run_div_clk <= 1'h0;
   end
   else begin
      if (we_r_dprio3_tx[1]) begin 
         r_dprio3_tx_free_run_div_clk   <=  din[11];  //
      end
end

// r_dprio3_tx_hrdrst_rst_sm_dis
// bitfield description: Hard Reset State Machine Disable
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio3_tx_hrdrst_rst_sm_dis <= 1'h0;
   end
   else begin
      if (we_r_dprio3_tx[1]) begin 
         r_dprio3_tx_hrdrst_rst_sm_dis   <=  din[12];  //
      end
end

// r_dprio3_tx_hrdrst_dcd_caldone_byp
// bitfield description: Hard Reset DCD Cal Done Bypass
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio3_tx_hrdrst_dcd_caldone_byp <= 1'h0;
   end
   else begin
      if (we_r_dprio3_tx[1]) begin 
         r_dprio3_tx_hrdrst_dcd_caldone_byp   <=  din[13];  //
      end
end

// r_dprio3_tx_hrdrst_dll_lock_byp
// bitfield description: Hard Reset DLL Lock Bypass
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio3_tx_hrdrst_dll_lock_byp <= 1'h0;
   end
   else begin
      if (we_r_dprio3_tx[1]) begin 
         r_dprio3_tx_hrdrst_dll_lock_byp   <=  din[14];  //
      end
end

// r_dprio3_tx_hrdrst_align_byp
// bitfield description: Hard Reset Align Bypass
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio3_tx_hrdrst_align_byp <= 1'h0;
   end
   else begin
      if (we_r_dprio3_tx[1]) begin 
         r_dprio3_tx_hrdrst_align_byp   <=  din[15];  //
      end
end

// r_dprio3_tx_hrdrst_user_ctl_en
// bitfield description: Hard Reset User Control Enable
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio3_tx_hrdrst_user_ctl_en <= 1'h0;
   end
   else begin
      if (we_r_dprio3_tx[2]) begin 
         r_dprio3_tx_hrdrst_user_ctl_en   <=  din[17];  //
      end
end

/* Definitions of REGISTER "r_dprio0_rx" */

// r_dprio0_rx_chnl_dp_map_mode
// bitfield description: Datapath Map Mode 
// 3'b000: disabled
// 
// 3'b001: EHIP mode
// br]
// 3'b010: ELANE mode
// br]
// 3'b011: RSFEC mode
// br]
// 3'b100: PMA-DIRECT mode
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio0_rx_chnl_dp_map_mode <= 3'h0;
   end
   else begin
      if (we_r_dprio0_rx[0]) begin 
         r_dprio0_rx_chnl_dp_map_mode[2:0]   <=  din[2:0];  //
      end
end

// r_dprio0_rx_pcs_testbus_sel
// bitfield description: PCS Testbus Select
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio0_rx_pcs_testbus_sel <= 3'h0;
   end
   else begin
      if (we_r_dprio0_rx[0]) begin 
         r_dprio0_rx_pcs_testbus_sel[2:0]   <=  din[7:5];  //
      end
end

// r_dprio0_rx_pld_8g_a1a2_k1k2_flag_poll_byp
// bitfield description: 8G a1a2_k1k2 Flag Polling Bypass
// customType  RW
// hwAccess: RO 
// reset value : 0x0 
// software enable:  "crssm_cfg_active"  

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio0_rx_pld_8g_a1a2_k1k2_flag_poll_byp <= 1'h0;
   end
   else begin
      if (we_r_dprio0_rx[1] && crssm_cfg_active) begin 
         r_dprio0_rx_pld_8g_a1a2_k1k2_flag_poll_byp   <=  din[8];  //
      end
end

// r_dprio0_rx_pld_10g_krfec_rx_diag_data_stat_poll_byp
// bitfield description: 10G KRFEC RX Diag Stat Polling Bypass
// customType  RW
// hwAccess: RO 
// reset value : 0x0 
// software enable:  "crssm_cfg_active"  

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio0_rx_pld_10g_krfec_rx_diag_data_stat_poll_byp <= 1'h0;
   end
   else begin
      if (we_r_dprio0_rx[1] && crssm_cfg_active) begin 
         r_dprio0_rx_pld_10g_krfec_rx_diag_data_stat_poll_byp   <=  din[9];  //
      end
end

// r_dprio0_rx_pld_pma_pcie_sw_done_poll_byp
// bitfield description: PMA PCIe SW-Done Polling Bypass
// customType  RW
// hwAccess: RO 
// reset value : 0x0 
// software enable:  "crssm_cfg_active"  

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio0_rx_pld_pma_pcie_sw_done_poll_byp <= 1'h0;
   end
   else begin
      if (we_r_dprio0_rx[1] && crssm_cfg_active) begin 
         r_dprio0_rx_pld_pma_pcie_sw_done_poll_byp   <=  din[10];  //
      end
end

// r_dprio0_rx_pld_pma_reser_in_poll_byp
// bitfield description: PMA Reser-In Polling Bypass
// customType  RW
// hwAccess: RO 
// reset value : 0x0 
// software enable:  "crssm_cfg_active"  

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio0_rx_pld_pma_reser_in_poll_byp <= 1'h0;
   end
   else begin
      if (we_r_dprio0_rx[1] && crssm_cfg_active) begin 
         r_dprio0_rx_pld_pma_reser_in_poll_byp   <=  din[11];  //
      end
end

// r_dprio0_rx_pld_pma_testbus_poll_byp
// bitfield description: PMA Testbus Polling Bypass
// customType  RW
// hwAccess: RO 
// reset value : 0x0 
// software enable:  "crssm_cfg_active"  

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio0_rx_pld_pma_testbus_poll_byp <= 1'h0;
   end
   else begin
      if (we_r_dprio0_rx[1] && crssm_cfg_active) begin 
         r_dprio0_rx_pld_pma_testbus_poll_byp   <=  din[12];  //
      end
end

// r_dprio0_rx_pld_test_data_poll_byp
// bitfield description: Test Data Polling Bypass
// customType  RW
// hwAccess: RO 
// reset value : 0x0 
// software enable:  "crssm_cfg_active"  

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio0_rx_pld_test_data_poll_byp <= 1'h0;
   end
   else begin
      if (we_r_dprio0_rx[1] && crssm_cfg_active) begin 
         r_dprio0_rx_pld_test_data_poll_byp   <=  din[13];  //
      end
end

// r_dprio0_rx_pld_8g_wa_boundary_poll_byp
// bitfield description: 8G Word Align Boundary Polling Bypass
// customType  RW
// hwAccess: RO 
// reset value : 0x0 
// software enable:  "crssm_cfg_active"  

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio0_rx_pld_8g_wa_boundary_poll_byp <= 1'h0;
   end
   else begin
      if (we_r_dprio0_rx[1] && crssm_cfg_active) begin 
         r_dprio0_rx_pld_8g_wa_boundary_poll_byp   <=  din[14];  //
      end
end

// r_dprio0_rx_pcspma_testbus_sel
// bitfield description: PCS/PMA Testbus Sel
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio0_rx_pcspma_testbus_sel <= 1'h0;
   end
   else begin
      if (we_r_dprio0_rx[1]) begin 
         r_dprio0_rx_pcspma_testbus_sel   <=  din[15];  //
      end
end

// r_dprio0_rx_fifo_empty
// bitfield description: RX FIFO Empty
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio0_rx_fifo_empty <= 5'h00;
   end
   else begin
      if (we_r_dprio0_rx[2]) begin 
         r_dprio0_rx_fifo_empty[4:0]   <=  din[20:16];  //
      end
end

// r_dprio0_rx_fifo_mode
// bitfield description: RX FIFO Mode
// 2'b00: Bypass mode
// 2'b01: Phase-comp mode
// others: Reserved
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio0_rx_fifo_mode <= 2'h0;
   end
   else begin
      if (we_r_dprio0_rx[2]) begin 
         r_dprio0_rx_fifo_mode[1:0]   <=  din[22:21];  //
      end
end

// r_dprio0_rx_wm_en
// bitfield description: Word Mark Enable
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio0_rx_wm_en <= 1'h0;
   end
   else begin
      if (we_r_dprio0_rx[2]) begin 
         r_dprio0_rx_wm_en   <=  din[23];  //
      end
end

// r_dprio0_rx_fifo_full
// bitfield description: RX FIFO Full
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio0_rx_fifo_full <= 5'h00;
   end
   else begin
      if (we_r_dprio0_rx[3]) begin 
         r_dprio0_rx_fifo_full[4:0]   <=  din[28:24];  //
      end
end

// r_dprio0_rx_phcomp_rd_delay
// bitfield description: RX FIFO Phase-Comp Read Delay
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio0_rx_phcomp_rd_delay <= 3'h0;
   end
   else begin
      if (we_r_dprio0_rx[3]) begin 
         r_dprio0_rx_phcomp_rd_delay[2:0]   <=  din[31:29];  //
      end
end

/* Definitions of REGISTER "r_dprio1_rx" */

// r_dprio1_rx_double_write
// bitfield description: RX FIFO Double Write
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio1_rx_double_write <= 1'h0;
   end
   else begin
      if (we_r_dprio1_rx[0]) begin 
         r_dprio1_rx_double_write   <=  din[0];  //
      end
end

// r_dprio1_rx_stop_read
// bitfield description: RX FIFO Stop Read
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio1_rx_stop_read <= 1'h0;
   end
   else begin
      if (we_r_dprio1_rx[0]) begin 
         r_dprio1_rx_stop_read   <=  din[1];  //
      end
end

// r_dprio1_rx_stop_write
// bitfield description: RX FIFO Stop Write
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio1_rx_stop_write <= 1'h0;
   end
   else begin
      if (we_r_dprio1_rx[0]) begin 
         r_dprio1_rx_stop_write   <=  din[2];  //
      end
end

// r_dprio1_rx_fifo_pempty
// bitfield description: FIFO Almost Empty Threshold
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio1_rx_fifo_pempty <= 5'h00;
   end
   else begin
      if (we_r_dprio1_rx[0]) begin 
         r_dprio1_rx_fifo_pempty[3:0]   <=  din[7:4];  //
      end
      if (we_r_dprio1_rx[1]) begin 
         r_dprio1_rx_fifo_pempty[4]   <=  din[8];  //
      end
end

// r_dprio1_rx_adapter_lpbk_mode
// bitfield description: Loopback Mode
// 00: disable
// 01: loopback 1x mode
// 10: loopback 2x mode
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio1_rx_adapter_lpbk_mode <= 2'h0;
   end
   else begin
      if (we_r_dprio1_rx[1]) begin 
         r_dprio1_rx_adapter_lpbk_mode[1:0]   <=  din[15:14];  //
      end
end

// r_dprio1_rx_aib_lpbk_en
// bitfield description: AIB Loopback Enable
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio1_rx_aib_lpbk_en <= 1'h0;
   end
   else begin
      if (we_r_dprio1_rx[3]) begin 
         r_dprio1_rx_aib_lpbk_en   <=  din[24];  //
      end
end

/* Definitions of REGISTER "r_dprio2_rx" */

// r_dprio2_rx_fifo_pfull
// bitfield description: RX FIFO Almost Full Threshold
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio2_rx_fifo_pfull <= 5'h00;
   end
   else begin
      if (we_r_dprio2_rx[0]) begin 
         r_dprio2_rx_fifo_pfull[4:0]   <=  din[5:1];  //
      end
end

// r_dprio2_rx_fifo_power_mode
// bitfield description: RX FIFO Power-Saving Mode
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio2_rx_fifo_power_mode <= 2'h0;
   end
   else begin
      if (we_r_dprio2_rx[0]) begin 
         r_dprio2_rx_fifo_power_mode[1:0]   <=  din[7:6];  //
      end
end

// r_dprio2_rx_usertest_sel
// bitfield description: User Test Select
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio2_rx_usertest_sel <= 2'h0;
   end
   else begin
      if (we_r_dprio2_rx[1]) begin 
         r_dprio2_rx_usertest_sel[1:0]   <=  din[15:14];  //
      end
end

// r_dprio2_rx_hrdrst_user_ctl_en
// bitfield description: Hard Reset User Control Enable
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio2_rx_hrdrst_user_ctl_en <= 1'h0;
   end
   else begin
      if (we_r_dprio2_rx[2]) begin 
         r_dprio2_rx_hrdrst_user_ctl_en   <=  din[16];  //
      end
end

// r_dprio2_rx_wr_adj_en
// bitfield description: RX FIFO Write-side Latency Adjust Enable
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio2_rx_wr_adj_en <= 1'h0;
   end
   else begin
      if (we_r_dprio2_rx[2]) begin 
         r_dprio2_rx_wr_adj_en   <=  din[17];  //
      end
end

// r_dprio2_rx_rd_adj_en
// bitfield description: RX FIFO Read-side Latency Adjust Enable
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio2_rx_rd_adj_en <= 1'h0;
   end
   else begin
      if (we_r_dprio2_rx[2]) begin 
         r_dprio2_rx_rd_adj_en   <=  din[18];  //
      end
end

// r_dprio2_rx_msb_rdptr_pipe_byp
// bitfield description: 1: Bypass pipelined MSB of read pointer in latency pulse measurement.
// 
// 0: Use pipelined MSB of read pointer in latency pulse measurement
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio2_rx_msb_rdptr_pipe_byp <= 1'h0;
   end
   else begin
      if (we_r_dprio2_rx[2]) begin 
         r_dprio2_rx_msb_rdptr_pipe_byp   <=  din[19];  //
      end
end

// r_dprio2_rx_async_ltr_rstval
// bitfield description: PLD LTR Reset Val
// customType  RW
// hwAccess: RO 
// reset value : 0x0 
// software enable:  "crssm_cfg_active"  

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio2_rx_async_ltr_rstval <= 1'h0;
   end
   else begin
      if (we_r_dprio2_rx[2] && crssm_cfg_active) begin 
         r_dprio2_rx_async_ltr_rstval   <=  din[21];  //
      end
end

// r_dprio2_rx_async_ltd_b_rstval
// bitfield description: PLD LTD-B Reset Val
// customType  RW
// hwAccess: RO 
// reset value : 0x0 
// software enable:  "crssm_cfg_active"  

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio2_rx_async_ltd_b_rstval <= 1'h0;
   end
   else begin
      if (we_r_dprio2_rx[2] && crssm_cfg_active) begin 
         r_dprio2_rx_async_ltd_b_rstval   <=  din[22];  //
      end
end

// r_dprio2_rx_async_pld_8g_sig_det_out_rstval
// bitfield description: PLD 8G Signal Detect Out Rst Val
// customType  RW
// hwAccess: RO 
// reset value : 0x0 
// software enable:  "crssm_cfg_active"  

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio2_rx_async_pld_8g_sig_det_out_rstval <= 1'h0;
   end
   else begin
      if (we_r_dprio2_rx[2] && crssm_cfg_active) begin 
         r_dprio2_rx_async_pld_8g_sig_det_out_rstval   <=  din[23];  //
      end
end

// r_dprio2_rx_async_pld_10g_rx_crc32_err_rstval
// bitfield description: PLD 10G CRC32 Error Rst Val
// customType  RW
// hwAccess: RO 
// reset value : 0x0 
// software enable:  "crssm_cfg_active"  

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio2_rx_async_pld_10g_rx_crc32_err_rstval <= 1'h0;
   end
   else begin
      if (we_r_dprio2_rx[3] && crssm_cfg_active) begin 
         r_dprio2_rx_async_pld_10g_rx_crc32_err_rstval   <=  din[24];  //
      end
end

// r_dprio2_rx_async_rx_fifo_align_clr_rstval
// bitfield description: PLD RX FIFO Align Clear Reset Val
// customType  RW
// hwAccess: RO 
// reset value : 0x0 
// software enable:  "crssm_cfg_active"  

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio2_rx_async_rx_fifo_align_clr_rstval <= 1'h0;
   end
   else begin
      if (we_r_dprio2_rx[3] && crssm_cfg_active) begin 
         r_dprio2_rx_async_rx_fifo_align_clr_rstval   <=  din[25];  //
      end
end

// r_dprio2_rx_async_hip_en
// bitfield description: HIP Enable
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio2_rx_async_hip_en <= 1'h0;
   end
   else begin
      if (we_r_dprio2_rx[3]) begin 
         r_dprio2_rx_async_hip_en   <=  din[26];  //
      end
end

// r_dprio2_rx_parity_sel
// bitfield description: RX Asynch Parity Select
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio2_rx_parity_sel <= 2'h0;
   end
   else begin
      if (we_r_dprio2_rx[3]) begin 
         r_dprio2_rx_parity_sel[1:0]   <=  din[28:27];  //
      end
end

// r_dprio2_rx_stretch_num_stages
// bitfield description: RX Signal Stretch Num Stages
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio2_rx_stretch_num_stages <= 3'h0;
   end
   else begin
      if (we_r_dprio2_rx[3]) begin 
         r_dprio2_rx_stretch_num_stages[2:0]   <=  din[31:29];  //
      end
end

/* Definitions of REGISTER "r_dprio3_rx" */

// r_dprio3_rx_datapath_tb_sel
// bitfield description: RX Datapath Testbus Select
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio3_rx_datapath_tb_sel <= 4'h0;
   end
   else begin
      if (we_r_dprio3_rx[0]) begin 
         r_dprio3_rx_datapath_tb_sel[3:0]   <=  din[3:0];  //
      end
end

// r_dprio3_rx_internal_clk1_sel0
// bitfield description: Internal Clock 1 Select0
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio3_rx_internal_clk1_sel0 <= 1'h0;
   end
   else begin
      if (we_r_dprio3_rx[0]) begin 
         r_dprio3_rx_internal_clk1_sel0   <=  din[4];  //
      end
end

// r_dprio3_rx_internal_clk1_sel1
// bitfield description: Internal Clock 1 Select1
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio3_rx_internal_clk1_sel1 <= 1'h0;
   end
   else begin
      if (we_r_dprio3_rx[0]) begin 
         r_dprio3_rx_internal_clk1_sel1   <=  din[5];  //
      end
end

// r_dprio3_rx_internal_clk1_sel2
// bitfield description: Internal Clock 1 Select2
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio3_rx_internal_clk1_sel2 <= 1'h0;
   end
   else begin
      if (we_r_dprio3_rx[0]) begin 
         r_dprio3_rx_internal_clk1_sel2   <=  din[6];  //
      end
end

// r_dprio3_rx_internal_clk1_sel3
// bitfield description: Internal Clock 1 Select3
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio3_rx_internal_clk1_sel3 <= 1'h0;
   end
   else begin
      if (we_r_dprio3_rx[0]) begin 
         r_dprio3_rx_internal_clk1_sel3   <=  din[7];  //
      end
end

// r_dprio3_rx_txfiford_prect_sel
// bitfield description: TXFIFO Read-side Pre-Clock-Tree Sel
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio3_rx_txfiford_prect_sel <= 1'h0;
   end
   else begin
      if (we_r_dprio3_rx[1]) begin 
         r_dprio3_rx_txfiford_prect_sel   <=  din[8];  //
      end
end

// r_dprio3_rx_txfiford_postct_sel
// bitfield description: TXFIFO Read-side Post-Clock-Tree Sel
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio3_rx_txfiford_postct_sel <= 1'h0;
   end
   else begin
      if (we_r_dprio3_rx[1]) begin 
         r_dprio3_rx_txfiford_postct_sel   <=  din[9];  //
      end
end

// r_dprio3_rx_txfifowr_postct_sel
// bitfield description: TXFIFO Write-side Post-Clock-Tree Sel
// 0: sclk_mux3
// 1: TX FIFO read-side clock
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio3_rx_txfifowr_postct_sel <= 1'h0;
   end
   else begin
      if (we_r_dprio3_rx[1]) begin 
         r_dprio3_rx_txfifowr_postct_sel   <=  din[10];  //
      end
end

// r_dprio3_rx_txfifowr_from_aib_sel
// bitfield description: TXFIFO Write-side Pre-Clock-Tree (from AIB) Sel
// 0: sclk_mux1
// 1: TX transfer clk from AIB
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio3_rx_txfifowr_from_aib_sel <= 1'h0;
   end
   else begin
      if (we_r_dprio3_rx[1]) begin 
         r_dprio3_rx_txfifowr_from_aib_sel   <=  din[11];  //
      end
end

// r_dprio3_rx_rxfiford_to_aib_sel
// bitfield description: RXFIFO Read to AIB Sel
// 0: sclk_mux1
// 1: RX Transfer clk from AIB
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio3_rx_rxfiford_to_aib_sel <= 1'h0;
   end
   else begin
      if (we_r_dprio3_rx[1]) begin 
         r_dprio3_rx_rxfiford_to_aib_sel   <=  din[12];  //
      end
end

// r_dprio3_rx_fifo_wr_clk_sel
// bitfield description: RXFIFO Write Clock Sel 000: rx_ehip_clk
// 001: rx_rsfec_clk
// 010: rx_elane_clk
// 011: rx_pma_div2_clk
// 100: tx_transfer_clk
// 101: tx_transfer_div2_clk
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio3_rx_fifo_wr_clk_sel <= 3'h0;
   end
   else begin
      if (we_r_dprio3_rx[1]) begin 
         r_dprio3_rx_fifo_wr_clk_sel[2:0]   <=  din[15:13];  //
      end
end

// r_dprio3_rx_fifo_rd_clk_sel
// bitfield description: RXFIFO Read Clock Sel
// 000: rx_ehip_frd_clk
// 001: rx_rsfec_frd_clk
// 010: rx_pma_clk
// 011: tx_pma_clk
// 100: tx_transfer_clk
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio3_rx_fifo_rd_clk_sel <= 3'h0;
   end
   else begin
      if (we_r_dprio3_rx[2]) begin 
         r_dprio3_rx_fifo_rd_clk_sel[2:0]   <=  din[18:16];  //
      end
end

// r_dprio3_rx_latency_src_sel
// bitfield description: Latency Pulse Source Select 
// 0: selects latency pulse from Adapter, 1: selects latency pulse from XCVRIF
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio3_rx_latency_src_sel <= 1'h0;
   end
   else begin
      if (we_r_dprio3_rx[2]) begin 
         r_dprio3_rx_latency_src_sel   <=  din[19];  //
      end
end

// r_dprio3_rx_internal_clk1_sel
// bitfield description: Internal Clock 1 Select
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio3_rx_internal_clk1_sel <= 4'h0;
   end
   else begin
      if (we_r_dprio3_rx[2]) begin 
         r_dprio3_rx_internal_clk1_sel[3:0]   <=  din[23:20];  //
      end
end

// r_dprio3_rx_internal_clk2_sel
// bitfield description: Internal Clock 2 Select
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio3_rx_internal_clk2_sel <= 4'h0;
   end
   else begin
      if (we_r_dprio3_rx[3]) begin 
         r_dprio3_rx_internal_clk2_sel[3:0]   <=  din[27:24];  //
      end
end

// r_dprio3_rx_fifo_wr_clk_scg_en
// bitfield description: RXFIFO Write Clock SCG Enable
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio3_rx_fifo_wr_clk_scg_en <= 1'h0;
   end
   else begin
      if (we_r_dprio3_rx[3]) begin 
         r_dprio3_rx_fifo_wr_clk_scg_en   <=  din[28];  //
      end
end

// r_dprio3_rx_fifo_rd_clk_scg_en
// bitfield description: RXFIFO Read Clock SCG Enable
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio3_rx_fifo_rd_clk_scg_en <= 1'h0;
   end
   else begin
      if (we_r_dprio3_rx[3]) begin 
         r_dprio3_rx_fifo_rd_clk_scg_en   <=  din[29];  //
      end
end

// r_dprio3_rx_osc_clk_scg_en
// bitfield description: Oscillator Clock SCG Enable
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio3_rx_osc_clk_scg_en <= 1'h0;
   end
   else begin
      if (we_r_dprio3_rx[3]) begin 
         r_dprio3_rx_osc_clk_scg_en   <=  din[30];  //
      end
end

// r_dprio3_rx_hrdrst_rx_osc_clk_scg_en
// bitfield description: Hard Reset RX Oscillator Clock SCG Enable
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio3_rx_hrdrst_rx_osc_clk_scg_en <= 1'h0;
   end
   else begin
      if (we_r_dprio3_rx[3]) begin 
         r_dprio3_rx_hrdrst_rx_osc_clk_scg_en   <=  din[31];  //
      end
end

/* Definitions of REGISTER "r_dprio4_rx" */

// r_dprio4_rx_pma_coreclkin_sel
// bitfield description: PMA Core-clock In Select
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio4_rx_pma_coreclkin_sel <= 1'h0;
   end
   else begin
      if (we_r_dprio4_rx[0]) begin 
         r_dprio4_rx_pma_coreclkin_sel   <=  din[0];  //
      end
end

// r_dprio4_rx_free_run_div_clk
// bitfield description: Free-run Div Clock
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio4_rx_free_run_div_clk <= 1'h0;
   end
   else begin
      if (we_r_dprio4_rx[0]) begin 
         r_dprio4_rx_free_run_div_clk   <=  din[1];  //
      end
end

// r_dprio4_rx_hrdrst_rst_sm_dis
// bitfield description: Hard Reset Reset-SM Disable
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio4_rx_hrdrst_rst_sm_dis <= 1'h0;
   end
   else begin
      if (we_r_dprio4_rx[0]) begin 
         r_dprio4_rx_hrdrst_rst_sm_dis   <=  din[2];  //
      end
end

// r_dprio4_rx_hrdrst_dcd_caldone_byp
// bitfield description: Hard Reset DCD Calibration Done Bypass
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio4_rx_hrdrst_dcd_caldone_byp <= 1'h0;
   end
   else begin
      if (we_r_dprio4_rx[0]) begin 
         r_dprio4_rx_hrdrst_dcd_caldone_byp   <=  din[3];  //
      end
end

// r_dprio4_rx_rmfflag_stretch_en
// bitfield description: RMF Flag Pulse Stretch Enable
// customType  RW
// hwAccess: RO 
// reset value : 0x0 
// software enable:  "crssm_cfg_active"  

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio4_rx_rmfflag_stretch_en <= 1'h0;
   end
   else begin
      if (we_r_dprio4_rx[0] && crssm_cfg_active) begin 
         r_dprio4_rx_rmfflag_stretch_en   <=  din[4];  //
      end
end

// r_dprio4_rx_rmfflag_stretch_num_stages
// bitfield description: RMF Flag Stretch Num Stages
// customType  RW
// hwAccess: RO 
// reset value : 0x0 
// software enable:  "crssm_cfg_active"  

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio4_rx_rmfflag_stretch_num_stages <= 3'h0;
   end
   else begin
      if (we_r_dprio4_rx[0] && crssm_cfg_active) begin 
         r_dprio4_rx_rmfflag_stretch_num_stages[2:0]   <=  din[7:5];  //
      end
end

// r_dprio4_rx_internal_clk2_sel0
// bitfield description: Internal Clock 2 Select0
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio4_rx_internal_clk2_sel0 <= 1'h0;
   end
   else begin
      if (we_r_dprio4_rx[1]) begin 
         r_dprio4_rx_internal_clk2_sel0   <=  din[8];  //
      end
end

// r_dprio4_rx_internal_clk2_sel1
// bitfield description: Internal Clock 2 Select1
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio4_rx_internal_clk2_sel1 <= 1'h0;
   end
   else begin
      if (we_r_dprio4_rx[1]) begin 
         r_dprio4_rx_internal_clk2_sel1   <=  din[9];  //
      end
end

// r_dprio4_rx_internal_clk2_sel2
// bitfield description: Internal Clock 2 Select2
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio4_rx_internal_clk2_sel2 <= 1'h0;
   end
   else begin
      if (we_r_dprio4_rx[1]) begin 
         r_dprio4_rx_internal_clk2_sel2   <=  din[10];  //
      end
end

// r_dprio4_rx_internal_clk2_sel3
// bitfield description: Internal Clock 2 Select3
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio4_rx_internal_clk2_sel3 <= 1'h0;
   end
   else begin
      if (we_r_dprio4_rx[1]) begin 
         r_dprio4_rx_internal_clk2_sel3   <=  din[11];  //
      end
end

// r_dprio4_rx_rxfifowr_prect_sel
// bitfield description: RXFIFO Write Pre-Clock-Tree Select
// 0: sclk_mux4
// 1: rx_clock_fifo_wr_clk_mux1
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio4_rx_rxfifowr_prect_sel <= 1'h0;
   end
   else begin
      if (we_r_dprio4_rx[1]) begin 
         r_dprio4_rx_rxfifowr_prect_sel   <=  din[12];  //
      end
end

// r_dprio4_rx_rxfifowr_postct_sel
// bitfield description: RXFIFO Write Post-Clock-Tree Select
// 0: sclk_mux3
// 1: rx_clock_fifo_wr_clk
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio4_rx_rxfifowr_postct_sel <= 1'h0;
   end
   else begin
      if (we_r_dprio4_rx[1]) begin 
         r_dprio4_rx_rxfifowr_postct_sel   <=  din[13];  //
      end
end

// r_dprio4_rx_rxfiford_postct_sel
// bitfield description: RXFIFO Read Post-Clock-Tree Select
// 0: sclk_mux2
// 1: rx_clock_fifo_rd_clk
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio4_rx_rxfiford_postct_sel <= 1'h0;
   end
   else begin
      if (we_r_dprio4_rx[1]) begin 
         r_dprio4_rx_rxfiford_postct_sel   <=  din[14];  //
      end
end

/* Definitions of REGISTER "r_dprio_status" */

// r_dprio_status_rx_chnl
// bitfield description: RX Channel Status [2:0]: Reset init status
// [3]: FIFO ready
// [4]: FIFO empty
// [5]: FIFO full
// [6]: Reserved
// [7]: Reserved
// customType  RO
// hwAccess: RW 
// reset value : 0x00 
// inputPort: "EMPTY" 
// outputPort:  "" 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio_status_rx_chnl <= 8'h00;
   end
   else begin
         r_dprio_status_rx_chnl[7:0]   <=  r_dprio_status_rx_chnl_i[7:0] ;
end

// r_dprio_status_tx_chnl
// bitfield description: TX Channel Status
// [8]: align done
// [9]: word-align error
// [13:10]: word-align error count
// [14]: FIFO empty
// [15]: FIFO full
// customType  RO
// hwAccess: RW 
// reset value : 0x00 
// inputPort: "EMPTY" 
// outputPort:  "" 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio_status_tx_chnl <= 8'h00;
   end
   else begin
         r_dprio_status_tx_chnl[7:0]   <=  r_dprio_status_tx_chnl_i[7:0] ;
end

// r_dprio_status_sr
// bitfield description: SR Status
// [16]: SSR load signal
// [17]: SSR counter start
// [18]: SSR counter expiration
// [19]: SSR current state
// [16]: FSR load signal
// [17]: FSR counter start
// [18]: FSR counter expiration
// [19]: FSR current state
// customType  RO
// hwAccess: RW 
// reset value : 0x00 
// inputPort: "EMPTY" 
// outputPort:  "" 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio_status_sr <= 8'h00;
   end
   else begin
         r_dprio_status_sr[7:0]   <=  r_dprio_status_sr_i[7:0] ;
end

/* Definitions of REGISTER "r_aibdprio0" */

// r_aibdprio0_aib_dprio0_ctrl_0
// bitfield description: DPRIO AIB Control 0
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_aibdprio0_aib_dprio0_ctrl_0 <= 8'h00;
   end
   else begin
      if (we_r_aibdprio0[0]) begin 
         r_aibdprio0_aib_dprio0_ctrl_0[7:0]   <=  din[7:0];  //
      end
end

// r_aibdprio0_aib_dprio0_ctrl_1
// bitfield description: DPRIO AIB Control 1
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_aibdprio0_aib_dprio0_ctrl_1 <= 8'h00;
   end
   else begin
      if (we_r_aibdprio0[1]) begin 
         r_aibdprio0_aib_dprio0_ctrl_1[7:0]   <=  din[15:8];  //
      end
end

// r_aibdprio0_aib_dprio0_ctrl_2
// bitfield description: DPRIO AIB Control 2
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_aibdprio0_aib_dprio0_ctrl_2 <= 8'h00;
   end
   else begin
      if (we_r_aibdprio0[2]) begin 
         r_aibdprio0_aib_dprio0_ctrl_2[7:0]   <=  din[23:16];  //
      end
end

// r_aibdprio0_aib_dprio0_ctrl_3
// bitfield description: DPRIO AIB Control 3
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_aibdprio0_aib_dprio0_ctrl_3 <= 8'h00;
   end
   else begin
      if (we_r_aibdprio0[3]) begin 
         r_aibdprio0_aib_dprio0_ctrl_3[7:0]   <=  din[31:24];  //
      end
end

/* Definitions of REGISTER "r_aibdprio1" */

// r_aibdprio1_aib_dprio1_ctrl_4
// bitfield description: DPRIO AIB Control 4
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_aibdprio1_aib_dprio1_ctrl_4 <= 8'h00;
   end
   else begin
      if (we_r_aibdprio1) begin 
         r_aibdprio1_aib_dprio1_ctrl_4[7:0]   <=  din[7:0];  //
      end
end

/* Definitions of REGISTER "r_dprio_sr" */

// r_dprio_sr_reserved
// bitfield description: RESERVED
// customType  RW
// hwAccess: RO 
// reset value : 0x0000 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio_sr_reserved <= 16'h0000;
   end
   else begin
      if (we_r_dprio_sr[0]) begin 
         r_dprio_sr_reserved[7:0]   <=  din[7:0];  //
      end
      if (we_r_dprio_sr[1]) begin 
         r_dprio_sr_reserved[15:8]   <=  din[15:8];  //
      end
end

/* Definitions of REGISTER "r_dprio_avmm1" */

// r_dprio_avmm1_reserved
// bitfield description: RESERVED
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio_avmm1_reserved <= 8'h00;
   end
   else begin
      if (we_r_dprio_avmm1) begin 
         r_dprio_avmm1_reserved[7:0]   <=  din[7:0];  //
      end
end

/* Definitions of REGISTER "r_dprio_avmm2" */

// r_dprio_avmm2_reserved
// bitfield description: RESERVED
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_dprio_avmm2_reserved <= 8'h00;
   end
   else begin
      if (we_r_dprio_avmm2) begin 
         r_dprio_avmm2_reserved[7:0]   <=  din[7:0];  //
      end
end

/* Definitions of REGISTER "r_spare0" */

// r_spare0_rsvd
// bitfield description: Spare reserved bits
// customType  RW
// hwAccess: RW 
// reset value : 0x00 
// inputPort: "EMPTY" 
// outputPort:  "" 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_spare0_rsvd <= 8'h00;
   end
   else begin
      if (we_r_spare0[0]) begin 
         r_spare0_rsvd[7:0]   <=  din[7:0];  //
      end
      else begin 
         r_spare0_rsvd[7:0]   <=  r_spare0_rsvd_i[7:0] ;
      end
end

// r_spare0_rsvd_prst
// bitfield description: Spare reserved bits with preset
// customType  RW
// hwAccess: RW 
// reset value : 0xf 
// inputPort: "EMPTY" 
// outputPort:  "" 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_spare0_rsvd_prst <= 4'hf;
   end
   else begin
      if (we_r_spare0[2]) begin 
         r_spare0_rsvd_prst[3:0]   <=  din[19:16];  //
      end
      else begin 
         r_spare0_rsvd_prst[3:0]   <=  r_spare0_rsvd_prst_i[3:0] ;
      end
end




// read process
always @ (*)
begin
rdata_comb = 32'h0;
   if(re) begin
      case (addr)  
	8'h00 : begin
		rdata_comb [29:0]	= r_usr_outbox_usr_msg [29:0] ;		// readType = read   writeType =write
		rdata_comb [31]	= r_usr_outbox_send_msg  ;		// readType = read   writeType =write
	end
	8'h04 : begin
		rdata_comb [29:0]	= r_usr_inbox_usr_msg [29:0] ;		// readType = read   writeType =illegal
		rdata_comb [30]	= r_usr_inbox_autoclear_dis  ;		// readType = read   writeType =write
		rdata_comb [31]	= r_usr_inbox_new_msg  ;		// readType = read   writeType =illegal
	end
	8'h08 : begin
		rdata_comb [2:0]	= r_dprio0_tx_chnl_dp_map_mode [2:0] ;		// readType = read   writeType =write
		rdata_comb [9]	= r_dprio0_tx_usertest_sel  ;		// readType = read   writeType =write
		rdata_comb [15:11]	= r_dprio0_tx_fifo_empty [4:0] ;		// readType = read   writeType =write
		rdata_comb [23:19]	= r_dprio0_tx_fifo_full [4:0] ;		// readType = read   writeType =write
		rdata_comb [26:24]	= r_dprio0_tx_phcomp_rd_delay [2:0] ;		// readType = read   writeType =write
		rdata_comb [27]	= r_dprio0_tx_double_read  ;		// readType = read   writeType =write
		rdata_comb [28]	= r_dprio0_tx_stop_read  ;		// readType = read   writeType =write
		rdata_comb [29]	= r_dprio0_tx_stop_write  ;		// readType = read   writeType =write
	end
	8'h0c : begin
		rdata_comb [4:0]	= r_dprio1_tx_fifo_pempty [4:0] ;		// readType = read   writeType =write
		rdata_comb [5]	= r_dprio1_tx_dv_gating_en  ;		// readType = read   writeType =write
		rdata_comb [6]	= r_dprio1_tx_rev_lpbk  ;		// readType = read   writeType =write
		rdata_comb [11:7]	= r_dprio1_tx_fifo_pfull [4:0] ;		// readType = read   writeType =write
	end
	8'h10 : begin
		rdata_comb [0]	= r_dprio2_tx_wa_en  ;		// readType = read   writeType =write
		rdata_comb [2:1]	= r_dprio2_tx_fifo_power_mode [1:0] ;		// readType = read   writeType =write
		rdata_comb [10:8]	= r_dprio2_tx_stretch_num_stages [2:0] ;		// readType = read   writeType =write
		rdata_comb [13:11]	= r_dprio2_tx_datapath_tb_sel [2:0] ;		// readType = read   writeType =write
		rdata_comb [14]	= r_dprio2_tx_wr_adj_en  ;		// readType = read   writeType =write
		rdata_comb [15]	= r_dprio2_tx_rd_adj_en  ;		// readType = read   writeType =write
		rdata_comb [16]	= r_dprio2_tx_async_txelecidle_rstval  ;		// readType = read   writeType =write
		rdata_comb [17]	= r_dprio2_tx_async_hip_aib_fsr_in_bit0_rstval  ;		// readType = read   writeType =write
		rdata_comb [18]	= r_dprio2_tx_async_hip_aib_fsr_in_bit1_rstval  ;		// readType = read   writeType =write
		rdata_comb [19]	= r_dprio2_tx_async_hip_aib_fsr_in_bit2_rstval  ;		// readType = read   writeType =write
		rdata_comb [20]	= r_dprio2_tx_async_hip_aib_fsr_in_bit3_rstval  ;		// readType = read   writeType =write
		rdata_comb [21]	= r_dprio2_tx_async_pld_pmaif_mask_tx_pll_rstval  ;		// readType = read   writeType =write
		rdata_comb [22]	= r_dprio2_tx_async_hip_aib_fsr_out_bit0_rstval  ;		// readType = read   writeType =write
		rdata_comb [23]	= r_dprio2_tx_async_hip_aib_fsr_out_bit1_rstval  ;		// readType = read   writeType =write
		rdata_comb [24]	= r_dprio2_tx_async_hip_aib_fsr_out_bit2_rstval  ;		// readType = read   writeType =write
		rdata_comb [25]	= r_dprio2_tx_async_hip_aib_fsr_out_bit3_rstval  ;		// readType = read   writeType =write
	end
	8'h14 : begin
		rdata_comb [1:0]	= r_dprio3_tx_fifo_rd_clk_sel [1:0] ;		// readType = read   writeType =write
		rdata_comb [6]	= r_dprio3_tx_fifo_wr_clk_scg_en  ;		// readType = read   writeType =write
		rdata_comb [7]	= r_dprio3_tx_fifo_rd_clk_scg_en  ;		// readType = read   writeType =write
		rdata_comb [8]	= r_dprio3_tx_osc_clk_scg_en  ;		// readType = read   writeType =write
		rdata_comb [9]	= r_dprio3_tx_hrdrst_rx_osc_clk_scg_en  ;		// readType = read   writeType =write
		rdata_comb [10]	= r_dprio3_tx_hip_osc_clk_scg_en  ;		// readType = read   writeType =write
		rdata_comb [11]	= r_dprio3_tx_free_run_div_clk  ;		// readType = read   writeType =write
		rdata_comb [12]	= r_dprio3_tx_hrdrst_rst_sm_dis  ;		// readType = read   writeType =write
		rdata_comb [13]	= r_dprio3_tx_hrdrst_dcd_caldone_byp  ;		// readType = read   writeType =write
		rdata_comb [14]	= r_dprio3_tx_hrdrst_dll_lock_byp  ;		// readType = read   writeType =write
		rdata_comb [15]	= r_dprio3_tx_hrdrst_align_byp  ;		// readType = read   writeType =write
		rdata_comb [17]	= r_dprio3_tx_hrdrst_user_ctl_en  ;		// readType = read   writeType =write
	end
	8'h18 : begin
		rdata_comb [2:0]	= r_dprio0_rx_chnl_dp_map_mode [2:0] ;		// readType = read   writeType =write
		rdata_comb [7:5]	= r_dprio0_rx_pcs_testbus_sel [2:0] ;		// readType = read   writeType =write
		rdata_comb [8]	= r_dprio0_rx_pld_8g_a1a2_k1k2_flag_poll_byp  ;		// readType = read   writeType =write
		rdata_comb [9]	= r_dprio0_rx_pld_10g_krfec_rx_diag_data_stat_poll_byp  ;		// readType = read   writeType =write
		rdata_comb [10]	= r_dprio0_rx_pld_pma_pcie_sw_done_poll_byp  ;		// readType = read   writeType =write
		rdata_comb [11]	= r_dprio0_rx_pld_pma_reser_in_poll_byp  ;		// readType = read   writeType =write
		rdata_comb [12]	= r_dprio0_rx_pld_pma_testbus_poll_byp  ;		// readType = read   writeType =write
		rdata_comb [13]	= r_dprio0_rx_pld_test_data_poll_byp  ;		// readType = read   writeType =write
		rdata_comb [14]	= r_dprio0_rx_pld_8g_wa_boundary_poll_byp  ;		// readType = read   writeType =write
		rdata_comb [15]	= r_dprio0_rx_pcspma_testbus_sel  ;		// readType = read   writeType =write
		rdata_comb [20:16]	= r_dprio0_rx_fifo_empty [4:0] ;		// readType = read   writeType =write
		rdata_comb [22:21]	= r_dprio0_rx_fifo_mode [1:0] ;		// readType = read   writeType =write
		rdata_comb [23]	= r_dprio0_rx_wm_en  ;		// readType = read   writeType =write
		rdata_comb [28:24]	= r_dprio0_rx_fifo_full [4:0] ;		// readType = read   writeType =write
		rdata_comb [31:29]	= r_dprio0_rx_phcomp_rd_delay [2:0] ;		// readType = read   writeType =write
	end
	8'h1c : begin
		rdata_comb [0]	= r_dprio1_rx_double_write  ;		// readType = read   writeType =write
		rdata_comb [1]	= r_dprio1_rx_stop_read  ;		// readType = read   writeType =write
		rdata_comb [2]	= r_dprio1_rx_stop_write  ;		// readType = read   writeType =write
		rdata_comb [8:4]	= r_dprio1_rx_fifo_pempty [4:0] ;		// readType = read   writeType =write
		rdata_comb [15:14]	= r_dprio1_rx_adapter_lpbk_mode [1:0] ;		// readType = read   writeType =write
		rdata_comb [24]	= r_dprio1_rx_aib_lpbk_en  ;		// readType = read   writeType =write
	end
	8'h20 : begin
		rdata_comb [5:1]	= r_dprio2_rx_fifo_pfull [4:0] ;		// readType = read   writeType =write
		rdata_comb [7:6]	= r_dprio2_rx_fifo_power_mode [1:0] ;		// readType = read   writeType =write
		rdata_comb [15:14]	= r_dprio2_rx_usertest_sel [1:0] ;		// readType = read   writeType =write
		rdata_comb [16]	= r_dprio2_rx_hrdrst_user_ctl_en  ;		// readType = read   writeType =write
		rdata_comb [17]	= r_dprio2_rx_wr_adj_en  ;		// readType = read   writeType =write
		rdata_comb [18]	= r_dprio2_rx_rd_adj_en  ;		// readType = read   writeType =write
		rdata_comb [19]	= r_dprio2_rx_msb_rdptr_pipe_byp  ;		// readType = read   writeType =write
		rdata_comb [21]	= r_dprio2_rx_async_ltr_rstval  ;		// readType = read   writeType =write
		rdata_comb [22]	= r_dprio2_rx_async_ltd_b_rstval  ;		// readType = read   writeType =write
		rdata_comb [23]	= r_dprio2_rx_async_pld_8g_sig_det_out_rstval  ;		// readType = read   writeType =write
		rdata_comb [24]	= r_dprio2_rx_async_pld_10g_rx_crc32_err_rstval  ;		// readType = read   writeType =write
		rdata_comb [25]	= r_dprio2_rx_async_rx_fifo_align_clr_rstval  ;		// readType = read   writeType =write
		rdata_comb [26]	= r_dprio2_rx_async_hip_en  ;		// readType = read   writeType =write
		rdata_comb [28:27]	= r_dprio2_rx_parity_sel [1:0] ;		// readType = read   writeType =write
		rdata_comb [31:29]	= r_dprio2_rx_stretch_num_stages [2:0] ;		// readType = read   writeType =write
	end
	8'h24 : begin
		rdata_comb [3:0]	= r_dprio3_rx_datapath_tb_sel [3:0] ;		// readType = read   writeType =write
		rdata_comb [4]	= r_dprio3_rx_internal_clk1_sel0  ;		// readType = read   writeType =write
		rdata_comb [5]	= r_dprio3_rx_internal_clk1_sel1  ;		// readType = read   writeType =write
		rdata_comb [6]	= r_dprio3_rx_internal_clk1_sel2  ;		// readType = read   writeType =write
		rdata_comb [7]	= r_dprio3_rx_internal_clk1_sel3  ;		// readType = read   writeType =write
		rdata_comb [8]	= r_dprio3_rx_txfiford_prect_sel  ;		// readType = read   writeType =write
		rdata_comb [9]	= r_dprio3_rx_txfiford_postct_sel  ;		// readType = read   writeType =write
		rdata_comb [10]	= r_dprio3_rx_txfifowr_postct_sel  ;		// readType = read   writeType =write
		rdata_comb [11]	= r_dprio3_rx_txfifowr_from_aib_sel  ;		// readType = read   writeType =write
		rdata_comb [12]	= r_dprio3_rx_rxfiford_to_aib_sel  ;		// readType = read   writeType =write
		rdata_comb [15:13]	= r_dprio3_rx_fifo_wr_clk_sel [2:0] ;		// readType = read   writeType =write
		rdata_comb [18:16]	= r_dprio3_rx_fifo_rd_clk_sel [2:0] ;		// readType = read   writeType =write
		rdata_comb [19]	= r_dprio3_rx_latency_src_sel  ;		// readType = read   writeType =write
		rdata_comb [23:20]	= r_dprio3_rx_internal_clk1_sel [3:0] ;		// readType = read   writeType =write
		rdata_comb [27:24]	= r_dprio3_rx_internal_clk2_sel [3:0] ;		// readType = read   writeType =write
		rdata_comb [28]	= r_dprio3_rx_fifo_wr_clk_scg_en  ;		// readType = read   writeType =write
		rdata_comb [29]	= r_dprio3_rx_fifo_rd_clk_scg_en  ;		// readType = read   writeType =write
		rdata_comb [30]	= r_dprio3_rx_osc_clk_scg_en  ;		// readType = read   writeType =write
		rdata_comb [31]	= r_dprio3_rx_hrdrst_rx_osc_clk_scg_en  ;		// readType = read   writeType =write
	end
	8'h28 : begin
		rdata_comb [0]	= r_dprio4_rx_pma_coreclkin_sel  ;		// readType = read   writeType =write
		rdata_comb [1]	= r_dprio4_rx_free_run_div_clk  ;		// readType = read   writeType =write
		rdata_comb [2]	= r_dprio4_rx_hrdrst_rst_sm_dis  ;		// readType = read   writeType =write
		rdata_comb [3]	= r_dprio4_rx_hrdrst_dcd_caldone_byp  ;		// readType = read   writeType =write
		rdata_comb [4]	= r_dprio4_rx_rmfflag_stretch_en  ;		// readType = read   writeType =write
		rdata_comb [7:5]	= r_dprio4_rx_rmfflag_stretch_num_stages [2:0] ;		// readType = read   writeType =write
		rdata_comb [8]	= r_dprio4_rx_internal_clk2_sel0  ;		// readType = read   writeType =write
		rdata_comb [9]	= r_dprio4_rx_internal_clk2_sel1  ;		// readType = read   writeType =write
		rdata_comb [10]	= r_dprio4_rx_internal_clk2_sel2  ;		// readType = read   writeType =write
		rdata_comb [11]	= r_dprio4_rx_internal_clk2_sel3  ;		// readType = read   writeType =write
		rdata_comb [12]	= r_dprio4_rx_rxfifowr_prect_sel  ;		// readType = read   writeType =write
		rdata_comb [13]	= r_dprio4_rx_rxfifowr_postct_sel  ;		// readType = read   writeType =write
		rdata_comb [14]	= r_dprio4_rx_rxfiford_postct_sel  ;		// readType = read   writeType =write
	end
	8'h2c : begin
		rdata_comb [7:0]	= r_dprio_status_rx_chnl [7:0] ;		// readType = read   writeType =illegal
		rdata_comb [15:8]	= r_dprio_status_tx_chnl [7:0] ;		// readType = read   writeType =illegal
		rdata_comb [23:16]	= r_dprio_status_sr [7:0] ;		// readType = read   writeType =illegal
	end
	8'h30 : begin
		rdata_comb [7:0]	= r_aibdprio0_aib_dprio0_ctrl_0 [7:0] ;		// readType = read   writeType =write
		rdata_comb [15:8]	= r_aibdprio0_aib_dprio0_ctrl_1 [7:0] ;		// readType = read   writeType =write
		rdata_comb [23:16]	= r_aibdprio0_aib_dprio0_ctrl_2 [7:0] ;		// readType = read   writeType =write
		rdata_comb [31:24]	= r_aibdprio0_aib_dprio0_ctrl_3 [7:0] ;		// readType = read   writeType =write
	end
	8'h34 : begin
		rdata_comb [7:0]	= r_aibdprio1_aib_dprio1_ctrl_4 [7:0] ;		// readType = read   writeType =write
	end
	8'h38 : begin
		rdata_comb [15:0]	= r_dprio_sr_reserved [15:0] ;		// readType = read   writeType =write
	end
	8'h3c : begin
		rdata_comb [7:0]	= r_dprio_avmm1_reserved [7:0] ;		// readType = read   writeType =write
	end
	8'h40 : begin
		rdata_comb [7:0]	= r_dprio_avmm2_reserved [7:0] ;		// readType = read   writeType =write
	end
	8'hfc : begin
		rdata_comb [7:0]	= r_spare0_rsvd [7:0] ;		// readType = read   writeType =write
		rdata_comb [19:16]	= r_spare0_rsvd_prst [3:0] ;		// readType = read   writeType =write
	end
	default : begin
		rdata_comb = 32'h00000000;
	end
      endcase
   end
end

endmodule
