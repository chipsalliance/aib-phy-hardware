// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module altr_hps_gray2bin (
	 gray_in,
	 bin_out
);
input  [2:0] gray_in;
output [2:0] bin_out;
reg    [2:0] bin_out;

always @(*) 
begin // gray to binary converting
	 case(gray_in)
		  3'b000: bin_out = 3'b000;
		  3'b001: bin_out = 3'b001;
		  3'b011: bin_out = 3'b010;
		  3'b010: bin_out = 3'b011;
		  3'b110: bin_out = 3'b100;
		  3'b111: bin_out = 3'b101;
		  3'b101: bin_out = 3'b110;
		  3'b100: bin_out = 3'b111;
		  default:bin_out = 3'b000;
	 endcase
end
endmodule
