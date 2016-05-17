#!/bin/sh

# Builds a bitfile using Vivado. Pass in the config file for the
# project you want to build. Expects Xilinx tools to be installed in
# /opt/Xilinx like the docker image.

usage () {
    echo "Usage: make_bitfile.sh path/to/config"
    exit 1
}

if [ -z "$1" ]; then
    usage
fi

CONFIG_FILE=`realpath $1`

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Config file not found"
    exit 1
fi

PRJ_DIR=`dirname "$CONFIG_FILE"`
IP_DIR=`realpath ../zynq-ip/hm2_ip_wrap`

# Get the project specific environment variables
. "$CONFIG_FILE"

## Put pin info into the sources defining the wrapper IP package
# component file1 needs the pin file path
sed "s|@PIN_FILE@|$PIN_FILE|" \
    "$IP_DIR"/component.xml.in > \
    "$IP_DIR"/component.xml
# VHDL files need correct package name
sed "s|@PIN_NAME@|$PIN_NAME|" \
    "$IP_DIR"/src/hostmot2.vhd.in > \
    "$IP_DIR"/src/hostmot2.vhd
sed -e "s|@PIN_NAME@|$PIN_NAME|" \
    -e "s|@BOARD_NAME_HEX@|$BOARD_NAME_HEX|" \
    "$IP_DIR"/src/hostmot2_ip_wrap.vhd.in > \
    "$IP_DIR"/src/hostmot2_ip_wrap.vhd    
  
# Run the tcl script to build the project and generate the bitfile
/opt/Xilinx/Vivado/2015.4/bin/vivado -mode batch -source "$PRJ_DIR/$BUILD_TCL"

# Update the bif file for bootgen
# component file1 needs the pin file path
sed "s|@BIT_FILE@|$PRJ_DIR/$BIT_FILE|" \
    bif/all.bif.in > \
    bif/all.bif
    
# Now use bootgen so we can program it from linux
/opt/Xilinx/SDK/2015.4/bin/bootgen -image bif/all.bif -w -process_bitstream bin

