#! /bin/sh

if [ $# -ne 2 ]; then
    echo usage : $(basename $0) DEVICE-NAME '[open|close]'
    exit 1
fi

if [ -b $1 ]; then
    type=$(blkid $1 | cut -d'"' -f4)
    base=$(basename $1)
    if [ $type = "crypto_LUKS" ]; then
	case $2 in
	    open)
		cryptsetup luksOpen $1 xx
		case "$?" in
		    0)
			fstype=$(blkid /dev/mapper/xx | sed 's/"//g' | cut -d= -f3 | cut -d' ' -f1)
			option=
			test -d /mnt/$base || mkdir -p /mnt/$base
			case $fstype in
			    ntfs)
				option="-o nls=utf8,uid=1000,gid=100,umask=02"
				;;
			esac
			mount /dev/mapper/xx $option /mnt/$base
			;;
		esac
		;;
	    close)
		map=$(mount | grep $base | cut -d' ' -f1)
		if [ $map == "/dev/mapper/xx" ]; then
		    umount /mnt/$base
		    cryptsetup luksClose xx
		fi
		;;
	esac
    else
	echo "$1 is not crypted device."
	exit 1
    fi
else
    echo "$1 is not block device."
    exit 1
fi
