// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3aibadapt_cmn_clkmux2_cell
(
        output  wire    Z,
        input   wire    I0,
        input   wire    I1,
        input   wire    S
);

      assign Z = S ? I1 : I0;

endmodule // c3aibadapt_cmn_clkmux2_cell
