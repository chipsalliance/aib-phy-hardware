`timescale 1ps/1fs

module aibio_pi_phsel_quarter
		(
		//--------Supply pins-------------//
		input vddcq,
		input vss,
		//--------Input pins-------------//
		input [3:0] i_clkph,
		input [3:0] i_clkphsel_stg1,
		input i_clkphsel_stg2,
		input i_pbias,
		input [2:0] i_pbias_trim,
		input i_nbias,
		input [2:0] i_nbias_trim,
		input [1:0] i_cap_sel,
		input [1:0] i_cap_selb,
		//---------Output pins------------//
		output o_clkph
		);

wire ph_MUX_out;

aibio_pimux4x1 MUX0
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_clkph_sel(i_clkphsel_stg1),
		.i_clkph(i_clkph),
		.o_clkph(ph_MUX_out)
		);

assign o_clkph = (i_clkphsel_stg2 == 1'b1) ? ph_MUX_out : 1'bz;

endmodule
