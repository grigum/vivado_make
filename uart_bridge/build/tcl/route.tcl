set origin_dir [file dirname [info script]]

route_design
write_checkpoint -force ${origin_dir}/../route
