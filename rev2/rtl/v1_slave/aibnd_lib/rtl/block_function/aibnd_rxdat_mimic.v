// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module aibnd_rxdat_mimic (
	input wire vccl_aibnd,
	input wire vssl_aibnd,
	input wire odat_in,
	output wire odat_out
);

assign odat_out = odat_in;

endmodule
