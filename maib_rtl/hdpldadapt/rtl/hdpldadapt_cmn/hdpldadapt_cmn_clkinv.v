// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved
module hdpldadapt_cmn_clkinv
(
        output  wire    clkout,
        input   wire    clk
);

	assign clkout = ~clk;

endmodule // hdpldadapt_cmn_clkinv
