set origin_dir [file dirname [info script]]
set bitfile [lindex $argv 0]

write_bitstream -force ${origin_dir}/../${bitfile}.bit

