import sys
import os
import binascii
import struct
import mif
import argparse
import google.protobuf.text_format

# path to generated protobuf imports
sys.path.insert(0, os.path.abspath(os.path.dirname(os.path.abspath(__file__)) + "../../machinetalk-protobuf/build/python"))


maxsize = 2048
cookie = 0xFEEDBABE
width = 32  # of MIF file
format = '<L'  # LittleEndian


parser = argparse.ArgumentParser()
parser.add_argument("config")
args = parser.parse_args()


# one file per config, name <config>.py - eg 7I76_7I76_7I76_7I76.py
fwid = __import__(args.config)
fw = fwid.gen_fwid()

# serialize it to a blob
buffer = fw.SerializeToString()

print "%%\nconfig argument: %s" % (args.config)
print "\nsize of encoded message: %d 0x%x" % (fw.ByteSize(),fw.ByteSize())
print "text format representation:\n---\n", str(fw), "---\n"
print "wire format length=%d %s" % (len(buffer), binascii.hexlify(buffer))

# generate the Altera MIF file
# prepend with cookie and length field
blob = struct.pack(format, cookie) + struct.pack(format,  fw.ByteSize()) + buffer

assert len(blob) <= maxsize, ValueError("encoded message size too large: %d (max %d)" % (len(blob), maxsize))

print "\nsize of MIF struct including cookie and length field: %d" % (len(blob))
print "%\n\n"

mif.create(sys.stdout, width, len(blob), blob, format=format)
