02/09/2021

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

Commands to run VCS test:
./run_compile.ch  -- VCS for single channel
./simv
./run_compile     -- VCS for stack (24 channel + aux)
./simv
