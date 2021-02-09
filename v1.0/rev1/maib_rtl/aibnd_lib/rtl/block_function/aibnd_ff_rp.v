// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module aibnd_ff_rp ( 
	input wire clk,
	input wire rb,
	input wire psb,
	input wire d,
	//input wire vss,
	//input wire vcc,
	output reg o
);

always@(posedge clk or negedge rb or negedge psb) begin
	if (!rb) begin
		o <= 1'b0;
	end
	else if (!psb) begin
		o <= 1'b1;
	end
	else begin
		o <= d;
	end
end
endmodule




