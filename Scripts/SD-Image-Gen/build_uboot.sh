#!/bin/bash

# Script to build u-boot + preloader for Altera Soc Platform (Only Nano / Atlas board initially)
# usage: build_uboot.sh <builddir path>
#------------------------------------------------------------------------------------------------------
# Variables
#------------------------------------------------------------------------------------------------------
CURRENT_DIR=`pwd`
WORK_DIR=${1}

SCRIPT_ROOT_DIR=${2}
UBOOT_VERSION=${3}

#UBOOT_VERSION='v2015.10'
#UBOOT_VERSION='v2016.01'
CHKOUT_OPTIONS=''
#CHKOUT_OPTIONS='-b tmp'

BOARD_CONFIG='socfpga_de0_nano_soc_defconfig'
MAKE_CONFIG='u-boot-with-spl-dtb.sfp'

UBOOT_SPLFILE=${UBOOT_DIR}/u-boot-with-spl-dtb.sfp

PATCH_FILE="u-boot-${UBOOT_VERSION}-changes.patch"

UBOOT_DIR=${WORK_DIR}/uboot

#-------------------------------------------
# u-boot, toolchain, imagegen vars
#-------------------------------------------
#--------- altera socfpga kernel --------------------------------------#
CC_FOLDER_NAME="gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux"
#CC_DIR="${WORK_DIR}/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux"
#CC_FILE="${CC_DIR}.tar.bz2"
CC_URL="https://releases.linaro.org/14.09/components/toolchain/binaries/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux.tar.xz"

#--------- patched kernel ---------------------------------------------#
#CC_FOLDER_NAME="gcc-linaro-5.2-2015.11-1-x86_64_arm-linux-gnueabihf"

CC_DIR="${WORK_DIR}/${CC_FOLDER_NAME}"
CC_FILE="${CC_FOLDER_NAME}.tar.xz"
#CC_URL="http://releases.linaro.org/components/toolchain/binaries/latest-5.2/arm-linux-gnueabihf/${CC_FILE}"

#----------------------------------------------------------------------#

CC="${CC_DIR}/bin/arm-linux-gnueabihf-"


NCORES=`nproc`

install_dep() {
# install deps for u-boot build
sudo apt -y install  device-tree-compiler bc u-boot-tools 
# install linaro gcc 4.9 crosstoolchain dependency:
sudo apt -y install lib32stdc++6

}

extract_toolchain() {
    echo "using tar for xz extract"
    tar xf ${CC_FILE}
}


get_toolchain() {
# download linaro cross compiler toolchain

if [ ! -d ${CC_DIR} ]; then
    if [ ! -f ${CC_FILE} ]; then
        echo "downloading toolchain"
    	wget -c ${CC_URL}
    fi
# extract linaro cross compiler toolchain
# uses multicore extract (lbzip2) if available(set via links in /usr/sbin)
    echo "extracting toolchain" 
    extract_toolchain
fi
}

patch_uboot() {
cd $UBOOT_DIR
git am --signoff <  $SCRIPT_ROOT_DIR/$PATCH_FILE
}

fetch_uboot() {
if [ ! -d ${UBOOT_DIR} ]; then
    echo "cloning u-boot"
    git clone git://git.denx.de/u-boot.git uboot
    install_dep
fi

cd $UBOOT_DIR
if [ ! -z "$UBOOT_VERSION" ]
then
    git fetch origin
    git reset --hard origin/master
    echo "Will now check out " $UBOOT_VERSION
    git checkout $UBOOT_VERSION $CHKOUT_OPTIONS
    echo "Will now apply patch: " $SCRIPT_ROOT_DIR/$PATCH_FILE
    patch_uboot
fi
cd ..
}

install_sid_armhf_crosstoolchain() {
sudo dpkg --add-architecture armhf
sudo apt-get update

#sudo apt-get install crossbuild-essential-armhf
#sudo apt-get install gcc-arm-linux-gnueabihf

sudo apt-get install gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf libc6-dev debconf dpkg-dev libconfig-auto-perl file libfile-homedir-perl libfile-temp-perl liblocale-gettext-perl perl binutils-multiarch fakeroot

}

build_uboot() {
cd $UBOOT_DIR
# compile u-boot + spl
export ARCH=arm
export PATH=$CC_DIR/bin/:$PATH
export CROSS_COMPILE=$CC

echo "compiling u-boot"
make mrproper
make $BOARD_CONFIG
make $MAKE_CONFIG -j$NCORES
}

# run functions
echo "#---------------------------------------------------------------------------------- "
echo "#-------------+++      build_uboot.sh Start      +++------------------------------- "
echo "#---------------------------------------------------------------------------------- "

set -e

if [ ! -z "$WORK_DIR" ]; then
    cd $WORK_DIR
    get_toolchain
    fetch_uboot
    
    build_uboot
else
    echo "no workdir parameter given"
    echo "usage: build_uboot.sh <builddir path>"
fi
echo "#---------------------------------------------------------------------------------- "
echo "#-------------+++      build_uboot.sh End      +++--------------------------------- "
echo "#---------------------------------------------------------------------------------- "


