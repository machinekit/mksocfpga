## Running machinekit-hal on the Kria KR260 board

First Iteration of the KR260 port runs on the  Xilinx Ubuntu Desktop 22.04 LTS from Canonical:
https://ubuntu.com/download/amd-xilinx

## Docker based build image for building custom bitfiles:

    docker pull thesnowwhite/bionic-vivado-sdk:2022.2
    sudo mkdir /tftpboot
    /usr/bin/docker run --rm --privileged --memory 48g --shm-size 1g --device /dev/snd -itv $(pwd):/work -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix --net=host -e TZ=Europe/Copenhagen -v $HOME/.Xauthority:/home/vivado/.Xauthority -v $HOME/.Xresources:/home/vivado/.Xresources -v $HOME/.Xilinx:/home/vivado/.Xilinx -v /tftpboot:/tftpboot --name xilinx-sdk bionic-vivado-sdk:2022.2 /bin/bash

## To enable running hostmot2 based machinekit-hal the mksocfpga fpga firmware can be auto loaded


    wget

    sudo mkdir -p /lib/firmware/xilinx/machinekit
    sudo cp kr260_xck26.bit kria_kr260_xck26_ol.dtbo /lib/firmware/xilinx/machinekit

    sudo sh -c 'cat <<EOF > "/lib/firmware/xilinx/machinekit/shell.json"
    {
        "shell_type" : "XRT_FLAT",
        "num_slots": "1"
    }
    EOF'

    sudo sh -c 'cat <<EOF > "/etc/dfx-mgrd/default_firmware"
    machinekit
    EOF'

## Until the machinekit-hal cloudsmith Jammy packages get online the debs are provided here:

    wget

Then install the following packages:

    sudo apt install ./machinekit-hal_0.5.21099-1.git2c2ff0e51~jammy_arm64.deb \
    ./libmachinekit-hal_0.5.21099-1.git2c2ff0e51~jammy_arm64.deb \




## Hal is then invoked with:

    halrun -I

    loadrt hostmot2
    newinst hm2_soc_ol hm2-socfpga0 already_programmed=1 -- config="num_pwmgens=3 num_stepgens=6"

    exit

## To check what happened in the log:

    cat /var/log/syslog | grep 'rtapi\|msgd'


## The syslog can be cleared with:

    sudo sh -c 'echo "" > /var/log/syslog'