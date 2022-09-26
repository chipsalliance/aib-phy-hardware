## Advanced Interface Bus (AIB) PHY
This repository contains the RTL and cell models for the AIB interface.  See the [AIB Spec](https://github.com/chipsalliance/AIB-specification) for the AIB Specification.

September 26, 2022

AIB 1.0 Users (Spec rev 1.2) should go to Version 1.0 v1.0/rev2. 

AIB 2.0 Users (Spec rev 2.0.3) should go to Version 2.0 v2.0. 


## Version 1.0

#### Version 1.0, Revision 1 (v1.0/rev1)
The rev1 open source AIB release is the same as the original moved from https://github.com/intel/aib-phy-hardware.

The rev1 directory structure is:                                    
```aib_phy_hardware
    ├── aib_lib
    ├── docs
    ├── how2use
    ├── maib_rtl
    ├── ndsimslv
```
See README.txt under rev1 and subdirectories for detail.                  
New users should start with rev1 for quickest ramp up.                                   

#### Version 1.0, Revision 2 (v1.0/rev2)
Rev2 has multi-die AIB instances and test benches.

Main directory structure is below.  Read the README.txt files in the subdirectories for details.

```aib_phy_hardware
├── docs
│   └── archive
└── rev2              --  Multi-die AIBs design (for advanced user reference)
    ├── dv            --  System Verilog DV to be released in the future.
    │   ├── flist     --  File lists for multi-die AIB IPs.
    │   ├── sims      --  Compilation directory. VCS is supported for now.
    └── rtl           --  For the detail of the rtl release, see README.txt in this directory
        ├── v1_master
        ├── v1_slave
        ├── v2_common
        ├── v2_master
        └── v2_slave
```

#### Version 1, FPGA Main Die AIB (MAIB)
v1.0/rev2/rtl/v1_slave 
24 channel S10 MAIB Plus AUX (AUX only uses four pins)
Use this for interop simulations with Stratix 10.

## Version 2.0

v2.0/rev1 is a behavioral model of AIB 2.0.
v2.0/ rev1.1 is RTL extracted from an actual AIB 2.0 design. Functionally rev1 and rev1.1 are intended to be equivalent. rev1 simulates a lot faster than rev1.1, so some people prefer to use rev1. For a tapeout, a user should run rev1.1 for final verification.

#### Version 2.0 (v2.0/rev1)
AIB 2.0 behavior RTL based on AIB spec 2.0.

#### Version 2.0 (v2.0/rev1.1)
Main directory structure is below.  Read the README.txt files in the subdirectories for details.

```aib-phy-hardware
├── docs
│   └── archive
├── v1.0
│   ├── rev1             -- Previous rev1
│   │   ├── aib_lib
│   │   ├── how2use
│   │   ├── maib_rtl
│   │   ├── ndsimslv
│   │   └── rtl
│   └── rev2             -- Previous rev2 as above
│       ├── constraints
│       ├── dv
│       └── rtl
└── v2.0
    ├── rev1           -- AIB model for AIB 2.0 Specification
    │   ├── dv         -- System Verilog Verification Suite
    │   └── rtl        -- Behavior RTL model
    ├── rev1.1         -- MAIB 1.1
        ├── dv
        └── rtl        -- MAIB 1.1 model
```
#### FPGA Main Die AIB (MAIB)
v2.0/rev1.1/rtl/maib_rev1.1
24 channel Agilex with no AUX. The device_detect and power_on_reset signals go through a microbumped AUX channel on Agilex just like Stratix 10. 
This model presents a MAIB MAC interface to FPGA soft IP, just like Quartus will provide.
The AUX connection of device_detect and power_on-reset is in the testbench.
