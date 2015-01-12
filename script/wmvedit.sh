#! /bin/sh

export PATH=$PATH:$HOME/bin

args="$*"
output=`echo $args | cut -d' ' -f1 | cut -d'-' -f1`

input=
for fn in $args
do
	input="${input} -i ${fn}"
done

echo -- asfbin-bin ${input} -o ${output}.wmv
asfbin-bin ${input} -o ${output}.wmv

case "$?" in
0)
	rm -f $args
	;;
esac	
