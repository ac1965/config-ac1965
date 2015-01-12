#! /bin/sh

fnames="$@"

for f in $fnames
do
    echo - $f
    suffix=`echo $f | awk -F"." '{print $NF}'`
    case "$suffix" in
	flv)
	    ffmpeg -i $f -acodec copy `basename $f .flv`.mp3;;
    esac
done
