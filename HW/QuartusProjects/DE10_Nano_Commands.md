DE10_Nano_Commands:

u-boot: (replace xx:xx:xx:xx:xx:xx with a REAL mac address)

    setenv ethaddr xx:xx:xx:xx:xx:xx
    setenv hostname mksocfpga-nano-soc
    saveenv
    reset

Machinekit:
    sudo apt install machinekit-rt-preempt

Configs:
    sudo apt install socfpga-rbf
    sudo apt install git ca-certificates

    git clone https://github.com/the-snowwhite/Hm2-soc_FDM.git
for De10_Nano:

    git checkout DE10_Nano_FB_Cramps

    git clone https://github.com/the-snowwhite/Machineface.git
    git checkout work-updated
    cd ..
    git clone https://github.com/the-snowwhite/Cetus.git
    git checkout probework2
    cd ..

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

    