set part [lindex $argv 0]
set src_ip [lindex $argv 1]
set origin_dir [file dirname [info script]]
set ip_name [file rootname [file tail $src_ip]]
set ip_work_dir [file normalize ${origin_dir}/../.srcs/sources_1/ip/${ip_name} ]
set ip_dest_dir [file normalize ${origin_dir}/../ip/ ]

if { [file exists ${ip_work_dir}] } {
    file delete -force $ip_work_dir
}

if { ! [file exists ${ip_dest_dir}] } {
    file mkdir $ip_dest_dir
}

create_project -in_memory -part $part
source $src_ip
synth_ip [get_ips ${ip_name}] -force
file copy -force ${ip_work_dir}/${ip_name}.dcp ${ip_dest_dir}

