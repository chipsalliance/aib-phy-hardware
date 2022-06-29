`timescale 1ps/1fs

module aibio_inpclk_select_txdll
		(
		//--------Supply pins----------//
		input vddcq,
		input vss,
		//--------Input pins-----------//
		input i_clk_in,
		input i_clk_loopback,
		input i_clk_sys,
		input i_clk_jtag,
		input [1:0] i_clksel,
		//--------Output pins-----------//
		output o_clkp,
		output o_clkn
		);
/*
wire i_clk_inp;
wire i_clk_inn;
wire i_clk_loopbackp;
wire i_clk_loopbackn;
wire i_clk_sysp;
wire i_clk_sysn;
wire i_clk_jtagp;
wire i_clk_jtagn;

assign i_clk_loopbackp = i_clk_loopback;
assign i_clk_loopbackn = ~i_clk_loopback;

assign i_clk_sysp = i_clk_sys;
assign i_clk_sysn = ~i_clk_sys;

assign i_clk_inp = i_clk_in;
assign i_clk_inn = ~i_clk_in;

assign i_clk_jtagp = i_clk_jtag;
assign i_clk_jtagn = ~i_clk_jtag;


assign o_clkp = (i_clksel == 2'b00) ? i_clk_inp :
					 (i_clksel == 2'b01) ? i_clk_loopbackp :
					 (i_clksel == 2'b10) ? i_clk_sysp :
					 (i_clksel == 2'b11) ? i_clk_jtagp :
					 1'b0;

assign o_clkn = (i_clksel == 2'b00) ? i_clk_inn :
					 (i_clksel == 2'b01) ? i_clk_loopbackn :
					 (i_clksel == 2'b10) ? i_clk_sysn :
					 (i_clksel == 2'b11) ? i_clk_jtagn :
					 1'b0;
*/
wire o_clk;
wire [3:0]clksel_decoded;

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
	.i_clkph({i_clk_jtag,i_clk_sys,i_clk_loopback,i_clk_in}),
	.o_clkph(o_clk)
	);


aibio_se_to_diff se_diff_1
	(
	.vddcq(vddcq),
	.vss(vss),
	.i(o_clk),
	.o(o_clkp),
	.o_b(o_clkn)
	);


endmodule
