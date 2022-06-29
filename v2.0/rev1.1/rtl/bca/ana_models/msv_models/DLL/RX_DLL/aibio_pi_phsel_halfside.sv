`timescale 1ps/1fs

module aibio_pi_phsel_halfside
		(
		//---------Supply pins--------//
		input vddcq,
		input vss,
		//--------Input pins---------//
		input [1:0]i_cap_sel,
		input [1:0]i_cap_selb,
		input [3:0]i_clk_evnph,
		input [3:0]i_clk_evnphsel_stg1,
		input i_clk_evnphsel_stg2,
		input [3:0]i_clk_oddph,
		input [3:0]i_clk_oddphsel_stg1,
		input i_clk_oddphsel_stg2,
		input i_nbias,
		input [2:0]i_nbias_trim,
		input i_pbias,
		input [2:0]i_pbias_trim,
		//--------Output pins----------//
		output o_clk_evnph,
		output o_clk_oddph
		);

aibio_pi_phsel_quarter phsel_mux_odd
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_clkph(i_clk_oddph),
		.i_clkphsel_stg1(i_clk_oddphsel_stg1),
		.i_clkphsel_stg2(i_clk_oddphsel_stg2),
		.i_pbias(i_pbias),
		.i_pbias_trim(i_pbias_trim),
		.i_nbias(i_nbias),
		.i_nbias_trim(i_nbias_trim),
		.i_cap_sel(i_cap_sel),
		.i_cap_selb(i_cap_selb),
		.o_clkph(o_clk_oddph)
		);

aibio_pi_phsel_quarter phsel_mux_evn
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_clkph(i_clk_evnph),
		.i_clkphsel_stg1(i_clk_evnphsel_stg1),
		.i_clkphsel_stg2(i_clk_evnphsel_stg2),
		.i_pbias(i_pbias),
		.i_pbias_trim(i_pbias_trim),
		.i_nbias(i_nbias),
		.i_nbias_trim(i_nbias_trim),
		.i_cap_sel(i_cap_sel),
		.i_cap_selb(i_cap_selb),
		.o_clkph(o_clk_evnph)
		);

endmodule
