#!/bin/bash

# Working Invokes selected scripts in same folder that generates a working armhf Debian Jessie sd-card-image().img
# for the Terasic De0 Nano / Altera Atlas Soc-Fpga dev board

#TODO:   complete MK depedencies

# 1.initial source: make minimal rootfs on amd64 Debian Jessie, according to "How to create bare minimum Debian Wheezy rootfs from scratch"
# http://olimex.wordpress.com/2014/07/21/how-to-create-bare-minimum-debian-wheezy-rootfs-from-scratch/

#------------------------------------------------------------------------------------------------------
# Variables Prerequsites
#------------------------------------------------------------------------------------------------------
SCRIPT_ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CURRENT_DIR=`pwd`
WORK_DIR=$1

ROOTFS_DIR=${CURRENT_DIR}/rootfs
MK_KERNEL_DRIVER_FOLDER=$SCRIPT_ROOT_DIR/../../SW/MK/kernel-drivers

BOOT_FILES_DIR=$SCRIPT_ROOT_DIR/../boot_files

#------------------------------------------------------------------------------------------------------
# Variables Custom settings
#------------------------------------------------------------------------------------------------------

#IMG_FILE=${CURRENT_DIR}/mksoc_sdcard-test.img
IMG_FILE=${CURRENT_DIR}/mksocfpga_sdcard.img
## Expandable image
IMG_BOOT_PART=p2
IMG_ROOT_PART=p3

## Old Inverted image
#IMG_BOOT_PART=p1
#IMG_ROOT_PART=p2

UBOOT_VERSION="v2016.01"


distro=stretch

#CHROOT_DIR=$HOME/stretch

#-------------------------------------------
# u-boot, toolchain, imagegen vars
#-------------------------------------------
#set -e      #halt on all errors
#--------------  u-boot  ------------------------------------------------------------------#

UBOOT_SPLFILE=${CURRENT_DIR}/uboot/u-boot-with-spl-dtb.sfp

#----------- Git kernel clone URL's -----------------------------------#
#--------- RHN kernel -------------------------------------------------#
#RHN_KERNEL_URL='https://github.com/RobertCNelson/armv7-multiplatform'
#RHN_KERNEL_CHKOUT='origin/v4.4.x'

##--------- altera socfpga kernel --------------------------------------#
ALT_KERNEL_URL="https://github.com/altera-opensource/linux-socfpga.git"
#ALT_KERNEL_CHKOUT='linux-rt linux/socfpga-3.10-ltsi-rt'
ALT_KERNEL_CHKOUT="linux/socfpga-3.10-ltsi-rt"

# cross toolchain
#--------- altera rt-ltsi socfpga kernel --------------------------------------------------#
#ALT_CC_FOLDER_NAME="gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux"
#ALT_CC_URL="https://releases.linaro.org/14.09/components/toolchain/binaries/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux.tar.xz"
#ALT_KERNEL_FOLDER_NAME="linux-3.10"

#--------- rt-ltsi patched kernel ---------------------------------------------------------#
PCH_CC_FOLDER_NAME="gcc-linaro-5.2-2015.11-1-x86_64_arm-linux-gnueabihf"
#PCH_CC_URL="http://releases.linaro.org/components/toolchain/binaries/latest-5.2/arm-linux-gnueabihf/${CC_FILE}"
PCH_CC_FILE="${PCH_CC_FOLDER_NAME}.tar.xz"
PCH_CC_URL="http://releases.linaro.org/components/toolchain/binaries/5.2-2015.11-1/arm-linux-gnueabihf/${PCH_CC_FILE}"
#http://releases.linaro.org/components/toolchain/binaries/5.2-2015.11-1/arm-linux-gnueabihf/gcc-linaro-5.2-2015.11-1-x86_64_arm-linux-gnueabihf.tar.xz

#4.4-KERNEL
KERNEL_44_FOLDER_NAME="linux-4.4.3"
PATCH_44_FILE="patch-4.4.3-rt9.patch.gz"

#-------------- all kernel ----------------------------------------------------------------#
# mksoc uio kernel driver module filder:
UIO_DIR=$MK_KERNEL_DRIVER_FOLDER/hm2reg_uio-module
ADC_DIR=$MK_KERNEL_DRIVER_FOLDER/hm2adc_uio-module

# --- config ----------------------------------#
#KERNEL_FOLDER_NAME=$ALT_KERNEL_FOLDER_NAME
KERNEL_URL=$ALT_KERNEL_URL
KERNEL_CHKOUT=$ALT_KERNEL_CHKOUT

#----- select toolchain -------------#
# CC_FOLDER_NAME=$RHN_CC_FOLDER_NAME
# CC_URL=$RHN_CC_URL
#CC_FOLDER_NAME=$ALT_CC_FOLDER_NAME
#CC_URL=$ALT_CC_URL
CC_FOLDER_NAME=$PCH_CC_FOLDER_NAME
#CC_URL=$PCH_CC_URL
# --- config end ------------------------------#
KERNEL_FOLDER_NAME=$KERNEL_44_FOLDER_NAME
KERNEL_FILE=${KERNEL_FOLDER_NAME}.tar.xz
PATCH_FILE=$PATCH_44_FILE

# --- config end ------------------------------#

CC_DIR="${CURRENT_DIR}/${CC_FOLDER_NAME}"
CC_FILE="${CC_FOLDER_NAME}.tar.xz"
CC="${CC_DIR}/bin/arm-linux-gnueabihf-"

CC_URL=$PCH_CC_URL

KERNEL_FILE_URL="ftp://ftp.kernel.org/pub/linux/kernel/v4.x/${KERNEL_FILE}"
PATCH_URL='https://www.kernel.org/pub/linux/kernel/projects/rt/4.4/'${PATCH_FILE}


KERNEL_BUILD_DIR=${CURRENT_DIR}/arm-linux-${KERNEL_FOLDER_NAME}-gnueabifh-kernel

KERNEL_DIR=${KERNEL_BUILD_DIR}/linux

NCORES=`nproc`

BOOT_MNT=/mnt/boot
ROOTFS_MNT=/mnt/rootfs

#Rhn-rootfs:
#ROOTFS_URL='https://rcn-ee.com/rootfs/eewiki/minfs/debian-8.2-minimal-armhf-2015-09-07.tar.xz'
#ROOTFS_NAME='debian-8.2-minimal-armhf-2015-09-07'
#ROOTFS_FILE=$ROOTFS_NAME'.tar.xz'
#RHN_ROOTFS_DIR=$CURRENT_DIR/$ROOTFS_NAME

#-----------------------------------------------------------------------------------
# build files
#-----------------------------------------------------------------------------------

function build_uboot {
$SCRIPT_ROOT_DIR/build_uboot.sh $CURRENT_DIR $SCRIPT_ROOT_DIR $UBOOT_VERSION
}

function build_kernel {
$SCRIPT_ROOT_DIR/build_kernel.sh $CURRENT_DIR $SCRIPT_ROOT_DIR $CC_FOLDER_NAME $CC_URL $KERNEL_FOLDER_NAME $KERNEL_URL $KERNEL_CHKOUT $KERNEL_FILE_URL $PATCH_URL $PATCH_FILE
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


compress_rootfs(){
DRIVE=`bash -c 'sudo losetup --show -f '$IMG_FILE''`
sudo partprobe $DRIVE

sudo mkdir -p $ROOTFS_MNT
sudo mount ${DRIVE}$IMG_ROOT_PART $ROOTFS_MNT

echo "Rootfs configured ... compressing ...."
cd $ROOTFS_MNT
sudo tar -cjSf $CURRENT_DIR/$COMPNAME--rootfs.tar.bz2 *

cd $CURRENT_DIR
echo "${COMPNAME} rootfs compressed finish ... unmounting"

sudo umount -R $ROOTFS_MNT
sudo losetup -D
}

build_rootfs_in_image_and_compress() {
$SCRIPT_ROOT_DIR/gen_rootfs-stretch.sh $CURRENT_DIR $ROOTFS_DIR $IMG_FILE $IMG_ROOT_PART
COMPNAME=raw
compress_rootfs
}

build_rootfs_into_folder() {
$SCRIPT_ROOT_DIR/gen_rootfs.sh $CURRENT_DIR $ROOTFS_DIR
}

function create_image {
$SCRIPT_ROOT_DIR/create_img.sh $CURRENT_DIR $IMG_FILE
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
sudo sh -c 'cat <<EOF > '$ROOTFS_MNT'/home/initial.sh
#!/bin/bash

set -x

export DEFGROUPS="sudo,kmem,adm,dialout,machinekit,video,plugdev"
export LANG=C

apt -y update
apt -y upgrade

#sudo apt-get -y install resolvconf apt-utils ssh ntpdate openssl nano locales
#apt -y install xorg

#locale-gen en_GB.UTF-8 en_US.UTF-8 en_DK.UTF-8

echo "root:machinekit" | chpasswd

echo "ECHO: " "Will add user machinekit pw: machinekit"
/usr/sbin/useradd -s /bin/bash -d /home/machinekit -m machinekit
echo "machinekit:machinekit" | chpasswd
adduser machinekit sudo
chsh -s /bin/bash machinekit

echo "ECHO: ""User Added"

echo "ECHO: ""Will now add user to groups"
usermod -a -G '$DEFGROUPS' machinekit
sync

cat <<EOT >> /home/machinekit/.bashrc

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
EOT


#systemctl enable systemd-resolved
#systemctl enable systemd-networkd

rm -f /etc/resolv.conf
ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf


echo "ECHO: ""Will now run apt update, upgrade"
apt -y update
apt -y upgrade
exit
EOF'

sudo chmod +x $ROOTFS_MNT/home/initial.sh
}

fix_profile(){
sudo sh -c 'cat <<EOF > '$ROOTFS_MNT'/home/fix-profile.sh
#!/bin/bash

cat <<EOT >> /home/machinekit/.profile

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
EOT

exit
EOF'
sudo chmod +x $ROOTFS_MNT/home/fix-profile.sh

sudo chroot $ROOTFS_MNT chown machinekit:machinekit /home/fix-profile.sh
sudo chroot $ROOTFS_MNT /bin/su -l machinekit /bin/sh -c /home/fix-profile.sh
sudo chroot $ROOTFS_MNT /bin/su -l root /usr/sbin/locale-gen en_GB.UTF-8 en_US.UTF-8
}

function run_initial_sh {
echo "------------------------------------------"
echo "----  running initial.sh      ------------"
echo "------------------------------------------"
DRIVE=`bash -c 'sudo losetup --show -f '$IMG_FILE''`
sudo partprobe $DRIVE

sudo mkdir -p $ROOTFS_MNT
sudo mount ${DRIVE}$IMG_ROOT_PART $ROOTFS_MNT

## extract raw-rootfs into image:
sudo tar xvfj $CURRENT_DIR/raw--rootfs.tar.bz2 -C $ROOTFS_MNT


cd $ROOTFS_MNT # or where you are preparing the chroot dir
sudo mount -t proc proc proc/
sudo mount -t sysfs sys sys/
sudo mount -o bind /dev dev/

gen_initial_sh
echo "ECHO: gen_initial.sh finhed ... will now run in chroot"

sudo chroot $ROOTFS_MNT /bin/bash -c /home/initial.sh
#sudo chroot $ROOTFS_DIR rm /usr/sbin/policy-rc.d
echo "will fix profile locale"
fix_profile
echo "profile locale fixed ... unmounting .."

cd $CURRENT_DIR
PREFIX=$ROOTFS_MNT
kill_ch_proc

PREFIX=$ROOTFS_MNT
umount_ch_proc
#sudo umount -R $ROOTFS_MNT
#sudo losetup -D
sync

COMPNAME=final
compress_rootfs
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
sudo mount -o uid=1000,gid=1000 ${DRIVE}$IMG_BOOT_PART $BOOT_MNT

echo "copying boot sector files"
sudo cp $KERNEL_DIR/arch/arm/boot/zImage $BOOT_MNT

## Quartus files:
# if [ -d ${BOOT_FILES_DIR} ]; then
#     sudo cp -fv $BOOT_FILES_DIR/socfpga* $BOOT_MNT
# else    
#     echo "mksocfpga boot files missing"
# fi

sudo cp -v $KERNEL_DIR/arch/arm/boot/dts/socfpga_cyclone5_de0_sockit.dts $BOOT_MNT/socfpga.dts
sudo cp -v $KERNEL_DIR/arch/arm/boot/dts/socfpga_cyclone5_de0_sockit.dtb $BOOT_MNT/socfpga.dtb
sudo cp -v $BOOT_FILES_DIR/socfpga.rbf $BOOT_MNT/socfpga.rbf
sudo umount $BOOT_MNT

echo "# --------- installing rootfs partition files (chroot, kernel modules) ---------"
sudo mkdir -p $ROOTFS_MNT
sudo mount ${DRIVE}$IMG_ROOT_PART $ROOTFS_MNT

# Rootfs -------#
sudo tar xvfj $CURRENT_DIR/final--rootfs.tar.bz2 -C $ROOTFS_MNT

#cd $ROOTFS_DIR
#sudo tar cf - . | (sudo tar xvf - -C $ROOTFS_MNT)

#RHN:
#sudo tar xfvp $ROOTFS_DIR/armhf-rootfs-*.tar -C $ROOTFS_MNT

# kernel modules -------#
cd $KERNEL_DIR
export PATH=$CC_DIR/bin/:$PATH
export CROSS_COMPILE=$CC
sudo make ARCH=arm INSTALL_MOD_PATH=$ROOTFS_MNT modules_install
sudo make ARCH=arm -C $KERNEL_DIR M=$UIO_DIR INSTALL_MOD_PATH=$ROOTFS_MNT modules_install
#sudo make ARCH=arm -C $KERNEL_DIR M=$ADC_DIR INSTALL_MOD_PATH=$ROOTFS_MNT modules_install

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
#build_kernel

##build_rcn_kernel

##build_rootfs_into_folder

create_image

build_rootfs_in_image_and_compress

##fetch_extract_rcn_rootfs

create_image

run_initial_sh


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


