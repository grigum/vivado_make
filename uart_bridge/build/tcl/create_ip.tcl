set origin_dir [file dirname [info script]]
set part [lindex $argv 0]
create_project -in_memory -part $part

foreach ip_path [glob -type d $origin_dir/../.srcs/sources_1/ip/*] {
    foreach ips [glob $ip_path/*.xci] {
        read_ip $ips
    }
}

start_gui

