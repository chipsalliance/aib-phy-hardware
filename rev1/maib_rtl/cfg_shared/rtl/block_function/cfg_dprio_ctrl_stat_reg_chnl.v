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
module cfg_dprio_ctrl_stat_reg_chnl 
#(
   parameter BINDEX              = 0,   // Base index
   parameter SEGMENT             = 0,   // CSR segment
   parameter DATA_WIDTH          = 16,  // Data width
   parameter ADDR_WIDTH          = 10,  // Address width
   parameter NUM_CTRL_REGS       = 18,  // Number of n-bit control registers
   parameter NUM_STATUS_REGS     = 1,   // Number of n-bit status registers
   parameter BYPASS_STAT_SYNC    = 0,   // Parameter to bypass the Synchronization SM in case of individual status bits
   parameter NUM_ATPG_SCAN_CHAIN = 1,   // Number of ATPG scan chains
   parameter CLK_FREQ_MHZ        = 250, // Clock freq in MHz
   parameter SECTOR_ROW          = 0,
   parameter SECTOR_COL          = 0,
   parameter TOGGLE_TYPE     = 1,
   parameter VID             = 1
 )
( 
// Avalon-MM interface
input  wire                                  rst_n,            // reset
input  wire                                  clk,              // clock
input  wire                                  write,            // write enable input
input  wire                                  read,             // read enable input
input  wire [ADDR_WIDTH-1:0]                 reg_addr,         // address input
input  wire [ADDR_WIDTH-1:0]                 base_addr,        // base address value from CSR
input  wire [DATA_WIDTH-1:0]                 writedata,        // write data input
input  wire                                  hold_csr,         // Hold CSR value  
input  wire                                  gated_cram,       // Gating CRAM output
input  wire                                  dprio_sel,        // 1'b1=choose csr_in
                                                               // 1'b0=choose dprio_in
input  wire                                  pma_csr_test_dis, // Disable PMA CSR test
input  wire [(DATA_WIDTH/8)-1:0]             byte_en,          // Byte enable
input  wire                                  broadcast_en,     // Broadcast enable (controlled by extra CSR bit)
input  wire [DATA_WIDTH*NUM_STATUS_REGS-1:0] user_datain,      // status from custom logic
input  wire [NUM_STATUS_REGS-1:0]            write_en_ack,     // write data acknowlege from user logic
input  wire [NUM_ATPG_SCAN_CHAIN-1:0]        csr_chain_in,     // ATPG scan input

output wire [NUM_ATPG_SCAN_CHAIN-1:0]        csr_chain_out,    // ATPG scan output
output wire [NUM_STATUS_REGS-1:0]            write_en,         // write data enable to user logic
output wire [DATA_WIDTH-1:0]                 readdata,         // Read data to route back to central Avalon-MM
output wire [DATA_WIDTH*NUM_CTRL_REGS-1:0]   user_dataout,     // CRAM connecting to custom logic
output reg                                   block_select      // Signal to tell the central interface to select its readdata
);

wire        [ADDR_WIDTH*NUM_CTRL_REGS-1:0]   ctrl_target_addr; 
wire        [ADDR_WIDTH*NUM_STATUS_REGS-1:0] stat_target_addr; 
wire        [DATA_WIDTH*NUM_STATUS_REGS-1:0] user_readdata;

reg                                          read_reg;
reg         [ADDR_WIDTH-1:0]                 reg_addr_reg;

wire        [NUM_CTRL_REGS+NUM_STATUS_REGS-1:0] readdata_sel;

// Target address for control registers
generate 
  genvar i;
  for (i=0; i < NUM_CTRL_REGS; i=i+1)
    begin: ctrl_target_address
      assign ctrl_target_addr[ADDR_WIDTH*(i+1)-1:ADDR_WIDTH*i] = base_addr + i;
    end
endgenerate

// Target address for status registers
generate 
  genvar j;
  for (j=0; j < NUM_STATUS_REGS; j=j+1)
    begin: status_target_address
      assign stat_target_addr[ADDR_WIDTH*(j+1)-1:ADDR_WIDTH*j] = base_addr + NUM_CTRL_REGS + j;
    end
endgenerate

// registering address and read signal
always @ (negedge rst_n or posedge clk)
begin
  if (rst_n == 1'b0)
    begin
      read_reg <= 1'b0;
      reg_addr_reg <= {ADDR_WIDTH{1'b0}};
    end
  else
    begin
      read_reg <= read;
      reg_addr_reg <= reg_addr;
    end
end

// Control Registers
cfg_dprio_ctrl_reg_nregs  
 #(
   .BINDEX(BINDEX),
   .SEGMENT(SEGMENT),
   .DATA_WIDTH(DATA_WIDTH),
   .ADDR_WIDTH(ADDR_WIDTH),
   .NUM_CTRL_REGS(NUM_CTRL_REGS),
   .NUM_ATPG_SCAN_CHAIN(NUM_ATPG_SCAN_CHAIN),
   .SECTOR_ROW(SECTOR_ROW),
   .SECTOR_COL(SECTOR_COL)
   ) ctrl_reg_nregs 
     (.clk (clk),
      .write (write),
      .reg_addr (reg_addr),
      .target_addr (ctrl_target_addr),
      .writedata (writedata), 
      .hold_csr (hold_csr), 
      .gated_cram (gated_cram),
      .dprio_sel (dprio_sel),
      .pma_csr_test_dis (pma_csr_test_dis),
      .byte_en (byte_en),
      .broadcast_en (broadcast_en),
      .csr_chain_in (csr_chain_in),
      .csr_chain_out(csr_chain_out),
      .user_dataout (user_dataout)
      );

// Status Registers
cfg_dprio_status_reg_nregs 
#(
  .DATA_WIDTH(DATA_WIDTH),             // Data width
  .ADDR_WIDTH(ADDR_WIDTH),             // Address width
  .NUM_STATUS_REGS(NUM_STATUS_REGS),   // Number of n-bit status registers
  .BYPASS_STAT_SYNC(BYPASS_STAT_SYNC), // Parameter to bypass the Synchronization SM in case of individual status bits
  .CLK_FREQ_MHZ(CLK_FREQ_MHZ),
  .TOGGLE_TYPE(TOGGLE_TYPE),
  .VID(VID)
 ) status_reg_nregs
(.rst_n (rst_n),                      // reset
 .clk(clk),                           // clock
 .read(read),                         // read enable input
 .reg_addr(reg_addr),                 // address input
 .target_addr(stat_target_addr),      // hardwired address value
 .user_datain(user_datain),           // status from custom logic
 .write_en_ack(write_en_ack),         // write data acknowlege from user logic
 .write_en(write_en),                 // write data enable to user logic
 .user_readdata(user_readdata)        // status register outputs
);

// 1-hot muxing
generate
  genvar k;
  for (k=0; k < NUM_CTRL_REGS; k=k+1)
    begin: ctrl_select
      //assign readdata_sel[k] = (reg_addr_reg == ctrl_target_addr[ADDR_WIDTH*(k+1)-1:ADDR_WIDTH*k]) ? 1'b1 : 1'b0;
      cfg_dprio_readdata_sel
      #(
         .ADDR_WIDTH(ADDR_WIDTH)  // Address width
       ) ctrl_select_i
      ( 
       .reg_addr     (reg_addr_reg),                                       // address input
       .target_addr  (ctrl_target_addr[ADDR_WIDTH*(k+1)-1:ADDR_WIDTH*k]),  // target address input
       .readdata_sel (readdata_sel[k])                                     // read select output
      );      
    end
endgenerate

generate
  genvar m;
  for (m=0; m < NUM_STATUS_REGS; m=m+1)
    begin: status_select
      //assign readdata_sel[NUM_CTRL_REGS+m] = (reg_addr_reg == stat_target_addr[ADDR_WIDTH*(m+1)-1:ADDR_WIDTH*m]) ? 1'b1 : 1'b0;
      cfg_dprio_readdata_sel
      #(
         .ADDR_WIDTH(ADDR_WIDTH)  // Address width
       ) status_select_i
      ( 
       .reg_addr     (reg_addr_reg),                                       // address input
       .target_addr  (stat_target_addr[ADDR_WIDTH*(m+1)-1:ADDR_WIDTH*m]),  // target address input
       .readdata_sel (readdata_sel[NUM_CTRL_REGS+m])                       // read select output
      );            
    end
endgenerate

cfg_dprio_readdata_mux 
#(
   .DATA_WIDTH(DATA_WIDTH),                     // Data width
   .NUM_INPUT(NUM_CTRL_REGS+NUM_STATUS_REGS)    // Number of n-bit input
 ) cfg_dprio_readdata_mux
( 
 .clk(clk),
 .rst_n(rst_n),
 .read(read_reg),
 .sel(readdata_sel),                            // 1-hot selection input
 .data_in({user_readdata,user_dataout}),        // data input

 .data_out(readdata)                            // data output
);

// Block select logic to indicate if read address matches one of the CONTROL/STATUS address
always @ (negedge rst_n or posedge clk)
  if (rst_n == 1'b0)
    begin
      block_select <= 1'b0;
    end
  else
    begin
      if (read_reg == 1'b1)
        begin
          block_select <= |readdata_sel;
        end
      else
        begin
          block_select <= 1'b0;
        end
    end

endmodule
