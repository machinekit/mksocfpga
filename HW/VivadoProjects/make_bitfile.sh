#!/bin/sh
set -e  # Exit immediately if a command exits with a non-zero status

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

CUR_DIR=`realpath .`
CONFIG_FILE=`realpath $1`

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Config file not found"
    exit 1
fi

PRJ_DIR=`dirname "$CONFIG_FILE"`
IP_DIR=`realpath ../zynq-ip/hm2_ip_wrap`

# Get the project specific environment variables
. "$CONFIG_FILE"

# Delete any old project artifacts folder and remake it
PRJ_DIR_CREATED="$PRJ_DIR"/"$PRJ_NAME"_created
[ -d "$PRJ_DIR_CREATED" ] && rm -r "$PRJ_DIR_CREATED"
mkdir "$PRJ_DIR_CREATED"

## Put pin and firmware info into the sources defining the wrapper IP package
# component file1 needs the pin and firmware file path
sed -e "s|%PIN_FILE%|$PRJ_DIR/$PIN_FILE|" \
    -e "s|%FW_FILE%|"$PRJ_DIR_CREATED"/firmware_id.mif|" \
    "$IP_DIR"/component.xml.in > \
    "$IP_DIR"/component.xml

# VHDL file needs generics filled out. This short circuits having to regen
# IP inside the gui
sed -e "s|%PIN_NAME%|$PIN_NAME|" \
    -e "s|%BOARD_NAME_HIGH_HEX%|$BOARD_NAME_HIGH_HEX|" \
    -e "s|%BOARD_NAME_LOW_HEX%|$BOARD_NAME_LOW_HEX|" \
    "$IP_DIR"/src/hostmot2_ip_wrap.vhd.in > \
    "$IP_DIR"/src/hostmot2_ip_wrap.vhd

PRJ_FILE="$PRJ_DIR_CREATED"/"$PRJ_NAME".tcl
BIT_FILE="$PRJ_NAME".bit

# Update the project creation script from the config
sed -e "s|%PRJ_NAME%|$PRJ_NAME|" \
    -e "s|%FPGA_DEVICE%|$FPGA_DEVICE|" \
    -e "s|%BOARD_PART%|$BOARD_PART|" \
    -e "s|%TOP_LEVEL_BD_FILE%|$TOP_LEVEL_BD_FILE|" \
    -e "s|%BIT_FILE%|$BIT_FILE|" \
    -e "s|%PIN_HW_XDC_FILE%|$PIN_HW_XDC_FILE|" \
    "$PRJ_DIR"/"$TCL_TEMP_FILE" > \
    "$PRJ_FILE"

# Create a dts variant for every input template file a project exposes
if [ -d "$PRJ_DIR"/dts ]; then
    temps=`find "$PRJ_DIR"/dts/ -type f -name *.dts.in`
    for temp in $temps
    do
        outname=`basename "$temp"`
        outfpath="$PRJ_DIR_CREATED"/${outname%_ol.dts.in}_"$FPGA_DEV_SHORT"_ol.dts
        echo $outfpath
        sed "s|%BIT_FILE%|$BIT_FILE.bin|" \
            "$temp" > "$outfpath"
    done
fi

# Create the firmware_id.mif file
cd ../firmware-tag
make py-proto
python genfwid.py "$FWID_NAME" > "$PRJ_DIR_CREATED/firmware_id.mif"
cd ../VivadoProjects

# Run the tcl script to build the project and generate the bitfile
/tools/Xilinx/Vivado/2019.1/bin/vivado -mode batch -source "$PRJ_FILE"

# bootgen: skip mpsoc projects
if test "${1#*"ultra96"}" = "$1" && test "${1#*"fz3"}" = "$1" && test "${1#*"ultramyir"}" = "$1"; then

    # Update the bif file for bootgen
    # component file1 needs the pin file path
    sed "s|%BIT_FILE%|$PRJ_DIR_CREATED/$BIT_FILE|" \
        bif/all.bif.in > \
        bif/all.bif

    # Now use bootgen so we can program it from linux
    /tools/Xilinx/SDK/2019.1/bin/bootgen -image bif/all.bif -w -process_bitstream bin
fi
