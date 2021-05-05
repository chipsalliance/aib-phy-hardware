05/05/2021

============================================================
Test bench(top_tb.sv and top_tb_ch.sv) description
============================================================

                 ---------------                           ---------------
    random       |             |                           |             |-----> rx data checker
    data  tx---->| dut_master1 |<=========================>| dut_slave1  |
                 |             |                           |             |-----> tx random data
    data  rx<----|             |                           |             | 
    checker      |             |                           |             | 
                 ---------------                           ---------------  
                 master aka leader                         slave aka follower 

Test vectors:
The rest of the test vectors are located in the testcases dir. Link or copy them to this dir.

Three cases for running 24 channel leader and follower:
===========================================================
1) AIB2.0 (Gen2)  <---->  AIB2.0 (Gen2)
===========================================================
Commands to run VCS test:
./run_compile.ch  -- VCS for single channel
./simv
test vector: fifo1x_test_ch.inc
             fifo2x_test_ch.inc
             fifo4x_test_ch.inc
             reg_test_ch.inc
             redundancy_ch.inc
./run_compile     -- VCS for stack (24 channel + aux)
./simv
test vector: fifo2x_test.inc
             fifo2x_test.inc
             fifo4x_test.inc
             reg_test.inc

Commands to run ncsim test
./runnc.ch
==========================================================
2) AIB2.0 Gen1 Leader <---->  AIB1.0 Follower (FPGA)
==========================================================
commands to run
./run_compile_m2s1
./simv
test vector: fifo2x_test_slaib1.inc

==========================================================
3) AIB1.0 Leader  <-----> AIB2.0 Gen1 Follower
==========================================================
command to run
./run_compile_m1s2
./simv
test vector: fifo2x_testmsaib1.inc
