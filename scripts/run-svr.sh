#! /bin/bash

set -e                  # exit on error
set -o pipefail         # exit on pipeline error
set -u                  # treat unset variable as error

SYSTEM_QEMU_PATH=$(dirname $(which qemu-system-x86_64))
HACKY_QEMU_PATH=~/hacky-qemu/build

usage() {
    SCRIPT_NAME="$(basename "$(readlink -f "$0")")"
    echo "Usage: $SCRIPT_NAME [option]"
    echo "Option:"
    echo "  -s          Run system qemu"
    exit 1
}

if [[ $# > 1 ]] ; then
    usage
fi

if [[ $# == 0 ]] ; then
    QEMU_PATH=$HACKY_QEMU_PATH
elif [[ $# == 1 && $1 == "-s" ]] ; then
    QEMU_PATH=$SYSTEM_QEMU_PATH
else
    usage
fi

QEMU=$QEMU_PATH/qemu-system-x86_64

if [[ $(uname -a) == *""microsoft* ]] ; then
    echo "WSL!!!"
    OPTIONS=""
else
    echo "NO WSL!!!"
    OPTIONS="-cpu host -enable-kvm"
fi

# sudo $QEMU -cpu host -enable-kvm -smp $(nproc) -m 8G \

sudo $QEMU $OPTIONS -smp $(nproc) -m 8G \
    -drive file=system.qcow,format=qcow2,if=none,id=boot \
    -device ahci,id=ahci \
    -device ide-hd,drive=boot,bus=ahci.0 \
    -drive file=sata.raw,format=raw,if=none,id=sata \
    -device ide-hd,serial=00SATA00,drive=sata,bus=ahci.1 \
    -drive file=nvme.raw,format=raw,if=none,id=nvm \
    -device nvme,serial=00NAVMe00,drive=nvm

# Let's get it!