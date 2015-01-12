#! /bin/sh

pid=/var/run/dhcpcd-wlan0.pid
test -f ${pid} && kill -9 `cat ${pid}`
dev=`awk '{print $1}' /proc/net/dev|grep ':'|sed 's/://'|egrep 'ra|wlan'`
echo "$dev use"
#dev=wlan0
#dev=ra0
/sbin/ifconfig ${dev} up
/sbin/iwconfig ${dev} essid 0016018FA8B8
/sbin/iwconfig ${dev} key "s:taka.#1234@00"
/sbin/dhcpcd ${dev}
