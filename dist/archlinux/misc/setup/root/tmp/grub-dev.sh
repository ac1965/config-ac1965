#! /bin/sh

enc_dev=/dev/sdb2
key_dev=/dev/sdb1

enc_uuid=$(blkid $enc_dev | cut -d' ' -f2|sed 's/UUID="\(.*\)"/\1/')
key_uuid=$(blkid $key_dev | cut -d' ' -f2|sed 's/UUID="\(.*\)"/\1/')

# GRUB_CMDLINE_LINUX="cryptdevice=/dev/disk/by-uuid/ENC-ROOTDEV-UUID:arch cryptkey=/dev/disk/by-uuid/KEY-DEV-UUID:ext4:abc.jpg"

grub=/root/tmp/grub
test -f $grub && (
	cp $grub ${grub}.bak
	sed -i 's/ENC-ROOTDEV-UUID/'$enc_uuid'/' ${grub}
	sed -i 's/KEY-DEV-UUID/'$key_uuid'/' ${grub}
  	mv $grub /etc/default
)
