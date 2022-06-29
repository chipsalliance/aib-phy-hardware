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
			input i_reset,
			input i_jtag_en,
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
			output o_dnb,
			output real ph_diff
		);

integer clk_count=0;
logic cdr_clk_int;

realtime DIFF_8_0_RISE_TIME;

realtime DIFF_4_0_RISE_TIME;
realtime DIFF_8_4_RISE_TIME;
realtime DIFF_12_8_RISE_TIME;
realtime DIFF_0_12_RISE_TIME;

realtime DIFF_2_0_RISE_TIME;
realtime DIFF_4_2_RISE_TIME;
realtime DIFF_6_4_RISE_TIME;
realtime DIFF_8_6_RISE_TIME;
realtime DIFF_10_8_RISE_TIME;
realtime DIFF_12_10_RISE_TIME;
realtime DIFF_14_12_RISE_TIME;
realtime DIFF_0_14_RISE_TIME;

realtime clkp_RISE_TIME;
realtime clkp16_RISE_TIME;

realtime ph0_RISE_TIME;
realtime ph2_RISE_TIME;
realtime ph4_RISE_TIME;
realtime ph6_RISE_TIME;
realtime ph8_RISE_TIME;
realtime ph10_RISE_TIME;
realtime ph12_RISE_TIME;
realtime ph14_RISE_TIME;

logic ph0_RISE_TIME_OK;
logic ph2_RISE_TIME_OK;
logic ph4_RISE_TIME_OK;
logic ph6_RISE_TIME_OK;
logic ph8_RISE_TIME_OK;
logic ph10_RISE_TIME_OK;
logic ph12_RISE_TIME_OK;
logic ph14_RISE_TIME_OK;

logic ph0;
logic ph1;
logic ph2;
logic ph3;
logic ph4;
logic ph5;
logic ph6;
logic ph7;
logic ph8;
logic ph9;
logic ph10;
logic ph11;
logic ph12;
logic ph13;
logic ph14;
logic ph15;

integer clkp_posedge_cnt = 0;
real jtag_delay = 10;
logic [15:0] jtag_clk_int;
logic [15:0] o_dll_clkphb_int;

initial begin
	DIFF_8_0_RISE_TIME = 10;
	DIFF_4_0_RISE_TIME = 10;
	DIFF_8_4_RISE_TIME = 10;
	DIFF_12_8_RISE_TIME = 10;
	DIFF_0_12_RISE_TIME = 10;
	DIFF_2_0_RISE_TIME = 10;
	DIFF_4_2_RISE_TIME = 10;
	DIFF_6_4_RISE_TIME = 10;
	DIFF_8_6_RISE_TIME = 10;
	DIFF_10_8_RISE_TIME = 10;
	DIFF_12_10_RISE_TIME = 10;
	DIFF_14_12_RISE_TIME = 10;
	DIFF_0_14_RISE_TIME = 10;

	ph0_RISE_TIME_OK = 1'b0;
	ph2_RISE_TIME_OK = 1'b0;
	ph4_RISE_TIME_OK = 1'b0;
	ph6_RISE_TIME_OK = 1'b0;
	ph8_RISE_TIME_OK = 1'b0;
	ph10_RISE_TIME_OK = 1'b0;
	ph12_RISE_TIME_OK = 1'b0;
	ph14_RISE_TIME_OK = 1'b0;

	clkp_RISE_TIME = 0;
	clkp16_RISE_TIME = 10;
	ph0_RISE_TIME = 0;
	ph2_RISE_TIME = 0;
	ph4_RISE_TIME = 0;
	ph6_RISE_TIME = 0;
	ph8_RISE_TIME = 0;
	ph10_RISE_TIME = 0;
	ph12_RISE_TIME = 0;
	ph14_RISE_TIME = 0;
	
	ph1 = 0;
	ph2 = 0;
	ph3 = 0;
	ph4 = 0;
	ph5 = 0;
	ph6 = 0;
	ph7 = 0;
	ph8 = 0;
	ph9 = 0;
	ph10 = 0;
	ph11 = 0;
	ph12 = 0;
	ph13 = 0;
	ph14 = 0;
	ph15 = 0;
end


assign ph0 = i_clkp;


always @(posedge i_clkp)
begin
	clkp_posedge_cnt = clkp_posedge_cnt + 1;
end

always @(posedge i_clkp)
begin
	if((clkp_posedge_cnt % 2) == 0)
	begin
		clkp_RISE_TIME <= $realtime;
	end
	else begin
		clkp16_RISE_TIME <= $realtime;
	end
end

always @(posedge ph0)
begin
	ph0_RISE_TIME <= $realtime;
	if($realtime > 50 && ph0_RISE_TIME_OK == 1'b0)
	begin
		ph0_RISE_TIME_OK <= 1'b1;
	end
	else if(($realtime - ph0_RISE_TIME) > 100000)
	begin
		ph0_RISE_TIME_OK <= 1'b0;
	end
	if(ph8_RISE_TIME_OK == 1'b1 && ($realtime - ph8_RISE_TIME) < 100000)
	begin
		DIFF_8_0_RISE_TIME <= $realtime - ph8_RISE_TIME;
	end
end


always @(posedge ph8)
begin
	ph8_RISE_TIME <= $realtime;
	if($realtime > 50 && ph8_RISE_TIME_OK == 1'b0)
	begin
		ph8_RISE_TIME_OK <= 1'b1;
	end
	else if(($realtime - ph8_RISE_TIME) > 100000)
	begin
		ph8_RISE_TIME_OK <= 1'b0;
	end
end

always @ph0
begin
	if((clkp_RISE_TIME - clkp16_RISE_TIME) > 0.0)
	begin
		ph8 <= #((clkp_RISE_TIME - clkp16_RISE_TIME) /2.0) ph0;
	end
	else if((clkp_RISE_TIME - clkp16_RISE_TIME) < 0.0)
	begin
		ph8 <= #((clkp16_RISE_TIME - clkp_RISE_TIME) /2.0) ph0;
	end
end


always @ph0
begin
	ph4 <= #(DIFF_8_0_RISE_TIME / 2.0) ph0;
end


always @ph8
begin
	ph12 <= #(DIFF_8_0_RISE_TIME / 2) ph8;
end

always @(posedge ph8)
begin
	if(ph4_RISE_TIME_OK == 1'b1 && ($realtime - ph4_RISE_TIME) < 100000)
	begin
		DIFF_8_4_RISE_TIME <= $realtime - ph4_RISE_TIME;
	end
end

always @(posedge ph12)
begin
	ph12_RISE_TIME <= $realtime;
	if($realtime > 50 && ph12_RISE_TIME_OK == 1'b0)
	begin
		ph12_RISE_TIME_OK <= 1'b1;
	end
	else if(($realtime - ph12_RISE_TIME) > 100000)
	begin
		ph12_RISE_TIME_OK <= 1'b0;
	end
	if(ph8_RISE_TIME_OK == 1'b1 && ($realtime - ph8_RISE_TIME) < 100000)
	begin
		DIFF_12_8_RISE_TIME <= $realtime - ph8_RISE_TIME;
	end
end

always @(posedge ph0)
begin
	if(ph12_RISE_TIME_OK == 1'b1 && ($realtime - ph12_RISE_TIME) < 100000)
	begin
		DIFF_0_12_RISE_TIME <= $realtime - ph12_RISE_TIME;
	end
end

always @(posedge ph4)
begin
	ph4_RISE_TIME <= $realtime;
	if($realtime > 50 && ph4_RISE_TIME_OK == 1'b0)
	begin
		ph4_RISE_TIME_OK <= 1'b1;
	end
	else if(($realtime - ph4_RISE_TIME) > 100000)
	begin
		ph4_RISE_TIME_OK <= 1'b0;
	end
	if(ph0_RISE_TIME_OK == 1'b1 && ($realtime - ph0_RISE_TIME) < 100000)
	begin
		DIFF_4_0_RISE_TIME <= $realtime - ph0_RISE_TIME;
	end
end // outputs

always @ph8
begin
	ph10 <= #(DIFF_12_8_RISE_TIME / 2.0) ph8; //Btw ~quadrature phase and ~in_phase
end

always @ph12
begin
	ph14 <= #(DIFF_0_12_RISE_TIME / 2.0) ph12; //Btw ~quadrature phase and in_phase
end

always @ph0
begin
	ph2 <= #(DIFF_4_0_RISE_TIME / 2.0) ph0; //Btw in-phase and quadrature phase
end

always @ph4
begin
	ph6 <= #(DIFF_8_4_RISE_TIME / 2.0) ph4; //Btw quadrature phase and ~in_phase
end


always @(posedge ph4)
begin
	if(ph2_RISE_TIME_OK == 1'b1 && ($realtime - ph2_RISE_TIME) < 100000)
	begin
		DIFF_4_2_RISE_TIME <= $realtime - ph2_RISE_TIME;
	end
end

always @(posedge ph6)
begin
	ph6_RISE_TIME <= $realtime;
	if($realtime > 50 && ph6_RISE_TIME_OK == 1'b0)
	begin
		ph6_RISE_TIME_OK <= 1'b1;
	end
	else if(($realtime - ph6_RISE_TIME) > 100000)
	begin
		ph6_RISE_TIME_OK <= 1'b0;
	end
	if(ph4_RISE_TIME_OK == 1'b1 && ($realtime - ph4_RISE_TIME) < 100000)
	begin
		DIFF_6_4_RISE_TIME <= $realtime - ph4_RISE_TIME;
	end
end

always @(posedge ph8)
begin
	if(ph6_RISE_TIME_OK == 1'b1 && ($realtime - ph6_RISE_TIME) < 100000)
	begin
		DIFF_8_6_RISE_TIME <= $realtime - ph6_RISE_TIME;
	end
end

always @(posedge ph10)
begin
	ph10_RISE_TIME <= $realtime;
	if($realtime > 50 && ph10_RISE_TIME_OK == 1'b0)
	begin
		ph10_RISE_TIME_OK <= 1'b1;
	end
	else if(($realtime - ph10_RISE_TIME) > 100000)
	begin
		ph10_RISE_TIME_OK <= 1'b0;
	end
	if(ph8_RISE_TIME_OK == 1'b1 && ($realtime - ph8_RISE_TIME) < 100000)
	begin
		DIFF_10_8_RISE_TIME <= $realtime - ph8_RISE_TIME;
	end
end

always @(posedge ph12)
begin
	if(ph10_RISE_TIME_OK == 1'b1 && ($realtime - ph10_RISE_TIME) < 100000)
	begin
		DIFF_12_10_RISE_TIME <= $realtime - ph10_RISE_TIME;
	end
end

always @(posedge ph14)
begin
	ph14_RISE_TIME <= $realtime;
	if($realtime > 50 && ph14_RISE_TIME_OK == 1'b0)
	begin
		ph14_RISE_TIME_OK <= 1'b1;
	end
	else if(($realtime - ph14_RISE_TIME) > 100000)
	begin
		ph14_RISE_TIME_OK <= 1'b0;
	end
	if(ph12_RISE_TIME_OK == 1'b1 && ($realtime - ph12_RISE_TIME) < 100000)
	begin
		DIFF_14_12_RISE_TIME <= $realtime - ph12_RISE_TIME;
	end
end

always @(posedge ph0)
begin
	if(ph14_RISE_TIME_OK == 1'b1 && ($realtime - ph14_RISE_TIME) < 100000)
	begin
		DIFF_0_14_RISE_TIME <= $realtime - ph14_RISE_TIME;
	end
end

always @(posedge ph2)
begin
	ph2_RISE_TIME <= $realtime;
	if($realtime > 50 && ph2_RISE_TIME_OK == 1'b0)
	begin
		ph2_RISE_TIME_OK <= 1'b1;
	end
	else if(($realtime - ph2_RISE_TIME) > 100000)
	begin
		ph2_RISE_TIME_OK <= 1'b0;
	end
	if(ph0_RISE_TIME_OK == 1'b1 && ($realtime - ph0_RISE_TIME) < 100000)
	begin
		DIFF_2_0_RISE_TIME <= $realtime - ph0_RISE_TIME;
	end
end // outputs

always @ph0
begin
	ph1 <= #(DIFF_2_0_RISE_TIME / 2.0) ph0;
end

always @ph2
begin
	ph3 <= #(DIFF_4_2_RISE_TIME / 2.0) ph2;
end

always @ph4
begin
	ph5 <= #(DIFF_6_4_RISE_TIME / 2.0) ph4;
end

always @ph6
begin
	ph7 <= #(DIFF_8_6_RISE_TIME / 2.0) ph6;
end

always @ph8
begin
	ph9 <= #(DIFF_10_8_RISE_TIME / 2.0) ph8;
end

always @ph10
begin
	ph11 <= #(DIFF_12_10_RISE_TIME / 2.0) ph10;
end

always @ph12
begin
	ph13 <= #(DIFF_14_12_RISE_TIME / 2.0) ph12;
end

always @ph14
begin
	ph15 <= #(DIFF_0_14_RISE_TIME / 2.0) ph14;
end

assign #(jtag_delay) jtag_clk_int[0] = !i_clkp;
assign #(jtag_delay) jtag_clk_int[1] = !i_clkp;
assign #(jtag_delay) jtag_clk_int[2] = !i_clkp;
assign #(jtag_delay) jtag_clk_int[3] = !i_clkp;
assign #(jtag_delay) jtag_clk_int[4] = !i_clkp;
assign #(jtag_delay) jtag_clk_int[5] = !i_clkp;
assign #(jtag_delay) jtag_clk_int[6] = !i_clkp;
assign #(jtag_delay) jtag_clk_int[7] = !i_clkp;
assign #(jtag_delay) jtag_clk_int[8] = !i_clkp;
assign #(jtag_delay) jtag_clk_int[9] = !i_clkp;
assign #(jtag_delay) jtag_clk_int[10] = !i_clkp;
assign #(jtag_delay) jtag_clk_int[11] = !i_clkp;
assign #(jtag_delay) jtag_clk_int[12] = !i_clkp;
assign #(jtag_delay) jtag_clk_int[13] = !i_clkp;
assign #(jtag_delay) jtag_clk_int[14] = !i_clkp;
assign #(jtag_delay) jtag_clk_int[15] = !i_clkp;

//-----------------OUTPUT---------------------
assign #(DIFF_2_0_RISE_TIME) o_dll_clkphb_int[0]  =  (i_dll_en) ? !ph0 : 1'b1 ;
assign #(DIFF_2_0_RISE_TIME) o_dll_clkphb_int[1]  =  (i_dll_en) ? !ph1 : 1'b1 ;
assign #(DIFF_2_0_RISE_TIME) o_dll_clkphb_int[2]  =  (i_dll_en) ? !ph2 : 1'b1 ;
assign #(DIFF_2_0_RISE_TIME) o_dll_clkphb_int[3]  =  (i_dll_en) ? !ph3 : 1'b1 ;
assign #(DIFF_2_0_RISE_TIME) o_dll_clkphb_int[4]  =  (i_dll_en) ? !ph4 : 1'b1 ;
assign #(DIFF_2_0_RISE_TIME) o_dll_clkphb_int[5]  =  (i_dll_en) ? !ph5 : 1'b1 ;
assign #(DIFF_2_0_RISE_TIME) o_dll_clkphb_int[6]  =  (i_dll_en) ? !ph6 : 1'b1 ;
assign #(DIFF_2_0_RISE_TIME) o_dll_clkphb_int[7]  =  (i_dll_en) ? !ph7 : 1'b1 ;
assign #(DIFF_2_0_RISE_TIME) o_dll_clkphb_int[8]  =  (i_dll_en) ? !ph8 : 1'b1 ;
assign #(DIFF_2_0_RISE_TIME) o_dll_clkphb_int[9]  =  (i_dll_en) ? !ph9 : 1'b1 ;
assign #(DIFF_2_0_RISE_TIME) o_dll_clkphb_int[10] =  (i_dll_en) ? !ph10 : 1'b1 ;
assign #(DIFF_2_0_RISE_TIME) o_dll_clkphb_int[11] =  (i_dll_en) ? !ph11 : 1'b1 ;
assign #(DIFF_2_0_RISE_TIME) o_dll_clkphb_int[12] =  (i_dll_en) ? !ph12 : 1'b1 ;
assign #(DIFF_2_0_RISE_TIME) o_dll_clkphb_int[13] =  (i_dll_en) ? !ph13 : 1'b1 ;
assign #(DIFF_2_0_RISE_TIME) o_dll_clkphb_int[14] =  (i_dll_en) ? !ph14 : 1'b1 ;
assign #(DIFF_2_0_RISE_TIME) o_dll_clkphb_int[15] =  (i_dll_en) ? !ph15 : 1'b1 ;

assign o_dll_clkphb[0] = i_jtag_en ? jtag_clk_int[0] : o_dll_clkphb_int[0];
assign o_dll_clkphb[1] = i_jtag_en ? jtag_clk_int[1] : o_dll_clkphb_int[1];
assign o_dll_clkphb[2] = i_jtag_en ? jtag_clk_int[2] : o_dll_clkphb_int[2];
assign o_dll_clkphb[3] = i_jtag_en ? jtag_clk_int[3] : o_dll_clkphb_int[3];
assign o_dll_clkphb[4] = i_jtag_en ? jtag_clk_int[4] : o_dll_clkphb_int[4];
assign o_dll_clkphb[5] = i_jtag_en ? jtag_clk_int[5] : o_dll_clkphb_int[5];
assign o_dll_clkphb[6] = i_jtag_en ? jtag_clk_int[6] : o_dll_clkphb_int[6];
assign o_dll_clkphb[7] = i_jtag_en ? jtag_clk_int[7] : o_dll_clkphb_int[7];
assign o_dll_clkphb[8] = i_jtag_en ? jtag_clk_int[8] : o_dll_clkphb_int[8];
assign o_dll_clkphb[9] = i_jtag_en ? jtag_clk_int[9] : o_dll_clkphb_int[9];
assign o_dll_clkphb[10] = i_jtag_en ? jtag_clk_int[10] : o_dll_clkphb_int[10];
assign o_dll_clkphb[11] = i_jtag_en ? jtag_clk_int[11] : o_dll_clkphb_int[11];
assign o_dll_clkphb[12] = i_jtag_en ? jtag_clk_int[12] : o_dll_clkphb_int[12];
assign o_dll_clkphb[13] = i_jtag_en ? jtag_clk_int[13] : o_dll_clkphb_int[13];
assign o_dll_clkphb[14] = i_jtag_en ? jtag_clk_int[14] : o_dll_clkphb_int[14];
assign o_dll_clkphb[15] = i_jtag_en ? jtag_clk_int[15] : o_dll_clkphb_int[15];



assign o_piclk_180 = !o_dll_clkphb[8];
assign o_piclk_90 = !o_dll_clkphb[4];


assign #(DIFF_2_0_RISE_TIME) cdr_clk_int = i_clkp_cdr;

assign o_cdr_clk = (i_dll_en) ? cdr_clk_int : 1'b1;

initial begin
	o_up =1'b0;
	o_dn = 1'b0;
end

always @(posedge i_clkp or negedge i_dll_en or posedge i_reset) begin
	if(!i_dll_en) begin
      o_dn = 1'b0;
   end
	else if(i_reset) begin
		o_dn = 1'b0;
	end
   else begin
		#50;
		o_dn = 1'b1;
		#50;
		o_dn = 1'b0;
   end
end

always @(posedge i_clkp or negedge i_dll_en or posedge i_reset) begin
	if(!i_dll_en) begin
   	o_up = 1'b0;
   end
	else if(i_reset) begin
		o_up = 0;
		clk_count = 0;
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

assign ph_diff = DIFF_2_0_RISE_TIME/2.0 ;

endmodule

