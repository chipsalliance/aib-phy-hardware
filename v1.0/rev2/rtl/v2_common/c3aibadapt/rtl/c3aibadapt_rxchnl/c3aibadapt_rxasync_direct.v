// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3aibadapt_rxasync_direct (
// PCS IF
input   wire            pld_8g_rxelecidle,
input   wire            pld_pma_rxpll_lock,
input   wire            hip_aib_async_out,
input   wire            r_rx_async_hip_en,
input   wire  [1:0]     r_rx_parity_sel,
input   wire            pld_pma_pfdmode_lock,
input   wire  [5:0]     sr_parity_error_flag,
input	wire		avmm_transfer_error,
input	wire		rx_direct_transfer_testbus,
input	wire		r_rx_usertest_sel,

// AIB_IF
output  wire            aib_hssi_pld_pma_pfdmode_lock,
output  wire            aib_hssi_pld_8g_rxelecidle,
output  wire            aib_hssi_pld_pma_rxpll_lock
);



assign aib_hssi_pld_8g_rxelecidle  = r_rx_async_hip_en ? hip_aib_async_out : r_rx_usertest_sel ? (r_rx_parity_sel == 2'b00 ? pld_8g_rxelecidle : (r_rx_parity_sel == 2'b01 ? |sr_parity_error_flag[2:0] : (r_rx_parity_sel == 2'b10 ? |sr_parity_error_flag[5:3] : avmm_transfer_error) ) ) : rx_direct_transfer_testbus;
assign aib_hssi_pld_pma_rxpll_lock = pld_pma_rxpll_lock;
assign aib_hssi_pld_pma_pfdmode_lock = pld_pma_pfdmode_lock;
endmodule
