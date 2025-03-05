#! /bin/bash

: ${QEMU_PATH:=~/hacky-qemu/build}

QEMU=$QEMU_PATH/qemu-system-x86_64

if [[ $(uname -a) == *""microsoft* ]] ; then
    echo "WSL!!!"
else
    echo "NO WSL!!!"
    : ${OPTIONS:="-cpu host -enable-kvm"}
fi

# sudo $QEMU -cpu host -enable-kvm -smp $(nproc) -m 8G \

sudo $QEMU $OPTIONS -smp $(nproc) -m 8G \
    -drive file=system.qcow,format=qcow2,if=none,id=boot \
    -device ahci,id=ahci \
    -device ide-hd,drive=boot,bus=ahci.0 \
    -drive file=sata.raw,format=raw,if=none,id=sata \
    -device ide-hd,drive=sata,bus=ahci.1 \
    -drive file=nvme.raw,format=raw,if=none,id=nvm \
    -device nvme,serial=deadbeef,drive=nvm

# Let's get it!