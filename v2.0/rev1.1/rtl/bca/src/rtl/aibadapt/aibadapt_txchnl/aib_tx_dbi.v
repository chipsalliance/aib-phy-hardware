// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.
// Copyright (C) 2021 Intel Corporation. 

module aib_tx_dbi (
   // Inputs
   input  wire        rst_n,   // Asynchronous reset
   input  wire        clk,     // Clock
   input  wire [79:0] data_in, // Data input before DBI logic
   input  wire        dbi_en,  // Data bus inversion (DBI) enable
   // Outputs
   output wire [79:0] data_out // Data output after DBI logic
   );

wire [3:0]  dbi_calc;     // dbi_calc[1:0] takes DDR data pin TX[19],       
                          // dbi_calc[3:2] takes DDR data pin TX[39]        
wire [39:0] idat0;        // Even data group 78, 76, 74 ..0;                
wire [39:0] idat1;        // Odd  data group 79, 77, 75 ..1;                
wire [39:0] prev_dat0;    // Prev Even data group                           
wire [39:0] prev_dat1;    // Prev Odd  data group                           
wire [37:0] dbi_dat_lo;   // Low word with DB calculation - bits from 37-0  
wire [37:0] dbi_dat_hi;   // High word with DB calculation - bits from 77-40
wire  [79:0] next_dbi_data_out; // Calculated DBI data
reg  [79:0] dbi_data_out; // Register to latch data after DBI calculation

// Output MUX to select data based on DBI enabled
assign data_out = dbi_en? dbi_data_out : data_in;

// Pre-calculation of DBI bits
genvar i; // Generate index
generate
for (i=0; i<40; i=i+1) 
  begin:data_in_gen
  assign idat0[i] = data_in[2*i];   //Even data group 78, 76, 74 ..0;
  assign idat1[i] = data_in[2*i+1]; //Odd  data group 79, 77, 75 ..1;

  assign prev_dat0[i] = next_dbi_data_out[2*i];//Prev Even data group. Used to 
                                            //get dbi[1] and dbi[3] calculation
  assign prev_dat1[i] = dbi_data_out[2*i+1];//Prev Odd  data group. Used to get
                                            // dbi[0] and dbi[2] calculation
  end // block: data_in_gen
endgenerate

// Calculation of data bits 79, 78, 39 and 38 used on DBI
assign dbi_calc = {dbi_value(idat1[38:20],
                   prev_dat0[38:20]),
                   dbi_value(idat0[38:20],
                   prev_dat1[38:20]),
                   dbi_value(idat1[18:0],
                   prev_dat0[18:0]),
                   dbi_value(idat0[18:0],
                   prev_dat1[18:0])};

// Calculation of DBI data - low word and high word
genvar j; // Generate index
generate
for (j=0; j<19; j=j+1)
  begin:data_out_gen
    assign dbi_dat_lo[2*j]   = idat0[j]^dbi_calc[0];
    assign dbi_dat_lo[2*j+1] = idat1[j]^dbi_calc[1];
    assign dbi_dat_hi[2*j]   = idat0[j+20]^dbi_calc[2];
    assign dbi_dat_hi[2*j+1] = idat1[j+20]^dbi_calc[3];
end
endgenerate

// Calculated bits after DBI logic
assign next_dbi_data_out = {dbi_calc[3:2], dbi_dat_hi,
                            dbi_calc[1:0], dbi_dat_lo};

// DBI data output registered
always @(posedge clk or negedge rst_n)
  begin: dbi_data_out_register
    if (!rst_n)
      begin
        dbi_data_out <= 80'h0;
      end
    else
      begin
        dbi_data_out <= next_dbi_data_out;
      end
  end // block: dbi_data_out_register

// Function to calculate each DBI bit
function  reg dbi_value (
  input [18:0] cur_d,  // Current data
  input [18:0] prv_d); // Previous data
  integer          i;  // Integer index
  reg [4:0] tmp;       // Temporary variable
  reg [18:0] dbi_bit;  // Intermediate DBI value

  tmp = 5'd0;                            
  for (i=0; i<19; i=i+1)                 
    begin                                
      dbi_bit[i] = cur_d[i] ^ prv_d[i];  
      tmp = tmp + dbi_bit[i];            
    end                                  
  dbi_value = (tmp > 9) ? 1 : 0;         
endfunction // block: dbi_value function


endmodule // aib_tx_dbi
