DE10_Nano_Commands:

u-boot: (replace xx:xx:xx:xx:xx:xx with a REAL mac address)

setenv ethaddr xx:xx:xx:xx:xx:xx
setenv hostname mksocfpga-nano-soc
saveenv
reset


sudo cp /etc/apt/sources.list-local /etc/apt/sources.list


sudo apt update
cp /boot/uEnv.txt .
nano uEnv.txt

machinekit@mksocfpga-nano-soc:~$ cat uEnv.txt
kver=4.1.22-ltsi-rt23-socfpga-0.1
initrd_installed=Yes
bitimage=/lib/firmware/socfpga/DE10_Nano_FB_Cramps.3x24.rbf
fpgaload=mmc rescan;load mmc ${bootpart} ${loadaddr} ${bitimage}; fpga load 0 ${loadaddr} ${filesize}
fpgaintf=ffd08028
fpgaintf_handoff=0x00000000
fpga2sdram_apply=3ff795a4
fpga2sdram=ffc25080
fpga2sdram_handoff=0x00000000
axibridge=ffd0501c
axibridge_handoff=0x00000000
l3remap=ff800000
l3remap_handoff=0x00000019
bridge_enable_handoff=mw ${fpgaintf} ${fpgaintf_handoff}; mw ${fpga2sdram} ${fpga2sdram_handoff}; mw ${axibridge} ${axibridge_handoff}; mw ${l3remap} ${l3remap_handoff}
loadimage=run fpgaload; run bridge_enable_handoff; load mmc ${bootpart} ${loadaddr} ${bootimage}; load mmc ${bootpart} ${fdt_addr} ${fdtimage}


sudo apt install machinekit-rt-preempt
sudo apt install socfpga-rbf
sudo apt install git ca-certificates

git clone https://github.com/the-snowwhite/Hm2-soc_FDM.git
git clone https://github.com/the-snowwhite/Machineface.git
git clone https://github.com/the-snowwhite/Cetus.git

SPI for tmc2130 stepper drivers:
git clone --recursive https://github.com/the-snowwhite/SPI.git
sudo apt install python-dev
cd SPI/py-spidev
sudo python setup.py install
cd ~/

if /usr/include/features.h:374:25: fatal error: sys/cdefs.h: No such file or directory
-->sudo apt install --reinstall libc6-dev

gksu leafpad /etc/linuxcnc/machinekit.ini
--> REMOTE=1

cat <<EOT > start.sh
#!/bin/bash

## Enable debug
sudo sh -c 'echo 1 > /proc/sys/fs/suid_dumpable'
export DEBUG=5

/home/machinekit/SPI/set_tmc2130.sh 8
/usr/bin/mklauncher /home/machinekit/Hm2-soc_FDM

EOT

chmod +x start.sh

leafpad Hm2-soc_FDM/Cramps/PY/Mibrap-X_hm2_mill-soc/fdm/config/motion.py
line 15-16

    #    os.system('halcmd newinst hm2_soc_ol hm2-socfpga0 -- config="firmware=socfpga/dtbo/DE0_Nano_SoC_Cramps.3x24_cap.dtbo num_pwmgens=6 num_stepgens=8" debug=1')
    #    os.system('halcmd newinst hm2_soc_ol hm2-socfpga0 -- config="firmware=socfpga/dtbo/DE10_Nano_FB_Cramps.3x24_cap.dtbo num_pwmgens=6 num_stepgens=8" debug=1')
        os.system('halcmd newinst hm2_soc_ol hm2-socfpga0 -- config="num_pwmgens=6 num_stepgens=8" debug=1')

gives problem:

    Aug 29 14:47:47 mksocfpga-nano-soc rtapi:0: 1:rtapi_app:2065:user hm2_soc_ol: soc_mmap_fail hm2-socfpga0
    Aug 29 14:47:47 mksocfpga-nano-soc rtapi:0: 1:rtapi_app:2065:user hm2/foo: failed to program fpga, aborting hm2_register
    Aug 29 14:47:47 mksocfpga-nano-soc rtapi:0: 1:rtapi_app:2065:user foo: hm2_soc_ol_board fails HM2 registration
    Aug 29 14:47:47 mksocfpga-nano-soc rtapi:0: 1:rtapi_app:2065:user hm2_soc_ol: error registering UIO driver: -22

    