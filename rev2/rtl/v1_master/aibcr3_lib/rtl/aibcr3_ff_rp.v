// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module aibcr3_ff_rp ( 
	input wire CP,
	input wire CDN,
	input wire SDN,
	input wire D,
	output reg Q
);

always@(posedge CP or negedge CDN or negedge SDN) begin
	if (!CDN) begin
		Q <= 1'b0;
	end
	else if (!SDN) begin
		Q <= 1'b1;
	end
	else begin
		Q <= D;
	end
end
endmodule



