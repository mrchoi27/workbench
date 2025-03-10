
# generate disks
qemu-img create -format raw sata.raw 10G
qemu-img create -format raw nvme.raw 10G


# build qemu on linux - https://wiki.qemu.org/Hosts/Linux
## required packages
sudo apt-get install git libglib2.0-dev libfdt-dev libpixman-1-dev zlib1g-dev ninja-build
sudo apt install at-spi2-core

# configure
./configure --target-list=x86_64-softmmu --enable-slirp --enable-debug

# compile
make -j $(nproc)


# build qemu on macOS - https://wiki.qemu.org/Hosts/Mac
## required packages
libffi, gettext, glib, pkg-config, pixman, ninja, meson

# compile
make -j $(sysctl -h hw.ncpu)