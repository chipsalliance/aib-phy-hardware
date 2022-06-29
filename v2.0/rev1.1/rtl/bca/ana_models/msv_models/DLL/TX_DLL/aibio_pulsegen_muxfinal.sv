`timescale 1ps/1fs

module aibio_pulsegen_muxfinal
		(
		//-------Supply pins--------//
		input vddcq,
		input vss,
		//-------Input pins--------//
		input [1:0]i_clkph1_even,
		input [1:0]i_clkph1_odd,
		input [1:0]i_clkph1_sel_even,
		input [1:0]i_clkph1_sel_odd,
		input [1:0]i_clkph2_even,
		input [1:0]i_clkph2_odd,
		input [1:0]i_clkph2_sel_even,
		input [1:0]i_clkph2_sel_odd,
		//-------Output pins---------//
		output clk_out_even,
		output clk_out_odd,
		output pulse_out_even,
		output pulse_out_odd
		);

wire clkph1b_even;
wire clkph2b_even;
wire clkph1b_odd;
wire clkph2b_odd;

wire clkph2_odd;
wire clkph2_even;

aibio_pulsegen_mux2x1 I0
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_clkph(i_clkph1_even),
		.i_clkph_sel(i_clkph1_sel_even),
		.o_clkph(clkph1b_even)
		);

aibio_pulsegen_mux2x1 I1
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_clkph(i_clkph2_even),
		.i_clkph_sel(i_clkph2_sel_even),
		.o_clkph(clkph2b_even)
		);

aibio_pulsegen_mux2x1 I3
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_clkph(i_clkph2_odd),
		.i_clkph_sel(i_clkph2_sel_odd),
		.o_clkph(clkph2b_odd)
		);

aibio_pulsegen_mux2x1 I4
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_clkph(i_clkph1_odd),
		.i_clkph_sel(i_clkph1_sel_odd),
		.o_clkph(clkph1b_odd)
		);

assign clk_out_even = ~clkph1b_even;
assign clk_out_odd = ~clkph1b_odd;
assign clkph2_odd = ~clkph2b_odd;
assign clkph2_even = ~clkph2b_even;

assign pulse_out_even = clk_out_even && clkph2_even; 
assign pulse_out_odd = clk_out_odd && clkph2_odd;

endmodule
