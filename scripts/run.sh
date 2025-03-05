#! /bin/bash

~/qemu/build/qemu-system-x86_64 -M q35 -smp 4 -m 4G \
	-drive file=nvm.qcow,if=none,id=nvm \
	-device nvme,serial=deadbeef,drive=nvm \
	-cdrom ubuntu-21.10-desktop-amd64.iso
