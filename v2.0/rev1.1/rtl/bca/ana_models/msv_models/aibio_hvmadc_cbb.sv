`timescale 1ps/1fs

module aibio_hvmadc_cbb
(
	//------Supply pins------//
	input vddc,
	input vss,
	//------Input pins------//
	input adcclk,
	input [1:0] clkdiv,
	input real adc_anain[7:0],
	input [2:0] adc_anamux_sel,
	input adc_en,
	input reset,
	input adc_start,
	input chopen,
	input adc_dfx_en,
	input [2:0] adc_anaviewsel,
	//------Output pins------//
	output reg [9:0] adcout,
	output adcdone,
	output adc_anaviewout,
	//------Spare pins------//
	input [3:0] i_adc_spare,
	output [3:0] o_adc_spare
);

parameter integer CLK_CYCLES = 1024;
parameter real vref = 0.85;

reg[4:0] r_reg;
reg[4:0] r_nxt;
reg clk_int;
integer div_fac;
logic div_clk;

real inp;
real mux_out;
real inp_int;

reg flag;
integer clk_cnt;

reg eoc_int;
reg eoc;
wire [9:0] d;

initial begin
	r_reg = 'd0;
	clk_int = 1'b0;
	adcout = 'd0;
	eoc_int = 1'b0;
end

//-------------------Clk Division-------------------//
assign div_fac = (clkdiv == 2'b00) ? 4 :
					  (clkdiv == 2'b01) ? 8 :
					  (clkdiv == 2'b10) ? 2 :
					  (clkdiv == 2'b11) ? 16:
						1;

always @(posedge adcclk or posedge reset)
begin
	if(reset)
	begin
		r_reg <= 0;
		clk_int <= 1'b0;
	end
	else if(r_nxt == div_fac/2)
	begin
		r_reg <= 0;
		clk_int <= ~clk_int;
	end
	else
	begin
		r_reg <= r_nxt;
	end
end

assign r_nxt = r_reg + 1;
assign div_clk = clk_int;
//--------------------------------------------------//

//---------------MUX SELECTION-------------------//
always @(adc_anamux_sel)
	case (adc_anamux_sel)
   	3'b000 : mux_out = adc_anain[0];
      3'b001 : mux_out = adc_anain[1];
      3'b010 : mux_out = adc_anain[2];
      3'b011 : mux_out = adc_anain[3];
      3'b100 : mux_out = adc_anain[4];
      3'b101 : mux_out = adc_anain[5];
      3'b110 : mux_out = adc_anain[6];
      3'b111 : mux_out = adc_anain[7];
      default : mux_out = 0.0;
	endcase

assign inp = (adc_dfx_en == 1'b1) ? adc_anain[0] : mux_out;

//-----------------------------------------------//

always @(posedge adc_start)
begin
	inp_int = inp;
	clk_cnt = 0;
	flag = 1'b1;
end

always @(posedge div_clk)
begin
	if(flag == 1'b1)
	begin
		clk_cnt = clk_cnt + 1;
	end
	else
	begin
		clk_cnt = 0;
	end
end

always @(posedge div_clk)
begin
	if(clk_cnt > CLK_CYCLES && clk_int <= CLK_CYCLES + 1)
	begin
		eoc_int = 1'b1;
		flag = 1'b0;
	end
	else
	begin
		eoc_int = 1'b0;
	end
end

assign d = (inp_int > 0.85) ? 10'b11_1111_1111 :
				(inp_int < 0) 	 ? 10'b00_0000_0000 :
				((inp_int / vref) * 1024) ;

assign eoc = eoc_int && adc_en;

always @(posedge eoc or posedge reset)
begin
	if(reset)
	begin
		adcout = 'd0;
	end
	else
	begin
		adcout = d;
	end
end

assign adcdone = eoc && (!reset);

endmodule


