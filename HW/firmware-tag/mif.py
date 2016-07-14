#!/usr/bin/env python
# lifted from https://www-asim.lip6.fr/svn/dsx/dsx/trunk/dsx/lib/python/bintools/mif.py

__all__ = ['create']

import struct

def emit_mif_internal(fd, data, width = 4):
    addr = 0
    while data:
        word = data[:4]
        data = data[4:]
        if len(word) < 4:
            word = word + "\x00"*(4-len(word))
        wval, = struct.unpack('>L', word)
        print >> fd, '  %04x : %08x;'%( addr, wval )
        addr += 1
    return addr

def create(fd, width, depth, data):
    assert width%8 == 0, ValueError("width must be *8")
    print >> fd, "WIDTH=%d;" % width
    print >> fd, "DEPTH=%d;" % ( depth / (width / 8) )
    print >> fd
    print >> fd, "ADDRESS_RADIX=HEX;"
    print >> fd, "DATA_RADIX=HEX;"
    print >> fd
    print >> fd, "CONTENT BEGIN"
    end_addr = emit_mif_internal(fd, data)
    if end_addr < depth/(width/8)-1:
        print >> fd, "  [%04x .. %04x] : %08x;" % (end_addr, depth/(width/8)-1, 0)
    print >> fd, "END;"


def _main():
    import sys
    create(sys.stdout,
           int(sys.argv[2]),
           int(sys.argv[3]),
           open(sys.argv[1]).read())

if __name__ == '__main__':
    _main()
    
