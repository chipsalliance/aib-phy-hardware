
`timescale 1ps/1ps

module top_tb;

    //------------------------------------------------------------------------------------------

parameter TOTAL_CHNL_NUM = 24;
parameter AVMM_CYCLE = 4000;
parameter OSC_CYCLE  = 1000;
parameter FWD_CYCLE  = 500;

logic  avmm_clk = 1'b0; 
logic  osc_clk = 1'b0; 
logic  fwd_clk = 1'b0; 
logic  wr_clk = 1'b0; 
logic  rd_clk = 1'b0;
int run_for_n_pkts_ms1;
int run_for_n_pkts_sl1;
int run_for_n_wa_cycle;
int err_count;
logic [80*24-1:0] sl1_xmit_q [$];
logic [80*24-1:0] ms1_xmit_q [$];

logic [320*24-1:0] sl1_xmit_f_q [$];
logic [320*24-1:0] ms1_xmit_f_q [$];
bit [1023:0] status;

`include "top_tb_declare.inc"
`include "agent.sv"

//------------------------------------------------------------------------------------------
// Clock generation.
//------------------------------------------------------------------------------------------

    always #(AVMM_CYCLE/2) avmm_clk = ~avmm_clk;

    always #(OSC_CYCLE/2)  osc_clk  = ~osc_clk;

    always #(FWD_CYCLE/2)  fwd_clk  = ~fwd_clk;


    //-----------------------------------------------------------------------------------------
    //Avalon MM Interface instantiation

    //-----------------------------------------------------------------------------------------

    avalon_mm_if avmm_if_m1  (
     .clk    (avmm_clk)
    );

    avalon_mm_if avmm_if_s1  (
     .clk    (avmm_clk)
    );
    //-----------------------------------------------------------------------------------------
    // Mac Interface instantiation

    //-----------------------------------------------------------------------------------------
    dut_if_mac #(.DWIDTH (40)) intf_m1 (.wr_clk(wr_clk), .rd_clk(rd_clk), .fwd_clk(fwd_clk), .osc_clk(osc_clk));
    dut_if_mac #(.DWIDTH (40)) intf_s1 (.wr_clk(wr_clk), .rd_clk(rd_clk), .fwd_clk(fwd_clk), .osc_clk(osc_clk));
    //-----------------------------------------------------------------------------------------
    // DUT instantiation
    //-----------------------------------------------------------------------------------------

    // One channel master uses aib model
    parameter DATAWIDTH      = 40;
    aib_model_top  #(.DATAWIDTH(DATAWIDTH)) dut_master1 (
        `include "dut_ms1_port.inc"
     );
    // One channel slave uses aib model 
    aib_model_top #(.DATAWIDTH(DATAWIDTH)) dut_slave1 (
        `include "dut_sl1_port.inc"
       );

    // One channel Embedded Multi-Die Interconnect Bridge (EMIB) For future use

//  emib dut_emib (
//      `include "dut_emib.inc"
//     );


   //---------------------------------------------------------------------------
   // DUMP
   //---------------------------------------------------------------------------
   initial
   begin
     $vcdpluson;
   end

   `include "test.inc"

endmodule 
