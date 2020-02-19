// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Blue Cheetah Analog Design, Inc.
// Copyright (C) 2019 Intel Corporation. 
//
module aibcr3_ddrmux (
        input wire clk,
        input wire in0,
        input wire in1,
        output wire out
    );

`ifdef BEHAVIORAL
    assign out = (clk) ? in1 : in0;
`else
    data_mux_2_1 mx(.sel(clk), .in0(in0), .in1(in1), .out(out));
`endif

endmodule
