// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.

module dmux_cell(
output o,  // Output
input  d1, // Data 1
input  d2, // Data 2
input  s   // Data selection
);

// mux
assign o = s ? d1 : d2;

endmodule // dmux_cell
