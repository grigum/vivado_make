set origin_dir [file dirname [info script]]
set part [lindex $argv 0]
create_project -in_memory -part $part

add_files  -fileset sources_1 [ glob -nocomplain "$origin_dir/../../src/hdl/*.vhd" ]      
add_files  -fileset sim_1 [ glob -nocomplain "$origin_dir/../../src/tb/*.vhd" ]      
foreach ip_path [glob -type d $origin_dir/../.srcs/sources_1/ip/*] {
    foreach ips [glob $ip_path/*.xci] {
        read_ip $ips
    }
}

start_gui

