06/25/2022

============================================================
Test bench(top_tb.sv and top_tb_ch.sv) description
The top_tb.sv is located in rev1/dv/tb. rev1.1 re-use the top_tb.
The dut_master1 is replaced by BCA hard macro leader mode.
The dut_slave1 is replaced by either BCA hard macro follower mode
or maib rev1.1. (Note, aux channel sit outside of maib top)
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


Three cases for running 24 channel leader and follower:
===========================================================
1) AIB2.0 (Gen2) BCA  <---->  AIB2.0 (Gen2) BCA 
===========================================================
Commands to run VCS test:
./run_compile_bca     -- VCS for stack (24 channel + aux)
./simv
test vector: fifo1x_test.inc
             fifo2x_test.inc
             fifo4x_test.inc
             reg_test.inc
             fifo4x_dbi_test.inc
             fifo4x_nslpbk_test.inc
             fifo4x_fslpbk_test.inc   
             fifo2x_fifo4x_test.inc    //Asymmetric case

Note: Cadence ncsim example is provided. Commands to run:
./run_compile_bca_ncsim
./run_compile_bca_rotate -- If due to chiplet physical layout, so that Ch0 <-> Ch23 ... rotation are required 

==========================================================
2) AIB2.0 Gen1 Leader BCA or AIB2.0 model <---->  AIB1.0 Follower (FPGA MAIB rev1.1)
   The FPGA is 80 bit 2XFIFO mode.
   The master is 80 bit 2xFIFO mode or 40 bit 1XFIFO mode
==========================================================
commands to run
./run_compile_bca2s1 (Takes long time for simulation) or ./run_compile_m2s1
./simv
test vector: fifo2x_test_slaib1.inc
             fifo1x_test_slaib1.inc

==========================================================
3) AIB1.0 Leader  <-----> AIB2.0 Gen1 Follower (BCA)
   The leader is 40 bit register mode in 1GHZ
   The Follower is 2xFIFO mode with 80 bit or
                   1XFIFO mode with 40 bit
   This is only used to connect a legacy leader AIB 1.0 to BCA AIB2.0 Follower.
   In this case, the BCA AIB2.0 HM is rotated physically.  Ch0 <-> Ch23 ...
==========================================================
command to run
./run_compile_m1bca
./simv
test vector: fifo2x_test_msaib1.inc
test vector: fifo1x_test_msaib1.inc
