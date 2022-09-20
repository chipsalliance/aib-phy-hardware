`timescale 1ps/1fs

module aibio_cdr_detect
		(
		//----------Supply pins------------//
		input vddcq,
		input vss,
		//---------Input pins--------------//
		input i_cdr_clk,
		input i_piclk_90,
		input i_piclk_180,
		input i_sdr_mode,
		input i_reset,
		//---------Output pins-------------//
		output reg o_cdr_phdet
		);

wire clk_int;
wire rstb;

assign rstb = ~i_reset;

assign clk_int = (i_sdr_mode) ? i_piclk_180 : i_piclk_90;

`ifdef POST_WORST
	localparam t_setup = 0.0;
	localparam t_hold = 0.0;
	localparam t_clk2q = 0.0;
`else
	localparam t_setup = 0.0;
	localparam t_hold = 0.0;
	localparam t_clk2q = 0.0;
`endif

sampler #(t_setup,t_hold,t_clk2q)
			i_cdr_phdet
			(
			.data_in(i_cdr_clk),
			.clk(clk_int),
			.rst(rstb),
			.data_out(o_cdr_phdet)
			);
/*
always @(posedge clk_int or negedge rstb)
begin
	if(!rstb)
	begin
		o_cdr_phdet <= 1'b0;
	end
	else
	begin
		o_cdr_phdet <= i_cdr_clk;
	end
end
*/

endmodule
