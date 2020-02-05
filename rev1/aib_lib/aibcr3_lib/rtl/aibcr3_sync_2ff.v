// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module aibcr3_sync_2ff (CDN, CP, D, SE, SI, Q);
    input CDN, CP, D, SE, SI;
    output reg Q;
    wire data;
    reg flop_0;

        assign data = SE ?  SI : D ; 
	
	always @(posedge CP or negedge CDN)
		if (!CDN) {Q,flop_0} <= 0;
		else if (CDN) {Q,flop_0} <= {flop_0,data};
		else {Q,flop_0} <= 0;
endmodule
