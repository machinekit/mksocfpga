#fan pwm control
#set_property PACKAGE_PIN AD14 [get_ports {FAN_PWM}]
#set_property IOSTANDARD LVCMOS18 [get_ports FAN_PWM]

#######################################################################
# Ultra96 MESA Hostmot2 Signals
#######################################################################
#Pmod0
set_property PACKAGE_PIN J4 [get_ports {IOBits[0]}];   # "J4.IO_L19N_T3L_N1_DBC_AD9N_65"
set_property PACKAGE_PIN J5 [get_ports {IOBits[1]}];   # "J5.IO_L19P_T3L_N0_DBC_AD9P_65"
set_property PACKAGE_PIN N8 [get_ports {IOBits[2]}];   # "N8.IO_L17N_T2U_N9_AD10N_65"
set_property PACKAGE_PIN N9 [get_ports {IOBits[3]}];   # "N9.IO_L17P_T2U_N8_AD10P_65"
set_property PACKAGE_PIN J9 [get_ports {IOBits[4]}];   # "j9.IO_L23N_T3U_N9_65"
set_property PACKAGE_PIN K9 [get_ports {IOBits[5]}];   # "K9.IO_L23P_T3U_N8_I2C_SCLK_65"
set_property PACKAGE_PIN H6 [get_ports {IOBits[6]}];   # "H6.IO_L20N_T3L_N3_AD1N_65"
set_property PACKAGE_PIN J6 [get_ports {IOBits[7]}];   # "J6.IO_L20P_T3L_N2_AD1P_65"
#Pmod1
set_property PACKAGE_PIN AD4 [get_ports {IOBits[8]}];   # "AD4.IO_L13N_T2L_N1_GC_QBC_64"
set_property PACKAGE_PIN AD5 [get_ports {IOBits[9]}];   # "AD5.IO_L13P_T2L_N0_GC_QBC_64"
set_property PACKAGE_PIN AH3 [get_ports {IOBits[10]}];  # "AH3.IO_L20N_T3L_N3_AD1N_64"
set_property PACKAGE_PIN AH1 [get_ports {IOBits[11]}];  # "AH1.IO_L23N_T3U_N9_64"
set_property PACKAGE_PIN AE3 [get_ports {IOBits[12]}];  # "AE3.IO_L21P_T3L_N4_AD8P_64"
set_property PACKAGE_PIN AH4 [get_ports {IOBits[13]}];  # "AH4.IO_L19N_T3L_N1_DBC_AD9N_64"
set_property PACKAGE_PIN AC1 [get_ports {IOBits[14]}];  # "AC1.IO_L18N_T2U_N11_AD2N_64"
set_property PACKAGE_PIN AF3 [get_ports {IOBits[15]}];  # "AF3.IO_L21N_T3L_N5_AD8N_64"
# Arduino
set_property PACKAGE_PIN K8 [get_ports {IOBits[16]}];  # "K8.IO_L22P_T3U_N6_DBC_AD0P_65"
set_property PACKAGE_PIN AH2 [get_ports {IOBits[17]}];  # "AH2.IO_L23P_T3U_N8_64"
set_property PACKAGE_PIN AF2 [get_ports {IOBits[18]}];  # "AF2.IO_L22N_T3U_N7_DBC_AD0N_64"
set_property PACKAGE_PIN AE2 [get_ports {IOBits[19]}];  # "AE2.IO_L22P_T3U_N6_DBC_AD0P_64"
set_property PACKAGE_PIN L8 [get_ports {IOBits[20]}];  # "L8.IO_L18N_T2U_N11_AD2N_65"
set_property PACKAGE_PIN M8 [get_ports {IOBits[21]}];  # "M8.IO_L18P_T2U_N10_AD2P_65"
set_property PACKAGE_PIN AG1 [get_ports {IOBits[22]}];  # "AG1.IO_L24N_T3U_N11_64"
set_property PACKAGE_PIN AF1 [get_ports {IOBits[23]}];  # "AF1.IO_L24P_T3U_N10_64"
set_property PACKAGE_PIN L5 [get_ports {IOBits[24]}];  # "L5.IO_L14N_T2L_N3_GC_65"
set_property PACKAGE_PIN M6 [get_ports {IOBits[25]}];  # "M6.IO_L14P_T2L_N2_GC_65"
set_property PACKAGE_PIN P6 [get_ports {IOBits[26]}];  # "P6.IO_L16N_T2U_N7_QBC_AD3N_65"
set_property PACKAGE_PIN P7 [get_ports {IOBits[27]}];  # "P7.IO_L16P_T2U_N6_QBC_AD3P_65"
set_property PACKAGE_PIN L6 [get_ports {IOBits[28]}];  # "L6.IO_L13N_T2L_N1_GC_QBC_65"
set_property PACKAGE_PIN E1 [get_ports {IOBits[29]}];  # "E1.IO_L13P_T2L_N0_GC_QBC_65"
set_property PACKAGE_PIN N6 [get_ports {IOBits[30]}];  # "N6.IO_L15N_T2L_N5_AD11N_65"
set_property PACKAGE_PIN N7 [get_ports {IOBits[31]}];  # "N7.IO_L15P_T2L_N4_AD11P_65"
#Led
set_property PACKAGE_PIN K7 [get_ports {LED[0]}];      # "K7.IO_L22N_T3U_N7_DBC_AD0N_65"
#FMC Debug J20
set_property PACKAGE_PIN G6 [get_ports {IOBits[32]}];  # "G6.IO_L15P_T2L_N4_AD11P_66"
set_property PACKAGE_PIN K2 [get_ports {IOBits[33]}];  # "K2.IO_L9P_T1L_N4_AD12P_65"
set_property PACKAGE_PIN F6 [get_ports {IOBits[34]}];  # "F6.IO_L15N_T2L_N5_AD11N_66 "
set_property PACKAGE_PIN J2 [get_ports {IOBits[35]}];  # "J2.IO_L9N_T1L_N5_AD12N_65"
set_property PACKAGE_PIN G8 [get_ports {RATES[0]}];    # "G8.IO_L16P_T2U_N6_QBC_AD3P_66"
set_property PACKAGE_PIN R7 [get_ports {RATES[1]}];    # "R7.IO_L5P_T0U_N8_AD14P_65"
set_property PACKAGE_PIN F7 [get_ports {RATES[2]}];    # "F7.IO_L16N_T2U_N7_QBC_AD3N_66"
set_property PACKAGE_PIN T7 [get_ports {RATES[3]}];    # "T7.IO_L5N_T0U_N9_AD14N_65"
set_property PACKAGE_PIN F8 [get_ports {RATES[4]}];    # "F8.IO_L17P_T2U_N8_AD10P_66"

# Set the bank voltage for IO Bank 25 to 3.3V
#set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 25]]

# Set the bank voltage for IO Bank 26 to 3.3V
set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 64]]

# Set the bank voltage for IO Bank 65 to 1.8V
set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 65]]

# Set the bank voltage for IO Bank 66 to 1.8V
set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 66]]
