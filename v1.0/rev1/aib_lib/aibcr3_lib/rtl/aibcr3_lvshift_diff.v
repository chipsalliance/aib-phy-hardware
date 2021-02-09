// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// Library - aibcr_lib, Cell - aibcr3_lvshift_diff, View - schematic

module aibcr3_lvshift_diff ( out, outb, in, inb, por
     );

output  out, outb;


input  in, inb, por;
reg out, outb;
wire NET58 , in_shift , in_shiftb , inb , in_sw , NET59 ;
//no vcc_input, vcc_output and vss tracking as of now.
always @ (in, por, inb)
begin
	if (por == 1'b1)
	begin
		out = 1'b0;
		outb = 1'b1;
	end
	else if (por == 1'b0)
	begin
	     if ( in==1'b0 && inb==1'b0)
		begin
			out = 1'b1;
			outb = 1'b1;
		end
	     else if ( in==1'b1 && inb==1'b1)
		begin
			out = 1'bx;
			outb = 1'bx;
		end	
	     else
		begin	
			out = in;
			outb = inb;	
		end
	end
	else
	begin
		out = 1'bx;
		outb = 1'bx;
	end	
end
endmodule

