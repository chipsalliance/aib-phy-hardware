// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation.
/////////////////////////////////////////////////////////////////////////////////////////
//--------------------------------------------------------------------------------------
// Description: Channel Configuration Decoding
//
//
// Change log
// 1/26/2021
/////////////////////////////////////////////////////////////////////////////////////////

module aib_avmm (
  input [5:0]   cfg_avmm_addr_id, 
  input         cfg_avmm_clk,
  input         cfg_avmm_rst_n,
  input         cfg_avmm_write,
  input         cfg_avmm_read,
  input [16:0]  cfg_avmm_addr,
  input [31:0]  cfg_avmm_wdata,
  input [3:0]   cfg_avmm_byte_en,
  output [31:0] cfg_avmm_rdata,
  output        cfg_avmm_rdatavld,
  output        cfg_avmm_waitreq,

//Adapt control CSR
  output [31:0] rx_adapt_0,
  output [31:0] rx_adapt_1,
  output [31:0] tx_adapt_0,
  output [31:0] tx_adapt_1,

//AIB IO control CSR
  output [31:0] redund_0,
  output [31:0] redund_1,
  output [31:0] redund_2,
  output [31:0] redund_3  
);

wire cfg_csr_clk, cfg_csr_reset;
wire cfg_csr_read,cfg_csr_write;
wire cfg_csr_rdatavld;
wire [31:0] cfg_csr_wdata, cfg_csr_rdata;
wire [6:0]  cfg_csr_addr;
wire [3:0]  cfg_csr_byteen; 
wire cfg_adapt_addr_match, cfg_io_addr_match;
wire cfg_adapt_rdatavld, cfg_io_rdatavld;
wire [31:0] cfg_adapt_rdata, cfg_io_rdata;

localparam AIB_BASE_BOT = 11'h200;
localparam AIB_BASE_MID = 11'h300;
localparam AIB_BASE_TOP = 11'h400;

// Configuration registers for Adapter and AIBIO
assign cfg_only_id_match = (cfg_avmm_addr_id[5:0] == cfg_avmm_addr[16:11]);

assign cfg_only_addr_match  = (cfg_avmm_addr[10:0] >= AIB_BASE_BOT) & (cfg_avmm_addr[10:0] < AIB_BASE_TOP) & cfg_only_id_match;
assign cfg_adapt_addr_match = (cfg_avmm_addr[10:0] >= AIB_BASE_BOT) & (cfg_avmm_addr[10:0] < AIB_BASE_MID); 
assign cfg_io_addr_match    = (cfg_avmm_addr[10:0] >= AIB_BASE_MID) & (cfg_avmm_addr[10:0] < AIB_BASE_TOP); 
assign cfg_only_write       = cfg_only_addr_match & cfg_avmm_write;
assign cfg_only_read        = cfg_only_addr_match & cfg_avmm_read;
assign cfg_csr_rdatavld     = cfg_adapt_rdatavld | cfg_io_rdatavld;
assign cfg_csr_rdata        = cfg_adapt_rdata | cfg_io_rdata;

aib_avmm_rdl_intf #( .AVMM_ADDR_WIDTH(8), .RDL_ADDR_WIDTH (7))
  adapt_cfg_rdl_intf (
   .avmm_clk            (cfg_avmm_clk),        // input   logic  // AVMM Slave interface
   .avmm_rst_n          (cfg_avmm_rst_n),      // input   logic
   .i_avmm_write        (cfg_only_write),      // input   logic
   .i_avmm_read         (cfg_only_read),       // input   logic
   .i_avmm_addr         (cfg_avmm_addr[7:0]),  // input   logic  [AVMM_ADDR_WIDTH-1:0]
   .i_avmm_wdata        (cfg_avmm_wdata),      // input   logic  [31:0]
   .i_avmm_byte_en      (cfg_avmm_byte_en),    // input   logic  [3:0]
   .o_avmm_rdata        (cfg_avmm_rdata),      // output  logic  [31:0]
   .o_avmm_rdatavalid   (cfg_avmm_rdatavld),   // output  logic
   .o_avmm_waitrequest  (cfg_avmm_waitreq),    // output  logic
   .clk                 (cfg_csr_clk),         // output  logic  // RDL-generated memory map interface
   .reset               (cfg_csr_reset),       // output  logic
   .writedata           (cfg_csr_wdata),       // output  logic  [31:0]
   .read                (cfg_csr_read),        // output  logic
   .write               (cfg_csr_write),       // output  logic
   .byteenable          (cfg_csr_byteen),      // output  logic  [3:0]
   .readdata            (cfg_csr_rdata),       // input   logic  [31:0]
   .readdatavalid       (cfg_csr_rdatavld),    // input   logic
   .address             (cfg_csr_addr)         // output  logic  [RDL_ADDR_WIDTH-1:0]
);


aib_avmm_adapt_csr adapt_csr (
       .rx_0(rx_adapt_0),
       .rx_1(rx_adapt_1),
       .tx_0(tx_adapt_0),
       .tx_1(tx_adapt_1),

       .clk(cfg_csr_clk),
       .reset(cfg_csr_reset),
       .writedata(cfg_csr_wdata),
       .read((cfg_csr_read & cfg_adapt_addr_match)),
       .write((cfg_csr_write &cfg_adapt_addr_match)),
       .byteenable(cfg_csr_byteen),
       .readdata(cfg_adapt_rdata),
       .readdatavalid(cfg_adapt_rdatavld),
       .address(cfg_csr_addr)

);


aib_avmm_io_csr io_csr (
       .redund_0(redund_0),
       .redund_1(redund_1),
       .redund_2(redund_2),
       .redund_3(redund_3),

       .clk(cfg_csr_clk),
       .reset(cfg_csr_reset),
       .writedata(cfg_csr_wdata),
       .read((cfg_csr_read & cfg_io_addr_match)),
       .write((cfg_csr_write & cfg_io_addr_match)),
       .byteenable(cfg_csr_byteen),
       .readdata(cfg_io_rdata),
       .readdatavalid(cfg_io_rdatavld),
       .address(cfg_csr_addr)

);


endmodule
