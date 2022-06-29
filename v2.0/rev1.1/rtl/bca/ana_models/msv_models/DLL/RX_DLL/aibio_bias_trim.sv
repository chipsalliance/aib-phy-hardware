`timescale 1ps/1fs

module aibio_bias_trim
		(
		//-------Supply pins---------//
		input vddcq,
		input vss,
		//-------Input pins---------//
		input [2:0]i_bias_trim,
		input i_pbias,
		input i_nbias,
		//--------Output pins----------//
		output [2:0]o_pbias_trim,
		output [2:0]o_nbias_trim
			);

//assign o_pbias_trim = ~(i_bias_trim);
//assign o_nbias_trim = i_bias_trim;

assign o_pbias_trim[0] = i_bias_trim[0] ? i_pbias : vddcq;
assign o_pbias_trim[1] = i_bias_trim[1] ? i_pbias : vddcq;
assign o_pbias_trim[2] = i_bias_trim[2] ? i_pbias : vddcq;

assign o_nbias_trim[0] = i_bias_trim[0] ? i_nbias : vss;
assign o_nbias_trim[1] = i_bias_trim[1] ? i_pbias : vss;
assign o_nbias_trim[2] = i_bias_trim[2] ? i_pbias : vss;

//assign o_pbias_trim = 3'b000;
//assign o_nbias_trim = 3'b000;

endmodule

