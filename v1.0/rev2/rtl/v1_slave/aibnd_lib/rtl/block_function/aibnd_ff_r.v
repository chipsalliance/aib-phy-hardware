// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module aibnd_ff_r ( 
	input wire clk,
	input wire rb,
	input wire d,
	//input wire vss,
	//input wire vcc,
	output reg o
);

always@(posedge clk or negedge rb) begin
	if (!rb) begin
		o <= 1'b0;
	end
	else begin
		o <= d;
	end
end
endmodule




