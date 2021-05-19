// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//-----------------------------------------------------------------------------------------------//
//-----------------------------------------------------------------------------------------------//



module aib_avmm_io_csr (
output	reg [31:0] redund_0,
output	reg [31:0] redund_1,
output	reg [31:0] redund_2,
output	reg [31:0] redund_3,

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

wire	[1:0]  we_redund_0_lo = we & (addr[6:0] == 7'h20) ? byteenable[1:0] : {2{1'b0}};
wire	[1:0]  we_redund_0_hi = we & (addr[6:0] == 7'h22) ? byteenable[1:0] : {2{1'b0}};
wire	[1:0]  we_redund_1_lo = we & (addr[6:0] == 7'h24) ? byteenable[1:0] : {2{1'b0}};
wire	[1:0]  we_redund_1_hi = we & (addr[6:0] == 7'h26) ? byteenable[1:0] : {2{1'b0}};
wire	[1:0]  we_redund_2_lo = we & (addr[6:0] == 7'h28) ? byteenable[1:0] : {2{1'b0}};
wire	[1:0]  we_redund_2_hi = we & (addr[6:0] == 7'h2a) ? byteenable[1:0] : {2{1'b0}};
wire	[1:0]  we_redund_3_lo = we & (addr[6:0] == 7'h1c) ? byteenable[1:0] : {2{1'b0}};
wire	[1:0]  we_redund_3_hi = we & (addr[6:0] == 7'h1e) ? byteenable[1:0] : {2{1'b0}};

// A read byte 	enable for each register


always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      redund_0[31:0] <= 32'h0000;
   end
   else begin
      if (we_redund_0_lo[0]) begin 
         redund_0[7:0]   <=  din[7:0];  
      end
      if (we_redund_0_lo[1]) begin 
         redund_0[15:8]  <=  din[15:8];  
      end
      if (we_redund_0_hi[0]) begin 
         redund_0[23:16] <=  din[7:0]; 
      end
      if (we_redund_0_hi[1]) begin 
         redund_0[31:24] <=  din[15:8];
      end
end


always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      redund_1[31:0]<= 32'h00000000;
   end
   else begin
      if (we_redund_1_lo[0]) begin  
         redund_1[7:0]   <=  din[7:0];  
      end
      if (we_redund_1_lo[1]) begin         
         redund_1[15:8]  <=  din[15:8];  
      end
      if (we_redund_1_hi[1]) begin          
         redund_1[23:16] <=  din[7:0];  
      end
      if (we_redund_1_hi[0]) begin          
         redund_1[31:24] <=  din[15:8];  
      end
end

always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      redund_2[31:0] <= 32'h00000000;
   end
   else begin
      if (we_redund_2_lo[0]) begin  
         redund_2[7:0]   <=  din[7:0];  
      end
      if (we_redund_2_lo[1]) begin         
         redund_2[15:8]  <=  din[15:8];  
      end
      if (we_redund_2_hi[1]) begin          
         redund_2[23:16] <=  din[7:0];  
      end
      if (we_redund_2_hi[0]) begin          
         redund_2[31:24] <=  din[15:8];  
      end
end


always @( negedge  reset_n,  posedge clk)
   if (!reset_n)  begin
      redund_3[31:0]<= 32'h00000000;
   end
   else begin
      if (we_redund_3_lo[0]) begin
         redund_3[7:0]   <=  din[7:0];
      end
      if (we_redund_3_lo[1]) begin
         redund_3[15:8]  <=  din[15:8];
      end
      if (we_redund_3_hi[1]) begin
         redund_3[23:16] <=  din[7:0];
      end
      if (we_redund_3_hi[0]) begin
         redund_3[31:24] <=  din[15:8];
      end
end



// read process
always @ (*)
begin
rdata_comb = 32'h0;
   if(re) begin
      case (addr)  
	7'h20 : begin
		rdata_comb = redund_0[15:0];
	end
	7'h22 : begin
		rdata_comb = redund_0[31:16];
	end
	7'h24 : begin
		rdata_comb = redund_1[15:0];
	end
	7'h26 : begin
		rdata_comb = redund_1[31:16];
	end
	7'h28 : begin
		rdata_comb = redund_2[15:0];
	end
	7'h2a : begin
		rdata_comb = redund_2[31:16];
	end
	7'h1c : begin
		rdata_comb = redund_3[15:0];
	end
	7'h1e : begin
		rdata_comb = redund_3[31:16];
	end
	default : begin
		rdata_comb = 16'h0000;
	end
      endcase
   end
end

endmodule
