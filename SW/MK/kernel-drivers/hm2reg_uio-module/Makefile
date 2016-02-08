KERNEL_SRC_DIR=/home/mib/Development/Projects/arm-linux-gnueabifh-kernel/linux
CURDIR=$(shell pwd)
CROSS_C="/home/mib/Development/Projects/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux/bin/arm-linux-gnueabihf-"
ARCH=arm

OUT_DIR =$(KERNEL_SRC_DIR)

//NCORES=`nproc`
NCORES=1



#LINUX_VARIABLES = PATH=$(PATH)
LINUX_VARIABLES = ARCH=$(ARCH)
ifneq ("$(KBUILD_BUILD_VERSION)","")
	LINUX_VARIABLES += KBUILD_BUILD_VERSION="$(KBUILD_BUILD_VERSION)" 
endif
LINUX_VARIABLES += CROSS_COMPILE=$(CROSS_C)

#ifneq ("$(DEVICETREE_SRC)","")
#	LINUX_VARIABLES += CONFIG_DTB_SOURCE=$(DEVICETREE_SRC)
#endif
#LINUX_VARIABLES += INSTALL_MOD_PATH=$(INSTALL_MOD_PATH)


ifndef OUT_DIR
    $(error OUT_DIR is undefined, bad environment, you point OUT_DIR to the linux kernel build output directory)
endif

KDIR ?= $(OUT_DIR)

default:
	$(MAKE) -j$(NCORES) $(LINUX_VARIABLES) -C $(KDIR) M=$(CURDIR)

clean:
	$(MAKE) -C $(KDIR) $(LINUX_VARIABLES) M=$(CURDIR) clean

help:
	$(MAKE) -C $(KDIR) $(LINUX_VARIABLES) M=$(CURDIR) help

modules:
	$(MAKE) -j$(NCORES) $(LINUX_VARIABLES) -C $(KDIR) M=$(CURDIR) modules

modules_install:
	$(MAKE) -C $(KDIR) $(LINUX_VARIABLES) M=$(CURDIR) modules_install

