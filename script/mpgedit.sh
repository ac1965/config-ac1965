#! /bin/sh

export PATH=$PATH:$HOME/bin

args="$*"
output=`echo $args | cut -d' ' -f1 | cut -d'_' -f1`

input=
for fn in $args
do
	input="${input} ${fn}"
done

echo -- cat ${input}  ${output}.mpg
cat ${input} > ${output}.mpg

case "$?" in
0)
	rm -f $args
	;;
esac	
