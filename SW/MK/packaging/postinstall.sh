#!/bin/bash -e
cd /lib/firmware/socfpga/dtbo
echo rebuilding device tree overlays in ${PWD} 
make all

