// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//****************************************************************************************
// (C) 2012 Altera Corporation. 
//
//****************************************************************************************

//************************************************************
// Description:
//
// Status register synchronizers used in common DPRIO module
//************************************************************

module cfg_dprio_status_sync_regs 
#(
   parameter DATA_WIDTH         = 16,  // Data width
   parameter BYPASS_STAT_SYNC   = 0,   // Parameter to bypass the Synchronization SM in case of individual status bits
   parameter CLK_FREQ_MHZ       = 250,  // Clock freq in MHz
   parameter TOGGLE_TYPE        = 1,
   parameter VID                = 1 
 )
(
input  wire                                 rst_n,         // reset
input  wire                                 clk,           // clock
input  wire [DATA_WIDTH-1:0]                stat_data_in,  // status data input
input  wire                                 write_en_ack,  // write data acknowlege from user logic

output reg                                  write_en,      // write data enable to user logic
output reg  [DATA_WIDTH-1:0]                stat_data_out  // status data output

);

//********************************************************************
// Define Parameters 
//********************************************************************
 localparam  WE_LOCAL        = 2'b00;
 localparam  CDC_WE_ACK      = 2'b01;
 localparam  CDC_WE_N_ACK    = 2'b10;

wire       write_en_ack_sync;
reg  [1:0] cdc_cs;
reg  [1:0] cdc_ns;
reg        write_en_comb;
reg        write_en_local_comb;
reg        write_en_local;

// Bit sync for write_en_ack
cdclib_bitsync2
   #(
      .DWIDTH       (1), // Sync Data input 
      .RESET_VAL    (0), // Reset value
      .CLK_FREQ_MHZ (CLK_FREQ_MHZ),
      .TOGGLE_TYPE(TOGGLE_TYPE),
      .VID(VID)
    ) write_en_ack_sync_1
   (
    .clk  (clk),                  // read clock
    .rst_n(rst_n),                // async reset for read clock domain
    .data_in (write_en_ack),      // data in
    .data_out(write_en_ack_sync)  // data out
   );

// Registering data_in with write_en
always @(negedge rst_n or posedge clk)
  if (rst_n == 1'b0)
    begin
      stat_data_out   <= {DATA_WIDTH{1'b0}};
    end
  else if (write_en_local == 1'b1)
    begin      
      stat_data_out <= stat_data_in;
    end

// CDC SM
// Output
always @(negedge rst_n or posedge clk)
  if (rst_n == 1'b0)
    begin
      write_en       <= 1'b0;
      write_en_local <= 1'b0;
      cdc_cs         <= WE_LOCAL;
    end
  else if (BYPASS_STAT_SYNC == 1'b1)
    begin
      write_en       <= 1'b1;
      write_en_local <= 1'b1;
      cdc_cs         <= WE_LOCAL;
    end  
  else
    begin      
      write_en       <= write_en_comb;
      write_en_local <= write_en_local_comb;
      cdc_cs         <= cdc_ns;      
    end

// SM
always @ (*)
  begin
    cdc_ns              = cdc_cs;
    write_en_comb       = 1'b0;
    write_en_local_comb = 1'b0;
    
    case (cdc_cs)
      WE_LOCAL:
        begin
          write_en_local_comb = 1'b1;
          cdc_ns              = CDC_WE_ACK;
        end

      CDC_WE_ACK:
        begin
          write_en_comb       = 1'b1;
          if (write_en_ack_sync == 1'b1)
            begin
              cdc_ns          = CDC_WE_N_ACK;
            end
        end

      CDC_WE_N_ACK:
        begin
          if (write_en_ack_sync == 1'b0)
            begin
              cdc_ns          = WE_LOCAL;
            end
        end
        
      default:
        begin
          cdc_ns          = WE_LOCAL;
          write_en_comb       = 1'b0;
          write_en_local_comb = 1'b0;          
        end
      endcase        
  end

endmodule

