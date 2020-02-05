07/03/2019

============================================================
Test bench(top.sv) description
============================================================
c3aib c3aib_master and (CHIP AIB(aib) model or s10aib FPGA aib model) are instantiated in the test bench. the left side as master, the right side CHIP AIB model or s10aib as slave.
AS is illustrated below:
    if S10_MODEL macro turn on rx_parallel_data will looped back to tx_parallel_data.
    Two modes of operation are supported by macro REGISTER_MOD. 
    1) if REGISTER_MOD on, FPGA side not using phasecom FIFO, lower speed, all 40 data bits are used.
    2) if REGISTER_MOD off, FPGA side is using phasecom FIFO at the half clock rate of master clock rate. 78 bit data width with alignment mark of bit 39/79.

                 ------------                           -----------
    random       |          |                           |         |rx-->|
    data  tx---->| c3aib    |<=========================>| s10aib  |     V (data loopback at FPGA fabric side)
                 |          |                           |         |tx<--|
    data  rx<----|          |                           |         |
    checker      |          |                           |         |
                 -----------                            -----------   
                   master                                 slave



    if S10_MODEL macro define not turn on, aib model is used at the slave side:
                 ------------                           -----------
    random       |          |                           |         |rx-->|
    data  tx---->| c3aib    |<=========================>|  aib    |     V (data loopback)
                 |          |                           |         |tx<--|
    data  rx<----|          |                           |         |
    checker      |          |                           |         |<---ms_nsl
                 -----------                            -----------    (1'b0, slave)
                   master                                 slave



Random data will be sent out from the master to slave. The data will be looped back in the slave after it is received, then sent back to master.
The received data from the master will be compared with the data sent out. Test is pass when all the data match.

This test bench is just an example for data transfer and checking. User can change the test bench, break the loop back on the slave, for independent simplex data transfer.

c3aib and the CHIP AIB model in the test bench includes one channel.

The following is the example of command to run simulation for different mode:

1) master connect to s10 model in register mode. Typical usage is for AIB control channel for low latency low performance.
vcs -sverilog +v2k -full64 +vcs+vcdpluson -timescale=1ps/1ps +define+VCS+TIMESCALE_EN+ALTR_HPS_INTEL_MACROS_OFF+S10_MODEL+REGISTER_MOD -f ./multidie.f ./top.sv ./dut_io.sv ./test.sv -l compile.log

2) master connect to s10 model in 1:2 phasecom FIFO mode. Typical usage is for AIB data channel for high bandwidth.
vcs -sverilog +v2k -full64 +vcs+vcdpluson -timescale=1ps/1ps +define+VCS+TIMESCALE_EN+ALTR_HPS_INTEL_MACROS_OFF+S10_MODEL -f ./multidie.f ./top.sv ./dut_io.sv ./test.sv -l compile.log

3) master connect to AIB model. The model matches to AIB specification 1.1.
vcs -sverilog +v2k -full64 +vcs+vcdpluson -timescale=1ps/1ps +define+VCS+TIMESCALE_EN+ALTR_HPS_INTEL_MACROS_OFF -f ./multidie.f ./top.sv ./dut_io.sv ./test.sv -l compile.log
