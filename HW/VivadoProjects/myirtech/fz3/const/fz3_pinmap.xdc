#fan pwm control
#set_property PACKAGE_PIN AD14 [get_ports {FAN_PWM}]
#set_property IOSTANDARD LVCMOS33 [get_ports FAN_PWM]

#######################################################################
# Ultra96 MESA Hostmot2 Signals
#######################################################################
set_property PACKAGE_PIN B11 [get_ports {IOBits[0]}];   # "B11.HD_L10P_25"
set_property PACKAGE_PIN E12 [get_ports {IOBits[1]}];   # "E12.HD_L08P_25"
set_property PACKAGE_PIN A10 [get_ports {IOBits[2]}];   # "A10.HD_L10N_25"
set_property PACKAGE_PIN D11 [get_ports {IOBits[3]}];   # "D11.HD_L08N_25"
set_property PACKAGE_PIN F12 [get_ports {IOBits[4]}];   # "F12.HD_L06P_25"
set_property PACKAGE_PIN G13 [get_ports {IOBits[5]}];   # "G13.HD_L07P_26"
set_property PACKAGE_PIN F11 [get_ports {IOBits[6]}];   # "F11.HD_L06N_25"
set_property PACKAGE_PIN F13 [get_ports {IOBits[7]}];   # "F13.HD_L07N_26"
set_property PACKAGE_PIN E10 [get_ports {IOBits[8]}];   # "E10.HD_L07P_25"
set_property PACKAGE_PIN G11 [get_ports {IOBits[9]}];   # "G11.HD_L05P_25"
set_property PACKAGE_PIN D10 [get_ports {IOBits[10]}];  # "D10.HD_L07N_25"
set_property PACKAGE_PIN F10 [get_ports {IOBits[11]}];  # "F10.HD_L05N_25"
set_property PACKAGE_PIN A12 [get_ports {IOBits[12]}];  # "A12.HD_L11P_25"
set_property PACKAGE_PIN C11 [get_ports {IOBits[13]}];  # "C11.HD_L09P_25"
set_property PACKAGE_PIN A11 [get_ports {IOBits[14]}];  # "A11.HD_L11N_25"
set_property PACKAGE_PIN B10 [get_ports {IOBits[15]}];  # "B10.HD_L09N_25"
set_property PACKAGE_PIN E14 [get_ports {IOBits[16]}];  # "E14.HD_L06P_26"
set_property PACKAGE_PIN B13 [get_ports {IOBits[17]}];  # "B13.HD_L03P_26"
set_property PACKAGE_PIN E13 [get_ports {IOBits[18]}];  # "E13.HD_L06N_26"
set_property PACKAGE_PIN A13 [get_ports {IOBits[19]}];  # "A13.HD_L03N_26"
set_property PACKAGE_PIN F15 [get_ports {IOBits[20]}];  # "F15.HD_L08P_26"
set_property PACKAGE_PIN H14 [get_ports {IOBits[21]}];  # "H14.HD_L10P_26"
set_property PACKAGE_PIN E15 [get_ports {IOBits[22]}];  # "E15.HD_L08N_26"
set_property PACKAGE_PIN H13 [get_ports {IOBits[23]}];  # "M4.HD_L10N_26"
set_property PACKAGE_PIN A2 [get_ports {IOBits[24]}];  # "A2.HP_BANK66_L08_P"
set_property PACKAGE_PIN C1 [get_ports {IOBits[25]}];  # "C1.HP_BANK66_L07_P"
set_property PACKAGE_PIN A1 [get_ports {IOBits[26]}];  # "A1.HP_BANK66_L08_N"
set_property PACKAGE_PIN B1 [get_ports {IOBits[27]}];  # "B1.HP_BANK66_L07_N"
set_property PACKAGE_PIN C3 [get_ports {IOBits[28]}];  # "C3.HP_BANK66_L12_P"
set_property PACKAGE_PIN E1 [get_ports {IOBits[29]}];  # "E1.HP_BANK66_L02_P"
set_property PACKAGE_PIN C2 [get_ports {IOBits[30]}];  # "C2.HP_BANK66_L12_N"
set_property PACKAGE_PIN D1 [get_ports {IOBits[31]}];  # "D1.HP_BANK66_L02_N"
set_property PACKAGE_PIN G1 [get_ports {LED[0]}];      # "G1.HP_BANK66_L01_P"
set_property PACKAGE_PIN J1 [get_ports {IOBits[32]}];  # "J1.HP_BANK65_L08_P"
set_property PACKAGE_PIN F1 [get_ports {IOBits[33]}];  # "F1.HP_BANK66_L01_N"
set_property PACKAGE_PIN H1 [get_ports {IOBits[34]}];  # "H1.HP_BANK65_L08_N"
set_property PACKAGE_PIN L1 [get_ports {IOBits[35]}];  # "L1.HP_BANK65_L07_P"
set_property PACKAGE_PIN L3 [get_ports {RATES[0]}];    # "L3.HP_BANK65_L12_P"
set_property PACKAGE_PIN K1 [get_ports {RATES[1]}];    # "K1.HP_BANK65_L07_N"
set_property PACKAGE_PIN L2 [get_ports {RATES[2]}];    # "L2.HP_BANK65_L12_N"

# Set the bank voltage for IO Bank 25 to 3.3V
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 25]]

# Set the bank voltage for IO Bank 26 to 3.3V
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 26]]

# Set the bank voltage for IO Bank 65 to 1.8V
set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 65]]

# Set the bank voltage for IO Bank 66 to 1.8V
set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 66]]
