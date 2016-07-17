import sys
import os
import binascii
import struct
import mif
import google.protobuf.text_format
from machinetalk.protobuf.firmware_pb2 import Firmware, Connector
import subprocess

def get_git_revision_short_hash():
    return subprocess.check_output(['git', 'rev-parse', '--short', 'HEAD']).strip()

maxsize = 2048
cookie = 0xFEEDBABE
width = 32  # of MIF file
format = '<L'  # LittleEndian
#format = '>L'  # BigEndian

# construct the descriptor object
fw  = Firmware()

try:
    fw.build_sha = get_git_revision_short_hash()
except Exception:
    fw.build_sha = "not a git repo"

try:
    fw.comment = os.getenv("BUILD_URL") # jenkins job id
except Exception:
    fw.comment = "$BUILD_URL unset"

fw.fpga_part_number = "altera socfpga"
fw.num_leds = 2
fw.board_name = "Terasic DE0-Nano"

c = fw.connector.add()
c.name = "GPIO0.P2"
c.pins = 17

c = fw.connector.add()
c.name = "GPIO0.P3"
c.pins = 17

c = fw.connector.add()
c.name = "GPIO1.P2"
c.pins = 17

c = fw.connector.add()
c.name = "GPIO1.P3"
c.pins = 17


# serialize it to a blob
buffer = fw.SerializeToString()

print "%%\nsize of encoded message: %d 0x%x" % (fw.ByteSize(),fw.ByteSize())
print "text format representation:\n---\n", str(fw), "---\n"
print "wire format length=%d %s" % (len(buffer), binascii.hexlify(buffer))

# generate an Altera MIF file

# prepend with cookie and length field
blob = struct.pack(format, cookie) + struct.pack(format,  fw.ByteSize()) + buffer

assert len(blob) <= maxsize, ValueError("encoded message size too large: %d (max %d)" % (len(blob), maxsize))

print "\nsize of MIF struct including cookie and length field: %d" % (len(blob))
print "%\n\n"

mif.create(sys.stdout, width, len(blob), blob, format=format)
