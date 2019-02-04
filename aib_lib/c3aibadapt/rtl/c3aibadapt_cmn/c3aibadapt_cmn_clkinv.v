// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved
module c3aibadapt_cmn_clkinv
(
        output  wire    ZN,
        input   wire    I
);

	assign ZN = ~I;

endmodule // c3aibadapt_cmn_clkinv
