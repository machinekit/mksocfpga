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

ROOTFS_DIR=${CURRENT_DIR}/rootfs
distro=jessie

CHROOT_DIR=$HOME/stretch

#-------------------------------------------
# u-boot, toolchain, imagegen vars
#-------------------------------------------
set -e      #halt on all errors

# cross toolchain
CC_DIR="${CURRENT_DIR}/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux"
CC_URL="https://releases.linaro.org/14.09/components/toolchain/binaries/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux.tar.bz2"
CC_FILE="${CC_DIR}.tar.bz2"
CC="${CC_DIR}/bin/arm-linux-gnueabihf-"

#UBOOT_VERSION=''
UBOOT_VERSION='v2016.01'
UBOOT_SPLFILE=${CURRENT_DIR}/uboot/u-boot-with-spl-dtb.sfp

IMG_FILE=${CURRENT_DIR}/mksoc_sdcard.img
DRIVE=/dev/loop0

# 4.15-kernel:
KERNEL_FOLDER_NAME="linux-4.1.15"
KERNEL_DIR=${CHROOT_DIR}/$KERNEL_FOLDER_NAME

#KERNEL_DIR=${CURRENT_DIR}/arm-linux-gnueabifh-kernel/linux

NCORES=`nproc`

BOOT_MNT=/mnt/boot
ROOTFS_MNT=/mnt/rootfs

#Rhn-rootfs:
ROOTFS_URL='https://rcn-ee.com/rootfs/eewiki/minfs/debian-8.2-minimal-armhf-2015-09-07.tar.xz'
ROOTFS_NAME='debian-8.2-minimal-armhf-2015-09-07'
ROOTFS_FILE=$ROOTFS_NAME'.tar.xz'


#-----------------------------------------------------------------------------------
# build files
#-----------------------------------------------------------------------------------

function build_uboot {
$SCRIPT_ROOT_DIR/build_uboot.sh $CRRENT_DIR ##//  $CHROOT_DIR
}

function build_kernel {
$SCRIPT_ROOT_DIR/build_kernel.sh $CURRENT_DIR
}

function build_patched_kernel {
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


function build_chroot_into_image {
$SCRIPT_ROOT_DIR/gen_rootfs.sh $CURRENT_DIR /mnt
}

function build_chroot_into_folder {
$SCRIPT_ROOT_DIR/gen_rootfs.sh $CURRENT_DIR
}

#-----------------------------------------------------------------------------------
# local functions
#-----------------------------------------------------------------------------------


function fetch_rcn_rootfs {
cd $CURRENT_DIR
wget -c $ROOTFS_URL
md5sum $ROOTFS_FILE > md5sum.txt
# TODO compare md5sums (406cd5193f4ba6c2694e053961103d1a  debian-8.2-minimal-armhf-2015-09-07.tar.xz)
tar xf $ROOTFS_FILE
mv  $ROOTFS_NAME $ROOTFS_DIR
}

function gen_initial_sh {
echo "------------------------------------------"
echo "generating initial.sh chroot config script"
echo "------------------------------------------"
export DEFGROUPS="sudo,kmem,adm,dialout,machinekit,video,plugdev"
sudo sh -c 'cat <<EOT > '$ROOTFS_DIR'/home/initial.sh
#!/bin/bash

set -x

export DEFGROUPS="sudo,kmem,adm,dialout,machinekit,video,plugdev"
export LANG=C


sudo apt-get -y update
#sudo apt-get -y upgrade
sudo apt-get -y install xorg

sudo locale-gen

echo "NOTE: " "Will add user machinekit pw: machinekit"
sudo /usr/sbin/useradd -s /bin/bash -d /home/machinekit -m machinekit
sudo bash -c "echo "machinekit:machinekit" | chpasswd"
sudo adduser machinekit sudo
sudo chsh -s /bin/bash machinekit

echo "NOTE: ""User Added"

echo "NOTE: ""Will now add user to groups"
sudo usermod -a -G '$DEFGROUPS' machinekit
sync

echo "NOTE: ""Will now run apt update, upgrade"
sudo apt-get -y update
#sudo apt-get -y upgrade
exit
EOT'

sudo chmod +x $ROOTFS_DIR/home/initial.sh
}

function run_initial_sh {
echo "------------------------------------------"
echo "running initial.sh config script in chroot"
echo "------------------------------------------"
cd $ROOTFS_DIR # or where you are preparing the chroot dir
sudo mount -t proc proc proc/
sudo mount -t sysfs sys sys/
sudo mount -o bind /dev dev/

sudo chroot $ROOTFS_DIR /bin/bash -c /home/initial.sh
#sudo chroot $ROOTFS_DIR rm /usr/sbin/policy-rc.d

sudo umount dev/
sudo umount sys/
sudo umount proc/

}


function create_image {
$SCRIPT_ROOT_DIR/create_img.sh $CURRENT_DIR
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

echo "# --------- installing boot partition files (kernel, dts, dtb) ---------"
sudo mkdir -p $BOOT_MNT
sudo mount -o uid=1000,gid=1000 ${DRIVE}p1 $BOOT_MNT

echo "copying boot sector files"
sudo cp $KERNEL_DIR/arch/arm/boot/zImage $BOOT_MNT
#sudo cp $KERNEL_DIR/arch/arm/boot/dts/socfpga_cyclone5.dts $BOOT_MNT/socfpga.dts
#sudo cp $KERNEL_DIR/linux/arch/arm/boot/dts/socfpga_cyclone5_de0_sockit.dts $BOOT_MNT/socfpga.dts
#sudo cp $KERNEL_DIR/arch/arm/boot/dts/socfpga_cyclone5.dtb $BOOT_MNT/socfpga.dtb
sudo umount $BOOT_MNT

echo "# --------- installing rootfs partition files (chroot, kernel modules) ---------"
sudo mkdir -p $ROOTFS_MNT
sudo mount ${DRIVE}p2 $ROOTFS_MNT

# Rootfs -------#
cd $ROOTFS_DIR
sudo tar cf - . | (sudo tar xvf - -C $ROOTFS_MNT)

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
set -v -e

if [ ! -z "$WORK_DIR" ]; then

#build_uboot
#build_kernel
#build_patched_kernel

##build_rcn_kernel

##build_chroot_into_image
#build_chroot_into_folder

##fetch_rcn_rootfs

#gen_initial_sh
#run_initial_sh


create_image
#install_files
#install_uboot

echo "#---------------------------------------------------------------------------------- "
echo "#-------             Image building process complete                       -------- "
echo "#---------------------------------------------------------------------------------- "
else
    echo "#---------------------------------------------------------------------------------- "
    echo "#-------------     Unsuccessfull script not run      ------------------------------ "
    echo "#-------------  workdir parameter missing      ------------------------------------ "
    echo "#---------------------------------------------------------------------------------- "
fi


