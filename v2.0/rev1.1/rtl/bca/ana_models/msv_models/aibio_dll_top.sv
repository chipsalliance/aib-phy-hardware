`timescale 1ps/1fs

module aibio_dll_top
			(
			//------Supply pins--------//
			input vddcq,
			input vss,
			//------Input pins--------//
			input i_clkp,
			input i_clkn,
			input i_clkp_cdr,
			input i_clkn_cdr,
			input [3:0] i_dll_biasctrl,
			input [4:0] i_dll_capctrl,
			input i_dll_en,
			input i_dll_enb,
			//-------Output pins--------//
			output [15:0] o_dll_clkphb,
			output o_piclk_180,
			output o_piclk_90,
			output o_cdr_clk,
			output o_pbias,
			output o_nbias,
			output reg o_up,
			output reg o_dn,
			output o_upb,
			output o_dnb
			);

reg ph0,ph1,ph2,ph3,ph4,ph5,ph6,ph7,ph8,ph9,ph10,ph11,ph12,ph13,ph14,ph15,cdr_clk_int;
real t1,t2,t3,time_period_ck_inp,phase_delay_ck_inp;
integer clk_count=0;

//----------------Time period of CLKP---------------
always @(i_clkp)
	begin
	t1=$realtime;
 	@(i_clkp);
 	t2=$realtime;
 	@(i_clkp);
 	t3=$realtime;
	time_period_ck_inp = (t3-t1) ;
	end

assign phase_delay_ck_inp = time_period_ck_inp/16; //--------Phase delay calculation

//-------------Output logic for 16 phase clock-------------------------//
always @(i_clkp)
begin
	if(phase_delay_ck_inp > 0.0)
	begin
		ph0 <= #(2*phase_delay_ck_inp) i_clkp;
		ph1 <= #(3*phase_delay_ck_inp) i_clkp;
		ph2 <= #(4*phase_delay_ck_inp) i_clkp;
		ph3 <= #(5*phase_delay_ck_inp) i_clkp;
		ph4 <= #(6*phase_delay_ck_inp) i_clkp;
		ph5 <= #(7*phase_delay_ck_inp) i_clkp;
		ph6 <= #(8*phase_delay_ck_inp) i_clkp;
		ph7 <= #(9*phase_delay_ck_inp) i_clkp;
		ph8 <= #(10*phase_delay_ck_inp) i_clkp;
		ph9 <= #(11*phase_delay_ck_inp) i_clkp;
		ph10<= #(12*phase_delay_ck_inp) i_clkp;
		ph11<= #(13*phase_delay_ck_inp) i_clkp;
		ph12<= #(14*phase_delay_ck_inp) i_clkp;
		ph13<= #(15*phase_delay_ck_inp) i_clkp;
		ph14<= #(16*phase_delay_ck_inp) i_clkp;
		ph15<= #(17*phase_delay_ck_inp) i_clkp;
	end
	else
	begin
		ph0 <= 1'b0;
		ph1 <= 1'b0;
		ph2 <= 1'b0;
		ph3 <= 1'b0;
		ph4 <= 1'b0;
		ph5 <= 1'b0;
		ph6 <= 1'b0;
		ph7 <= 1'b0;
		ph8 <= 1'b0;
		ph9 <= 1'b0;
		ph10 <= 1'b0;
		ph11 <= 1'b0;
		ph12 <= 1'b0;
		ph13 <= 1'b0;
		ph14 <= 1'b0;
		ph15 <= 1'b0;
	end
end

//-----------------OUTPUT---------------------
assign o_dll_clkphb[0]  =  !ph0 && i_dll_en ;
assign o_dll_clkphb[1]  =  !ph1 && i_dll_en ;
assign o_dll_clkphb[2]  =  !ph2 && i_dll_en ;
assign o_dll_clkphb[3]  =  !ph3 && i_dll_en ;
assign o_dll_clkphb[4]  =  !ph4 && i_dll_en ;
assign o_dll_clkphb[5]  =  !ph5 && i_dll_en ;
assign o_dll_clkphb[6]  =  !ph6 && i_dll_en ;
assign o_dll_clkphb[7]  =  !ph7 && i_dll_en ;
assign o_dll_clkphb[8]  =  !ph8 && i_dll_en ;
assign o_dll_clkphb[9]  =  !ph9 && i_dll_en ;
assign o_dll_clkphb[10] =  !ph10 && i_dll_en ;
assign o_dll_clkphb[11] =  !ph11 && i_dll_en ;
assign o_dll_clkphb[12] =  !ph12 && i_dll_en ;
assign o_dll_clkphb[13] =  !ph13 && i_dll_en ;
assign o_dll_clkphb[14] =  !ph14 && i_dll_en ;
assign o_dll_clkphb[15] =  !ph15 && i_dll_en ;

assign o_piclk_180 = !o_dll_clkphb[8] && i_dll_en;
assign o_piclk_90 = !o_dll_clkphb[4] && i_dll_en;

always @(i_clkp_cdr)
begin
	if(phase_delay_ck_inp > 0.0)
	begin
		cdr_clk_int = #(2*phase_delay_ck_inp) i_clkp_cdr;
	end
	else
	begin
		cdr_clk_int = 1'b0;
	end
end

assign o_cdr_clk = cdr_clk_int && i_dll_en;

initial begin
	o_up =1'b0;
	o_dn = 1'b0;
end

always @(posedge i_clkp or negedge i_dll_en) begin
	if(!i_dll_en) begin
      o_dn = 1'b0;
   end
   else begin
		#50;
		o_dn = 1'b1;
		#50;
		o_dn = 1'b0;
   end
end

always @(posedge i_clkp or negedge i_dll_en) begin
	if(!i_dll_en) begin
		clk_count = 0;
   	o_up = 1'b0;
   end
   else begin
		clk_count = clk_count + 1;
		if(clk_count <= 10) begin
	      o_up = 1'b1;
			#100;
			o_up = 1'b0;
		end
		else if (clk_count > 10 && clk_count <= 20 ) begin
			#10;
	      o_up = 1'b1;
			#90;
			o_up = 1'b0;
		end
		else if (clk_count >20 && clk_count <= 30 ) begin
			#20;
	      o_up = 1'b1;
			#80;
			o_up = 1'b0;
		end
		else if (clk_count >30 && clk_count <= 40 ) begin
			#30;
	      o_up = 1'b1;
			#70;
			o_up = 1'b0;
		end
		else if (clk_count >40 && clk_count <= 50 ) begin
			#40;
	      o_up = 1'b1;
			#60;
			o_up = 1'b0;
		end
		else if (clk_count >50) begin
			#50;
	      o_up = 1'b1;
			#50;
			o_up = 1'b0;
		end
   end
end

assign o_upb = ~ o_up;
assign o_dnb = ~ o_dn;

endmodule

