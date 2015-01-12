#! /bin/sh

export PATH=$PATH:/opt/producer11

args="$*"
output=`echo $args | cut -d' ' -f1 | cut -d'-' -f1`

input=
for fn in $args
do
	input="${input} -i ${fn}"
done

echo -- rmeditor ${input} -o ${output}.rm
rmeditor ${input} -o ${output}.rm

case "$?" in
0)
	rm -f $args
	;;
esac	
