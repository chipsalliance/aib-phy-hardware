// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//-----------------------------------------------------------------------------
// Copyright © 2015 Altera Corporation. 
//-----------------------------------------------------------------------------
//  Date        :  01/4/2016
//-----------------------------------------------------------------------------
// Description:
//
// c3lib_avmm_pulse_cross  :
//        This module handle the cross domain clocking transfer of a pulse bit
//        from a any clock rate to any clock rate , no phase nor frequency relation
//  Operates with any clock ratio :
//
//  o_next_i_pulse       : Assert when ready to send next Pulse
//                         Any i_pulse posedge sent when ~o_next_i_pulse
//                         is ignored
//
//  i_clk < o_clk -------:------------------------------------------------------------------
//                          _______       .~.._____         _______         _______
//  i_clk                :_|       |______.~..     |_______|       |_______|       |_______|
//                       :            ____.~..
//  i_pulse              :____________|   .~..______________________________________________
//                       : __    __    __ .~..  __    __    __    __    __    __    __    _
//  i_oclk               :|  |__|  |__|  |.~.. |  |__|  |__|  |__|  |__|  |__|  |__|  |__|
//                       :                .~..        _____
//  o_out_pulse          :________________.~.._______|     |___________________________________
//                       :_____________   .~..        ______________________________________
//  o_next_i_pulse       :            |___.~.._______|
//
//
//  i_clk > o_clk -------:------------------------------------------------------------------
//                        __    __    __ .~..  __    __    __    __    __    __    __    __
//  i_clk                |  |__|  |__|  |.~.. |  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |
//                       :          _____.~..
//  i_pulse              :_________|     .~..__________________________________________________
//                       :  _______      .~..______         _______         _______
//  i_oclk               :_|       |_____.~..      |_______|       |_______|       |_______|
//                       :               .~..               _______________
//  o_out_pulse          :_______________.~..______________|               |___________________
//                       :
//                       :_____________  .~..               ________________________________
//  o_next_i_pulse       :            |__.~..______________|
//
//--------------------------------------------------------------------------------------------
// Change log
//
//
//
//
//-----------------------------------------------------------------------------

module c3lib_avmm_pulse_cross (
      input  logic i_clk          ,
      input  logic i_rstn         ,
      input  logic i_pulse        ,
      input  logic i_oclk         ,
      input  logic i_early_pulse  , // When set return o_out_pulse prior to wit for round-trip
      input  logic i_orstn        ,
      output logic o_next_i_pulse ,
      output logic o_out_pulse      );

localparam ST_INIT=1'b0,
           ST_WAIT=1'b1;
logic       pulse_state;

logic l_in_pulse;
logic l_in_pulse_back;
logic l_in_pulse_back_norst;

logic l_out_pulse;
logic rl_out_pulse;
logic orstn_act_iclk, orstn_act;

assign l_in_pulse_back_norst = ((l_in_pulse_back==1'b1)||(orstn_act_iclk  == 1'b1))?1'b1:1'b0;

always @(posedge i_clk  or negedge i_rstn) begin : p_in_pulse
   if (i_rstn==1'b0) begin
      l_in_pulse     <= 1'b0;
      pulse_state    <= ST_INIT;
   end
   else begin
      case (pulse_state)
         ST_INIT : pulse_state <= ((l_in_pulse_back_norst==1'b0) &&
                                   (i_pulse    == 1'b1     )) ? ST_WAIT : ST_INIT;
         ST_WAIT : pulse_state <= (l_in_pulse_back_norst == 1'b1) ? ST_INIT : ST_WAIT;
         default : pulse_state <= ST_INIT;
      endcase

      if (l_in_pulse_back_norst==1'b1) begin
         l_in_pulse <= 1'b0;
      end
      else if (pulse_state==ST_INIT) begin
         if (i_pulse==1'b1) begin
            l_in_pulse <= 1'b1;
         end
      end
   end
end : p_in_pulse

assign o_next_i_pulse = ((pulse_state==ST_INIT) && (l_in_pulse_back_norst==1'b0)) ? 1'b1 : 1'b0;


c3lib_bitsync #(
   .DWIDTH            (1   ),
   .RESET_VAL         (1'b0),
   .DST_CLK_FREQ_MHZ  (500 ),
   .SRC_DATA_FREQ_MHZ (100 )
) bitsync_in        (
   .clk               (i_oclk       ) ,
   .rst_n             (i_orstn      ) ,
   .data_in           (l_in_pulse   ) ,
   .data_out          (l_out_pulse  ));

always @(posedge i_oclk  or negedge i_orstn) begin : p_out_pulse
// CDC Note orstn_act and  l_out_pulse are exclusive
// as orstn_act assert only on async reset i_orstn ans should be considered quasi-static
   if (i_orstn==1'b0) begin
      rl_out_pulse <= 1'b0;
      orstn_act    <= 1'b1;
   end
   else begin
      rl_out_pulse <= l_out_pulse;
      orstn_act   <= 1'b0;
   end
end : p_out_pulse


c3lib_bitsync #(
   .DWIDTH            (1   ),
   .RESET_VAL         (1'b0),
   .DST_CLK_FREQ_MHZ  (500 ),
   .SRC_DATA_FREQ_MHZ (100 )
) bitsync_out        (
   .clk               (i_clk           ) ,
   .rst_n             (i_rstn          ) ,
   .data_in           (l_out_pulse     ) ,
   .data_out          (l_in_pulse_back ));

c3lib_bitsync #(
   .DWIDTH            (1   ),
   .RESET_VAL         (1'b0),
   .DST_CLK_FREQ_MHZ  (500 ),
   .SRC_DATA_FREQ_MHZ (100 )
) bitsync_outrstn    (
   .clk               (i_clk         ) ,
   .rst_n             (i_rstn        ) ,
   .data_in           (orstn_act     ) ,
   .data_out          (orstn_act_iclk));

assign o_out_pulse = ((i_early_pulse==1'b0)&&(rl_out_pulse==1'b1) && (l_out_pulse==1'b0)) ? 1'b1:
                     ((i_early_pulse==1'b1)&&(rl_out_pulse==1'b0) && (l_out_pulse==1'b1)) ? 1'b1:1'b0;

//                                    __    __    __    __    __    __    __    __    __    __    __    __    __    __    __    _
//  i_clk                          : |  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|
//                                 :            ________
//  i_pulse        (i_clk)         :  _________|        |________________________________________________________________________
//                                 :              ________________________
//  l_in_pulse     (i_clk)         :  ___________|                        |______________________________________________________
//                                 :                                ________________________________
//  l_out_pulse    (o_clk)         :  ____________________BITSYNC__|                 BITSYNC        |____________________________
//                                 :                                      _______________________________
//  l_in_pulse_back(i_clk)         :  _______________________BITSYNC_____|                     BITSYNC   |_______________________
//                                 :    _______       ______         _______         _______         _______         _______
//  i_oclk                         :  _|       |_____|      |_______|       |_______|       |_______|       |_______|       |____
//                                 :                                  _______________
//  o_out_pulse    (o_clk) early=1 :  _______________________________|               |__________________________________________________
//              posedge l_out_pulse:
//                                 :                                                                  ______________
//  o_out_pulse    (o_clk) early=0 :  _______________________________________________________________|              |__________________
//             negedge l_out_pulse :
//
endmodule
