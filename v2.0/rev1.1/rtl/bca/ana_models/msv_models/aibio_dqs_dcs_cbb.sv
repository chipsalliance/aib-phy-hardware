`timescale 1ps/1fs

module aibio_dqs_dcs_cbb
(
	//------Supply pins------//
	input vddc,
	input vssx,
	//------Input pins------//
	input clk,
	input [1:0] clkdiv,
	input clkn,
	input clkp,
	input dcs_en,
	input reset,
	input sel_clkp,
	input sel_clkn,
	input en_single_ended,
	input chopen,
	input dcs_dfx_en,
	input [2:0] dcs_anaviewsel,
	//------Output pins------//
	output reg dc_gt_50,
	output dc_gt_50_preflop,
	output ckph1,
	output dcs_anaviewout,
	//------Spare pins------//
	input [3:0] dcs_spare,
	output [3:0] o_dcs_spare
);

//------------Internal variables-------------//
reg[4:0] r_reg;
reg[4:0] r_nxt;
reg clk_int;
integer div_fac;
reg div_clk;
integer count;

reg ck_in;
real ck_in_period;
real ck_in_on_time;
real t1,t2,t3;

reg dc_gt_50_preflop_int;

reg flag_high;

initial begin
	r_reg = 'd0;
	clk_int = 1'b0;
	dc_gt_50_preflop_int = 1'b0;
	count = 0;
	div_clk = 1'b0;
	@(clk);
	@(clk);
	clk_int = 1'b1;
end


//-------------------Clk Division-------------------//
assign div_fac = (clkdiv == 2'b00) ? 4 :
					  (clkdiv == 2'b01) ? 8 :
					  (clkdiv == 2'b10) ? 2 :
					  (clkdiv == 2'b11) ? 16:
						1;

always @(posedge clk)
begin
	count = count+1;
	if(count == div_fac/2)
	begin
		div_clk = ~div_clk;
		count = 0;
	end
end

//--------------------------------------------------//


always @(en_single_ended or sel_clkp or sel_clkn or clkp or clkn)
begin
	if(en_single_ended == 1'b1)
	begin
		if(sel_clkp == 1'b1 && sel_clkn == 1'b0)
		begin
			ck_in = clkp;
		end
		else if(sel_clkp == 1'b0 && sel_clkn == 1'b1)
		begin
			ck_in = clkn;
		end
		else if(sel_clkp == 1'b1 && sel_clkn == 1'b1)
		begin
			$display("Error : Both sel_clkp & sel_clkn are high at the same time in single ended mode");
		end
	end
	else
	begin
		ck_in = clkp;
	end
end

//----------------Time period of ck_in---------------//
always @(ck_in)
begin
	t1=$realtime;
	if(ck_in == 1'b1)
	begin
		flag_high = 1'b1;
	end
	else
	begin
		flag_high = 1'b0;
	end
 	@(ck_in);
 	t2=$realtime;
 	@(ck_in);
 	t3=$realtime;
	ck_in_period = (t3-t1) ;
	if(flag_high)
	begin
		ck_in_on_time = (t2 - t1);
	end
	else
	begin
		ck_in_on_time = (t3 - t2);
	end
	dc_gt_50_preflop_int = (((ck_in_on_time / ck_in_period) * 100) > 50 ) ? 1'b1 : 1'b0;
end

assign dc_gt_50_preflop = (dcs_en == 1'b0 || reset == 1'b1) ? 1'b0 : dc_gt_50_preflop_int;

always @(posedge div_clk or reset or dcs_en)
begin
	if(reset === 1'b1 || dcs_en === 1'b0)
	begin
		dc_gt_50 = 1'b0;
	end
	else
	begin
		dc_gt_50 = dc_gt_50_preflop;
	end
end

assign ckph1 = (div_clk && (!reset));

endmodule



