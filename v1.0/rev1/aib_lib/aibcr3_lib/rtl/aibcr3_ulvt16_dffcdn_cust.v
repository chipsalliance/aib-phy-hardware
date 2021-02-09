// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module aibcr3_ulvt16_dffcdn_cust ( 
	input wire CK,
	input wire CDN,
	input wire D,
	output reg Q
);

always@(posedge CK or negedge CDN) begin
	if (!CDN) begin
		Q <= 1'b0;
	end
	else begin
		Q <= D;
	end
end
endmodule



