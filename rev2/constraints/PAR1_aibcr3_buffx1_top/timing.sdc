# SPDX-License-Identifier: Apache-2.0
# Copyright 2019 Blue Cheetah Analog Design, Inc.
# Copyright (c) 2019 Ayar Labs, Inc.

set_units -capacitance 1.0pF
set_units -time 1.0ns

# Clock periods (in ns)
set jtag_clk_period     33.33

# Clock uncertainty
set clk_uncertainty     0.020
# Assume istrbclk comes in at 0.00, disclk
# Distclk could come in at various points in time relative to strbclk, leave as
# much as possible in higher level implementation
set distclk_delay_min   0.05
set distclk_delay_max   0.20

# Setting some variables
# Default internal margin
set int_dly          0.25

# Because odat*_aib / odat*_in1 connected together by abutment, delays must be matched
set odat_red_dly_min    0.1
set odat_red_dly_max    [expr $clk_period - $int_dly]

#-----------------------------------------------------------------------------
# Clock Definitions
#-----------------------------------------------------------------------------

# JTAG Clocks
create_clock  [get_ports jtag_clkdr_in] -name jtag_clkdr_in -period $jtag_clk_period
# iclkin_dist_in1, istrbclk_in1 Not connected

# Create data clocks
foreach clk {iclkin_dist_in0 ilaunch_clk_in0 ilaunch_clk_in1 istrbclk_in0} {
    create_clock [get_ports $clk] -name $clk -period $clk_period
}

# Model distclk delay variation
set_clock_latency -source -min $distclk_delay_min [get_ports iclkin_dist_in0]
set_clock_latency -source -max $distclk_delay_max [get_ports iclkin_dist_in0]

# Create clock domains
set jtag_clk_domain     [list [get_clocks {jtag_clkdr_in}]]
set tx_clk_domain       [list [get_clocks {ilaunch_clk_in0 ilaunch_clk_in1}]]
set rx_clk_domain       [list [get_clocks {istrbclk_in0 iclkin_dist_in0}]]

# Don't check paths to scan chains
set_false_path -from $jtag_clk_domain -to $tx_clk_domain
set_false_path -from $tx_clk_domain -to $jtag_clk_domain
set_false_path -from $jtag_clk_domain -to $rx_clk_domain
set_false_path -from $rx_clk_domain -to $jtag_clk_domain
set_false_path -from $tx_clk_domain -to $rx_clk_domain
set_false_path -from $rx_clk_domain -to $tx_clk_domain

#-----------------------------------------------------------------------------
# Clock Properties
#-----------------------------------------------------------------------------
set_clock_uncertainty $clk_uncertainty [get_clocks]

#-----------------------------------------------------------------------------
# Serializer non-sequential data checks
#-----------------------------------------------------------------------------
set txdig_loc x3/x1/x1
set ddrmux_loc $txdig_loc/ddrmux/mx/process_cell

# The tool said it didn't do anything with this, and indeed it doesn't make sense for this to be here -
# the mux is not a sequential element, so setting a multicyle path to it wouldn't do anything.
#set_multicycle_path -setup 2 -to $ddrmux_loc/a
#set_multicycle_path -setup 2 -to $ddrmux_loc/b

# Original constraints could have violated hold window, so adding in a minimum delay constraint as well.
# Mux margin is applied equally to both the setup and hold constraints
set mux_margin 0.1
set_max_delay -from $txdig_loc/x18/CK -to $txdig_loc/ddrmux/in0 [expr ${clk_period} / 2 - $mux_margin]
set_min_delay -from $txdig_loc/x18/CK -to $txdig_loc/ddrmux/in0 $mux_margin
set_max_delay -from $txdig_loc/x29/E -to $txdig_loc/ddrmux/in1 [expr ${clk_period} / 2 - $mux_margin]
set_min_delay -from $txdig_loc/x29/E -to $txdig_loc/ddrmux/in1 $mux_margin

#-----------------------------------------------------------------------------
# Pin Constraints
#-----------------------------------------------------------------------------
# Input/Output delays # Refine with Tim's constraints (Add min and max numbers)
# set_input_delay $data_delay -clock [get_clocks tx_clk] [get_ports DataIn[*]]
set jtag_inputs [ list \
        jtag_clksel jtag_intest jtag_mode_in jtag_rstb jtag_rstb_en \
        jtag_tx_scan_in jtag_tx_scanen_in \
    ]
set jtag_outputs [ list \
        jtag_clkdr_out jtag_clkdr_outn jtag_rx_scan_out \
    ]
set_input_delay -max [expr 0.8* ($jtag_clk_period/2)]   -clock [get_clocks jtag_clkdr_in ] $jtag_inputs
set_input_delay -min 0.1                                -clock [get_clocks jtag_clkdr_in ] $jtag_inputs

set_output_delay -max [expr 0.8 *($jtag_clk_period/2)]  -clock [get_clocks jtag_clkdr_in ] $jtag_outputs
set_output_delay -min 0.1                               -clock [get_clocks jtag_clkdr_in ] $jtag_outputs

# Set delays to / from the pad
set_input_delay -max 0.0                                -clock [get_clocks istrbclk_in0 ] iopad
set_input_delay -min 0.0                                -clock [get_clocks istrbclk_in0 ] iopad
set_output_delay -max [expr 0.15 * $clk_period]         -clock [get_clocks ilaunch_clk_in0 ] iopad

# At-speed data path constraints
# Launch data (Tx)
set_input_delay     -max [expr $clk_period-$int_dly]    -clock [get_clocks ilaunch_clk_in0] idata*_in0 idata*_in1
set_input_delay     -min 0.1                            -clock [get_clocks ilaunch_clk_in0] idata*_in0 idata*_in1

# Receive data output (Rx)
# Output post-redundancy mux
set_output_delay    -max [expr $clk_period-$int_dly-$distclk_delay_max] -clock [get_clocks iclkin_dist_in0] odat*_out
set_output_delay    -min [expr -$distclk_delay_min]                     -clock [get_clocks iclkin_dist_in0] odat*_out
set_output_delay    -max [expr $clk_period-$int_dly]    -clock [get_clocks istrbclk_in0] oclk_out oclkb_out
set_output_delay    -min 0.0                            -clock [get_clocks istrbclk_in0] oclk_out oclkb_out

# Output (odat*_aib) / Input (odat*_in*) to redundancy mux
set_output_delay    -max [expr $odat_red_dly_max - $distclk_delay_max]  -clock [get_clocks iclkin_dist_in0] odat0_aib odat1_aib
set_output_delay    -min [expr $odat_red_dly_min - $distclk_delay_min]  -clock [get_clocks iclkin_dist_in0] odat0_aib odat1_aib

set_output_delay    -max $odat_red_dly_max              -clock [get_clocks istrbclk_in0] oclk_aib oclkb_aib
set_output_delay    -min $odat_red_dly_min              -clock [get_clocks istrbclk_in0] oclk_aib oclkb_aib

# Because these are combinational paths, must margin this appropriately and give it enough time to propagate
set_input_delay     -max [expr $int_dly / 2] \
    -clock [get_clocks istrbclk_in0] oclk_in1 oclkb_in1
set_input_delay     -min $odat_red_dly_min \
    -clock [get_clocks istrbclk_in0] oclk_in1 oclkb_in1

set_input_delay     -max [expr $int_dly / 2] \
    -clock [get_clocks iclkin_dist_in0] odat0_in1 odat1_in1
set_input_delay     -min $odat_red_dly_min \
    -clock [get_clocks iclkin_dist_in0] odat0_in1 odat1_in1

if {$jtag_en} {
    set_output_delay    -max [expr 0.8* ($jtag_clk_period/2)] \
        -clock [get_clocks jtag_clkdr_in] idata*_in*_jtag_out
    set_output_delay    -min $odat_red_dly_min \
        -clock [get_clocks jtag_clkdr_in] idata*_in*_jtag_out
} else {
    set_output_delay    -max [expr $int_dly / 2] \
        -clock [get_clocks ilaunch_clk_in0] idata*_in*_jtag_out
    set_output_delay    -min $odat_red_dly_min \
        -clock [get_clocks ilaunch_clk_in0] idata*_in*_jtag_out
}

# Reset signals
# Using multicycle_path here causes bogus recovery time checks on negative clock edge (due to
# negative-edge clocked flops, better to just leave it as a false path if timing doesn't matter)
set_false_path -setup -from anlg_rstb dig_rstb
set_false_path -hold -from anlg_rstb dig_rstb

# Async ports
set async_inputs [list \
        odat_async_in1 async_dat_in0 async_dat_in1 \
    ]
set async_outputs [list \
        odat_async_aib odat_async_out async_dat_in*_jtag_out \
    ]

set_input_delay     -max [expr $clk_period-$int_dly]    -clock [get_clocks ilaunch_clk_in0] $async_inputs
set_input_delay     -min 0.1                            -clock [get_clocks ilaunch_clk_in0] $async_inputs
set_output_delay     -max [expr $clk_period-$int_dly]   -clock [get_clocks istrbclk_in0] -add $async_outputs
set_output_delay     -min 0.1                           -clock [get_clocks istrbclk_in0] -add $async_outputs
set_output_delay     -max [expr $clk_period-$int_dly]   -clock [get_clocks ilaunch_clk_in0] -add $async_outputs
set_output_delay     -min 0.1                           -clock [get_clocks ilaunch_clk_in0] -add $async_outputs

set_multicycle_path -setup 3 -from $async_inputs
set_false_path -hold -from $async_inputs

set_multicycle_path -setup 3 -to $async_outputs
set_false_path -hold -to $async_outputs

# Config inputs do not need to be timing checked, but should be bounded so they don't
# go and do anything crazy
# ilpbk_en*? what do these do?
set cfg_inputs [list \
        idataselb_in* iddren_in* indrv_in* ipdrv_in* irxen_in* itxen_in* \
        ilpbk_en_in* test_weakp* \
        shift_en prev_io_shift_en \
        por_* \
    ]

set_input_delay     -max [expr $clk_period-$int_dly]    -clock [get_clocks ilaunch_clk_in0] $cfg_inputs
set_input_delay     -min 0.1                            -clock [get_clocks ilaunch_clk_in0] $cfg_inputs
set_multicycle_path -setup 3 -from $cfg_inputs
set_false_path -hold -from $cfg_inputs

# NOTES:
# anlg_rstb actually doesn't go to any flops
# what is pd_data_*? this seems to be tapping a signal from a timing critical node and exposing it at top-level!
# anlg_rst -> appears to not go to any sequential elements
# dig_rst -> no reset synchronizer within buffx1_top, do all flops need to exit reset on same cycle?
# odat_async signals -> are these truly asynchronous?

# lpbki *in1 ports are not conencted

#Special Signals
set_dont_touch [get_nets -segments iclkn]
set_dont_touch [get_nets -segments por_aib_vccl]
set_dont_touch [get_nets -segments oclkn]
# Prevent buffering on these to allow frontend pins to be directly used as buffx1 pins. These
# signals are buffered inside the frontend
set_dont_touch [get_nets -segments oclkb_aib]
set_dont_touch [get_nets -segments oclk_aib]

## Output Ports

# Make sure all input transitions are < 40ps given a 1kohm input driver
# Also limit the input cap of each port to be < 5 fF by default
set_input_transition -max 0.050 [all_inputs]
set_input_transition -min 0.001 [all_inputs]

set_max_transition 0.050 [all_inputs]
set_max_capacitance 0.020 [all_inputs]
# Set defaults for signals we care less about to be a lot higher
set_max_transition 0.100 [concat $cfg_inputs $async_inputs $jtag_inputs]
set_max_capacitance 0.030 [concat $cfg_inputs $async_inputs $jtag_inputs]
set_max_capacitance 1.000 iopad

# Make sure all output transitions are < 60 ps given a pin load of 10 fF
set_max_transition 0.060 [all_outputs]
set_load -pin_load 0.010 [all_outputs]

# oclk_aib and oclkb_aib are special
set_max_transition 0.040 [list oclk_aib oclkb_aib]
set_load -pin_load 0.005 [list oclk_aib oclkb_aib]

# Set defaults for signals we care less about to be a lot higher
set_max_transition 0.100 [concat $async_outputs $jtag_outputs]
set_max_capacitance 0.050 [concat $async_outputs $jtag_outputs]

# Functional Clocks (0) propagated
set_case_analysis $jtag_en [get_ports jtag_clksel]
set_case_analysis $jtag_en [get_ports jtag_mode_in]
set_case_analysis $jtag_en [get_ports jtag_rstb_en]
set_case_analysis $jtag_en [get_ports jtag_intest]
set_case_analysis $jtag_en [get_ports jtag_tx_scanen_in]

# suspend
