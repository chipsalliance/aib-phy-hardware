// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
// (C) 2001-2012 Altera Corporation. .

//-----------------------------------
//2 stage flop synchronizer with AND clear
//DWIDTH | (this determine the width of the sync flop)
//The reset value is fixed to 1'b0 (not changeable)
//-----------------------------------

module altr_hps_sync_clr
#(parameter DWIDTH='d1)
(
  input clk,				//main clk signal
  input rst_n,				//main reset signal
  input clr,				//active high clear signal (expected this clear signal to be quasi-static)
  input [DWIDTH-1:0] data_in,		//data in
  output [DWIDTH-1:0] data_out		//data out
);

`ifdef ALTR_HPS_INTEL_MACROS_OFF

reg [DWIDTH-1:0] dff1;
reg [DWIDTH-1:0] dff2;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n) 
	begin
		dff1 <= {DWIDTH{1'b0}};
		dff2 <= {DWIDTH{1'b0}};
	end
	else
	begin
		dff1 <= data_in & ~clr;
		dff2 <= dff1 & ~clr;	
	end
end

assign data_out = dff2;

`else

`endif

endmodule
