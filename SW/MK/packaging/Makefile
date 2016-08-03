# find all .rbf files
# generate a matching dts containing the path name
# convert to dtbo under /lib/firmware/socfpga/dtbo/<rbf-basename>.dtbo

# use dtc which came with kernel:
#DTC  := /usr/src/linux-headers-$(shell uname -r)/scripts/dtc/dtc
# use the dtc from apt install device-tree-compiler
DTC := dtc

BASEDIR := /lib/firmware/socfpga
RBF_BASENAMES := $(patsubst %.rbf,%,$(patsubst $(BASEDIR)/%,%, $(wildcard $(BASEDIR)/*.rbf)))
DTBS := $(addprefix $(BASEDIR)/dtbo/, $(addsuffix .dts,$(RBF_BASENAMES)))
DTBO := $(addprefix $(BASEDIR)/dtbo/, $(addsuffix .dtbo,$(RBF_BASENAMES)))

all:	$(DTBO)

clean:
	rm -f $(DTBO)


# how to create a dts given an rbf name
$(BASEDIR)/dtbo/%.dts:  $(BASEDIR)/%.rbf
	sed "s/%FIRMWARE%/socfpga\/"$(<F)"/g" < $(BASEDIR)/dtbo/template.dts > $@

# dts files depend on the template
$(DTBS): 	$(BASEDIR)/dtbo/template.dts

# how to create a dtbo from a dts:
%.dtbo: %.dts
	$(DTC) -I dts -O dtb -@  -o $@ $<
