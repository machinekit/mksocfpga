#!/bin/bash -e

cd /work/HW/VivadoProjects

configs=`find . -type f -name *_config`

for cfg in ${configs}
do
	echo building ${cfg}
   	./make_bitfile.sh ${cfg}
done
