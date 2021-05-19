// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//-----------------------------------------------------------------------------------------------//
//-----------------------------------------------------------------------------------------------//



module aib_avmm_adapt_csr (
output	reg [31:0] rx_0,
output	reg [31:0] rx_1,
output	reg [31:0] tx_0,
output	reg [31:0] tx_1,

//Bus Interface
input clk,

input reset,
input [15:0] writedata,
input read,
input write,
input [1:0] byteenable,
output reg [15:0] readdata,
output reg readdatavalid,
input [6:0] address

);

wire reset_n = !reset;	

// Protocol management
// combinatorial read data signal declaration
reg [15:0] rdata_comb;

// synchronous process for the read
always @(negedge reset_n ,posedge clk)  
   if (!reset_n) readdata[15:0] <= 16'h0; else readdata[15:0] <= rdata_comb[15:0];

// read data is always returned on the next cycle
always @(negedge reset_n , posedge clk)
   if (!reset_n) readdatavalid <= 1'b0; else readdatavalid <= read;
//
//  Protocol specific assignment to inside signals
//
wire        we = write;
wire        re = read;
wire [6:0]  addr = address[6:0];
wire [15:0] din  = writedata [15:0];

// A write byte enable for each register

wire	[1:0]  we_rx_0_lo = we & (addr[6:0] == 7'h08) ? byteenable[1:0] : {2{1'b0}};
wire	[1:0]  we_rx_0_hi = we & (addr[6:0] == 7'h0a) ? byteenable[1:0] : {2{1'b0}};
wire	[1:0]  we_rx_1_lo = we & (addr[6:0] == 7'h10) ? byteenable[1:0] : {2{1'b0}};
wire	[1:0]  we_rx_1_hi = we & (addr[6:0] == 7'h12) ? byteenable[1:0] : {2{1'b0}};
wire	[1:0]  we_tx_0_lo = we & (addr[6:0] == 7'h18) ? byteenable[1:0] : {2{1'b0}};
wire	[1:0]  we_tx_0_hi = we & (addr[6:0] == 7'h1a) ? byteenable[1:0] : {2{1'b0}};
wire	[1:0]  we_tx_1_lo = we & (addr[6:0] == 7'h1c) ? byteenable[1:0] : {2{1'b0}};
wire	[1:0]  we_tx_1_hi = we & (addr[6:0] == 7'h1e) ? byteenable[1:0] : {2{1'b0}};

// A read byte 	enable for each register


always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      rx_0[31:0] <= 32'h00000000;
   end
   else begin
      if (we_rx_0_lo[0]) begin 
         rx_0[7:0]   <=  din[7:0];  
      end
      if (we_rx_0_lo[1]) begin 
         rx_0[15:8]  <=  din[15:8];  
      end
      if (we_rx_0_hi[0]) begin 
         rx_0[23:16] <=  din[7:0]; 
      end
      if (we_rx_0_hi[1]) begin 
         rx_0[31:24] <=  din[15:8];
      end
end

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      rx_1[31:0]<= 32'h00000000;
   end
   else begin
      if (we_rx_1_lo[0]) begin  
         rx_1[7:0]   <=  din[7:0];  
      end
      if (we_rx_1_lo[1]) begin         
         rx_1[15:8]  <=  din[15:8];  
      end
      if (we_rx_1_hi[0]) begin          
         rx_1[23:16] <=  din[7:0];  
      end
      if (we_rx_1_hi[1]) begin          
         rx_1[31:24] <=  din[15:8];  
      end
end

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      tx_0[31:0] <= 32'h00000000;
   end
   else begin
      if (we_tx_0_lo[0]) begin  
         tx_0[7:0]   <=  din[7:0];  
      end
      if (we_tx_0_lo[1]) begin         
         tx_0[15:8]  <=  din[15:8];  
      end
      if (we_tx_0_hi[0]) begin          
         tx_0[23:16] <=  din[7:0];  
      end
      if (we_tx_0_hi[1]) begin          
         tx_0[31:24] <=  din[15:8];  
      end
end


always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      tx_1[31:0]<= 32'h00000000;
   end
   else begin
      if (we_tx_1_lo[0]) begin
         tx_1[7:0]   <=  din[7:0];
      end
      if (we_tx_1_lo[1]) begin
         tx_1[15:8]  <=  din[15:8];
      end
      if (we_tx_1_hi[0]) begin
         tx_1[23:16] <=  din[7:0];
      end
      if (we_tx_1_hi[1]) begin
         tx_1[31:24] <=  din[15:8];
      end
end



// read process
always @ (*)
begin
rdata_comb = 16'h0;
   if(re) begin
      case (addr)  
	7'h08 : begin
		rdata_comb    = rx_0[15:0];
	end
	7'h0a : begin
		rdata_comb    = rx_0[31:16] ;
	end
        
	7'h10 : begin
		rdata_comb    = rx_1 [15:0] ;
	end
	7'h12 : begin
		rdata_comb    = rx_1 [31:16] ;
	end

	7'h18 : begin
		rdata_comb    = tx_0[15:0];
	end
	7'h1a : begin
		rdata_comb    = tx_0[31:16];
	end
	7'h1c : begin
		rdata_comb    = tx_1[15:0];
	end
	7'h1e : begin
		rdata_comb    = tx_1[31:16];
	end

	default : begin
		rdata_comb = 16'h0000;
	end
      endcase
   end
end

endmodule
