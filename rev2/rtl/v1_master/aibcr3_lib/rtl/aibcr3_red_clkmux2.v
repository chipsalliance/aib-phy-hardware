// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr_lib, Cell - aibcr_red_clkmux2, View - schematic
// LAST TIME SAVED: May 14 14:31:29 2015
// NETLIST TIME: May 14 14:36:18 2015

module aibcr3_red_clkmux2 ( muxout, in0, in1, sel, vcc, vssl );

output  muxout;

input  in0, in1, sel, vcc, vssl;




assign muxout = sel ?  in1 : in0 ;


endmodule




