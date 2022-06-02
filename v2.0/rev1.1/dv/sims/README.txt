04/21/2022

============================================================
Test bench(top_tb.sv and top_tb_ch.sv) description
The top_tb.sv is located in rev1/dv/tb. rev1.1 re-use the top_tb.
The dut_master1 is AIB2.0 Gen1 
The dut_slave1 is replaced by or maib rev1.1. (Note, aux channel sit outside of maib top)
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
For example:
test.inc -> ../../../rev1/dv/test/test_cases/fifo2x_test_slaib1.inc


==========================================================
   AIB2.0 Gen1 Leader BCA or AIB2.0 model <---->  AIB1.0 Follower (FPGA MAIB rev1.1)
   The FPGA is 80 bit 2XFIFO mode.
   The master is 80 bit 2xFIFO mode or 40 bit 1XFIFO mode
==========================================================
commands to run
./run_compile_m2s1
./simv
test vector: fifo2x_test_slaib1.inc
             fifo1x_test_slaib1.inc
