`timescale 1ps/1fs

module aibio_pulsegen_top
		(
		//---------Supply pins----------//
		input vddcq,
		input vss,
		//---------Input pins----------//
		input [15:0] i_clkphb,
		input [3:0] i_dll_even_phase1_sel,
		input [3:0] i_dll_odd_phase1_sel,
		input [3:0] i_dll_even_phase2_sel,
		input [3:0] i_dll_odd_phase2_sel,
		//--------Output pins-----------//
		output o_clk_even,
		output o_clk_odd,
		output o_pulseclk_even,
		output o_pulseclk_odd
		);

wire [1:0]clkph1_even;
wire [1:0]clkph2_even;
wire [1:0]clkph1_odd;
wire [1:0]clkph2_odd;

wire i_dll_odd_phase1_selb_3;
wire i_dll_even_phase1_selb_3;
wire i_dll_odd_phase2_selb_3;
wire i_dll_even_phase2_selb_3;

assign i_dll_odd_phase2_selb_3 = ~i_dll_odd_phase2_sel[3];
assign i_dll_even_phase2_selb_3 = ~i_dll_even_phase2_sel[3];
assign i_dll_odd_phase1_selb_3 = ~i_dll_odd_phase1_sel[3];
assign i_dll_even_phase1_selb_3 = ~i_dll_even_phase1_sel[3];

aibio_pulsegen_oddevn_halfside phsel_LSB
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_clkph(i_clkphb[7:0]),
		.i_evn_ph1_sel(i_dll_even_phase1_sel[2:0]),
		.i_evn_ph2_sel(i_dll_even_phase2_sel[2:0]),
		.i_odd_ph1_sel(i_dll_odd_phase1_sel[2:0]),
		.i_odd_ph2_sel(i_dll_odd_phase2_sel[2:0]),
		.o_clkph1_evn(clkph1_even[0]),
		.o_clkph1_odd(clkph1_odd[0]),
		.o_clkph2_evn(clkph2_even[0]),
		.o_clkph2_odd(clkph2_odd[0])
		);

aibio_pulsegen_oddevn_halfside phsel_MSB
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_clkph(i_clkphb[15:8]),
		.i_evn_ph1_sel(i_dll_even_phase1_sel[2:0]),
		.i_evn_ph2_sel(i_dll_even_phase2_sel[2:0]),
		.i_odd_ph1_sel(i_dll_odd_phase1_sel[2:0]),
		.i_odd_ph2_sel(i_dll_odd_phase2_sel[2:0]),
		.o_clkph1_evn(clkph1_even[1]),
		.o_clkph1_odd(clkph1_odd[1]),
		.o_clkph2_evn(clkph2_even[1]),
		.o_clkph2_odd(clkph2_odd[1])
		);

aibio_pulsegen_muxfinal muxfinal
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_clkph1_even(clkph1_even),
		.i_clkph1_odd(clkph1_odd),
		.i_clkph1_sel_even({i_dll_even_phase1_sel[3],i_dll_even_phase1_selb_3}),
		.i_clkph1_sel_odd({i_dll_odd_phase1_sel[3],i_dll_odd_phase1_selb_3}),
		.i_clkph2_even(clkph2_even),
		.i_clkph2_odd(clkph2_odd),
		.i_clkph2_sel_even({i_dll_even_phase2_selb_3,i_dll_even_phase2_sel[3]}),
		.i_clkph2_sel_odd({i_dll_odd_phase2_selb_3,i_dll_odd_phase2_sel[3]}),
		.clk_out_even(o_clk_even),
		.clk_out_odd(o_clk_odd),
		.pulse_out_even(o_pulseclk_even),
		.pulse_out_odd(o_pulseclk_odd)
		);

endmodule
