// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module aibcr3_rxdat_mimic (
	input wire odat_in,
	input wire vcc_aibcr,
	input wire vss_aibcr,
	output wire odat_out
);

	assign odat_out = odat_in;

endmodule
