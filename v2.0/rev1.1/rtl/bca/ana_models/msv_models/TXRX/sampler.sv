`timescale 1ps/1fs

module sampler(data_in,rst,clk,data_out);

input data_in;
input rst;
input clk;
output data_out;

parameter t_setup = 0.0;
parameter t_hold = 0.0;
parameter t_clk2q = 0.0;

reg data_1;

reg sample_1,sample_2;
reg q1,q2,q3;
reg q3_prev;

wire clk_1;

real clk2q_delay;

assign #(t_setup) data_1 = data_in;
assign #(t_hold) clk_1 = clk;

always @(posedge clk or negedge rst)
begin
	if(rst == 1'b0)
	begin
		sample_1 = 1'b0;
	end
	else
	begin
		sample_1 = data_in;
	end
end

always @(posedge clk or negedge rst)
begin
	if(rst == 1'b0)
	begin
		sample_2 = 1'b0;
	end
	else
	begin
		sample_2 = data_1;
	end
end

always @(posedge clk_1 or negedge rst)
begin
	if(rst == 1'b0)
	begin
		q3 = 1'b0;
		q3_prev = 1'b0;
	end
	else
	begin
		q3 <= data_in;
		q3_prev <= q3;
	end
end

always @(posedge clk_1 or negedge rst)
begin
	if(rst == 1'b0)
	begin
		q1 = 1'b0;
	end
	else
	begin
		q1 = sample_1;
	end
end

always @(posedge clk_1 or negedge rst)
begin
	if(rst == 1'b0)
	begin
		q2 = 1'b0;
	end
	else
	begin
		q2 <= sample_2;
	end
end

assign clk2q_delay = (t_clk2q > t_hold) ? (t_clk2q - t_hold) : 0.0;

assign #(clk2q_delay) data_out = ((q1==q2) && (q2==q3) &&(q1==q3)) ? q3 : q3_prev;

endmodule


