// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module aibnd_txdat_mimic (
	input wire vccl_aibnd,
	input wire vssl_aibnd,
	input wire idata_in,
	output wire idata_out
);

assign idata_out = idata_in;

endmodule
