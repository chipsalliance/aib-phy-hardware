`timescale 1ps/1fs

module aibio_pioddevn_mixer_top
		(
		//--------Supply pins--------//
		input vddcq,
		input vss,
		//--------Input pins---------//
		input i_clkevn_evn,
		input i_clkevn_odd,
		input i_clkodd_evn,
		input i_clkodd_odd,
		input i_pien,
		input [7:0]i_pimixer_evn,
		input [7:0]i_pimixer_odd,
		input [15:0]i_clkph,
		input [7:0]i_pievn_code,
		input [7:0]i_piodd_code,
		input real ph_diff,
		//--------Output pins---------//
		output o_clk_evn,
		output o_clk_odd
		);

wire odd_clk_mixer;
wire evn_clk_mixer;

wire odd_clk_mixerb;
wire evn_clk_mixerb;

wire out_ph_0_flag_evn;
wire out_ph_0_flag_odd;
wire out_ph_0_flag;

wire odd_clk_mixer_int;
wire evn_clk_mixer_int;

aibio_pi_mixer_top mixer_odd
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_clkph_evn(i_clkevn_odd),
		.i_clkph_odd(i_clkodd_odd),
		.i_oddph_en(i_pimixer_odd),
		.i_pien(i_pien),
		.i_clkph(i_clkph),
		.i_picode(i_piodd_code),
		.ph_diff(ph_diff),
		.o_clkmix_out(odd_clk_mixer)
		);

aibio_pi_mixer_top mixer_evn
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_clkph_evn(i_clkevn_evn),
		.i_clkph_odd(i_clkodd_evn),
		.i_oddph_en(i_pimixer_evn),
		.i_pien(i_pien),
		.i_clkph(i_clkph),
		.i_picode(i_pievn_code),
		.ph_diff(ph_diff),
		.o_clkmix_out(evn_clk_mixer)
		);


assign evn_clk_mixerb = ~evn_clk_mixer;
assign o_clk_evn = ~evn_clk_mixerb;

assign odd_clk_mixerb = ~odd_clk_mixer;
assign o_clk_odd = ~odd_clk_mixerb;

endmodule

