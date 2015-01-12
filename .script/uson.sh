#!/bin/bash

test -d ~/tmp || mkdir -p ~/tmp
echo ""
echo "Creating 'uson' file with list of Online Users"
echo "----------------------------------------------"
curl -s http://vpn.pwn0.com/users | awk '{print $1}' > ~/tmp/uson

if [ $? -gt 0 ]; then
echo ""
echo -e "ERROR! Please continue later."
echo ""
exit 1
fi

echo "Completed. File 'uson' created."
echo ""
exit 0
