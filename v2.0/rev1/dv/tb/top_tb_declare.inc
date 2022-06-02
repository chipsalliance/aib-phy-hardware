    //=================================================================================
    // Slave AIB IOs
    //=================================================================================
    wire [M_PAD_NUM-1:0] m1_iopad_ch0_aib;
    wire [S_PAD_NUM-1:0] s1_iopad_ch0_aib;
    wire [M_PAD_NUM-1:0] m1_iopad_ch1_aib;
    wire [S_PAD_NUM-1:0] s1_iopad_ch1_aib;
    wire [M_PAD_NUM-1:0] m1_iopad_ch2_aib;
    wire [S_PAD_NUM-1:0] s1_iopad_ch2_aib;
    wire [M_PAD_NUM-1:0] m1_iopad_ch3_aib;
    wire [S_PAD_NUM-1:0] s1_iopad_ch3_aib;
    wire [M_PAD_NUM-1:0] m1_iopad_ch4_aib;
    wire [S_PAD_NUM-1:0] s1_iopad_ch4_aib;
    wire [M_PAD_NUM-1:0] m1_iopad_ch5_aib;
    wire [S_PAD_NUM-1:0] s1_iopad_ch5_aib;
    wire [M_PAD_NUM-1:0] m1_iopad_ch6_aib;
    wire [S_PAD_NUM-1:0] s1_iopad_ch6_aib;
    wire [M_PAD_NUM-1:0] m1_iopad_ch7_aib;
    wire [S_PAD_NUM-1:0] s1_iopad_ch7_aib;
    wire [M_PAD_NUM-1:0] m1_iopad_ch8_aib;
    wire [S_PAD_NUM-1:0] s1_iopad_ch8_aib;
    wire [M_PAD_NUM-1:0] m1_iopad_ch9_aib;
    wire [S_PAD_NUM-1:0] s1_iopad_ch9_aib;
    wire [M_PAD_NUM-1:0] m1_iopad_ch10_aib;
    wire [S_PAD_NUM-1:0] s1_iopad_ch10_aib;
    wire [M_PAD_NUM-1:0] m1_iopad_ch11_aib;
    wire [S_PAD_NUM-1:0] s1_iopad_ch11_aib;
    wire [M_PAD_NUM-1:0] m1_iopad_ch12_aib;
    wire [S_PAD_NUM-1:0] s1_iopad_ch12_aib;
    wire [M_PAD_NUM-1:0] m1_iopad_ch13_aib;
    wire [S_PAD_NUM-1:0] s1_iopad_ch13_aib;
    wire [M_PAD_NUM-1:0] m1_iopad_ch14_aib;
    wire [S_PAD_NUM-1:0] s1_iopad_ch14_aib;
    wire [M_PAD_NUM-1:0] m1_iopad_ch15_aib;
    wire [S_PAD_NUM-1:0] s1_iopad_ch15_aib;
    wire [M_PAD_NUM-1:0] m1_iopad_ch16_aib;
    wire [S_PAD_NUM-1:0] s1_iopad_ch16_aib;
    wire [M_PAD_NUM-1:0] m1_iopad_ch17_aib;
    wire [S_PAD_NUM-1:0] s1_iopad_ch17_aib;
    wire [M_PAD_NUM-1:0] m1_iopad_ch18_aib;
    wire [S_PAD_NUM-1:0] s1_iopad_ch18_aib;
    wire [M_PAD_NUM-1:0] m1_iopad_ch19_aib;
    wire [S_PAD_NUM-1:0] s1_iopad_ch19_aib;
    wire [M_PAD_NUM-1:0] m1_iopad_ch20_aib;
    wire [S_PAD_NUM-1:0] s1_iopad_ch20_aib;
    wire [M_PAD_NUM-1:0] m1_iopad_ch21_aib;
    wire [S_PAD_NUM-1:0] s1_iopad_ch21_aib;
    wire [M_PAD_NUM-1:0] m1_iopad_ch22_aib;
    wire [S_PAD_NUM-1:0] s1_iopad_ch22_aib;
    wire [M_PAD_NUM-1:0] m1_iopad_ch23_aib;
    wire [S_PAD_NUM-1:0] s1_iopad_ch23_aib;
    wire HI = 1'b1;
    wire LO = 1'b0;
    //=================================================================================
    // Register config for testbench 
    //=================================================================================
    reg  [1:0]  ms1_tx_fifo_mode;
    reg  [1:0]  sl1_tx_fifo_mode;
    reg  [1:0]  ms1_rx_fifo_mode;
    reg  [1:0]  sl1_rx_fifo_mode;
    reg  [4:0]  ms1_tx_markbit;
    reg  [4:0]  sl1_tx_markbit;
    reg         ms1_gen1;
    reg         sl1_gen1;
    reg         ms1_lpbk;
    reg         sl1_lpbk;
    reg         ms1_dbi_en;
    reg         sl1_dbi_en;
