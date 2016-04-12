Guidelines for adding a new Xilinx board:

--- first board ....

The HW/hm2 folder contains all needed MESA (unmodified) hm2 sources.
Initilally There should be added:

a main "include file" simlar to the hm2_socfpga.qip file that added
to a new quartus board project adds / setups all hostmot2 dependencies.

a (bitfile)config file in the hm2/config folder including the board, idrom constants, and pin / core config parameter files (duplicate(s) of *.qip for Quartus)

and also a Vivado .qip equaliant in the functions folder.

---

Next step is to develop a hostmot2_io (UIO) ip core that can be recognized by the hm2_soc.c
via It's uio driver:

the details for getting the correct detaile into the device tree are documented here:
https://github.com/machinekit/machinekit/blob/master/src/hal/drivers/mesa-hostmot2/hm2_soc.c#L23

This is excatly the string / line that the hm2_socfpga uio driver is probing for:

    compatible = "machkt,hm2reg-io-1.0";

NOTE: Reason the quartus project is not using an AXI ip core interface is solely that I was unable
to come up with / find an AXI driver with a shared address bus.
(The unmodified hostmot2 top file interface, has separate in / out data busses but only 1 address bus...?)

Also the UIO driver requires the interface to be fully memory mappable (no bursts ... ?)
---

Then there is only to create a top level project file wirering into the hostmot2.vhd instance.

and lastly setup / correct the inputted parameters. (from config folder).


--- Next boards --------------------

later added boards will then just need to add the Vivado (ISE ?) hm2_socfpga.???.

add the interface core.

add hostmot2 core to the top file and wire up I/Os and interface.

and setup "emulated" board configuration.



