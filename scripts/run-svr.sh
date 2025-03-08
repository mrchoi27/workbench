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

QEMU_PATH=$HACKY_QEMU_PATH
while getopts "s" opt; do
    case $opt in
        s)
            QEMU_PATH=$SYSTEM_QEMU_PATH
            ;;
        \?)
            usage
            ;;
    esac
done

QEMU=$QEMU_PATH/qemu-system-x86_64

if [[ $(uname -a) == *""microsoft* ]] ; then
    echo "[+] Environment = WSL!!!"
    OPTIONS="-cpu host"
    CORES=$(nproc)
elif [[ $(uname -a) == *"Darwin"* ]] ; then
    echo "[+] Environment = macOS!!!"
    OPTIONS="-cpu Westmere"
    CORES=$(sysctl -n hw.ncpu)
else
    echo "[+] Environment = Native!!!"
    OPTIONS="-cpu host -enable-kvm"
    CORES=$(nproc)
fi

$QEMU $OPTIONS -smp $CORES -m 8G \
    -drive file=system.qcow2,format=qcow2,if=none,id=boot \
    -device ahci,id=ahci \
    -device ide-hd,drive=boot,bus=ahci.0 \
    -drive file=sata.raw,format=raw,if=none,id=sata \
    -device ide-hd,serial=-=SATA=-,drive=sata,bus=ahci.1 \
    -drive file=nvme.raw,format=raw,if=none,id=nvm \
    -device nvme,serial=-=NAVMe=-,drive=nvm \
    -netdev user,id=usernet,hostfwd=tcp::22-:22 \
    -device e1000,netdev=usernet
