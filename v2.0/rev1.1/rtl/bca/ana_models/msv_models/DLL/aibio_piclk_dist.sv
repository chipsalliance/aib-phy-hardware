`timescale 1ps/1fs

module aibio_clock_dist
		(
		//---------Supply pins------------//
		input vddcq,
		input vss,
		//---------Input pins------------//
		input i_piclk_even_in,
		input i_piclk_odd_in,
		input i_loopback_en,
		//---------Output pins----------//
		output o_piclk_even_loopback,
		output o_piclk_odd_loopback
		);

assign o_piclk_even_loopback = i_loopback_en ? i_piclk_even_in : 1'b0;
assign o_piclk_odd_loopback = i_loopback_en ? i_piclk_odd_in : 1'b0;

endmodule
