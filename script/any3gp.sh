#! /bin/sh

fnames="$@"

for f in $fnames
do
    echo - $f
    suffix=`echo $f | awk -F"." '{print $NF}'`
    ffmpeg -i $f \
    	-vcodec mpeg4 -acodec aac -f 3gp \
	`basename $f .${suffix}`.3gp
#    	-y -async 1 -vcodec mpeg4 -s 240x176 -r 29.97 -b 512 \
#	-acodec aac -ac 1 -ar 48000 -ab 96 -f 3gp \
done
