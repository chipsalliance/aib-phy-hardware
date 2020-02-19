// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//-----------------------------------------------------------------------------------------------//
//   Generated with Magillem S.A. MRV generator.                                  
//   MRV generator version : 0.2
//   Protocol :  AVALON
//   Wait State : WS1_OUTPUT                                         
//-----------------------------------------------------------------------------------------------//



module c3aibadapt_cfg_csr (
// register offset : 0x00, field offset : 0, access : RW
output	reg [29:0] r_cfg_outbox_cfg_msg ,
// register offset : 0x00, field offset : 31, access : RW
output	reg  r_cfg_outbox_send_msg ,
// register offset : 0x04, field offset : 0, access : RO
output	reg [29:0] r_cfg_inbox_cfg_msg ,
// register offset : 0x04, field offset : 30, access : RW
output	reg  r_cfg_inbox_autoclear_dis ,
// register offset : 0x04, field offset : 31, access : RO
output	reg  r_cfg_inbox_new_msg ,
// register offset : 0x08, field offset : 0, access : RW
output	reg  r_ifctl_usr_active ,
// register offset : 0x08, field offset : 8, access : RW
output	reg [5:0] r_ifctl_mcast_addr ,
// register offset : 0x08, field offset : 15, access : RW
output	reg  r_ifctl_mcast_en ,
// register offset : 0x08, field offset : 16, access : RW
output	reg [6:0] r_ifctl_hwcfg_mode ,
// register offset : 0x08, field offset : 23, access : RW
output	reg  r_ifctl_hwcfg_adpt_en ,
// register offset : 0x08, field offset : 24, access : RW
output	reg  r_ifctl_hwcfg_aib_en ,
// register offset : 0x0c, field offset : 0, access : RW
output	reg  r_rstctl_tx_elane_ovrval ,
// register offset : 0x0c, field offset : 1, access : RW
output	reg  r_rstctl_tx_elane_ovren ,
// register offset : 0x0c, field offset : 2, access : RW
output	reg  r_rstctl_rx_elane_ovrval ,
// register offset : 0x0c, field offset : 3, access : RW
output	reg  r_rstctl_rx_elane_ovren ,
// register offset : 0x0c, field offset : 4, access : RW
output	reg  r_rstctl_tx_xcvrif_ovrval ,
// register offset : 0x0c, field offset : 5, access : RW
output	reg  r_rstctl_tx_xcvrif_ovren ,
// register offset : 0x0c, field offset : 6, access : RW
output	reg  r_rstctl_rx_xcvrif_ovrval ,
// register offset : 0x0c, field offset : 7, access : RW
output	reg  r_rstctl_rx_xcvrif_ovren ,
// register offset : 0x0c, field offset : 8, access : RW
output	reg  r_rstctl_tx_adpt_ovrval ,
// register offset : 0x0c, field offset : 9, access : RW
output	reg  r_rstctl_tx_adpt_ovren ,
// register offset : 0x0c, field offset : 10, access : RW
output	reg  r_rstctl_rx_adpt_ovrval ,
// register offset : 0x0c, field offset : 11, access : RW
output	reg  r_rstctl_rx_adpt_ovren ,
// register offset : 0x0c, field offset : 16, access : RW
output	reg  r_rstctl_tx_pld_div2_rst_opt ,
// register offset : 0x10, field offset : 0, access : RW
output	reg [1:0] r_avmm_testbus_sel ,
// register offset : 0x10, field offset : 4, access : RW
output	reg  r_avmm_hrdrst_osc_clk_scg_en ,
// register offset : 0x10, field offset : 8, access : RW
output	reg [7:0] r_avmm_spare_rsvd ,
// register offset : 0x10, field offset : 16, access : RW
output	reg [3:0] r_avmm_spare_rsvd_prst ,
// register offset : 0x14, field offset : 0, access : RW
output	reg  r_sr_hip_en ,
// register offset : 0x14, field offset : 1, access : RW
output	reg  r_sr_reserbits_in_en ,
// register offset : 0x14, field offset : 2, access : RW
output	reg  r_sr_reserbits_out_en ,
// register offset : 0x14, field offset : 3, access : RW
output	reg  r_sr_parity_en ,
// register offset : 0x14, field offset : 4, access : RW
output	reg  r_sr_osc_clk_scg_en ,
// register offset : 0x14, field offset : 5, access : RW
output	reg [1:0] r_sr_osc_clk_div_sel ,
// register offset : 0x14, field offset : 7, access : RW
output	reg  r_sr_free_run_div_clk ,
// register offset : 0x18, field offset : 0, access : RW
output	reg  r_avmm1_osc_clk_scg_en ,
// register offset : 0x18, field offset : 1, access : RW
output	reg  r_avmm1_avmm_clk_scg_en ,
// register offset : 0x18, field offset : 2, access : RW
output	reg  r_avmm1_avmm_clk_dcg_en ,
// register offset : 0x18, field offset : 3, access : RW
output	reg  r_avmm1_free_run_div_clk ,
// register offset : 0x18, field offset : 4, access : RW
output	reg [5:0] r_avmm1_rdfifo_full ,
// register offset : 0x18, field offset : 10, access : RW
output	reg  r_avmm1_rdfifo_stop_read ,
// register offset : 0x18, field offset : 11, access : RW
output	reg  r_avmm1_rdfifo_stop_write ,
// register offset : 0x18, field offset : 12, access : RW
output	reg [5:0] r_avmm1_rdfifo_empty ,
// register offset : 0x18, field offset : 20, access : RW
output	reg  r_avmm1_use_rsvd_bit1 ,
// register offset : 0x18, field offset : 21, access : RW
output	reg  r_avmm1_sr_test_enable ,
// register offset : 0x1c, field offset : 0, access : RW
output	reg  r_avmm2_osc_clk_scg_en ,
// register offset : 0x1c, field offset : 1, access : RW
output	reg  r_avmm2_avmm_clk_scg_en ,
// register offset : 0x1c, field offset : 2, access : RW
output	reg  r_avmm2_avmm_clk_dcg_en ,
// register offset : 0x1c, field offset : 3, access : RW
output	reg  r_avmm2_free_run_div_clk ,
// register offset : 0x1c, field offset : 4, access : RW
output	reg [5:0] r_avmm2_rdfifo_full ,
// register offset : 0x1c, field offset : 10, access : RW
output	reg  r_avmm2_rdfifo_stop_read ,
// register offset : 0x1c, field offset : 11, access : RW
output	reg  r_avmm2_rdfifo_stop_write ,
// register offset : 0x1c, field offset : 12, access : RW
output	reg [5:0] r_avmm2_rdfifo_empty ,
// register offset : 0x20, field offset : 0, access : RW
output	reg [7:0] r_aib_csr0_aib_csr0_ctrl_0 ,
// register offset : 0x20, field offset : 8, access : RW
output	reg [7:0] r_aib_csr0_aib_csr0_ctrl_1 ,
// register offset : 0x20, field offset : 16, access : RW
output	reg [7:0] r_aib_csr0_aib_csr0_ctrl_2 ,
// register offset : 0x20, field offset : 24, access : RW
output	reg [7:0] r_aib_csr0_aib_csr0_ctrl_3 ,
// register offset : 0x24, field offset : 0, access : RW
output	reg [7:0] r_aib_csr1_aib_csr1_ctrl_4 ,
// register offset : 0x24, field offset : 8, access : RW
output	reg [7:0] r_aib_csr1_aib_csr1_ctrl_5 ,
// register offset : 0x24, field offset : 16, access : RW
output	reg [7:0] r_aib_csr1_aib_csr1_ctrl_6 ,
// register offset : 0x24, field offset : 24, access : RW
output	reg [7:0] r_aib_csr1_aib_csr1_ctrl_7 ,
// register offset : 0x28, field offset : 0, access : RW
output	reg [7:0] r_aib_csr2_aib_csr2_ctrl_8 ,
// register offset : 0x28, field offset : 8, access : RW
output	reg [7:0] r_aib_csr2_aib_csr2_ctrl_9 ,
// register offset : 0x28, field offset : 16, access : RW
output	reg [7:0] r_aib_csr2_aib_csr2_ctrl_10 ,
// register offset : 0x28, field offset : 24, access : RW
output	reg [7:0] r_aib_csr2_aib_csr2_ctrl_11 ,
// register offset : 0x2c, field offset : 0, access : RW
output	reg [7:0] r_aib_csr3_aib_csr3_ctrl_12 ,
// register offset : 0x2c, field offset : 8, access : RW
output	reg [7:0] r_aib_csr3_aib_csr3_ctrl_13 ,
// register offset : 0x2c, field offset : 16, access : RW
output	reg [7:0] r_aib_csr3_aib_csr3_ctrl_14 ,
// register offset : 0x2c, field offset : 24, access : RW
output	reg [7:0] r_aib_csr3_aib_csr3_ctrl_15 ,
// register offset : 0x30, field offset : 0, access : RW
output	reg [7:0] r_aib_csr4_aib_csr4_ctrl_16 ,
// register offset : 0x30, field offset : 8, access : RW
output	reg [7:0] r_aib_csr4_aib_csr4_ctrl_17 ,
// register offset : 0x30, field offset : 16, access : RW
output	reg [7:0] r_aib_csr4_aib_csr4_ctrl_18 ,
// register offset : 0x30, field offset : 24, access : RW
output	reg [7:0] r_aib_csr4_aib_csr4_ctrl_19 ,
// register offset : 0x34, field offset : 0, access : RW
output	reg [7:0] r_aib_csr5_aib_csr5_ctrl_20 ,
// register offset : 0x34, field offset : 8, access : RW
output	reg [7:0] r_aib_csr5_aib_csr5_ctrl_21 ,
// register offset : 0x34, field offset : 16, access : RW
output	reg [7:0] r_aib_csr5_aib_csr5_ctrl_22 ,
// register offset : 0x34, field offset : 24, access : RW
output	reg [7:0] r_aib_csr5_aib_csr5_ctrl_23 ,
// register offset : 0x38, field offset : 0, access : RW
output	reg [7:0] r_aib_csr6_aib_csr6_ctrl_24 ,
// register offset : 0x38, field offset : 8, access : RW
output	reg [7:0] r_aib_csr6_aib_csr6_ctrl_25 ,
// register offset : 0x38, field offset : 16, access : RW
output	reg [7:0] r_aib_csr6_aib_csr6_ctrl_26 ,
// register offset : 0x38, field offset : 24, access : RW
output	reg [7:0] r_aib_csr6_aib_csr6_ctrl_27 ,
// register offset : 0x3c, field offset : 0, access : RW
output	reg [7:0] r_aib_csr7_aib_csr7_ctrl_28 ,
// register offset : 0x3c, field offset : 8, access : RW
output	reg [7:0] r_aib_csr7_aib_csr7_ctrl_29 ,
// register offset : 0x3c, field offset : 16, access : RW
output	reg [7:0] r_aib_csr7_aib_csr7_ctrl_30 ,
// register offset : 0x3c, field offset : 24, access : RW
output	reg [7:0] r_aib_csr7_aib_csr7_ctrl_31 ,
// register offset : 0x40, field offset : 0, access : RW
output	reg [7:0] r_aib_csr8_aib_csr8_ctrl_32 ,
// register offset : 0x40, field offset : 8, access : RW
output	reg [7:0] r_aib_csr8_aib_csr8_ctrl_33 ,
// register offset : 0x40, field offset : 16, access : RW
output	reg [7:0] r_aib_csr8_aib_csr8_ctrl_34 ,
// register offset : 0x40, field offset : 24, access : RW
output	reg [7:0] r_aib_csr8_aib_csr8_ctrl_35 ,
// register offset : 0x44, field offset : 0, access : RW
output	reg [7:0] r_aib_csr9_aib_csr9_ctrl_36 ,
// register offset : 0x44, field offset : 8, access : RW
output	reg [7:0] r_aib_csr9_aib_csr9_ctrl_37 ,
// register offset : 0x44, field offset : 16, access : RW
output	reg [7:0] r_aib_csr9_aib_csr9_ctrl_38 ,
// register offset : 0x44, field offset : 24, access : RW
output	reg [7:0] r_aib_csr9_aib_csr9_ctrl_39 ,
// register offset : 0x48, field offset : 0, access : RW
output	reg [31:0] r_aib_csr10_aib_csr10_ctrl_4x ,
// register offset : 0x4c, field offset : 0, access : RW
output	reg [31:0] r_aib_csr11_aib_csr11_ctrl_4x ,
// register offset : 0x50, field offset : 0, access : RW
output	reg [31:0] r_aib_csr12_aib_csr12_ctrl_4x ,
// register offset : 0x54, field offset : 0, access : RW
output	reg [15:0] r_aib_csr13_aib_csr13_ctrl_5x ,
// register offset : r_cfg_outbox, field offset : 31, access : RW
input    r_cfg_outbox_send_msg_i,
// register offset : r_cfg_inbox, field offset : 0, access : RO
input  [29:0]  r_cfg_inbox_cfg_msg_i,
// register offset : r_cfg_inbox, field offset : 31, access : RO
input    r_cfg_inbox_new_msg_i,
// register offset : r_avmm, field offset : 8, access : RW
input  [7:0]  r_avmm_spare_rsvd_i,
// register offset : r_avmm, field offset : 16, access : RW
input  [3:0]  r_avmm_spare_rsvd_prst_i,
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
input [6:0] address

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
wire [6:0] addr = address[6:0];
wire [31:0] din  = writedata [31:0];
// A write byte enable for each register
// register r_cfg_outbox with  writeType:  write
wire	[3:0]  we_r_cfg_outbox		=	we  & (addr[6:0]  == 7'h00)	?	byteenable[3:0]	:	{4{1'b0}};
// register r_cfg_inbox with  writeType:  write
wire	  we_r_cfg_inbox		=	we  & (addr[6:0]  == 7'h04)	?	byteenable[3]	:	1'b0;
// register r_ifctl with  writeType:  write
wire	[3:0]  we_r_ifctl		=	we  & (addr[6:0]  == 7'h08)	?	byteenable[3:0]	:	{4{1'b0}};
// register r_rstctl with  writeType:  write
wire	[2:0]  we_r_rstctl		=	we  & (addr[6:0]  == 7'h0c)	?	byteenable[2:0]	:	{3{1'b0}};
// register r_avmm with  writeType:  write
wire	[2:0]  we_r_avmm		=	we  & (addr[6:0]  == 7'h10)	?	byteenable[2:0]	:	{3{1'b0}};
// register r_sr with  writeType:  write
wire	  we_r_sr		=	we  & (addr[6:0]  == 7'h14)	?	byteenable[0]	:	1'b0;
// register r_avmm1 with  writeType:  write
wire	[2:0]  we_r_avmm1		=	we  & (addr[6:0]  == 7'h18)	?	byteenable[2:0]	:	{3{1'b0}};
// register r_avmm2 with  writeType:  write
wire	[2:0]  we_r_avmm2		=	we  & (addr[6:0]  == 7'h1c)	?	byteenable[2:0]	:	{3{1'b0}};
// register r_aib_csr0 with  writeType:  write
wire	[3:0]  we_r_aib_csr0		=	we  & (addr[6:0]  == 7'h20)	?	byteenable[3:0]	:	{4{1'b0}};
// register r_aib_csr1 with  writeType:  write
wire	[3:0]  we_r_aib_csr1		=	we  & (addr[6:0]  == 7'h24)	?	byteenable[3:0]	:	{4{1'b0}};
// register r_aib_csr2 with  writeType:  write
wire	[3:0]  we_r_aib_csr2		=	we  & (addr[6:0]  == 7'h28)	?	byteenable[3:0]	:	{4{1'b0}};
// register r_aib_csr3 with  writeType:  write
wire	[3:0]  we_r_aib_csr3		=	we  & (addr[6:0]  == 7'h2c)	?	byteenable[3:0]	:	{4{1'b0}};
// register r_aib_csr4 with  writeType:  write
wire	[3:0]  we_r_aib_csr4		=	we  & (addr[6:0]  == 7'h30)	?	byteenable[3:0]	:	{4{1'b0}};
// register r_aib_csr5 with  writeType:  write
wire	[3:0]  we_r_aib_csr5		=	we  & (addr[6:0]  == 7'h34)	?	byteenable[3:0]	:	{4{1'b0}};
// register r_aib_csr6 with  writeType:  write
wire	[3:0]  we_r_aib_csr6		=	we  & (addr[6:0]  == 7'h38)	?	byteenable[3:0]	:	{4{1'b0}};
// register r_aib_csr7 with  writeType:  write
wire	[3:0]  we_r_aib_csr7		=	we  & (addr[6:0]  == 7'h3c)	?	byteenable[3:0]	:	{4{1'b0}};
// register r_aib_csr8 with  writeType:  write
wire	[3:0]  we_r_aib_csr8		=	we  & (addr[6:0]  == 7'h40)	?	byteenable[3:0]	:	{4{1'b0}};
// register r_aib_csr9 with  writeType:  write
wire	[3:0]  we_r_aib_csr9		=	we  & (addr[6:0]  == 7'h44)	?	byteenable[3:0]	:	{4{1'b0}};
// register r_aib_csr10 with  writeType:  write
wire	[3:0]  we_r_aib_csr10		=	we  & (addr[6:0]  == 7'h48)	?	byteenable[3:0]	:	{4{1'b0}};
// register r_aib_csr11 with  writeType:  write
wire	[3:0]  we_r_aib_csr11		=	we  & (addr[6:0]  == 7'h4c)	?	byteenable[3:0]	:	{4{1'b0}};
// register r_aib_csr12 with  writeType:  write
wire	[3:0]  we_r_aib_csr12		=	we  & (addr[6:0]  == 7'h50)	?	byteenable[3:0]	:	{4{1'b0}};
// register r_aib_csr13 with  writeType:  write
wire	[1:0]  we_r_aib_csr13		=	we  & (addr[6:0]  == 7'h54)	?	byteenable[1:0]	:	{2{1'b0}};

// A read byte 	enable for each register


/* Definitions of REGISTER "r_cfg_outbox" */

// r_cfg_outbox_cfg_msg
// bitfield description: Message to send
// customType  RW
// hwAccess: RO 
// reset value : 0x00000000 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_cfg_outbox_cfg_msg <= 30'h00000000;
   end
   else begin
      if (we_r_cfg_outbox[0]) begin 
         r_cfg_outbox_cfg_msg[7:0]   <=  din[7:0];  //
      end
      if (we_r_cfg_outbox[1]) begin 
         r_cfg_outbox_cfg_msg[15:8]   <=  din[15:8];  //
      end
      if (we_r_cfg_outbox[2]) begin 
         r_cfg_outbox_cfg_msg[23:16]   <=  din[23:16];  //
      end
      if (we_r_cfg_outbox[3]) begin 
         r_cfg_outbox_cfg_msg[29:24]   <=  din[29:24];  //
      end
end

// r_cfg_outbox_send_msg
// bitfield description: 1: Initiate message transfer (auto-clear)
// customType  RW
// hwAccess: RW 
// reset value : 0x0 
// inputPort: "EMPTY" 
// outputPort:  "" 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_cfg_outbox_send_msg <= 1'h0;
   end
   else begin
      if (we_r_cfg_outbox[3]) begin 
         r_cfg_outbox_send_msg   <=  din[31];  //
      end
      else begin 
         r_cfg_outbox_send_msg   <=  r_cfg_outbox_send_msg_i ;
      end
end

/* Definitions of REGISTER "r_cfg_inbox" */

// r_cfg_inbox_cfg_msg
// bitfield description: Message received
// customType  RO
// hwAccess: RW 
// reset value : 0x00000000 
// inputPort: "EMPTY" 
// outputPort:  "" 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_cfg_inbox_cfg_msg <= 30'h00000000;
   end
   else begin
         r_cfg_inbox_cfg_msg[29:0]   <=  r_cfg_inbox_cfg_msg_i[29:0] ;
end

// r_cfg_inbox_autoclear_dis
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
      r_cfg_inbox_autoclear_dis <= 1'h0;
   end
   else begin
      if (we_r_cfg_inbox) begin 
         r_cfg_inbox_autoclear_dis   <=  din[30];  //
      end
end

// r_cfg_inbox_new_msg
// bitfield description: Message status 
// 
// 1: New message received. (Clears on read)
// 
// 0: No new message
// customType  RO
// hwAccess: RW 
// reset value : 0x0 
// inputPort: "EMPTY" 
// outputPort:  "" 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_cfg_inbox_new_msg <= 1'h0;
   end
   else begin
         r_cfg_inbox_new_msg   <=  r_cfg_inbox_new_msg_i ;
end

/* Definitions of REGISTER "r_ifctl" */

// r_ifctl_usr_active
// bitfield description: Avalon-MM master configuration arbitration
// 1: User has access to  registers, 0:  has access to config registers
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_ifctl_usr_active <= 1'h0;
   end
   else begin
      if (we_r_ifctl[0]) begin 
         r_ifctl_usr_active   <=  din[0];  //
      end
end

// r_ifctl_mcast_addr
// bitfield description: Multicast address
// Specifies upper bits (16:11) to allow broadcast of Avalon-MM write
// Available address: 6b1000_10 to 6b1110_10
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_ifctl_mcast_addr <= 6'h00;
   end
   else begin
      if (we_r_ifctl[1]) begin 
         r_ifctl_mcast_addr[5:0]   <=  din[13:8];  //
      end
end

// r_ifctl_mcast_en
// bitfield description: Multicast address enable
// 1: enable the channel to accept  write with upper address targeting mcast_addr(5:0)
// Valid only for  Avalon-MM write requests
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_ifctl_mcast_en <= 1'h0;
   end
   else begin
      if (we_r_ifctl[1]) begin 
         r_ifctl_mcast_en   <=  din[15];  //
      end
end

// r_ifctl_hwcfg_mode
// bitfield description: Hardware-based configuration setting
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_ifctl_hwcfg_mode <= 7'h00;
   end
   else begin
      if (we_r_ifctl[2]) begin 
         r_ifctl_hwcfg_mode[6:0]   <=  din[22:16];  //
      end
end

// r_ifctl_hwcfg_adpt_en
// bitfield description: Enable hardware-based configuration for Adapter registers
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_ifctl_hwcfg_adpt_en <= 1'h0;
   end
   else begin
      if (we_r_ifctl[2]) begin 
         r_ifctl_hwcfg_adpt_en   <=  din[23];  //
      end
end

// r_ifctl_hwcfg_aib_en
// bitfield description: Enable hardware-based configuration for AIB registes
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_ifctl_hwcfg_aib_en <= 1'h0;
   end
   else begin
      if (we_r_ifctl[3]) begin 
         r_ifctl_hwcfg_aib_en   <=  din[24];  //
      end
end

/* Definitions of REGISTER "r_rstctl" */

// r_rstctl_tx_elane_ovrval
// bitfield description: TX Elane reset override value
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_rstctl_tx_elane_ovrval <= 1'h0;
   end
   else begin
      if (we_r_rstctl[0]) begin 
         r_rstctl_tx_elane_ovrval   <=  din[0];  //
      end
end

// r_rstctl_tx_elane_ovren
// bitfield description: TX Elane reset override enable. 
// 0: PLD drives reset, 1: NIOS-II drives reset
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_rstctl_tx_elane_ovren <= 1'h0;
   end
   else begin
      if (we_r_rstctl[0]) begin 
         r_rstctl_tx_elane_ovren   <=  din[1];  //
      end
end

// r_rstctl_rx_elane_ovrval
// bitfield description: RX Elane reset override value
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_rstctl_rx_elane_ovrval <= 1'h0;
   end
   else begin
      if (we_r_rstctl[0]) begin 
         r_rstctl_rx_elane_ovrval   <=  din[2];  //
      end
end

// r_rstctl_rx_elane_ovren
// bitfield description: RX Elane reset override enable. 
// 0: PLD drives reset, 1: NIOS-II drives reset
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_rstctl_rx_elane_ovren <= 1'h0;
   end
   else begin
      if (we_r_rstctl[0]) begin 
         r_rstctl_rx_elane_ovren   <=  din[3];  //
      end
end

// r_rstctl_tx_xcvrif_ovrval
// bitfield description: TX XCVRIF reset override value
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_rstctl_tx_xcvrif_ovrval <= 1'h0;
   end
   else begin
      if (we_r_rstctl[0]) begin 
         r_rstctl_tx_xcvrif_ovrval   <=  din[4];  //
      end
end

// r_rstctl_tx_xcvrif_ovren
// bitfield description: TX XCVRIF reset override enable. 
// 0: PLD drives reset, 1: NIOS-II drives reset
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_rstctl_tx_xcvrif_ovren <= 1'h0;
   end
   else begin
      if (we_r_rstctl[0]) begin 
         r_rstctl_tx_xcvrif_ovren   <=  din[5];  //
      end
end

// r_rstctl_rx_xcvrif_ovrval
// bitfield description: RX XCVRIF reset override value
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_rstctl_rx_xcvrif_ovrval <= 1'h0;
   end
   else begin
      if (we_r_rstctl[0]) begin 
         r_rstctl_rx_xcvrif_ovrval   <=  din[6];  //
      end
end

// r_rstctl_rx_xcvrif_ovren
// bitfield description: RX XCVRIF reset override enable.
// 0: PLD drives reset, 1: NIOS-II drives reset
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_rstctl_rx_xcvrif_ovren <= 1'h0;
   end
   else begin
      if (we_r_rstctl[0]) begin 
         r_rstctl_rx_xcvrif_ovren   <=  din[7];  //
      end
end

// r_rstctl_tx_adpt_ovrval
// bitfield description: TX Adapt reset override value
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_rstctl_tx_adpt_ovrval <= 1'h0;
   end
   else begin
      if (we_r_rstctl[1]) begin 
         r_rstctl_tx_adpt_ovrval   <=  din[8];  //
      end
end

// r_rstctl_tx_adpt_ovren
// bitfield description: TX Adapt reset override enable. 
// 0: PLD drives reset, 1: NIOS-II drives reset
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_rstctl_tx_adpt_ovren <= 1'h0;
   end
   else begin
      if (we_r_rstctl[1]) begin 
         r_rstctl_tx_adpt_ovren   <=  din[9];  //
      end
end

// r_rstctl_rx_adpt_ovrval
// bitfield description: RX Adapt reset override value
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_rstctl_rx_adpt_ovrval <= 1'h0;
   end
   else begin
      if (we_r_rstctl[1]) begin 
         r_rstctl_rx_adpt_ovrval   <=  din[10];  //
      end
end

// r_rstctl_rx_adpt_ovren
// bitfield description: RX Adapt reset override enable.
// 0: PLD drives reset, 1: NIOS-II drives reset
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_rstctl_rx_adpt_ovren <= 1'h0;
   end
   else begin
      if (we_r_rstctl[1]) begin 
         r_rstctl_rx_adpt_ovren   <=  din[11];  //
      end
end

// r_rstctl_tx_pld_div2_rst_opt
// bitfield description: TX Adapt Option to reset div-2 clock dividers
// 0: PLD may not reset dividers, 1: PLD may reset dividers
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_rstctl_tx_pld_div2_rst_opt <= 1'h0;
   end
   else begin
      if (we_r_rstctl[2]) begin 
         r_rstctl_tx_pld_div2_rst_opt   <=  din[16];  //
      end
end

/* Definitions of REGISTER "r_avmm" */

// r_avmm_testbus_sel
// bitfield description: AVMM Testbus Sel
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_avmm_testbus_sel <= 2'h0;
   end
   else begin
      if (we_r_avmm[0]) begin 
         r_avmm_testbus_sel[1:0]   <=  din[1:0];  //
      end
end

// r_avmm_hrdrst_osc_clk_scg_en
// bitfield description: Hard Reset Osc Clock SCG Enable
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_avmm_hrdrst_osc_clk_scg_en <= 1'h0;
   end
   else begin
      if (we_r_avmm[0]) begin 
         r_avmm_hrdrst_osc_clk_scg_en   <=  din[4];  //
      end
end

// r_avmm_spare_rsvd
// bitfield description: Reserved spare bits
// customType  RW
// hwAccess: RW 
// reset value : 0x00 
// inputPort: "EMPTY" 
// outputPort:  "" 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_avmm_spare_rsvd <= 8'h00;
   end
   else begin
      if (we_r_avmm[1]) begin 
         r_avmm_spare_rsvd[7:0]   <=  din[15:8];  //
      end
      else begin 
         r_avmm_spare_rsvd[7:0]   <=  r_avmm_spare_rsvd_i[7:0] ;
      end
end

// r_avmm_spare_rsvd_prst
// bitfield description: Reserved spare bits w/ preset
// customType  RW
// hwAccess: RW 
// reset value : 0xf 
// inputPort: "EMPTY" 
// outputPort:  "" 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_avmm_spare_rsvd_prst <= 4'hf;
   end
   else begin
      if (we_r_avmm[2]) begin 
         r_avmm_spare_rsvd_prst[3:0]   <=  din[19:16];  //
      end
      else begin 
         r_avmm_spare_rsvd_prst[3:0]   <=  r_avmm_spare_rsvd_prst_i[3:0] ;
      end
end

/* Definitions of REGISTER "r_sr" */

// r_sr_hip_en
// bitfield description: HIP Enable
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_sr_hip_en <= 1'h0;
   end
   else begin
      if (we_r_sr) begin 
         r_sr_hip_en   <=  din[0];  //
      end
end

// r_sr_reserbits_in_en
// bitfield description: SR Reserbits In En
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_sr_reserbits_in_en <= 1'h0;
   end
   else begin
      if (we_r_sr) begin 
         r_sr_reserbits_in_en   <=  din[1];  //
      end
end

// r_sr_reserbits_out_en
// bitfield description: SR Reserbits Out En
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_sr_reserbits_out_en <= 1'h0;
   end
   else begin
      if (we_r_sr) begin 
         r_sr_reserbits_out_en   <=  din[2];  //
      end
end

// r_sr_parity_en
// bitfield description: SR Parity Enable
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_sr_parity_en <= 1'h0;
   end
   else begin
      if (we_r_sr) begin 
         r_sr_parity_en   <=  din[3];  //
      end
end

// r_sr_osc_clk_scg_en
// bitfield description: SR Osc Clk SCG Enable
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_sr_osc_clk_scg_en <= 1'h0;
   end
   else begin
      if (we_r_sr) begin 
         r_sr_osc_clk_scg_en   <=  din[4];  //
      end
end

// r_sr_osc_clk_div_sel
// bitfield description: SR Osc Clk Div Sel
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_sr_osc_clk_div_sel <= 2'h0;
   end
   else begin
      if (we_r_sr) begin 
         r_sr_osc_clk_div_sel[1:0]   <=  din[6:5];  //
      end
end

// r_sr_free_run_div_clk
// bitfield description: SR Free-Run Div
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_sr_free_run_div_clk <= 1'h0;
   end
   else begin
      if (we_r_sr) begin 
         r_sr_free_run_div_clk   <=  din[7];  //
      end
end

/* Definitions of REGISTER "r_avmm1" */

// r_avmm1_osc_clk_scg_en
// bitfield description: Oscillator Clock SCG Enable
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_avmm1_osc_clk_scg_en <= 1'h0;
   end
   else begin
      if (we_r_avmm1[0]) begin 
         r_avmm1_osc_clk_scg_en   <=  din[0];  //
      end
end

// r_avmm1_avmm_clk_scg_en
// bitfield description: AVMM Clock SCG Enable
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_avmm1_avmm_clk_scg_en <= 1'h0;
   end
   else begin
      if (we_r_avmm1[0]) begin 
         r_avmm1_avmm_clk_scg_en   <=  din[1];  //
      end
end

// r_avmm1_avmm_clk_dcg_en
// bitfield description: AVMM Clock DCG Enable
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_avmm1_avmm_clk_dcg_en <= 1'h0;
   end
   else begin
      if (we_r_avmm1[0]) begin 
         r_avmm1_avmm_clk_dcg_en   <=  din[2];  //
      end
end

// r_avmm1_free_run_div_clk
// bitfield description: AVMM1 Free Run Div Clock
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_avmm1_free_run_div_clk <= 1'h0;
   end
   else begin
      if (we_r_avmm1[0]) begin 
         r_avmm1_free_run_div_clk   <=  din[3];  //
      end
end

// r_avmm1_rdfifo_full
// bitfield description: AVMM1 Read-FIFO full
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_avmm1_rdfifo_full <= 6'h00;
   end
   else begin
      if (we_r_avmm1[0]) begin 
         r_avmm1_rdfifo_full[3:0]   <=  din[7:4];  //
      end
      if (we_r_avmm1[1]) begin 
         r_avmm1_rdfifo_full[5:4]   <=  din[9:8];  //
      end
end

// r_avmm1_rdfifo_stop_read
// bitfield description: AVMM1 Read-FIFO Stop Read
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_avmm1_rdfifo_stop_read <= 1'h0;
   end
   else begin
      if (we_r_avmm1[1]) begin 
         r_avmm1_rdfifo_stop_read   <=  din[10];  //
      end
end

// r_avmm1_rdfifo_stop_write
// bitfield description: AVMM1 Read-FIFO Stop Write
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_avmm1_rdfifo_stop_write <= 1'h0;
   end
   else begin
      if (we_r_avmm1[1]) begin 
         r_avmm1_rdfifo_stop_write   <=  din[11];  //
      end
end

// r_avmm1_rdfifo_empty
// bitfield description: AVMM1 Read-FIFO Empty
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_avmm1_rdfifo_empty <= 6'h00;
   end
   else begin
      if (we_r_avmm1[1]) begin 
         r_avmm1_rdfifo_empty[3:0]   <=  din[15:12];  //
      end
      if (we_r_avmm1[2]) begin 
         r_avmm1_rdfifo_empty[5:4]   <=  din[17:16];  //
      end
end

// r_avmm1_use_rsvd_bit1
// bitfield description: [1]: Enable AVMM1 reserved bit [1] as write 'done' indicator.
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_avmm1_use_rsvd_bit1 <= 1'h0;
   end
   else begin
      if (we_r_avmm1[2]) begin 
         r_avmm1_use_rsvd_bit1   <=  din[20];  //
      end
end

// r_avmm1_sr_test_enable
// bitfield description: SR Test Enable
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_avmm1_sr_test_enable <= 1'h0;
   end
   else begin
      if (we_r_avmm1[2]) begin 
         r_avmm1_sr_test_enable   <=  din[21];  //
      end
end

/* Definitions of REGISTER "r_avmm2" */

// r_avmm2_osc_clk_scg_en
// bitfield description: Oscillator Clock SCG Enable
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_avmm2_osc_clk_scg_en <= 1'h0;
   end
   else begin
      if (we_r_avmm2[0]) begin 
         r_avmm2_osc_clk_scg_en   <=  din[0];  //
      end
end

// r_avmm2_avmm_clk_scg_en
// bitfield description: AVMM2 Clock SCG Enable
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_avmm2_avmm_clk_scg_en <= 1'h0;
   end
   else begin
      if (we_r_avmm2[0]) begin 
         r_avmm2_avmm_clk_scg_en   <=  din[1];  //
      end
end

// r_avmm2_avmm_clk_dcg_en
// bitfield description: AVMM2 Clock DCG Enable
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_avmm2_avmm_clk_dcg_en <= 1'h0;
   end
   else begin
      if (we_r_avmm2[0]) begin 
         r_avmm2_avmm_clk_dcg_en   <=  din[2];  //
      end
end

// r_avmm2_free_run_div_clk
// bitfield description: AVMM2 Free Run Div Clock
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_avmm2_free_run_div_clk <= 1'h0;
   end
   else begin
      if (we_r_avmm2[0]) begin 
         r_avmm2_free_run_div_clk   <=  din[3];  //
      end
end

// r_avmm2_rdfifo_full
// bitfield description: AVMM2 Read-FIFO full
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_avmm2_rdfifo_full <= 6'h00;
   end
   else begin
      if (we_r_avmm2[0]) begin 
         r_avmm2_rdfifo_full[3:0]   <=  din[7:4];  //
      end
      if (we_r_avmm2[1]) begin 
         r_avmm2_rdfifo_full[5:4]   <=  din[9:8];  //
      end
end

// r_avmm2_rdfifo_stop_read
// bitfield description: AVMM2 Read-FIFO Stop Read
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_avmm2_rdfifo_stop_read <= 1'h0;
   end
   else begin
      if (we_r_avmm2[1]) begin 
         r_avmm2_rdfifo_stop_read   <=  din[10];  //
      end
end

// r_avmm2_rdfifo_stop_write
// bitfield description: AVMM2 Read-FIFO Stop Write
// customType  RW
// hwAccess: RO 
// reset value : 0x0 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_avmm2_rdfifo_stop_write <= 1'h0;
   end
   else begin
      if (we_r_avmm2[1]) begin 
         r_avmm2_rdfifo_stop_write   <=  din[11];  //
      end
end

// r_avmm2_rdfifo_empty
// bitfield description: AVMM2 Read-FIFO Empty
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_avmm2_rdfifo_empty <= 6'h00;
   end
   else begin
      if (we_r_avmm2[1]) begin 
         r_avmm2_rdfifo_empty[3:0]   <=  din[15:12];  //
      end
      if (we_r_avmm2[2]) begin 
         r_avmm2_rdfifo_empty[5:4]   <=  din[17:16];  //
      end
end

/* Definitions of REGISTER "r_aib_csr0" */

// r_aib_csr0_aib_csr0_ctrl_0
// bitfield description: AIB Control 0
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_aib_csr0_aib_csr0_ctrl_0 <= 8'h00;
   end
   else begin
      if (we_r_aib_csr0[0]) begin 
         r_aib_csr0_aib_csr0_ctrl_0[7:0]   <=  din[7:0];  //
      end
end

// r_aib_csr0_aib_csr0_ctrl_1
// bitfield description: AIB Control 1
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_aib_csr0_aib_csr0_ctrl_1 <= 8'h00;
   end
   else begin
      if (we_r_aib_csr0[1]) begin 
         r_aib_csr0_aib_csr0_ctrl_1[7:0]   <=  din[15:8];  //
      end
end

// r_aib_csr0_aib_csr0_ctrl_2
// bitfield description: AIB Control 2
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_aib_csr0_aib_csr0_ctrl_2 <= 8'h00;
   end
   else begin
      if (we_r_aib_csr0[2]) begin 
         r_aib_csr0_aib_csr0_ctrl_2[7:0]   <=  din[23:16];  //
      end
end

// r_aib_csr0_aib_csr0_ctrl_3
// bitfield description: AIB Control 3
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_aib_csr0_aib_csr0_ctrl_3 <= 8'h00;
   end
   else begin
      if (we_r_aib_csr0[3]) begin 
         r_aib_csr0_aib_csr0_ctrl_3[7:0]   <=  din[31:24];  //
      end
end

/* Definitions of REGISTER "r_aib_csr1" */

// r_aib_csr1_aib_csr1_ctrl_4
// bitfield description: AIB Control 4
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_aib_csr1_aib_csr1_ctrl_4 <= 8'h00;
   end
   else begin
      if (we_r_aib_csr1[0]) begin 
         r_aib_csr1_aib_csr1_ctrl_4[7:0]   <=  din[7:0];  //
      end
end

// r_aib_csr1_aib_csr1_ctrl_5
// bitfield description: AIB Control 5
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_aib_csr1_aib_csr1_ctrl_5 <= 8'h00;
   end
   else begin
      if (we_r_aib_csr1[1]) begin 
         r_aib_csr1_aib_csr1_ctrl_5[7:0]   <=  din[15:8];  //
      end
end

// r_aib_csr1_aib_csr1_ctrl_6
// bitfield description: AIB Control 6
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_aib_csr1_aib_csr1_ctrl_6 <= 8'h00;
   end
   else begin
      if (we_r_aib_csr1[2]) begin 
         r_aib_csr1_aib_csr1_ctrl_6[7:0]   <=  din[23:16];  //
      end
end

// r_aib_csr1_aib_csr1_ctrl_7
// bitfield description: AIB Control 7
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_aib_csr1_aib_csr1_ctrl_7 <= 8'h00;
   end
   else begin
      if (we_r_aib_csr1[3]) begin 
         r_aib_csr1_aib_csr1_ctrl_7[7:0]   <=  din[31:24];  //
      end
end

/* Definitions of REGISTER "r_aib_csr2" */

// r_aib_csr2_aib_csr2_ctrl_8
// bitfield description: AIB Control 8
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_aib_csr2_aib_csr2_ctrl_8 <= 8'h00;
   end
   else begin
      if (we_r_aib_csr2[0]) begin 
         r_aib_csr2_aib_csr2_ctrl_8[7:0]   <=  din[7:0];  //
      end
end

// r_aib_csr2_aib_csr2_ctrl_9
// bitfield description: AIB Control 9
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_aib_csr2_aib_csr2_ctrl_9 <= 8'h00;
   end
   else begin
      if (we_r_aib_csr2[1]) begin 
         r_aib_csr2_aib_csr2_ctrl_9[7:0]   <=  din[15:8];  //
      end
end

// r_aib_csr2_aib_csr2_ctrl_10
// bitfield description: AIB Control 10
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_aib_csr2_aib_csr2_ctrl_10 <= 8'h00;
   end
   else begin
      if (we_r_aib_csr2[2]) begin 
         r_aib_csr2_aib_csr2_ctrl_10[7:0]   <=  din[23:16];  //
      end
end

// r_aib_csr2_aib_csr2_ctrl_11
// bitfield description: AIB Control 11
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_aib_csr2_aib_csr2_ctrl_11 <= 8'h00;
   end
   else begin
      if (we_r_aib_csr2[3]) begin 
         r_aib_csr2_aib_csr2_ctrl_11[7:0]   <=  din[31:24];  //
      end
end

/* Definitions of REGISTER "r_aib_csr3" */

// r_aib_csr3_aib_csr3_ctrl_12
// bitfield description: AIB Control 12
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_aib_csr3_aib_csr3_ctrl_12 <= 8'h00;
   end
   else begin
      if (we_r_aib_csr3[0]) begin 
         r_aib_csr3_aib_csr3_ctrl_12[7:0]   <=  din[7:0];  //
      end
end

// r_aib_csr3_aib_csr3_ctrl_13
// bitfield description: AIB Control 13
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_aib_csr3_aib_csr3_ctrl_13 <= 8'h00;
   end
   else begin
      if (we_r_aib_csr3[1]) begin 
         r_aib_csr3_aib_csr3_ctrl_13[7:0]   <=  din[15:8];  //
      end
end

// r_aib_csr3_aib_csr3_ctrl_14
// bitfield description: AIB Control 14
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_aib_csr3_aib_csr3_ctrl_14 <= 8'h00;
   end
   else begin
      if (we_r_aib_csr3[2]) begin 
         r_aib_csr3_aib_csr3_ctrl_14[7:0]   <=  din[23:16];  //
      end
end

// r_aib_csr3_aib_csr3_ctrl_15
// bitfield description: AIB Control 15
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_aib_csr3_aib_csr3_ctrl_15 <= 8'h00;
   end
   else begin
      if (we_r_aib_csr3[3]) begin 
         r_aib_csr3_aib_csr3_ctrl_15[7:0]   <=  din[31:24];  //
      end
end

/* Definitions of REGISTER "r_aib_csr4" */

// r_aib_csr4_aib_csr4_ctrl_16
// bitfield description: AIB Control 16
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_aib_csr4_aib_csr4_ctrl_16 <= 8'h00;
   end
   else begin
      if (we_r_aib_csr4[0]) begin 
         r_aib_csr4_aib_csr4_ctrl_16[7:0]   <=  din[7:0];  //
      end
end

// r_aib_csr4_aib_csr4_ctrl_17
// bitfield description: AIB Control 17
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_aib_csr4_aib_csr4_ctrl_17 <= 8'h00;
   end
   else begin
      if (we_r_aib_csr4[1]) begin 
         r_aib_csr4_aib_csr4_ctrl_17[7:0]   <=  din[15:8];  //
      end
end

// r_aib_csr4_aib_csr4_ctrl_18
// bitfield description: AIB Control 18
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_aib_csr4_aib_csr4_ctrl_18 <= 8'h00;
   end
   else begin
      if (we_r_aib_csr4[2]) begin 
         r_aib_csr4_aib_csr4_ctrl_18[7:0]   <=  din[23:16];  //
      end
end

// r_aib_csr4_aib_csr4_ctrl_19
// bitfield description: AIB Control 19
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_aib_csr4_aib_csr4_ctrl_19 <= 8'h00;
   end
   else begin
      if (we_r_aib_csr4[3]) begin 
         r_aib_csr4_aib_csr4_ctrl_19[7:0]   <=  din[31:24];  //
      end
end

/* Definitions of REGISTER "r_aib_csr5" */

// r_aib_csr5_aib_csr5_ctrl_20
// bitfield description: AIB Control 20
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_aib_csr5_aib_csr5_ctrl_20 <= 8'h00;
   end
   else begin
      if (we_r_aib_csr5[0]) begin 
         r_aib_csr5_aib_csr5_ctrl_20[7:0]   <=  din[7:0];  //
      end
end

// r_aib_csr5_aib_csr5_ctrl_21
// bitfield description: AIB Control 21
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_aib_csr5_aib_csr5_ctrl_21 <= 8'h00;
   end
   else begin
      if (we_r_aib_csr5[1]) begin 
         r_aib_csr5_aib_csr5_ctrl_21[7:0]   <=  din[15:8];  //
      end
end

// r_aib_csr5_aib_csr5_ctrl_22
// bitfield description: AIB Control 22
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_aib_csr5_aib_csr5_ctrl_22 <= 8'h00;
   end
   else begin
      if (we_r_aib_csr5[2]) begin 
         r_aib_csr5_aib_csr5_ctrl_22[7:0]   <=  din[23:16];  //
      end
end

// r_aib_csr5_aib_csr5_ctrl_23
// bitfield description: AIB Control 23
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_aib_csr5_aib_csr5_ctrl_23 <= 8'h00;
   end
   else begin
      if (we_r_aib_csr5[3]) begin 
         r_aib_csr5_aib_csr5_ctrl_23[7:0]   <=  din[31:24];  //
      end
end

/* Definitions of REGISTER "r_aib_csr6" */

// r_aib_csr6_aib_csr6_ctrl_24
// bitfield description: AIB Control 24
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_aib_csr6_aib_csr6_ctrl_24 <= 8'h00;
   end
   else begin
      if (we_r_aib_csr6[0]) begin 
         r_aib_csr6_aib_csr6_ctrl_24[7:0]   <=  din[7:0];  //
      end
end

// r_aib_csr6_aib_csr6_ctrl_25
// bitfield description: AIB Control 25
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_aib_csr6_aib_csr6_ctrl_25 <= 8'h00;
   end
   else begin
      if (we_r_aib_csr6[1]) begin 
         r_aib_csr6_aib_csr6_ctrl_25[7:0]   <=  din[15:8];  //
      end
end

// r_aib_csr6_aib_csr6_ctrl_26
// bitfield description: AIB Control 26
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_aib_csr6_aib_csr6_ctrl_26 <= 8'h00;
   end
   else begin
      if (we_r_aib_csr6[2]) begin 
         r_aib_csr6_aib_csr6_ctrl_26[7:0]   <=  din[23:16];  //
      end
end

// r_aib_csr6_aib_csr6_ctrl_27
// bitfield description: AIB Control 27
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_aib_csr6_aib_csr6_ctrl_27 <= 8'h00;
   end
   else begin
      if (we_r_aib_csr6[3]) begin 
         r_aib_csr6_aib_csr6_ctrl_27[7:0]   <=  din[31:24];  //
      end
end

/* Definitions of REGISTER "r_aib_csr7" */

// r_aib_csr7_aib_csr7_ctrl_28
// bitfield description: AIB Control 28
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_aib_csr7_aib_csr7_ctrl_28 <= 8'h00;
   end
   else begin
      if (we_r_aib_csr7[0]) begin 
         r_aib_csr7_aib_csr7_ctrl_28[7:0]   <=  din[7:0];  //
      end
end

// r_aib_csr7_aib_csr7_ctrl_29
// bitfield description: AIB Control 29
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_aib_csr7_aib_csr7_ctrl_29 <= 8'h00;
   end
   else begin
      if (we_r_aib_csr7[1]) begin 
         r_aib_csr7_aib_csr7_ctrl_29[7:0]   <=  din[15:8];  //
      end
end

// r_aib_csr7_aib_csr7_ctrl_30
// bitfield description: AIB Control 30
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_aib_csr7_aib_csr7_ctrl_30 <= 8'h00;
   end
   else begin
      if (we_r_aib_csr7[2]) begin 
         r_aib_csr7_aib_csr7_ctrl_30[7:0]   <=  din[23:16];  //
      end
end

// r_aib_csr7_aib_csr7_ctrl_31
// bitfield description: AIB Control 31
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_aib_csr7_aib_csr7_ctrl_31 <= 8'h00;
   end
   else begin
      if (we_r_aib_csr7[3]) begin 
         r_aib_csr7_aib_csr7_ctrl_31[7:0]   <=  din[31:24];  //
      end
end

/* Definitions of REGISTER "r_aib_csr8" */

// r_aib_csr8_aib_csr8_ctrl_32
// bitfield description: AIB Control 32
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_aib_csr8_aib_csr8_ctrl_32 <= 8'h00;
   end
   else begin
      if (we_r_aib_csr8[0]) begin 
         r_aib_csr8_aib_csr8_ctrl_32[7:0]   <=  din[7:0];  //
      end
end

// r_aib_csr8_aib_csr8_ctrl_33
// bitfield description: AIB Control 33
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_aib_csr8_aib_csr8_ctrl_33 <= 8'h00;
   end
   else begin
      if (we_r_aib_csr8[1]) begin 
         r_aib_csr8_aib_csr8_ctrl_33[7:0]   <=  din[15:8];  //
      end
end

// r_aib_csr8_aib_csr8_ctrl_34
// bitfield description: AIB Control 34
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_aib_csr8_aib_csr8_ctrl_34 <= 8'h00;
   end
   else begin
      if (we_r_aib_csr8[2]) begin 
         r_aib_csr8_aib_csr8_ctrl_34[7:0]   <=  din[23:16];  //
      end
end

// r_aib_csr8_aib_csr8_ctrl_35
// bitfield description: AIB Control 35
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_aib_csr8_aib_csr8_ctrl_35 <= 8'h00;
   end
   else begin
      if (we_r_aib_csr8[3]) begin 
         r_aib_csr8_aib_csr8_ctrl_35[7:0]   <=  din[31:24];  //
      end
end

/* Definitions of REGISTER "r_aib_csr9" */

// r_aib_csr9_aib_csr9_ctrl_36
// bitfield description: AIB Control 36
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_aib_csr9_aib_csr9_ctrl_36 <= 8'h00;
   end
   else begin
      if (we_r_aib_csr9[0]) begin 
         r_aib_csr9_aib_csr9_ctrl_36[7:0]   <=  din[7:0];  //
      end
end

// r_aib_csr9_aib_csr9_ctrl_37
// bitfield description: AIB Control 37
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_aib_csr9_aib_csr9_ctrl_37 <= 8'h00;
   end
   else begin
      if (we_r_aib_csr9[1]) begin 
         r_aib_csr9_aib_csr9_ctrl_37[7:0]   <=  din[15:8];  //
      end
end

// r_aib_csr9_aib_csr9_ctrl_38
// bitfield description: AIB Control 38
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_aib_csr9_aib_csr9_ctrl_38 <= 8'h00;
   end
   else begin
      if (we_r_aib_csr9[2]) begin 
         r_aib_csr9_aib_csr9_ctrl_38[7:0]   <=  din[23:16];  //
      end
end

// r_aib_csr9_aib_csr9_ctrl_39
// bitfield description: AIB Control 39
// customType  RW
// hwAccess: RO 
// reset value : 0x00 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_aib_csr9_aib_csr9_ctrl_39 <= 8'h00;
   end
   else begin
      if (we_r_aib_csr9[3]) begin 
         r_aib_csr9_aib_csr9_ctrl_39[7:0]   <=  din[31:24];  //
      end
end

/* Definitions of REGISTER "r_aib_csr10" */

// r_aib_csr10_aib_csr10_ctrl_4x
// bitfield description: AIB Control 40-43
// customType  RW
// hwAccess: RO 
// reset value : 0x00000000 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_aib_csr10_aib_csr10_ctrl_4x <= 32'h00000000;
   end
   else begin
      if (we_r_aib_csr10[0]) begin 
         r_aib_csr10_aib_csr10_ctrl_4x[7:0]   <=  din[7:0];  //
      end
      if (we_r_aib_csr10[1]) begin 
         r_aib_csr10_aib_csr10_ctrl_4x[15:8]   <=  din[15:8];  //
      end
      if (we_r_aib_csr10[2]) begin 
         r_aib_csr10_aib_csr10_ctrl_4x[23:16]   <=  din[23:16];  //
      end
      if (we_r_aib_csr10[3]) begin 
         r_aib_csr10_aib_csr10_ctrl_4x[31:24]   <=  din[31:24];  //
      end
end

/* Definitions of REGISTER "r_aib_csr11" */

// r_aib_csr11_aib_csr11_ctrl_4x
// bitfield description: AIB Control 44-47
// customType  RW
// hwAccess: RO 
// reset value : 0x00000000 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_aib_csr11_aib_csr11_ctrl_4x <= 32'h00000000;
   end
   else begin
      if (we_r_aib_csr11[0]) begin 
         r_aib_csr11_aib_csr11_ctrl_4x[7:0]   <=  din[7:0];  //
      end
      if (we_r_aib_csr11[1]) begin 
         r_aib_csr11_aib_csr11_ctrl_4x[15:8]   <=  din[15:8];  //
      end
      if (we_r_aib_csr11[2]) begin 
         r_aib_csr11_aib_csr11_ctrl_4x[23:16]   <=  din[23:16];  //
      end
      if (we_r_aib_csr11[3]) begin 
         r_aib_csr11_aib_csr11_ctrl_4x[31:24]   <=  din[31:24];  //
      end
end

/* Definitions of REGISTER "r_aib_csr12" */

// r_aib_csr12_aib_csr12_ctrl_4x
// bitfield description: AIB Control 48-51
// customType  RW
// hwAccess: RO 
// reset value : 0x00000000 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_aib_csr12_aib_csr12_ctrl_4x <= 32'h00000000;
   end
   else begin
      if (we_r_aib_csr12[0]) begin 
         r_aib_csr12_aib_csr12_ctrl_4x[7:0]   <=  din[7:0];  //
      end
      if (we_r_aib_csr12[1]) begin 
         r_aib_csr12_aib_csr12_ctrl_4x[15:8]   <=  din[15:8];  //
      end
      if (we_r_aib_csr12[2]) begin 
         r_aib_csr12_aib_csr12_ctrl_4x[23:16]   <=  din[23:16];  //
      end
      if (we_r_aib_csr12[3]) begin 
         r_aib_csr12_aib_csr12_ctrl_4x[31:24]   <=  din[31:24];  //
      end
end

/* Definitions of REGISTER "r_aib_csr13" */

// r_aib_csr13_aib_csr13_ctrl_5x
// bitfield description: AIB Control 52-53
// customType  RW
// hwAccess: RO 
// reset value : 0x0000 

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      r_aib_csr13_aib_csr13_ctrl_5x <= 16'h0000;
   end
   else begin
      if (we_r_aib_csr13[0]) begin 
         r_aib_csr13_aib_csr13_ctrl_5x[7:0]   <=  din[7:0];  //
      end
      if (we_r_aib_csr13[1]) begin 
         r_aib_csr13_aib_csr13_ctrl_5x[15:8]   <=  din[15:8];  //
      end
end




// read process
always @ (*)
begin
rdata_comb = 32'h0;
   if(re) begin
      case (addr)  
	7'h00 : begin
		rdata_comb [29:0]	= r_cfg_outbox_cfg_msg [29:0] ;		// readType = read   writeType =write
		rdata_comb [31]	= r_cfg_outbox_send_msg  ;		// readType = read   writeType =write
	end
	7'h04 : begin
		rdata_comb [29:0]	= r_cfg_inbox_cfg_msg [29:0] ;		// readType = read   writeType =illegal
		rdata_comb [30]	= r_cfg_inbox_autoclear_dis  ;		// readType = read   writeType =write
		rdata_comb [31]	= r_cfg_inbox_new_msg  ;		// readType = read   writeType =illegal
	end
	7'h08 : begin
		rdata_comb [0]	= r_ifctl_usr_active  ;		// readType = read   writeType =write
		rdata_comb [13:8]	= r_ifctl_mcast_addr [5:0] ;		// readType = read   writeType =write
		rdata_comb [15]	= r_ifctl_mcast_en  ;		// readType = read   writeType =write
		rdata_comb [22:16]	= r_ifctl_hwcfg_mode [6:0] ;		// readType = read   writeType =write
		rdata_comb [23]	= r_ifctl_hwcfg_adpt_en  ;		// readType = read   writeType =write
		rdata_comb [24]	= r_ifctl_hwcfg_aib_en  ;		// readType = read   writeType =write
	end
	7'h0c : begin
		rdata_comb [0]	= r_rstctl_tx_elane_ovrval  ;		// readType = read   writeType =write
		rdata_comb [1]	= r_rstctl_tx_elane_ovren  ;		// readType = read   writeType =write
		rdata_comb [2]	= r_rstctl_rx_elane_ovrval  ;		// readType = read   writeType =write
		rdata_comb [3]	= r_rstctl_rx_elane_ovren  ;		// readType = read   writeType =write
		rdata_comb [4]	= r_rstctl_tx_xcvrif_ovrval  ;		// readType = read   writeType =write
		rdata_comb [5]	= r_rstctl_tx_xcvrif_ovren  ;		// readType = read   writeType =write
		rdata_comb [6]	= r_rstctl_rx_xcvrif_ovrval  ;		// readType = read   writeType =write
		rdata_comb [7]	= r_rstctl_rx_xcvrif_ovren  ;		// readType = read   writeType =write
		rdata_comb [8]	= r_rstctl_tx_adpt_ovrval  ;		// readType = read   writeType =write
		rdata_comb [9]	= r_rstctl_tx_adpt_ovren  ;		// readType = read   writeType =write
		rdata_comb [10]	= r_rstctl_rx_adpt_ovrval  ;		// readType = read   writeType =write
		rdata_comb [11]	= r_rstctl_rx_adpt_ovren  ;		// readType = read   writeType =write
		rdata_comb [16]	= r_rstctl_tx_pld_div2_rst_opt  ;		// readType = read   writeType =write
	end
	7'h10 : begin
		rdata_comb [1:0]	= r_avmm_testbus_sel [1:0] ;		// readType = read   writeType =write
		rdata_comb [4]	= r_avmm_hrdrst_osc_clk_scg_en  ;		// readType = read   writeType =write
		rdata_comb [15:8]	= r_avmm_spare_rsvd [7:0] ;		// readType = read   writeType =write
		rdata_comb [19:16]	= r_avmm_spare_rsvd_prst [3:0] ;		// readType = read   writeType =write
	end
	7'h14 : begin
		rdata_comb [0]	= r_sr_hip_en  ;		// readType = read   writeType =write
		rdata_comb [1]	= r_sr_reserbits_in_en  ;		// readType = read   writeType =write
		rdata_comb [2]	= r_sr_reserbits_out_en  ;		// readType = read   writeType =write
		rdata_comb [3]	= r_sr_parity_en  ;		// readType = read   writeType =write
		rdata_comb [4]	= r_sr_osc_clk_scg_en  ;		// readType = read   writeType =write
		rdata_comb [6:5]	= r_sr_osc_clk_div_sel [1:0] ;		// readType = read   writeType =write
		rdata_comb [7]	= r_sr_free_run_div_clk  ;		// readType = read   writeType =write
	end
	7'h18 : begin
		rdata_comb [0]	= r_avmm1_osc_clk_scg_en  ;		// readType = read   writeType =write
		rdata_comb [1]	= r_avmm1_avmm_clk_scg_en  ;		// readType = read   writeType =write
		rdata_comb [2]	= r_avmm1_avmm_clk_dcg_en  ;		// readType = read   writeType =write
		rdata_comb [3]	= r_avmm1_free_run_div_clk  ;		// readType = read   writeType =write
		rdata_comb [9:4]	= r_avmm1_rdfifo_full [5:0] ;		// readType = read   writeType =write
		rdata_comb [10]	= r_avmm1_rdfifo_stop_read  ;		// readType = read   writeType =write
		rdata_comb [11]	= r_avmm1_rdfifo_stop_write  ;		// readType = read   writeType =write
		rdata_comb [17:12]	= r_avmm1_rdfifo_empty [5:0] ;		// readType = read   writeType =write
		rdata_comb [20]	= r_avmm1_use_rsvd_bit1  ;		// readType = read   writeType =write
		rdata_comb [21]	= r_avmm1_sr_test_enable  ;		// readType = read   writeType =write
	end
	7'h1c : begin
		rdata_comb [0]	= r_avmm2_osc_clk_scg_en  ;		// readType = read   writeType =write
		rdata_comb [1]	= r_avmm2_avmm_clk_scg_en  ;		// readType = read   writeType =write
		rdata_comb [2]	= r_avmm2_avmm_clk_dcg_en  ;		// readType = read   writeType =write
		rdata_comb [3]	= r_avmm2_free_run_div_clk  ;		// readType = read   writeType =write
		rdata_comb [9:4]	= r_avmm2_rdfifo_full [5:0] ;		// readType = read   writeType =write
		rdata_comb [10]	= r_avmm2_rdfifo_stop_read  ;		// readType = read   writeType =write
		rdata_comb [11]	= r_avmm2_rdfifo_stop_write  ;		// readType = read   writeType =write
		rdata_comb [17:12]	= r_avmm2_rdfifo_empty [5:0] ;		// readType = read   writeType =write
	end
	7'h20 : begin
		rdata_comb [7:0]	= r_aib_csr0_aib_csr0_ctrl_0 [7:0] ;		// readType = read   writeType =write
		rdata_comb [15:8]	= r_aib_csr0_aib_csr0_ctrl_1 [7:0] ;		// readType = read   writeType =write
		rdata_comb [23:16]	= r_aib_csr0_aib_csr0_ctrl_2 [7:0] ;		// readType = read   writeType =write
		rdata_comb [31:24]	= r_aib_csr0_aib_csr0_ctrl_3 [7:0] ;		// readType = read   writeType =write
	end
	7'h24 : begin
		rdata_comb [7:0]	= r_aib_csr1_aib_csr1_ctrl_4 [7:0] ;		// readType = read   writeType =write
		rdata_comb [15:8]	= r_aib_csr1_aib_csr1_ctrl_5 [7:0] ;		// readType = read   writeType =write
		rdata_comb [23:16]	= r_aib_csr1_aib_csr1_ctrl_6 [7:0] ;		// readType = read   writeType =write
		rdata_comb [31:24]	= r_aib_csr1_aib_csr1_ctrl_7 [7:0] ;		// readType = read   writeType =write
	end
	7'h28 : begin
		rdata_comb [7:0]	= r_aib_csr2_aib_csr2_ctrl_8 [7:0] ;		// readType = read   writeType =write
		rdata_comb [15:8]	= r_aib_csr2_aib_csr2_ctrl_9 [7:0] ;		// readType = read   writeType =write
		rdata_comb [23:16]	= r_aib_csr2_aib_csr2_ctrl_10 [7:0] ;		// readType = read   writeType =write
		rdata_comb [31:24]	= r_aib_csr2_aib_csr2_ctrl_11 [7:0] ;		// readType = read   writeType =write
	end
	7'h2c : begin
		rdata_comb [7:0]	= r_aib_csr3_aib_csr3_ctrl_12 [7:0] ;		// readType = read   writeType =write
		rdata_comb [15:8]	= r_aib_csr3_aib_csr3_ctrl_13 [7:0] ;		// readType = read   writeType =write
		rdata_comb [23:16]	= r_aib_csr3_aib_csr3_ctrl_14 [7:0] ;		// readType = read   writeType =write
		rdata_comb [31:24]	= r_aib_csr3_aib_csr3_ctrl_15 [7:0] ;		// readType = read   writeType =write
	end
	7'h30 : begin
		rdata_comb [7:0]	= r_aib_csr4_aib_csr4_ctrl_16 [7:0] ;		// readType = read   writeType =write
		rdata_comb [15:8]	= r_aib_csr4_aib_csr4_ctrl_17 [7:0] ;		// readType = read   writeType =write
		rdata_comb [23:16]	= r_aib_csr4_aib_csr4_ctrl_18 [7:0] ;		// readType = read   writeType =write
		rdata_comb [31:24]	= r_aib_csr4_aib_csr4_ctrl_19 [7:0] ;		// readType = read   writeType =write
	end
	7'h34 : begin
		rdata_comb [7:0]	= r_aib_csr5_aib_csr5_ctrl_20 [7:0] ;		// readType = read   writeType =write
		rdata_comb [15:8]	= r_aib_csr5_aib_csr5_ctrl_21 [7:0] ;		// readType = read   writeType =write
		rdata_comb [23:16]	= r_aib_csr5_aib_csr5_ctrl_22 [7:0] ;		// readType = read   writeType =write
		rdata_comb [31:24]	= r_aib_csr5_aib_csr5_ctrl_23 [7:0] ;		// readType = read   writeType =write
	end
	7'h38 : begin
		rdata_comb [7:0]	= r_aib_csr6_aib_csr6_ctrl_24 [7:0] ;		// readType = read   writeType =write
		rdata_comb [15:8]	= r_aib_csr6_aib_csr6_ctrl_25 [7:0] ;		// readType = read   writeType =write
		rdata_comb [23:16]	= r_aib_csr6_aib_csr6_ctrl_26 [7:0] ;		// readType = read   writeType =write
		rdata_comb [31:24]	= r_aib_csr6_aib_csr6_ctrl_27 [7:0] ;		// readType = read   writeType =write
	end
	7'h3c : begin
		rdata_comb [7:0]	= r_aib_csr7_aib_csr7_ctrl_28 [7:0] ;		// readType = read   writeType =write
		rdata_comb [15:8]	= r_aib_csr7_aib_csr7_ctrl_29 [7:0] ;		// readType = read   writeType =write
		rdata_comb [23:16]	= r_aib_csr7_aib_csr7_ctrl_30 [7:0] ;		// readType = read   writeType =write
		rdata_comb [31:24]	= r_aib_csr7_aib_csr7_ctrl_31 [7:0] ;		// readType = read   writeType =write
	end
	7'h40 : begin
		rdata_comb [7:0]	= r_aib_csr8_aib_csr8_ctrl_32 [7:0] ;		// readType = read   writeType =write
		rdata_comb [15:8]	= r_aib_csr8_aib_csr8_ctrl_33 [7:0] ;		// readType = read   writeType =write
		rdata_comb [23:16]	= r_aib_csr8_aib_csr8_ctrl_34 [7:0] ;		// readType = read   writeType =write
		rdata_comb [31:24]	= r_aib_csr8_aib_csr8_ctrl_35 [7:0] ;		// readType = read   writeType =write
	end
	7'h44 : begin
		rdata_comb [7:0]	= r_aib_csr9_aib_csr9_ctrl_36 [7:0] ;		// readType = read   writeType =write
		rdata_comb [15:8]	= r_aib_csr9_aib_csr9_ctrl_37 [7:0] ;		// readType = read   writeType =write
		rdata_comb [23:16]	= r_aib_csr9_aib_csr9_ctrl_38 [7:0] ;		// readType = read   writeType =write
		rdata_comb [31:24]	= r_aib_csr9_aib_csr9_ctrl_39 [7:0] ;		// readType = read   writeType =write
	end
	7'h48 : begin
		rdata_comb [31:0]	= r_aib_csr10_aib_csr10_ctrl_4x [31:0] ;		// readType = read   writeType =write
	end
	7'h4c : begin
		rdata_comb [31:0]	= r_aib_csr11_aib_csr11_ctrl_4x [31:0] ;		// readType = read   writeType =write
	end
	7'h50 : begin
		rdata_comb [31:0]	= r_aib_csr12_aib_csr12_ctrl_4x [31:0] ;		// readType = read   writeType =write
	end
	7'h54 : begin
		rdata_comb [15:0]	= r_aib_csr13_aib_csr13_ctrl_5x [15:0] ;		// readType = read   writeType =write
	end
	default : begin
		rdata_comb = 32'h00000000;
	end
      endcase
   end
end

endmodule
