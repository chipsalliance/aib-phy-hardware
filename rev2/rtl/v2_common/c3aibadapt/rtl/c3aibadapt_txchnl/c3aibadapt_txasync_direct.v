// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3aibadapt_txasync_direct (
// PCS IF
input	wire		pld_pma_fpll_lc_lock,

// AIB IF
input   wire            aib_hssi_pld_pma_txdetectrx,

// PCS IF
output	wire		pld_pma_txdetectrx,

// AIB IF
output  wire            aib_hssi_pld_pma_fpll_lc_lock

);


assign pld_pma_txdetectrx            = aib_hssi_pld_pma_txdetectrx;
assign aib_hssi_pld_pma_fpll_lc_lock = pld_pma_fpll_lc_lock;

endmodule
