`timescale 1ps/1fs

module aibio_pi_mixer_top
		(
		//--------Supply pins----------//
		input vddcq,
		input vss,
		//--------Input pins----------//
		input i_clkph_evn,
		input i_clkph_odd,
		input [7:0] i_oddph_en,
		input i_pien,
		input [15:0]i_clkph,
		input [7:0]i_picode,
		input real ph_diff,
		//--------Output pins----------//
		output o_clkmix_out
		);

logic clkmix_out_local;

logic [7:0] i_picode_sync;
logic [127:0] clk;

always @(i_oddph_en)
begin
	i_picode_sync <= i_picode;
end

clkgen i_clk_7_0
		(
		.i_clk(i_clkph[0]),
		.ph_diff(ph_diff),
		.o_clk(clk[7:0])
		);

clkgen i_clk_15_8
		(
		.i_clk(i_clkph[1]),
		.ph_diff(ph_diff),
		.o_clk(clk[15:8])
		);

clkgen i_clk_23_16
		(
		.i_clk(i_clkph[2]),
		.ph_diff(ph_diff),
		.o_clk(clk[23:16])
		);

clkgen i_clk_31_24
		(
		.i_clk(i_clkph[3]),
		.ph_diff(ph_diff),
		.o_clk(clk[31:24])
		);

clkgen i_clk_39_32
		(
		.i_clk(i_clkph[4]),
		.ph_diff(ph_diff),
		.o_clk(clk[39:32])
		);

clkgen i_clk_47_40
		(
		.i_clk(i_clkph[5]),
		.ph_diff(ph_diff),
		.o_clk(clk[47:40])
		);

clkgen i_clk_55_48
		(
		.i_clk(i_clkph[6]),
		.ph_diff(ph_diff),
		.o_clk(clk[55:48])
		);

clkgen i_clk_63_56
		(
		.i_clk(i_clkph[7]),
		.ph_diff(ph_diff),
		.o_clk(clk[63:56])
		);

clkgen i_clk_71_64
		(
		.i_clk(i_clkph[8]),
		.ph_diff(ph_diff),
		.o_clk(clk[71:64])
		);

clkgen i_clk_79_72
		(
		.i_clk(i_clkph[9]),
		.ph_diff(ph_diff),
		.o_clk(clk[79:72])
		);

clkgen i_clk_87_80
		(
		.i_clk(i_clkph[10]),
		.ph_diff(ph_diff),
		.o_clk(clk[87:80])
		);

clkgen i_clk_95_88
		(
		.i_clk(i_clkph[11]),
		.ph_diff(ph_diff),
		.o_clk(clk[95:88])
		);

clkgen i_clk_103_96
		(
		.i_clk(i_clkph[12]),
		.ph_diff(ph_diff),
		.o_clk(clk[103:96])
		);

clkgen i_clk_111_104
		(
		.i_clk(i_clkph[13]),
		.ph_diff(ph_diff),
		.o_clk(clk[111:104])
		);

clkgen i_clk_119_112
		(
		.i_clk(i_clkph[14]),
		.ph_diff(ph_diff),
		.o_clk(clk[119:112])
		);

clkgen i_clk_127_120
		(
		.i_clk(i_clkph[15]),
		.ph_diff(ph_diff),
		.o_clk(clk[127:120])
		);

assign clkmix_out_local = (i_pien) ? clk[i_picode_sync] : 1'b0;

assign o_clkmix_out = clkmix_out_local;

endmodule


module clkgen
	(
	input i_clk,
	input real ph_diff,
	output [7:0] o_clk
	);

assign #(0*(ph_diff/8.0)) o_clk[0] = i_clk;
assign #(1*(ph_diff/8.0)) o_clk[1] = i_clk;
assign #(2*(ph_diff/8.0)) o_clk[2] = i_clk;
assign #(3*(ph_diff/8.0)) o_clk[3] = i_clk;
assign #(4*(ph_diff/8.0)) o_clk[4] = i_clk;
assign #(5*(ph_diff/8.0)) o_clk[5] = i_clk;
assign #(6*(ph_diff/8.0)) o_clk[6] = i_clk;
assign #(7*(ph_diff/8.0)) o_clk[7] = i_clk;

endmodule
