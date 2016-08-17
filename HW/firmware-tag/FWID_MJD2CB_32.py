from machinetalk.protobuf.firmware_pb2 import Firmware, Connector
from util import get_git_revision_short_hash, get_build_url


def gen_fwid(*args,**kwargs):
    # construct the descriptor object
    fw  = Firmware()
    fw.build_sha = get_git_revision_short_hash()
    fw.comment = get_build_url()

    fw.fpga_part_number = "7z010"
    fw.num_leds = 0
    fw.board_name = "JDCBM"

    c = fw.connector.add()
    c.name = "GPIO0.P1"
    c.pins = 32

    return fw
