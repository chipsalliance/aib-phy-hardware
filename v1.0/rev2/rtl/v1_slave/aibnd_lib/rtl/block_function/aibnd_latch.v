// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module aibnd_latch (
	input wire clk,
	input wire rb,
	//input wire vcc,
	//input wire vss,
	input wire d,
	output reg o
);

always@(*) begin
	if (!rb) begin
		o <= 0;
	end
	else begin
		if (clk)
			o <= d;
	end
end
endmodule




