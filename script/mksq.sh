#! /bin/sh
 
dt=`date +%Y%m%d`
size=65536
  
test -f funtoo-${dt}.sqfs && mv funtoo-${dt}.sqfs funtoo-${dt}.sqfs.old

mksquashfs funtoo funtoo-${dt}.sqfs -b $size
