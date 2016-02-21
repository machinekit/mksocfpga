Stretch: (Qemu 2.5)
Qemu-debootstrap works with the --include=<your-specified comma seperated .deb packages> that then also will configure the packages.


NOTE:  this workaround has beem applied to the stretch rootfs gen script 21 feb 2016.


However the debootstrap file contains an -e at the very top, making it grind to a halt midways with following message:

    I: Running command: chroot /mnt/rootfs /debootstrap/debootstrap --second-stage
    I: Keyring file not available at /usr/share/keyrings/debian-archive-keyring.gpg; switching to https mirror https://mirrors.kernel.org/debian


    
Open a separete konsole window and change the -e to: -x or -v (in nano)


    sudo nano /mnt/rootfs/debootstrap/debootstrap

ctrl-x --> y    
    

then continue the script with:
    
    sudo chroot /mnt/rootfs /debootstrap/debootstrap --second-stage                          


Afterwards you need to unmount the image completely (option: use "lsblk" command to view the mounts):

    sudo umount -R /mnt/rootfs
    sudo losetup -D

Lastly Remember to comment out at least (with a #)

    #create_image
    #build_rootfs_into_image

At the bottom and save the script before re-running the image build script

---

Jessie 

Default qemu-debootstrap in jessie does not support --include=

    additional apt package install is therefore moved to the intial run script
    


