// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module altr_hps_bin2gray (
	 bin_in,
	 gray_out
);

input  [2:0] bin_in;
output [2:0] gray_out;
reg    [2:0] gray_out;

always @(*) 
begin  // 3 bit gray code 
	 case(bin_in)
		  3'b000 : gray_out = 3'b000; 
		  3'b001 : gray_out = 3'b001; 
		  3'b010 : gray_out = 3'b011; 
		  3'b011 : gray_out = 3'b010; 
		  3'b100 : gray_out = 3'b110; 
		  3'b101 : gray_out = 3'b111; 
		  3'b110 : gray_out = 3'b101; 
		  3'b111 : gray_out = 3'b100; 
		  default: gray_out = 3'b000;
	 endcase
end

endmodule
