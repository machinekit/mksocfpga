#!/bin/sh

sopc-create-header-files \
"$PWD/soc_system.sopcinfo" \
--single hps_0.h \
--module hps_0
