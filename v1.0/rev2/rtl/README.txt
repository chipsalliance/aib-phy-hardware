README.txt
January 29, 2020

===========================================================
Revision history:
Version 1.0: Initial release
===========================================================
Four example IPs are provided for user to reference.
Multiple chiplet simulation examples will be provided in future release


                             Pair1                                 Pair2
                 ------------        -----------       ------------        -----------    
                 |          | EMIB   |         |       |          | EMIB   |         |
                 | v1_master|<======>| v2_slave|       | v2_master|<======>| v1_slave|
                 |          |        |         |       |          |        |         |
                 |          |        |         |       |          |        |         |
                 -----------         -----------       -----------         -----------
                   Chiplet1                    Chiplet2                     FPGA (S10)



Included in this directory are RTL file for 4 AIB IPs shown as above diagram. 

rtl
├── README.txt                    -- This file
├── v1_master                     -- 24 channel plus aux AIB IP legacy design that works in chiplet1. 
│   ├── aibcr3aux_lib
│   ├── aibcr3_lib
│   ├── aibcr3pnr_lib
│   ├── c3aibadapt
│   ├── c3aibadapt_wrap
│   ├── c3dfx
│   ├── c3lib
│   └── README.txt                -- For top level RTL and file list for the IP, see here
├── v1_slave                      -- 24 channel slave AIB plus AUX of FPGA models Chiplet3. 
│   ├── aibndaux_lib
│   ├── aibnd_lib
│   ├── aibndpnr_lib
│   ├── cdclib
│   ├── cfg_shared
│   ├── hdpldadapt
│   ├── io_common_custom
│   ├── README.txt                -- For top level RTL and file list for the IP, see here
│   ├── s10aib
│   └── soc_std_macro
├── v2_common                     -- common files that shared between v2_slave IP and v2_master IP 
│   ├── aibcr3aux_lib
│   ├── aibcr3_lib
│   ├── aibcr3pnr_lib
│   ├── ana
│   ├── armod
│   ├── c3aibadapt
│   ├── c3aibadapt_wrap
│   ├── c3dfx
│   ├── c3lib
│   ├── dig
│   └── README.txt
├── v2_master                    -- top level of 24 channel plus aux AIB IP legacy master design for Chiplet2.
│   ├── c3aibadapt_wrap
│   └── README.txt               -- For top level RTL and file list for the IP, see here
└── v2_slave                     -- top level of 24 channel plus aux AIB IP legacy slave design Chiplet2. 
    ├── aibadapt_wrap
    ├── aib_slv
    └── README.txt               -- For top level RTL and file list for the IP, see here

    
===========================================================
File list for compilation:
===========================================================
Instruction for compilation:
1) File sharing: Same file name but different content are existed in this multi-die drop.
2) v2 master/v2_common/v1_slave has no file collision.
3) v1_master will have file collision with v2_master/v2_slave system.
4) Suggest compile v1_master in its own library.
                   v2_master and v2_slave in its own libarary
                   v1_slave in its own library
