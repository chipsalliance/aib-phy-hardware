// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//------------------------------------------------------------------------
//
// Revision:    $Revision: #1 $
// Date:        $DateTime: 2014/09/20 12:06:43 $
//------------------------------------------------------------------------
// Description: gated 8 clock phases for powerdown and regulator power domain crossing
//
//------------------------------------------------------------------------

module io_min_pdn (
input          pdn,           		// power down active low
input    [7:0] phy_clk_phs,             // 8 phase 1.6GHz local clock
output   [7:0] phy_clk_phs_gated       // gated 8 phase 1.6GHz local clock
);

`ifdef TIMESCALE_EN
                timeunit 1ps;
                timeprecision 1ps;
`endif

parameter  INV_DELAY      = 15;  // 15ps

assign #(2 * INV_DELAY) phy_clk_phs_gated[3:0] = phy_clk_phs[3:0] & {4{pdn}};
assign #(2 * INV_DELAY) phy_clk_phs_gated[7:4] = phy_clk_phs[7:4] | {4{~pdn}};

endmodule


