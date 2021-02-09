    //=================================================================================
    // Slave AIB IOs
    //=================================================================================
    wire [40*24-1:0] m1_iopad_tx;
    wire [40*24-1:0] m1_iopad_rx;
    wire [23:0]      m1_iopad_ns_rcv_clkb;
    wire [23:0]      m1_iopad_ns_rcv_clk;
    wire [23:0]      m1_iopad_ns_fwd_clk;
    wire [23:0]      m1_iopad_ns_fwd_clkb;
    wire [23:0]      m1_iopad_ns_sr_clk;
    wire [23:0]      m1_iopad_ns_sr_clkb;
    wire [23:0]      m1_iopad_ns_sr_load;
    wire [23:0]      m1_iopad_ns_sr_data;
    wire [23:0]      m1_iopad_ns_mac_rdy;
    wire [23:0]      m1_iopad_ns_adapter_rstn;
    wire [23:0]      m1_iopad_spare1;
    wire [23:0]      m1_iopad_spare0;
    wire [23:0]      m1_iopad_fs_rcv_clkb;
    wire [23:0]      m1_iopad_fs_rcv_clk;
    wire [23:0]      m1_iopad_fs_fwd_clkb;
    wire [23:0]      m1_iopad_fs_fwd_clk;
    wire [23:0]      m1_iopad_fs_sr_clkb;
    wire [23:0]      m1_iopad_fs_sr_clk;
    wire [23:0]      m1_iopad_fs_sr_load;
    wire [23:0]      m1_iopad_fs_sr_data;
    wire [23:0]      m1_iopad_fs_mac_rdy;
    wire [23:0]      m1_iopad_fs_adapter_rstn;

    //=================================================================================
    // Register config for testbench 
    //=================================================================================
    reg  [1:0]  ms1_tx_fifo_mode;
    reg  [1:0]  sl1_tx_fifo_mode;
    reg  [1:0]  ms1_rx_fifo_mode;
    reg  [1:0]  sl1_rx_fifo_mode;

