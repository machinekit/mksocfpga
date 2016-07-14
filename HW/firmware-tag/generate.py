
limit = 2048

import sys
import os
import binascii
import struct
import google.protobuf.text_format
from   intelhex import IntelHex
import mif

from machinetalk.protobuf.firmware_pb2 import Firmware, Connector

# construct the descriptor object
fw  = Firmware()

fw.build_sha = "e6a72edd67601b36cf7c6b2a31ba4cc9e9324b43"
fw.fpga_part_number = "altera socfpga whatever"
fw.num_leds = 2
fw.board_name = "Terasic DE0-Nano"
fw.comment = "mystery firmware"

c = fw.connector.add()
c.name = "GPIO0.P2"
c.pins = 17

c = fw.connector.add()
c.name = "GPIO0.P3"
c.pins = 17


print "size of encoded blob: %d 0x%x" % (fw.ByteSize(),fw.ByteSize())
print "text format representation:\n---\n", str(fw), "---\n"

# serialize it to a blob
buffer = fw.SerializeToString()
print "wire format length=%d %s" % (len(buffer), binascii.hexlify(buffer))


# place the blob size as uint32 at loadaddr
# place the actual blob at loadaddr + 4

ih = IntelHex()
loadaddr = 0x400  # I'm making something up
format = '<I'     # uint32 little endian blob size

# place the blob length
ih.puts(loadaddr, struct.pack(format,  fw.ByteSize()))

# followed by actual blob
ih.puts(loadaddr + 4, buffer)

print "blob ranges from 0x%x to 0x%x" % (ih.minaddr(), ih.maxaddr())
print "addresses:", ih.addresses()
print "segments:", ih.segments()

ih.tofile("foo.hex", format='hex')
ih.tofile("foo.bin", format='bin')

# read back from the hex file
rb = IntelHex("foo.hex")
rb.dump()

# generate an Altera MIF file, width 32
width = 32
# prepend length field
blob = struct.pack(format,  fw.ByteSize()) + buffer

assert len(blob) <= limit

mif.create(sys.stdout, width, len(blob), blob)
