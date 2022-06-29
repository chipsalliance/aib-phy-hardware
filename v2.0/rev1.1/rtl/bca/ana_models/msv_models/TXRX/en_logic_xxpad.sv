`timescale 1ps/1fs

module en_logic_xxpad
		(
		input data,
		input pwrgoodtx,
		input pwrgood,
		input rst_strap,
		input wk_pu_en,
		input wk_pd_en,
		input compen_n,
		input compen_p,
		input tx_en,
		input sdr_mode_en,
		input tx_async_en,
		input gen1_en,
		output reg pu_en_gen1,
		output reg pd_en_gen1,
		output reg pu_en_gen2,
		output reg pd_en_gen2,
		output reg wkpd_en,
		output reg wkpu_en
		);

wire pg;
wire compen;
wire wk_en;

assign pg = (pwrgoodtx && pwrgood);
assign compen = (compen_p ^ compen_n);
assign wk_en = (wk_pu_en ^ wk_pd_en);

always @(rst_strap,pg,wk_en,compen,tx_en,sdr_mode_en,tx_async_en,gen1_en,data)
begin
	if(rst_strap) 								//reset
	begin
		pu_en_gen1 = 1'b0;
		pd_en_gen1 = 1'b0;
		pu_en_gen2 = 1'b0;
		pd_en_gen2 = 1'b1;
		wkpd_en = 1'b0;
		wkpu_en = 1'b0;
	end
	else if(!pg) 								//pwrgoodtx and pwrgood invalid
	begin
		pu_en_gen1 = 1'b0;
		pd_en_gen1 = 1'b0;
		pu_en_gen2 = 1'b0;
		pd_en_gen2 = 1'b0;
		wkpd_en = 1'b0;
		wkpu_en = 1'b0;
	end
	else if(wk_en)
	begin
		if(wk_pu_en) 							//Weak PULL-UP
		begin
			pu_en_gen1 = 1'b0;
			pd_en_gen1 = 1'b0;
			pu_en_gen2 = 1'b0;
			pd_en_gen2 = 1'b0;
			wkpd_en = 1'b0;
			wkpu_en = 1'b1;
		end
		else if(wk_pd_en) 					//Weak PULL-DOWN
		begin
			pu_en_gen1 = 1'b0;
			pd_en_gen1 = 1'b0;
			pu_en_gen2 = 1'b0;
			pd_en_gen2 = 1'b0;
			wkpd_en = 1'b1;
			wkpu_en = 1'b0;
		end
	end
	else if(compen)
	begin
		if(compen_n) 							//rcomp_n
		begin
			pu_en_gen1 = 1'b0;
			pd_en_gen1 = 1'b0;
			pu_en_gen2 = 1'b1;
			pd_en_gen2 = 1'b1;
			wkpd_en = 1'b0;
			wkpu_en = 1'b0;
		end
		else if(compen_p) 					//rcomp_p
		begin
			pu_en_gen1 = 1'b1;
			pd_en_gen1 = 1'b1;
			pu_en_gen2 = 1'b0;
			pd_en_gen2 = 1'b0;
			wkpd_en = 1'b0;
			wkpu_en = 1'b0;
		end
	end
	else if(tx_async_en) 					//Async mode(Assumption ---> gen1_en is high): data here is async data
	begin
		pu_en_gen1 = (data == 1'b1) ? 1'b1 : 1'b0;
		pd_en_gen1 = (data == 1'b0) ? 1'b1 : 1'b0;
		pu_en_gen2 = 1'b0;
		pd_en_gen2 = 1'b0;
		wkpd_en = 1'b0;
		wkpu_en = 1'b0;
	end
	else if(!tx_en) 							//No Mode: Both tx_async_en & tx_en is low
	begin
		pu_en_gen1 = 1'b0;
		pd_en_gen1 = 1'b0;
		pu_en_gen2 = 1'b0;
		pd_en_gen2 = 1'b0;
		wkpd_en = 1'b0;
		wkpu_en = 1'b0;
	end
	else if(tx_en)								//tx_en : high
	begin
		if(sdr_mode_en)						//SDR Mode(Assumption ---> gen1_en is high) : Here data is even data
		begin
			pu_en_gen1 = (data == 1'b1) ? 1'b1 : 1'b0;
			pd_en_gen1 = (data == 1'b0) ? 1'b1 : 1'b0;
			pu_en_gen2 = 1'b0;
			pd_en_gen2 = 1'b0;
			wkpd_en = 1'b0;
			wkpu_en = 1'b0;
		end
		else
		begin
			if(gen1_en) 						//GEN1 Mode : Here data is serialised data
			begin
				pu_en_gen1 = (data == 1'b1) ? 1'b1 : 1'b0;
				pd_en_gen1 = (data == 1'b0) ? 1'b1 : 1'b0;
				pu_en_gen2 = 1'b0;
				pd_en_gen2 = 1'b0;
				wkpd_en = 1'b0;
				wkpu_en = 1'b0;
			end
			else 									//GEN2 Mode : Here data is serialised data
			begin
				pu_en_gen1 = 1'b0;
				pd_en_gen1 = 1'b0;
				pu_en_gen2 = (data == 1'b1) ? 1'b1 : 1'b0;
				pd_en_gen2 = (data == 1'b0) ? 1'b1 : 1'b0;
				wkpd_en = 1'b0;
				wkpu_en = 1'b0;
			end
		end
	end
end

endmodule
