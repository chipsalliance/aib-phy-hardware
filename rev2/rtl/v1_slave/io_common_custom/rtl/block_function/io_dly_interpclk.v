// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 

//---------------------------------------------------------------------------------------------------------------------------------------------
//  io_dly_interpclk
//---------------------------------------------------------------------------------------------------------------------------------------------

module io_dly_interpclk (
input         nfrzdrv,
input         fout_p,
input         fout_n,
output        a_in_p,
output        b_in_p,
output        c_in_p,
output        a_in_n,
output        b_in_n,
output        c_in_n
);

`ifdef TIMESCALE_EN
		timeunit 1ps; 
		timeprecision 1ps; 
`endif

parameter   NAND_DELAY = 20;

assign #(0 * NAND_DELAY) a_in_p = nfrzdrv? fout_p : 1'b0;
assign #(2 * NAND_DELAY) b_in_p = nfrzdrv? fout_p : 1'b0;
assign #(4 * NAND_DELAY) c_in_p = nfrzdrv? fout_p : 1'b0;

assign #(0 * NAND_DELAY) a_in_n = nfrzdrv? fout_n : 1'b1;
assign #(2 * NAND_DELAY) b_in_n = nfrzdrv? fout_n : 1'b1;
assign #(4 * NAND_DELAY) c_in_n = nfrzdrv? fout_n : 1'b1;

/*
io_interp_basecap xxcapap (
.cin	(a_in_p	)
);

io_interp_basecap xxcapbp (
.cin	(b_in_p	)
);

io_interp_basecap xxcapcp (
.cin	(c_in_p	)
);

io_interp_basecap xxcapan (
.cin	(a_in_n	)
);

io_interp_basecap xxcapbn (
.cin	(b_in_n	)
);

io_interp_basecap xxcapcn (
.cin	(c_in_n	)
);

*/

endmodule



