// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// *****************************************************************************
// *****************************************************************************
// Copyright © 2016 Altera Corporation.  
// *****************************************************************************
//  Module Name :  c3dfx_aibadaptwrap_tcb
//  Date        :  Tue May 19 2016
//  Description :  Aib Adapter Wrap Tcb
// *****************************************************************************

module c3dfx_aibadaptwrap_tcb
(
//c3dfx_aibadaptwrap interface
  input  logic i_tck,                                 // Jtag clock input - route to Tib
  input  logic i_scan_clk1,                           // Scan clock input - route to Tib
  input  logic i_scan_clk2,                           // Scan clock input - route to Tib
  input  logic i_scan_clk3,                           // Scan clock input - route to Tib
  input  logic i_scan_clk4,                           // Scan clock input - route to Tib
  input  logic i_test_clk_1g,                         // test ref clock input - route to Tib
  input  logic i_test_clk_500m,                       // test ref clock input - route to Tib
  input  logic i_test_clk_250m,                       // test ref clock input - route to Tib
  input  logic i_test_clk_125m,                       // test ref clock input - route to Tib
  input  logic i_test_clk_62m,                        // test ref clock input - route to Tib
  input  logic [`AIBADAPTWRAPTCB_JTAG_IN_RNG] i_tst_aibadaptwraptcb_jtag,                // Test controls - instance specific - tck domain - route to Tib
  input  logic [`AIBADAPTWRAPTCB_JTAG_COMMON_RNG] i_tst_aibadaptwraptcb_jtag_common,     // Test controls common - tck domain - route to Tib
  input  logic [`AIBADAPTWRAPTCB_STATIC_COMMON_RNG] i_tst_aibadaptwraptcb_static_common,  // Test controls common - static - route to Tib
  input  logic [`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG] i_tst_aibadaptwrap_scan_in,             //  scan input - scan_clk domain - route to Tib
  output logic [`AIBADAPTWRAPTCB_JTAG_OUT_RNG] o_tst_aibadaptwraptcb_jtag,                // Test controls outputs - tck domain - route to Tcb
  output logic [`AIBADAPTWRAPTCB_SCAN_CHAINS_RNG] o_tst_aibadaptwrap_scan_out,            // scan output - scan_clk domain - route to Tib
// Add inter block test signals below
  output logic [1:0]                o_dftcore2dll,
  input  logic [12:0]               i_dftdll2core,
  output logic [`TCM_WRAP_CTRL_RNG] o_avmm1_tst_tcm_ctrl,
  output logic                      o_avmm1_test_clk,
  output logic                      o_avmm1_scan_clk,
  output logic [`TCM_WRAP_CTRL_RNG] o_rxchnl_tst_tcm_ctrl,
  output logic                      o_rxchnl_test_clk,
  output logic                      o_rxchnl_scan_clk,
  output logic [`TCM_WRAP_CTRL_RNG] o_sr_0_tst_tcm_ctrl,
  output logic                      o_sr_0_test_clk,
  output logic                      o_sr_0_scan_clk,
  output logic [`TCM_WRAP_CTRL_RNG] o_sr_1_tst_tcm_ctrl,
  output logic                      o_sr_1_test_clk,
  output logic                      o_sr_1_scan_clk,
  output logic [`TCM_WRAP_CTRL_RNG] o_sr_2_tst_tcm_ctrl,
  output logic                      o_sr_2_test_clk,
  output logic                      o_sr_2_scan_clk,
  output logic [`TCM_WRAP_CTRL_RNG] o_sr_3_tst_tcm_ctrl,
  output logic                      o_sr_3_test_clk,
  output logic                      o_sr_3_scan_clk,
  output logic [`TCM_WRAP_CTRL_RNG] o_txchnl_0_tst_tcm_ctrl,
  output logic                      o_txchnl_0_test_clk,
  output logic                      o_txchnl_0_scan_clk,
  output logic [`TCM_WRAP_CTRL_RNG] o_txchnl_1_tst_tcm_ctrl,
  output logic                      o_txchnl_1_test_clk,
  output logic                      o_txchnl_1_scan_clk,
  output logic [`TCM_WRAP_CTRL_RNG] o_txchnl_2_tst_tcm_ctrl,
  output logic                      o_txchnl_2_test_clk,
  output logic                      o_txchnl_2_scan_clk,
  output logic                      o_scan_mode_n,
  output logic                      o_scan_rst_n,
  output logic                      o_scan_shift_n,
  output logic                      o_global_pipe_scanen,
  output logic                      o_atpg_scan_in0,
  output logic                      o_atpg_scan_in1,
  input  logic                      i_atpg_scan_out0,
  input  logic                      i_atpg_scan_out1,
  output logic                      o_atpg_scan_clk_in0,
  output logic                      o_atpg_scan_clk_in1,
  output logic                      o_atpg_bsr0_scan_in,
  output logic                      o_atpg_bsr0_scan_shift_clk,
  input  logic                      i_atpg_bsr0_scan_out,
  output logic                      o_atpg_bsr1_scan_in,
  output logic                      o_atpg_bsr1_scan_shift_clk,
  input  logic                      i_atpg_bsr1_scan_out,
  output logic                      o_atpg_bsr2_scan_in,
  output logic                      o_atpg_bsr2_scan_shift_clk,
  input  logic                      i_atpg_bsr2_scan_out,
  output logic                      o_atpg_bsr3_scan_in,
  output logic                      o_atpg_bsr3_scan_shift_clk,
  input  logic                      i_atpg_bsr3_scan_out,
  output logic                      o_atpg_bsr_scan_shift_n

);

logic scan_mode;
logic scan_enable;
logic scan_loes_mode;
logic scan_reset;

generate
genvar i;

for (i=0;i<11;i=i+1) begin
  c3lib_ckbuf_ctn uu_c3dfx_scan_out (.in('0),
                                     .out(o_tst_aibadaptwrap_scan_out[i])
                                    );
end
endgenerate

assign o_tst_aibadaptwraptcb_jtag[`AIBADAPTWRAPTCB_DFTDLL2CORE] =  i_dftdll2core;

assign o_dftcore2dll              = i_tst_aibadaptwraptcb_static_common[`AIBADAPTWRAPTCB_DFTCORE2DLL];

assign scan_mode = i_tst_aibadaptwraptcb_static_common[`SCAN_MODE_BIT];
assign scan_reset = i_tst_aibadaptwraptcb_static_common[`SCAN_RESET_BIT];

c3lib_ckbuf_ctn uu_c3dfx_scan_enable (.in(i_tst_aibadaptwraptcb_static_common[`SCAN_ENABLE_BIT]),
                                      .out(scan_enable)
                                     );

c3lib_ckbuf_ctn uu_c3dfx_scan_loes_mode (.in(i_tst_aibadaptwraptcb_static_common[`SCAN_LOES_MODE]),
                                         .out(scan_loes_mode)
                                        );

// for TCM that drive s_clk
assign o_rxchnl_tst_tcm_ctrl      = {scan_mode, scan_enable, i_tst_aibadaptwraptcb_static_common[`AIBADAPTWRAPTCBTCM_RX_TCM]};
assign o_rxchnl_test_clk          = i_test_clk_500m;
assign o_rxchnl_scan_clk          = i_scan_clk1;

assign o_txchnl_0_tst_tcm_ctrl    = {scan_mode, scan_enable, i_tst_aibadaptwraptcb_static_common[`AIBADAPTWRAPTCBTCM_TX0_TCM]};
assign o_txchnl_0_test_clk        = i_test_clk_500m;
assign o_txchnl_0_scan_clk        = i_scan_clk2;

assign o_txchnl_1_tst_tcm_ctrl    = {scan_mode, scan_enable, i_tst_aibadaptwraptcb_static_common[`AIBADAPTWRAPTCBTCM_TX1_TCM]};
assign o_txchnl_1_test_clk        = i_test_clk_1g;
assign o_txchnl_1_scan_clk        = i_scan_clk2;

assign o_txchnl_2_tst_tcm_ctrl    = {scan_mode, scan_enable, i_tst_aibadaptwraptcb_static_common[`AIBADAPTWRAPTCBTCM_TX2_TCM]};
assign o_txchnl_2_test_clk        = i_test_clk_500m;
assign o_txchnl_2_scan_clk        = i_scan_clk3;

assign o_sr_0_tst_tcm_ctrl        = {scan_mode, scan_enable, i_tst_aibadaptwraptcb_static_common[`AIBADAPTWRAPTCBTCM_SR0_TCM]};
assign o_sr_0_test_clk            = i_test_clk_1g;
assign o_sr_0_scan_clk            = i_scan_clk4;

assign o_sr_1_tst_tcm_ctrl        = {scan_mode, scan_enable, i_tst_aibadaptwraptcb_static_common[`AIBADAPTWRAPTCBTCM_SR1_TCM]};
assign o_sr_1_test_clk            = i_test_clk_1g;
assign o_sr_1_scan_clk            = i_scan_clk4;

assign o_sr_2_tst_tcm_ctrl        = {scan_mode, scan_enable, i_tst_aibadaptwraptcb_static_common[`AIBADAPTWRAPTCBTCM_SR2_TCM]};
assign o_sr_2_test_clk            = i_test_clk_500m;
assign o_sr_2_scan_clk            = i_scan_clk4;

assign o_sr_3_tst_tcm_ctrl        = {scan_mode, scan_enable, i_tst_aibadaptwraptcb_static_common[`AIBADAPTWRAPTCBTCM_SR3_TCM]};
assign o_sr_3_test_clk            = i_test_clk_250m;
assign o_sr_3_scan_clk            = i_scan_clk4;

assign o_avmm1_tst_tcm_ctrl       = {scan_mode, scan_enable, i_tst_aibadaptwraptcb_static_common[`AIBADAPTWRAPTCBTCM_AVMM1_TCM]};
assign o_avmm1_test_clk           = i_test_clk_125m;
assign o_avmm1_scan_clk           = i_scan_clk1;

assign o_scan_mode_n              = ~scan_mode;
assign o_scan_rst_n               = ~scan_reset;
assign o_scan_shift_n             = ~scan_enable;
assign o_atpg_bsr_scan_shift_n    = ~scan_enable;

assign o_global_pipe_scanen       = scan_loes_mode;

assign o_atpg_scan_clk_in0        = i_scan_clk4;
assign o_atpg_scan_clk_in1        = i_scan_clk4;
assign o_atpg_bsr0_scan_shift_clk = i_scan_clk4;
assign o_atpg_bsr1_scan_shift_clk = i_scan_clk4;
assign o_atpg_bsr2_scan_shift_clk = i_scan_clk4;
assign o_atpg_bsr3_scan_shift_clk = i_scan_clk4;

//scan chain
assign o_atpg_scan_in0            = i_tst_aibadaptwrap_scan_in[11];
assign o_atpg_scan_in1            = i_tst_aibadaptwrap_scan_in[12];
assign o_atpg_bsr0_scan_in        = i_tst_aibadaptwrap_scan_in[13];
assign o_atpg_bsr1_scan_in        = i_tst_aibadaptwrap_scan_in[14];
assign o_atpg_bsr2_scan_in        = i_tst_aibadaptwrap_scan_in[15];
assign o_atpg_bsr3_scan_in        = i_tst_aibadaptwrap_scan_in[16];

assign o_tst_aibadaptwrap_scan_out[11] = i_atpg_scan_out0;
assign o_tst_aibadaptwrap_scan_out[12] = i_atpg_scan_out1;
assign o_tst_aibadaptwrap_scan_out[13] = i_atpg_bsr0_scan_out;
assign o_tst_aibadaptwrap_scan_out[14] = i_atpg_bsr1_scan_out;
assign o_tst_aibadaptwrap_scan_out[15] = i_atpg_bsr2_scan_out;
assign o_tst_aibadaptwrap_scan_out[16] = i_atpg_bsr3_scan_out;

endmodule

