`timescale 1ps/1fs

module aibio_pvtmon_ndmnn11 (
				//-----Supply Pins---//
				input logic vdd,
				input logic vss,
				
				//-----Input Pins---//
				input logic en,
				input logic clk_prev,
				
				//----Output pins----//
				output logic out
				);
				
parameter real temp=27;
parameter string corner="ttt";				

real n_Time_period;
genvar i;
logic [1:0]out_int;
logic osc_clk;
logic or_gate;


assign n_Time_period= ( temp == 27   &&  corner == "ttt" && en == 1'b1)?((1/1.18e9)*1e12):0;  //847.4576ps //---oscillator time period 

assign out_int[0]=( n_Time_period !=0)?out_int[1]:1'b0; 			

generate 	//---clock generation
 	for(i=0; i<1 ;i=i+1)
	begin
		not #(n_Time_period/2) (out_int[i+1],out_int[0]);
	end
endgenerate

assign osc_clk = en ? out_int[1] : vss; //---osc clock

assign out = (osc_clk | clk_prev) ; 
		
endmodule				
