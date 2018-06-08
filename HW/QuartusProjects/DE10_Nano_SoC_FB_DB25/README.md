This project is a clone of the DE0_Nano_SoC_DB25 project only with an added framebuffer driving the HDMI output.

The current screen resolution is: 1024x768x8bpp @60Hz.


The frame reader runs on a separate bus (f2h_sdram) as bus master, making it noticably faster than a cpu alone fb.

This project uses the hm2 config files from the DE0_Nano_SoC_DB25 project folder, so it will run with the same hm2 soc configs.
