![Firsttime Quartus setup guide ](./Quartus-Setup-guide.md)

Just a small overview of the path from software --> cpu to fpga hostmot2 --> I/O pins

Going straight for an axi Interface would mean redesigning the top hostmot2.vhd
module splitting the (outside hps) address bus into 2(in / out).

So initially I have settled on using a basic Avalon interface as this is the most straight forward way to implement an I/O path with 1 16-bit adressbus and 2 unidirectional 32-bit data buses.


![Hps/cpu to fpga pathways through bridges](https://github.com/the-snowwhite/mksocfpga/blob/master/docs/pics/Hps-fpga-bridges.png)


Would be an idea to build this hm2 top controller module into the qsys design as an ip core instead of having it hanging outside through a bus type interface port?  --> no ..


(The hps soc will be the 1 single static basic design partition for starters). (hostmot2.vhd will be the top of the dynamic reconfigurable opartition)


The link between the hm2 avalon interface ip (in qsys), the devicetree (dts-->dtb) entry, and link to getting memory mapped access in (linux) software is sketched out here:

[Machinekit driver sketch](https://github.com/the-snowwhite/machinekit/blob/mksocfpga/src/hal/drivers/mesa-hostmot2/hm2_soc.c#L23)


[Avalon Interface IP config file](https://github.com/the-snowwhite/mksocfpga/blob/master/HW/ip/hm2reg_io/hm2reg_io_hw.tcl#L76)


[this script creates the following relevant headerfile](https://github.com/the-snowwhite/mksocfpga/blob/master/HW/QuartusProjects/DE0_NANO_SOC_GHRD/generate_hps_qsys_header.sh#L1)


[Headerfile containing all hw address info in customized hps soc ](https://github.com/the-snowwhite/mksocfpga/blob/master/HW/QuartusProjects/DE0_NANO_SOC_GHRD/hps_0.h#L12)


-----

PINOUTS:

So how do the Hardware I/O pins relate to the Quartus project files ?


https://github.com/the-snowwhite/mksocfpga/blob/master/HW/hm2/hostmot2.vhd#L70

https://github.com/the-snowwhite/mksocfpga/blob/master/HW/QuartusProjects/DE0_NANO_SOC_GHRD/soc_system.qsf#L651

https://github.com/the-snowwhite/mksocfpga/blob/master/HW/hm2/config/PIN_G540x2_34.vhd


![Hostmot2 top instance](https://github.com/the-snowwhite/mksocfpga/blob/master/docs/pics/Hostmot2-vhd_inst-pinouts.png)






On the near future wish list is to implement partial re-configuration partions with the lower level hm2 modules, giving a more modular (hal like) approach to custom configuring.

Is done with a (mostly) solid unchanging interface structure giving "boxes / slots", block elements can be swapped in / out of....(think 4-8 partions at most)

