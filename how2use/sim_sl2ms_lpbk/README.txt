07/03/2019

============================================================
Test bench(top.sv) description
============================================================
c3aib c3aib_master and (CHIP AIB(aib) model or s10aib FPGA aib model) are instantiated in the test bench. the left side as slave, the right side is c3aib.
Both clocks and data are supplied at the slave side. c3aib was properly configured in loopback mode and release the reset. No transfer clocks and data supplied at master side.

                 ------------                           ---------------
    random       |          |                           |       rx-->||
    data  tx---->| s10aib   |<=========================>| c3aib      V|(data loopback at master side)
                 |          |                           |       tx<--||
    data  rx<----|          |                           |             | 
    checker      |          |                           |             | 
                 -----------                            ---------------  
                   slave                                  master 


Three simulator supported:
./runsim  -- VCS
./runnc   -- Cadence
./runvsim -- Modelsim
