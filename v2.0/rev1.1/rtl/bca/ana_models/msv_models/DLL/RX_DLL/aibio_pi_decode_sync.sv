`timescale 1ps/1fs

module aibio_pi_decode_sync
		(
		//---------Supply pins--------//
		input vddcq,
		input vss,
		//---------Input pins----------//
		input i_clk_en,
		input i_clk_sync,
		input [7:0] i_picode,
		input i_reset,
		input i_update,
		//---------Output pins---------//
		output [7:0] o_clkphsel_stg1_synced,
		output [1:0] o_clkphsel_stg2_synced,
		output [7:0] o_pimixer_synced
		);

wire [7:0] clkphsel_stg1;
wire [1:0] clkphsel_stg2;
wire [7:0] pimixer;

aibio_pi_decode I1
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_picode(i_picode),
		.o_clkphsel_stg1(clkphsel_stg1),
		.o_clkphsel_stg2(clkphsel_stg2),
		.o_pimixer(pimixer)
		);

aibio_pi_codeupdate I2
		(
 		.vddcq(vddcq),
		.vss(vss),
 		.i_clk(i_clk_sync),
 		.i_clk_en(i_clk_en),
		.i_clkphsel_stg1(clkphsel_stg1),
		.i_clkphsel_stg2(clkphsel_stg2),
		.i_pimixer(pimixer),
		.i_update(i_update),
		.i_reset(i_reset),
		.o_clkphsel_stg1(o_clkphsel_stg1_synced),
		.o_clkphsel_stg2(o_clkphsel_stg2_synced),
		.o_pimixer(o_pimixer_synced)
		);

endmodule
