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
  set IOBits [ create_bd_port -dir IO -from 35 -to 0 -type data IOBits ]
  set uart0_rxd [ create_bd_port -dir I -type data uart0_rxd ]
  set uart0_txd [ create_bd_port -dir O -type data uart0_txd ]
  set uart1_rxd [ create_bd_port -dir I -type data uart1_rxd ]
  set uart1_txd [ create_bd_port -dir O -type data uart1_txd ]

  # Create instance: HostMot2_ip_wrap_0, and set properties
  set HostMot2_ip_wrap_0 [ create_bd_cell -type ip -vlnv machinekit.io:user:HostMot2_ip_wrap:1.0 HostMot2_ip_wrap_0 ]
  set_property -dict [ list \
CONFIG.IOWidth {36} \
 ] $HostMot2_ip_wrap_0

  # Create instance: btint_axi_0, and set properties
  set btint_axi_0 [ create_bd_cell -type ip -vlnv jd2.com:user:btint_axi:1.0 btint_axi_0 ]

  # Create instance: btint_axi_1, and set properties
  set btint_axi_1 [ create_bd_cell -type ip -vlnv jd2.com:user:btint_axi:1.0 btint_axi_1 ]

  # Create instance: hm2_axilite_int_0, and set properties
  set hm2_axilite_int_0 [ create_bd_cell -type ip -vlnv machinekit.io:user:hm2_axilite_int:1.0 hm2_axilite_int_0 ]

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list \
CONFIG.PCW_CAN0_CAN0_IO {MIO 14 .. 15} \
CONFIG.PCW_CAN0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_ENET0_ENET0_IO {MIO 16 .. 27} \
CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1} \
CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_EN_CLK1_PORT {1} \
CONFIG.PCW_EN_CLK2_PORT {0} \
CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100} \
CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {200} \
CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {200} \
CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {0} \
CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1} \
CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_I2C0_RESET_ENABLE {0} \
CONFIG.PCW_I2C1_I2C1_IO {MIO 12 .. 13} \
CONFIG.PCW_I2C1_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_IRQ_F2P_INTR {1} \
CONFIG.PCW_MIO_0_PULLUP {disabled} \
CONFIG.PCW_MIO_16_SLEW {slow} \
CONFIG.PCW_MIO_17_SLEW {fast} \
CONFIG.PCW_MIO_18_SLEW {fast} \
CONFIG.PCW_MIO_19_SLEW {fast} \
CONFIG.PCW_MIO_20_SLEW {fast} \
CONFIG.PCW_MIO_21_SLEW {fast} \
CONFIG.PCW_MIO_22_SLEW {fast} \
CONFIG.PCW_MIO_23_SLEW {fast} \
CONFIG.PCW_MIO_24_SLEW {fast} \
CONFIG.PCW_MIO_25_SLEW {fast} \
CONFIG.PCW_MIO_26_SLEW {fast} \
CONFIG.PCW_MIO_27_SLEW {fast} \
CONFIG.PCW_MIO_46_PULLUP {disabled} \
CONFIG.PCW_MIO_47_PULLUP {disabled} \
CONFIG.PCW_MIO_50_PULLUP {disabled} \
CONFIG.PCW_MIO_51_PULLUP {disabled} \
CONFIG.PCW_MIO_9_PULLUP {disabled} \
CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V} \
CONFIG.PCW_QSPI_GRP_FBCLK_ENABLE {1} \
CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_SD0_GRP_CD_ENABLE {1} \
CONFIG.PCW_SD0_GRP_CD_IO {MIO 46} \
CONFIG.PCW_SD0_GRP_WP_ENABLE {1} \
CONFIG.PCW_SD0_GRP_WP_IO {MIO 47} \
CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_UART0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_UART0_UART0_IO {MIO 10 .. 11} \
CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {0.271} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {0.259} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2 {0.219} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3 {0.207} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {0.229} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {0.250} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 {0.121} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 {0.146} \
CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41J256M16 RE-125} \
CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE {1} \
CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE {1} \
CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL {1} \
CONFIG.PCW_USB0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_USB0_RESET_ENABLE {1} \
CONFIG.PCW_USB0_RESET_IO {MIO 7} \
CONFIG.PCW_USE_FABRIC_INTERRUPT {1} \
CONFIG.PCW_USE_S_AXI_HP0 {0} \
 ] $processing_system7_0

  # Create instance: processing_system7_0_axi_periph, and set properties
  set processing_system7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 processing_system7_0_axi_periph ]
  set_property -dict [ list \
CONFIG.NUM_MI {3} \
 ] $processing_system7_0_axi_periph

  # Create instance: rst_processing_system7_0_100M, and set properties
  set rst_processing_system7_0_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_processing_system7_0_100M ]

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
CONFIG.NUM_PORTS {1} \
 ] $xlconcat_0

  # Create interface connections
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins processing_system7_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M00_AXI [get_bd_intf_pins btint_axi_0/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M01_AXI [get_bd_intf_pins btint_axi_1/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M02_AXI [get_bd_intf_pins hm2_axilite_int_0/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net processing_system7_1_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_1_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]

  # Create port connections
  connect_bd_net -net HostMot2_ip_wrap_0_interrupt [get_bd_pins HostMot2_ip_wrap_0/interrupt] [get_bd_pins btint_axi_0/sync] [get_bd_pins btint_axi_1/sync] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net HostMot2_ip_wrap_0_obus [get_bd_pins HostMot2_ip_wrap_0/obus] [get_bd_pins hm2_axilite_int_0/OBUS]
  connect_bd_net -net Net [get_bd_ports IOBits] [get_bd_pins HostMot2_ip_wrap_0/iobits]
  connect_bd_net -net btint_axi_0_UART_TX [get_bd_ports uart0_txd] [get_bd_pins btint_axi_0/UART_TX]
  connect_bd_net -net btint_axi_1_UART_TX [get_bd_ports uart1_txd] [get_bd_pins btint_axi_1/UART_TX]
  connect_bd_net -net hm2_axilite_int_0_ADDR [get_bd_pins HostMot2_ip_wrap_0/addr] [get_bd_pins hm2_axilite_int_0/ADDR]
  connect_bd_net -net hm2_axilite_int_0_IBUS [get_bd_pins HostMot2_ip_wrap_0/ibus] [get_bd_pins hm2_axilite_int_0/IBUS]
  connect_bd_net -net hm2_axilite_int_0_READSTB [get_bd_pins HostMot2_ip_wrap_0/readstb] [get_bd_pins hm2_axilite_int_0/READSTB]
  connect_bd_net -net hm2_axilite_int_0_WRITESTB [get_bd_pins HostMot2_ip_wrap_0/writestb] [get_bd_pins hm2_axilite_int_0/WRITESTB]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins HostMot2_ip_wrap_0/clklow] [get_bd_pins HostMot2_ip_wrap_0/clkmed] [get_bd_pins btint_axi_0/S_AXI_ACLK] [get_bd_pins btint_axi_1/S_AXI_ACLK] [get_bd_pins hm2_axilite_int_0/S_AXI_ACLK] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0_axi_periph/ACLK] [get_bd_pins processing_system7_0_axi_periph/M00_ACLK] [get_bd_pins processing_system7_0_axi_periph/M01_ACLK] [get_bd_pins processing_system7_0_axi_periph/M02_ACLK] [get_bd_pins processing_system7_0_axi_periph/S00_ACLK] [get_bd_pins rst_processing_system7_0_100M/slowest_sync_clk]
  connect_bd_net -net processing_system7_0_FCLK_CLK1 [get_bd_pins HostMot2_ip_wrap_0/clkhigh] [get_bd_pins processing_system7_0/FCLK_CLK1]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_processing_system7_0_100M/ext_reset_in]
  connect_bd_net -net rst_processing_system7_0_100M_interconnect_aresetn [get_bd_pins processing_system7_0_axi_periph/ARESETN] [get_bd_pins rst_processing_system7_0_100M/interconnect_aresetn]
  connect_bd_net -net rst_processing_system7_0_100M_peripheral_aresetn [get_bd_pins btint_axi_0/S_AXI_ARESETN] [get_bd_pins btint_axi_1/S_AXI_ARESETN] [get_bd_pins hm2_axilite_int_0/S_AXI_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M00_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M01_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M02_ARESETN] [get_bd_pins processing_system7_0_axi_periph/S00_ARESETN] [get_bd_pins rst_processing_system7_0_100M/peripheral_aresetn]
  connect_bd_net -net uart0_rxd_1 [get_bd_ports uart0_rxd] [get_bd_pins btint_axi_0/UART_RX]
  connect_bd_net -net uart1_rxd_1 [get_bd_ports uart1_rxd] [get_bd_pins btint_axi_1/UART_RX]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins processing_system7_0/IRQ_F2P] [get_bd_pins xlconcat_0/dout]

  # Create address segments
  create_bd_addr_seg -range 0x10000 -offset 0x43C00000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs btint_axi_0/S_AXI/reg0] SEG_btint_axi_0_reg0
  create_bd_addr_seg -range 0x10000 -offset 0x43C10000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs btint_axi_1/S_AXI/reg0] SEG_btint_axi_1_reg0
  create_bd_addr_seg -range 0x10000 -offset 0x43C20000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs hm2_axilite_int_0/S_AXI/reg0] SEG_hm2_axilite_int_0_reg0

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   guistr: "# # String gsaved with Nlview 6.5.5  2015-06-26 bk=1.3371 VDI=38 GEI=35 GUI=JA:1.8
#  -string -flagsOSRD
preplace port DDR -pg 1 -y 360 -defaultsOSRD
preplace port uart0_rxd -pg 1 -y 720 -defaultsOSRD
preplace port uart1_txd -pg 1 -y 740 -defaultsOSRD
preplace port uart1_rxd -pg 1 -y 760 -defaultsOSRD
preplace port FIXED_IO -pg 1 -y 380 -defaultsOSRD
preplace port uart0_txd -pg 1 -y 570 -defaultsOSRD
preplace portBus IOBits -pg 1 -y 120 -defaultsOSRD
preplace inst rst_processing_system7_0_100M -pg 1 -lvl 3 -y 210 -defaultsOSRD
preplace inst xlconcat_0 -pg 1 -lvl 2 -y 470 -defaultsOSRD
preplace inst hm2_axilite_int_0 -pg 1 -lvl 5 -y 270 -defaultsOSRD
preplace inst btint_axi_0 -pg 1 -lvl 5 -y 570 -defaultsOSRD
preplace inst btint_axi_1 -pg 1 -lvl 5 -y 740 -defaultsOSRD
preplace inst HostMot2_ip_wrap_0 -pg 1 -lvl 1 -y 160 -defaultsOSRD
preplace inst processing_system7_0_axi_periph -pg 1 -lvl 4 -y 550 -defaultsOSRD
preplace inst processing_system7_0 -pg 1 -lvl 3 -y 460 -defaultsOSRD
preplace netloc uart0_rxd_1 1 0 5 NJ 720 NJ 720 NJ 730 NJ 730 NJ
preplace netloc btint_axi_0_UART_TX 1 5 1 NJ
preplace netloc processing_system7_0_axi_periph_M00_AXI 1 4 1 N
preplace netloc HostMot2_ip_wrap_0_interrupt 1 1 4 280 420 NJ 720 NJ 720 1290
preplace netloc processing_system7_0_M_AXI_GP0 1 3 1 940
preplace netloc processing_system7_0_FCLK_RESET0_N 1 2 2 500 120 910
preplace netloc btint_axi_1_UART_TX 1 5 1 NJ
preplace netloc uart1_rxd_1 1 0 5 NJ 760 NJ 760 NJ 760 NJ 760 NJ
preplace netloc processing_system7_0_axi_periph_M02_AXI 1 4 1 1250
preplace netloc rst_processing_system7_0_100M_peripheral_aresetn 1 3 2 930 290 1270
preplace netloc xlconcat_0_dout 1 2 1 NJ
preplace netloc hm2_axilite_int_0_WRITESTB 1 0 6 30 300 NJ 300 NJ 90 NJ 90 NJ 90 1550
preplace netloc hm2_axilite_int_0_READSTB 1 0 6 30 30 NJ 30 NJ 30 NJ 30 NJ 30 1560
preplace netloc HostMot2_ip_wrap_0_obus 1 1 4 NJ 80 NJ 80 NJ 80 1300
preplace netloc hm2_axilite_int_0_IBUS 1 0 6 20 290 NJ 290 NJ 300 NJ 300 NJ 350 1540
preplace netloc processing_system7_1_DDR 1 3 3 NJ 360 NJ 360 NJ
preplace netloc rst_processing_system7_0_100M_interconnect_aresetn 1 3 1 950
preplace netloc processing_system7_0_FCLK_CLK0 1 0 5 0 20 NJ 20 490 610 920 710 1300
preplace netloc hm2_axilite_int_0_ADDR 1 0 6 10 10 NJ 10 NJ 10 NJ 10 NJ 10 1570
preplace netloc Net 1 1 5 NJ 110 NJ 110 NJ 110 NJ 110 NJ
preplace netloc processing_system7_1_FIXED_IO 1 3 3 NJ 380 NJ 380 NJ
preplace netloc processing_system7_0_FCLK_CLK1 1 0 4 40 310 NJ 310 NJ 310 900
preplace netloc processing_system7_0_axi_periph_M01_AXI 1 4 1 1260
levelinfo -pg 1 -20 160 380 700 1100 1420 1600 -top 0 -bot 830
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


