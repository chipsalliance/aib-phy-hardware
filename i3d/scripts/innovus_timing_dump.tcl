package require csv
namespace import ::tcl::mathfunc::*
namespace import ::tcl::mathop::*

# Remember to set your view names and nominal voltage prior to sourcing this script
# variable setup_view <your_setup_view>
# variable setup_view_shifted <your_setup_view for shifted case analysis>
# variable hold_view <your_hold_view>
# variable hold_view_shifted <your_hold_view for shifted case analysis>
# variable typ_view <your_typical_view>
# variable typ_view_shifted <your_typical_view for shifted case analysis>
# variable vnom 0.8

# Calculate timing specs
variable tper 0.25
variable skew [expr 0.12*$tper]
variable vmin [expr $vnom*0.9]
variable vmax [expr $vnom*1.1]
variable dnom [format "%.4f" [expr $vnom / (0.0153*pow(0.8,2) + 0.0188*0.8 - 0.0084) / 1000]]
variable dmax [format "%.4f" [expr $vmin / (0.0153*pow($vmin,2) + 0.0188*$vmin - 0.0084) / 1000 + 0.12 * $tper]]
variable dmin [format "%.4f" [expr $vmax / (0.0153*pow($vmax,2) + 0.0188*$vmax - 0.0084) / 1000 - 0.08 * $tper]]
variable dspread [expr ($dmax - $dmin) / $tper]
variable aperture 0.03
variable apspec [expr $aperture * $tper]

# collection to list utility
proc col2list { col } {
    set list ""
    foreach_in_collection item $col { lappend list $item }
    return $list
}

# Uniquify list
proc unique_list { l } {
    set unique {}
    foreach item $l {
        if {$item ni $unique} {
            lappend unique $item
        }
    }
    return $unique
}

# Filter specific clock pattern
proc filter_for_clock { clk rpts } {
    return [lmap p $rpts {
        if {![string match $clk [get_db $p .capturing_clock_pin.base_name]]} continue
        set p
    }]
}

# Buffer cells
proc count_bufs {buflist} {
    set bufcells {b15bfn|b15bfm}
    set count 0
    foreach item $buflist {
        if ([regexp $bufcells $item]) {
            incr count
        }
    }
    return $count
}

# Clocks
proc coded_clocks {} {
    # Open file
    set f [open coded_clocks.csv w]
    set lines {{"From Port" "To Port" "Delay (S)" "Mean Delay (S)" "DCD % (S)" "Delay (H)" "Mean Delay (H)" "DCD % (H)" "Wirelength" "Wire Delay % (S)" "Wire Delay % (H)" "Path Cells"}}

    # Tx ports are returned in the reverse order
    set tx_in [lreverse [get_db ports clocks_TXCK*]]
    set tx_out [lreverse [get_db ports TXCK*]]
    set num_tx [llength $tx_in]
    set start 0
    for {set i 0} {$i < $num_tx} {incr i} {
        # 2 clocks per module
        foreach out [lrange $tx_out $start $start+1] {
            set in [lindex $tx_in $i]
            puts "$in -> $out"
            # Reports
            set setup_rpt_r [report_timing -from_rise $in -to $out -split_delay -retime path_slew_propagation -collection -late]
            set setup_rpt_f [report_timing -from_fall $in -to $out -split_delay -retime path_slew_propagation -collection -late]
            set hold_rpt_r [report_timing -from_rise $in -to $out -split_delay -retime path_slew_propagation -collection -early -view $::hold_view]
            set hold_rpt_f [report_timing -from_fall $in -to $out -split_delay -retime path_slew_propagation -collection -early -view $::hold_view]
            # Delay (rise/fall/OCV/mean)
            set sdr [get_db $setup_rpt_r .path_delay]
            set sdf [get_db $setup_rpt_f .path_delay]
            set sdrm [get_db $setup_rpt_r .path_delay_mean]
            set sdfm [get_db $setup_rpt_f .path_delay_mean]
            set hdr [get_db $hold_rpt_r .path_delay]
            set hdf [get_db $hold_rpt_f .path_delay]
            set hdrm [get_db $hold_rpt_r .path_delay_mean]
            set hdfm [get_db $hold_rpt_f .path_delay_mean]
            # Duty cycle distortion
            set sdcd [format "%.2f" [expr ($sdf - $sdr) / $::tper * 100]]
            set hdcd [format "%.2f" [expr ($hdf - $hdr) / $::tper * 100]]
            # Wirelength
            set wl [get_db $setup_rpt_r .cumulative_manhattan_length]
            set wd_pct_s [format "%.2f" [expr [get_db $setup_rpt_r .path_net_delay] / $sdr * 100]]
            set wd_pct_h [format "%.2f" [expr [get_db $hold_rpt_r .path_net_delay] / $hdr * 100]]
            # Cells
            set cells [get_db $setup_rpt_r .nets.driver_pins.inst.ref_lib_cell_name]
            # Line
            lappend lines [list $in $out $sdr $sdrm $sdcd $hdr $hdrm $hdcd $wl $wd_pct_s $wd_pct_h $cells]
        }
        # Jump two clocks
        incr start 2
    }

    # Rx ports are returned in the reverse order
    set rx_in [lreverse [get_db ports RXCK*]]
    foreach in $rx_in {
        # Reports
        set setup_rpt_r [report_timing -from_fall $in -split_delay -retime path_slew_propagation -unconstrained -collection -late -view $::setup_view]
        set setup_rpt_f [report_timing -from_rise $in -split_delay -retime path_slew_propagation -unconstrained -collection -late -view $::setup_view]
        set hold_rpt_r [report_timing -from_fall $in -split_delay -retime path_slew_propagation -unconstrained -collection -early -view $::hold_view]
        set hold_rpt_f [report_timing -from_rise $in -split_delay -retime path_slew_propagation -unconstrained -collection -early -view $::hold_view]
        set out [get_db $setup_rpt_r .capturing_point]
        puts "$in -> $out"
        # Delay (rise/fall/OCV/mean)
        set sdr [get_db $setup_rpt_r .path_delay]
        set sdf [get_db $setup_rpt_f .path_delay]
        set sdrm [get_db $setup_rpt_r .path_delay_mean]
        set sdfm [get_db $setup_rpt_f .path_delay_mean]
        set hdr [get_db $hold_rpt_r .path_delay]
        set hdf [get_db $hold_rpt_f .path_delay]
        set hdrm [get_db $hold_rpt_r .path_delay_mean]
        set hdfm [get_db $hold_rpt_f .path_delay_mean]
        # Duty cycle distortion
        set sdcd [format "%.2f" [expr ($sdf - $sdr) / $::tper * 100]]
        set hdcd [format "%.2f" [expr ($hdf - $hdr) / $::tper * 100]]
        # Wirelength
        set wl [get_db $setup_rpt_r .cumulative_manhattan_length]
        set wd_pct_s [format "%.2f" [expr [get_db $setup_rpt_r .path_net_delay] / $sdr * 100]]
        set wd_pct_h [format "%.2f" [expr [get_db $hold_rpt_r .path_net_delay] / $hdr * 100]]
        # Cells
        set cells [get_db $setup_rpt_r .nets.driver_pins.inst.ref_lib_cell_name]
        # Line
        lappend lines [list $in $out $sdr $sdrm $sdcd $hdr $hdrm $hdcd $wl $wd_pct_s $wd_pct_h $cells]
    }

    # Write
    puts -nonewline $f [csv::joinlist $lines]
    close $f
    puts "Clock timing written to coded_clocks.csv"
}

proc shifted_clocks {} {
    # Open file
    set f [open shifted_clocks.csv w]
    set lines {{"From Port" "To Port" "Delay (S)" "Mean Delay (S)" "DCD % (S)" "Delay (H)" "Mean Delay (H)" "DCD % (H)" "Wirelength" "Wire Delay % (S)" "Wire Delay % (H)" "Path Cells"}}

    # Tx ports are returned in the reverse order
    set tx_in [lreverse [get_db ports clocks_TXCK*]]
    set tx_out [lreverse [get_db ports TXCK*]]
    set num_tx [llength $tx_in]
    set num_red [expr [llength $tx_out] - [llength $tx_in]]
    set late_views [list $::setup_view $::setup_view_shifted]
    set early_views [list $::hold_view $::hold_view_shifted]
    # Interleaved case analysis
    for {set i 0} {$i < $num_tx} {incr i} {
        set in [lindex $tx_in $i]
        set out_clks [list [lindex $tx_out $i] [lindex $tx_out [expr $i + $num_red]]]
        for {set j 0} {$j < 2} {incr j} {
            set out [lindex $out_clks $j]
            set setup_view [lindex $late_views $j]
            set hold_view [lindex $early_views $j]
            puts "$in -> $out"
            # Reports
            set setup_rpt_r [report_timing -from_rise $in -to $out -split_delay -retime path_slew_propagation -collection -late -view $setup_view]
            set setup_rpt_f [report_timing -from_fall $in -to $out -split_delay -retime path_slew_propagation -collection -late -view $setup_view]
            set hold_rpt_r [report_timing -from_rise $in -to $out -split_delay -retime path_slew_propagation -collection -early -view $hold_view]
            set hold_rpt_f [report_timing -from_fall $in -to $out -split_delay -retime path_slew_propagation -collection -early -view $hold_view]
            # Delay (rise/fall/OCV/mean)
            set sdr [get_db $setup_rpt_r .path_delay]
            set sdf [get_db $setup_rpt_f .path_delay]
            set sdrm [get_db $setup_rpt_r .path_delay_mean]
            set sdfm [get_db $setup_rpt_f .path_delay_mean]
            set hdr [get_db $hold_rpt_r .path_delay]
            set hdf [get_db $hold_rpt_f .path_delay]
            set hdrm [get_db $hold_rpt_r .path_delay_mean]
            set hdfm [get_db $hold_rpt_f .path_delay_mean]
            # Duty cycle distortion
            set sdcd [format "%.2f" [expr ($sdf - $sdr) / $::tper * 100]]
            set hdcd [format "%.2f" [expr ($hdf - $hdr) / $::tper * 100]]
            # Wirelength
            set wl [get_db $setup_rpt_r .cumulative_manhattan_length]
            set wd_pct_s [format "%.2f" [expr [get_db $setup_rpt_r .path_net_delay] / $sdr * 100]]
            set wd_pct_h [format "%.2f" [expr [get_db $hold_rpt_r .path_net_delay] / $hdr * 100]]
            # Cells
            set cells [get_db $setup_rpt_r .nets.driver_pins.inst.ref_lib_cell_name]
            # Line
            lappend lines [list $in $out $sdr $sdrm $sdcd $hdr $hdrm $hdcd $wl $wd_pct_s $wd_pct_h $cells]
        }
    }

    # Rx ports are returned in the reverse order
    set rx_in [lreverse [get_db ports RXCK*]]
    foreach in $rx_in {
        # Interleaved case analysis
        for {set i 0} {$i < 2} {incr i} {
            set setup_view [lindex $late_views $i]
            set hold_view [lindex $early_views $i]
            # Reports
            set setup_rpt_r [report_timing -from_fall $in -split_delay -retime path_slew_propagation -unconstrained -collection -late -view $setup_view]
            set out [get_db $setup_rpt_r .capturing_point]
            # Skip if clock isn't propagated
            if {[string first "RXCK" $out] < 0} { continue }
            set setup_rpt_f [report_timing -from_rise $in -split_delay -retime path_slew_propagation -unconstrained -collection -late -view $setup_view]
            set hold_rpt_r [report_timing -from_fall $in -split_delay -retime path_slew_propagation -unconstrained -collection -early -view $hold_view]
            set hold_rpt_f [report_timing -from_rise $in -split_delay -retime path_slew_propagation -unconstrained -collection -early -view $hold_view]
            puts "$in -> $out"
            # Delay (rise/fall/OCV/mean)
            set sdr [get_db $setup_rpt_r .path_delay]
            set sdf [get_db $setup_rpt_f .path_delay]
            set sdrm [get_db $setup_rpt_r .path_delay_mean]
            set sdfm [get_db $setup_rpt_f .path_delay_mean]
            set hdr [get_db $hold_rpt_r .path_delay]
            set hdf [get_db $hold_rpt_f .path_delay]
            set hdrm [get_db $hold_rpt_r .path_delay_mean]
            set hdfm [get_db $hold_rpt_f .path_delay_mean]
            # Duty cycle distortion
            set sdcd [format "%.2f" [expr ($sdf - $sdr) / $::tper * 100]]
            set hdcd [format "%.2f" [expr ($hdf - $hdr) / $::tper * 100]]
            # Wirelength
            set wl [get_db $setup_rpt_r .cumulative_manhattan_length]
            set wd_pct_s [format "%.2f" [expr [get_db $setup_rpt_r .path_net_delay] / $sdr * 100]]
            set wd_pct_h [format "%.2f" [expr [get_db $hold_rpt_r .path_net_delay] / $hdr * 100]]
            # Cells
            set cells [get_db $setup_rpt_r .nets.driver_pins.inst.ref_lib_cell_name]
            # Line
            lappend lines [list $in $out $sdr $sdrm $sdcd $hdr $hdrm $hdcd $wl $wd_pct_s $wd_pct_h $cells]
        }
    }

    # Write
    puts -nonewline $f [csv::joinlist $lines]
    close $f
    puts "Clock timing written to shifted_clocks.csv"
}

# Clock tree ID & skew
proc clock_tree_stats {} {
    foreach grp [concat [get_db skew_groups TXCK*] [get_db skew_groups RXCK*]] {
        # Reports
        set early_long [get_skew_group_delay -skew_group $grp -delay_type early -longest]
        set early_short [get_skew_group_delay -skew_group $grp -delay_type early -shortest]
        set early_mean [expr ($early_long + $early_short) / 2]
        set early_skew [expr ($early_long - $early_short) / 2]
        set late_long [get_skew_group_delay -skew_group $grp -delay_type late -longest]
        set late_short [get_skew_group_delay -skew_group $grp -delay_type late -shortest]
        set late_mean [expr ($late_long + $late_short) / 2]
        set late_skew [expr ($late_long - $late_short) / 2]
        set pass [expr {$early_skew < $::skew && $late_skew < $::skew ? "PASS" : "FAIL"}]
        puts "[get_db $grp .cts_skew_group_created_from_clock]:"
        puts "\tEarly: $early_mean +/- $early_skew\t$pass"
        puts "\tLate: $late_mean +/- $late_skew\t$pass\n"
    }
}

# Tx output delay
proc tx_output_delay {{shifted 0}} {
    if {$shifted} {
        set csv_file tx_output_delay_shifted.csv
        set sview $::setup_view_shifted
        set hview $::hold_view_shifted
        set tview $::typ_view_shifted
    } else {
        set csv_file tx_output_delay.csv
        set sview $::setup_view
        set hview $::hold_view
        set tview $::typ_view
    }
    # Open file
    set f [open $csv_file w]
    set lines {{"Port" "Clock" "Slack (S)" "Sigma (S)" "Dtx (S)" "Mean Dtx (S)" "Skew (S)" "Slack (H)" "Sigma (H)" "Dtx (H)" "Mean Dtx (H)" "Skew (H)" "Spread (UI)" "Mean Spread (UI)" "Pass?" "D-D Skew" "Data WL" "Data WD % (S)" "Data WD % (H)" "Clock WL" "Clock WD % (S)" "Clock WD % (H)" "Path Cells"}}

    # For min/max skew tracking
    set dmin_s [dict create]
    set dmin_h [dict create]
    set dmax_s [dict create]
    set dmax_h [dict create]
    set llskew [dict create]

    foreach pin [lreverse [get_db ports {TXDATA* TXRED*}]] {
        # Need to report large nworst to filter out lane-to-lane skew paths
        set setup_rpts [filter_for_clock TXCK* [col2list [report_timing -to $pin -path_type full_clock -split_delay -retime path_slew_propagation -check_type data_setup -nworst 1000 -view $sview -collection]]]
        # Continue if no paths (data-to-data check against clock)
        set clks [unique_list [get_db $setup_rpts .capturing_clock_pin.base_name]]
        if {[llength $clks] == 0} { continue }
        set hold_rpts [filter_for_clock TXCK* [col2list [report_timing -to $pin -path_type full_clock -split_delay -retime path_slew_propagation -check_type data_hold -nworst 1000 -view $hview -collection]]]
        set typ_rpts [filter_for_clock TXCK* [col2list [report_timing -to $pin -path_type full_clock -split_delay -retime path_slew_propagation -check_type data_hold -nworst 1000 -view $tview -collection]]]
        foreach clk $clks {
            puts "$clk -> $pin"
            # Slack
            set sslk [min {*}[get_db [filter_for_clock $clk $setup_rpts] .slack]]
            set sslk_sigma [max {*}[get_db [filter_for_clock $clk $setup_rpts] .slack_sigma]]
            set hslk [min {*}[get_db [filter_for_clock $clk $hold_rpts] .slack]]
            set hslk_sigma [max {*}[get_db [filter_for_clock $clk $hold_rpts] .slack_sigma]]
            # Calculated Dtx
            set sdt [max {*}[lmap p $setup_rpts {expr [get_db $p .arrival] - [get_db $p .capturing_clock_latency]}]]
            set sdtm [max {*}[lmap p $setup_rpts {expr [get_db $p .arrival_mean] - [get_db $p .capturing_clock_latency_mean]}]]
            set hdt [min {*}[lmap p $hold_rpts {expr [get_db $p .arrival] - $::tper - [get_db $p .capturing_clock_latency]}]]
            set hdtm [min {*}[lmap p $hold_rpts {expr [get_db $p .arrival_mean] - $::tper - [get_db $p .capturing_clock_latency_mean]}]]
            set spread [expr ($sdt - $hdt) / $::tper]
            set spread_mean [expr ($sdtm - $hdtm) / $::tper]
            set pass [expr {$spread <= $::dspread ? "Y" : "N"}]
            # Clock tree leaf vs. output clock skew
            set sskew [min {*}[lmap p $setup_rpts {expr [get_db $p .capturing_clock_latency] - [get_db $p .launching_clock_latency]}]]
            set hskew [min {*}[lmap p $hold_rpts {expr [get_db $p .capturing_clock_latency] - [get_db $p .launching_clock_latency]}]]
            # Lane-to-lane skew calcs
            set tdts [lmap p $typ_rpts {expr [get_db $p .arrival] - $::tper - [get_db $p .capturing_clock_latency]}]
            set tskew [expr [+ {*}$tdts] / [llength $tdts] - $::dnom]
            if {[dict exists $dmin_s $clk]} {
                if {[dict get $dmin_s $clk] > $sdt} {
                    dict set dmin_s $clk $sdt
                }
            } else { dict set dmin_s $clk $sdt }
            if {[dict exists $dmin_h $clk]} {
                if {[dict get $dmin_h $clk] > $hdt} {
                    dict set dmin_h $clk $hdt
                }
            } else { dict set dmin_h $clk $hdt }
            if {[dict exists $dmax_s $clk]} {
                if {[dict get $dmax_s $clk] < $sdt} {
                    dict set dmax_s $clk $sdt
                }
            } else { dict set dmax_s $clk $sdt }
            if {[dict exists $dmax_h $clk]} {
                if {[dict get $dmax_h $clk] < $hdt} {
                    dict set dmax_h $clk $hdt
                }
            } else { dict set dmax_h $clk $hdt }
            dict set llskew $clk [expr max([expr [dict get $dmax_s $clk] - [dict get $dmin_s $clk]], [expr [dict get $dmax_h $clk] - [dict get $dmin_h $clk]])]
            # Wirelength
            set dwl [get_db [lindex $setup_rpts 0 ] .cumulative_manhattan_length]
            set dwd_pct_s [format "%.2f" [expr [get_db [lindex $setup_rpts 0] .path_net_delay] / [get_db [lindex $setup_rpts 0] .path_delay] * 100]]
            set dwd_pct_h [format "%.2f" [expr [get_db [lindex $hold_rpts 0] .path_net_delay] / [get_db [lindex $hold_rpts 0] .path_delay] * 100]]
            set flop_pin [get_db [lindex $setup_rpts 0] .launching_point]
            set ioclk_to_flop_setup_rpt [report_timing -to $flop_pin -path_type full_clock -split_delay -retime path_slew_propagation -late -collection]
            set ioclk_to_flop_hold_rpt [report_timing -to $flop_pin -path_type full_clock -split_delay -retime path_slew_propagation -early -collection]
            set clkport_to_ioclk_setup_rpt [report_timing -to [get_db $ioclk_to_flop_setup_rpt .launching_point] -path_type full_clock -split_delay -retime path_slew_propagation -late -collection]
            set clkport_to_ioclk_hold_rpt [report_timing -to [get_db $ioclk_to_flop_hold_rpt .launching_point] -path_type full_clock -split_delay -retime path_slew_propagation -early -collection]
            set cwl [expr [get_db $ioclk_to_flop_setup_rpt .cumulative_manhattan_length] + [get_db $clkport_to_ioclk_setup_rpt .cumulative_manhattan_length]]
            set cpnd_s [expr [get_db $ioclk_to_flop_setup_rpt .path_net_delay] + [get_db $clkport_to_ioclk_setup_rpt .path_net_delay]]
            set cpnd_h [expr [get_db $ioclk_to_flop_hold_rpt .path_net_delay] + [get_db $clkport_to_ioclk_hold_rpt .path_net_delay]]
            set cpd_s [expr [get_db $ioclk_to_flop_setup_rpt .path_delay] + [get_db $clkport_to_ioclk_setup_rpt .path_delay]]
            set cpd_h [expr [get_db $ioclk_to_flop_hold_rpt .path_delay] + [get_db $clkport_to_ioclk_hold_rpt .path_delay]]
            set cwd_pct_s [format "%.2f" [expr $cpnd_s / $cpd_s * 100]]
            set cwd_pct_h [format "%.2f" [expr $cpnd_h / $cpd_h * 100]]
            # Cells
            set cells [get_db [lindex $setup_rpts 0] .nets.driver_pins.inst.ref_lib_cell_name]
            set bufcnt [count_bufs $cells]
            # Line
            lappend lines [list $pin $clk $sslk $sslk_sigma $sdt $sdtm $sskew $hslk $hslk_sigma $hdt $hdtm $hskew $spread $spread_mean $pass $tskew $dwl $dwd_pct_s $dwd_pct_h $cwl $cwd_pct_s $cwd_pct_h $cells]
        }
    }

    # Write
    puts -nonewline $f [csv::joinlist $lines]
    close $f
    puts "Tx output delay written to $csv_file"
    puts "Lane-to-lane skews:"
    foreach item [dict keys $llskew] {
        set val [dict get $llskew $item]
        puts "\t$item: $val [expr {$val <= 0.03 ? "PASS" : "FAIL"}]"
    }
}

# Tx input delay
proc tx_input_delay {{shifted 0}} {
    if {$shifted} {
        set csv_file tx_input_delay_shifted.csv
        set sview $::setup_view_shifted
        set hview $::hold_view_shifted
        set tview $::typ_view_shifted
    } else {
        set csv_file tx_input_delay.csv
        set sview $::setup_view
        set hview $::hold_view
        set tview $::typ_view
    }
    # Open file
    set f [open $csv_file w]
    set lines {{"Port" "Pin" "Clock" "Slack (S)" "Dmax" "Slack (H)" "Dmin" "Wirelength" "Path Cells"}}

    foreach pin [get_db pins iocells_*/txRetimed_reg/d] {
        # Reports
        set setup_rpt [report_timing -to $pin -path_type full_clock -split_delay -retime path_slew_propagation -collection -late -view $sview]
        set port [get_db $setup_rpt .launching_point.base_name]
        # Skip if no launching point
        if {[llength $port] == 0} { continue }
        set hold_rpt [report_timing -to $pin -path_type full_clock -split_delay -retime path_slew_propagation -collection -early -view $hview]
        set pin_name [get_db $pin .name]
        set clk [get_db $hold_rpt .capturing_clock.base_name]
        # Slacks
        set sslk [get_db $setup_rpt .slack]
        set hslk [get_db $hold_rpt .slack]
        # Delay
        set dmax [expr $::tper + [get_db $setup_rpt .capturing_clock_latency] - [get_db $setup_rpt .data_path]]
        set dmin [expr [get_db $hold_rpt .capturing_clock_latency] - [get_db $hold_rpt .data_path]]
        # Wirelength
        set wl [get_db $setup_rpt .cumulative_manhattan_length]
        # Cells
        set cells [get_db $setup_rpt .nets.driver_pins.inst.ref_lib_cell_name]
        set bufcnt [count_bufs $cells]
        # Line
        lappend lines [list $port $pin_name $clk $sslk $dmax $hslk $dmin $wl $cells]
    }

    # Write
    puts -nonewline $f [csv::joinlist $lines]
    close $f
    puts "Tx input delay written to $csv_file"
}

# Rx input delay
# Shifting doesn't matter (both cases have the same path)
proc rx_input_delay {} {
    # Open file
    set f [open rx_input_delay.csv w]
    set lines {{"Port" "Clock" "Slack (S)" "Sigma (S)" "Drx (S)" "Pass?" "Slack (H)" "Sigma (H)" "Drx (H)" "Pass?" "Aperture (UI)" "Pass?" "Wirelength" "Wire Delay % (S)" "Wire Delay % (H)" "Path Cells"}}

    foreach pin [get_db ports {RXDATA* RXRED*}] {
        # Reports
        set setup_rpts [col2list [report_timing -from $pin -path_type full_clock -split_delay -retime path_slew_propagation -collection -nworst 2 -view $::setup_view]]
        set hold_rpts [col2list [report_timing -from $pin -path_type full_clock -split_delay -retime path_slew_propagation -collection -nworst 2 -view $::hold_view]]
        set port [lindex [get_db $setup_rpts .launching_point.base_name] 0]
        set clk [lindex [get_db $hold_rpts .capturing_clock.base_name] 0]
        # Slack
        set sslk [min {*}[get_db $setup_rpts .slack]]
        set sslk_sigma [max {*}[get_db $setup_rpts .slack_sigma]]
        set hslk [min {*}[get_db $hold_rpts .slack]]
        set hslk_sigma [max {*}[get_db $hold_rpts .slack_sigma]]
        # Calculated Drx
        set sdt [max {*}[lmap p $setup_rpts {expr [get_db $p .capturing_clock_latency] - [get_db $p .data_path]}]]
        set sdt_pass [expr {$sdt <= $::dmax ? "Y" : "N"}]
        set hdt [min {*}[lmap p $hold_rpts {expr [get_db $p .capturing_clock_latency] - [get_db $p .data_path]}]]
        set hdt_pass [expr {$hdt >= $::dmin ? "Y" : "N"}]
        # Sampling aperture
        set ap [expr ($sslk + $hslk) / $::tper]
        set ap_pass [expr {$ap >= $::aperture ? "Y" : "N"}]
        # Wirelength
        set wl [lindex [get_db $setup_rpts .cumulative_manhattan_length] 0]
        set wd_pct_s [format "%.2f" [expr [max {*}[get_db $setup_rpts .path_net_delay]] / [max {*}[get_db $setup_rpts .path_delay]] * 100]]
        set wd_pct_h [format "%.2f" [expr [min {*}[get_db $hold_rpts .path_net_delay]] / [min {*}[get_db $hold_rpts .path_delay]] * 100]]
        # Cells
        set cells [get_db [lindex $setup_rpts 0] .nets.driver_pins.inst.ref_lib_cell_name]
        set bufcnt [count_bufs $cells]
        # Line
        lappend lines [list $port $clk $sslk $sslk_sigma $sdt $sdt_pass $hslk $hslk_sigma $hdt $hdt_pass $ap $ap_pass $wl $wd_pct_s $wd_pct_h $cells]
    }

    # Write
    puts -nonewline $f [csv::joinlist $lines]
    close $f
    puts "Rx input delay written to rx_input_delay.csv"
}

# Rx output delay
proc rx_output_delay {{shifted 0}} {
    if {$shifted} {
        set csv_file rx_output_delay_shifted.csv
        set sview $::setup_view_shifted
        set hview $::hold_view_shifted
        set tview $::typ_view_shifted
    } else {
        set csv_file rx_output_delay.csv
        set sview $::setup_view
        set hview $::hold_view
        set tview $::typ_view
    }
    # Open file
    set f [open $csv_file w]
    set lines {{"Port" "Clock" "Slack (S)" "Delay (S)" "Slack (H)" "Delay (H)" "Wirelength" "Wire Delay % (S)" "Wire Delay % (H)" "Path Cells"}}

    foreach pin [get_db pins iocells*/io_rxData_REG_reg/clk] {
        # Report output delay paths only with -check_type
        set setup_rpts [col2list [report_timing -from $pin -path_type full_clock -split_delay -retime path_slew_propagation -nworst 2 -check_type setup -view $sview -collection]]
        # Continue if no paths
        if {[llength $setup_rpts] == 0} { continue }
        set hold_rpts [col2list [report_timing -from $pin -path_type full_clock -split_delay -retime path_slew_propagation -nworst 2 -check_type hold -view $hview -collection]]
        set port [lindex [get_db $setup_rpts .capturing_point.base_name] 0]
        set clk [lindex [get_db $setup_rpts .capturing_clock.base_name] 0]
        # Slacks
        set sslk [min {*}[get_db $setup_rpts .slack]]
        set hslk [min {*}[get_db $hold_rpts .slack]]
        # Delay
        set sdt [max {*}[get_db $setup_rpts .path_delay]]
        set hdt [min {*}[get_db $hold_rpts .path_delay]]
        # Wirelength
        set wl [lindex [get_db $setup_rpts .cumulative_manhattan_length] 0]
        set wd_pct_s [format "%.2f" [expr [max {*}[get_db $setup_rpts .path_net_delay]] / [max {*}[get_db $setup_rpts .path_delay]] * 100]]
        set wd_pct_h [format "%.2f" [expr [min {*}[get_db $hold_rpts .path_net_delay]] / [min {*}[get_db $hold_rpts .path_delay]] * 100]]
        # Cells
        set cells [get_db [lindex $setup_rpts 0] .nets.driver_pins.inst.ref_lib_cell_name]
        set bufcnt [count_bufs $cells]
        # Line
        lappend lines [list $port $clk $sslk $sdt $hslk $hdt $wl $wd_pct_s $wd_pct_h $cells]
    }

    # Write
    puts -nonewline $f [csv::joinlist $lines]
    close $f
    puts "Rx output delay written to $csv_file"
}

# Static power
proc report_static_power {{shifted 0}} {
    # Assume random data - likely worst case activity factor
    set_default_switching_activity -reset
    set_default_switching_activity -input_activity 0.5 -clip_activity_to_domain_freq true
    # Remove contribution of control clock domain
    set_switching_activity -clock clock -activity 0
    if {$shifted} {
        report_power -view $::typ_view_shifted
    } else {
        report_power -view $::typ_view
    }
}
