#!/bin/sh

projdirname=HW/QuartusProjects
projects=$(ls ../$projdirname)
folder=DE0_NANO_SOC_GHRD
set -e  # exit on all errors

mkdir -p boot_files
#for folder in $projects

#do
#        tar -zxvf ../QuartusProjects/$folder/sd_fat.tar.gz soc_system.dtb
#        mv soc_system.dtb $folder.dtb
#        tar -zxvf ../QuartusProjects/$folder/sd_fat.tar.gz boot_files/*.rbf
#        mv boot_files/*.rbf boot_files/$folder.rbf
    
        cp -v ../$projdirname/$folder/soc_system.dtb boot_files/socfpga.dtb 
        cp -v ../$projdirname/$folder/soc_system.dts boot_files/socfpga.dts 
        cp -v ../$projdirname/$folder/output_files/soc_system.rbf boot_files/socfpga.rbf
#done


if [ "$1" != "" ]; then
        lsblk
        echo ""
        echo "files will be installed on $1"
        echo ""
        sudo mkdir -p /mnt/boot
        sudo mount -o uid=1000,gid=1000 $1 /mnt/boot
#        sudo cp *.dtb /mnt/boot
        sudo cp -fv boot_files/socfpga* /mnt/boot
#        sudo cp u-boot.scr /mnt/boot
        sync
        sudo umount /mnt/boot
        sync
        echo "operation finished"
else
        lsblk
        echo ""
        echo "! -- not installing files"
        echo "no installation drive given"
        echo "ie: /dev/sdxx"
        echo ""
fi

