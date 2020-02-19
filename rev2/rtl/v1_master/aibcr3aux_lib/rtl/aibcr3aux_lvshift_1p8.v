// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 


module aibcr3aux_lvshift_1p8 ( out1p8, vccl_aibcr3aux, vcca_aibcr3aux, vssl_aibcr3aux, in);

output  out1p8;

input  vccl_aibcr3aux, vcca_aibcr3aux, vssl_aibcr3aux;

input  in;
reg out1p8;
//wire NET58 , in_shift , in_shiftb , inb , in_sw , NET59 ;
//no vccl_aibcr3aux, vcca_aibcr3aux and vssl_aibcr3aux tracking as of now.
always @ (in, vccl_aibcr3aux, vcca_aibcr3aux)
begin
	if (vccl_aibcr3aux == 1'b0 && vcca_aibcr3aux == 1'b0) 
	begin
		out1p8 = 1'b0;		
	end
	else if (vccl_aibcr3aux == 1'b0 && vcca_aibcr3aux == 1'b1)
	begin
		out1p8 = 1'b1;
	end
	else if (vccl_aibcr3aux == 1'b1 && vcca_aibcr3aux == 1'b0)
	begin
		out1p8 = 1'b0;
	end
	else if (vccl_aibcr3aux == 1'b1 && vcca_aibcr3aux == 1'b1)
	begin
		out1p8 = in;
	end
	else
	begin
		out1p8 = 1'bx;
	end	
end
endmodule

