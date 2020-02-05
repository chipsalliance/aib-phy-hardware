// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Blue Cheetah Analog Design, Inc.
// Copyright (C) 2019 Intel Corporation. 
// *****************************************************************************
// Copyright (C) 2016 Altera Corporation. 
// *****************************************************************************
//  Module Name :  c3lib_ckmux4_lvt_gate
//  Date        :  Thu May 12 10:44:58 2016
//  Description :  4-to-1 clock mux w/ no scan support
// *****************************************************************************

// Ayar modifications: Added default_nettype none block to try to guard against
// net name typos, switched to using a hardened clock mux cell because there is
// a danger that synthesized cells may glitch
`default_nettype none
module  c3lib_ckmux4_lvt_gate(

  ck0,
  ck1,
  ck2,
  ck3,
  s0,
  s1,
  ck_out,

  // Scan IOs
  tst_override,
  tst_s0,
  tst_s1

);

    // Functional IOs
    input wire      ck0;
    input wire      ck1;
    input wire      ck2;
    input wire      ck3;
    input wire      s0;
    input wire      s1;
    output wire     ck_out;

    // Scan IOs
    input wire      tst_override;
    input wire      tst_s0;
    input wire      tst_s1;

    var    logic    int_fp_ck_out;
    var    logic    int_tst_ck_out;
    var    logic    int_ck_out;
`ifdef BEHAVIORAL

  always_comb begin
    unique case ( { s1, s0 } )
      2'b00   : int_fp_ck_out = ck0;
      2'b01   : int_fp_ck_out = ck1;
      2'b10   : int_fp_ck_out = ck2;
      2'b11   : int_fp_ck_out = ck3;
      default : int_fp_ck_out = 1'bx;
    endcase
  end

  always_comb begin
    unique case ( { tst_s1, tst_s0 } )
      2'b00   : int_tst_ck_out = ck0;
      2'b01   : int_tst_ck_out = ck1;
      2'b10   : int_tst_ck_out = ck2;
      2'b11   : int_tst_ck_out = ck3;
      default : int_tst_ck_out = 1'bx;
    endcase
  end

  always_comb begin
    unique case ( { tst_override } )
      1'b0    : int_ck_out = int_fp_ck_out;
      1'b1    : int_ck_out = int_tst_ck_out;
      default : int_ck_out = 1'bx;
    endcase
  end
`else
    // Intel process only has 2:1 clk mux, so construct from those
    wire ck_mux_mid_1, ck_mux_mid_2;
    clock_mux ck_mux_1 (.in0(ck0), .in1(ck1), .sel(s0), .out(ck_mux_mid_1));
    clock_mux ck_mux_2 (.in0(ck2), .in1(ck3), .sel(s0), .out(ck_mux_mid_2));
    clock_mux ck_mux_3 (.in0(ck_mux_mid_1), .in1(ck_mux_mid_2), .sel(s1), .out(int_fp_ck_out));

    wire ck_mux_tst_mid_1, ck_mux_tst_mid_2;
    clock_mux ck_mux_tst_1 (.in0(ck0), .in1(ck1), .sel(tst_s0), .out(ck_mux_tst_mid_1));
    clock_mux ck_mux_tst_2 (.in0(ck2), .in1(ck3), .sel(tst_s0), .out(ck_mux_tst_mid_2));
    clock_mux ck_mux_tst_3 (.in0(ck_mux_tst_mid_1), .in1(ck_mux_tst_mid_2), .sel(tst_s1), .out(int_tst_ck_out));

    clock_mux out_mux (.in0(int_fp_ck_out), .in1(int_tst_ck_out), .sel(tst_override), .out(int_ck_out));
`endif
  assign ck_out = int_ck_out;

endmodule
`default_nettype wire
