README.txt
January 29, 2020

===========================================================
Revision history:
Version 1.0: Initial release
===========================================================


Included in this package are Slave AIB top level RTL of Chiplet2:

aibadapt_wrap
└── rtl
    ├── aib_top_v2s.v             -- The RTL top level delivery. instantiated c3aibadapt_wrap_top_v2s.v and aux
    ├── c3aibadapt_wrap_top_v2s.v -- 24 AIB slave channel. Instantiated aib_slv.v from aib_slv directory 
    └── aib_top_wrapper_v2s.sv    -- An optional wrapper file that instantiate aib_top_v2s.v and mapped ports
                                     to match AIB specification. Can be used in simulation when integrating
                                     multi-chiplet for the more unified interface.
aib_slv                           -- One Slave AIB channel
    ├── aib_slv.v

    
===========================================================
File list for compilation:
===========================================================
For RTL compilation of v2_slave, the compilation file list is located at:
../../dv/flist/
sl_v2.cf
