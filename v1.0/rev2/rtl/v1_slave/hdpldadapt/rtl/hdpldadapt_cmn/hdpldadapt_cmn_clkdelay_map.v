// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module hdpldadapt_cmn_clkdelay_map
(
        output  wire    	clkout,
	input	wire [3:0]	r_clk_delay_sel,
        input   wire    	clk
);

	reg [14:0]	rsel;
	wire		rsel0;
	wire		rsel1;
	wire		rsel2;
	wire		rsel3;
	wire		rsel4;
	wire		rsel5;
	wire		rsel6;
	wire		rsel7;
	wire		rsel8;
	wire		rsel9;
	wire		rsel10;
	wire		rsel11;
	wire		rsel12;
	wire		rsel13;
	wire		rsel14;

always @* 
begin
	case(r_clk_delay_sel)
	    4'b0000:	rsel = 15'b000_0000_0000_0000;
	    4'b0001:	rsel = 15'b000_0000_0000_0001;
	    4'b0010:	rsel = 15'b000_0000_0000_0011;
	    4'b0011:	rsel = 15'b000_0000_0000_0111;
	    4'b0100:	rsel = 15'b000_0000_0000_1111;
	    4'b0101:	rsel = 15'b000_0000_0001_1111;
	    4'b0110:	rsel = 15'b000_0000_0011_1111;
	    4'b0111:	rsel = 15'b000_0000_0111_1111;
	    4'b1000:	rsel = 15'b000_0000_1111_1111;
	    4'b1001:	rsel = 15'b000_0001_1111_1111;
	    4'b1010:	rsel = 15'b000_0011_1111_1111;
	    4'b1011:	rsel = 15'b000_0111_1111_1111;
	    4'b1100:	rsel = 15'b000_1111_1111_1111;
	    4'b1101:	rsel = 15'b001_1111_1111_1111;
	    4'b1110:	rsel = 15'b011_1111_1111_1111;
	    4'b1111:	rsel = 15'b111_1111_1111_1111;
	    default	rsel = 15'b000_0000_0000_0000;
	endcase

end

assign rsel0 = rsel[0];
assign rsel1 = rsel[1];
assign rsel2 = rsel[2];
assign rsel3 = rsel[3];
assign rsel4 = rsel[4];
assign rsel5 = rsel[5];
assign rsel6 = rsel[6];
assign rsel7 = rsel[7];
assign rsel8 = rsel[8];
assign rsel9 = rsel[9];
assign rsel10 = rsel[10];
assign rsel11 = rsel[11];
assign rsel12 = rsel[12];
assign rsel13 = rsel[13];
assign rsel14 = rsel[14];
	
hdpldadapt_cmn_clkdelay hdpldadapt_cmn_clkdelay
    (
        .rsel0(rsel0),
        .rsel1(rsel1),
        .rsel2(rsel2),
        .rsel3(rsel3),
        .rsel4(rsel4),
        .rsel5(rsel5),
        .rsel6(rsel6),
        .rsel7(rsel7),
        .rsel8(rsel8),
        .rsel9(rsel9),
        .rsel10(rsel10),
        .rsel11(rsel11),
        .rsel12(rsel12),
        .rsel13(rsel13),
        .rsel14(rsel14),
        .clk(clk),
        .clkout(clkout)
    );

endmodule // hdpldadapt_cmn_clkdelay_map
