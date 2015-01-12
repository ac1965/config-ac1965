#! /bin/sh

script=$(readlink -f $(dirname $0))

#if [ $# -eq 1 ]; then
#    if [ -f $1 ]; then
        lists=$(curl -s -o - $1 | redtube-page.pl)
        for l in $lists
        do
           echo -- $l 
           echo http://www,redtube.com/$l >> ~/tmp/url.txt
           $script/redtube.sh http://www.redtube.com/$l
        done
#    fi
#fi

