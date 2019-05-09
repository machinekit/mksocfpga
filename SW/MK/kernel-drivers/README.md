
the hm2adc_uio-module is for now redundant. (not of use).

hm2reg_uio-module is currently implemented in Machinekit via the hostmot2 hm2_soc driver.

This documents the inner ADC functionality:


HAL hostmot2_ol:  Builtin Nano Soc adc ip core. [relative link here](../../../HW/QuartusProjects/Common/adc_ltc2308_fifo.s)

when running the hm2_soc_ol driver with _adc=1

adc values show up as:
hm2_5i25.0.nano_soc_adc.ch.0.out
hm2_5i25.0.nano_soc_adc.ch.1.out
hm2_5i25.0.nano_soc_adc.ch.2.out
hm2_5i25.0.nano_soc_adc.ch.3.out
hm2_5i25.0.nano_soc_adc.ch.4.out
hm2_5i25.0.nano_soc_adc.ch.5.out
hm2_5i25.0.nano_soc_adc.ch.6.out
hm2_5i25.0.nano_soc_adc.ch.7.out
in the hal

mksocmemio:   c++ generic Hostmot2 memory read/write utility:


manual usage examples:


      #---------- Single channel select --------------#

      # set measure number (number of samples = 8)
      mksocmemio -w 0x204 8  # limit = 2047 !

      # set sample channel 2 start (ch_nr << 1 | 0x001)
      mksocmemio -w 0x204 1  fetch 1 sample
      mksocmemio -w 0x200 4
      .mksocmemio -w 0x200 5

      # read and print all sampled values to screen
      mksocmemio -r 0x204 // 1 sample

      # set sample channel 0 start (ch_nr << 1 | 0x001)
      mksocmemio -w 0x204 4  fetch 4 samples
      mksocmemio -w 0x200 0
      mksocmemio -w 0x200 1

      # read and print all sampled values to screen
      mksocmemio -r 0x204 // each suggesive read command to this location shows the next sample


      #---------- Auto channel select mode ----------------#
      #---------- this is the current mode the DExx hal adc ---------------#
      # set measure number (number of samples = 8)
      .mksocmemio -w 0x204 8

      # set sample channel 2 ready/start/ready and auto update bit(ch_nr << 1 | 0x00(0/1) | 0x010)
      mksocmemio -w 0x200 0x0100
      mksocmemio -w 0x200 0x0101  // start sampling

      # read and print all sampled values to screen
      mksocmemio -r 0x204 // repeat 8 times to read all (8) samples

