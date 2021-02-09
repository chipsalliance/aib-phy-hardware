// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3aibadapt_cmn_clkand2
(
        output  wire    Z,
        input   wire    A1,
        input   wire    A2
);

	assign Z = A1 & A2;

endmodule // c3adapt_cmn_clkand2
