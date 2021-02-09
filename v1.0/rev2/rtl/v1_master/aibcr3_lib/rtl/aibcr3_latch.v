// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module aibcr3_latch (
	input wire E,
	input wire CDN,
	//input wire vcc,
	//input wire vss,
	input wire D,
	output reg Q
);

always@(*) begin
	if (!CDN) begin
		Q <= 0;
	end
	else begin
		if (E)
			Q <= D;
	end
end
endmodule


