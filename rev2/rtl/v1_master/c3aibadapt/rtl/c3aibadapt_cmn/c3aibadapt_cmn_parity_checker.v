// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module c3aibadapt_cmn_parity_checker
    #(
	parameter WIDTH = 'd0   
    )   
    (
        output  reg			parity_error,
	input	wire			clk,
	input	wire			rst_n,
        input   wire [WIDTH-1:0]    	data,
	input	wire			parity_checker_ena,
	input	wire			parity_received
    );

	wire	parity_calculated;

	assign parity_calculated = ^data[WIDTH-1:0];

        always @(negedge rst_n or posedge clk)
        begin
                if (~rst_n)
                begin
			parity_error <= 1'b0;
                end
                else
                begin
                	parity_error <= parity_error || ( (parity_calculated != parity_received) && parity_checker_ena) ;
                end
        end

endmodule // c3aibadapt_cmn_parity_checker
