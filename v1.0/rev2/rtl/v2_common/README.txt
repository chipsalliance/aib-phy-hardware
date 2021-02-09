README.txt
August 24, 2020


Included in this package are lower level RTL that share by both v2_slave and v2_master.

Note that in the file 
 ./dig/bc_mod/aibcr3_dcc_dly.v,
the module aibcr3_dcc_dly has inputs launch and measure. measure is expected to arrive at 
its DCC input exactly one "clk_dcd" clock cycle after launch does.  Digital logic should 
provide the one clock period of delay, while your clock tree synthesis and optimization 
tools are expected to phase align the rising edges of the launch and measure signals at 
the DCC’s inputs.
