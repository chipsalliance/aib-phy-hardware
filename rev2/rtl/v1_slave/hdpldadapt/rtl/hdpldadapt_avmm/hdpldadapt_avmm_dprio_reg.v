// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. 
module hdpldadapt_avmm_dprio_reg 
(
input wire          csr_clk,    // CSR clock 
input wire          avmm_clk,  
input wire          scan_mode_n,
input wire          scan_shift_n,
input wire          csr_in_ds,       
input wire [3:0]    scan_in,  
input wire          csr_en,
input wire          avmm_rst_n,
input wire          write,
input wire          read,
input wire [7:0]    reg_addr,
input wire [7:0]    writedata,
input wire          csr_test_mode, 
input wire          mdio_dis,     
input wire [15:0]   user_datain,   
input wire [1:0]    write_en_ack,  

output wire         csr_out,       // last csr_in
output wire [3:0]   scan_out,      
output wire [7:0]   readdata,
output wire         block_select,
output wire [383:0] user_dataout,  
output wire [1:0]   write_en,      
output wire [639:0] extra_csr_out  
);

localparam                        DATA_WIDTH             =   8;  // Data width
localparam                        ADDR_WIDTH             =   8;  // Address width
localparam                        NUM_CTRL_REGS          =  8'd48;  // Number of n-bit TX control registers. 
localparam                        NUM_EXTRA_CSR_REG      =  8'd80;  // Number of extra 8-bit register for CSR. 
localparam                        NUM_STATUS_REGS        =   2;  // Number of n-bit status registers. 
localparam                        CSR_OUT_NEG_FF_EN      =   0;  // Enable negative FF on csr_out
localparam                        BYPASS_STAT_SYNC       =   0;  // to bypass the Synchronization SM in case of individual status bits
localparam                        USE_AVMM_INTF          =   1;  // Specify if AVMM Interface is used.  Bypass clock selection if using AVMM Interface.
localparam                        FORCE_INTER_SEL_CVP_EN =   0;  // Enable logic to force interface_sel in CVP mode
localparam                        NUM_ATPG_SCAN_CHAIN    =   2;  // Specify number of scan chain
localparam                        NUM_CSR_ATPG_SCAN_CHAIN=   2;  // Specify number of scan chain
localparam                        STAT_REG_CLK_FREQ_MHZ  =   200;  
localparam                        STAT_REG_TOGGLE_TYPE   =   2;  
localparam                        STAT_REG_VID           =   1;  

   cfg_dprio_ctrl_stat_reg_top 
     #(
       .DATA_WIDTH              (DATA_WIDTH),
       .ADDR_WIDTH              (ADDR_WIDTH),
       .NUM_CTRL_REGS           (NUM_CTRL_REGS),
       .NUM_EXTRA_CSR_REG       (NUM_EXTRA_CSR_REG),
       .NUM_STATUS_REGS         (NUM_STATUS_REGS),
       .CSR_OUT_NEG_FF_EN       (CSR_OUT_NEG_FF_EN),
       .BYPASS_STAT_SYNC        (BYPASS_STAT_SYNC),
       .USE_AVMM_INTF           (USE_AVMM_INTF),
       .FORCE_INTER_SEL_CVP_EN  (FORCE_INTER_SEL_CVP_EN),
       .NUM_CSR_ATPG_SCAN_CHAIN (NUM_CSR_ATPG_SCAN_CHAIN),
       .STAT_REG_CLK_FREQ_MHZ   (STAT_REG_CLK_FREQ_MHZ),
       .STAT_REG_TOGGLE_TYPE    (STAT_REG_TOGGLE_TYPE),
       .STAT_REG_VID            (STAT_REG_VID),
       .NUM_ATPG_SCAN_CHAIN     (NUM_ATPG_SCAN_CHAIN)
       )
       cfg_dprio_ctrl_stat_reg_top 
         (
           // input
           .scan_mode_n                 (scan_mode_n),
           .scan_shift_n                (scan_shift_n),
           .csr_clk                     (csr_clk),
           .csr_in                      (csr_in_ds),
           .atpg_scan_in                (scan_in),
           .csr_en                      (csr_en),
           .dprio_rst_n                 (avmm_rst_n),
           .dprio_clk                   (avmm_clk),
           .write                       (write),
           .read                        (read),
           .byte_en                     (1'b1),
           .reg_addr                    (reg_addr),
           .writedata                   (writedata),
           .csr_test_mode               (csr_test_mode),
           .mdio_dis                    (mdio_dis),
           .user_datain                 (user_datain), 
           .write_en_ack                (write_en_ack),
           .pma_csr_test_dis            (1'b1),
           // output 
           .csr_out                     (csr_out),
           .atpg_scan_out               (scan_out),
           .readdata                    (readdata),
           .block_select                (block_select),
           .user_dataout                (user_dataout),
           .write_en                    (write_en),
           .extra_csr                   (extra_csr_out)
           );

endmodule
