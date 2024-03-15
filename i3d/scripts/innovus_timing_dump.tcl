package require csv
namespace import ::tcl::mathfunc::*
namespace import ::tcl::mathop::*

# Remember to set your view names and nominal voltage prior to sourcing this script
# variable setup_view <your_setup_view>
# variable hold_view <your_hold_view>
# variable typ_view <your_typical_view>
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

    set tx_in [get_db ports clocks_TXCK*]
    set tx_out [get_db ports TXCK*]
    set num_tx [llength $tx_in]
    set start 0
    for {set i 0} {$i < $num_tx} {incr i} {
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

    # Rx path is split due to inversion
    set rx_in [get_db ports RXCK*]
    foreach in $rx_in {
        # Note clock inversion
        # Reports to IO cell output
        set setup_rpt_r_1 [report_timing -from_fall $in -split_delay -retime path_slew_propagation -unconstrained -collection -late]
        set setup_rpt_f_1 [report_timing -from_rise $in -split_delay -retime path_slew_propagation -unconstrained -collection -late]
        set hold_rpt_r_1 [report_timing -from_fall $in -split_delay -retime path_slew_propagation -unconstrained -collection -early -view $::hold_view]
        set hold_rpt_f_1 [report_timing -from_rise $in -split_delay -retime path_slew_propagation -unconstrained -collection -early -view $::hold_view]
        # Reports from IO cell output
        set midpt [get_clocks [get_db $rx_in .name]]
        set setup_rpt_r_2 [report_timing -from_rise $midpt -split_delay -retime path_slew_propagation -collection -late]
        set setup_rpt_f_2 [report_timing -from_fall $midpt -split_delay -retime path_slew_propagation -collection -late]
        set hold_rpt_r_2 [report_timing -from_rise $midpt -split_delay -retime path_slew_propagation -collection -early -view $::hold_view]
        set hold_rpt_f_2 [report_timing -from_fall $midpt -split_delay -retime path_slew_propagation -collection -early -view $::hold_view]
        set out [get_db $setup_rpt_r_2 .capturing_point]
        puts "$in -> $out"
        # Delay (rise/fall/OCV/mean)
        set sdr [expr [get_db $setup_rpt_r_1 .path_delay] + [get_db $setup_rpt_r_2 .path_delay]]
        set sdf [expr [get_db $setup_rpt_f_1 .path_delay] + [get_db $setup_rpt_f_2 .path_delay]]
        set sdrm [expr [get_db $setup_rpt_r_1 .path_delay_mean] + [get_db $setup_rpt_r_2 .path_delay_mean]]
        set sdfm [expr [get_db $setup_rpt_f_1 .path_delay_mean] + [get_db $setup_rpt_f_2 .path_delay_mean]]
        set hdr [expr [get_db $hold_rpt_r_1 .path_delay] + [get_db $hold_rpt_r_2 .path_delay]]
        set hdf [expr [get_db $hold_rpt_f_1 .path_delay] + [get_db $hold_rpt_f_2 .path_delay]]
        set hdrm [expr [get_db $hold_rpt_r_1 .path_delay_mean] + [get_db $hold_rpt_r_2 .path_delay_mean]]
        set hdfm [expr [get_db $hold_rpt_f_1 .path_delay_mean] + [get_db $hold_rpt_f_2 .path_delay_mean]]
        # Duty cycle distortion
        set sdcd [format "%.2f" [expr ($sdf - $sdr) / $::tper * 100]]
        set hdcd [format "%.2f" [expr ($hdf - $hdr) / $::tper * 100]]
        # Wirelength
        set wl [expr [get_db $setup_rpt_r_1 .cumulative_manhattan_length] + [get_db $setup_rpt_r_2 .cumulative_manhattan_length]]
        set wd_pct_s [format "%.2f" [expr ([get_db $setup_rpt_r_1 .path_net_delay] + [get_db $setup_rpt_r_1 .path_net_delay]) / $sdr * 100]]
        set wd_pct_h [format "%.2f" [expr ([get_db $hold_rpt_r_1 .path_net_delay] + [get_db $hold_rpt_r_1 .path_net_delay]) / $hdr * 100]]
        # Cells
        set cells [list [get_db $setup_rpt_r_1 .nets.driver_pins.inst.ref_lib_cell_name] [get_db $setup_rpt_r_2 .nets.driver_pins.inst.ref_lib_cell_name]]
        # Line
        lappend lines [list $in $out $sdr $sdrm $sdcd $hdr $hdrm $hdcd $wl $wd_pct_s $wd_pct_h $cells]
    }

    # Write
    puts -nonewline $f [csv::joinlist $lines]
    close $f
    puts "Clock timing written to coded_clocks.csv"
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
proc tx_output_delay {} {
    # Open file
    set f [open tx_output_delay.csv w]
    set lines {{"Port" "Clock" "Slack (S)" "Sigma (S)" "Dtx (S)" "Mean Dtx (S)" "Skew (S)" "Slack (H)" "Sigma (H)" "Dtx (H)" "Mean Dtx (H)" "Skew (H)" "Spread (UI)" "Mean Spread (UI)" "Pass?" "D-D Skew" "Data WL" "Data WD % (S)" "Data WD % (H)" "Clock WL" "Clock WD % (S)" "Clock WD % (H)" "Path Cells"}}

    # For min/max skew tracking
    set dmin_s [dict create]
    set dmin_h [dict create]
    set dmax_s [dict create]
    set dmax_h [dict create]
    set llskew [dict create]

    foreach pin [get_db ports {TXDATA* TXRED*}] {
        set setup_rpts [filter_for_clock TXCK* [col2list [report_timing -to $pin -path_type full_clock -split_delay -retime path_slew_propagation -check_type data_setup -nworst 1000 -collection]]]
        set hold_rpts [filter_for_clock TXCK* [col2list [report_timing -to $pin -path_type full_clock -split_delay -retime path_slew_propagation -check_type data_hold -nworst 1000 -view $::hold_view -collection]]]
        set typ_rpts [filter_for_clock TXCK* [col2list [report_timing -to $pin -path_type full_clock -split_delay -retime path_slew_propagation -check_type data_hold -nworst 1000 -view $::typ_view -collection]]]
        set clks [unique_list [lmap rpt $setup_rpts {get_db $rpt .capturing_clock_pin.base_name}]]
        foreach clk $clks {
            # Slack
            set sslk [max {*}[get_db [filter_for_clock $clk $setup_rpts] .slack]]
            set sslk_sigma [max {*}[get_db [filter_for_clock $clk $setup_rpts] .slack_sigma]]
            set hslk [min {*}[get_db [filter_for_clock $clk $hold_rpts] .slack]]
            set hslk_sigma [min {*}[get_db [filter_for_clock $clk $hold_rpts] .slack_sigma]]
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
            set clk_setup_rpt [report_timing -to $flop_pin -path_type full_clock -split_delay -retime path_slew_propagation -late -collection]
            set clk_hold_rpt [report_timing -to $flop_pin -path_type full_clock -split_delay -retime path_slew_propagation -early -collection]
            set cwl [get_db $clk_setup_rpt .cumulative_manhattan_length]
            set cwd_pct_s [format "%.2f" [expr [get_db $clk_setup_rpt .path_net_delay] / [get_db $clk_setup_rpt .path_delay] * 100]]
            set cwd_pct_h [format "%.2f" [expr [get_db $clk_hold_rpt .path_net_delay] / [get_db $clk_hold_rpt .path_delay] * 100]]
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
    puts "Tx output delay written to tx_output_delay.csv"
    puts "Lane-to-lane skews:"
    foreach item [dict keys $llskew] {
        set val [dict get $llskew $item]
        puts "\t$item: $val [expr {$val <= 0.03 ? "PASS" : "FAIL"}]"
    }
}

# Tx input delay
proc tx_input_delay {} {
    # Open file
    set f [open tx_input_delay.csv w]
    set lines {{"Port" "Pin" "Clock" "Slack (S)" "Dmax" "Slack (H)" "Dmin" "Wirelength" "Path Cells"}}

    foreach pin [get_db pins iocells_*/txRetimed_reg/d] {
        # Reports
        set setup_rpt [report_timing -to $pin -path_type full_clock -split_delay -retime path_slew_propagation -collection -late]
        set hold_rpt [report_timing -to $pin -path_type full_clock -split_delay -retime path_slew_propagation -collection -early -view $::hold_view]
        set port [get_db $setup_rpt .launching_point.base_name]
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
    puts "Tx input delay written to tx_input_delay.csv"
}

# Rx input delay
proc rx_input_delay {} {
    # Open file
    set f [open rx_input_delay.csv w]
    set lines {{"Port" "Clock" "Slack (S)" "Sigma (S)" "Drx (S)" "Pass?" "Slack (H)" "Sigma (H)" "Drx (H)" "Pass?" "Aperture (UI)" "Pass?" "Wirelength" "Wire Delay % (S)" "Wire Delay % (H)" "Path Cells"}}

    foreach pin [get_db ports RXDATA*] {
        # Reports
        set setup_rpt [report_timing -from $pin -path_type full_clock -split_delay -retime path_slew_propagation -collection -late]
        set hold_rpt [report_timing -from $pin -path_type full_clock -split_delay -retime path_slew_propagation -collection -early -view $::hold_view]
        set port [get_db $setup_rpt .launching_point.base_name]
        set clk [get_db $hold_rpt .capturing_clock.base_name]
        # Slack
        set sslk [get_db $setup_rpt .slack]
        set sslk_sigma [get_db $setup_rpt .slack_sigma]
        set hslk [get_db $hold_rpt .slack]
        set hslk_sigma [get_db $hold_rpt .slack_sigma]
        # Calculated Drx
        set sdt [expr [get_db $setup_rpt .capturing_clock_latency] - [get_db $setup_rpt .data_path]]
        set sdt_pass [expr {$sdt <= $::dmax ? "Y" : "N"}]
        set hdt [expr [get_db $hold_rpt .capturing_clock_latency] - [get_db $hold_rpt .data_path]]
        set hdt_pass [expr {$hdt >= $::dmin ? "Y" : "N"}]
        # Sampling aperture
        set ap [expr ($sslk + $hslk) / $::tper]
        set ap_pass [expr {$ap >= $::aperture ? "Y" : "N"}]
        # Wirelength
        set wl [get_db $setup_rpt .cumulative_manhattan_length]
        set wd_pct_s [format "%.2f" [expr [get_db $setup_rpt .path_net_delay] / [get_db $setup_rpt .path_delay] * 100]]
        set wd_pct_h [format "%.2f" [expr [get_db $hold_rpt .path_net_delay] / [get_db $hold_rpt .path_delay] * 100]]
        # Cells
        set cells [get_db $setup_rpt .nets.driver_pins.inst.ref_lib_cell_name]
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
proc rx_output_delay {} {
    # Open file
    set f [open rx_output_delay.csv w]
    set lines {{"Port" "Clock" "Slack (S)" "Delay (S)" "Slack (H)" "Delay (H)" "Wirelength" "Wire Delay % (S)" "Wire Delay % (H)" "Path Cells"}}

    foreach pin [get_db pins iocells*/io_rxData_REG_reg/clk] {
        # Reports
        set setup_rpt [report_timing -from $pin -path_type full_clock -split_delay -retime path_slew_propagation -collection -late]
        set hold_rpt [report_timing -from $pin -path_type full_clock -split_delay -retime path_slew_propagation -collection -early -view $::hold_view]
        set port [get_db $setup_rpt .capturing_point.base_name]
        set clk [get_db $setup_rpt .capturing_clock.base_name]
        # Slacks
        set sslk [get_db $setup_rpt .slack]
        set hslk [get_db $hold_rpt .slack]
        # Delay
        set sdt [get_db $setup_rpt .path_delay]
        set hdt [get_db $hold_rpt .path_delay]
        # Wirelength
        set wl [get_db $setup_rpt .cumulative_manhattan_length]
        set wd_pct_s [format "%.2f" [expr [get_db $setup_rpt .path_net_delay] / [get_db $setup_rpt .path_delay] * 100]]
        set wd_pct_h [format "%.2f" [expr [get_db $hold_rpt .path_net_delay] / [get_db $hold_rpt .path_delay] * 100]]
        # Cells
        set cells [get_db $setup_rpt .nets.driver_pins.inst.ref_lib_cell_name]
        set bufcnt [count_bufs $cells]
        # Line
        lappend lines [list $port $clk $sslk $sdt $hslk $hdt $wl $wd_pct_s $wd_pct_h $cells]
    }

    # Write
    puts -nonewline $f [csv::joinlist $lines]
    close $f
    puts "Rx output delay written to rx_output_delay.csv"
}

# Static power
proc report_static_power {} {
    # Assume random data - likely worst case activity factor
    set_default_switching_activity -reset
    set_default_switching_activity -input_activity 0.5 -clip_activity_to_domain_freq true
    # Remove contribution of control clock domain
    set_switching_activity -clock clock -activity 0
    report_power -view $::typ_view
}
