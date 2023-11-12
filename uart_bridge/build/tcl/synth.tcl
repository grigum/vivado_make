
set top [lindex $argv 0]
set part [lindex $argv 1]
set clk_freq [lindex $argv 2]
set baudrate_a [lindex $argv 3]
set baudrate_b [lindex $argv 4]
set origin_dir [file dirname [info script]]

set project_root [file normalize $origin_dir/../../]


read_vhdl [ glob -nocomplain "$origin_dir/../../src/hdl/*.vhd" ]         
read_xdc [ glob -nocomplain "$origin_dir/../../src/constr/*.xdc" ]

# Добавляем IP-ядра
set ip_files [glob -nocomplain "[file normalize "$origin_dir/../../src/ip/*.tcl" ]"]
foreach ff $ip_files {
	set ip_name [file rootname [file tail $ff]]
    read_checkpoint [file normalize ${origin_dir}/../ip/${ip_name}.dcp]
}


set_property top $top [current_fileset]
reorder_files -auto -disable_unused
synth_design -top $top -part $part -generic CLK_FREQUENCY_HZ=${clk_freq} \
    -generic BAUDRATE_A=${baudrate_a} \
    -generic BAUDRATE_B=${baudrate_b}
write_checkpoint -force $origin_dir/../synth
 
 

