
# Mesanet.com firmware for the CycloneV and Zynq

hostmot2 firmware for Altera and Xilinx SoC/FPGA platforms, works with the Machinekit [hm2_soc_ol driver](http://www.machinekit.io/docs/man/man9/hm2_soc_ol/).

## Building for CycloneV platforms:

````
# see https://github.com/cdsteinkuehler/QuartusBuildVMs
docker pull cdsteinkuehler/jessie-quartus-15.1.2

git clone https://github.com/machinekit/mksocfpga.git/
cd mksocfpga
docker run -itv $(pwd):/work cdsteinkuehler/jessie-quartus-15.1.2 /work/build.quartus.sh
````

## Building for Zynq platforms:

build docker images from https://github.com/dkhughes/vivado-docker.

````
 docker run -itv $(pwd):/work <maintainer>/jessie-vivado-2015.4 /work/build.vivado.sh
````

## Debian packages

repo: `http://deb.machinekit.io/debian jessie main`

CycloneV: `apt install socfpga-rbf`

Zynq: `apt install socfpga-rbf`

Quartus: build [![Quartus Build Status](https://jenkins.machinekit.io/buildStatus/icon?job=mksocfpga-quartus)](https://jenkins.machinekit.io/buildStatus/icon?job=mksocfpga-quartus)
packaging [![Debian Packaging Status](https://jenkins.machinekit.io/buildStatus/icon?job=mksocfpga-packaging-quartus)](https://jenkins.machinekit.io/buildStatus/icon?job=mksocfpga-packaging-quartus)

Vivado: build [![Vivado Build Status](https://jenkins.machinekit.io/buildStatus/icon?job=mksocfpga-vivado)](https://jenkins.machinekit.io/job/mksocfpga-vivado)
packaging: [![Build Status](https://jenkins.machinekit.io/buildStatus/icon?job=mksocfpga-packaging-vivado)](https://jenkins.machinekit.io/job/mksocfpga-packaging-vivado)

