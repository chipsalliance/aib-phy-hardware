/// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//-----------------------------------------------------------------------------
// Copyright © 2015 Altera Corporation.  
//-----------------------------------------------------------------------------

module c3aibadapt_avmm_decode (
   input  logic             avmm_clk                      , // Avalon-MM Master Interface
   input  logic             avmm_rst_n                    , // Avalon-MM Master Interface
   input  logic             i_avmm_write                  , // Avalon-MM Master Interface
   input  logic             i_avmm_read                   , // Avalon-MM Master Interface
   input  logic  [ 16:0]    i_avmm_addr                   , // Avalon-MM Master Interface
   input  logic  [31:0]     i_avmm_wdata                  , // Avalon-MM Master Interface
   input  logic  [3:0]      i_avmm_byte_en                , // Avalon-MM Master Interface
   output logic  [31:0]     o_avmm_rdata                  , // Avalon-MM Master Interface
   output logic             o_avmm_rdatavalid             , // Avalon-MM Master Interface
   output logic             o_avmm_waitrequest            , // Avalon-MM Master Interface
   input logic              i_arb_sel_user_avmm           ,

   output logic             o_pma_avmm_write              , // 
   output logic             o_pma_avmm_read               , // 
   output logic  [6:0]      o_pma_avmm_addr               , // 
   output logic  [31:0]     o_pma_avmm_wdata              , // 
   output logic  [3:0]      o_pma_avmm_byte_en            , //
   input  logic  [31:0]     i_pma_avmm_rdata              , // 
   input  logic             i_pma_avmm_rdatavalid         , // 
   input  logic             i_pma_avmm_waitrequest        , // 

   output logic             o_ehiplane_avmm_write         , // 
   output logic             o_ehiplane_avmm_read          , // 
   output logic  [14:0]     o_ehiplane_avmm_addr          , // 
   output logic  [31:0]     o_ehiplane_avmm_wdata         , // 
   output logic  [3:0]      o_ehiplane_avmm_byte_en       , // 
   input  logic  [31:0]     i_ehiplane_avmm_rdata         , // 
   input  logic             i_ehiplane_avmm_rdatavalid    , // 
   input  logic             i_ehiplane_avmm_waitrequest   , // 

   output logic             o_aib_avmm_write              , // 
   output logic             o_aib_avmm_read               , // 
   output logic  [5:0]      o_aib_avmm_addr               , // 
   output logic  [31:0]     o_aib_avmm_wdata              , // 
   output logic  [3:0]      o_aib_avmm_byte_en            , // 
   input  logic  [31:0]     i_aib_avmm_rdata              , // 
   input  logic             i_aib_avmm_rdatavalid         , // 
   input  logic             i_aib_avmm_waitrequest        , // 
   output logic [13:0]      o_avmm_decode_tb_direct         // 
);

localparam SM_IDLE                = 3'h0;
localparam SM_WRITE               = 3'h1;
localparam SM_WRITE_DONE          = 3'h2;
localparam SM_READ                = 3'h3;
localparam SM_WAIT_4_SLV_RDVAL    = 3'h4;
localparam SM_RELEASE_MST_WAITREQ = 3'h5;
localparam SM_SET_MST_RDVAL       = 3'h6;

localparam  USR_ADDR_DW           = 19-2;
localparam  PMA_ADDR_DW           =  9-2;
localparam  EHP_ADDR_DW           = 17-2;
localparam  AIB_ADDR_DW           =  9-2;

localparam BASE_ADDR_DW_XCVR      = 32'h000;
localparam BASE_ADDR_DW_BASE      = 32'h080;
localparam BASE_ADDR_DW_CAIB      = 32'h084;
localparam BASE_ADDR_DW_NAIB      = 32'h0C0;
localparam BASE_ADDR_DW_EHIP      = 32'h100;

logic [2:0]   sm_avmmc;
logic [2:0]   sm_avmmp;

// Address Hits
logic         hit_aib;
logic         hit_ehiplane;
logic         hit_xcvr_intf;
logic         hit_nd;
logic [31:0]  rddata_fmt;
logic [31:0]  rddata;
logic         avmm_waitrequest;
logic         avmm_rdatavalid;

assign o_avmm_decode_tb_direct  ={hit_nd,hit_aib,i_avmm_addr[6:0],hit_xcvr_intf,hit_ehiplane,sm_avmmp[2:0]};

// Avalon-MM Slaves command

assign  o_aib_avmm_write        = ((hit_aib==1'b1)&&(sm_avmmp==SM_WRITE)) ? 1'b1 : 1'b0;
assign  o_aib_avmm_read         = ((hit_aib==1'b1)&&(sm_avmmp==SM_READ )) ? 1'b1 : 1'b0;
assign  o_aib_avmm_addr         = i_avmm_addr [5:0]   ;
assign  o_aib_avmm_wdata        = i_avmm_wdata   [31:0] ;
assign  o_aib_avmm_byte_en      = i_avmm_byte_en [3:0]  ;

assign  o_ehiplane_avmm_write   = ((hit_ehiplane==1'b1)&&(sm_avmmp==SM_WRITE)) ? 1'b1 : 1'b0;
assign  o_ehiplane_avmm_read    = ((hit_ehiplane==1'b1)&&(sm_avmmp==SM_READ))  ? 1'b1 : 1'b0;
assign  o_ehiplane_avmm_addr    = (i_arb_sel_user_avmm==1'b0)?15'(i_avmm_addr[14:0] - 15'h100):
                                                   {1'b0, i_avmm_addr[16:9], i_avmm_addr[5:0]};
assign  o_ehiplane_avmm_wdata   = i_avmm_wdata   [31:0] ;
assign  o_ehiplane_avmm_byte_en = i_avmm_byte_en [3:0]  ;

assign  o_pma_avmm_write        = ((hit_xcvr_intf==1'b1)&&(sm_avmmp==SM_WRITE))? 1'b1 : 1'b0;
assign  o_pma_avmm_read         = ((hit_xcvr_intf==1'b1)&&(sm_avmmp==SM_READ)) ? 1'b1 : 1'b0;
assign  o_pma_avmm_addr         = i_avmm_addr    [6:0];
assign  o_pma_avmm_wdata        = i_avmm_wdata   [31:0] ;
assign  o_pma_avmm_byte_en      = i_avmm_byte_en [3:0]  ;

// Avalon-MM Master responses
assign o_avmm_waitrequest       = avmm_waitrequest;//((sm_avmmp==SM_WRITE_DONE)||(sm_avmmp==SM_RELEASE_MST_WAITREQ )) ? 1'b0 : 1'b1;
assign o_avmm_rdatavalid        = avmm_rdatavalid ;//(sm_avmmp==SM_SET_MST_RDVAL    )                                 ? 1'b1 : 1'b0;
assign o_avmm_rdata[31:0]       = rddata_fmt[31:0];

always @(posedge avmm_clk or negedge avmm_rst_n) begin :  p_smreg
   if (avmm_rst_n==1'b0) begin
      sm_avmmp         <= SM_IDLE;
      hit_aib          <= 1'b0; // CR3.AIB
      hit_ehiplane     <= 1'b0; // EHIPLANE
      hit_xcvr_intf    <= 1'b0; // XCVR_INTF
      hit_nd           <= 1'b0; // MAIB
      rddata[31:0]     <= 32'h0;
      rddata_fmt[31:0] <= 32'h0;
      avmm_waitrequest <= 1'b1;
      avmm_rdatavalid  <= 1'b0;
   end
   else begin
      sm_avmmp <= sm_avmmc;
      if (sm_avmmp==SM_IDLE) begin
         if (i_avmm_addr[USR_ADDR_DW-1:0]<BASE_ADDR_DW_BASE[USR_ADDR_DW-1:0]) begin
            {hit_nd,hit_aib,hit_xcvr_intf,hit_ehiplane} <= 4'b0010; // PMA
         end
         else if (i_avmm_addr[USR_ADDR_DW-1:0]<BASE_ADDR_DW_NAIB[USR_ADDR_DW-1:0]) begin
            {hit_nd,hit_aib,hit_xcvr_intf,hit_ehiplane} <= 4'b0100; // CAIB
         end
         else if ((i_avmm_addr[USR_ADDR_DW-1:0]<BASE_ADDR_DW_EHIP[USR_ADDR_DW-1:0])
                   &&  (i_arb_sel_user_avmm==1'b0))        begin
            {hit_nd,hit_aib,hit_xcvr_intf,hit_ehiplane} <= 4'b1000; // NAIB when USR_CLK, CONFIG-ONLY When CONFIG_CLK
         end
         else if ((i_avmm_addr[7:6]==2'b11)&&(i_arb_sel_user_avmm==1'b1)) begin
            {hit_nd,hit_aib,hit_xcvr_intf,hit_ehiplane} <= 4'b1000; // NAIB when USR_CLK, CONFIG-ONLY When CONFIG_CLK
         end
         else begin
            {hit_nd,hit_aib,hit_xcvr_intf,hit_ehiplane} <= 4'b0001; // EHIP
         end
      end

      avmm_rdatavalid  <= (sm_avmmc==SM_SET_MST_RDVAL)? 1'b1 : 1'b0;

      rddata_fmt[31:0] <= (sm_avmmc==SM_SET_MST_RDVAL)? rddata[31:0] : 32'h0;

      rddata[31:0]     <= ((hit_aib       ==1'b1)&&(i_aib_avmm_rdatavalid     ==1'b1)) ? i_aib_avmm_rdata     [31:0]:
                          ((hit_ehiplane  ==1'b1)&&(i_ehiplane_avmm_rdatavalid==1'b1)) ? i_ehiplane_avmm_rdata[31:0]:
                          ((hit_xcvr_intf ==1'b1)&&(i_pma_avmm_rdatavalid     ==1'b1)) ? i_pma_avmm_rdata     [31:0]:rddata[31:0];

      avmm_waitrequest <= ((sm_avmmc==SM_WRITE_DONE)||(sm_avmmc==SM_RELEASE_MST_WAITREQ )) ? 1'b0 : 1'b1;

   end
end : p_smreg

always @(*) begin :  p_sm
      case (sm_avmmp)
         SM_IDLE                : sm_avmmc = (i_avmm_write==1'b1) ? SM_WRITE:
                                             (i_avmm_read ==1'b1) ? SM_READ :
                                                                    SM_IDLE ;
         // Write States : SM_WRITE, SM_WRITE_DONE
         SM_WRITE               : sm_avmmc =  (hit_nd         ==1'b1)                                       ? SM_WRITE_DONE:
                                              ((hit_aib       ==1'b1)&&(i_aib_avmm_waitrequest     ==1'b0)) ? SM_WRITE_DONE:
                                              ((hit_ehiplane  ==1'b1)&&(i_ehiplane_avmm_waitrequest==1'b0)) ? SM_WRITE_DONE:
                                              ((hit_xcvr_intf ==1'b1)&&(i_pma_avmm_waitrequest     ==1'b0)) ? SM_WRITE_DONE:
                                                                                                              SM_WRITE     ;
         SM_WRITE_DONE          : sm_avmmc = SM_IDLE;

         // Read States : SM_READ, SM_WAIT_4_SLV_RDVAL,
         //               SM_RELEASE_MST_WAITREQ, SM_SET_MST_RDVAL
         SM_READ                : sm_avmmc = (hit_nd==1'b1)                                                ? SM_RELEASE_MST_WAITREQ:
                                             ((hit_aib       ==1'b1)&&(i_aib_avmm_waitrequest     ==1'b0)) ? SM_WAIT_4_SLV_RDVAL:
                                             ((hit_ehiplane  ==1'b1)&&(i_ehiplane_avmm_waitrequest==1'b0)) ? SM_WAIT_4_SLV_RDVAL:
                                             ((hit_xcvr_intf ==1'b1)&&(i_pma_avmm_waitrequest     ==1'b0)) ? SM_WAIT_4_SLV_RDVAL:
                                                                                                             SM_READ            ;
         SM_WAIT_4_SLV_RDVAL    : sm_avmmc = ((hit_aib       ==1'b1)&&(i_aib_avmm_rdatavalid     ==1'b1)) ? SM_RELEASE_MST_WAITREQ:
                                             ((hit_ehiplane  ==1'b1)&&(i_ehiplane_avmm_rdatavalid==1'b1)) ? SM_RELEASE_MST_WAITREQ:
                                             ((hit_xcvr_intf ==1'b1)&&(i_pma_avmm_rdatavalid     ==1'b1)) ? SM_RELEASE_MST_WAITREQ:
                                                                                                            SM_WAIT_4_SLV_RDVAL ;
         SM_RELEASE_MST_WAITREQ : sm_avmmc = SM_SET_MST_RDVAL;
         SM_SET_MST_RDVAL       : sm_avmmc = SM_IDLE    ;

         default                 : sm_avmmc = SM_IDLE    ;
      endcase
end : p_sm


endmodule : c3aibadapt_avmm_decode
