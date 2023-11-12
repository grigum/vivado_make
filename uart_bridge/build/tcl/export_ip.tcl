set origin_dir [file dirname [info script]]
foreach ip [get_ips] {
    set props [list_property [get_ips $ip]]
    foreach pr $props {
        dict set ip_props $pr [get_property $pr [get_ips $ip]]
    }
    
    set ff [open $origin_dir/../../src/ip/${ip}.tcl w]
    puts $ff [format "create_ip -vendor %s -library %s -name %s -version %s -module_name %s" \
    {*}[split [dict get $ip_props IPDEF] : ] [dict get $ip_props NAME]]
    puts $ff "set_property -dict \[list \\"
    dict for {k v} $ip_props {
        if { [string first CONFIG. $k ] == 0 } {
            puts $ff [format "\t%s {%s} \\" $k $v]
        } 
    }
    puts $ff [format "\] \[ get_ips %s \]" [dict get $ip_props NAME]]
    close $ff
}
