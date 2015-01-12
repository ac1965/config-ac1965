#! /bin/sh

abort ()
{
	echo $1
	exit 0
}

f=$1
test -f $f || abort "file:$f not found."
name=`basename $f .txt`
no=0

for sm in `cat $f`; do
	no=`expr $no + 1`
	fn=`printf "%s-%02d" $name $no`
	echo nicovideo-dl -u tjy1965@gmail.com -p taka1234 "http://www.nicovideo.jp/watch/$sm" -o ${fn}.flv
	nicovideo-dl -u tjy1965@gmail.com -p taka1234 "http://www.nicovideo.jp/watch/$sm" -o ${fn}.flv
done
