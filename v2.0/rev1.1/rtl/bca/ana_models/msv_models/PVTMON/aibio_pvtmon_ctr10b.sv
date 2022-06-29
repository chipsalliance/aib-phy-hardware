`timescale 1ps/1fs

module aibio_pvtmon_ctr10b (
				//-----Supply Pins---//
				input logic vdd,
				input logic vss,
				
				//-----Input Pins---//
				input logic clkin,
				input logic din,
				input logic rb,
				input logic sat_en,
				
				//----Output pins----//
				output logic [9:0]ctrout,
				output logic ctr_running
				);



logic clk_and_1;
logic nand_1,nand_2,nand_3,nand_4,nand_5,nand_6,nor_1,nor_2,nor_3;

logic allone;
logic [9:0]c;
logic dout[9:0];


assign ctr_running = ~(sat_en & allone) ;
assign clk_and_1 = (clkin & ctr_running);


aibio_pvtmon_ctrunit i0(	.vdd(vdd),
				.vss(vss),
				.din(din),
				.rb(rb),
				.clk(clk_and_1),
				.dout(dout[0]),
				.ctrout(ctrout[0])
				);


aibio_pvtmon_ctrunit i1(	.vdd(vdd),
				.vss(vss),
				.din(dout[0]),
				.rb(rb),
				.clk(clk_and_1),
				.dout(dout[1]),
				.ctrout(ctrout[1])
				);
aibio_pvtmon_ctrunit i2(	.vdd(vdd),
				.vss(vss),
				.din(dout[1]),
				.rb(rb),
				.clk(clk_and_1),
				.dout(dout[2]),
				.ctrout(ctrout[2])
				);
aibio_pvtmon_ctrunit i3(	.vdd(vdd),
				.vss(vss),
				.din(dout[2]),
				.rb(rb),
				.clk(clk_and_1),
				.dout(dout[3]),
				.ctrout(ctrout[3])
				);								
aibio_pvtmon_ctrunit i4(	.vdd(vdd),
				.vss(vss),
				.din(dout[3]),
				.rb(rb),
				.clk(clk_and_1),
				.dout(dout[4]),
				.ctrout(ctrout[4])
				);
aibio_pvtmon_ctrunit i5(	.vdd(vdd),
				.vss(vss),
				.din(dout[4]),
				.rb(rb),
				.clk(clk_and_1),
				.dout(dout[5]),
				.ctrout(ctrout[5])
				);
aibio_pvtmon_ctrunit i6(	.vdd(vdd),
				.vss(vss),
				.din(dout[5]),
				.rb(rb),
				.clk(clk_and_1),
				.dout(dout[6]),
				.ctrout(ctrout[6])
				);
aibio_pvtmon_ctrunit i7(	.vdd(vdd),
				.vss(vss),
				.din(dout[6]),
				.rb(rb),
				.clk(clk_and_1),
				.dout(dout[7]),
				.ctrout(ctrout[7])
				);												
aibio_pvtmon_ctrunit i8(	.vdd(vdd),
				.vss(vss),
				.din(dout[7]),
				.rb(rb),
				.clk(clk_and_1),
				.dout(dout[8]),
				.ctrout(ctrout[8])
				);
aibio_pvtmon_ctrunit i9(	.vdd(vdd),
				.vss(vss),
				.din(dout[8]),
				.rb(rb),
				.clk(clk_and_1),
				.dout(dout[9]),
				.ctrout(ctrout[9])
				);				


assign c=ctrout;

assign nand_1 =~(c[9]&c[8]);
assign nand_2 = ~(c[7]&c[6]);
assign nor_1 = ~(nand_1 | nand_2);

assign nand_3 = ~(nor_1&c[5]);
assign nand_4 = ~(c[4]&c[3]);
assign nor_2 =~(nand_3 | nand_4);


assign nand_5 =~(nor_2 &c[2]);
assign nand_6 =~(c[1] & c[0]);
assign nor_3 = ~(nand_5 | nand_6);

assign allone = nor_3;
				
endmodule				
				
