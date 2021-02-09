// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr_lib, Cell - aibcr_triinv_dig, View - schematic
// LAST TIME SAVED: May 14 14:09:51 2015
// NETLIST TIME: May 14 14:36:18 2015

module aibcr3_triinv_dig ( out, en, enb, in, vcc, vssl );

output  out;

input  en, enb, in, vcc, vssl;


assign out = ((en == 1'b1) & (enb == 1'b0))? ~in : 1'bz; 


endmodule

