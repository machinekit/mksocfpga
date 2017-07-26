#!/bin/sh
export PATH="$PATH:/root/altera_lite/15.1/quartus/bin/:/root/altera_lite/15.1/quartus/sopc_builder/bin/"
cd /work/HW/QuartusProjects/DE0_Nano_SoC_Cramps/
make -j$(nproc) rbf dts dtb
