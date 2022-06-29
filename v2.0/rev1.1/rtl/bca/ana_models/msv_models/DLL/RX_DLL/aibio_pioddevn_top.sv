`timescale 1ps/1fs

module aibio_pioddevn_top
		(
		//--------Supply pins-----------//
		input vddcq,
		input vss,
		//--------Input pins-----------//
		input [15:0]i_clkphb,
		input [7:0]i_picode_evn,
		input [7:0]i_picode_odd,
		input i_pbias,
		input i_nbias,
		input [2:0]i_bias_trim,
		input [1:0]i_capsel,
		input [1:0]i_capselb,
		input i_clken,
		input i_pien,
		input i_reset,
		input i_update,
		input real ph_diff,
		//-------Output pins-----------//
		output o_clkpi_evn,
		output o_clkpi_odd
		);

//--------Internal signals----------//
wire [2:0]pbias_trim;
wire [2:0]nbias_trim;

wire clkph_0;
wire clkph_1;
wire clkph_2;
wire clkph_3;
wire clkph_4;
wire clkph_5;
wire clkph_6;
wire clkph_7;
wire clkph_8;
wire clkph_9;
wire clkph_10;
wire clkph_11;
wire clkph_12;
wire clkph_13;
wire clkph_14;
wire clkph_15;

wire [7:0]clkphsel_stg1_odd;
wire [7:0]clkphsel_stg1_evn;

wire [1:0]clkphsel_stg2_odd;
wire [1:0]clkphsel_stg2_evn;

wire [7:0]pixer_odd;
wire [7:0]pixer_evn;

wire [1:0]phsel_stg2_b_odd;
wire [1:0]phsel_stg2_b_evn;

wire [1:0]phsel_stg2_bb_odd;
wire [1:0]phsel_stg2_bb_evn;

wire clkevn_evn;
wire clkevn_odd;
wire clkodd_evn;
wire clkodd_odd;

assign clkph_0 = ~i_clkphb[0];
assign clkph_1 = ~i_clkphb[1];
assign clkph_2 = ~i_clkphb[2];
assign clkph_3 = ~i_clkphb[3];
assign clkph_4 = ~i_clkphb[4];
assign clkph_5 = ~i_clkphb[5];
assign clkph_6 = ~i_clkphb[6];
assign clkph_7 = ~i_clkphb[7];
assign clkph_8 = ~i_clkphb[8];
assign clkph_9 = ~i_clkphb[9];
assign clkph_10 = ~i_clkphb[10];
assign clkph_11 = ~i_clkphb[11];
assign clkph_12 = ~i_clkphb[12];
assign clkph_13 = ~i_clkphb[13];
assign clkph_14 = ~i_clkphb[14];
assign clkph_15 = ~i_clkphb[15];

assign phsel_stg2_b_odd[0] = ~(clkphsel_stg2_odd[0] && i_pien);
assign phsel_stg2_b_odd[1] = ~(clkphsel_stg2_odd[1] && i_pien);

assign phsel_stg2_bb_odd[0] = ~phsel_stg2_b_odd[0];
assign phsel_stg2_bb_odd[1] = ~phsel_stg2_b_odd[1];

assign phsel_stg2_b_evn[0] = ~(clkphsel_stg2_evn[0] && i_pien);
assign phsel_stg2_b_evn[1] = ~(clkphsel_stg2_evn[1] && i_pien);

assign phsel_stg2_bb_evn[0] = ~phsel_stg2_b_evn[0];
assign phsel_stg2_bb_evn[1] = ~phsel_stg2_b_evn[1];


aibio_bias_trim I2
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_bias_trim(i_bias_trim),
		.i_pbias(i_pbias),
		.i_nbias(i_nbias),
		.o_pbias_trim(pbias_trim),
		.o_nbias_trim(nbias_trim)
		);

aibio_pi_decode_sync odd_decode_sync
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_clk_en(i_clken),
		.i_clk_sync(o_clkpi_odd),
		.i_picode(i_picode_odd),
		.i_reset(i_reset),
		.i_update(i_update),
		.o_clkphsel_stg1_synced(clkphsel_stg1_odd),
		.o_clkphsel_stg2_synced(clkphsel_stg2_odd),
		.o_pimixer_synced(pixer_odd)
		);

aibio_pi_decode_sync evn_decode_sync
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_clk_en(i_clken),
		.i_clk_sync(o_clkpi_evn),
		.i_picode(i_picode_evn),
		.i_reset(i_reset),
		.i_update(i_update),
		.o_clkphsel_stg1_synced(clkphsel_stg1_evn),
		.o_clkphsel_stg2_synced(clkphsel_stg2_evn),
		.o_pimixer_synced(pixer_evn)
		);

aibio_pioddevn_phsel_half phsel_oddevn_LSB
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_cap_sel(i_capsel),
		.i_cap_selb(i_capselb),
		.i_clk_evnph({clkph_6,clkph_4,clkph_2,clkph_0}),
		.i_clk_evnphsel_stg1_evn({clkphsel_stg1_evn[6],clkphsel_stg1_evn[4],clkphsel_stg1_evn[2],clkphsel_stg1_evn[0]}),
		.i_clk_evnphsel_stg1_odd({clkphsel_stg1_odd[6],clkphsel_stg1_odd[4],clkphsel_stg1_odd[2],clkphsel_stg1_odd[0]}),
		.i_clk_evnphsel_stg2_evn(phsel_stg2_b_evn[0]),
		.i_clk_evnphsel_stg2_odd(phsel_stg2_b_odd[0]),
		.i_clk_oddph({clkph_7,clkph_5,clkph_3,clkph_1}),
		.i_clk_oddphsel_stg1_evn({clkphsel_stg1_evn[7],clkphsel_stg1_evn[5],clkphsel_stg1_evn[3],clkphsel_stg1_evn[1]}),
		.i_clk_oddphsel_stg1_odd({clkphsel_stg1_odd[7],clkphsel_stg1_odd[5],clkphsel_stg1_odd[3],clkphsel_stg1_odd[1]}),
		.i_clk_oddphsel_stg2_evn(phsel_stg2_b_evn[1]),
		.i_clk_oddphsel_stg2_odd(phsel_stg2_b_odd[1]),
		.i_nbias(i_nbias),
		.i_nbias_trim(nbias_trim),
		.i_pbias(i_pbias),
		.i_pbias_trim(pbias_trim),
		.o_clk_evnph_evn(clkevn_evn),
		.o_clk_evnph_odd(clkevn_odd),
		.o_clk_oddph_evn(clkodd_evn),
		.o_clk_oddph_odd(clkodd_odd)
		);

aibio_pioddevn_phsel_half phsel_oddevn_MSB
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_cap_sel(i_capsel),
		.i_cap_selb(i_capselb),
		.i_clk_evnph({clkph_14,clkph_12,clkph_10,clkph_8}),
		.i_clk_evnphsel_stg1_evn({clkphsel_stg1_evn[6],clkphsel_stg1_evn[4],clkphsel_stg1_evn[2],clkphsel_stg1_evn[0]}),
		.i_clk_evnphsel_stg1_odd({clkphsel_stg1_odd[6],clkphsel_stg1_odd[4],clkphsel_stg1_odd[2],clkphsel_stg1_odd[0]}),
		.i_clk_evnphsel_stg2_evn(phsel_stg2_bb_evn[0]),
		.i_clk_evnphsel_stg2_odd(phsel_stg2_bb_odd[0]),
		.i_clk_oddph({clkph_15,clkph_13,clkph_11,clkph_9}),
		.i_clk_oddphsel_stg1_evn({clkphsel_stg1_evn[7],clkphsel_stg1_evn[5],clkphsel_stg1_evn[3],clkphsel_stg1_evn[1]}),
		.i_clk_oddphsel_stg1_odd({clkphsel_stg1_odd[7],clkphsel_stg1_odd[5],clkphsel_stg1_odd[3],clkphsel_stg1_odd[1]}),
		.i_clk_oddphsel_stg2_evn(phsel_stg2_bb_evn[1]),
		.i_clk_oddphsel_stg2_odd(phsel_stg2_bb_odd[1]),
		.i_nbias(i_nbias),
		.i_nbias_trim(nbias_trim),
		.i_pbias(i_pbias),
		.i_pbias_trim(pbias_trim),
		.o_clk_evnph_evn(clkevn_evn),
		.o_clk_evnph_odd(clkevn_odd),
		.o_clk_oddph_evn(clkodd_evn),
		.o_clk_oddph_odd(clkodd_odd)
		);

aibio_pioddevn_mixer_top oddevn_mixer
		(
		.vddcq(vddcq),
		.vss(vss),
		.i_clkevn_evn(clkevn_evn),
		.i_clkevn_odd(clkevn_odd),
		.i_clkodd_evn(clkodd_evn),
		.i_clkodd_odd(clkodd_odd),
		.i_pien(i_pien),
		.i_pimixer_evn(pixer_evn),
		.i_pimixer_odd(pixer_odd),
		.i_clkph({clkph_15,clkph_14,clkph_13,clkph_12,clkph_11,clkph_10,clkph_9,clkph_8,clkph_7,clkph_6,clkph_5,clkph_4,clkph_3,clkph_2,clkph_1,clkph_0}),
		.i_pievn_code(i_picode_evn),
		.i_piodd_code(i_picode_odd),
		.ph_diff(ph_diff),
		.o_clk_evn(o_clkpi_evn),
		.o_clk_odd(o_clkpi_odd)
		);

endmodule
