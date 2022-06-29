`timescale 1ps/1fs

module aibio_pvtmon_clkdiv ( 	
				//-----Supply Pins---//
				input logic vdd,
				input logic vss,
				
				//-----Input Pins---//
				input logic clkin,
				input logic [2:0]clkdiv_sel,
				
				//----Output pins----//
				output logic clkout
				);
				
logic [7:0]divsel;
logic net12;
logic net3;
logic net2,net6;
logic net25,net29,net34,net39,net44,net49,net54,net5,net4,net9,net11;
logic clkby64,clkby32,clkby16,clkby8,clkby4,clkby2;

aibio_pvtmon_3to8dec Dec(
				.vdd(vdd),
				.vss(vss),
				.sel(clkdiv_sel),
				.out(divsel)
				);

aibio_pvtmon_clk_divby2  i_clkby64(
				.vdd(vdd),
				.vss(vss),
				.clk(clkby32),
				.rb(net12),
				
				.clkout(clkby64)
				);
aibio_pvtmon_clk_divby2  i_clkby32(
				.vdd(vdd),
				.vss(vss),
				.clk(clkby16),
				.rb(net12),
				
				.clkout(clkby32)
				);

aibio_pvtmon_clk_divby2  i_clkby16(
				.vdd(vdd),
				.vss(vss),
				.clk(clkby8),
				.rb(net12),
				
				.clkout(clkby16)
				);

aibio_pvtmon_clk_divby2  i_clkby8(
				.vdd(vdd),
				.vss(vss),
				.clk(clkby4),
				.rb(net12),
				
				.clkout(clkby8)
				);
				

aibio_pvtmon_clk_divby2  i_clkby4(
				.vdd(vdd),
				.vss(vss),
				.clk(clkby2),
				.rb(net12),
				
				.clkout(clkby4)
				);
				
aibio_pvtmon_clk_divby2  i_clkby2(
				.vdd(vdd),
				.vss(vss),
				.clk(clkin),
				.rb(net12),
				
				.clkout(clkby2)
				);
				
				

assign net11= ~(net6 & net3);
assign net9 = ~(net39 &net49);
assign net4= ~(net34 & net44);
assign net5= ~(net25 & net29);

assign net54= ~(clkin & divsel[0]);
assign net49= ~(clkby2 & divsel[1]);
assign net44= ~(clkby8 & divsel[3]);
assign net39= ~(clkby4 & divsel[2]);
assign net34= ~(clkby16 & divsel[4]);
assign net29= ~(clkby32 & divsel[5]);
assign net25= ~(clkby64 & divsel[6]);

assign net2=~net54;
assign net6= ~(net9 | net2);
assign net3= ~(net5 | net4);
assign clkout = net11;
assign net12 = ~vss;

endmodule

