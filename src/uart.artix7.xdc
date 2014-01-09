# LOC and IOSTANDARDS set for all IOs which is required for generating a Bitstream

## Clock signal
##Bank = 35, Pin name = IO_L12P_T1_MRCC_35,					Sch name = CLK100MHZ
						
	
	
set_property PACKAGE_PIN E3 [get_ports osc_clk]
set_property IOSTANDARD LVCMOS33 [get_ports osc_clk]
create_clock -add -name osc_clk -period 10 [get_ports osc_clk]

#create_clock -period 10 -name hash_clk [get_ports hash_clk]
#create_clock -period 12.5 -name uart_clk [get_ports uart_clk]
#create_clock -period 50 -name pbkdf_clk [get_ports pbkdf_clk]



set_property PACKAGE_PIN C4 [get_ports RxD]
set_property PACKAGE_PIN D4 [get_ports TxD]
set_property PACKAGE_PIN T8 [get_ports led[0]]
set_property PACKAGE_PIN V9 [get_ports led[1]]
set_property PACKAGE_PIN R8 [get_ports led[2]]
set_property PACKAGE_PIN T6 [get_ports led[3]]


set_property PACKAGE_PIN U8 [get_ports dip]

set_property IOSTANDARD LVCMOS33 [all_inputs]
set_property IOSTANDARD LVCMOS33 [all_outputs]

