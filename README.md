# mksocfpga
Further development of the Machinekit SocFpga

Update(19 feb-2016)

Partition layout changed: rootfs -->p3 (this should make downloaded images easiely expandable)

fpga config on boot patched onto u-boot.

Enable uio driver patched onto kernel config.

Kernel changed to mainline 4.4.1-rt with rt ltsi patch 4.4.1-rc6

TODO: fix network ipv4 access (via systemd upgrade...)

u-boot compiles with 4.9 and 5.2 gcc (linaro x86_64 cross + ?)

4.4.1 kernel builds with gcc 5.2     (linaro x86_64 cross + ?)

rootfs has native armhf gcc 4.9

No manual u-boot env changes needed

SD-Cross-Build scripts split into Debian Jessie and Stretch edition 

---

update(14-feb-2014)

Fully bootable sd-image (MK-Rip-built) (3.10-rt-ltsi kernel from Altera socfpga repo)

Remember usb serial console 115200 8n1 on first boot.
3 - sek > press kay and:

https://github.com/the-snowwhite/mksocfpga/blob/master/docs/set-uboot-env.md

Msel (SW10):

 010101  

(123456)

https://drive.google.com/file/d/0BwyLvgyVIdi8QTRjVGZDbk1OZGs/view?usp=sharing

https://drive.google.com/file/d/0BwyLvgyVIdi8amE3ZW1fLUxld2s/view?usp=sharing

---

username machinekit
Pw: machinekit

To set localtimezone:

    sudo dpkg-reconfigure tzdata

    
---
    
    

DE0-Nano Quartus project fully functional.

    Initial hal hostmot2 module drivers to be tested with custom uio driver module online:

    
https://github.com/the-snowwhite/machinekit/tree/mksoc/src

Quickstart test quide:

1   mksoc --> mksocfpga   !!!  (use the new  repo)

2. in a new repo folder do: git clone https://github.com/the-snowwhite/mksocfpga.git

3. then create and cd to a different new folder (your work folder).

4.a extract the rootfs sd image into the work folder. links:
https://drive.google.com/file/d/0BwyLvgyVIdi8cjM3MlYyWG9xY1E/view?usp=sharing
https://drive.google.com/file/d/0BwyLvgyVIdi8TkI5NHNBQlhnSms/view?usp=sharing


4.b copy the folder boot_files from repo to work folder (contains valid out_put from quartus ... no need to run quartus makefile)

4.c copy folder hm2reg_uio-module (from SW/MK/kernel-drivers) to work folder.

4.d Note: you will neeed to copy the socfpga_defconfig into the (correct) arm/config folder overwriting the default one to enable uio-driver after the script has cloned the kernel repo on first run(with warnings). (needs patch fix...!)

5. edit this script in your local mksocfpga repo folder:
 https://github.com/the-snowwhite/mksocfpga/blob/master/Scripts/SD-Image-Gen/mksocfpga-debian-jessie-sd-image-gen.sh#L333

as so(near bottom):

    if [ ! -z "$WORK_DIR" ]; then

    build_uboot
    build_kernel

    ##build_rcn_kernel

    ##build_rootfs_into_folder

    #create_image
    #build_rootfs_into_image

    #fetch_extract_rcn_rootfs

    #run_initial_sh


    install_files
    install_uboot

    echo "#---------------------------------------------------------------------------------- "
    echo "#-------             Image building process complete                       -------- "


keep cd in your work folder and call the script like this:

"your repo folder"/mksocfpga/Scripts/SD-Image-Gen/mksocfpga-debian-jessie-sd-image-gen.sh anything

NOTE:
Remember on your first boot to have yout usbserial terminal connected and press space (or any key) within 3 sek,
then paste 1 and 3 into the console from here:
https://github.com/the-snowwhite/mksocfpga/blob/master/docs/set-uboot-env.md

