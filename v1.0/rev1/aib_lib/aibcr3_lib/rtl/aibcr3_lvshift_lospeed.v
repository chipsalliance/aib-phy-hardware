// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr3_lib, Cell - aibcr3_lvshift_lospeed, View - schematic
// LAST TIME SAVED: Oct  3 18:25:57 2014
// NETLIST TIME: Oct 28 12:42:28 2014

module aibcr3_lvshift_lospeed ( out, outb, vcc_input, vcc_output, vss, in, por_high, por_low
     );

output  out, outb;

inout  vcc_input, vcc_output, vss;

input  in, por_high, por_low;
reg out, outb;
wire NET58 , in_shift , in_shiftb , inb , in_sw , NET59 ;
//no vcc_input, vcc_output and vss tracking as of now.
always @ (in, por_high, por_low)
begin
	if ((por_high == 1'b0) && (por_low == 1'b1))
	begin
		out = 1'b0;
		outb = 1'b1;
	end
	else if ((por_high == 1'b1) && (por_low == 1'b0))
	begin
                out = 1'b1;
                outb = 1'b0;
	end
	else if ((por_high == 1'b0) && (por_low == 1'b0))
	begin
		out = in;
		outb = ~in;	
	end
	else
	begin
		out = 1'bx;
		outb = 1'bx;
	end	
end
endmodule

