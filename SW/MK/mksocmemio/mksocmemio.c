
#include <stdio.h>
#include <stdlib.h>

#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include "hwlib.h"
#include "socal/socal.h"
#include "socal/hps.h"

#define HW_REGS_BASE ( ALT_STM_OFST )
#define HW_REGS_SPAN ( 65536 )
#define HW_REGS_MASK ( HW_REGS_SPAN - 1 )

//#define MAX_ADDR 65533 (higher creates no output error)
#define MAX_ADDR 1020
void usage(void);

void usage(void)
{
	printf("Usage:\n");
	printf(" -r address \n");
	printf(" -w address \n");
	exit (8);
}


int main ( int argc, char *argv[] )
{
    void *virtual_base;
    void *h2p_lw_axi_mem_addr=NULL;
    int fd;

    printf("    mksocfpgamemio: read write hm2 memory locatons by cmmandline arguments  \n");

    // Open /dev/uio0
    if ( ( fd = open ( "/dev/uio0", ( O_RDWR | O_SYNC ) ) ) == -1 ) {
        printf ( "    ERROR: could not open \"/dev/uio0\"...\n" );
        return ( 1 );
    }
    printf("    /dev/uio0 opened fine OK \n");

    // get virtual addr that maps to physical
    virtual_base = mmap( NULL, HW_REGS_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, 0);

    if ( virtual_base == MAP_FAILED ) {
        printf ( "    ERROR: mmap() failed...\n" );

        close ( fd );
        return ( 1 );
    }
    printf("    region mmap'ed  OK \n");

    // Get the base address that maps to the device
    //    assign pointer
    h2p_lw_axi_mem_addr=virtual_base;// + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + HM2REG_IO_0_BASE ) & ( unsigned long)( HW_REGS_MASK ) );

    printf("    mem pointer created OK\n");

    uint32_t index = (uint32_t) strtol(argv[2], NULL, 16);

    uint32_t value = *((uint32_t *)(h2p_lw_axi_mem_addr + index));


    printf("Program name: %s    input option = %c \n", argv[0], argv[1][1]);

	switch (argv[1][1])
	{
		case 'r':
			printf("Read only \n");
			printf("Address %u \tvalue = 0x%08X \tdecimal = %u \n", index, value, value);
			break;

		case 'w':
			printf("read Write read  \n");
			printf("Address %u will be set to \tvalue = 0x%08X \tdecimal = %u \n", index, value, value);
			uint32_t inval = (uint32_t) atoi(argv[3]);
			uint32_t oldval = *((uint32_t *)(h2p_lw_axi_mem_addr + index));
			*((uint32_t *)(h2p_lw_axi_mem_addr + index)) = inval;
			value = *((uint32_t *)(h2p_lw_axi_mem_addr + index));
			printf("Address %u \tformer val = 0x%08X \t wrote: --> 0x%08X \tdecimal = %u \t read: = 0x%08X \tdecimal = %u \n", index, oldval, inval, inval, value, value);
			break;

		default:
			printf("Wrong Argument: %s\n", argv[1]);
			usage();
	}
    return (0);
}