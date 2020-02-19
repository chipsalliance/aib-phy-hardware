// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module  altr_hps_1r1w_4x2_rfifo_async_write (
        	 write_clk,
        	 write_rst_n,
        	 wr_valid,
        	 w_data,
        	 write_ready,
        	 w_addr_gray_out,
    
        	 r_addr,
        	 r_addr_gray_in,
        	 r_data
    );
    
// General inputs and outputs
// ----------------------------------------------------
input	 		 write_clk;
input	 		 write_rst_n;
input	 		 wr_valid;
output    	 write_ready;        // Tell the source device the fifo is ready to write
input  [1:0] w_data;
output [2:0] w_addr_gray_out;   // write pointer flop the gray code for write ponter

input  [1:0] r_addr;
output [1:0] r_data;
input  [2:0] r_addr_gray_in;    // write pointer flop the gray code for write ponter

// -----------------------------------------------------------------------------------
// WRITE SIDE LOGIC
// -----------------------------------------------------------------------------------

// Write side wire and reg definition
// ----------------------------------------------------
reg    [1:0] r_data;
reg    [2:0]  w_addr; 					// write pointer
wire   [1:0]  w_data;
wire   [2:0]  w_addr_gray; 		   // write pointer gray code out
reg    [2:0]  w_addr_gray_out;      // write pointer flop the gray code for write ponter
wire          w_enable;					// read enable
wire          fifo_full;				// fifo full 

// read side wire and reg definition
// ----------------------------------------------------
wire   [2:0]  r_addr_gray_in; 		// read pointer gray code out
wire   [2:0]  r_addr_sync; 			// read pointer sync r_addr to write_clk 
wire   [2:0]  r_addr_bin; 			   // read pointer sync r_addr to write_clk 

// write counter increment when it is enabled 
// ----------------------------------------------------
always @(posedge write_clk or negedge write_rst_n)
begin
	 if (~write_rst_n) begin
		  w_addr[2:0] <= 3'd0;
	 end
	 else if (w_enable) begin
	     w_addr[2:0] <= w_addr[2:0] + 3'd1;
	 end
end

//----------------------------------------------------
altr_hps_bin2gray  bin2gray_w(
      .bin_in(w_addr[2:0]),
      .gray_out(w_addr_gray[2:0])
);

// Flop out the w_addr_gray_out
// --------------------------------------------------
always @(posedge write_clk or negedge write_rst_n)
begin
	 if (~write_rst_n)
	    w_addr_gray_out[2:0] <= 3'd0;
	 else 
	    w_addr_gray_out[2:0] <= w_addr_gray[2:0];
end

// Read address synced by write clk (two flop synchronizer)
// -----------------------------------------------------
altr_hps_bitsync 
  #(.DWIDTH(3),.RESET_VAL(0))
    r_pointer_sync (
        .clk(write_clk),
        .rst_n(write_rst_n),
        .data_in(r_addr_gray_in[2:0]),
        .data_out(r_addr_sync[2:0]) 
    );

// defparam  altr_hps_1r1w_4x2_rfifo_async_write.r_pointer_sync.DWIDTH=3'd3;
// defparam  altr_hps_1r1w_4x2_rfifo_async_write.r_pointer_sync.RESET_VAL=1'd1;

// gray to binary for read pointer
// ---------------------------------------------------------
altr_hps_gray2bin  gray2bin_rp (
	 .gray_in(r_addr_sync[2:0]),
	 .bin_out(r_addr_bin[2:0])
);

// generate the fifo full and write enable signals
// ----------------------------------------------------------------------------------
assign fifo_full    = (r_addr_bin[2] ^ w_addr[2]) & (r_addr_bin[1:0] == w_addr[1:0]);
assign w_enable     = wr_valid & !fifo_full;
assign write_ready  = !fifo_full;

// ----------------------------------------------------------------------------------
// define flop based memory 4x2
// ----------------------------------------------------------------------------------
reg    [1:0] mem0;
reg    [1:0] mem1;
reg    [1:0] mem2;
reg    [1:0] mem3;

// write the data into memory (flop based)
// ----------------------------------------------------
always @(posedge write_clk or negedge write_rst_n)
begin
	 if (~write_rst_n) begin
		  mem0[1:0] <= 2'd0;
		  mem1[1:0] <= 2'd0;
		  mem2[1:0] <= 2'd0;
		  mem3[1:0] <= 2'd0;
	 end
	 else if (w_enable) begin
		  case (w_addr[1:0])
		    2'b00 :   mem0[1:0]  <= w_data[1:0];
		    2'b01 :   mem1[1:0]  <= w_data[1:0];
		    2'b10 :   mem2[1:0]  <= w_data[1:0];
		    2'b11 :   mem3[1:0]  <= w_data[1:0];
		    default : mem0[1:0]  <= w_data[1:0];
		  endcase
	 end
end

// Read out the data (floped data) out
// ----------------------------------------------------
always @(*) begin
	    case (r_addr[1:0])
		   2'b00  : r_data[1:0] = mem0[1:0];
		   2'b01  : r_data[1:0] = mem1[1:0];
		   2'b10  : r_data[1:0] = mem2[1:0];
		   2'b11  : r_data[1:0] = mem3[1:0];
		   default: r_data[1:0] = 2'b00;
	    endcase
end

endmodule
