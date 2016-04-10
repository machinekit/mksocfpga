Note: Qsys complaints about ip search path not found can be solved via a single file:
the Quartus gui Global ip core library path likewise:
look at:

[fix Qsys ip search path link:](Quartus-Qsys-Ip-search-path_linux-location.md)


---

Using the Makefile:

Start Quartus shell:

    '~/altera/15.1/embedded/embedded_command_shell.sh'

cd to a quartus project folder:

    cd /the-snowwhite_git/mksocfpga/HW/QuartusProjects/DE0_NANO_SOC_GHRD

to start quartus loaded with project loaded:

    make quartus_edit


To script compile all needed output files:

    make dts dtb rbf


(make sof may be needed instead of rbf to generate the .rbf fpga config file)

Note:


    Quartus config is in *.qsf files, there are (unclear)differences between linux / and windows \\ paths.


Note2:

   On my (older) SocKit boards the usb serial uart chip does not power on from the usb cable alone.
   Forcing you to power on the SocKit board before dev/ttyUSB0 gets available.

   This is because the uart chips Reset signal gets pulled down to low (0.84V) to come out of reset
   without powering up the whole board.

   To fix this you can simply desolder R301. (On bottomside, middle about 3 cm abowe switches [H_SW0])