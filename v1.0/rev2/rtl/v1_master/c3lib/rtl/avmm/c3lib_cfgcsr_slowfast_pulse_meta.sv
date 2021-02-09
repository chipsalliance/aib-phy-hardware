// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//-----------------------------------------------------------------------------
// Copyright (C) 2015 Altera Corporation. 
//-----------------------------------------------------------------------------
//  Date        :  01/4/2016
//-----------------------------------------------------------------------------
// Description:
//
// c3lib_cfgcsr_slowfast_pulse_meta  :
//        This module handle the cross domain clocking transfer of a pulse bit
//        from a slow clock to a fast clock
//
// Assume that i_usr_avmm_read or i_usr_avmm_write do not toggle while o_usr_avmm_waitrequest is set
// if CLOCKRATIO_GT2==1, ok with nyquist
//                           :
//  i_slowclk                : |          |        |       |        |
//                           :            _________
//  i_slowpulse              :____________|        |__________________
//                           :
//  i_fastclk                :|  |  |  |   |  |  |  |  |  |  |  |  |
//                           :              ___
//  o_fastpulse              :_____________|  |_____________________
//
// else
//  i_slowclk                : |          |        |       |        |
//                           :            _________
//  i_slowpulse              :____________|        |__________________
//                           :
//  i_fastclk                :|       |      |      |      |      |
//                           :              ___
//  o_fastpulse              :_____________|  |_____________________
//
// Notation
//       fast prefix refers to signal and register from the i_fastclk clock domain
//       slow prefix refers to signal and register from the i_slowclk clock domain
//-----------------------------------------------------------------------------
// When CLOCKRATIO_GT2==0
//-----------------------------------------------------------------------------
// Change log: copied over from ehip/config_csr
//
//
//
//
//-----------------------------------------------------------------------------

module c3lib_cfgcsr_slowfast_pulse_meta #(
      parameter TRIGGER_POSEDGE = 1,// When set, use active high signal for reset and pulse generation
      parameter CREATE_PULSE    = 1,// When set output is a single pulse, else basic cross domain crossing
      parameter SYNC_FF_DEPTH   = 2,// When set output is a single pulse, else basic cross domain crossing
      parameter COMB_SLOWPULSE  = 0,// When set do not register the slow pulse, assumed to come from an DFF in the i_slowclk/i_slowrstn domain
      parameter CLOCKRATIO_GT2  = 1
      )(
      input  wire i_slowclk      ,
      input  wire i_slowrstn     ,
      input  wire i_slowpulse    ,
      input  wire i_fastclk      ,
      input  wire i_fastrstn     ,
      output wire o_fastpulse    );

localparam DETECT_EDGE        =(TRIGGER_POSEDGE==1)?2'b01:2'b10;
localparam RST_SLOW           =(TRIGGER_POSEDGE==1)?1'b0:1'b1;
localparam FASTPULSE_ASSERT   =(TRIGGER_POSEDGE==1)?1'b1:1'b0;
localparam FASTPULSE_DEASSERT =(TRIGGER_POSEDGE==1)?1'b0:1'b1;

logic                     fastpulse_meta; // Meta DFF
logic [SYNC_FF_DEPTH-1:0] r_fastpulse;
logic                     w_slowpulse;

c3lib_bitsync # (
   .DWIDTH            (1             ),
   .RESET_VAL         ((TRIGGER_POSEDGE==1)?0:1),
   .DST_CLK_FREQ_MHZ  (500           ),
   .SRC_DATA_FREQ_MHZ (100           ))
   bitsync            (
   .clk               (i_fastclk     ),
   .rst_n             (i_fastrstn    ),
   .data_in           (w_slowpulse   ),
   .data_out          (fastpulse_meta));

generate
   if (SYNC_FF_DEPTH>1) begin : g_d
      always @(posedge i_fastclk  or negedge i_fastrstn) begin : p_fast_sample
         if (i_fastrstn==1'b0) begin
            r_fastpulse[SYNC_FF_DEPTH-1:0]  <= {SYNC_FF_DEPTH{RST_SLOW}};
         end
         else begin
            r_fastpulse[SYNC_FF_DEPTH-1:0] <= {r_fastpulse[SYNC_FF_DEPTH-2:0],fastpulse_meta};
         end
      end
   end
   else begin : g_s
      always @(posedge i_fastclk  or negedge i_fastrstn) begin : p_fast_sample
         if (i_fastrstn==1'b0) begin
            r_fastpulse[0]  <= {RST_SLOW};
         end
         else begin
            r_fastpulse[0] <= fastpulse_meta;
         end
      end
   end
endgenerate


generate
   if (CREATE_PULSE==1) begin :g_p
      assign o_fastpulse = (r_fastpulse[SYNC_FF_DEPTH-1:0] == DETECT_EDGE)?FASTPULSE_ASSERT:FASTPULSE_DEASSERT;
   end
   else begin : g_l
      assign o_fastpulse = r_fastpulse[SYNC_FF_DEPTH-1];
   end
endgenerate


generate
   if (COMB_SLOWPULSE==0) begin : g_spdff
      reg       r_slowpulse;
      always @(posedge i_slowclk  or negedge i_slowrstn) begin : p_slow_sample
         if (i_slowrstn==1'b0) begin
            r_slowpulse <= RST_SLOW;
         end
         else begin
            r_slowpulse <= i_slowpulse;
         end
      end : p_slow_sample
      assign w_slowpulse = r_slowpulse;
   end
   else begin : g_spwdff
      assign w_slowpulse = i_slowpulse;
   end
endgenerate


endmodule
