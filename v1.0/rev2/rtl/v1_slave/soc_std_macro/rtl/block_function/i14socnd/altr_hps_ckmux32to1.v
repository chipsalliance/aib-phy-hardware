// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//****************************************************************************************
// Copyright (C) 2011 Altera Corporation. 
//
//****************************************************************************************

//------------------------------------------------------------------------
// Description: standard 4:1 clock mux, built of three 2:1 muxes
//              clk_sel = 00, clk_o = clk_0 
//              clk_sel = 01, clk_o = clk_1 
//              clk_sel = 10, clk_o = clk_2 
//              clk_sel = 11, clk_o = clk_3 
//------------------------------------------------------------------------

module altr_hps_ckmux32to1
    (
    input  wire [31:0]       clk_i, 

    input  wire  [4:0]       clk_sel,   // clock selector
    output wire              clk_o      // clock out
     );


`ifdef ALTR_HPS_INTEL_MACROS_OFF

  reg clk_o_reg;

  always @*
  begin : clk_sel_mux
    case(clk_sel[4:0])
      5'b00000: clk_o_reg = clk_i[0];
      5'b00001: clk_o_reg = clk_i[1];
      5'b00010: clk_o_reg = clk_i[2];
      5'b00011: clk_o_reg = clk_i[3];
      5'b00100: clk_o_reg = clk_i[4];
      5'b00101: clk_o_reg = clk_i[5];
      5'b00110: clk_o_reg = clk_i[6];
      5'b00111: clk_o_reg = clk_i[7];
      5'b01000: clk_o_reg = clk_i[8];
      5'b01001: clk_o_reg = clk_i[9];
      5'b01010: clk_o_reg = clk_i[10];
      5'b01011: clk_o_reg = clk_i[11];
      5'b01100: clk_o_reg = clk_i[12];
      5'b01101: clk_o_reg = clk_i[13];
      5'b01110: clk_o_reg = clk_i[14];
      5'b01111: clk_o_reg = clk_i[15];
      5'b10000: clk_o_reg = clk_i[16];
      5'b10001: clk_o_reg = clk_i[17];
      5'b10010: clk_o_reg = clk_i[18];
      5'b10011: clk_o_reg = clk_i[19];
      5'b10100: clk_o_reg = clk_i[20];
      5'b10101: clk_o_reg = clk_i[21];
      5'b10110: clk_o_reg = clk_i[22];
      5'b10111: clk_o_reg = clk_i[23];
      5'b11000: clk_o_reg = clk_i[24];
      5'b11001: clk_o_reg = clk_i[25];
      5'b11010: clk_o_reg = clk_i[26];
      5'b11011: clk_o_reg = clk_i[27];
      5'b11100: clk_o_reg = clk_i[28];
      5'b11101: clk_o_reg = clk_i[29];
      5'b11110: clk_o_reg = clk_i[30];
      5'b11111: clk_o_reg = clk_i[31];
      default: clk_o_reg = 1'bx;
    endcase
  end

  assign clk_o = clk_o_reg;

`else

`endif

endmodule // altr_hps_ckmux32to1
