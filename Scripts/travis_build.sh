#!/bin/sh
export PATH="$PATH:/root/altera_lite/15.1/quartus/bin/:/root/altera_lite/15.1/quartus/sopc_builder/bin/"
cd /work/HW/QuartusProjects/DE0_NANO_SOC_GHRD/
make -j$(nproc) rbf # dts dtb
