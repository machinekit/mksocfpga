
the hm2adc_uio-module is for now redundant. (not of use).

hm2reg_uio-module is currently implemented in Machinekit via the hostmot2 hm2_soc driver.

This documents the:

adcreg:  Driver module for the modded Nano Soc adc ip core.

adcfs:   c++ adc read test app:


usage examples:


      # when driver not compiled into kernel.
      sudo insmod adcreg.ko

      #---------- Single channel select --------------#

      # set measure number (number of samples = 2047)
      ./adcfs w 1 2047  # limit !

      # set sample channel 2 start (ch_nr << 1 | 0x001)
      ./adcfs w 0 4
      ./adcfs w 0 5
      ./adcfs w 0 4

      # read and print all sampled values to screen
      ./adcfs a

      # set sample channel 0 start (ch_nr << 1 | 0x001)
      ./adcfs w 0 0
      ./adcfs w 0 1
      ./adcfs w 0 0

      # read and print all sampled values to screen
      ./adcfs a


      #---------- Auto channel select ----------------#
      # set measure number (number of samples = 16)
      ./adcfs w 1 16

      # set sample channel 2 ready/start/ready and auto update bit(ch_nr << 1 | 0x00(0/1) | 0x010)
      ./adcfs w 0 20
      ./adcfs w 0 21
      ./adcfs w 0 20

      # read and print all sampled values to screen
      ./adcfs a
