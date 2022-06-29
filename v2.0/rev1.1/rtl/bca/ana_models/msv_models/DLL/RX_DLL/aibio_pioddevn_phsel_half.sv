`timescale 1ps/1fs

module aibio_pioddevn_phsel_half
		(
		//--------Supply pins---------//
		input vddcq,
		input vss,
		//--------Input pins----------//
		input [1:0]i_cap_sel,
		input [1:0]i_cap_selb,
		input [3:0]i_clk_evnph,
		input [3:0]i_clk_evnphsel_stg1_evn,
		input [3:0]i_clk_evnphsel_stg1_odd,
		input i_clk_evnphsel_stg2_evn,
		input i_clk_evnphsel_stg2_odd,
		input [3:0]i_clk_oddph,
		input [3:0]i_clk_oddphsel_stg1_evn,
		input [3:0]i_clk_oddphsel_stg1_odd,
		input i_clk_oddphsel_stg2_evn,
		input i_clk_oddphsel_stg2_odd,
		input i_nbias,
		input [2:0] i_nbias_trim,
		input i_pbias,
		input [2:0]i_pbias_trim,
		//---------Output pins-----------//
		output o_clk_evnph_evn,
		output o_clk_evnph_odd,
		output o_clk_oddph_evn,
		output o_clk_oddph_odd
		);

aibio_pi_phsel_halfside oddclk_phselhalf
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_cap_sel(i_cap_sel),
		.i_cap_selb(i_cap_selb),
		.i_clk_evnph(i_clk_evnph),
		.i_clk_evnphsel_stg1(i_clk_evnphsel_stg1_odd),
		.i_clk_evnphsel_stg2(i_clk_evnphsel_stg2_odd),
		.i_clk_oddph(i_clk_oddph),
		.i_clk_oddphsel_stg1(i_clk_oddphsel_stg1_odd),
		.i_clk_oddphsel_stg2(i_clk_oddphsel_stg2_odd),
		.i_nbias(i_nbias),
		.i_nbias_trim(i_nbias_trim),
		.i_pbias(i_pbias),
		.i_pbias_trim(i_pbias_trim),
		.o_clk_evnph(o_clk_evnph_odd),
		.o_clk_oddph(o_clk_oddph_odd)
		);

aibio_pi_phsel_halfside evnclk_phselhalf
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_cap_sel(i_cap_sel),
		.i_cap_selb(i_cap_selb),
		.i_clk_evnph(i_clk_evnph),
		.i_clk_evnphsel_stg1(i_clk_evnphsel_stg1_evn),
		.i_clk_evnphsel_stg2(i_clk_evnphsel_stg2_evn),
		.i_clk_oddph(i_clk_oddph),
		.i_clk_oddphsel_stg1(i_clk_oddphsel_stg1_evn),
		.i_clk_oddphsel_stg2(i_clk_oddphsel_stg2_evn),
		.i_nbias(i_nbias),
		.i_nbias_trim(i_nbias_trim),
		.i_pbias(i_pbias),
		.i_pbias_trim(i_pbias_trim),
		.o_clk_evnph(o_clk_evnph_evn),
		.o_clk_oddph(o_clk_oddph_evn)
		);

endmodule
