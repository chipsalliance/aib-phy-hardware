// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved
module aibcr3_ff_p ( 
	input wire CP,
	input wire SDN,
	input wire D,
	output reg Q
);

always@(posedge CP or negedge SDN) begin
	if (!SDN) begin
		Q <= 1'b1;
	end
	else begin
		Q <= D;
	end
end
endmodule



