`timescale 1ps/1fs

module pad_out_logic
		(
		input rst,
		input pu_gen1,
		input pd_gen1,
		input pu_gen2,
		input pd_gen2,
		input wkpu,
		input wkpd,
		output reg data_out
		);

always @(rst,wkpu,wkpd,pu_gen1,pd_gen1,pu_gen2,pd_gen2)
begin
	if(rst)
	begin
		data_out = 1'b0;
	end
	else if(wkpu)
	begin
		data_out = 1'b1;
	end
	else if(wkpd)
	begin
		data_out = 1'b0;
	end
	else if(pu_gen1 && pd_gen1)
	begin
		data_out = 1'bx;
	end
	else if(pu_gen2 && pd_gen2)
	begin
		data_out = 1'bx;
	end
	else if(pu_gen1 ^ pd_gen1)
	begin
		data_out = pu_gen1;
	end
	else if(pu_gen2 ^ pd_gen2)
	begin
		data_out = pu_gen2;
	end
	else
	begin
		data_out = 1'bz;
	end
end

endmodule
