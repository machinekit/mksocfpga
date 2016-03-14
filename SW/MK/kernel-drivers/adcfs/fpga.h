#ifndef FPGA_H
#define FPGA_H

#include <unistd.h>
#include <stdbool.h>
#include <sys/types.h>

#define addr_size 32

class FPGAFS
{
public:
    FPGAFS();
    ~FPGAFS();
    int adcregSize( void );
    int adcregReadall( char** );
    char adcregGet( unsigned int addr );
    bool adcregSet(u_int16_t , u_int16_t);


protected:
    bool m_bInitSuccess;
    int fd;
//    bool m_bIsVideoEnabled;
//    u_int8_t *s_synthreg_base;
    bool Init();

};

#endif // FPGA_H
