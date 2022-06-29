`timescale 1ps/1fs
module aibio_pvtmon_digview(
				//-----Supply Pins---//
				input logic vdd,
				input logic vss,
				
				//-----Input Pins---//
				input logic dfx_en,
				input logic [7:0]dig_in,
				input logic [2:0]sel,
				
				//----Output pins----//
				output logic digview_out
				);



		  
		  
logic [2:0]sel_bf;
logic [7:0]stg1_out;
logic net2,net1;
logic [3:0]stg2_out;
logic [1:0]stg3_out;

assign 	digview_out = ~net1;
assign  net2 = dfx_en;
	  			   
assign sel_bf=sel;

assign stg1_out[0] = ~(net2 & dig_in[0]);
assign stg1_out[1] = ~(net2 & dig_in[1]);
assign stg1_out[2] = ~(net2 & dig_in[2]);
assign stg1_out[3] = ~(net2 & dig_in[3]);
assign stg1_out[4] = ~(net2 & dig_in[4]);
assign stg1_out[5] = ~(net2 & dig_in[5]);
assign stg1_out[6] = ~(net2 & dig_in[6]);
assign stg1_out[7] = ~(net2 & dig_in[7]);


mux2x1 i1(	.vdd(vdd),
		.vss(vss),
		
		.in({stg1_out[4],stg1_out[0]}),
		.s(sel_bf[2]),
		.out(stg2_out[0])
	);


mux2x1 i2(	.vdd(vdd),
		.vss(vss),
		
		.in({stg1_out[5],stg1_out[1]}),
		.s(sel_bf[2]),
		.out(stg2_out[1])
	);

mux2x1 i3(	.vdd(vdd),
		.vss(vss),
		
		.in({stg1_out[6],stg1_out[2]}),
		.s(sel_bf[2]),
		.out(stg2_out[2])
	);
	
mux2x1 i4(	.vdd(vdd),
		.vss(vss),
		
		.in({stg1_out[7],stg1_out[3]}),
		.s(sel_bf[2]),
		.out(stg2_out[3])
	);
	
mux2x1 i5(	.vdd(vdd),
		.vss(vss),
		
		.in({stg3_out[1],stg3_out[0]}),
		.s(sel_bf[0]),
		.out(net1)
	);
	
mux2x1 i6(	.vdd(vdd),
		.vss(vss),
		
		.in({stg2_out[2],stg2_out[0]}),
		.s(sel_bf[1]),
		.out(stg3_out[0])
	);
	
mux2x1 i7(	.vdd(vdd),
		.vss(vss),
		
		.in({stg2_out[3],stg2_out[1]}),
		.s(sel_bf[1]),
		.out(stg3_out[1])
	);
					
endmodule				
