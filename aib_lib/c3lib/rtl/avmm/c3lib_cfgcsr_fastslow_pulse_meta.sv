// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved
//-----------------------------------------------------------------------------
// Copyright (C) 2015 Altera Corporation. All rights reserved.  Altera products are
// protected under numerous U.S. and foreign patents, maskwork rights, copyrights and
// other intellectual property laws.
//-----------------------------------------------------------------------------
//  Date        :  01/4/2016
//-----------------------------------------------------------------------------
// Description:
//
// c3lib_cfgcsr_fastslow_pulse_meta  :
//        This module handle the cross domain clocking transfer of a pulse bit
//        from a fast clock to a slow clock
//        operates on discrete transfer, not back to back request, input must de-assert
//        before the next pulse, next pulse occurs only after issuing o_slowpulse
//
// Assume that i_usr_avmm_read or i_usr_avmm_write do not toggle while o_usr_avmm_waitrequest is set
//  i_fastclk              : |  |  |  |  |  |  |  |  |  |  |  |  |  |
//                         :        ___
//  i_fastpulse            :_______|  |________________________________
//                         :
//  i_slowclk              :    |          |        |          |        |       |        |
//                         :                 _________
//  o_slowpulse            :________________|        |__________________
//                         :
//---------------------------------------------------------------------------
// Notation
//       fast prefix refers to signal and register from the i_fastclk clock domain
//       slow prefix refers to signal and register from the i_slowclk clock domain
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// Change log
// Copied over from ehip/config_csr 
//
//
//
//-----------------------------------------------------------------------------

module c3lib_cfgcsr_fastslow_pulse_meta #( parameter TRIGGER_POSEDGE=1, parameter NPULSE_EXT=3) (
      input  wire i_fastclk     ,
      input  wire i_fastrstn    ,
      input  wire i_fastpulse   ,
      input  wire i_slowclk     ,
      input  wire i_slowrstn    ,
      output wire o_slowpulse   );

localparam DETECT_EDGE        =(TRIGGER_POSEDGE==1)?2'b01:2'b10;
localparam RST_FAST           =(TRIGGER_POSEDGE==1)?1'b0:1'b1;
localparam SLOWPULSE_ASSERT   =(TRIGGER_POSEDGE==1)?1'b1:1'b0;
localparam SLOWPULSE_DEASSERT =(TRIGGER_POSEDGE==1)?1'b0:1'b1;

logic                  r_fastpulse;
logic [NPULSE_EXT-1:0] capture_edge_ext;
logic                  fastedge_extended;

logic                  slowedge_meta;       // Meta DFF synchronized
logic                  r_slowedge;
logic                  capture_edge ;


assign  capture_edge = ({r_fastpulse,i_fastpulse}==DETECT_EDGE)?1'b1:1'b0;

always @(posedge i_fastclk  or negedge i_fastrstn) begin : p_fast_sample
   if (i_fastrstn==1'b0) begin
      r_fastpulse  <= RST_FAST;
      capture_edge_ext <= {NPULSE_EXT{1'b0}};
      fastedge_extended  <= 1'b0;
   end
   else begin
      r_fastpulse       <= i_fastpulse;
      if (capture_edge==1'b1) begin
         capture_edge_ext[NPULSE_EXT-1:0]   <= {NPULSE_EXT{1'b1}};
      end
      else begin
         capture_edge_ext[NPULSE_EXT-1:0] <= {capture_edge_ext[NPULSE_EXT-2:0],1'b0};
      end
      fastedge_extended <= (capture_edge==1'b1)?1'b1: |capture_edge_ext[NPULSE_EXT-1:0];
   end
end : p_fast_sample

c3lib_bitsync # (
   .DWIDTH            (1                   ),
   .RESET_VAL         (0                   ),
   .DST_CLK_FREQ_MHZ  (100                 ),
   .SRC_DATA_FREQ_MHZ (500                 ))
   bitsync (
   .clk               (i_slowclk           ),
   .rst_n             (i_slowrstn          ),
   .data_in           (fastedge_extended   ),
   .data_out          (slowedge_meta      ));

always @(posedge i_slowclk  or negedge i_slowrstn) begin : p_cross_fast_slow
   if (i_slowrstn==1'b0) begin
      r_slowedge <= 1'b0;
   end
   else begin
      r_slowedge <= slowedge_meta;
   end
end : p_cross_fast_slow

assign o_slowpulse = ({r_slowedge,slowedge_meta} ==2'b01)?SLOWPULSE_ASSERT:SLOWPULSE_DEASSERT;



endmodule
