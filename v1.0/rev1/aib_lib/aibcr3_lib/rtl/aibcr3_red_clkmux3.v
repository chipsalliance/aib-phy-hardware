// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr_lib, Cell - aibcr_red_clkmux3, View - schematic
// LAST TIME SAVED: May 14 14:12:18 2015
// NETLIST TIME: May 14 14:42:24 2015

module aibcr3_red_clkmux3 ( muxout, in0, in1, in2, sel0, sel1, sel2,
     vcc, vssl );

output  muxout;

input  in0, in1, in2, sel0, sel1, sel2, vcc, vssl;

reg muxout;

always @ ( sel0 or sel1 or sel2 or in0 or in1 or in2 )
	case ( {sel2,sel1,sel0} )
		3'b001 : muxout = in0 ;
		3'b010 : muxout = in1 ;
		3'b100 : muxout = in2 ;
		default : muxout = 1'bx ;
	endcase
endmodule


// End HDL models

