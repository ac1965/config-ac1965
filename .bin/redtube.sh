#! /bin/sh

script=$(readlink -f $(dirname $0))

curl -s -o - $1 | $script/redtube.pl 
