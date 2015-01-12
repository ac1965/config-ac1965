#! /bin/sh

#bt="00:1D:FD:91:A8:12"
bt="F8:DB:7F:06:6E:15"

case "$1" in
umount)
	test -d ~/mnt/n82 && fusermount -u ~/mnt/n82
	;;
mount)
	test -d ~/mnt/n82 && obexfs -b $bt ~/mnt/n82
	;;
*)
	echo "usage: `basename $0` [mount|umount]"
	;;
esac
