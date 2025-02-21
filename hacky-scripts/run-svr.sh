#! /bin/bash

~/qemu/build/qemu-system-x86_64 -cpu host -enable-kvm -smp $(nproc) -m 8G \
    -drive file=system.qcow,format=qcow2,if=virtio,id=boot \
    -device ahci,id=ahci \
    -device ide-hd,drive=boot,bus=ahci.0 \
    -drive file=sata.raw,format=raw,if=none,id=sata \
    -device ide-hd,drive=sata,bus=ahci.1 \
    -drive file=nvme.raw,format=raw,if=none,id=nvm \
    -device nvme,serial=deadbeef,drive=nvm
