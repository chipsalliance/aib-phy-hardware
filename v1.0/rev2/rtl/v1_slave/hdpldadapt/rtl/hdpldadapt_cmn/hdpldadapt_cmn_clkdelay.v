// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module hdpldadapt_cmn_clkdelay
(
        output  wire	clkout,
	input	wire 	rsel0,
	input	wire 	rsel1,
	input	wire 	rsel2,
	input	wire 	rsel3,
	input	wire 	rsel4,
	input	wire 	rsel5,
	input	wire 	rsel6,
	input	wire 	rsel7,
	input	wire 	rsel8,
	input	wire 	rsel9,
	input	wire 	rsel10,
	input	wire 	rsel11,
	input	wire 	rsel12,
	input	wire 	rsel13,
	input	wire 	rsel14,
        input   wire   	clk
);

hdpldadapt_cmn_clkdelay_cell hdpldadapt_cmn_clkdelay_cell
    (
        .rsel0(rsel0),
        .rsel1(rsel1),
        .rsel2(rsel2),
        .rsel3(rsel3),
        .rsel4(rsel4),
        .rsel5(rsel5),
        .rsel6(rsel6),
        .rsel7(rsel7),
        .rsel8(rsel8),
        .rsel9(rsel9),
        .rsel10(rsel10),
        .rsel11(rsel11),
        .rsel12(rsel12),
        .rsel13(rsel13),
        .rsel14(rsel14),
        .clk(clk),
        .clkout(clkout)
    );

endmodule // hdpldadapt_cmn_clkdelay_cell
