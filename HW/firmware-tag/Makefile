# override as needed with 'make TOPDIR=<foo>'
TOPDIR := $(realpath ../..)

all: py-proto demo.mif


py-proto: $(TOPDIR)/HW/machinetalk-protobuf/build/python/machinetalk/protobuf/firmware_pb2.py

$(TOPDIR)/HW/machinetalk-protobuf/build/python/machinetalk/protobuf/firmware_pb2.py:
	(cd $(TOPDIR)/HW/machinetalk-protobuf; make)

demo.mif: generate.py mif.py
	@PYTHONPATH=$(TOPDIR)/HW/machinetalk-protobuf/build/python python generate.py
