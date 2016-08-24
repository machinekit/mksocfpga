#!/bin/bash -e
set -x

QSYS_ROOTDIR=/home/builder/altera_lite/15.1/quartus/sopc_builder/bin
ALTERAOCLSDKROOT=/home/builder/altera_lite/15.1/hld
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/builder/altera_lite/15.1/quartus/bin:/home/builder/altera_lite/15.1/quartus/sopc_builder/bin
HOME=/home/builder

# generate the protobuf python bindings
cd /work/HW/firmware-tag
make TOPDIR=/work py-proto

# generate Quartus bitfiles
cd /work/
make -j$(nproc) -f Makefile.Quartus all

# results are in HW/QuartusProjects/**/output_files/*.rbf
