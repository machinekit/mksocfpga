################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2015.4
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   puts "ERROR: This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."

   return 1
}

################################################################
# START
################################################################

# CHECKING IF PROJECT EXISTS
if { [get_projects -quiet] eq "" } {
   puts "ERROR: Please open or create a project!"
   return 1
}

# CHANGE DESIGN NAME HERE
set design_name soc_system

# This script was generated for a remote BD
set str_bd_folder [get_property directory [current_project]]/src
set str_bd_filepath ${str_bd_folder}/${design_name}.bd

# Check if remote design exists on disk
if { [file exists $str_bd_filepath ] == 1 } {
   puts "ERROR: The remote BD file path <$str_bd_filepath> already exists!\n"

   puts "INFO: Please modify the variable <str_bd_folder> to another path or modify the variable <design_name>."

   return 1
}

# Check if design exists in memory
set list_existing_designs [get_bd_designs -quiet $design_name]
if { $list_existing_designs ne "" } {
   puts "ERROR: The design <$design_name> already exists in this project!"
   puts "ERROR: Will not create the remote BD <$design_name> at the folder <$str_bd_folder>.\n"

   puts "INFO: Please modify the variable <design_name>."

   return 1
}

# Check if design exists on disk within project
set list_existing_designs [get_files */${design_name}.bd]
if { $list_existing_designs ne "" } {
   puts "ERROR: The design <$design_name> already exists in this project at location:"
   puts "   $list_existing_designs"
   puts "ERROR: Will not create the remote BD <$design_name> at the folder <$str_bd_folder>.\n"

   puts "INFO: Please modify the variable <design_name>."

   return 1
}

# Now can create the remote BD
create_bd_design -dir $str_bd_folder $design_name
current_bd_design $design_name

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]

  # Create ports
  set IOBits [ create_bd_port -dir IO -from 31 -to 0 IOBits ]
  set uart_rtl_0_rxd [ create_bd_port -dir I uart_rtl_0_rxd ]
  set uart_rtl_0_txd [ create_bd_port -dir O -from 0 -to 0 uart_rtl_0_txd ]
  set uart_rtl_1_rxd [ create_bd_port -dir I uart_rtl_1_rxd ]
  set uart_rtl_1_txd [ create_bd_port -dir O uart_rtl_1_txd ]

  # Create instance: HostMot2_ip_wrap_0, and set properties
  set HostMot2_ip_wrap_0 [ create_bd_cell -type ip -vlnv machinekit.io:user:HostMot2_ip_wrap:1.0 HostMot2_ip_wrap_0 ]
  set_property -dict [ list \
CONFIG.ClockLow {100000000} \
CONFIG.IOPorts {1} \
CONFIG.IOWidth {32} \
CONFIG.PortWidth {32} \
 ] $HostMot2_ip_wrap_0

  # Create instance: btint_axi_0, and set properties
  set btint_axi_0 [ create_bd_cell -type ip -vlnv jd2.com:user:btint_axi:1.0 btint_axi_0 ]

  # Create instance: btint_axi_1, and set properties
  set btint_axi_1 [ create_bd_cell -type ip -vlnv jd2.com:user:btint_axi:1.0 btint_axi_1 ]

  # Create instance: hm2_axilite_int_0, and set properties
  set hm2_axilite_int_0 [ create_bd_cell -type ip -vlnv machinekit.io:user:hm2_axilite_int:1.0 hm2_axilite_int_0 ]
  set_property -dict [ list \
CONFIG.C_S_AXI_ADDR_WIDTH {16} \
 ] $hm2_axilite_int_0

  # Create instance: hm2_io_ts_0, and set properties
  set hm2_io_ts_0 [ create_bd_cell -type ip -vlnv machinekit.io:user:hm2_io_ts:1 hm2_io_ts_0 ]
  set_property -dict [ list \
CONFIG.WIDTH {32} \
 ] $hm2_io_ts_0

  # Create instance: jd2_mad_logic_0, and set properties
  set jd2_mad_logic_0 [ create_bd_cell -type ip -vlnv jd2.com:user:jd2_mad_logic:1 jd2_mad_logic_0 ]
  set_property -dict [ list \
CONFIG.WIDTH {32} \
 ] $jd2_mad_logic_0

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list \
CONFIG.PCW_APU_CLK_RATIO_ENABLE {6:2:1} \
CONFIG.PCW_APU_PERIPHERAL_FREQMHZ {667} \
CONFIG.PCW_CPU_PERIPHERAL_CLKSRC {ARM PLL} \
CONFIG.PCW_CRYSTAL_PERIPHERAL_FREQMHZ {33.333333} \
CONFIG.PCW_DDR_PERIPHERAL_CLKSRC {DDR PLL} \
CONFIG.PCW_ENET0_ENET0_IO {MIO 16 .. 27} \
CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1} \
CONFIG.PCW_ENET0_GRP_MDIO_IO {MIO 52 .. 53} \
CONFIG.PCW_ENET0_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_ENET0_PERIPHERAL_FREQMHZ {1000 Mbps} \
CONFIG.PCW_ENET0_RESET_ENABLE {0} \
CONFIG.PCW_EN_CLK0_PORT {1} \
CONFIG.PCW_EN_CLK1_PORT {1} \
CONFIG.PCW_EN_CLK2_PORT {0} \
CONFIG.PCW_EN_CLK3_PORT {0} \
CONFIG.PCW_EN_DDR {1} \
CONFIG.PCW_EN_RST0_PORT {1} \
CONFIG.PCW_EN_RST1_PORT {0} \
CONFIG.PCW_EN_RST2_PORT {0} \
CONFIG.PCW_EN_RST3_PORT {0} \
CONFIG.PCW_FCLK0_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_FCLK1_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_FCLK2_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_FCLK3_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_FCLK_CLK0_BUF {true} \
CONFIG.PCW_FCLK_CLK1_BUF {true} \
CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100} \
CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {200} \
CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {33.333333} \
CONFIG.PCW_FPGA3_PERIPHERAL_FREQMHZ {50} \
CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {0} \
CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1} \
CONFIG.PCW_GPIO_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_I2C_RESET_ENABLE {0} \
CONFIG.PCW_IRQ_F2P_INTR {1} \
CONFIG.PCW_MIO_0_PULLUP {disabled} \
CONFIG.PCW_MIO_0_SLEW {slow} \
CONFIG.PCW_MIO_10_PULLUP {disabled} \
CONFIG.PCW_MIO_10_SLEW {slow} \
CONFIG.PCW_MIO_11_PULLUP {disabled} \
CONFIG.PCW_MIO_11_SLEW {slow} \
CONFIG.PCW_MIO_12_PULLUP {disabled} \
CONFIG.PCW_MIO_12_SLEW {slow} \
CONFIG.PCW_MIO_13_PULLUP {disabled} \
CONFIG.PCW_MIO_13_SLEW {slow} \
CONFIG.PCW_MIO_14_PULLUP {disabled} \
CONFIG.PCW_MIO_14_SLEW {slow} \
CONFIG.PCW_MIO_15_PULLUP {disabled} \
CONFIG.PCW_MIO_15_SLEW {slow} \
CONFIG.PCW_MIO_16_PULLUP {disabled} \
CONFIG.PCW_MIO_16_SLEW {slow} \
CONFIG.PCW_MIO_17_PULLUP {disabled} \
CONFIG.PCW_MIO_17_SLEW {slow} \
CONFIG.PCW_MIO_18_PULLUP {disabled} \
CONFIG.PCW_MIO_18_SLEW {slow} \
CONFIG.PCW_MIO_19_PULLUP {disabled} \
CONFIG.PCW_MIO_19_SLEW {slow} \
CONFIG.PCW_MIO_1_PULLUP {disabled} \
CONFIG.PCW_MIO_1_SLEW {slow} \
CONFIG.PCW_MIO_20_PULLUP {disabled} \
CONFIG.PCW_MIO_20_SLEW {slow} \
CONFIG.PCW_MIO_21_PULLUP {disabled} \
CONFIG.PCW_MIO_21_SLEW {slow} \
CONFIG.PCW_MIO_22_PULLUP {disabled} \
CONFIG.PCW_MIO_22_SLEW {slow} \
CONFIG.PCW_MIO_23_PULLUP {disabled} \
CONFIG.PCW_MIO_23_SLEW {slow} \
CONFIG.PCW_MIO_24_PULLUP {disabled} \
CONFIG.PCW_MIO_24_SLEW {slow} \
CONFIG.PCW_MIO_25_PULLUP {disabled} \
CONFIG.PCW_MIO_25_SLEW {slow} \
CONFIG.PCW_MIO_26_PULLUP {disabled} \
CONFIG.PCW_MIO_26_SLEW {slow} \
CONFIG.PCW_MIO_27_PULLUP {disabled} \
CONFIG.PCW_MIO_27_SLEW {slow} \
CONFIG.PCW_MIO_28_PULLUP {disabled} \
CONFIG.PCW_MIO_28_SLEW {slow} \
CONFIG.PCW_MIO_29_PULLUP {disabled} \
CONFIG.PCW_MIO_29_SLEW {slow} \
CONFIG.PCW_MIO_2_SLEW {slow} \
CONFIG.PCW_MIO_30_PULLUP {disabled} \
CONFIG.PCW_MIO_30_SLEW {slow} \
CONFIG.PCW_MIO_31_PULLUP {disabled} \
CONFIG.PCW_MIO_31_SLEW {slow} \
CONFIG.PCW_MIO_32_PULLUP {disabled} \
CONFIG.PCW_MIO_32_SLEW {slow} \
CONFIG.PCW_MIO_33_PULLUP {disabled} \
CONFIG.PCW_MIO_33_SLEW {slow} \
CONFIG.PCW_MIO_34_PULLUP {disabled} \
CONFIG.PCW_MIO_34_SLEW {slow} \
CONFIG.PCW_MIO_35_PULLUP {disabled} \
CONFIG.PCW_MIO_35_SLEW {slow} \
CONFIG.PCW_MIO_36_PULLUP {disabled} \
CONFIG.PCW_MIO_36_SLEW {slow} \
CONFIG.PCW_MIO_37_PULLUP {disabled} \
CONFIG.PCW_MIO_37_SLEW {slow} \
CONFIG.PCW_MIO_38_PULLUP {disabled} \
CONFIG.PCW_MIO_38_SLEW {slow} \
CONFIG.PCW_MIO_39_PULLUP {disabled} \
CONFIG.PCW_MIO_39_SLEW {slow} \
CONFIG.PCW_MIO_3_SLEW {slow} \
CONFIG.PCW_MIO_40_PULLUP {disabled} \
CONFIG.PCW_MIO_40_SLEW {slow} \
CONFIG.PCW_MIO_41_PULLUP {disabled} \
CONFIG.PCW_MIO_41_SLEW {slow} \
CONFIG.PCW_MIO_42_PULLUP {disabled} \
CONFIG.PCW_MIO_42_SLEW {slow} \
CONFIG.PCW_MIO_43_PULLUP {disabled} \
CONFIG.PCW_MIO_43_SLEW {slow} \
CONFIG.PCW_MIO_44_PULLUP {disabled} \
CONFIG.PCW_MIO_44_SLEW {slow} \
CONFIG.PCW_MIO_45_PULLUP {disabled} \
CONFIG.PCW_MIO_45_SLEW {slow} \
CONFIG.PCW_MIO_46_PULLUP {disabled} \
CONFIG.PCW_MIO_46_SLEW {slow} \
CONFIG.PCW_MIO_47_PULLUP {disabled} \
CONFIG.PCW_MIO_47_SLEW {slow} \
CONFIG.PCW_MIO_48_PULLUP {disabled} \
CONFIG.PCW_MIO_48_SLEW {slow} \
CONFIG.PCW_MIO_49_PULLUP {disabled} \
CONFIG.PCW_MIO_49_SLEW {slow} \
CONFIG.PCW_MIO_4_SLEW {slow} \
CONFIG.PCW_MIO_50_PULLUP {disabled} \
CONFIG.PCW_MIO_50_SLEW {slow} \
CONFIG.PCW_MIO_51_PULLUP {disabled} \
CONFIG.PCW_MIO_51_SLEW {slow} \
CONFIG.PCW_MIO_52_PULLUP {disabled} \
CONFIG.PCW_MIO_52_SLEW {slow} \
CONFIG.PCW_MIO_53_PULLUP {disabled} \
CONFIG.PCW_MIO_53_SLEW {slow} \
CONFIG.PCW_MIO_5_SLEW {slow} \
CONFIG.PCW_MIO_6_SLEW {slow} \
CONFIG.PCW_MIO_7_SLEW {slow} \
CONFIG.PCW_MIO_8_SLEW {slow} \
CONFIG.PCW_MIO_9_PULLUP {disabled} \
CONFIG.PCW_MIO_9_SLEW {slow} \
CONFIG.PCW_PACKAGE_NAME {clg400} \
CONFIG.PCW_PRESET_BANK0_VOLTAGE {LVCMOS 3.3V} \
CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V} \
CONFIG.PCW_QSPI_GRP_FBCLK_ENABLE {1} \
CONFIG.PCW_QSPI_GRP_FBCLK_IO {MIO 8} \
CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
CONFIG.PCW_QSPI_GRP_SINGLE_SS_IO {MIO 1 .. 6} \
CONFIG.PCW_QSPI_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_QSPI_PERIPHERAL_FREQMHZ {200} \
CONFIG.PCW_SD0_GRP_CD_ENABLE {1} \
CONFIG.PCW_SD0_GRP_CD_IO {MIO 46} \
CONFIG.PCW_SD0_GRP_WP_ENABLE {1} \
CONFIG.PCW_SD0_GRP_WP_IO {MIO 50} \
CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_SD0_SD0_IO {MIO 40 .. 45} \
CONFIG.PCW_SDIO_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ {25} \
CONFIG.PCW_TTC0_CLK0_PERIPHERAL_CLKSRC {CPU_1X} \
CONFIG.PCW_TTC0_CLK1_PERIPHERAL_CLKSRC {CPU_1X} \
CONFIG.PCW_TTC0_CLK2_PERIPHERAL_CLKSRC {CPU_1X} \
CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_TTC0_TTC0_IO {EMIO} \
CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_UART1_UART1_IO {MIO 48 .. 49} \
CONFIG.PCW_UART_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_UART_PERIPHERAL_FREQMHZ {50} \
CONFIG.PCW_UIPARAM_ACT_DDR_FREQ_MHZ {533.333374} \
CONFIG.PCW_UIPARAM_DDR_BL {8} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {0.294} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {0.298} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2 {0.338} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3 {0.334} \
CONFIG.PCW_UIPARAM_DDR_BUS_WIDTH {32 Bit} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_0_LENGTH_MM {39.7} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_1_LENGTH_MM {39.7} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_2_LENGTH_MM {54.14} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_3_LENGTH_MM {54.14} \
CONFIG.PCW_UIPARAM_DDR_DQS_0_LENGTH_MM {50.05} \
CONFIG.PCW_UIPARAM_DDR_DQS_1_LENGTH_MM {50.43} \
CONFIG.PCW_UIPARAM_DDR_DQS_2_LENGTH_MM {50.10} \
CONFIG.PCW_UIPARAM_DDR_DQS_3_LENGTH_MM {50.01} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {-0.073} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {-0.072} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 {0.024} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 {0.023} \
CONFIG.PCW_UIPARAM_DDR_DQ_0_LENGTH_MM {49.59} \
CONFIG.PCW_UIPARAM_DDR_DQ_1_LENGTH_MM {51.74} \
CONFIG.PCW_UIPARAM_DDR_DQ_2_LENGTH_MM {50.32} \
CONFIG.PCW_UIPARAM_DDR_DQ_3_LENGTH_MM {48.55} \
CONFIG.PCW_UIPARAM_DDR_MEMORY_TYPE {DDR 3 (Low Voltage)} \
CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41K256M16 RE-125} \
CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE {1} \
CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE {1} \
CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL {1} \
CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF {1} \
CONFIG.PCW_USB0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_USB0_RESET_ENABLE {1} \
CONFIG.PCW_USB0_RESET_IO {MIO 7} \
CONFIG.PCW_USB0_USB0_IO {MIO 28 .. 39} \
CONFIG.PCW_USE_FABRIC_INTERRUPT {1} \
CONFIG.PCW_USE_M_AXI_GP0 {1} \
CONFIG.PCW_USE_M_AXI_GP1 {0} \
 ] $processing_system7_0

  # Create instance: processing_system7_0_axi_periph, and set properties
  set processing_system7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 processing_system7_0_axi_periph ]
  set_property -dict [ list \
CONFIG.NUM_MI {3} \
 ] $processing_system7_0_axi_periph

  # Create instance: rst_processing_system7_0_100M, and set properties
  set rst_processing_system7_0_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_processing_system7_0_100M ]

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [ list \
CONFIG.C_OPERATION {not} \
CONFIG.C_SIZE {1} \
 ] $util_vector_logic_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
CONFIG.IN0_WIDTH {1} \
CONFIG.NUM_PORTS {1} \
 ] $xlconcat_0

  # Create interface connections
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins processing_system7_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M00_AXI [get_bd_intf_pins hm2_axilite_int_0/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M01_AXI [get_bd_intf_pins btint_axi_0/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M02_AXI [get_bd_intf_pins btint_axi_1/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M02_AXI]

  # Create port connections
  connect_bd_net -net HostMot2_ip_wrap_0_interrupt [get_bd_pins HostMot2_ip_wrap_0/interrupt] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net HostMot2_ip_wrap_0_ioddrbits [get_bd_pins HostMot2_ip_wrap_0/ioddrbits] [get_bd_pins hm2_io_ts_0/ddr_bits]
  connect_bd_net -net HostMot2_ip_wrap_0_ioodrbits [get_bd_pins HostMot2_ip_wrap_0/ioodrbits] [get_bd_pins hm2_io_ts_0/odr_bits]
  connect_bd_net -net HostMot2_ip_wrap_0_obus [get_bd_pins HostMot2_ip_wrap_0/obus] [get_bd_pins hm2_axilite_int_0/OBUS]
  connect_bd_net -net HostMot2_ip_wrap_0_outbits [get_bd_pins HostMot2_ip_wrap_0/outbits] [get_bd_pins hm2_io_ts_0/o_bits]
  connect_bd_net -net Net [get_bd_ports IOBits] [get_bd_pins hm2_io_ts_0/iobits]
  connect_bd_net -net btint_axi_0_UART_TX [get_bd_ports uart_rtl_0_txd] [get_bd_pins btint_axi_0/UART_TX]
  connect_bd_net -net btint_axi_1_UART_TX [get_bd_ports uart_rtl_1_txd] [get_bd_pins btint_axi_1/UART_TX]
  connect_bd_net -net hm2_axilite_int_0_ADDR [get_bd_pins HostMot2_ip_wrap_0/addr] [get_bd_pins hm2_axilite_int_0/ADDR]
  connect_bd_net -net hm2_axilite_int_0_IBUS [get_bd_pins HostMot2_ip_wrap_0/ibus] [get_bd_pins hm2_axilite_int_0/IBUS]
  connect_bd_net -net hm2_axilite_int_0_READSTB [get_bd_pins HostMot2_ip_wrap_0/readstb] [get_bd_pins hm2_axilite_int_0/READSTB]
  connect_bd_net -net hm2_axilite_int_0_WRITESTB [get_bd_pins HostMot2_ip_wrap_0/writestb] [get_bd_pins hm2_axilite_int_0/WRITESTB]
  connect_bd_net -net hm2_io_ts_0_i_bits [get_bd_pins hm2_io_ts_0/i_bits] [get_bd_pins jd2_mad_logic_0/INS]
  connect_bd_net -net jd2_mad_logic_0_LOG_INS [get_bd_pins HostMot2_ip_wrap_0/inbits] [get_bd_pins jd2_mad_logic_0/LOG_INS]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins HostMot2_ip_wrap_0/clklow] [get_bd_pins HostMot2_ip_wrap_0/clkmed] [get_bd_pins btint_axi_0/S_AXI_ACLK] [get_bd_pins btint_axi_1/S_AXI_ACLK] [get_bd_pins hm2_axilite_int_0/S_AXI_ACLK] [get_bd_pins jd2_mad_logic_0/clk] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0_axi_periph/ACLK] [get_bd_pins processing_system7_0_axi_periph/M00_ACLK] [get_bd_pins processing_system7_0_axi_periph/M01_ACLK] [get_bd_pins processing_system7_0_axi_periph/M02_ACLK] [get_bd_pins processing_system7_0_axi_periph/S00_ACLK] [get_bd_pins rst_processing_system7_0_100M/slowest_sync_clk]
  connect_bd_net -net processing_system7_0_FCLK_CLK1 [get_bd_pins HostMot2_ip_wrap_0/clkhigh] [get_bd_pins processing_system7_0/FCLK_CLK1]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_processing_system7_0_100M/ext_reset_in]
  connect_bd_net -net rst_processing_system7_0_100M_interconnect_aresetn [get_bd_pins processing_system7_0_axi_periph/ARESETN] [get_bd_pins rst_processing_system7_0_100M/interconnect_aresetn]
  connect_bd_net -net rst_processing_system7_0_100M_peripheral_aresetn [get_bd_pins btint_axi_0/S_AXI_ARESETN] [get_bd_pins btint_axi_1/S_AXI_ARESETN] [get_bd_pins hm2_axilite_int_0/S_AXI_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M00_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M01_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M02_ARESETN] [get_bd_pins processing_system7_0_axi_periph/S00_ARESETN] [get_bd_pins rst_processing_system7_0_100M/peripheral_aresetn]
  connect_bd_net -net uart_rtl_0_rxd_1 [get_bd_ports uart_rtl_0_rxd] [get_bd_pins btint_axi_0/UART_RX]
  connect_bd_net -net uart_rtl_1_rxd_1 [get_bd_ports uart_rtl_1_rxd] [get_bd_pins btint_axi_1/UART_RX]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins btint_axi_0/sync] [get_bd_pins btint_axi_1/sync] [get_bd_pins util_vector_logic_0/Res] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins processing_system7_0/IRQ_F2P] [get_bd_pins xlconcat_0/dout]

  # Create address segments
  create_bd_addr_seg -range 0x10000 -offset 0x43C10000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs btint_axi_0/S_AXI/reg0] SEG_btint_axi_0_reg0
  create_bd_addr_seg -range 0x10000 -offset 0x43C20000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs btint_axi_1/S_AXI/reg0] SEG_btint_axi_1_reg0
  create_bd_addr_seg -range 0x10000 -offset 0x43C00000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs hm2_axilite_int_0/S_AXI/reg0] SEG_hm2_axilite_int_0_reg0

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   guistr: "# # String gsaved with Nlview 6.5.5  2015-06-26 bk=1.3371 VDI=38 GEI=35 GUI=JA:1.8
#  -string -flagsOSRD
preplace port uart_rtl_1_rxd -pg 1 -y 360 -defaultsOSRD -right
preplace port uart_rtl_1_txd -pg 1 -y 450 -defaultsOSRD
preplace port DDR -pg 1 -y 540 -defaultsOSRD
preplace port FIXED_IO -pg 1 -y 730 -defaultsOSRD
preplace port uart_rtl_0_rxd -pg 1 -y 710 -defaultsOSRD -right
preplace portBus uart_rtl_0_txd -pg 1 -y 630 -defaultsOSRD
preplace portBus IOBits -pg 1 -y 250 -defaultsOSRD
preplace inst rst_processing_system7_0_100M -pg 1 -lvl 5 -y 430 -defaultsOSRD
preplace inst jd2_mad_logic_0 -pg 1 -lvl 1 -y 220 -defaultsOSRD
preplace inst xlconcat_0 -pg 1 -lvl 4 -y 750 -defaultsOSRD
preplace inst util_vector_logic_0 -pg 1 -lvl 3 -y 100 -defaultsOSRD
preplace inst hm2_io_ts_0 -pg 1 -lvl 7 -y 240 -defaultsOSRD
preplace inst hm2_axilite_int_0 -pg 1 -lvl 7 -y 90 -defaultsOSRD
preplace inst btint_axi_0 -pg 1 -lvl 7 -y 630 -defaultsOSRD
preplace inst btint_axi_1 -pg 1 -lvl 7 -y 450 -defaultsOSRD
preplace inst HostMot2_ip_wrap_0 -pg 1 -lvl 2 -y 150 -defaultsOSRD
preplace inst processing_system7_0_axi_periph -pg 1 -lvl 6 -y 490 -defaultsOSRD
preplace inst processing_system7_0 -pg 1 -lvl 5 -y 740 -defaultsOSRD
preplace netloc processing_system7_0_DDR 1 5 3 NJ 650 NJ 540 NJ
preplace netloc btint_axi_0_UART_TX 1 7 1 NJ
preplace netloc processing_system7_0_axi_periph_M00_AXI 1 6 1 1700
preplace netloc HostMot2_ip_wrap_0_interrupt 1 2 1 NJ
preplace netloc processing_system7_0_M_AXI_GP0 1 5 1 1380
preplace netloc util_vector_logic_0_Res 1 3 4 720 600 NJ 600 NJ 670 1770
preplace netloc uart_rtl_0_rxd_1 1 6 2 1780 720 NJ
preplace netloc processing_system7_0_FCLK_RESET0_N 1 4 2 930 290 1340
preplace netloc hm2_io_ts_0_i_bits 1 0 8 20 330 NJ 330 NJ 330 NJ 330 NJ 330 NJ 330 NJ 340 2020
preplace netloc btint_axi_1_UART_TX 1 7 1 NJ
preplace netloc HostMot2_ip_wrap_0_ioddrbits 1 2 5 NJ 160 NJ 160 NJ 160 NJ 160 1780
preplace netloc jd2_mad_logic_0_LOG_INS 1 1 1 N
preplace netloc processing_system7_0_axi_periph_M02_AXI 1 6 1 1710
preplace netloc rst_processing_system7_0_100M_peripheral_aresetn 1 5 2 1390 660 1730
preplace netloc HostMot2_ip_wrap_0_outbits 1 2 5 NJ 150 NJ 150 NJ 150 NJ 150 1770
preplace netloc xlconcat_0_dout 1 4 1 NJ
preplace netloc uart_rtl_1_rxd_1 1 6 2 1780 360 NJ
preplace netloc hm2_axilite_int_0_WRITESTB 1 1 7 290 290 NJ 280 NJ 280 NJ 280 NJ 280 NJ 330 2030
preplace netloc hm2_axilite_int_0_READSTB 1 1 7 260 10 NJ 10 NJ 10 NJ 10 NJ 10 NJ 10 2060
preplace netloc processing_system7_0_FIXED_IO 1 5 3 NJ 680 NJ 730 NJ
preplace netloc HostMot2_ip_wrap_0_obus 1 2 5 530 50 NJ 50 NJ 50 NJ 50 NJ
preplace netloc hm2_axilite_int_0_IBUS 1 1 7 250 310 NJ 310 NJ 310 NJ 310 NJ 310 NJ 320 2040
preplace netloc rst_processing_system7_0_100M_interconnect_aresetn 1 5 1 1360
preplace netloc processing_system7_0_FCLK_CLK0 1 0 7 20 160 240 320 NJ 320 NJ 320 920 300 1370 300 1750
preplace netloc hm2_axilite_int_0_ADDR 1 1 7 270 300 NJ 300 NJ 300 NJ 270 NJ 270 NJ 310 2050
preplace netloc Net 1 7 1 NJ
preplace netloc HostMot2_ip_wrap_0_ioodrbits 1 2 5 NJ 180 NJ 180 NJ 180 NJ 180 1760
preplace netloc processing_system7_0_FCLK_CLK1 1 1 5 280 340 NJ 340 NJ 340 NJ 340 1330
preplace netloc processing_system7_0_axi_periph_M01_AXI 1 6 1 1690
levelinfo -pg 1 0 130 410 630 820 1130 1540 1900 2080 -top 0 -bot 880
",
}

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


