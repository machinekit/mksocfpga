
# Mesanet.com firmware for the CycloneV and Zynq

hostmot2 firmware for Altera and Xilinx SoC/FPGA platforms, works with the Machinekit [hm2_soc_ol driver](http://www.machinekit.io/docs/man/man9/hm2_soc_ol/).

## Building for CycloneV platforms:

build docker images from https://github.com/machinekit/mksocfpga.git

````
docker pull cdsteinkuehler/jessie-quartus-15.1.2

git clone https://github.com/machinekit/mksocfpga.git/
cd mksocfpga
docker run -itv $(pwd):/work cdsteinkuehler/jessie-quartus-15.1.2 /work/build.quartus.sh
````

## Building a single CycloneV bit file:

build docker images from https://github.com/machinekit/mksocfpga.git

### Launch a Docker build machine with the latest mksocfpga source code
````
docker pull cdsteinkuehler/jessie-quartus-15.1.2

git clone https://github.com/machinekit/mksocfpga.git/
cd mksocfpga
docker run -itv $(pwd):/work cdsteinkuehler/jessie-quartus-15.1.2 /bin/bash

# You should now have a command prompt for the Docker Quartus build image
````

### Build the firmware-id protobuf bindings
````
# From the Docker Quartus build image command line, run:
cd /work/HW/firmware-tag
make TOPDIR=/work py-proto
````

### Build the desired FPGA bit file
````
# From the Docker Quartus build image command line, run:
cd /work/HW/QuartusProjects/<project>
./build.sh <config>

# ie:
cd /work/HW/QuartusProjects/DE0_Nano_SoC_DB25
./build.sh 7I76_7I76_7I76_7I76
````

## Building for Zynq platforms:

build docker images from https://github.com/dkhughes/vivado-docker.

````
docker run -itv $(pwd):/work <maintainer>/jessie-vivado-2015.4 /work/build.vivado.sh
````

## Debian packages

repo: `http://deb.machinekit.io/debian jessie main`

CycloneV: `apt install socfpga-rbf`

Zynq: `apt install socfpga-bit`

Quartus: build [![Quartus Build Status](https://jenkins.machinekit.io/buildStatus/icon?job=mksocfpga-quartus)](https://jenkins.machinekit.io/job/mksocfpga-quartus)
packaging [![Debian Packaging Status](https://jenkins.machinekit.io/buildStatus/icon?job=mksocfpga-packaging-quartus)](https://jenkins.machinekit.io/job/mksocfpga-packaging-quartus)

Vivado: build [![Vivado Build Status](https://jenkins.machinekit.io/buildStatus/icon?job=mksocfpga-vivado)](https://jenkins.machinekit.io/job/mksocfpga-vivado)
packaging: [![Build Status](https://jenkins.machinekit.io/buildStatus/icon?job=mksocfpga-packaging-vivado)](https://jenkins.machinekit.io/job/mksocfpga-packaging-vivado)
