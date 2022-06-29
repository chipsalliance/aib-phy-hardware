`timescale 1ps/1fs

module aibio_inpclk_select
		(
		//--------Supply pins----------//
		input vddcq,
		input vss,
		//--------Input pins-----------//
		input i_clk_inp,
		input i_clk_inn,
		input i_clk_loopback,
		input i_clk_sys,
		input i_clk_jtag,
		input i_clk_cdr_inp,
		input i_clk_cdr_inn,
		input [1:0] i_clksel,
		//--------Output pins-----------//
		output o_clkp,
		output o_clkn,
		output o_cdr_clkp,
		output o_cdr_clkn
		);

wire i_clk_loopbackp;
wire i_clk_loopbackn;
wire i_clk_sysp;
wire i_clk_sysn;
wire i_clk_jtagp;
wire i_clk_jtagn;

wire [3:0] clksel_decoded;

wire net016,net017,net018,net019;


aibio_se_to_diff se_diff_1
	(
	.vddcq(vddcq),
	.vss(vss),
	.i(i_clk_loopback),
	.o(i_clk_loopbackp),
	.o_b(i_clk_loopbackn)
	);

aibio_se_to_diff I7
	(
	.vddcq(vddcq),
	.vss(vss),
	.i(i_clk_jtag),
	.o(i_clk_jtagp),
	.o_b(i_clk_jtagn)
	);

aibio_se_to_diff se_diff_2
	(
	.vddcq(vddcq),
	.vss(vss),
	.i(i_clk_sys),
	.o(i_clk_sysp),
	.o_b(i_clk_sysn)
	);


aibio_pimux4x1 MUX_dummy_p
	(
	.vddcq(vddcq),
	.vss(vss),
	.i_clkph_sel({1'b0,1'b0,1'b0,1'b1}), //TBD
	.i_clkph({1'b0,1'b0,1'b0,i_clk_cdr_inp}),
	.o_clkph(net017)
	);


aibio_pimux4x1 MUX_dummy_n
	(
	.vddcq(vddcq),
	.vss(vss),
	.i_clkph_sel({1'b0,1'b0,1'b0,1'b1}),
	.i_clkph({1'b0,1'b0,1'b0,i_clk_cdr_inn}),
	.o_clkph(net016)
	);


aibio_decoder2x4 I5
	(
	.vddcq(vddcq),
	.vss(vss),
	.i(i_clksel),
	.o(clksel_decoded)
	);

aibio_pimux4x1 MUX_clkp
	(
	.vddcq(vddcq),
	.vss(vss),
	.i_clkph_sel(clksel_decoded),
	.i_clkph({i_clk_jtagp,i_clk_sysp,i_clk_loopbackp,i_clk_inp}),
	.o_clkph(net019)
	);

aibio_pimux4x1 MUX_clkn
	(
	.vddcq(vddcq),
	.vss(vss),
	.i_clkph_sel(clksel_decoded),
	.i_clkph({i_clk_jtagn,i_clk_sysn,i_clk_loopbackn,i_clk_inn}),
	.o_clkph(net018)
	);


/*
assign o_cdr_clkp = ~net017;
assign o_cdr_clkn = ~net016;
assign o_clkp = ~net019;
assign o_clkn = ~net018;
*/

assign o_cdr_clkp = net017;
assign o_cdr_clkn = net016;
assign o_clkp = net019;
assign o_clkn = net018;

endmodule


