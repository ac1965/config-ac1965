#! /bin/sh

build="~iso"
arch="core2_32" export arch
#snapshot="funtoo"
snapshot="~funtoo"
date='2010.11.19'
startdate=$(date +%Y.%m.%d) export startdate

test -d /home/mirror/linux/$snapshot/$arch/$snapshot-$arch-$date || (
	mkdir -p /home/mirror/linux/$snapshot/$arch/{.control/{version,strategy},$snapshot-$arch-$date}
	wget -O /home/mirror/linux/$snapshot/$arch/$snapshot-$arch-$date/stage3-$arch-$date.tar.xz \
		http://distro.ibiblio.org/pub/linux/distributions/funtoo/$snapshot/$arch/$snapshot-$arch-$date/stage3-$arch-$date.tar.xz
)

test "$?" -eq 0 || exit
cd /home/mirror/linux/$snapshot/$arch/.control
echo $date > version/stage3
echo local > strategy/build
echo stage3 > strategy/seed

test -d /root/metro || (
	git clone git://github.com/theappleman/metro.git /root/metro
)

cd /root/metro
#git checkout -b squashfs origin/squashfs

test -h /usr/bin/metro || ln -s /root/metro/metro /usr/bin/metro
test -h /usr/lib/metro || ln -s /root/metro /usr/lib/metro

test $? -eq 0 && emerge -1u app-cdr/cdrtools sys-boot/syslinux sys-fs/squashfs-tools

test $? -eq 0 && /usr/lib/metro/scripts/ezbuild.sh $build $arch

test $? -eq 0 && \
	/usr/lib/metro/scripts/mklivemedia.sh bin: /usr/share/syslinux/isolinux-debug.bin \
		out:  /home/mirror/linux/$snapshot/$arch/$snapshot-$arch-$startdate/install-$arch-$startdate.iso \
		sqfs: /home/mirror/linux/$snapshot/$arch/$snapshot-$arch-$startdate/stage5-$arch-$startdate.squashfs \
			/home/mirror/linux/$snapshot/$arch/$snapshot-$arch-$startdate/stage3-$arch-$startdate.tar.xz

# cdrecord dev=/dev/cdrom /home/mirror/linux/$snapshot/$arch/$snapshot-$arch-$startdate/install-$arch-$startdate.iso
