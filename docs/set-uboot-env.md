
Missing config fpga on u-boot boot fix

    setenv fpgaimage socfpga.rbf
    setenv fpgadata 0x2000000

    setenv mmcload 'mmc rescan;load mmc 0:1 ${fpgadata} ${fpgaimage};load mmc 0:1 ${loadaddr} ${bootimage};load mmc 0:1 ${fdt_addr} ${fdtimage}'

    setenv fpgaconfig 'load mmc 0:1 ${fpgadata} ${fpgaimage};fpga load 0 ${fpgadata} ${filesize}'

    setenv bootcmd 'run fpgaconfig; run mmcload; run mmcboot'

Missing lan @u-boot fix !! permanent until preloader reinstall 
    
    setenv ethaddr xx:xx:xx:xx:xx:xx


Save variables and reboot ->

    saveenv
    reset
    