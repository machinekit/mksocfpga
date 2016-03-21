#include "fpga.h"

//#include <unistd.h>
#include <sys/types.h>
//#include <sys/ioctl.h>
//#include <linux/i2c-dev.h>
//#include <fcntl.h>

#include <ios>
#include <iostream>
#include <fstream>
#include <string>

#define FILE_DEV "/sys/bus/platform/drivers/adcreg/adcreg"

using namespace std;

bool m_bInitSuccess; 

FPGAFS::FPGAFS()// :
//    m_bIsVideoEnabled(false)
{
    m_bInitSuccess = Init();
    if (!m_bInitSuccess )
        cout << "FPGAFS init failed!!!" "\n";
    else
        cout << "FPGAFS init success" << "\n ";
}

FPGAFS::~FPGAFS()
{
    close(fd);
}

bool FPGAFS::Init()
{
    bool bSuccess = false;
    fstream fileB;
    fileB.open(FILE_DEV);
    if (fileB.is_open()){
        bSuccess = true;
        fileB.close();
    }
    return bSuccess;
}

int FPGAFS::adcregSize( void ){
    int size = 0;
//    ifstream file( FILE_DEV, ios::binary | ios::ate);
    ifstream file( FILE_DEV, std::ios::binary);

    // Stop eating new lines in binary mode!!!
    file.unsetf(std::ios::skipws);

    // get its size:
    std::streampos fileSize;

    file.seekg(0, std::ios::end);
//    fileSize = file.tellg();
    size = file.tellg();
    file.seekg(0, std::ios::beg);
    
//    size = file.tellg();
    
    cout << "FPGAFS::adcregSize: page size = " << size << "\n";
    file.close();
//    if(size > 22) {std::cout << "!!! Size error \n \n" << "!!! Size error \n \n"; size = 22;}
    return size;
}

int FPGAFS::adcregReadall( char** buf){
    int insize = 0, size = 0, count = 0;
    insize = adcregSize();
    char* bufpoint = new char[insize];
//    char c;
    
    ifstream in( FILE_DEV, ios::binary  | ios::ate);
//    ifstream in( FILE_DEV, std::ios::binary);

    // Stop eating new lines in binary mode!!!
//    in.unsetf(std::ios::skipws);

    in.seekg(0);
    size = insize;

//    in.seekg(0);
    in.get(bufpoint,size);
    *buf = bufpoint;
    cout << "FPGAFS::adcregReadall: bufsize = " << size << "\n";
    in.close();
    return size;
}

char FPGAFS::adcregGet(unsigned int addr ){
    int size = adcregSize();
    char data[size];
    if (m_bInitSuccess){
       ifstream gin( FILE_DEV, ios::binary | ios::ate);
        //        fileB.open(FILE_DEV);//
//        ifstream file;
/*        if (!fi.is_open())
        {
            cout<< "Failed to open /sys/bus/platform/drivers/hmreg/hmreg for reading\r\n";
            return false;
        }
*/
//      cout << "reading value \n";
//        size = in.tellg(); 
        gin.seekg (0);
        gin.get(data,size);
//        cout << "got value ... closing file \n";
        gin.close();
        //        value = alt_read_byte((void *) ( (u_int8_t *)synthreg_mem + ( ( uint32_t )( regaddr + SYNTHREG_OFFSET) & ( uint32_t )( HW_REGS_MASK ) )) );
    }
     return data[addr];
}


bool FPGAFS::adcregSet( u_int16_t addr, u_int16_t value ){
    if (!m_bInitSuccess)
        return false;
    ofstream fileB( FILE_DEV, ios::binary | ios::ate);
//    fileB.open(FILE_DEV);//
    if (!fileB.is_open())
    {
        cout<< "Failed to open" << FILE_DEV << " for writing\r\n";
        return false;
    }
    cout << "\n" << "in adcresSet addr = " << addr << "\tvalue = " << value << "\n";
    fileB.seekp(0);
//    fileB << addr << value;
    fileB.put(addr & 0x00FF);
    fileB.put((addr & 0xFF00) >> 8);
    fileB.put(value & 0x00FF);
    fileB.put((value & 0xFF00) >> 8);
    fileB.close();
    //   alt_write_byte((void *) ( (u_int8_t *)synthreg_mem + ( ( uint32_t )( regadr + SYNTHREG_OFFSET) & ( uint32_t )( HW_REGS_MASK ) )) , value );
    return true;
}


