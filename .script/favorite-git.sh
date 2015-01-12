#! /bin/sh

abort () {
    echo $*
    exit
}

text=${HOME}/tmp/favorite-git.txt

test -f $text || abort "${text} not found."

test -d $HOME/archives || install -d $HOME/archives

test -d $HOME/archives || install -d $HOME/archives
test -d $HOME/archives/ac1965/config-ac1965/tmp && cp ${HOME}/tmp/favorite-git.txt $HOME/archives/ac1965/config-ac1965/tmp

for u in $(egrep -v '^(#|$)' $text| grep ^http)
do
    cd $HOME/archives
    p=$(echo $u | cut -d'/' -f4)
    r=$(basename $(echo $u | cut -d'/' -f5) .git)
    echo -- $u -- $p -- $r
    test -d $p || install -d $p
    cd $p 
    (test -d $r/.git && git update || git clone $u) >/dev/null 2>&1
    cd - > /dev/null
done
