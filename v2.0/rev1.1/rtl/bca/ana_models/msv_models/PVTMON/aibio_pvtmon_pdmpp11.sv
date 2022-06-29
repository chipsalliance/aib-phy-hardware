`timescale 1ps/1fs

module aibio_pvtmon_pdmpp11 (
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


real p_Time_period;
genvar i;
logic [1:0]out_int;
logic osc_clk;
logic or_gate;


assign p_Time_period= ( temp == 27   &&  corner == "ttt" && en == 1'b1)?((1/634e6)*1e12):0;  //1.5772870662ns

assign out_int[0]=(p_Time_period !=0)?out_int[1]:1'b0; 			

generate 
 	for(i=0; i<1 ;i=i+1)
	begin
		not #(p_Time_period/2) (out_int[i+1],out_int[0]);
	end
endgenerate


assign osc_clk = (  en==1'b1 ) ? out_int[1] : vss;
assign out = (osc_clk | clk_prev);
					
endmodule				
