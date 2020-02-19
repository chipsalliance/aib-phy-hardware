// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
//****************************************************************************************
// (C) 2012 Altera Corporation. .
//
//****************************************************************************************

//*****************************************************************
// Description:
//
// reserved address and separation of TX/RX/Common
//*****************************************************************
module cfg_dprio_ctrl_stat_reg_w_resvrd_chnl 
#(
   parameter DATA_WIDTH             = 16,  // Data width
   parameter ADDR_WIDTH             = 11,  // Address width
   parameter NUM_TX_CTRL_REGS       = 5,   // Number of n-bit TX control registers
   parameter NUM_TX_RSVD_CTRL_REGS  = 5,   // Number of n-bit TX Reserved control registers
   parameter NUM_RX_CTRL_REGS       = 10,  // Number of n-bit RX control registers
   parameter NUM_RX_RSVD_CTRL_REGS  = 10,  // Number of n-bit RX Reserved control registers
   parameter NUM_CM_CTRL_REGS       = 10,  // Number of n-bit Common control registers
   parameter NUM_CM_RSVD_CTRL_REGS  = 10,  // Number of n-bit Common Reserved control registers
   parameter TOTAL_NUM_CTRL_REGS    = 25,  // Total number of real n-bit control registers
   parameter NUM_STATUS_REGS        = 5,   // Number of n-bit status registers
   parameter NUM_STATUS_RSVD_REGS   = 5,   // Number of n-bit Reserved status registers
   parameter BYPASS_STAT_SYNC       = 0,   // Parameter to bypass the Synchronization SM in case of individual status bits
   parameter NUM_ATPG_SCAN_CHAIN    = 1,   // Number of ATPG scan chains
   parameter CLK_FREQ_MHZ           = 250  // Clock freq in MHz
 )
( 
// Scan interface
input  wire                                        scan_mode_n,     // active low scan mode enable
input  wire                                        scan_shift_n,    // active low scan shift
// Avalon-MM interface
input  wire                                        rst_n,           // reset
input  wire                                        clk,             // clock
input  wire                                        write,           // write enable input
input  wire                                        read,            // read enable input
input  wire [ADDR_WIDTH-1:0]                       reg_addr,        // address input
input  wire [ADDR_WIDTH-1:0]                       base_addr,       // base address value from CSR
input  wire [DATA_WIDTH-1:0]                       writedata,       // write data input
input  wire                                        hold_csr,        // Hold CSR value  
input  wire                                        gated_cram,      // Gating CRAM output
input  wire                                        dprio_sel,       // 1'b1=choose csr_in
                                                                    // 1'b0=choose dprio_in
input  wire                                        pma_csr_test_dis,// Disable PMA CSR test
input  wire [(DATA_WIDTH/8)-1:0]                   byte_en,         // Byte enable
input  wire                                        broadcast_en,    // Broadcast enable (controlled by extra CSR bit)
input  wire [DATA_WIDTH*NUM_STATUS_REGS-1:0]       user_datain,     // status from custom logic
input  wire [NUM_STATUS_REGS-1:0]                  write_en_ack,    // write data acknowlege from user logic
input  wire [NUM_ATPG_SCAN_CHAIN-1:0]              csr_chain_in,    // ATPG scan input

output wire [NUM_ATPG_SCAN_CHAIN-1:0]              csr_chain_out,   // ATPG scan output
output wire [NUM_STATUS_REGS-1:0]                  write_en,        // write data enable to user logic
output wire [DATA_WIDTH-1:0]                       readdata,        // Read data to route back to central Avalon-MM
output wire [DATA_WIDTH*NUM_TX_CTRL_REGS-1:0]      tx_user_dataout, // CRAM connecting to custom TX logic
output wire [DATA_WIDTH*NUM_RX_CTRL_REGS-1:0]      rx_user_dataout, // CRAM connecting to custom RX logic
output wire [DATA_WIDTH*NUM_CM_CTRL_REGS-1:0]      cm_user_dataout, // CRAM connecting to custom Common logic
output reg                                         block_select     // Signal to tell the central interface to select its readdata
);

localparam TOTAL_ALL_CTRL_REGS = TOTAL_NUM_CTRL_REGS + NUM_TX_RSVD_CTRL_REGS + NUM_RX_RSVD_CTRL_REGS + NUM_CM_RSVD_CTRL_REGS;

wire        [ADDR_WIDTH*NUM_TX_CTRL_REGS-1:0]   tx_ctrl_target_addr; 
wire        [ADDR_WIDTH*NUM_RX_CTRL_REGS-1:0]   rx_ctrl_target_addr; 
wire        [ADDR_WIDTH*NUM_CM_CTRL_REGS-1:0]   cm_ctrl_target_addr; 

wire        [ADDR_WIDTH*NUM_STATUS_REGS-1:0]    stat_target_addr; 
wire        [DATA_WIDTH*NUM_STATUS_REGS-1:0]    user_readdata;

reg                                             read_reg;
reg         [ADDR_WIDTH-1:0]                    reg_addr_reg;

wire        [TOTAL_NUM_CTRL_REGS+NUM_STATUS_REGS-1:0] readdata_sel;

// Target address for TX control registers
generate 
  genvar i;
  for (i=0; i < NUM_TX_CTRL_REGS; i=i+1)
    begin: tx_ctrl_target_address
      assign tx_ctrl_target_addr[ADDR_WIDTH*(i+1)-1:ADDR_WIDTH*i] = base_addr + i;
    end
endgenerate

// Target address for RX control registers
generate 
  genvar j;
  for (j=0; j < NUM_RX_CTRL_REGS; j=j+1)
    begin: rx_ctrl_target_address
      assign rx_ctrl_target_addr[ADDR_WIDTH*(j+1)-1:ADDR_WIDTH*j] = base_addr + NUM_TX_CTRL_REGS + NUM_TX_RSVD_CTRL_REGS + j;
    end
endgenerate

// Target address for Common control registers
generate 
  genvar k;
  for (k=0; k < NUM_CM_CTRL_REGS; k=k+1)
    begin: cm_ctrl_target_address
      assign cm_ctrl_target_addr[ADDR_WIDTH*(k+1)-1:ADDR_WIDTH*k] = base_addr + NUM_TX_CTRL_REGS + NUM_TX_RSVD_CTRL_REGS + NUM_RX_CTRL_REGS + NUM_RX_RSVD_CTRL_REGS + k;
    end
endgenerate

// Target address for status registers
generate 
  genvar l;
  for (l=0; l < NUM_STATUS_REGS; l=l+1)
    begin: status_target_address
      assign stat_target_addr[ADDR_WIDTH*(l+1)-1:ADDR_WIDTH*l] = base_addr + TOTAL_ALL_CTRL_REGS + l;
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
   .DATA_WIDTH(DATA_WIDTH),
   .ADDR_WIDTH(ADDR_WIDTH),
   .NUM_CTRL_REGS(TOTAL_NUM_CTRL_REGS),
   .NUM_ATPG_SCAN_CHAIN(NUM_ATPG_SCAN_CHAIN)
   ) ctrl_reg_nregs 
     (.clk (clk),
      .write (write),
      .reg_addr (reg_addr),
      .target_addr ({cm_ctrl_target_addr,rx_ctrl_target_addr,tx_ctrl_target_addr}),
      .writedata (writedata), 
      //.csr_in (csr_in), 
      .hold_csr (hold_csr), 
      .gated_cram (gated_cram),
      .dprio_sel (dprio_sel),
      .pma_csr_test_dis (pma_csr_test_dis),
      .byte_en (byte_en),
      .broadcast_en (broadcast_en),
      .csr_chain_in (csr_chain_in),
      .csr_chain_out(csr_chain_out),
      .user_dataout ({cm_user_dataout,rx_user_dataout,tx_user_dataout}) 
      //.csr_out (csr_out)
      );

// Status Registers
cfg_dprio_status_reg_nregs 
#(
  .DATA_WIDTH(DATA_WIDTH),            // Data width
  .ADDR_WIDTH(ADDR_WIDTH),            // Address width
  .NUM_STATUS_REGS(NUM_STATUS_REGS),  // Number of n-bit status registers
  .BYPASS_STAT_SYNC(BYPASS_STAT_SYNC),// Parameter to bypass the Synchronization SM in case of individual status bits  
  .CLK_FREQ_MHZ(CLK_FREQ_MHZ)
 ) status_reg_nregs
( 
 .rst_n(rst_n),                       // reset
 .clk(clk),                           // clock
 .read(read),                         // read enable input
 .reg_addr(reg_addr),                 // address input
 .target_addr(stat_target_addr),      // hardwired address value
 .user_datain(user_datain),           // status from custom logic
 .write_en_ack(write_en_ack),         // write data acknowlege from user logic
 .write_en(write_en),                 // write data enable to user logic
 .user_readdata(user_readdata)        // status register outputs
);

// 1-hot muxing for TX control registers
generate
  genvar n;
  for (n=0; n < NUM_TX_CTRL_REGS; n=n+1)
    begin: tx_ctrl_select
      assign readdata_sel[n] = (reg_addr_reg == tx_ctrl_target_addr[ADDR_WIDTH*(n+1)-1:ADDR_WIDTH*n]) ? 1'b1 : 1'b0;
    end
endgenerate

// 1-hot muxing for RX control registers
generate
  genvar o;
  for (o=0; o < NUM_RX_CTRL_REGS; o=o+1)
    begin: rx_ctrl_select
      assign readdata_sel[NUM_TX_CTRL_REGS+o] = (reg_addr_reg == rx_ctrl_target_addr[ADDR_WIDTH*(o+1)-1:ADDR_WIDTH*o]) ? 1'b1 : 1'b0;
    end
endgenerate

// 1-hot muxing for Common control registers
generate
  genvar p;
  for (p=0; p < NUM_CM_CTRL_REGS; p=p+1)
    begin: cm_ctrl_select
      assign readdata_sel[NUM_TX_CTRL_REGS+NUM_RX_CTRL_REGS+p] = (reg_addr_reg == cm_ctrl_target_addr[ADDR_WIDTH*(p+1)-1:ADDR_WIDTH*p]) ? 1'b1 : 1'b0;
    end
endgenerate

// 1-hot muxing for status registers
generate
  genvar m;
  for (m=0; m < NUM_STATUS_REGS; m=m+1)
    begin: status_select
      assign readdata_sel[TOTAL_NUM_CTRL_REGS+m] = (reg_addr_reg == stat_target_addr[ADDR_WIDTH*(m+1)-1:ADDR_WIDTH*m]) ? 1'b1 : 1'b0;
    end
endgenerate

cfg_dprio_readdata_mux 
#(
   .DATA_WIDTH(DATA_WIDTH),                           // Data width
   .NUM_INPUT(TOTAL_NUM_CTRL_REGS+NUM_STATUS_REGS)    // Number of n-bit input
 ) cfg_dprio_readdata_mux
( 
 .clk(clk),
 .rst_n(rst_n),
 .read(read_reg),
 .sel(readdata_sel),                                                                // 1-hot selection input
 .data_in({user_readdata,cm_user_dataout,rx_user_dataout,tx_user_dataout}),        // data input

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
