#! /bin/sh

abort () {
    echo $@
    exit
}

usage () {
    echo usage: $0 from to 
    echo  dd command show progress copy bar with status.
    exit
}

[[ $(type -p pv) ]] || abort "pv not found."

if [ $# -ne 2 ]; then
    usage
else
    from=$1
    to=$2
    [[ -f $from ]] || abort "$from not exist."
fi

#(pv -n $from | dd of=$to bs=128M conv=notrunc,noerror) 2>&1 | dialog --gauge "Running dd command (cloning), please wait..." 10 70 0

