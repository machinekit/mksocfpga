#include <iostream>
#include <sys/types.h>
#include <stdlib.h>
#include "fpga.h"
#include <stdbool.h>
#include <stdio.h>

#include <string.h>

using namespace std;

bool ADC_LTC2308_Read(int, int, u_int16_t );

bool ADC_LTC2308_Read(int ch, int nReadNum, u_int16_t szData[]){

    u_int16_t Value;
    int i;
    bool bSuccess = false, set_success = false;
    u_int32_t Timeout;
    
    FPGAFS fpga;
    // set measure number (num of samples to run);
    set_success = fpga.adcregSet(0x4,nReadNum);
    if(set_success){
	set_success = fpga.adcregSet(0x0,((ch << 1) | 0x0000));
	set_success = fpga.adcregSet(0x0,((ch << 1) | 0x0001));
	set_success = fpga.adcregSet(0x0,((ch << 1) | 0x0000));
    }

/*   
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
*/
    return set_success;
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
    
//    nActiveChannel = 3;
    nNum = sizeof(szAdcValue)/sizeof(szAdcValue[0]);

    FPGAFS fpga;
    
    if (argc >= 2) {
        option = *argv[1];
        if (option != 'w' && option != 'r' && option != 'a' && option != 'd') {
            cout<< "Invalid option for 1 argument \n" <<
            " a as argument displays all address values \n" << 
            " d as argument displays adc value \n" << 
            " r (read) + an address location displays a single location \n" << 
            " w (write) + and arddress location + writes a single location \n";
            exit(EXIT_FAILURE);
//             cout<< "Invalid option setting. " <<
//             "Option must be either r (read) or w (write)\n";
//             exit(EXIT_FAILURE);
        }
    }
    
    if (argc == 2) {
        option = *argv[1];
        if ( option != 'a' ) {
            cout<< "Invalid option for 1 argument \n" <<
            " a as argument displays all address values \n" << 
            " d as argument displays adc value \n" << 
            " r (read) + an address location displays a single location \n" << 
            " w (write) + and arddress location + writes a single location \n";
            exit(EXIT_FAILURE);
        }

	if (option == 'a'){
	    char* buf = NULL;
	    u_int16_t s_word, s_val;
//	    u_int8_t s_ch;
	    int val;
	    int readbuffsize = fpga.adcregReadall(& buf);
	    u_int16_t info_word = ((buf[1] << 8) | buf[0]);
	    u_int16_t num_samples = ((info_word >> 1) & 0x0FFF);
	    u_int16_t s_ch = ((info_word >> 13) & 0x0007);
	    
	    cout << "\nOption a: Read " << readbuffsize << " bytes" << " Got " <<  num_samples << " samples from adc ch: " << s_ch << 
	    " status word = 0x" << std::hex << info_word << " status bit = " << std::dec << (info_word & 1) << "\n";

	    for(int j=1;j<num_samples+1;j++){
		s_word = ((buf[(j*2)+1] << 8) | buf[j*2]);
		s_val = (s_word & 0x0FFF);
		s_ch = ((s_word >> 12) & 0x0007); 
		cout <<"\n" << std::dec << j << "\t" << s_ch << "\t" << s_val << "\t" << std::hex << "0x" << s_val << "\n";
//		cout <<"\n" << std::dec << j << "\t" << s_val << "\t" << std::hex << "0x" << s_val << "\n";
	    }
	    cout << "\n";
        
	    if(buf!=NULL)
	    {
		delete[] buf;
	    }
	}
    }
        
    if (argc >= 3) {
        // check the bounds of the address //
	int address_reg = atol(argv[2]);
	if (address_reg > 1) {
	    cout << "Invalid address input. \n" <<
	    "Address must be between 0 and " << 1 << " inclusive.\n";
	    exit(EXIT_FAILURE);
	}
	offset = address_reg << 2;
	cout<< "offset = " << offset << "\n";

	if (argc == 3) {
	    option = *argv[1];
	    if ( option != 'r' ) {
	      cout<< "Invalid option for 1 argument \n" <<
		" a as argument displays all address values \n" << 
		" d as argument displays adc value \n" << 
		" r (read) + an address location displays a single location \n" << 
		" w (write) + and arddress location + writes a single location \n";
		exit(EXIT_FAILURE);
	    }
	    if (option == 'r') {
		cout << "r option running \n";
		char datavalue = fpga.adcregGet(offset);
		int pval = datavalue;
		cout << "\n Register " << offset << " Value = " << pval << " \n";
	    }
	}
	else if (argc == 4) {
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
	    else if (option == 'd') {
		cout << "d option running \n";
		if (!ADC_LTC2308_Read(nActiveChannel, nNum, szAdcValue)) {
		    cout<< "failed to read \n"; 
		}
	    }
	}
    }
    cout << "\n#---------------------------------   End of adcfs adc tester  ---------------------------#\n";
}