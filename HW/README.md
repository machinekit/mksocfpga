Note: Qsys complaints about ip search path not found can be solved via a single file:
the Quartus gui Global ip core library path likewise:
look at:

[fix Qsys ip search path link:](Quartus-Qsys-Ip-search-path_linux-location.md)


---

Using the Makefile:

Start Quartus shell:

    '~/altera/15.1/embedded/embedded_command_shell.sh'

cd to one of the quartus project folders:

    cd /the-snowwhite_git/mksocfpga/HW/QuartusProjects/DE0_NANO_SOC_GHRD

to start quartus gui with the project in current folder loaded:

    make quartus_edit


To script compile all needed output files for Machinekit (via hm2_soc driver):

    make all   (same as dts dtb rbf)

Note:


    The projects Quartus config is in *.qsf file(be carefull when hand editing).
    Beware There are (unclear when needed) differences between linux / and windows \\ Global paths.


Note2:

   On my (older) SocKit boards the usb serial uart chip does not power on from the usb cable alone.
   Forcing you to power on the SocKit board before dev/ttyUSB0 gets available. And dropping the usb
   connection when you power-off-reboot the board.

   This is because the uart chips Reset signal is pulled down too much (0.84V) to be able to come out
   of reset without powering up the whole board (caused by the chip connected to R301).

   A simple fix for this is to simply desolder R301. (On pcb-bottomside, near middle about 3 cm abowe switches [H_SW0])