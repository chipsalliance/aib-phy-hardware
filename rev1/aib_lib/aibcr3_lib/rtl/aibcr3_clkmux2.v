// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr_lib, Cell - aibcr_clkmux2, View - schematic
// LAST TIME SAVED: Sep  7 23:41:23 2015
// NETLIST TIME: Oct  9 02:05:40 2015

module aibcr3_clkmux2 ( oclk_out, mux_sel, oclk_in0, oclk_in1, vcc, vssl
     );

output  oclk_out;

input  mux_sel, oclk_in0, oclk_in1, vcc, vssl;

 

assign oclk_out = mux_sel ?  oclk_in1 : oclk_in0 ;



endmodule
