// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2022 HCL Technologies Ltd.
// Copyright (C) 2022 Blue Cheetah Analog Design, Inc.
// Copyright (C) 2021 Intel Corporation. 

module aib_rx_dbi (
   // Inputs
   input  wire        rst_n,    // Asynchronous reset
   input  wire        clk,      // Clock
   input  wire [79:0] data_in,  // Data input before DBI logic
   input  wire        dbi_en,   // Data inversion enable
   // Outputs
   output wire [79:0] data_out  // Output data after DBI logic
   );

wire [3 :0] dbi_calc;     // Bits 79, 78, 39 and 38 used on DBI calculation
wire [37:0] dbi_dat_lo;   // Low word with DB calculation - bits from 37-0
wire [37:0] dbi_dat_hi;   // High word with DB calculation - bits from 77-40
reg  [79:0] dbi_data_out; // Register data after DBI calculation

// DBI output mux selects data accoding to DBI enable
assign data_out = dbi_en? dbi_data_out : data_in;

// Data bits 79, 78, 39 and 38 used on DBI calculation
assign dbi_calc = {data_in[79], data_in[78], data_in[39], data_in[38]};

// Calculation of DBI low word and DBI high word
genvar j; // Generate index
generate
for (j=0; j<19; j=j+1)
  begin:data_out_gen
    assign dbi_dat_lo[2*j]   = data_in[2*j]     ^dbi_calc[0];
    assign dbi_dat_lo[2*j+1] = data_in[2*j+1]   ^dbi_calc[1];
    assign dbi_dat_hi[2*j]   = data_in[2*j+40]  ^dbi_calc[2];
    assign dbi_dat_hi[2*j+1] = data_in[2*j+1+40]^dbi_calc[3];
  end // block data_out_gen
endgenerate

// Output register to latch DBI calculation
always @(posedge clk or negedge rst_n)
  begin: dbi_data_out_register
    if (!rst_n)
      begin
        dbi_data_out <= 80'h0;
      end
    else
      begin
        dbi_data_out <= {dbi_calc[3:2], dbi_dat_hi, dbi_calc[1:0], dbi_dat_lo};
      end
  end // block: dbi_data_out_register

endmodule // aib_rx_dbi
