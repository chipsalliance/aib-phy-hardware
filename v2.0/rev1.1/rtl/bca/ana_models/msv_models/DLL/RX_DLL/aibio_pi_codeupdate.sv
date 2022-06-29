`timescale 1ps/1fs

module aibio_pi_codeupdate
		(
 		input logic vddcq,
		input logic vss,
 		input logic i_clk,
 		input logic i_clk_en,
		input logic [7:0]i_clkphsel_stg1,
		input logic [1:0]i_clkphsel_stg2,
		input logic [7:0]i_pimixer,
		input logic i_update,
		input logic i_reset,
		output logic [7:0]o_clkphsel_stg1,
		output logic [1:0]o_clkphsel_stg2,
		output logic [7:0]o_pimixer
		);

logic net13;
logic net38;
logic net43;
logic enb;
logic resetb_combined;
logic ff1_out;
logic ff2_out;
logic ff1_outb;
logic ff2_outb;
logic enlatb;
logic enlat;

assign net13 = i_clk && i_clk_en ;
assign enb = ~i_clk_en;

nor U1(net43,enb,i_reset);

flop i_ff1
	(
	.vdd(vddcq),
	.vss(vss),
	.clk(net13),
	.rb(net43),
	.o(ff1_out),
	.in(i_update)
	);

flop i_ff2
	(
	.vdd(vddcq),
	.vss(vss),
	.clk(net13),
	.rb(net43),
	.o(ff2_out),
	.in(ff1_out)
	);

/*
always @(posedge net13 or resetb_combined)
begin
	if(resetb_combined == 1'b0)
	begin
		ff1_out = 1'b0;
	end
	else
	begin
		ff1_out = i_update;
	end
end

always @(posedge net13 or resetb_combined)
begin
	if(resetb_combined == 1'b0)
	begin
		ff2_out = 1'b0;
	end
	else
	begin
		ff2_out = ff1_out;
	end
end
*/
assign ff1_outb = ~ff1_out;
assign ff2_outb = ~ff2_out;

nand U2(net38,ff1_outb,net43);
nand U3(enlatb,ff2_outb,net38);

assign enlat = ~enlatb;

latch i_latch0_stg1
	(
	.vdd(vddcq),
	.vss(vss),
	.clk(enlat),
	.o(o_clkphsel_stg1[0]),
	.in(i_clkphsel_stg1[0])
	);

latch i_latch1_stg1
	(
	.vdd(vddcq),
	.vss(vss),
	.clk(enlat),
	.o(o_clkphsel_stg1[1]),
	.in(i_clkphsel_stg1[1])
	);

latch i_latch2_stg1
	(
	.vdd(vddcq),
	.vss(vss),
	.clk(enlat),
	.o(o_clkphsel_stg1[2]),
	.in(i_clkphsel_stg1[2])
	);
latch i_latch3_stg1
	(
	.vdd(vddcq),
	.vss(vss),
	.clk(enlat),
	.o(o_clkphsel_stg1[3]),
	.in(i_clkphsel_stg1[3])
	);
latch i_latch4_stg1
	(
	.vdd(vddcq),
	.vss(vss),
	.clk(enlat),
	.o(o_clkphsel_stg1[4]),
	.in(i_clkphsel_stg1[4])
	);
latch i_latch5_stg1
	(
	.vdd(vddcq),
	.vss(vss),
	.clk(enlat),
	.o(o_clkphsel_stg1[5]),
	.in(i_clkphsel_stg1[5])
	);
latch i_latch6_stg1
	(
	.vdd(vddcq),
	.vss(vss),
	.clk(enlat),
	.o(o_clkphsel_stg1[6]),
	.in(i_clkphsel_stg1[6])
	);

latch i_latch7_stg1
	(
	.vdd(vddcq),
	.vss(vss),
	.clk(enlat),
	.o(o_clkphsel_stg1[7]),
	.in(i_clkphsel_stg1[7])
	);

latch i_latch0_pimix
	(
	.vdd(vddcq),
	.vss(vss),
	.clk(enlat),
	.o(o_pimixer[0]),
	.in(i_pimixer[0])
	);

latch i_latch1_pimix
	(
	.vdd(vddcq),
	.vss(vss),
	.clk(enlat),
	.o(o_pimixer[1]),
	.in(i_pimixer[1])
	);

latch i_latch2_pimix
	(
	.vdd(vddcq),
	.vss(vss),
	.clk(enlat),
	.o(o_pimixer[2]),
	.in(i_pimixer[2])
	);

latch i_latch3_pimix
	(
	.vdd(vddcq),
	.vss(vss),
	.clk(enlat),
	.o(o_pimixer[3]),
	.in(i_pimixer[3])
	);
latch i_latch4_pimix
	(
	.vdd(vddcq),
	.vss(vss),
	.clk(enlat),
	.o(o_pimixer[4]),
	.in(i_pimixer[4])
	);
latch i_latch5_pimix
	(
	.vdd(vddcq),
	.vss(vss),
	.clk(enlat),
	.o(o_pimixer[5]),
	.in(i_pimixer[5])
	);
latch i_latch6_pimix
	(
	.vdd(vddcq),
	.vss(vss),
	.clk(enlat),
	.o(o_pimixer[6]),
	.in(i_pimixer[6])
	);

latch i_latch7_pimix
	(
	.vdd(vddcq),
	.vss(vss),
	.clk(enlat),
	.o(o_pimixer[7]),
	.in(i_pimixer[7])
	);

latch i_latch0_stg2
	(
	.vdd(vddcq),
	.vss(vss),
	.clk(enlat),
	.o(o_clkphsel_stg2[0]),
	.in(i_clkphsel_stg2[0])
	);

latch i_latch1_stg2
	(
	.vdd(vddcq),
	.vss(vss),
	.clk(enlat),
	.o(o_clkphsel_stg2[1]),
	.in(i_clkphsel_stg2[1])
	);
/*
always @(posedge enlat or resetb_combined)
begin
	if(resetb_combined == 1'b0)
	begin
		o_clkphsel_stg1 = 'd0;
	end
	else
	begin
		o_clkphsel_stg1 = i_clkphsel_stg1;
	end
end

always @(posedge enlat or resetb_combined)
begin
	if(resetb_combined == 1'b0)
	begin
		o_clkphsel_stg2 = 'd0;
	end
	else
	begin
		o_clkphsel_stg2 = i_clkphsel_stg2;
	end
end

always @(posedge enlat or resetb_combined)
begin
	if(resetb_combined == 1'b0)
	begin
		o_pimixer = 'd0;
	end
	else
	begin
		o_pimixer = i_pimixer;
	end
end
*/

endmodule


module flop
	(
	input logic vdd,
	input logic vss,
	input logic clk,
	input logic rb,
	input logic in,
	output logic o
	);

always @(posedge clk or negedge rb)
begin
	if(rb == 1'b0)
	begin
		o <= 'd0;
	end
	else
	begin
		o <= in;
	end
end

endmodule


module latch
	(
	input logic vdd,
	input logic vss,
	input logic clk,
	input logic in,
	output logic o
	);

always @(clk or in)
begin
	if(clk == 1'b1)
	begin
		o <= in;
	end
end

endmodule
