// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 

//-----------------------------------------------------------------------------
// Copyright © 2015 Altera Corporation.   
//-----------------------------------------------------------------------------
// Description:
//             Convert USR AVMM from byte Data[7:0] to dword Data[31:0], add byteeenable
//
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
module c3aibadapt_avmm_usr32_exp (
   input  logic         i_usr_avmm_clk           ,
   input  logic         i_usr_avmm_rst_n         ,
   input  logic         i_usr_avmm_read          ,
   input  logic         i_usr_avmm_write         ,
   input  logic  [7:0]  i_usr_avmm_wdata         ,
   input  logic  [18:0] i_usr_avmm_addr          ,
   output logic  [7:0]  o_usr_avmm_rdata         ,
   output logic         o_usr_avmm_readdatavalid ,
   output logic         o_usr_avmm_writedone     ,
   output logic         o_usr_avmm_waitrequest   ,

   output logic         o_usr_avmm32_write       ,
   output logic         o_usr_avmm32_read        ,
   output logic  [16:0] o_usr_avmm32_addr        ,
   output logic  [31:0] o_usr_avmm32_wdata       ,
   output logic  [3:0]  o_usr_avmm32_byte_en     ,
   input  logic  [31:0] i_usr_avmm32_rdata       ,
   input  logic         i_usr_avmm32_rdatavalid  ,
   input  logic         i_usr_avmm32_waitrequest
);

localparam  SM_IDLE = 1'h0;
localparam  SM_READ = 1'h1;
localparam  ZEROS   = 512'h0;
localparam  ADDR_W  =19;
logic       usr_wdone;
logic       sm_mrd;
logic [3:0] byte_en;
logic       usr_avmm_rst_sync;
logic       cmd, cmd_r;
logic       pending_cmd; // Assert during a command to completion cycle
                         // Qualifier to filter-out incorrect USER AVMM requests

assign o_usr_avmm_readdatavalid = (usr_avmm_rst_sync==1'b1) ? 1'b0: i_usr_avmm32_rdatavalid ;
assign o_usr_avmm_writedone     = usr_wdone;
assign o_usr_avmm_waitrequest   = 1'b0;
assign cmd                      = i_usr_avmm_read | i_usr_avmm_write;
assign o_usr_avmm_rdata   [7:0] = (byte_en[0]==1'b1) ? i_usr_avmm32_rdata[ 7: 0] :
                                  (byte_en[1]==1'b1) ? i_usr_avmm32_rdata[15: 8] :
                                  (byte_en[2]==1'b1) ? i_usr_avmm32_rdata[23:16] :
                                  (byte_en[3]==1'b1) ? i_usr_avmm32_rdata[31:24] : 8'h0 ;

// usr_wdone is only used by avmm1_transfer, which is driven on usr_avmm_clk
always @(posedge i_usr_avmm_clk or negedge i_usr_avmm_rst_n) begin :  w_done
   if (i_usr_avmm_rst_n==1'b0) begin
      usr_wdone <= 1'b0;
   end
   else begin
      usr_wdone <= o_usr_avmm32_write;
   end
end : w_done

always @(posedge i_usr_avmm_clk or negedge i_usr_avmm_rst_n) begin :  p_pipe
   if (!i_usr_avmm_rst_n) begin
      o_usr_avmm32_addr     <=  '0;
      o_usr_avmm32_wdata    <=  32'd0;
      o_usr_avmm32_byte_en  <=  4'h0;
      o_usr_avmm32_read     <=  1'b0;
      o_usr_avmm32_write    <=  1'b0;
      cmd_r                 <=  1'b0;
      pending_cmd           <=  1'b0;
      usr_avmm_rst_sync     <=  1'b1;
   end
   else begin
      usr_avmm_rst_sync    <=  1'b0;
      if (i_usr_avmm32_waitrequest==1'b0) begin
         cmd_r <= 1'b0;
      end
      else begin
         cmd_r <= cmd;
      end

      if (i_usr_avmm32_waitrequest==1'b0) begin
         pending_cmd <= 1'b0;
      end
      else if ((cmd_r == 1'b0 )&& (cmd==1'b1)) begin
         pending_cmd <= 1'b1;
      end

      if ((pending_cmd==1'b0)||(i_usr_avmm32_waitrequest==1'b0)) begin
         o_usr_avmm32_read     <=  i_usr_avmm_read;
         o_usr_avmm32_write    <=  ~i_usr_avmm_read & i_usr_avmm_write; // Filter-out write if read is asserted
         if (cmd==1'b1) begin
            o_usr_avmm32_addr [ADDR_W-3:0] <=  i_usr_avmm_addr[ADDR_W-1:2];
            o_usr_avmm32_byte_en           <=  (i_usr_avmm_addr[1:0]==2'b01) ? 4'b0010 :
                                               (i_usr_avmm_addr[1:0]==2'b10) ? 4'b0100 :
                                               (i_usr_avmm_addr[1:0]==2'b11) ? 4'b1000 : 4'b0001;
         end
         if (i_usr_avmm_write) begin
            o_usr_avmm32_wdata    <=  {i_usr_avmm_wdata[7:0],i_usr_avmm_wdata[7:0],i_usr_avmm_wdata[7:0],i_usr_avmm_wdata[7:0]};
         end
      end
  end
end : p_pipe

always @(posedge i_usr_avmm_clk or negedge i_usr_avmm_rst_n) begin :  p_be
   if (i_usr_avmm_rst_n==1'b0) begin
      byte_en  <= 4'h1;
      sm_mrd   <= SM_IDLE;
   end
   else begin
      case (sm_mrd)
         SM_IDLE : sm_mrd <= (i_usr_avmm_read==1'b1)        ?SM_READ:
                                                             SM_IDLE;
         SM_READ : sm_mrd <= (i_usr_avmm32_rdatavalid==1'b1)?SM_IDLE:
                                                             SM_READ;
         default : sm_mrd <= SM_IDLE;
      endcase

      if ((sm_mrd==SM_IDLE)||(i_usr_avmm32_rdatavalid==1'b1)) begin
         case (i_usr_avmm_addr[1:0])
            2'b00   : byte_en  <= 4'b0001;
            2'b01   : byte_en  <= 4'b0010;
            2'b10   : byte_en  <= 4'b0100;
            2'b11   : byte_en  <= 4'b1000;
            default : byte_en  <= 4'b0001;
         endcase
      end

   end
end : p_be




endmodule : c3aibadapt_avmm_usr32_exp
