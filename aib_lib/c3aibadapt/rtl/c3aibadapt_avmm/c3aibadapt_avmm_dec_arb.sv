// SPDX-License-Identifier: Apache-2.0
// Copyright (C) 2019 Intel Corporation. All rights reserved
//-----------------------------------------------------------------------------
// Copyright (C) 2015 Altera Corporation. All rights reserved.  Altera products are
// protected under numerous U.S. and foreign patents, maskwork rights, copyrights and
// other intellectual property laws.
//
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// Description: Channel Configuration arbitration and decoding
//
//
//---------------------------------------------------------------------------
//
//
//-----------------------------------------------------------------------------
// Change log
//
//
//
//
//-----------------------------------------------------------------------------
module c3aibadapt_avmm_dec_arb (

      input  logic                                   i_usr_avmm_clk                   ,// 150MHz clock
      input  logic                                   i_usr_avmm_rst_n                 ,//  async           User AVMM interface reset 0: Reset User AVMM interface Comes from the AIB adapter
      input  logic                                   i_usr_avmm_read                  ,//   i_usr_avmm_clk      AVMM Read 1: Requests a read to the address given by i_avmm_addr. The data corresponding to this read request will be valid <avmm_latency>  cycles later Maps to status_read in Ethernet soft cores
      input  logic                                   i_usr_avmm_write                 ,//   i_usr_avmm_clk      AVMM Write 1: Requests the data given by i_avmm_wdata be written to the address given by i_avmm_addr Maps to status_write in Ethernet soft cores
      input  logic  [7:0]                            i_usr_avmm_wdata                 ,//   i_usr_avmm_clk      AVMM Write Data Data to be written to the register addressed by i_avmm_addr for the current write request Maps to status_writedata in Ethernet soft cores
      input  logic  [9:0]                            i_usr_avmm_addr                  ,//   i_usr_avmm_clk      AVMM Address Register address for read and write requests Maps to status_addr in Ethernet soft cores
      input  logic  [8:0]                            i_usr_avmm_rsvd                  ,//   i_usr_avmm_clk      AVMM Reserved bits to use as address for ELANE
      output logic  [7:0]                            o_usr_avmm_rdata                 ,//   i_usr_avmm_clk      AVMM Read Data Data from the register addressed by i_avmm_addr on a previously accepted read request Maps to status_readdata in Ethernet soft cores
      output logic                                   o_usr_avmm_readdatavalid         ,//   i_usr_avmm_clk      AVMM Read Data Valid 1: Data on o_user_avmm_rdata[7:0] is valid
      output logic                                   o_usr_avmm_writedone             ,//   i_usr_avmm_clk      AVMM Write Done 1: Most recently requested user AVMM write is complete
      output logic                                   o_usr_avmm_waitrequest           ,//   i_usr_avmm_clk      AVMM Waitrequest 

      input  logic                                   i_config_avmm_clk                ,// 250MHz clock
      input  logic                                   i_config_avmm_rst_n              ,//   i_config_avmm_clk (locally synchronized)  Configuration AVMM interface reset 0: EHIP Configuration AVMM interface held in reset 
      input  logic                                   i_config_avmm_raw_rst_n          ,//   raw reset from CRSSM
      input  logic                                   i_config_avmm_write              ,//   i_config_avmm_clk     Configuration AVMM Write control Write enable control signal feed through to next Hard IP
      input  logic                                   i_config_avmm_read               ,//   i_config_avmm_clk     Configuration AVMM Read control 1: Requests a read to the address given by i_avmm_addr. The data corresponding to this read request will be valid <avmm_latency>  cycles later
      input  logic  [16:0]                           i_config_avmm_addr               ,//   i_config_avmm_clk     Configuration AVMM Address Register byte address for read and write requests
      input  logic  [31:0]                           i_config_avmm_wdata              ,//   i_config_avmm_clk     Configuration AVMM Write Data Data to be written to the register addressed by i_avmm_addr for the current write request
      input  logic  [3:0]                            i_config_avmm_byte_en            ,//   i_config_avmm_clk     Configuration AVMM Byte enable 
      output logic  [31:0]                           o_config_avmm_rdata              ,//   input wire i_config_avmm_clk     Configuration AVMM read data Register address for read and write requests
      output logic                                   o_config_avmm_rdatavalid         ,//   input wire i_config_avmm_clk     Configuration AVMM read data Register address for read and write requests
      output logic                                   o_config_avmm_waitrequest        ,//   input wire i_config_avmm_clk     Configuration AVMM Waitrequest Waitrequest from previous Hard IP feedthrough 
      input  logic  [5:0]                            i_config_avmm_addr_id            ,//   i_config_avmm_clk
      output logic                                   o_config_avmm_slave_active       ,//   i_config_avmm_clk


      output logic                                   o_pma_avmm_clk                   ,// Mux    clock
      output logic                                   o_pma_avmm_rst_n                 ,//   o_pma_avmm_clk (locally synchronized)  Configuration AVMM interface reset 0: EHIP Configuration AVMM interface held in reset by the 
      output logic                                   o_pma_avmm_from_usr_master       ,//   o_aib_avmm_clk     When set indicates AVMM Master is the PLD User AVMM
      output logic                                   o_pma_avmm_write                 ,//   o_pma_avmm_clk     Configuration AVMM Write control Write enable control signal feed through to next Hard IP
      output logic                                   o_pma_avmm_read                  ,//   o_pma_avmm_clk     Configuration AVMM Read control 1: Requests a read to the address given by i_avmm_addr. The data corresponding to this read request will be valid <avmm_latency>  cycles later
      output logic  [ 8:0]                           o_pma_avmm_addr                  ,//   o_pma_avmm_clk     Configuration AVMM Address Register byte address for read and write requests
      output logic  [31:0]                           o_pma_avmm_wdata                 ,//   o_pma_avmm_clk     Configuration AVMM Write Data Data to be written to the register addressed by i_avmm_addr for the current write request
      output logic  [3:0]                            o_pma_avmm_byte_en               ,//   o_pma_avmm_clk     Configuration AVMM Byte enable selects 
      input  logic  [31:0]                           i_pma_avmm_rdata                 ,//   o_pma_avmm_clk     Configuration AVMM read data Register address for read and write requests
      input  logic                                   i_pma_avmm_rdatavalid            ,//   o_pma_avmm_clk     Configuration AVMM read data Register address for read and write requests
      input  logic                                   i_pma_avmm_waitrequest           ,//   o_pma_avmm_clk     Configuration AVMM Waitrequest Waitrequest from previous Hard IP feedthrough 


      output logic                                   o_ehiplane_avmm_clk              ,// Mux    clock
      output logic                                   o_ehiplane_avmm_rst_n            ,//   o_ehiplane_avmm_clk (locally synchronized)  Configuration AVMM interface reset 0: EHIP Configuration AVMM interface held in reset 
      output logic                                   o_ehiplane_avmm_from_usr_master  ,//   o_aib_avmm_clk     When set indicates AVMM Master is the PLD User AVMM
      output logic                                   o_ehiplane_avmm_write            ,//   o_ehiplane_avmm_clk     Configuration AVMM Write control Write enable control signal feed through to next Hard IP
      output logic                                   o_ehiplane_avmm_read             ,//   o_ehiplane_avmm_clk     Configuration AVMM Read control 1: Requests a read to the address given by i_avmm_addr. The data corresponding to this read request will be valid <avmm_latency>  cycles later
      output logic  [ 16:0]                          o_ehiplane_avmm_addr             ,//   o_ehiplane_avmm_clk     Configuration AVMM Address Register byte address for read and write requests
      output logic  [31:0]                           o_ehiplane_avmm_wdata            ,//   o_ehiplane_avmm_clk     Configuration AVMM Write Data Data to be written to the register addressed by i_avmm_addr for the current write request
      output logic  [3:0]                            o_ehiplane_avmm_byte_en          ,//   o_ehiplane_avmm_clk     Configuration AVMM Byte enable 
      input  logic  [31:0]                           i_ehiplane_avmm_rdata            ,//   o_ehiplane_avmm_clk     Configuration AVMM read data Register address for read and write requests
      input  logic                                   i_ehiplane_avmm_rdatavalid       ,//   o_ehiplane_avmm_clk     Configuration AVMM read data Register address for read and write requests
      input  logic                                   i_ehiplane_avmm_waitrequest      ,//   o_ehiplane_avmm_clk     Configuration AVMM Waitrequest Waitrequest from previous Hard IP feedthrough 

      output logic                                   o_aib_avmm_clk                   ,// Mux clock
      output logic                                   o_aib_avmm_rst_n                 ,//   o_aib_avmm_clk (locally synchronized)  Configuration AVMM interface reset 0: EHIP Configuration AVMM interface held in reset 
      output logic                                   o_aib_avmm_from_usr_master       ,//   o_aib_avmm_clk     When set indicates AVMM Master is the PLD User AVMM
      output logic                                   o_aib_avmm_write                 ,//   o_aib_avmm_clk     Configuration AVMM Write control Write enable control signal feed through to next Hard IP
      output logic                                   o_aib_avmm_read                  ,//   o_aib_avmm_clk     Configuration AVMM Read control 1: Requests a read to the address given by i_avmm_addr. The data corresponding to this read request will be valid <avmm_latency>  cycles later
      output logic  [ 7:0]                           o_aib_avmm_addr                  ,//   o_aib_avmm_clk     Configuration AVMM Address Register byte address for read and write requests
      output logic  [31:0]                           o_aib_avmm_wdata                 ,//   o_aib_avmm_clk     Configuration AVMM Write Data Data to be written to the register addressed by i_avmm_addr for the current write request
      output logic  [3:0]                            o_aib_avmm_byte_en               ,//   o_aib_avmm_clk     Configuration AVMM Byte enable 
      input  logic  [31:0]                           i_aib_avmm_rdata                 ,//   o_aib_avmm_clk     Configuration AVMM read data Register address for read and write requests
      input  logic                                   i_aib_avmm_rdatavalid            ,//   o_aib_avmm_clk     Configuration AVMM read data Register address for read and write requests
      input  logic                                   i_aib_avmm_waitrequest           ,//   o_aib_avmm_clk     Configuration AVMM Waitrequest Waitrequest from previous Hard IP feedthrough 

      input logic  [5:0]                             i_prg_mcast_addr                 , // i_config_avmm_clk
      input logic                                    i_prg_mcast_addr_en              , // i_config_avmm_clk
      input logic                                    i_arbiter_base                   , // i_config_avmm_clk

      input logic                                    i_scan_mode_n                    ,// Scan reset inputs
      input logic                                    i_rst_n_bypass                   ,// Scan reset inputs
    
      output logic [15:0]                            o_dec_arb_tb_direct 

);

localparam ZEROS                      = 512'h0;
localparam SM_IDLE                    = 2'h0;
localparam SM_WRITE                   = 2'h1;
localparam SM_READ                    = 2'h2;
localparam SM_CPL                     = 2'h3;
localparam ARBITER_DELAY              = 8;
localparam BASE_ADDR_DW_XCVR          = 32'h000;
localparam BASE_ADDR_DW_BASE          = 32'h080;
localparam BASE_ADDR_DW_CAIB          = 32'h084;
localparam BASE_ADDR_DW_NAIB          = 32'h0C0;
localparam BASE_ADDR_DW_EHIP          = 32'h100;
localparam USR_ADDR_DW                = 19-2;
localparam USR_ADDR_BW                = 19; // ADDR_BW : BYTE ADRESS BUS WIDTH
localparam PMA_ADDR_BW                =  9; // ADDR_BW : BYTE ADRESS BUS WIDTH
localparam EHP_ADDR_BW                = 17; // ADDR_BW : BYTE ADRESS BUS WIDTH
localparam AIB_ADDR_BW                =  8; // ADDR_BW : BYTE ADRESS BUS WIDTH.. Decode for AIB User space, not for config-only space

logic          match_id;
logic          match_addr;
logic          match_addr_cfg_only;
logic [1:0]    sm_cfg_act;
logic [1:0]    sm_cfg_past_act;

logic [ARBITER_DELAY-1:0]  arbiter_delay;
logic          arbiter                  ;
logic          arbiter_base             ;
logic          arbiter_n                ;
logic          avmm_clk                 ;
logic          avmm_rst_n               ;
logic          avmm_write               ;
logic          avmm_read                ;
logic  [USR_ADDR_BW-3:0] avmm_addr      ;
logic  [31:0]  avmm_wdata               ;
logic  [3:0]   avmm_byte_en             ;
logic  [31:0]  avmm_rdata               ;
logic          avmm_rdatavalid          ;
logic          avmm_waitrequest         ;

logic          usr_avmm32_write         ;
logic          usr_avmm32_read          ;
logic  [USR_ADDR_BW-1:0] usr_avmm8_addr ;
logic  [USR_ADDR_BW-3:0] usr_avmm32_addr;
logic  [31:0]  usr_avmm32_wdata         ;
logic  [3:0]   usr_avmm32_byte_en       ;
logic  [31:0]  usr_avmm32_rdata         ;
logic          usr_avmm32_rdatavalid    ;
logic          usr_avmm32_waitrequest   ;
logic          usr_wdone;

// logic          base_avmm_write          ;
// logic          base_avmm_read           ;
// logic  [5:0]   base_avmm_addr           ;
// logic  [31:0]  base_avmm_wdata          ;
// logic  [3:0]   base_avmm_byte_en        ;
// logic  [31:0]  base_avmm_rdata          ;
// logic          base_avmm_rdatavalid     ;
// logic          base_avmm_waitrequest    ;
logic  [5:0]   prg_mcast_addr           ;
logic          prg_mcast_addr_en        ;
logic  [31:0]  ehiplane_avmm_rdata      ;
logic  [8:0]   ehiplane_avmm_rsvd       ;
logic  [13:0]  avmm_decode_tb_direct    ;


assign o_dec_arb_tb_direct = {sm_cfg_past_act[1:0], avmm_decode_tb_direct[13:12],
                              avmm_decode_tb_direct[8+:4],
                              avmm_decode_tb_direct[4+:4],
                              avmm_decode_tb_direct[0+:3],avmm_clk};

assign arbiter_n =~arbiter;

// Arbiter synchronized to new dynamic clock
// c3lib_bitsync #(
//    .DWIDTH            (1  ),
//    .RESET_VAL         (0  ),
//    .DST_CLK_FREQ_MHZ  (500),
//    .SRC_DATA_FREQ_MHZ (100)
// ) use_usr_intf (
//   .clk                (avmm_clk),
//   .rst_n              (avmm_rst_n),
//   .data_in            (arbiter),
//   .data_out           (arb_sel_user_avmm));

assign avmm_rst_n        = i_config_avmm_rst_n;

c3lib_gf_clkmux avmm1_gf_clkmux (
  .i_sel_clk       (arbiter),                  // Clock Mux selector; arbiter controlled by i_config_avmm_clk only;
  .i_clk_a         (i_config_avmm_clk),       // CRSSM-AVMM clk input
  .i_rst_a_n       (i_config_avmm_rst_n),     //
  .i_clk_b         (i_usr_avmm_clk),          // User-AVMM clk input
  .i_rst_b_n       (i_usr_avmm_rst_n),        // CRSSM-AVMM clk input
  .i_scan_mode_n   (i_scan_mode_n),
  .i_rst_n_bypass  (i_rst_n_bypass),
  .o_clk_out       (avmm_clk)              // Mux clock output
);

// broadcast clk/rstn to all downstream masters
// i_config_avmm_raw_rst_n is taken directly from CRSSM
assign o_ehiplane_avmm_clk   = avmm_clk  ;
assign o_ehiplane_avmm_rst_n = i_config_avmm_raw_rst_n;
assign o_pma_avmm_clk        = avmm_clk  ;
assign o_pma_avmm_rst_n      = i_config_avmm_raw_rst_n;
// For local Adapter registers, use synchronized reset
assign o_aib_avmm_clk    = avmm_clk  ;
assign o_aib_avmm_rst_n  = i_config_avmm_rst_n;
// i_config_avmm_rst_n is synchronized reset


assign o_aib_avmm_from_usr_master      = arbiter;
assign o_pma_avmm_from_usr_master      = arbiter;
assign o_ehiplane_avmm_from_usr_master = arbiter;

c3aibadapt_avmm_usr32_exp   usr32_exp (
      .i_usr_avmm_clk              (i_usr_avmm_clk                             ) ,// input  logic
      .i_usr_avmm_rst_n            (i_usr_avmm_rst_n                           ) ,// input  logic
      .i_usr_avmm_read             (i_usr_avmm_read                            ) ,// input  logic
      .i_usr_avmm_write            (i_usr_avmm_write                           ) ,// input  logic
      .i_usr_avmm_wdata            (i_usr_avmm_wdata         [7:0]             ) ,// input  logic  [7:0]
      .i_usr_avmm_addr             (usr_avmm8_addr[USR_ADDR_BW-1:0]            ) ,// input  logic  [9:0]
      .o_usr_avmm_rdata            (o_usr_avmm_rdata         [7:0]             ) ,// output logic  [7:0]
      .o_usr_avmm_readdatavalid    (o_usr_avmm_readdatavalid                   ) ,// output logic
      .o_usr_avmm_writedone        (o_usr_avmm_writedone                       ) ,// output logic
      .o_usr_avmm_waitrequest      (o_usr_avmm_waitrequest                     ) ,// output logic
      .o_usr_avmm32_write          (usr_avmm32_write                           ) ,// output  logic
      .o_usr_avmm32_read           (usr_avmm32_read                            ) ,// output  logic
      .o_usr_avmm32_addr           (usr_avmm32_addr          [USR_ADDR_BW-3:0] ) ,// output  logic  [7:0]
      .o_usr_avmm32_wdata          (usr_avmm32_wdata         [31:0]            ) ,// output  logic  [31:0]
      .o_usr_avmm32_byte_en        (usr_avmm32_byte_en       [3:0]             ) ,// output  logic  [3:0]
      .i_usr_avmm32_rdata          (usr_avmm32_rdata         [31:0]            ) ,// input   logic  [31:0]
      .i_usr_avmm32_rdatavalid     (usr_avmm32_rdatavalid                      ) ,// input   logic
      .i_usr_avmm32_waitrequest    (usr_avmm32_waitrequest                     )  // input   logic
);

c3aibadapt_avmm_decode  decode (
      .avmm_clk                    (avmm_clk                             ),
      .avmm_rst_n                  (avmm_rst_n                           ),
      .i_avmm_write                (avmm_write                           ),
      .i_avmm_read                 (avmm_read                            ),
      .i_avmm_addr                 (avmm_addr        [USR_ADDR_BW-3:0]   ),
      .i_avmm_wdata                (avmm_wdata                  [31:0]   ),
      .i_avmm_byte_en              (avmm_byte_en                [3:0]    ),
      .o_avmm_rdata                (avmm_rdata                  [31:0]   ),
      .o_avmm_rdatavalid           (avmm_rdatavalid                      ),
      .o_avmm_waitrequest          (avmm_waitrequest                     ),
      .i_arb_sel_user_avmm         (arbiter                              ),

      .o_pma_avmm_write            (o_pma_avmm_write                     ),
      .o_pma_avmm_read             (o_pma_avmm_read                      ),
      .o_pma_avmm_addr             (o_pma_avmm_addr  [PMA_ADDR_BW-1:2]   ),
      .o_pma_avmm_wdata            (o_pma_avmm_wdata            [31:0]   ),
      .o_pma_avmm_byte_en          (o_pma_avmm_byte_en          [3:0]    ),
      .i_pma_avmm_rdata            (i_pma_avmm_rdata            [31:0]   ),
      .i_pma_avmm_rdatavalid       (i_pma_avmm_rdatavalid                ),
      .i_pma_avmm_waitrequest      (i_pma_avmm_waitrequest               ),

      .o_ehiplane_avmm_write       (o_ehiplane_avmm_write                ),
      .o_ehiplane_avmm_read        (o_ehiplane_avmm_read                 ),
      .o_ehiplane_avmm_addr        (o_ehiplane_avmm_addr[EHP_ADDR_BW-1:2]),
      .o_ehiplane_avmm_wdata       (o_ehiplane_avmm_wdata       [31:0]   ),
      .o_ehiplane_avmm_byte_en     (o_ehiplane_avmm_byte_en     [3:0]    ),
      .i_ehiplane_avmm_rdata       (ehiplane_avmm_rdata         [31:0]   ),
      .i_ehiplane_avmm_rdatavalid  (i_ehiplane_avmm_rdatavalid           ),
      .i_ehiplane_avmm_waitrequest (i_ehiplane_avmm_waitrequest          ),

      .o_aib_avmm_write            (o_aib_avmm_write                     ),
      .o_aib_avmm_read             (o_aib_avmm_read                      ),
      .o_aib_avmm_addr             (o_aib_avmm_addr  [AIB_ADDR_BW-1:2]   ),
      .o_aib_avmm_wdata            (o_aib_avmm_wdata            [31:0]   ),
      .o_aib_avmm_byte_en          (o_aib_avmm_byte_en          [3:0]    ),
      .i_aib_avmm_rdata            (i_aib_avmm_rdata            [31:0]   ),
      .i_aib_avmm_rdatavalid       (i_aib_avmm_rdatavalid                ),
      .i_aib_avmm_waitrequest      (i_aib_avmm_waitrequest               ),
      .o_avmm_decode_tb_direct     (avmm_decode_tb_direct                )

);

assign   o_aib_avmm_addr[1:0]     = 2'h0;
assign   o_pma_avmm_addr[1:0]     = 2'h0;

// Note Per case 428793,
//    Definition :
//       Aligned DWORD Address for 32-bit AVMM interface
//          Address uses only location 0x0, 0x4, 0x8, 0xc (32-bit aligned
//          address
//          Use byte_en[3:0] to access any byte of the address above
//       Byte DWORD Address for 32-bit AVMM interface
//          Address uses any location 0x1, 0x2, 0x3, 0x4
//          No use of Byte enable
//          the AVMM data path [31:0] only uses the lower 8 bite [7:0]
//    All 32-bit AVMM interfaces of this module uses Aligned DWORD address convention
//    except ehiplane_avmm  when operating in user mode
//    (o_config_avmm_slave_active==1'b0)
//
//
assign o_ehiplane_avmm_addr[1:0]  = (o_config_avmm_slave_active==1'b1     ) ? 2'h0 :
                                    (o_ehiplane_avmm_byte_en[3:0]==4'b0010) ? 2'h1 :
                                    (o_ehiplane_avmm_byte_en[3:0]==4'b0100) ? 2'h2 :
                                    (o_ehiplane_avmm_byte_en[3:0]==4'b1000) ? 2'h3 : 2'h0;
assign ehiplane_avmm_rdata[31:0]  = (o_config_avmm_slave_active==1'b1     ) ? i_ehiplane_avmm_rdata[31:0] :
                                                                             {i_ehiplane_avmm_rdata[7:0],i_ehiplane_avmm_rdata[7:0],
                                                                              i_ehiplane_avmm_rdata[7:0],i_ehiplane_avmm_rdata[7:0]} ;

assign prg_mcast_addr[5:0] = i_prg_mcast_addr[5:0];
assign prg_mcast_addr_en   = i_prg_mcast_addr_en  ;
assign arbiter_base        = i_arbiter_base       ;

// Adding delay to ensure completion of pending AVMM READ transaction
always @(posedge i_config_avmm_clk or negedge i_config_avmm_rst_n) begin :  p_avmm
   if (i_config_avmm_rst_n==1'b0) begin
      arbiter_delay[ARBITER_DELAY-1:0]  <= ZEROS[ARBITER_DELAY-1:0];
   end
   else begin
      arbiter_delay[ARBITER_DELAY-1:0]  <= {arbiter_delay[ARBITER_DELAY-2:0], arbiter_base};
   end
end : p_avmm
assign arbiter = arbiter_delay[ARBITER_DELAY-1];

assign avmm_write     = (arbiter == 1'b1)? usr_avmm32_write :(i_config_avmm_write & match_id);
assign avmm_read      = (arbiter == 1'b1)? usr_avmm32_read  :(i_config_avmm_read  & match_id);
assign avmm_addr      = (arbiter == 1'b1)? usr_avmm32_addr[USR_ADDR_BW-3:0]: {ZEROS[USR_ADDR_BW-1:11], i_config_avmm_addr[10:2] };
assign usr_avmm8_addr = {i_usr_avmm_rsvd[8:0],i_usr_avmm_addr[9:0]};
assign avmm_wdata     = (arbiter == 1'b1)? usr_avmm32_wdata  [31:0]:i_config_avmm_wdata  [31:0];
assign avmm_byte_en   = (arbiter == 1'b1)? usr_avmm32_byte_en[3:0] :i_config_avmm_byte_en[3:0] ;

////////////////////////////////////////////////
//
// USR CFG Arbitration

assign usr_avmm32_rdata       = avmm_rdata[31:0]                     ;
assign usr_avmm32_rdatavalid  = (arbiter == 1'b1) ? avmm_rdatavalid  : 1'b0;
assign usr_avmm32_waitrequest = (arbiter == 1'b1) ? avmm_waitrequest : 1'b1;


// assign o_usr_avmm_writedone = usr_wdone;

// always @(posedge avmm_clk or negedge avmm_rst_n) begin :  w_done
//    if (avmm_rst_n==1'b0) begin
//       usr_wdone <= 1'b0;
//    end
//    else begin
//       usr_wdone <= usr_avmm32_write;
//    end
// end : w_done

////////////////////////////////////////////////////////////////////////////
//
// config_avmm control signal management
//

assign o_config_avmm_rdata        = avmm_rdata[31:0]                     ;
assign o_config_avmm_rdatavalid   = (arbiter_n==1'b1) ? avmm_rdatavalid  : 1'b0;
assign o_config_avmm_waitrequest  = (arbiter_n==1'b1) ? avmm_waitrequest : 1'b1;
assign o_config_avmm_slave_active = arbiter_n;

always @(posedge i_config_avmm_clk or negedge i_config_avmm_rst_n) begin :  p_sl_act
   if (i_config_avmm_rst_n==1'b0) begin
      sm_cfg_past_act  <= SM_IDLE;
   end
   else begin
      sm_cfg_past_act  <= sm_cfg_act;
   end
end : p_sl_act


assign match_addr = ( (i_config_avmm_addr_id[5:0] == i_config_avmm_addr[16:11])||
                      ((prg_mcast_addr_en==1'b1)&&(prg_mcast_addr[5:0]== i_config_avmm_addr[16:11])));

assign match_addr_cfg_only = (i_config_avmm_addr[10:0]<11'h300)?1'b0:
                             (i_config_avmm_addr[10:0]<11'h400)?1'b1:1'b0;

assign match_id = (match_addr         ==1'b0)? 1'b0:
                  (match_addr_cfg_only==1'b1)? 1'b0:
                  (i_config_avmm_write==1'b1)? 1'b1:
                  (i_config_avmm_read ==1'b1)? 1'b1:1'b0;

always @(*) begin : p_act
   case (sm_cfg_past_act)
      SM_IDLE : sm_cfg_act  = (arbiter == 1'b1)                ?SM_IDLE:
                              (match_id == 1'b0)               ?SM_IDLE:
                              (i_config_avmm_write==1'b1)      ?SM_WRITE:
                              (i_config_avmm_read==1'b1)       ?SM_READ:
                                                                SM_IDLE;
      SM_WRITE : sm_cfg_act = (o_config_avmm_waitrequest==1'b0)?SM_IDLE:
                                                                SM_WRITE;
      SM_READ  : sm_cfg_act = (o_config_avmm_waitrequest==1'b0)?SM_CPL:
                                                                SM_READ;
      SM_CPL   : sm_cfg_act = (o_config_avmm_rdatavalid==1'b1) ?SM_IDLE:
                                                                SM_CPL;
      default  : sm_cfg_act =                                   SM_IDLE;

   endcase
end : p_act

endmodule : c3aibadapt_avmm_dec_arb
