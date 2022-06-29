`timescale 1ps/1fs

module aibio_pvtmon_dig (
				//-----Supply Pins---//
				input logic vdd,
				input logic vss,
				
				//-----Input Pins---//
				input logic clkosc,
				input logic clkref,
				input logic count_start,
				input logic en,
				input logic [2:0]oscdiv,
				input logic [2:0]refdiv,
				
				input logic dfx_en,
				input logic [2:0]digview_sel,
				
				//----Output pins----//
				output logic count_done,
				output logic [9:0]codeout,
				output logic digviewout
				);
				
				
				
				
				



logic softone;
logic [9:0]refctr;
logic net2;
logic start_sync;
logic clkref_div_gated;
logic clkosc_div_gated;
logic clkref_gated;
logic clkosc_div;
logic clkref_div;

aibio_pvtmon_ctr10b aibio_pvtmon_ctr10b_ref(
					.vdd(vdd),
					.vss(vss),
					.clkin(clkref_div_gated),
					.din(softone),
					.rb(start_sync),
					.sat_en(softone),
					
					.ctrout(refctr),
					.ctr_running()
					);

aibio_pvtmon_ctr10b aibio_pvtmon_ctr10b_osc(
					.vdd(vdd),
					.vss(vss),
					.clkin(clkosc_div_gated),
					.din(softone),
					.rb(start_sync),
					.sat_en(softone),
					
					.ctrout(codeout),
					.ctr_running()
					);					

aibio_pvtmon_clkdiv oscclk_div(
				.vdd(vdd),
				.vss(vss),
				.clkin(clkosc),
				.clkdiv_sel(oscdiv),
				
				 .clkout(clkosc_div)
				 );

aibio_pvtmon_clkdiv refclk_div(
				.vdd(vdd),
				.vss(vss),
				.clkin(clkref_gated),
				.clkdiv_sel(refdiv),
				
				 .clkout(clkref_div)
				 );
assign softone = ~vss;
assign net2 = ~refctr[5];
assign count_done = ~net2;

DFF fpn00(
		.vdd(vdd),
		.vss(vss),
		.clk(clkref_gated),
		.rb(en),
		.d(count_start),
		.o(start_sync)
		);
		



assign clkref_div_gated = (net2 & clkref_div);
assign clkosc_div_gated = (net2 & clkosc_div);
assign clkref_gated = (en & clkref);



aibio_pvtmon_digview 	digview(
				.vdd(vdd),
				.vss(vss),
				.dfx_en(dfx_en),
				.sel(digview_sel),
				.dig_in({vss,vss,vss,vss,vss,clkref_div,clkosc_div,start_sync}),
				.digview_out(digviewout)
				);


endmodule				


				
