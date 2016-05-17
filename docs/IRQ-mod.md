
#-------------------------------------------------------------------------------------#

#-------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------------#


machinekit ~/machinekit/configs/hm2-soc-stepper2/5i25-soc.ini

sudo ./uio_test &

sudo ./mksocmemio -r a00

sudo ./mksocmemio -w a00 2
sudo ./mksocmemio -w a00 0

sudo ./mksocmemio -w b00 0

# 0xCB00000
sudo ./mksocmemio -w 7200 211812352

#----------------------------------------------------------------------#

sudo modprobe -r uio_pdrv_genirq
sudo modprobe uio_pdrv_genirq of_id="hm2reg_io,generic-uio,ui_pdrv"

# use this instead:
machinekit@mksocfpga:~$ cat /etc/modprobe.d/uiohm2.conf
options uio_pdrv_genirq of_id="hm2reg_io,generic-uio,ui_pdrv"

#----> references:

Handling GPIO interrupts in userspace on Linux with UIO:
https://yurovsky.github.io/2014/10/10/linux-uio-gpio-interrupt/


http://stackoverflow.com/questions/16178876/c-implicit-declaration-of-function

Howard Mao
Exploring the Arrow SoCKit Part X - Sending and Handling Interrupts:
https://zhehaomao.com/blog/fpga/2014/05/24/sockit-10.html

Dynamic Kernel Module Support:
https://wiki.archlinux.org/index.php/Dynamic_Kernel_Module_Support

pread and pwrite not defined?:
http://stackoverflow.com/questions/12411942/pread-and-pwrite-not-defined

Setting up a device tree entry on Altera’s SoC FPGAs:
http://xillybus.com/tutorials/device-tree-altera-soc-cyclone