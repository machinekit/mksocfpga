#include <iostream>
#include <sys/types.h>
#include <stdlib.h>
#include "fpga.h"
#include <stdbool.h>
#include <stdio.h>

using namespace std;

bool ADC_LTC2308_Read(int, int, u_int16_t );

bool ADC_LTC2308_Read(int ch, int nReadNum, u_int16_t szData[]){

    u_int16_t Value;
    int i;
    bool bSuccess = false;
    u_int32_t Timeout;
    
    FPGAFS fpga;
    cout << "will now nReadnum \n";
    fpga.adcregSet(0x01, nReadNum);

    cout << "Starting measurement \n";
    // start measure
    fpga.adcregSet(0x00, (ch << 1) | 0x00);
    fpga.adcregSet(0x00, (ch << 1) | 0x01);
    fpga.adcregSet(0x00, (ch << 1) | 0x00);
    
    usleep(1);

    // wait measure done
//    Timeout = alt_nticks() + alt_ticks_per_second()/2;
//    while ( ((fpga.adcregGet(0x00) & 0x01) == 0x00) && (alt_nticks() < Timeout)){
    while ( fpga.adcregGet(0x00 & 0x01) == 0x00) {

    }

    if ((fpga.adcregGet(0x00) & 0x01) == 0x01) {
	bSuccess = true;
    }
	// read adc value
    if (bSuccess) {
      for(i=0;i<nReadNum;i++) {
	Value = fpga.adcregGet(0x01);
	szData[i] = Value;
	//printf("CH%d=%.3fV\r\n", ch, (float)Value/1000.0);
      }
      return bSuccess;
    }
}

int main (int argc, char *argv[] ) {
    cout << "\n#--------------------------------  Welcone to adcfs adc tester --------------------------#\n";
    cout << "Input "<< argc << " Arguments::--> ";//  << " arguments:" << cout;
    for (int i = 0; i < argc; ++i) {
        cout<< argv[i] << " ";
    }
    cout << "\n";
    
    int ret = EXIT_FAILURE;
    unsigned char  option;
    u_int16_t value, offset;
    int index;

    int	nNum;
    u_int16_t szAdcValue[10];
    int nActiveChannel;
    
    nActiveChannel = 3;
    nNum = sizeof(szAdcValue)/sizeof(szAdcValue[0]);
    
    if (argc == 2) {
        option = *argv[1];
        if ( option != 'a' && option != 'd') {
            cout<< "Invalid option for 1 argument \n" <<
            " a as argument displays all address values \n" << 
            " d as argument displays adc value \n" << 
            " r (read) + an address location displays a single location \n" << 
            " w (write) + and arddress location + writes a single location \n";
            exit(EXIT_FAILURE);
        }
    }
    
    
    if (argc >= 2) {
        option = *argv[1];
        if (option != 'w' && option != 'r' && option != 'a' && option != 'd') {
            cout<< "Invalid option setting. " <<
            "Option must be either r (read) or w (write)\n";
            exit(EXIT_FAILURE);
        }
    }
        
    if (argc >= 3) {
        // check the bounds of the address //
        offset = atol(argv[2]);
        if (offset > ((addr_size / 2)-1)) {
            cout << "Invalid offset input. \n" <<
            "Address must be between 0 and " << ((addr_size / 2) -1) << " inclusive.\n";
            exit(EXIT_FAILURE);
        }
        cout<< "offset = " << offset << "\n";
        
    }

    FPGAFS fpga;
    
    if (argc == 4) {
        // check the bounds of the value being set //
        value = atol(argv[3]);
        if (value > 4095) {
            cout << "Invalid number setting. " <<
            "Value must be between 0 and 4095, inclusive.\n";
            exit(EXIT_FAILURE);
        }
    
	if (option == 'w') {
	    cout << "w option running \n";
	    char datavalue = fpga.adcregSet(offset,value);
	    int pval = datavalue;
	    cout << "\n Register " << offset << " Set Value = " << value << " adcregSet return value = "<< pval << " \n";
	}
    }

    
    if (option == 'a'){
        char* buf = NULL;
//        int buffsize = fpga.adcregReadall(& buf);
        int buffsize = fpga.adcregSize();
        cout << "File Size = " << buffsize << " \n";
        int val;
	int readbuffsize = fpga.adcregReadall(& buf);
	cout << "(readbuffsize) Got " << readbuffsize << " bytes \n";
        cout << "Buff Size = " << buffsize << " \n";
	for(int j=0;j<(addr_size/2);j++){
            cout <<"\n" << std::dec << j << "\t";
            for(int i=0;i<2;i++){
                val = buf[i+(j*2)];
                if (i==2) cout <<"\t";
                cout << std::hex << val  << "\t";
                cout << std::dec ;
            }
        }
        cout << "\n";
        
        if(buf!=NULL)
        {
            delete[] buf;
        }
    }
    else if (option == 'r') {
        cout << "r option running \n";
        char datavalue = fpga.adcregGet(offset);
        int pval = datavalue;
        cout << "\n Register " << offset << " Value = " << pval << " \n";
    }
    
    else if (option == 'd') {
        cout << "d option running \n";
	if (!ADC_LTC2308_Read(nActiveChannel, nNum, szAdcValue)) {
	    cout<< "failed to read \n"; 
	}
//        char datavalue = fpga.adcregGet(offset);
//        int pval = datavalue;
//        cout << "Register " << offset << " Value = " << pval << " \n";
    }
    
    
//    cout << "Hmmm = \n";
    
    /*    printf("Hello\n");
    int fd, ret = EXIT_FAILURE;
    unsigned char  value,option,datavalue;
    uint16_t  offset;
    int index;
    off_t hmreg_base = (LWHPS2FPGA_BRIDGE_BASE);// + HMREG_OFFSET);
    printf("Welcome \n");

    // open the memory device file //
    fd = open("/dev/mem", O_RDWR|O_SYNC);
    if (fd < 0) {
        perror("open");
        exit(EXIT_FAILURE);
    }
    
    // map the LWHPS2FPGA bridge into process memory //
    bridge_map = mmap(NULL, PAGE_SIZE, PROT_WRITE, MAP_SHARED,
                      fd, hmreg_base);
    if (bridge_map == MAP_FAILED) {
        perror("mmap");
        goto cleanup;
    }
    
    // get the registers peripheral's base offset //
    hmreg_mem = (unsigned char *) (bridge_map + HMREG_OFFSET);
    
    else if (option == 'w' && argc == 4){
        *(hmreg_mem + offset) = value;
        printf("Value %d written to 0x%x\n",value,offset);
    }
    else if (option == 'a'){
        for(index=0;index<256;index++) {
            datavalue = *(hmreg_mem + index);
            printf("Register 0x%x Value = 0x%x \n",index,datavalue);
        }
    }
    
    if (munmap(bridge_map, PAGE_SIZE) < 0) {
        perror("munmap");
        goto cleanup;
    }
    
    ret = 0;
    
    cleanup:
    close(fd);
    return ret;
*/

    cout << "\n#---------------------------------   End of adcfs adc tester  ---------------------------#\n";

}