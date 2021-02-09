// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module io_phs_check (
input            rst_n,
input            sample_clk,
input      [7:0] ph_in,
output 	   [7:0] ph_and_sample,
output     [3:0] ph_sample 
);

`ifdef TIMESCALE_EN
                timeunit 1ps;
                timeprecision 1ps;
`endif

wire [7:0]  ph_and;       // and neighboring phases
wire [7:0]  ph_or;        // or neighboring phases

parameter  FF_DELAY = 100;

assign ph_and[7:0] = ph_in[7:0] & {ph_in[0],ph_in[7:1]};
assign ph_or[7:0] = {ph_in[3:0],ph_in[7:4]} | {ph_in[4:0],ph_in[7:5]};

io_phdet_ff_ln ph_sample_reg_0 (
.dp     ( ph_in[0] 	),
.dn     ( ph_in[4] 	),
.clk_p  ( sample_clk  	),
.rst_n  ( rst_n 	),
.q      ( ph_sample[0] 	)
);

io_phdet_ff_ln ph_sample_reg_1 (
.dp     ( ph_in[1] 	),
.dn     ( ph_in[5] 	),
.clk_p  ( sample_clk  	),
.rst_n  ( rst_n 	),
.q      ( ph_sample[1] 	)
);

io_phdet_ff_ln ph_sample_reg_2 (
.dp     ( ph_in[2] 	),
.dn     ( ph_in[6] 	),
.clk_p  ( sample_clk  	),
.rst_n  ( rst_n 	),
.q      ( ph_sample[2] 	)
);

io_phdet_ff_ln ph_sample_reg_3 (
.dp     ( ph_in[3] 	),
.dn     ( ph_in[7] 	),
.clk_p  ( sample_clk  	),
.rst_n  ( rst_n 	),
.q      ( ph_sample[3] 	)
);

io_phdet_ff_ln ph_and_sample_reg_0 (
.dp     ( ph_and[0]	 	),
.dn     ( ph_or[0]	 	),
.clk_p  ( sample_clk  		),
.rst_n  ( rst_n 		),
.q      ( ph_and_sample[0] 	)
);

io_phdet_ff_ln ph_and_sample_reg_1 (
.dp     ( ph_and[1]	 	),
.dn     ( ph_or[1]	 	),
.clk_p  ( sample_clk  		),
.rst_n  ( rst_n 		),
.q      ( ph_and_sample[1] 	)
);

io_phdet_ff_ln ph_and_sample_reg_2 (
.dp     ( ph_and[2]	 	),
.dn     ( ph_or[2]	 	),
.clk_p  ( sample_clk  		),
.rst_n  ( rst_n 		),
.q      ( ph_and_sample[2] 	)
);

io_phdet_ff_ln ph_and_sample_reg_3 (
.dp     ( ph_and[3]	 	),
.dn     ( ph_or[3]	 	),
.clk_p  ( sample_clk  		),
.rst_n  ( rst_n 		),
.q      ( ph_and_sample[3] 	)
);

io_phdet_ff_ln ph_and_sample_reg_4 (
.dp     ( ph_and[4]	 	),
.dn     ( ph_or[4]	 	),
.clk_p  ( sample_clk  		),
.rst_n  ( rst_n 		),
.q      ( ph_and_sample[4] 	)
);

io_phdet_ff_ln ph_and_sample_reg_5 (
.dp     ( ph_and[5]	 	),
.dn     ( ph_or[5]	 	),
.clk_p  ( sample_clk  		),
.rst_n  ( rst_n 		),
.q      ( ph_and_sample[5] 	)
);

io_phdet_ff_ln ph_and_sample_reg_6 (
.dp     ( ph_and[6]	 	),
.dn     ( ph_or[6]	 	),
.clk_p  ( sample_clk  		),
.rst_n  ( rst_n 		),
.q      ( ph_and_sample[6] 	)
);

io_phdet_ff_ln ph_and_sample_reg_7 (
.dp     ( ph_and[7]	 	),
.dn     ( ph_or[7]	 	),
.clk_p  ( sample_clk  		),
.rst_n  ( rst_n 		),
.q      ( ph_and_sample[7] 	)
);

endmodule
