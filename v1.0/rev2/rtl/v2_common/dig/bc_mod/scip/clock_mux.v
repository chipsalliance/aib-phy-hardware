// SPDX-License-Identifier: Apache-2.0
// Copyright (c) 2019 Blue Cheetah Analog Design, Inc.

module clock_mux (
    input in0,
    input in1,
    input sel,
    output out
);

`ifdef BEHAVIORAL
assign out = sel ? in1 : in0;
`else
 //replace this section with user technology cell
 //for the purpose of cell hardening, synthesis don't touch
 $display("ERROR : %m : replace this section with user technology cell");
 $finish;
`endif

endmodule
