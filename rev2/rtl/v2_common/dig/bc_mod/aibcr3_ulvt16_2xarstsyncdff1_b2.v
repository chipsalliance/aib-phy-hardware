// SPDX-License-Identifier: Apache-2.0
// Copyright (c) 2019 Blue Cheetah Analog Design, Inc.
// Copyright (C) 2019 Intel Corporation. 
//
// On 11/25/19, BCA modified to use standard synchronizer methodology
//
module aibcr3_ulvt16_2xarstsyncdff1_b2 (CLR_N, CK, D, SE, SI, Q);
    input CLR_N, CK, D, SE, SI;
    output logic Q;
    wire data;

        assign data = SE ?  SI : D ; 
	
`ifdef BEHAVIORAL

    reg flop_0;

	always @(posedge CK or negedge CLR_N)
		if (!CLR_N) {Q,flop_0} <= 0;
		else if (CLR_N) {Q,flop_0} <= {flop_0,data};
		else {Q,flop_0} <= 0;

`else

data_sync_for_aib
# ( 
    .ActiveLow    ( 1    ),
    .ResetVal     ( 1'b0 ),
    .SyncRegWidth ( 2    )
    )
u_data_sync
  ( 
    .clk      ( CK       ),
    .rst_in   ( CLR_N    ),
    .data_in  ( data     ),
    .data_out ( Q        )
    );

`endif

endmodule
