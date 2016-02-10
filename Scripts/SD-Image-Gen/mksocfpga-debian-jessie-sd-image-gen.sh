#!/bin/bash

# Working Invokes selected scripts in same folder that generates a working armhf Debian Jessie sd-card-image().img
# for the Terasic De0 Nano / Altera Atlas Soc-Fpga dev board

#TODO:   complete MK depedencies

# 1.initial source: make minimal rootfs on amd64 Debian Jessie, according to "How to create bare minimum Debian Wheezy rootfs from scratch"
# http://olimex.wordpress.com/2014/07/21/how-to-create-bare-minimum-debian-wheezy-rootfs-from-scratch/

#------------------------------------------------------------------------------------------------------
# Variables
#------------------------------------------------------------------------------------------------------
SCRIPT_ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CURRENT_DIR=`pwd`
WORK_DIR=$1

ROOTFS_DIR=${CURRENT_DIR}/rootfs-test
BOOT_FILES_DIR=${CURRENT_DIR}/boot_files
distro=jessie

CHROOT_DIR=$HOME/stretch

#-------------------------------------------
# u-boot, toolchain, imagegen vars
#-------------------------------------------
#set -e      #halt on all errors

# cross toolchain
#--------- altera rt-ltsi socfpga kernel --------------------------------------------------#
ALT_CC_FOLDER_NAME="gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux"
ALT_CC_URL="https://releases.linaro.org/14.09/components/toolchain/binaries/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux.tar.bz2"
ALT_KERNEL_FOLDER_NAME="linux-3.10"

#--------- rt-ltsi patched kernel ---------------------------------------------------------#
#CC_FOLDER_NAME="gcc-linaro-5.2-2015.11-1-x86_64_arm-linux-gnueabihf"
#CC_URL="http://releases.linaro.org/components/toolchain/binaries/latest-5.2/arm-linux-gnueabihf/${CC_FILE}"

#4.1-KERNEL
KERNEL_4115_FOLDER_NAME="linux-4.1.15"
PATCH_4115_FILE="patch-4.1.15-rt17.patch.xz"

#4.4-KERNEL
KERNEL_441_FOLDER_NAME="linux-4.4.1"
PATCH_441_FILE="patch-4.4.1-rt5.patch.xz"

#-------------- all kernel ----------------------------------------------------------------#
# --- config ----------------------------------#
KERNEL_FOLDER_NAME=$ALT_KERNEL_FOLDER_NAME

#----- select toolchain -------------#
# CC_FOLDER_NAME=$RHN_CC_FOLDER_NAME
# CC_URL=$RHN_CC_URL
CC_FOLDER_NAME=$ALT_CC_FOLDER_NAME
#CC_URL=$ALT_CC_URL
# --- config end ------------------------------#

CC_DIR="${CURRENT_DIR}/${CC_FOLDER_NAME}"
CC_FILE="${CC_FOLDER_NAME}.tar.xz"
CC="${CC_DIR}/bin/arm-linux-gnueabihf-"

#--------------  u-boot  ------------------------------------------------------------------#

#UBOOT_VERSION=''
UBOOT_VERSION='v2016.01'
UBOOT_SPLFILE=${CURRENT_DIR}/uboot/u-boot-with-spl-dtb.sfp

IMG_FILE=${CURRENT_DIR}/mksoc_sdcard-test.img
DRIVE=/dev/loop0

KERNEL_BUILD_DIR=${CURRENT_DIR}/arm-linux-${KERNEL_FOLDER_NAME}-gnueabifh-kernel

KERNEL_DIR=${KERNEL_BUILD_DIR}/linux

NCORES=`nproc`

BOOT_MNT=/mnt/boot
ROOTFS_MNT=/mnt/rootfs

#Rhn-rootfs:
ROOTFS_URL='https://rcn-ee.com/rootfs/eewiki/minfs/debian-8.2-minimal-armhf-2015-09-07.tar.xz'
ROOTFS_NAME='debian-8.2-minimal-armhf-2015-09-07'
ROOTFS_FILE=$ROOTFS_NAME'.tar.xz'
RHN_ROOTFS_DIR=$CURRENT_DIR/$ROOTFS_NAME

#-----------------------------------------------------------------------------------
# build files
#-----------------------------------------------------------------------------------

function build_uboot {
$SCRIPT_ROOT_DIR/build_uboot.sh $CURRENT_DIR ##//  $CHROOT_DIR
}

function build_kernel {
$SCRIPT_ROOT_DIR/build_kernel.sh $CURRENT_DIR
}

build_patched_kernel() {
$SCRIPT_ROOT_DIR/build_patched-kernel.sh $CHROOT_DIR
}

function build_rcn_kernel {
cd $CURRENT_DIR
git clone https://github.com/RobertCNelson/armv7-multiplatform
cd armv7-multiplatform/

git checkout origin/v4.4.x -b tmp
./build_kernel.sh
cd ..

}


build_rootfs_into_image() {
$SCRIPT_ROOT_DIR/gen_rootfs.sh $CURRENT_DIR $ROOTFS_DIR $IMG_FILE
}

build_rootfs_into_folder() {
$SCRIPT_ROOT_DIR/gen_rootfs.sh $CURRENT_DIR $ROOTFS_DIR
}

#-----------------------------------------------------------------------------------
# local functions
#-----------------------------------------------------------------------------------

function fetch_extract_rcn_rootfs {
cd $CURRENT_DIR
ROOTFS_DIR=$RHN_ROOTFS_DIR
if [ ! -d ${ROOTFS_DIR} ]; then
    if [ ! -f ${ROOTFS_FILE} ]; then
        echo "downloading rhn rootfs"
        wget -c ${ROOTFS_URL}
        md5sum $ROOTFS_FILE > md5sum.txt
# TODO compare md5sums (406cd5193f4ba6c2694e053961103d1a  debian-8.2-minimal-armhf-2015-09-07.tar.xz)
    fi
# extract footfs-file
    tar xf $ROOTFS_FILE
    echo "extracting rhn rootfs" 
fi
}


kill_ch_proc(){
FOUND=0

for ROOT in /proc/*/root; do
    LINK=$(sudo readlink $ROOT)
    if [ "x$LINK" != "x" ]; then
        if [ "x${LINK:0:${#PREFIX}}" = "x$PREFIX" ]; then
            # this process is in the chroot...
            PID=$(basename $(dirname "$ROOT"))
            sudo kill -9 "$PID"
            FOUND=1
        fi
    fi
done
}

umount_ch_proc(){
COUNT=0

while sudo grep -q "$PREFIX" /proc/mounts; do
    COUNT=$(($COUNT+1))
    if [ $COUNT -ge 20 ]; then
        echo "failed to umount $PREFIX"
        if [ -x /usr/bin/lsof ]; then
            /usr/bin/lsof "$PREFIX"
        fi
        exit 1
    fi
    grep "$PREFIX" /proc/mounts | \
        cut -d\  -f2 | LANG=C sort -r | xargs -r -n 1 sudo umount || sleep 1
done
}


gen_initial_sh() {
echo "------------------------------------------"
echo "generating initial.sh chroot config script"
echo "------------------------------------------"
export DEFGROUPS="sudo,kmem,adm,dialout,machinekit,video,plugdev"
sudo sh -c 'cat <<EOT > '$ROOTFS_MNT'/home/initial.sh
#!/bin/bash

set -x

export DEFGROUPS="sudo,kmem,adm,dialout,machinekit,video,plugdev"
export LANG=C

apt -y update
apt -y upgrade
#apt-get -y install xorg

locale-gen en_US en_US.UTF-8 en_GB en_GB.UTF-8 en_DK en_DK.UTF-8

echo "root:machinekit" | chpasswd

echo "NOTE: " "Will add user machinekit pw: machinekit"
/usr/sbin/useradd -s /bin/bash -d /home/machinekit -m machinekit
echo "machinekit:machinekit" | chpasswd
adduser machinekit sudo
chsh -s /bin/bash machinekit

echo "NOTE: ""User Added"

echo "NOTE: ""Will now add user to groups"
usermod -a -G '$DEFGROUPS' machinekit
sync

systemctl enable systemd-networkd
systemctl enable systemd-resolved

echo "NOTE: ""Will now run apt update, upgrade"
apt -y update
apt -y upgrade
exit
EOT'

sudo chmod +x $ROOTFS_MNT/home/initial.sh
}

function run_initial_sh {
echo "------------------------------------------"
echo "running initial.sh config script in chroot"
echo "------------------------------------------"
DRIVE=`bash -c 'sudo losetup --show -f '$IMG_FILE''`
sudo partprobe $DRIVE

sudo mkdir -p $ROOTFS_MNT
sudo mount ${DRIVE}p2 $ROOTFS_MNT

cd $ROOTFS_MNT # or where you are preparing the chroot dir
sudo mount -t proc proc proc/
sudo mount -t sysfs sys sys/
sudo mount -o bind /dev dev/

gen_initial_sh

sudo chroot $ROOTFS_MNT /bin/bash -c /home/initial.sh
#sudo chroot $ROOTFS_DIR rm /usr/sbin/policy-rc.d
sudo rm $ROOTFS_MNT/usr/sbin/policy-rc.d

cd $CURRENT_DIR
PREFIX=$ROOTFS_MNT
kill_ch_proc
PREFIX=$ROOTFS_MNT
umount_ch_proc

sudo losetup -D
sync

}


function create_image {
$SCRIPT_ROOT_DIR/create_img.sh $CURRENT_DIR $IMG_FILE
}

function install_files {
echo "#-------------------------------------------------------------------------------#"
echo "#-------------------------------------------------------------------------------#"
echo "#-----------------------------          ----------------------------------------#"
echo "#----------------     +++    Installing files         +++ ----------------------#"
echo "#-----------------------------          ----------------------------------------#"
echo "#-------------------------------------------------------------------------------#"
echo "#-------------------------------------------------------------------------------#"

DRIVE=`bash -c 'sudo losetup --show -f '$IMG_FILE''`
sudo partprobe $DRIVE
echo "# --------- installing boot partition files (kernel, dts, dtb) ---------"
sudo mkdir -p $BOOT_MNT
sudo mount -o uid=1000,gid=1000 ${DRIVE}p1 $BOOT_MNT

echo "copying boot sector files"
sudo cp $KERNEL_DIR/arch/arm/boot/zImage $BOOT_MNT

# Quartus files:
if [ -d ${BOOT_FILES_DIR} ]; then
    sudo cp -fv $BOOT_FILES_DIR/socfpga* $BOOT_MNT
else    
    echo "mksocfpga boot files missing"
fi

#sudo cp $KERNEL_DIR/arch/arm/boot/dts/socfpga_cyclone5.dts $BOOT_MNT/socfpga.dts
#sudo cp $KERNEL_DIR/linux/arch/arm/boot/dts/socfpga_cyclone5_de0_sockit.dts $BOOT_MNT/socfpga.dts
#sudo cp $KERNEL_DIR/arch/arm/boot/dts/socfpga_cyclone5.dtb $BOOT_MNT/socfpga.dtb
sudo umount $BOOT_MNT

echo "# --------- installing rootfs partition files (chroot, kernel modules) ---------"
sudo mkdir -p $ROOTFS_MNT
sudo mount ${DRIVE}p2 $ROOTFS_MNT

# Rootfs -------#
#cd $ROOTFS_DIR
#sudo tar cf - . | (sudo tar xvf - -C $ROOTFS_MNT)

#RHN:
sudo tar xfvp $ROOTFS_DIR/armhf-rootfs-*.tar -C $ROOTFS_MNT

# kernel modules -------#
cd $KERNEL_DIR
export PATH=$CC_DIR/bin/:$PATH
#export CROSS_COMPILE=$CC
sudo make ARCH=arm INSTALL_MOD_PATH=$ROOTFS_MNT modules_install
#sudo make -j$NCORES LOADADDR=0x8000 modules_install INSTALL_MOD_PATH=$ROOTFS_MNT
#sudo chroot $ROOTFS_MNT rm /usr/sbin/policy-rc.d

sudo umount $ROOTFS_MNT
sudo losetup -D
sync
}

function install_uboot {
echo "installing u-boot-with-spl"
sudo dd bs=512 if=$UBOOT_SPLFILE of=$IMG_FILE seek=2048 conv=notrunc
sync
}



#------------------.............. run functions section ..................-----------#
echo "#---------------------------------------------------------------------------------- "
echo "#-----------+++     Full Image building process start       +++-------------------- "
echo "#---------------------------------------------------------------------------------- "
set -e

if [ ! -z "$WORK_DIR" ]; then

#build_uboot
build_kernel

##build_rcn_kernel

##build_rootfs_into_folder

create_image
#build_rootfs_into_image

fetch_extract_rcn_rootfs

#run_initial_sh


install_files
install_uboot

echo "#---------------------------------------------------------------------------------- "
echo "#-------             Image building process complete                       -------- "
echo "#---------------------------------------------------------------------------------- "
else
    echo "#---------------------------------------------------------------------------------- "
    echo "#-------------     Unsuccessfull script not run      ------------------------------ "
    echo "#-------------  workdir parameter missing      ------------------------------------ "
    echo "#---------------------------------------------------------------------------------- "
fi


