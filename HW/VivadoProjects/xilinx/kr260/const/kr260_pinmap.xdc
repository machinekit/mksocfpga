#Fan Speed Enable
set_property PACKAGE_PIN A12 [get_ports {fan_en_b[0]}]
set_property SLEW SLOW [get_ports {fan_en_b[0]}]
set_property DRIVE 4 [get_ports {fan_en_b[0]}]

#######################################################################
# KR260 MESA Hostmot2 Signals
#######################################################################
######################## PMOD 1 Upper ########################
set_property PACKAGE_PIN H12 [get_ports {IOBits[0]}]
set_property PACKAGE_PIN E10 [get_ports {IOBits[1]}]
set_property PACKAGE_PIN D10 [get_ports {IOBits[2]}]
set_property PACKAGE_PIN C11 [get_ports {IOBits[3]}]

######################## PMOD 1 Lower ########################
set_property PACKAGE_PIN B10 [get_ports {IOBits[4]}]
set_property PACKAGE_PIN E12 [get_ports {IOBits[5]}]
set_property PACKAGE_PIN D11 [get_ports {IOBits[6]}]
set_property PACKAGE_PIN B11 [get_ports {IOBits[7]}]

######################## PMOD 2 Upper ########################
set_property PACKAGE_PIN J11 [get_ports {IOBits[8]}]
set_property PACKAGE_PIN J10 [get_ports {IOBits[9]}]
set_property PACKAGE_PIN K13 [get_ports {IOBits[10]}]
set_property PACKAGE_PIN K12 [get_ports {IOBits[11]}]

######################## PMOD 2 Lower ########################
set_property PACKAGE_PIN H11 [get_ports {IOBits[12]}]
set_property PACKAGE_PIN G10 [get_ports {IOBits[13]}]
set_property PACKAGE_PIN F12 [get_ports {IOBits[14]}]
set_property PACKAGE_PIN F11 [get_ports {IOBits[15]}]

######################## PMOD 3 Upper ########################
set_property PACKAGE_PIN AE12 [get_ports {IOBits[16]}]
set_property PACKAGE_PIN AF12 [get_ports {IOBits[17]}]
set_property PACKAGE_PIN AG10 [get_ports {IOBits[18]}]
set_property PACKAGE_PIN AH10 [get_ports {IOBits[19]}]

######################## PMOD 3 Lower ########################
set_property PACKAGE_PIN AF11 [get_ports {IOBits[20]}]
set_property PACKAGE_PIN AG11 [get_ports {IOBits[21]}]
set_property PACKAGE_PIN AH12 [get_ports {IOBits[22]}]
set_property PACKAGE_PIN AH11 [get_ports {IOBits[23]}]

######################## PMOD 4 Upper ########################
set_property PACKAGE_PIN AC12 [get_ports {IOBits[24]}]
set_property PACKAGE_PIN AD12 [get_ports {IOBits[25]}]
set_property PACKAGE_PIN AE10 [get_ports {IOBits[26]}]
set_property PACKAGE_PIN AF10 [get_ports {IOBits[27]}]

######################## PMOD 4 Lower ########################
set_property PACKAGE_PIN AD11 [get_ports {IOBits[28]}]
set_property PACKAGE_PIN AD10 [get_ports {IOBits[29]}]
set_property PACKAGE_PIN AA11 [get_ports {IOBits[30]}]
set_property PACKAGE_PIN AA10 [get_ports {IOBits[31]}]

set_property PACKAGE_PIN AD15 [get_ports {LED[0]}]
set_property PACKAGE_PIN AD14 [get_ports {IOBits[32]}]
set_property PACKAGE_PIN AE15 [get_ports {IOBits[33]}]
set_property PACKAGE_PIN AE14 [get_ports {IOBits[34]}]
set_property PACKAGE_PIN AG14 [get_ports {IOBits[35]}]
set_property PACKAGE_PIN AH14 [get_ports {RATES[0]}]
set_property PACKAGE_PIN AG13 [get_ports {RATES[1]}]
set_property PACKAGE_PIN AH13 [get_ports {RATES[2]}]

# Set the bank voltage for IO Bank 43 to 3.3V
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 43]]

# Set the bank voltage for IO Bank 44 to 3.3V
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 44]]

# Set the bank voltage for IO Bank 45 to 3.3V
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 45]]

# Set the bank voltage for IO Bank 65 to 1.8V
#set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 65]]

# Set the bank voltage for IO Bank 66 to 1.8V
#set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 66]]

