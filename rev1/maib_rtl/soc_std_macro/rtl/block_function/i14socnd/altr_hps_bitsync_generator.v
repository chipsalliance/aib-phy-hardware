// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//****************************************************************************************
// � 2011 Altera Corporation. 
//
//****************************************************************************************

//------------------------------------------------------------------------
// Description: BITSYNC Generator
// 
// multi-bit signal through this macro, e.g: RESET == 3'b101 is supported
// Due to this is not supported on normal bitsync macro.
// 
//------------------------------------------------------------------------


module altr_hps_bitsync_generator #( parameter DWIDTH = 1, parameter [DWIDTH-1:0] RESET_VAL = 'd0 ) 
(
	input wire clk,				//clock
	input wire rst_n,			//async reset
	input wire [DWIDTH-1:0] data_in,	//data in
        output wire [DWIDTH-1:0] data_out	//data out
);

genvar i;

generate 
 for(i = 0; i < DWIDTH; i=i+1)
 begin: bit_sync_i
	if(RESET_VAL[i] == 1'b0)
	 begin
		altr_hps_bitsync #(.DWIDTH(1), .RESET_VAL(1'b0) ) bitsync_clr_inst (
			.clk(clk),
			.rst_n(rst_n),
			.data_in(data_in[i]),
			.data_out(data_out[i])
		);
	 end
	else
	 begin
		altr_hps_bitsync #(.DWIDTH(1), .RESET_VAL(1'b1) ) bitsync_pst_inst (
			.clk(clk),
			.rst_n(rst_n),
			.data_in(data_in[i]),
			.data_out(data_out[i])
		);
	 end
 end //end for     
endgenerate // endgenerate

endmodule // altr_hps_bitsync_generator
