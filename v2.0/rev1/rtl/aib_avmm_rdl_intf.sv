// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 

//-----------------------------------------------------------------------------
// Copyright (C) 2015 Altera Corporation. 
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// Description:
//            Standard Interface between a 32-bit Avalon-MM slave port to the
//            Memory Map interface of a RDL-generated Verilog
//            Produce Avalon-MM Waitrequest
//            Address with adaptation
//---------------------------------------------------------------------------
//
//
//-----------------------------------------------------------------------------
// Change log
//
//
//
//
//-----------------------------------------------------------------------------
module aib_avmm_rdl_intf #(
      parameter AVMM_ADDR_WIDTH=8,
      parameter RDL_ADDR_WIDTH =8
   ) (
   input   logic                         avmm_clk           , // AVMM Slave interface
   input   logic                         avmm_rst_n         ,
   input   logic                         i_avmm_write       ,
   input   logic                         i_avmm_read        ,
   input   logic  [AVMM_ADDR_WIDTH-1:0]  i_avmm_addr        ,
   input   logic  [31:0]                 i_avmm_wdata       ,
   input   logic  [3:0]                  i_avmm_byte_en     ,
   output  logic  [31:0]                 o_avmm_rdata       ,
   output  logic                         o_avmm_rdatavalid  ,
   output  logic                         o_avmm_waitrequest ,
   output  logic                         clk                , // RDL-generated memory map interface
   output  logic                         reset              ,
   output  logic  [31:0]                 writedata          ,
   output  logic                         read               ,
   output  logic                         write              ,
   output  logic  [3:0]                  byteenable         ,
   input   logic  [31:0]                 readdata           ,
   input   logic                         readdatavalid      ,
   output  logic  [RDL_ADDR_WIDTH-1:0]   address

);

localparam ZEROS                  = 256'h0;
localparam SM_IDLE                = 3'h0;
localparam SM_WRITE               = 3'h1;
localparam SM_READ                = 3'h2;
localparam SM_CPL                 = 3'h3;
localparam RDATA_OUT_OF_RANGE_ADDR= 32'h0;

logic [2:0] sm_base;
logic addr_out_of_range;
logic addr_out_of_range_r;

assign o_avmm_waitrequest = ((sm_base==SM_WRITE)||(sm_base==SM_READ))?1'b0:1'b1;
assign o_avmm_rdatavalid  = (sm_base==SM_CPL)?1'b1:1'b0;

always @(posedge avmm_clk or negedge avmm_rst_n) begin : p_avmm
   if (avmm_rst_n==1'b0) begin
      sm_base             <= SM_IDLE;
      addr_out_of_range_r <= 1'b0;
   end
   else begin
      if (o_avmm_waitrequest==1'b0) begin
         addr_out_of_range_r <= addr_out_of_range;
      end
      case(sm_base)
         SM_IDLE : sm_base <= (i_avmm_write==1'b1)  ? SM_WRITE:
                              (i_avmm_read == 1'b1) ? SM_READ :
                                                      SM_IDLE;
         SM_WRITE : sm_base <= SM_IDLE;
         SM_READ  : sm_base <= SM_CPL ;
         SM_CPL   : sm_base <= SM_IDLE;
         default  : sm_base <= SM_IDLE;
      endcase
   end
end : p_avmm

generate
   if (RDL_ADDR_WIDTH<AVMM_ADDR_WIDTH) begin : g_addr
      assign addr_out_of_range = (i_avmm_addr[AVMM_ADDR_WIDTH-1:RDL_ADDR_WIDTH]==ZEROS[AVMM_ADDR_WIDTH-1:RDL_ADDR_WIDTH] )?1'b0:1'b1;
   end
   else begin
      assign addr_out_of_range = 1'b0;
   end
endgenerate

assign o_avmm_rdata                = (addr_out_of_range_r==1'b0)?readdata[31:0]:RDATA_OUT_OF_RANGE_ADDR;
assign write                       = (addr_out_of_range==1'b0)?i_avmm_write  :1'b0;
assign writedata                   = i_avmm_wdata[31:0];
assign byteenable                  = i_avmm_byte_en[3:0];
assign address[RDL_ADDR_WIDTH-1:0] = i_avmm_addr[RDL_ADDR_WIDTH-1:0];
assign read                        = i_avmm_read;
assign clk                         = avmm_clk;
assign reset                       = ~avmm_rst_n;

endmodule 
