# compile all .dts files into .dtbo (device tree overlays)
#
# use dtc which came with kernel:
DTC  := /usr/src/linux-headers-$(shell uname -r)/scripts/dtc/dtc
DTBS := $(wildcard *.dts)
DTBO := $(patsubst  %.dts, %.dtbo, $(wildcard *.dts))

%.dtbo: %.dts
	$(DTC) -I dts -O dtb -@  -o $@ $<

all: $(DTBO)

clean:
	rm -f $(DTBO)


