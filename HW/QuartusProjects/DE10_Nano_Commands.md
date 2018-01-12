DE10_Nano_Commands:

u-boot: (replace xx:xx:xx:xx:xx:xx with a REAL mac address)

    setenv ethaddr xx:xx:xx:xx:xx:xx
    setenv hostname mksocfpga-nano-soc
    saveenv
    reset

    sudo apt update

Machinekit:

    sudo apt-get install $(apt-cache depends machinekit | grep Depends | sed "s/.*ends:\ //" | tr '\n' ' ')
    sudo apt purge machinekit
    (sudo dpkg -i machinekit-rt-preempt_0.1.1-1_armhf.deb machinekit_0.1.1-1_armhf.deb)
    (sudo apt-get autoremove)
    sudo apt install machinekit-rt-preempt

Configs:
    sudo apt install socfpga-rbf
    sudo apt install git ca-certificates

    git clone https://github.com/the-snowwhite/Hm2-soc_FDM.git
for De10_Nano:

    cd Hm2-soc_FDM
    git checkout DE10_Nano_FB_Cramps
    cd ~/

    git clone https://github.com/the-snowwhite/Machineface.git
    cd Machineface
    git checkout work-updated
    cd ~/
    git clone https://github.com/the-snowwhite/Cetus.git
    cd Cetus
    git checkout probework2
    cd ~/

SPI for tmc2130 stepper drivers:

    git clone --recursive https://github.com/the-snowwhite/SPI.git
    sudo apt install python-dev
    cd SPI/py-spidev
    sudo python setup.py install
    cd ~/

    if /usr/include/features.h:374:25: fatal error: sys/cdefs.h: No such file or directory
    -->sudo apt install --reinstall libc6-dev
    sudo python setup.py install
    cd ~/

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

    ./start.sh

then run machinekit client :-)