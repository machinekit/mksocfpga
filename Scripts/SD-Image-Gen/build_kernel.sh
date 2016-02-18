#!/bin/bash

#------------------------------------------------------------------------------------------------------
# Variables
#------------------------------------------------------------------------------------------------------
CURRENT_DIR=`pwd`
WORK_DIR=${1}
SCRIPT_ROOT_DIR=${2}
CC_FOLDER_NAME=${3}
CC_URL=${4}
KERNEL_FOLDER_NAME=${5}
KERNEL_URL=${6}
KERNEL_CHKOUT=${7}
KERNEL_FILE_URL=${8}
PATCH_URL=${9}
PATCH_FILE=${10}

echo "NOTE: in build_kernel.sh param = ${8}"

#----------- Git clone URL's ------------------------------------------#
#--------- RHN kernel -------------------------------------------------#
#RHN_KERNEL_URL='https://github.com/RobertCNelson/armv7-multiplatform'
#RHN_KERNEL_CHKOUT='origin/v4.4.x'

##--------- altera socfpga kernel --------------------------------------#
#ALT_KERNEL_URL='https://github.com/altera-opensource/linux-socfpga.git'
#ALT_KERNEL_CHKOUT='linux-rt linux/socfpga-3.10-ltsi-rt'
#ALT_KERNEL_FOLDER_NAME="linux-3.10"

#--------- patched kernels --------------------------------------------#

##4.1-KERNEL
#KERNEL_4115_FOLDER_NAME="linux-4.1.15"
#PATCH_4115_FILE="patch-4.1.15-rt17.patch.xz"

##4.4-KERNEL
#KERNEL_441_FOLDER_NAME="linux-4.4.1"
#PATCH_441_FILE="patch-4.4.1-rt5.patch.xz"

#-----------  Toolchains ----------------------------------------------#
#--------- altera rt-ltsi socfpga kernel ------------------------------#
#ALT_CC_FOLDER_NAME="gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux"
#ALT_CC_URL="https://releases.linaro.org/14.09/components/toolchain/binaries/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux.tar.xz"
#ALT_KERNEL_FOLDER_NAME="linux-3.10"

#----------------------------------------------------------------------#
#--------- patched kernel ---------------------------------------------#
#MAINL_CC_FOLDER_NAME="gcc-linaro-5.2-2015.11-1-x86_64_arm-linux-gnueabihf"
#MAINL_CC_URL="http://releases.linaro.org/components/toolchain/binaries/latest-5.2/arm-linux-gnueabihf/${CC_FILE}"

#-------------- all kernel ----------------------------------------------------------------#

# mksoc uio kernel driver module filder:
MK_KERNEL_DRIVER_FOLDER=$SCRIPT_ROOT_DIR/../../SW/MK/kernel-drivers
UIO_DIR=$MK_KERNEL_DRIVER_FOLDER/hm2reg_uio-module
ADC_DIR=$MK_KERNEL_DRIVER_FOLDER/hm2adc_uio-module

# --- config ----------------------------------#
#----- select mainline kernel -------#
# KERNEL_FILE=${KERNEL_4115_FOLDER_NAME}.tar.xz
# PATCH_FILE=$PATCH_4115_FILE
#KERNEL_FILE=${KERNEL_441_FOLDER_NAME}.tar.xz
#PATCH_FILE=$PATCH_441_FILE
#----- select clone url -------------#
# KERNEL_URL=$RHN_KERNEL_URL
# KERNEL_CHKOUT=$RHN_KERNEL_CHKOUT
#KERNEL_URL=$ALT_KERNEL_URL
#KERNEL_CHKOUT=$ALT_KERNEL_CHKOUT
#--------#
#KERNEL_FOLDER_NAME=$ALT_KERNEL_FOLDER_NAME

#----- select toolchain -------------#
# CC_FOLDER_NAME=$RHN_CC_FOLDER_NAME
# CC_URL=$RHN_CC_URL
#CC_FOLDER_NAME=$ALT_CC_FOLDER_NAME
#CC_URL=$ALT_CC_URL

# --- config end ------------------------------#

#KERNEL_FILE_URL='ftp://ftp.kernel.org/pub/linux/kernel/v4.x/'${KERNEL_FILE}
#PATCH_URL='https://www.kernel.org/pub/linux/kernel/projects/rt/4.4/'${PATCH_FILE}

CC_DIR="${WORK_DIR}/${CC_FOLDER_NAME}"
CC_FILE="${CC_FOLDER_NAME}.tar.xz"
CC="${CC_DIR}/bin/arm-linux-gnueabihf-"

KERNEL_FILE=${KERNEL_FOLDER_NAME}.tar.xz
#PATCH_FILE=$PATCH_441_FILE


KERNEL_CONF='socfpga_defconfig'

#----------------------------------------------------------------------#
#----------------------------------------------------------------------#
#----------------------------------------------------------------------#


IMG_FILE=${WORK_DIR}/mksoc_sdcard.img
DRIVE=/dev/loop0

KERNEL_BUILD_DIR=${WORK_DIR}/arm-linux-${KERNEL_FOLDER_NAME}-gnueabifh-kernel
KERNEL_DIR=${KERNEL_BUILD_DIR}/linux

NCORES=`nproc`

install_dep() {
# install deps for kernel build
sudo apt -y install bc u-boot-tools 
# install linaro gcc 4.9 crosstoolchain dependency:
sudo apt -y install lib32stdc++6

}

extract_toolchain() {
#    if hash lbzip2 2>/dev/null; then
#        echo "lbzip2 found"
#        tar --use=lbzip2 -xf ${CC_FILE}
#    else
#        echo "lbzip2 not found using tar simglecore extract"
        echo "using tar for xz extract"
        tar xf ${CC_FILE}
#    fi
}

get_toolchain() {
# download linaro cross compiler toolchain

if [ ! -d ${CC_DIR} ]; then
    if [ ! -f ${CC_FILE} ]; then
        echo "downloading toolchain"
    	wget -c ${CC_URL}
    fi
# extract linaro cross compiler toolchain
# uses multicore extract (lbzip2) if available
    install_dep
    echo "extracting toolchain" 
    extract_toolchain	
fi
}

clone_kernel() {
    if [ -d ${KERNEL_BUILD_DIR} ]; then
        echo the kernel target directory $KERNEL_BUILD_DIR already exists.
        echo cleaning repo
        cd $KERNEL_BUILD_DIR/linux 
        git clean -d -f -x
        git fetch linux
        git checkout $KERNEL_CHKOUT
    else
        mkdir -p $KERNEL_BUILD_DIR
        cd $KERNEL_BUILD_DIR
        git clone $KERNEL_URL linux
        cd linux 
        git remote add linux $KERNEL_URL
        git fetch linux
        git checkout -b $KERNEL_CHKOUT
#Uio Patch:
#cat <<EOT >> arch/arm/configs/socfpga_defconfig 
#CONFIG_UIO=y
#CONFIG_UIO_PDRV=y
#CONFIG_UIO_PDRV_GENIRQ=y
#EOT
#git add 
#git commit -s -a -m "getting rid of -dirty"

echo "Kernel UIO Patch added"
    fi
    cd ..  
}

fetch_kernel() {
    if [ -d ${KERNEL_BUILD_DIR} ]; then
        echo the kernel target directory $KERNEL_BUILD_DIR already exists.
        echo reinstalling file
        cd $KERNEL_BUILD_DIR 
        echo "deleting kernel folder"
        rm -Rf linux 
    else
        echo "creating ${KERNEL_BUILD_DIR}"
        mkdir -p $KERNEL_BUILD_DIR
        cd $KERNEL_BUILD_DIR
        echo "fetching kernel"
        wget $KERNEL_FILE_URL
        echo "fetching patch"
        wget $PATCH_URL
    fi
    echo "extracting kernel"
    tar xf $KERNEL_FILE
    mv $KERNEL_FOLDER_NAME linux
}

patch_kernel() {
cd $KERNEL_DIR
xzcat ../$PATCH_FILE | patch -p1
}

build_kernel() {

set -v

export CROSS_COMPILE=$CC
cd $KERNEL_DIR

#clean
make -j$NCORES mrproper
# configure
make ARCH=arm $KERNEL_CONF 2>&1 | tee ../linux-config_rt-log.txt
#make $KERNEL_CONF 2>&1 | tee ../linux-config_rt-log.txt

# zImage:
make -j$NCORES ARCH=arm 2>&1 | tee ../linux-make_rt-log_.txt
#make -j$NCORES 2>&1 | tee ../linux-make_rt-log_.txt

# modules:
make -j$NCORES ARCH=arm modules 2>&1 | tee ../linux-modules_rt-log.txt
#make -j$NCORES modules 2>&1 | tee ../linux-modules_rt-log.txt

# uio hm2_mksoc module:
make -j$NCORES ARCH=arm -C $KERNEL_DIR M=$UIO_DIR  modules 2>&1 | tee ../linux-uio-module_rt-log.txt

# uio adc module:
#make -j$NCORES ARCH=arm -C $KERNEL_DIR M=$ADC_DIR  modules 2>&1 | tee ../linux-uio-module_rt-log.txt

}

echo "#---------------------------------------------------------------------------------- "
echo "#-------------------+++        build_kernel.sh Start        +++-------------------- "
echo "#---------------------------------------------------------------------------------- "

set -e -x

if [ ! -z "$WORK_DIR" ]; then
install_dep
echo "fetching / extracting toolchain"
get_toolchain
echo "Downloading / extracting kernel"
fetch_kernel
    echo "Applying patch"
    patch_kernel
#echo "cloning kernel"
#clone_kernel
echo "building kernel"
build_kernel
echo "#---------------------------------------------------------------------------------- "
echo "#--------+++       build_kernel.sh Finished Successfull      +++------------------- "
echo "#---------------------------------------------------------------------------------- "

else
    echo "#---------------------------------------------------------------------------------- "
    echo "#-------------    build_kernel.sh  Unsuccessfull     ------------------------------ "
    echo "#-------------    workdir parameter missing    ------------------------------------ "
    echo "#---------------------------------------------------------------------------------- "
fi


