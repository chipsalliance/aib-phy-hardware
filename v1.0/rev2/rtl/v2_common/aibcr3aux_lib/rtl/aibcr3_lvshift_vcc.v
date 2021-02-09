// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// 04/22/2020: Removed vssl_aibcr3aux. BC will need to replace this module.

module aibcr3_lvshift_vcc ( out, vccl_aibcr3aux, vcc_aibcr3aux,  in);

output  out;

input  vccl_aibcr3aux, vcc_aibcr3aux;

input  in;
reg out;

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

