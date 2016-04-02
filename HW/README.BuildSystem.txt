Build System Install Notes
==========================

How to create a Debian based Quartus system to build the FPGA code
  Debian Jessie
  Quartus 15.1.2

Install Debian Jessie amd64 via net install on your favorite platform
  Full details can be found elsewhere
  I used VirtualBox and the netboot mini.iso installer
  Install the base system
    Username: builder
    Password: builder
  Install software selections:
    SSH server
    standard system utilities
    *NO* Desktop selected! (unless you want *LOTS* of extra stuff)

Install additional required Debian packages:
  git
  make
  libsm6

Obtain the Quartus install files from:
http://dl.altera.com/15.1/?edition=lite&platform=linux&download_manager=direct

  Quartus Prime:
  Size: 1.7 GB MD5: CC8BFDE25F57C2F05D1753882BC9607A
  QuartusLiteSetup-15.1.0.185-linux.run

  Cyclone V device support:
  Size: 1.1 GB MD5: 7F108A307455ACDC3CF6DA21B1FBF211
  cyclonev-15.1.0.185.qdz

  Quartus Prime Software v15.1 Update 2
  Size: 4.1 GB MD5: EECCEF76A26E98E8022C59C7491FC215
  QuartusSetup-15.1.2.193-linux.run

Connect to the system via ssh with X11 port-forwarding
(the Altera install scripts launch "pop-up" windows)

Install the Quartus tools:
./QuartusLiteSetup-15.1.0.185-linux.run

Add the Quartus tools to your path:
  # This assumes the default install location for user "builder".  Adjust as
  # necessary for your system
  export PATH="$PATH:/home/builder/altera_lite/15.1/quartus/bin:/home/builder/altera_lite/15.1/quartus/sopc_builder/bin"

Enable Talkback:
  tb2_install

Grab the source code:

  git clone https://github.com/the-snowwhite/mksocfpga.git

Build the bitfile:

  cd mksocfpga/HW/QuartusProjects/DE0_NAN0_SOC_GHRD
  make sof
  ...wait...
  ...wait...
  ...wait...
  <ding>  If all went well, your chip is ready!


