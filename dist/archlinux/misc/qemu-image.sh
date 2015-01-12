#!/bin/sh

QEMU="qemu-system-x86_64"

# qemu -m 512 -net nic,model=rtl8139 -net user -drive cache=writeback,index=0,media=disk,file=$(echo debian-hurd-*.img)
if [ "$#" -eq 1 ]; then
    image=$1
    test -f $image || exit
    #$QEMU -boot c /dev/cdrom -hda $image -user net -m 512
    $QEMU -m 1024 -net nic,model=rtl8139 -net user -drive cache=writeback,index=0,media=disk,file=$image -redir tcp:8000::8000 -redir tcp:2022::22 
fi
