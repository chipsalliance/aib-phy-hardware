// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module hdpldadapt_cmn_clkdelay_cell
(
        output  reg   	clkout,
	input	wire 	rsel0,
	input	wire 	rsel1,
	input	wire 	rsel2,
	input	wire 	rsel3,
	input	wire 	rsel4,
	input	wire 	rsel5,
	input	wire 	rsel6,
	input	wire 	rsel7,
	input	wire 	rsel8,
	input	wire 	rsel9,
	input	wire 	rsel10,
	input	wire 	rsel11,
	input	wire 	rsel12,
	input	wire 	rsel13,
	input	wire 	rsel14,
        input   wire   	clk
);

	wire	clk_delay0;
	wire	clk_delay1;
	wire	clk_delay2;
	wire	clk_delay3;
	wire	clk_delay4;
	wire	clk_delay5;
	wire	clk_delay6;
	wire	clk_delay7;
	wire	clk_delay8;
	wire	clk_delay9;
	wire	clk_delay10;
	wire	clk_delay11;
	wire	clk_delay12;
	wire	clk_delay13;
	wire	clk_delay14;
	wire	clk_delay15;

        assign clk_delay0 = clk;
        assign clk_delay1 = clk;
        assign clk_delay2 = clk;
        assign clk_delay3 = clk;
        assign clk_delay4 = clk;
        assign clk_delay5 = clk;
        assign clk_delay6 = clk;
        assign clk_delay7 = clk;
        assign clk_delay8 = clk;
        assign clk_delay9 = clk;
        assign clk_delay10 = clk;
        assign clk_delay11 = clk;
        assign clk_delay12 = clk;
        assign clk_delay13 = clk;
        assign clk_delay14 = clk;
        assign clk_delay15 = clk;

always @*
begin
        casez({rsel0,rsel1,rsel2,rsel3,rsel4,rsel5,rsel6,rsel7,rsel8,rsel9,rsel10,rsel11,rsel12,rsel13,rsel14})
            15'b0??_????_????_????:	clkout = clk_delay0;
            15'b10?_????_????_????:	clkout = clk_delay1;
            15'b110_????_????_????:	clkout = clk_delay2;
            15'b111_0???_????_????:	clkout = clk_delay3;
            15'b111_10??_????_????:	clkout = clk_delay4;
            15'b111_110?_????_????:	clkout = clk_delay5;
            15'b111_1110_????_????:	clkout = clk_delay6;
            15'b111_1111_0???_????:	clkout = clk_delay7;
            15'b111_1111_10??_????:	clkout = clk_delay8;
            15'b111_1111_110?_????:	clkout = clk_delay9;
            15'b111_1111_1110_????:	clkout = clk_delay10;
            15'b111_1111_1111_0???:	clkout = clk_delay11;
            15'b111_1111_1111_10??:	clkout = clk_delay12;
            15'b111_1111_1111_110?:	clkout = clk_delay13;
            15'b111_1111_1111_1110:	clkout = clk_delay14;
            15'b111_1111_1111_1111:	clkout = clk_delay15;
            default	clkout = clk;
        endcase

end


endmodule // hdpldadapt_cmn_clkdelay_cell
