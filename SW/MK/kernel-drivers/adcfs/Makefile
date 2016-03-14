# obj := adcfs.o

#KERNEL_SRC_DIR=/home/mib/Development/Projects/arm-linux-gnueabifh-kernel/linux
#PWD=$(shell pwd)
CROSS_C=/home/mib/Development/Beta3_Project/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux/bin/arm-linux-gnueabihf-
CC=$(CROSS_C)g++

all:  adcfs

adcfs:  main.o adcfs.o
	$(CC) -o adcfs main.o adcfs.o
	
main.o: main.cpp
	$(CC) -c main.cpp

adcfs.o: adcfs.cpp
	$(CC) -c adcfs.cpp

clean:
	rm -rf *.o
	rm -rf adcfs
