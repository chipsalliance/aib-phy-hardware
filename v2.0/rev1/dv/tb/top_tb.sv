
`timescale 1ps/1ps

module top_tb;

    //------------------------------------------------------------------------------------------

parameter TOTAL_CHNL_NUM = 24;
parameter AVMM_CYCLE = 4000;
parameter OSC_CYCLE  = 1000;
//parameter FWD_CYCLE  = 500;

`ifdef MS_AIB_GEN1
   parameter M_PAD_NUM  = 96;
`else
   parameter M_PAD_NUM  = 102;
`endif
`ifdef SL_AIB_GEN1
   parameter S_PAD_NUM  = 96;
`else
   parameter S_PAD_NUM  = 102;
`endif

logic  avmm_clk = 1'b0; 
logic  osc_clk = 1'b0; 
logic  fwd_clk = 1'b0; 
logic  wr_clk = 1'b0; 
logic  rd_clk = 1'b0;
int run_for_n_pkts_ms1;
int run_for_n_pkts_sl1;
int run_for_n_wa_cycle;
int err_count;

logic [40*24-1:0] ms1_rcv_40b_q [$];

logic [80*24-1:0] sl1_rcv_80b_q [$];
logic [80*24-1:0] ms1_rcv_80b_q [$];

logic [320*24-1:0] sl1_rcv_320b_q [$];
logic [320*24-1:0] ms1_rcv_320b_q [$];
bit [1023:0] status;

`include "top_tb_declare.inc"
`include "agent.sv"

//------------------------------------------------------------------------------------------
// Clock generation.
//------------------------------------------------------------------------------------------

    always #(AVMM_CYCLE/2) avmm_clk = ~avmm_clk;

    always #(OSC_CYCLE/2)  osc_clk  = ~osc_clk;

//  always #(FWD_CYCLE/2)  fwd_clk  = ~fwd_clk;


    //-----------------------------------------------------------------------------------------
    //Avalon MM Interface instantiation

    //-----------------------------------------------------------------------------------------
`ifdef MS_AIB_GEN1
    avalon_mm_if #(.AVMM_WIDTH(32), .BYTE_WIDTH(4)) avmm_if_m1  (
     .clk    (avmm_clk)
    );
`else
    avalon_mm_if #(.AVMM_WIDTH(32), .BYTE_WIDTH(4)) avmm_if_m1  (
     .clk    (avmm_clk)
    );
`endif
     avalon_mm_if #(.AVMM_WIDTH(32), .BYTE_WIDTH(4)) avmm_if_s1  (
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
`ifdef MS_AIB_GEN1
    aib_top_wrapper_v1m dut_master1 (
       `include "dut_ms_gen1.inc"
    );
`else 
    aib_model_top  #(.DATAWIDTH(DATAWIDTH)) dut_master1 (
        `include "dut_ms1_port.inc"
     );
`endif

`ifdef SL_AIB_GEN1
    maib_top dut_slave1 (
        `include "dut_sl_gen1.inc"
       );
initial begin
@(posedge dut_slave1.config_done);
`include "../test/data/maib_prog.inc"
end
    
`else
    aib_model_top #(.DATAWIDTH(DATAWIDTH)) dut_slave1 (
        `include "dut_sl1_port.inc"
       );
`endif

    // 24 channel Embedded Multi-Die Interconnect Bridge (EMIB) For future use
`ifdef MS_AIB_GEN1
    emib_m1s2 dut_emib (
        `include "dut_emib.inc"
       );
`elsif SL_AIB_GEN1
    emib_m2s1 dut_emib (
        `include "dut_emib.inc"
       );
`else
    emib_m2s2 dut_emib (
        `include "dut_emib.inc"
       );
`endif

   //---------------------------------------------------------------------------
   // DUMP
   //---------------------------------------------------------------------------
`ifdef VCS
   initial
   begin
     $vcdpluson;
   end
`endif
   `include "test.inc"

endmodule 
