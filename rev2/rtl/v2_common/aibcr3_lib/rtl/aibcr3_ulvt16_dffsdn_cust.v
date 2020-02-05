// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module aibcr3_ulvt16_dffsdn_cust ( 
	input wire CK,
	input wire SDN,
	input wire D,
	output reg Q
);

always@(posedge CK or negedge SDN) begin
	if (!SDN) begin
		Q <= 1'b1;
	end
	else begin
		Q <= D;
	end
end

endmodule



