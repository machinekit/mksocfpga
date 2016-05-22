#!/bin/bash -e
cd /lib/firmware/socfpga
echo rebuilding device tree overlays in $PWD:
make clean all
