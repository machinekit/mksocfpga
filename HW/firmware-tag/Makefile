# override as needed with 'make TOPDIR=<foo>'
TOPDIR := $(realpath ../..)

all: py-proto example.mif


py-proto: $(TOPDIR)/HW/machinetalk-protobuf/build/python/machinetalk/protobuf/firmware_pb2.py

$(TOPDIR)/HW/machinetalk-protobuf/build/python/machinetalk/protobuf/firmware_pb2.py:
	(cd $(TOPDIR)/HW/machinetalk-protobuf; make)

example.mif: genfwid.py mif.py
	python genfwid.py 7I76_7I76_7I76_7I76

