// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module hdpldadapt_rx_async_direct (
// AIB IF
input   wire   aib_fabric_pld_8g_rxelecidle,
input   wire   aib_fabric_pld_pma_rxpll_lock,
input   wire   aib_fabric_pld_pma_pfdmode_lock,

// PLD IF
output   wire  pld_pma_pfdmode_lock,
output   wire  pld_8g_rxelecidle,
output   wire  pld_pma_rxpll_lock

);

assign pld_8g_rxelecidle  = aib_fabric_pld_8g_rxelecidle;
assign pld_pma_rxpll_lock = aib_fabric_pld_pma_rxpll_lock;
assign pld_pma_pfdmode_lock          = aib_fabric_pld_pma_pfdmode_lock;

endmodule
