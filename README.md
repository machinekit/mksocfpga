# mksocfpga
Further development of the Machinekit SocFpga

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

<your repo folder>/mksocfpga/blob/master/Scripts/SD-Image-Gen/mksocfpga-debian-jessie-sd-image-gen.sh anything


