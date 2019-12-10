///////////////////////////////////////////////////////////////////////////////////////////
//                 ------------                           -----------
//    random       |          |                           |         |rx-->|
//    data  tx---->|   aib    |<=========================>|  aib    |     V (data loopback)
//                 |          |                           |         |tx<--|
//    data  rx<----|          |                           |         |          
//    checker      |          |<---ms_nsl                 |         |<---ms_nsl
//                 -----------     (1'b1, master)         -----------    (1'b0, slave)      
//                   master                                 slave
///////////////////////////////////////////////////////////////////////////////////////////
// This testbench testing DDR data path. The following change needs to make for SDR test 
// .iddren(1'b1),  -> .iddren(1'b0), For both master and slave.
//////////////////////////////////////////////////////////////////////////////////////////

`timescale 1ps/1fs
module tb_top ();

parameter DATAWIDTH = 20;

  reg     clk;
always #(500)       clk = ~clk;

 wire [DATAWIDTH-1:0]    ms_tx;
 wire [DATAWIDTH-1:0]    ms_rx;
 wire     ms_sr_clk, ms_sr_clkb; 
 wire     sl_sr_clk, sl_sr_clkb; 
 wire     ms_sr_load; 
 wire     sl_sr_load; 
 wire     ms_sr_data;
 wire     sl_sr_data;
 wire     iopad_ns_mac_rdy; 
 wire     iopad_fs_mac_rdy; 
 wire     iopad_ns_adapter_rstn;
 wire     iopad_fs_adapter_rstn;

 wire     iopad_device_detect;
 wire     iopad_device_detect_copy;
 wire     iopad_por;
 wire     iopad_por_copy;

 wire     ms_ns_rcv_clk, ms_ns_rcv_clkb, ms_fs_rcv_clk, ms_fs_rcv_clkb;
 wire     ms_fs_fwd_clk, ms_fs_fwd_clkb, ms_ns_fwd_clk, ms_ns_fwd_clkb;
 wire     ms_spare1, ms_spare0;

reg        ms_config_done, sl_config_done;
reg        ms_rx_dcc_dll_lock_req, ms_tx_dcc_dll_lock_req;
reg        sl_rx_dcc_dll_lock_req, sl_tx_dcc_dll_lock_req;
reg        ms_ns_adapter_rstn;
reg        sl_ns_adapter_rstn;
reg        ms_ns_mac_rdy;
reg        sl_ns_mac_rdy;
//reg        ms_device_detect, sl_por;
reg        m_power_on_reset_i;

reg [DATAWIDTH*2-1:0] ms_data_in;
wire [DATAWIDTH*2-1:0] sl_data_out;
wire [DATAWIDTH*2-1:0] ms_data_out;
wire   ms_m_ns_fwd_clk, ms_m_ns_rcv_clk;
wire   sl_m_ns_fwd_clk, sl_m_ns_rcv_clk;

assign ms_m_ns_fwd_clk = clk;
assign ms_m_ns_rcv_clk = clk;
assign sl_m_ns_fwd_clk = clk;
assign sl_m_ns_rcv_clk = clk;


    int err_count;
    int run_for_n_pkts;
        
    logic [DATAWIDTH*2 -1:0] xmit_q [$];
        


initial
      $vcdpluson(0, tb_top);

initial begin
	run_for_n_pkts = 10;
        clk = 1'b0;
        ms_ns_adapter_rstn = 1'b0;
        sl_ns_adapter_rstn = 1'b0;
        ms_ns_mac_rdy = 1'b0;
        sl_ns_mac_rdy = 1'b0;
        ms_config_done = 1'b0;
        sl_config_done = 1'b0;
	ms_rx_dcc_dll_lock_req = 1'b0;
	ms_tx_dcc_dll_lock_req = 1'b0;
	sl_rx_dcc_dll_lock_req = 1'b0;
	sl_tx_dcc_dll_lock_req = 1'b0;
        ms_data_in[DATAWIDTH*2-1:0] = {(DATAWIDTH*2){1'b0}};
//      ms_device_detect = 1'b0;
        m_power_on_reset_i = 1'b0; 
//      sl_por = 1'b0;
        repeat (10) @(posedge clk);
        m_power_on_reset_i = 1'b1;
        repeat (10) @(posedge clk);
//      ms_device_detect = 1'b1;
        repeat (10) @(posedge clk);
        m_power_on_reset_i = 1'b0;
//      sl_por = 1'b1;
        ms_config_done = 1'b1;
        sl_config_done = 1'b1;
        repeat (10) @(posedge clk);
        ms_ns_adapter_rstn = 1'b1;
        sl_ns_adapter_rstn = 1'b1;
        ms_ns_mac_rdy = 1'b1;
        sl_ns_mac_rdy = 1'b1;
        repeat (10) @(posedge clk);
        repeat (2) @(posedge clk);
	ms_rx_dcc_dll_lock_req = 1'b1;
	sl_rx_dcc_dll_lock_req = 1'b0;
	sl_tx_dcc_dll_lock_req = 1'b1;
	ms_tx_dcc_dll_lock_req = 1'b1;
        repeat (2) @(posedge clk);
        repeat (20) @(posedge clk);
	sl_rx_dcc_dll_lock_req = 1'b1;
        repeat (300) @(posedge clk);
        wait_xfer_ready     ();
	fork
	    data_xmit ();
	    data_rcv  ();
	join
	$display ("[%t] #########  All Tasks are finished normally #############", $time);
        repeat (20) @(posedge clk);
        repeat (100) @(posedge clk);
        //ms_data_in[DATAWIDTH*2-1:0] = {(DATAWIDTH*2){1'b0}};
        repeat (100) @(posedge clk);
        ms_ns_mac_rdy = 1'b0;
        repeat (100) @(posedge clk);
        sl_ns_mac_rdy = 1'b0;
        repeat (100) @(posedge clk);
        ms_ns_mac_rdy = 1'b1;
        ms_data_in[DATAWIDTH*2-1:0] = {(DATAWIDTH*2){1'b0}};
        repeat (100) @(posedge clk);
        sl_ns_mac_rdy = 1'b1;
        repeat (100) @(posedge clk);
        ms_ns_adapter_rstn = 1'b0;
        sl_ns_adapter_rstn = 1'b0;
        repeat (100) @(posedge clk);
	ms_rx_dcc_dll_lock_req = 1'b0;
	sl_rx_dcc_dll_lock_req = 1'b0;
	sl_tx_dcc_dll_lock_req = 1'b0;
	ms_tx_dcc_dll_lock_req = 1'b0;
        repeat (100) @(posedge clk);
        ms_ns_adapter_rstn = 1'b1;
        sl_ns_adapter_rstn = 1'b1;
        repeat (100) @(posedge clk);
	ms_rx_dcc_dll_lock_req = 1'b1;
	sl_rx_dcc_dll_lock_req = 1'b1;
	sl_tx_dcc_dll_lock_req = 1'b1;
        repeat (100) @(posedge clk);
	ms_tx_dcc_dll_lock_req = 1'b1;
        repeat (300) @(posedge clk);
        Finish();
        end


aib #(.DATAWIDTH(DATAWIDTH)) 
master
 (  //IO pads, AIB channel
    .iopad_tx(ms_tx),
    .iopad_rx(ms_rx),
    .iopad_ns_rcv_clkb(ms_ns_rcv_clkb), 
    .iopad_ns_rcv_clk(ms_ns_rcv_clk),
    .iopad_ns_fwd_clk(ms_ns_fwd_clk), 
    .iopad_ns_fwd_clkb(ms_ns_fwd_clkb),
    .iopad_ns_sr_clk(ms_sr_clk), 
    .iopad_ns_sr_clkb(ms_sr_clkb),
    .iopad_ns_sr_load(ms_sr_load), 
    .iopad_ns_sr_data(ms_sr_data),
    .iopad_ns_mac_rdy(iopad_ns_mac_rdy), 
    .iopad_ns_adapter_rstn(iopad_ns_adapter_rstn),
    .iopad_spare1(ms_spare1), 
    .iopad_spare0(ms_spare0),
    .iopad_fs_rcv_clkb(ms_fs_rcv_clkb), 
    .iopad_fs_rcv_clk(ms_fs_rcv_clk),
    .iopad_fs_fwd_clkb(ms_fs_fwd_clkb), 
    .iopad_fs_fwd_clk(ms_fs_fwd_clk),
    .iopad_fs_sr_clkb(sl_sr_clkb), 
    .iopad_fs_sr_clk(sl_sr_clk),
    .iopad_fs_sr_load(sl_sr_load), 
    .iopad_fs_sr_data(sl_sr_data),
    .iopad_fs_mac_rdy(iopad_fs_mac_rdy), 
    .iopad_fs_adapter_rstn(iopad_fs_adapter_rstn),
    //IO pads, AUX channel
    .iopad_device_detect(iopad_device_detect),
    .iopad_device_detect_copy(iopad_device_detect_copy),
    .iopad_por(iopad_por),
    .iopad_por_copy(iopad_por_copy),

    //Control/status from/to MAC 
    .data_in(ms_data_in[DATAWIDTH*2 -1:0]), //output data to pad
    .data_out(ms_data_out[DATAWIDTH*2 -1:0]), //input data from pad
    .m_ns_fwd_clk(ms_m_ns_fwd_clk), //output data clock
    .m_fs_rcv_clk(), 
    .m_fs_fwd_clk(), 
    .m_ns_rcv_clk(ms_m_ns_rcv_clk), 

    .ms_ns_adapter_rstn(ms_ns_adapter_rstn),
    .sl_ns_adapter_rstn(sl_ns_adapter_rstn),
    .ms_ns_mac_rdy(ms_ns_mac_rdy),
    .sl_ns_mac_rdy(sl_ns_mac_rdy),
    .fs_mac_rdy(),

    .ms_config_done(ms_config_done),
    .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req),
    .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req),
    .sl_config_done(sl_config_done),
    .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req),
    .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req),
    .ms_tx_transfer_en(),
    .ms_rx_transfer_en(),
    .sl_tx_transfer_en(),
    .sl_rx_transfer_en(),
    .sr_ms_tomac(),
    .sr_sl_tomac(),
    .ms_nsl(1'b1),

    //IO buffer control from MAC
    .iddren(1'b1),
    .idataselb(1'b0), //output async data selection
    .itxen(1'b1), //data tx enable
    .irxen(3'b111),//data input enable

    //Aux channel signals from MAC
//  .ms_device_detect(ms_device_detect),
//  .sl_por(),

    .m_por_ovrd(1'b0),
    .m_device_detect_ovrd(1'b0),
    .m_power_on_reset_i(),
    .m_device_detect(),
    .m_power_on_reset(),


    //JTAG ports
    .jtag_clkdr_in(1'b0),
    .scan_out(),
    .jtag_intest(1'b0),
    .jtag_mode_in(1'b0),
    .jtag_rstb(1'b0),
    .jtag_rstb_en(1'b0),
    .jtag_weakpdn(1'b0),
    .jtag_weakpu(1'b0),
    .jtag_tx_scanen_in(1'b0),
    .scan_in(1'b0),

//Redundancy control signals
`include "redundancy_ctrl_sim.vh"
//`include "redundancy_ctrl_simt.vh"

    .sl_external_cntl_26_0(27'b0),
    .sl_external_cntl_30_28(3'b0),
    .sl_external_cntl_57_32(26'b0),

    .ms_external_cntl_4_0(5'b0),
    .ms_external_cntl_65_8(58'hf),

    .vccl_aib(1'b1),
    .vssl_aib(1'b0) );

aib #(.DATAWIDTH(DATAWIDTH))
slave
 (  //IO pads, AIB channel
    .iopad_tx(ms_rx),
    .iopad_rx(ms_tx),
    .iopad_ns_rcv_clkb(ms_fs_rcv_clkb), 
    .iopad_ns_rcv_clk(ms_fs_rcv_clk),
    .iopad_ns_fwd_clk(ms_fs_fwd_clk), 
    .iopad_ns_fwd_clkb(ms_fs_fwd_clkb),
    .iopad_ns_sr_clk(sl_sr_clk), 
    .iopad_ns_sr_clkb(sl_sr_clkb),
    .iopad_ns_sr_load(sl_sr_load), 
    .iopad_ns_sr_data(sl_sr_data),
    .iopad_ns_mac_rdy(iopad_fs_mac_rdy), 
    .iopad_ns_adapter_rstn(iopad_fs_adapter_rstn),
    .iopad_spare1(ms_spare0), 
    .iopad_spare0(ms_spare1),
    .iopad_fs_rcv_clkb(ms_ns_rcv_clkb), 
    .iopad_fs_rcv_clk(ms_ns_rcv_clk),
    .iopad_fs_fwd_clkb(ms_ns_fwd_clkb), 
    .iopad_fs_fwd_clk(ms_ns_fwd_clk),
    .iopad_fs_sr_clkb(ms_sr_clkb), 
    .iopad_fs_sr_clk(ms_sr_clk),
    .iopad_fs_sr_load(ms_sr_load), 
    .iopad_fs_sr_data(ms_sr_data),
    .iopad_fs_mac_rdy(iopad_ns_mac_rdy), 
    .iopad_fs_adapter_rstn(iopad_ns_adapter_rstn),
    //IO pads, AUX channel
    .iopad_device_detect(iopad_device_detect),
    .iopad_device_detect_copy(iopad_device_detect_copy),
    .iopad_por(iopad_por),
    .iopad_por_copy(iopad_por_copy),

    //Control/status from/to MAC 
    .data_in(sl_data_out[DATAWIDTH*2-1:0]), //output data to pad
    .data_out(sl_data_out[DATAWIDTH*2-1:0]), //input data from pad
    .m_ns_fwd_clk(sl_m_ns_fwd_clk), //output data clock
    .m_fs_rcv_clk(), 
    .m_fs_fwd_clk(), 
    .m_ns_rcv_clk(sl_m_ns_rcv_clk), 

    .ms_ns_adapter_rstn(ms_ns_adapter_rstn),
    .sl_ns_adapter_rstn(sl_ns_adapter_rstn),
    .ms_ns_mac_rdy(ms_ns_mac_rdy),
    .sl_ns_mac_rdy(sl_ns_mac_rdy),
    .fs_mac_rdy(),

    .ms_config_done(ms_config_done),
    .ms_rx_dcc_dll_lock_req(ms_rx_dcc_dll_lock_req),
    .ms_tx_dcc_dll_lock_req(ms_tx_dcc_dll_lock_req),
    .sl_config_done(sl_config_done),
    .sl_rx_dcc_dll_lock_req(sl_rx_dcc_dll_lock_req),
    .sl_tx_dcc_dll_lock_req(sl_tx_dcc_dll_lock_req),
    .ms_tx_transfer_en(),
    .ms_rx_transfer_en(),
    .sl_tx_transfer_en(),
    .sl_rx_transfer_en(),
    .sr_ms_tomac(),
    .sr_sl_tomac(),
    .ms_nsl(1'b0),

    //IO buffer control from MAC
    .iddren(1'b1),
    .idataselb(1'b0), //output async data selection
    .itxen(1'b1), //data tx enable
    .irxen(3'b111),//data input enable

    //Aux channel signals from MAC
//  .ms_device_detect(),
//  .sl_por(sl_por),
    .m_por_ovrd(1'b0),
    .m_device_detect_ovrd(1'b0),
    .m_power_on_reset_i(m_power_on_reset_i),
    .m_device_detect(),
    .m_power_on_reset(),


    //JTAG ports
    .jtag_clkdr_in(1'b0),
    .scan_out(),
    .jtag_intest(1'b0),
    .jtag_mode_in(1'b0),
    .jtag_rstb(1'b0),
    .jtag_rstb_en(1'b0),
    .jtag_weakpdn(1'b0),
    .jtag_weakpu(1'b0),
    .jtag_tx_scanen_in(1'b0),
    .scan_in(1'b0),

//Redundancy control signals
`include "./redundancy_ctrl_sim.vh"
//`include "./redundancy_ctrl_simr.vh"

    .sl_external_cntl_26_0({1'b1,26'b0}),
    .sl_external_cntl_30_28(3'b0),
    .sl_external_cntl_57_32(26'b0),

    .ms_external_cntl_4_0(5'b0),
    .ms_external_cntl_65_8(58'b0),

    .vccl_aib(1'b1),
    .vssl_aib(1'b0) );

    task wait_xfer_ready();
        wait (tb_top.master.aib_channel.aib_sm.ms_tx_transfer_en);
        
    endtask

    task data_xmit ();
	static int pkts_gen = 0;
	bit [DATAWIDTH*2 -1:0] data = 0;
	
        while (pkts_gen < run_for_n_pkts) begin
	    data[DATAWIDTH*2 -1:DATAWIDTH] = $random;
	    data[DATAWIDTH -1:0] = $random;
	    $display ("[%t] Generating data[%d] = %x \n", $time, pkts_gen, data);
            
	    @(posedge tb_top.clk);
	    tb_top.ms_data_in[DATAWIDTH*2-1:0] <= data[DATAWIDTH*2-1:0];
            xmit_q.push_back(data);
            pkts_gen++;
        end
    endtask

    //*************************************************
    // task to check data received on TX side
    //*************************************************
    task data_rcv ();
        bit [DATAWIDTH*2 -1:0] data_exp = 0;
        static int pkts_rcvd = 0;
        begin
            while(pkts_rcvd < run_for_n_pkts) begin
                @ (posedge tb_top.ms_fs_rcv_clk);
                if (tb_top.master.iddren & tb_top.slave.iddren & ({tb_top.ms_data_out[DATAWIDTH*2-1:0]} != 0)) begin
                    $display ("[%t] Receiving data[%d] = %x \n", $time, pkts_rcvd, tb_top.ms_data_out[DATAWIDTH*2-1:0]);
                    data_exp = xmit_q.pop_front();
                    pkts_rcvd++;
                    if ({tb_top.ms_data_out[DATAWIDTH*2-1:0]} != data_exp) begin
                        err_count++;
                        $display ("[%t]DATA COMPARE ERROR: received = %x | expected = %x\n", $time, tb_top.ms_data_out[DATAWIDTH*2-1:0], data_exp);
                    end   
                end
                else
                 if (!tb_top.master.iddren & !tb_top.slave.iddren & ({tb_top.ms_data_out[DATAWIDTH-1:0]} != 0)) begin
                    $display ("[%t] Receiving data[%d] = %x \n", $time, pkts_rcvd, tb_top.ms_data_out[DATAWIDTH-1:0]);
                    data_exp = xmit_q.pop_front();
                    pkts_rcvd++;
                    if ({tb_top.ms_data_out[DATAWIDTH-1:0]} != data_exp[DATAWIDTH-1:0]) begin
                        err_count++;
                        $display ("[%t]DATA COMPARE ERROR: received = %x | expected = %x\n", $time, tb_top.ms_data_out[DATAWIDTH*2-1:0], data_exp);
                    end   
                end
            end
            if (xmit_q.size() != 0) //check if all the data are received
              $display("[%t]ERROR: Tramit Queue Not Empty, still %d data left\n", $time, xmit_q.size());
            
        end
    endtask // mstr_req_rcv
        


    //---------------------------------------------------------------
    // Finish

    task Finish ();
	begin
	    $display("%0t: %m: finishing simulation..", $time);
	    repeat (100) @(posedge tb_top.clk);
	    $display("\n////////////////////////////////////////////////////////////////////////////");
	    $display("%0t: Simulation ended, ERROR count: %0d", $time, err_count);
	    $display("////////////////////////////////////////////////////////////////////////////\n");
            if (err_count == 0) begin
                $display("+++++++++++++++++++++++++++++++++\n");
                $display("TEST PASSED!!!!!!!!!!!\n");
                $display("+++++++++++++++++++++++++++++++++\n");
            end
	    $finish;
	end
    endtask

endmodule
