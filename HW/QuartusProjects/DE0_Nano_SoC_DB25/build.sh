#!/bin/bash

# This script builds various PIN configurations targeting this board
# Usage:
#     ./build.sh [config [config]]
#
# If you want to build a particular configuration, specify it on the
# command line, otherwise the default is to build all configurations
#
# This is a batch file because each configuration needs to be built
# sequentially for two reasons:
#
#   1} The hostmot_cfg.vhd file needs to be customized for each config
#
#   2} You cannot run multiple Quartus builds in the same directory
#      simultaniously or BadThings happen
#
# Should the build process ever migrate to running each Quartus build
# in it's own Docker container, each of those containers could have
# their own local build directory and run simultaniously.

# Some specifics for this build, adjust as necessary

BOARDNAME=DE0_Nano_SoC_DB25
OUTPUTDIR=output_files

# You probably don't have to change anything below unless you alter
# the directory structure and naming convention

# Exit if any commands fail
set -e

# Path to the configuration files
CONFIG_DIR="../../hm2/config/${BOARDNAME}"


# Routine to build a specific configuration
build_config() {
    echo "Building configuration $1"

    # Create customized hostmot2_cfg.vhd file
    # Use sed because the C pre-processor only allows identifiers to be #define'd
    # which means in rare instances it could match actual VHDL code.  Here we use
    # the % character to support a batch-style variable scheme
    sed "s/%CONFIG%/${1}/g" <hostmot2_cfg.vhd.in > hostmot2_cfg.vhd


    # generate the MIF file containing the FirmwareID protobuf message
    python ../../firmware-tag/genfwid.py $1 >firmware_id.mif

    # Actually build the FPGA bit file
    make rbf

    # Rename the resulting bit file to <board>.<config>.rbf
    mv "${OUTPUTDIR}/${BOARDNAME}.rbf" "${OUTPUTDIR}/${BOARDNAME}.${1}.rbf"

    # Move the *.sof file as well
    mv "${OUTPUTDIR}/${BOARDNAME}.sof" "${OUTPUTDIR}/${BOARDNAME}.${1}.sof"
}


# If we were passed specific configurations to build, just build those
if [ -n "$1" ] ; then
    CONFIG_NAMES="$*"

# No configuration(s) specified, so let's find and build them all...
else
    # List of all configuration vhd files for this board
    CONFIG_VHD="${CONFIG_DIR}/PIN_*.vhd"

    # Strip off the directory portion, leaving just the filename
    CONFIG_FILES=""
    for CONFIG in ${CONFIG_VHD} ; do
        CONFIG_FILES="${CONFIG_FILES} $(basename ${CONFIG})"
    done

    # Remove PIN_ and .vhd, leaving just the configuration name
    CONFIG_NAMES=""
    for CONFIG in ${CONFIG_FILES} ; do
        CONFIG=${CONFIG%.vhd}
        CONFIG=${CONFIG#PIN_}
        CONFIG_NAMES="${CONFIG_NAMES} ${CONFIG}"
    done
fi

# Now we have a space separated list of configs, time to start building

# Cleanup all stamp files to trigger a full rebuild
# Including processing the qsys files into synthesizable code
make clean

# Build each configuration, one at a time
for CONFIG in ${CONFIG_NAMES} ; do
    # Cleanup Quartus stamp file to trigger a build of the bitfile
    # Leave the other stamp files (for qsys and pin assignments) since
    # those only need to be built once per board, not for each PIN config
    rm stamp/quartus.stamp || true

    # Build the current configuration
    FILE="${CONFIG_DIR}/PIN_${CONFIG}.vhd"
    if [ -r "${FILE}" ] ; then
        build_config ${CONFIG}
    else
        echo "Unknown configuration ${CONFIG}!"
        echo "Try one of:"
        ls -1 ${CONFIG_DIR}/PIN_*.vhd | sed 's/^.*PIN_//;s/\.vhd//'
        exit 1
    fi
done

