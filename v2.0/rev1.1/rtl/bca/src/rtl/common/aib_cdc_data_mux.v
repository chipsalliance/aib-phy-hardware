// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.

module aib_cdc_data_mux #(
parameter DWIDTH = 'd80   // Data bus width
)
(
// Inputs
input  [DWIDTH-1:0] dmux_in0, // Data input for dmux_sel = 1
input  [DWIDTH-1:0] dmux_in1, // Data input for dmux_sel = 0
input               dmux_sel, // Data selection
// Outputs
output [DWIDTH-1:0] dmux_out // Data mux output
);

genvar i;
generate
  for(i = 0; i < DWIDTH; i = i + 1)
    begin: dmux_out_gen
      dmux_cell dmux_cell(
      .d1 (dmux_in0[i]),  // Data selected when selection = 1
      .d2 (dmux_in1[i]),  // Data selected when selection = 0
      .s  (dmux_sel),     // Data selection
      .o  ( dmux_out[i])  // MUX output data
      );
    end
endgenerate

endmodule // aib_cdc_data_mux
