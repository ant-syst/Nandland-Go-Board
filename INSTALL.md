# Tools installation #

## Install Lattice iCEcube2 Software on 64 bits Ubuntu 19.04 ##

List all dynamic libraries required by the software :

```bash
ldd ./iCEcube2setup_Sep_12_2017_1708
	linux-gate.so.1 (0xf7f99000)
	libz.so.1 => not found
	libXext.so.6 => not found
	libX11.so.6 => not found
	libpng12.so.0 => not found
	libSM.so.6 => not found
	libICE.so.6 => not found
	libXi.so.6 => not found
	libXrender.so.1 => not found
	libXrandr.so.2 => not found
	libXfixes.so.3 => not found
	libXcursor.so.1 => not found
	libXinerama.so.1 => not found
	libfreetype.so.6 => not found
	libfontconfig.so.1 => not found
	libgthread-2.0.so.0 => not found
	libglib-2.0.so.0 => not found
	librt.so.1 => not found
	libdl.so.2 => not found
	libpthread.so.0 => not found
	libstdc++.so.6 => /lib32/libstdc++.so.6 (0xf78dc000)
	libm.so.6 => not found
	libgcc_s.so.1 => not found
	libc.so.6 => not found
	libxcb.so.1 => not found
	libuuid.so.1 => not found
	libbsd.so.0 => not found
	libexpat.so.1 => not found
	libpcre.so.3 => not found
	/lib/ld-linux.so.2 (0xf7f9a000)
	libXau.so.6 => not found
	libXdmcp.so.6 => not found
```

Install 32 bits support and libraries: 
```bash
sudo apt install gcc-multilib
sudo apt install lib32z1
sudo apt install lib32xext
sudo apt install libxext6:i386
sudo apt install libpng16-16:i386
sudo apt install libsm6:i386
sudo apt install libxi6:i386
sudo apt install libxrender1:i386
sudo apt install libxrandr2:i386
sudo apt install libxfixes3:i386 
sudo apt install libxcursor1:i386
sudo apt install libxinerama1:i386
sudo apt install libfreetype6:i386
sudo apt install libfontconfig1:i386
sudo apt install libglib2.0-0:i386
```

The required version of libpng (libpng-1.2.7) is not available on Ubuntu 
19.04.

We could either compile the missing version of libpng or create a 
symbolic link to replace the unavailable libpng12.so.0 library by the 
current library version (libpng16). The last solution allows to run the 
software, but, unfortunately, does not works leading to missing icons.

* Compilation 

```bash
wget https://sourceforge.net/projects/gnuwin32/files/libpng/1.2.7/libpng-1.2.7-src.zip/download
unzip download
cd src/libpng/1.2.7/libpng-1.2.7
sudo apt install zlib1g-dev
cp scripts/makefile.linux .
# Update CFLAGS to add -m32 flags
# Update all CC lines to add -m32 flags
make -f makefile.linux
sudo cp libpng*so* //lib/i386-linux-gnu/

```

* Create a symbolic link to replace the libpng12.so.0 library, which is 
not available, by the libpng16.so.

```bash
sudo ln -s /lib/i386-linux-gnu/libpng16.so /lib/i386-linux-gnu/libpng12.so.0
```

Create the fake eth0 interface used for licensing (source [source](http://insanity4004.blogspot.com/2018/03/using-lattice-icecube2-software-on.html)).
```bash
sudo modprobe dummy
sudo ip link set eth0 address 10:5c:b-:7C:47:70
sudo ip link add eth0 type dummy
```

In Ubuntu the path `/bin/sh` is a symbolic link to `/bin/dash` and 
iCEcube2 expects a symbolic link to `/bin/bash`.

Find all `/bin/sh` paths and replaces them by `/bin/bash`
```bash
cd ~/lscc/iCEcube2.2017.08/synpbase/
cp -r bin bin2
find bin -type f -exec sed -i 's/#!\/bin\/sh/#!\/bin\/bash/g' {} \;
```

## Install iceprog on archlinux ##

```bash
pacman -S libftdi
git clone https://github.com/cliffordwolf/icestorm.git icestorm
cd icestorm
make -j4
```
