#! /bin/sh

case "$1" in
umount)
	umount /mnt/win
	cryptsetup luksClose win
	;;
""|mount)
	cryptsetup luksOpen /dev/sdc1 win
	test -d /mnt/win || install -d /mnt/win
	ntfs-3g /dev/mapper/win /mnt/win
	;;
*)
	echo "`basename $0` [mount|umount]"
	;;
esac
