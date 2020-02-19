// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// *****************************************************************************
// *****************************************************************************
// Copyright © 2016 Altera Corporation. 
// *****************************************************************************
//  Module Name :  c3dfx_tcm_wrap
//  Date        :  Tue May 11 2016
//  Description :  Test clock macro wrapper
// *****************************************************************************

module c3dfx_tcm_wrap 
# (
  parameter     SYNC_FUNC_CLKEN   = 1,          // Synchronize i_func_clken wih the i_func_clk
  parameter     RESET_VAL         = 0,          // Reset value is LOW if set to 0, otherwise HIGH
  parameter     CLK_DIV           = 0,          // i_func_clk divided by 2  if set to 2
                                                // divided by 4 if set to 4
                                                // divided by 8 if set to 8
  parameter     DST_CLK_FREQ_MHZ  = 500,        // Clock frequency for destination domain in MHz
  parameter     SRC_DATA_FREQ_MHZ = 100         // Average source data 'frequency' in MHz

) (
  input  logic i_func_clk,                           // Fucntional clock input
  input  logic i_func_clken,                         // Fucntional clock enable input
  input  logic i_rst_n,                              // Fucntional active low reset input
  input  logic i_test_clk,                           // Test clock input - route to Tcb
  input  logic i_scan_clk,                           // Scan clock input - route to Tcb
  input  logic [`TCM_WRAP_CTRL_RNG] i_tst_tcm_ctrl,  // Test controls input - route to Tcb
  output logic o_clk                                 // Output clock
);

  logic i_scan_mode;
  logic i_scan_enable;
  logic i_capture_enable;
  logic [3:0] i_tcm_mode;
  logic tdr_scan_capture_n ;
  logic flop_scan_capture ;
  logic func_clken ;
  logic func_clk ;

  assign {i_scan_mode, i_scan_enable,
          tdr_scan_capture_n, i_tcm_mode[3:0]} = i_tst_tcm_ctrl[`TCM_WRAP_CTRL_RNG];

`ifdef C3DFX_RTL_MODE
  always @(posedge i_scan_clk or negedge i_scan_mode)
    if(~i_scan_mode)
      flop_scan_capture <= 1'b0;
    else
      flop_scan_capture <= flop_scan_capture;
`else
//jprabhu will instantiate a flop here and make it keep reg
  always @(posedge i_scan_clk or negedge i_scan_mode)
    if(~i_scan_mode)
      flop_scan_capture <= 1'b0;
    else
      flop_scan_capture <= flop_scan_capture;
`endif

  assign i_capture_enable = flop_scan_capture | ~tdr_scan_capture_n;

// Synchronize the i_func_clken
  generate
    if (SYNC_FUNC_CLKEN == 0) begin : SKIP_SYNC
      assign func_clken = i_func_clken;
    end
    else begin : SYNC
      c3lib_bitsync #(.DWIDTH(1),
                      .RESET_VAL(RESET_VAL),
                      .DST_CLK_FREQ_MHZ(DST_CLK_FREQ_MHZ),
                      .SRC_DATA_FREQ_MHZ(SRC_DATA_FREQ_MHZ))
                     uu_c3dfx_tcm_sync (.clk(i_func_clk),
                                        .rst_n(i_rst_n),
                                        .data_in(i_func_clken),
                                        .data_out(func_clken));
    end
  endgenerate

  generate
    if (CLK_DIV == 2) begin : CLK_DIV_2
      c3lib_ckdiv2_ctn #(.RESET_VAL(RESET_VAL))
                        uu_c3dfx_tcm_div2 (.clk_in(i_func_clk),
                                           .rst_n(i_rst_n),
                                           .clk_out(func_clk));
    end
    else if (CLK_DIV == 4) begin : CLK_DIV_4
      c3lib_ckdiv4_ctn #(.RESET_VAL(RESET_VAL))
                        uu_c3dfx_tcm_div4 (.clk_in(i_func_clk),
                                           .rst_n(i_rst_n),
                                           .clk_out(func_clk));
    end
    else if (CLK_DIV == 8) begin : CLK_DIV_8
      c3lib_ckdiv8_ctn #(.RESET_VAL(RESET_VAL))
                        uu_c3dfx_tcm_div8 (.clk_in(i_func_clk),
                                           .rst_n(i_rst_n),
                                           .clk_out(func_clk));
    end
    else begin : NO_CLK_DIV
      assign func_clk = i_func_clk;
    end
  endgenerate

  c3dfx_tcm uu_c3dfx_tcm (.i_func_clken(func_clken),
                          .i_func_clk(func_clk),
                          .*);

endmodule

