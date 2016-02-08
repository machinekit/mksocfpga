#!/bin/bash

# Create, partition and mount SD-Card image:
#------------------------------------------------------------------------------------------------------
# Variables
#------------------------------------------------------------------------------------------------------
CURRENT_DIR=`pwd`
WORK_DIR=$1

SD_IMG=${WORK_DIR}/mksoc_sdcard.img
ROOTFS_IMG=${WORK_DIR}/rootfs.img
DRIVE=/dev/loop0

function create_sdcard_img {
#--------------- Initial sd-card image - partitioned --------------
echo "#-------------------------------------------------------------------------------#"
echo "#-----------------------------          ----------------------------------------#"
echo "#---------------     +++ generating sd-card image  zzz  +++ ........  ----------#"
echo "#---------------------------  Please  wait   -----------------------------------#"
echo "#-------------------------------------------------------------------------------#"
sudo dd if=/dev/zero of=$SD_IMG  bs=1024 count=3700K

sudo losetup --show -f $SD_IMG
sudo fdisk /dev/loop0 << EOF
n
p
3

+1M
t
a2
n
p
2

+3600M
n
p
1


t
1
b
w
EOF

sudo partprobe $DRIVE

echo "creating file systems"

sudo mkfs.vfat -F 32 -n "BOOT" ${DRIVE}p1
sudo mke2fs -j -L "rootfs" ${DRIVE}p2

sync
sudo partprobe $DRIVE
sync
sudo losetup -D
sync
}

function create_rootfs_img {
echo "#-------------------------------------------------------------------------------#"
echo "#-----------------------------          ----------------------------------------#"
echo "#----------------     +++ generating rootfs image  zzz  +++ ........  ----------#"
echo "#-----------------------------   wait   ----------------------------------------#"
echo "#-------------------------------------------------------------------------------#"
sudo dd if=/dev/zero of=$ROOTFS_IMG  bs=1024 count=3600K
sudo mke2fs -j -L "rootfs" $ROOTFS_IMG
}

if [ ! -z "$WORK_DIR" ]; then
    if [ -f ${SD_IMG} ]; then
        echo "Deleting old imagefile"
        rm -f $SD_IMG
    fi
    if [ -f ${ROOTFS_IMG} ]; then
        echo "Deleting old imagefile"
        rm -f $ROOTFS_IMG
    fi
#create_rootfs_img 
create_sdcard_img

echo "#---------------------------------------------------------------------------------- "
echo "#-------------  create_img.sh Finished with Success  ------------------------------ "
echo "#---------------------------------------------------------------------------------- "

else
    echo "#---------------------------------------------------------------------------------- "
    echo "#----------------  create_img.sh Ended Unsuccessfully    -------------------------- "
    echo "#-------------  workdir parameter missing     ------------------------------------- "
    echo "#---------------------------------------------------------------------------------- "
fi


