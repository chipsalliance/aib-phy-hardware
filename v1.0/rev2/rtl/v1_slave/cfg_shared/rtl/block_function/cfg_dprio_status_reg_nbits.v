// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//****************************************************************************************
// (C) 2012 Altera Corporation. .
//
//****************************************************************************************

//*****************************************************************
// Description:
//
//*****************************************************************
module cfg_dprio_status_reg_nbits 
#(
   parameter DATA_WIDTH      = 16,  // Data width
   parameter ADDR_WIDTH      = 16   // Address width
 )
( 
input  wire                  rst_n,        // reset
input  wire                  clk,          // clock
input  wire                  read,         // read enable input
input  wire [ADDR_WIDTH-1:0] reg_addr,     // address input
input  wire [ADDR_WIDTH-1:0] target_addr,  // hardwired address value
input  wire [DATA_WIDTH-1:0] user_datain,  // status from custom logic

output reg  [DATA_WIDTH-1:0] user_readdata // status register outputs
);

// Registering the status input when reading
always @(negedge rst_n or posedge clk)
  begin
    if(~rst_n)
      begin
        user_readdata <= {DATA_WIDTH{1'b0}};
      end
    else
      begin
	if((reg_addr == target_addr) && (read == 1'b1))
	begin
	  user_readdata <= user_datain;
	end
      end
  end

endmodule
