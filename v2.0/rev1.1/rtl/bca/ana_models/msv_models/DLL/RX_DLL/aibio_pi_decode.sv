`timescale 1ps/1fs

module aibio_pi_decode
		(
		//--------Supply pins----------//
		input vddcq,
		input vss,
		//--------Input pins-----------//
		input [7:0] i_picode,
		//--------Output pins----------//
		output [7:0]o_clkphsel_stg1,
		output [1:0]o_clkphsel_stg2,
		output [7:0]o_pimixer
		);

wire [3:0] picode_plus1;
wire mix_on;
wire [7:0] curr_code;
wire [7:0] next_code;

wire [7:1] therm;
wire [7:1] therm_b;
wire next_odd_en;
wire next_evn_en;
wire i_picode_b_3;


aibio_decoder3x8 I7
		(
		.vddcq(vddcq),
		.vss(vss),
		.i(i_picode[5:3]),
		.o(curr_code)
		);

aibio_decoder3x8 I6
		(
		.vddcq(vddcq),
		.vss(vss),
		.i(picode_plus1[2:0]),
		.o(next_code)
		);

aibio_3bit_bin_to_therm I3
		(
		.vddcq(vddcq),
		.vss(vss),
		.b(i_picode[2:0]),
		.t(therm)
		);

aibio_4bit_plus1 I4
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_code(i_picode[6:3]),
		.o_code(picode_plus1)
		);


assign therm_b[7] = ~therm[7];
assign therm_b[6] = ~therm[6];
assign therm_b[5] = ~therm[5];
assign therm_b[4] = ~therm[4];
assign therm_b[3] = ~therm[3];
assign therm_b[2] = ~therm[2];
assign therm_b[1] = ~therm[1];

//assign mix_on = i_picode[2] || i_picode[1] || i_picode[0];
//assign next_evn_en = i_picode[3] && mix_on ;
assign next_evn_en = i_picode[3];
assign i_picode_b_3 = ~i_picode[3];
//assign next_odd_en = i_picode_b_3 && mix_on;
assign next_odd_en = i_picode_b_3;

assign o_clkphsel_stg2[0] = next_evn_en ? picode_plus1[3] : i_picode[6];
assign o_clkphsel_stg2[1] = next_odd_en ? picode_plus1[3] : i_picode[6];

assign o_clkphsel_stg1[6] = next_evn_en ? next_code[6] : curr_code[6];
assign o_clkphsel_stg1[4] = next_evn_en ? next_code[4] : curr_code[4];
assign o_clkphsel_stg1[2] = next_evn_en ? next_code[2] : curr_code[2];
assign o_clkphsel_stg1[0] = next_evn_en ? next_code[0] : curr_code[0];

assign o_clkphsel_stg1[7] = next_odd_en ? next_code[7] : curr_code[7];
assign o_clkphsel_stg1[5] = next_odd_en ? next_code[5] : curr_code[5];
assign o_clkphsel_stg1[3] = next_odd_en ? next_code[3] : curr_code[3];
assign o_clkphsel_stg1[1] = next_odd_en ? next_code[1] : curr_code[1];

assign o_pimixer[7] = i_picode[3] ? therm_b[7] : therm[7];
assign o_pimixer[6] = i_picode[3] ? therm_b[6] : therm[6];
assign o_pimixer[5] = i_picode[3] ? therm_b[5] : therm[5];
assign o_pimixer[4] = i_picode[3] ? therm_b[4] : therm[4];
assign o_pimixer[3] = i_picode[3] ? therm_b[3] : therm[3];
assign o_pimixer[2] = i_picode[3] ? therm_b[2] : therm[2];
assign o_pimixer[1] = i_picode[3] ? therm_b[1] : therm[1];

assign o_pimixer[0] = i_picode[3];

endmodule
