Right now the quartus design projectfiles behind the initial mesa 5i25 test design in the first socfpga machinekit sd-images is residing here in masterbranch of the mksocpga repo.

It has an avalon --> uio driver interface, ~~that hopefully shortly will be replaced with an axi interfacce.~~

Requirements to re-build the required quartus binaries:


Altera Quartus 15.1.2 prime lite
Altera Soc Eds

(Install into default altera/15.1 folder do not change paths...)

From Altera --> Download --> (update version)

Quartus prime 15.1.2  (on Debian.)(no license required for lite version)

    Download the complete download:
    Quartus-lite-15.1.2.193-linux.tar

    extract

    3. Change the file permission for all the setup (.run) files by running the command: chmod +x *.run.
 	 4. Run the QuartusSetup-15.1.2.193-linux.run file.


Soc EDS:

   On download page click Soc Eds
   download:


 	 SoC Embedded Design Suite (EDS)
    Size: 2.3 GB MD5: 7FE507F3A29652E3529FA6432AA9E165 - See more at: http://dl.altera.com/soceds/?edition=standard#sthash.lUOCRFVv.dpuf

 	extract and chmod +x as before

 	Run the SoCEDSSetup-15.1.1.60-linux.run file   (first as normal user)

 	Read and follow instructions.

 	Run afterwards the suggested script file a root.
 	Install all suggested dependencies.

 	You do not have to install DS-5

   Last not least if you want to use usb-blaster jtag you need to add a udev rule (ask) TODO:
----


Git clone:


    git clone https://github.com/the-snowwhite/mksocfpga.git mkhm2soc

    cd mkhm2soc


Open Quartus shell in new konsole and run make all in project folder:


    mib@debian9-ws:~$ ~/altera/15.1/embedded/embedded_command_shell.sh
    WARNING: DS-5 install not detected. SoC EDS may not function correctly without a DS-5 install.
    ------------------------------------------------
    Altera Embedded Command Shell

    Version 15.1 [Build 193]
    ------------------------------------------------
    mib@debian9-ws:~$ cd /home/mib/Development/the-snowwhite-git/mkhm2soc/QuartusProjects/DE0_NANO_SOC_GHRD
    mib@debian9-ws:~/Development/the-snowwhite-git/mkhm2soc/QuartusProjects/DE0_NANO_SOC_GHRD$ make dts dtb sof

Build time around 10 min or so .... ends with:

    Info: Quartus Prime Shell was successful. 0 errors, 527 warnings
        Info: Peak virtual memory: 1085 megabytes
        Info: Processing ended: Tue Mar 29 12:55:52 2016
        Info: Elapsed time: 00:07:31
        Info: Total CPU time (on all processors): 00:13:50
    quartus_cpf -c -o bitstream_compression=on output_files/soc_system.sof output_files/soc_system.rbf

     ....

         Info: Command: quartus_cpf -c -o bitstream_compression=on output_files/soc_system.sof output_files/soc_system.rbf
    Info: Quartus Prime Convert_programming_file was successful. 0 errors, 0 warnings
        Info: Peak virtual memory: 400 megabytes
        Info: Processing ended: Tue Mar 29 12:55:53 2016
        Info: Elapsed time: 00:00:01
        Info: Total CPU time (on all processors): 00:00:01



Output is collected in this archive.

To install into sd boot folder:

look at this script:

https://github.com/the-snowwhite/soc-image-buildscripts/blob/master/inst-rbf-dtb.sh
