README.txt
Aug. 03, 2021

============================================================
============================================================

Included in this package are:
1. AIB 2.0 behavior RTL based on AIB spec 2.0 
   a) Dual mode (Leader and Follower  aka. Master and Slave) single channel 
   b) Dual mode (Leader and Follower  aka. Master and Slave) 24 channel + aux aka. stack 
2. SystemVerilog DV suites for single channel and the stack. 
   a) In both test suite, top level RTL configed as leader and follower.
   b) Traffic are generated from transmit side of leader and master.
   c) Traffic are auto checked at the receiver side of the leader and master.
   d) Basic data path configurations tests are provided.
3. For avmm register detail, see aib_csr_for_2.0_v3.xlsx in doc directory at the top.

===========================================================
Revision history:
Version 1.0: Initial release
04/05/2021: Changelist
1) Modified AIB model ports. The microbump names changed.
2) Changed default marker bit position from bit 78 to bit 77
3) Modified adaptor FIFO reset sequence.
4) Added redundancy test.
5) Added ncsim simulation support

05/05/2021: Changelist
1) Modified testbench and test vector to include
   AIB2.0 leader      <---> AIB 2.0 Follower (Gen2)
   AIB2.0 Leader Gen1 <---> AIB 1.0 Follower (FPGA)
   AIB1.0 Leader      <---> AIB 2.0 Follower Gen1
2) See README.txt under sims for the detail instruction to run

08/03/2021: changelist
Added three test cases:
   fifo1x_test_msaib1.inc
   fifo2x_fifo4x_test.inc
   fifo1x_test_slaib1.inc
For detail how to run these test, see README.txt under aib-phy-hardware/v2.0/rev1/dv/sims
============================================================
Files included:
============================================================
README.txt           - This file

============================================================



rev1
├── dv
│   ├── emib                    -- Connection files for Leader and Follower chiplets
│   ├── flist                   -- File lists for compilation
│   │   ├── ms.cf               -- File list for RTL
│   │   ├── tb_rtl.cf           -- File list for 24 channel + AUX DV files
│   │   └── tb_rtl_ch.cf        -- File list for single channel DV files
│   ├── interface
│   │   ├── avalon_mm_if.sv     -- Avalon memory mapping interface
│   │   ├── dut_if_mac_ch.sv    -- Mac interface for single channel
│   │   ├── dut_if_mac.sv       -- Mac interface for 24 channel + AUX
│   │   ├── dut_ms1_port_ch.inc -- master model port instantiation per channel
│   │   ├── dut_ms1_port.inc    -- master model port instantiation for 24 channel
│   │   ├── dut_sl1_port_ch.inc -- slave model port instantiation per channel
│   │   └── dut_sl1_port.inc    -- slave model port instantiation for 24 channel
│   ├── sims                    -- Go to this directory for running the test. See README.txt in this subdirectory.
│   │   ├── run_compile         -- compile script for 24 channel
│   │   ├── run_compile.ch      -- compile script for single channel
│   │   ├── test_ch.inc         -- test vector for single channel For more test case, copy or link from ./test/test_cases
│   │   └── test.inc            -- test vector for 24 channels. For more test case, copy or link from ./test/test_cases
│   ├── tb
│   │   ├── top_tb_ch.sv        -- Top level test bench for single channel
│   │   ├── top_tb_declare_ch.inc
│   │   ├── top_tb_declare.inc
│   │   └── top_tb.sv           -- Top level test bench for 24 channel + aux
│   └── test
│       ├── task
│       │   ├── agent_ch.sv     -- Basic test vector task for single channel
│       │   └── agent.sv        -- Basic test vector task for 24 channel + aux
│       └── test_cases
│           ├── fifo1x_test_ch.inc  -- Test single channle FIFO 1X mode
│           ├── fifo1x_test.inc     -- Test 24 channle FIFO 1X mode
│           ├── fifo2x_test_ch.inc  -- Test single channle FIFO 2X mode
│           ├── fifo2x_test.inc     -- Test 24 channle FIFO 2X mode
│           ├── fifo4x_test_ch.inc  -- Test single channle FIFO 4X mode
│           ├── fifo4x_test.inc     -- Test 24 channle FIFO 4X mode
│           ├── reg_test_ch.inc     -- Test single channle register mode
│           |── reg_test.inc        -- Test 24 channle register mode
│           |── redundancy_ch.inc   -- Test single channel redunduncy repair
└── rtl                          -- AIB 2.0 RTL model
    ├── aib_adapt_2doto.v        -- Dual mode aib adapter top level
    ├── aib_adapt_rxchnl.v
    ├── aib_adaptrxdbi_rxdp.v
    ├── aib_adaptrxdp_async_fifo.v
    ├── aib_adaptrxdp_fifo_ptr.v
    ├── aib_adaptrxdp_fifo_ram.v
    ├── aib_adaptrxdp_fifo.v
    ├── aib_adaptrxdp_rxdp.v
    ├── aib_adapt_txchnl.v
    ├── aib_adapttxdbi_txdp.v
    ├── aib_adapttxdp_async_fifo.v
    ├── aib_adapttxdp_fifo_ptr.v
    ├── aib_adapttxdp_fifo_ram.v
    ├── aib_adapttxdp_fifo.v
    ├── aib_aliasd.v
    ├── aib_aux_channel.v      -- Dual mode Top level for aux channel
    ├── aib_avmm_adapt_csr.v
    ├── aib_avmm_aibio_csr.v
    ├── aib_avmm_rdl_intf.sv
    ├── aib_avmm.v
    ├── aib_bitsync.v
    ├── aib_bsr_red_wrap.v
    ├── aib_buffx1_top.v
    ├── aib_channel.v          -- Dual mode Top level for single channel aib 2.0
    ├── aib_dcc.v
    ├── aib_io_buffer.sv
    ├── aib_ioring.v
    ├── aib_jtag_bscan.v
    ├── aib_model_top.v        -- Dual mode Top level for 24 channel plus aux 
    ├── aib_mux21.v
    ├── aib_redundancy.v
    ├── aib_rstnsync.v
    ├── aib_sm.v
    ├── aib_sr_ms.v
    ├── aib_sr_sl.v
    └── dll.sv

