// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
//
// Revision:    $Revision: #4 $
// Date:        $DateTime: 2015/06/09 19:56:18 $
//------------------------------------------------------------------------
// Description: IO DLL PHASE DETECTOR
//
//------------------------------------------------------------------------


module io_dll_phdet (
   input  wire         i_del_p,            // phase detector input, from delay chain output
   input  wire         i_del_n,            // phase detector complementary input, from delay chain output
   input  wire         phase_clk,          // clock for phase detector
   input  wire         phase_clkb,         // complementary clock for phase detector
   input  wire         dll_reset_n,
   output wire         t_up,               // output of phase detector
   output wire         t_down              // output of phase detector
);

`ifdef TIMESCALE_EN
  timeunit 1ps;
  timeprecision 1ps;
`endif

/*
always @(posedge phase_clk or negedge dll_reset_n)
  if (~dll_reset_n)                         {t_up,t_down} <= #FF_DELAY 2'b00;
  else if ({i_del_p,i_del_n} == 2'b10)  {t_up,t_down} <= #FF_DELAY 2'b10;
  else if ({i_del_p,i_del_n} == 2'b01)  {t_up,t_down} <= #FF_DELAY 2'b01;
  else                                  {t_up,t_down} <= #FF_DELAY 2'b00;
*/

an_io_phdet_ff_ln xsampling_up (
      .dp(i_del_p),
      .dn(i_del_n),
      .clk_p(phase_clk),
      .rst_n(dll_reset_n),
      .q(t_up)
);

an_io_phdet_ff_ln xsampling_dn (
      .dp(phase_clkb),
      .dn(phase_clk),
      .clk_p(i_del_n),
      .rst_n(dll_reset_n),
      .q(t_down)
);

endmodule // io_dll_phdet
