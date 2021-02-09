    //=================================================================================
    // AIB IOs
    //=================================================================================
    wire [39:0] m1_iopad_tx;
    wire [39:0] m1_iopad_rx;
    wire        m1_iopad_ns_rcv_clkb;
    wire        m1_iopad_ns_rcv_clk;
    wire        m1_iopad_ns_fwd_clk;
    wire        m1_iopad_ns_fwd_clkb;
    wire        m1_iopad_ns_sr_clk;
    wire        m1_iopad_ns_sr_clkb;
    wire        m1_iopad_ns_sr_load;
    wire        m1_iopad_ns_sr_data;
    wire        m1_iopad_ns_mac_rdy;
    wire        m1_iopad_ns_adapter_rstn;
    wire        m1_iopad_spare1;
    wire        m1_iopad_spare0;
    wire        m1_iopad_fs_rcv_clkb;
    wire        m1_iopad_fs_rcv_clk;
    wire        m1_iopad_fs_fwd_clkb;
    wire        m1_iopad_fs_fwd_clk;
    wire        m1_iopad_fs_sr_clkb;
    wire        m1_iopad_fs_sr_clk;
    wire        m1_iopad_fs_sr_load;
    wire        m1_iopad_fs_sr_data;
    wire        m1_iopad_fs_mac_rdy;
    wire        m1_iopad_fs_adapter_rstn;
    //========================================================================
    // Register config for testbench
    //========================================================================
    reg  [1:0]  ms1_tx_fifo_mode;
    reg  [1:0]  sl1_tx_fifo_mode;
    reg  [1:0]  ms1_rx_fifo_mode;
    reg  [1:0]  sl1_rx_fifo_mode;
