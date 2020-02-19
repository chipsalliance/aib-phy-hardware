// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module altr_hps_1r1w_4x2_rfifo_async_read (
        	 read_clk,
        	 read_rst_n,
        	 read_ready,
        	 r_data_in,
        	 r_data_out,
        	 w_addr_gray_in,
        	 r_addr_out,
        	 r_addr_gray_out,
        	 rd_valid
);

input	 		 read_clk;             // read clock
input	 		 read_rst_n;         // Read reset
input	 		 read_ready;       // read device is ready for read
input  [2:0] w_addr_gray_in; 	// write pointer gray code in
output       rd_valid;   			// read data valid
output [2:0] r_addr_gray_out;    // read pointer gray code floped for de-glitches
output [1:0] r_addr_out;    		// read pointer gray code floped for de-glitches

input  [1:0] r_data_in;  		// the read data in
output [1:0] r_data_out; 		// read data just pass through but we can pipeline a flop if the timing issue

// read side wire and reg definition
// ----------------------------------------------------
wire [2:0]  w_addr_gray_in; 		// write pointer gray code in
wire [2:0]  w_addr_sync; 		   // write pointer gray code in synchronized out
wire [2:0]  w_addr_bin; 		   // write pointer synced binary out
reg  [2:0]  r_addr;              // read pointer 
wire [2:0]  r_addr_gray; 		   // read pointer gray code 
wire [1:0]  r_addr_out; 		   // read pointer gray code 
reg  [2:0]  r_addr_gray_out;     // read pointer gray code floped for de-glitches
wire        r_enable;				// read enable
wire        fifo_empty;				// fifo empty 
wire        rd_valid;     			// Output data valid
wire [1:0]  r_data_in;    		// read pointer gray code floped for de-glitches
wire [1:0]  r_data_out;    		// read pointer gray code floped for de-glitches

//wire [1:0]  r_data_out;   		// read data just pass through but we can add a flop if the timing issue

assign r_addr_out[1:0] = r_addr[1:0];

// read counter increment when it is enabled 
// ----------------------------------------------------
always @(posedge read_clk or negedge read_rst_n)
begin
	 if (~read_rst_n) begin
		  r_addr[2:0] <= 3'd0;
	 end
	 else if (r_enable) begin
	     r_addr[2:0] <= r_addr[2:0] + 3'd1;
	 end
end

// ---------------------------------------------------------------------------------
// READ SIDE LOGIC
// ---------------------------------------------------------------------------------

//Using gray code
//----------------------------------------------------
altr_hps_bin2gray  bin2gray_r(
      .bin_in(r_addr[2:0]),
      .gray_out(r_addr_gray[2:0])
);

// Flop out the w_addr_gray_out
// --------------------------------------------------
always @(posedge read_clk or negedge read_rst_n)
begin
	 if (~read_rst_n)
	    r_addr_gray_out[2:0] <= 3'd0;
	 else 
	    r_addr_gray_out[2:0] <= r_addr_gray[2:0];
end

altr_hps_bitsync
   #(.DWIDTH(3),.RESET_VAL(0))
    w_pointer_sync (
        .clk(read_clk),
        .rst_n(read_rst_n),
        .data_in(w_addr_gray_in[2:0]),
        .data_out(w_addr_sync[2:0]) 
    );
// defparam altr_hps_1r1w_4x2_rfifo_async_read.w_pointer_sync.DWIDTH=3'd3;
// defparam altr_hps_1r1w_4x2_rfifo_async_read.w_pointer_sync.RESET_VAL=1'd0;

// gray to binary for read pointer
// ---------------------------------------------------------
altr_hps_gray2bin  gray2bin_wp (
	 .gray_in(w_addr_sync[2:0]),
	 .bin_out(w_addr_bin[2:0])
);

// compare logic for fifo empth and read enable signals
// ----------------------------------------------------------------------------------
assign fifo_empty = (w_addr_bin[2] == r_addr[2]) & (w_addr_bin[1:0] == r_addr[1:0]);
assign r_enable = read_ready & !fifo_empty;
assign rd_valid = !fifo_empty;

assign r_data_out[1:0] = rd_valid ? r_data_in[1:0] : 2'b00;

endmodule
