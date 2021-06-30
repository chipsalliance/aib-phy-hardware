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
input [31:0] writedata,
input read,
input write,
input [3:0] byteenable,
output reg [31:0] readdata,
output reg readdatavalid,
input [6:0] address

);

wire reset_n = !reset;	

// Protocol management
// combinatorial read data signal declaration
reg [31:0] rdata_comb;

// synchronous process for the read
always @(negedge reset_n ,posedge clk)  
   if (!reset_n) readdata[31:0] <= 32'h0; else readdata[31:0] <= rdata_comb[31:0];

// read data is always returned on the next cycle
always @(negedge reset_n , posedge clk)
   if (!reset_n) readdatavalid <= 1'b0; else readdatavalid <= read;
//
//  Protocol specific assignment to inside signals
//
wire        we = write;
wire        re = read;
wire [6:0]  addr = address[6:0];
wire [31:0] din  = writedata [31:0];

// A write byte enable for each register

wire	[3:0]  we_rx_0 = we & (addr[6:0] == 7'h08) ? byteenable[3:0] : {4{1'b0}};
wire	[3:0]  we_rx_1 = we & (addr[6:0] == 7'h10) ? byteenable[3:0] : {4{1'b0}};
wire	[3:0]  we_tx_0 = we & (addr[6:0] == 7'h18) ? byteenable[3:0] : {4{1'b0}};
wire	[3:0]  we_tx_1 = we & (addr[6:0] == 7'h1c) ? byteenable[3:0] : {4{1'b0}};

// A read byte 	enable for each register


always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      rx_0[31:0] <= 32'h00000000;
   end
   else begin
      if (we_rx_0[0]) begin 
         rx_0[7:0]   <=  din[7:0];  
      end
      if (we_rx_0[1]) begin 
         rx_0[15:8]  <=  din[15:8];  
      end
      if (we_rx_0[2]) begin 
         rx_0[23:16] <=  din[23:16]; 
      end
      if (we_rx_0[3]) begin 
         rx_0[31:24] <=  din[31:24];
      end
end

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      rx_1[31:0]<= 32'h00000000;
   end
   else begin
      if (we_rx_1[0]) begin  
         rx_1[7:0]   <=  din[7:0];  
      end
      if (we_rx_1[1]) begin         
         rx_1[15:8]  <=  din[15:8];  
      end
      if (we_rx_1[2]) begin          
         rx_1[23:16] <=  din[23:16];  
      end
      if (we_rx_1[3]) begin          
         rx_1[31:24] <=  din[31:24];  
      end
end

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      tx_0[31:0] <= 32'h00000000;
   end
   else begin
      if (we_tx_0[0]) begin  
         tx_0[7:0]   <=  din[7:0];  
      end
      if (we_tx_0[1]) begin         
         tx_0[15:8]  <=  din[15:8];  
      end
      if (we_tx_0[2]) begin          
         tx_0[23:16] <=  din[23:16];  
      end
      if (we_tx_0[3]) begin          
         tx_0[31:24] <=  din[31:24];  
      end
end


always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      tx_1[31:0]<= 32'h00000000;
   end
   else begin
      if (we_tx_1[0]) begin
         tx_1[7:0]   <=  din[7:0];
      end
      if (we_tx_1[1]) begin
         tx_1[15:8]  <=  din[15:8];
      end
      if (we_tx_1[2]) begin
         tx_1[23:16] <=  din[23:16];
      end
      if (we_tx_1[3]) begin
         tx_1[31:24] <=  din[31:24];
      end
end



// read process
always @ (*)
begin
rdata_comb = 32'h0;
   if(re) begin
      case (addr)  
	7'h08 : begin
		rdata_comb [1:0]   = rx_0[1:0];
		rdata_comb [26:24] = rx_0[26:24] ;
	end
	7'h10 : begin
		rdata_comb [7:0] = rx_1 [7:0] ;
	end
	7'h18 : begin
		rdata_comb [1:0]   = tx_0[1:0];
		rdata_comb [23:16] = tx_0[23:16];
		rdata_comb [31:28] = tx_0[31:28];
	end
	7'h1c : begin
		rdata_comb [15:14]= tx_1[15:14];
	end
	default : begin
		rdata_comb = 32'h00000000;
	end
      endcase
   end
end

endmodule
