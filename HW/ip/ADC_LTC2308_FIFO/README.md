## Readme for  ADC_LTC2308_FIFO  ip core modded by Michael Brown marts 2016 for Machinekit usage ##


The core now has single channel read as before.

And a new auto channel select mode, which increases the selected channel on each read (0-7) and then wraps around to ch 0.

The buffer can contain upto 2048 samples, which each are appended with the adc channel number the data sample is read from.

the ip core currently presents 2 16 bit read write registers of which:

reg 0 is used only as control / status register.

reg 1 is also used for reading the data samples.



      WRite:
      // write for control
      reg 				measure_fifo_start;
      reg  [11:0] 	measure_fifo_num;
      reg	[2:0]		measure_fifo_ch;
      reg				auto_ch_select;

      addr 0  `define WRITE_REG_START_CH      0   {auto_ch_select, measure_fifo_ch, measure_fifo_start} <= slave_writedata[4:0];

      addr 1  `define WRITE_REG_MEASURE_NUM   1   {measure_fifo_num} <= slave_writedata[11:0];

      REad:
      reg measure_fifo_done;
      wire [11:0]	 fifo_q;
      wire [2:0] fifo_ch_q;

      addr 0  `define READ_REG_MEASURE_DONE   0   slave_read_status   slave_readdata <= {measure_fifo_ch, measure_fifo_num, measure_fifo_done};

      addr 1  `define READ_REG_ADC_VALUE      1   slave_read_data     slave_readdata <= {1'b0, fifo_ch_q, fifo_q};


A typical data read cycle would consist of:

1. setting the number of measurements by writing reg 1.

2. setting bit 1 in reg 1 to 0 (and selected ch in bits 3 - 1, and eventually setting bit 4 for auto ch select mode)

3. setting bit 1 in reg 1 to 1 (and selected ch in bits 3 - 1, and eventually setting bit 4 for auto ch select mode)

   Starts the adc read run.

4. setting bit 1 in reg 1 to 0 (and selected ch in bits 3 - 1, and eventually setting bit 4 for auto ch select mode)

   Makes the adc ready for next read.


NOTE: the measure_fifo_done signal (bit 0 in reg 0), is 1 when the adc data measurement run is finished an data is ready to be read.

See the adcreg driver and app example software (in mksocfpga/SW/MK/kernel-drivers/  folder) for specifics.