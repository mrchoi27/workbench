
# generate disks
qemu-img create -format raw sata.raw 10G
qemu-img create -format raw nvme.raw 10G

# build qemu
./configure --target-list=x86_64-softmmu --enable-slirp
make -j $(nproc)

# misc
sudo apt install at-spi2-core
