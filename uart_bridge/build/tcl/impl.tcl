set origin_dir [file dirname [info script]]

# Добавляем IP-ядра
#set ip_files [glob "[file normalize "$origin_dir/../ip/*.dcp" ]"]
#foreach ff $ip_files {
#	set ip_name [file rootname [file tail $ff]]
#    read_checkpoint $ff
#}

opt_design
place_design
phys_opt_design
route_design
write_checkpoint -force ${origin_dir}/../impl

