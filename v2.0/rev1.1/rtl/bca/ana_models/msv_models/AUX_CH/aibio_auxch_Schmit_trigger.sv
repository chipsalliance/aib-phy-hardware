`timescale 1ps/1fs

module aibio_auxch_Schmit_trigger
		(
		//-------Supply pins----------//
		input vddc,
		input vss,
		//-------Input pin-----------//
		input vin,
		//-------Output pin---------//
		output vout
		);

assign vout=vin;

endmodule
