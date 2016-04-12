sudo apt install expat fontconfig libfreetype6 xfonts-base xfonts-tipa libc6 libgtk2.0-0 libcanberra0 libpng3 libpng12.0 libice6 libsm6 util-linux libncurses5 tcl tcllib libx11-6 libxau6 libxdmcp6 libxext6 libxft2 libxrender1 libxt6 libxtst6

#sudo apt install expat:i386 fontconfig:i386 libfreetype6:i386 libc6:i386 libgtk2.0-0:i386 libcanberra0:i386 libpng3:i386 libpng12-0:i386 libice6:i386 libsm6:i386 util-linux:i386 libncurses5:i386 tcl:i386 libx11-6:i386 libxau6:i386 libxdmcp6:i386 libxext6:i386 libxft2:i386 libxrender1:i386 libxt6:i386 libxtst6:i386
sudo apt install libfreetype6:i386 libc6:i386 libgtk2.0-0:i386 libcanberra0:i386 libpng3:i386 libpng12-0:i386 libice6:i386 libsm6:i386 libncurses5:i386 libx11-6:i386 libxau6:i386 libxdmcp6:i386 libxext6:i386 libxft2:i386 libxrender1:i386 libxt6:i386 libxtst6:i386

#sudo apt install expat:i386 fontconfig:i386 libfreetype6:i386 libc6:i386 libgtk2.0-0:i386 libcanberra0:i386

sudo apt install libncurses5:i386 tcl:i386 libx11-6:i386 libxau6:i386 libxdmcp6:i386 libxext6:i386 libxft2:i386 libxrender1:i386 libxt6:i386 libxtst6:i386

# skip
util-linux:i386

----

# Add eth0 named lan interface (fix detection of node based licenses for * mac hw address)

# replace "xx:xx:xx:xx:xx:xx"  with the real mac address of the lan interface to rename.
# AFAIK the interface renamed to eth0 does not need to be active or plugged in for the
# node locked licening to work. Also you kan install a virtual software only "dummy" 
# lan interface, and still get the licening to work.

sudo nano /etc/udev/rules.d/10-network.rules
SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="xx:xx:xx:xx:xx:xx", NAME="eth0"

mib@debian9-ws:~/$ cat /etc/udev/rules.d/92-usbblaster.rules
# USB-Blaster
SUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6001", MODE="0666"
SUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6002", MODE="0666"

SUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6003", MODE="0666"

# USB-Blaster II
SUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6010", MODE="0666"
SUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6810", MODE="0666"

mib@debian9-ws:~$ cat /etc/udev/rules.d/10-network.rules
SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="78:24:af:8f:a4:7c", NAME="eth0"


sudo udevadm control --reload
