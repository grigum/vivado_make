# AC701 Evaluation Board Rev2.0
# clocking
set_property -dict {IOSTANDARD LVDS_25 PACKAGE_PIN R3} [get_ports i_clk_p]
create_clock -period 5.0 [get_ports i_clk_p]

#reset
set_property -dict {IOSTANDARD SSTL15 PACKAGE_PIN U4} [get_ports i_reset]

# USB-to-Uart bridge
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN U19} [get_ports o_tx_a]
set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN T19} [get_ports i_rx_a]

# PMOD_0 = tx
# PMOD_1 = rx
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN P26} [get_ports o_tx_b]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN T22} [get_ports i_rx_b]
