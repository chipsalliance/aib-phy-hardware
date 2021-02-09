// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 


module aibcr3aux_lvshift ( out, vccl_aibcr3aux, vcc_aibcr3aux, vssl_aibcr3aux, in);

output  out;

input  vccl_aibcr3aux, vcc_aibcr3aux, vssl_aibcr3aux;

input  in;
reg out;
//wire NET58 , in_shift , in_shiftb , inb , in_sw , NET59 ;
//no vccl_aibcr3aux, vcc_aibcr3aux and vssl_aibcr3aux tracking as of now.
always @ (in, vccl_aibcr3aux, vcc_aibcr3aux)
begin
	if (vccl_aibcr3aux == 1'b0 && vcc_aibcr3aux == 1'b0) 
	begin
		out = 1'b0;		
	end
	else if (vccl_aibcr3aux == 1'b0 && vcc_aibcr3aux == 1'b1)
	begin
		out = 1'b1;
	end
	else if (vccl_aibcr3aux == 1'b1 && vcc_aibcr3aux == 1'b0)
	begin
		out = 1'b0;
	end
	else if (vccl_aibcr3aux == 1'b1 && vcc_aibcr3aux == 1'b1)
	begin
		out = in;
	end
	else
	begin
		out = 1'bx;
	end	
end
endmodule

