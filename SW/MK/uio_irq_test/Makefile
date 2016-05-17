#
TARGET = uio_test

SOCEDS_DEST_ROOT = /home/mib/altera/15.1/embedded
HWLIBS_ROOT = /home/mib/altera/15.1/embedded/ip/altera/hps/altera_hps/hwlib/
CROSS_COMPILE := /home/mib/Development/Projects/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux/bin/arm-linux-gnueabihf-
ALT_DEVICE_FAMILY ?= soc_cv_av

CFLAGS := -g $(OFLAG) -Wall -Werror -std=c99 $(MULTILIBFLAGS) -I$(HWLIBS_ROOT)/include -I$(HWLIBS_ROOT)/include/$(ALT_DEVICE_FAMILY) -D$(ALT_DEVICE_FAMILY)
ALL_HWLIBS_SRC = $(wildcard $(HWLIBS_ROOT)/src/hwmgr/*.c) $(wildcard $(HWLIBS_ROOT)/src/hwmgr/$(ALT_DEVICE_FAMILY)/*.c $(wildcard $(HWLIBS_ROOT)/src/utils/*.c))

LDFLAGS =  -g -Wall
CC = $(CROSS_COMPILE)gcc
ARCH= arm

all:  $(TARGET)

build: $(TARGET)
$(TARGET): $(TARGET).o
	$(CC) $(LDFLAGS)   $^ -o $@
%.o : %.c
	$(CC) $(CFLAGS) -c $< -o $@

.PHONY: clean
clean:
	rm -f $(TARGET) *.a *.o *~
