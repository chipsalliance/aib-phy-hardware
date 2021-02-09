// SPDX-License-Identifier: Apache-2.0
// Copyright (c) 2019  Ayar Labs, Inc.
// Copyright (C) 2019 Intel Corporation. 
// Ayar modification: added pragma to ensure synthesis of a
// resettable latch (as opposed to something that forces E = 1'b1 to reset)
module aibcr3_latch (
	input wire E,
	input wire CDN,
	input wire D,
	output reg Q
);

wire latch_reset;
assign latch_reset = !CDN;

//cadence async_set_reset "latch_reset"
//synopsys async_set_reset "latch_reset"
always@(*) begin
	if (latch_reset) Q <= 0;
	else if (E) Q <= D;
end
endmodule


