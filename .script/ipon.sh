#!/bin/bash

test -d ~/tmp || mkdir -p ~/tmp

echo ""
echo "Creating 'ipon' file with list of Online IP Addresses"
echo "-----------------------------------------------------"

curl -s http://vpn0.pwn0.com/nmap | awk 'BEGIN{FS=",";OFS="\n"} {$1=$1; print NR,$0}' | awk '{sub(/^[ \t]+/, "")};1 {if (NR!=1) {print}}' > ~/tmp/ipon

if [ $? -gt 0 ]; then
echo ""
echo -e "ERROR! Please continue later."
echo ""
exit 1
fi

echo "Completed. File 'ipon' created."
echo ""
exit 0
