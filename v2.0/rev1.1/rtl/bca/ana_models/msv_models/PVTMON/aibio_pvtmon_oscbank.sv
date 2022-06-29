`timescale 1ps/1fs

module aibio_pvtmon_oscbank(
				//-----Supply Pins---//
				input logic vdd,
				input logic vss,
				
				//-----Input Pins---//
				input logic en,
				input logic [2:0]osc_sel,
				
				//----Output pins----//
				output logic osc_out
				);
				
logic [2:0]net2;
logic pdmpp11_out;
logic [7:0]oscen;

aibio_pvtmon_3to8dec decoder(
			.vdd(vdd),
			.vss(vss),
			.sel(net2),
			.out(oscen)
			);


aibio_pvtmon_ndmnn11 ndmnn11 (
				.vdd(vdd),
				.vss(vss),
				
				.en(oscen[1]),
				.clk_prev(vss),
				
				.out(ndmnn11_out)
				);
				
				
aibio_pvtmon_pdmpp11 pdmpp11(
				.vdd(vdd),
				.vss(vss),
				
				.en(oscen[2]),
				.clk_prev(ndmnn11_out),
				
				.out(pdmpp11_out)
				);
				
				
assign net2[2]= (en && osc_sel[2]);
assign net2[1]= (en && osc_sel[1]);
assign net2[0]= (en && osc_sel[0]);
assign osc_out= pdmpp11_out;
											
endmodule				

				
