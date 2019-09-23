#######################################################################
# Ultra96 Bluetooth UART Modem Signals
#######################################################################
set_property IOSTANDARD LVCMOS18 [get_ports bt*]
#BT_HCI_RTS on Ultra96 / emio_uart0_ctsn
set_property PACKAGE_PIN B7 [get_ports bt_ctsn]
#BT_HCI_CTS on Ultra96 / emio_uart0_rtsn
set_property PACKAGE_PIN B5 [get_ports bt_rtsn]

## Fan signal:
set_property PACKAGE_PIN F4 [get_ports {FAN_PWM}];     # "F4.FAN_PWM"

#######################################################################
# Ultra96 MESA Hostmot2 Signals
#######################################################################
set_property PACKAGE_PIN D7 [get_ports {IOBits[0]}];   # "D7.HD_GPIO_0"
set_property PACKAGE_PIN F8 [get_ports {IOBits[1]}];   # "F8.HD_GPIO_1"
set_property PACKAGE_PIN F7 [get_ports {IOBits[2]}];   # "F7.HD_GPIO_2"
set_property PACKAGE_PIN G7 [get_ports {IOBits[3]}];   # "G7.HD_GPIO_3"
set_property PACKAGE_PIN F6 [get_ports {IOBits[4]}];   # "F6.HD_GPIO_4"
set_property PACKAGE_PIN G5 [get_ports {IOBits[5]}];   # "G5.HD_GPIO_5"
set_property PACKAGE_PIN A6 [get_ports {IOBits[6]}];   # "A6.HD_GPIO_6"
set_property PACKAGE_PIN A7 [get_ports {IOBits[7]}];   # "A7.HD_GPIO_7"
set_property PACKAGE_PIN G6 [get_ports {IOBits[8]}];   # "G6.HD_GPIO_8"
set_property PACKAGE_PIN E6 [get_ports {IOBits[9]}];   # "E6.HD_GPIO_9"
set_property PACKAGE_PIN E5 [get_ports {IOBits[10]}];  # "E5.HD_GPIO_10"
set_property PACKAGE_PIN D6 [get_ports {IOBits[11]}];  # "D6.HD_GPIO_11"
set_property PACKAGE_PIN D5 [get_ports {IOBits[12]}];  # "D5.HD_GPIO_12"
set_property PACKAGE_PIN C7 [get_ports {IOBits[13]}];  # "C7.HD_GPIO_13"
set_property PACKAGE_PIN B6 [get_ports {IOBits[14]}];  # "B6.HD_GPIO_14"
set_property PACKAGE_PIN C5 [get_ports {IOBits[15]}];  # "C5.HD_GPIO_15"
set_property PACKAGE_PIN N2 [get_ports {IOBits[16]}];  # "N2.CSI0_C_P"
set_property PACKAGE_PIN P1 [get_ports {IOBits[17]}];  # "P1.CSI0_C_N"
set_property PACKAGE_PIN N5 [get_ports {IOBits[18]}];  # "N5.CSI0_D0_P"
set_property PACKAGE_PIN N4 [get_ports {IOBits[19]}];  # "N4.CSI0_D0_N"
set_property PACKAGE_PIN M2 [get_ports {IOBits[20]}];  # "M2.CSI0_D1_P"
set_property PACKAGE_PIN M1 [get_ports {IOBits[21]}];  # "M1.CSI0_D1_N"
set_property PACKAGE_PIN M5 [get_ports {IOBits[22]}];  # "M5.CSI0_D2_P"
set_property PACKAGE_PIN M4 [get_ports {IOBits[23]}];  # "M4.CSI0_D2_N"
set_property PACKAGE_PIN L2 [get_ports {IOBits[24]}];  # "L2.CSI0_D3_P"
set_property PACKAGE_PIN L1 [get_ports {IOBits[25]}];  # "L1.CSI0_D3_N"
set_property PACKAGE_PIN P3 [get_ports {IOBits[26]}];  # "P3.CSI1_D0_P"
set_property PACKAGE_PIN R3 [get_ports {IOBits[27]}];  # "R3.CSI1_D0_N"
set_property PACKAGE_PIN U2 [get_ports {IOBits[28]}];  # "U2.CSI1_D1_P"
set_property PACKAGE_PIN U1 [get_ports {IOBits[29]}];  # "U1.CSI1_D1_N"
set_property PACKAGE_PIN T3 [get_ports {IOBits[30]}];  # "T3.CSI1_C_P"
set_property PACKAGE_PIN T2 [get_ports {IOBits[31]}];  # "T2.CSI1_C_N"
set_property PACKAGE_PIN C2 [get_ports {LED[0]}];      # "C2.HSIC_DATA"
set_property PACKAGE_PIN A2 [get_ports {IOBits[32]}];  # "A2.HSIC_STR"
set_property PACKAGE_PIN C3 [get_ports {IOBits[33]}];  # "C3.DSI_D3_N"
set_property PACKAGE_PIN D3 [get_ports {IOBits[34]}];  # "D3.DSI_D3_P"
set_property PACKAGE_PIN D1 [get_ports {IOBits[35]}];  # "D1.DSI_D2_N"
set_property PACKAGE_PIN E1 [get_ports {RATES[0]}];    # "E1.DSI_D2_P"
set_property PACKAGE_PIN E3 [get_ports {RATES[1]}];    # "E3.DSI_D1_N"
set_property PACKAGE_PIN E4 [get_ports {RATES[2]}];    # "E4.DSI_D1_P"
set_property PACKAGE_PIN F1 [get_ports {RATES[3]}];    # "F1.DSI_D0_N"
set_property PACKAGE_PIN G1 [get_ports {RATES[4]}];    # "G1.DSI_D0_P"

# Set the bank voltage for IO Bank 26 to 1.8V
set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 26]]

# Set the bank voltage for IO Bank 65 to 1.2V
set_property IOSTANDARD LVCMOS12 [get_ports -of_objects [get_iobanks 65]]

# Set the bank voltage for IO Bank 66 to 1.2V
set_property IOSTANDARD LVCMOS12 [get_ports -of_objects [get_iobanks 66]]
