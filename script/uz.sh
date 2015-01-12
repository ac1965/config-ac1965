#!/bin/sh

files="$@"

for f in $files
do
    suffix=`echo $f | cut -d'.' -f2`
    if [ $suffix == "zip" ]; then
	echo - $f
	unzip $f
	rm -f *.html >/dev/null 2>&1
	rm -f *.htm >/dev/null 2>&1
	rm -f *.url >/dev/null 2>&1
	rm -f $f
    fi
done
