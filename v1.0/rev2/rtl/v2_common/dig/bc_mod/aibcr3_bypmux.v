// SPDX-License-Identifier: Apache-2.0
// Copyright (c) 2019 Blue Cheetah Analog Design, Inc.
// Copyright (C) 2019 Intel Corporation. 
//
// For more info, please visit www.bcanalog.com or contact info@bcanalog.com

module aibcr3_bypmux (
        input wire byp,
        input wire in0,
        input wire in1,
        output wire out
    );

`ifdef BEHAVIORAL
    assign out = (byp) ? in1 : in0;
`else
    data_mux_2_1 mx(.sel(byp), .in0(in0), .in1(in1), .out(out));
`endif

endmodule

module aibcr3_bypmux_x4 (
        input wire byp,
        input wire in0,
        input wire in1,
        output wire out
    );

`ifdef BEHAVIORAL
    assign out = (byp) ? in1 : in0;
`else
    data_mux_2_1 mx(.sel(byp), .in0(in0), .in1(in1), .out(out));
`endif

endmodule


