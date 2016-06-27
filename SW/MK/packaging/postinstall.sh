#!/bin/bash -e
cd /lib/firmware/socfpga/dtbo
echo rebuilding device tree overlays in ${PWD} 
make DTC=/usr/src/linux-headers-4.1.17-ltsi-rt17-gab2edea/scripts/dtc/dtc all

