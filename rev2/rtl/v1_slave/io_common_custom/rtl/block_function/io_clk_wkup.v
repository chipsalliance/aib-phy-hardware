// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
//
// Revision:    $Revision: #1 $
// Date:        $DateTime: 2014/11/15 16:17:29 $
//------------------------------------------------------------------------
// Description: smaller size dq/dqs driver
//
//------------------------------------------------------------------------

module io_clk_wkup (
input          enb,           		// 
output         drain_out                //
);

assign drain_out = enb ? 1'bz : 1'b1;

endmodule

