#! /bin/bash

~/qemu/build/qemu-system-x86_64 -M q35 -smp $(nproc) -m 8G \
    -drive file=disk-svr.qcow,if=none,id=boot \
	-device ahci,id=ahci \
	-device ide-hd,drive=boot,bus=ahci.0 \
    -drive file=sata.qcow,if=none,id=sata \
	-device ide-hd,drive=sata,bus=ahci.1 \
    -drive file=nvm.qcow,if=none,id=nvm \
    -device nvme,serial=deadbeef,drive=nvm
