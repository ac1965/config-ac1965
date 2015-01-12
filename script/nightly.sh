#! /bin/sh

dt=$(date +"%Y%m%d")

android=${HOME}/android
srcd=${android}/system/out/target/product/ace
dstd=${android}/ROM/CyanogenMod

SRCROM=update-cm-7.1.0-RC1-DesireHD-KANG-signed.zip
DSTROM=update-cm-7.1.0-RC1-DesireHD-KANG_${dt}-signed.zip

abort ()
{
	echo "$1"
	exit 1
}

copyf ()
{
	echo "$1 .. $2"
	cp $1 $2
}

test -d $srcd || abort "$srcd not found."
test -d $dstd || install -d $dstd
test -f ${srcd}/${SRCROM} && \
	copyf ${srcd}/${SRCROM} ${dstd}/${DSTROM}
exit 0
