---
enable mksocfpga uio_irq



---

mksocmemio can read or write the mksoc hostmot2 registers
Here:
[HostMot2 Register map](http://freeby.mesanet.com/regmap)

	usage:
	read: 	mksocmemio -r [address in hex]
	write: 	mksocmemio -w [ address in hex] [value in decimal]


---

uio_test outputs number of uio0 interrupts

	sudo ./uio_test &

to remove:

	sudo pkill uio_test

---

to set uio_pdrv_genirq parameter manually:

	sudo modprobe -r uio_pdrv_genirq
	sudo modprobe uio_pdrv_genirq of_id="hm2reg_io,generic-uio,ui_pdrv"

use this to set permantly instead:

	machinekit@mksocfpga:~$ sudo sh -c 'echo options uio_pdrv_genirq of_id="hm2reg_io,generic-uio,ui_pdrv" > /etc/modprobe.d/uiohm2.conf'

---

hm2_soc mk config with:

	[HOSTMOT2]
	DRIVER=hm2_soc_ol
	BOARD=5i25
	CONFIG="firmware=socfpga/dtbo/hm2reg_uio.dtbo num_encoders=2 num_pwmgens=2 num_stepgens=10"

to run:

	machinekit ~/machinekit/configs/hm2-soc-stepper2/5i25-soc.ini

---

enable timer 1 interrupt:
and set period to roughly 1ms (1kHz)
	sudo ./mksocmemio -w a00 2
	sudo ./mksocmemio -w 7200 211812352

dec 211812352 = 0xCB00000 hex


![waveform on dpll pin (red)](pics/HM-Soc-DPLL_wave.png)

---

reset interrupt:

	sudo ./mksocmemio -w b00 0

![waveform on intirq pin (blue)](pics/HM-Soc-IRQ_wave1.png)

note:  int start at random time, and ends on dpll signal low

![waveform on intirq pin (blue)](pics/HM-Soc-IRQ_wave2.png)


---

----> references:

Generating clock interrupts from Mesanet cards:
https://github.com/mhaberler/asciidoc-sandbox/wiki/Generating-clock-interrupts-from-Mesanet-cards

Installing the Machinekit SOCFPGA test image for the Terasic DE0-Nano-SoC Kit
https://gist.github.com/mhaberler/89a813dc70688e35d8848e8e467a1337


Handling GPIO interrupts in userspace on Linux with UIO:
https://yurovsky.github.io/2014/10/10/linux-uio-gpio-interrupt/

Howard Mao
Exploring the Arrow SoCKit Part X - Sending and Handling Interrupts:
https://zhehaomao.com/blog/fpga/2014/05/24/sockit-10.html

Setting up a device tree entry on Altera’s SoC FPGAs:
http://xillybus.com/tutorials/device-tree-altera-soc-cyclone

Dynamic Kernel Module Support:
https://wiki.archlinux.org/index.php/Dynamic_Kernel_Module_Support


pread and pwrite not defined?:
http://stackoverflow.com/questions/12411942/pread-and-pwrite-not-defined

http://stackoverflow.com/questions/16178876/c-implicit-declaration-of-function
