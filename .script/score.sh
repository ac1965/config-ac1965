#!/bin/bash

test -d ~/tmp || mkdir -p ~/tmp
clear
echo ""
echo "  PWN0 Score with Different Usernames"
echo "======================================="
echo ""
echo -n "Please enter the filename: "
read user_file

while read line
do
        username=`echo -e $line`
        echo "-------------------------------------------------"
        curl http://vpn.pwn0.com/score?user=$username
        if [ $? -gt 0 ]; then
                echo ""
                echo -e "ERROR! Please continue later."
                echo ""
                exit 1
                fi
        echo ""
done < $user_file
