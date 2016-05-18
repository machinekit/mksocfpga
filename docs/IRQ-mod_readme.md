---
enable mksocfpga uio_irq


---

Added mini version of mesaflash tool called:

mksocmemio

[this utility can read or write the mksocfpga hostmot2 registers](../SW/MK/mksocmemio/)

Memory layout Here:

[HostMot2 Register map](http://freeby.mesanet.com/regmap)

	usage:
	read: 	mksocmemio -r [address in hex]
	write: 	mksocmemio -w [ address in hex] [value in decimal]

---

Added utility to count and display number of uio0 interrupts:

uio_test

[this utility counts and displays the number of uio0 interrupts occured](../SW/MK/uio_irq_test/)

	sudo ./uio_test &

to remove:

	sudo pkill uio_test

---

Making hm2reg-uio-dkms driver obsolete:

Inspired from here:

[Handling GPIO interrupts in userspace on Linux with UIO](https://yurovsky.github.io/2014/10/10/linux-uio-gpio-interrupt/)

First remove all custom hm2 soc uio driver instances:

	sudo dkms remove sudo dkms remove hm2reg_uio/0.0.2 --all
	sudo apt purge hm2reg-uio-dkms

reboot

to set uio_pdrv_genirq parameter manually:


	sudo modprobe -r uio_pdrv_genirq
	sudo modprobe uio_pdrv_genirq of_id="hm2reg_io,generic-uio,ui_pdrv"

use this to set permantly instead:

	machinekit@mksocfpga:~$ sudo sh -c 'echo options uio_pdrv_genirq of_id="hm2reg_io,generic-uio,ui_pdrv" > /etc/modprobe.d/uiohm2.conf'

---

Dts:

[Remember to recompile the new changed device tree overlay fragment:](../SW/MK/dts-overlays/hm2reg_uio-irq.dts)


note: compatible string is replaced with:

	compatible = "hm2reg_io,generic-uio,ui_pdrv";

compile with dtc v1.4:

[install newest device-tree-tools:](../SW/MK/dts-overlays/device-tree-tools-install.sh)

	./device-tree-tools-install.sh

compile:

	dtc -I dts -O dtb -o hm2reg_uio.dtbo hm2reg_uio-irq.dts

copy:

	sudo cp hm2reg_uio.dtbo /lib/firmware/socfpga/dtbo/hm2reg_uio.dtbo

---

Run machinekit:

[use hm2_soc mk config with the hm2_soc_ol driver like in this example config:](./test-configs/hm2-soc-stepper-cramps)

	[HOSTMOT2]
	DRIVER=hm2_soc_ol
	BOARD=5i25
	CONFIG="firmware=socfpga/dtbo/hm2reg_uio.dtbo num_encoders=2 num_pwmgens=2 num_stepgens=10"

---

To download test hal config:

	sudo apt install subversion
	cd machinekit/configs
	svn checkout https://github.com/the-snowwhite/mksocfpga/trunk/docs/test-configs/hm2-soc-stepper-cramps

or

	svn checkout https://github.com/machinekit/mksocfpga/trunk/docs/test-configs/hm2-soc-stepper-cramps

to run:

	machinekit ~/machinekit/configs/hm2-soc-stepper-cramps/5i25-soc.ini

---

in separate console:

start uio interrupt count readout:

	sudo ./uio_test &


		machinekit@mksocfpga:~$ sudo ./uio_test &
	[1] 3177


To end afterwards:

	sudo pkill uio_test

---

set period to roughly 1ms (1kHz)

and enable timer 1 interrupt:

	sudo ./mksocmemio -w 7200 211812352
	sudo ./mksocmemio -w a00 2


shows:

	machinekit@mksocfpga:~$ sudo ./mksocmemio -w 7200 211812352
		mksocfpgamemio: read write hm2 memory locatons by cmmandline arguments
		/dev/uio0 opened fine OK
		region mmap'ed  OK
		mem pointer created OK
	Program name: ./mksocmemio    input option = w
	read Write read
	Address 29184   value = 436175482
	Address 29184   former val = 0x19FF827A          wrote: --> 0x0CA00000   read: = 0x0CFA0000


	machinekit@mksocfpga:~$ sudo ./mksocmemio -w a00 2
		mksocfpgamemio: read write hm2 memory locatons by cmmandline arguments
		/dev/uio0 opened fine OK
		region mmap'ed  OK
		mem pointer created OK
	Program name: ./mksocmemio    input option = w
	read Write read
	Address 2560    value = 1
	Address 2560    former val = 0x00000001          wrote: --> 0x00000002   read: = 0x00000002
	Interrupt #2!


dec 211812352 = 0xCB00000 hex

waveform on dpll pin (red)

![waveform on dpll pin (red)](pics/irq/HM-Soc-DPLL_wave.png)

---

reset interrupt:

	sudo ./mksocmemio -w b00 0

shows:

	machinekit@mksocfpga:~$ sudo ./mksocmemio -w b00 0
		mksocfpgamemio: read write hm2 memory locatons by cmmandline arguments
		/dev/uio0 opened fine OK
		region mmap'ed  OK
		mem pointer created OK
	Program name: ./mksocmemio    input option = w
	read Write read
	Address 2816    value = 131071
	Address 2816    former val = 0x0001FFFF          wrote: --> 0x00000000   read: = 0x0001FFFF
	Interrupt #3!


2 waveform examples on intirq pin (blue)

![waveform on intirq pin (blue)](pics/irq/HM-Soc-IRQ_wave1.png)

note:  int signal goes high(inactive) at random time (press enter), and goes low (irq trigger) when dpll signal falls low.

![waveform on intirq pin (blue)](pics/irq/HM-Soc-IRQ_wave2.png)


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
