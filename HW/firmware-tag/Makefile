# override as needed with 'make TOPDIR=<foo>'
TOPDIR := /home/mah/mk-src/mksocfpga

all: py-proto demo


py-proto: $(TOPDIR)/HW/machinetalk-protobuf/build/python/machinetalk/protobuf/firmware_pb2.py
	(cd $(TOPDIR)/HW/machinetalk-protobuf; make)

demo:
	PYTHONPATH=$(TOPDIR)/HW/machinetalk-protobuf/build/python python generate.py
